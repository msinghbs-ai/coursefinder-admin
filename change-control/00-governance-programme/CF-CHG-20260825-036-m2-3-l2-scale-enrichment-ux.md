# CF-CHG-20260825-036 — M2.3 Production-Grade Data Operations, Scale Enrichment & Decision UX

**Status:** APPROVED / IN PROGRESS — CORE PILOT UX/RUNTIME IMPLEMENTED; FINAL ACCEPTANCE CLASSIFICATION REMAINS  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 21:26 AEST (+10:00)  
**Scope expanded:** 25 August 2026 22:13 AEST (+10:00)  
**Last reconciled:** 26 August 2026 09:55 AEST (+10:00)  
**Owner:** CourseFinder programme / Data Operations

## Core milestone outcome

M2.3 is the production-grade Layers 1–4 Data Operations gate in Pilot/UAT. It does not create the separate Production environment or grant broad Publication authority.

`Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 AI-assisted Evidence interpretation → Layer 4 human resolution`.

Layer 4 is terminal. Search/Publication remain downstream states.

## Current reconciled implementation

The earlier 06:36 AEST partial-implementation record is superseded by Go 3/Go 4 runtime reconciliation.

Implemented and deployed in Pilot include:

- production-oriented Layer 1/Layer 2 execution and Evidence controls including bounded batch/retry/resume foundations;
- Firecrawl monthly budget guard for the user-confirmed 5,000 pages/month entitlement;
- Layer 3 profile/runtime under CF-CHG-20260825-038;
- terminal Layer 4 workspace with all six governed actions and detailed review context;
- reusable Country / Provider / Course Onboarding foundation and Admin workspace under CF-CHG-20260825-037;
- source-precise Important Dates and bounded refresh intelligence;
- Important Links directory;
- Scholarship Selection with explicit source-fact / derived-score / missing-unresolved semantics;
- PIM Admin release-note history;
- permanent deployed desktop/mobile regression across Data Quality, performance, Layer 2, Course Detail, M2.3 Intelligence and Scholarship Selection.

Go 4 adds the Platform-Admin-only Layer 3 Provider credential workflow using Supabase Vault without changing Layer 1, Layer 2, Layer 4 or Publication authority.

## Runtime checkpoints

### Go 3 accepted baseline

Pilot SHA `e94383bd4fd3b5718566bc4bb1c19f8cf687de36`:

- Frontend Build `32910110978` — PASS;
- Deployed UAT `32910110993` — PASS;
- desktop `98002494209` — PASS;
- mobile `98002494407` — PASS.

The desktop Evidence test recorded one transient `admin_read/evidence_detail` HTTP 500 that passed on retry; the job was green. Mobile was clean 27/27.

### Go 4 target

Pilot SHA `87da570d8e6701928e45d532caf11877b6eab369`:

- visible PIM Admin `v2.15.5`;
- M2.3 Intelligence `v1.2`;
- Frontend build PASS at this reconciliation write;
- expanded browser smoke and deployed desktop/mobile UAT executing; only their final outcome may establish this SHA as deployed-accepted.

## Layer 4/Admin UX — implemented

The deployed M2.3 Intelligence workspace exposes:

- status and unresolved-field filtering/prioritisation;
- before/proposed values;
- Evidence, Layer 2 and Layer 3 lineage;
- configured and returned Layer 3 model context;
- validator/token/cost context;
- full decision history;
- all six terminal actions;
- edited final value for Edit and Approve;
- downstream Search refresh signal context.

No second Layer 4 canonical authority is authorised.

## Important Dates/Admin UX — implemented

The browser is aligned to the source-precision model. Permanent deployed UAT verifies date-only UQ values, source-vague semantics, no fabricated timestamps and country-reference no-ingestion messaging.

## Onboarding — implemented, acceptance dependency remains

Migration `20260825202903_m2_3_onboarding_lifecycle_foundation` and the deployed Admin workspace provide the reusable lifecycle described in CF-CHG-037. The remaining CF-CHG-037 gate is representative lifecycle/negative-path acceptance, not implementation.

## Layer 3 provider boundary

The prior blocker caused by inability to manage/verify an authorised secret through the available surface is superseded. Go 4 provides an Admin-entered, Vault-backed, audited credential path. At this checkpoint the user has not yet entered a key; `openrouter-free-router-v1` remains enabled, PAUSED and `pending_credentials_and_benchmark`.

**Layer 3 external gate: BLOCKED — USER CREDENTIAL NOT YET CONFIGURED / QUALITY BENCHMARK NOT RUN.**

## Advisor state

Post-Go-4 Security Advisor: INFO-only; no WARN/ERROR.

Post-Go-4 Performance Advisor: INFO-only. Inherited unindexed-FK, unused-index and Auth connection-strategy observations remain backlog and do not represent a new Go 4 acceptance-level regression.

## Firecrawl commercial boundary

User-confirmed entitlement remains **Firecrawl paid subscription — 5,000 pages/month**. Do not fabricate monetary subscription cost. The deployed M2.3 budget guard must prevent silent paid fallback beyond the approved page allowance. Direct HTTP/zero-cost acquisition remains preferred when it satisfies the Evidence contract.

## Remaining M2.3 acceptance classification

Before M2.3 can close, reconcile the final Go 4 desktop/mobile result and explicitly classify remaining criteria, including:

- representative Onboarding lifecycle rollback/negative UAT;
- final production-grade Layer 1 source certification/recovery matrix;
- representative AU/NZ Layer 2 scale/economics qualification where not already covered;
- role guides/quick tours aligned to the final `v2.15.5` screens;
- the real Layer 3 OpenRouter benchmark after the user supplies the authorised credential;
- any remaining database/API/security/storage/replay/authority regressions not already retained in permanent UAT.

Every gate must end PASS, BLOCKED with evidence/accepted residual decision, or explicitly DEFERRED. M2.4 does not start before that classification.

## Commercial/time boundary

Technical execution does not create billable-time entries. The maintained engagement-time record remains authoritative.
