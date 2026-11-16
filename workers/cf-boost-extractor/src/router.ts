// CF-247 Boost extractor: the free-tier failover router.
// Chain (Platform Admin, 16 Nov 2026 20:31): Google AI Studio (gemini-2.5-flash, gemini-2.5-flash-lite) -> Groq (llama-3.3-70b-versatile)
// -> Mistral (mistral-small-latest, La Plateforme free tier) -> OpenRouter (mistralai/mistral-small-3.2-24b-instruct, xiaomi/mimo-v2-flash).
//
// Binding (admin docs/platform/layer4-clearance-and-model-benchmark-2026-11-16.md §5 lesson 8): a failover never mixes models inside one answer.
// Each attempt is one pinned model on one provider; the answer kept is the first complete one, and the result row names exactly that provider
// and model with every earlier attempt and why it moved on. OpenRouter calls pin the model with provider fallbacks off and require_parameters
// on, so OpenRouter itself never swaps the model. Whether a model's answers may be admitted is decided in the database (promotion), never here.
//
// Moves to the next step on: 429 (rate limit; the provider is cooled down for its Retry-After), 5xx, a time-out, a refused or empty answer, or an
// answer that is not JSON. A 400/401/403 is a configuration fault: it moves on and is reported, never retried on the same step.

export type Step = { provider: "google" | "groq" | "mistral" | "openrouter"; model: string };
export const CHAIN: Step[] = [
  { provider: "google", model: "gemini-2.5-flash" },
  { provider: "google", model: "gemini-2.5-flash-lite" },
  { provider: "groq", model: "llama-3.3-70b-versatile" },
  { provider: "mistral", model: "mistral-small-latest" },
  { provider: "openrouter", model: "mistralai/mistral-small-3.2-24b-instruct" },
  { provider: "openrouter", model: "xiaomi/mimo-v2-flash" },
];

export type Keys = { GOOGLE_AI_STUDIO_KEY?: string; GROQ_API_KEY?: string; MISTRAL_API_KEY?: string; OPENROUTER_API_KEY?: string };
export type Attempt = { provider: string; model: string; status: number | "timeout" | "network" | "skipped"; outcome: string; ms: number };
export type Answered = { ok: true; provider: string; model: string; answer: any; usage: any; attempts: Attempt[] };
export type Failed = { ok: false; attempts: Attempt[]; reason: string };
export type Prompt = { system: string; user: string; max_tokens: number; temperature: number };

// provider cool-down, per isolate: a 429 parks the provider until its Retry-After (or the default) has passed
const coolUntil = new Map<string, number>();
const DEFAULT_COOL_MS = 60_000; // fixed: used only when a 429 carries no Retry-After; the provider's own header wins
export function coolDown(provider: string, retryAfter: string | null, now = Date.now()) {
  const s = Number(retryAfter);
  coolUntil.set(provider, now + (Number.isFinite(s) && s > 0 ? s * 1000 : DEFAULT_COOL_MS));
}
export function isCool(provider: string, now = Date.now()) { return (coolUntil.get(provider) ?? 0) > now }
export function resetCooling() { coolUntil.clear() }

const keyOf = (p: Step["provider"], k: Keys) =>
  p === "google" ? k.GOOGLE_AI_STUDIO_KEY : p === "groq" ? k.GROQ_API_KEY : p === "mistral" ? k.MISTRAL_API_KEY : k.OPENROUTER_API_KEY;

