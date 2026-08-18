# CourseFinder Running Build v2.26

**Date:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.24.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.24.md`  
**QILT UAT:** `docs/uat/coursefinder-layer2a-au-qilt-production-gate-uat-v1.0.md`

## Current build position

**M1-L2-AU-QILT — PASS.**

The live Pilot now contains production Layer 2A QILT observations over the accepted AU CRICOS Provider substrate. QILT is explicitly non-authoritative for Provider/Course identity.

Pilot source-control runtime commit: `cffda52eb6b05108b9e197da5b363303931066fb`.

## Live QILT population

| Survey | Version | Observations | Providers | Mapping coverage |
|---|---:|---:|---:|---:|
| GOS | 2025 | 593 | 72 | 100 / 136 institution labels |
| SES | 2024 | 977 | 103 | 112 / 149 |
| GOS-L | 2025 | 235 | 40 | 41 / 43 |
| ESS | 2025 | 228 | 38 | 40 / 42 |
| **Total** | — | **2,033** | — | — |

Unmatched/ambiguous publisher labels are withheld from observations. No guessed Provider merge is permitted.

## Evidence hashes

- GOS workbook: `fdc20abd4bf0f5f9338807ac9b82663477d4a3f4beced0709cd1f476de52df17`
- SES workbook: `5949c0f66ced356492ef49ce6c2c42e207fbd67535f9fb5e25bfe40923c71684`
- GOS-L workbook: `6a67528df6343d9fe23317cacfb63877eb62a3cf58ff7e963d1a2d8b99952be8`
- ESS workbook: `60103546b51564b50d82cf50f91c0d90243758955442eed32e86ed2b64dcc7b6`

Artifacts are private XLSX evidence under `layer2a/AU/qilt/...` and are referenced by every accepted observation.

## Identity/search regression

QILT changed none of the accepted Layer 1/Search identities:

- AU Providers: **1,546**, with 0 Provider rows updated during the QILT gate;
- AU Courses: **26,648**, with 0 Course rows updated;
- accepted Search Documents: **33,105**, with 0 Search rows updated by QILT.

Canada remains paused/unpublished and New Zealand remains accepted.

## Idempotency/integrity

Second identical APPLY:
- GOS: 593 seen / **0 changed**;
- SES: 977 / **0**;
- GOS-L: 235 / **0**;
- ESS: 228 / **0**.

Integrity after APPLY:
- duplicate observation keys: 0;
- orphan Providers: 0;
- orphan metrics: 0;
- orphan sources: 0;
- orphan evidence: 0;
- missing verified source-to-Provider mappings: 0;
- QILT rows with canonical study level assigned: 0.

## Runtime

Edge Function: `qilt-au-etl` v0.2.4.

Key runtime controls:
- official QILT ZIP/XLSX acquisition;
- required-sheet validation;
- workbook SHA-256 evidence identity;
- CRICOS-derived conservative alias matching only;
- one-time Pilot nonce required;
- service-role-only write RPCs;
- bounded 3,000 mapping / 5,000 observation RPC contracts;
- authenticated `ui_provider_outcomes` read projection.

Direct Edge call without nonce returned 401 in UAT.

Representative authenticated provider outcome projection: 36 rows in approximately 7.8 ms.

## Cohort model

QILT publisher cohorts `UG`, `PGC`, `PGR`, `ALL` are stored as `source_cohort_code`.

They are not canonical `study_level_id` values and are not the `audience` dimension. This prevents publisher taxonomy from silently redefining the CourseFinder academic model.

## Review queue

Unresolved examples include:
- `University of New South Wales` versus CRICOS substrate `UNSW Sydney`;
- `Victoria University`, which is ambiguous across two existing CRICOS Provider records;
- additional NUHEI publisher labels without a unique safe CRICOS crosswalk.

These remain governed review items, not ingestion errors and not identity writes.

## Next build

Primary next Layer 2 workstream: **M1-L2-AU-PRISMS**.

Parallel valid workstreams: Scholarships, Admin/PIM outcome/evidence review surfaces, and M1-SEARCH consumer projection design.
