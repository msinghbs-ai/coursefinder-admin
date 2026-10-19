-- CF-247 paste file, 19 Oct 2026: indexes nothing needs (Platform Admin 20:33: "refresh plan for evidence, plan and execute the next steps").
-- Project: fxcwkweaxjtknorudmwp (StudySearch). Paste into the Supabase SQL editor and run as one block.
--
-- Drops 6 indexes (about 14 MB) that are used a handful of times or never in the 87 days since the statistics were last reset, or that
-- repeat another index:
--   pipeline.evidence_job_idx                    repeats pipeline.pipeline_evidence_job_idx (job_id, which also serves the job_id lookups)
--   pipeline.evidence_entity_links_provider_idx  11 uses in 87 days (the old evidence link model)
--   pipeline.layer2_evidence_review_idx          5 uses (retired Layer 2 review)
--   pipeline.evidence_layer2_profile_version_idx 5 uses (retired source profiles)
--   pipeline.layer2_items_batch_status_idx       13 uses (retired Layer 2 batch runner)
--   pipeline.idx_l2_course_discovery_trial       2 uses (retired discovery trials; the table is empty)
-- Indexes the consumer API's tables use (search, catalogue) are not touched. No table, row or column changes; an index can be built again
-- at any time from the definition kept in the component register note.
-- Checks first: each index is exactly the definition reviewed, backs no constraint, and is still barely used. If not, nothing is dropped.
begin;
do $idx$
declare r record; v_bad text;
begin
  for r in select * from (values
      ('pipeline.evidence_job_idx', '8eeff8287aaeafc3a85de1a5a0748215', 50000),
      ('pipeline.evidence_entity_links_provider_idx', 'dcef1d0a5d3acc2891cf3ab9b9351492', 50),
      ('pipeline.layer2_evidence_review_idx', 'c0b33d4206842ea5a351d5cdaeafa607', 50),
      ('pipeline.evidence_layer2_profile_version_idx', '11da9cc0f6425cd1fd40696481430d3b', 50),
      ('pipeline.layer2_items_batch_status_idx', 'df956bf9457bcba6286341abd622fe57', 50),
      ('pipeline.idx_l2_course_discovery_trial', '82615f71117e6c0ec433c78287f8b739', 50)) x(idx, md5, max_scans) loop
    select string_agg(r.idx, ', ') into v_bad from pg_stat_user_indexes s
     where s.schemaname || '.' || s.indexrelname = r.idx
       and (md5(pg_get_indexdef(s.indexrelid)) <> r.md5 or s.idx_scan > r.max_scans or exists (select 1 from pg_constraint k where k.conindid = s.indexrelid));
    if v_bad is not null then raise exception '% changed or is now in use; nothing dropped', v_bad; end if;
    if to_regclass(r.idx) is null then raise exception '% not found; nothing dropped', r.idx; end if;
  end loop;
  if to_regclass('pipeline.pipeline_evidence_job_idx') is null then raise exception 'the job_id index that stays is missing; nothing dropped'; end if;
end $idx$;

drop index pipeline.evidence_job_idx;
drop index pipeline.evidence_entity_links_provider_idx;
drop index pipeline.layer2_evidence_review_idx;
drop index pipeline.evidence_layer2_profile_version_idx;
drop index pipeline.layer2_items_batch_status_idx;
drop index pipeline.idx_l2_course_discovery_trial;

do $chk$ begin
  if jsonb_array_length(security.consumer_api_check_v1() -> 'drift') <> 0 then raise exception 'consumer API drift'; end if;
end $chk$;
commit;
