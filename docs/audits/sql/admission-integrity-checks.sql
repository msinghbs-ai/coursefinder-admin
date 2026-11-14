-- StudySearch / CourseFinder: storage and admission integrity checks (READ ONLY).
-- Companion to docs/audits/studysearch-ingestion-validation-report.md (14 Nov 2026). Every query below was run on the Pilot project
-- fxcwkweaxjtknorudmwp on 14 Nov 2026 and returned in under the SQL Editor's default time limit; results quoted in the report.
-- Nothing here writes, deletes, calls a worker or spends a credit. Paste one query at a time into the Supabase SQL Editor.

-- S1. Buckets: limits, allowed MIME types, object counts ------------------------------------------------------------------------------
select b.id, b.public, b.file_size_limit, b.allowed_mime_types,
       (select count(*) from storage.objects o where o.bucket_id = b.id) objects
from storage.buckets b order by 1;

-- S2. Evidence bucket by prefix and stored MIME type: zero-byte objects, size, last write ---------------------------------------------
select split_part(name,'/',1)||'/'||split_part(name,'/',2)||'/'||split_part(name,'/',3) prefix,
       metadata->>'mimetype' mime, count(*) n,
       count(*) filter (where coalesce((metadata->>'size')::bigint,0) = 0) zero_bytes,
       round(sum(coalesce((metadata->>'size')::bigint,0))/1048576.0,1) mb,
       max(created_at)::date last_written
from storage.objects where bucket_id = 'evidence'
group by 1,2 order by n desc limit 40;

-- S3. Manifest rows whose object is missing, empty, or whose path hash disagrees with the recorded hash; MIME semantics per type -------
--     (recorded_mime is the CONTENT type; object_mime is the CONTAINER type: gzip copies are 'application/gzip' with metadata.gzip = true)
with ea as (
  select id, evidence_type, mime_type, storage_path, content_hash from pipeline.evidence_artifacts
  where evidence_type in ('source_snapshot','scholarship_ai_page','scholarship_candidate_page','scholarship_page','enrich_home_page'))
select ea.evidence_type, ea.mime_type recorded_mime, o.metadata->>'mimetype' object_mime, count(*) n,
       count(*) filter (where o.id is null) missing_object,
       count(*) filter (where o.id is not null and coalesce((o.metadata->>'size')::bigint,0) = 0) zero_bytes,
       count(*) filter (where ea.storage_path ~ '[0-9a-f]{64}\.' and substring(ea.storage_path from '([0-9a-f]{64})\.') <> ea.content_hash) path_hash_disagrees
from ea left join storage.objects o on o.bucket_id = 'evidence' and o.name = ea.storage_path
group by 1,2,3 order by n desc;

-- S4. Objects with no manifest row, by prefix (an "orphan" here only means no pipeline.evidence_artifacts row: companion, adapter and
--     Firecrawl-run copies are referenced from their own tables by design; see S5 for the coverage case) ---------------------------------
select split_part(o.name,'/',1)||'/'||split_part(o.name,'/',2)||'/'||split_part(o.name,'/',3) prefix,
       count(*) objects, count(*) filter (where ea.id is null) no_artifact_row,
       round(sum(coalesce((o.metadata->>'size')::bigint,0)) filter (where ea.id is null)/1048576.0,1) orphan_mb,
       count(*) filter (where coalesce((o.metadata->>'size')::bigint,0) < 200) under_200_bytes
from storage.objects o left join pipeline.evidence_artifacts ea on ea.storage_path = o.name
where o.bucket_id = 'evidence' and o.name ~ '^layer2/(AU|NZ|CA)/'
group by 1 order by objects desc limit 20;

-- S5. Coverage copies with no manifest row whose content is already registered under another path (duplicate bytes, not lost evidence).
--     30-day window keeps it inside the time limit; change 'AU' to 'NZ' or 'CA' for the other prefixes. -------------------------------------
with orph as materialized (
  select o.name, substring(o.name from '([0-9a-f]{64})\.html\.gz$') h, o.created_at
  from storage.objects o
  where o.bucket_id = 'evidence' and o.name like 'layer2/AU/coverage/%' and o.created_at > now() - interval '30 days'
    and not exists (select 1 from pipeline.evidence_artifacts ea where ea.storage_path = o.name))
select count(*) orphans_30d,
       count(*) filter (where exists (select 1 from pipeline.evidence_artifacts e where e.content_hash = orph.h and e.evidence_type = 'source_snapshot')) same_hash_registered,
       min(created_at)::date first, max(created_at)::date last
from orph;

-- S6. Scholarship copies stored under the AU prefix, by provider country (the worker writes every scholarship copy to layer2/AU/...) ----
select cp.country_id, count(*) objects
from storage.objects o left join catalogue.providers cp on cp.id::text = split_part(o.name,'/',4)
where o.bucket_id = 'evidence' and o.name like 'layer2/AU/scholarships/%'
group by 1 order by 2 desc;

