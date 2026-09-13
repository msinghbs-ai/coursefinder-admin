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

Latest captured worker metrics during the active wave:

| University | Discovery scope | Jobs | Terminal jobs | Running jobs | Processed | Failed | Avg queue sec | Avg terminal execution sec |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| RMIT | 27 | 3 | 3 | 0 | 27 | 0 | 0.37 | 50.72 |
| Curtin | 356 | 5 | 4 | 1 | 64 | 0 | 0.31 | 62.03 |
| Flinders | 461 | 5 | 4 | 1 | 39 | 0 | 0.22 | 63.06 |
| Griffith | 294 | 5 | 4 | 1 | 49 | 0 | 0.21 | 61.20 |
| La Trobe | 244 | 4 | 3 | 1 | 39 | 0 | 0.16 | 63.94 |
| QUT | 294 | 4 | 3 | 1 | 41 | 0 | 0.16 | 61.86 |

At this snapshot **259 course items had been processed with 0 job-level failures**. RMIT completed its full 27-course discovery scope and moved to `handoff_started`; the other five bindings remained active under bounded continuation.

Provider/Evidence snapshot:

| University | Firecrawl attempts | ZenRows attempts | Successful attempts | Failed attempts | Running attempts | Candidate courses | Selected | Not found | Ambiguous | Identity mismatch | Raw Evidence | HTML Evidence | Screenshot Evidence |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| RMIT | 27 | 0 | 27 | 0 | 0 | 27 | 0 | 26 | 1 | 0 | 27 | 27 | 27 |
| Curtin | 87 | 0 | 86 | 0 | 1 | 85 | 1 | 83 | 1 | 0 | 86 | 86 | 86 |
| Flinders | 54 | 0 | 53 | 0 | 1 | 52 | 1 | 27 | 3 | 21 | 53 | 53 | 53 |
| Griffith | 64 | 0 | 63 | 0 | 1 | 63 | 0 | 63 | 0 | 0 | 63 | 63 | 63 |
| La Trobe | 55 | 0 | 54 | 0 | 1 | 54 | 0 | 54 | 0 | 0 | 54 | 54 | 54 |
| QUT | 59 | 0 | 58 | 0 | 1 | 58 | 0 | 58 | 0 | 0 | 58 | 58 | 58 |

Observations from the snapshot:

- Firecrawl is carrying the entire active workload; **ZenRows fallback has not yet been invoked**.
- Provider HTTP/acquisition execution is healthy; no failed provider attempt was recorded in this snapshot.
- Evidence generation is keeping pace with completed provider attempts, including raw, HTML and screenshot Evidence.
- The dominant outcome is a governed negative discovery result rather than transport failure. This is expected to flow to the existing Layer 3/4 parking boundary when retries are exhausted.
- Flinders is the main identity-quality signal to watch: 21 courses had reached `identity_mismatch` at this snapshot. Do not loosen identity confirmation to improve the success rate.
- Queue delay is negligible relative to ~51–64 second chunk execution, so scraper/site processing rather than queue contention is the current throughput limiter.

Continue collecting provider usage, throughput, Evidence production, selected/terminal-negative/ambiguous/identity-mismatch rates, fallback use and Layer 3/4 parking counts. Do not create duplicate dispatches while bindings remain active.

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
- only unresolved courses are parked;
- Layer 3 receives a blocked `refresh_request` using the existing `manual_governed` trigger type;
- Layer 3 requests intentionally have `evidence_id=null`, so the existing Layer 3 Evidence gate remains authoritative;
- Layer 4 receives a pending `official_course_url` review item for each unresolved course;
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

## Authority boundary

This change does not make Layer 3 autonomous without Evidence and does not permit Layer 4 to mutate canonical truth automatically. It creates an explicit escalation/parking boundary so acquisition failures can be reviewed later rather than forcing engineering to reverse-engineer each institution's website.

No Search or Publication admission is created. No Layer 1 authority changes. No security, ACL, RLS, service-role or Evidence rule is weakened.

## Exact next actions

1. Continue reconciling all six Preview tokens to terminal Jobs/Evidence/handoff/Layer 3+4 outcomes and preserve provider/tooling metrics.
2. Keep Firecrawl/ZenRows budget and reserve controls enforced; do not treat successful HTTP retrieval as successful identity resolution.
3. Finish Admin PR #37 exact-head review/merge from current-main governance truth.
4. Reconcile PR #79 release-currentness/version and rerun exact-head checks/review before merge.
5. Reconcile REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS to the terminal batch boundary, then close CF-093 when the remaining governance/release follow-on is complete.
6. Keep M2.5 paused unless separately authorised.
