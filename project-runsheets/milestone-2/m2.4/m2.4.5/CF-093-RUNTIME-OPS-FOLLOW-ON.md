# CF-CHG-20260910-093 — Runtime Operations Follow-on

**Status:** ACTIVE FOLLOW-ON / SCRAPER ESCALATION BOUNDARY DEPLOYED  
**Updated:** 13 September 2026 AEST

## Current implementation

- PR #72 merged Preview-bound async Layer 2 discovery.
- PR #80 merged deployed-main acceptance-trigger recovery.
- PR #81 merged UQ acceptance-count/invariant reconciliation.
- PR #82 merged as Pilot main `ac0e1ca3100397abfb5fa13e77d5be6c12d6d27d`, implementing Firecrawl -> ZenRows bounded discovery and Layer 3/4 parking for unresolved exhaustion.
- PR #83 merged as Pilot main `cb31abe21ffe9a041cacd5f975a0e4af5248daa5`, enabling the bounded six-university AU batch cohort.
- PR #79 remains the separate browser-visible Runtime Health / efficiency candidate and still requires release-currentness/version reconciliation before merge.
- Visible accepted release remains v2.15.78.

## Deployed observability/runtime migrations

1. Runtime ledger `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`; repository source `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`.
2. Runtime ledger `20260913102217 cf_093_scheduled_runtime_metrics_read`; repository source `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`.
3. Runtime ledger `20260913115513 cf_093_firecrawl_zenrows_exhaustion_parking`; repository source `20260913113000_cf_093_firecrawl_zenrows_exhaustion_parking.sql`.
4. Runtime ledger `20260913121052 cf_093_large_university_batch_enablement`; repository source `20260913121500_cf_093_large_university_batch_enablement.sql`.

Preserve runtime-ledger and repository identities separately. Applied migration history is immutable.

## Runtime Health / telemetry

The terminal timestamp correction is proven in genuine UQ consequential traffic. Four bounded discovery jobs received real `completed_at` timestamps and measurable execution durations. Exact-token reconciliation showed all 42 bound discovery courses received exactly three governed attempts.

The rank-4 `jobs_runtime` read remains fail-closed for lower ranks/anon/public and does not expose raw payload/result/error text, URLs, Storage paths or secrets. The bounded recent-50 deployed wrapper proof measured about 21.4 ms.

## Six-university batch metrics

Active cohort: RMIT, Curtin, Flinders, Griffith, La Trobe and QUT. Total Preview-bound discovery scope: **1,676 courses**.

Prior active-wave snapshot:

| University | Discovery scope | Jobs | Terminal jobs | Running jobs | Processed | Failed | Avg queue sec | Avg terminal execution sec |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| RMIT | 27 | 3 | 3 | 0 | 27 | 0 | 0.37 | 50.72 |
| Curtin | 356 | 5 | 4 | 1 | 64 | 0 | 0.31 | 62.03 |
| Flinders | 461 | 5 | 4 | 1 | 39 | 0 | 0.22 | 63.06 |
| Griffith | 294 | 5 | 4 | 1 | 49 | 0 | 0.21 | 61.20 |
| La Trobe | 244 | 4 | 3 | 1 | 39 | 0 | 0.16 | 63.94 |
| QUT | 294 | 4 | 3 | 1 | 41 | 0 | 0.16 | 61.86 |

At that snapshot **259 course items had been processed with 0 job-level failures**.

### Terminal discovery reconciliation — 13 September 2026 AEST

All six Preview-bound discovery bindings have now transitioned to `handoff_started`; there are **no running discovery Jobs**.

| University | Scope | Discovery jobs | Processed | Job failed | Avg queue sec | Avg execution sec | Selected | Not found | Ambiguous | Identity mismatch | Firecrawl | ZenRows |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| RMIT | 27 | 3 | 27 | 0 | 0.37 | 50.72 | 0 | 26 | 1 | 0 | 37 | 0 |
| Curtin | 356 | 21 | 356 | 0 | 0.22 | 62.09 | 1 | 350 | 3 | 2 | 358 | 0 |
| Flinders | 461 | 47 | 462* | 0 | 0.16 | 62.77 | 10 | 237 | 38 | 176 | 491 | 0 |
| Griffith | 294 | 25 | 294 | 0 | 0.19 | 61.09 | 0 | 292 | 1 | 1 | 294 | 0 |
| La Trobe | 244 | 19 | 244 | 0 | 0.22 | 61.50 | 0 | 243 | 0 | 1 | 244 | 0 |
| QUT | 294 | 22 | 294 | 0 | 0.18 | 61.20 | 0 | 294 | 0 | 0 | 294 | 0 |

