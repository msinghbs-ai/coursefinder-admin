# CF-CHG-20260821-018 — M1 Data Quality Readiness operational gate

**Status:** **CLOSED / PASS — TECHNICAL, BUILD, SECURITY, PERFORMANCE AND DEPLOYED END-TO-END BROWSER UAT COMPLETE**  
**Category:** `30-admin-pim-ux`  
**Initiated:** 21 August 2026 14:47 AEST (UTC+10)  
**Closed:** 22 August 2026 13:41 AEST (UTC+10)  
**Origin chat/workstream:** `M1-DATA-QUALITY-READINESS — Completeness, Freshness, Exceptions & Decision-Queue Gate`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Admin operational UX / governed read contract / data-quality semantics / performance / UAT

## 1. Trigger and objective

The historical Course-only completeness percentage could not distinguish regulatory source gaps, country-specific non-applicability, unattempted Layer 2 enrichment, stale observations, suppressed values, ambiguity or rejection. This control establishes Data Quality / Readiness as a governed operational workspace across Provider, Course, Campus, Scholarship and enrichment without manufacturing values or collapsing source authority, Search admission and publication state.

Readiness domains are:

- identity completeness;
- regulatory completeness;
- geography / delivery;
- taxonomy;
- regulatory fee;
- current Provider fee;
- Course URL;
- Intake;
- English requirement;
- Scholarship;
- Evidence;
- verification / freshness;
- Search admission;
- publication readiness.

## 2. Governing semantic decision

A single equal-weight cross-domain completeness percentage is **not exposed as the authoritative Data Quality measure**. Domain readiness always distinguishes:

`present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`

Rules:

1. `present` and legitimate numeric `zero` are ready states;
2. `not_applicable` is excluded from the applicable denominator;
3. `source_null` is used only where governed source evidence proves the authority supplied no value/relationship;
4. absence before accepted enrichment is `not_yet_enriched`;
5. suppressed, stale, ambiguous and rejected remain distinct;
6. canonical identity, Search admission and publication remain separate authorities;
7. no canonical Provider/Course/Campus/Scholarship identity or factual value is rewritten;
8. no synthetic Campus, fee, URL, Intake, English requirement, Scholarship or Review item is created to improve readiness.

Durable semantic contract: `docs/coursefinder-data-quality-readiness-contract-v1.0.md`.

## 3. Related accepted controls

Retained and not reopened:

- `CF-CHG-20260820-012` — lifecycle / publication / readiness / Search separation;
- `CF-CHG-20260820-014` — Completeness Profiles are policy context, not truth;
- `CF-CHG-20260820-015` — accepted PIM operational browser/performance baseline;
- `CF-CHG-20260821-016` — Pipeline Operations read boundary;
- `CF-CHG-20260821-017` — Evidence workspace/private-boundary baseline.

## 4. Accepted country/source classifications

Existing accepted CRICOS completeness evidence is preserved:

- 34 AU Course→Campus gaps are authoritative CRICOS Course Location source absences;
- 191 AU registered Tuition Fee gaps are authoritative source absences;
- 131 AU registered tuition values are legitimate numeric zero;
- no synthetic Campus or fee is created.

For NZ, NZQA remains the accepted Layer 1 Provider + Qualification authority. There is no accepted CRICOS-equivalent registered total-course tuition dimension, so NZ regulatory tuition is `not_applicable`; absent NZ Course geography/delivery is `not_yet_enriched`. Scholarship verification/freshness is not inferred from `updated_at`.

## 5. Accepted scope inventory

- all canonical: 3,085 Providers / 43,461 Courses / 3,922 Campuses / 4 Scholarships;
- AU+NZ: 1,955 Providers / 33,105 Courses / 3,922 Campuses / 4 Scholarships;
- Search Course documents: 33,105;
- Course links: 10;
- Course intakes: 18 rows / 10 distinct Courses;
- Course English requirement rows: 32 / 10 distinct Courses;
- AU+NZ Provider-current fee rows: 10;
- `workflow.review_queue`: 0 rows at implementation.

## 6. Accepted read contract

Browser boundary remains `public.admin_read(text,jsonb)`.

Added operations:

