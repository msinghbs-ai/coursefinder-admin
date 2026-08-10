# Coursefinder — Pilot to Production Project Plan v1.2

**Status:** Living delivery plan  
**Authoritative Pilot runtime:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Pilot code repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Architecture/design/planning repository:** `msinghbs-ai/coursefinder-admin`

> The Pilot repository is code/runtime only. Architecture, database design, project planning, UAT evidence, build state, handover and roadmap records remain in `coursefinder-admin`.

## Current position

The clean Mumbai production-model database is built through migration 023 with a 7-provider / 35-course UAT seed and Search Projection generation 2. The new clean Pilot GitHub repository has been created and the first read-only PIM UI shell has been merged to `main`.

### Completed foundation

- Mumbai Supabase Pilot created and deployed.
- Production-model multi-schema database built.
- PIM, catalogue, scholarship, pipeline, workflow, publishing, search and security structures implemented.
- Search Projection, PostgreSQL FTS, pgvector/HNSW structures, Search Profiles and query cache designed/deployed.
- UI authenticated RPC bridge deployed.
- Supabase Studio multi-schema visual expectations documented.
- 61-table RLS hardening requirement identified and recorded as mandatory pre-UAT security gate.
- `Coursefinder-Pilot` clean code repository created.
- Pilot UI PR #1 merged: commit `10474eba29ea51835ea1cb42260f10d8a7fa76ae`.
- Vite/React/Supabase Auth scaffold implemented.
- Live read-only screens implemented: Dashboard, Providers, Courses, Scholarships, Attributes, Completeness, Review Queue, Pipeline and Jobs.
- Placeholder navigation created for Campuses, Course Collections, Categories, Integrations and Settings pending dedicated API contracts.

## Engineering effort achieved so far

Planning-equivalent effort remains approximately **~100–108 hours**. This is an engineering planning estimate, not a timesheet claim.

| Workstream | Est. achieved |
|---|---:|
| Architecture & domain modelling | 16 hrs |
| Physical DB design | 18 hrs |
| Pilot validation / scenario design | 16 hrs |
| Search / API / pgvector design | 14 hrs |
| Mumbai clean project deployment | 12 hrs |
| Security & performance hardening to date | 8 hrs |
| UI/API bridge and first Pilot UI shell | 10–12 hrs |
| Documentation / handover / project controls | 10–12 hrs |
| **Total planning-equivalent achieved** | **~104–108 hrs** |

## Phase plan

### Phase 0 — Clean Pilot repository & runtime bootstrap

**Status:** IN PROGRESS / largely complete  
**Estimate:** 6–10 hrs

Completed:

- clean GitHub Pilot repo;
- code-only repository boundary;
- Vite/React scaffold;
- Supabase client/auth integration;
- environment template;
- first PIM UI shell merged.

Remaining:

- connect new Cloudflare Worker/Pages deployment;
- configure environment variables;
- confirm `npm run build` and `dist` deployment;
- confirm Pilot URL and runtime connectivity.

**Exit gate:** Cloudflare build succeeds and authenticated UI connects to Mumbai.

### Phase 0A — Mandatory RLS / privilege hardening

**Status:** BLOCKING before formal UI/UAT sign-off  
**Estimate:** 4–6 hrs

Scope:

- enable RLS on the 61 currently unprotected internal domain tables;
- validate no broad anon/authenticated direct-table access;
- preserve service-role/server workflows;
- validate authenticated UI RPCs after hardening;
- re-run Security Advisor;
- require no Critical/Error findings before UAT sign-off.

This can run in parallel with early UI visual development but must complete before formal UAT.

### Phase 1 — PIM Admin UI

**Status:** STARTED  
**Estimate:** 24–32 hrs total

#### Wave 1 — read-only shell — COMPLETED baseline

- Dashboard
- Providers
- Courses
- Scholarships
- Attributes
- Completeness
- Review Queue
- Pipeline
- Jobs

#### Wave 2 — core catalogue workspaces

- Provider detail
- Campus list/detail
- Course Collection list/detail
- Course detail
- Academic Options inside Course detail
- Category tree
- filters, sort, pagination and saved table state

#### Wave 3 — PIM configuration

- Families
- Attribute Groups
- Attributes
- Options
- Category assignments
- Completeness Profiles

#### Wave 4 — controlled write operations

- role-checked create/update APIs;
- edit forms generated from family/group/attribute configuration;
- bulk operations;
- publication state actions;
- review/evidence actions.

**Exit gate:** authorised Pilot user can manage a provider/course through PIM-style workflows without direct internal-schema browser access.

### Phase 2 — Canonical Pilot data migration

**Status:** NOT STARTED beyond UI seed  
**Estimate:** 14–20 hrs

- reconcile wider validated source catalogue;
- migrate stable provider/course identities;
- migrate aliases/registrations/fees where trusted;
- retain provenance;
- do not migrate old embeddings/cache;
- rebuild Search Projection.

