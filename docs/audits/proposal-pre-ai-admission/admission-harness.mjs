#!/usr/bin/env node
// PROPOSAL (not deployed): CF-247 pre-AI admission harness for pre-ai-admission-v1
// (admin docs/audits/studysearch-pre-ai-admission-gate-design.md §6).
// Validates a sample of stored evidence copies end to end against the storage contract and the shadow admission gates, using the worker's own
// pure modules, so what it reports is what the worker would decide. READ ONLY: it downloads objects, never writes, deletes, calls AI or Firecrawl.
//
//   node --experimental-strip-types scripts/admission-harness.mjs --self-test
//   node --experimental-strip-types scripts/admission-harness.mjs --manifest sample.json --dir ./objects     (copies already downloaded)
//   SUPABASE_URL=… SUPABASE_SERVICE_ROLE_KEY=… node --experimental-strip-types scripts/admission-harness.mjs --manifest sample.json --supabase
//
// sample.json is the output of query H1 in docs/audits/sql/admission-integrity-checks.sql (one JSON array of manifest rows with a "lane").
// Exit code 1 means a STORAGE CONTRACT failure (missing object, zero bytes, hash mismatch, path/hash disagreement). Gate rejections are
// measurements and never fail the run.
import { readFile, writeFile } from "node:fs/promises";
import { gunzipSync } from "node:zlib";
import { createHash } from "node:crypto";
import path from "node:path";
import { pathToFileURL } from "node:url";

const argv = process.argv.slice(2);
const opt = (k, d = null) => { const i = argv.indexOf(`--${k}`); return i >= 0 && argv[i + 1] && !argv[i + 1].startsWith("--") ? argv[i + 1] : d };
const flag = (k) => argv.includes(`--${k}`);
const workerDir = path.resolve(opt("worker", "supabase/functions/coverage-sweep"));
const G = await import(pathToFileURL(path.join(workerDir, "admission-gate.ts")).href);

const sha256 = (buf) => createHash("sha256").update(buf).digest("hex");
const decode = (row, bytes) => {
  const raw = row.container === "gzip" || /\.gz$/.test(row.storage_path) ? gunzipSync(bytes) : bytes;
  return { raw, text: /pdf/.test(row.content_mime) ? "" : raw.toString("utf8") };
};
async function fetchObject(row) {
  if (flag("supabase")) {
    const base = process.env.SUPABASE_URL, key = process.env.SUPABASE_SERVICE_ROLE_KEY;
    if (!base || !key) throw Error("SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required with --supabase");
    const r = await fetch(`${base.replace(/\/$/, "")}/storage/v1/object/${row.bucket || "evidence"}/${row.storage_path.split("/").map(encodeURIComponent).join("/")}`, { headers: { authorization: `Bearer ${key}`, apikey: key } });
    if (!r.ok) return { missing: true, status: r.status };
    return { bytes: Buffer.from(await r.arrayBuffer()) };
  }
  const dir = opt("dir"); if (!dir) throw Error("--dir or --supabase is required with --manifest");
  try { return { bytes: await readFile(path.join(dir, row.storage_path)) } } catch { return { missing: true, status: 404 } }
}

