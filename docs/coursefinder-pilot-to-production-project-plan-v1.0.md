# Coursefinder — Pilot to Production Project Plan v1.0

**Status:** Living delivery plan  
**Purpose:** Track Coursefinder from current Mumbai pilot state through UI build, API integration, Zoho UAT, production readiness and cutover.  
**Current authoritative pilot:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Current pilot project ref:** `fxcwkweaxjtknorudmwp`

> This document is the delivery source-of-truth for scope, phase status, estimated engineering effort, dependencies and acceptance gates. Update it as work progresses. Hours are planning estimates / engineering-equivalent effort, not a timesheet record.

---

## 1. Current Position

The architecture and physical database model have moved beyond conceptual design and are now deployed in the Mumbai pilot environment.

### Completed foundation

- Clean Supabase pilot project created in Mumbai.
- Production-model schemas separated into `ref`, `catalogue`, `pim`, `scholarship`, `integration`, `pipeline`, `search`, `publishing`, `workflow`, `security`, `api`.
- Production migrations applied through migration 023.
- PIM model built: Families, Groups, Attribute Definitions, Options, Values, Categories and Completeness Profiles.
- Catalogue model built: Providers, identifiers, registrations, campuses, courses, fees, intakes, English requirements and collections.
- Course Academic Options implemented.
- Provider Associations / lineage implemented.
- Scholarship model implemented, including Course Collection scope and machine-normalised eligibility structure.
- Layer 1–4 workflow structures implemented.
- Evidence lineage and private evidence storage implemented.
- Search Projection implemented.
- PostgreSQL FTS implemented.
- pgvector/HNSW model implemented.
- Search Profiles, intent normalisation structure and query embedding cache implemented.
- Curated API/RPC contracts created.
- Authenticated UI bridge created.
- Temporary compatibility read layer created and security-hardened.
- Foreign-key index hardening completed.
- Supabase Security/Performance Advisor review completed.
- 7-provider / 35-course validated UI seed loaded.
- Search Projection rebuilt for the UI seed.
- Pilot-to-production validation scenarios completed, including Course Collections, Academic Options, Layer 2, scholarships, Layer 4, API traffic, Search Projection, pgvector, true query embeddings, intent normalisation and query embedding caching.

### Current boundary

The database foundation is ready for UI development and pilot pipeline work. The next phase should occur in a new clean GitHub repository and new Cloudflare Worker/application deployment created specifically for the Pilot.

---

## 2. Engineering Effort Achieved So Far

These are **planning-equivalent hours**, reconstructed from delivered scope. They are not claimed as measured elapsed time.

| Workstream | Achieved scope | Est. hours |
|---|---|---:|
| Architecture & domain modelling | Canonical model, PIM principles, Course Collections, Academic Options, Provider Associations, scholarship/evidence/workflow boundaries | 16 |
| Physical DB design | Schemas, relations, constraints, stable keys, reference data, migration model | 18 |
| Pilot validation / scenario design | Multi-provider validation, Layer 2/4, scholarship scope, API/search/load scenarios | 16 |
| Search / API / pgvector design | Search Projection, FTS, HNSW, hybrid search, query embeddings, intent normalisation, cache strategy | 14 |
| Mumbai clean project deployment | New project, migrations, seed, evidence storage, search projection | 12 |
| Security & performance hardening | RLS posture, API exposure, security-invoker bridge, FK indexes, advisor remediation | 8 |
| UI integration bridge | Authenticated RPCs, compatibility layer, UI handoff preparation | 7 |
| Documentation / handover | Versioned architecture, DB, validation and operational handover documents | 9 |
| **Total achieved planning effort** |  | **100 hrs** |

### What the 100 hours represents

It represents the architecture, data model, search/API proofing, security hardening and pilot database build that would otherwise have been undertaken during later implementation phases. It should therefore reduce uncertainty and rework in the UI, API and production phases.

---

# 3. Pilot → Production Phase Plan

## Phase 0 — New Pilot Repository & Worker Bootstrap

**Status:** Waiting on new GitHub repo / Worker from project owner.  
**Estimated effort:** 6–10 hrs

### Scope

- Create clean Pilot repository structure.
- Bring forward only approved v2.9.1 migrations / schema definitions / handover documents.
- Do not copy historical demo code debt.
- Configure Cloudflare Worker / Pages deployment.
- Configure environment variables for Mumbai Supabase Pilot.
- Configure build/deployment workflow.
- Establish branch/PR convention.
- Establish Pilot/UAT release tagging.

### Acceptance gate

- Clean repository builds successfully.
- Cloudflare deployment works.
- Pilot UI reaches Mumbai Supabase using publishable key only.
- No service-role key exists in browser code.

