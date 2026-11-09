-- CF-247 E16 fee containment: withdraw provider fees whose only source is a wrong-programme page (E1 pattern: status 'inactive', note,
-- valid_to). PASTE FILE PREPARED READ-ONLY 2 NOV 2026 09:47 AEDT, AFTER SEARCH REFRESH #7725 (v2.15.402). NOT RUN. Not a migration.
-- Project fxcwkweaxjtknorudmwp only. Run as postgres in an allowed minute, after apply-hold.sql and contain-links.sql.
-- Authority: Platform Admin 2 Nov 2026 07:21, E16 final disposition section 2 action 4 ("suppress unsupported fees where provenance verifies a
--   wrong-course source, using approved reversible correction controls"); section 9 ("a course publishing another programme's fee is not"
--   acceptable). The E16 classification is a candidate assessment.
-- Scope: the 31 sibling-page fees of 2 Nov (all still active, unchanged ids). Each block below is independent.
--   F1  2 fees  adapter read of the wrong page (Flinders 105122F, UQ 116548M): the straight misreads. Withdraw.
--   F2 10 fees  copied from the parent award by exit_awards_apply_v2 on a link v2.15.402 now REFUSES (fees derived from a refused parent link
--               are unsupported). Split F2a (6, amount not consistent with the CRICOS register) and F2b (4, consistent: integrator, keep?).
--   F3 14 fees  copied from the parent award on a link v2.15.402 ACCEPTS, but contained by contain-links.sql part C1. Only if part C1 is run.
--               Split F3a (6 not consistent) and F3b (8 consistent with the register: integrator, keep?).
--   Not touched: 5 fees (RMIT 103217D, 103221H, 103222G, 103224E, 103226C): link accepted by v2.15.402 and no longer shown (the projection
--               shows the course's own page); all 5 consistent with the register. CRICOS 'tuition' rows on every course are kept.
-- "Consistent with the register": annual amount x the award's exit years (pipeline.course_exit_awards.exit_years) within 2% of the CRICOS
--   registered total tuition (catalogue.course_fees fee_type 'tuition', dataset cricos-courses.csv). That supports the amount, not the source.
-- After the refresh: the website item tuition (provider_annual_tuition_amount) and tuition_history, and the Zoho tuition fields, drop the
--   withdrawn amount; regulatory (CRICOS) fields are unchanged. UniMelb 085950F keeps its 2027 fee (508f19c7, 64,640, read from the 2027 fee
--   table, not touched); every other course in these blocks shows no provider fee ("no supported fee"), which the decision accepts.


-- ===== F1: fee read from another programme page (adapter misread) (2 fees) =====
-- Recurrence: the adapter read the fee from the page bound to the course. apply-hold.sql sets that binding to 'mismatch' and holds the
-- course; held courses are skipped by every read lane. Guard 5 requires the hold.
-- Fee ids md5 (sorted, comma-joined): 1f4f7bd7501ff4eefd9f2705d6f91a88
begin;
do $e16f1$
declare v_n int; v_md5 text; v_before jsonb;
begin
  create temp table e16_f1(fee_id uuid, course_id uuid, row_md5 text, page_md5 text) on commit drop;
  insert into e16_f1 values
    ('69c6da38-c3b0-4a76-be90-242f047e05ae'::uuid, '1b78ba46-638c-4465-859e-8689e96295a8'::uuid, '2a972813141409d271bf9f6c091286bc', '186a2c6925bb18b1ee93dbcd40fdb261'),  -- 116548M 60,952 (2027); adapter read of the wrong page
    ('7253f4a7-3138-44c0-9213-33468ce5dbe0'::uuid, '486ed99f-09f3-4ef5-9649-1dec1d9878d8'::uuid, '20528b758d89c0f8190a29b9c402e928', '5d71934397dccf31251b2c4f8ff4b4e8');  -- 105122F 42,900 (2026); adapter read of the wrong page
  select count(distinct fee_id), md5(string_agg(fee_id::text, ',' order by fee_id)) into v_n, v_md5 from e16_f1;
  if v_n <> 2 or v_md5 <> '1f4f7bd7501ff4eefd9f2705d6f91a88' then raise exception 'E16 F1 guard 1: id set % / %', v_n, v_md5; end if;
  -- guard 2: each row is exactly as read on 2 Nov 09:47 AEDT: md5(id|course|amount|year|status|evidence|valid_to), active provider fee
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
  -- guard 5: nothing writes the fee back (see the note above)
  select count(*) into v_n from e16_f1 e where not security.course_held_v1(e.course_id);
  if v_n <> 0 then raise exception 'E16 F1: % courses are not held; run apply-hold.sql first (the adapter re-reads the bound page)', v_n; end if;
  select jsonb_agg(to_jsonb(f) order by f.id) into v_before from catalogue.course_fees f join e16_f1 e on e.fee_id = f.id;
  perform set_config('cf.manual_edit', 'on', true);  -- fixed: the change is a recorded human decision, not a pipeline write
  update catalogue.course_fees f
     set status = 'inactive', updated_at = now(), valid_to = current_date,
         notes = concat_ws(' | ', f.notes, 'E16 withdrawn ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') ||
                 ' AEDT (F1): fee read from another programme page (adapter misread); E16 final disposition 2 Nov 2026')
   where f.id in (select fee_id from e16_f1) and f.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 2 then raise exception 'E16 F1: updated % rows, expected 2; rolled back', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'e16_fee_withdrawal', 'catalogue.course_fees',
          jsonb_build_object('part', 'F1', 'count', v_n, 'ids_md5', '1f4f7bd7501ff4eefd9f2705d6f91a88', 'reason', 'fee read from another programme page (adapter misread)',
                             'before', v_before, 'after', jsonb_build_object('status', 'inactive', 'valid_to', current_date),
                             'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2 action 4', 'rollback', 'fees.sql rollback block F1'), null);
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
-- (all rows had valid_to null before; the rollback restores null)


