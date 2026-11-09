-- PASTE FILE — withdraw 1 admitted tuition value whose course identity the source does not prove (CF-247)
-- For: Platform Admin, by hand in the SQL editor of fxcwkweaxjtknorudmwp (NOT coursefinder-demo). Never applied by the agent.
-- Authority: Platform Admin 27 Oct 2026 19:10: "Keep values active only where their provenance and admission evidence are valid. If ... any other
-- value cannot be traced to valid source evidence, prepare a count-guarded manual withdrawal proposal". Record: admin
-- docs/platform/ui-audit/2026-10-27-mandate-0546-response.md (19:2x, audit of the five out-of-scope PDFs).
-- Finding (read only): fee 15802bef gives University of Divinity "Graduate Certificate in Theology" (CRICOS 053016J) AUD 27,072 for 2026. It was
-- read from the 2026 PDF line "Graduate Certificate in Divinity | FT/PT | 0.5 | 26 | 2 | PG | 3 | 3,384 ..." (title agreement 0.667, above the
-- 0.6 gate, no course code on the line). The page never names the Graduate Certificate in Theology, so the identity is not proven by the source.
-- (It may be the same award renamed for 2027; the 2027 PDF prints "Graduate Certificate in Theology" with the same structure. The rename is not
-- evidenced, so it is not inferred.) The course keeps its 2027 value (fee 90daaf42, AUD 28,704, read from its own named line), so it still has
-- provider tuition and the AU numerator does not change.
-- What it does (one transaction; raises and changes nothing if the live state differs): fee 15802bef -> status 'inactive', valid_to today, with the
-- reason appended to its notes; evidence, source and history kept; nothing deleted; one admin_control_events row.
begin;
do $paste$
declare v_n int;
begin
  select count(*) into v_n from catalogue.course_fees f
   where f.id = '15802bef-6748-4649-9406-fe6e04268854' and f.course_id = 'a3484e37-c1fe-4b40-9bc9-0ad265ad2091' and f.fee_type = 'provider_current_tuition'
     and coalesce(f.status, 'active') = 'active' and f.amount = 27072 and f.fee_year = 2026;
  if v_n <> 1 then raise exception 'guard: fee 15802bef is not the active 2026 value of 27,072; nothing changed'; end if;
  select count(*) into v_n from catalogue.course_fees f
   where f.course_id = 'a3484e37-c1fe-4b40-9bc9-0ad265ad2091' and f.fee_type = 'provider_current_tuition' and coalesce(f.status, 'active') = 'active'
     and f.id = '90daaf42-416c-4c47-b8b3-0c62685ea2da' and f.amount = 28704 and f.fee_year = 2027;
  if v_n <> 1 then raise exception 'guard: the course''s 2027 value (90daaf42) is not active; nothing changed'; end if;
  update catalogue.course_fees set status = 'inactive', valid_to = current_date, updated_at = now(),
         notes = coalesce(notes, '') || ' | Withdrawn 27 Oct 2026 (Platform Admin paste): read from the line "Graduate Certificate in Divinity", which does not name this course; identity not proven by the source.'
   where id = '15802bef-6748-4649-9406-fe6e04268854' and coalesce(status, 'active') = 'active';
  get diagnostics v_n = row_count; if v_n <> 1 then raise exception 'withdrew %, expected 1; rolled back', v_n; end if;
  select count(*) into v_n from catalogue.course_fees where course_id = 'a3484e37-c1fe-4b40-9bc9-0ad265ad2091' and fee_type = 'provider_current_tuition' and coalesce(status, 'active') = 'active';
  if v_n <> 1 then raise exception 'the course has % active provider tuition values, expected 1; rolled back', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('fees', 'withdraw_paste', 'catalogue.course_fees 15802bef (University of Divinity, GC Theology 053016J)',
          jsonb_build_object('fees', 1, 'amount', 27072, 'fee_year', 2026, 'reason', 'source line names Graduate Certificate in Divinity, not this course',
                             'kept', '90daaf42 (2027, 28,704)', 'audit', 'out-of-scope PDF audit 27 Oct 2026'), '63ba56cb-48d4-4169-98c2-7c4d1f72925b'::uuid);
end $paste$;
commit;
