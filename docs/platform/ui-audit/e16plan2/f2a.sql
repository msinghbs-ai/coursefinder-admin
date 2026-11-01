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