-- ===== F2a: fee copied from a parent award link the binding check refuses; amount not consistent with the CRICOS register (6 fees) =====
-- Recurrence: exit_awards_apply_v2 copies the parent fee only after the page check passes (line 28-37 'continue' comes before the fee code
-- at lines 43-57); for these courses the check refuses, so the fee is not written back. Guard 5 re-checks that live.
-- Fee ids md5 (sorted, comma-joined): f610aa83587da1ab073b5a43566af6a0
begin;
do $e16f2a$
declare v_n int; v_md5 text; v_before jsonb;
begin
  create temp table e16_f2a(fee_id uuid, course_id uuid, row_md5 text, page_md5 text) on commit drop;
  insert into e16_f2a values
    ('5802ffe3-a74b-474b-b532-dec6d89f1fb7'::uuid, '111079e4-ca8d-4a72-bca1-145a141e201d'::uuid, '4814d92fae1f591fc9b467a1a758342a', '489dfce134df8ec5a9da41d08a97c0fc'),  -- 082403B 43,000 (2027); CRICOS 41,999 for 1 yr: not consistent
    ('8d9a1c5d-8131-46a3-9404-7ff0c5968963'::uuid, '7e117900-eab0-4c4d-8104-11b9ffaf9b26'::uuid, '3fbe72923092c352052933493f423ac3', 'f254dbf229ef36fcfc7714bd5c0b50d2'),  -- 107421A 42,500 (2027); CRICOS 20,797 for 0.5 yr: not consistent
    ('8ecb865a-6d90-407c-beba-df39c5a83c62'::uuid, '4241f004-3144-4fd4-8468-960854850e38'::uuid, '384d5b726525bee4f4ce9238d9bbf4c9', '88c19bf35c7c0ab2707c8574ff3ecbf7'),  -- 043153E 44,800 (2027); CRICOS 43,000 for 1 yr: not consistent
    ('eb97e07d-1aca-499b-906f-b61064634f34'::uuid, '95fcd50f-257e-43d6-9920-f3599cacf374'::uuid, '91d3b34d7d7560dbd41a3edab7f86b50', 'f7d07ccd085a2c852a60aa35beb797c0'),  -- 114089E 41,000 (2027); CRICOS 39,999 for 1 yr: not consistent
    ('ed928df0-7176-4736-a726-67d4e2b47564'::uuid, '6d42acd7-35e9-4975-aa9f-2b7f400d341d'::uuid, '620e07142eade059424e475573fbc8b6', '6910946fb1520495be758cd07be2c9a8'),  -- 076022K 50,880 (2027); CRICOS 49,440 for 1 yr: not consistent
    ('fd2134f9-9c34-4ebd-800a-66c220f52a57'::uuid, 'da0667c1-9818-4ab3-bbf7-c047f5de404d'::uuid, 'a20ca0408b63096c4f3123665eb4c6a5', '24b97c2b854f31e7b9db4bc775a03f6c');  -- 102427B 43,000 (2027); CRICOS 41,400 for 1 yr: not consistent
  select count(distinct fee_id), md5(string_agg(fee_id::text, ',' order by fee_id)) into v_n, v_md5 from e16_f2a;
  if v_n <> 6 or v_md5 <> 'f610aa83587da1ab073b5a43566af6a0' then raise exception 'E16 F2a guard 1: id set % / %', v_n, v_md5; end if;
  -- guard 2: each row is exactly as read on 2 Nov 09:47 AEDT: md5(id|course|amount|year|status|evidence|valid_to), active provider fee
  select count(*) into v_n from e16_f2a e join catalogue.course_fees f on f.id = e.fee_id
   where f.course_id = e.course_id and md5(concat_ws('|', f.id, f.course_id, f.amount, f.fee_year, f.status, f.evidence_id, f.valid_to)) = e.row_md5
     and f.status = 'active' and f.fee_type = 'provider_current_tuition' and f.audience = 'international';
  if v_n <> 6 then raise exception 'E16 F2a guard 2: % of 6 rows unchanged since 2 Nov; nothing changed', v_n; end if;
  -- guard 3: the fee's own evidence is a copy of the wrong page (address without #section, md5)
  select count(*) into v_n from e16_f2a e join catalogue.course_fees f on f.id = e.fee_id join pipeline.evidence_artifacts a on a.id = f.evidence_id
   where md5(split_part(a.source_url, '#', 1)) = e.page_md5;
  if v_n <> 6 then raise exception 'E16 F2a guard 3: % of 6 fees still carry the wrong-page evidence', v_n; end if;
  -- guard 4: no fee lock set by hand
  select count(*) into v_n from pipeline.manual_locks k join e16_f2a e on k.entity = 'course' and k.entity_id = e.course_id and k.field in ('tuition', 'fee', 'fees');
  if v_n <> 0 then raise exception 'E16 F2a guard 4: % fee locks; stop and re-read', v_n; end if;
  -- guard 5: nothing writes the fee back (see the note above)
  select count(*) into v_n from e16_f2a e join catalogue.course_fees f on f.id = e.fee_id join pipeline.evidence_artifacts a on a.id = f.evidence_id
   join pipeline.course_exit_awards x on x.child_course_id = e.course_id and x.active
   where not security.page_refused_v1(e.course_id, x.page_url) and security.course_page_check_v1(e.course_id, x.page_url)->>'verdict' = 'pass';
  if v_n <> 0 then raise exception 'E16 F2a: % courses have an award link the lane would apply (and copy the fee) at :37', v_n; end if;
  select jsonb_agg(to_jsonb(f) order by f.id) into v_before from catalogue.course_fees f join e16_f2a e on e.fee_id = f.id;
  perform set_config('cf.manual_edit', 'on', true);  -- fixed: the change is a recorded human decision, not a pipeline write
  update catalogue.course_fees f
     set status = 'inactive', updated_at = now(), valid_to = current_date,
         notes = concat_ws(' | ', f.notes, 'E16 withdrawn ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') ||
                 ' AEDT (F2a): fee copied from a parent award link the binding check refuses; amount not consistent with the CRICOS register; E16 final disposition 2 Nov 2026')
   where f.id in (select fee_id from e16_f2a) and f.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 6 then raise exception 'E16 F2a: updated % rows, expected 6; rolled back', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'e16_fee_withdrawal', 'catalogue.course_fees',
          jsonb_build_object('part', 'F2a', 'count', v_n, 'ids_md5', 'f610aa83587da1ab073b5a43566af6a0', 'reason', 'fee copied from a parent award link the binding check refuses; amount not consistent with the CRICOS register',
                             'before', v_before, 'after', jsonb_build_object('status', 'inactive', 'valid_to', current_date),
                             'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2 action 4', 'rollback', 'fees.sql rollback block F2a'), null);
  insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal F2a (6 fees)');
