-- CF-247 paste file, 20 Oct 2026: D11 second step, drop the 9 retiring tables whose live readers moved off, and the 31 functions that only served them.
-- Platform Admin 21:29: "proceed with task 1"; on the cross-check, choice "Drop the 9, keep the 15 (Recommended)" (the 15 still in use went back
-- to active). Migration 20261020140000 (v2.15.302) moved the readers off first; run this only after it is applied.
-- Project: fxcwkweaxjtknorudmwp (StudySearch). Paste into the Supabase SQL editor and run as one block.
--
-- What it does, in one transaction (all or nothing):
--   1 Checks the export in Storage (bucket "archive", folder cf247-d11-drop-9-2026-10-20/39409708653): every file and the manifest exist with the exported sizes.
--   2 Checks migration 20261020140000 is applied and every table still holds exactly what was exported (count and key hash).
--   3 Drops the 31 functions that only served these tables (nothing calls them: no scheduled job, trigger, admin screen, edge worker or
--     live function; checked 20 Oct 2026).
--   4 Checks nothing names the 9 tables any more (functions, views, policies, foreign keys, scheduled jobs). If something does, it stops.
--   5 Drops the 9 tables (about 13.4 MB, mostly the emptied Layer 2 scale qualification items), marks them retired and logs it.
-- Takes a few seconds. If a worker holds a needed lock it stops after 5 seconds and removes nothing; run it again a minute later.
-- Nothing needs vacuuming afterwards: dropping a table hands its space back at once.
begin;
set local statement_timeout = '2min';
set local lock_timeout = '5s';  -- dropping layer2_provider_trial_results briefly locks the Firecrawl provider table (foreign key); never wait on workers
do $drop$
declare v_n bigint; v_h text; v_refs text; t text; f text;
begin
  -- 1 the export is in Storage
  select string_agg(x.name, ', ') into v_refs
    from (values
      ('cf247-d11-drop-9-2026-10-20/39409708653/pipeline__coverage_identity_results/part-000.jsonl.gz', 108023),
      ('cf247-d11-drop-9-2026-10-20/39409708653/pipeline__layer2_provider_trial_results/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-9-2026-10-20/39409708653/pipeline__layer2_scale_qualification_items/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-9-2026-10-20/39409708653/pipeline__layer2_scale_qualification_runs/part-000.jsonl.gz', 13293),
      ('cf247-d11-drop-9-2026-10-20/39409708653/pipeline__layer2_tuning_events/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-9-2026-10-20/39409708653/pipeline__layer3_quality_benchmark_runs/part-000.jsonl.gz', 134290),
      ('cf247-d11-drop-9-2026-10-20/39409708653/pipeline__pim_source_candidates/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-9-2026-10-20/39409708653/pipeline__scholarship_ai_runs/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-9-2026-10-20/39409708653/pipeline__scholarship_ai_settings/part-000.jsonl.gz', 308),
      ('cf247-d11-drop-9-2026-10-20/39409708653/manifest.json', null)) x(name, bytes)
   where not exists (select 1 from storage.objects o where o.bucket_id = 'archive' and o.name = x.name
                       and (x.bytes is null or (o.metadata->>'size')::bigint = x.bytes));
  if v_refs is not null then raise exception 'export not found in Storage (or a different size): %; nothing removed', v_refs; end if;

  -- 2 the readers are off, and every table is exactly what was exported
  if not exists (select 1 from supabase_migrations.schema_migrations where version = '20261020140000') then raise exception 'migration 20261020140000 (readers moved off) is not applied yet; nothing removed'; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.coverage_identity_results z) z) y;
  if v_n <> 960 or v_h <> '83b5b223523b09a006db62e2324a3368' then raise exception 'pipeline.coverage_identity_results: % rows now, 960 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer2_provider_trial_results z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'pipeline.layer2_provider_trial_results: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer2_scale_qualification_items z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'pipeline.layer2_scale_qualification_items: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer2_scale_qualification_runs z) z) y;
  if v_n <> 95 or v_h <> '2fe39dbb6496f31e1d2a50193f56a1ed' then raise exception 'pipeline.layer2_scale_qualification_runs: % rows now, 95 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer2_tuning_events z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'pipeline.layer2_tuning_events: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer3_quality_benchmark_runs z) z) y;
  if v_n <> 80 or v_h <> '805ed4e126129babf15077288ebbf6b9' then raise exception 'pipeline.layer3_quality_benchmark_runs: % rows now, 80 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.pim_source_candidates z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'pipeline.pim_source_candidates: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.scholarship_ai_runs z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'pipeline.scholarship_ai_runs: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.country_code)::text k from (select z.* from pipeline.scholarship_ai_settings z) z) y;
  if v_n <> 3 or v_h <> '6d846c3795d02b7c5764cb8da647479f' then raise exception 'pipeline.scholarship_ai_settings: % rows now, 3 exported (or different rows); nothing removed', v_n; end if;

  -- 3 the functions that only served these tables, the view, and (no view or outside foreign key to remove)
  foreach f in array array[
    'admin_api.scholarship_ai_run_status(p_run_id uuid)',
    'admin_api.scholarship_ai_settings_write(p_country_code text, p_patch jsonb)',
    'pim_api.manual_pim_candidate_decide(p_candidate_id uuid, p_action text, p_reason text)',
    'pim_api.manual_pim_candidate_register(p_entity_type text, p_target_provider_id uuid, p_source_kind text, p_external_identifier text, p_source_url text, p_evidence_id uuid, p_candidate_payload jsonb, p_reason text)',
    'pim_api.manual_pim_candidates_read(p_status text, p_entity_type text, p_limit integer)',
    'pipeline.layer2_provider_trial_summary(p_trial_id uuid)',
    'public.layer2_ops_policy_update(p_actor uuid, p_profile_id uuid, p_patch jsonb)',
    'public.layer2_scale_cross_layer_handoff(p_run_id uuid)',
    'public.layer2_scale_pattern_reconcile(p_run_id uuid)',
    'public.layer2_scale_qualification_context(p_run_id uuid, p_limit integer)',
    'public.layer2_scale_qualification_prepare(p_run_id uuid)',
    'public.layer2_scale_qualification_provider_finish(p_run_id uuid, p_provider_id uuid, p_evidence_id uuid, p_status text, p_outcome jsonb)',
    'public.layer2_scale_scope_service(p_actor uuid, p_action text, p_country_code text, p_scope_type text, p_scope_id uuid, p_wave_size integer, p_sample_size integer)',
    'public.layer3_cf245_tuition_benchmark_record_service(p_provider_cases jsonb, p_control_cases jsonb, p_returned_models text[], p_external_call_count integer, p_input_tokens integer, p_output_tokens integer, p_estimated_cost_usd numeric, p_max_latency_ms integer, p_evidence_ids uuid[], p_summary text)',
    'public.layer3_cf245_tuition_benchmark_record_service(p_provider_cases jsonb, p_control_cases jsonb, p_returned_models text[], p_external_call_count integer, p_input_tokens integer, p_output_tokens integer, p_estimated_cost_usd numeric, p_max_latency_ms integer, p_evidence_ids uuid[], p_summary text, p_binding_hash text)',
    'public.layer3_cf245_tuition_benchmark_record_service(p_provider_cases jsonb, p_control_cases jsonb, p_returned_models text[], p_external_call_count integer, p_input_tokens integer, p_output_tokens integer, p_estimated_cost_usd numeric, p_max_latency_ms integer, p_evidence_ids uuid[], p_summary text, p_binding_hash text, p_profile_id uuid)',
    'public.layer3_contact_benchmark_record_service(p_pass boolean, p_provider_cases jsonb, p_control_cases jsonb, p_returned_models text[], p_external_call_count integer, p_input_tokens integer, p_output_tokens integer, p_estimated_cost_usd numeric, p_max_latency_ms integer, p_evidence_ids uuid[], p_summary text)',
    'public.layer3_holdout_finalise_service(p_run_label text, p_binding_hash text, p_summary jsonb)',
    'public.layer3_source_pattern_benchmark_record_service(p_pass boolean, p_provider_cases jsonb, p_control_cases jsonb, p_returned_models text[], p_external_call_count integer, p_input_tokens integer, p_output_tokens integer, p_estimated_cost_usd numeric, p_max_latency_ms integer, p_evidence_ids uuid[], p_summary text)',
    'public.layer3_usage_window_service(p_profile_id uuid)',
    'public.scholarship_ai_budget_service(p_country_code text)',
    'security.admin_layer3_operations_read_v1(p_args jsonb)',
    'security.layer2_qualification_root(p_run_id uuid)',
    'security.layer3_operational_alerts_read()',
    'public.admin_layer3_operations(p_args jsonb)',
    'public.layer3_dispatch_headroom_service(p_task_class text)',
    'public.manual_pim_candidate_decide(p_candidate_id uuid, p_action text, p_reason text)',
    'public.manual_pim_candidate_register(p_entity_type text, p_target_provider_id uuid, p_source_kind text, p_external_identifier text, p_source_url text, p_evidence_id uuid, p_candidate_payload jsonb, p_reason text)',
    'public.manual_pim_candidates_read(p_status text, p_entity_type text, p_limit integer)',
    'public.scholarship_ai_run_status(p_run_id uuid)',
    'public.scholarship_ai_settings_write(p_country_code text, p_patch jsonb)'] loop
    execute format('drop function %s', f);
  end loop;
  -- 4 nothing names the 9 tables any more
  foreach t in array array['pipeline.coverage_identity_results', 'pipeline.layer2_provider_trial_results', 'pipeline.layer2_scale_qualification_items', 'pipeline.layer2_scale_qualification_runs', 'pipeline.layer2_tuning_events', 'pipeline.layer3_quality_benchmark_runs', 'pipeline.pim_source_candidates', 'pipeline.scholarship_ai_runs', 'pipeline.scholarship_ai_settings'] loop
    select string_agg(n.nspname || '.' || p.proname, ', ') into v_refs
      from pg_proc p join pg_namespace n on n.oid = p.pronamespace
     where n.nspname not in ('pg_catalog', 'information_schema') and regexp_replace(p.prosrc, '--[^\n]*', '', 'g') ~* ('\m' || split_part(t, '.', 2) || '\M');  -- comments do not count
    if v_refs is not null then raise exception '% is still named by %; nothing removed', t, v_refs; end if;
    select string_agg(c.oid::regclass::text, ', ') into v_refs from pg_class c
     where c.relkind in ('v', 'm') and pg_get_viewdef(c.oid) ~* ('\m' || split_part(t, '.', 2) || '\M');
    if v_refs is not null then raise exception '% is used by view %; nothing removed', t, v_refs; end if;
    select string_agg(schemaname || '.' || tablename, ', ') into v_refs from pg_policies
     where (coalesce(qual, '') || coalesce(with_check, '')) ~* ('\m' || split_part(t, '.', 2) || '\M') and (schemaname || '.' || tablename) <> all (array['pipeline.coverage_identity_results', 'pipeline.layer2_provider_trial_results', 'pipeline.layer2_scale_qualification_items', 'pipeline.layer2_scale_qualification_runs', 'pipeline.layer2_tuning_events', 'pipeline.layer3_quality_benchmark_runs', 'pipeline.pim_source_candidates', 'pipeline.scholarship_ai_runs', 'pipeline.scholarship_ai_settings']);
    if v_refs is not null then raise exception '% is named by a policy on %; nothing removed', t, v_refs; end if;
    select string_agg(conrelid::regclass::text, ', ') into v_refs from pg_constraint
     where contype = 'f' and confrelid = t::regclass and conrelid::regclass::text <> all (array['pipeline.coverage_identity_results', 'pipeline.layer2_provider_trial_results', 'pipeline.layer2_scale_qualification_items', 'pipeline.layer2_scale_qualification_runs', 'pipeline.layer2_tuning_events', 'pipeline.layer3_quality_benchmark_runs', 'pipeline.pim_source_candidates', 'pipeline.scholarship_ai_runs', 'pipeline.scholarship_ai_settings']);
    if v_refs is not null then raise exception '% is referenced by %; nothing removed', t, v_refs; end if;
    if exists (select 1 from cron.job where command ~* ('\m' || split_part(t, '.', 2) || '\M')) then raise exception 'a scheduled job names %; nothing removed', t; end if;
  end loop;

  -- 5 drop the 9 tables (foreign keys between them go with them)
  foreach t in array array['pipeline.coverage_identity_results', 'pipeline.layer2_provider_trial_results', 'pipeline.layer2_scale_qualification_items', 'pipeline.layer2_scale_qualification_runs', 'pipeline.layer2_tuning_events', 'pipeline.layer3_quality_benchmark_runs', 'pipeline.pim_source_candidates', 'pipeline.scholarship_ai_runs', 'pipeline.scholarship_ai_settings'] loop
    execute format('drop table %s cascade', t);
  end loop;
  if exists (select 1 from pg_class c join pg_namespace n on n.oid = c.relnamespace where (n.nspname || '.' || c.relname) = any (array['pipeline.coverage_identity_results', 'pipeline.layer2_provider_trial_results', 'pipeline.layer2_scale_qualification_items', 'pipeline.layer2_scale_qualification_runs', 'pipeline.layer2_tuning_events', 'pipeline.layer3_quality_benchmark_runs', 'pipeline.pim_source_candidates', 'pipeline.scholarship_ai_runs', 'pipeline.scholarship_ai_settings'])) then
    raise exception 'a table is still there; nothing removed';
  end if;

  update pipeline.component_register set status = 'retired', updated_at = now(),
         note = coalesce(note || '; ', '') || 'dropped 20 Oct 2026 by paste file (D11 second step; rows in Storage: archive/cf247-d11-drop-9-2026-10-20/39409708653)'
   where kind = 'table' and name = any (array['pipeline.coverage_identity_results', 'pipeline.layer2_provider_trial_results', 'pipeline.layer2_scale_qualification_items', 'pipeline.layer2_scale_qualification_runs', 'pipeline.layer2_tuning_events', 'pipeline.layer3_quality_benchmark_runs', 'pipeline.pim_source_candidates', 'pipeline.scholarship_ai_runs', 'pipeline.scholarship_ai_settings']);
  insert into pipeline.admin_control_events(area, action, target, detail, actor) values
   ('retention', 'drop', '9 retiring tables (D11 second step)',
    jsonb_build_object('decision', 'Platform Admin 20 Oct 2026: "Drop the 9, keep the 15 (Recommended)"', 'export', 'archive/cf247-d11-drop-9-2026-10-20/39409708653',
                       'tables_dropped', to_jsonb(array['pipeline.coverage_identity_results', 'pipeline.layer2_provider_trial_results', 'pipeline.layer2_scale_qualification_items', 'pipeline.layer2_scale_qualification_runs', 'pipeline.layer2_tuning_events', 'pipeline.layer3_quality_benchmark_runs', 'pipeline.pim_source_candidates', 'pipeline.scholarship_ai_runs', 'pipeline.scholarship_ai_settings']), 'functions_dropped', 31), null);
end $drop$;
commit;

-- Check afterwards (optional):
-- select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname || '.' || c.relname in ('pipeline.layer2_scale_qualification_items', 'pipeline.scholarship_ai_runs', 'pipeline.pim_source_candidates');   -- 0
-- select pg_size_pretty(pg_database_size(current_database()));
