# CF-CHG-20260820-011 — Scholarship compound eligibility, cycle and scope semantics

**Status:** APPLIED / DB-RPC-SECURITY + FRONTEND SOURCE PASS — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 13:26 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Scholarship semantic read contract / compound eligibility / time-scoped presentation / provenance / security ACL

## Trigger

The Scholarship semantic audit found that the canonical relational model retained Offering Cycles, Application Windows, Scopes, compound Criterion Groups/Criteria, Award Tiers and Coverage, but the Admin detail did not preserve their business relationships.

Two concrete defects were present:

1. the backend returned `cycles` / `windows` while the frontend expected `offering_cycles` / `application_windows`, so Offering Cycles and Application Windows were not represented as intended first-class sections;
2. Criterion Groups and Criteria were displayed as separate raw tables, which removed parent/child and `all` / `any` conjunction meaning.

The legacy public Scholarship-detail helper was also directly executable by `authenticated` even though `public.admin_read` is the governed browser boundary.

## Semantic decisions

1. Scholarship identity uses stable identifier before name.
2. Offering Cycle is the governing temporal grain for cycle-specific windows, scopes, eligibility, award tiers and coverage.
3. Application Window belongs to its Offering Cycle; nullable exact timestamps must not be replaced by invented dates.
4. Source-only date text remains source text when the authority supplies no exact timestamp.
5. Criterion Group parentage and conjunction are executable/business meaning, not display metadata.
6. `conjunction=all` means all relevant children/criteria in the group are required; `conjunction=any` means one of the governed alternatives satisfies that group, subject to parent-group logic.
7. `machine_evaluable=false` means the rule requires human/source interpretation; it does not mean the criterion failed.
8. Scope `include_exclude` is explicit. No Scope rows must not be interpreted as universal Provider/Course applicability.
9. Award Tier is an award-value option. Coverage is a benefit component. They must not be collapsed into one amount/text field.
10. Child source/evidence remains attached to the child observation rather than inherited silently from the Scholarship header.
11. Observations with `cycle_id=NULL` remain in an explicit unscoped/review bucket; they are not silently attached to the newest/current cycle.
12. Admin visibility does not grant Search/Website/Zoho admission.

## Bounded reference A — Australia Awards Scholarships

Scholarship UUID: `95cbac08-2699-597b-a511-c9ca2161b540`  
Stable key: `scholarship:AU:au_dfat_australia_awards:aas`

Current structured state:

- Offering Cycles: 1 — 2027;
- Application Windows: 2 — main round + Palau round;
- Criterion Groups: 2;
- Criteria: 9;
- Coverage components: 9;
- Award Tiers: 0;
- structured Scope rows: 0.

Compound eligibility:

- top group `General eligibility` — mandatory — `all` — 7 direct criteria;
- child group `Participating-country pathway` — mandatory — parent = General eligibility — `any` — 2 direct criteria.

Flattening the nine criteria would lose the rule that general eligibility must be satisfied together with the participating-country pathway logic.

No structured Scope rows are currently loaded. This does **not** authorise Admin/Zoho to interpret Australia Awards as universally applicable to every Provider/Course. Country eligibility is represented in the governed criteria/source material.

## Bounded reference B — RMIT David Phillips Memorial Scholarship

Scholarship UUID: `e9b61e99-5a67-5706-a533-df84dba16d80`

Current structured state:

- Offering Cycle: `recurring`;
- one Application Window;
- exact `opens_at` / `closes_at`: NULL;
- retained source closing text: `Mid September each year - check website for exact dates`;
- one `include` Provider Scope resolved to `RMIT University (RMIT)`;
- one Award Tier: AUD 5,000 / `annual`;
- one eligibility group.

The source closing text is not converted into an invented September date.

## Applied governed read contract

Pilot migration:

`m1_pim_gov_scholarship_semantics_v1`

Repository mirror:

`supabase/production-migrations/065_m1_pim_gov_scholarship_semantics.sql`

Private helper:

`security.admin_scholarship_semantic_summary(uuid)`

The helper returns:

- `record_provenance`;
- `cycles[]`, with each cycle containing:
  - cycle provenance;
  - `application_windows[]`;
  - resolved `scopes[]`;
  - `eligibility_groups[]`, each with its direct `criteria[]`;
  - `award_tiers[]`;
  - `coverage[]`;
- explicit `unscoped` collections for child observations whose `cycle_id` is NULL.

`public.admin_read('scholarship_detail',...)` appends this governed `semantic_summary` while preserving the existing base record.

No Scholarship/cycle/window/scope/criterion/tier/coverage row was rewritten.

## Security after-state

- `anon` EXECUTE on `security.admin_scholarship_semantic_summary(uuid)`: false;
- `authenticated` EXECUTE on the non-exposed helper: true so the invoker `public.admin_read` may dispatch to it;
- helper retains safe search path and assigned-CourseFinder-role check;
- `authenticated` direct EXECUTE on legacy `public.ui_scholarship_detail(uuid)`: false;
- `authenticated` EXECUTE on governed `public.admin_read(text,jsonb)`: true.

## Frontend release — PIM Admin v2.8.0

`src/ScholarshipSemanticDetail.jsx` replaces the generic Scholarship raw-table detail with governed sections for:

- Scholarship provenance;
- Offering Cycles;
- Application Windows;
- resolved Applicability Scopes;
- recursive Eligibility Logic with explicit **ALL of the following** / **ANY of the following** semantics;
- Criteria with human text/operator/mandatory/machine-evaluable/confidence/source/evidence;
- Award Tiers;
- Coverage / benefits;
- explicit Needs Attention for Scholarship-level/unscoped observations.

The component preserves source-only closing text when exact timestamps are absent and does not equate missing Scope rows with universal applicability.

Visible/package version is `2.8.0`.

## UAT

Detailed UAT:

`docs/uat/coursefinder-m1-pim-gov-scholarship-v2.8.0-uat-2026-08-20.md`

Passed technical/authenticated cases:

### Australia Awards

- cycle count 1;
- window count 2;
- eligibility groups 2;
- top conjunction `all`;
- child conjunction `any`;
- child parent-group relationship retained;
- top criteria 7;
- child criteria 2;
- coverage 9;
- scope count 0;
- unscoped criteria 0.

### RMIT David Phillips

- cycle code `recurring`;
- window count 1;
- source closing text retained;
- Provider include scope resolved to RMIT University (RMIT);
- one Award Tier AUD 5,000 / annual;
- one eligibility group.

Frontend branch integrity before governance additions:

- `src/ScholarshipSemanticDetail.jsx` added;
- `src/main.jsx`: only 3 additions / 2 deletions;
- `package.json`: one version-line change;
- branch was ahead 3 / behind 0 from PIM Admin v2.7 baseline.

## Consumer consequence

Zoho/Website must not consume Scholarship eligibility as a single Boolean or unqualified text field. The curated contract must preserve cycle, window, scope, group conjunction/parentage, criterion, award tier and coverage cardinality.

This change defines semantics only. Consumer admission remains separate.

## Rollback

Frontend rollback restores the v2.7 generic Scholarship detail while leaving canonical Scholarship data intact. Backend rollback removes the semantic-summary wrapper/helper and restores the previous direct-helper ACL only if separately authorised. Do not collapse or rewrite canonical Scholarship relational data as rollback.

## Decision / status history

| Timestamp | Status | Event |
|---|---|---|
| 20 Aug 2026 13:26 AEST | OPEN / AUDITED | Scholarship cycle/scope/compound-eligibility presentation defects confirmed |
| 20 Aug 2026 | APPLIED / TECHNICAL PASS | Governed cycle-nested Scholarship summary and ACL applied in Pilot |
| 20 Aug 2026 | FRONTEND SOURCE PASS | PIM Admin v2.8.0 Scholarship semantic component staged with minimal integration diff |

## Closure

**Final status:** OPEN — DB/RPC/SECURITY + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING  
**Closed at:** N/A  
**Outcome:** Scholarship cycle, application-window, scope, compound eligibility, tier, coverage and provenance semantics are preserved through the governed read and v2.8 source presentation. Closure requires deployed authenticated browser UAT.