end $e16f2a$;
select status, count(*) from catalogue.course_fees where id = any(array['5802ffe3-a74b-474b-b532-dec6d89f1fb7','8d9a1c5d-8131-46a3-9404-7ff0c5968963','8ecb865a-6d90-407c-beba-df39c5a83c62','eb97e07d-1aca-499b-906f-b61064634f34','ed928df0-7176-4736-a726-67d4e2b47564','fd2134f9-9c34-4ebd-800a-66c220f52a57']::uuid[]) group by 1;   -- expect 6 inactive
commit;
-- ROLLBACK F2a:
-- begin;
-- do $e16f2ar$ declare v_n int; begin
--   select count(*) into v_n from catalogue.course_fees where id = any(array['5802ffe3-a74b-474b-b532-dec6d89f1fb7','8d9a1c5d-8131-46a3-9404-7ff0c5968963','8ecb865a-6d90-407c-beba-df39c5a83c62','eb97e07d-1aca-499b-906f-b61064634f34','ed928df0-7176-4736-a726-67d4e2b47564','fd2134f9-9c34-4ebd-800a-66c220f52a57']::uuid[]) and status = 'inactive' and notes like '%E16 withdrawn % (F2a)%';
--   if v_n <> 6 then raise exception 'E16 F2a rollback guard: % of 6 rows are in the withdrawn state', v_n; end if;
--   perform set_config('cf.manual_edit', 'on', true);  -- fixed: recorded human decision
--   update catalogue.course_fees set status = 'active', valid_to = null, updated_at = now(),
--          notes = notes || ' | E16 withdrawal F2a rolled back ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') || ' AEDT'
--    where id = any(array['5802ffe3-a74b-474b-b532-dec6d89f1fb7','8d9a1c5d-8131-46a3-9404-7ff0c5968963','8ecb865a-6d90-407c-beba-df39c5a83c62','eb97e07d-1aca-499b-906f-b61064634f34','ed928df0-7176-4736-a726-67d4e2b47564','fd2134f9-9c34-4ebd-800a-66c220f52a57']::uuid[]) and status = 'inactive';
--   get diagnostics v_n = row_count; if v_n <> 6 then raise exception 'E16 F2a rollback: updated %, expected 6', v_n; end if;
--   insert into pipeline.admin_control_events(area, action, target, detail, actor) values ('layer4', 'e16_fee_withdrawal_rollback', 'catalogue.course_fees', jsonb_build_object('part', 'F2a', 'count', v_n, 'ids_md5', 'f610aa83587da1ab073b5a43566af6a0'), null);
--   insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal F2a rollback');
-- end $e16f2ar$;
-- commit;
-- (all rows had valid_to null before; the rollback restores null)


