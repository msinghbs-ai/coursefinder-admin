# CourseFinder Running Build v2.27

**Date:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.25.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.25.md`  
**QILT UAT:** `docs/uat/coursefinder-layer2a-au-qilt-production-gate-uat-v1.0.md`  
**PRISMS UAT:** `docs/uat/coursefinder-layer2a-au-prisms-production-gate-uat-v1.0.md`

## Current build position

**M1-L2-AU-PRISMS — PASS / ACCEPTED.**

The live Pilot now contains evidence-backed, time-scoped Australian international-student enrolment and commencement observations from the Department of Education PRISMS-derived ABS SA4 publication.

CRICOS remains the AU Provider/Course identity authority. The accepted PRISMS publication contains no Provider or Course identifiers, so this gate deliberately attaches **zero** Provider/Course identities.

Pilot source-control runtime commit: `0714aab19480924d62757ec20cbbfbe6fe881849`.

## Live PRISMS population

| Measure | Accepted state |
|---|---:|
| Collection version | 2025-12 |
| Period | 2025-01-01 → 2025-12-31 |
| Published rows | 1,135 |
| Total observations | **2,270** |
| Exact numeric observations | **2,069** |
| Privacy-suppressed `<5` observations | **201** |
| Enrolment observations | 1,135 |
| Commencement observations | 1,135 |
| AU subdivisions mapped | 8 |
| Source sectors | 5 |
| Source broad fields | 13 |
| Observations mapped to existing canonical field | 372 |
| Provider-attached observations | **0** |
| Course-attached observations | **0** |

Visible exact numeric totals reconcile to the source workbook summary:
- enrolments: **1,035,371**;
- commencements: **467,122**.

Suppressed values are stored as explicit `<5` facts with no imputation.

## Evidence/version state

Workbook SHA-256:

`c50cec06e48eb6729eed5f2359cdc88c67c9680ceded6cb57be485d8c2094aae`

Workbook size: **63,321 bytes**.

Source ID: `37f1776c-77a3-4083-8ec7-7d76ad7a9ad8`.  
Evidence ID: `78210aa1-8a20-46f5-ba52-9689068a1e2e`.

Private evidence path:

`layer2a/AU/prisms/sa4/2025-12/c50cec06e48eb6729eed5f2359cdc88c67c9680ceded6cb57be485d8c2094aae.xlsx`

## Identity/Search regression

Accepted state remained unchanged across PRISMS APPLY:

| Boundary | Count | Regression hash | Result |
|---|---:|---|---|
| AU Providers | 1,546 | `d63daea157023f0e6b83c71f0a9a88be` | unchanged |
| AU Courses | 26,648 | `12c4eed4f4b188a7199f42b68d012052` | unchanged |
| Search Documents | 33,105 | `19f4151148c4b4c7bb768409aeca3192` | unchanged |

PRISMS did not mutate Provider, Course or Search identity.

A deliberate negative UAT attempting to attach a valid AU Provider was rejected because the source metadata declares no Provider dimension.

## Idempotency/integrity

First APPLY:
- 2,270 seen / **2,270 changed**.

Second identical APPLY:
- 2,270 seen / **0 changed**.

Post-APPLY integrity:
- duplicate source observation keys: 0;
- invalid exact/suppressed value shapes: 0;
- missing subdivision mappings: 0;
- missing external study areas: 0;
- invalid canonical field mappings: 0;
- invalid source links: 0;
- invalid evidence links: 0;
- non-international observations: 0;
- Provider attachments: 0;
- Course attachments: 0.

## Runtime

Edge Function: `prisms-au-etl` v0.1.0.

Applied migrations:
- `20260818054601_prisms_layer2a_student_flow_contract`;
- `20260818054751_prisms_suppressed_value_and_replay_hardening`.

Key controls:
- official Department XLSX acquisition;
- expected title/source/sheet/header validation;
- source period extraction and row-count reconciliation;
- SHA-256 private evidence identity;
- exact AU subdivision mapping;
- source-qualified PRISMS study-area taxonomy;
- exact-only governed canonical field mapping;
- explicit privacy suppression storage;
- one-time Pilot nonce;
- service-role-only writes;
- bounded observation APPLY;
- source metadata rejects unpublished Provider/Course dimensions;
- authenticated `ui_international_student_observations` projection.

Direct Edge invocation without nonce returned 401.

## Read/performance

Authenticated full-period read returned all **2,270** observations including **201** explicit suppression rows.

Representative filtered read (`2025-12-31`, `AU-VIC`, `higher_education`):
- 224 rows;
- approximately **38.2 ms**;
- no measured disk reads.

No PRISMS-specific unindexed-foreign-key defect was reported by Supabase Performance Advisor.

## QILT retained state

M1-L2-AU-QILT remains **PASS / ACCEPTED** with **2,033** provider-outcome observations. PRISMS does not replace or reinterpret QILT; the two sources occupy separate governed Layer 2A observation grains.

## Current accepted Milestone 1 position

- AU CRICOS Layer 1 — PASS / ACCEPTED;
- NZ NZQA Layer 1 — PASS / ACCEPTED;
- CA Layer 1 — PAUSED / UNPUBLISHED;
- AU QILT Layer 2A — PASS / ACCEPTED;
- AU PRISMS Layer 2A — **PASS / ACCEPTED**;
- Search/API projection of enrichment — separate gate required.

## Next build

Valid next Milestone 1 workstreams are:
- authoritative Scholarship production ingestion;
- NZ Education Counts Layer 2 structured enrichment;
- Admin/PIM evidence, observation and review surfaces;
- M1-SEARCH consumer projection design for accepted Layer 2 facts.

Do not reopen AU Provider/Course identity decisions for PRISMS or QILT.