---

## Phase 1 — PIM Admin UI Foundation

**Estimated effort:** 24–32 hrs

### Priority screens

1. Dashboard
2. Providers
3. Campuses
4. Course Collections
5. Courses workspace
6. Course Academic Options
7. Scholarships
8. Categories
9. Attributes / Options / Families / Groups
10. Completeness
11. Pipeline / Jobs
12. Review Queue
13. Evidence
14. Integrations / Search Profiles / Reference Data

### UX model

Use UnoPIM-style UX principles:

- product-style course workspace;
- list/grid/table views;
- configurable columns and filters;
- bulk operations;
- family-driven course forms;
- grouped tabs such as General, Academic, Fees, Intakes, Admissions, English, Campuses, Scholarships, SEO/Content and Evidence;
- controlled option management;
- separate global Categories and provider Course Collections;
- completeness and publication status visible in the main workspace;
- role-aware actions.

### Acceptance gate

- Pilot user can browse core entities.
- Course edit UI reflects PIM Family/Group/Attribute configuration.
- Provider → Collection → Course hierarchy is visible.
- Academic Options are displayed as course children rather than generic attributes.
- UI no longer depends on historical compatibility views for new functionality.

---

## Phase 2 — Canonical Pilot Data Migration

**Estimated effort:** 14–20 hrs

### Scope

- Reconcile demo/source catalogue against v2.9.1 target.
- Migrate validated provider identities.
- Migrate provider identifiers / registrations / aliases.
- Migrate validated courses and regulatory registrations.
- Migrate current known fee data.
- Preserve evidence/source provenance.
- Preserve Provider Association history.
- Do not copy old embeddings or temporary search cache.
- Rebuild Search Projection after migration.

### Pilot data target

Recommended initial Pilot/UAT scope:

- 7 validated countries remain represented.
- AU remains the primary deep-validation market.
- 7 Wave-1 Australian universities used as detailed UAT reference providers.
- Broader catalogue can be loaded after reconciliation succeeds.

### Acceptance gate

- Provider/course counts reconcile.
- Stable keys reconcile.
- Regulatory IDs reconcile.
- No duplicate canonical providers/courses introduced.
- Search Projection generation matches canonical catalogue state.

---

## Phase 3 — Layer 1 Regulatory Pipeline

**Estimated effort:** 12–18 hrs

### Scope

- Rebuild/promote Layer 1 into the new Pilot worker/runtime.
- Country-specific regulatory ingestion.
- Source registration and evidence capture.
- Canonical Provider/Course upsert rules.
- Authority rules protect Layer 1 regulatory identity from lower-authority overwrite.
- Incremental run / rerun / failure handling.

### Acceptance gate

- Existing 7-country Layer 1 behaviour regresses successfully.
- Duplicate/provider identity reconciliation tested.
- Failed imports are visible in Jobs / Review Queue.
- Layer 1 evidence retained.

---

## Phase 4 — Layer 2 Acquisition & Evidence

**Estimated effort:** 24–32 hrs

### Scope

Course acquisition:

- official course page discovery;
- course URL;
- provider Course Collections / study-area hierarchy;
- fees with year/audience/basis;
- provider-labelled intakes;
- English requirements including component scores;
- campuses / delivery;
- course description / structure;
- Academic Options discovery;
- evidence snapshots and content hashes.

Scholarship acquisition:

- official scholarship discovery;
- award/value extraction;
- eligibility text;
- application windows;
- automatic consideration vs application required;
- scope candidates;
- evidence capture.

### Acceptance gate

- Monash, UTS, Sydney and other validation providers reproduce Scenario results.
- Evidence is versioned.
- Changed content creates a new evidence version.
- Low-confidence extraction is routed to Layer 4.

---

## Phase 5 — Layer 3 LLM Extraction / Normalisation

**Estimated effort:** 20–28 hrs

### Scope

- Versioned extraction profiles.
- Configurable model profiles.
- Routing profiles by country/provider/entity.
- Course enrichment normalisation.
- Academic Option extraction.
- Scholarship eligibility normalisation.
- Structured scholarship rules such as study level, citizenship, WAM/score, provider history and exclusions.
- Confidence thresholds.
- Evidence-backed claims.

### Acceptance gate

- Extraction prompt/model configuration is data-driven rather than hard-coded.
- Each generated field has evidence/provenance.
- Scholarship criteria are sufficiently structured for deterministic eligibility checks.

---

## Phase 6 — Layer 4 Human Review / Governance

**Estimated effort:** 18–24 hrs

### UAT scenarios