- `data_quality_overview` — one bounded aggregate RPC;
- `data_quality_exceptions` — one bounded/paged exception RPC.

Private implementation remains under `security.*`; browser roles do not receive direct execution rights on base/implementation helpers. There is no page-level N+1 detail pattern.

## 7. Supabase implementation

Live migrations:

- `20260821050044 — m1_data_quality_readiness_v1`;
- `20260821050313 — m1_data_quality_readiness_course_base_fast_v1`;
- `20260821050457 — m1_data_quality_readiness_overview_fast_v2`;
- `20260821050825 — m1_data_quality_readiness_exceptions_fast_v2`;
- `20260821050846 — m1_data_quality_readiness_runtime_memory_v1`.

The live Supabase migration ledger remains the authoritative migration record for this release.

## 8. Accepted AU+NZ results

- Identity: Course 33,105; Provider 1,955; Campus 3,922; Scholarship 4 — 100% ready.
- Regulatory: Course 33,105; Provider 1,955 — 100% present.
- Geography / delivery Course: 26,614 present / 34 source-null / 6,457 not-yet-enriched / 80.39%.
- Taxonomy Course: 26,648 present / 6,457 not-yet-enriched / 80.50%.
- Regulatory tuition Course: 26,326 present positive / 131 zero / 191 source-null / 6,457 not-applicable / 99.28%.
- Current Provider fee: 10 present / 33,095 not-yet-enriched.
- Course URL: 10 present / 33,095 not-yet-enriched.
- Intake: 10 Courses present / 33,095 not-yet-enriched.
- English requirement: 10 Courses present / 33,095 not-yet-enriched.
- Scholarship applicability: 500 present / 32,605 not-yet-enriched.
- Search admission: 33,105 / 33,105 AU+NZ Courses present in the governed Search projection.
- Publication readiness is not inferred from Search.

## 9. ACL/security UAT — PASS

- `public.admin_read`: authenticated yes / anon no;
- `security.admin_data_quality_read`: authenticated yes / anon no;
- private Data Quality base/implementation helpers: authenticated no / anon no;
- assigned Admin role can read overview/exceptions;
- existing dispatcher routes regress successfully;
- no Data Quality-specific security-advisor finding was introduced;
- no generic mutation/retry/replay/reset action exists.

## 10. Performance UAT — PASS

The first spilling aggregate implementation was rejected and optimised before promotion.

Accepted samples:

- AU+NZ overview warm: ~836.6 ms, zero temp spill;
- AU regulatory-fee source-null exception page, 50 rows: ~155.8 ms, zero temp spill;
- final representative cold overview after spill removal: ~4.0 s.

`work_mem=128MB` is scoped to the private Data Quality functions rather than applied globally.

## 11. Pilot frontend/build — PASS

Pilot PR #18 promoted Data Quality v1.0 with the dedicated workspace, responsive states, one overview RPC, one paged exception RPC and entity/Evidence drill-down. Production build run `32450608567` / #103 passed.

Initial browser UAT found the historical six-signal Course score labelled generically `Readiness`. Pilot PR #19 corrected presentation only:

- `Readiness` → `Legacy presence`;
- `Min readiness` → `Min legacy presence`.

Build run `32479758645` / #105 passed. Accepted Pilot source/head:

`72721c57d2a11a5fb79288c9eadf4e14602a2e14`

## 12. Deployed authenticated browser UAT — PASS

Detailed evidence:

- `docs/uat/coursefinder-m1-data-quality-readiness-technical-acceptance-2026-08-21.md`;
- `docs/uat/coursefinder-m1-data-quality-readiness-browser-evidence-2026-08-21.md`.