-- ===== F2b: fee copied from a parent award link the binding check refuses; amount consistent with the CRICOS register (integrator: keep?) (4 fees) =====
-- Recurrence: exit_awards_apply_v2 copies the parent fee only after the page check passes (line 28-37 'continue' comes before the fee code
-- at lines 43-57); for these courses the check refuses, so the fee is not written back. Guard 5 re-checks that live.
-- Fee ids md5 (sorted, comma-joined): 7e0c49476157592f76c05b1bcbd0db93
begin;
do $e16f2b$
declare v_n int; v_md5 text; v_before jsonb;
begin
  create temp table e16_f2b(fee_id uuid, course_id uuid, row_md5 text, page_md5 text) on commit drop;
  insert into e16_f2b values
    ('4b53cb71-d5a6-43f9-9073-c353a60e60bc'::uuid, '40afad92-5a55-47d8-88e3-2015c41d11af'::uuid, '3bc839c283a9b2943cb4b7821f9ba6ce', 'ea07f2246f4e61bae0905be99b9e8072'),  -- 014891M 50,880 (2027); CRICOS 50,880 for 1 yr: SUPPORTED BY THE REGISTER, KEEP?
    ('59b3859c-818e-4779-97e7-a3435528e9af'::uuid, '196a1939-628d-4e86-8e4f-f40e0858be2e'::uuid, 'd06471e31ab22ec839484b946577e0a5', '95ec8444c20658cf9301e6fe36fef337'),  -- 060584G 50,880 (2027); CRICOS 50,400 for 1 yr: SUPPORTED BY THE REGISTER, KEEP?
    ('712a5368-8841-435a-a3ac-5c6eb31a9a91'::uuid, '2d6d3d1c-8f6f-4455-8228-91d3f32ca491'::uuid, 'e254f9af23bef5e24c351fcb7a8e4d47', '512325ab968d069ff92be07fa6b2f5c9'),  -- 055528B 50,880 (2027); CRICOS 50,400 for 1 yr: SUPPORTED BY THE REGISTER, KEEP?
    ('8f6a080a-f8e5-49ae-8832-d971191885ab'::uuid, 'b86828bb-9b14-46b4-a9bc-50a8de61fa39'::uuid, 'b3baa138a2d0aa9c996c0d8f021bf531', '105176cb6b879f6e3277f226a3b28b11');  -- 031944F 50,976 (2026); CRICOS 25,280 for 0.5 yr: SUPPORTED BY THE REGISTER, KEEP?
  select count(distinct fee_id), md5(string_agg(fee_id::text, ',' order by fee_id)) into v_n, v_md5 from e16_f2b;
  if v_n <> 4 or v_md5 <> '7e0c49476157592f76c05b1bcbd0db93' then raise exception 'E16 F2b guard 1: id set % / %', v_n, v_md5; end if;
  -- guard 2: each row is exactly as read on 2 Nov 09:47 AEDT: md5(id|course|amount|year|status|evidence|valid_to), active provider fee
  select count(*) into v_n from e16_f2b e join catalogue.course_fees f on f.id = e.fee_id
   where f.course_id = e.course_id and md5(concat_ws('|', f.id, f.course_id, f.amount, f.fee_year, f.status, f.evidence_id, f.valid_to)) = e.row_md5
     and f.status = 'active' and f.fee_type = 'provider_current_tuition' and f.audience = 'international';
  if v_n <> 4 then raise exception 'E16 F2b guard 2: % of 4 rows unchanged since 2 Nov; nothing changed', v_n; end if;
  -- guard 3: the fee's own evidence is a copy of the wrong page (address without #section, md5)
  select count(*) into v_n from e16_f2b e join catalogue.course_fees f on f.id = e.fee_id join pipeline.evidence_artifacts a on a.id = f.evidence_id
   where md5(split_part(a.source_url, '#', 1)) = e.page_md5;
  if v_n <> 4 then raise exception 'E16 F2b guard 3: % of 4 fees still carry the wrong-page evidence', v_n; end if;
  -- guard 4: no fee lock set by hand
  select count(*) into v_n from pipeline.manual_locks k join e16_f2b e on k.entity = 'course' and k.entity_id = e.course_id and k.field in ('tuition', 'fee', 'fees');
  if v_n <> 0 then raise exception 'E16 F2b guard 4: % fee locks; stop and re-read', v_n; end if;
  -- guard 5: nothing writes the fee back (see the note above)
  select count(*) into v_n from e16_f2b e join catalogue.course_fees f on f.id = e.fee_id join pipeline.evidence_artifacts a on a.id = f.evidence_id
   join pipeline.course_exit_awards x on x.child_course_id = e.course_id and x.active
   where not security.page_refused_v1(e.course_id, x.page_url) and security.course_page_check_v1(e.course_id, x.page_url)->>'verdict' = 'pass';
  if v_n <> 0 then raise exception 'E16 F2b: % courses have an award link the lane would apply (and copy the fee) at :37', v_n; end if;
  select jsonb_agg(to_jsonb(f) order by f.id) into v_before from catalogue.course_fees f join e16_f2b e on e.fee_id = f.id;
  perform set_config('cf.manual_edit', 'on', true);  -- fixed: the change is a recorded human decision, not a pipeline write
  update catalogue.course_fees f
     set status = 'inactive', updated_at = now(), valid_to = current_date,
         notes = concat_ws(' | ', f.notes, 'E16 withdrawn ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') ||
                 ' AEDT (F2b): fee copied from a parent award link the binding check refuses; amount consistent with the CRICOS register (integrator: keep?); E16 final disposition 2 Nov 2026')
   where f.id in (select fee_id from e16_f2b) and f.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 4 then raise exception 'E16 F2b: updated % rows, expected 4; rolled back', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'e16_fee_withdrawal', 'catalogue.course_fees',
          jsonb_build_object('part', 'F2b', 'count', v_n, 'ids_md5', '7e0c49476157592f76c05b1bcbd0db93', 'reason', 'fee copied from a parent award link the binding check refuses; amount consistent with the CRICOS register (integrator: keep?)',
                             'before', v_before, 'after', jsonb_build_object('status', 'inactive', 'valid_to', current_date),
                             'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2 action 4', 'rollback', 'fees.sql rollback block F2b'), null);
  insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal F2b (4 fees)');
