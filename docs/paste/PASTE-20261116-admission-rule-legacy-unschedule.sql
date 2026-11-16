-- PASTE-20261116-admission-rule-legacy-unschedule.sql
-- CF-247 consolidation PR 2: unschedule the 20 legacy admission rule jobs after the 14-day retention window.
-- Prepared by: Pilot #1185, migration 20261116190000_cf247_admission_rule_runner_cutover (live 16 Nov 2026 23:31 AEDT: the 20 rules run by
--   admission-rule-runner, mode live; the 20 legacy cron.job rows switched off (active = false) and marked retiring, retire_after 30 Nov 2026).
-- Run on or after: 1 Dec 2026 (retire_after 30 Nov and 14 idle days since the legacy jobs' last start on 16 Nov 23:31 AEDT).
-- Pattern: Pilot CLAUDE.md "Cron dispatchers": the cron.unschedule paste file is held for hygiene.retire_after_days.
-- Guarded: refuses and changes nothing unless all 20 jobs are switched off, retiring, past retire_after, idle for hygiene.idle_days, and their
--   rules are still live in pipeline.admission_rules (so nothing is unscheduled while the dispatcher is not running them).
-- Replaces: nothing. Retires: the 20 jobs below (cron.unschedule, catalogue row removed, component register row set to retired).

begin;
do $$
declare v_jobs text[] := array['adapter-overwrite', 'coverage-admit', 'coverage-admit-intakes', 'exit-awards-apply', 'fee-period-settle', 'fee-wording-rules',
          'host-pages-apply', 'intake-dates-apply', 'l4-rule-fee-year-align', 'l4-rule-unofficial-source', 'policy-auto-approve', 'process-results',
          'provider-basis-rule-admit', 'provider-english-defaults', 'provider-fee-profiles-apply', 'provider-rule-admit',
          'aer-v2-identity-settle', 'layer4-auto-admit', 'intake-rule-b-qualify', 'scholarship-discovery-settle'];
        v_idle int := security.pipeline_num_v1('hygiene.idle_days', 14)::int; v_n int; v_live int;
begin
  select count(*) into v_live from pipeline.admission_rules where legacy_job = any(v_jobs) and mode = 'live' and enabled;
  if v_live <> 20 then raise exception 'refused: % of 20 rules are live in pipeline.admission_rules; nothing was changed', v_live; end if;
  select count(*) into v_n from cron.job j join pipeline.component_register r on r.kind = 'job' and r.name = j.jobname
   where j.jobname = any(v_jobs) and not j.active and r.status = 'retiring' and r.retire_after <= current_date
     and not exists (select 1 from cron.job_run_details d where d.jobid = j.jobid and d.start_time > now() - make_interval(days => v_idle));
  if v_n <> 20 then raise exception 'refused: % of 20 jobs are switched off, retiring, past retire_after and idle (retire_after is 30 Nov 2026); nothing was changed', v_n; end if;
  perform cron.unschedule(j.jobid) from cron.job j where j.jobname = any(v_jobs);
  delete from pipeline.automation_catalogue where jobname = any(v_jobs);
  update pipeline.component_register set status = 'retired', note = 'unscheduled by PASTE-20261116-admission-rule-legacy-unschedule.sql (rule run by admission-rule-runner)', updated_at = now()
   where kind = 'job' and name = any(v_jobs);
  if exists (select 1 from cron.job where jobname = any(v_jobs)) then raise exception 'post-check: a job is still scheduled'; end if;
  raise notice 'done: 20 legacy admission rule jobs unscheduled, catalogue rows removed, register rows retired';
end $$;
commit;