- approve correct candidate;
- reject incorrect candidate;
- L1 vs L2 conflict;
- two Layer 2 source conflict;
- Course Collection vs Academic Option classification;
- scholarship scope approval;
- scholarship exclusion approval;
- undergraduate scholarship vs postgraduate-course rejection;
- evidence change reopening a prior review;
- previous decision/history remains auditable.

### Acceptance gate

- Every decision creates an immutable audit action.
- Review can reopen when evidence changes.
- Reviewer can see old value, candidate value and evidence.
- No silent overwrite of protected canonical values.

---

## Phase 7 — Search, pgvector & Recommendation API

**Estimated effort:** 20–28 hrs

### Website API scenarios

- structured course browsing;
- autocomplete / FTS search;
- semantic natural-language search;
- country / study-level / field filters;
- scholarship-bearing courses;
- related courses;
- course detail;
- provider detail;
- comparison.

### Zoho API scenarios

- student-profile recommendation;
- hard eligibility constraints first;
- semantic intent search second;
- scholarship eligibility/matching;
- batch course compare;
- stable provider/course IDs returned;
- Coursefinder returns academic ranking only;
- Zoho may apply commercial/preferred-provider re-ranking separately.

### Proposed API surface

- `/search/courses`
- `/search/semantic`
- `/courses/{id}`
- `/courses/{id}/related`
- `/courses/compare`
- `/providers/{id}`
- `/scholarships/search`
- `/recommendations/courses`
- `/recommendations/scholarships`

### Acceptance gate

- Website and Zoho contracts versioned.
- API responses use stable IDs.
- Query embeddings generated server-side.
- Query embedding cache operating.
- Hybrid search results are measurable and reproducible.

---

## Phase 8 — Zoho Creator Integration & UAT

**Estimated effort:** 20–28 hrs

### Integration boundary

Coursefinder remains the academic catalogue/source-of-truth. Zoho Creator remains a consumer/workflow/commercial layer.

### UAT cases

1. Search provider/course by stable ID.
2. Search courses using hard filters.
3. Send free-text student intent.
4. Request course recommendations.
5. Request scholarship recommendations.
6. Compare selected courses in one batch call.
7. Validate academic result ordering.
8. Apply Zoho commercial preference outside Coursefinder ranking.
9. Handle missing/unknown eligibility criteria conservatively.
10. Handle API timeout/retry/idempotency.
11. Confirm no raw commission value appears in Coursefinder public/search API.
12. Confirm changed catalogue data propagates after Search Projection rebuild.

### Acceptance gate

- Zoho consumes only documented API contracts.
- No direct DB access from Zoho.
- Stable IDs survive catalogue refresh.
- Error and retry behaviour documented.
- Coursefinder academic truth and Zoho commercial preference remain separated.

---

## Phase 9 — Website Integration & UAT

**Estimated effort:** 18–24 hrs

### Scope

- Website search integration.
- Course detail and provider detail.
- Filters/facets.
- Related courses.
- Scholarship display.
- Pagination.
- caching/rate-limit behaviour.
- anonymous/public API safety.

### Traffic/UAT profiles

- autocomplete-heavy browsing;
- filtered search;
- semantic question;
- related-course lookup;
- hot course/provider detail pages;
- burst traffic;
- cache warm/cold comparison.

### Acceptance gate

- website does not query canonical internal schemas directly;
- no browser service-role credentials;
- response-time targets met;
- cache invalidation validated after catalogue generation changes.

---

## Phase 10 — Performance, Load & Resilience UAT

**Estimated effort:** 18–24 hrs

### Baseline metrics already observed during Pilot validation

- structured/FTS projection: approximately 1–3 ms DB execution in pilot tests;
- HNSW vector neighbour retrieval: approximately 10.8 ms warm on the partial embedding set;
- hybrid FTS + vector + fusion: approximately 37 ms warm in the pilot;
- 1,000 projected searches: approximately 1.71 seconds serial DB execution in the pilot versus approximately 23.99 seconds against canonical-table search.

These are pilot measurements only and must be re-baselined after the wider Mumbai catalogue and full embeddings are loaded.

### UAT targets to establish

- P50/P95/P99 API latency;
- Search Projection rebuild duration;
- embedding queue throughput;
- cache hit rate;
- query embedding provider latency/cost;
- pgvector candidate latency;
- Postgres CPU/memory/IO;
- API failure rate;
- concurrency limits;
- Zoho batch request behaviour.

### Acceptance gate

Performance thresholds are agreed from representative production traffic rather than synthetic micro-benchmarks alone.

---

## Phase 11 — Security / Production Readiness

**Estimated effort:** 14–20 hrs

### Scope

