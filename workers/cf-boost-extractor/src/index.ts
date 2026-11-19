// CF-247 Boost extractor (Cloudflare Workers, free tier). Platform Admin, 16 Nov 2026 20:31: "Compute-to-Storage Boost Program".
//
// What it does, per call of POST /run:
//   1. reads one outbound batch (NDJSON) from Supabase Storage, bucket staging-boost, path outbound/<file>;
//   2. takes the next items from `offset` (at most BOOST_ITEMS_PER_RUN; free tier: 50 subrequests a call);
//   3. asks the failover chain (router.ts) for each item, with the prompt the batch header carries (its sha-256 is checked);
//   4. verifies every answer (verify.ts: shape, allowed values, quote_on_page against the whole page, quote states the value);
//   5. writes one result line per item to staging-boost/inbound/result-<batch>-<offset>.ndjson.
// It never writes to the database. Rows reach the platform only through the promotion SQL (sql/boost-ingestion), which decides admission.
//
// CPU (free tier 10 ms a call): the exporter does the heavy, deterministic work (page to blocks, section selection, the page's flat form),
// so the worker only builds requests, waits on fetch (waiting is not CPU time) and compares flat strings.
import { ask, type Keys, type Prompt } from "./router.ts";
import { verifyFlat } from "./verify.ts";
import { LANES, type LaneKey } from "./lanes.ts";
import { fenceSourceText, SOURCE_TEXT_RULE } from "./fence.ts";

export type Env = Keys & {
  BOOST_TOKEN: string;                 // shared secret for POST /run (wrangler secret)
  SUPABASE_URL: string;                // https://fxcwkweaxjtknorudmwp.supabase.co (var)
  SUPABASE_SERVICE_ROLE_KEY: string;   // Storage read/write only (wrangler secret)
  BOOST_BUCKET?: string;               // default staging-boost
  BOOST_ITEMS_PER_RUN?: string;        // default 12
  BOOST_CALL_TIMEOUT_MS?: string;      // default 45000
};

export type Header = { kind: "header"; batch_id: string; lane: LaneKey; source: string; created_at: string;
  prompt: { id: string; version: string; sha256: string; system: string; user_template: string; max_tokens: number; temperature: number };
  allowed?: Record<string, string[]>; dictionary?: any[] };
export type Item = { kind: "item"; item_key: string; lane: LaneKey; entity: string; entity_id: string; evidence_id: string | null;
  source_url: string | null; context: Record<string, unknown>; input: { text: string; selector: string | null }; page_flat: string; gold?: unknown };

const json = (v: unknown, status = 200) => new Response(JSON.stringify(v), { status, headers: { "content-type": "application/json" } });

