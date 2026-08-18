# CourseFinder Master Project Plan v1.26

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.25.md`  
**Last consolidated:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.26.md`  
**Running build:** `docs/coursefinder-running-build-v2.28.md`  
**QILT gate:** `docs/uat/coursefinder-layer2a-au-qilt-production-gate-uat-v1.0.md`  
**PRISMS gate:** `docs/uat/coursefinder-layer2a-au-prisms-production-gate-uat-v1.0.md`  
**Scholarship gate:** `docs/uat/coursefinder-layer2-scholarships-au-first-source-gate-uat-v1.0.md`

This version retains the source-qualified country strategy and records completion of the first authoritative Australian Scholarship source gate: **M1-L2-SCHOLARSHIPS AU first-source is PASS / ACCEPTED**.

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS | PASS / ACCEPTED | Maintain canonical Provider/Course identity substrate |
| NZ Layer 1 NZQA | PASS / ACCEPTED | Maintain canonical identity substrate |
| CA Layer 1 | PAUSED / UNPUBLISHED | Preserve canonical/history; no fragmented expansion |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed Provider outcomes; no identity authority |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped student-flow observations; no identity authority |
| AU Scholarships | **PASS / FIRST-SOURCE ACCEPTED** | Expand only through qualified stable identifiers/evidence; keep publication separately gated |
| NZ Education Counts | QUEUED | Apply source-qualified structured-enrichment pattern |
| NZ Scholarships | QUEUED | Qualify official/provider sources before implementation |
| Admin/PIM | IN PROGRESS | Add relational Scholarship/evidence/outcome/review governance surfaces |
| Search/API enrichment | PENDING | Project accepted Layer 2 facts only after explicit consumer/search contract |

## Live accepted Australian structured enrichment

### QILT

Production Provider-outcome observations: **2,033**.

Accepted surveys remain GOS, SES, GOS-L and ESS. QILT enriches already-existing CRICOS Providers and has no Provider/Course identity authority.

### PRISMS

Accepted student-flow observations: **2,270** from the Department of Education ABS SA4 publication, including **201** explicit privacy-suppressed `<5` observations.

The source does not publish Provider/Course identifiers; accepted observations therefore keep Provider/Course scope null.

### Scholarships

First-source canonical population:
- Scholarships: **4**;
- Source Identifiers: **4**;
- Offering Cycles: **4**;
- Application Windows: **5**;
- Criterion Groups: **5**;
- Eligibility Criteria: **12**;
- Scopes: **3**;
- Award Tiers: **3**;
- Coverage: **10**.

All four Scholarship rows remain **unpublished**.

Accepted source contracts:
- Study Australia — stable 32-hex Scholarship source identifiers; Provider association only through the official Provider page's published CRICOS and exact accepted canonical registration;
- DFAT Australia Awards — enduring `AAS` Scholarship identity with `2027` as an Offering Cycle and separate country/application windows;
- Research Training Program — central program identity/coverage qualified, Provider-specific application windows deliberately bounded until first-party Provider evidence is acquired.

This first-source gate proves architecture and runtime behaviour. It is not a full national Scholarship catalogue load.

## Phase 0 — Foundation & Architecture

**Status: COMPLETE / GOVERNED**

Architecture v2.10.26 now contains accepted production contracts for:
- Layer 1 Provider/Course canonical identity;
- QILT Provider outcomes;
- PRISMS student-flow observations;
- relational Scholarships with source identity, cycles, windows, scopes, compound eligibility, award tiers, coverage and evidence/version history.

The common authority rule remains:

**Layer 2 sources enrich accepted canonical entities/dimensions; they do not redefine Layer 1 Provider/Course identity.**

Scholarships are independent canonical entities whose identity is established from source-native Scholarship identifiers rather than titles.

## Phase 1 — Layer 1 Regulatory / Canonical Data

**Status: AU + NZ ACCEPTED; COUNTRY EXPANSION PAUSED**

No change from v1.25.

Accepted AU substrate remains:
- Providers: 1,546;
- Courses: 26,648.

Accepted Search remains the separately governed AU+NZ projection of **33,105** documents.

Canada remains preserved but unpublished/paused. Future Layer 1 country work remains source-qualification-first.

## Phase 2 — Admin / PIM UX

**Status: IN PROGRESS**

The Scholarship gate now supplies real relational data for the Admin/PIM Scholarship workspace.

Required Scholarship Admin behaviour:
- show canonical Scholarship stable identity and source identifiers separately from title;
- show Provider association method and CRICOS evidence where applicable;
- show Offering Cycles and their lifecycle independently from Scholarship lifecycle;
- show multiple Application Windows per cycle;
- show Scopes separately from applicant Eligibility;
- render nested `all` / `any` Eligibility groups without flattening semantics;
- show Award Tiers separately from Coverage;
- expose source/evidence versions and private evidence metadata;
- preserve unpublished/publication status as a separate governance decision;
- route unresolved mappings or incomplete source structure to governed review rather than guessing.

QILT/PRISMS evidence and review surfaces remain required alongside Scholarship UX.

## Phase 3 — Layer 2 Structured Source Enrichment

