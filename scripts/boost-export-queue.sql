-- CF-247 Boost queue exporter (Platform Admin, 16 Nov 2026 20:31). READ ONLY: every statement runs inside
--   begin; set transaction read only; set local statement_timeout = '20s'; ... rollback;
-- scripts/boost-export-queue.ts picks the path, runs ONE block below (split on the "-- @block" lines), fetches each item's stored page from
-- Supabase Storage, builds the [B#] blocks and the section selection, and writes staging-boost/outbound/*.ndjson.
-- Project fxcwkweaxjtknorudmwp ONLY (never coursefinder-demo). Nothing here writes, locks or calls a function that writes.
--
-- Paths (automatic):
--   A  pipeline.field_execution_registry exists and declares the lane (S2 - SS Build PR 3, from Mon 16 Nov 23:15 AEDT): the live queue per lane.
--   B  otherwise: the fixture. The 50 frozen AER benchmark cases (set 5, admin #519) and 25 rows for study_load (15) and accreditations (10).
-- Deterministic fields (campuses.is_primary, empty_reason_code, grade_scale_conversions, destination.*) are not exported: S2 - SS Build owns them.

-- @block header
-- allowed values as the live CHECK constraints state them, and the field dictionary rows for the four lanes
select jsonb_build_object(
  'checks', (select coalesce(jsonb_object_agg(c.conname, pg_get_constraintdef(c.oid)), '{}'::jsonb)
             from pg_constraint c join pg_class t on t.oid = c.conrelid join pg_namespace n on n.oid = t.relnamespace
             where c.contype = 'c' and n.nspname = 'catalogue'
               and t.relname in ('courses', 'provider_accreditations', 'course_fees', 'course_entry_requirements')
               and pg_get_constraintdef(c.oid) ~* '(study_load|body_code|status|audience|fee_type)'),
  'dictionary', (select coalesce(jsonb_agg(jsonb_build_object('api_surface', d.api_surface, 'version', d.version, 'endpoint', d.endpoint,
                   'field_path', d.field_path, 'data_type', d.data_type, 'is_nullable', d.is_nullable, 'allowed_values', d.allowed_values)
                   order by d.api_surface, d.endpoint, d.field_path), '[]'::jsonb)
                 from ref.api_field_dictionary d
                 where d.version = 'v3' and d.endpoint in ('course', 'courses', 'provider', 'providers')
                   and d.field_path ~* '(study_load|accreditation|entry_requirement|description|fee)'),
  'registry', to_regclass('pipeline.field_execution_registry') is not null,
  'read_at', now()) as header;

-- @block fixture
-- Path B. 75 rows: 50 AER (set 5) + 15 study_load + 10 accreditations. Ordered, so the fixture is the same on every run.
with aer as (
  select 'aer_entry'::text lane, 'aer-' || e.id item_key, e.entity, e.entity_id, e.evidence_id, a.storage_path, a.source_url,
         jsonb_build_object('stratum', m.stratum, 'field', e.field, 'label', e.label) context, e.expected gold
  from pipeline.ai_eval_set_members m
  join pipeline.ai_eval_examples e on e.id = m.example_id
  left join pipeline.evidence_artifacts a on a.id = e.evidence_id
  where m.set_id = 5
  order by e.id
), sl as (
  select distinct on (i.course_id) 'study_load'::text lane, 'sl-' || i.course_id item_key, 'course'::text entity, i.course_id entity_id,
         i.evidence_id, coalesce(i.storage_path, a.storage_path) storage_path, coalesce(a.source_url, c.course_url) source_url,
         jsonb_build_object('title', c.display_title, 'from_field', i.field) context,
         jsonb_build_object('stated_quote', i.quote) gold
  from pipeline.field_enrich_items i
  join catalogue.courses c on c.id = i.course_id and c.lifecycle_status = 'active' and c.study_load is null
  left join pipeline.evidence_artifacts a on a.id = i.evidence_id
  where i.field in ('duration', 'intakes', 'delivery') and i.state = 'filled' and i.quote ~* '(full|part)[ -]?time'
  order by i.course_id, i.id desc
), acc as (
  select 'provider_accreditations'::text lane, 'acc-' || p.id item_key, 'provider'::text entity, p.id entity_id,
         r.evidence_id, a.storage_path, coalesce(r.source_url, p.website) source_url,
         jsonb_build_object('provider', p.display_name, 'website', p.website) context, null::jsonb gold
  from catalogue.providers p
  join lateral (select r.evidence_id, r.source_url from pipeline.provider_description_reads r
                where r.provider_id = p.id and r.evidence_id is not null order by r.updated_at desc limit 1) r on true
  left join pipeline.evidence_artifacts a on a.id = r.evidence_id
  where p.lifecycle_status = 'active' and p.canonical_name ~* '(business school|school of business|graduate school of management|university)'
  order by (p.canonical_name ~* 'business|management') desc, p.canonical_name
)
select jsonb_agg(x) as items from (
  (select * from aer)
  union all (select * from sl order by item_key limit 15)
  union all (select * from acc limit 10)
) x;

-- @block registry
-- Path A. :lane and :limit are bound by the exporter. The registry's own columns are read through to_jsonb, so a renamed column fails
-- loudly ("lane not declared") rather than exporting the wrong lane.
with lane as (
  select to_jsonb(r) reg from pipeline.field_execution_registry r
  where coalesce(to_jsonb(r)->>'lane', to_jsonb(r)->>'lane_key', to_jsonb(r)->>'field') = :'lane'
)
select case when not exists (select 1 from lane) then jsonb_build_object('error', 'lane not declared in pipeline.field_execution_registry')
  else jsonb_build_object('registry', (select reg from lane), 'items', case :'lane'
    when 'study_load' then (select coalesce(jsonb_agg(q), '[]') from (
      select 'study_load' lane, 'sl-' || c.id item_key, 'course' entity, c.id entity_id, a.id evidence_id, a.storage_path, coalesce(a.source_url, c.course_url) source_url,
             jsonb_build_object('title', c.display_title) context, null::jsonb gold
      from catalogue.courses c
      join lateral (select a.* from pipeline.evidence_artifacts a where a.entity_id = c.id and a.evidence_type in ('source_snapshot', 'provider_course_page_text')
                    order by a.captured_at desc limit 1) a on true
      where c.lifecycle_status = 'active' and c.study_load is null
      order by c.id limit :limit) q)
    when 'provider_accreditations' then (select coalesce(jsonb_agg(q), '[]') from (
      select 'provider_accreditations' lane, 'acc-' || p.id item_key, 'provider' entity, p.id entity_id, r.evidence_id, a.storage_path, coalesce(r.source_url, p.website) source_url,
             jsonb_build_object('provider', p.display_name, 'website', p.website) context, null::jsonb gold
      from catalogue.providers p
      join lateral (select r.evidence_id, r.source_url from pipeline.provider_description_reads r where r.provider_id = p.id and r.evidence_id is not null
                    order by r.updated_at desc limit 1) r on true
      left join pipeline.evidence_artifacts a on a.id = r.evidence_id
      where p.lifecycle_status = 'active' and p.canonical_name ~* '(business|management|university)'
        and not exists (select 1 from catalogue.provider_accreditations x where x.provider_id = p.id)
      order by p.id limit :limit) q)
    when 'aer_entry' then (select coalesce(jsonb_agg(q), '[]') from (
      select 'aer_entry' lane, 'aer-' || l.id item_key, l.entity_type entity, l.entity_id, l.evidence_id, a.storage_path, a.source_url,
             jsonb_build_object('field', l.field_code, 'review_item', l.id) context, null::jsonb gold
      from pipeline.layer4_review_items l left join pipeline.evidence_artifacts a on a.id = l.evidence_id
      where l.status = 'pending' and l.field_code in ('course_entry_first_read', 'entry_matrix_first_run', 'entry_matrix_change') and l.evidence_id is not null
      order by l.created_at limit :limit) q)
    when 'course_description' then (select coalesce(jsonb_agg(q), '[]') from (
      select 'course_description' lane, 'cd-' || i.id item_key, 'course' entity, i.course_id entity_id, i.evidence_id, i.storage_path, null::text source_url,
             jsonb_build_object('field_item', i.id) context, null::jsonb gold
      from pipeline.field_enrich_items i where i.field = 'description' and i.state = 'waiting' and i.storage_path is not null
      order by i.id limit :limit) q)
    when 'course_fees' then (select coalesce(jsonb_agg(q), '[]') from (
      select 'course_fees' lane, 'fee-' || to_jsonb(f)->>'id' item_key, 'course' entity, (to_jsonb(f)->>'course_id')::uuid entity_id,
             (to_jsonb(f)->>'evidence_id')::uuid evidence_id, to_jsonb(f)->>'storage_path' storage_path, null::text source_url,
             jsonb_build_object('queue_item', to_jsonb(f)->>'id') context, null::jsonb gold
      from pipeline.fee_reader_queue f where to_jsonb(f)->>'state' = 'waiting'
      order by 2 limit :limit) q)
    else '[]'::jsonb end) end as export;
