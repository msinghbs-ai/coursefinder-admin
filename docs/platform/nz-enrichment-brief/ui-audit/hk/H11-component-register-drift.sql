-- CF-247 housekeeping H11: component-register drift correction. Project fxcwkweaxjtknorudmwp ONLY.
-- PREPARED READ-ONLY 2 Nov 2026 11:05-11:16 AEDT. NOT RUN. The integrator runs it (a register write; no catalogue, consumer or Storage change).
-- Authority: Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 6 ("H11: Correct component-register drift under the existing
--   housekeeping authority"); Decision 260 / DATA-PIPELINE-OPERATING-MODEL.md section 6.1-6.2 (register upkeep). Finding: 2026-11-02-housekeeping-reconciliation.md H11.
-- Replaces: nothing. Retires: nothing (register rows only; nothing is dropped or deleted).
-- Status values used are the existing ones only: component_register_status_check = active | retiring | retired.
--
-- Live read-back, 2 Nov 11:05-11:16 AEDT (exact BEFORE and AFTER for each row):
-- | # | kind     | name                                                  | field        | before                   | after                                    | why |
-- |---|----------|-------------------------------------------------------|--------------|--------------------------|------------------------------------------|-----|
-- | 1 | function | public.layer2_provider_asset_promotion_context(uuid)  | status       | retiring                 | retired                                  | to_regprocedure null and no pg_proc row: already absent; retire_after 2026-10-29 passed |
-- |   |          |                                                       | note         | null                     | 'Absent from the database (checked 2 Nov 2026 11:05 AEDT); H11'       | |
-- | 2 | function | public.layer2_hotcourses_directory_apply              | status       | retiring                 | retired                                  | no pg_proc row in public: already absent; retire_after 2026-11-01 passed |
-- |   |          |                                                       | note         | '18 Oct 2026: no caller and no job' | '18 Oct 2026: no caller and no job. Absent from the database (checked 2 Nov 2026 11:05 AEDT); H11' | |
-- | 3 | function | security.semester_intake_apply_v1                     | retire_after | null                     | 2026-11-05                               | marked retiring by 20261022042000 (22 Oct) with no date; rule 6.2.3 = 14 days ahead |
-- |   |          |                                                       | replaced_by  | null                     | 'Intakes from the course''s own page only (20261022042000)' | |
-- | 4 | function | security.calendar_default_intakes_apply_v1            | retire_after | null                     | 2026-11-05                               | as row 3 |
-- |   |          |                                                       | replaced_by  | null                     | 'Intakes from the course''s own page only (20261022042000)' | |
-- | 5 | job      | provider-calendar-intakes                             | status       | active                   | retiring                                 | ADDITIONAL DRIFT found 2 Nov 11:05: cron.job active=false since 20261022042000 (it calls row 3); register still says active |
-- |   |          |                                                       | replaced_by / retire_after | null / null | 'Intakes from the course''s own page only (20261022042000)' / 2026-11-05 | |
-- | 6 | job      | provider-calendar-defaults                            | status       | active                   | retiring                                 | as row 5 (calls row 4) |
-- |   |          |                                                       | replaced_by / retire_after | null / null | as row 5 | |
--
-- Live facts behind rows 3-6 (2 Nov 11:05): security.semester_intake_apply_v1(uuid) def md5 c6fcd492212e9e3cf8931885e4ce2d35, 0 pg_depend refs,
--   1 cron ref = provider-calendar-intakes (7-59/10, active=false, no run in job_run_details); security.calendar_default_intakes_apply_v1()
--   def md5 ca425ddf42c5702f895c61e00ce600ac, 0 pg_depend refs, 1 cron ref = provider-calendar-defaults (3-59/10, active=false, no run).
--   Both stay in the database: dropping them (and unscheduling the paused jobs) is a later Decision 260 rule-4 paste file after 5 Nov, not this file.
-- updated_at before: rows 1 = 2026-10-15 02:15:33.299089+00; 2 = 2026-10-18 01:55:39.089355+00; 3 and 4 = 2026-10-22 11:50:09.206285+00. Rows 5-6 not read (rollback restores fields, not updated_at).
-- Note: the reconciliation's H11 named 4 rows; rows 5 and 6 are the same drift (the paused jobs of rows 3-4) and are corrected under the same authority.

begin;
do $h11$
declare v_n int;
begin
  -- Guard 1: rows 1-2 are retiring and their functions are absent
  select count(*) into v_n from pipeline.component_register
   where kind = 'function' and status = 'retiring'
     and name in ('public.layer2_provider_asset_promotion_context(uuid)', 'public.layer2_hotcourses_directory_apply');
  if v_n <> 2 then raise exception 'H11: expected 2 retiring rows (1-2), found %', v_n; end if;
  select count(*) into v_n from pg_proc p join pg_namespace n on n.oid = p.pronamespace
   where n.nspname = 'public' and p.proname in ('layer2_provider_asset_promotion_context', 'layer2_hotcourses_directory_apply');
  if v_n <> 0 then raise exception 'H11: % of the row 1-2 functions exist again; stop and re-read', v_n; end if;

  -- Guard 2: rows 3-4 retiring with no date and no replaced_by; their functions exist; their only cron callers are paused
  select count(*) into v_n from pipeline.component_register
   where kind = 'function' and status = 'retiring' and retire_after is null and replaced_by is null
     and name in ('security.semester_intake_apply_v1', 'security.calendar_default_intakes_apply_v1');
  if v_n <> 2 then raise exception 'H11: expected 2 undated retiring rows (3-4), found %', v_n; end if;
  select count(*) into v_n from cron.job
   where (command ilike '%semester_intake_apply_v1%' or command ilike '%calendar_default_intakes_apply_v1%') and active;
  if v_n <> 0 then raise exception 'H11: % active cron job(s) still call rows 3-4; they are not retiring; stop', v_n; end if;

  -- Guard 3: rows 5-6 say active while their cron jobs are paused
  select count(*) into v_n from pipeline.component_register r join cron.job j on j.jobname = r.name
   where r.kind = 'job' and r.status = 'active' and not j.active and r.retire_after is null and r.replaced_by is null
     and r.name in ('provider-calendar-intakes', 'provider-calendar-defaults');
  if v_n <> 2 then raise exception 'H11: expected 2 active register rows for paused jobs (5-6), found %', v_n; end if;

  update pipeline.component_register
     set status = 'retired',
         note = case when note is null then 'Absent from the database (checked 2 Nov 2026 11:05 AEDT); H11'
                     else note || '. Absent from the database (checked 2 Nov 2026 11:05 AEDT); H11' end,
         updated_at = now()
   where kind = 'function' and status = 'retiring'
     and name in ('public.layer2_provider_asset_promotion_context(uuid)', 'public.layer2_hotcourses_directory_apply');
  get diagnostics v_n = row_count; if v_n <> 2 then raise exception 'H11: rows 1-2 updated %, expected 2', v_n; end if;

  update pipeline.component_register
     set retire_after = date '2026-11-05', replaced_by = 'Intakes from the course''s own page only (20261022042000)', updated_at = now()
   where kind = 'function' and status = 'retiring' and retire_after is null and replaced_by is null
     and name in ('security.semester_intake_apply_v1', 'security.calendar_default_intakes_apply_v1');
  get diagnostics v_n = row_count; if v_n <> 2 then raise exception 'H11: rows 3-4 updated %, expected 2', v_n; end if;

  update pipeline.component_register
     set status = 'retiring', retire_after = date '2026-11-05', replaced_by = 'Intakes from the course''s own page only (20261022042000)', updated_at = now()
   where kind = 'job' and status = 'active' and retire_after is null and replaced_by is null
     and name in ('provider-calendar-intakes', 'provider-calendar-defaults');
  get diagnostics v_n = row_count; if v_n <> 2 then raise exception 'H11: rows 5-6 updated %, expected 2', v_n; end if;

  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('housekeeping', 'h11_component_register_drift', 'pipeline.component_register',
          jsonb_build_object('rows', 6, 'retired', jsonb_build_array('public.layer2_provider_asset_promotion_context(uuid)', 'public.layer2_hotcourses_directory_apply'),
                             'dated', jsonb_build_array('security.semester_intake_apply_v1', 'security.calendar_default_intakes_apply_v1'),
                             'now_retiring', jsonb_build_array('provider-calendar-intakes', 'provider-calendar-defaults'),
                             'authority', 'Platform Admin decision pack 2 Nov 2026 10:56, Decision 6 (H11); Decision 260 section 6.1-6.2'), null);
end $h11$;

-- Read-back (expect exactly 6 rows, matching the AFTER column above):
select kind, name, status, replaced_by, retire_after, note from pipeline.component_register
 where name in ('public.layer2_provider_asset_promotion_context(uuid)', 'public.layer2_hotcourses_directory_apply',
                'security.semester_intake_apply_v1', 'security.calendar_default_intakes_apply_v1',
                'provider-calendar-intakes', 'provider-calendar-defaults') order by kind, name;
-- If the read-back is not as expected: rollback;  otherwise: commit;

-- ROLLBACK after commit (restores the 2 Nov 11:05 values; nothing was deleted):
-- update pipeline.component_register set status='retiring', note=null, updated_at=now() where kind='function' and name='public.layer2_provider_asset_promotion_context(uuid)' and status='retired';  -- expect 1
-- update pipeline.component_register set status='retiring', note='18 Oct 2026: no caller and no job', updated_at=now() where kind='function' and name='public.layer2_hotcourses_directory_apply' and status='retired';  -- expect 1
-- update pipeline.component_register set retire_after=null, replaced_by=null, updated_at=now() where kind='function' and name in ('security.semester_intake_apply_v1','security.calendar_default_intakes_apply_v1') and retire_after=date '2026-11-05';  -- expect 2
-- update pipeline.component_register set status='active', retire_after=null, replaced_by=null, updated_at=now() where kind='job' and name in ('provider-calendar-intakes','provider-calendar-defaults') and status='retiring';  -- expect 2
-- Note: the daily component_register_sync_v1 / weekly hygiene-check may also touch these rows; re-read before any rollback.
