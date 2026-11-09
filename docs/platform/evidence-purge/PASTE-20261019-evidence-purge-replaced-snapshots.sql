-- CF-247 paste file, 19 Oct 2026: remove the replaced course-page snapshots (Platform Admin 06:34, evidence retention: "Archive, then
-- remove (Recommended)"; 17:05: "Proceed with task 4,5 and 6").
-- Project: fxcwkweaxjtknorudmwp (StudySearch). Paste into the Supabase SQL editor and run as one block.
--
-- What it removes: 8,531 course-page snapshots (pipeline.evidence_artifacts, evidence type source_snapshot) that a newer snapshot of the
-- same course page has replaced and that job evidence-purge-prepare found referred to nowhere (pipeline.evidence_purge, state checked),
-- with the 223 link-index rows that go with them (ON DELETE CASCADE). Their 8,517 files in the evidence bucket (about 240 MB) are then
-- removed through the Storage API by evidence-storage-dedupe, which skips any file another record still uses.
-- Database space handed back: about 8 MB (rows, index entries and Storage records). Storage: about 240 MB.
--
-- What it does, in one transaction (all or nothing):
--   1 Checks the export in Storage (bucket "archive", folder cf247-evidence-purge-2026-10-19/39208392871): every file, with its size.
--   2 Checks the three row sets are still exactly what was exported (row count and key hash). If anything changed, it stops and removes
--     nothing; run the export again and ask for a new paste file.
--   3 Checks again, now, that no column anywhere refers to these snapshots (every uuid column named *evidence_id*, *evidence_artifact_id*
--     or source_artifact_id, and the three uuid[] evidence lists), apart from the cascade-only link index. If one does, it stops.
--   4 Lists their files for removal, removes the rows, and checks the counts.
--   5 Stops the job evidence-purge-prepare (its work is done) and records it in the component register.
--   6 After the commit, asks evidence-storage-dedupe to remove the files (it runs on its own for up to 100 seconds; StudySearch runs it
--     again until every file is gone and reports the result).
-- After it, run the VACUUM line at the end ON ITS OWN to hand the space back.
begin;
set local statement_timeout = '15min';  -- the reference check reads every evidence column once; the limit is only a safety margin
do $purge$
declare v_refs text; v_n bigint; v_h text; v_ids uuid[]; r record; v_hit bigint; v_del bigint; v_idx_before bigint; v_paths bigint;
begin
  -- 1 the export is in Storage
  select string_agg(x.name, ', ') into v_refs
    from (values
      ('cf247-evidence-purge-2026-10-19/39208392871/evidence_artifacts_replaced/part-000.jsonl.gz', 833185),
      ('cf247-evidence-purge-2026-10-19/39208392871/evidence_artifacts_replaced/part-001.jsonl.gz', 588226),
      ('cf247-evidence-purge-2026-10-19/39208392871/evidence_link_index_state_cascade/part-000.jsonl.gz', 7126),
      ('cf247-evidence-purge-2026-10-19/39208392871/evidence_storage_objects/part-000.jsonl.gz', 725149),
      ('cf247-evidence-purge-2026-10-19/39208392871/evidence_storage_objects/part-001.jsonl.gz', 509763),
      ('cf247-evidence-purge-2026-10-19/39208392871/manifest.json', 2190)) x(name, bytes)
   where not exists (select 1 from storage.objects o where o.bucket_id = 'archive' and o.name = x.name and (o.metadata->>'size')::bigint = x.bytes);
  if v_refs is not null then raise exception 'export not found in Storage (or a different size): %; nothing removed', v_refs; end if;

  -- 2 every row set is exactly what was exported
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select e.* from pipeline.evidence_artifacts e where e.id in (select p.evidence_id from pipeline.evidence_purge p where p.state = 'checked')) z) y;
  if v_n <> 8531 or v_h <> 'd8cca369ea71e3eaa110027f38d77dc4' then raise exception 'evidence_artifacts_replaced: % rows now, 8531 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select md5(to_jsonb(z)::text) k from (select s.* from pipeline.evidence_link_index_state s where s.evidence_id in (select p.evidence_id from pipeline.evidence_purge p where p.state = 'checked')) z) y;
  if v_n <> 223 or v_h <> '536261af40661435f609a911696192ac' then raise exception 'evidence_link_index_state_cascade: % rows now, 223 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select o.id, o.bucket_id, o.name, o.metadata, o.created_at, o.updated_at from storage.objects o where o.bucket_id = 'evidence' and o.name in (select p.storage_path from pipeline.evidence_purge p where p.state = 'checked')) z) y;
  if v_n <> 8517 or v_h <> '9ef6d97eb7abd89ed65c8ebdd46f136d' then raise exception 'evidence_storage_objects: % rows now, 8517 exported (or different rows); nothing removed', v_n; end if;

  -- 3 nothing refers to them now
  v_ids := array(select p.evidence_id from pipeline.evidence_purge p where p.state = 'checked');
  for r in select c.table_schema sch, c.table_name tbl, c.column_name col
             from information_schema.columns c join information_schema.tables t on t.table_schema = c.table_schema and t.table_name = c.table_name and t.table_type = 'BASE TABLE'
            where c.data_type = 'uuid' and (c.column_name ilike '%evidence_id%' or c.column_name ilike '%evidence_artifact_id%' or c.column_name = 'source_artifact_id')
              and c.table_schema not in ('information_schema', 'pg_catalog')
              and not (c.table_schema = 'pipeline' and c.table_name = 'evidence_purge')
              and not exists (select 1 from pg_constraint k join pg_attribute a on a.attrelid = k.conrelid and a.attnum = k.conkey[1]
                                where k.contype = 'f' and k.confrelid = 'pipeline.evidence_artifacts'::regclass and k.confdeltype = 'c'
                                  and k.conrelid = format('%I.%I', c.table_schema, c.table_name)::regclass and a.attname = c.column_name) loop
    if r.sch = 'pipeline' and r.tbl = 'evidence_artifacts' then  -- a snapshot being removed may point at another being removed
      execute format('select count(*) from pipeline.evidence_artifacts where %I = any($1) and id <> all($1)', r.col) into v_hit using v_ids;
    else
      execute format('select count(*) from %I.%I where %I = any($1)', r.sch, r.tbl, r.col) into v_hit using v_ids;
    end if;
    if v_hit > 0 then raise exception '%.%.% now refers to % of these snapshots; nothing removed', r.sch, r.tbl, r.col, v_hit; end if;
  end loop;
  if exists (select 1 from pipeline.layer3_quality_benchmark_runs x where x.evidence_ids && v_ids)
     or exists (select 1 from pipeline.layer4_override_decisions x where x.evidence_refs && v_ids)
     or exists (select 1 from pipeline.provider_contact_dispositions x where x.evidence_ids && v_ids) then
    raise exception 'an evidence list now refers to these snapshots; nothing removed';
  end if;

  -- 4 list the files, remove the rows, check
  insert into pipeline.evidence_storage_dedupe_log(path, keeper_path, content_hash, bytes, scope, repointed_rows, status)
  select z.path, z.path, z.hash, z.bytes, 'evidence_purge_20261019', 0, 'repointed'
    from (select distinct on (e.storage_path) e.storage_path path, coalesce(e.content_hash, '') hash, (o.metadata->>'size')::bigint bytes
            from pipeline.evidence_artifacts e join storage.objects o on o.bucket_id = 'evidence' and o.name = e.storage_path
           where e.id = any(v_ids) order by e.storage_path) z
  on conflict (path) do nothing;
  get diagnostics v_paths = row_count;
  select count(*) into v_idx_before from pipeline.evidence_link_index_state;
  delete from pipeline.evidence_artifacts e where e.id = any(v_ids);
  get diagnostics v_del = row_count;
  if v_del <> 8531 then raise exception 'removed % snapshots, expected 8531; nothing removed', v_del; end if;
  if (select count(*) from pipeline.evidence_link_index_state) <> v_idx_before - 223 then raise exception 'link index rows not as expected; nothing removed'; end if;
  if v_paths <> 8517 then raise exception 'listed % files, expected 8517; nothing removed', v_paths; end if;

  -- 5 the job is done
  perform cron.unschedule('evidence-purge-prepare');
  update pipeline.component_register set status = 'retired', note = 'Done 19 Oct 2026: 8,531 replaced snapshots removed by paste file (export cf247-evidence-purge-2026-10-19/39208392871)', updated_at = now()
   where kind = 'job' and name = 'evidence-purge-prepare';
  update pipeline.component_register set status = 'retiring', retire_after = current_date + 14, replaced_by = 'nothing',
         note = 'The evidence purge of 19 Oct 2026 is done; kept for its record of checked and kept snapshots', updated_at = now()
   where (kind, name) in (('function', 'security.evidence_purge_prepare_v1'), ('table', 'pipeline.evidence_purge'));
  raise notice 'removed % snapshots and % link-index rows; % files listed for removal', v_del, 223, v_paths;
end $purge$;

-- 6 after the commit: remove the files (the request is sent when this transaction commits)
select net.http_post(url := rtrim(public.coursefinder_runtime_edge_base_url(), '/') || '/evidence-storage-dedupe',
                     headers := jsonb_build_object('content-type', 'application/json', 'x-cf-run-nonce', public.svc_pilot_issue_nonce('evidence-storage-dedupe')::text),
                     body := '{"remove": true, "limit": 100}'::jsonb, timeout_milliseconds := 120000) as file_removal_request;
commit;

-- Then, ON ITS OWN:
-- vacuum (analyze) pipeline.evidence_artifacts;