end $e16f2b$;
select status, count(*) from catalogue.course_fees where id = any(array['4b53cb71-d5a6-43f9-9073-c353a60e60bc','59b3859c-818e-4779-97e7-a3435528e9af','712a5368-8841-435a-a3ac-5c6eb31a9a91','8f6a080a-f8e5-49ae-8832-d971191885ab']::uuid[]) group by 1;   -- expect 4 inactive
commit;
-- ROLLBACK F2b:
-- begin;
-- do $e16f2br$ declare v_n int; begin
--   select count(*) into v_n from catalogue.course_fees where id = any(array['4b53cb71-d5a6-43f9-9073-c353a60e60bc','59b3859c-818e-4779-97e7-a3435528e9af','712a5368-8841-435a-a3ac-5c6eb31a9a91','8f6a080a-f8e5-49ae-8832-d971191885ab']::uuid[]) and status = 'inactive' and notes like '%E16 withdrawn % (F2b)%';
--   if v_n <> 4 then raise exception 'E16 F2b rollback guard: % of 4 rows are in the withdrawn state', v_n; end if;
--   perform set_config('cf.manual_edit', 'on', true);  -- fixed: recorded human decision
--   update catalogue.course_fees set status = 'active', valid_to = null, updated_at = now(),
--          notes = notes || ' | E16 withdrawal F2b rolled back ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') || ' AEDT'
--    where id = any(array['4b53cb71-d5a6-43f9-9073-c353a60e60bc','59b3859c-818e-4779-97e7-a3435528e9af','712a5368-8841-435a-a3ac-5c6eb31a9a91','8f6a080a-f8e5-49ae-8832-d971191885ab']::uuid[]) and status = 'inactive';
--   get diagnostics v_n = row_count; if v_n <> 4 then raise exception 'E16 F2b rollback: updated %, expected 4', v_n; end if;
--   insert into pipeline.admin_control_events(area, action, target, detail, actor) values ('layer4', 'e16_fee_withdrawal_rollback', 'catalogue.course_fees', jsonb_build_object('part', 'F2b', 'count', v_n, 'ids_md5', '7e0c49476157592f76c05b1bcbd0db93'), null);
--   insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal F2b rollback');
-- end $e16f2br$;
-- commit;
-- (all rows had valid_to null before; the rollback restores null)


-- ===== F3a: fee copied from a parent award link contained in E16 part C1; amount not consistent with the CRICOS register (6 fees) =====
-- Recurrence: v2.15.402 accepts these award links, so exit_awards_apply_v2 would copy the parent fee again (lines 43-57, written through
-- coverage_apply_course_v1's fee upsert, which sets status 'active'). Only after contain-links.sql part C1 (page rejection, line 25)
-- does it stop. Guard 5 requires the rejection. If part C1 is not run, do not run F3.
-- Fee ids md5 (sorted, comma-joined): 910964308e8eddf9facbc98adf91cc4a
begin;
do $e16f3a$
declare v_n int; v_md5 text; v_before jsonb;
begin
  create temp table e16_f3a(fee_id uuid, course_id uuid, row_md5 text, page_md5 text) on commit drop;
  insert into e16_f3a values
    ('191d4b0e-bbba-4c36-bc18-102fc00c5906'::uuid, '283a0dd2-0101-45c0-8a09-b0441f51d783'::uuid, 'e7fd72e568460990efdae08d19cd65a0', 'fc8acb4d10ed7849faa2582e506771d2'),  -- 103218C 54,060 (2027); CRICOS 50,880 for 1 yr: not consistent
    ('266cfa9b-802f-42a5-91b4-288f526a6cfa'::uuid, 'ebfc236d-1c66-4f5b-bd4d-815ad7655e33'::uuid, '9aeb8a6f65d07b519ba56a1889cbf7ef', '19f1d1a470c5058bace5c8ea2ad67b87'),  -- 046442E 41,000 (2027); CRICOS 20,047 for 0.5 yr: not consistent
    ('36fb521a-a62b-4749-9aed-d3f099f78e7e'::uuid, 'e1596a78-53ad-463f-bd1a-1442109c6ac3'::uuid, 'f0009f0828308e7b4228ea2cfc7940df', '89f5f9341df1b8c52d45f90cae623f23'),  -- 0101621 47,000 (2027); CRICOS 21,047 for 0.5 yr: not consistent
    ('37b7a8f9-aa04-42a6-8114-acb9ca8274bc'::uuid, '2cf5c4ac-b56d-44e2-b69e-93b6ce39a475'::uuid, 'b3423927a0f2e55d52cf1c180a7e676e', 'f7d07ccd085a2c852a60aa35beb797c0'),  -- 114091M 41,000 (2027); CRICOS 20,047 for 0.5 yr: not consistent
    ('6462dc9f-8a18-4ae9-82f3-4d6b3f2926c2'::uuid, '264c5b84-eff8-49ac-b03f-c8cf12708198'::uuid, 'd41c93ed4613c041a45f44d685c83d51', '74f2609f1e2a50db73295ac61b28bedf'),  -- 061457F 46,500 (2027); CRICOS 21,797 for 0.5 yr: not consistent
    ('67841648-642d-434c-a923-e4a9327a8ab3'::uuid, 'fa955ff0-37d1-4c91-826a-89c812cde021'::uuid, '18004ee34e0bb52d877741eecb18c9de', '1b4fd695e3a0ec37ab9463b99a048311');  -- 085950F 60,992 (2026); CRICOS 32,320 for 0.5 yr: not consistent
  select count(distinct fee_id), md5(string_agg(fee_id::text, ',' order by fee_id)) into v_n, v_md5 from e16_f3a;
  if v_n <> 6 or v_md5 <> '910964308e8eddf9facbc98adf91cc4a' then raise exception 'E16 F3a guard 1: id set % / %', v_n, v_md5; end if;
  -- guard 2: each row is exactly as read on 2 Nov 09:47 AEDT: md5(id|course|amount|year|status|evidence|valid_to), active provider fee
  select count(*) into v_n from e16_f3a e join catalogue.course_fees f on f.id = e.fee_id
   where f.course_id = e.course_id and md5(concat_ws('|', f.id, f.course_id, f.amount, f.fee_year, f.status, f.evidence_id, f.valid_to)) = e.row_md5
     and f.status = 'active' and f.fee_type = 'provider_current_tuition' and f.audience = 'international';
  if v_n <> 6 then raise exception 'E16 F3a guard 2: % of 6 rows unchanged since 2 Nov; nothing changed', v_n; end if;
  -- guard 3: the fee's own evidence is a copy of the wrong page (address without #section, md5)
  select count(*) into v_n from e16_f3a e join catalogue.course_fees f on f.id = e.fee_id join pipeline.evidence_artifacts a on a.id = f.evidence_id
   where md5(split_part(a.source_url, '#', 1)) = e.page_md5;
  if v_n <> 6 then raise exception 'E16 F3a guard 3: % of 6 fees still carry the wrong-page evidence', v_n; end if;
  -- guard 4: no fee lock set by hand
  select count(*) into v_n from pipeline.manual_locks k join e16_f3a e on k.entity = 'course' and k.entity_id = e.course_id and k.field in ('tuition', 'fee', 'fees');
  if v_n <> 0 then raise exception 'E16 F3a guard 4: % fee locks; stop and re-read', v_n; end if;
  -- guard 5: nothing writes the fee back (see the note above)
  select count(*) into v_n from e16_f3a e join pipeline.course_exit_awards x on x.child_course_id = e.course_id and x.active
   where not security.page_refused_v1(e.course_id, x.page_url);
  if v_n <> 0 then raise exception 'E16 F3a: % courses are not yet contained by contain-links.sql part C1 (no page rejection)', v_n; end if;
  select jsonb_agg(to_jsonb(f) order by f.id) into v_before from catalogue.course_fees f join e16_f3a e on e.fee_id = f.id;
  perform set_config('cf.manual_edit', 'on', true);  -- fixed: the change is a recorded human decision, not a pipeline write
  update catalogue.course_fees f
     set status = 'inactive', updated_at = now(), valid_to = current_date,
         notes = concat_ws(' | ', f.notes, 'E16 withdrawn ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') ||
                 ' AEDT (F3a): fee copied from a parent award link contained in E16 part C1; amount not consistent with the CRICOS register; E16 final disposition 2 Nov 2026')
   where f.id in (select fee_id from e16_f3a) and f.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 6 then raise exception 'E16 F3a: updated % rows, expected 6; rolled back', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'e16_fee_withdrawal', 'catalogue.course_fees',
          jsonb_build_object('part', 'F3a', 'count', v_n, 'ids_md5', '910964308e8eddf9facbc98adf91cc4a', 'reason', 'fee copied from a parent award link contained in E16 part C1; amount not consistent with the CRICOS register',
                             'before', v_before, 'after', jsonb_build_object('status', 'inactive', 'valid_to', current_date),
                             'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2 action 4', 'rollback', 'fees.sql rollback block F3a'), null);
  insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal F3a (6 fees)');