export async function sha256Hex(s: string): Promise<string> {
  const h = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(s));
  return [...new Uint8Array(h)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

export function parseBatch(ndjson: string): { header: Header; items: Item[] } {
  const lines = ndjson.split("\n").filter((l) => l.trim());
  const rows = lines.map((l) => JSON.parse(l));
  const header = rows[0];
  if (header?.kind !== "header" || !LANES[header.lane as LaneKey]) throw Error("the first line must be a batch header for a known lane");
  const items = rows.slice(1).filter((r) => r.kind === "item");
  if (items.some((i) => i.lane !== header.lane)) throw Error("every item must be in the header's lane");
  return { header, items };
}

export function promptFor(h: Header, it: Item): Prompt {
  // page content and context are data placed into the template; nothing in them is treated as an instruction to this worker
  // s811 (ISM-2158): the page text is fenced and the model is told so; the rule is added to the system text after the batch's own sha-256 was checked
  const user = h.prompt.user_template.replace("{{context}}", () => JSON.stringify(it.context)).replace("{{input}}", () => fenceSourceText(it.input.text));
  return { system: `${h.prompt.system}\n\n${SOURCE_TEXT_RULE}`, user, max_tokens: h.prompt.max_tokens, temperature: h.prompt.temperature };
}

export async function runItems(h: Header, items: Item[], keys: Keys, opt: { timeoutMs: number; fetchFn?: typeof fetch; deadline?: number }) {
  const out: any[] = [];
  for (const it of items) {  // one at a time: the free tier's subrequest budget, and the providers' free-tier rate limits
    const r = await ask(promptFor(h, it), keys, opt);
    const base = { kind: "result", batch_id: h.batch_id, item_key: it.item_key, lane: h.lane, entity: it.entity, entity_id: it.entity_id,
      evidence_id: it.evidence_id, source_url: it.source_url, prompt_id: h.prompt.id, prompt_version: h.prompt.version, prompt_sha256: h.prompt.sha256,
      selector: it.input.selector, attempts: r.attempts, at: new Date().toISOString() };
    if (!r.ok) { out.push({ ...base, status: "failed", provider: null, model: null, answer: null, verdict: { ok: false, problems: [r.reason], quotes_checked: 0 } }); continue }
    const verdict = verifyFlat(h.lane, r.answer, it.page_flat, { allowed: h.allowed });
    out.push({ ...base, status: verdict.ok ? "verified" : "rejected", provider: r.provider, model: r.model, usage: r.usage, answer: r.answer, verdict });
  }
  return out;
}

async function storage(env: Env, method: string, path: string, body?: string) {
  const bucket = env.BOOST_BUCKET || "staging-boost";
  return fetch(`${env.SUPABASE_URL}/storage/v1/object/${bucket}/${path}`, { method, body,
    headers: { authorization: `Bearer ${env.SUPABASE_SERVICE_ROLE_KEY}`, apikey: env.SUPABASE_SERVICE_ROLE_KEY,
      ...(body ? { "content-type": "application/x-ndjson", "x-upsert": "true" } : {}) } });
}

export default {
  async fetch(req: Request, env: Env): Promise<Response> {
    const url = new URL(req.url);
    if (req.method === "GET" && url.pathname === "/health")
      return json({ ok: true, worker: "cf-boost-extractor", keys: { google: !!env.GOOGLE_AI_STUDIO_KEY, groq: !!env.GROQ_API_KEY, mistral: !!env.MISTRAL_API_KEY, openrouter: !!env.OPENROUTER_API_KEY } });
    if (req.method !== "POST" || url.pathname !== "/run") return json({ error: "not found" }, 404);
    if (!env.BOOST_TOKEN || req.headers.get("x-boost-token") !== env.BOOST_TOKEN) return json({ error: "unauthorised" }, 401);
    const { batch_path, offset = 0 } = (await req.json().catch(() => ({}))) as { batch_path?: string; offset?: number };
    if (!batch_path || !/^outbound\/[A-Za-z0-9._-]+\.ndjson$/.test(batch_path)) return json({ error: "batch_path must be outbound/<file>.ndjson" }, 400);
    const got = await storage(env, "GET", batch_path);
    if (!got.ok) return json({ error: `batch not readable (${got.status})` }, 502);
    let batch;
    try { batch = parseBatch(await got.text()) } catch (e: any) { return json({ error: String(e?.message || e) }, 422) }
    const { header, items } = batch;
    if ((await sha256Hex(header.prompt.system + "\n" + header.prompt.user_template)) !== header.prompt.sha256) return json({ error: "prompt sha-256 does not match its text" }, 422);
    const per = Math.max(1, Number(env.BOOST_ITEMS_PER_RUN || 12)), slice = items.slice(offset, offset + per);
    const rows = await runItems(header, slice, env, { timeoutMs: Number(env.BOOST_CALL_TIMEOUT_MS || 45000) });
    const outPath = `inbound/result-${header.batch_id}-${String(offset).padStart(6, "0")}.ndjson`;
    const put = await storage(env, "POST", outPath, rows.map((r) => JSON.stringify(r)).join("\n") + "\n");
    if (!put.ok) return json({ error: `result not written (${put.status})`, rows: rows.length }, 502);
    const next = offset + slice.length;
    return json({ batch_id: header.batch_id, lane: header.lane, written: outPath, items: slice.length,
      verified: rows.filter((r) => r.status === "verified").length, rejected: rows.filter((r) => r.status === "rejected").length,
      failed: rows.filter((r) => r.status === "failed").length, next_offset: next < items.length ? next : null });
  },
};
