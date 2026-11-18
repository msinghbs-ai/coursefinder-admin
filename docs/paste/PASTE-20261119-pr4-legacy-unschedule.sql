-- PASTE-20261119-pr4-legacy-unschedule.sql
-- CF-247 consolidation PR 4: unschedule the 9 legacy jobs after the 14-day retention window.
-- Prepared by: Pilot migration 20261119070000_cf247_pr4_lane_fold_cutover (shadow 20261118170000, Pilot #1282; Platform Admin 18 Nov 2026 14:24):
--   page-text and the 7 single-mode coverage-sweep jobs run by coverage-lane-dispatch (pipeline.field_execution_registry, mode live), and
--   settings-backup-daily run by rollup-scheduler (pipeline.rollup_targets, group A, mode live); the 9 legacy cron.job rows switched off
--   (active = false) and marked retiring, retire_after = cutover date + hygiene.retire_after_days.
-- Run on or after: retire_after + 1 day (cutover on 19 Nov 2026 gives retire_after 3 Dec, so on or after 4 Dec 2026).
-- Pattern: Pilot CLAUDE.md "Cron dispatchers": the cron.unschedule paste file is held for hygiene.retire_after_days.
-- Guarded: refuses and changes nothing unless all 9 jobs are switched off, retiring, past retire_after, idle for hygiene.idle_days, their
--   targets are still live, and flag-recheck (security.flag_jobs_v1) reads the live lanes from the registry (as the PR 3 paste file).
-- Replaces: nothing. Retires: the 9 jobs below (cron.unschedule, catalogue row removed, component register row set to retired).

begin;
do $$
declare v_lanes text[] := array['central-find', 'coverage-ai-match', 'coverage-discover', 'coverage-discover-2', 'logo-find', 'ops-diagnose', 'page-text', 'scholarship-listing'];
        v_jobs text[] := array['central-find', 'coverage-ai-match', 'coverage-discover', 'coverage-discover-2', 'logo-find', 'ops-diagnose', 'page-text', 'scholarship-listing', 'settings-backup-daily'];
        v_idle int := security.pipeline_num_v1('hygiene.idle_days', 14)::int; v_n int; v_live int;
begin
  select count(*) into v_live from pipeline.field_execution_registry where kind = 'worker_lane' and legacy_job = any(v_lanes) and mode = 'live';
  if v_live <> 8 then raise exception 'refused: % of 8 lanes are live in pipeline.field_execution_registry; nothing was changed', v_live; end if;
  if not exists (select 1 from pipeline.rollup_targets where target_code = 'settings-backup-daily' and mode = 'live' and enabled) then
    raise exception 'refused: settings-backup-daily is not live in pipeline.rollup_targets; nothing was changed';
  end if;
  if position('field_execution_registry' in (select prosrc from pg_proc where oid = 'security.flag_jobs_v1()'::regprocedure)) = 0 then
    raise exception 'refused: security.flag_jobs_v1 does not yet read the live lanes from pipeline.field_execution_registry (the idle pause would stop); nothing was changed';
  end if;
  select count(*) into v_n from cron.job j join pipeline.component_register r on r.kind = 'job' and r.name = j.jobname
   where j.jobname = any(v_jobs) and not j.active and r.status = 'retiring' and r.retire_after <= current_date
     and not exists (select 1 from cron.job_run_details d where d.jobid = j.jobid and d.start_time > now() - make_interval(days => v_idle));
  if v_n <> 9 then raise exception 'refused: % of 9 jobs are switched off, retiring, past retire_after and idle; nothing was changed', v_n; end if;
  perform cron.unschedule(j.jobid) from cron.job j where j.jobname = any(v_jobs);
  delete from pipeline.automation_catalogue where jobname = any(v_jobs);
  update pipeline.component_register set status = 'retired', note = 'unscheduled by PASTE-20261119-pr4-legacy-unschedule.sql (run by its dispatcher)', updated_at = now()
   where kind = 'job' and name = any(v_jobs);
  if exists (select 1 from cron.job where jobname = any(v_jobs)) then raise exception 'post-check: a job is still scheduled'; end if;
  raise notice 'done: 9 legacy jobs unscheduled, catalogue rows removed, register rows retired';
end $$;
commit;
