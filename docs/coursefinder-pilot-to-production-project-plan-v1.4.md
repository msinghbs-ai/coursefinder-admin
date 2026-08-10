# Coursefinder — Pilot to Production Project Plan v1.4

**Status:** Living delivery plan  
**Authoritative Pilot runtime:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Pilot code repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Architecture/design/planning/guides:** `msinghbs-ai/coursefinder-admin`

> `Coursefinder-Pilot` remains code/runtime only. All architecture, database design, project controls, UAT evidence, guides, handover and roadmap records remain in `coursefinder-admin`.

## Current Position

The clean Mumbai database is built through migration 025. Cloudflare production build/deploy and Supabase Auth login are confirmed. Catalogue UI Release 2 is merged with Providers, Campuses, Course Collections, Courses/detail, Scholarships, Categories and operational screens.

## Achieved Planning-Equivalent Effort

Approximately **110–116 hrs** to date. This remains an engineering planning estimate rather than a timesheet claim.

| Workstream | Est. achieved |
|---|---:|
| Architecture & domain modelling | 16 hrs |
| Physical DB design | 18 hrs |
| Pilot validation / scenarios | 16 hrs |
| Search / API / pgvector design | 14 hrs |
| Mumbai clean deployment | 12 hrs |
| Security/performance hardening to date | 8 hrs |
| UI/API bridge + Catalogue UI Releases 1–2 | 14–16 hrs |
| Layer 1 Settings/source-control contract | 2–3 hrs |
| Documentation / handover / guides | 10–13 hrs |
| **Total** | **~110–116 hrs** |

# Delivery Phases

## Phase 0 — Runtime Bootstrap
**Status:** COMPLETE

- clean code-only Pilot repository;
- Vite/React scaffold;
- Supabase Auth/client;
- Cloudflare Worker build/deploy;
- Pilot user login confirmed.

## Phase 0A — Mandatory RLS / Privilege Hardening
**Status:** BLOCKING before formal UAT sign-off  
**Estimate:** 4–6 hrs

- enable/harden RLS on internal domain tables;
- eliminate broad anon/auth direct-table access;
- preserve server/service workflows;
- rerun Security Advisor;
- require no unresolved Critical/Error findings.

## Phase 1 — PIM Admin UI
**Status:** IN PROGRESS  
**Remaining estimate:** 18–26 hrs

Completed:

- Dashboard;
- Providers;
- Campuses;
- Course Collections;
- Course list/detail;
- Scholarships;
- Categories;
- Attributes;
- Completeness;
- Review Queue;
- Pipeline/Jobs.

Remaining:

- provider/campus/collection detail;
- PIM Families and Attribute Groups;
- options management;
- category assignment UX;
- filters/sort/pagination/saved state;
- role-aware menus/actions;
- controlled create/update forms;
- bulk/publication/review actions.

## Phase 1A — Platform Admin Settings / Layer 1 Source Control
**Status:** STARTED  
**Estimate:** 8–12 hrs

Completed:

- existing `ref.countries`, `pipeline.sources`, `integration.systems` selected as source-of-truth model;
- migration 025 deployed for regulatory-source Settings read contract.

Remaining:

- research/approve authoritative source for each enabled Pilot country;
- populate regulatory source registry;
- Super Admin `Settings → Regulatory Sources` UI;
- health/check telemetry;
- last successful fetch / failure visibility;
- source enable/disable and controlled override write contract;
- role check limited to Platform Admin for mutation.

**Design rule:** Layer 1 automatically resolves and uses approved country sources; it does not silently trust internet-discovered regulator URLs.

## Phase 2 — Canonical Pilot Data Migration
**Estimate:** 14–20 hrs

- migrate wider validated catalogue using stable keys;
- trusted aliases/registrations/fees;
- provenance reconciliation;
- rebuild Search Projection;
- do not migrate legacy embeddings/cache blindly.

## Phase 3 — Layer 1 Regulatory Pipeline
**Estimate:** 14–20 hrs

- Worker reads enabled countries;
- resolves authoritative country source from Settings registry;
- uses acquisition policy/system configuration;
- ingests authoritative provider/course identity/registration;
- evidence + job lineage;
- re-run/change/conflict handling;
- 7-country regression.

## Phase 4 — Layer 2 Acquisition & Evidence
**Estimate:** 24–32 hrs

Provider/course URLs, descriptions, campuses, Course Collections, fees, intakes, English, Academic Options, scholarships, evidence and changed-evidence lineage.

## Phase 5 — Layer 3 LLM Extraction / Normalisation
**Estimate:** 20–28 hrs

Model/extraction/routing profiles, structured scholarship criteria, confidence calibration and evidence-backed candidates.

## Phase 6 — Layer 4 Governance
**Estimate:** 18–24 hrs

Role-checked review actions, conflict resolution, evidence re-opening, audit history and publication governance.

## Phase 7 — Search / Website / Zoho APIs
**Estimate:** 20–28 hrs

Versioned API contracts, structured/semantic search, course/provider detail, related courses, compare, scholarships and recommendations.

## Phase 8 — Zoho Creator Integration & UAT
**Estimate:** 20–28 hrs

Stable-ID lookup, filtering, semantic intent, recommendations, scholarship matching, batch operations, retries/idempotency and commercial re-ranking separation.

## Phase 9 — Website Integration & UAT
**Estimate:** 18–24 hrs

Public search/detail/filter, related courses, scholarships, pagination, cache, rate limits and contract validation.

## Phase 10 — Performance / Security / Scale UAT
**Estimate:** 16–22 hrs

- API P50/P95/P99;
- concurrent load testing;
- Search Projection/FTS/vector benchmarking;
- cache effectiveness;
- role/RLS/privilege/security testing;
- Worker telemetry and errors.

## Phase 11 — Production Readiness / Cutover
**Estimate:** 12–18 hrs

- production config/secrets;
- migration replay/reconciliation;
- final data rebuild;
- DNS/API consumer change;
- rollback/hypercare.

## Documentation Workstream — Continuous

Maintain throughout all phases:

- Running Build;
- User Guide;
- Admin Guide;
- architecture/database versions;
- UAT scenarios/evidence;
- API contracts;
- operational handover;
- Improvements & Performance Roadmap.

Guides should evolve by role and include screenshots/annotated workflows when the relevant UI is stable enough to avoid constant visual churn.

## Current Remaining Envelope

Current remaining engineering planning estimate: approximately **210–278 hrs**, subject to Layer 2 site variability, external regulator interfaces, Zoho complexity and UAT findings.

## Immediate Order

1. Populate/approve active-country Layer 1 sources.
2. Super Admin Regulatory Sources UI.
3. Mandatory RLS hardening.
4. Layer 1 Worker source resolution/regression.
5. Continue PIM UI role-aware controls.
6. Wider catalogue migration and Layer 2.
7. API + Zoho UAT.
8. Website UAT.
9. scale/security/performance gate.
10. production cutover.
