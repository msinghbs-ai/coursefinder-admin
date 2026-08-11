# Coursefinder Master Project Plan v1.0

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Last consolidated:** 12 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.9.1.md`  
**Running build baseline:** `docs/coursefinder-running-build-v2.1.md`  
**Latest accepted major UAT gate:** Layer 1 Full AU CRICOS Ingestion — **PASS**  
**Current programme position:** Layer 1 multi-country production validation and production hardening before broad Layer 2 expansion

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

Detailed implementation logs belong in the relevant technical documents and repositories. This master plan records only the programme-level consequence of those implementation changes.

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
| 1 | Layer 1 Regulatory Data | **IN PROGRESS** | AU PASS; multi-country validation active |
| 2 | Admin / PIM UX | **IN PROGRESS / OPERATIONAL FOUNDATION** | Production-style regulatory workflow operational; broader UX incomplete |
| 3 | Layer 2 Source Enrichment | **PLANNED / PARTIALLY PROTOTYPED** | Broad production rollout intentionally deferred pending Layer 1 maturity |
| 4 | Layer 3 AI Enrichment | **PLANNED** | No production gate accepted |
| 5 | Data Quality & Human Review | **FOUNDATION PRESENT / IN PROGRESS** | Workflow model exists; full operational UAT pending |
| 6 | Search / API / Consumer Experience | **PARTIALLY COMPLETE** | AU Search Projection/FTS PASS; broader API/semantic/consumer UAT pending |
| 7 | Production Hardening & Operations | **IN PROGRESS** | Residual security, multi-country, monitoring and cutover gates remain |

### Current overall phase

The programme is currently in **Phase 1 — Layer 1 Regulatory Data**, specifically **multi-country production validation**, with Phase 7 security/operational hardening running in parallel.

The accepted AU regulatory baseline proves the canonical architecture and bounded execution model. The next programme objective is to prove additional priority countries without weakening stable identity, evidence lineage, idempotency or security boundaries.

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
- None; this phase establishes the dependency baseline for all later phases.

## Architecture Impact
Architecture v2.9.1 is authoritative.

Core principles:
- normalised canonical write model;
- denormalised/rebuildable search/read model;
- stable IDs and explicit regulator identifiers;
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

Architecture is considered proven for current programme use because the full AU Layer 1 ingestion and Search Projection gate passed against this model.

## Risks
- Architecture drift caused by implementation changes not being reflected in authoritative documents.
- Reintroduction of name/title-based identity matching.
- Browser exposure of internal/service-only schemas or functions.

## Linked Technical Docs
- `docs/coursefinder-database-architecture-v2.9.1.md`
- `docs/coursefinder-production-handover-v2.9.1.md`
- Historical validation/design documents remain retained as evidence but do not override v2.9.1.

---

# Phase 1 — Layer 1 Regulatory Data

**Status:** IN PROGRESS — AU COMPLETE; MULTI-COUNTRY VALIDATION ACTIVE

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
Accepted AU identity hardening:
- Provider identity = `country + registration_scheme + regulator_provider_code`;
- Course identity = `provider + registration_scheme + regulator_course_code`.

Migration:
- `041_layer1_identifier_identity_hardening.sql`

Accepted AU canonical baseline:
- Providers: **1,546**
- Courses: **26,648**
- Campuses: **3,922**
- Course↔Campus links: **47,671**
- Search Documents: **26,648**

## Deliverables
### Complete
- AU CRICOS authoritative acquisition.
- AU evidence/provenance.
- AU Providers/Courses/Locations/Course Locations reconciliation.
- Full-scale identity hardening.
- AU idempotency and integrity validation.
- AU Search Projection rebuild.
- Production-style bounded Layer 1 execution control.

### Active
- DE live DAAD validation.
- GB UKVI/provider and configured course-source validation.
- NZ/CA/IE/US adapter validation and progressive replacement of snapshot-backed acquisition with authoritative live acquisition where required.

## UAT Gate
### AU
**PASS / ACCEPTED.**

### Per-country production gate
Each additional country must pass all of the following:
- authoritative source confirmed;
- source health/freshness confirmed;
- stable regulatory identity confirmed;
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
- High concurrent Course Location batches causing PostgreSQL statement timeouts.
- Monolithic full-country Edge requests exceeding execution ceilings.
- Identity regression through name/title matching.
- Country-specific regulatory semantics requiring explicit architecture extension.

## Linked Technical Docs
- `docs/coursefinder-running-build-v2.1.md`
- `docs/uat/coursefinder-layer1-au-full-ingestion-uat-v1.0.md`
- `docs/coursefinder-admin-guide-v1.6.md`
- Relevant country-specific Layer 1/UAT documents under `docs/` and `docs/uat/`.

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
- Phase 0 PIM and workflow schemas.
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

New UX requirements that imply a new canonical field/entity must be assessed as an architecture/database change before implementation.

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
Phase 2 is accepted when:
- authorised roles can perform required operations without service-role exposure;
- critical PIM entities/attributes can be managed safely;
- regulatory execution is resumable and auditable;
- evidence/review states are understandable and traceable;
- failed operations produce actionable error/status information;
- permission boundaries pass negative testing;
- operator workflow is documented.

## Risks
- Admin convenience bypassing architecture/security boundaries.
- UI assumptions driving undocumented DB schema changes.
- Operational state being held only client-side rather than in durable job/result records.
- Security-definer functions having overly broad authenticated access.

## Linked Technical Docs
- `docs/coursefinder-admin-guide-v1.6.md`
- `docs/coursefinder-running-build-v2.1.md`
- `docs/coursefinder-database-architecture-v2.9.1.md`

---

# Phase 3 — Layer 2 Source Enrichment

**Status:** PLANNED / PARTIALLY PROTOTYPED — BROAD PRODUCTION ROLLOUT DEFERRED

## Scope
Acquire non-regulatory enrichment evidence from approved authoritative or provider sources, including structured facts not supplied adequately by Layer 1.

Expected domains include, subject to approved source strategy:
- tuition/fees;
- intakes;
- English requirements;
- scholarships;
- provider/course descriptive content;
- provider-defined course collections;
- academic options;
- other approved long-tail attributes.

## Dependencies
- Sufficient Layer 1 canonical coverage and stable IDs for the target country/entity set.
- Approved source registry and acquisition policies.
- Evidence/provenance pipeline.
- Change detection/content hashes.
- Phase 5 review workflow for non-deterministic/conflicting changes.

## Architecture Impact
Layer 2 acquires and normalises evidence but does not silently override regulatory truth.

All enrichment must attach to canonical stable IDs and retain source/evidence lineage.

Human-readable source content must not create duplicate canonical entities merely because wording differs.

## DB Impact
Primary areas:
- `pipeline.sources`
- `pipeline.acquisition_policies`
- `pipeline.jobs`
- `pipeline.evidence_artifacts`
- `pipeline.change_events`
- structured `catalogue`, `scholarship` and `pim` destination tables as approved.

No Layer 2 source may invent a new identity strategy outside the architecture baseline.

## Deliverables
- Approved source matrix by country/domain.
- Source acquisition adapters.
- Evidence/version/hash capture.
- Idempotent change detection.
- Structured normalisation into approved destination models.
- Conflict/review routing.
- Layer 2 operational metrics and retry controls.

## UAT Gate
Layer 2 gate requires:
- source terms/authority and technical access validated;
- stable canonical linking demonstrated;
- unchanged source rerun is idempotent;
- changed evidence is versioned and traceable;
- structured writes obey source-of-truth priority;
- conflicts route to Phase 5 rather than silently overwrite;
- representative scale/performance tested;
- rollback/reprocessing behaviour proven.

## Risks
- Provider website structure instability.
- Scraping/access restrictions.
- Source contradictions.
- Duplicate facts across multiple sources.
- Enrichment writes bypassing review/source-priority rules.
- Premature Layer 2 expansion before Layer 1 country identity is stable.

## Linked Technical Docs
- `docs/coursefinder-database-architecture-v2.9.1.md`
- Current Layer 2/source-specific documents in Admin repo as they are approved.
- Detailed ingestion implementation remains in its technical repo and should be linked here rather than duplicated.

---

# Phase 4 — Layer 3 AI Enrichment

**Status:** PLANNED

## Scope
Use approved AI models to transform unstructured evidence into structured candidate facts where deterministic extraction is insufficient.

Typical use cases:
- structured extraction from provider/course pages;
- scholarship eligibility normalisation;
- academic-option extraction;
- classification/mapping suggestions;
- long-tail PIM attribute extraction.

## Dependencies
- Phase 2/3 evidence and source controls.
- Approved model/integration configuration.
- Versioned prompts/extraction profiles.
- Phase 5 review workflow.
- Clear confidence/validation policy.

## Architecture Impact
AI output is not automatically canonical truth.

Layer 3 produces structured extraction results/suggestions with model, profile, evidence and run lineage. Acceptance into canonical data follows deterministic validation and/or Phase 5 review according to policy.

## DB Impact
Expected use of:
- `integration.models`
- `integration.extraction_profiles`
- `pipeline.extraction_runs`
- evidence references;
- workflow suggestions/review queue;
- approved canonical/PIM destinations only after acceptance.

## Deliverables
- Model/provider configuration.
- Versioned extraction profiles.
- Structured schemas/validation.
- Confidence and routing policy.
- Cost/token/rate-limit controls.
- Evidence-linked extraction results.
- Retry/idempotency behaviour.

## UAT Gate
- Same evidence/profile/model version produces controlled repeatable output within defined tolerance.
- Invalid/unparseable output fails safely.
- No AI result bypasses required review/validation.
- Model/profile/version/evidence lineage is queryable.
- Cost/performance envelope documented.
- Representative extraction accuracy is accepted per attribute/domain.

## Risks
- Hallucination or overconfident extraction.
- Prompt/model drift.
- Unbounded AI cost.
- AI-generated text being confused with source evidence.
- Automatic acceptance of ambiguous eligibility or academic facts.

## Linked Technical Docs
- `docs/coursefinder-database-architecture-v2.9.1.md`
- Future Layer 3 design/UAT documents to be added as implementation begins.

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
- Admin UX and RBAC.

## Architecture Impact
Human review is the governance boundary for uncertain/conflicting enrichment. Review decisions must be auditable and must not erase source/evidence history.

## DB Impact
Core tables include:
- `workflow.review_queue`
- `workflow.review_actions`
- `workflow.catalogue_suggestions`
- `workflow.import_jobs`
- `workflow.import_rows`
- `workflow.import_errors`
- `workflow.export_jobs`

Review reopening lineage includes:
- `reopened_from_review_id`
- `supersedes_review_id`
- `reopen_reason`

## Deliverables
- Completeness profiles/requirements.
- Validation rules.
- Review queue prioritisation.
- Evidence-aware comparison UI.
- Append-only review actions.
- Reopen/supersede behaviour.
- Data-quality dashboards/metrics.

## UAT Gate
- Conflicting candidate facts enter review correctly.
- Approval/rejection/edit actions are auditable.
- Changed evidence can reopen previously accepted decisions where policy requires.
- Review actions never destroy lineage.
- Permissions prevent unauthorised approval.
- Completeness calculations match configured requirements.

## Risks
- Review backlog growth.
- Inconsistent reviewer decisions.
- Approved values losing connection to evidence.
- Bulk actions causing unreviewed canonical changes.

## Linked Technical Docs
- `docs/coursefinder-database-architecture-v2.9.1.md`
- Admin/PIM workflow documentation.
- Future dedicated data-quality and Layer 4 UAT documents.

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

Commercial commission/preference belongs downstream, not in Coursefinder canonical academic relevance.

## DB Impact
Primary search tables:
- `search.profiles`
- `search.profile_fields`
- `search.intent_aliases`
- `search.documents`
- `search.embeddings`
- `search.index_jobs`
- `search.query_embedding_cache`

Potential API contracts include:
- `/search/courses`
- `/search/semantic`
- `/courses/{id}`
- `/courses/{id}/related`
- `/courses/compare`
- `/scholarships/search`
- `/recommendations/courses`

## Deliverables
### Complete / proven
- AU Search Projection rebuild.
- AU FTS baseline and indexed query performance.
- Search document count parity with AU Courses.

### Remaining
- Multi-country Search Projection validation.
- Production API contract implementation/UAT.
- Consumer authentication/rate limiting/caching.
- Search relevance acceptance set.
- Semantic search/embedding benchmark and cost controls where required.
- Website/Zoho integration UAT.

## UAT Gate
- Search document parity/integrity passes.
- Representative structured and text searches return accepted results.
- Search is rebuildable from canonical data.
- API returns stable Coursefinder IDs and approved fields only.
- Anonymous/authenticated boundaries are correct.
- Rate limiting/caching/error behaviour validated.
- Semantic retrieval, if enabled, passes relevance and performance benchmarks.
- Downstream consumer does not overwrite canonical academic truth.

## Risks
- Search projection becoming an accidental write/source-of-truth surface.
- Relevance regressions as countries/data domains expand.
- Semantic search cost/latency without measurable value.
- Consumer-specific commercial ranking leaking into canonical ranking.

## Linked Technical Docs
- `docs/coursefinder-database-architecture-v2.9.1.md`
- `docs/uat/coursefinder-layer1-au-full-ingestion-uat-v1.0.md`
- `docs/coursefinder-pilot-validation-wave1-scenario7-search-projection-api-load-v2.9.md`

---

# Phase 7 — Production Hardening & Operations

**Status:** IN PROGRESS

## Scope
- Security hardening.
- RBAC/RLS and privilege review.
- Secrets/authentication review.
- Runtime limits and batching standards.
- Monitoring, alerting and operational metrics.
- Backup/recovery and rollback.
- Deployment/release controls.
- Production region/runtime validation.
- Runbooks and operator documentation.
- Final production acceptance.

## Dependencies
- Accepted functional gates from Phases 0–6 as applicable to initial production scope.
- Stable migrations and reproducible deployment.
- Production secrets/configuration.
- Operational ownership.

## Architecture Impact
No production shortcut may weaken approved service/browser boundaries, stable identity or evidence lineage.

Regional deployment must remain reproducible from Git-tracked migrations/configuration and validated canonical data rather than opaque manual transfer.

## DB Impact
- Final privilege/RLS posture.
- Production indexes based on representative workload evidence.
- Retention/cleanup policies.
- Backup/recovery validation.
- Migration/cutover reconciliation.

## Deliverables
- Security advisor remediation/acceptance record.
- Review of `SECURITY DEFINER` exposure.
- Leaked-password protection enabled/validated where applicable.
- Internal-schema RLS/privilege intent documented.
- Runtime/batch/concurrency standards.
- Monitoring/alerting/runbooks.
- Production deployment/cutover plan.
- Backup/restore/rollback test evidence.
- Final production UAT and handover.

## UAT Gate
Production readiness requires:
- no unresolved Critical/High security issue without explicit risk acceptance;
- browser/service privilege boundaries validated;
- secrets not browser exposed;
- representative ingestion/search/API loads stay within runtime envelope;
- monitoring/alerting proves failure visibility;
- backup/restore or documented recovery path tested;
- migrations reproduce the target environment;
- row-count/identity/integrity reconciliation passes after deployment;
- operator runbooks complete;
- rollback window and acceptance authority defined;
- final production gate documented and approved.

## Risks / Current Technical Debt
| Item | Impact | Required Treatment |
|---|---|---|
| High concurrent Course Location batches can hit statement timeouts | Throughput/reliability | Keep deterministic bounded ranges; ~2,500 preferred when concurrent |
| Monolithic full-country Edge invocation exceeds runtime ceiling | Reliability | Bounded/resumable country execution is mandatory |
| Broader `public.ui_*` `SECURITY DEFINER` warnings | Security | Review necessity, privilege scope and hardening before final gate |
| Leaked-password protection disabled | Security | Enable/validate before production gate |
| RLS-enabled/no-policy notices on internal schemas | Governance/security | Confirm intentional service-only access and explicit privilege posture |
| Snapshot-backed non-AU adapters | Data freshness/quality | Validate and progressively replace with live authoritative acquisition where required |
| Documentation drift | Governance | Update this master plan whenever material scope/gate/architecture/runtime consequences change |

## Linked Technical Docs
- `docs/coursefinder-running-build-v2.1.md`
- `docs/coursefinder-admin-guide-v1.6.md`
- `docs/coursefinder-production-handover-v2.9.1.md`
- `docs/uat/coursefinder-layer1-au-full-ingestion-uat-v1.0.md`

---

## 3. Accepted Gates Register

| Gate | Status | Evidence |
|---|---|---|
| Architecture / canonical identity baseline | **ACCEPTED** | Database Architecture v2.9.1 |
| Production-model schema foundation | **ACCEPTED** | Architecture/migration baseline |
| Service/browser Layer 1 boundary | **ACCEPTED WITH RESIDUAL PLATFORM HARDENING** | Running build + AU UAT privilege checks |
| Regulatory Settings / bounded execution control | **OPERATIONAL** | Running Build v2.1 |
| AU controlled reconciliation/idempotency | **PASS** | AU Layer 1 UAT |
| AU full CRICOS ingestion | **PASS** | AU Full Ingestion UAT v1.0 |
| AU Search Projection / FTS baseline | **PASS** | AU Full Ingestion UAT v1.0 |
| Multi-country Layer 1 | **NOT YET ACCEPTED** | Country gates pending |
| Broad Layer 2 production enrichment | **NOT YET ACCEPTED** | Deferred pending Layer 1 maturity |
| Layer 3 AI enrichment | **NOT YET ACCEPTED** | Planned |
| Human-review production workflow | **NOT YET ACCEPTED** | Foundation present |
| Production API/consumer gate | **NOT YET ACCEPTED** | Partial search foundation only |
| Final production readiness | **NOT YET ACCEPTED** | Phase 7 active |

---

## 4. Active Workstreams

1. **Layer 1 multi-country validation** — priority programme workstream.
2. **Admin/PIM operational UX** — improve production usability without bypassing architecture/security controls.
3. **Security and production hardening** — close advisor findings and validate privileges.
4. **Search multi-country readiness** — retain AU baseline while proving projection integrity for additional countries.
5. **Layer 2 design readiness** — maintain source/enrichment design, but broad rollout follows sufficient Layer 1 country maturity unless explicitly re-sequenced here.

---

## 5. Next Recommended Phase / Gate

### Immediate gate: Multi-Country Layer 1 Production Validation

Recommended sequence:
1. **DE** — validate live paged DAAD acquisition end-to-end.
2. **GB** — validate UKVI Provider register and configured course-source reconciliation.
3. **NZ / CA / IE / US** — validate source freshness and stable identity, then replace snapshot-backed acquisition with authoritative live acquisition where required.

Each country must satisfy the Phase 1 gate before being marked production-ready.

### Parallel gate: Production Security Hardening
Close or explicitly accept the residual security findings before final production readiness.

### Following major programme stage
Begin broad **Phase 3 — Layer 2 Source Enrichment** after priority Layer 1 country gates are sufficiently mature, unless an explicit programme decision recorded in this document changes sequencing.

---

## 6. Change-Control Rules

Update this master plan whenever any implementation change materially affects:
- phase status or completion percentage;
- accepted UAT gates;
- programme sequence/dependencies;
- canonical identity or stable IDs;
- source-of-truth ownership;
- architecture or schema design;
- security boundaries;
- runtime/deployment model;
- production-readiness risk;
- scope of a major phase.

Also update the corresponding specialist document:
- **deployed runtime behaviour** -> running-build;
- **architecture/identity/database change** -> architecture/database architecture;
- **accepted test evidence** -> `docs/uat/`;
- **operator workflow** -> Admin guide;
- **implementation detail** -> relevant technical repository/document.

Do not use chat history as the authoritative source when the Admin repo can answer the question.

---

## 7. Control-Room Reporting Standard

Every future programme review should report:
- Current overall phase and completion status.
- Completed phases and accepted gates.
- Active workstreams.
- Blockers, risks and technical debt.
- Database or architecture changes.
- GitHub/runtime changes since the previous review.
- Next recommended phase and gate.
- Admin documentation requiring update.

Before reporting status or recommending next work, review at minimum:
1. this master project plan;
2. latest running-build document;
3. current architecture/database architecture baseline;
4. latest relevant UAT documents;
5. recent Admin repo changes that may alter programme state.

---

## 8. Current Gate Decision

**Phase 0 Foundation & Architecture:** ACCEPTED.  
**Phase 1 AU Layer 1:** ACCEPTED / PASS.  
**Phase 1 Multi-Country:** ACTIVE / NOT YET ACCEPTED.  
**Phase 7 Production Hardening:** ACTIVE.  
**Broad Layer 2 rollout:** NOT YET AUTHORISED AS THE PRIMARY PROGRAMME PHASE.

Coursefinder is cleared to continue **multi-country Layer 1 production validation plus security hardening**, using architecture v2.9.1 and stable regulator-derived identities as authoritative.