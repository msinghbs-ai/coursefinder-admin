# CourseFinder Layer 2A AU PRISMS Production Gate UAT v1.0

**Date:** 18 August 2026  
**Gate:** M1-L2-AU-PRISMS  
**Result:** **PASS**  
**Runtime:** `coursefinder_Pilot` / `prisms-au-etl` v0.1.0  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.25.md`  
**Pilot source-control commit:** `0714aab19480924d62757ec20cbbfbe6fe881849`

## 1. Acceptance objective

Prove that Australian PRISMS-derived international student enrolment and commencement statistics can be ingested as time-scoped, source/evidence/versioned Layer 2A observations without redefining accepted AU CRICOS Provider/Course identity or mutating the accepted Search projection.

## 2. Mandatory identity rule

CRICOS remains the AU Layer 1 Provider/Course identity authority.

For the accepted Department of Education ABS SA4 publication, the source does not publish Provider or Course identifiers. Therefore the production gate must not invent those mappings. PRISMS observations are accepted against canonical country/subdivision and only explicitly governed taxonomy mappings; `provider_id` and `course_id` remain null.

## 3. Source acquisition UAT

Accepted official Department source:

`https://www.education.gov.au/international-education-data-and-research/resources/international-student-enrolment-and-commencement-data-abs-sa4`

Direct XLSX used by the worker:

`https://www.education.gov.au/download/15221/international-student-enrolment-and-commencement-data-abs-sa4-publication/44345/document/xlsx`

Acquisition result:
- HTTP acquisition: PASS;
- workbook bytes: **63,321**;
- required sheet: `Data`;
- collection version: `2025-12`;
- period: `2025-01-01` to `2025-12-31`;
- workbook SHA-256: `c50cec06e48eb6729eed5f2359cdc88c67c9680ceded6cb57be485d8c2094aae`.

Source summary reported:
- rows: **1,135**;
- total enrolments: **1,035,371**;
- total commencements: **467,122**.

Result: **PASS**.

## 4. Dry-run/parser UAT

Bounded dry-run result:

| Measure | Result |
|---|---:|
| Published rows parsed | 1,135 |
| Candidate metric observations | 2,270 |
| Exact numeric observations | 2,069 |
| Privacy-suppressed `<5` observations | 201 |
| AU subdivisions mapped | 8 / 8 |
| Source sectors | 5 |
| Source broad fields | 13 |
| Observations with governed canonical field mapping | 372 |
| Duplicate normalized published-dimension groups | 2 |
| Provider dimension published | false |
| Course dimension published | false |
| Identity authority | false |

Parser controls passed:
- expected workbook title present;
- PRISMS source marker present;
- expected headers present;
- source row count reconciled;
- period parsed from the workbook rather than hard-coded as an observation date;
- source rows preserved deterministically where normalized dimensions repeat;
- `<5` retained as explicit suppression, never imputed;
- no Provider/Course mapping attempted.

Visible exact numeric sums reconciled exactly to the workbook summary:
- enrolments: **1,035,371**;
- commencements: **467,122**.

Result: **PASS**.

## 5. Canonical dimension UAT

### Subdivision

Exact mappings established for:
- AU-ACT;
- AU-NSW;
- AU-NT;
- AU-QLD;
- AU-SA;
- AU-TAS;
- AU-VIC;
- AU-WA.

Missing subdivision mappings after APPLY: **0**.

### Broad field

All 13 source broad-field labels are retained as PRISMS external study areas.

Only exact current canonical labels were mapped:
- Management and Commerce -> `management-commerce`;
- Natural and Physical Sciences -> `natural-physical-sciences`.

Mapping method: `exact_existing_canonical_label`; confidence 1.0.

No fuzzy mapping or canonical taxonomy creation was performed.

Result: **PASS**.

## 6. APPLY UAT

First successful APPLY:
- observations seen: **2,270**;
- observations changed: **2,270**;
- source ID: `37f1776c-77a3-4083-8ec7-7d76ad7a9ad8`;
- evidence ID: `78210aa1-8a20-46f5-ba52-9689068a1e2e`.

Evidence path:

`layer2a/AU/prisms/sa4/2025-12/c50cec06e48eb6729eed5f2359cdc88c67c9680ceded6cb57be485d8c2094aae.xlsx`

Evidence object properties:
- size: 63,321 bytes;
- XLSX MIME type recorded;
- content hash matches source acquisition hash;
- `evidence` bucket public flag: false.

Result: **PASS**.

## 7. Privacy suppression UAT

Post-APPLY population:
- total observations: **2,270**;
- exact numeric: **2,069**;
- suppressed: **201**;
- invalid numeric/suppression shapes: **0**.

Accepted storage rule:
- exact -> non-null non-negative `metric_value`, suppression false, no suppression code;
- suppressed -> null `metric_value`, suppression true, code `<5`.

No estimated values were generated for protected cells.

Result: **PASS**.

## 8. Idempotency UAT

Second identical APPLY:
- observations seen: **2,270**;
- observations changed: **0**;
- source ID unchanged;
- evidence ID unchanged;
- workbook SHA-256 unchanged.

