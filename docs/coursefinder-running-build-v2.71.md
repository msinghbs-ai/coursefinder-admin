# CourseFinder Running Build v2.71

**Status:** M1 FROZEN / M2.1 CLOSED-PASS / M2.2 CLOSED-PASS / **M2.3 ACTIVE — GOVERNANCE/RUNTIME RECONCILED**  
**Date:** 26 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.70.md`  
**Change Controls:** `CF-CHG-20260825-036`, `CF-CHG-20260825-037`, `CF-CHG-20260825-038`

## Current programme authority

Master Project Plan `v1.71` and M2→Production Delivery Plan / TSOW `v1.4` are current.

M2.3 is the complete operational Layers 1–4 / Data Operations / Onboarding acceptance gate. M2.4 is optimisation/regression/residual-risk/pre-blackout freeze work only and must not begin before M2.3 acceptance.

## Reconciled Pilot source/runtime

Last fully reconciled semantic Pilot runtime:

`400e06d26cb7147a14971af578607816b0aca342`

Evidence:

- Frontend Build `32854071358` — PASS;
- deployed UAT `32854071828` — PASS;
- desktop job `97821647704` — PASS;
- mobile job `97821647394` — PASS.

The previous selector-only correction remained `19cf9ba6bea6418f5cc7ef0a99e39d08dcba9878`, with replacement build `32852190781` PASS and deployed UAT `32852190776` PASS.

## Migration/source synchronisation repair

Live Supabase migration history establishes the M2.3 migration tail as:

- `20260825124619_m2_3_layer3_layer4_refresh_intelligence_foundation`;
- `20260825124942_m2_3_layer3_refresh_admin_read_write_contracts`;
- `20260825125714_m2_3_authenticated_rpc_invoker_hardening`;
- `20260825125742_m2_3_foreign_key_index_hardening`;
- `20260825133136_m2_3_refresh_scheduler_layer4_terminal_operations`;
- `20260825133749_m2_3_important_dates_source_precision`.

The last migration had been applied successfully but not source-controlled at the prior chat boundary. Its exact SQL was read back from `supabase_migrations.schema_migrations` and restored without semantic alteration at:

`supabase/migrations/20260825133749_m2_3_important_dates_source_precision.sql`.

Repair SHA:

`3858a8f9bf4ccfb7bb5aec89fbc239420718e47e`

Evidence at issue time:

- Frontend Build `32894556070` — PASS;
- deployed UAT `32894556145` — IN PROGRESS; therefore this SHA is not yet recorded as deployed-accepted by v2.71.

## Layer 3 runtime

Current deployed Edge Function:

- slug `layer3-interpret`;
- ID `33dd7564-990a-4b15-a884-35ac609c2258`;
- version 1;
- ACTIVE;
- `verify_jwt=true`;
- bundle SHA-256 `83dea5345d4cfd7d5970905285fff8680ed853f2dae5be8962d66e44672efad9`.

Current profile `openrouter-free-router-v1` remains enabled and PAUSED with validation `pending_credentials_and_benchmark`. The authorised management surface does not expose secret enumeration, therefore `OPENROUTER_API_KEY` presence is not verified.

**Provider benchmark gate: BLOCKED — CREDENTIAL REQUIRED / AUTHORISED SERVER SECRET NOT VERIFIED.**

No unpause is authorised until explicit benchmark PASS.

## Refresh intelligence

The cron job `coursefinder-m2-3-refresh-intelligence-tick` is ACTIVE on `*/15 * * * *` and calls only `security.refresh_scheduler_tick_impl(now(), 100)`.

Live policy state:

- policies: 10;
- enabled: 10;
- source-targeted: 10;
- unbounded: 0.

This is work selection only, not direct ingestion/model/human approval/Search publication authority.

## Important Dates

Source precision is now represented correctly in the database:

- exact sourced dates can use `starts_on` / `ends_on` without fabricated times;
- exact sourced timestamps retain `starts_at` / `ends_at`;
- `source_vague` retains source wording;
- refresh-capable dates require a bounded source/profile/entity target.

Permanent records include UQ `2026-11-30`, UQ `2027-02-22` and DFAT Round 22 `source_vague` as governed in CF-CHG-038.

The current browser still uses the older timestamp-oriented Important Date write path and must be updated to `important_date_upsert_v2` before M2.3 acceptance.

## Layer 4

All six terminal decision actions exist in the deployed contract and browser. The browser still requires full `layer4_review_context` integration, including filters/prioritisation, Evidence opening, L2 context, L3 profile/configured+returned model/result/validator/token/cost data, full history, edited final value and downstream refresh result.

No second Layer 4 canonical authority is authorised.

## Onboarding

No reusable Country/Provider/Course Onboarding workspace/table/function foundation existed at reconciliation. CF-CHG-037 remains **IN PROGRESS — IMPLEMENTATION REQUIRED**.

The required lifecycle is:

`Draft → Source Qualification → Adapter Assessment → Schema Assessment → L1 UAT → L2 UAT → L3 Ready → Operational Certification → Production Promotion Ready`.

Outcome semantics: READY / CONDITIONAL / BLOCKED / PAUSED / REJECTED.

## Advisor state

Latest Supabase Security Advisor: no M2.3 WARN/ERROR; INFO-only RLS/no-policy baseline on private schemas.

Latest Performance Advisor: INFO-only; no new M2.3 Layer 3/4/refresh unindexed-FK regression following migration `20260825125742`.

## Remaining M2.3 acceptance scope

M2.3 remains IN PROGRESS and must still prove or explicitly classify:

- production-grade Layer 1 source certification/limits/recovery;
- broad representative AU/NZ Layer 2 scale/Evidence/retry/economics;
- Firecrawl paid 5,000 pages/month budget enforcement;
- complete Layer 4 review UX and all-action UAT;
- Important Date precision UX and complete date contract UAT;
- Country/Provider/Course onboarding implementation and representative workflow UAT;
- QILT/PRISMS Course context and Scholarships;
- Scholarship Selection transparent scoring/coverage;
- role guides/quick tours matching deployed behaviour;
- private/anon/rank/secret leakage/Edge auth negative UAT;
- Layer 1/2/Evidence/Search/Publication regression;
- permanent deployed desktop/mobile/runtime UAT;
- real Layer 3 provider benchmark when an authorised server secret is verifiably available.

## Gate state

- M1 — CLOSED / PASS / FROZEN;
- M2.1 — CLOSED / PASS;
- M2.2 — CLOSED / PASS;
- M2.3 — **ACTIVE / IN PROGRESS**;
- CF-CHG-036 — IN PROGRESS;
- CF-CHG-037 — IN PROGRESS / IMPLEMENTATION REQUIRED;
- CF-CHG-038 — IN PROGRESS / provider benchmark BLOCKED on unverified server credential;
- M2.4 — NOT STARTED / BLOCKED BY M2.3 ACCEPTANCE;
- broad Publication — NOT AUTHORISED;
- Production cutover — NOT AUTHORISED.

## Exact next gate

Continue M2.3 only. First complete the deployed-UAT reconciliation for SHA `3858a8f9…`, then implement the missing Onboarding, Layer 4 context and Important Date precision UX/server contracts with automated rollback-only and permanent desktop/mobile UAT. Continue the remaining CF-CHG-036 production Data Operations scope. Update governance again before any M2.3 acceptance claim.

## Commercial/time boundary

Technical execution does not create billable-time entries. The maintained engagement-time record remains authoritative.