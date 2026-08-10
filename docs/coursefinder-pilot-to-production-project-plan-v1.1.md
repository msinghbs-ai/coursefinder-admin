# Coursefinder — Pilot to Production Project Plan v1.1

**Status:** Living delivery plan  
**Purpose:** Track Coursefinder from the current Mumbai pilot through UI build, API integration, Zoho UAT, production readiness and cutover.  
**Authoritative pilot:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Project ref:** `fxcwkweaxjtknorudmwp`  
**Supersedes:** `coursefinder-pilot-to-production-project-plan-v1.0.md`

> Hours are planning estimates / engineering-equivalent effort, not timesheet records. This document must be updated as delivery velocity and UAT evidence become available.

---

## 1. Current Position

The production-model database is deployed in the Mumbai pilot and is sufficiently complete for UI development, but **one mandatory security gate remains before UI/UAT is treated as production-like**: comprehensive Row Level Security hardening across the internal schemas.

### Completed foundation

- Clean Supabase Pilot project created in Mumbai.
- Production-model schemas separated into `ref`, `catalogue`, `pim`, `scholarship`, `integration`, `pipeline`, `search`, `publishing`, `workflow`, `security`, `api`.
- Production migrations applied through migration `023`.
- PIM model built: Families, Groups, Attribute Definitions, Options, Values, Categories and Completeness Profiles.
- Catalogue model built: Providers, identifiers, registrations, campuses, courses, fees, intakes, English requirements and Course Collections.
- Course Academic Options implemented.
- Provider Associations / lineage implemented.
- Scholarship model implemented, including Course Collection scope and machine-normalised eligibility structure.
- Layer 1–4 workflow structures implemented.
- Evidence lineage and private evidence Storage implemented.
- Search Projection, PostgreSQL FTS, pgvector/HNSW, Search Profiles and query embedding cache implemented.
- Curated API/RPC contracts created.
- Authenticated UI bridge created.
- Temporary compatibility read layer created and security-hardened against Security Definer View errors.
- Foreign-key index hardening completed.
- 7-provider / 35-course validated UI seed loaded.
- Search Projection rebuilt for the UI seed.
- Pilot validation completed for Course Collections, Academic Options, Layer 2, scholarships, Layer 4, API traffic, Search Projection, pgvector, true query embeddings, intent normalisation and query embedding caching.

### Mandatory security gate discovered during build verification

Supabase currently reports **61 internal tables with RLS disabled** across schemas including `ref`, `catalogue`, `scholarship`, `integration`, `pipeline`, `workflow`, `publishing` and `search`.

This is now a **blocking hardening task before formal UI/UAT sign-off**.

Required approach:

1. Enable RLS on internal tables.
2. Do not add broad anonymous policies.
3. Keep browser access through curated RPC/API contracts.
4. Add only the minimum authenticated policies required for explicit use cases.
5. Keep `service_role` server-side only.
6. Re-run Supabase Security Advisor and record the result.
7. Verify existing UI/API contracts still operate after RLS enablement.

This hardening must be implemented as Git-tracked migrations, not dashboard-only configuration.

---

## 2. Supabase Studio / Schema Visual Expectations

The database is **not expected to look populated when Supabase Studio is left on the default `public` schema**.

### Expected behaviour

The production model deliberately stores base tables outside `public`:

- `catalogue` — Providers, Courses, Collections, Campuses, fees, intakes, Academic Options, Provider Associations.
- `pim` — Families, Groups, Attributes, Options, Values, Categories and Completeness.
- `scholarship` — Scholarships, scopes, criteria, awards and coverage.
- `pipeline` — Sources, jobs, evidence and claims.
- `workflow` — Review, import/export, migration and handover state.
- `search` — Search Profiles, Search Projection, embeddings and query cache.
- `ref` — Countries, study levels, provider types, fields of study and other global reference data.
- `security` — Roles and role assignments.
- `publishing` / `integration` — channel and integration configuration.

`public` should contain only the intentionally exposed API/RPC/compatibility surface, not the canonical relational model.

### Studio checks

When reviewing the Pilot manually:

1. Change the **schema selector** from `public` to `catalogue` to see core Provider/Course tables.
2. Select `pim` to see the PIM model.
3. Select `search` to see the Search Projection and pgvector-related tables.
4. Select `workflow` for migration/review/import/export structures.
5. The Schema Visualizer may need to be scoped to a specific schema; an apparently empty `public` visual is not evidence that the database is empty.

### Current verification baseline