- final Supabase Security Advisor review;
- final Performance Advisor review;
- authentication and role review;
- API/RPC privilege review;
- RLS review;
- secrets review;
- Storage evidence access review;
- rate limiting;
- API abuse controls;
- logging/audit;
- backup/recovery procedure;
- migration replay test;
- production environment variables;
- deployment/runbook.

### Acceptance gate

- no critical/error Security Advisor findings;
- no service-role frontend exposure;
- migrations reproduce a clean environment;
- UAT sign-off recorded.

---

## Phase 12 — Production Cutover & Hypercare

**Estimated effort:** 10–16 hrs

### Scope

- final catalogue reconciliation;
- freeze migration window;
- Search Projection rebuild;
- final embedding run;
- deploy API/Worker/UI production release;
- update Website endpoint;
- update Zoho endpoint;
- smoke test;
- rollback checkpoint;
- 2–5 business day hypercare monitoring.

### Acceptance gate

- Website and Zoho production consumers stable;
- API metrics normal;
- no catalogue reconciliation drift;
- handover documentation complete.

---

# 4. Remaining Effort Summary

| Phase | Estimate |
|---|---:|
| 0. New repo / Worker bootstrap | 6–10 hrs |
| 1. PIM Admin UI | 24–32 hrs |
| 2. Pilot data migration | 14–20 hrs |
| 3. Layer 1 | 12–18 hrs |
| 4. Layer 2 | 24–32 hrs |
| 5. Layer 3 | 20–28 hrs |
| 6. Layer 4 | 18–24 hrs |
| 7. Search/API | 20–28 hrs |
| 8. Zoho integration/UAT | 20–28 hrs |
| 9. Website integration/UAT | 18–24 hrs |
| 10. Performance/load/resilience | 18–24 hrs |
| 11. Security/production readiness | 14–20 hrs |
| 12. Cutover/hypercare | 10–16 hrs |
| **Remaining estimated effort** | **218–304 hrs** |

### Overall planning envelope

- Achieved planning-equivalent effort: **~100 hrs**
- Remaining: **~218–304 hrs**
- Total full Pilot-to-Production engineering envelope: **~318–404 hrs**

This should be re-estimated after the clean Pilot repo is created and Phase 1 UI/Phase 4 Layer 2 implementation velocity is known.

---

# 5. UAT Streams

UAT must run as parallel streams rather than one final test event.

| UAT stream | Key outcome |
|---|---|
| Database/schema | Stable model; migrations replay cleanly |
| PIM UI | Admin can manage providers/courses/attributes/categories/collections |
| Layer 1 | Regulatory identity remains canonical |
| Layer 2 | Reliable evidence acquisition |
| Layer 3 | Correct extraction/normalisation with confidence/evidence |
| Layer 4 | Auditable human decisions and reopen workflow |
| Search | FTS/vector/hybrid quality and latency |
| Scholarship | Correct inclusion/exclusion and unknown handling |
| Zoho | Stable APIs, recommendation workflow, commercial boundary |
| Website | Public search/detail traffic, caching, rate limits |
| Security | Least privilege, no browser secrets, controlled API exposure |
| Performance | Representative P95/P99 latency and load behaviour |
| DR/rebuild | Environment reproducible from Git/migrations |

---

# 6. Project Control / Change Rules

1. All DB/schema changes must be migrations in Git.
2. Architecture/database changes require a new versioned MD document or version update as agreed.
3. Pilot environment must remain reproducible; dashboard-only undocumented changes are prohibited.
4. Demo data is a source/validation environment, not the production schema source.
5. Search data is derived and rebuildable.
6. Embeddings are derived and rebuildable.
7. Evidence is retained as provenance, not treated as canonical structured truth by itself.
8. Zoho cannot become the canonical academic catalogue.
9. Commercial/preferred-provider logic stays outside canonical academic ranking.
10. Every material performance/design improvement is recorded in the improvement roadmap.

---

# 7. Current Immediate Next Actions

**Owner actions:**

- Create new clean GitHub Pilot repository.
- Create new Cloudflare Worker/application deployment.
- Provide repo and Worker details.

**Next Coursefinder implementation actions after handoff:**

1. Bootstrap repository from approved migrations/docs only.
2. Connect new Worker/UI to Mumbai `coursefinder_Pilot`.
3. Create UAT Auth user / role.
4. Start PIM UI foundation.
5. In parallel, promote Layer 1 and Layer 2 pipeline components.
6. Begin wider canonical catalogue migration.

---

# 8. Revision Log

## v1.0

- Initial living project plan created after completion of Mumbai database foundation.
- Captures achieved scope and planning-equivalent hours.
- Defines Pilot → Production phases, Website UAT, Zoho/API UAT and production gates.
- Establishes ongoing project-control rules.
