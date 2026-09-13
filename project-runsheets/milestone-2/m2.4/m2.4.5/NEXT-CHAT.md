# M2.4.5 NEXT CHAT

## Active baseline — 14 September 2026 AEST

- Milestone: **M2.4.5 — Pre-Production Hardening**.
- M2.5 remains paused; no Production Supabase project exists.
- Active Change Control: **CF-CHG-20260910-093 — REOPENED for final governance/runtime-ops release follow-on**.
- Visible accepted release remains **v2.15.78**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Current Pilot main: **`7cf5cc72296ca82e6e026606a61f449ede4ead45`** after merged PR #84.
- PR #82 merged Firecrawl -> ZenRows exhaustion/Layer 3+4 parking.
- PR #83 merged bounded six-university batch enablement.
- PR #84 merged the Layer 2 runner transport-budget recovery.
- Pilot PR #79 remains open for browser-visible Runtime Health / efficiency and still needs release-currentness/version reconciliation before merge.
- Admin PR #37 remains the authoritative governance reconciliation vehicle.

## Six-university discovery — TERMINAL

Cohort: RMIT, Curtin, Flinders, Griffith, La Trobe and QUT.

All six Preview-bound discovery bindings are `handoff_started` with **1,676 / 1,676 distinct discovery courses accounted for (100%)** and no discovery-job failures.

| University | Scope | Selected | Not found | Ambiguous | Identity mismatch | Discovery jobs | Avg queue sec | Avg execution sec |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| RMIT | 27 | 0 | 26 | 1 | 0 | 3 | 0.37 | 50.72 |
| Curtin | 356 | 1 | 350 | 3 | 2 | 21 | 0.22 | 62.09 |
| Flinders | 461 | 10 | 237 | 38 | 176 | 47 | 0.16 | 62.77 |
| Griffith | 294 | 0 | 292 | 1 | 1 | 25 | 0.19 | 61.09 |
| La Trobe | 244 | 0 | 243 | 0 | 1 | 19 | 0.22 | 61.50 |
| QUT | 294 | 0 | 294 | 0 | 0 | 22 | 0.18 | 61.20 |

Flinders worker-result totals include one repeated continuation event; the acceptance denominator is the 461 distinct courses.

Provider-attempt baseline for the exact Preview tokens:

- Firecrawl attempts: **1,697** total;
- succeeded: **1,688**;
- failed: **1**;
- raw/html/screenshot Evidence references: **1,696 / 1,696 / 1,696**;
- ZenRows attempts: **0** for this six-university discovery wave.

Monthly provider ledger at terminal discovery:

- Firecrawl: **6,374 / 11,000** units recorded; **4,376 usable units remained before the configured 250-unit stop reserve**.
- ZenRows: **188** recorded monthly attempts/units.
- No silent paid fallback is authorised.

Flinders remains the strongest identity-quality signal: **176 identity mismatches + 38 ambiguous + 10 selected**. Do not relax matching rules to improve yield.

## RMIT deterministic Layer 2 recovery — ROOT CAUSE FIXED / CONTINUATION PROVEN

RMIT batch: `74b4b16f-20f0-4b61-a9e0-632d824f001a`.

The hourly metrics monitor correctly identified that discovery was terminal but the deterministic Layer 2 handoff had stalled at **253 queued + 1 acquiring + 9 `layer3_required`**.

Recovery evidence:

1. Original batch dispatch request **6031** timed out at the pg_net 120-second ceiling during DNS resolution and never established the HTTP request.
2. Existing stale-item recovery plus same-batch dispatch was used; no duplicate batch was created.
3. Recovery request **6166** reached the Edge runner, processed five more items, but then hit the same 120-second transport ceiling during HTTP request/response before reconciliation/continuation. Runtime moved to **248 queued + 1 acquiring + 14 `layer3_required`**.
4. Root cause: batch policy snapshot had `batch_size=10` and no `route_mode`; the runner therefore attempted up to ten sequential deterministic acquisitions/extractions inside one pg_net request. At observed per-item latency that could exceed the 120-second caller budget before self-continuation was scheduled.
5. Pilot PR #84 exact head `428fcde277918061f5e8051eea3b869912eed883` changed only the runner transport chunk and its existing UAT source contract: ordinary chunks max **4**, `scraper_first` remains max **2**. Provider routing, retries, identity, Evidence, Layer 3 authority and Search/Publication boundaries are unchanged.
6. PR #84 validation: Pilot Frontend Build `34781567078` PASS; Cloudflare exact-head preview PASS; Gitar exact-head review APPROVED with no findings.
7. Pilot `layer2-batch-runner` version **10** was deployed as the controlled recovery candidate.
8. Same RMIT batch was recovered and dispatched once as request **6167**. It returned **HTTP 200**, `timed_out=false`, `wave_size=4`, `processed_now=4`, summary `running`, and created its own continuation request **6168**.
9. This proves the defect boundary that previously failed: a bounded wave now completes within the pg_net transport budget and reaches deterministic reconcile/self-continuation.
10. PR #84 merged to Pilot main as **`7cf5cc72296ca82e6e026606a61f449ede4ead45`**.