- `catalogue.providers`: 7 rows.
- `catalogue.courses`: 35 rows.
- `pim.entity_registry`: 42 rows.
- `search.course_documents`: 35 rows.
- `search.intent_aliases`: 22 rows.
- `workflow.migration_entity_map`: 42 rows.

This visual expectation must be carried into the clean Pilot repository handover so new developers do not misdiagnose the database as empty.

---

## 3. Engineering Effort Achieved So Far

These are planning-equivalent hours reconstructed from delivered scope.

| Workstream | Achieved scope | Est. hours |
|---|---|---:|
| Architecture & domain modelling | Canonical/PIM model, collections, academic options, provider lineage, scholarships/evidence/workflow | 16 |
| Physical DB design | Schemas, relations, constraints, stable keys, reference data and migration model | 18 |
| Pilot validation | Multi-provider, Layer 2/4, scholarship, API/search/load scenarios | 16 |
| Search / API / pgvector | Projection, FTS, HNSW, hybrid search, query embeddings, intent normalisation, cache | 14 |
| Mumbai clean deployment | Project, migrations, seed, evidence storage, search projection | 12 |
| Security & performance work already completed | UI bridge hardening, Security Definer View remediation, FK indexes, advisor review | 8 |
| UI integration bridge | Authenticated RPCs, compatibility surface, UI handoff | 7 |
| Documentation / handover | Architecture, DB, validation, operational handover, plans | 9 |
| **Total achieved planning effort** |  | **100 hrs** |

**RLS hardening is not counted as completed work yet.** It is now a planned immediate task.

---

# 4. Pilot → Production Phase Plan

## Phase 0 — New Pilot Repository & Worker Bootstrap

**Status:** Waiting on clean GitHub repo / Worker.  
**Estimated effort:** 6–10 hrs

- Bring forward only approved v2.9.1/v1.1 artefacts.
- Configure Cloudflare Worker/Pages and environment variables.
- Establish branch/PR/release conventions.
- Ensure publishable key only in browser code.

**Gate:** clean repo builds and reaches Mumbai Supabase.

## Phase 0A — Database Security Hardening

**Status:** Mandatory / next DB task.  
**Estimated effort:** 4–6 hrs

- Enable RLS across all internal base tables currently flagged by Supabase.
- Preserve server-only schema model.
- Review/revoke direct `anon` and `authenticated` grants where unnecessary.
- Add only explicit policies required by approved client flows.
- Verify authenticated UI RPC bridge after RLS enablement.
- Re-run Security Advisor.
- Record expected/accepted INFO/WARN notices and resolve all Critical/Error findings.
- Commit hardening migrations to Git and update the running-build document.

**Gate:** no critical/error Security Advisor findings and no direct anonymous write path.

## Phase 1 — PIM Admin UI Foundation

**Estimated effort:** 24–32 hrs

Priority: Dashboard, Providers, Campuses, Course Collections, Courses workspace, Academic Options, Scholarships, Categories, Attributes/Options/Families/Groups, Completeness, Pipeline/Jobs, Review Queue, Evidence, Integrations/Search Profiles/Reference Data.

Use PIM-style UX: product-style workspace, filters, bulk actions, family-driven forms, grouped tabs, controlled options, separate Categories vs Course Collections, completeness/publication and role-aware actions.

## Phase 2 — Canonical Pilot Data Migration

**Estimated effort:** 14–20 hrs

Migrate validated canonical provider/course/regulatory data, preserve provenance/lineage, do not copy old embeddings/cache, rebuild Search Projection and reconcile counts/stable keys.

## Phase 3 — Layer 1 Regulatory Pipeline

**Estimated effort:** 12–18 hrs

Rebuild/promote 7-country regulatory ingestion, canonical upsert rules, authority protection, incremental reruns, job/error visibility and evidence retention.

## Phase 4 — Layer 2 Acquisition & Evidence

**Estimated effort:** 24–32 hrs

Course URL/discovery, collections, fees with year/audience/basis, provider-labelled intakes, English component scores, campuses/delivery, description/structure, Academic Options and scholarship acquisition with evidence/versioning.

## Phase 5 — Layer 3 LLM Extraction / Normalisation

**Estimated effort:** 20–28 hrs

Versioned extraction/model/routing profiles, evidence-backed claims, Academic Options, scholarship criteria normalisation, confidence thresholds and controlled vocabularies.

## Phase 6 — Layer 4 Human Review / Governance

**Estimated effort:** 18–24 hrs

Approval/rejection/conflict/reclassification/scholarship/evidence-change scenarios, immutable audit and reopening lineage.

## Phase 7 — Search, pgvector & Recommendation API

**Estimated effort:** 20–28 hrs

