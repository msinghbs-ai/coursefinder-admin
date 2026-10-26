-- PASTE FILE — AU courses that left the CRICOS register (30 Sep 2026 edition): retire them (CF-247 AU completion week)
-- For: Platform Admin, to apply in the Supabase SQL editor of project fxcwkweaxjtknorudmwp (NOT coursefinder-demo). Never applied by the agent.
-- Decision: Platform Admin 26 Oct 2026 21:12 ("The 563 course retirements from the 30 Sep register run are APPROVED. They are register-gone;
-- retirement is the honest state. Apply count-guarded alongside the two pastes.") Order: THIS FIRST, then the publish paste, then the fee re-apply.
-- Record: admin docs/platform/ui-audit/2026-10-26-au-completion-week.md.
--
-- What it does: approves the held departures of register run b8a541af (30 Sep 2026) through the platform's own approval path,
-- security.layer1_plan_finish_v1(run, force, actor), the same function as Layer 1 operations › approve departures:
--   - 563 active AU courses whose CRICOS code is not on the current register become inactive (lifecycle), each with a retirement row
--     ("Not in the register as of 01 Oct 2026") and its CRICOS course registration set inactive; any course listed again is reactivated
--     automatically by a later register run;
--   - 6 providers left with no active course get a "provider left the register" review item (closure or merger) in Layer 4;
--   - consumer API snapshots before and after are stored; one search refresh request.
-- Guards (one transaction, all or nothing):
--   guard 1  the run's departures are still held, and exactly 563 active courses match its departed codes (course-id list md5 78357842…);
--   guard 2  the function reports exactly 563 retired, and 563 retirement rows exist for the run;
--   log      one admin_control_events row.
-- Undo: a course can be reactivated by a person (Layer 1) or by a later register edition that lists it again.

begin;

do $paste$
declare v_n int; v_h text; v_r jsonb;
begin
  if not exists (select 1 from pipeline.layer1_run_plans where run_id = 'b8a541af-41f5-42e8-ae66-efe362423108' and departures_status = 'held') then
    raise exception 'guard 1: run b8a541af departures are not held any more; nothing changed';
  end if;
  select count(*), md5(string_agg(id::text, ',' order by id)) into v_n, v_h from (
    select distinct c.id from catalogue.course_registrations cr join catalogue.courses c on c.id = cr.course_id join catalogue.providers p on p.id = c.provider_id
     where p.country_id = 'e89cc13b-43b5-4255-8f26-45ef6d86141b' and lower(cr.scheme) = 'cricos' and c.lifecycle_status = 'active'
       and upper(cr.registration_code) = any (select upper(x) from unnest((select departed_keys from pipeline.layer1_run_plans where run_id = 'b8a541af-41f5-42e8-ae66-efe362423108')) x)) d;
  if v_n <> 563 or v_h <> '78357842ad6dee377eb56ca35e63f818' then
    raise exception 'guard 1: % courses match (md5 %), expected 563 (78357842…); nothing changed. Ask the agent to regenerate.', v_n, v_h;
  end if;

  v_r := security.layer1_plan_finish_v1('b8a541af-41f5-42e8-ae66-efe362423108'::uuid, true, '63ba56cb-48d4-4169-98c2-7c4d1f72925b'::uuid);
  if coalesce((v_r->>'retired')::int, -1) <> 563 then raise exception 'guard 2: retired %, expected 563; rolled back (%)', v_r->>'retired', v_r; end if;
  select count(*) into v_n from pipeline.layer1_course_retirements where run_id = 'b8a541af-41f5-42e8-ae66-efe362423108';
  if v_n <> 563 then raise exception 'guard 2: % retirement rows, expected 563; rolled back', v_n; end if;

  update pipeline.layer1_run_queue set result = coalesce(result, '{}'::jsonb) || jsonb_build_object('departures', v_r || jsonb_build_object('reason', 'Platform Admin 26 Oct 2026 21:12: register-gone; retirement is the honest state (paste)')), updated_at = now()
   where id = 'b8a541af-41f5-42e8-ae66-efe362423108';
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer1', 'approve_departures_paste', 'register run b8a541af (CRICOS, 30 Sep 2026)', v_r || jsonb_build_object('course_list_md5', '78357842ad6dee377eb56ca35e63f818'),
          '63ba56cb-48d4-4169-98c2-7c4d1f72925b'::uuid);
  raise notice 'retired 563 courses: %', v_r;
end $paste$;

commit;

-- After you apply it, the agent verifies the 563 retirements and records the counts.
