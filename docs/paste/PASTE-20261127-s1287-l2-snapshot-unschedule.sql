-- PASTE-20261127-s1287-l2-snapshot-unschedule.sql
-- CF-247 s1287: unschedule cron job layer2-onboarding-snapshot, switched off at the rollup-scheduler cutover by Pilot migration
-- 20261130064500_cf247_s1287_dispatcher_starvation_and_l2_snapshot_cutover, after the 14-day retention window.
-- Prepared by: S1-Build (SS-Programme-Control 27 Nov 2026 00:08 AEDT, item 5). The rollup-scheduler target layer2-onboarding-snapshot runs the
--   same command byte for byte (call_md5 4aa400e3ed741eb7d08683aa7d9b3bd9), live from the cutover.
-- Run on or after: retire_after + 1 day (applied 26 Nov 2026 UTC, so retire_after 10 Dec 2026; run on or after 11 Dec 2026).
-- Before running: if the cron job is wanted again, switch it back on and set its register row to active; this file then refuses.
-- Guarded: refuses and changes nothing unless the job is off, retiring, past retire_after, idle for hygiene.idle_days, and the target is live,
--   enabled, byte for byte and has succeeded since the cutover.
-- Replaces: nothing. Retires: cron job layer2-onboarding-snapshot (cron.unschedule, catalogue row removed, component register row retired).

begin;
do $$
declare v_idle int := security.pipeline_num_v1('hygiene.idle_days', 14)::int; v_ok boolean;
begin
  select exists (
    select 1 from cron.job j
      join pipeline.component_register r on r.kind = 'job' and r.name = j.jobname
      join pipeline.rollup_targets t on t.legacy_job = j.jobname
     where j.jobname = 'layer2-onboarding-snapshot' and not j.active and r.status = 'retiring' and r.retire_after <= current_date
       and t.mode = 'live' and t.enabled and t.call_md5 = md5(t.call_sql) and t.call_md5 = md5(j.command)
       and exists (select 1 from pipeline.rollup_runs u where u.target_code = t.target_code and u.status = 'succeeded' and u.started_at > r.updated_at)
       and not exists (select 1 from cron.job_run_details d where d.jobid = j.jobid and d.start_time > now() - make_interval(days => v_idle))) into v_ok;
  if not v_ok then raise exception 'refused: layer2-onboarding-snapshot is not off, retiring, past retire_after and idle with a live byte-for-byte target; nothing was changed'; end if;
  perform cron.unschedule(j.jobid) from cron.job j where j.jobname = 'layer2-onboarding-snapshot';
  delete from pipeline.automation_catalogue where jobname = 'layer2-onboarding-snapshot';
  update pipeline.component_register set status = 'retired', note = 'unscheduled by PASTE-20261127-s1287-l2-snapshot-unschedule.sql (rollup-scheduler target live; s1287)', updated_at = now()
   where kind = 'job' and name = 'layer2-onboarding-snapshot';
  if exists (select 1 from cron.job where jobname = 'layer2-onboarding-snapshot') then raise exception 'post-check: the job is still scheduled'; end if;
  raise notice 'done: layer2-onboarding-snapshot unscheduled, catalogue row removed, register row retired';
end $$;
commit;
