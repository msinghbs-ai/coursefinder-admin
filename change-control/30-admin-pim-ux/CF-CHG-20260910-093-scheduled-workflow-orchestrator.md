# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** REOPENED — CORE ACCEPTANCE BOUNDARY SATISFIED; RUNTIME/RELEASE FOLLOW-ON ACTIVE  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-14 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Visible accepted release:** v2.15.78  
**Current Pilot main:** `7cf5cc72296ca82e6e026606a61f449ede4ead45`

## Objective

Provide a governed Scheduled Tasks control plane for AU Course Facts while preserving CourseFinder authority boundaries: Layer 1 identity/regulatory authority, deterministic Evidence-preserving Layer 2, governed Layer 3 interpretation, Layer 4 human resolution, and separate Search/Publication admission.

## Accepted implementation path

- PR #72 merged the Preview-bound async Layer 2 authority contract.
- PR #80 repaired deployed-main acceptance triggering.
- PR #81 reconciled UQ acceptance to governed scope invariants.
- PR #82 merged Firecrawl -> ZenRows exhaustion/Layer 3+4 parking.
- PR #83 merged the bounded six-university scale-out.
- PR #84 merged the deterministic Layer 2 runner transport-budget recovery as Pilot main `7cf5cc72296ca82e6e026606a61f449ede4ead45`.

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

For the active governed university cohort the acquisition route remains:

1. Firecrawl — priority 10;
2. ZenRows — priority 20.

Direct HTTP, scrape.do and ScraperAPI are disabled for this cohort. Provider order, credential rules and identity confirmation are not changed by PR #84.

When the accepted unresolved-exhaustion contract applies, Layer 3 remains Evidence-gated, Layer 4 retains human authority and `canonical_mutation_authorised=false` remains explicit. No unresolved acquisition is silently promoted to canonical/Search/Publication truth.

## Deployed runtime identities

Preserve repository/runtime identities independently:

- repo `20260913113000_cf_093_firecrawl_zenrows_exhaustion_parking.sql`; runtime `20260913115513 cf_093_firecrawl_zenrows_exhaustion_parking`;
- repo `20260913121500_cf_093_large_university_batch_enablement.sql`; runtime `20260913121052 cf_093_large_university_batch_enablement`.

PR #84 is Edge/runtime code only and does not rewrite or add a database migration.

## UQ parking proof

Earlier UQ exhausted Preview token `b0eb7e77-d31a-4cb7-b187-8226445a1b7c` remains reconciled at:

- 42 blocked Layer 3 refresh requests;
- 42/42 with no fabricated Evidence;
- 42 pending Layer 4 `official_course_url` review items;
- 42/42 `canonical_mutation_authorised=false`.

## Six-university large-batch terminal discovery

PR #83 enabled RMIT, Curtin, Flinders, Griffith, La Trobe and QUT under the accepted Firecrawl -> ZenRows route.

Preview-bound discovery scope was **1,676 courses** and is now **1,676 / 1,676 distinct courses accounted for (100%)**. All six discovery bindings reached `handoff_started` with no discovery-job failure.

Terminal discovery outcome:

| University | Scope | Selected | Not found | Ambiguous | Identity mismatch |
|---|---:|---:|---:|---:|---:|
| RMIT | 27 | 0 | 26 | 1 | 0 |
| Curtin | 356 | 1 | 350 | 3 | 2 |
| Flinders | 461 | 10 | 237 | 38 | 176 |
| Griffith | 294 | 0 | 292 | 1 | 1 |
| La Trobe | 244 | 0 | 243 | 0 | 1 |
| QUT | 294 | 0 | 294 | 0 | 0 |

Exact-token provider baseline:

- Firecrawl attempts: 1,697;
- succeeded: 1,688;
- failed: 1;
- raw/html/screenshot Evidence refs: 1,696 / 1,696 / 1,696;
- ZenRows attempts: 0 for this discovery wave.

Monthly ledger at terminal discovery: Firecrawl 6,374 / 11,000 with 4,376 usable units remaining before the configured 250-unit stop reserve; ZenRows 188 recorded attempts/units. No silent paid fallback is authorised.

Flinders remains a strong identity-quality signal with 176 identity mismatches and 38 ambiguous outcomes. Matching rules must not be relaxed merely to improve yield.

## RMIT deterministic Layer 2 runtime recovery — PR #84

Discovery completed correctly, but RMIT deterministic Layer 2 batch `74b4b16f-20f0-4b61-a9e0-632d824f001a` stalled after handoff.

