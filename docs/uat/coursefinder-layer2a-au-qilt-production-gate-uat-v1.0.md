# CourseFinder Layer 2A AU QILT Production Gate UAT v1.0

**Date:** 18 August 2026  
**Gate:** M1-L2-AU-QILT  
**Result:** **PASS**  
**Runtime:** `coursefinder_Pilot` / `qilt-au-etl` v0.2.4  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.24.md`

## 1. Acceptance objective

Prove that official Australian QILT GOS, SES, GOS-L and ESS publications can enrich the accepted AU CRICOS Provider substrate as structured Layer 2A observations while preserving Layer 1 Provider/Course identity, source/evidence lineage, bounded replay, security and acceptable read performance.

## 2. Mandatory identity rule

QILT must never create, merge, rename, re-key or redefine a Provider or Course.

Only a unique mapping from a QILT institution label to an **already existing AU CRICOS Provider** is accepted. Ambiguous/unmatched labels are withheld.

## 3. Source acquisition UAT

All four official live QILT ZIPs returned successfully. Required XLSX workbooks and configured institution sheets were present.

| Survey | Collection | Workbook SHA-256 | Result |
|---|---:|---|---|
| GOS | 2025 | `fdc20abd4bf0f5f9338807ac9b82663477d4a3f4beced0709cd1f476de52df17` | PASS |
| SES | 2024 | `5949c0f66ced356492ef49ce6c2c42e207fbd67535f9fb5e25bfe40923c71684` | PASS |
| GOS-L | 2025 | `6a67528df6343d9fe23317cacfb63877eb62a3cf58ff7e963d1a2d8b99952be8` | PASS |
| ESS | 2025 | `60103546b51564b50d82cf50f91c0d90243758955442eed32e86ed2b64dcc7b6` | PASS |

Workbook hash, not ZIP container hash, is used as evidence content identity.

## 4. Dry-run/parser UAT

Final bounded dry-run results:

| Survey | Parsed institution labels | Unique CRICOS mappings | Unmatched/ambiguous | Candidate observations |
|---|---:|---:|---:|---:|
| GOS | 136 | 100 | 36 | 593 |
| SES | 149 | 112 | 37 | 977 |
| GOS-L | 43 | 41 | 2 | 235 |
| ESS | 42 | 40 | 2 | 228 |

PASS criteria met:
- all configured sheets present;
- metric cells parsed deterministically;
- only unique existing CRICOS targets promoted;
- ambiguous/unmatched labels withheld;
- no name-derived canonical identity generated.

## 5. APPLY UAT

First successful APPLY:

| Survey | Seen | Changed | Result |
|---|---:|---:|---|
| GOS | 593 | 593 | PASS |
| SES | 977 | 977 | PASS |
| GOS-L | 235 | 235 | PASS |
| ESS | 228 | 228 | PASS |

Total accepted observations: **2,033**.

Every observation references:
- active QILT survey/metric;
- an existing AU Provider;
- verified `source_provider_mappings` row;
- QILT `structured_outcomes` source;
- immutable private workbook evidence.

## 6. Idempotency UAT

Second identical APPLY:

| Survey | Seen | Changed |
|---|---:|---:|
| GOS | 593 | **0** |
| SES | 977 | **0** |
| GOS-L | 235 | **0** |
| ESS | 228 | **0** |

Workbook hashes were unchanged. Gate result: **PASS**.

## 7. Integrity UAT

Post-APPLY checks:
- duplicate unique observation keys: **0**;
- orphan Provider references: **0**;
- orphan metric references: **0**;
- orphan source references: **0**;
- orphan evidence references: **0**;
- observations lacking verified source-to-Provider mapping: **0**;
- observations with worker-assigned canonical `study_level_id`: **0**;
- observations with worker-assigned non-`all` audience: **0**.

Survey population:
- GOS — 593 observations / 72 Providers / 3 source cohorts;
- SES — 977 / 103 / 2;
- GOS-L — 235 / 40 / 2;
- ESS — 228 / 38 / 1.

## 8. Layer 1 regression UAT

Accepted AU substrate before QILT:
- Providers: 1,546;
- Courses: 26,648.

Post-QILT checks found:
- AU Provider rows updated during gate: **0**;
- AU Course rows updated during gate: **0**;
- Search Documents updated during gate: **0**.

Accepted Search remains **33,105 AU+NZ documents**.

Result: **PASS — QILT did not redefine Provider/Course/Search identity.**

## 9. Cohort semantic UAT

An early APPLY correctly failed because QILT course group labels were initially being tested against the existing `audience` constraint. The model was corrected rather than widening the constraint.

Accepted semantic contract:
- `UG`, `PGC`, `PGR`, `ALL` -> `source_cohort_code`;
- canonical `study_level_id` -> null unless separately governed;
- `audience` -> existing population dimension, `all` for this source slice.

The observation unique index includes `source_cohort_code`, preventing cohort collisions while preserving canonical taxonomy boundaries.

Result: **PASS**.

## 10. Security UAT

- Direct Edge invocation without one-time nonce -> **401**.
- Valid one-time nonce path -> successful dry-run/APPLY.
- QILT write RPCs -> `service_role` only.
- `anon`/`authenticated` direct internal table access -> deny-by-default architecture retained.
- `ui_provider_outcomes` -> authenticated curated RPC; unauthenticated test returned zero rows.
- Evidence bucket -> private.

Supabase Security Advisor contains existing informational deny-by-default/RPC notices and unrelated account-hardening warnings; none are a QILT production blocker.

Result: **PASS**.

## 11. Read/performance UAT

Representative provider: Australian Catholic University.

Authenticated `ui_provider_outcomes` result:
- rows: 36;
- missing evidence hashes: 0;
- maximum collection version: 2025;
- measured execution: approximately **7.8 ms**;
- no temporary I/O in the measured plan.

Result: **PASS**.

## 12. Mapping review behaviour

The gate intentionally leaves unresolved mappings where the current canonical substrate does not prove a unique target. Examples:
- `University of New South Wales` / `UNSW Sydney` branding mismatch;
- `Victoria University` -> two current CRICOS Provider records;
- additional NUHEI display brands without a safe unique CRICOS-derived crosswalk.

These are Layer 4 review items. They do not block the safe mapped observation population and must not be resolved through free-form name similarity in Layer 2A.

## 13. Gate decision

**PASS. M1-L2-AU-QILT is accepted as production Layer 2A structured outcomes enrichment.**

Conditions retained after PASS:
1. CRICOS remains AU Provider/Course identity authority.
2. QILT mappings must target existing Providers only.
3. unmatched/ambiguous labels remain reviewable, not auto-merged.
4. source cohort remains separate from canonical study level/audience.
5. evidence/version/hash is mandatory for observations.
6. Search enrichment requires a separate M1-SEARCH acceptance gate.
