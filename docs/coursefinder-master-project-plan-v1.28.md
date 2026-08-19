# CourseFinder Master Project Plan v1.28

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.27.md`  
**Last consolidated:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.28.md`  
**Running build:** `docs/coursefinder-running-build-v2.30.md`  
**AU completeness gate:** `docs/uat/coursefinder-au-geography-fields-completeness-gate-uat-v1.0.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity | PASS / ACCEPTED | Preserve exact CRICOS Provider/Course identity |
| AU Layer 1 geography + field completeness | **PASS / BOUNDED SOURCE-NULL GAP** | Provider State and Course ASCED complete; 1 Campus State remains source-null |
| NZ Layer 1 NZQA | PASS / ACCEPTED | Maintain canonical identity substrate |
| CA Layer 1 | PAUSED / UNPUBLISHED | Preserve canonical/history; no fragmented expansion |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed Provider outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped student-flow observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled evidence-backed expansion only |
| AU first-party Course enrichment | **NEXT AU DATA GATE** | Official Course Links, Fees, Intakes, English requirements |
| Admin/PIM | IN PROGRESS | Consume authoritative State/Field/readiness filters |
| Search/API enrichment | PENDING | Explicit consumer contract required |

## Phase 0 — Foundation & Architecture

**Status: COMPLETE / GOVERNED**

Architecture v2.10.28 adds explicit contracts for:
- Provider postal geography versus Campus operating geography;
- Course multi-State geography through Course↔Campus relationships;
- source-evidenced ASCED Course fields;
- Course delivery from Course↔Campus facts;
- relational Course Links and temporal Course Fees as Layer 2 domains.

No geography or field may be inferred merely to improve completeness.

## Phase 1 — Layer 1 Regulatory / Canonical Data

**Status: AU + NZ ACCEPTED; AU COMPLETENESS CORRECTION PASSED**

AU accepted state now includes:
- 1,546 / 1,546 Providers with direct CRICOS postal subdivision;
- 3,921 / 3,922 Campuses with direct CRICOS State;
- 26,648 / 26,648 Courses with exact CRICOS/ASCED narrow Field;
- 26,648 evidence-backed Course field observations;
- 47,671 Course↔Campus relationships retained unchanged.

The one Campus geography null is proven to be null in the authoritative CRICOS source and is not repaired from postcode.

The Course filter must use linked Campus State, not Provider postal State.

## Phase 2 — Admin / PIM UX

**Status: IN PROGRESS**

Backend decision/filter semantics now support:
- Country;
- State/Region through Course Campus geography;
- Provider;
- Study Level;
- exact ASCED Field;
- Delivery through Course↔Campus;
- Has State;
- Has Course Link;
- Has Fee;
- Has Intake;
- Has English requirement;
- Has Scholarship;
- completeness/freshness/lifecycle/publication.

The browser API client now carries Has State / Has Link arguments. Browser-rendered control UAT remains a separate UI deployment/UAT step.

## Phase 3 — Layer 2 Structured Source Enrichment

**Status: ACTIVE**

Accepted AU gates remain QILT, PRISMS and first-source Scholarships.

### Next AU subphase — first-party Course facts

Current structured coverage is deliberately zero for:
- official Course Links;
- Course Fees;
- Intakes;
- English requirements.

These are now the next AU evidence-backed ingestion gate.

Required source contract:
1. qualify first-party Provider/University source;
2. resolve source Course to accepted canonical Course using an authoritative stable key, preferably published CRICOS Course code where available;
3. capture content-hashed evidence;
4. retain source-local observation/link/fee keys;
5. preserve year/audience/campus/validity semantics;
6. bounded dry-run/APPLY/replay/idempotency;
7. queue ambiguity rather than fall back to title matching.

`catalogue.course_links` and `catalogue.course_fees` are structurally ready for this work.

## Phase 4 — Layer 3 AI Enrichment

**Status: NOT STARTED AS PRODUCTION PHASE**

Do not use AI to fill a source-null CRICOS State or invent fees/links. AI can later assist evidence-backed extraction only where deterministic parsing is insufficient.

## Phase 5 — Data Quality & Human Review

**Status: ACTIVE FOUNDATION**

New natural AU exception queues include:
- 1 Campus whose CRICOS State is null;
- 35 Courses without authoritative linked Campus State;
- 34 Courses without Course↔Campus/delivery relation;
- 26,648 Courses missing structured Course Link;
- 26,648 Courses missing structured Fee;
- current Intake/English gaps.

A missing fact means structured data is absent; it does not assert the real-world fact does not exist.

## Phase 6 — Search / API / Consumer Experience

**Status: FOUNDATION ACTIVE / ENRICHMENT GATED**

State and Field filter semantics can now be based on authoritative canonical data, but Search projection changes remain separately governed.

Course multi-State behavior must be preserved in consumer filters; a representative State must not suppress valid additional Campus States.

## Phase 7 — Production Hardening & Operations

**Status: PARTIAL**

The AU completeness correction proves:
- direct authoritative CSV acquisition;
- immutable evidence capture;
- exact content-hash pinning across batches;
- bounded APPLY;
- service-layer identity preservation;
- no-inference geography behavior;
- evidence-backed classification observations;
- replay/idempotency;
- runtime fallback when a national ZIP path exceeds Edge compute.

## Next programme action

Proceed with **M1-L2-AU-COURSE-FACTS** as the next AU data gate:
- qualify first-party Course URL/fee/intake/English sources;
- implement evidence-backed relational ingestion;
- start with bounded authoritative Provider sources and expand only after replay/idempotency and identity gates pass.

In parallel, Admin/PIM may expose the now-proven State, Field, Delivery, Has State and Has Link decision filters. Do not mark Fees/Links complete until the Layer 2 source gate passes.