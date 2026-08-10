# Coursefinder — Pilot to Production Project Plan v1.3

**Status:** Living delivery plan  
**Authoritative Pilot runtime:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Pilot code repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Architecture/design/planning repository:** `msinghbs-ai/coursefinder-admin`

> `Coursefinder-Pilot` remains code/runtime only. Architecture, database design, migrations/design records, project plans, UAT evidence, handover and roadmap remain in `coursefinder-admin`.

## Current position

The Mumbai production-model database is deployed through migration 024. Cloudflare production build/deploy is working, Supabase Auth login has been manually confirmed, and the second catalogue UI release has been merged.

Current Pilot seed:

- 7 Australian providers;
- 35 courses;
- 35 Search Projection documents;
- Search Projection generation 2.

## Planning-equivalent effort achieved

These are engineering planning estimates, not timesheet hours.

| Workstream | Est. achieved |
|---|---:|
| Architecture & domain modelling | 16 hrs |
| Physical DB design | 18 hrs |
| Pilot validation / scenario design | 16 hrs |
| Search / API / pgvector design | 14 hrs |
| Mumbai clean DB deployment | 12 hrs |
| Security & performance work to date | 8 hrs |
| UI/API bridge + Pilot UI Release 1/2 | 14–18 hrs |
| Documentation / handover / project controls | 10–12 hrs |
| **Total planning-equivalent achieved** | **~108–114 hrs** |

## Phase 0 — Clean Pilot repository & runtime bootstrap

**Status:** COMPLETE  
**Original estimate:** 6–10 hrs

Completed:

- clean code-only GitHub repo;
- Vite/React/Supabase Auth application;
- Cloudflare Worker deployment;
- environment variables/runtime connectivity;
- successful production build;
- authenticated Supabase login.

**Exit gate:** PASSED.

## Phase 0A — Mandatory RLS / privilege hardening

**Status:** BLOCKING before formal UAT sign-off  
**Estimate:** 4–6 hrs

Required:

- enable RLS on the 61 identified internal domain tables;
- validate anon/authenticated direct-table privileges;
- preserve service-role/server execution;
- validate UI RPCs after hardening;
- re-run Security Advisor;
- no Critical/Error findings before formal UAT approval.

Early read-only UI visual development may continue in parallel. Write operations remain blocked.

## Phase 1 — PIM Admin UI

**Status:** IN PROGRESS  
**Total estimate:** 24–32 hrs

### Wave 1 — Read-only shell — COMPLETE

- Dashboard
- Providers
- Courses
- Scholarships
- Attributes
- Completeness
- Review Queue
- Pipeline
- Jobs

### Wave 2 — Core catalogue workspaces — IN PROGRESS

Implemented/merged:

- Campuses list;
- Course Collections list;
- Categories list;
- Course master/detail workspace;
- Course detail for fees, intakes, English, Academic Options, Collections and Categories.

Remaining:

- Provider detail workspace;
- Campus detail;
- Course Collection detail/hierarchy;
- Category tree interaction;
- filters/sort/pagination/saved table state;
- evidence/completeness detail inside course workspace.

### Wave 3 — PIM configuration

Planned:

- Attribute Families;
- Attribute Groups;
- Attribute Definitions;
- Options;
- Category assignment;
- Completeness Profiles.

### Wave 4 — Controlled write operations

Blocked by security/role gate:

- role-checked create/update APIs;
- family-driven edit forms;
- bulk actions;
- publication actions;
- review/evidence decisions.

**Phase exit gate:** authorised UAT user can manage Provider/Course through PIM workflows without direct browser access to internal schemas.

## Phase 2 — Canonical Pilot data migration

**Status:** UI seed only  
**Estimate:** 14–20 hrs

- reconcile wider validated source catalogue;
- migrate stable identities, aliases, registrations and trusted detail rows;
- preserve source/evidence provenance;
- do not migrate old embeddings/query cache;
- rebuild Search Projection;
- reconcile counts and stable keys.

## Phase 3 — Layer 1 regulatory pipeline

**Status:** NOT STARTED in clean Pilot runtime  
**Estimate:** 12–18 hrs

- promote/rebuild Layer 1 worker;
- regress existing 7-country ingestion;
- evidence/identity handling;
- incremental reruns and failure handling;
- Jobs/Review Queue visibility.

## Phase 4 — Layer 2 acquisition & evidence

**Estimate:** 24–32 hrs

- course URLs/descriptions;
- provider Course Collections;
- fees year/audience/basis;
- labelled intakes;
- English/components;
- campuses/delivery;
- Academic Options;
- scholarship acquisition;
- evidence snapshots/content hashes/supersession.

## Phase 5 — Layer 3 LLM extraction / normalisation

**Estimate:** 20–28 hrs

- versioned extraction profiles;
- model/routing profiles;
- structured field normalisation;
- scholarship criteria normalisation;
- confidence calibration;
- evidence-backed candidate values.

