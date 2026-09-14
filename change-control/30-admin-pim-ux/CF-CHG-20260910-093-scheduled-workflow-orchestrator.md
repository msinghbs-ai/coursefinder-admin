# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** CLOSED / PASS — FINAL / DO NOT REOPEN FOR FUTURE COUNTRY ONBOARDING  
**Initiated:** 2026-09-10 AEST  
**Closed:** 2026-09-14 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted release:** v2.15.79 / package 0.1.6  
**Accepted Pilot main:** `7196c5d2fade8830ec371c663b008e8a47e01f74`  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`

## Final outcome

CF-093 is permanently closed as the implementation, recovery and acceptance vehicle for the governed Scheduled Tasks / Preview-bound Layer 2 orchestration work completed in September 2026.

The accepted implementation is incorporated into Pilot main and v2.15.79. The final deployed-UAT red status was recovered without weakening the test or authority contract: run `34819914624`, failed job `103900330312`, replacement job `103960817860` PASS, with `coursefinder/deployed-uat/targeted/chromium-desktop = success` on accepted main.

Six-university Preview-bound discovery reached terminal **1,676 / 1,676 distinct courses accounted for**. RMIT deterministic Layer 2 batch `74b4b16f-20f0-4b61-a9e0-632d824f001a` reached terminal `partial` at **263 / 263 processed**. Runtime controls, telemetry and recovery evidence have been retained.

## Accepted authority contract

The following remains part of the platform baseline and does not require CF-093 to stay open:

- same-actor Preview before consequential dispatch;
- exact Preview token/fingerprint/binding/identity provenance;
- deterministic Evidence-preserving Layer 2;
- bounded provider/policy/credential/budget qualification;
- no generic scheduler Layer 3 auto-approval;
- Layer 4 human authority for unresolved outcomes;
- no implicit Search/Publication consequence;
- rank/ACL/RLS/private-helper/service-role boundaries preserved;
- immutable forward-only migration history.

## Permanent closure rule

**CF-093 must not be reopened for Canada, another country, another provider cohort, or routine future onboarding.**

Future country/source onboarding must use a **new Change Control ID** scoped to that country/source/onboarding wave. That new record may reference CF-093 as historical architecture, implementation or acceptance evidence, but it must not change CF-093 back to ACTIVE/REOPENED.

Reopening CF-093 is reserved only for correcting the historical record itself (for example, evidence that the recorded September 2026 closure was factually wrong). A future defect in the same code path still receives a new Change Control and links back to CF-093.

## Operations after closure

Operational monitoring is continuing work, not a CF-093 closure gate. Track governed-run evidence through the active M2.4.5 metrics/operations model, including throughput, queue/execution latency, provider response and extraction p50/p95, retries, Evidence and field-resolution yield, provider budget, HTTP 429/5xx, terminal outcomes and recurrence of NZQA/`admin_read` runtime errors.

Dispatcher/provider settings remain evidence-led and must not be automatically changed merely because CF-093 is closed.

## Historical implementation evidence

- PR #72 merged Preview-bound async Layer 2 authority work.
- PRs #80–#89 completed acceptance/recovery/currentness corrections and operational hardening.
- PR #90 promoted v2.15.79 as the accepted recovery baseline.
- Applied migrations remain immutable and forward-only.
- v2.15.78 remains retained historical evidence but is superseded by v2.15.79 as the accepted recovery baseline.

## Rollback / recovery boundary

- Never rewrite applied migration history.
- Database rollback is forward-only through a new migration.
- Never fabricate Evidence, identity mappings, provider credentials or canonical values to obtain a PASS.
- Never bypass Layer 3 Evidence gating or Layer 4 human authority.
- Scraper exhaustion is an escalation outcome, not permission for implicit canonical/Search/Publication mutation.

**Final disposition:** CLOSED / PASS on 14 September 2026 AEST. Future Canada/country expansion, new source onboarding, operational tuning or defects must be governed under a new Change Control ID and may only reference CF-093 as closed historical evidence.