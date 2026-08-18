# CourseFinder Master Project Plan v1.25

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.24.md`  
**Last consolidated:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.25.md`  
**Running build:** `docs/coursefinder-running-build-v2.27.md`  
**QILT gate:** `docs/uat/coursefinder-layer2a-au-qilt-production-gate-uat-v1.0.md`  
**PRISMS gate:** `docs/uat/coursefinder-layer2a-au-prisms-production-gate-uat-v1.0.md`

This version retains the accepted source-qualified country strategy and records completion of the second priority Australian structured-enrichment workstream: **M1-L2-AU-PRISMS is PASS / ACCEPTED**.

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS | PASS / ACCEPTED | Maintain canonical Provider/Course identity substrate |
| NZ Layer 1 NZQA | PASS / ACCEPTED | Maintain canonical identity substrate |
| CA Layer 1 | PAUSED / UNPUBLISHED | Preserve canonical/history; no fragmented expansion |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed Provider outcomes; no identity authority |
| AU PRISMS Layer 2A | **PASS / ACCEPTED** | Maintain time-scoped student-flow observations; no identity authority |
| NZ Education Counts Layer 2 | QUEUED | Apply source-qualified structured-enrichment pattern |
| Scholarships | READY / NEXT | Continue authoritative structured source ingestion |
| Admin/PIM | IN PROGRESS | Add evidence/outcome/student-flow/review governance surfaces |
| Search/API enrichment | PENDING | Project accepted Layer 2 facts only after explicit consumer/search contract |

## Live accepted AU enrichment state

### QILT

Production QILT observations: **2,033**.

- GOS 2025 — 593 observations / 72 Providers;
- SES 2024 — 977 / 103;
- GOS-L 2025 — 235 / 40;
- ESS 2025 pooled 2023–2025 — 228 / 38.

QILT maps only to already-existing CRICOS Providers and does not alter Provider/Course identity.

### PRISMS

Accepted PRISMS ABS SA4 publication:
- collection version `2025-12`;
- period `2025-01-01` to `2025-12-31`;
- source rows: **1,135**;
- accepted observations: **2,270**;
- exact numeric observations: **2,069**;
- explicit privacy-suppressed `<5` observations: **201**;
- Provider attachments: **0**;
- Course attachments: **0**.

Visible exact numeric totals reconcile to the source workbook:
- enrolments: **1,035,371**;
- commencements: **467,122**.

The accepted public SA4 source has aggregate geography/sector/broad-field dimensions and no Provider/Course identifiers. CourseFinder therefore stores those facts without inventing identity links.

Second identical PRISMS APPLY saw 2,270 observations and changed **0**.

Neither QILT nor PRISMS changed AU Provider identity, Course identity or Search Documents. AU remains **1,546 Providers / 26,648 Courses** and accepted Search remains **33,105 AU+NZ documents**.

## Phase 0 — Foundation & Architecture

**Status: COMPLETE / GOVERNED**

Architecture v2.10.25 now includes two accepted Australian Layer 2A patterns:

1. **Provider outcomes (QILT)** — immutable evidence, publisher institution keys, verified mappings to existing CRICOS Providers, source cohorts and versioned outcome observations.
2. **Student-flow statistics (PRISMS)** — immutable evidence, period + source dimensions, exact governed canonical dimension mappings where available, explicit privacy suppression and nullable Provider/Course scope that cannot be populated unless the source actually publishes those dimensions.

Both patterns preserve the same authority rule: **Layer 2 observations enrich canonical entities/dimensions; they never redefine Layer 1 identity.**

## Phase 1 — Layer 1 Regulatory / Canonical Data

**Status: AU + NZ ACCEPTED; COUNTRY EXPANSION PAUSED**

No change from v1.24. PRISMS did not alter this phase.

Accepted AU substrate remains:
- Providers: 1,546;
- Courses: 26,648.

## Phase 2 — Admin / PIM UX

**Status: IN PROGRESS**

The Admin/PIM surface must support both accepted Layer 2A grains.

Required behaviour:
- show source/version and private evidence hash/path reference;
- distinguish source dimensions from canonical dimensions;
- show mapping status/method/confidence where a crosswalk exists;
- show explicit privacy suppression without converting `<5` to a number;
- show time period/type on student-flow observations;
- keep Provider/Course scope nullable where the source does not publish it;
- expose unresolved taxonomy or identity mappings to governed review only;
- never offer QILT or PRISMS as Provider/Course identity authorities;
- keep evidence access governed/private.