## Phase 6 — Layer 4 governance

**Estimate:** 18–24 hrs

- role-checked review actions;
- authority/conflict handling;
- evidence-change reopening;
- immutable audit history;
- publication governance.

## Phase 7 — API creation / Search / Recommendation

**Estimate:** 20–28 hrs

Planned versioned API surface:

- `/v1/search/courses`
- `/v1/search/semantic`
- `/v1/courses/{id}`
- `/v1/courses/{id}/related`
- `/v1/courses/compare`
- `/v1/providers/{id}`
- `/v1/scholarships/search`
- `/v1/recommendations/courses`
- `/v1/recommendations/scholarships`

Requirements:

- stable IDs;
- structured eligibility filters before semantic scoring;
- server-side embeddings;
- query embedding cache;
- rate limiting/telemetry;
- Website and Zoho field/channel profiles;
- academic ranking separate from commercial preference.

## Phase 8 — Zoho Creator integration & UAT

**Estimate:** 20–28 hrs

UAT scenarios:

1. stable Provider/Course ID lookup;
2. hard-filter course search;
3. free-text student intent;
4. course recommendations;
5. scholarship recommendations;
6. batch compare;
7. academic ranking validation;
8. Zoho commercial reranking outside Coursefinder;
9. `eligible` / `ineligible` / `possible` eligibility handling;
10. timeout/retry/idempotency;
11. no raw commission/agreement data in public/search vectors;
12. catalogue/Search Projection generation propagation.

**Integration boundary:** Zoho consumes documented APIs only; no direct database access.

## Phase 9 — Website integration & UAT

**Estimate:** 18–24 hrs

- structured search;
- filters/facets;
- course/provider detail;
- related courses;
- scholarships;
- pagination;
- anonymous/public API safety;
- caching/rate limits;
- warm/cold response tests.

## Phase 10 — Performance / Load / Resilience UAT

**Estimate:** 18–24 hrs

Historical Pilot comparison baseline retained:

- representative canonical search ~24 ms;
- Search Projection FTS ~1.25 ms;
- ~19× improvement for that representative query;
- 1,000 canonical searches ~23.99 s;
- 1,000 projected searches ~1.71 s;
- warm HNSW neighbour lookup ~10.8 ms;
- warm hybrid search ~36.9 ms.

Re-baseline after wider Mumbai catalogue and production embeddings are loaded.

Measure:

- API P50/P95/P99;
- DB/search/vector latency;
- embedding provider latency;
- cache hit rate;
- Worker errors/CPU;
- connection pressure;
- Search Projection rebuild time;
- pipeline throughput/queue age.

## Phase 11 — Security / Production readiness

**Estimate:** 14–20 hrs

- final Security/Performance Advisor pass;
- RLS/roles/API privilege review;
- secrets review;
- Storage evidence controls;
- rate limiting/abuse controls;
- logging/audit;
- backup/recovery;
- clean migration replay;
- UAT sign-off/runbook.

## Phase 12 — Production cutover & hypercare

**Estimate:** 10–16 hrs

- final catalogue reconciliation;
- Search Projection rebuild;
- full embedding generation;
- release API/Worker/UI;
- update Website and Zoho endpoints;
- smoke test/rollback checkpoint;
- 2–5 business day hypercare.

## Updated remaining effort envelope

Because Phase 0 is now complete and Phase 1 is partially delivered, the remaining planning estimate is approximately:

| Remaining scope | Estimate |
|---|---:|
| Phase 0A security gate | 4–6 hrs |
| Remaining Phase 1 UI | 14–20 hrs |
| Phase 2 | 14–20 hrs |
| Phase 3 | 12–18 hrs |
| Phase 4 | 24–32 hrs |
| Phase 5 | 20–28 hrs |
| Phase 6 | 18–24 hrs |
| Phase 7 | 20–28 hrs |
| Phase 8 | 20–28 hrs |
| Phase 9 | 18–24 hrs |
| Phase 10 | 18–24 hrs |
| Phase 11 | 14–20 hrs |
| Phase 12 | 10–16 hrs |
| **Remaining planning estimate** | **~206–264 hrs** |

Overall current engineering planning envelope:

- achieved: **~108–114 hrs**;
- remaining: **~206–264 hrs**;
- total: **~314–378 hrs**.

Re-estimate after Layer 2 implementation velocity and first Zoho API UAT are known.

## Immediate next gate

1. validate Pilot UI Release 2 Cloudflare build/runtime;
2. execute RLS/privilege hardening before formal UAT sign-off;
3. Provider detail + PIM configuration UI;
4. prepare controlled write API boundary;
5. begin wider canonical data migration and Layer 1/2 runtime promotion.

## Revision

### v1.3

- Cloudflare runtime bootstrap marked complete.
- Supabase Auth UAT login confirmed.
- Migration 024 and Pilot UI Release 2 incorporated.
- Remaining hours reduced to reflect delivered runtime/UI work.