Do not create another RMIT batch. Continue observing the existing batch/continuation chain. If a stale item reappears, use the existing stale recovery and same-batch dispatch contract only after confirming no active request is in flight.

Other deterministic Layer 2 results remain:

- Curtin: one selected URL -> partial batch with one `layer3_required` item.
- Flinders: ten selected URLs -> partial batch with nine `layer3_required` and one blocked item.
- Griffith, La Trobe and QUT: terminal-only discovery handoff; no synthetic Layer 2 work created.

## Separate runtime blocker — deployed UAT `admin_read` 500s

Pilot main had failed targeted deployed UAT workflow **34756359424** before PR #84. Worker reachability and authentication/preflight succeeded, but Supabase RPC `admin_read` intermittently returned HTTP 500 for operations including `layer_status_summary` and `dashboard`.

Observed acceptance result:

- NZQA authority/count: failed after retry because `admin_read` returned 500;
- CRICOS authority/count: flaky, passed retry after earlier 500s;
- QILT/PRISMS runnable-source validation: flaky, passed retry after earlier 500s;
- anonymous access contract passed;
- overall targeted desktop UAT: FAIL.

Treat this as a separate read-path reliability issue. Diagnose with read-only evidence first. Do not weaken UAT assertions, ACLs, rank boundaries or source-validation rules.

## Current acquisition policy

For the CF-093 university cohort:

1. Firecrawl — enabled, priority 10.
2. ZenRows — enabled, priority 20.
3. Direct HTTP — disabled.
4. scrape.do — disabled.
5. ScraperAPI — disabled.

Preserve these governed routes. Do not tune provider order merely to improve observed metrics.

## Runtime identities

Preserve repo/runtime identities separately:

- runtime `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`; repo `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`;
- runtime `20260913102217 cf_093_scheduled_runtime_metrics_read`; repo `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`;
- runtime `20260913115513 cf_093_firecrawl_zenrows_exhaustion_parking`; repo `20260913113000_cf_093_firecrawl_zenrows_exhaustion_parking.sql`;
- runtime `20260913121052 cf_093_large_university_batch_enablement`; repo `20260913121500_cf_093_large_university_batch_enablement.sql`.

PR #84 is Edge/runtime code only; it did not add or rewrite a database migration.

## Exact next gate

1. Verify RMIT continuation **6168 and successors** continue completing as HTTP 200 with bounded `wave_size=4` and that the existing batch makes sustained forward progress without duplicate dispatch.
2. Run/reconcile post-merge Pilot checks for main `7cf5cc72296ca82e6e026606a61f449ede4ead45`.
3. Diagnose the separate `admin_read` HTTP 500 reliability issue for `dashboard` / `layer_status_summary` using read-only evidence first and preserve fail-closed UAT.
4. Preserve the **1,676-course terminal discovery baseline** and continue collecting throughput/provider/Evidence metrics.
5. Finish Admin PR #37 exact-head review and merge only when current governance truth is clean.
6. Reconcile PR #79 release-currentness/version and exact-head validation before merge.
7. Reconcile REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS when the RMIT recovery reaches a material terminal state or the `admin_read` blocker changes.
8. Keep M2.5 paused unless separately authorised.

## Authority/security boundary

Preserve Layer 1 identity/regulatory authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model gating, Layer 4 human authority, Search/Publication separation, rank/ACL/RLS/private-helper/service-role boundaries and immutable forward-only migration history. Unresolved acquisition is never silently promoted into canonical truth.
