# M2.4.5 NEXT CHAT

## Active baseline — 13 September 2026

- Milestone: **M2.4.5 — Pre-Production Hardening**.
- M2.5 remains paused; no Production Supabase project exists.
- Active Change Control: **CF-CHG-20260910-093 — REOPENED for final governance/runtime-ops release follow-on, not scraper perfection**.
- Visible accepted release remains **v2.15.78**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Current Pilot main: **`ac0e1ca3100397abfb5fa13e77d5be6c12d6d27d`**.
- PR #82 is merged: Firecrawl -> ZenRows bounded UQ discovery with Layer 3/4 parking for unresolved exhaustion.
- Pilot PR #79 remains open for browser-visible Runtime Health / efficiency and needs release-currentness/version reconciliation before merge.
- Clean Admin PR #37 remains the authoritative current-main governance reconciliation vehicle; superseded Admin #36 stays closed unmerged.

## Current UQ acquisition policy

For the UQ Course Facts discovery profile, the live provider order is now:

1. **Firecrawl** — enabled, priority 10.
2. **ZenRows** — enabled, priority 20.

Direct HTTP, scrape.do and ScraperAPI are disabled for this path at priorities 110/120/130.

Do not spend CF-093 work on perfecting each institution's gatekeeper/search mechanism. Provider-specific recovery requires a separate governed reason if ever needed.

## Exhaustion / Layer 3 / Layer 4 boundary

When a Preview-bound discovery course exhausts its bounded retry policy:

- courses already resolved by a selected post-activation discovery candidate are excluded;
- unresolved courses are parked as blocked Layer 3 refresh requests;
- parked Layer 3 requests have no fabricated Evidence and cannot bypass the Evidence gate;
- the same unresolved courses are surfaced as pending Layer 4 `official_course_url` review items;
- Layer 4 state explicitly records `canonical_mutation_authorised=false`;
- the async binding moves to `handoff_started`.

This is now the governed terminal/escalation outcome for scraper exhaustion. It is not a reason to hold the milestone open for website-specific scraper engineering.

## Runtime identities

Preserve all repo/runtime identities separately:

- runtime `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`; repo `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`;
- runtime `20260913102217 cf_093_scheduled_runtime_metrics_read`; repo `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`;
- runtime **`20260913115513 cf_093_firecrawl_zenrows_exhaustion_parking`**; repo **`20260913113000_cf_093_firecrawl_zenrows_exhaustion_parking.sql`**.

Never rewrite applied migration history.

## Live UQ parking proof

Preview token: `b0eb7e77-d31a-4cb7-b187-8226445a1b7c`.

The already-exhausted binding was reconciled after migration with a no-op terminal Job update; no new scrape run was generated.

Live result:

- binding: `handoff_started`;
- Layer 3 parked: **42**;
- Layer 3 blocked/no Evidence: **42**;
- Layer 4 pending: **42**;
- canonical mutation unauthorised: **42/42**.

## Validation

PR #82 final exact head `1eb6f159bc351d5b1b6234450625aa03d6b943c1`:

- Fresh Reconstruction `34755602814`: PASS;
- Targeted Recovery `34755602820`: PASS;
- Frontend Build `34755602823`: PASS;
- Cloudflare preview: PASS;
- Gitar: Approved after resolved-course guard finding was fixed and marked resolved.

Post-merge Pilot main `ac0e1ca3100397abfb5fa13e77d5be6c12d6d27d`:

- Frontend Build `34755718375`: **PASS**;
- Deployed UAT `34755717852`: **PASS**.

## Exact next gate

1. Finish Admin PR #37 exact-head Gitar review and merge only if clean.
2. Reconcile PR #79 release-currentness/version, rerun exact-head CI/Gitar and merge only if clean.
3. Update REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS when those material states change.
4. Close CF-093 after the remaining governance/runtime-ops release follow-on is accepted; do **not** reopen scraper-specific website perfection as a closure gate.
5. Keep M2.5 paused unless separately authorised.

## Authority/security boundary

Preserve Layer 1 identity/regulatory authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model gating, Layer 4 human authority, Search/Publication separation, rank/ACL/RLS/private-helper/service-role boundaries and immutable forward-only migration history. Unresolved acquisition is parked for governed review; it is never silently promoted into canonical truth.
