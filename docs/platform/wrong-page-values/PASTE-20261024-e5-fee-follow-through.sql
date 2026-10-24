-- PASTE-20261024-e5-fee-follow-through.sql — record of what was run live on 24 Oct 2026 10:25–10:35 AEDT (E5 of the 09:55 mandate),
-- as the Platform Admin, continuing the 07:32 decision ("cricos should not be in any logic to admit data other than au") and the
-- 00:26 quarantine. Both steps are count-guarded and logged in pipeline.admin_control_events; re-running repeats nothing
-- (the guards fail on a second run because the rows have moved).

-- 1. Four Manukau Institute of Technology pages bound with a cricos_code label at 08:19 AEDT (inside the v0.45.0 deploy window,
--    after the 406 re-verification) — the same treatment as the 406: back to mismatch for reidentify under identity-v0.6.0,
--    their 3 live fees quarantined (unverified + one Layer 4 row, source identity_basis_reverify). Guard: exactly 4 rows.
--    Manual bindings (15 AUT/UoA pages carrying the label) are exempt and untouched.
begin;
create temp table _mit on commit drop as
select p.course_id, p.evidence_id, p.url, p.identity_basis from pipeline.coverage_course_pages p
  join catalogue.providers pr on pr.id = p.provider_id join ref.countries k on k.id = pr.country_id
 where p.identity_basis = 'cricos_code' and k.iso_alpha2 <> 'AU' and p.status = 'bound' and coalesce(p.basis, '') <> 'manual';
do $g$ declare n int; begin select count(*) into n from _mit; if n <> 4 then raise exception 'expected 4, found %', n; end if; end $g$;
update pipeline.coverage_course_pages p set status = 'mismatch', read_status = 'identity_mismatch', leased_until = null, next_read_at = now(), read_attempts = 0 from _mit m where p.course_id = m.course_id;
update catalogue.course_fees f set status = 'unverified', updated_at = now() from _mit m where f.course_id = m.course_id and f.status = 'active' and f.audience = 'international';
insert into pipeline.layer4_review_items(entity_type, entity_id, field_code, evidence_id, before_value, proposed_value, layer2_state, layer3_state, status, escalation_reason, change_control_ref)
select 'course', m.course_id, 'provider_current_tuition', m.evidence_id, null, null,
       jsonb_build_object('source', 'identity_basis_reverify', 'state', 'quarantined', 'country', 'NZ', 'identity_basis', m.identity_basis, 'page', m.url), '{}'::jsonb, 'pending',
       'quarantined for re-verification: the course page was bound with a cricos_code proof during the v0.45.0 deploy window (08:19 AEDT), which is not a NZ proof; reidentify under identity-v0.6.0 re-binds it and the fee re-admits (Platform Admin 24 Oct 2026 07:32, continuation)',
       'CF-CHG-20260915-247 item 8a'
  from _mit m where exists (select 1 from catalogue.course_fees f where f.course_id = m.course_id and f.status = 'unverified')
   and not exists (select 1 from pipeline.layer4_review_items l where l.entity_type = 'course' and l.entity_id = m.course_id and l.field_code = 'provider_current_tuition' and l.status = 'pending');
insert into pipeline.admin_control_events(area, action, target, detail, actor)
values ('layer4', 'identity_basis_reverify_quarantine', 'NZ', jsonb_build_object('courses', 4, 'reason', '4 MIT pages bound with a cricos_code label at 08:19 AEDT during the v0.45.0 deploy window, missed by the 406 re-verification; same treatment (Platform Admin 24 Oct 2026 07:32)'), '<platform admin uuid>');
insert into search.refresh_requests(requested_by) values ('identity_basis_reverify continuation (4 MIT pages)');
commit;
-- Result: reset 4, fees unverified 3, Layer 4 rows 3.

-- 2. The 149 quarantine rows of 00:35 stayed pending although 112 courses were re-bound under their country's rule and 115 carry a
--    live international fee again — nothing closes a quarantine row when the fee re-admits. Closed (status superseded, an existing
--    value) where the page is re-bound with an allowed proof AND an active international fee was written after the quarantine.
--    Guard: exactly 95.
begin;
create temp table _done on commit drop as
select l.id, l.entity_id course_id from pipeline.layer4_review_items l
 where l.entity_type = 'course' and l.field_code = 'provider_current_tuition' and l.status = 'pending' and l.layer2_state->>'source' = 'identity_basis_reverify'
   and exists (select 1 from pipeline.coverage_course_pages p where p.course_id = l.entity_id and p.status = 'bound' and security.coverage_identity_allowed(p.provider_id, p.identity_basis, 'tuition'))
   and exists (select 1 from catalogue.course_fees f where f.course_id = l.entity_id and f.status = 'active' and f.audience = 'international' and f.updated_at > '2026-10-23 13:30+00');
do $g$ declare n int; begin select count(*) into n from _done; if n <> 95 then raise exception 'expected 95, found %', n; end if; end $g$;
update pipeline.layer4_review_items l set status = 'superseded', decided_at = now(),
       escalation_reason = l.escalation_reason || ' — closed 24 Oct 2026: the page was re-bound under the country''s rule and the fee re-admitted (live international fee present)'
  from _done d where l.id = d.id;
insert into pipeline.admin_control_events(area, action, target, detail, actor)
values ('layer4', 'identity_basis_reverify_closed', 'NZ,CA', jsonb_build_object('closed', 95, 'reason', 'E5 fee follow-through (Platform Admin 24 Oct 2026 09:55): quarantine rows whose course was re-bound under its country rule and carries a re-admitted live international fee'), '<platform admin uuid>');
commit;
-- Result: closed 95; still pending 54 + 3 (MIT) = 57: 37 NZ pages not proved (mismatch, need a new page), 16 NZ re-bound with an open
-- fee request, 1 CA re-bound and queued, 3 MIT awaiting reidentify.