end $e16f3a$;
select status, count(*) from catalogue.course_fees where id = any(array['191d4b0e-bbba-4c36-bc18-102fc00c5906','266cfa9b-802f-42a5-91b4-288f526a6cfa','36fb521a-a62b-4749-9aed-d3f099f78e7e','37b7a8f9-aa04-42a6-8114-acb9ca8274bc','6462dc9f-8a18-4ae9-82f3-4d6b3f2926c2','67841648-642d-434c-a923-e4a9327a8ab3']::uuid[]) group by 1;   -- expect 6 inactive
commit;
-- ROLLBACK F3a:
-- begin;
-- do $e16f3ar$ declare v_n int; begin
--   select count(*) into v_n from catalogue.course_fees where id = any(array['191d4b0e-bbba-4c36-bc18-102fc00c5906','266cfa9b-802f-42a5-91b4-288f526a6cfa','36fb521a-a62b-4749-9aed-d3f099f78e7e','37b7a8f9-aa04-42a6-8114-acb9ca8274bc','6462dc9f-8a18-4ae9-82f3-4d6b3f2926c2','67841648-642d-434c-a923-e4a9327a8ab3']::uuid[]) and status = 'inactive' and notes like '%E16 withdrawn % (F3a)%';
--   if v_n <> 6 then raise exception 'E16 F3a rollback guard: % of 6 rows are in the withdrawn state', v_n; end if;
--   perform set_config('cf.manual_edit', 'on', true);  -- fixed: recorded human decision
--   update catalogue.course_fees set status = 'active', valid_to = null, updated_at = now(),
--          notes = notes || ' | E16 withdrawal F3a rolled back ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') || ' AEDT'
--    where id = any(array['191d4b0e-bbba-4c36-bc18-102fc00c5906','266cfa9b-802f-42a5-91b4-288f526a6cfa','36fb521a-a62b-4749-9aed-d3f099f78e7e','37b7a8f9-aa04-42a6-8114-acb9ca8274bc','6462dc9f-8a18-4ae9-82f3-4d6b3f2926c2','67841648-642d-434c-a923-e4a9327a8ab3']::uuid[]) and status = 'inactive';
--   get diagnostics v_n = row_count; if v_n <> 6 then raise exception 'E16 F3a rollback: updated %, expected 6', v_n; end if;
--   insert into pipeline.admin_control_events(area, action, target, detail, actor) values ('layer4', 'e16_fee_withdrawal_rollback', 'catalogue.course_fees', jsonb_build_object('part', 'F3a', 'count', v_n, 'ids_md5', '910964308e8eddf9facbc98adf91cc4a'), null);
--   insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal F3a rollback');
-- end $e16f3ar$;
-- commit;
-- (all rows had valid_to null before; the rollback restores null)


