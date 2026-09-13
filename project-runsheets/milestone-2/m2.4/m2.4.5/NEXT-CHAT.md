# M2.4.5 NEXT CHAT

## Active baseline — 13 September 2026

- Milestone: **M2.4.5 — Pre-Production Hardening**.
- M2.5 remains paused; no Production Supabase project exists.
- Active Change Control: **CF-CHG-20260910-093 — REOPENED for final governance/runtime-ops release follow-on, not scraper perfection**.
- Visible accepted release remains **v2.15.78**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Current Pilot main: **`cb31abe21ffe9a041cacd5f975a0e4af5248daa5`**.
- PR #82 merged the Firecrawl -> ZenRows exhaustion/Layer 3+4 parking boundary.
- PR #83 merged the bounded six-university batch enablement.
- Pilot PR #79 remains open for browser-visible Runtime Health / efficiency and needs release-currentness/version reconciliation before merge.
- Clean Admin PR #37 remains the authoritative current-main governance reconciliation vehicle; superseded Admin #36 stays closed unmerged.

## Current acquisition policy

For the active CF-093 university batch cohort the live provider order is:

1. **Firecrawl** — enabled, priority 10.
2. **ZenRows** — enabled, priority 20.

Direct HTTP, scrape.do and ScraperAPI are disabled for this cohort at priorities 110/120/130.

Do not spend CF-093 work on perfecting each institution's gatekeeper/search mechanism. Exhausted unresolved work follows Layer 3/4 escalation.

## Exhaustion / Layer 3 / Layer 4 boundary

When a Preview-bound discovery course exhausts its bounded retry policy:

- courses already resolved by a selected post-activation discovery candidate are excluded;
- unresolved courses are parked as blocked Layer 3 refresh requests;
- parked Layer 3 requests have no fabricated Evidence and cannot bypass the Evidence gate;
- the same unresolved courses are surfaced as pending Layer 4 `official_course_url` review items;
- Layer 4 state explicitly records `canonical_mutation_authorised=false`;
- the async binding moves to `handoff_started`.

This is the governed terminal/escalation outcome for scraper exhaustion. It is not a reason to hold the milestone open for website-specific scraper engineering.

## Runtime identities

Preserve all repo/runtime identities separately:

- runtime `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`; repo `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`;
- runtime `20260913102217 cf_093_scheduled_runtime_metrics_read`; repo `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`;
- runtime `20260913115513 cf_093_firecrawl_zenrows_exhaustion_parking`; repo `20260913113000_cf_093_firecrawl_zenrows_exhaustion_parking.sql`;
- runtime **`20260913121052 cf_093_large_university_batch_enablement`**; repo **`20260913121500_cf_093_large_university_batch_enablement.sql`**.

Never rewrite applied migration history.

## Live six-university batch — ACTIVE

PR #83 merged as `cb31abe21ffe9a041cacd5f975a0e4af5248daa5`. Exact-head Fresh Reconstruction, Targeted Recovery, Frontend Build and Cloudflare preview passed before merge. Rollback-only proof established all six scopes were executable before runtime promotion.

The governed acquisition-only wave was then dispatched using separate exact Preview tokens:

| University | Preview token | Discovery scope | Dispatch request |
|---|---|---:|---:|
| RMIT | `7d445b99-b545-4987-99f2-df5c1bbc2211` | 27 | 6015 |
| Curtin | `c2e70f76-c5ac-45f7-b99b-c8af38fa3ae1` | 356 | 6016 |
| Flinders | `40d7e691-4d49-4448-aabd-c4238c690db6` | 461 | 6017 |
| Griffith | `3de32f03-e5d9-4b26-a7ee-61f7241eefad` | 294 | 6018 |
| La Trobe | `8823638e-df65-4e7e-9518-2190130bf203` | 244 | 6020 |
| QUT | `cb84a25c-a52d-420b-91bd-071d034444f7` | 294 | 6021 |

Total Preview-bound discovery scope: **1,676 courses**.

Initial runtime evidence at launch:

- RMIT first worker chunk completed **5 processed / 0 failed**;
- Curtin, Flinders, Griffith and RMIT continuation had active discovery workers;
- La Trobe and QUT bindings were active and queued behind bounded concurrency;
- first measured provider-attempt sample: **50 Firecrawl attempts / 50 HTTP-successful attempts**;
- no scrape.do/ScraperAPI/Direct HTTP acquisition is authorised for this cohort.

Do not dispatch duplicate runs while these Preview bindings are active. Let bounded continuation/dedupe operate. Reconcile terminal outcomes by token; unresolved exhaustion should park into Layer 3/4 automatically.

## Live UQ parking proof

Earlier UQ Preview token: `b0eb7e77-d31a-4cb7-b187-8226445a1b7c`.

Live result remains:

- binding: `handoff_started`;
- Layer 3 parked: **42**;
- Layer 3 blocked/no Evidence: **42**;
- Layer 4 pending: **42**;
- canonical mutation unauthorised: **42/42**.

## Exact next gate

1. Reconcile the six active Preview tokens to terminal Jobs/Evidence/handoff/Layer 3+4 outcomes. Do not create duplicate dispatches while bindings remain active.
2. Record Firecrawl/ZenRows usage and throughput for the larger wave; keep vendor budget/reserve enforced.
3. Finish Admin PR #37 exact-head review and merge only if clean.
4. Reconcile PR #79 release-currentness/version, rerun exact-head CI/Gitar and merge only if clean.
5. Update REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS when these material states change.
6. Close CF-093 after the remaining governance/runtime-ops release follow-on is accepted; do not reopen scraper-specific website perfection as a closure gate.
7. Keep M2.5 paused unless separately authorised.

## Authority/security boundary

Preserve Layer 1 identity/regulatory authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model gating, Layer 4 human authority, Search/Publication separation, rank/ACL/RLS/private-helper/service-role boundaries and immutable forward-only migration history. Unresolved acquisition is parked for governed review; it is never silently promoted into canonical truth.
