import { createClient } from "npm:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const json = (d: unknown, s = 200) => new Response(JSON.stringify(d), { status: s, headers: { ...CORS, "Content-Type": "application/json" } });

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "POST required" }, 405);

  const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  let body: { query?: string; country?: string; level?: string; limit?: number } = {};
  try { body = await req.json(); } catch { return json({ error: "invalid JSON" }, 400); }

  const query = (body.query ?? "").trim();
  if (!query) return json({ error: "query is required" }, 400);
  const country = body.country ? body.country.trim().toUpperCase().slice(0, 2) : null;
  const level = body.level ? body.level.trim().toLowerCase() : null;
  const limit = Math.min(Math.max(body.limit ?? 20, 1), 50);

  const { data: cfgRows, error: cfgErr } = await supabase.from("pipeline_config").select("value").eq("key", "llm").limit(1);
  if (cfgErr) return json({ error: "embedding configuration unavailable" }, 500);
  const llm = cfgRows?.[0]?.value ?? {};
  if (!llm.api_key) return json({ error: "embedding provider is not configured" }, 500);

  const base = (llm.base_url ?? "https://openrouter.ai/api/v1").replace(/\/$/, "");
  const model = llm.embed_model ?? "openai/text-embedding-3-small";

  const embedStarted = performance.now();
  const resp = await fetch(`${base}/embeddings`, {
    method: "POST",
    headers: { "content-type": "application/json", authorization: `Bearer ${llm.api_key}` },
    body: JSON.stringify({ model, input: query }),
  });
  if (!resp.ok) return json({ error: `embedding failed (HTTP ${resp.status})` }, 502);
  const payload = await resp.json();
  const embedding: number[] | undefined = payload.data?.[0]?.embedding;
  if (!embedding?.length) return json({ error: "embedding provider returned no vector" }, 502);
  if (embedding.length !== 1536) return json({ error: `embedding dimension mismatch: expected 1536, received ${embedding.length}` }, 500);
  const embedMs = performance.now() - embedStarted;

  const dbStarted = performance.now();
  const { data, error } = await supabase.rpc("hybrid_search_query_embedding_pilot_v2_9", {
    p_query: query,
    p_query_embedding: JSON.stringify(embedding),
    p_country: country,
    p_level: level,
    p_limit: limit,
  });
  if (error) return json({ error: error.message }, 500);
  const dbMs = performance.now() - dbStarted;

  return json({
    status: "succeeded",
    query,
    filters: { country, level },
    model,
    dimensions: embedding.length,
    timings_ms: { embedding: +embedMs.toFixed(1), database: +dbMs.toFixed(1), total: +(embedMs + dbMs).toFixed(1) },
    results: data ?? [],
  });
});
