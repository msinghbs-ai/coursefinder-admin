# CourseFinder Master Project Plan v1.29

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.28.md`  
**Last consolidated:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.29.md`  
**Running build:** `docs/coursefinder-running-build-v2.31.md`  
**AU completeness gate:** `docs/uat/coursefinder-au-geography-fields-completeness-gate-uat-v1.0.md`  
**M1-SEARCH UAT:** `msinghbs-ai/Coursefinder-Pilot/docs/m1-search-governed-projection-uat-2026-08-19.md`

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
| Search governed projection + FTS | **PASS / ACCEPTED** | 33,105 AU+NZ projection; explicit country/enrichment gates; multi-State preserved |
| Website/Zoho API contracts | **PASS / CONTRACT ACCEPTED** | Curated versioned DTOs only; internal schemas remain private |
| Vector/semantic Search | **PENDING / GATED** | No accepted embeddings; model/profile + relevance/latency UAT required |

## Phase 0 — Foundation & Architecture

**Status: COMPLETE / GOVERNED**

Architecture v2.10.29 retains all v2.10.28 canonical contracts and adds the governed Search boundary:
- Search is derived, not canonical;
- Search country admission is explicit and independent of ingestion flags;
- Search enrichment admission is explicit and independent of row existence;
- Course State remains multi-valued through Course↔Campus geography;
- Website/Zoho consume curated DTO contracts rather than internal schemas;
- semantic/vector publication remains a separate gate.

No geography, field or enrichment fact may be inferred merely to improve completeness or Search coverage.

## Phase 1 — Layer 1 Regulatory / Canonical Data

**Status: AU + NZ ACCEPTED; AU COMPLETENESS CORRECTION PASSED**

AU accepted state remains:
- 1,546 / 1,546 Providers with direct CRICOS postal subdivision;
- 3,921 / 3,922 Campuses with direct CRICOS State;
- 26,648 / 26,648 Courses with exact CRICOS/ASCED narrow Field;
- 26,648 evidence-backed Course field observations;
- 47,671 Course↔Campus relationships retained unchanged.

The one Campus geography null is proven to be null in the authoritative CRICOS source and is not repaired from postcode.

The Course filter uses linked Campus State, not Provider postal State.

## Phase 2 — Admin / PIM UX

**Status: IN PROGRESS**

Backend decision/filter semantics support:
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

The browser API client carries Has State / Has Link arguments. Browser-rendered control UAT remains a separate UI deployment/UAT step.

## Phase 3 — Layer 2 Structured Source Enrichment

**Status: ACTIVE**

Accepted AU gates remain QILT, PRISMS and first-source Scholarships.

### Next AU subphase — first-party Course facts

Current structured coverage is deliberately zero for:
- official Course Links;
- Course Fees;
- Intakes;
- English requirements.

These remain the next AU evidence-backed ingestion gate.

Required source contract:
1. qualify first-party Provider/University source;
2. resolve source Course to accepted canonical Course using an authoritative stable key, preferably published CRICOS Course code where available;
3. capture content-hashed evidence;
4. retain source-local observation/link/fee keys;
5. preserve year/audience/campus/validity semantics;
6. bounded dry-run/APPLY/replay/idempotency;
7. queue ambiguity rather than fall back to title matching.

`catalogue.course_links` and `catalogue.course_fees` remain structurally ready for this work. Search gates for Link/Fee/Intake/English stay **blocked** until this UAT is accepted.

## Phase 4 — Layer 3 AI Enrichment

**Status: NOT STARTED AS PRODUCTION PHASE**

Do not use AI to fill a source-null CRICOS State or invent fees/links. AI can later assist evidence-backed extraction only where deterministic parsing is insufficient.

Search embeddings are also derived computation, not authoritative facts. An embedding model cannot be promoted merely because vector infrastructure exists.

## Phase 5 — Data Quality & Human Review

**Status: ACTIVE FOUNDATION**