-- ===== F3b: fee copied from a parent award link contained in E16 part C1; amount consistent with the CRICOS register (integrator: keep?) (8 fees) =====
-- Recurrence: v2.15.402 accepts these award links, so exit_awards_apply_v2 would copy the parent fee again (lines 43-57, written through
-- coverage_apply_course_v1's fee upsert, which sets status 'active'). Only after contain-links.sql part C1 (page rejection, line 25)
-- does it stop. Guard 5 requires the rejection. If part C1 is not run, do not run F3.
-- Fee ids md5 (sorted, comma-joined): 38f268e6bcaba0cf977a4a6aff50856d
begin;
do $e16f3b$
declare v_n int; v_md5 text; v_before jsonb;
begin
  create temp table e16_f3b(fee_id uuid, course_id uuid, row_md5 text, page_md5 text) on commit drop;
  insert into e16_f3b values
    ('34b2de4c-7f3b-4016-8850-e6c19c60f680'::uuid, 'cdc06d73-f08b-40fc-9d30-1700df678e62'::uuid, '7299233a0750d9a231b84f3b2f8efede', '54c4362ebb50b60463f76cb2e6a33683'),  -- 103228A 41,280 (2027); CRICOS 41,280 for 1 yr: SUPPORTED BY THE REGISTER, KEEP?
    ('4942e2ea-c735-427a-b4c9-0f29a58a9866'::uuid, 'ff63eb8b-2705-4db7-8500-1db2c548216a'::uuid, '9c03897bfac307a88c297536d1f0575a', '6a052f4d1d4ba4ccf7d9a56c9ec50162'),  -- 103223F 45,120 (2027); CRICOS 45,120 for 1 yr: SUPPORTED BY THE REGISTER, KEEP?
    ('98cc7c9b-a8b6-4b95-853a-22570d478223'::uuid, 'b2226705-305a-4e88-9af5-fd8b404239c5'::uuid, '3f4aca03268a38f3e879995a80d8718c', 'b6c5493599a073302ff7ee9774ea03c5'),  -- 121356K 27,000 (2026); CRICOS 27,000 for 1 yr: SUPPORTED BY THE REGISTER, KEEP?
    ('9f056cbf-f183-469d-959a-556cd122ce92'::uuid, '6b5874f1-770f-4000-9614-56a6df194724'::uuid, '53fe9695dacb84a25d8560f606ef079e', '7cadcf8d9fcbfb7215eb4ef0bd4f8b9c'),  -- 103236A 43,200 (2027); CRICOS 43,200 for 1 yr: SUPPORTED BY THE REGISTER, KEEP?
    ('9fbb1d35-1e83-45f8-999b-936ad132173f'::uuid, 'd25f60bb-bd10-4956-8337-cdefdff8b1ce'::uuid, 'f5802f33282a5c70c648ea2b725daaae', '43cd714c3f5ee57e1e2f3cb7afb770a3'),  -- 103229M 50,880 (2027); CRICOS 50,880 for 1 yr: SUPPORTED BY THE REGISTER, KEEP?
    ('e630b018-ec0f-4b8a-ad9d-f95aadb1f662'::uuid, 'ba8d7def-6f2e-48aa-a314-70603abe8d9c'::uuid, 'b45c7deaedd992a3e86fbfa6ee9153bf', '77d0fe215243fac3019b2c85a2bebf73'),  -- 103220J 45,120 (2027); CRICOS 45,120 for 1 yr: SUPPORTED BY THE REGISTER, KEEP?
    ('f14eb0b2-9d1c-4cc8-8e81-efc6358f0e6a'::uuid, 'de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd'::uuid, 'f7f151dc4f25618f2d30131522192523', '1096cfa202d89bd69260832e2f5a9b39'),  -- 103227B 41,280 (2027); CRICOS 41,280 for 1 yr: SUPPORTED BY THE REGISTER, KEEP?
    ('fd5c87a9-11ec-47f2-a0e6-e09e3b9a2a95'::uuid, '60ebab30-d9a8-47f9-bf7f-85aebc49039f'::uuid, '8445b62cd3d132c651b764c96b030af3', 'd0d8d0ada29b388fd4ae3c4df73f0672');  -- 104982C 48,960 (2027); CRICOS 48,960 for 1 yr: SUPPORTED BY THE REGISTER, KEEP?
  select count(distinct fee_id), md5(string_agg(fee_id::text, ',' order by fee_id)) into v_n, v_md5 from e16_f3b;
  if v_n <> 8 or v_md5 <> '38f268e6bcaba0cf977a4a6aff50856d' then raise exception 'E16 F3b guard 1: id set % / %', v_n, v_md5; end if;
  -- guard 2: each row is exactly as read on 2 Nov 09:47 AEDT: md5(id|course|amount|year|status|evidence|valid_to), active provider fee
  select count(*) into v_n from e16_f3b e join catalogue.course_fees f on f.id = e.fee_id
   where f.course_id = e.course_id and md5(concat_ws('|', f.id, f.course_id, f.amount, f.fee_year, f.status, f.evidence_id, f.valid_to)) = e.row_md5
     and f.status = 'active' and f.fee_type = 'provider_current_tuition' and f.audience = 'international';
  if v_n <> 8 then raise exception 'E16 F3b guard 2: % of 8 rows unchanged since 2 Nov; nothing changed', v_n; end if;
  -- guard 3: the fee's own evidence is a copy of the wrong page (address without #section, md5)
  select count(*) into v_n from e16_f3b e join catalogue.course_fees f on f.id = e.fee_id join pipeline.evidence_artifacts a on a.id = f.evidence_id
   where md5(split_part(a.source_url, '#', 1)) = e.page_md5;
  if v_n <> 8 then raise exception 'E16 F3b guard 3: % of 8 fees still carry the wrong-page evidence', v_n; end if;
  -- guard 4: no fee lock set by hand
  select count(*) into v_n from pipeline.manual_locks k join e16_f3b e on k.entity = 'course' and k.entity_id = e.course_id and k.field in ('tuition', 'fee', 'fees');
  if v_n <> 0 then raise exception 'E16 F3b guard 4: % fee locks; stop and re-read', v_n; end if;
  -- guard 5: nothing writes the fee back (see the note above)
  select count(*) into v_n from e16_f3b e join pipeline.course_exit_awards x on x.child_course_id = e.course_id and x.active
   where not security.page_refused_v1(e.course_id, x.page_url);
  if v_n <> 0 then raise exception 'E16 F3b: % courses are not yet contained by contain-links.sql part C1 (no page rejection)', v_n; end if;
  select jsonb_agg(to_jsonb(f) order by f.id) into v_before from catalogue.course_fees f join e16_f3b e on e.fee_id = f.id;
  perform set_config('cf.manual_edit', 'on', true);  -- fixed: the change is a recorded human decision, not a pipeline write
  update catalogue.course_fees f
     set status = 'inactive', updated_at = now(), valid_to = current_date,
         notes = concat_ws(' | ', f.notes, 'E16 withdrawn ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') ||
                 ' AEDT (F3b): fee copied from a parent award link contained in E16 part C1; amount consistent with the CRICOS register (integrator: keep?); E16 final disposition 2 Nov 2026')
   where f.id in (select fee_id from e16_f3b) and f.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 8 then raise exception 'E16 F3b: updated % rows, expected 8; rolled back', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'e16_fee_withdrawal', 'catalogue.course_fees',
          jsonb_build_object('part', 'F3b', 'count', v_n, 'ids_md5', '38f268e6bcaba0cf977a4a6aff50856d', 'reason', 'fee copied from a parent award link contained in E16 part C1; amount consistent with the CRICOS register (integrator: keep?)',
                             'before', v_before, 'after', jsonb_build_object('status', 'inactive', 'valid_to', current_date),
                             'decision', 'E16 final disposition, Platform Admin 2 Nov 2026 07:21, section 2 action 4', 'rollback', 'fees.sql rollback block F3b'), null);
  insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal F3b (8 fees)');
