# Coursefinder Master Project Plan v1.0

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Last consolidated:** 12 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.9.1.md`  
**Running build baseline:** `docs/coursefinder-running-build-v2.1.md`  
**Latest accepted major UAT gates:** AU Full CRICOS Layer 1 — **PASS**; NZ Layer 1 Production Gate — **PASS**  
**Current programme position:** Phase 1 multi-country Layer 1 production validation; **CA active next**; GB, US and IE queued; DE deferred/blocked pending Provider identity/source-authority remediation. Phase 7 hardening continues in parallel.

---

## 1. Purpose and Governance

This document is the single authoritative programme-level plan for Coursefinder.

It governs:
- phase status and sequencing;
- accepted gates;
- dependencies;
- architecture and database impact;
- active workstreams;
- programme risks and technical debt;
- UAT entry/exit criteria;
- production-readiness decisions;
- links to detailed implementation and UAT evidence.

### Source-of-truth order

1. Approved architecture and database identity rules.
2. This master project plan for programme scope/status/sequencing.
3. Current running-build documentation for deployed runtime behaviour.
4. Accepted UAT evidence for gate decisions.
5. Admin/operator guides and detailed implementation documents.

Any change to stable identity, canonical ownership, source authority, security boundaries or production-gate criteria must be reflected here and in the relevant technical documentation.

---

## 2. Overall Programme Status

| Phase | Name | Status | Gate Position |
|---|---|---|---|
| 0 | Foundation & Architecture | **COMPLETE / ACCEPTED** | Architecture v2.9.1 authoritative |
| 1 | Layer 1 Regulatory Data | **IN PROGRESS** | AU PASS; NZ PASS; CA ACTIVE; GB/US/IE pending; DE deferred/blocked |
| 2 | Admin / PIM UX | **IN PROGRESS / OPERATIONAL FOUNDATION** | Regulatory operations foundation available; broader PIM UX incomplete |
| 3 | Layer 2 Source Enrichment | **PLANNED / PARTIALLY PROTOTYPED** | Broad rollout waits for Layer 1 maturity |
| 4 | Layer 3 AI Enrichment | **PLANNED** | No production gate accepted |
| 5 | Data Quality & Human Review | **FOUNDATION PRESENT / IN PROGRESS** | Full operational UAT pending |
| 6 | Search / API / Consumer Experience | **PARTIALLY COMPLETE** | AU + NZ Search Projection accepted; broader consumer/API/semantic UAT pending |
| 7 | Production Hardening & Operations | **IN PROGRESS** | Security/performance/monitoring/cutover work remains |

The programme is currently in **Phase 1 — Layer 1 Regulatory Data**, with Phase 7 hardening running in parallel.

---

# Phase 0 — Foundation & Architecture

**Status:** COMPLETE / ACCEPTED BASELINE

## Scope
- Production-model PostgreSQL/Supabase architecture.
- Stable Provider/Course identity model.
- Evidence/provenance and temporal-validity model.
- Canonical catalogue, PIM, pipeline, workflow, search and API separation.
- Security schemas and browser/service separation.
- Migration/reset/rebuild strategy.

## Architecture Impact
Architecture v2.9.1 is authoritative.

Core principles:
- canonical entities use stable identifiers, never descriptive names/titles as identity;
- Layer 1 owns regulatory truth;
- Layer 2 enriches evidence;
- Layer 3 produces structured AI suggestions, not unreviewed canonical truth;
- Layer 4/human workflow governs ambiguous/conflicting changes;
- search/read projections are rebuildable from canonical data;
- internal schemas are not general browser CRUD surfaces.

## UAT Gate
**ACCEPTED.**

The architecture is proven by AU and NZ Layer 1 production gates.

## Linked Docs
- `docs/coursefinder-database-architecture-v2.9.1.md`
- `docs/coursefinder-production-handover-v2.9.1.md`

---

# Phase 1 — Layer 1 Regulatory Data

**Status:** IN PROGRESS — AU PASS; NZ PASS; CA ACTIVE; GB/US/IE PENDING; DE DEFERRED/BLOCKED

## Scope
- Country-specific authoritative regulatory acquisition.
- Stable regulator/source identity.
- Source health/freshness.
- Private evidence capture with SHA-256 lineage.
- Parsing and deterministic canonical reconciliation.
- Idempotent reruns.
- Bounded/resumable execution.
- Search Projection rebuild.
- Security and operational validation.

## Production Identity Contract

Provider identity:
- `country + registration_scheme + stable regulator/source provider code`

Course identity:
- `provider + registration_scheme + stable regulator/source course code`

Names and titles remain descriptive only.

## Controlled Country Order

1. **NZ — PASS / ACCEPTED**
2. **CA — ACTIVE NEXT**
3. **GB — PENDING**
4. **US — PENDING**
5. **IE — PENDING**
6. **DE — DEFERRED / BLOCKED** until preceding countries are accepted and DE identity/source-authority remediation is complete.

AU remains the accepted reference baseline and is not part of the remaining queue.

## Accepted AU Baseline

- Providers: **1,546**
- Courses: **26,648**
- Campuses: **3,922**
- Course↔Campus links: **47,671**
- Search Documents: **26,648**

Detailed UAT:
- `docs/uat/coursefinder-layer1-au-full-ingestion-uat-v1.0.md`

## Accepted NZ Baseline

Authoritative runtime source:
- NZQA Education Organisations / Qualifications register.

Secondary authority:
- Education Counts retained as an independent authority/freshness cross-check; not a hard runtime dependency because the database runtime encountered a Cloudflare challenge.

Stable identity:
- Provider = `NZ + nzqa + Education Organisation number`.
- Course = `Provider + nzqa + NZQA qualification Number`.

Accepted NZ population:
- Providers: **409**
- Provider Registrations: **409**
- Courses: **6,457**
- Course Registrations: **6,457**
- Search Documents: **6,457**

Integrity:
- duplicate Provider identity keys: **0**
- duplicate Course identity keys at `provider + scheme + qualification code`: **0**
- Providers without registration: **0**
- Courses without registration: **0**
- orphan Course Registrations: **0**

Security:
- production worker retains JWT + Platform Admin protection;
- Layer 1 write/evidence/finalisation RPCs remain service-role only;
- temporary UAT-token validation function and token rows were removed after testing;
- temporary NZ UAT/inspection Edge Functions were retired as JWT-protected HTTP 410 harnesses.

Detailed UAT:
- `docs/uat/coursefinder-layer1-nz-production-gate-uat-v1.0.md`

## Combined Accepted Catalogue After NZ

- Providers: **1,955**
- Courses: **33,105**
- Search Documents: **33,105**

## CA Active Gate

CA must now prove:
- authoritative Canadian Provider source coverage;
- authoritative course/programme source coverage appropriate to Layer 1;
- stable non-name Provider and Course identifiers;
- live acquisition replacing the legacy snapshot-backed path before APPLY;
- bounded dry-run/APPLY/resume behaviour;
- evidence/provenance;
- idempotency;
- duplicate/orphan/integrity checks;
- Search Projection rebuild;
- JWT/Platform Admin/service-role boundaries;
- runtime/performance within the approved operational model.

No architecture change is assumed. Any Canadian-specific extension must be justified and documented before implementation.

## GB Pending Gate

Known current position:
- live UKVI Provider register exists;
- course path remains snapshot-backed/configured legacy logic;
- name-derived Provider identity must not be used for production APPLY.

GB starts only after CA is accepted.

## US / IE Pending Gates

Both remain snapshot-backed plus live-health-check implementations and are not accepted for production APPLY until their country gates replace/validate the acquisition path and stable identities.

## DE Deferred / Blocked

Known blocker:
- current DAAD programme path exposes stable programme IDs but not an accepted stable Provider identifier in the tested payload;
- `slug(academy)` or any other name-derived Provider identity is prohibited;
- existing database safety guard blocks unsafe DAAD Provider registration writes.

DE must be reassessed only after IE passes and then rerun against the then-current runtime/source model.

Detailed DE evidence:
- `docs/uat/coursefinder-layer1-de-production-gate-uat-v1.1.md`

## Phase 1 Operational Finding

NZ scale UAT exposed finalisation contention when multiple bounded APPLY slices simultaneously call `svc_layer1_finalize_catalogue()`.

Accepted hardening direction:
- reconcile bounded country slices;
- perform a single Search Projection rebuild after the country load, or serialize finalisation;
- avoid concurrent full-catalogue finalisation from every slice.

This did not cause NZ canonical integrity defects but remains a Phase 7 production-hardening item.

## Per-Country UAT Exit Criteria

A country is accepted only when all are true:
- authoritative source confirmed;
- stable source identifiers confirmed;
- live source acquisition accepted;
- bounded dry-run passes;
- bounded APPLY passes;
- evidence hashes/provenance retained;
- rerun proves idempotency;
- duplicate/orphan/integrity checks pass;
- Search Projection matches accepted canonical population;
- privilege/security negative tests pass;
- runtime/performance/resume behaviour is acceptable;
- country UAT document is committed;
- this master plan, running build and multi-country gate board are updated.

## Linked Docs
- `docs/coursefinder-running-build-v2.1.md`
- `docs/uat/coursefinder-layer1-multicountry-production-validation-v1.0.md`
- `docs/uat/coursefinder-layer1-au-full-ingestion-uat-v1.0.md`
- `docs/uat/coursefinder-layer1-nz-production-gate-uat-v1.0.md`
- `docs/uat/coursefinder-layer1-de-production-gate-uat-v1.1.md`

---

# Phase 2 — Admin / PIM UX

**Status:** IN PROGRESS / OPERATIONAL FOUNDATION

## Scope
- Admin navigation and PIM-style management.
- Regulatory source/settings visibility.
- Country-specific Layer 1 operations.
- Evidence/reconciliation/history visibility.
- Completeness and review surfaces.
- Bulk operations/import/export where approved.

## Current Foundation
Operational regulatory workflow includes:
1. select country;
2. inspect source/adapter/identity model;
3. set bounded batch/offset;
4. validate without writes;
5. explicit country APPLY confirmation;
6. continue from `nextOffset`;
7. rerun for idempotency when required;
8. finalise Search Projection after country completion.

## Remaining Gate Work
- broader production-grade PIM editing;
- review/evidence ergonomics;
- completeness/bulk-management UX;
- role/permission UAT;
- production routing consistency for country-specific adapters.

---

# Phase 3 — Layer 2 Source Enrichment

**Status:** PLANNED / PARTIALLY PROTOTYPED

## Scope
Acquire non-regulatory enrichment evidence such as fees, intakes, English requirements, scholarships, descriptive content and approved long-tail attributes.

## Entry Dependency
Sufficient Layer 1 country identity/coverage maturity must exist first.

## Gate Principles
- attach enrichment to stable canonical IDs;
- preserve source evidence/version/hash;
- apply source-priority rules;
- route conflicts/uncertainty to review;
- enrichment must not silently override regulatory truth.

---

# Phase 4 — Layer 3 AI Enrichment

**Status:** PLANNED

## Scope
Use approved AI models to transform unstructured evidence into structured candidate facts where deterministic extraction is insufficient.

## Gate Principles
- AI output is evidence-linked structured suggestion, not automatic canonical truth;
- schemas and confidence policies are versioned;
- invalid/ambiguous output fails safely or enters review;
- token/cost/rate limits are controlled;
- repeatability and lineage are testable.

---

# Phase 5 — Data Quality & Human Review

**Status:** FOUNDATION PRESENT / IN PROGRESS

## Scope
- conflict detection;
- review queue;
- suggestion acceptance/rejection;
- provenance inspection;
- data-quality scoring/completeness;
- audit trail and reviewer accountability.

## Gate
Representative multi-country conflicts and enrichment suggestions must be safely reviewable without bypassing canonical/source-authority rules.

---

# Phase 6 — Search / API / Consumer Experience

**Status:** PARTIALLY COMPLETE

## Current Accepted Position
- AU Search Projection: PASS.
- NZ Search Projection: PASS.
- Combined accepted Search Documents after NZ: **33,105**.

## Remaining Scope
- broader multi-country search UAT;
- API contracts and pagination/filtering;
- semantic/vector search where approved;
- consumer/counsellor experience;
- search relevance/performance/observability.

## Gate
Search/API results must remain derived from canonical accepted data, support country/filter boundaries correctly and meet representative performance/relevance targets.

---

# Phase 7 — Production Hardening & Operations

**Status:** IN PROGRESS

## Scope
- privilege/RLS/security review;
- runtime ceilings and batching;
- retries/resume/idempotency;
- source-health monitoring;
- evidence retention;
- job observability;
- Search Projection finalisation strategy;
- backup/recovery/cutover/runbooks;
- operational documentation.

## Active Hardening Items
- remove per-slice concurrent full-catalogue finalisation; finalise once per completed country load or serialize finalisation;
- retain service-role-only write/evidence/finalisation RPC boundary;
- maintain retired UAT harnesses as disabled/410 or remove them in later cleanup;
- continue eliminating snapshot-backed country paths before production acceptance;
- preserve DE safety guard until accepted Provider identity exists.

## Production Readiness Gate
The programme is production-ready only when required country gates, security checks, monitoring, recovery, operational runbooks and release/cutover criteria are accepted.

---

## 3. Immediate Programme Sequence

1. **CA Layer 1 Production Gate — ACTIVE.**
2. GB Layer 1 Production Gate.
3. US Layer 1 Production Gate.
4. IE Layer 1 Production Gate.
5. Re-enter DE blocker/remediation and rerun complete DE gate.
6. Continue Phase 2/5/6 maturation and Phase 7 hardening in parallel where it does not compromise Phase 1 sequencing.

Do not advance a country merely because its legacy snapshot or source URL is reachable. The accepted AU/NZ gate standard remains mandatory.

---

## 4. Current Programme Decision

**NZ is accepted. CA is the next active country. DE remains deferred/blocked.**
