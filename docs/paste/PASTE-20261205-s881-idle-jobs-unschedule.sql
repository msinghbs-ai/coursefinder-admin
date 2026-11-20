-- PASTE-20261205-s881-idle-jobs-unschedule.sql
-- CF-247 s881: unschedule the 7 idle jobs switched off by Pilot migration 20261120181000_cf247_s881_retire_idle_cron_jobs (Pilot #1434),
-- after the 14-day retention window.
-- Prepared by: S1-Build (Platform Admin 20 Nov 2026 17:14 and 17:15 AEDT): boost-benchmark, lean-sections-eval, lean-qualify, aer-v2-shadow,
--   course-url-fill, reread-pilot and course-description-stale-retire were switched off (active = false) and marked retiring, retire_after =
--   migration date + hygiene.retire_after_days (14). Each did no work: a finished benchmark or evaluation, or a job switched off by its own setting.
-- Run on or after: retire_after + 1 day (applied 20 Nov 2026, so retire_after 4 Dec 2026; run on or after 5 Dec 2026).
-- Before running: if any of these jobs is wanted again, switch it back on (cron.alter_job(jobid, active => true)) and set its register row to
--   active instead; this file then refuses, because not all 7 are off.
-- Guarded: refuses and changes nothing unless all 7 jobs are switched off, retiring, past retire_after and have not run for hygiene.idle_days.
-- Replaces: nothing. Retires: the 7 jobs below (cron.unschedule, catalogue row removed, component register row set to retired).

begin;
do $$
declare v_jobs text[] := array['aer-v2-shadow', 'boost-benchmark', 'course-description-stale-retire', 'course-url-fill', 'lean-qualify', 'lean-sections-eval', 'reread-pilot'];
        v_idle int := security.pipeline_num_v1('hygiene.idle_days', 14)::int; v_n int;
begin
  select count(*) into v_n from cron.job j join pipeline.component_register r on r.kind = 'job' and r.name = j.jobname
   where j.jobname = any(v_jobs) and not j.active and r.status = 'retiring' and r.retire_after <= current_date
     and not exists (select 1 from cron.job_run_details d where d.jobid = j.jobid and d.start_time > now() - make_interval(days => v_idle));
  if v_n <> 7 then raise exception 'refused: % of 7 jobs are switched off, retiring, past retire_after and idle; nothing was changed', v_n; end if;
  perform cron.unschedule(j.jobid) from cron.job j where j.jobname = any(v_jobs);
  delete from pipeline.automation_catalogue where jobname = any(v_jobs);
  update pipeline.component_register set status = 'retired', note = 'unscheduled by PASTE-20261205-s881-idle-jobs-unschedule.sql (no work left; s881)', updated_at = now()
   where kind = 'job' and name = any(v_jobs);
  if exists (select 1 from cron.job where jobname = any(v_jobs)) then raise exception 'post-check: a job is still scheduled'; end if;
  raise notice 'done: 7 idle jobs unscheduled, catalogue rows removed, register rows retired';
end $$;
commit;
