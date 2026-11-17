-- PASTE-20261118-rollup-legacy-unschedule.sql
-- CF-247 consolidation PR 1: unschedule the 25 legacy report and cache jobs after the 14-day retention window.
-- Prepared by: Pilot migration 20261118010000_cf247_rollup_scheduler_cutover (Platform Admin 17 Nov 2026 23:07: the 25 targets of
--   pipeline.rollup_targets group A run by rollup-scheduler, mode live; the 25 legacy cron.job rows switched off (active = false) and marked
--   retiring, retire_after 1 Dec 2026). layer2-onboarding-snapshot stays on its own job and is not in this file.
-- Run on or after: 2 Dec 2026 (retire_after 1 Dec and 14 idle days since the legacy jobs' last start on 17 Nov 2026, about 23:47 AEDT).
-- Pattern: Pilot CLAUDE.md "Cron dispatchers": the cron.unschedule paste file is held for hygiene.retire_after_days.
-- Guarded: refuses and changes nothing unless all 25 jobs are switched off, retiring, past retire_after, idle for hygiene.idle_days, and their
--   targets are still live in pipeline.rollup_targets (so nothing is unscheduled while the dispatcher is not running them).
-- Replaces: nothing. Retires: the 25 jobs below (cron.unschedule, catalogue row removed, component register row set to retired).

begin;
do $$
declare v_jobs text[] := array['adapter-build-readiness', 'admin-read-snapshots', 'admin-summary-snapshots-refresh', 'aer-outcome-register',
          'api-usage-rollup', 'course-completeness-build', 'course-coverage-build', 'course-coverage-snapshot',
          'course-field-source-build', 'coursefinder-cf245-enrichment-coverage-snapshot', 'coursefinder-cf245-enrichment-hourly-admin-cache', 'coursefinder-data-quality-overview-refresh',
          'data-delivery', 'enrich-coverage-snapshot', 'evidence-filter-options-refresh', 'firecrawl-panel-figures',
          'lane-funnel', 'ops-scorecard', 'progress-snapshot', 'provider-fee-ranges-refresh',
          'provider-field-daily', 'provider-priority-refresh', 'stats-15m', 'storage-size-daily',
          'toolset-use-daily'];
        v_idle int := security.pipeline_num_v1('hygiene.idle_days', 14)::int; v_n int; v_live int;
begin
  select count(*) into v_live from pipeline.rollup_targets where legacy_job = any(v_jobs) and rollup_group = 'A' and mode = 'live' and enabled;
  if v_live <> 25 then raise exception 'refused: % of 25 targets are live in pipeline.rollup_targets; nothing was changed', v_live; end if;
  select count(*) into v_n from cron.job j join pipeline.component_register r on r.kind = 'job' and r.name = j.jobname
   where j.jobname = any(v_jobs) and not j.active and r.status = 'retiring' and r.retire_after <= current_date
     and not exists (select 1 from cron.job_run_details d where d.jobid = j.jobid and d.start_time > now() - make_interval(days => v_idle));
  if v_n <> 25 then raise exception 'refused: % of 25 jobs are switched off, retiring, past retire_after and idle (retire_after is 1 Dec 2026); nothing was changed', v_n; end if;
  perform cron.unschedule(j.jobid) from cron.job j where j.jobname = any(v_jobs);
  delete from pipeline.automation_catalogue where jobname = any(v_jobs);
  update pipeline.component_register set status = 'retired', note = 'unscheduled by PASTE-20261118-rollup-legacy-unschedule.sql (target run by rollup-scheduler)', updated_at = now()
   where kind = 'job' and name = any(v_jobs);
  if exists (select 1 from cron.job where jobname = any(v_jobs)) then raise exception 'post-check: a job is still scheduled'; end if;
  raise notice 'done: 25 legacy rollup jobs unscheduled, catalogue rows removed, register rows retired';
end $$;
commit;