end $e16f3b$;
select status, count(*) from catalogue.course_fees where id = any(array['34b2de4c-7f3b-4016-8850-e6c19c60f680','4942e2ea-c735-427a-b4c9-0f29a58a9866','98cc7c9b-a8b6-4b95-853a-22570d478223','9f056cbf-f183-469d-959a-556cd122ce92','9fbb1d35-1e83-45f8-999b-936ad132173f','e630b018-ec0f-4b8a-ad9d-f95aadb1f662','f14eb0b2-9d1c-4cc8-8e81-efc6358f0e6a','fd5c87a9-11ec-47f2-a0e6-e09e3b9a2a95']::uuid[]) group by 1;   -- expect 8 inactive
commit;
-- ROLLBACK F3b:
-- begin;
-- do $e16f3br$ declare v_n int; begin
--   select count(*) into v_n from catalogue.course_fees where id = any(array['34b2de4c-7f3b-4016-8850-e6c19c60f680','4942e2ea-c735-427a-b4c9-0f29a58a9866','98cc7c9b-a8b6-4b95-853a-22570d478223','9f056cbf-f183-469d-959a-556cd122ce92','9fbb1d35-1e83-45f8-999b-936ad132173f','e630b018-ec0f-4b8a-ad9d-f95aadb1f662','f14eb0b2-9d1c-4cc8-8e81-efc6358f0e6a','fd5c87a9-11ec-47f2-a0e6-e09e3b9a2a95']::uuid[]) and status = 'inactive' and notes like '%E16 withdrawn % (F3b)%';
--   if v_n <> 8 then raise exception 'E16 F3b rollback guard: % of 8 rows are in the withdrawn state', v_n; end if;
--   perform set_config('cf.manual_edit', 'on', true);  -- fixed: recorded human decision
--   update catalogue.course_fees set status = 'active', valid_to = null, updated_at = now(),
--          notes = notes || ' | E16 withdrawal F3b rolled back ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') || ' AEDT'
--    where id = any(array['34b2de4c-7f3b-4016-8850-e6c19c60f680','4942e2ea-c735-427a-b4c9-0f29a58a9866','98cc7c9b-a8b6-4b95-853a-22570d478223','9f056cbf-f183-469d-959a-556cd122ce92','9fbb1d35-1e83-45f8-999b-936ad132173f','e630b018-ec0f-4b8a-ad9d-f95aadb1f662','f14eb0b2-9d1c-4cc8-8e81-efc6358f0e6a','fd5c87a9-11ec-47f2-a0e6-e09e3b9a2a95']::uuid[]) and status = 'inactive';
--   get diagnostics v_n = row_count; if v_n <> 8 then raise exception 'E16 F3b rollback: updated %, expected 8', v_n; end if;
--   insert into pipeline.admin_control_events(area, action, target, detail, actor) values ('layer4', 'e16_fee_withdrawal_rollback', 'catalogue.course_fees', jsonb_build_object('part', 'F3b', 'count', v_n, 'ids_md5', '38f268e6bcaba0cf977a4a6aff50856d'), null);
--   insert into search.refresh_requests(requested_by) values ('E16 fee withdrawal F3b rollback');
-- end $e16f3br$;
-- commit;
-- (all rows had valid_to null before; the rollback restores null)
