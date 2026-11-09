-- PASTE-20261024-au-quick-wins-fire.sql
-- Record of what was fired on 24 Oct 2026 (09:20–10:40 AEDT) for the AU quick-wins mandate
-- (docs/platform/nz-enrichment-brief/2026-10-24-au-quick-wins-and-247-ingestion.md, section 3).
-- Run as the Platform Admin (session claims set first). Every step is logged by the function it
-- calls (pipeline.admin_control_events) — re-running this file repeats nothing that was
-- already done: the fill is idempotent on bound pages, the central lane skips sources already
-- queued, proposed or approved, and the enrich task would create a new task.
-- Outcomes as read back live (ids and counts verified 10:30 AEDT):
--   course_url.fill_countries  ["NZ"] -> ["NZ","AU","CA"]        (control event 'setting', 09:21)
--   batch.course_url_fill      2000 -> 5000 -> 2000               (two 'setting' events)
--   course_url_fill_v1() x4    5,000 / 5,000 / 5,000 / 3,753 filled = 18,753
--                              by country AU 16,889, CA 1,863, NZ 1; refilled 1; retracted 0
--   admin_enrich_fields start  task 77c5a3bf-8e96-4c05-9617-6e5ae9892cc6, 1,269 items,
--                              finished: 1 filled, 1 review, 1,267 skipped
--   central_ai_enqueue_v1      206 AU providers checked, 94 fact sources enqueued (32 providers)

select set_config('request.jwt.claims', '{"sub":"63ba56cb-48d4-4169-98c2-7c4d1f72925b","role":"authenticated"}', true),
       set_config('request.jwt.claim.sub', '63ba56cb-48d4-4169-98c2-7c4d1f72925b', true);

-- 1. Widen the official-link fill to AU and CA (Platform Admin decision, 24 Oct 2026 09:17).
select public.admin_toolsets_write('setting', jsonb_build_object(
  'toolset', 'pipeline', 'key', 'course_url.fill_countries', 'value', '["NZ","AU","CA"]'::jsonb,
  'reason', 'Platform Admin 24 Oct 2026 09:17 (AU quick wins mandate): widen the official-link fill to AU and CA; the NZ run was clean (1,874 filled, 0 retractions)'));

-- 2. First fill in large runs, then back to the standing batch.
select public.admin_toolsets_write('setting', jsonb_build_object(
  'toolset', 'pipeline', 'key', 'batch.course_url_fill', 'value', to_jsonb(5000),
  'reason', 'Platform Admin 24 Oct 2026 09:17 (AU quick wins mandate): first AU/CA fill in large runs; back to 2,000 after'));

select security.course_url_fill_v1();   -- 5,000 (AU 4,512 / CA 487 / NZ 1; refilled 1)
select security.course_url_fill_v1();   -- 5,000 (AU 4,509 / CA 491)
select security.course_url_fill_v1();   -- 5,000 (AU 4,478 / CA 522)
select security.course_url_fill_v1();   -- 3,753 (AU 3,390 / CA 363) — the queue is drained

select public.admin_toolsets_write('setting', jsonb_build_object(
  'toolset', 'pipeline', 'key', 'batch.course_url_fill', 'value', to_jsonb(2000),
  'reason', 'Platform Admin 24 Oct 2026 09:17: first AU/CA fill done (16,889 AU, 1,863 CA); back to 2,000'));

-- Count guard (expected after the four runs): open fills AU 16,889, CA 1,863, NZ 2,055.
select country_code, count(*) from pipeline.course_url_fills f
  join catalogue.courses c on c.id = f.course_id join catalogue.providers p on p.id = c.provider_id join ref.countries k on k.id = p.country_id
 where f.retracted_at is null group by 1 order by 1;

-- 3. Enrich fields task for the 29 AU universities (intakes, English, duration, campus, delivery, international; AI over stored copies, no scraper).
-- Provider ids were the 29 named in the deliverable's section 3; the task runner created 1,269 items.
-- select public.admin_enrich_fields('start', jsonb_build_object('provider_ids', <29 uuids>, 'fields', '["intakes","english","duration","campus","delivery","international"]'::jsonb,
--   'ai', true, 'scraper', false, 'reason', 'Platform Admin 24 Oct 2026 09:17 (AU quick wins mandate): AU gaps from stored copies'));

-- 4. Central AI: queue the stored English-policy and intake-calendar pages of every published AU provider with a gap.
with gap as (
  select d.provider_id from search.course_documents d where d.country_code = 'AU'
   group by 1 having count(*) filter (where not d.has_english or not d.has_intake) > 0),
q as (select g.provider_id, security.central_ai_enqueue_v1(g.provider_id) n from gap g)
select count(*) providers, sum(n) enqueued, count(*) filter (where n > 0) providers_enqueued from q;
-- expected on first run: 206 / 94 / 32; on a re-run: 206 / 0 / 0
