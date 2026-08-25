# CF-CHG-20260825-036 — M2.3 Production-Grade Data Operations, Scale Enrichment & Decision UX

**Status:** APPROVED / IN PROGRESS — EXPANDED SCOPE  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 21:26 AEST (+10:00)  
**Scope expanded:** 25 August 2026 22:13 AEST (+10:00)  
**Origin:** M2.2 → M2.3 sequential progression  
**Owner:** CourseFinder programme / Data Operations

## Trigger

M2.2 is CLOSED / PASS. M2.3 is the production-grade Data Operations maturity gate for Layer 1 and Layer 2, plus governed decision-support and onboarding foundations.

The user has confirmed Firecrawl is on a **paid subscription with 5,000 pages/month**. M2.3 must therefore stop treating Firecrawl as Free and reconcile live provider billing metadata, monthly-unit controls, remaining-budget visibility and no-surprise paid fallback before broad paid-provider batching.

M2.3 also introduces a separate **Country / Provider / Course Onboarding** workspace governed by `CF-CHG-20260825-037`. The onboarding framework must support future-country source qualification, adapter/Worker assessment, database-extension decisions and controlled Layer 1 → Layer 3 readiness without forking the canonical Provider/Course model.

The planned-hours baseline remains the existing 12-hour M2.3 planning allocation until engagement time is explicitly reconciled. Technical execution does not create billable-time entries.

## Core milestone outcome

Layer 1 is production-grade operational capability, not experimental. This does not create the separate Production environment or spend M2.5 Production deployment authority. Pilot/UAT remains the current validation environment; accepted Layer 1 semantics and operating controls must nevertheless meet Production-quality standards.

## Required top-level Admin structure

- Dashboard
- Catalogue / PIM
- **Onboarding**
- **Data Operations**
- Data Quality
- Scholarship Selection
- Search / Publication (only currently authorised capability)
- Administration / Settings
- Help / Guides

`Onboarding` owns controlled introduction of new countries/sources/providers/courses. `Data Operations` owns day-to-day Layer 1–4 execution, monitoring, retry/resume, Evidence and Jobs.

## Data Operations journey

**Data Operations**

1. Overview
2. Layer 1 — Regulatory
3. Layer 2 — Enrichment
4. Layer 3 — AI Interpretation (handoff/readiness only until M2.4 grants execution authority)
5. Layer 4 — Human Resolution
6. Evidence & Provenance
7. Jobs / Runs

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream states.

## Scope

### 1. Layer 1 — production-grade regulatory operations

- Remove experimental/trial framing for accepted Layer 1 country/source pipelines.
- Reconcile every accepted regulatory Provider/Course authority and adapter.
- Define and vet source-specific pagination/page-size, safe batch size, concurrency, rate limit, timeout, retry/backoff, cursor/resume and maximum safe execution window.
- Distinguish source-native limits from CourseFinder safety limits.
- Validate repeatability, idempotency, freshness, identity/count/hash invariants and failure recovery.
- Maintain a Source Certification Matrix with READY / CONDITIONAL / BLOCKED status.
- Centralise batch/rate/retry policy where practical instead of scattering limits through Workers.

### 2. Layer 2 — production-shaped scale and economics

- Collect/reconcile all current Layer 2 ingestion profiles, routes, acquisition providers, attempts, Evidence, deterministic extractors, candidate mappings and unresolved handoff state.
- Controlled provider budgets/concurrency and no surprise paid fallback.
- Production-shaped batch scheduling, retry/resume, partial completion, cancellation and replay.
- Evidence dedupe, retention, storage thresholds and growth economics.
- Representative/broad AU/NZ Course/Scholarship enrichment with identity and fee guards.
- NZ first-party Layer 2 qualification/profile work where current profile coverage is absent.
- Measure vendor units, cost/entity, cost/resolved entity, retry/fallback, Evidence/entity and resolution quality.

### 3. Firecrawl paid-provider control

Confirmed commercial entitlement: **Firecrawl paid subscription — 5,000 pages/month**.

M2.3 must:

- replace stale `plan_tier=free` runtime/governance metadata with the confirmed paid entitlement;
- treat the 5,000-page allowance as a monthly vendor-unit budget;
- record billing-cycle/reset semantics when available;
- expose used / remaining / projected monthly pages where measurable;
- define warning/stop thresholds before exhausting the allowance;
- include Firecrawl pages in batch impact preview;
- prevent a batch from silently falling through to Firecrawl when its approved budget would be exceeded;
- retain direct HTTP/zero-cost preference where it satisfies the accepted Evidence contract;
- measure paid-provider pages per attempted/resolved entity.

Do not fabricate monetary subscription cost if the actual billed amount is not in the project billing record.

### 4. Country / Provider / Course Onboarding

Implement the framework governed by `CF-CHG-20260825-037`.

The canonical architecture remains shared and country-neutral:

- Providers use governed country identity;
- Courses remain keyed to Providers;
- stable entity keys remain global;
- source-specific/native staging preserves source grain;
- adapters/Workers handle source differences;
- extension/fact tables are used for genuinely country-specific regulatory concepts;
- do not create a separate canonical Provider/Course schema per country.

Onboarding stages should cover:

