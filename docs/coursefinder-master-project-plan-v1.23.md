# CourseFinder Master Project Plan v1.23

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.22.md`  
**Last consolidated:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.23.md`  
**Running build:** `docs/coursefinder-running-build-v2.25.md`  
**Source matrix:** `docs/coursefinder-country-authoritative-source-matrix-v1.0.md`

## Programme decision

Country-by-country Layer 1 ETL generation is **PAUSED** unless the target country first passes the source-qualification gate in architecture v2.10.23.

The programme will no longer treat country count as the Milestone 1 success measure or compensate for fragmented national sources by building institution-by-institution ETL indefinitely.

Milestone 1 focus is now:
- prove the canonical platform deeply with Australia and New Zealand;
- add structured outcomes/enrichment and Scholarship sources to those accepted canonical identities;
- finish the Admin/PIM governance surfaces;
- preserve but pause Canada;
- qualify future countries at source level before implementation begins.

## Current production position

| Country | Layer 1 status | Publication/Search status | Programme decision |
|---|---|---|---|
| Australia | **PASS / ACCEPTED** | **ACTIVE** | Maintain and enrich |
| New Zealand | **PASS / ACCEPTED** | **ACTIVE** | Maintain and enrich |
| Canada | **PAUSED / BLOCKED** | **NOT IN ACCEPTED SEARCH** | Preserve current canonical/history; no further institution-by-institution ETL under M1 |
| United Kingdom | HOLD | Not active | Source qualification only; structured outcomes may proceed separately |
| United States | HOLD | Not active | Source qualification only; College Scorecard considered Layer 2A first |
| Ireland | HOLD / QUALIFY | Not active | QQI machine-access/source gate before adapter build |
| Germany | PAUSED | Not active | Machine-access/licensing/completeness gate before adapter build |

## Live Milestone 1 data substrate

At the programme reset:

- Providers: **3,085**
- Physical Courses: **43,358**
- Campuses: **3,922**
- Course-Campus links: **47,671**
- Evidence artifacts: **1,017**
- Pipeline jobs/history: **948**
- Search Documents: **33,105**

Country physical populations:
- AU — 1,546 Providers / 26,648 Courses;
- NZ — 409 Providers / 6,457 Courses;
- CA — 1,130 Providers / 10,253 physical Courses.

Canada lifecycle state:
- 2,279 active scoped physical Course rows;
- 7,974 inactive/historical Course rows.

The accepted Search Projection is deliberately only:

`AU 26,648 + NZ 6,457 = 33,105`

Canada remains excluded from accepted student-facing Search while paused/blocked.

## Phase 0 — Foundation & Architecture

**Status: COMPLETE / GOVERNED**

Completed:
- canonical schema separation;
- PIM configuration model;
- Provider/Course/Scholarship relational domains;
- evidence/provenance architecture;
- workflow/review architecture;
- Search Projection and vector/search foundation;
- API/RPC security boundary;
- Supabase Edge execution boundary;
- source-qualified country policy in v2.10.23.

Current architecture baseline: `coursefinder-database-architecture-v2.10.23.md`.

## Phase 1 — Layer 1 Regulatory / Canonical Data

**Status: PARTIALLY COMPLETE / COUNTRY EXPANSION PAUSED**

### Accepted

Australia:
- CRICOS full national load accepted;
- Provider/Course stable identity;
- Locations/Course Locations and canonical Campus relationships;
- repeatable evidence/idempotency/reset behaviour.

New Zealand:
- NZQA national tertiary Provider/Qualification load accepted;
- 409 Providers / 6,457 Courses;
- identity/idempotency/Search integrity accepted.

### Preserved but paused

Canada:
- IRCC Provider authority accepted at 1,130 DLIs;
- substantial source-scoped Course identity work retained;
- 10,253 physical Course rows currently present;
- national Bachelor+ source coverage remains fragmented;
- no further institution-by-institution ETL in Milestone 1;
- CA remains unpublished from accepted Search.

### Future country policy

GB/US/IE/DE do not enter implementation merely because useful public datasets exist. Each must first pass the complete Layer 1 source gate.

## Phase 2 — Admin / PIM UX

**Status: IN PROGRESS**

