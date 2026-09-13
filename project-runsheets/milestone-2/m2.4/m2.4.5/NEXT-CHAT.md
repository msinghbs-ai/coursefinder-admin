# M2.4.5 NEXT CHAT

## Active baseline — 14 September 2026 AEST

- Milestone: **M2.4.5 — Pre-Production Hardening**.
- M2.5 remains paused; no Production Supabase project exists.
- Active Change Control: **CF-CHG-20260910-093 — REOPENED for final governance/runtime-ops release follow-on**.
- Visible accepted release remains **v2.15.78**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Current Pilot main: **`cb31abe21ffe9a041cacd5f975a0e4af5248daa5`**.
- PR #82 merged Firecrawl -> ZenRows exhaustion/Layer 3+4 parking.
- PR #83 merged bounded six-university batch enablement.
- Pilot PR #79 remains open and mergeable for browser-visible Runtime Health / efficiency, but still needs release-currentness/version reconciliation before merge.
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

Current provider-attempt reconciliation for these exact Preview tokens:

- Firecrawl attempts: **1,697** total;
- succeeded: **1,688**;
- failed: **1**;
- running: **0**;
- raw/html/screenshot Evidence references: **1,696 / 1,696 / 1,696**;
- ZenRows attempts: **0** for this six-university wave.

The difference between 1,697 attempts and 1,688 `succeeded` + 1 `failed` is retained as provider-attempt state accounting; do not coerce unclassified/other statuses into success. Firecrawl handled the discovery wave without invoking ZenRows, but this does not remove the governed fallback.

## Provider budget / Evidence

Current monthly provider ledger:

- Firecrawl: **6,374 / 11,000** attempts/units recorded; **4,626 nominal units remain**, or **4,376 usable units before the configured 250-unit stop reserve**.
- ZenRows: **188** recorded monthly attempts/units.
- No silent paid fallback is authorised.

Evidence remains fail-closed and no canonical/Search/Publication authority changed. Successful HTTP acquisition is not equivalent to identity resolution.

Flinders remains the strongest identity-quality signal: **176 identity mismatches + 38 ambiguous + 10 selected**. Do not relax matching rules to improve yield.

## Deterministic Layer 2 handoff — MATERIAL BLOCKER

Discovery is complete, but the RMIT deterministic Layer 2 batch remains stalled and is the active runtime blocker.

RMIT batch: `74b4b16f-20f0-4b61-a9e0-632d824f001a`.

Current state remains:

- batch status: `running`;
- 263 total items;
- **253 queued**;
- **1 acquiring**;
- **9 `layer3_required`**;
- 0 completed/accepted;
- 0 failed/rejected;
- last item activity: **2026-09-13 12:18:28 UTC**.

No forward progress has occurred since the prior snapshot. This is not authority to redispatch, change retries/routes/credentials, weaken identity/Evidence controls, or mutate canonical/Search/Publication state. Treat it as a runtime-operations/dispatcher investigation gate.

Other deterministic Layer 2 results:

- Curtin: one selected URL -> partial batch with one `layer3_required` item.
- Flinders: ten selected URLs -> partial batch with nine `layer3_required` and one blocked item.
- Griffith, La Trobe and QUT: terminal-only discovery handoff; no synthetic Layer 2 work created.
- No new `official_course_url` Layer 4 review items were created after this six-university batch start; do not manufacture parking rows for already-accounted terminal-negative outcomes.

## Material CI/runtime finding — deployed UAT failure

Current Pilot main `cb31abe21ffe9a041cacd5f975a0e4af5248daa5` has a failed status for `coursefinder/deployed-uat/targeted/chromium-desktop` from workflow run **34756359424**.

The Worker was reachable and authentication/preflight succeeded. The targeted Layer 1 suite failure was caused by repeated **HTTP 500** responses from Pilot Supabase RPC `admin_read`, specifically operations including `layer_status_summary` and `dashboard`.

Observed test outcome:

- NZQA authority/count validation: failed after retry because `admin_read` returned 500;
- CRICOS authority/count validation: flaky, passed retry after earlier 500s;
- QILT/PRISMS runnable-source validation: flaky, passed retry after earlier 500s;
- anonymous access contract passed;
- overall desktop targeted UAT: **FAIL**.

Treat this as a separate runtime/read-path reliability blocker until reconciled. It is not evidence to weaken UAT assertions, ACLs, role boundaries or source validation.

## Current acquisition policy

For this cohort:

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

Never rewrite applied migration history.

## Exact next gate

1. Diagnose the **stalled RMIT deterministic Layer 2 dispatcher/batch** from runtime truth; do not create a duplicate dispatch.
2. Diagnose Pilot `admin_read` 500s for `dashboard` / `layer_status_summary` using read-only evidence first and preserve fail-closed UAT.
3. Preserve the 1,676-course terminal discovery metrics as the current scale baseline.
4. Keep Firecrawl/ZenRows budget and stop reserve enforced.
5. Finish Admin PR #37 exact-head review and merge only if clean.
6. Reconcile PR #79 release-currentness/version and exact-head validation before merge.
7. Reconcile REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS when either the RMIT runtime blocker or deployed-UAT read-path blocker materially changes.
8. Keep M2.5 paused unless separately authorised.

## Authority/security boundary

Preserve Layer 1 identity/regulatory authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model gating, Layer 4 human authority, Search/Publication separation, rank/ACL/RLS/private-helper/service-role boundaries and immutable forward-only migration history. Unresolved acquisition is never silently promoted into canonical truth.
