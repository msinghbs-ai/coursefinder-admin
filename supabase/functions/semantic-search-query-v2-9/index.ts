import { createClient } from "npm:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const json = (d: unknown, s = 200) => new Response(JSON.stringify(d), { status: s, headers: { ...CORS, "Content-Type": "application/json" } });
const hex = (buffer: ArrayBuffer) => Array.from(new Uint8Array(buffer)).map((b) => b.toString(16).padStart(2, "0")).join("");

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "POST required" }, 405);

  const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  let body: { query?: string; country?: string; level?: string; limit?: number } = {};
  try { body = await req.json(); } catch { return json({ error: "invalid JSON" }, 400); }

  const originalQuery = (body.query ?? "").trim();
  if (!originalQuery) return json({ error: "query is required" }, 400);
  const country = body.country ? body.country.trim().toUpperCase().slice(0, 2) : null;
  const explicitLevel = body.level ? body.level.trim().toLowerCase() : null;
  const limit = Math.min(Math.max(body.limit ?? 20, 1), 50);

  const { data: normRows, error: normErr } = await supabase.rpc("intent_normalize_pilot_v2_9", { p_query: originalQuery });
  if (normErr) return json({ error: `intent normalisation failed: ${normErr.message}` }, 500);
  const norm = normRows?.[0] ?? { original_query: originalQuery, normalized_query: originalQuery.toLowerCase(), inferred_level: null, applied_aliases: [] };
  const normalizedQuery = (norm.normalized_query ?? originalQuery).trim();
  const level = explicitLevel ?? norm.inferred_level ?? null;

  const { data: cfgRows, error: cfgErr } = await supabase.from("pipeline_config").select("value").eq("key", "llm").limit(1);
  if (cfgErr) return json({ error: "embedding configuration unavailable" }, 500);
  const llm = cfgRows?.[0]?.value ?? {};
  if (!llm.api_key) return json({ error: "embedding provider is not configured" }, 500);

  const base = (llm.base_url ?? "https://openrouter.ai/api/v1").replace(/\/$/, "");
  const model = llm.embed_model ?? "openai/text-embedding-3-small";
  const profileVersion = "v2.9-pilot-intent-v1";
  const cacheMaterial = `${model}|${profileVersion}|${normalizedQuery}`;
  const cacheKey = hex(await crypto.subtle.digest("SHA-256", new TextEncoder().encode(cacheMaterial)));

  let embedding: number[] | undefined;
  let cacheHit = false;
  let cacheHitCount = 0;
  let embedMs = 0;

  const cacheStarted = performance.now();
  const { data: cacheRows, error: cacheErr } = await supabase.rpc("query_embedding_cache_get_pilot_v2_9", {
    p_cache_key: cacheKey,
    p_model: model,
    p_profile_version: profileVersion,
  });
  const cacheLookupMs = performance.now() - cacheStarted;
  if (!cacheErr && cacheRows?.[0]?.embedding) {
    const raw = cacheRows[0].embedding;
    embedding = Array.isArray(raw) ? raw : JSON.parse(raw);
    cacheHit = true;
    cacheHitCount = Number(cacheRows[0].hit_count ?? 0);
  }

  if (!embedding) {
    const embedStarted = performance.now();
    const resp = await fetch(`${base}/embeddings`, {
      method: "POST",
      headers: { "content-type": "application/json", authorization: `Bearer ${llm.api_key}` },
      body: JSON.stringify({ model, input: normalizedQuery }),
    });
    if (!resp.ok) return json({ error: `embedding failed (HTTP ${resp.status})` }, 502);
    const payload = await resp.json();
    embedding = payload.data?.[0]?.embedding;
    if (!embedding?.length) return json({ error: "embedding provider returned no vector" }, 502);
    if (embedding.length !== 1536) return json({ error: `embedding dimension mismatch: expected 1536, received ${embedding.length}` }, 500);
    embedMs = performance.now() - embedStarted;

    const { error: putErr } = await supabase.rpc("query_embedding_cache_put_pilot_v2_9", {
      p_cache_key: cacheKey,
      p_model: model,
      p_profile_version: profileVersion,
      p_embedding: JSON.stringify(embedding),
      p_ttl_seconds: 604800,
    });
    if (putErr) console.error("query embedding cache put failed", putErr.message);
  }

  const dbStarted = performance.now();
  const { data, error } = await supabase.rpc("hybrid_search_query_embedding_pilot_v2_9", {
    p_query: normalizedQuery,
    p_query_embedding: JSON.stringify(embedding),
    p_country: country,
    p_level: level,
    p_limit: limit,
  });
  if (error) return json({ error: error.message }, 500);
  const dbMs = performance.now() - dbStarted;

  return json({
    status: "succeeded",
    query: originalQuery,
    normalized_query: normalizedQuery,
    intent: { inferred_level: norm.inferred_level ?? null, applied_aliases: norm.applied_aliases ?? [] },
    filters: { country, level, level_source: explicitLevel ? "request" : norm.inferred_level ? "intent" : null },
    embedding: { model, dimensions: embedding.length, profile_version: profileVersion, cache_hit: cacheHit, cache_hit_count: cacheHitCount },
    timings_ms: { cache_lookup: +cacheLookupMs.toFixed(1), embedding: +embedMs.toFixed(1), database: +dbMs.toFixed(1), total: +(cacheLookupMs + embedMs + dbMs).toFixed(1) },
    results: data ?? [],
  });
});
