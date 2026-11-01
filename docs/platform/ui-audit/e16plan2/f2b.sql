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
