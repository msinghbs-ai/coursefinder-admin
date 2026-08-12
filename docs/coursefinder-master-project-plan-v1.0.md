# Coursefinder Master Project Plan v1.0

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Last consolidated:** 12 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.9.1.md`  
**Running build baseline:** `docs/coursefinder-running-build-v2.1.md`  
**Latest accepted major UAT gate:** Layer 1 Full AU CRICOS Ingestion — **PASS**  
**Current programme position:** Phase 1 multi-country Layer 1 production validation; AU accepted, DE blocked pending identity/source-authority remediation; Phase 7 hardening in parallel.

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
- links to detailed technical documentation.

Detailed implementation logs belong in the relevant technical documents and repositories. This master plan records the programme-level consequence of implementation changes.

### Source-of-truth order

Where documents conflict, use the following authority order:
1. approved architecture and database identity rules;
2. this master project plan for programme scope/status/sequencing;
3. current running-build documentation for deployed runtime behaviour;
4. accepted UAT evidence for gate decisions;
5. Admin/operator guides and detailed technical implementation documents.

Any change to architecture, stable identity, source-of-truth rules, phase scope, canonical ownership, security boundaries or production gate criteria must be explicitly reflected here and in the relevant architecture documentation.

---

## 2. Overall Programme Status

| Phase | Name | Status | Gate Position |
|---|---|---|---|
| 0 | Foundation & Architecture | **COMPLETE / ACCEPTED BASELINE** | Architecture v2.9.1 authoritative |
| 1 | Layer 1 Regulatory Data | **IN PROGRESS** | AU PASS; DE BLOCKED; remaining country gates pending |
| 2 | Admin / PIM UX | **IN PROGRESS / OPERATIONAL FOUNDATION** | Production-style regulatory workflow operational; broader UX incomplete |
| 3 | Layer 2 Source Enrichment | **PLANNED / PARTIALLY PROTOTYPED** | Broad production rollout deferred pending Layer 1 maturity |
| 4 | Layer 3 AI Enrichment | **PLANNED** | No production gate accepted |
| 5 | Data Quality & Human Review | **FOUNDATION PRESENT / IN PROGRESS** | Workflow model exists; full operational UAT pending |
| 6 | Search / API / Consumer Experience | **PARTIALLY COMPLETE** | AU Search Projection/FTS PASS; multi-country/API/semantic/consumer UAT pending |
| 7 | Production Hardening & Operations | **IN PROGRESS** | Residual security, multi-country, monitoring and cutover gates remain |

### Current overall phase

The programme is in **Phase 1 — Layer 1 Regulatory Data**, specifically multi-country production validation, with Phase 7 security/operational hardening running in parallel.

The accepted AU regulatory baseline proves the canonical architecture and bounded execution model. Additional countries must prove the same identity, lineage, idempotency, integrity, search and security properties without weakening architecture v2.9.1.

---

# Phase 0 — Foundation & Architecture

**Status:** COMPLETE / ACCEPTED BASELINE

## Scope
- Production-model PostgreSQL/Supabase schema architecture.
- Separation of canonical catalogue truth, enrichment evidence, workflow governance, search projection and consumer APIs.
- Stable identity model for Providers, Courses and related canonical entities.
- Evidence/provenance and temporal-validity model.
- Security schemas, curated API boundaries and service/browser separation.
- Migration/reset/rebuild strategy.
- Regional deployment and reproducibility approach.

## Dependencies
None; this phase establishes the dependency baseline for all later phases.

## Architecture Impact
Architecture v2.9.1 is authoritative.

Core principles:
- normalised canonical write model;
- denormalised/rebuildable search/read model;
- stable IDs and explicit identifiers/aliases;
- names/titles never act as identity;
- Layer 1 owns regulatory truth;
- Layer 2 acquires/enriches evidence;
- Layer 3 performs structured AI extraction where required;
- Layer 4/human workflow governs acceptance/rejection/conflict resolution;
- commercial ranking remains outside canonical academic truth;
- internal schemas are not general browser CRUD surfaces.

## DB Impact
Authoritative schema families:
- `ref`
- `catalogue`
- `pim`
- `scholarship`
- `integration`
- `pipeline`
- `search`
- `publishing`
- `workflow`
- `security`
- `api`
- `extensions`

`public` is not the canonical business-table schema.

## Deliverables
- Approved database architecture v2.9.1.
- Production migration chain.
- Stable Provider/Course identity model.
- Evidence and lineage model.
- Search projection architecture.
- Layer 4 workflow data model.
- API/security boundary design.

## UAT Gate
**ACCEPTED.**

The architecture is proven for current programme use by the accepted AU Layer 1 full-ingestion and Search Projection gate.

## Risks
- Architecture drift caused by implementation changes not reflected in authoritative documents.
- Reintroduction of name/title-based identity matching.
- Browser exposure of internal/service-only schemas or functions.

## Linked Technical Docs
- `docs/coursefinder-database-architecture-v2.9.1.md`
- `docs/coursefinder-production-handover-v2.9.1.md`

---

# Phase 1 — Layer 1 Regulatory Data

**Status:** IN PROGRESS — AU COMPLETE; DE BLOCKED; MULTI-COUNTRY VALIDATION ACTIVE

## Scope
- Country-specific authoritative regulatory acquisition.
- Source health and source configuration.
- Evidence capture and SHA-256 lineage.
- Parsing and normalisation.
- Stable regulatory identity.
- Deterministic canonical reconciliation.
- Idempotent reruns.
- Bounded/resumable execution.
- Search Projection rebuild after canonical ingestion.

## Dependencies
- Phase 0 architecture and stable identity rules.
- Country regulatory settings/source definitions.
- Private evidence storage.
- Service-role/Platform Admin execution boundary.
- Search Projection rebuild path.

## Architecture Impact
No approved change to canonical ownership.

Layer 1 remains the owner of regulatory truth. It must not derive identity from descriptive names or titles.

Production execution contract is bounded and resumable:
- `country`
- `apply`
- `offset`
- `batchSize`

Country adapters return progress including `nextOffset` and `hasMore` so long-running country loads are resumable rather than monolithic.

## DB Impact
Accepted identity pattern:
- Provider identity = `country + registration_scheme + stable regulator/source provider code`;
- Course identity = `provider + registration_scheme + stable regulator/source course code`.

Accepted AU identity hardening migration:
- `041_layer1_identifier_identity_hardening.sql`

Accepted AU canonical baseline:
- Providers: **1,546**
- Courses: **26,648**
- Campuses: **3,922**
- Course↔Campus links: **47,671**
- Search Documents: **26,648**

Current DE baseline after production-gate review:
- Providers: **0**
- Provider Identifiers: **0**
- Courses: **0**
- Course Registrations: **0**
- Search Documents: **0**

No DE schema change or canonical population was accepted during the blocked gate.

## Deliverables
### Complete
- AU CRICOS authoritative acquisition.
- AU evidence/provenance.
- AU Providers/Courses/Locations/Course Locations reconciliation.
- Full-scale identity hardening.
- AU idempotency and integrity validation.
- AU Search Projection rebuild.
- Production-style bounded Layer 1 execution control.

### DE gate review completed — remediation active
The deployed live paged DAAD adapter was inspected against the AU production standard.

Confirmed implementation properties:
- live DAAD JSON acquisition;
- bounded offset/batch pagination;
- calculated upstream start page;
- private evidence storage and SHA-256 lineage implementation;
- resumable `nextOffset` / `hasMore` contract;
- JWT + Platform Admin execution boundary;
- service-only Layer 1 RPC privileges.

Critical DE blocker:
- deployed `normaliseDaadCourse()` currently derives `provider_code` from `slug(c.academy)`;
- this is name-derived Provider identity and violates architecture v2.9.1;
- DE APPLY is therefore prohibited until a stable non-name institution identifier is used.

DE source-authority decision also remains explicit:
- current source registry marks `HRK Hochschulkompass` as DE `coverage_role=primary`;
- `DAAD International Programmes` is an official DAAD international-programme source but is complementary to the full HRK German study landscape;
- the programme must either retain HRK/base national authority for Provider/base-course identity and use DAAD as complementary official data, or explicitly approve a deliberately scoped DAAD International Programmes Layer 1 coverage model;
- neither option permits provider identity derived from institution name.

### Active after DE blocker
- DE provider-identity/source-authority remediation and complete re-test.
- GB UKVI/provider and configured course-source validation.
- NZ/CA/IE/US adapter validation and progressive replacement of snapshot-backed acquisition with authoritative live acquisition where required.

## UAT Gate
### AU
**PASS / ACCEPTED.**

### DE
**BLOCKED / NOT ACCEPTED FOR APPLY.**

Blockers:
1. Provider identity is currently generated from DAAD institution name (`slug(c.academy)`).
2. Full-country Layer 1 authority/coverage must be explicitly reconciled between current HRK-primary registry semantics and DAAD International Programmes scope.
3. End-to-end dry-run/APPLY/idempotency/integrity/Search Projection/performance/resume evidence must be rerun after identity remediation.

Detailed evidence:
- `docs/uat/coursefinder-layer1-de-production-gate-uat-v1.0.md`

### Per-country production gate
Each additional country must pass all of the following:
- authoritative source confirmed;
- source health/freshness confirmed;
- stable regulatory/source identity confirmed;
- bounded dry-run and APPLY succeed;
- evidence/provenance recorded;
- rerun creates zero duplicate canonical entities;
- integrity/orphan checks pass;
- Search Projection rebuild passes;
- execution remains within bounded runtime contract;
- privileges remain within approved service/admin boundaries;
- UAT evidence is committed under `docs/uat/`;
- this master plan is updated.

## Risks
- Source structure or endpoints changing without controlled adapter change.
- Snapshot-backed adapters being treated as production-complete.
- Name-derived identity causing duplicate or false-merged canonical entities.
- Country source coverage being mistaken for full regulatory coverage.
- High concurrent Course Location batches causing PostgreSQL statement timeouts.
- Monolithic full-country Edge requests exceeding execution ceilings.
- Country-specific regulatory semantics requiring explicit architecture extension.

## Linked Technical Docs
- `docs/coursefinder-running-build-v2.1.md`
- `docs/uat/coursefinder-layer1-au-full-ingestion-uat-v1.0.md`
- `docs/uat/coursefinder-layer1-de-production-gate-uat-v1.0.md`
- `docs/coursefinder-admin-guide-v1.6.md`

---

# Phase 2 — Admin / PIM UX

**Status:** IN PROGRESS / OPERATIONAL FOUNDATION

## Scope
- Admin navigation and PIM-style entity management.
- Country regulatory settings.
- Layer 1 operational control.
- Source health and adapter visibility.
- Evidence and reconciliation visibility.
- PIM families/groups/attributes/options/categories.
- Completeness indicators.
- Review workflow surfaces.
- Bulk operations/import/export where approved.

## Dependencies
- Phase 0 PIM/workflow schemas.
- Phase 1 regulatory/runtime contracts.
- Approved authentication/RBAC model.

## Architecture Impact
The Admin UI is a control/management surface; it does not redefine canonical ownership.

UI operations must use curated APIs/RPCs/Edge Functions and approved roles rather than direct unrestricted access to internal schemas.

## DB Impact
Uses existing:
- `pim.*`
- `workflow.*`
- `pipeline.*`
- `security.*`
- curated `api`/UI functions.

New UX requirements that imply a new canonical field/entity require architecture/database assessment before implementation.

## Deliverables
### Operational
- Country selection.
- Adapter/source information.
- Bounded batch size/offset controls.
- Validate-before-write flow.
- Explicit `APPLY <COUNTRY>` confirmation.
- Continue from returned/persisted `nextOffset`.
- Idempotency rerun capability.

### Remaining
- Production-grade PIM entity editing.
- Completeness and bulk-management UX.
- Evidence/review ergonomics.
- Consistent operational history/status presentation.
- Final role/permission UX validation.

## UAT Gate
Phase 2 is accepted when authorised roles can operate safely without service-role exposure, critical PIM entities can be managed, regulatory execution is resumable/auditable, evidence/review states are traceable, failed operations are actionable and permission negative tests pass.

## Risks
- Admin convenience bypassing architecture/security boundaries.
- UI assumptions driving undocumented DB schema changes.
- Operational state held only client-side rather than durable job/result records.
- Over-broad `SECURITY DEFINER` access.

## Linked Technical Docs
- `docs/coursefinder-admin-guide-v1.6.md`
- `docs/coursefinder-running-build-v2.1.md`
- `docs/coursefinder-database-architecture-v2.9.1.md`

---

# Phase 3 — Layer 2 Source Enrichment

**Status:** PLANNED / PARTIALLY PROTOTYPED — BROAD PRODUCTION ROLLOUT DEFERRED

## Scope
Acquire non-regulatory enrichment evidence from approved authoritative or provider sources, including tuition/fees, intakes, English requirements, scholarships, descriptive content, collections, academic options and other approved long-tail attributes.

## Dependencies
- Sufficient Layer 1 canonical coverage and stable IDs.
- Approved source registry/acquisition policies.
- Evidence/provenance pipeline.
- Change detection/content hashes.
- Phase 5 review workflow for uncertain/conflicting changes.

## Architecture Impact
Layer 2 acquires and normalises evidence but does not silently override regulatory truth. All enrichment attaches to stable canonical IDs and retains lineage.

## DB Impact
Primary areas:
- `pipeline.sources`
- `pipeline.acquisition_policies`
- `pipeline.jobs`
- `pipeline.evidence_artifacts`
- `pipeline.change_events`
- approved `catalogue`, `scholarship` and `pim` destinations.

## Deliverables
- Approved source matrix by country/domain.
- Source acquisition adapters.
- Evidence/version/hash capture.
- Idempotent change detection.
- Structured normalisation.
- Conflict/review routing.
- Operational metrics/retry controls.

## UAT Gate
Source authority/access, stable canonical linking, rerun idempotency, evidence versioning, source-priority rules, conflict routing, representative scale and reprocessing/rollback must pass.

## Risks
- Provider website instability/access restrictions.
- Contradictory or duplicate facts.
- Enrichment bypassing review/source-priority rules.
- Premature expansion before Layer 1 identity maturity.

## Linked Technical Docs
- `docs/coursefinder-database-architecture-v2.9.1.md`
- Approved Layer 2/source-specific documents as added.

---

# Phase 4 — Layer 3 AI Enrichment

**Status:** PLANNED

## Scope
Use approved AI models to transform unstructured evidence into structured candidate facts where deterministic extraction is insufficient.

## Dependencies
- Phase 2/3 evidence controls.
- Approved model/integration configuration.
- Versioned extraction profiles.
- Phase 5 review workflow.
- Confidence/validation policy.

## Architecture Impact
AI output is not automatically canonical truth. Layer 3 produces structured, evidence-linked suggestions; canonical acceptance follows deterministic validation and/or human review.

## DB Impact
Expected use of:
- `integration.models`
- `integration.extraction_profiles`
- `pipeline.extraction_runs`
- evidence references;
- workflow suggestions/review queue;
- approved canonical/PIM destinations after acceptance.

## Deliverables
- Model/provider configuration.
- Versioned extraction profiles.
- Structured schemas/validation.
- Confidence/routing policy.
- Cost/token/rate-limit controls.
- Evidence-linked results.
- Retry/idempotency behaviour.

## UAT Gate
Controlled repeatability, safe failure on invalid output, mandatory review/validation boundaries, lineage, cost/performance and representative extraction accuracy must pass.

## Risks
- Hallucination/overconfidence.
- Prompt/model drift.
- Unbounded AI cost.
- AI text confused with source evidence.
- Automatic acceptance of ambiguous facts.

## Linked Technical Docs
- `docs/coursefinder-database-architecture-v2.9.1.md`

---

# Phase 5 — Data Quality & Human Review

**Status:** FOUNDATION PRESENT / IN PROGRESS

## Scope
- Completeness measurement.
- Validation failures.
- Duplicate/conflict handling.
- Human review queues.
- Approve/reject/edit/reclassify workflows.
- Review reopening when evidence changes.
- Import/export validation.
- Audit history.

## Dependencies
- Stable canonical IDs.
- Evidence lineage from Layers 1–3.
- PIM completeness configuration.
- Admin UX/RBAC.

## Architecture Impact
Human review is the governance boundary for uncertain/conflicting enrichment. Review decisions must be auditable and preserve source/evidence history.

## DB Impact
Core tables include:
- `workflow.review_queue`
- `workflow.review_actions`
- `workflow.catalogue_suggestions`
- `workflow.import_jobs`
- `workflow.import_rows`
- `workflow.import_errors`
- `workflow.export_jobs`

## Deliverables
- Completeness profiles/requirements.
- Validation rules.
- Review queue prioritisation.
- Evidence-aware comparison UX.
- Append-only review actions.
- Reopen/supersede behaviour.
- Quality dashboards/metrics.

## UAT Gate
Conflict routing, auditable decisions, evidence-triggered reopening, lineage preservation, permission boundaries and completeness calculations must pass.

## Risks
- Review backlog growth.
- Inconsistent decisions.
- Accepted values losing evidence linkage.
- Unsafe bulk actions.

## Linked Technical Docs
- `docs/coursefinder-database-architecture-v2.9.1.md`
- Admin/PIM workflow documentation.

---

# Phase 6 — Search / API / Consumer Experience

**Status:** PARTIALLY COMPLETE

## Scope
- Rebuildable Search Projection.
- Structured filters and FTS.
- Search Profiles and intent aliases.
- Optional pgvector/semantic retrieval.
- API contracts for Website and authenticated consumers such as Zoho.
- Course detail/compare/related/recommendation surfaces.
- Academic ranking separated from downstream commercial re-ranking.

## Dependencies
- Canonical catalogue quality.
- Stable Coursefinder IDs.
- Search Projection rebuild process.
- Search Profile configuration.
- API/security boundary.
- Sufficient enrichment for advanced filters/recommendations.

## Architecture Impact
Search remains derived and rebuildable; it never becomes canonical truth.

Normal search path:
`structured filters -> FTS -> ranking`

Semantic path:
`intent normalisation -> hard filters -> query embedding/cache -> FTS candidates + vector candidates -> rank fusion -> academic ranking`

Commercial commission/preference remains downstream.

## DB Impact
Primary search tables:
- `search.profiles`
- `search.profile_fields`
- `search.intent_aliases`
- `search.documents` / current physical `search.course_documents`
- embeddings/jobs/query cache structures.

## Deliverables
### Complete / proven
- AU Search Projection rebuild.
- AU FTS baseline/indexed query performance.
- Search document parity with AU Courses.

### Remaining
- Multi-country Search Projection validation.
- Production API contract UAT.
- Consumer authentication/rate limiting/caching.
- Relevance acceptance set.
- Semantic benchmark/cost controls if enabled.
- Website/Zoho integration UAT.

## UAT Gate
Search parity/integrity, representative relevance, rebuildability, stable IDs, API field/security boundaries, rate limiting/caching/error behaviour and semantic benchmarks if enabled must pass.

## Risks
- Search projection becoming a write/source-of-truth surface.
- Relevance regressions as countries expand.
- Semantic cost/latency without measurable value.
- Commercial ranking leaking into canonical ranking.

## Linked Technical Docs
- `docs/coursefinder-database-architecture-v2.9.1.md`
- `docs/uat/coursefinder-layer1-au-full-ingestion-uat-v1.0.md`
- `docs/uat/coursefinder-layer1-de-production-gate-uat-v1.0.md`

---

# Phase 7 — Production Hardening & Operations

**Status:** IN PROGRESS

## Scope
- Security hardening.
- RBAC/RLS and privilege review.
- Secrets/authentication review.
- Runtime limits and batching standards.
- Monitoring/alerting/operational metrics.
- Backup/recovery and rollback.
- Deployment/release controls.
- Production region/runtime validation.
- Runbooks/operator documentation.
- Final production acceptance.

## Dependencies
- Accepted functional gates from Phases 0–6 as applicable.
- Stable migrations and reproducible deployment.
- Production secrets/configuration.
- Operational ownership.

## Architecture Impact
No production shortcut may weaken approved service/browser boundaries, stable identity or evidence lineage. Regional deployment remains reproducible from Git-tracked migrations/configuration and validated data.

## DB Impact
- Final privilege/RLS posture.
- Production indexes based on representative workload.
- Retention/cleanup policies.
- Backup/recovery validation.
- Migration/cutover reconciliation.

## Deliverables
- Security advisor remediation/acceptance record.
- `SECURITY DEFINER` exposure review.
- Leaked-password protection validation where applicable.
- Internal-schema RLS/privilege intent documented.
- Runtime/batch/concurrency standards.
- Monitoring/alerting/runbooks.
- Deployment/cutover plan.
- Backup/restore/rollback evidence.
- Final production UAT/handover.

## UAT Gate
Production readiness requires no unresolved Critical/High security issue without explicit acceptance, validated browser/service boundaries, safe secrets, representative runtime/load performance, failure visibility, recovery evidence, reproducible migrations, row-count/identity/integrity reconciliation, completed runbooks and defined rollback/acceptance authority.

## Risks / Current Technical Debt
| Item | Impact | Required Treatment |
|---|---|---|
| DE name-derived Provider identity in current adapter | Canonical integrity | Block DE APPLY; replace with stable non-name identifier and rerun DE gate |
| DE HRK-primary vs DAAD International Programmes coverage semantics | Source-of-truth governance | Explicitly resolve before DE production acceptance |
| High concurrent Course Location batches can hit statement timeouts | Throughput/reliability | Keep deterministic bounded ranges; ~2,500 preferred when concurrent |
| Monolithic full-country Edge invocation exceeds runtime ceiling | Reliability | Bounded/resumable country execution mandatory |
| Broader `public.ui_*` `SECURITY DEFINER` warnings | Security | Review necessity, privilege scope and hardening before final gate |
| Leaked-password protection disabled | Security | Enable/validate before final production gate |
| RLS-enabled/no-policy notices on internal schemas | Governance/security | Confirm intentional service-only access and explicit privilege posture |
| Snapshot-backed non-AU adapters | Data freshness/quality | Validate and replace with live authoritative acquisition where required |
| Documentation drift | Governance | Update this master plan on material scope/gate/runtime changes |

## Linked Technical Docs
- `docs/coursefinder-running-build-v2.1.md`
- `docs/coursefinder-admin-guide-v1.6.md`
- `docs/coursefinder-production-handover-v2.9.1.md`
- `docs/uat/coursefinder-layer1-au-full-ingestion-uat-v1.0.md`
- `docs/uat/coursefinder-layer1-de-production-gate-uat-v1.0.md`

---

## 3. Accepted Gates Register

| Gate | Status | Evidence |
|---|---|---|
| Architecture / canonical identity baseline | **ACCEPTED** | Database Architecture v2.9.1 |
| Production-model schema foundation | **ACCEPTED** | Architecture/migration baseline |
| Service/browser Layer 1 boundary | **ACCEPTED WITH RESIDUAL PLATFORM HARDENING** | Running build + AU/DE privilege review |
| Regulatory Settings / bounded execution control | **OPERATIONAL** | Running Build v2.1 |
| AU controlled reconciliation/idempotency | **PASS** | AU Layer 1 UAT |
| AU full CRICOS ingestion | **PASS** | AU Full Ingestion UAT v1.0 |
| AU Search Projection / FTS baseline | **PASS** | AU Full Ingestion UAT v1.0 |
| DE Layer 1 production gate | **BLOCKED** | `docs/uat/coursefinder-layer1-de-production-gate-uat-v1.0.md` |
| Multi-country Layer 1 | **NOT YET ACCEPTED** | DE remediation + remaining country gates pending |
| Broad Layer 2 production enrichment | **NOT YET ACCEPTED** | Deferred pending Layer 1 maturity |
| Layer 3 AI enrichment | **NOT YET ACCEPTED** | Planned |
| Human-review production workflow | **NOT YET ACCEPTED** | Foundation present |
| Production API/consumer gate | **NOT YET ACCEPTED** | Partial search foundation only |
| Final production readiness | **NOT YET ACCEPTED** | Phase 7 active |

---

## 4. Active Workstreams

1. **DE Layer 1 remediation** — replace name-derived Provider identity, resolve HRK/DAAD coverage contract, then rerun complete DE production gate.
2. **Layer 1 multi-country validation** — continue GB then NZ/CA/IE/US after/alongside DE remediation without weakening gate criteria.
3. **Admin/PIM operational UX** — improve production usability without bypassing architecture/security controls.
4. **Security and production hardening** — close advisor findings and validate privileges.
5. **Search multi-country readiness** — retain AU baseline while proving projection integrity for accepted countries.
6. **Layer 2 design readiness** — maintain source/enrichment design; broad rollout follows sufficient Layer 1 maturity unless explicitly re-sequenced here.

---

## 5. Next Recommended Phase / Gate

### Immediate DE remediation gate

1. Identify/confirm a stable non-name institution identifier from DAAD or the approved German authority mapping.
2. Explicitly resolve whether DE Layer 1 is full German catalogue coverage (HRK/base authority + DAAD complementary) or a deliberately scoped DAAD International Programmes catalogue.
3. Update the DE adapter without changing canonical identity rules.
4. Rerun DE source health, dry-run, APPLY, idempotency, integrity/orphan, Search Projection, security-negative, performance and resumability tests.
5. Update DE UAT and this master plan only if the evidence supports PASS.

### Following country gate
After DE remediation is under control, proceed to **GB** production validation, then NZ/CA/IE/US according to source readiness.

### Parallel gate
Continue **Phase 7 Production Security Hardening**.

### Following major programme stage
Begin broad **Phase 3 — Layer 2 Source Enrichment** after priority Layer 1 country gates are sufficiently mature, unless an explicit programme decision recorded here changes sequencing.

---

## 6. Change-Control Rules

Update this master plan whenever implementation materially affects:
- phase status/completion;
- accepted UAT gates;
- programme sequence/dependencies;
- canonical identity/stable IDs;
- source-of-truth ownership;
- architecture/schema design;
- security boundaries;
- runtime/deployment model;
- production-readiness risk;
- scope of a major phase.

Also update the corresponding specialist document:
- deployed runtime behaviour -> running-build;
- architecture/identity/database change -> architecture/database architecture;
- accepted test evidence -> `docs/uat/`;
- operator workflow -> Admin guide;
- implementation detail -> relevant technical repository/document.

Do not use chat history as the authoritative source when the Admin repo can answer the question.

---

## 7. Control-Room Reporting Standard

Every programme review should report:
- current overall phase and completion status;
- completed phases and accepted gates;
- active workstreams;
- blockers, risks and technical debt;
- database or architecture changes;
- GitHub/runtime changes since previous review;
- next recommended phase/gate;
- Admin documentation requiring update.

Before reporting status or recommending next work, review at minimum:
1. this master project plan;
2. latest running-build document;
3. current architecture/database architecture baseline;
4. latest relevant UAT documents;
5. recent Admin/runtime changes that may alter programme state.

---

## 8. Current Gate Decision

**Phase 0 Foundation & Architecture:** ACCEPTED.  
**Phase 1 AU Layer 1:** ACCEPTED / PASS.  
**Phase 1 DE Layer 1:** BLOCKED / REMEDIATION REQUIRED.  
**Phase 1 Multi-Country:** ACTIVE / NOT YET ACCEPTED.  
**Phase 7 Production Hardening:** ACTIVE.  
**Broad Layer 2 rollout:** NOT YET AUTHORISED AS THE PRIMARY PROGRAMME PHASE.

Coursefinder is cleared to continue **DE Layer 1 identity/source-authority remediation, multi-country Layer 1 production validation and security hardening**, using architecture v2.9.1 and stable non-name regulator/source identities as authoritative.
