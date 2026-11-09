-- CF-247 E16 F1: withdraw 2 provider fees read from another programme's page (Flinders 105122F, UQ 116548M). E1 pattern (status
-- 'inactive', note, valid_to). PASTE FILE PREPARED READ-ONLY 2 NOV 2026 12:30 AEDT from fees.sql block F1 (e16plan2). NOT RUN. Not a migration.
-- Project fxcwkweaxjtknorudmwp only. Run as postgres in an allowed minute, AFTER contain-links-A.sql has committed.
-- Authority: Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 1 ("F1's two associated fees must be independently
--   checked and withdrawn only when their source is confirmed invalid, under the applicable authorisation"); the applicable authorisation is
--   E16 final disposition 2 Nov 2026 07:21 section 2 action 4 (suppress fees whose provenance verifies a wrong-course source).
--
-- INDEPENDENT SOURCE CHECK (live, 2 Nov 11:46 and 12:07 AEDT; read-only):
--   116548M Bachelor of Nutrition Sciences, fee 69c6da38 60,952 AUD annual (2027), note "University adapter reading of the course page".
--     * evidence 35e7642f, captured 1 Oct 2026, source_url study.uq.edu.au/.../bachelor-nutrition-sciences-master-dietetics-studies-2534
--       = the wrongly bound page (not the course's own page; course_url was filled from the same wrong binding).
--     * the bound page's stored reading: page title "Bachelor of Nutrition Sciences / Master of Dietetics Studies - Study - The University of
--       Queensland", duration "4 Years", fee candidate 60,952 (2027, adapter pattern) = the stored amount.
--     * the same page is the official link of 116549K (the dual programme), whose own provider fee is 60,952 (2027).
--     * this course's CRICOS registered total is 171,150 for the whole course; the double degree's (116549K) is 235,179: different programmes.
--     => CONFIRMED: another programme's page (the double degree).
--   105122F Graduate Diploma in Computer Science, fee 7253f4a7 42,900 AUD annual (2026), note "University adapter reading of the course page".
--     * evidence 7be3c2d1, captured 30 Sep 2026, source_url flinders.edu.au/study/courses/postgraduate-master-computer-science = the wrongly
--       bound page.
--     * stored reading: page title "Study a Master of Computer Science - Flinders University", duration "2 years", fee candidate 42,900 (2026).
--     * the same page is the official link of 105121G Master of Computer Science, whose own provider fee is 42,900 (2026).
--     * this course's CRICOS registered total is 35,500 for 1 year (-17.2%); its adapter award row register_check is 'fail'.
--     => CONFIRMED: another programme's page (the parent master).
--   The amount on the page itself is in gzipped Storage, not readable through SQL; the stored extraction (coverage_course_pages.candidates
--   ->'fee') is the reading of that page and equals both amounts.
--
-- Recurrence (why the old guard 5 is replaced): the old guard required the SS-007 hold, which Decision 1 does not use. The writer of both
--   fees is security.adapter_overwrite_v1 (job adapter-overwrite, :x9), which reads only bindings with read_status 'read'
--   (live: "where pg.read_status = 'read' and pg.identity_basis is not null"). contain-links-A.sql sets both bindings to 'page_refused' and
--   adds the e16_containment_a rejection. New guard 5 requires both. No award lane writes these fees: 116548M has no award row; 105122F's
--   adapter award row has register_check 'fail' (skipped by exit_awards_apply_v2). Live 12:26: no fee exclusion row, no pending Layer 4
--   item on either course.
-- Predicted consumer effect after the refresh: website item tuition (provider_annual_tuition_amount, tuition_history) and the Zoho tuition
--   fields drop 60,952 (116548M) and 42,900 (105122F); neither course has another active provider fee, so each shows no provider fee
--   ("no supported fee"); the CRICOS regulatory fields (171,150; 35,500) are unchanged.
-- Fee ids md5 (sorted, comma-joined): 1f4f7bd7501ff4eefd9f2705d6f91a88 (same as fees.sql F1; row md5s re-read unchanged 11:46).

begin;
do $e16f1$
declare v_n int; v_md5 text; v_before jsonb;
begin
  create temp table e16_f1(fee_id uuid, course_id uuid, row_md5 text, page_md5 text) on commit drop;
  insert into e16_f1 values
    ('69c6da38-c3b0-4a76-be90-242f047e05ae'::uuid, '1b78ba46-638c-4465-859e-8689e96295a8'::uuid, '2a972813141409d271bf9f6c091286bc', '186a2c6925bb18b1ee93dbcd40fdb261'),  -- 116548M 60,952 (2027); the double-degree page (116549K)
    ('7253f4a7-3138-44c0-9213-33468ce5dbe0'::uuid, '486ed99f-09f3-4ef5-9649-1dec1d9878d8'::uuid, '20528b758d89c0f8190a29b9c402e928', '5d71934397dccf31251b2c4f8ff4b4e8');  -- 105122F 42,900 (2026); the master's page (105121G)
  select count(distinct fee_id), md5(string_agg(fee_id::text, ',' order by fee_id)) into v_n, v_md5 from e16_f1;
  if v_n <> 2 or v_md5 <> '1f4f7bd7501ff4eefd9f2705d6f91a88' then raise exception 'E16 F1 guard 1: id set % / %', v_n, v_md5; end if;
  -- guard 2: each row is exactly as read on 2 Nov: md5(id|course|amount|year|status|evidence|valid_to), active provider fee
  select count(*) into v_n from e16_f1 e join catalogue.course_fees f on f.id = e.fee_id
   where f.course_id = e.course_id and md5(concat_ws('|', f.id, f.course_id, f.amount, f.fee_year, f.status, f.evidence_id, f.valid_to)) = e.row_md5
     and f.status = 'active' and f.fee_type = 'provider_current_tuition' and f.audience = 'international';
  if v_n <> 2 then raise exception 'E16 F1 guard 2: % of 2 rows unchanged since 2 Nov; nothing changed', v_n; end if;
  -- guard 3: the fee's own evidence is a copy of the wrong page (address without #section, md5)
  select count(*) into v_n from e16_f1 e join catalogue.course_fees f on f.id = e.fee_id join pipeline.evidence_artifacts a on a.id = f.evidence_id
   where md5(split_part(a.source_url, '#', 1)) = e.page_md5;
  if v_n <> 2 then raise exception 'E16 F1 guard 3: % of 2 fees still carry the wrong-page evidence', v_n; end if;
  -- guard 4: no fee lock set by hand
  select count(*) into v_n from pipeline.manual_locks k join e16_f1 e on k.entity = 'course' and k.entity_id = e.course_id and k.field in ('tuition', 'fee', 'fees');
  if v_n <> 0 then raise exception 'E16 F1 guard 4: % fee locks; stop and re-read', v_n; end if;
  -- guard 5 (replaces "requires the SS-007 hold"): group (a) containment ran - the wrong page carries the e16_containment_a rejection for
  -- this course, and the binding is no longer read_status 'read', so security.adapter_overwrite_v1 does not read it again
  select count(*) into v_n from e16_f1 e
   where exists (select 1 from pipeline.page_rejections r where r.course_id = e.course_id and md5(r.url) = e.page_md5
                   and r.source = 'e16_containment' and r.signals->>'tag' = 'e16_containment_a')
     and exists (select 1 from pipeline.coverage_course_pages p where p.course_id = e.course_id and md5(p.url) = e.page_md5 and p.read_status is distinct from 'read');
  if v_n <> 2 then raise exception 'E16 F1 guard 5: % of 2 courses are contained by contain-links-A.sql (rejection e16_containment_a and binding not read); run it first', v_n; end if;
  select jsonb_agg(to_jsonb(f) order by f.id) into v_before from catalogue.course_fees f join e16_f1 e on e.fee_id = f.id;
  perform set_config('cf.manual_edit', 'on', true);  -- fixed: the change is a recorded human decision, not a pipeline write
  update catalogue.course_fees f
     set status = 'inactive', updated_at = now(), valid_to = current_date,
         notes = concat_ws(' | ', f.notes, 'E16 withdrawn ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') ||
                 ' AEDT (F1): fee read from another programme page (adapter reading of the wrongly bound page); Decision 1, 2 Nov 2026')
   where f.id in (select fee_id from e16_f1) and f.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 2 then raise exception 'E16 F1: updated % rows, expected 2; rolled back', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'e16_fee_withdrawal', 'catalogue.course_fees',
          jsonb_build_object('part', 'F1', 'count', v_n, 'ids_md5', '1f4f7bd7501ff4eefd9f2705d6f91a88', 'reason', 'fee read from another programme page (adapter reading of the wrongly bound page)',
                             'source_check', jsonb_build_object('116548M', 'page = 116549K Bachelor of Nutrition Sciences / Master of Dietetics Studies, its fee 60,952 (2027); CRICOS 171,150 over 3 years',
                                                                '105122F', 'page = 105121G Master of Computer Science, its fee 42,900 (2026); CRICOS 35,500 for 1 year'),
                             'before', v_before, 'after', jsonb_build_object('status', 'inactive', 'valid_to', current_date),
                             'decision', 'Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 1; E16 final disposition 07:21 section 2 action 4',
                             'rollback', 'fees-F1.sql rollback block'), null);
  insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal F1 (2 fees)');