Natural AU exception queues remain:
- 1 Campus whose CRICOS State is null;
- 35 Courses without authoritative linked Campus State;
- 34 Courses without Course↔Campus/delivery relation;
- 26,648 Courses missing structured Course Link;
- 26,648 Courses missing structured Fee;
- current Intake/English gaps.

A missing fact means structured data is absent; it does not assert the real-world fact does not exist.

## Phase 6 — Search / API / Consumer Experience

**Status: CORE GOVERNED PROJECTION + FTS + CONTRACT GATE PASS; VECTOR GATED**

### Accepted substrate

- Search projection version: `course-v2`
- total documents: **33,105**
- AU: **26,648**
- NZ: **6,457**
- generation: **12**
- replay: **0 changed / 33,105 unchanged**
- AU Courses with State: **26,613**
- AU Courses with delivery: **26,614**
- AU multi-State Courses retained: **4,388**

AU + NZ are explicitly Search-approved. CA and later countries cannot enter the accepted Search projection automatically after ingestion.

### Search enrichment governance

Scholarship is structurally admitted but publication-gated; current Search scholarship readiness remains 0 because current Scholarship rows are unpublished.

Link, Fee, Intake and English are explicitly Search-blocked until their Layer 2 gate is accepted.

### Search performance

Representative accepted database measurements:
- weighted FTS warm top-20: ~1.95 ms;
- structured State/Field/Delivery filter top-20: ~11.35 ms;
- hybrid request without accepted vectors: ~11.77 ms via deterministic FTS fallback.

The initial generic hybrid-fallback implementation (~159 ms) was rejected and optimised before gate acceptance.

### Consumer contracts

Website: `website-course-search-v1` via `api.website_course_search_v1`, service-gateway only and published-only.

Zoho: `zoho-course-candidates-v1` via `api.zoho_course_candidates_v1`, authenticated Counsellor-or-higher and published/internal only.

Internal canonical/Search/evidence schemas are not public contracts.

All 33,105 current Search Documents remain unpublished, so consumer API UAT correctly returns empty `items` arrays. Publication was not changed to manufacture a positive demo result.

### Vector/semantic sub-gate

Current accepted embedding count: **0**. HNSW structure is valid and hybrid fallback works, but vector relevance and latency are not accepted.

Required vector sub-gate:
1. approve embedding model/profile/dimensions and cost/latency envelope;
2. generate embeddings keyed to semantic-content hash;
3. measure vector-only latency and filtered retrieval behavior;
4. compare FTS versus vector versus hybrid relevance on a curated query set;
5. prove replay/cache invalidation when semantic content changes;
6. approve semantic publication separately.

## Phase 7 — Production Hardening & Operations

**Status: PARTIAL**

The accepted programme now additionally proves:
- dry-run/APPLY/replay Search projection lifecycle;
- explicit country admission and enrichment admission gates;
- deterministic projection/content hashing;
- multi-State consumer filtering without representative-State collapse;
- FTS index use and bounded benchmark evidence;
- deterministic hybrid fallback when vectors are unavailable;
- curated Website/Zoho DTO boundaries with no anonymous internal-schema exposure.

Existing Admin/PIM public `SECURITY DEFINER` advisor warnings and Auth leaked-password-protection warning remain separate hardening work.

## Next programme action

Proceed with **M1-L2-AU-COURSE-FACTS** as the next AU data gate:
- qualify first-party Course URL/fee/intake/English sources;
- implement evidence-backed relational ingestion;
- start with bounded authoritative Provider sources and expand only after replay/idempotency and identity gates pass.

In parallel, **M1-SEARCH-VECTOR** may run as a bounded derived-search sub-gate to select/approve the embedding profile and benchmark semantic/hybrid relevance. It must not publish vectors or broaden consumer visibility until its own acceptance gate passes.

Admin/PIM may continue consuming the proven State, Field, Delivery, Has State and Has Link semantics. Fees/Links/Intakes/English must remain incomplete until the corresponding Layer 2 source gate passes.