**Status: ACTIVE / THREE AU GATES ACCEPTED**

### 3A — Australia QILT

**PASS / COMPLETE FOR INITIAL PRODUCTION GATE.**

Accepted surveys: GOS, SES, GOS-L and ESS.

### 3B — Australia PRISMS

**PASS / COMPLETE FOR INITIAL PRODUCTION GATE.**

Accepted first source: Department of Education PRISMS-derived international enrolment/commencement data by ABS SA4.

### 3C — New Zealand Education Counts

**QUEUED.**

Reuse the evidence/version/time-scoped observation pattern and map only authoritative dimensions to accepted NZ canonical identities.

### 3D — Scholarships

**AU FIRST-AUTHORITATIVE-SOURCE GATE: PASS / ACCEPTED.**

Accepted now:
- Study Australia stable source identity and exact-CRICOS Provider mapping contract;
- DFAT Australia Awards enduring Scholarship identity, 2027 cycle/windows, compound eligibility and coverage;
- RTP bounded source contract;
- private content-hashed evidence and source-record version history;
- deterministic dry-run/APPLY/replay/idempotency behaviour;
- service-role-only writes and unpublished canonical state.

Next Scholarship work is controlled expansion rather than model redesign:
- additional Study Australia records in bounded evidence-backed batches;
- first-party Provider RTP windows where justified;
- New Zealand official/provider Scholarship qualification and ingestion.

## Phase 4 — Layer 3 AI Enrichment

**Status: NOT STARTED AS PRODUCTION PHASE.**

The accepted AU structured-source gates continue to prefer deterministic extraction. AI may later assist evidence-backed structure where official sources are unstructured, but cannot invent identity, eligibility or award facts.

## Phase 5 — Data Quality & Human Review

**Status: FOUNDATION PRESENT / REAL REVIEW WORKLOAD AVAILABLE.**

Review surfaces must now support:
- QILT unmatched/ambiguous Provider labels;
- PRISMS source taxonomies without exact canonical crosswalks;
- Scholarship Provider/source ambiguities;
- incomplete or narrative-only eligibility structure;
- explicit approval/rejection of mappings and derived structure with evidence lineage.

Human review may approve explicit crosswalks/structure. It must not rewrite Layer 1 identity or fabricate Scholarship facts.

## Phase 6 — Search / API / Consumer Experience

**Status: FOUNDATION ACTIVE; ENRICHMENT PUBLICATION REMAINS SEPARATELY GATED.**

Accepted QILT and PRISMS read projections do not imply Search ranking/filter publication.

Scholarships likewise remain unpublished after the source gate.

M1-SEARCH must define Scholarship consumer semantics before projection, including:
- current/closed cycle selection;
- relevant application-window selection;
- eligibility display/evaluation boundaries;
- Award Tier/Coverage display;
- missing/unknown data behaviour;
- evidence/source presentation;
- ranking/filtering rules and deduplication.

No Scholarship should enter student-facing Search solely because canonical ingestion has passed.

## Phase 7 — Production Hardening & Operations

**Status: PARTIAL / INITIAL AU LAYER 2 GATES PASSED.**

Across QILT, PRISMS and Scholarships the platform has now proven:
- authoritative live-source acquisition;
- source-contract validation;
- immutable private evidence with content hashes;
- source/version/time/cycle lineage;
- bounded service-role APPLY;
- replay/idempotency;
- governed canonical crosswalks only;
- explicit withholding of unsafe mappings;
- one-time nonce Edge invocation;
- deny-by-default internal data structures;
- Layer 1/Search regression protection;
- autonomous defect correction before handover;
- integrity/security/performance UAT.

Existing unrelated Supabase advisor notices remain programme hardening items and are not blockers for these accepted gates.

## Milestone 1 delivery position

Milestone 1 now demonstrates the canonical/enrichment architecture deeply in Australia and New Zealand rather than chasing unsupported country count:

1. AU Layer 1 CRICOS — complete/accepted.
2. NZ Layer 1 NZQA — complete/accepted.
3. AU QILT — initial Layer 2A production gate complete.
4. AU PRISMS — initial Layer 2A production gate complete.
5. AU Scholarships — first-authoritative-source relational gate complete.
6. Admin/PIM governance — in progress.
7. Search/API consumer enrichment contracts — pending.
8. NZ Education Counts / NZ Scholarships — queued source-qualified expansion.
9. Future Layer 1 countries — remain source-qualification/HOLD unless the complete gate passes.

## Next programme action

The Scholarship relational architecture is now proven with real authoritative AU sources and should not be redesigned merely to accelerate catalogue count.

Approved next Milestone 1 work can proceed in parallel:
1. **M1-PIM** — implement relational Scholarship, evidence and review workspaces using the accepted live data;
2. **M1-SEARCH** — define publication/filter/ranking semantics for accepted QILT/PRISMS/Scholarship facts;
3. **M1-L2-SCHOLARSHIPS** — bounded expansion of qualified Study Australia records and provider-specific RTP evidence;
4. **NZ Education Counts / NZ Scholarships** — qualify and implement the next structured NZ sources.

Do not reopen accepted AU Provider/Course identity decisions and do not publish enrichment without its separate consumer gate.
