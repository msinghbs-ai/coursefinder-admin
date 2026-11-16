// CF-247 Boost queue exporter (Platform Admin, 16 Nov 2026 20:31). Writes staging-boost/outbound/<file>.ndjson for the Boost Worker.
//
//   node --experimental-strip-types scripts/boost-export-queue.ts [--lane study_load] [--limit 200] [--out ./staging-boost] [--upload]
//
// Environment:
//   BOOST_DB_URL            Postgres URL of fxcwkweaxjtknorudmwp (a read-only role is enough; every query runs in a read-only transaction)
//   SUPABASE_URL            https://fxcwkweaxjtknorudmwp.supabase.co
//   SUPABASE_SERVICE_ROLE_KEY  reads the stored pages (bucket evidence) and, with --upload, writes the batch to bucket staging-boost
//   PILOT_DIR               a checkout of Coursefinder-Pilot (default ../Coursefinder-Pilot or ../coursefinder-pilot): the page converter, block
//                           format and section selector are imported from there, never copied, so a batch is built exactly as the live worker builds it
//
// Path choice (automatic, printed): A when pipeline.field_execution_registry exists AND declares --lane (S2 - SS Build PR 3); otherwise B, the
// 75-row fixture (50 frozen AER benchmark cases of set 5, 15 study_load, 10 accreditations). Read only throughout; refuses any other project.
import { execFileSync } from "node:child_process";
import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { gunzipSync } from "node:zlib";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const PROD_REF = "fxcwkweaxjtknorudmwp", DEMO_REF = "gfryvshbeptxwbzjomhe";
const arg = (k: string, d?: string) => { const i = process.argv.indexOf(`--${k}`); return i > 0 ? (process.argv[i + 1] ?? "") : d };
const flag = (k: string) => process.argv.includes(`--${k}`);

const DB = process.env.BOOST_DB_URL || "", SB = process.env.SUPABASE_URL || "", KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || "";
if (!DB || !SB || !KEY) { console.error("BOOST_DB_URL, SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required"); process.exit(2) }
if (DB.includes(DEMO_REF) || SB.includes(DEMO_REF)) { console.error("refused: coursefinder-demo is never targeted"); process.exit(2) }
if (!DB.includes(PROD_REF) || !SB.includes(PROD_REF)) { console.error(`refused: the exporter reads the production project ${PROD_REF} only`); process.exit(2) }

const PILOT = resolve(process.env.PILOT_DIR || [join(HERE, "../../Coursefinder-Pilot"), join(HERE, "../../coursefinder-pilot")].find(existsSync) || "");
const CS = join(PILOT, "supabase/functions/coverage-sweep/");
if (!existsSync(join(CS, "lean-sections.ts"))) { console.error(`PILOT_DIR does not hold the coverage-sweep worker: ${PILOT}`); process.exit(2) }
const li = await import(join(CS, "lean-input.ts")), av = await import(join(CS, "aer-v2.ts")), ls = await import(join(CS, "lean-sections.ts"));
const pilotSha = execFileSync("git", ["-C", PILOT, "rev-parse", "HEAD"]).toString().trim();

const SQL = readFileSync(join(HERE, "boost-export-queue.sql"), "utf8");
const block = (name: string) => { const m = SQL.split(/^-- @block /m).find((b) => b.startsWith(name + "\n")); if (!m) throw Error(`block ${name} missing`); return m.slice(name.length + 1).trim().replace(/;\s*$/, "") };

// one read-only transaction per query, 20 s cap; psql binds :lane and :limit for the registry block
function q(sql: string, vars: Record<string, string> = {}): any {
  const v = Object.entries(vars).flatMap(([k, x]) => ["-v", `${k}=${x}`]);
  const wrapped = `begin;\nset transaction read only;\nset local statement_timeout = '20s';\n${sql};\nrollback;\n`;
  const out = execFileSync("psql", [DB, "-X", "-q", "-At", "-v", "ON_ERROR_STOP=1", ...v, "-f", "-"], { input: wrapped, maxBuffer: 1 << 30 }).toString().trim();
  return JSON.parse(out.split("\n").filter((l) => l.startsWith("{") || l.startsWith("[")).pop() || "null");
}

async function storageGet(bucket: string, path: string): Promise<Buffer | null> {
  const r = await fetch(`${SB}/storage/v1/object/${bucket}/${path.split("/").map(encodeURIComponent).join("/")}`, { headers: { authorization: `Bearer ${KEY}`, apikey: KEY } });
  return r.ok ? Buffer.from(await r.arrayBuffer()) : null;
}
const unzip = (b: Buffer, p: string) => (p.endsWith(".gz") ? gunzipSync(b) : b).toString("utf8");

// the stored page as the live readers see it: Firecrawl's markdown beside the page when kept (reading.markdown_input = 1), else the stored copy
async function pageOf(path: string) {
  const md = path.replace(/\.(html?|txt|json)(\.gz)?$/i, "") + ".md.gz";
  const m = md !== path ? await storageGet("evidence", md) : null;
  if (m) return { lean: li.leanTextFromMarkdown(unzip(m, md)), from: "markdown" };
  const raw = await storageGet("evidence", path);
  if (!raw) return null;
  const t = unzip(raw, path);
  return { lean: /<\/?(html|body|div|p|h\d)\b/i.test(t) ? li.leanText(t) : li.leanTextFromMarkdown(t), from: "stored_copy" };
}

const FIELD: Record<string, string> = { study_load: "duration", provider_accreditations: "description", aer_entry: "entry_requirements", course_description: "description", course_fees: "fees" };