`Draft → Source Qualification → Adapter Assessment → Schema Assessment → Layer 1 UAT → Layer 2 UAT → Layer 3 Ready → Operational Certification → Production Promotion Ready`.

Layer 3 general execution remains M2.4 authority. M2.3 may build the onboarding stage, profile/configuration and handoff readiness.

Use the same codebase/migrations/adapter framework across UAT/Pilot and Production, but never one Supabase project/database as both environments. Promote accepted configuration, migrations and adapter SHAs—not UAT secrets, live job state or Evidence objects.

### 5. Unified Data Operations UX

For Layers 1–4 expose consistent operational concepts where applicable:

- source/configuration and authority;
- last successful run/current job;
- discovered/selected/processed/accepted/rejected;
- creates/updates/unchanged/conflicts;
- Evidence count;
- duration;
- batch/concurrency/rate limits;
- retry/resume cursor;
- next action;
- health/freshness;
- blocker;
- affected entities;
- Change Control/UAT reference.

Use drill-down rather than duplicate pages.

### 6. Scholarship Selection mini-app

Create transparent, coverage-aware decision support using governed Provider/Course/Scholarship facts. Rank only on explicit criteria; explain WHY an option matched; distinguish SOURCE FACT, DERIVED SCORE and MISSING/UNRESOLVED. Missing data is not zero. Link results to Course, Provider, Scholarship and Evidence. This is not admissions/visa/application authority.

### 7. Course detail blade

Include, where applicable:

- regulatory identity;
- CRICOS fee concepts kept separate;
- Provider-current Layer 2 facts;
- QILT contextual metrics with grain/period/source clearly labelled;
- PRISMS contextual signals with grain/period/source clearly labelled;
- relevant Scholarships;
- Evidence/freshness/completeness/unresolved state;
- Search/publication state without implying publication authority;
- compact cross-layer timeline.

### 8. Menu simplification and guides

Remove redundant Sources/Pipelines/Enrichment/Jobs/Evidence top-level overhead where functionality belongs inside Data Operations. Preserve deep links and role permissions.

Update User Guide, PIM/Admin Guide and Operations guidance with deployed screen mock-ups/screenshots and role-specific quick tours for Platform Admin, PIM/Data Admin, Reviewer, Counsellor and Integration/Operations support.

## Automated UAT

M2.3 requires automated database/API/security/storage/performance/replay/deployed desktop/mobile UAT including:

- Layer 1 source certification and source-specific limit tests;
- Layer 2 batch/retry/resume/provider-budget tests;
- Firecrawl 5,000-page budget enforcement and no-surprise paid fallback;
- Evidence replay/dedupe/storage-threshold tests;
- Country/provider/course onboarding workflow UAT;
- adapter/schema-assessment decision UAT;
- Course detail QILT/PRISMS semantic tests;
- Scholarship Selection deterministic scoring/explanation/coverage tests;
- role/navigation/negative-authorisation tests;
- M1/M2.1/M2.2 identity, fee, Auth, Search and Publication regression.

## Authority boundaries

M2.3 does not authorise:

- the separate Production environment/cutover owned by M2.5;
- general Layer 3 AI execution beyond onboarding/readiness/handoff;
- broad Publication;
- Production consumer traffic;
- Zoho cutover;
- final Production handover;
- fabricated Course/Provider/Scholarship/QILT/PRISMS facts.

## Current evidence inherited

- M2.2 CLOSED / PASS on accepted Pilot state.
- First real M2.3 UQ batch completed 3/3 resolved at Layer 2 after one bounded retry, 3 vendor units, USD 0 vendor cost.
- Modern Evidence idempotent replay/dedupe controls are implemented.
- Firecrawl credential has historical successful runtime evidence; commercial entitlement is now confirmed by the user as paid 5,000 pages/month and must be reconciled into runtime metadata/control policy.
- Current NZ Layer 2 Course-detail first-party profile coverage remains a gap to qualify/implement if still absent.
- Country/provider/course onboarding framework is governed separately by `CF-CHG-20260825-037` and is part of M2.3 acceptance.

## Acceptance

M2.3 closes only when:

- accepted Layer 1 sources are production-grade and source-specific batch policies are vetted;
- all current Layer 2 ingestion paths are reconciled and representative/broad batching, retries, economics and Evidence controls are proven;
- Firecrawl paid 5,000-page monthly controls are represented and enforced;
- Country/Provider/Course Onboarding is implemented to its accepted M2.3 boundary without creating country-specific canonical forks;
- unified Onboarding/Data Operations IA is deployed and role-safe;
- Course detail QILT/PRISMS context passes semantic UAT;
- Scholarship Selection is deployed with transparent, coverage-aware ranking;
- Admin/User Guides and role quick tours match deployed behaviour;
- automated database/API/security/storage/browser/performance/replay UAT passes;
- M1/M2.1/M2.2 invariants remain safe.

## Rollback

Any batch, onboarding or UX change that threatens canonical identity, source authority, fee semantics, Evidence integrity, security, storage capacity, provider budget or publication boundaries is stopped/reverted and retained as blocker evidence.

## Documentation

Maintain Master Project Plan/TSOW, Running Build, Change Control Register, `CF-CHG-20260825-037`, architecture/data-flow decisions, navigation/IA, Operations Runbook, Admin/PIM Guide, User Guide, role quick tours, milestone record and M2.3 UAT evidence.