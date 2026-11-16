// CF-247 Boost extractor tests (node --test, no network: every provider call is a mock).
// Harness points 1 (failover and CPU) and 2 (every ungrounded quote blocked before any database ingress).
import { test } from "node:test";
import assert from "node:assert/strict";
import { ask, CHAIN, resetCooling } from "../src/router.ts";
import { verify, flatForm } from "../src/verify.ts";
import { parseBatch, runItems, sha256Hex } from "../src/index.ts";

const ok = (body) => new Response(JSON.stringify(body), { status: 200, headers: { "content-type": "application/json" } });
const openaiAnswer = (obj, model) => ok({ model, choices: [{ message: { content: JSON.stringify(obj) } }] });
const googleAnswer = (obj) => ok({ candidates: [{ content: { parts: [{ text: JSON.stringify(obj) }] } }] });
const r429 = (s = "30") => new Response("slow down", { status: 429, headers: { "retry-after": s } });
const keys = { GOOGLE_AI_STUDIO_KEY: "g", GROQ_API_KEY: "q", MISTRAL_API_KEY: "m", OPENROUTER_API_KEY: "o" };
const prompt = { system: "s", user: "u", max_tokens: 400, temperature: 0 };

const PAGE = [
  "Bachelor of Business. Duration: 3 years full-time or the part-time equivalent.",
  "The School of Business holds AACSB accreditation, awarded in 2019 and reaffirmed in 2024.",
  "Entry requirements: a minimum ATAR of 70.00 or equivalent; IELTS 6.5 overall with no band below 6.0.",
  "Tuition fee for international students: AUD 38,400 per year (2026).",
].join("\n").repeat(1) + "\n" + "Other campus information and student services. ".repeat(1800); // about 85,000 characters, like a long course page

test("429 failover: Google rate-limited, its second model skipped while cooling, Groq answers; the row names Groq alone", async () => {
  resetCooling();
  const seen = [];
  const fetchFn = async (url) => { seen.push(url); if (url.includes("googleapis")) return r429("30"); return openaiAnswer({ study_load: "both", quote: "3 years full-time or the part-time equivalent" }, "llama-3.3-70b-versatile") };
  const r = await ask(prompt, keys, { timeoutMs: 1000, fetchFn });
  assert.equal(r.ok, true);
  assert.equal(r.provider, "groq");
  assert.equal(r.model, "llama-3.3-70b-versatile");
  assert.deepEqual(r.attempts.map((a) => [a.provider, a.model, a.status]), [["google", "gemini-2.5-flash", 429], ["google", "gemini-2.5-flash-lite", "skipped"], ["groq", "llama-3.3-70b-versatile", 200]]);
  assert.equal(seen.filter((u) => u.includes("googleapis")).length, 1, "a cooling provider is not called again");
});

test("chain order is the Platform Admin's: Google, Groq, Mistral, OpenRouter (pinned models)", () => {
  assert.deepEqual(CHAIN.map((s) => s.provider), ["google", "google", "groq", "mistral", "openrouter", "openrouter"]);
  assert.deepEqual(CHAIN.filter((s) => s.provider === "openrouter").map((s) => s.model), ["mistralai/mistral-small-3.2-24b-instruct", "xiaomi/mimo-v2-flash"]);
});

test("every provider rate-limited or down: the item fails with each attempt recorded; nothing is invented", async () => {
  resetCooling();
  const fetchFn = async (url) => url.includes("mistral.ai") ? new Response("err", { status: 503 }) : r429();
  const r = await ask(prompt, keys, { timeoutMs: 1000, fetchFn });
  assert.equal(r.ok, false);
  assert.ok(r.attempts.length === CHAIN.length);
});

test("OpenRouter: provider fallbacks off and require_parameters on; an answer from another model is refused (binding)", async () => {
  resetCooling();
  let body;
  const fetchFn = async (url, init) => {
    if (!url.includes("openrouter")) return r429();
    body = JSON.parse(init.body);
    return openaiAnswer({ study_load: "full_time", quote: "3 years full-time or the part-time equivalent" }, body.model === "xiaomi/mimo-v2-flash" ? "xiaomi/mimo-v2-flash" : "some/other-model");
  };
  const r = await ask(prompt, keys, { timeoutMs: 1000, fetchFn });
  assert.deepEqual(body.provider, { allow_fallbacks: false, require_parameters: true });
  assert.equal(r.ok, true);
  assert.equal(r.model, "xiaomi/mimo-v2-flash");
  assert.match(r.attempts.find((a) => a.model === "mistralai/mistral-small-3.2-24b-instruct").outcome, /not the pinned model/);
});

test("Google answers come from generateContent with JSON output; the key travels in a header, never the URL", async () => {
  resetCooling();
  let u, h;
  const r = await ask(prompt, keys, { timeoutMs: 1000, fetchFn: async (url, init) => { u = url; h = init.headers; return googleAnswer({ study_load: "full_time", quote: "x" }) } });
  assert.equal(r.provider, "google");
  assert.ok(!u.includes("key="));
  assert.equal(h["x-goog-api-key"], "g");
});

