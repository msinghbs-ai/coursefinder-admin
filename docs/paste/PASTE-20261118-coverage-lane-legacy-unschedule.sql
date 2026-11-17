-- PASTE-20261118-coverage-lane-legacy-unschedule.sql
-- CF-247 consolidation PR 3: unschedule the 13 legacy coverage worker jobs after the 14-day retention window.
-- Prepared by: Pilot #1229, migration 20261118012000_cf247_pr3_coverage_lane_dispatch_cutover (cutover brought forward by the Platform Admin,
--   17 Nov 2026 23:02: the 13 lanes run by coverage-lane-dispatch, mode live; the 13 legacy cron.job rows switched off (active = false) and
--   marked retiring, retire_after 1 Dec 2026).
-- Run on or after: 2 Dec 2026 (retire_after 1 Dec and hygiene.idle_days since the legacy jobs' last start).
-- Pattern: Pilot CLAUDE.md "Cron dispatchers": the cron.unschedule paste file is held for hygiene.retire_after_days.
-- Guarded: refuses and changes nothing unless all 13 jobs are switched off, retiring, past retire_after, idle for hygiene.idle_days, their lanes
--   are still live in pipeline.field_execution_registry, and flag-recheck (security.flag_jobs_v1) reads the live lanes from the registry.
--   Today flag_jobs_v1 finds coverage jobs through their cron.job rows (#1227 makes it act on the live lane); once the legacy rows are
--   unscheduled it would no longer see these lanes, so the idle pause would stop. A Pilot change must first make flag_jobs_v1 iterate the
--   registry's live worker lanes; this file refuses until it has.
-- Replaces: nothing. Retires: the 13 jobs below (cron.unschedule, catalogue row removed, component register row set to retired).

begin;
do $$
declare v_jobs text[] := array['companion-read', 'course-link-search-worker', 'course-list-read', 'coverage-find-site', 'coverage-reextract',
          'coverage-reidentify', 'credential-read', 'policy-add-tests', 'programme-discover', 'programme-read', 'provider-contact-page',
          'provider-facts', 'source-find'];
        v_idle int := security.pipeline_num_v1('hygiene.idle_days', 14)::int; v_n int; v_live int;
begin
  select count(*) into v_live from pipeline.field_execution_registry where kind = 'worker_lane' and legacy_job = any(v_jobs) and mode = 'live';
  if v_live <> 13 then raise exception 'refused: % of 13 lanes are live in pipeline.field_execution_registry; nothing was changed', v_live; end if;
  if position('field_execution_registry' in (select prosrc from pg_proc where oid = 'security.flag_jobs_v1()'::regprocedure)) = 0 then
    raise exception 'refused: security.flag_jobs_v1 does not yet read the live lanes from pipeline.field_execution_registry (the idle pause would stop); nothing was changed';
  end if;
  select count(*) into v_n from cron.job j join pipeline.component_register r on r.kind = 'job' and r.name = j.jobname
   where j.jobname = any(v_jobs) and not j.active and r.status = 'retiring' and r.retire_after <= current_date
     and not exists (select 1 from cron.job_run_details d where d.jobid = j.jobid and d.start_time > now() - make_interval(days => v_idle));
  if v_n <> 13 then raise exception 'refused: % of 13 jobs are switched off, retiring, past retire_after and idle (retire_after is 1 Dec 2026); nothing was changed', v_n; end if;
  perform cron.unschedule(j.jobid) from cron.job j where j.jobname = any(v_jobs);
  delete from pipeline.automation_catalogue where jobname = any(v_jobs);
  update pipeline.component_register set status = 'retired', note = 'unscheduled by PASTE-20261118-coverage-lane-legacy-unschedule.sql (lane run by coverage-lane-dispatch)', updated_at = now()
   where kind = 'job' and name = any(v_jobs);
  if exists (select 1 from cron.job where jobname = any(v_jobs)) then raise exception 'post-check: a job is still scheduled'; end if;
  raise notice 'done: 13 legacy coverage worker jobs unscheduled, catalogue rows removed, register rows retired';
end $$;
commit;
