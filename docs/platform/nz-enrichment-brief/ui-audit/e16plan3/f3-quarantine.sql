-- CF-247 E16 F3 (Decision 2): quarantine the ONE C1 fee with independent evidence that the amount is another programme's, and route it to
-- Layer 4. PREPARED READ-ONLY 2 NOV 2026 12:40 AEDT. NOT RUN. Not a migration. Project fxcwkweaxjtknorudmwp only. Run as postgres in an
-- allowed minute (:x6-:x8 with today's stagger), not :35-:42 and not in the 3 minutes before :37 (exit-awards-apply).
-- Authority: Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 2 ("F3's 14 associated fees must follow their own
--   provenance and applicability assessment. Do not automatically withdraw all 14"; "Where independent evidence establishes a wrong
--   programme ... quarantine that specific [value] and route it to Layer 4").
-- Assessment of all 14: f3-assessment.csv (11 keep, 1 independent evidence, 2 unclear). The C1 award LINK of 0101621 is retained
--   (Decision 2: v2.15.402 accepts it, rule award_on_parent_page, re-checked live 12:16). Only the fee is quarantined.
--
-- 0101621 Graduate Certificate in International Law (Griffith), fee 36fb521a 47,000 AUD annual (2027), copied by exit_awards_apply_v2 from
--   parent 099995M Master of International Law Studies (page .../master-of-international-law-studies-5738, evidence 1afa1229).
--   Independent evidence: CRICOS registered total for THIS programme 21,047 for 0.5 year (42,094 a year); the copied whole fee is 23,500
--   (+11.7%), still about +8.7% after one year's indexation (register 20,500 -> 21,047). The award lane's own register check is 'fail'
--   (-10.4%, allowed -6.0% to +2.0%); the lane copied it only because the award row was recorded by hand. The programme has its own page
--   held (graduate-certificate-in-international-law-3354). The amount is the parent's rate, not this programme's.
-- Recurrence: exit_awards_apply_v2 (live md5 e7080925ba79eef320f361bf236cb072) re-copies the parent fee whenever the child has no active
--   fee of that year equal to it ("... is distinct from v_fee.amount"), so a withdrawal alone is undone at the next :37. Its only per-course
--   stop that keeps the link is "not security.uni_adapter_excluded(r.child_course_id, 'fee')" (pipeline.uni_adapter_exclusions, PK
--   (course_id, field), field 'fee'), the existing governed exclusion that the adapter fee branch also honours. Live 12:16: none on 0101621.
-- Quarantine state: status 'unverified' with one pending Layer 4 item, field provider_current_tuition (the R1 identity-gate shape of
--   security.course_fee_identity_gate_tg, which the inbox decides with "Admit this fee / Do not admit this fee"). Live 12:26: no pending item.
-- Predicted consumer effect after the refresh: 0101621 drops the provider fee 47,000 (2027) from website tuition and Zoho tuition fields;
--   the CRICOS regulatory total 21,047 stays; the official link (the parent's page, retained under Decision 2) is unchanged.
-- Fee ids md5: f01b7ee058f278f298f9ca62f9d06ff2.

begin;
do $e16f3q$
declare v_n int; v_md5 text; v_before jsonb; v_item uuid;
begin
  create temp table e16_f3q(fee_id uuid, course_id uuid, provider_id uuid, row_md5 text, page_md5 text) on commit drop;
  insert into e16_f3q values
    ('36fb521a-a62b-4749-9aed-d3f099f78e7e'::uuid, 'e1596a78-53ad-463f-bd1a-1442109c6ac3'::uuid, '36086f5e-9fe0-4878-aa40-1897a7d8cb24'::uuid,
     'f0009f0828308e7b4228ea2cfc7940df', '89f5f9341df1b8c52d45f90cae623f23');  -- 0101621 47,000 (2027); CRICOS 21,047 for 0.5 yr
  select count(distinct fee_id), md5(string_agg(fee_id::text, ',' order by fee_id)) into v_n, v_md5 from e16_f3q;
  if v_n <> 1 or v_md5 <> 'f01b7ee058f278f298f9ca62f9d06ff2' then raise exception 'E16 F3Q guard 1: id set % / %', v_n, v_md5; end if;
  -- guard 2: the row is exactly as read on 2 Nov 11:46 (md5 id|course|amount|year|status|evidence|valid_to), active provider fee
  select count(*) into v_n from e16_f3q e join catalogue.course_fees f on f.id = e.fee_id
   where f.course_id = e.course_id and md5(concat_ws('|', f.id, f.course_id, f.amount, f.fee_year, f.status, f.evidence_id, f.valid_to)) = e.row_md5
     and f.status = 'active' and f.fee_type = 'provider_current_tuition' and f.audience = 'international';
  if v_n <> 1 then raise exception 'E16 F3Q guard 2: row changed since 2 Nov; nothing changed'; end if;
  -- guard 3: the fee's evidence is the parent's page copy, and the award row is still the hand-recorded one with register_check 'fail'
  select count(*) into v_n from e16_f3q e join catalogue.course_fees f on f.id = e.fee_id join pipeline.evidence_artifacts a on a.id = f.evidence_id
    join pipeline.course_exit_awards x on x.child_course_id = e.course_id and x.active and md5(x.page_url) = e.page_md5
   where md5(split_part(a.source_url, '#', 1)) = e.page_md5 and x.set_by = 'hand' and x.register_check = 'fail';
  if v_n <> 1 then raise exception 'E16 F3Q guard 3: evidence or award row differs from 2 Nov; re-read'; end if;
  -- guard 4: the CRICOS register still says 21,047 (active) for this course
  select count(*) into v_n from catalogue.course_fees t join e16_f3q e on e.course_id = t.course_id
   where t.fee_type = 'tuition' and t.status = 'active' and t.amount = 21047;
  if v_n <> 1 then raise exception 'E16 F3Q guard 4: CRICOS registered total changed; re-assess'; end if;
  -- guard 5: no fee lock by hand, no fee exclusion yet, no pending fee item
  select count(*) into v_n from pipeline.manual_locks k join e16_f3q e on k.entity = 'course' and k.entity_id = e.course_id and k.field in ('tuition', 'fee', 'fees');
  if v_n <> 0 then raise exception 'E16 F3Q guard 5: % fee locks; stop', v_n; end if;
  select count(*) into v_n from pipeline.uni_adapter_exclusions x join e16_f3q e on e.course_id = x.course_id and x.field = 'fee';
  if v_n <> 0 then raise exception 'E16 F3Q guard 5b: a fee exclusion row already exists; re-read'; end if;
  select count(*) into v_n from pipeline.layer4_review_items i join e16_f3q e on e.course_id = i.entity_id
   where i.entity_type = 'course' and i.field_code in ('provider_current_tuition', 'provider_current_tuition_validation') and i.status = 'pending';
  if v_n <> 0 then raise exception 'E16 F3Q guard 5c: % pending fee items; reuse them instead', v_n; end if;

  select jsonb_agg(to_jsonb(f) order by f.id) into v_before from catalogue.course_fees f join e16_f3q e on e.fee_id = f.id;
  perform set_config('cf.manual_edit', 'on', true);  -- fixed: the change is a recorded human decision, not a pipeline write
  update catalogue.course_fees f
     set status = 'unverified', updated_at = now(),
         notes = concat_ws(' | ', f.notes, 'E16 quarantined ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') ||
                 ' AEDT (F3): the parent master''s annual fee; this programme''s CRICOS registered total (21,047 for 0.5 year) differs by more than one year''s indexation; Layer 4 review; Decision 2, 2 Nov 2026')
   where f.id in (select fee_id from e16_f3q) and f.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 1 then raise exception 'E16 F3Q: updated % rows, expected 1; rolled back', v_n; end if;
  -- the award lane and the adapter do not copy a fee onto this course again until the exclusion is lifted (the link is not touched)
  insert into pipeline.uni_adapter_exclusions(course_id, field, provider_id, active, reason, set_by, set_at)
  select e.course_id, 'fee', e.provider_id, true,
         'E16 F3 (Decision 2, Platform Admin 2 Nov 2026 10:56): the parent''s fee does not apply (CRICOS register differs); held for Layer 4 fee review', null, now()
    from e16_f3q e;
  get diagnostics v_n = row_count;
  if v_n <> 1 then raise exception 'E16 F3Q: % exclusions written, expected 1; rolled back', v_n; end if;
  -- one Layer 4 fee item (R1 shape), one at a time per course
  perform pg_advisory_xact_lock(hashtext('layer4 fee ' || 'e1596a78-53ad-463f-bd1a-1442109c6ac3'));
  insert into pipeline.layer4_review_items(entity_type, entity_id, field_code, evidence_id, before_value, proposed_value, layer2_state, layer3_state, status, escalation_reason, change_control_ref)
  select 'course', e.course_id, 'provider_current_tuition', f.evidence_id, null,
         jsonb_build_object('amount', f.amount, 'currency', f.currency_code, 'basis', f.basis, 'fee_year', f.fee_year, 'page', a.source_url),
         jsonb_build_object('source', 'e16_f3_assessment', 'state', 'quarantined', 'fee_id', f.id, 'register_total', 21047, 'register_years', 0.5,
                            'award_of', '099995M', 'award_register_check', 'fail'),
         '{}'::jsonb, 'pending',
         'Quarantined: this fee is the parent master''s annual fee (47,000), copied to the Graduate Certificate as an exit award. The CRICOS register gives this programme 21,047 for half a year, which does not fit. If the programme''s own page states this fee, admit it; otherwise do not admit it.',
         'CF-CHG-20260915-247; E16 Decision 2 (Platform Admin 2 Nov 2026 10:56)'
    from e16_f3q e join catalogue.course_fees f on f.id = e.fee_id left join pipeline.evidence_artifacts a on a.id = f.evidence_id
  returning id into v_item;
  if v_item is null then raise exception 'E16 F3Q: no Layer 4 item written; rolled back'; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer4', 'e16_fee_quarantine', 'catalogue.course_fees',
          jsonb_build_object('part', 'F3Q', 'count', 1, 'ids_md5', 'f01b7ee058f278f298f9ca62f9d06ff2', 'layer4_item', v_item,
                             'reason', 'independent evidence (CRICOS register) that the copied parent fee is not this programme''s',
                             'before', v_before, 'after', jsonb_build_object('status', 'unverified', 'fee_exclusion', true),
                             'decision', 'Platform Admin consolidated decision pack 2 Nov 2026 10:56, Decision 2', 'rollback', 'f3-quarantine.sql rollback block'), null);
  insert into search.refresh_requests(requested_by) values ('E16 fee quarantine F3 (1 fee, 0101621)');
end $e16f3q$;
select f.status, (select count(*) from pipeline.uni_adapter_exclusions x where x.course_id = f.course_id and x.field = 'fee' and x.active) excl,
       (select count(*) from pipeline.layer4_review_items i where i.entity_type = 'course' and i.entity_id = f.course_id and i.field_code = 'provider_current_tuition' and i.status = 'pending') items
  from catalogue.course_fees f where f.id = '36fb521a-a62b-4749-9aed-d3f099f78e7e';   -- expect unverified, 1, 1
commit;
-- After the next :37 (exit-awards-apply), recurrence test: the fee is still 'unverified' and no new active provider fee exists on 0101621.

-- ROLLBACK F3Q (Platform Admin): restore the fee, lift the exclusion, settle the item:
-- begin;
-- do $e16f3qr$ declare v_n int; begin
--   perform set_config('cf.manual_edit', 'on', true);  -- fixed: recorded human decision
--   update catalogue.course_fees set status = 'active', updated_at = now(),
--          notes = notes || ' | E16 quarantine F3 rolled back ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') || ' AEDT'
--    where id = '36fb521a-a62b-4749-9aed-d3f099f78e7e' and status = 'unverified' and notes like '%E16 quarantined % (F3)%';
--   get diagnostics v_n = row_count; if v_n <> 1 then raise exception 'E16 F3Q rollback: updated %, expected 1', v_n; end if;
--   update pipeline.uni_adapter_exclusions set active = false, reason = reason || ' | lifted: E16 F3 rollback' where course_id = 'e1596a78-53ad-463f-bd1a-1442109c6ac3' and field = 'fee' and active;
--   update pipeline.layer4_review_items set status = 'superseded' where entity_type = 'course' and entity_id = 'e1596a78-53ad-463f-bd1a-1442109c6ac3'
--      and field_code = 'provider_current_tuition' and status = 'pending' and layer2_state->>'source' = 'e16_f3_assessment';
--   insert into pipeline.admin_control_events(area, action, target, detail, actor) values ('layer4', 'e16_fee_quarantine_rollback', 'catalogue.course_fees', jsonb_build_object('part', 'F3Q', 'count', v_n, 'ids_md5', 'f01b7ee058f278f298f9ca62f9d06ff2'), null);
--   insert into search.refresh_requests(requested_by) values ('E16 fee quarantine F3 rollback');
-- end $e16f3qr$;
-- commit;


