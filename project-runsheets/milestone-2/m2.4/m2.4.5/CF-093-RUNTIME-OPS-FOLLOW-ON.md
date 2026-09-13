# CF-CHG-20260910-093 — Runtime Operations Follow-on

**Status:** ACTIVE FOLLOW-ON / SCRAPER ESCALATION BOUNDARY DEPLOYED  
**Updated:** 13 September 2026 AEST

## Current implementation

- PR #72 merged Preview-bound async Layer 2 discovery.
- PR #80 merged deployed-main acceptance-trigger recovery.
- PR #81 merged UQ acceptance-count/invariant reconciliation.
- PR #82 merged as Pilot main `ac0e1ca3100397abfb5fa13e77d5be6c12d6d27d`, implementing Firecrawl -> ZenRows bounded discovery and Layer 3/4 parking for unresolved exhaustion.
- PR #79 remains the separate browser-visible Runtime Health / efficiency candidate and still requires release-currentness/version reconciliation before merge.
- Visible accepted release remains v2.15.78.

## Deployed observability/runtime migrations

1. Runtime ledger `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`; repository source `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`.
2. Runtime ledger `20260913102217 cf_093_scheduled_runtime_metrics_read`; repository source `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`.
3. Runtime ledger `20260913115513 cf_093_firecrawl_zenrows_exhaustion_parking`; repository source `20260913113000_cf_093_firecrawl_zenrows_exhaustion_parking.sql`.

Preserve runtime-ledger and repository identities separately. Applied migration history is immutable.

## Runtime Health / telemetry

The terminal timestamp correction is proven in genuine UQ consequential traffic. Four bounded discovery jobs received real `completed_at` timestamps and measurable execution durations. Exact-token reconciliation showed all 42 bound discovery courses received exactly three governed attempts.

The rank-4 `jobs_runtime` read remains fail-closed for lower ranks/anon/public and does not expose raw payload/result/error text, URLs, Storage paths or secrets. The bounded recent-50 deployed wrapper proof measured about 21.4 ms.

## Accepted acquisition boundary

Website-specific scraper perfection is no longer an acceptance objective for this path.

Current live UQ route:

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

Post-merge Pilot main `ac0e1ca3100397abfb5fa13e77d5be6c12d6d27d`:

- Frontend Build `34755718375`: **PASS**.
- Deployed UAT `34755717852`: **PASS**.

## Authority boundary

This change does not make Layer 3 autonomous without Evidence and does not permit Layer 4 to mutate canonical truth automatically. It creates an explicit escalation/parking boundary so acquisition failures can be reviewed later rather than forcing engineering to reverse-engineer each institution's website.

No Search or Publication admission is created. No Layer 1 authority changes. No security, ACL, RLS, service-role or Evidence rule is weakened.

## Exact next actions

1. Finish Admin PR #37 exact-head review/merge from current-main governance truth.
2. Stop treating scrape.do/provider-specific website mechanics as CF-093 acceptance blockers; unresolved cases now belong to Layer 3/4 queues.
3. Reconcile PR #79 release-currentness/version and rerun exact-head checks/review before merge.
4. Reconcile REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS to this boundary, then close CF-093 when the remaining governance/release follow-on is complete.
5. Keep M2.5 paused unless separately authorised.