async function runManifest() {
  const rows = JSON.parse(await readFile(opt("manifest"), "utf8"));
  const out = [], tally = { rows: rows.length, contract_fail: 0, missing: 0, admit: 0, would_reject: 0, would_park: 0, tokens_saved_estimate: 0 }, byReason = {};
  for (const row of rows) {
    const rec = { evidence_id: row.evidence_id, storage_path: row.storage_path, lane: row.lane };
    const o = await fetchObject(row);
    if (o.missing) { rec.contract = { ok: false, problems: ["object_missing"], status: o.status }; tally.contract_fail++; tally.missing++; out.push(rec); continue }
    const stored = o.bytes.length, { raw, text } = decode(row, o.bytes), computed = sha256(raw);
    const m = { ...row, stored_bytes: stored, content_bytes: raw.length };
    rec.contract = G.checkManifest(m, computed);
    if (!rec.contract.ok) tally.contract_fail++;
    if (text && row.lane) {
      const d = await G.admit({ lane: row.lane, html: text, url: row.final_url || row.source_url, manifest: m, computed_sha: computed,
        prompt_key: row.prompt_key || "harness", model: row.model || "harness", schema_key: row.schema_key || row.lane }, { budget_chars: Number(row.budget_chars) || undefined });
      rec.gate = { would: d.would, reasons: d.reasons.map((r) => r.code), sent_chars: d.sent_chars, tokens_saved_estimate: d.tokens_saved_estimate, signals: { main_chars: d.signals.main_chars, scholarship: d.signals.scholarship?.score, preflight: d.signals.preflight, leak: d.signals.leak } };
      tally[d.would === "admit" ? "admit" : d.would === "park" ? "would_park" : "would_reject"]++; tally.tokens_saved_estimate += d.tokens_saved_estimate;
      for (const r of d.reasons) byReason[r.code] = (byReason[r.code] || 0) + 1;
    }
    out.push(rec);
  }
  const report = { harness: "admission-harness", gate: G.ADMISSION_GATE, at: new Date().toISOString(), tally, by_reason: byReason, rows: out };
  if (opt("out")) await writeFile(opt("out"), JSON.stringify(report, null, 2));
  console.log(JSON.stringify({ tally, by_reason: byReason }, null, 2));
  for (const r of out.filter((x) => !x.contract?.ok)) console.log(`CONTRACT FAIL ${r.storage_path}: ${(r.contract?.problems || []).join(",")}`);
  process.exit(tally.contract_fail ? 1 : 0);
}