Observed recovery evidence:

1. Original dispatch request **6031** timed out at 120 seconds during DNS resolution before HTTP establishment.
2. Existing stale-item recovery and same-batch dispatch were used; no duplicate batch was created.
3. Recovery request **6166** reached `layer2-batch-runner` and processed five additional items, but exceeded the same 120-second pg_net caller ceiling before reconcile/self-continuation. State moved from 253 queued + 1 acquiring + 9 `layer3_required` to 248 queued + 1 acquiring + 14 `layer3_required`.
4. Root cause: batch snapshot had `batch_size=10` and no `route_mode`, so the runner attempted up to ten sequential deterministic acquisition/extraction items inside one 120-second transport invocation.
5. PR #84 exact head `428fcde277918061f5e8051eea3b869912eed883` introduced only a transport chunk bound: ordinary chunks max **4**; existing `scraper_first` cap remains **2**. Routing, retries, identity, Evidence, Layer 3 authority and Search/Publication semantics are unchanged.
6. Exact-head validation: Pilot Frontend Build `34781567078` PASS; Cloudflare preview PASS; Gitar APPROVED with no findings.
7. Pilot `layer2-batch-runner` version 10 deployed as the controlled recovery candidate.
8. Same RMIT batch request **6167** returned HTTP 200, `timed_out=false`, `wave_size=4`, `processed_now=4`, summary `running`, and self-created continuation **6168**.
9. Continuation **6168** also returned HTTP 200, `timed_out=false`, `wave_size=4`, `processed_now=4`, summary `running`, and self-created **6169**.
10. Two consecutive successful self-continuations prove the prior transport-budget stall mechanism is corrected. Further work must continue on this same batch without duplicate dispatch.

PR #84 then merged to Pilot main as `7cf5cc72296ca82e6e026606a61f449ede4ead45`.

## Separate deployed-UAT read-path blocker

Earlier targeted deployed UAT run `34756359424` failed because authenticated RPC `admin_read` intermittently returned HTTP 500 for operations including `dashboard` and `layer_status_summary`; anonymous access remained fail-closed.

Read-only authenticated profiling on 14 September found:

- `security.admin_dashboard_maturity()` execution about **107 ms**;
- `security.admin_layer_status_summary()` execution about **233 ms**.

Both functions execute successfully in isolation, so no persistent SQL-definition error is currently proven. Treat the earlier 500s as a separate runtime/read-path reliability regression, potentially load-related, until a clean deployed rerun proves the blocker resolved. Do not weaken UAT, ACLs, role checks or source validation.

## Runtime-operations follow-on

Pilot PR #79 remains open for browser-visible Runtime Health / efficiency work. Its read-only observability migrations remain valid, but the UI change still requires release-currentness/version reconciliation before merge. Visible accepted release remains v2.15.78 until that governed release gate changes.

## Remaining closure gates

CF-CHG-20260910-093 remains REOPENED for final runtime/governance/release reconciliation, not for website-specific scraper engineering.

1. Let the existing RMIT batch continue through self-generated continuations and reconcile it to terminal state; do not create a duplicate batch.
2. Continue collecting transport/throughput/Evidence/provider metrics from that batch.
3. Re-run/reconcile deployed UAT for `admin_read` read-path reliability; diagnose further only if the 500s reproduce.
4. Finish Admin PR #37 exact-head governance review and merge when clean.
5. Reconcile PR #79 release-currentness/version and exact-head validation before merge.
6. Reconcile REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS to the final merged/deployed boundary.
7. Close CF-093 when the remaining runtime/governance release follow-on is accepted.
8. M2.5 remains paused unless separately reopened.

## Rollback / recovery

- Never rewrite applied migration history.
- Database rollback is forward-only through a new migration.
- Never fabricate Evidence, identity mappings, provider credentials or canonical values to obtain a PASS.
- Never bypass Layer 3 Evidence gating or Layer 4 human authority.
- For this RMIT recovery, use existing stale recovery and the same batch only after confirming no active request is in flight.
- Scraper exhaustion is an escalation outcome, not permission for implicit canonical/Search/Publication mutation.

**Current outcome:** six-university discovery is terminal at 1,676/1,676 distinct courses. The RMIT deterministic Layer 2 transport stall was reproduced, root-caused and corrected by PR #84; two consecutive bounded self-continuation requests now pass. Remaining work is terminal RMIT reconciliation, deployed-UAT read-path reliability confirmation, and final governance/release closure.