# CourseFinder Master Project Plan v1.24

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.23.md`  
**Last consolidated:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.24.md`  
**Running build:** `docs/coursefinder-running-build-v2.26.md`  
**QILT gate:** `docs/uat/coursefinder-layer2a-au-qilt-production-gate-uat-v1.0.md`

This version retains the source-qualified country strategy from v1.23 and records completion of the first priority structured-enrichment workstream: **M1-L2-AU-QILT is PASS**.

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS | PASS / ACCEPTED | Maintain canonical identity substrate |
| NZ Layer 1 NZQA | PASS / ACCEPTED | Maintain canonical identity substrate |
| CA Layer 1 | PAUSED / UNPUBLISHED | Preserve canonical/history; no fragmented expansion |
| AU QILT Layer 2A | **PASS / ACCEPTED** | Maintain and expose through governed outcomes API |
| AU PRISMS Layer 2A | NEXT | Structured international-student observations; no identity authority |
| Scholarships | READY / NEXT | Continue authoritative structured source ingestion |
| Admin/PIM | IN PROGRESS | Add evidence/outcome/review governance surfaces |
| Search/API enrichment | PENDING | Project approved Layer 2 facts only after explicit search contract |

## Live accepted AU QILT state

Production QILT observations: **2,033**.

- GOS 2025 — 593 observations / 72 Providers;
- SES 2024 — 977 / 103;
- GOS-L 2025 — 235 / 40;
- ESS 2025 pooled 2023–2025 — 228 / 38.

Second identical APPLY changed **0 rows for every survey**.

No QILT run modified AU Provider identity, Course identity or Search Documents. AU remains 1,546 Providers / 26,648 Courses and accepted Search remains 33,105 AU+NZ documents.

## Phase 0 — Foundation & Architecture

**Status: COMPLETE / GOVERNED**

Architecture v2.10.24 now includes the accepted external-outcomes grain:
- immutable evidence workbook;
- source/version metadata;
- verified source-to-CRICOS Provider mapping;
- provider outcome observation;
- publisher cohort in `source_cohort_code`;
- no QILT identity authority.

## Phase 1 — Layer 1 Regulatory / Canonical Data

**Status: AU + NZ ACCEPTED; COUNTRY EXPANSION PAUSED**

No change from v1.23. QILT did not alter this phase.

## Phase 2 — Admin / PIM UX

**Status: IN PROGRESS**

QILT now supplies real production data for the outcome/evidence/review surfaces.

Required Admin behaviour:
- show source survey/version and evidence hash;
- show source institution label/key separately from canonical Provider;
- show mapping status/method;
- show QILT source cohort independently of canonical study level;
- expose unmatched/ambiguous labels to review without auto-merging;
- never offer QILT as a Provider/Course identity authority;
- keep evidence access governed/private.

## Phase 3 — Layer 2 Structured Source Enrichment

**Status: ACTIVE**

### 3A — Australia QILT

**PASS / COMPLETE FOR INITIAL PRODUCTION GATE.**

Accepted surveys: GOS, SES, GOS-L and ESS. UAT evidence is recorded in `docs/uat/coursefinder-layer2a-au-qilt-production-gate-uat-v1.0.md`.

### 3B — Australia PRISMS

**NEXT PRIORITY.**

Apply the same architecture: evidence-backed time-scoped observations mapped to accepted CRICOS identities; PRISMS must not redefine Provider/Course identity.

### 3C — New Zealand Education Counts

Queued after/alongside AU enrichment according to Milestone 1 priority.

### 3D — Scholarships

Relational foundation remains accepted; continue source-qualified production ingestion independently of Layer 1 country expansion.

## Phase 4 — Layer 3 AI Enrichment

**Status: NOT STARTED AS PRODUCTION PHASE.**

No QILT values required AI extraction. Deterministic workbook parsing remains preferred.

## Phase 5 — Data Quality & Human Review

**Status: FOUNDATION PRESENT / REAL REVIEW QUEUE NOW AVAILABLE.**

QILT unmatched/ambiguous institution labels provide the first real Layer 2 mapping review workload. Layer 4 review may approve explicit crosswalks; it must not change CRICOS stable identity.

## Phase 6 — Search / API / Consumer Experience

**Status: FOUNDATION ACTIVE; QILT READ API ACCEPTED; SEARCH ENRICHMENT PENDING.**

`public.ui_provider_outcomes` is the authenticated curated read projection for QILT observations.

Do not inject QILT metrics into Search ranking/filtering until M1-SEARCH defines a consumer contract, cohort selection and missing-data behaviour.

## Phase 7 — Production Hardening & Operations

**Status: PARTIAL / QILT GATE PASSED.**

QILT proved:
- official live acquisition;
- required-sheet validation;
- immutable workbook evidence/hash;
- bounded APPLY;
- zero-change replay;
- verified mapping enforcement;
- deny-by-default internal tables;
- one-time nonce Edge invocation;
- authenticated read projection;
- integrity and performance gate.

Existing unrelated Supabase advisor notices remain programme hardening items and are not QILT blockers.

## Next programme action

Proceed with **M1-L2-AU-PRISMS** or the parallel Scholarship/PIM workstreams. Do not reopen Provider/Course identity decisions for QILT and do not project QILT into Search without the separate M1-SEARCH gate.