// ---------- self-test: fixed fixtures, one per reason, plus admit cases ----------
async function selfTest() {
  const page = (title, body, h1 = title) => `<!doctype html><html><head><title>${title}</title></head><body><nav>Home Study Research</nav><main><h1>${h1}</h1>${body}</main><footer>Privacy</footer></body></html>`;
  const para = (s, n = 1) => `<p>${s}</p>`.repeat(n);
  const course = page("Master of Data Science | Example University",
    "<h2>Overview</h2>" + para("This two-year course builds skills in statistics, machine learning and data engineering for industry roles.", 6) +
    "<h2>Entry requirements</h2>" + para("A bachelor degree in any discipline with a minimum GPA of 4.5 on a 7-point scale.") +
    "<h3>English language requirements</h3>" + para("IELTS Academic 6.5 overall with no band below 6.0.") +
    "<h2>Fees</h2><table><thead><tr><th>Student</th><th>Annual fee</th></tr></thead><tbody><tr><td>International</td><td>AUD 48,000</td></tr></tbody></table>");
  const award = page("Global Excellence Scholarship | Example University",
    para("The Global Excellence Scholarship offers a 25% reduction in tuition fees for international students commencing a coursework degree.") +
    "<h2>Eligibility</h2>" + para("Applicants must be international students holding an offer for full-time study.") +
    "<h2>How to apply</h2>" + para("You are automatically considered when you apply for admission. Applications close 30 November.") );
  const news = page("Campus news | Example University", para("Our rowing team won the regional regatta this weekend and the library opens late during exams.", 8));
  const listing = page("Scholarships", Array.from({ length: 20 }, (_, i) => `<li><a href="/scholarships/award-${i}">Award ${i}</a></li>`).join(""));
  const thin = page("Scholarship", "<p>Loading…</p>");
  const captcha = page("Just a moment...", "<p>Verify you are human by completing the action below. cf-chl</p>");
  const notFound = page("Page not found | Example University", para("Sorry, the page you are looking for could not be found. Try the search.", 3));
  const leaky = page("Bachelor of Arts", "<h2>Entry requirements</h2>" + para("ATAR 70 or equivalent. IELTS 6.5.") + `<p>${"QUJDRA".repeat(60)}</p>`);
  const sha = (s) => sha256(Buffer.from(s, "utf8"));
  const manifest = (html, extra = {}) => ({ evidence_id: "00000000-0000-0000-0000-000000000000", bucket: "evidence", storage_path: `layer2/AU/coverage/p/c/${sha(html)}.html.gz`, container: "gzip",
    content_mime: "text/html", content_sha256: sha(html), stored_bytes: 100, content_bytes: Buffer.byteLength(html), source_url: "https://example.edu/x", page_status: 200, captured_at: new Date().toISOString(), ...extra });
  const base = { url: "https://example.edu/x", prompt_key: "p", model: "m", schema_key: "s" };
  const cases = [
    ["course page admitted to the AER read", { ...base, lane: "aer", html: course, manifest: manifest(course), computed_sha: sha(course) }, "admit", []],
    ["award page admitted to the scholarship read", { ...base, lane: "scholarship", html: award, url: "https://example.edu/scholarships/global" }, "admit", []],
    ["fee table admitted to the fee read", { ...base, lane: "tuition_fees", html: course }, "admit", []],
    ["news page: scholarship score too low", { ...base, lane: "scholarship", html: news }, "reject", ["scholarship_low_signal"]],
    ["listing page routed away from a single-award read", { ...base, lane: "scholarship", html: listing, url: "https://example.edu/scholarships" }, "reject", ["scholarship_listing"]],
    ["near-empty copy is thin", { ...base, lane: "scholarship", html: thin }, "reject", ["thin_page"]],
    ["challenge page is a soft block", { ...base, lane: "scholarship", html: captcha }, "reject", ["soft_block"]],
    ["200 page that says not found", { ...base, lane: "aer", html: notFound }, "reject", ["soft_not_found"]],
    ["news page has no AER signal", { ...base, lane: "aer", html: news }, "reject", ["aer_no_signal"]],
    ["base64 run in the sent text is a prompt leak", { ...base, lane: "aer", html: leaky }, "reject", ["prompt_leak"]],
    ["hash mismatch fails the storage contract", { ...base, lane: "aer", html: course, manifest: manifest(course), computed_sha: "0".repeat(64) }, "reject", ["manifest_invalid"]],
    ["404 page status fails before any read", { ...base, lane: "aer", html: course, manifest: manifest(course, { page_status: 404 }), computed_sha: sha(course) }, "reject", ["page_not_ok"]],
  ];
  let failed = 0;
  for (const [name, input, want, reasons] of cases) {
    const d = await G.admit(input, {});
    const codes = d.reasons.map((r) => r.code);
    const ok = d.would === want && reasons.every((r) => codes.includes(r)) && d.decision === "admit" && (want === "admit" ? d.shadow === false : d.shadow === true);
    if (!ok) failed++;
    console.log(`${ok ? "PASS" : "FAIL"}  ${name}: would ${d.would} [${codes.join(",")}] decision ${d.decision}${d.shadow ? " (shadow)" : ""}`);
  }
  // enforcement is per reason and explicit
  const enforced = await G.admit({ ...base, lane: "scholarship", html: thin }, { enforce: { thin_page: true } });
  const eok = enforced.decision === "reject" && enforced.shadow === false && enforced.tokens_saved_estimate >= 0;
  if (!eok) failed++; console.log(`${eok ? "PASS" : "FAIL"}  enforce thin_page: decision ${enforced.decision}`);
  // duplicate input parks (reuse), it does not reject
  const first = await G.admit({ ...base, lane: "aer", html: course });
  const dup = await G.admit({ ...base, lane: "aer", html: course, seen_fingerprints: new Set([first.fingerprint]) }, { enforce: { duplicate_input: true } });
  const dok = dup.decision === "park" && dup.reasons.some((r) => r.code === "duplicate_input");
  if (!dok) failed++; console.log(`${dok ? "PASS" : "FAIL"}  duplicate input parks for reuse: decision ${dup.decision}`);
  // over budget splits/parks, never cuts: the sent text is the full selection
  const big = await G.admit({ ...base, lane: "course_overview", html: course }, { budget_chars: 50 });
  const bok = big.would === "park" && big.sent_chars > 50;
  if (!bok) failed++; console.log(`${bok ? "PASS" : "FAIL"}  over budget parks with reason (sent ${big.sent_chars} > 50, not cut)`);
  // every selected line is a labelled block line: proximity and offsets survive
  const { seg } = G.segment(course, null, ["aer"]);
  const lok = seg.text.aer.split("\n").every((l) => /^\[B\d+ @(\d+|data)\] /.test(l)) && seg.by_lane.aer.block_ids.length > 0;
  if (!lok) failed++; console.log(`${lok ? "PASS" : "FAIL"}  AER segment keeps [B#] block labels (${seg.by_lane.aer.block_ids.length} blocks)`);
  console.log(failed ? `\n${failed} FAILED` : `\nall ${cases.length + 4} checks passed`);
  process.exit(failed ? 1 : 0);
}

if (flag("self-test")) await selfTest();
else if (opt("manifest")) await runManifest();
else { console.error("usage: --self-test | --manifest <file> (--dir <dir> | --supabase) [--out report.json] [--worker <coverage-sweep dir>]"); process.exit(2) }