`*` Flinders worker-result processed totals sum to 462 against a 461-course scope because continuation accounting includes one repeated processing event; distinct candidate-course reconciliation remains exactly 461. Treat the distinct course scope, not the summed worker counter, as the acceptance denominator.

Terminal distinct-course reconciliation is therefore **1,676 / 1,676 discovery courses accounted for (100%)**. There are no discovery-job failures. One Firecrawl provider attempt on Flinders is recorded failed while the bounded continuation still completed the full distinct-course scope; no identity or Evidence rule was weakened to compensate.

Evidence/provider snapshot at terminal discovery:

| University | Successful provider attempts | Failed provider attempts | Raw Evidence | HTML Evidence | Screenshot Evidence |
|---|---:|---:|---:|---:|---:|
| RMIT | 37 | 0 | 37 | 27 | 37 |
| Curtin | 358 | 0 | 358 | 357 | 358 |
| Flinders | 482 | 1 | 490 | 480 | 490 |
| Griffith | 294 | 0 | 294 | 294 | 294 |
| La Trobe | 244 | 0 | 244 | 244 | 244 |
| QUT | 294 | 0 | 294 | 294 | 294 |

Key terminal observations:

- **Firecrawl completed the entire six-university discovery wave; ZenRows fallback was never invoked.** This is a tooling result, not authority to remove the governed fallback.
- Discovery queue delay remained negligible at about **0.16–0.37 seconds average**; average completed chunk execution remained about **51–63 seconds**. Site/acquisition processing remains the throughput limiter rather than queue contention.
- The dominant outcome is governed terminal-negative discovery, especially `current_page_not_found`; successful HTTP acquisition must not be interpreted as identity resolution.
- **Flinders is the strongest identity-quality signal:** 176 identity mismatches and 38 ambiguous outcomes, while still producing 10 selected URLs. This profile should be treated as a data/source-pattern quality candidate for later analysis, not relaxed to improve yield.
- Curtin produced one selected discovery URL; Griffith, La Trobe, QUT and this RMIT retry produced no selected discovery URL.
- No canonical mutation or Search/Publication admission is authorised by the handoff records.

### Deterministic Layer 2 handoff state

Discovery completion does not mean all deterministic Layer 2 work is terminal.

- **RMIT:** 263 queueable Layer 2 targets handed off in batch `74b4b16f-20f0-4b61-a9e0-632d824f001a`; batch remains `running` with 253 items still queued/running at this sample. Do not duplicate dispatch.
- **Curtin:** one selected discovery URL handed to deterministic Layer 2 batch `7f73a6fa-7c35-4250-b73d-03b26bf3df52`; batch completed `partial`, processed 1, resolved L2 0, escalated L3 1.
- **Flinders:** ten selected discovery URLs handed to deterministic Layer 2 batch `a27f7ab9-3da3-46af-b680-64f27ef507d8`; batch completed `partial`, processed 10, resolved L2 0, escalated L3 9, blocked 1.
- **Griffith, La Trobe and QUT:** terminal-only handoff; all discovery courses were governed terminal negatives, so no deterministic Layer 2 batch was manufactured.

The generic Layer 3/4 exhaustion-parking tables show no new parking rows for these six discovery bindings at this point. That is consistent with their terminal-negative/selected handoff accounting rather than the earlier UQ transient-exhaustion case. Do not manufacture parking rows where the accepted scheduler contract has already produced a terminal-negative outcome.

### Provider budget / headroom

Current monthly provider ledger:

- Firecrawl: **6,374 / 11,000** vendor units consumed this month; **4,626 nominal units remain**, or **4,376 usable units before the configured 250-unit stop reserve**.
- ZenRows: **188** recorded monthly attempts/units; free-tier cash outlay basis is recorded, but no known hard free-tier limit is configured.
- No silent paid fallback is authorised.

