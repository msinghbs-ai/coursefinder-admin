# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** REOPENED — CORE ACCEPTANCE BOUNDARY SATISFIED; RUNTIME-OPS / RELEASE FOLLOW-ON ACTIVE  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-13 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Visible accepted release:** v2.15.78  
**Current Pilot main:** `ac0e1ca3100397abfb5fa13e77d5be6c12d6d27d`

## Objective

Provide a governed Scheduled Tasks control plane for AU Course Facts while preserving CourseFinder authority boundaries: Layer 1 identity/regulatory authority, deterministic Evidence-preserving Layer 2, governed Layer 3 interpretation, Layer 4 human resolution, and separate Search/Publication admission.

## Accepted implementation path

PR #72 merged the Preview-bound async Layer 2 authority contract. PR #80 repaired deployed-main acceptance triggering. PR #81 reconciled the UQ acceptance contract to governed scope invariants. PR #82 (`CF-093: Firecrawl/ZenRows discovery and Layer 3/4 parking`) merged to Pilot main as `ac0e1ca3100397abfb5fa13e77d5be6c12d6d27d`.

The accepted authority contract remains:

- same-actor Preview before consequential dispatch;
- exact Preview token/fingerprint/binding/identity provenance;
- bounded profile/policy/route/credential/budget qualification;
- deterministic Layer 2 and Evidence truth;
- no generic scheduler Layer 3 auto-approval;
- Layer 4 retains human authority for unresolved outcomes;
- no implicit Search/Publication consequence.

## Scraper / escalation boundary

CourseFinder does **not** require website-specific scraper perfection before work can progress.

For the governed UQ discovery path the active route is now:

1. Firecrawl — priority 10;
2. ZenRows — priority 20.

Direct HTTP, scrape.do and ScraperAPI are disabled for this UQ path and retained only as inactive historical configuration at priorities 110/120/130.

If a Preview-bound course remains unresolved after its governed retry limit:

- successful selected discovery candidates are excluded from escalation;
- unresolved courses are parked as blocked Layer 3 refresh work;
- Layer 3 remains Evidence-gated and is not called with fabricated Evidence;
- the same unresolved courses are surfaced as pending Layer 4 `official_course_url` review items;
- `canonical_mutation_authorised=false` is retained;
- the async binding moves from `active` to `handoff_started` so scraper exhaustion is not left as an active scheduler blocker.

This is the intended architecture boundary: acquisition failure becomes governed enrichment/human-review work, not an instruction to keep engineering around each institution's website mechanics.

## Deployed runtime identity and proof

Repository migration:

- `20260913113000_cf_093_firecrawl_zenrows_exhaustion_parking.sql`

Pilot runtime ledger:

- `20260913115513 cf_093_firecrawl_zenrows_exhaustion_parking`

Preserve both identities independently; do not rename, retimestamp or rewrite applied migration history.

Live UQ runtime proof after deployment:

- Firecrawl enabled priority 10;
- ZenRows enabled priority 20;
- Direct HTTP disabled priority 110;
- scrape.do disabled priority 120;
- ScraperAPI disabled priority 130;
- exhausted Preview token `b0eb7e77-d31a-4cb7-b187-8226445a1b7c` moved to `handoff_started` without another scraper run;
- **42** unresolved courses parked as blocked Layer 3 refresh requests;
- all **42** Layer 3 requests have `evidence_id = null` and therefore cannot bypass the Layer 3 Evidence gate;
- **42** pending Layer 4 review items created for `official_course_url`;
- all **42** explicitly retain `canonical_mutation_authorised=false`.

The migration was proven rollback-only before deployment against the existing exhausted UQ binding. Gitar identified one resolved-course escalation edge case; it was corrected by reusing the established selected-discovery-candidate rule. The review thread is resolved.

## Acceptance / validation evidence

Deployed-main workflow `34753552186` proved authenticated Preview -> Run Now initiation. UQ scope remained internally reconciled at 382 scoped = 251 queueable + 42 discovery + 89 fresh terminal-negative.

PR #82 final exact head `1eb6f159bc351d5b1b6234450625aa03d6b943c1` passed Fresh Reconstruction `34755602814`, Targeted Recovery `34755602820`, Frontend Build `34755602823`, Cloudflare preview and Gitar review.

Post-merge exact Pilot main `ac0e1ca3100397abfb5fa13e77d5be6c12d6d27d` passed:

- Frontend Build `34755718375`;
- Deployed UAT `34755717852`.

The earlier scraper failures remain useful bounded-acquisition evidence but are no longer a reason to keep CF-093 open for provider/site-specific engineering. They now terminate into the governed Layer 3/4 parking path.

## Runtime-operations follow-on

Pilot PR #79 remains open for browser-visible Runtime Health / efficiency work. Its already-deployed read-only observability migrations remain valid, but the UI change still requires release-currentness/version reconciliation before merge. Visible accepted release therefore remains v2.15.78 until that governed release gate changes.

## Remaining closure gates

CF-CHG-20260910-093 remains REOPENED only for final governance/release reconciliation, not for further website-specific scraper engineering.

1. Finish Admin PR #37 exact-head review and merge from current-main governance truth.
2. Reconcile PR #79 release-currentness/version and exact-head validation before its merge.
3. Reconcile REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT to the merged/deployed boundary.
4. Close CF-093 when the remaining governance/runtime-ops release follow-on is accepted; do **not** reopen scraper-specific perfection as a closure gate.
5. M2.5 remains paused unless separately reopened.

## Rollback / recovery

- Never rewrite applied migration history.
- Database rollback is forward-only through a new migration.
- Never fabricate Evidence, identity mappings, provider credentials or canonical values to obtain a PASS.
- Never bypass Layer 3 Evidence gating or Layer 4 human authority.
- Scraper exhaustion is an escalation outcome, not permission for implicit canonical/Search/Publication mutation.

**Current outcome:** Scheduled Tasks Preview/dispatch authority is proven; Firecrawl -> ZenRows is the bounded UQ scraper route; unresolved scraper outcomes park safely into Layer 3 and Layer 4; exact-main post-merge build and deployed UAT pass. Remaining work is governance/runtime-ops release reconciliation, not institution-specific scraper perfection.