Available foundation:
- authenticated PIM/Admin shell;
- Dashboard;
- Providers;
- Courses and Course detail workspace;
- Campuses;
- Course Collections;
- Categories;
- Regulatory Sources;
- Jobs/Review/Scholarship/configuration foundations.

Remaining priority:
- canonical identity/evidence/lifecycle visibility;
- Provider detail;
- complete Attribute Family/Group/Option administration;
- Completeness Profiles;
- Evidence Viewer;
- richer role-aware actions;
- Scholarship relational workspace;
- outcome/observation administration surfaces.

## Phase 3 — Layer 2 Structured Source Enrichment

**Status: FOUNDATION READY / NOW PRIORITY**

Priority workstreams:

### 3A — Australia QILT
- Graduate Outcomes Survey;
- Student Experience Survey;
- GOS-Longitudinal;
- Employer Satisfaction Survey.

Purpose: outcome/experience observations mapped to accepted canonical Providers/Courses/study dimensions without redefining identity.

### 3B — Australia PRISMS
- international enrolment;
- commencement;
- student/trend observations.

### 3C — New Zealand Education Counts
- provider/qualification achievement;
- completion/progression and related structured observations.

### 3D — Scholarship enrichment
- Study Australia / official/provider sources first;
- NZ official/provider sources second;
- other country government scholarship datasets can be independently qualified even where Layer 1 is on HOLD.

## Phase 4 — Layer 3 AI Enrichment

**Status: NOT STARTED AS PRODUCTION PHASE**

AI is reserved for evidence-backed structure/extraction that deterministic sources cannot provide reliably. It cannot establish Layer 1 identity.

## Phase 5 — Data Quality & Human Review

**Status: FOUNDATION PRESENT / UX AND OPERATIONS PENDING**

Existing workflow schema/review lineage remains. Next work follows structured enrichment so real ambiguity can exercise the governance model.

## Phase 6 — Search / API / Consumer Experience

**Status: FOUNDATION ACTIVE; ACCEPTED SEARCH = AU + NZ**

Current accepted Search Documents: 33,105.

Next work:
- enrich search projection with approved outcome/scholarship facts;
- preserve source/country publication gates;
- benchmark FTS/hybrid/vector paths after representative enriched data exists;
- curate Website and Zoho contracts separately.

## Phase 7 — Production Hardening & Operations

**Status: PARTIAL**

Already proven across accepted Layer 1 paths:
- RLS/private-schema posture;
- service-role server-side boundary;
- private evidence;
- idempotent bounded ingestion;
- Search Projection reconciliation;
- reset/UAT discipline.

Remaining:
- production monitoring/alerting;
- broader performance baselines;
- disaster/recovery/retention operations;
- Auth leaked-password protection decision;
- final release runbooks.

## Milestone 1 deliverable strategy

Milestone 1 will demonstrate quality and extensibility rather than nominal global coverage:

1. AU canonical regulatory catalogue — complete.
2. NZ canonical regulatory catalogue — complete.
3. canonical identity/history/evidence model — complete foundation.
4. structured outcomes — QILT/PRISMS/Education Counts next.
5. relational Scholarship domain — foundation complete; source ingestion next.
6. Admin/PIM governance — in progress.
7. accepted Search/API substrate — AU+NZ active.
8. future country adapters — source-qualified backlog only.

## New process/chat boundaries

Work must move into separate process chats rather than one long country thread:

1. **M1-ARCH — CourseFinder Milestone 1 Canonical Architecture & Meeting**
2. **M1-L2-AU-QILT — Australia QILT Outcomes Enrichment**
3. **M1-L2-AU-PRISMS — Australia International Student Enrichment**
4. **M1-L2-SCHOLARSHIPS — Scholarship Source Enrichment**
5. **M1-PIM — Admin/PIM UX & Governance**
6. **M1-SEARCH — Search/API Projection & Consumer Contracts**
7. **SRC-QUAL — Country Source Qualification** — research/gate only; no ETL implementation until PASS.
8. **CA-PAUSED — Canada Layer 1 Frozen State** — only use if resuming after a new source strategy is approved.

## Current programme decision

**Country ETL expansion is paused. AU and NZ form the accepted Milestone 1 canonical substrate. Canada is frozen with its existing canonical/history work preserved and unpublished. Milestone 1 effort now shifts to structured outcomes, Scholarships, PIM governance and accepted Search/API quality.**