The six-university wave materially increased Firecrawl use from the earlier 4,656-unit baseline, but remains inside the governed reserve boundary.

## Accepted acquisition boundary

Website-specific scraper perfection is no longer an acceptance objective for this path.

Current active cohort route:

| Priority | Provider | Enabled |
|---:|---|---|
| 10 | Firecrawl | Yes |
| 20 | ZenRows | Yes |
| 110 | Direct HTTP | No |
| 120 | scrape.do | No |
| 130 | ScraperAPI | No |

The route retains existing governed fallback semantics; no 401 bypass or credential substitution was introduced.

When bounded Preview-bound discovery is exhausted:

- any course with a selected, non-null discovery candidate created after binding activation for the same Preview token/profile version is treated as resolved and excluded;
- only unresolved transient exhaustion is parked;
- Layer 3 receives a blocked `refresh_request` using the existing `manual_governed` trigger type where the accepted exhaustion contract applies;
- Layer 3 requests intentionally have `evidence_id=null`, so the existing Layer 3 Evidence gate remains authoritative;
- Layer 4 receives a pending `official_course_url` review item for each parked unresolved course;
- Layer 4 state records `canonical_mutation_authorised=false`;
- the async binding transitions to `handoff_started` rather than remaining active indefinitely.

## UQ live reconciliation

Existing authoritative Preview token: `b0eb7e77-d31a-4cb7-b187-8226445a1b7c`.

After deploying the parking migration, the existing exhausted final Job was re-fired with a no-op status update. No new scraper request was generated.

Live result:

- binding status: `handoff_started`;
- Layer 3 parked: **42**;
- Layer 3 blocked with no Evidence: **42**;
- Layer 4 pending: **42**;
- Layer 4 items with canonical mutation explicitly unauthorised: **42**.

Rollback-only pre-deployment proof produced the same 42/42 result and was fully rolled back.

## Review/CI evidence

Final PR #82 exact head before merge: `1eb6f159bc351d5b1b6234450625aa03d6b943c1`.

- Fresh Reconstruction `34755602814`: PASS.
- Targeted Recovery `34755602820`: PASS.
- Pilot Frontend Build `34755602823`: PASS.
- Cloudflare exact-head preview: PASS.
- Gitar: Approved after one resolved-course escalation finding was fixed; review thread resolved.

Post-merge Pilot main `ac0e1ca3100397abfb5fa13e77d5be6c12d6d27d` passed Frontend Build `34755718375` and Deployed UAT `34755717852`.

PR #83 exact head `c437ef6caa495b3ffc122a9d3e6d9174745d44de` passed Fresh Reconstruction `34756285717`, Targeted Recovery `34756285696`, Pilot Frontend Build `34756285691` and Cloudflare preview before merge.

Current Pilot main remains `cb31abe21ffe9a041cacd5f975a0e4af5248daa5`; no newer Pilot implementation commit was found during this terminal metrics reconciliation.

## Authority boundary

This change does not make Layer 3 autonomous without Evidence and does not permit Layer 4 to mutate canonical truth automatically. It creates an explicit escalation/parking boundary so acquisition failures can be reviewed later rather than forcing engineering to reverse-engineer each institution's website.

No Search or Publication admission is created. No Layer 1 authority changes. No security, ACL, RLS, service-role or Evidence rule is weakened.

## Exact next actions

1. Treat six-university **discovery** acceptance as terminal at 1,676 / 1,676 distinct courses accounted for and retain the tooling metrics as the scale baseline.
2. Continue monitoring the still-running **RMIT deterministic Layer 2 batch** to terminal state; do not create a duplicate dispatch.
3. Analyse Flinders identity-mismatch/ambiguity patterns separately if optimisation is desired; do not loosen identity confirmation.
4. Keep Firecrawl/ZenRows budget and reserve controls enforced. Current usable Firecrawl headroom before stop reserve is about 4,376 units.
5. Finish Admin PR #37 exact-head review/merge from current-main governance truth.
6. Reconcile PR #79 release-currentness/version and rerun exact-head checks/review before merge.
7. Reconcile REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS to the terminal discovery boundary, then close CF-093 when the remaining governance/release follow-on is complete.
8. Keep M2.5 paused unless separately authorised.
