-- CF-247 paste file, 20 Oct 2026: D11, drop the 33 retiring tables that nothing live uses, and the 61 functions that only served them.
-- Platform Admin 20:54: "Why do we need to wait for 3 Nov ... cross check all references. List all the tables and their sizes that can be
-- retired"; choice "Drop 34 now, fix 23 (Recommended)" (the 14-day wait is waived for these). pipeline.layer2_tuning_events moved to the
-- tables fixed first: the shared admin read still names it.
-- Project: fxcwkweaxjtknorudmwp (StudySearch). Paste into the Supabase SQL editor and run as one block.
--
-- What it does, in one transaction (all or nothing):
--   1 Checks the export in Storage (bucket "archive", folder cf247-d11-drop-34-2026-10-20/39405000377): every file and the manifest exist with the exported sizes.
--   2 Checks every table still holds exactly what was exported (row count and a hash of the row keys). If anything changed, it stops.
--   3 Drops the 61 functions that only served these tables (nothing calls them: no scheduled job, trigger, admin screen, edge worker or
--     live function; checked 20 Oct 2026), the view pipeline.scholarship_provider_stats, and the three foreign keys that point at the
--     Layer 2 trial tables from tables that stay.
--   4 Checks nothing names the 33 tables any more (functions, views, policies, foreign keys, scheduled jobs). If something does, it stops.
--   5 Drops the 33 tables (about 49.5 MB), marks them retired in the component register and records it in the admin events.
-- Nothing needs vacuuming afterwards: dropping a table hands its space back at once.
begin;
set local statement_timeout = '5min';
do $drop$
declare v_n bigint; v_h text; v_refs text; t text; f text;
begin
  -- 1 the export is in Storage
  select string_agg(x.name, ', ') into v_refs
    from (values
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__ca_source_qualifications/part-000.jsonl.gz', 3592),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__coverage_identity_cases/part-000.jsonl.gz', 67335),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__coverage_identity_sets/part-000.jsonl.gz', 171),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__directory_institutions/part-000.jsonl.gz', 18221),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__directory_pages/part-000.jsonl.gz', 550238),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__evidence_purge/part-000.jsonl.gz', 2324251),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__evidence_purge/part-001.jsonl.gz', 2326986),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__evidence_purge/part-002.jsonl.gz', 2326796),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__evidence_purge/part-003.jsonl.gz', 1233490),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__layer2_auto_discovery_attempts/part-000.jsonl.gz', 21143),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__layer2_auto_discovery_settings/part-000.jsonl.gz', 168),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__layer2_auto_discovery_settings_audit/part-000.jsonl.gz', 365),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__layer2_completeness_trial_courses/part-000.jsonl.gz', 4026),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__layer2_completeness_trials/part-000.jsonl.gz', 1208),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__layer3_benchmark_jobs/part-000.jsonl.gz', 388),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__layer3_intake_benchmark_cases/part-000.jsonl.gz', 19558),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__layer3_intake_benchmark_results/part-000.jsonl.gz', 32590),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__layer3_intake_gold_sets/part-000.jsonl.gz', 316),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__layer3_profile_activation_events/part-000.jsonl.gz', 5158),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__layer3_task_contract_freezes/part-000.jsonl.gz', 1811),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__onboarding_cases/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__onboarding_lifecycle_events/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__orphan_files/part-000.jsonl.gz', 1491949),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__orphan_files/part-001.jsonl.gz', 638191),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__provider_asset_candidates/part-000.jsonl.gz', 73546),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__provider_directory_observations/part-000.jsonl.gz', 2667),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__scholarship_ai_run_items/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__scholarship_catalogue_runs/part-000.jsonl.gz', 3079),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__scholarship_coverage_benchmarks/part-000.jsonl.gz', 557),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__scholarship_maintenance_runs/part-000.jsonl.gz', 718),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__scholarship_runtime_settings/part-000.jsonl.gz', 300),
      ('cf247-d11-drop-34-2026-10-20/39405000377/pipeline__scholarship_scope_acquisition_requests/part-000.jsonl.gz', 2559),
      ('cf247-d11-drop-34-2026-10-20/39405000377/workflow__import_errors/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-34-2026-10-20/39405000377/workflow__import_rows/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-34-2026-10-20/39405000377/workflow__migration_entity_map/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-34-2026-10-20/39405000377/workflow__migration_runs/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-34-2026-10-20/39405000377/workflow__reconciliation_checks/part-000.jsonl.gz', 20),
      ('cf247-d11-drop-34-2026-10-20/39405000377/manifest.json', null)) x(name, bytes)
   where not exists (select 1 from storage.objects o where o.bucket_id = 'archive' and o.name = x.name
                       and (x.bytes is null or (o.metadata->>'size')::bigint = x.bytes));
  if v_refs is not null then raise exception 'export not found in Storage (or a different size): %; nothing removed', v_refs; end if;

  -- 2 every table is exactly what was exported
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.source_id)::text k from (select z.* from pipeline.ca_source_qualifications z) z) y;
  if v_n <> 9 or v_h <> '5752789151a71edb336e5caee5f3644e' then raise exception 'pipeline.ca_source_qualifications: % rows now, 9 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select md5(to_jsonb(z)::text) k from (select z.* from pipeline.coverage_identity_cases z) z) y;
  if v_n <> 480 or v_h <> '5d836aa279e2bd933667663db2bd3179' then raise exception 'pipeline.coverage_identity_cases: % rows now, 480 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.gold_set)::text k from (select z.* from pipeline.coverage_identity_sets z) z) y;
  if v_n <> 2 or v_h <> '39145d8e2a50a02c3820d0ea8793d4f6' then raise exception 'pipeline.coverage_identity_sets: % rows now, 2 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select md5(to_jsonb(z)::text) k from (select z.* from pipeline.directory_institutions z) z) y;
  if v_n <> 414 or v_h <> '7dcbf4a1981e4fa8bb6f4e609aea3bc1' then raise exception 'pipeline.directory_institutions: % rows now, 414 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.directory_pages z) z) y;
  if v_n <> 244 or v_h <> 'e1bdbed1785234e81ac75f518d0974a1' then raise exception 'pipeline.directory_pages: % rows now, 244 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.evidence_id)::text k from (select z.* from pipeline.evidence_purge z) z) y;
  if v_n <> 70611 or v_h <> 'fc77b9d0e7d486e6c36e2422840504eb' then raise exception 'pipeline.evidence_purge: % rows now, 70611 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer2_auto_discovery_attempts z) z) y;
  if v_n <> 195 or v_h <> '23657eee977dfcd8410688cbb9262808' then raise exception 'pipeline.layer2_auto_discovery_attempts: % rows now, 195 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer2_auto_discovery_settings z) z) y;
  if v_n <> 1 or v_h <> 'c4ca4238a0b923820dcc509a6f75849b' then raise exception 'pipeline.layer2_auto_discovery_settings: % rows now, 1 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer2_auto_discovery_settings_audit z) z) y;
  if v_n <> 1 or v_h <> '3147ef4f7fe785a5a6ea891f83166581' then raise exception 'pipeline.layer2_auto_discovery_settings_audit: % rows now, 1 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer2_completeness_trial_courses z) z) y;
  if v_n <> 50 or v_h <> 'e0e350b7e97ee378264acccd6107915f' then raise exception 'pipeline.layer2_completeness_trial_courses: % rows now, 50 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer2_completeness_trials z) z) y;
  if v_n <> 6 or v_h <> 'dad68add449c26d0a49ead494d33b50c' then raise exception 'pipeline.layer2_completeness_trials: % rows now, 6 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer3_benchmark_jobs z) z) y;
  if v_n <> 2 or v_h <> '337f6d190f4ca731f4e8bd36c3e97305' then raise exception 'pipeline.layer3_benchmark_jobs: % rows now, 2 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer3_intake_benchmark_cases z) z) y;
  if v_n <> 89 or v_h <> '3f7a3c0d104702d03a1e8e1c4916a029' then raise exception 'pipeline.layer3_intake_benchmark_cases: % rows now, 89 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer3_intake_benchmark_results z) z) y;
  if v_n <> 178 or v_h <> 'e17da919225112c62261ab77d40e2cc9' then raise exception 'pipeline.layer3_intake_benchmark_results: % rows now, 178 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.gold_set)::text k from (select z.* from pipeline.layer3_intake_gold_sets z) z) y;
  if v_n <> 2 or v_h <> '6214bbe7e495fd46f526aa3091b3ea2e' then raise exception 'pipeline.layer3_intake_gold_sets: % rows now, 2 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer3_profile_activation_events z) z) y;
  if v_n <> 39 or v_h <> 'e132e7ffd50f62bf9fe038c4baec411e' then raise exception 'pipeline.layer3_profile_activation_events: % rows now, 39 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.layer3_task_contract_freezes z) z) y;
  if v_n <> 3 or v_h <> '3d8c2dc3f3e6d856eaadffb648755832' then raise exception 'pipeline.layer3_task_contract_freezes: % rows now, 3 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.onboarding_cases z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'pipeline.onboarding_cases: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.onboarding_lifecycle_events z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'pipeline.onboarding_lifecycle_events: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.name)::text k from (select z.* from pipeline.orphan_files z) z) y;
  if v_n <> 28938 or v_h <> '85cbfb14cbfe02180aa46180d9d6b56b' then raise exception 'pipeline.orphan_files: % rows now, 28938 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.provider_asset_candidates z) z) y;
  if v_n <> 582 or v_h <> '1eda74a85a261165b314bf86f45730e8' then raise exception 'pipeline.provider_asset_candidates: % rows now, 582 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.provider_directory_observations z) z) y;
  if v_n <> 24 or v_h <> 'f77ffec042aeb8ce01297875415656f9' then raise exception 'pipeline.provider_directory_observations: % rows now, 24 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.scholarship_ai_run_items z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'pipeline.scholarship_ai_run_items: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.scholarship_catalogue_runs z) z) y;
  if v_n <> 16 or v_h <> '079db1eb68a96880934b524d381615f5' then raise exception 'pipeline.scholarship_catalogue_runs: % rows now, 16 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.scholarship_coverage_benchmarks z) z) y;
  if v_n <> 4 or v_h <> '99c9f5157c92492cc9f5a6b9c2bc1a4a' then raise exception 'pipeline.scholarship_coverage_benchmarks: % rows now, 4 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.scholarship_maintenance_runs z) z) y;
  if v_n <> 9 or v_h <> 'f80c6efa3c482bc1f236c36e62781ea4' then raise exception 'pipeline.scholarship_maintenance_runs: % rows now, 9 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.country_code)::text k from (select z.* from pipeline.scholarship_runtime_settings z) z) y;
  if v_n <> 3 or v_h <> '6d846c3795d02b7c5764cb8da647479f' then raise exception 'pipeline.scholarship_runtime_settings: % rows now, 3 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from pipeline.scholarship_scope_acquisition_requests z) z) y;
  if v_n <> 27 or v_h <> '215a927b8bdd7bc977b6f9aa4f3a76fe' then raise exception 'pipeline.scholarship_scope_acquisition_requests: % rows now, 27 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from workflow.import_errors z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'workflow.import_errors: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from workflow.import_rows z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'workflow.import_rows: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from workflow.migration_entity_map z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'workflow.migration_entity_map: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from workflow.migration_runs z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'workflow.migration_runs: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;
  select count(*), md5(coalesce(string_agg(k, ',' order by k collate "C"), '')) into v_n, v_h from (select (z.id)::text k from (select z.* from workflow.reconciliation_checks z) z) y;
  if v_n <> 0 or v_h <> 'd41d8cd98f00b204e9800998ecf8427e' then raise exception 'workflow.reconciliation_checks: % rows now, 0 exported (or different rows); nothing removed', v_n; end if;

  -- 3 the functions that only served these tables, the view, and the three foreign keys into a dropped table
  foreach f in array array[
    'admin_api.scholarship_runtime_settings_write(p_patch jsonb)',
    'pipeline.layer3_intake_gold_digest(p_gold_set text)',
    'public.layer2_auto_discovery_settings_read_v1()',
    'public.layer2_auto_discovery_settings_save_v1(p_enabled boolean, p_daily_provider_cap integer, p_providers_in_flight integer, p_candidates_per_provider integer, p_reason text)',
    'public.layer2_completeness_trial_create(p_country_code text, p_provider_id uuid, p_batch_size integer)',
    'public.layer2_completeness_trial_finalize(p_trial_id uuid)',
    'public.layer2_hotcourses_directory_apply(p_evidence_id uuid, p_rows jsonb)',
    'public.layer2_provider_asset_promotion_context(p_candidate_id uuid)',
    'public.layer2_provider_onboarding_queue_v1(p_country text, p_limit integer)',
    'public.layer2_provider_trial_record(p_trial_course_id uuid, p_acquisition_provider_id uuid, p_domain_key text, p_provider_attempt_id uuid, p_acquisition_success boolean, p_gatekeeping_bypassed boolean, p_javascript_rendered boolean, p_evidence_quality_score numeric, p_deterministic_extraction_success boolean, p_correctness_status text, p_latency_ms integer, p_request_count integer, p_vendor_cost_usd numeric, p_fields_targeted integer, p_fields_resolved integer, p_layer3_required boolean, p_layer4_required boolean, p_blocker text, p_metrics jsonb)',
    'public.layer2_record_course_trial_result(p_course_id uuid, p_attempt_id uuid, p_fields_targeted integer, p_fields_resolved integer, p_correctness_status text, p_layer3_required boolean, p_blocker text, p_metrics jsonb)',
    'public.layer2_scholarship_catalogue_apply(p_evidence_id uuid, p_links jsonb, p_status text, p_metadata jsonb)',
    'public.layer3_contract_freeze_record_service(p_task_class text, p_version text, p_fingerprint text, p_components jsonb)',
    'public.layer3_fail_interpretation_service(p_interpretation_id uuid, p_error text, p_external_call_count integer, p_call_latency_ms integer)',
    'public.layer3_intake_benchmark_cases_service(p_gold_set text)',
    'public.layer3_intake_benchmark_finalise_service(p_run_label text, p_summary jsonb, p_binding_hash text)',
    'public.layer3_intake_benchmark_profile_service(p_code text)',
    'public.layer3_intake_benchmark_result_record_service(p_run_label text, p_case_id uuid, p_result jsonb)',
    'public.scholarship_ai_item_finish_service(p_item_id uuid, p_status text, p_result_status text, p_interpretation_id uuid, p_error_text text, p_api_calls integer, p_input_tokens integer, p_output_tokens integer, p_cost_usd numeric, p_metadata jsonb)',
    'public.scholarship_ai_item_finish_service(p_item_id uuid, p_status text, p_result_status text, p_interpretation_id uuid, p_error_text text, p_api_calls integer, p_input_tokens integer, p_output_tokens integer, p_cost_usd numeric, p_metadata jsonb, p_result_payload jsonb)',
    'public.scholarship_ai_next_item_service(p_run_id uuid)',
    'public.scholarship_operations_read()',
    'public.scholarship_scope_job_mark(p_job_id uuid, p_status text, p_result jsonb, p_error text, p_execution jsonb)',
    'public.svc_coverage_identity_cases(p_gold_set text, p_offset integer, p_limit integer)',
    'public.svc_coverage_identity_result(p_run_label text, p_gold_set text, p_case_no integer, p_model text, p_returned text, p_answer jsonb, p_checks jsonb, p_accepted boolean, p_cost numeric)',
    'public.svc_directory_anchor_hints(p_site text, p_country text, p_page_id bigint, p_page_url text, p_anchors jsonb)',
    'public.svc_directory_page_record(p_site text, p_country text, p_url text, p_final_url text, p_http integer, p_storage_path text, p_sha256 text, p_title text, p_links jsonb, p_text text)',
    'public.svc_layer1_reset_au_uat()',
    'public.svc_layer1_reset_database()',
    'public.svc_layer2_trial_course_update(p_trial_course_id uuid, p_status text, p_post_factual jsonb, p_post_context jsonb)',
    'public.svc_layer2_trial_detail(p_trial_id uuid)',
    'public.svc_layer2_trial_list()',
    'security.directory_match_v1(p_site text)',
    'security.evidence_purge_prepare_v1(p_batch integer)',
    'security.layer3_benchmark_claim_impl(p_token_hash text)',
    'security.layer3_benchmark_claim_job_impl(p_job_id uuid)',
    'security.layer3_benchmark_record_impl(p_job_id uuid, p_profile_id uuid, p_actor uuid, p_pass boolean, p_provider_cases jsonb, p_control_cases jsonb, p_configured_model text, p_returned_models text[], p_external_call_count integer, p_input_tokens integer, p_output_tokens integer, p_estimated_cost_usd numeric, p_max_latency_ms integer, p_evidence_ids uuid[], p_summary text)',
    'security.layer3_profile_activate_impl(p_profile_id uuid, p_reason text)',
    'security.layer3_profile_pause_impl(p_profile_id uuid, p_reason text)',
    'security.onboarding_case_context_impl(p_case_id uuid)',
    'security.onboarding_case_create_impl(p_case_type text, p_country_code text, p_title text, p_source_id uuid, p_source_profile_id uuid, p_provider_id uuid, p_course_id uuid, p_adapter_family text, p_reason text, p_change_control_ref text, p_uat_ref text)',
    'security.onboarding_case_metadata_update_impl(p_case_id uuid, p_adapter_family text, p_source_qualification jsonb, p_adapter_assessment jsonb, p_schema_assessment jsonb, p_operational_manifest jsonb, p_reason text, p_uat_ref text)',
    'security.onboarding_case_transition_impl(p_case_id uuid, p_to_stage text, p_outcome text, p_reason text, p_details jsonb, p_evidence_id uuid, p_uat_ref text)',
    'security.onboarding_cases_list_impl(p_stage text, p_outcome text, p_country_code text, p_case_type text, p_limit integer)',
    'security.scholarship_ai_run_create_impl(p_country_code text, p_task_class text, p_profile_id uuid, p_limit integer, p_trigger_mode text, p_changes_only boolean)',
    'security.scholarship_ai_scheduler_tick_impl(p_now timestamp with time zone)',
    'security.scholarship_maintenance_tick_impl(p_now timestamp with time zone)',
    'public.layer3_benchmark_claim_job_service(p_job_id uuid)',
    'public.layer3_benchmark_claim_service(p_token_hash text)',
    'public.layer3_benchmark_record_service(p_job_id uuid, p_profile_id uuid, p_actor uuid, p_pass boolean, p_provider_cases jsonb, p_control_cases jsonb, p_configured_model text, p_returned_models text[], p_external_call_count integer, p_input_tokens integer, p_output_tokens integer, p_estimated_cost_usd numeric, p_max_latency_ms integer, p_evidence_ids uuid[], p_summary text)',
    'public.layer3_profile_activate(p_profile_id uuid, p_reason text)',
    'public.layer3_profile_pause(p_profile_id uuid, p_reason text)',
    'public.scholarship_ai_run_create(p_country_code text, p_task_class text, p_profile_id uuid, p_limit integer, p_trigger_mode text, p_changes_only boolean)',
    'security.onboarding_case_context_browser_bridge(p_case_id uuid)',
    'security.onboarding_case_create_browser_bridge(p_case_type text, p_country_code text, p_title text, p_source_id uuid, p_source_profile_id uuid, p_provider_id uuid, p_course_id uuid, p_adapter_family text, p_reason text, p_change_control_ref text, p_uat_ref text)',
    'security.onboarding_case_metadata_update_browser_bridge(p_case_id uuid, p_adapter_family text, p_source_qualification jsonb, p_adapter_assessment jsonb, p_schema_assessment jsonb, p_operational_manifest jsonb, p_reason text, p_uat_ref text)',
    'security.onboarding_case_transition_browser_bridge(p_case_id uuid, p_to_stage text, p_outcome text, p_reason text, p_details jsonb, p_evidence_id uuid, p_uat_ref text)',
    'security.onboarding_cases_list_browser_bridge(p_stage text, p_outcome text, p_country_code text, p_case_type text, p_limit integer)',
    'public.onboarding_case_metadata_update(p_case_id uuid, p_adapter_family text, p_source_qualification jsonb, p_adapter_assessment jsonb, p_schema_assessment jsonb, p_operational_manifest jsonb, p_reason text, p_uat_ref text)',
    'security.layer3_model_profile_set_state_impl(p_profile_id uuid, p_enabled boolean, p_paused boolean, p_reason text)',
    'public.layer3_model_profile_set_state(p_profile_id uuid, p_enabled boolean, p_paused boolean, p_reason text)'] loop
    execute format('drop function %s', f);
  end loop;
  drop view pipeline.scholarship_provider_stats;
  alter table pipeline.layer2_course_discovery_candidates drop constraint layer2_course_discovery_candidates_trial_course_id_fkey;
  alter table pipeline.layer2_provider_trial_results drop constraint layer2_provider_trial_results_trial_course_id_fkey;
  alter table pipeline.layer2_provider_trial_results drop constraint layer2_provider_trial_results_trial_id_fkey;

  -- 4 nothing names the 33 tables any more
  foreach t in array array['pipeline.ca_source_qualifications', 'pipeline.coverage_identity_cases', 'pipeline.coverage_identity_sets', 'pipeline.directory_institutions', 'pipeline.directory_pages', 'pipeline.evidence_purge', 'pipeline.layer2_auto_discovery_attempts', 'pipeline.layer2_auto_discovery_settings', 'pipeline.layer2_auto_discovery_settings_audit', 'pipeline.layer2_completeness_trial_courses', 'pipeline.layer2_completeness_trials', 'pipeline.layer3_benchmark_jobs', 'pipeline.layer3_intake_benchmark_cases', 'pipeline.layer3_intake_benchmark_results', 'pipeline.layer3_intake_gold_sets', 'pipeline.layer3_profile_activation_events', 'pipeline.layer3_task_contract_freezes', 'pipeline.onboarding_cases', 'pipeline.onboarding_lifecycle_events', 'pipeline.orphan_files', 'pipeline.provider_asset_candidates', 'pipeline.provider_directory_observations', 'pipeline.scholarship_ai_run_items', 'pipeline.scholarship_catalogue_runs', 'pipeline.scholarship_coverage_benchmarks', 'pipeline.scholarship_maintenance_runs', 'pipeline.scholarship_runtime_settings', 'pipeline.scholarship_scope_acquisition_requests', 'workflow.import_errors', 'workflow.import_rows', 'workflow.migration_entity_map', 'workflow.migration_runs', 'workflow.reconciliation_checks'] loop
    select string_agg(n.nspname || '.' || p.proname, ', ') into v_refs
      from pg_proc p join pg_namespace n on n.oid = p.pronamespace
     where n.nspname not in ('pg_catalog', 'information_schema') and regexp_replace(p.prosrc, '--[^\n]*', '', 'g') ~* ('\m' || split_part(t, '.', 2) || '\M');  -- comments do not count
    if v_refs is not null then raise exception '% is still named by %; nothing removed', t, v_refs; end if;
    select string_agg(c.oid::regclass::text, ', ') into v_refs from pg_class c
     where c.relkind in ('v', 'm') and pg_get_viewdef(c.oid) ~* ('\m' || split_part(t, '.', 2) || '\M');
    if v_refs is not null then raise exception '% is used by view %; nothing removed', t, v_refs; end if;
    select string_agg(schemaname || '.' || tablename, ', ') into v_refs from pg_policies
     where (coalesce(qual, '') || coalesce(with_check, '')) ~* ('\m' || split_part(t, '.', 2) || '\M') and (schemaname || '.' || tablename) <> all (array['pipeline.ca_source_qualifications', 'pipeline.coverage_identity_cases', 'pipeline.coverage_identity_sets', 'pipeline.directory_institutions', 'pipeline.directory_pages', 'pipeline.evidence_purge', 'pipeline.layer2_auto_discovery_attempts', 'pipeline.layer2_auto_discovery_settings', 'pipeline.layer2_auto_discovery_settings_audit', 'pipeline.layer2_completeness_trial_courses', 'pipeline.layer2_completeness_trials', 'pipeline.layer3_benchmark_jobs', 'pipeline.layer3_intake_benchmark_cases', 'pipeline.layer3_intake_benchmark_results', 'pipeline.layer3_intake_gold_sets', 'pipeline.layer3_profile_activation_events', 'pipeline.layer3_task_contract_freezes', 'pipeline.onboarding_cases', 'pipeline.onboarding_lifecycle_events', 'pipeline.orphan_files', 'pipeline.provider_asset_candidates', 'pipeline.provider_directory_observations', 'pipeline.scholarship_ai_run_items', 'pipeline.scholarship_catalogue_runs', 'pipeline.scholarship_coverage_benchmarks', 'pipeline.scholarship_maintenance_runs', 'pipeline.scholarship_runtime_settings', 'pipeline.scholarship_scope_acquisition_requests', 'workflow.import_errors', 'workflow.import_rows', 'workflow.migration_entity_map', 'workflow.migration_runs', 'workflow.reconciliation_checks']);
    if v_refs is not null then raise exception '% is named by a policy on %; nothing removed', t, v_refs; end if;
    select string_agg(conrelid::regclass::text, ', ') into v_refs from pg_constraint
     where contype = 'f' and confrelid = t::regclass and conrelid::regclass::text <> all (array['pipeline.ca_source_qualifications', 'pipeline.coverage_identity_cases', 'pipeline.coverage_identity_sets', 'pipeline.directory_institutions', 'pipeline.directory_pages', 'pipeline.evidence_purge', 'pipeline.layer2_auto_discovery_attempts', 'pipeline.layer2_auto_discovery_settings', 'pipeline.layer2_auto_discovery_settings_audit', 'pipeline.layer2_completeness_trial_courses', 'pipeline.layer2_completeness_trials', 'pipeline.layer3_benchmark_jobs', 'pipeline.layer3_intake_benchmark_cases', 'pipeline.layer3_intake_benchmark_results', 'pipeline.layer3_intake_gold_sets', 'pipeline.layer3_profile_activation_events', 'pipeline.layer3_task_contract_freezes', 'pipeline.onboarding_cases', 'pipeline.onboarding_lifecycle_events', 'pipeline.orphan_files', 'pipeline.provider_asset_candidates', 'pipeline.provider_directory_observations', 'pipeline.scholarship_ai_run_items', 'pipeline.scholarship_catalogue_runs', 'pipeline.scholarship_coverage_benchmarks', 'pipeline.scholarship_maintenance_runs', 'pipeline.scholarship_runtime_settings', 'pipeline.scholarship_scope_acquisition_requests', 'workflow.import_errors', 'workflow.import_rows', 'workflow.migration_entity_map', 'workflow.migration_runs', 'workflow.reconciliation_checks']);
    if v_refs is not null then raise exception '% is referenced by %; nothing removed', t, v_refs; end if;
    if exists (select 1 from cron.job where command ~* ('\m' || split_part(t, '.', 2) || '\M')) then raise exception 'a scheduled job names %; nothing removed', t; end if;
  end loop;

  -- 5 drop the 33 tables (foreign keys between them go with them)
  foreach t in array array['pipeline.ca_source_qualifications', 'pipeline.coverage_identity_cases', 'pipeline.coverage_identity_sets', 'pipeline.directory_institutions', 'pipeline.directory_pages', 'pipeline.evidence_purge', 'pipeline.layer2_auto_discovery_attempts', 'pipeline.layer2_auto_discovery_settings', 'pipeline.layer2_auto_discovery_settings_audit', 'pipeline.layer2_completeness_trial_courses', 'pipeline.layer2_completeness_trials', 'pipeline.layer3_benchmark_jobs', 'pipeline.layer3_intake_benchmark_cases', 'pipeline.layer3_intake_benchmark_results', 'pipeline.layer3_intake_gold_sets', 'pipeline.layer3_profile_activation_events', 'pipeline.layer3_task_contract_freezes', 'pipeline.onboarding_cases', 'pipeline.onboarding_lifecycle_events', 'pipeline.orphan_files', 'pipeline.provider_asset_candidates', 'pipeline.provider_directory_observations', 'pipeline.scholarship_ai_run_items', 'pipeline.scholarship_catalogue_runs', 'pipeline.scholarship_coverage_benchmarks', 'pipeline.scholarship_maintenance_runs', 'pipeline.scholarship_runtime_settings', 'pipeline.scholarship_scope_acquisition_requests', 'workflow.import_errors', 'workflow.import_rows', 'workflow.migration_entity_map', 'workflow.migration_runs', 'workflow.reconciliation_checks'] loop
    execute format('drop table %s cascade', t);
  end loop;
  if exists (select 1 from pg_class c join pg_namespace n on n.oid = c.relnamespace where (n.nspname || '.' || c.relname) = any (array['pipeline.ca_source_qualifications', 'pipeline.coverage_identity_cases', 'pipeline.coverage_identity_sets', 'pipeline.directory_institutions', 'pipeline.directory_pages', 'pipeline.evidence_purge', 'pipeline.layer2_auto_discovery_attempts', 'pipeline.layer2_auto_discovery_settings', 'pipeline.layer2_auto_discovery_settings_audit', 'pipeline.layer2_completeness_trial_courses', 'pipeline.layer2_completeness_trials', 'pipeline.layer3_benchmark_jobs', 'pipeline.layer3_intake_benchmark_cases', 'pipeline.layer3_intake_benchmark_results', 'pipeline.layer3_intake_gold_sets', 'pipeline.layer3_profile_activation_events', 'pipeline.layer3_task_contract_freezes', 'pipeline.onboarding_cases', 'pipeline.onboarding_lifecycle_events', 'pipeline.orphan_files', 'pipeline.provider_asset_candidates', 'pipeline.provider_directory_observations', 'pipeline.scholarship_ai_run_items', 'pipeline.scholarship_catalogue_runs', 'pipeline.scholarship_coverage_benchmarks', 'pipeline.scholarship_maintenance_runs', 'pipeline.scholarship_runtime_settings', 'pipeline.scholarship_scope_acquisition_requests', 'workflow.import_errors', 'workflow.import_rows', 'workflow.migration_entity_map', 'workflow.migration_runs', 'workflow.reconciliation_checks'])) then
    raise exception 'a table is still there; nothing removed';
  end if;

  update pipeline.component_register set status = 'retired', updated_at = now(),
         note = coalesce(note || '; ', '') || 'dropped 20 Oct 2026 by paste file (D11; 14-day wait waived by the Platform Admin; rows in Storage: archive/cf247-d11-drop-34-2026-10-20/39405000377)'
   where kind = 'table' and name = any (array['pipeline.ca_source_qualifications', 'pipeline.coverage_identity_cases', 'pipeline.coverage_identity_sets', 'pipeline.directory_institutions', 'pipeline.directory_pages', 'pipeline.evidence_purge', 'pipeline.layer2_auto_discovery_attempts', 'pipeline.layer2_auto_discovery_settings', 'pipeline.layer2_auto_discovery_settings_audit', 'pipeline.layer2_completeness_trial_courses', 'pipeline.layer2_completeness_trials', 'pipeline.layer3_benchmark_jobs', 'pipeline.layer3_intake_benchmark_cases', 'pipeline.layer3_intake_benchmark_results', 'pipeline.layer3_intake_gold_sets', 'pipeline.layer3_profile_activation_events', 'pipeline.layer3_task_contract_freezes', 'pipeline.onboarding_cases', 'pipeline.onboarding_lifecycle_events', 'pipeline.orphan_files', 'pipeline.provider_asset_candidates', 'pipeline.provider_directory_observations', 'pipeline.scholarship_ai_run_items', 'pipeline.scholarship_catalogue_runs', 'pipeline.scholarship_coverage_benchmarks', 'pipeline.scholarship_maintenance_runs', 'pipeline.scholarship_runtime_settings', 'pipeline.scholarship_scope_acquisition_requests', 'workflow.import_errors', 'workflow.import_rows', 'workflow.migration_entity_map', 'workflow.migration_runs', 'workflow.reconciliation_checks']);
  insert into pipeline.admin_control_events(area, action, target, detail, actor) values
   ('retention', 'drop', '33 retiring tables (D11)',
    jsonb_build_object('decision', 'Platform Admin 20 Oct 2026: "Drop 34 now, fix 23 (Recommended)"', 'export', 'archive/cf247-d11-drop-34-2026-10-20/39405000377',
                       'tables_dropped', to_jsonb(array['pipeline.ca_source_qualifications', 'pipeline.coverage_identity_cases', 'pipeline.coverage_identity_sets', 'pipeline.directory_institutions', 'pipeline.directory_pages', 'pipeline.evidence_purge', 'pipeline.layer2_auto_discovery_attempts', 'pipeline.layer2_auto_discovery_settings', 'pipeline.layer2_auto_discovery_settings_audit', 'pipeline.layer2_completeness_trial_courses', 'pipeline.layer2_completeness_trials', 'pipeline.layer3_benchmark_jobs', 'pipeline.layer3_intake_benchmark_cases', 'pipeline.layer3_intake_benchmark_results', 'pipeline.layer3_intake_gold_sets', 'pipeline.layer3_profile_activation_events', 'pipeline.layer3_task_contract_freezes', 'pipeline.onboarding_cases', 'pipeline.onboarding_lifecycle_events', 'pipeline.orphan_files', 'pipeline.provider_asset_candidates', 'pipeline.provider_directory_observations', 'pipeline.scholarship_ai_run_items', 'pipeline.scholarship_catalogue_runs', 'pipeline.scholarship_coverage_benchmarks', 'pipeline.scholarship_maintenance_runs', 'pipeline.scholarship_runtime_settings', 'pipeline.scholarship_scope_acquisition_requests', 'workflow.import_errors', 'workflow.import_rows', 'workflow.migration_entity_map', 'workflow.migration_runs', 'workflow.reconciliation_checks']), 'functions_dropped', 61), null);
end $drop$;
commit;

-- Check afterwards (optional):
-- select count(*) from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname || '.' || c.relname in ('pipeline.evidence_purge', 'pipeline.orphan_files', 'workflow.import_rows');   -- 0
-- select pg_size_pretty(pg_database_size(current_database()));