Authenticated screenshots prove `coursefinder-pilot.techm.workers.dev` serves:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · governed`

Browser regression proves:

- AU Course Catalogue: 26,648;
- all-country Course Catalogue: 43,461;
- legitimate `AUD 0` renders correctly;
- `Legacy presence` / `Min legacy presence` is deployed;
- Data Quality AU+NZ overview and all nine states render;
- Regulatory fee shows 26,326 present / 191 source-null / 6,457 not-applicable / 131 zero / 99.28%;
- Exceptions reports 191 source-null records;
- paging is proven across 1–50, 51–100, 101–150 and 151–191;
- a canonical Course opens from the exception flow and retains provenance links.

### Final Evidence-detail proof — PASS

A 22 August 2026 13:30 AEST authenticated screenshot proves a real Evidence link opens the deployed Evidence detail workspace. Visible evidence includes:

- `Evidence Artifact` → `Regulatory Snapshot`;
- source `CRICOS Providers, Courses and Locations`;
- `PRIVATE EVIDENCE BOUNDARY`;
- acquisition job `regulatory_sync`;
- 103,315 extracted observations/claims;
- 25,500 affected/linked canonical entities;
- 0 reviews, consistent with the real current Review state;
- source authority/acquisition, content hash/storage, observations and affected-entity sections.

This directly proves the previously corrected `evidence_id` route and closes the operational chain:

`Domain aggregate → Exception → canonical Course → Evidence artifact`.

No Review row was manufactured for UAT.

### Final browser telemetry

The 13:29–13:30 AEST final Evidence interaction correlates with repeated `POST /rest/v1/rpc/admin_read` HTTP 200 calls, including four successful reads around 13:30:08 AEST.

Two earlier statement timeouts were observed at approximately 13:24 and 13:26 AEST in the broader session. The API log does not expose `p_operation`, so they are not attributed to Data Quality or Evidence without proof. The required final Evidence navigation subsequently completed successfully. These transient failures are retained as an operational lesson and are a direct input to `M1-UAT-HARNESS`, which will automatically retain browser/network traces and fail on unexpected server 5xx responses.

## 13. Rollback

This change is additive/read-only. Rollback may revert the frontend promotion and remove Data Quality dispatcher branches/private helpers. Do not delete or rewrite canonical, Evidence, Search, publishing or Review data.

## 14. Documentation impact

Closure authorises the accepted-baseline updates to:

- PIM Admin Guide v1.13;
- Admin/PIM Design Decisions v1.12;
- Running Build v2.62;
- Master Project Plan v1.59;
- Change Control Register.

Database Architecture v2.10.38 remains current because this control adds governed read semantics/UI only and does not change canonical identity, source authority, evidence grain or core database architecture. Zoho contract is unchanged.

## 15. Decision / status history

| Timestamp | Status | Decision / event |
|---|---|---|
| 21 Aug 2026 14:47 AEST | PROPOSED / IMPLEMENTING | Gate initiated after Admin/Pilot/live Supabase reconciliation. |
| 21 Aug 2026 15:23 AEST | TECHNICAL PASS | Semantics, ACL, dispatcher regression and performance passed. |
| 21 Aug 2026 15:27–15:29 AEST | BUILD PASS / SOURCE PROMOTED | Pilot PR #18 passed and Data Quality v1.0 source promoted. |
| 21 Aug 2026 ~21:55 AEST | DEPLOYMENT / CATALOGUE PASS | Live Worker and canonical counts proven; generic `Readiness` label defect identified. |
| 21 Aug 2026 22:00 AEST | BUILD PASS / SOURCE PROMOTED | Pilot PR #19 relabel passed and merged. |
| 21 Aug 2026 22:08 AEST | OVERVIEW BROWSER PASS | AU+NZ workspace, nine-state vocabulary and governed counts proven. |
| 21 Aug 2026 22:23–22:26 AEST | EXCEPTION / COURSE PASS | 191 total, four pages and canonical Course drill-down proven. |
| 22 Aug 2026 ~13:30 AEST | EVIDENCE DETAIL PASS | Real Evidence link opens deployed Regulatory Snapshot/private Evidence workspace. |
| 22 Aug 2026 13:41 AEST | CLOSED / PASS | Full Data Quality operational chain accepted. |

## 16. Closure

**Final status:** **CLOSED / PASS**  
**Closed at:** 22 August 2026 13:41 AEST  
**Outcome:** Data Quality semantics, live DB/RPC, ACL, security, performance, production build, source promotion and deployed authenticated-browser UAT all pass. The accepted end-to-end path is `domain readiness → exception → canonical Course → Evidence`. The historical six-signal Course percentage remains only as explicitly labelled `Legacy presence`. Future UAT automation is governed separately under `M1-UAT-HARNESS`; it does not reopen this accepted Data Quality semantic baseline.