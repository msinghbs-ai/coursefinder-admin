-- Item 8a acceptance, re-verification gap (Platform Admin 24 Oct 2026 00:21). NOT RUN. Runs inside the 8a migration only after
-- worker v0.45 (identity rule identity-v0.6.0, per-country labels from pipeline.country_identity_rules) is live: with the current
-- rule (identity-v0.5.12) reidentify would relabel the same way and re-bind them.
-- Bound pages whose proof label is not in their country's allowed_for[] are put back to mismatch / identity_mismatch, which
-- (a) removes them from tuition admission at once (fee_course_pages_enqueue_v1 and coverage_apply_course_v1 take status = 'bound' only)
-- and (b) hands them to the existing reidentify mode, which re-binds only when the correct country's proof is on the page.
-- Expected rows (live 24 Oct 00:25): 421 = NZ cricos_code 301 + CA cricos_code 63 + CA nzqa_code 57. Manual bindings are never touched.
with wrong as (
  select p.course_id, p.evidence_id, k.iso_alpha2 cc, p.identity_basis
  from pipeline.coverage_course_pages p
  join catalogue.providers pr on pr.id = p.provider_id
  join ref.countries k on k.id = pr.country_id
  join pipeline.country_identity_rules r on r.country = k.iso_alpha2            -- 8a table: country, basis, proof, allowed_for[]
  where p.status = 'bound' and coalesce(p.basis, '') <> 'manual'
    and p.identity_basis is not null
    and not exists (select 1 from pipeline.country_identity_rules a where a.country = k.iso_alpha2 and a.basis = p.identity_basis)
  group by 1, 2, 3, 4
), n as (select count(*) c from wrong)
update pipeline.coverage_course_pages p
   set status = 'mismatch', read_status = 'identity_mismatch', leased_until = null
  from wrong w, n
 where p.course_id = w.course_id
   and n.c = 421;                                                              -- the migration raises if the live count differs from the file
-- The reidentify job (coverage-reidentify, every minute, batch.coverage_reidentify) then takes them with rule identity-v0.6.0; the
-- 8a contract test proves: every row of LIST-20261023-sweep-identity-not-admitted-and-mismatch.csv is either re-bound with a
-- basis in its country's allowed_for[] or still mismatch with the refusing rule named; none is admitted for tuition in between.
