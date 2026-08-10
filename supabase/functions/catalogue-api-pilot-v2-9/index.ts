import { createClient } from "npm:@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
};

const json = (body: unknown, status = 200, extra: Record<string,string> = {}) =>
  new Response(JSON.stringify(body), {
    status,
    headers: {
      ...cors,
      "Content-Type": "application/json",
      "Cache-Control": "public, max-age=30",
      ...extra,
    },
  });

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "GET") return json({ error: "GET only" }, 405);

  const started = performance.now();
  const url = new URL(req.url);
  const q = (url.searchParams.get("q") ?? "").trim().slice(0, 80);
  const country = (url.searchParams.get("country") ?? "").trim().toUpperCase().slice(0, 2);
  const level = (url.searchParams.get("level") ?? "").trim().slice(0, 40);
  const limit = Math.min(Math.max(Number(url.searchParams.get("limit") ?? 20) || 20, 1), 50);

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { auth: { persistSession: false, autoRefreshToken: false } },
  );

  let query = supabase
    .from("courses")
    .select("id,canonical_title,level_code,field_of_study,duration_weeks,course_url,publication,providers!inner(id,canonical_name,country_code,city),course_fees(amount_min,amount_max,currency,billing_period,academic_year)")
    .eq("publication", "published")
    .order("canonical_title", { ascending: true })
    .limit(limit);

  if (q) query = query.ilike("canonical_title", `%${q}%`);
  if (country) query = query.eq("providers.country_code", country);
  if (level) query = query.eq("level_code", level);

  const { data, error } = await query;
  if (error) return json({ error: "query_failed", detail: error.message }, 500);

  const results = (data ?? []).map((row: any) => ({
    course_id: row.id,
    course_name: row.canonical_title,
    level: row.level_code,
    field_of_study: row.field_of_study,
    duration_weeks: row.duration_weeks,
    course_url: row.course_url,
    provider: row.providers ? {
      provider_id: row.providers.id,
      university_name: row.providers.canonical_name,
      country_code: row.providers.country_code,
      city: row.providers.city,
    } : null,
    fees: (row.course_fees ?? []).slice(0, 3),
  }));

  const elapsed = Math.round((performance.now() - started) * 10) / 10;
  return json({
    api_version: "pilot-v2.9",
    filters: { q: q || null, country: country || null, level: level || null, limit },
    count: results.length,
    db_roundtrips: 1,
    elapsed_ms: elapsed,
    results,
  }, 200, { "X-Coursefinder-Elapsed-Ms": String(elapsed) });
});
