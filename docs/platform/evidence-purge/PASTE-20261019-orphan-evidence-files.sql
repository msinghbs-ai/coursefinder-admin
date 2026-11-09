-- CF-247 paste file, 19 Oct 2026: remove evidence files no record uses (Platform Admin 20:33: "refresh plan for evidence, plan and
-- execute the next steps").
-- Project: fxcwkweaxjtknorudmwp (StudySearch). Paste into the Supabase SQL editor and run as one block.
--
-- What it removes: 28,938 files in the evidence bucket (about 1.56 GB) that no record names, listed in pipeline.orphan_files:
-- 27,766 course-page files, 621 adapter-builder captures whose draft is gone, 551 scholarship page files, all saved before 19 Oct 2026.
-- Their Storage records were exported first (bucket "archive", folder cf247-orphan-files-2026-10-19/39234401795). The files themselves
-- are not kept: no record points to them, and a newer copy of every page that is in use is kept.
-- Database space handed back: about 80 MB of Storage records. Storage: about 1.56 GB.
--
-- What it does, in one transaction (all or nothing):
--   1 Checks the export in Storage, every file with its size.
--   2 Checks the three lists are still exactly what was exported (count and key hash).
--   3 Checks again, now, that no record names any of these files (every file-path column, the register replay path lists, kept copies in
--      the dedupe log, and an adapter draft for adapter captures). If one does, it stops and removes nothing.
--   4 Lists the files for removal by evidence-storage-dedupe (which skips any file an evidence record still uses) and marks the list done.
--   5 After the commit, asks evidence-storage-dedupe to remove them (about 100 seconds a run; StudySearch runs it again until every file
--      is gone and reports the result).
begin;
set local statement_timeout = '10min';  -- the check reads 21 path lists once; the limit is only a safety margin
create temp table used_paths on commit drop as
select storage_path p from pipeline.evidence_artifacts where storage_path is not null
union select storage_path from catalogue.provider_assets union select storage_path from pipeline.admin_job_items union select storage_path from pipeline.course_companion_pages
union select storage_path from pipeline.coverage_identity_cases union select storage_path from pipeline.directory_pages union select storage_path from pipeline.evidence_lineage_reconciliations
union select keeper_path from pipeline.evidence_storage_dedupe_log where status <> 'deleted' union select storage_path from pipeline.field_enrich_items
union select storage_path from pipeline.provider_contact_import_batches union select storage_path from pipeline.reference_institutions union select storage_path from pipeline.register_replay_runs
union select unnest(paths) from pipeline.register_replay_runs union select storage_path from pipeline.rule6_page_checks union select storage_path from pipeline.scholarship_ai_extractions
union select storage_path from pipeline.scholarship_ai_queue union select storage_path from pipeline.scholarship_ai_reviews union select storage_path from pipeline.scholarship_page_candidates
union select storage_path from ranking.manual_imports union select storage_path from workflow.export_jobs union select storage_path from workflow.import_jobs;
create index on used_paths (p);
analyze used_paths;

do $orph$
declare v_refs text; v_n bigint; v_h text; v_listed bigint;
begin
  -- 1 the export is in Storage
  select string_agg(x.name, ', ') into v_refs
    from (values
      ('cf247-orphan-files-2026-10-19/39234401795/orphan_course_page_files/part-000.jsonl.gz', 1445839),
      ('cf247-orphan-files-2026-10-19/39234401795/orphan_course_page_files/part-001.jsonl.gz', 1449321),
      ('cf247-orphan-files-2026-10-19/39234401795/orphan_course_page_files/part-002.jsonl.gz', 1127754),
      ('cf247-orphan-files-2026-10-19/39234401795/orphan_adapter_files/part-000.jsonl.gz', 66632),
      ('cf247-orphan-files-2026-10-19/39234401795/orphan_scholarship_files/part-000.jsonl.gz', 74896),
      ('cf247-orphan-files-2026-10-19/39234401795/manifest.json', 2145)) x(name, bytes)
   where not exists (select 1 from storage.objects o where o.bucket_id = 'archive' and o.name = x.name and (o.metadata->>'size')::bigint = x.bytes);
  if v_refs is not null then raise exception 'export not found in Storage (or a different size): %; nothing removed', v_refs; end if;

  -- 2 the lists are exactly what was exported
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select o.id from storage.objects o join pipeline.orphan_files f on f.object_id = o.id where o.bucket_id = 'evidence' and f.kind = 'course_page') z) y;
  if v_n <> 27766 or v_h <> '370ca11ce85aa932e466d73e455e1e9d' then raise exception 'course-page files: % now, 27766 exported (or different files); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select o.id from storage.objects o join pipeline.orphan_files f on f.object_id = o.id where o.bucket_id = 'evidence' and f.kind = 'adapter_capture') z) y;
  if v_n <> 621 or v_h <> '63672aa5e85d83f1efa7c4d9f0aa6c19' then raise exception 'adapter captures: % now, 621 exported (or different files); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select o.id from storage.objects o join pipeline.orphan_files f on f.object_id = o.id where o.bucket_id = 'evidence' and f.kind = 'scholarship_page') z) y;
  if v_n <> 551 or v_h <> 'a16af6bf61af3be606e7b182d248f25b' then raise exception 'scholarship files: % now, 551 exported (or different files); nothing removed', v_n; end if;

  -- 3 nothing names them now
  select count(*) into v_n from pipeline.orphan_files f join used_paths u on u.p = f.name;
  if v_n > 0 then raise exception '% of the listed files are now named by a record; nothing removed', v_n; end if;
  select count(*) into v_n from pipeline.orphan_files f
   where f.kind = 'adapter_capture' and exists (select 1 from pipeline.uni_adapter_drafts d where d.id::text = split_part(f.name, '/', 5));
  if v_n > 0 then raise exception '% adapter captures belong to a draft again; nothing removed', v_n; end if;

  -- 4 list them for removal
  insert into pipeline.evidence_storage_dedupe_log(path, keeper_path, content_hash, bytes, scope, repointed_rows, status)
  select f.name, f.name, '', f.bytes, 'orphan_files_20261019', 0, 'repointed' from pipeline.orphan_files f
  on conflict (path) do nothing;
  get diagnostics v_listed = row_count;
  if v_listed <> 28938 then raise exception 'listed % files, expected 28938; nothing removed', v_listed; end if;
  update pipeline.component_register set status = 'retiring', retire_after = current_date + 14, replaced_by = 'nothing',
         note = 'Files listed for removal 19 Oct 2026 (export cf247-orphan-files-2026-10-19/39234401795)', updated_at = now()
   where kind = 'table' and name = 'pipeline.orphan_files';
  raise notice '% files listed for removal', v_listed;
end $orph$;

-- 5 after the commit: remove the files (the request is sent when this transaction commits)
select net.http_post(url := rtrim(public.coursefinder_runtime_edge_base_url(), '/') || '/evidence-storage-dedupe',
                     headers := jsonb_build_object('content-type', 'application/json', 'x-cf-run-nonce', public.svc_pilot_issue_nonce('evidence-storage-dedupe')::text),
                     body := '{"remove": true, "limit": 100}'::jsonb, timeout_milliseconds := 120000) as file_removal_request;
commit;
