-- Identity-basis re-verification quarantine, 24 Oct 2026 00:35 AEDT, run live by Claude on the Platform Admin's 00:26 decision (kept for the record).
-- Fees admitted on a mislabelled binding (NZ page bound with a cricos_code proof; CA page with a cricos_code or nzqa_code proof; manual
-- bindings never touched) go to status unverified with one Layer 4 row per course, same path as the fee-floor quarantine, distinct
-- source 'identity_basis_reverify' so the hourly report's quarantine_growth keeps the two populations apart. Reversible: reidentify
-- under identity-v0.6.0 re-binds the page, it re-reads, the fee re-admits through the proper path.
-- Guard: the live set was 149 courses / 158 fee rows (NZ 147 / 156, CA 2 / 2). The 160 quoted at 00:30 counted manual bindings too.
begin;
create temp table _rev on commit drop as
select f.id, f.course_id, f.evidence_id, f.amount, f.currency_code, k.iso_alpha2 cc, p.identity_basis, p.url
from catalogue.course_fees f
join pipeline.coverage_course_pages p on p.course_id = f.course_id and p.status = 'bound' and coalesce(p.basis,'') <> 'manual'
join catalogue.providers pr on pr.id = p.provider_id join ref.countries k on k.id = pr.country_id
where f.status = 'active' and f.audience = 'international'
  and ((k.iso_alpha2 = 'NZ' and p.identity_basis = 'cricos_code') or (k.iso_alpha2 = 'CA' and p.identity_basis in ('cricos_code','nzqa_code')));
do $g$ declare n int; c int; begin
  select count(*), count(distinct course_id) into n, c from _rev;
  if c <> 149 or n <> 158 then raise exception 'expected 149 courses / 158 fee rows, found % / %', c, n; end if; end $g$;
update catalogue.course_fees f set status = 'unverified', updated_at = now() from _rev x where f.id = x.id;
insert into pipeline.layer4_review_items(entity_type, entity_id, field_code, evidence_id, before_value, proposed_value, layer2_state, layer3_state, status, escalation_reason, change_control_ref)
select 'course', x.course_id, 'provider_current_tuition', x.evidence_id,
       jsonb_build_object('amount', x.amount, 'currency', x.currency_code, 'status', 'active'),
       jsonb_build_object('amount', x.amount, 'currency', x.currency_code, 'status', 'unverified'),
       jsonb_build_object('source', 'identity_basis_reverify', 'state', 'quarantined', 'country', x.cc, 'identity_basis', x.identity_basis, 'page', x.url), '{}'::jsonb, 'pending',
       'quarantined for re-verification: the course page was bound with a ' || x.identity_basis || ' proof, which is not a ' || x.cc || ' proof; reidentify under identity-v0.6.0 re-binds it and the fee re-admits (Platform Admin 24 Oct 2026 00:26)',
       'CF-CHG-20260915-247 item 8a'
  from (select distinct on (course_id) * from _rev order by course_id, id) x
 where not exists (select 1 from pipeline.layer4_review_items l where l.entity_type = 'course' and l.entity_id = x.course_id and l.field_code = 'provider_current_tuition' and l.status = 'pending' and l.layer2_state->>'source' = 'identity_basis_reverify');
insert into pipeline.admin_control_events(area, action, target, detail, actor)
values ('layer4', 'identity_basis_reverify_quarantine', 'NZ,CA',
        jsonb_build_object('courses', 149, 'fee_rows', 158, 'by_country', (select jsonb_object_agg(cc, n) from (select cc, count(distinct course_id) n from _rev group by 1) z),
                           'reason', 'Platform Admin 24 Oct 2026 00:26: quarantine the fees admitted on mislabelled bindings until reidentify (identity-v0.6.0) re-binds the page'),
        '<platform admin uuid>');
insert into search.refresh_requests(requested_by) select 'identity_basis_reverify quarantine (NZ, CA)';
commit;
-- Verified after commit: 158 fee rows unverified, 149 Layer 4 rows (source identity_basis_reverify, pending), 0 such fees still live;
-- the 22 fee-floor rows stay a separate population.