## Phase 3 — Layer 2 Structured Source Enrichment

**Status: ACTIVE**

### 3A — Australia QILT

**PASS / COMPLETE FOR INITIAL PRODUCTION GATE.**

Accepted surveys: GOS, SES, GOS-L and ESS. UAT evidence is recorded in `docs/uat/coursefinder-layer2a-au-qilt-production-gate-uat-v1.0.md`.

### 3B — Australia PRISMS

**PASS / COMPLETE FOR INITIAL PRODUCTION GATE.**

Accepted first source: Department of Education PRISMS-derived international enrolment/commencement data by ABS SA4, collection `2025-12`.

Accepted grain:

`host country + AU subdivision + SA4 + remoteness + sector + source broad field + metric + period + evidence`

Provider/Course references are null for this source and are protected by the write contract because those dimensions are not published.

UAT evidence is recorded in `docs/uat/coursefinder-layer2a-au-prisms-production-gate-uat-v1.0.md`.

### 3C — New Zealand Education Counts

**QUEUED.**

Reuse the accepted evidence/version/time-scoped observation pattern. Map only dimensions and entities that the authoritative source genuinely publishes and that can be proven against the accepted NZ canonical substrate.

### 3D — Scholarships

**READY / NEXT.**

Relational foundation remains accepted. Continue source-qualified production ingestion independently of Layer 1 country expansion.

## Phase 4 — Layer 3 AI Enrichment

**Status: NOT STARTED AS PRODUCTION PHASE.**

QILT and PRISMS both proved that structured official sources should be parsed deterministically. AI extraction is not required where structured authoritative data is available.

## Phase 5 — Data Quality & Human Review

**Status: FOUNDATION PRESENT / REAL REVIEW WORKLOAD AVAILABLE.**

Review surfaces now need to accommodate:
- unresolved QILT Provider labels;
- PRISMS source taxonomies that do not yet have an exact canonical crosswalk;
- explicit approval/rejection of future source mappings;
- evidence-backed provenance for every decision.

Layer 4 review may approve explicit crosswalks. It must not mutate CRICOS stable identity to make Layer 2 sources fit.

## Phase 6 — Search / API / Consumer Experience

**Status: FOUNDATION ACTIVE; GOVERNED READ APIS ACCEPTED; SEARCH ENRICHMENT PENDING.**

Accepted authenticated read projections:
- `public.ui_provider_outcomes` for QILT;
- `public.ui_international_student_observations` for PRISMS.

Do not inject Layer 2 metrics into Search ranking/filtering until M1-SEARCH defines:
- selected metric and period semantics;
- missing/suppressed-data behaviour;
- source versus canonical taxonomy display;
- aggregation and double-counting controls;
- consumer ranking/filtering rules.

## Phase 7 — Production Hardening & Operations

**Status: PARTIAL / AU STRUCTURED-ENRICHMENT GATES PASSED.**

Across QILT and PRISMS the platform has now proven:
- official live structured-source acquisition;
- schema/header/sheet validation;
- immutable private evidence with SHA-256 identity;
- source/version/period lineage;
- bounded service-role APPLY;
- zero-change replay;
- governed crosswalk enforcement;
- explicit withholding of unsafe mappings;
- privacy suppression preservation;
- deny-by-default internal tables;
- one-time nonce Edge invocation;
- authenticated curated read projections;
- Layer 1/Search regression protection;
- integrity and read-performance gates.

Existing unrelated Supabase advisor notices remain programme hardening items and are not blockers for the accepted PRISMS gate.

## Next programme action

The initial AU QILT and PRISMS Layer 2A gates are complete.

Proceed with one of the approved next Milestone 1 workstreams:
1. **authoritative Scholarship production ingestion**;
2. **NZ Education Counts structured enrichment**;
3. **Admin/PIM evidence, observation and review surfaces**;
4. **M1-SEARCH consumer projection design** for accepted Layer 2 facts.

Do not reopen AU Provider/Course identity decisions for QILT or PRISMS, and do not project either source into Search without the separate M1-SEARCH gate.