export function request(step: Step, key: string, pr: Prompt): { url: string; init: RequestInit } {
  if (step.provider === "google") {
    return {
      url: `https://generativelanguage.googleapis.com/v1beta/models/${step.model}:generateContent`,
      init: { method: "POST", headers: { "content-type": "application/json", "x-goog-api-key": key }, body: JSON.stringify({
        systemInstruction: { parts: [{ text: pr.system }] },
        contents: [{ role: "user", parts: [{ text: pr.user }] }],
        generationConfig: { temperature: pr.temperature, maxOutputTokens: pr.max_tokens, responseMimeType: "application/json" },
      }) },
    };
  }
  const base = step.provider === "groq" ? "https://api.groq.com/openai/v1" : step.provider === "mistral" ? "https://api.mistral.ai/v1" : "https://openrouter.ai/api/v1";
  const body: any = { model: step.model, temperature: pr.temperature, max_tokens: pr.max_tokens, response_format: { type: "json_object" },
    messages: [{ role: "system", content: pr.system }, { role: "user", content: pr.user }] };
  // one model, no provider fallback to another model, parameters honoured or refused (lesson 8)
  if (step.provider === "openrouter") body.provider = { allow_fallbacks: false, require_parameters: true };
  return { url: `${base}/chat/completions`, init: { method: "POST", headers: { "content-type": "application/json", authorization: `Bearer ${key}` }, body: JSON.stringify(body) } };
}

export function textOf(step: Step, d: any): string | null {
  if (step.provider === "google") return d?.candidates?.[0]?.content?.parts?.map((p: any) => p?.text ?? "").join("") || null;
  return d?.choices?.[0]?.message?.content ?? null;
}

// a JSON object from the model's text: the whole text, or the one fenced block it returned
export function parseAnswer(t: string | null): any | null {
  if (!t) return null;
  const s = t.trim().replace(/^```(?:json)?\s*/i, "").replace(/```\s*$/, "");
  try { const v = JSON.parse(s); return v && typeof v === "object" ? v : null } catch { return null }
}

export async function ask(pr: Prompt, keys: Keys, opt: { chain?: Step[]; timeoutMs: number; fetchFn?: typeof fetch; deadline?: number }): Promise<Answered | Failed> {
  const f = opt.fetchFn ?? fetch, attempts: Attempt[] = [];
  for (const step of opt.chain ?? CHAIN) {
    const t0 = Date.now(), key = keyOf(step.provider, keys);
    if (opt.deadline && t0 > opt.deadline) { attempts.push({ ...step, status: "skipped", outcome: "no time left in this run", ms: 0 }); break }
    if (!key) { attempts.push({ ...step, status: "skipped", outcome: "no key set", ms: 0 }); continue }
    if (isCool(step.provider, t0)) { attempts.push({ ...step, status: "skipped", outcome: "cooling down after a 429", ms: 0 }); continue }
    const { url, init } = request(step, key, pr);
    let r: Response;
    try { r = await f(url, { ...init, signal: AbortSignal.timeout(opt.timeoutMs) }) }
    catch (e: any) { attempts.push({ ...step, status: e?.name === "TimeoutError" ? "timeout" : "network", outcome: String(e?.message || e).slice(0, 160), ms: Date.now() - t0 }); continue }
    if (r.status === 429) { coolDown(step.provider, r.headers.get("retry-after")); attempts.push({ ...step, status: 429, outcome: "rate limited", ms: Date.now() - t0 }); continue }
    if (!r.ok) { attempts.push({ ...step, status: r.status, outcome: (await r.text().catch(() => "")).slice(0, 160), ms: Date.now() - t0 }); continue }
    const d: any = await r.json().catch(() => null);
    const answer = parseAnswer(textOf(step, d));
    if (!answer) { attempts.push({ ...step, status: r.status, outcome: "empty or not JSON", ms: Date.now() - t0 }); continue }
    // OpenRouter reports the model that actually answered; a different model would break the binding, so it is refused
    if (step.provider === "openrouter" && d?.model && d.model !== step.model) { attempts.push({ ...step, status: r.status, outcome: `answered by ${d.model}, not the pinned model`, ms: Date.now() - t0 }); continue }
    attempts.push({ ...step, status: r.status, outcome: "answered", ms: Date.now() - t0 });
    return { ok: true, provider: step.provider, model: step.model, answer, usage: d?.usage ?? d?.usageMetadata ?? null, attempts };
  }
  return { ok: false, attempts, reason: attempts.length ? `every step failed (last: ${attempts[attempts.length - 1].outcome})` : "empty chain" };
}