Website: structured search, FTS, semantic search, filters, related courses, detail and compare.  
Zoho: student-profile recommendation, hard filters first, semantic intent second, scholarship matching, batch compare and stable IDs.

Target API surface includes `/search/courses`, `/search/semantic`, `/courses/{id}`, `/courses/{id}/related`, `/courses/compare`, `/providers/{id}`, `/scholarships/search`, `/recommendations/courses`, `/recommendations/scholarships`.

## Phase 8 — Zoho Creator Integration & UAT

**Estimated effort:** 20–28 hrs

Validate stable IDs, filters, free-text intent, course/scholarship recommendations, batch compare, commercial re-ranking outside Coursefinder, conservative unknown eligibility, timeout/retry/idempotency and catalogue-generation propagation.

## Phase 9 — Website Integration & UAT

**Estimated effort:** 18–24 hrs

Website search/detail/filter/facet/related-course/scholarship/pagination/cache/rate-limit integration. Public website must use curated APIs and never query canonical schemas directly.

## Phase 10 — Performance, Load & Resilience UAT

**Estimated effort:** 18–24 hrs

Re-baseline API P50/P95/P99, Search Projection rebuild, embeddings, cache hit rate, vector latency, DB resource behaviour, concurrency and Zoho batching using representative Mumbai data.

Historical pilot baselines retained:
- Search Projection FTS ~1–3 ms.
- HNSW top-20 warm ~10.8 ms.
- Hybrid FTS + vector ~36.9 ms warm.
- 1,000 projected serial searches ~1.71 s vs ~23.99 s canonical-table equivalent.

## Phase 11 — Security / Production Readiness

**Estimated effort:** 14–20 hrs

Final RLS/privilege/authentication/secrets/storage/rate-limiting/API abuse/logging/backup/recovery/replay review. Phase 0A must already be complete; this is the final production review.

## Phase 12 — Production Cutover & Hypercare

**Estimated effort:** 10–16 hrs

Final reconciliation, projection/embedding rebuild, deploy API/Worker/UI, change Website and Zoho endpoints, smoke test, rollback checkpoint and 2–5 business day hypercare.

---

## 5. Remaining Effort Summary

| Phase | Estimate |
|---|---:|
| 0. New repo / Worker bootstrap | 6–10 hrs |
| 0A. RLS / privilege hardening | 4–6 hrs |
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
| **Remaining estimated effort** | **222–310 hrs** |

Overall planning envelope:
- achieved: ~100 hrs;
- remaining: ~222–310 hrs;
- total: ~322–410 hrs.

Re-estimate after the clean repo and first UI/Layer 2 delivery sprint.

---

## 6. UAT Streams

### Database / PIM
Schema integrity, stable keys, reference data, PIM forms/options/categories, collections, academic options, lineage, import/export and completeness.

### Pipeline
Layer 1 identity, Layer 2 acquisition/evidence, Layer 3 normalisation, Layer 4 governance/reopening/audit.

### Search / API
Structured search, FTS, semantic search, hybrid fusion, cache, related courses, comparison, scholarships and API versioning.

### Zoho
Stable IDs, profile-based recommendation, scholarship matching, batching, retry/idempotency and academic/commercial ranking separation.

### Website
Public search/detail/facets/semantic/related-course flows, rate limiting and cache behaviour.

### Security
RLS, grants, API boundaries, Auth/RBAC, Storage, secrets, advisor findings and abuse controls.

### Performance
P50/P95/P99, DB execution, vector latency/recall, cache hit rates, projection freshness, concurrency and Worker/Supabase telemetry.

---

## 7. Ongoing Delivery Records

Maintain these together:

1. `coursefinder-pilot-to-production-project-plan-v*.md` — scope, phases, hours and gates.
2. `coursefinder-running-build-v*.md` — exact current environment/build state and known issues.
3. `coursefinder-improvements-performance-roadmap-v*.md` — measured improvements and optimisation backlog.
4. Versioned architecture/database documents — only for material architecture/schema changes.

Every significant implementation change should update the running build document; every new optimisation idea should enter the roadmap rather than silently changing architecture.

---

## 8. Revision Log

### v1.1

- Added mandatory Phase 0A RLS/privilege hardening gate after Supabase flagged 61 internal tables with RLS disabled.
- Recorded Supabase Studio schema/visual expectations so an empty-looking `public` schema is not mistaken for an empty database.
- Added current table/row verification baseline.
- Increased remaining effort by 4–6 hrs for explicit RLS hardening.
- Defined the running-build document as a required ongoing delivery record.

### v1.0

- Initial Pilot-to-Production living plan.