end $e16f1$;
select status, count(*) from catalogue.course_fees where id = any(array['69c6da38-c3b0-4a76-be90-242f047e05ae','7253f4a7-3138-44c0-9213-33468ce5dbe0']::uuid[]) group by 1;   -- expect 2 inactive
commit;
-- ROLLBACK F1:
-- begin;
-- do $e16f1r$ declare v_n int; begin
--   select count(*) into v_n from catalogue.course_fees where id = any(array['69c6da38-c3b0-4a76-be90-242f047e05ae','7253f4a7-3138-44c0-9213-33468ce5dbe0']::uuid[]) and status = 'inactive' and notes like '%E16 withdrawn % (F1)%';
--   if v_n <> 2 then raise exception 'E16 F1 rollback guard: % of 2 rows are in the withdrawn state', v_n; end if;
--   perform set_config('cf.manual_edit', 'on', true);  -- fixed: recorded human decision
--   update catalogue.course_fees set status = 'active', valid_to = null, updated_at = now(),
--          notes = notes || ' | E16 withdrawal F1 rolled back ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') || ' AEDT'
--    where id = any(array['69c6da38-c3b0-4a76-be90-242f047e05ae','7253f4a7-3138-44c0-9213-33468ce5dbe0']::uuid[]) and status = 'inactive';
--   get diagnostics v_n = row_count; if v_n <> 2 then raise exception 'E16 F1 rollback: updated %, expected 2', v_n; end if;
--   insert into pipeline.admin_control_events(area, action, target, detail, actor) values ('layer4', 'e16_fee_withdrawal_rollback', 'catalogue.course_fees', jsonb_build_object('part', 'F1', 'count', v_n, 'ids_md5', '1f4f7bd7501ff4eefd9f2705d6f91a88'), null);
--   insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal F1 rollback');
-- end $e16f1r$;
-- commit;
-- (both rows had valid_to null before; the rollback restores null)