test("quote_on_page: 100% of ungrounded quotes are blocked (50 cases), grounded quotes pass", () => {
  const bad = Array.from({ length: 50 }, (_, i) => ({ study_load: "full_time", quote: `Duration ${i + 2} years full-time on the Mars campus` }));
  const blocked = bad.filter((a) => !verify("study_load", a, PAGE).ok).length;
  assert.equal(blocked, 50);
  assert.equal(verify("study_load", { study_load: "both", quote: "3 years full-time or the part-time equivalent" }, PAGE).ok, true);
  // spacing, case and punctuation do not matter (the Pilot worker's flat form); words do
  assert.equal(verify("study_load", { study_load: "full_time", quote: "3 YEARS   full time, or the part-time" }, PAGE).ok, true);
});

test("quote must state the value: study load never from delivery mode (REQ-52); fee amount must be printed; body must be named", () => {
  assert.equal(verify("study_load", { study_load: "full_time", quote: "Other campus information and student services" }, PAGE).ok, false);
  assert.equal(verify("course_fees", { fees: [{ amount: 38400, currency: "AUD", audience: "international", quote: "AUD 38,400 per year (2026)" }] }, PAGE).ok, true);
  assert.equal(verify("course_fees", { fees: [{ amount: 39400, currency: "AUD", quote: "AUD 38,400 per year (2026)" }] }, PAGE).ok, false);
  assert.equal(verify("provider_accreditations", { accreditations: [{ body_code: "AACSB", status: "active", quote: "The School of Business holds AACSB accreditation" }] }, PAGE).ok, true);
  assert.equal(verify("provider_accreditations", { accreditations: [{ body_code: "EQUIS", status: "active", quote: "The School of Business holds AACSB accreditation" }] }, PAGE).ok, false);
});

test("schema: values outside the live CHECK lists are refused; a live list in the batch header wins", () => {
  assert.equal(verify("study_load", { study_load: "half_time", quote: "full-time" }, PAGE).ok, false);
  assert.equal(verify("provider_accreditations", { accreditations: [{ body_code: "ABS", status: "active", quote: "x" }] }, PAGE).ok, false);
  const narrower = { allowed: { study_load: ["full_time"] } };
  assert.equal(verify("study_load", { study_load: "both", quote: "3 years full-time or the part-time equivalent" }, PAGE, narrower).ok, false);
  const rec = (q) => ({ records: [{ audience: "all", exact_block: 3, exact_quote: q, lead_in_quote: "Entry requirements:", support: [{ quote: "IELTS 6.5 overall" }] }] });
  assert.equal(verify("aer_entry", rec("a minimum ATAR of 70.00 or equivalent"), PAGE).ok, true);
  assert.equal(verify("aer_entry", rec("a minimum ATAR of 90.00 or equivalent"), PAGE).ok, false);
  assert.equal(verify("aer_entry", { records: [{ ...rec("a minimum ATAR of 70.00 or equivalent").records[0], support: [{ quote: "IELTS 7.5 overall with no band" }] }] }, PAGE).ok, false);
});

test("batch: header first, one lane, prompt sha-256 over system + newline + template", async () => {
  const header = { kind: "header", batch_id: "t1", lane: "study_load", source: "fixture", created_at: "2026-11-16T10:00:00Z",
    prompt: { id: "boost-study-load", version: "v1", system: "S", user_template: "C {{context}} I {{input}}", max_tokens: 300, temperature: 0 } };
  header.prompt.sha256 = await sha256Hex("S\nC {{context}} I {{input}}");
  const nd = [header, { kind: "item", item_key: "a", lane: "study_load", entity: "course", entity_id: "x", evidence_id: null, source_url: null, context: {}, input: { text: "t", selector: null }, page_flat: "" }].map((r) => JSON.stringify(r)).join("\n");
  const b = parseBatch(nd);
  assert.equal(b.items.length, 1);
  assert.throws(() => parseBatch(JSON.stringify({ ...header, lane: "unknown" })));
});

test("CPU: 12 items (one free-tier call) with an 85,000-character page stay under 10 ms of work beside the waits", async () => {
  resetCooling();
  const pageFlat = flatForm(PAGE);
  const header = { kind: "header", batch_id: "cpu", lane: "study_load", source: "fixture", created_at: "", allowed: undefined,
    prompt: { id: "p", version: "v1", sha256: "x", system: "S".repeat(4000), user_template: "{{context}}\n{{input}}", max_tokens: 300, temperature: 0 } };
  const items = Array.from({ length: 12 }, (_, i) => ({ kind: "item", item_key: `k${i}`, lane: "study_load", entity: "course", entity_id: `c${i}`, evidence_id: null, source_url: null,
    context: { title: "Bachelor of Business" }, input: { text: PAGE.slice(0, 8000), selector: "lean-sections-v3" }, page_flat: pageFlat }));
  const answer = { study_load: "both", quote: "3 years full-time or the part-time equivalent" };
  const fetchFn = async () => googleAnswer(answer);
  await runItems(header, items, keys, { timeoutMs: 1000, fetchFn }); // warm up (JIT), as a deployed isolate would be
  const t0 = performance.now();
  const rows = await runItems(header, items, keys, { timeoutMs: 1000, fetchFn });
  const ms = performance.now() - t0;
  assert.equal(rows.filter((r) => r.status === "verified").length, 12);
  console.log(`cpu: 12 items in ${ms.toFixed(2)} ms (mocked fetch resolves at once, so this is the worker's own work)`);
  assert.ok(ms < 10, `12 items took ${ms.toFixed(2)} ms`);
});