-- ===== Part U (NOT for running as prepared; commented out): the 2 "unclear" F3 fees, route to Layer 4 WITHOUT withdrawal =====
-- The brief asked for SQL for the independent-evidence class only. Decision 2 still routes the unclear class; this block is the shape the
-- integrator can enable. 061457F fee 6462dc9f 46,500 (2027) row md5 d41c93ed4613c041a45f44d685c83d51; 103218C fee 191d4b0e 54,060 (2027)
-- row md5 e7fd72e568460990efdae08d19cd65a0. Fee ids md5 4c804f46cbfc6715fc513e54ffb77937. The fees stay active and shown; nothing else changes.
-- Note: a pending provider_current_tuition item does not stop the award lane (it only re-copies when the amount differs, and it does not).
-- begin;
-- do $e16f3u$ declare v_n int := 0; r record; begin
--   for r in select f.*, a.source_url from catalogue.course_fees f left join pipeline.evidence_artifacts a on a.id = f.evidence_id
--             where (f.id, md5(concat_ws('|', f.id, f.course_id, f.amount, f.fee_year, f.status, f.evidence_id, f.valid_to))) in
--                   (('6462dc9f-8a18-4ae9-82f3-4d6b3f2926c2'::uuid, 'd41c93ed4613c041a45f44d685c83d51'), ('191d4b0e-bbba-4c36-bc18-102fc00c5906'::uuid, 'e7fd72e568460990efdae08d19cd65a0'))
--               and f.status = 'active' loop
--     perform pg_advisory_xact_lock(hashtext('layer4 fee ' || r.course_id::text));
--     if exists (select 1 from pipeline.layer4_review_items i where i.entity_type = 'course' and i.entity_id = r.course_id
--                  and i.field_code in ('provider_current_tuition', 'provider_current_tuition_validation') and i.status = 'pending') then continue; end if;
--     insert into pipeline.layer4_review_items(entity_type, entity_id, field_code, evidence_id, before_value, proposed_value, layer2_state, layer3_state, status, escalation_reason, change_control_ref)
--     values ('course', r.course_id, 'provider_current_tuition', r.evidence_id, jsonb_build_object('amount', r.amount, 'fee_year', r.fee_year, 'status', 'active'),
--             jsonb_build_object('amount', r.amount, 'currency', r.currency_code, 'basis', r.basis, 'fee_year', r.fee_year, 'page', r.source_url),
--             jsonb_build_object('source', 'e16_f3_assessment', 'state', 'shown_pending_review', 'fee_id', r.id), '{}'::jsonb, 'pending',
--             'Check: this fee is the parent master''s annual fee, shown for this exit award. The CRICOS register for this programme differs by about 6%. If the programme''s own page states this fee, admit it; otherwise do not admit it.',
--             'CF-CHG-20260915-247; E16 Decision 2 (Platform Admin 2 Nov 2026 10:56)');
--     v_n := v_n + 1;
--   end loop;
--   if v_n > 2 then raise exception 'E16 F3U: % items, at most 2 expected', v_n; end if;
--   insert into pipeline.admin_control_events(area, action, target, detail, actor) values ('layer4', 'e16_fee_routed', 'pipeline.layer4_review_items',
--     jsonb_build_object('part', 'F3U', 'created', v_n, 'ids_md5', '4c804f46cbfc6715fc513e54ffb77937', 'withdrawal', false, 'decision', 'Decision 2, 2 Nov 2026 10:56'), null);
-- end $e16f3u$;
-- commit;