### Phase 3 — Layer 1 regulatory pipeline

**Estimate:** 12–18 hrs

- promote/rebuild Layer 1 worker for clean Pilot runtime;
- 7-country regression;
- incremental/rerun failure handling;
- evidence and identity reconciliation.

### Phase 4 — Layer 2 acquisition & evidence

**Estimate:** 24–32 hrs

- URLs, descriptions, collections, fees, intakes, English, campuses, academic options;
- scholarship acquisition;
- evidence snapshots/content hashes;
- changed-evidence lineage.

### Phase 5 — Layer 3 LLM extraction / normalisation

**Estimate:** 20–28 hrs

- extraction/model/routing profiles;
- structured scholarship criteria;
- confidence calibration;
- evidence-backed candidate values.

### Phase 6 — Layer 4 governance

**Estimate:** 18–24 hrs

- review actions;
- conflict handling;
- evidence-change reopening;
- immutable audit history;
- publication governance.

### Phase 7 — Search / Website / Zoho APIs

**Estimate:** 20–28 hrs

Core API surface:

- `/search/courses`
- `/search/semantic`
- `/courses/{id}`
- `/courses/{id}/related`
- `/courses/compare`
- `/providers/{id}`
- `/scholarships/search`
- `/recommendations/courses`
- `/recommendations/scholarships`

Requirements:

- stable IDs;
- hard filters before semantic scoring;
- server-side query embeddings;
- query embedding cache;
- versioned API contracts;
- academic ranking separate from Zoho commercial reranking.

### Phase 8 — Zoho Creator integration & UAT

**Estimate:** 20–28 hrs

UAT includes stable-ID lookup, filtered search, semantic intent, recommendations, scholarship matching, batch compare, retry/idempotency and commercial reranking separation.

### Phase 9 — Website integration & UAT

**Estimate:** 18–24 hrs

- public search/detail/filter integration;
- related courses;
- scholarships;
- pagination;
- caching/rate limits;
- anonymous public API safety.

### Phase 10 — Performance/load/resilience

**Estimate:** 18–24 hrs

Retain historical Pilot baselines for comparison:

- Search Projection FTS ~1–3 ms in pilot DB tests;
- HNSW warm vector ~10.8 ms;
- hybrid warm ~36.9 ms;
- 1,000 projected serial searches ~1.71 s vs ~23.99 s canonical-table path.

Re-baseline after wider Mumbai catalogue and full embeddings.

### Phase 11 — Security / production readiness

**Estimate:** 14–20 hrs

- final Security/Performance Advisor;
- Auth/RBAC/API/RPC/RLS review;
- secrets and storage review;
- rate limiting and logging;
- backup/recovery;
- migration replay test;
- deployment/runbook.

### Phase 12 — Production cutover & hypercare

**Estimate:** 10–16 hrs

- final reconciliation;
- projection/embedding rebuild;
- API/UI release;
- Website/Zoho endpoint switch;
- smoke test/rollback;
- 2–5 business-day hypercare.

## Remaining effort summary

| Phase | Remaining estimate |
|---|---:|
| 0. Runtime/Cloudflare completion | 2–4 hrs |
| 0A. RLS hardening | 4–6 hrs |
| 1. Remaining PIM UI | 18–26 hrs |
| 2. Wider Pilot data migration | 14–20 hrs |
| 3. Layer 1 | 12–18 hrs |
| 4. Layer 2 | 24–32 hrs |
| 5. Layer 3 | 20–28 hrs |
| 6. Layer 4 | 18–24 hrs |
| 7. Search/API | 20–28 hrs |
| 8. Zoho integration/UAT | 20–28 hrs |
| 9. Website integration/UAT | 18–24 hrs |
| 10. Performance/load | 18–24 hrs |
| 11. Security/readiness | 14–20 hrs |
| 12. Cutover/hypercare | 10–16 hrs |
| **Remaining planning estimate** | **~212–298 hrs** |

Overall engineering planning envelope is approximately **~316–406 hrs**, subject to re-estimation after Cloudflare build validation, UI Wave 2 delivery velocity and Layer 2 implementation.

## Current gates

1. **Cloudflare build/runtime gate** — next.
2. **RLS hardening gate** — mandatory before formal UAT.
3. **Auth/RBAC UAT user gate** — required for actual user testing.
4. **Core catalogue API contract gate** — required for Collections/Campuses/Categories and write-enabled UI.
5. **Zoho/API UAT gate** — after canonical data/search APIs are stable.

## Revision log

### v1.2

- Establishes code-only `Coursefinder-Pilot` repo boundary.
- Records first Pilot UI merge and Phase 1 start.
- Splits Cloudflare runtime validation from the UI shell build.
- Keeps RLS hardening as a mandatory security gate.
- Updates remaining effort to reflect delivered UI baseline.
