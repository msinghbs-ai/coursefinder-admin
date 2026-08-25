# CF-CHG-20260825-036 — M2.3 Production-Grade Data Operations, Scale Enrichment & Decision UX

**Status:** APPROVED / IN PROGRESS — PARTIAL IMPLEMENTATION, ACCEPTANCE NOT MET  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 21:26 AEST (+10:00)  
**Scope expanded:** 25 August 2026 22:13 AEST (+10:00)  
**Last reconciled:** 26 August 2026 06:36 AEST (+10:00)  
**Owner:** CourseFinder programme / Data Operations

## Core milestone outcome

M2.3 is the complete production-grade Layers 1–4 Data Operations gate in Pilot/UAT. It does not create the separate Production environment or grant broad Publication authority.

The accepted authority model remains:

`Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 AI-assisted Evidence interpretation → Layer 4 human resolution`.

Layer 4 is terminal. Search/Publication remain downstream states.

## Required M2.3 scope

M2.3 acceptance requires all of the following to be reconciled and automated-UAT backed:

- production-grade Layer 1 source certification, source-specific batch/rate/retry/resume/freshness policy and failure recovery;
- production-shaped Layer 2 scale, AU/NZ deterministic enrichment, Evidence lifecycle, retry/resume and provider economics;
- Firecrawl paid 5,000 pages/month controls with used/remaining/batch-impact/stop thresholds and no surprise paid fallback;
- operational Layer 3 under CF-CHG-20260825-038;
- operational terminal Layer 4 with complete review context and all six governed actions;
- Country/Provider/Course onboarding under CF-CHG-20260825-037;
- unified Onboarding / Data Operations IA;
- Course detail QILT/PRISMS/Scholarship context with grain/period/source semantics intact;
- transparent Scholarship Selection with SOURCE FACT / DERIVED SCORE / MISSING-UNRESOLVED distinctions;
- Important Links and Important Dates/refresh intelligence;
- role quick tours, Admin/User/Operations guidance matching the deployed application;
- full database/API/security/storage/replay/performance/desktop/mobile/deployed-runtime regression.

## Current reconciled implementation

CF-CHG-20260825-038 now has a live-reconciled Layer 3/4/refresh foundation. Current database migration tail includes:

- `20260825124619_m2_3_layer3_layer4_refresh_intelligence_foundation`;
- `20260825124942_m2_3_layer3_refresh_admin_read_write_contracts`;
- `20260825125714_m2_3_authenticated_rpc_invoker_hardening`;
- `20260825125742_m2_3_foreign_key_index_hardening`;
- `20260825133136_m2_3_refresh_scheduler_layer4_terminal_operations`;
- `20260825133749_m2_3_important_dates_source_precision`.

The unknown Important Dates migration was recovered exactly from deployed migration history and restored to Pilot source in commit `3858a8f9bf4ccfb7bb5aec89fbc239420718e47e` without changing runtime semantics.

Live refresh state has ten enabled source-targeted policies and zero unbounded policies. The scheduler cron remains active every 15 minutes as bounded work selection only.

The Layer 3 OpenRouter free-router profile remains intentionally PAUSED because authorised server-secret presence cannot be enumerated through the available management surface. Provider benchmark gate remains `BLOCKED — CREDENTIAL REQUIRED / AUTHORISED SERVER SECRET NOT VERIFIED` while all noncredential M2.3 work continues.

## Current CI/runtime checkpoint

Last fully reconciled semantic Pilot runtime:

- SHA `400e06d26cb7147a14971af578607816b0aca342`;
- Frontend Build `32854071358` — PASS;
- Deployed UAT `32854071828` — PASS;
- desktop `97821647704` — PASS;
- mobile `97821647394` — PASS.

Migration-source synchronisation SHA `3858a8f9bf4ccfb7bb5aec89fbc239420718e47e` has Frontend Build `32894556070` PASS; its deployed UAT `32894556145` was still executing at this governance checkpoint and therefore is not yet recorded as deployed-accepted.

## Advisor state

Latest Security Advisor contains no M2.3 WARN/ERROR finding. Remaining RLS/no-policy entries are INFO-only on deliberately private/RLS-protected schemas.

Latest Performance Advisor is INFO-only; no new M2.3 Layer 3/4/refresh unindexed-FK regression is present after the earlier hardening migration.

## Confirmed remaining gaps

This Change Control is not complete merely because L3/L4/refresh foundations exist.

### Layer 4/Admin UX

The browser currently exposes the six terminal actions and before/proposed values, but it does not yet consume the complete `layer4_review_context` package. M2.3 still requires filters/prioritisation, Evidence opening, Layer 2 context, Layer 3 configured/returned model/result/validator/token/cost context, full decision history, edited final value and downstream refresh result.

### Important Dates/Admin UX

The database supports source-precise date-only semantics through `important_date_upsert_v2`, but the current browser still uses the older timestamp-oriented write path and therefore must be corrected before acceptance.

### Onboarding

No reusable Onboarding workspace/table/function foundation was present at reconciliation. CF-CHG-20260825-037 remains an active acceptance dependency and must not be marked complete.

### Layer 1 / Layer 2 scale and economics

The current M2.3 work does not yet constitute final production-grade certification of every accepted Layer 1 source or broad AU/NZ Layer 2 scale. Firecrawl runtime metadata/control must still reflect the user-confirmed paid 5,000 pages/month entitlement and enforce monthly budget boundaries. NZ first-party Layer 2 coverage remains to be reconciled/qualified where absent.

### Course/Scholarship decision intelligence

Course detail QILT/PRISMS contextual semantics, Scholarships and the Scholarship Selection mini-app still require explicit deployed acceptance evidence against the M2.3 scope. Missing data must never be converted to zero or false certainty.

### Guides and regression

Admin/User/Operations guidance and role tours must be reconciled to the final deployed M2.3 screens. Full inherited M1/M2.1/M2.2 identity, fee, Auth, Evidence, Search and Publication regression is still required.

## Firecrawl commercial boundary

User-confirmed entitlement remains **Firecrawl paid subscription — 5,000 pages/month**. Do not fabricate monetary subscription cost. M2.3 must track/enforce page allowance semantics and prevent silent fallback that would exceed an approved budget. Direct HTTP/zero-cost acquisition remains preferred when it satisfies the accepted Evidence contract.

## Acceptance

**Gate: IN PROGRESS.**

CF-CHG-20260825-036 closes only when every applicable acceptance criterion above is PASS, deliberately DEFERRED outside M2.3, or explicitly accepted as a residual risk with evidence. M2.4 optimisation/regression work does not start before the M2.3 acceptance boundary is established.

## Commercial/time boundary

Technical execution does not create billable-time entries. The maintained engagement-time record remains authoritative.