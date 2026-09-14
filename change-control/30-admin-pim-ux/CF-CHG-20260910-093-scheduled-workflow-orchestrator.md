# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** REOPENED — IMPLEMENTATION/RELEASE ACCEPTED; FINAL GOVERNANCE + OPERATIONS CLOSURE ACTIVE  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-14 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Visible accepted/recovery release:** v2.15.79 / package 0.1.6  
**Current Pilot main:** `7196c5d2fade8830ec371c663b008e8a47e01f74`  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`

## Objective

Provide a governed Scheduled Tasks control plane for AU Course Facts and related operational workflows while preserving CourseFinder authority boundaries: Layer 1 identity/regulatory authority, deterministic Evidence-preserving Layer 2, governed Layer 3 interpretation, Layer 4 human resolution, separate Search/Publication admission, rank/ACL/RLS boundaries and immutable forward-only migration history.

## Accepted implementation path

The implementation advanced beyond the earlier PR #72 candidate state and is now incorporated into accepted Pilot main.

Material path retained as evidence:

- PR #72 merged the Preview-bound async Layer 2 authority contract.
- PR #80 repaired deployed-main acceptance triggering.
- PR #81 reconciled UQ acceptance to governed scope invariants.
- PR #82 merged Firecrawl -> ZenRows exhaustion/Layer 3+4 parking.
- PR #83 merged the bounded six-university scale-out.
- PR #84 bounded deterministic Layer 2 transport waves to fit the transport budget.
- PR #85 added Administration → Scraper Config dispatcher tuning and comparable runtime metrics while retaining existing authority/security boundaries.
- PRs #86–#89 corrected stale deployed-UAT/release-currentness contracts without weakening application/runtime authority.
- PR #90 promoted **v2.15.79** to the accepted recovery baseline.

The accepted authority contract remains:

- same-actor Preview before consequential dispatch;
- exact Preview token/fingerprint/binding/identity provenance;
- bounded profile/policy/route/credential/budget qualification;
- deterministic Layer 2 and Evidence truth;
- no generic scheduler Layer 3 auto-approval;
- Layer 4 retains human authority for unresolved outcomes;
- no implicit Search/Publication consequence;
- no fabricated source/profile/route/Evidence/identity values to obtain acceptance.

## Runtime / scale evidence

Six-university Preview-bound discovery is terminal at **1,676 / 1,676 distinct courses accounted for**. Firecrawl completed the governed discovery wave; ZenRows fallback was not required for that wave. Identity-quality outcomes remain evidence and must not be relaxed merely to improve yield.

RMIT deterministic Layer 2 batch `74b4b16f-20f0-4b61-a9e0-632d824f001a` reached terminal `partial` at **263 / 263 processed**. The transport-budget recovery preserved the same batch and introduced an ordinary wave cap of 4 while retaining scraper-first cap 2.

Accepted dispatcher/runtime controls include:

- ordinary transport wave cap **4**;
- scraper-first cap **2**;
- pg_net request ceiling **120 seconds**;
- rank-4 sanitized metrics read; lower-rank/anonymous access denied;
- rank-5+ governed tuning only;
- mandatory governance reason at control boundary;
- audit trail records actor, actual changed fields and before/after policy;
- in-flight `policy_snapshot` is immutable;
- provider credentials/routing remain separate controls;
- monitoring does not auto-change dispatcher/provider settings.

Comparable RMIT telemetry recorded before release acceptance showed active throughput about **2.68 items/min**, Firecrawl current-profile average attempt about **14.64 s**, extraction about **1.94 s**, and zero HTTP 429s. Current evidence identifies provider/source latency as the primary efficiency constraint; no concurrency increase is justified without newer comparable evidence.

## Release / recovery state

Pilot PR #90 completed the governed release lifecycle for **v2.15.79 / package 0.1.6**. Current Pilot main is `7196c5d2fade8830ec371c663b008e8a47e01f74`.

v2.15.79 is now the accepted/recovery release. v2.15.78 remains immutable retained history but is no longer the active recovery authority.

Release identity is governed by the maintained release-version-control model and must not be duplicated or manually promoted outside that contract.

## Deployed UAT recovery — 14 September 2026

Targeted deployed UAT run **`34819914624`** on current main initially failed because the real NZQA authority/count validation received HTTP 500 from `layer1-operations-control`. CRICOS and the remaining Layer 1 deployed checks passed.

The failed job `103900330312` was re-run as job `103960817860` without weakening the test, ACL or authority contract. The replacement attempt completed **SUCCESS** and current commit status is:

- `coursefinder/deployed-uat/targeted/chromium-desktop = success`

The initial NZQA HTTP 500 remains retained as transient runtime evidence and must be monitored for recurrence; it is not erased from recovery history.

## Security / authority boundaries retained

- Layer 1 identity/source authority unchanged.
- Layer 2 deterministic Evidence truth remains fail-closed.
- Layer 3 remains separately Evidence/profile/model/revalidation governed.
- Layer 4 human authority remains separate.
- Search/Publication remains separately governed.
- Rank/ACL/RLS/private-helper/service-role boundaries remain unchanged.
- Applied migrations remain immutable and forward-only.
- Release recovery must never be used to rewrite migration history.
- No direct ad-hoc SQL/RPC execution substitutes for governed operator acceptance.

## Remaining closure gates

CF-CHG-20260910-093 remains REOPENED only for final governance/operations reconciliation. Do not infer CLOSED/PASS solely from the v2.15.79 promotion.

1. Reconcile Admin PR #37 and authoritative continuity to Pilot main `7196c5d...`, accepted v2.15.79 and deployed UAT recovery run `34819914624` attempt 2 PASS.
2. Reconcile `REGISTER.md`, `RUNSHEET.md`, `CURRENT-STATE.md`, `FOLLOW-UPS.md`, `NEXT-CHAT.md` and `SYSTEM-METRICS.md` where stale.
3. Continue evidence-led monitoring on real governed workloads: throughput, queue wait/execution, provider response p50/p95, extraction p50/p95, retries, Evidence counts, field-resolution yield, provider budget, HTTP 429/5xx, terminal outcomes and recurrence of `admin_read`/NZQA 5xx.
4. Hold dispatcher/provider settings steady until another legitimately comparable governed run supports a change.
5. Close CF-093 only after governance/continuity state matches accepted implementation/runtime truth and no unresolved mandatory gate remains.
6. M2.5 remains paused unless separately authorised.

## Rollback / recovery

- Never rewrite applied migration history.
- Database rollback is forward-only through a new migration.
- Never fabricate Evidence, identity mappings, provider credentials or canonical values to obtain a PASS.
- Never bypass Layer 3 Evidence gating or Layer 4 human authority.
- Scraper exhaustion is an escalation outcome, not permission for implicit canonical/Search/Publication mutation.

**Current outcome:** accepted Pilot release is v2.15.79 at `7196c5d...`; the immediate deployed-UAT red status has been recovered to green on run `34819914624`. Remaining work is authoritative governance/continuity closure plus ongoing evidence-led operational monitoring.