-- S7. Duplicate manifest rows for identical content (same hash, same URL) per evidence type --------------------------------------------
select evidence_type, count(*) rows, count(distinct (content_hash, source_url)) distinct_content_url,
       count(*) - count(distinct (content_hash, source_url)) duplicate_rows
from pipeline.evidence_artifacts
where evidence_type in ('source_snapshot','scholarship_ai_page','scholarship_candidate_page','scholarship_page')
group by 1 order by 2 desc;

-- A1. Scholarship AI spend by outcome, 14 days (what an admission gate could have avoided) ---------------------------------------------
select coalesce(verdict, case when error is not null then 'error' else 'none' end) outcome, count(*) n, round(sum(cost_usd),2) usd,
       percentile_cont(0.5) within group (order by tokens_in) p50_tokens_in,
       count(*) filter (where url ~* '(scholarship|bursar|grant|award|stipend|prize|waiver|funding)') url_has_award_word
from pipeline.scholarship_ai_extractions where at > now() - interval '14 days'
group by 1 order by usd desc nulls last;

-- A2. AI calls on near-empty stored scholarship copies (under 600 compressed bytes), all time ---------------------------------------------
with tiny as (
  select name from storage.objects
  where bucket_id = 'evidence' and name like 'layer2/%/scholarships/%' and coalesce((metadata->>'size')::bigint,0) < 600)
select (select count(*) from tiny) tiny_objects,
       count(x.id) ai_calls, round(sum(x.cost_usd),3) usd, string_agg(distinct coalesce(x.verdict,'error'), ',') outcomes
from tiny t join pipeline.scholarship_ai_extractions x on x.storage_path = t.name;

-- A3. Repeat paid reads of the same stored content with the same prompt version and model, 14 days (F4 cache gap) -----------------------
with x as (
  select coalesce(x.content_hash, ea.content_hash) h, x.prompt_version, x.model_identifier, x.run_kind, x.cost_usd
  from pipeline.scholarship_ai_extractions x left join pipeline.evidence_artifacts ea on ea.id = x.evidence_id
  where x.at > now() - interval '14 days' and x.error is null and x.cost_usd > 0)
select run_kind, count(*) paid, count(*) filter (where h is null) no_hash,
       count(distinct (h, prompt_version, model_identifier)) filter (where h is not null) distinct_inputs, round(sum(cost_usd),2) usd,
       round((select sum(c) from (select sum(cost_usd) - max(cost_usd) c from x x2 where x2.run_kind = x.run_kind and x2.h is not null
              group by h, prompt_version, model_identifier) s),2) repeat_usd
from x group by run_kind order by usd desc;

-- A4. Answers lost or under-costed: record time-outs, cut answers, refusals, 14 days ---------------------------------------------------
select left(regexp_replace(error,'[0-9]+','#','g'),70) error_kind, count(*) n, round(sum(cost_usd),2) recorded_usd
from pipeline.scholarship_ai_extractions where at > now() - interval '14 days' and error is not null
group by 1 order by n desc limit 15;

-- A5. Lean AI Phase 1 observation coverage: observations vs enrichment reads since the switch was turned on -------------------------------
select (select value from pipeline.platform_toolset_settings where key = 'reading.input_observe_on') observe_on,
       (select updated_at from pipeline.platform_toolset_settings where key = 'reading.input_observe_on') switched_at,
       (select count(*) from pipeline.ai_input_observations) observations,
       (select max(received_at) from pipeline.enrich_ai_answers) last_enrich_answer;

-- H1. Harness sample: 3 recent stored copies per lane as ArtifactManifest rows (save the JSON array as sample.json) ----------------------
with pick as (
  select ea.*, case when ea.evidence_type like 'scholarship%' then 'scholarship' else 'aer' end lane,
         row_number() over (partition by case when ea.evidence_type like 'scholarship%' then 'scholarship' else 'aer' end order by ea.captured_at desc) rn
  from pipeline.evidence_artifacts ea
  where ea.evidence_type in ('source_snapshot','scholarship_ai_page','scholarship_candidate_page','scholarship_page')
    and ea.storage_path like 'layer2/%' and ea.captured_at > now() - interval '7 days')
select jsonb_agg(jsonb_build_object(
  'evidence_id', p.id, 'bucket', 'evidence', 'storage_path', p.storage_path,
  'container', case when p.storage_path like '%.gz' then 'gzip' else 'none' end,
  'content_mime', case when p.mime_type = 'application/gzip' then 'text/html' else p.mime_type end,
  'content_sha256', p.content_hash, 'stored_bytes', coalesce((o.metadata->>'size')::bigint, 0),
  'source_url', p.source_url, 'fetched_via', p.metadata->>'fetched_via', 'page_status', null,
  'captured_at', p.captured_at, 'lane', p.lane)) manifest
from pick p left join storage.objects o on o.bucket_id = 'evidence' and o.name = p.storage_path
where p.rn <= 3;   -- raise to 50 for a real batch
