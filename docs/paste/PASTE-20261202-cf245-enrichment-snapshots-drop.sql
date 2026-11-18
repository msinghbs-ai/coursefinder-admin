-- PASTE-20261202-cf245-enrichment-snapshots-drop.sql
-- CF-247 legacy telemetry retirement (S2-Build; Platform Admin 18 Nov 2026 12:19). For the Platform Admin to run in the Supabase SQL editor of
-- fxcwkweaxjtknorudmwp ON OR AFTER 2 Dec 2026 (retire_after 2 Dec, hygiene.retire_after_days 14), after PASTE-20261118-rollup-legacy-unschedule.sql
-- has unscheduled the legacy cron rows of the two CF-245 report jobs.
-- Pilot migration 20261118151000 switched off rollup targets coursefinder-cf245-enrichment-coverage-snapshot and
-- coursefinder-cf245-enrichment-hourly-admin-cache; no screen or operation reads their output. This drops the two tables (and their rows), the two
-- snapshot functions and the read behind admin_read('enrichment_operations'), then marks them retired. The admin_read branch that names the read
-- stays (it raises if called) until the next change to admin_read removes it.
-- It refuses unless: both targets are off and have not run since 18 Nov; every object is still marked retiring with retire_after passed; no
-- function other than the ones dropped here references the two tables.

begin;

do $$
declare v_refs text;
begin
  if exists (select 1 from pipeline.rollup_targets where target_code in ('coursefinder-cf245-enrichment-coverage-snapshot', 'coursefinder-cf245-enrichment-hourly-admin-cache')
              and (enabled or coalesce(last_started_at, '-infinity') > timestamptz '2026-11-18 02:00+00')) then
    raise exception 'a CF-245 target is on or has run since it was switched off';
  end if;
  if (select count(*) from pipeline.component_register where status = 'retiring' and retire_after <= current_date
        and name in ('public.svc_cf245_capture_coverage_snapshot', 'public.svc_cf245_refresh_hourly_admin_cache', 'security.admin_enrichment_operations_read',
                     'pipeline.enrichment_coverage_snapshots', 'pipeline.layer2_enrichment_hourly_admin_cache_v1')) <> 5 then
    raise exception 'not all five objects are retiring with retire_after passed';
  end if;
  select string_agg(p.oid::regprocedure::text, ', ') into v_refs from pg_proc p
   where p.prosrc ~ '(enrichment_coverage_snapshots|layer2_enrichment_hourly_admin_cache_v1)'
     and p.oid not in ('public.svc_cf245_capture_coverage_snapshot()'::regprocedure, 'public.svc_cf245_refresh_hourly_admin_cache()'::regprocedure,
                       'security.admin_enrichment_operations_read(jsonb)'::regprocedure);
  if v_refs is not null then raise exception 'other functions still read the tables: %', v_refs; end if;
end $$;

drop function public.svc_cf245_capture_coverage_snapshot();
drop function public.svc_cf245_refresh_hourly_admin_cache();
drop function security.admin_enrichment_operations_read(jsonb);
drop table pipeline.enrichment_coverage_snapshots;
drop table pipeline.layer2_enrichment_hourly_admin_cache_v1;

update pipeline.component_register set status = 'retired', updated_at = now()
 where name in ('public.svc_cf245_capture_coverage_snapshot', 'public.svc_cf245_refresh_hourly_admin_cache', 'security.admin_enrichment_operations_read',
                'pipeline.enrichment_coverage_snapshots', 'pipeline.layer2_enrichment_hourly_admin_cache_v1');
insert into pipeline.admin_control_events(area, action, target, detail, actor)
values ('housekeeping', 'telemetry_drop', 'cf245-enrichment-snapshots', jsonb_build_object('paste_file', 'PASTE-20261202-cf245-enrichment-snapshots-drop.sql'), auth.uid());

commit;

-- read back: both tables and the three functions gone; consumer API unchanged (expect 75 and 48)
select to_regclass('pipeline.enrichment_coverage_snapshots') a, to_regclass('pipeline.layer2_enrichment_hourly_admin_cache_v1') b,
       to_regprocedure('security.admin_enrichment_operations_read(jsonb)') c,
       (select count(*) from security.consumer_api_functions_v1()) consumer_functions, (select count(*) from security.consumer_api_relations_v1()) consumer_relations;