Result: **PASS**.

## 9. Integrity UAT

Post-APPLY checks:
- duplicate `(source_id, source_observation_key)` values: **0**;
- missing subdivision references: **0**;
- missing external study-area references: **0**;
- invalid governed canonical field mappings: **0**;
- invalid source links: **0**;
- invalid evidence links: **0**;
- non-international observations: **0**;
- Provider-attached PRISMS observations: **0**;
- Course-attached PRISMS observations: **0**.

Metric population:
- enrolment observations: **1,135**;
- commencement observations: **1,135**.

Result: **PASS**.

## 10. Layer 1 and Search regression UAT

Pre-APPLY accepted baseline:
- AU Providers: **1,546**;
- AU Courses: **26,648**;
- Search Documents: **33,105**.

Regression fingerprints before PRISMS:
- AU Provider hash: `d63daea157023f0e6b83c71f0a9a88be`;
- AU Course hash: `12c4eed4f4b188a7199f42b68d012052`;
- Search hash: `19f4151148c4b4c7bb768409aeca3192`.

Post-APPLY:
- AU Providers: **1,546**, hash unchanged;
- AU Courses: **26,648**, hash unchanged;
- Search Documents: **33,105**, hash unchanged.

Result: **PASS — PRISMS changed no accepted Provider/Course/Search identity.**

## 11. Negative identity UAT

A controlled write test attempted to attach an already-existing AU CRICOS Provider to one PRISMS observation.

The service apply contract rejected the operation with:

`source does not publish a Provider dimension`

This proves the non-authoritative source metadata is enforced at the write boundary rather than relying only on worker behaviour.

Result: **PASS**.

## 12. Security UAT

- Direct `prisms-au-etl` invocation without one-time nonce -> **401**.
- Valid one-time nonce dry-run/APPLY -> **200**.
- PRISMS service/write RPCs -> `service_role` only.
- `anon`/`authenticated` direct SELECT on `catalogue.student_flow_observations` -> denied.
- table RLS -> enabled.
- authenticated `public.ui_international_student_observations` -> permitted.
- `anon` execution of curated read RPC -> revoked.
- evidence Storage -> private.

Edge logs for the final worker version show the dry-run/APPLY/replay requests succeeding and the deliberate no-nonce request returning 401; no PRISMS 500 occurred in the gate sequence.

Security Advisor notes:
- deny-by-default RLS-with-no-policy INFO is expected for the internal table because clients have no direct table grant;
- authenticated SECURITY DEFINER read-RPC warning is intentional and matches the existing governed `ui_*` projection pattern; the function requires `auth.uid()`, anon execute is revoked and the underlying tables remain private;
- unrelated existing account-hardening notices are outside this gate.

Result: **PASS**.

## 13. Read/performance UAT

Authenticated projection test for full `2025-12-31` period:
- rows returned: **2,270**;
- suppressed rows exposed explicitly: **201**;
- min/max period end: `2025-12-31`.

Representative filtered projection:
- filters: `2025-12-31`, `AU-VIC`, `higher_education`;
- rows: **224**;
- measured execution: approximately **38.2 ms**;
- shared-buffer hits only;
- disk reads: 0.

Supabase Performance Advisor found no unindexed foreign-key defect on `catalogue.student_flow_observations`. Newly created indexes reported as unused are informational immediately after creation and retained for the intended period/dimension access paths.

Result: **PASS**.

## 14. Runtime/source-control UAT

Applied migrations:
- `20260818054601_prisms_layer2a_student_flow_contract`;
- `20260818054751_prisms_suppressed_value_and_replay_hardening`.

Deployed Edge Function:
- name: `prisms-au-etl`;
- worker version: `prisms-au-etl-v0.1.0`;
- Supabase function deployment version: 1;
- deployment function ID: `b0c0f8f5-a847-454c-ab03-c63a1b84e3fd`.

Pilot source-control files:
- `supabase/migrations/20260818054601_prisms_layer2a_student_flow_contract.sql`;
- `supabase/migrations/20260818054751_prisms_suppressed_value_and_replay_hardening.sql`;
- `supabase/functions/prisms-au-etl/index.ts`.

Pilot repository head after source sync:

`0714aab19480924d62757ec20cbbfbe6fe881849`

Result: **PASS**.

## 15. Gate decision

**PASS. M1-L2-AU-PRISMS is accepted as production Layer 2A structured statistical enrichment.**

Conditions retained after PASS:
1. CRICOS remains AU Provider/Course identity authority.
2. The accepted SA4 PRISMS source must remain Provider/Course-unmapped because it publishes no such identifiers.
3. Future PRISMS source variants may populate a canonical dimension only when that dimension is actually published and a separate governed mapping contract proves the target.
4. `<5` values remain explicit privacy suppression and must never be estimated.
5. source/version/hash/private evidence is mandatory for every observation.
6. source taxonomy may map to canonical taxonomy only through explicit governed mappings; no fuzzy promotion.
7. Search enrichment requires a separate M1-SEARCH acceptance gate.