async function promptFor(lane: string) {
  if (lane === "aer_entry") {
    const p = q(`select to_jsonb(p) from pipeline.aer_prompt_versions p where version = 'aer-v2-course-v3-mistral-small-3.2'`);
    return { id: "aer-v2-course-v3", version: p.version, system: p.system_text, user_template: "{{input}}", max_tokens: 4000, temperature: 0 };
  }
  const f = join(HERE, "../workers/cf-boost-extractor/prompts", `${lane}.json`);
  if (!existsSync(f)) throw Error(`no registered prompt for lane ${lane}`);
  return JSON.parse(readFileSync(f, "utf8"));
}

function allowedFrom(checks: Record<string, string>) {
  const list = (name: string) => { const d = checks[name]; return d ? [...d.matchAll(/'([a-z_A-Z]+)'::text/g)].map((m) => m[1]) : undefined };
  const out: Record<string, string[]> = {};
  const add = (k: string, v?: string[]) => { if (v?.length) out[k] = v };
  add("study_load", list("courses_study_load_check")); add("body_code", list("provider_accreditations_body_code_check"));
  add("status", list("provider_accreditations_status_check")); add("audience", list("course_entry_requirements_audience_check"));
  return out;
}

const header0 = q(block("header"));
const lane = arg("lane"), limit = arg("limit", "200")!;
let path: "A" | "B" = "B", items: any[] = [], registry: any = null;
if (header0.registry && lane) {
  const ex = q(block("registry"), { lane, limit });
  if (ex?.error) console.log(`path B: ${ex.error} (${lane})`); else { path = "A"; items = ex.items; registry = ex.registry }
} else console.log(header0.registry ? "path B: no --lane given" : "path B: pipeline.field_execution_registry is not live yet (S2 - SS Build PR 3)");
if (path === "B") items = q(block("fixture"));

const outDir = resolve(arg("out", join(HERE, "../staging-boost"))!), stamp = new Date().toISOString().replace(/[-:]/g, "").slice(0, 13);
mkdirSync(join(outDir, "outbound"), { recursive: true });
const byLane = new Map<string, any[]>();
for (const it of items) byLane.set(it.lane, [...(byLane.get(it.lane) || []), it]);

const written: string[] = [];
for (const [ln, list] of byLane) {
  const pr = await promptFor(ln);
  const sha256 = createHash("sha256").update(pr.system + "\n" + pr.user_template).digest("hex");
  const batch_id = `${ln}-${path === "B" ? "fixture" : "live"}-${stamp}`;
  const header = { kind: "header", batch_id, lane: ln, source: path === "B" ? "fixture (set 5 + 25)" : "pipeline.field_execution_registry", created_at: new Date().toISOString(),
    pilot_commit: pilotSha, selector: ls.LEAN_SECTIONS, block_input: ls.BLOCK_INPUT, registry, checks: header0.checks, dictionary: header0.dictionary,
    allowed: allowedFrom(header0.checks), prompt: { ...pr, sha256 } };
  const lines = [JSON.stringify(header)], skipped: any[] = [];
  for (const it of list) {
    if (!it.storage_path) { skipped.push({ item_key: it.item_key, reason: "no stored page" }); continue }
    const pg = await pageOf(it.storage_path);
    if (!pg) { skipped.push({ item_key: it.item_key, reason: "stored page not readable" }); continue }
    const ab = av.aerV3Blocks(pg.lean, null), whole = ls.blockPlain(ab);
    let text: string, selector: string | null = null;
    if (ln === "aer_entry") {
      // the same long-page rule as the live worker (v1.0.6): a page is never cut; a long page sends its entry requirement sections
      const lim = 60000, w = ls.longPageWindow(ab, lim, true);
      if (!w.send) { skipped.push({ item_key: it.item_key, reason: "page_too_long (sections do not fit)" }); continue }
      selector = w.window ? ls.LEAN_SECTIONS : null;
      text = av.aerV3User({ title: String(it.context?.label || ""), provider: "", url: it.source_url }, [], w.send, ab.blocks.length);
    } else {
      const s = ls.selectSections(ab, FIELD[ln]);
      selector = s.no_selection ? null : ls.LEAN_SECTIONS;
      text = s.no_selection ? ab.text : s.text;
    }
    lines.push(JSON.stringify({ kind: "item", item_key: it.item_key, lane: ln, entity: it.entity, entity_id: it.entity_id, evidence_id: it.evidence_id,
      source_url: it.source_url, context: it.context, input: { text, selector, page_from: pg.from }, page_flat: ls.flatForm(whole), gold: it.gold ?? undefined }));
  }
  const file = path === "B" ? `fixture-${ln}-${stamp}.ndjson` : `batch-${ln}-${stamp}.ndjson`;
  writeFileSync(join(outDir, "outbound", file), lines.join("\n") + "\n");
  writeFileSync(join(outDir, "outbound", file.replace(/\.ndjson$/, ".skipped.json")), JSON.stringify(skipped, null, 2));
  if (flag("upload")) {
    const r = await fetch(`${SB}/storage/v1/object/staging-boost/outbound/${file}`, { method: "POST", body: lines.join("\n") + "\n",
      headers: { authorization: `Bearer ${KEY}`, apikey: KEY, "content-type": "application/x-ndjson", "x-upsert": "true" } });
    if (!r.ok) throw Error(`upload of ${file} failed: ${r.status} ${await r.text()}`);
  }
  written.push(`${file}: ${lines.length - 1} items, ${skipped.length} skipped`);
}
console.log(`path ${path}; pilot ${pilotSha.slice(0, 8)}; ${written.join("; ")}`);
