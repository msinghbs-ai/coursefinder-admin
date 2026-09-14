# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CLOSED / PASS; CF-245 IMPLEMENTATION IN PROGRESS  
**Reconciled:** 2026-09-15 AEST  
**Accepted Pilot main:** `7196c5d2fade8830ec371c663b008e8a47e01f74`  
**Active CF-245 Pilot branch:** `cf-245-enrichment-ops` @ `2feb5be5d9bf39f0d677a323bafd30c7f8da1026`  
**Visible accepted release:** v2.15.79 / package 0.1.6  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## CF-093 final disposition

`CF-CHG-20260910-093` remains CLOSED / PASS / HISTORICAL ONLY. It must not be reopened for country/source onboarding, provider expansion, operational tuning or defects.

Its terminal deterministic baseline remains useful only as comparable evidence: six-university discovery accounted for 1,676 / 1,676 courses; the final RMIT batch `74b4b16f-20f0-4b61-a9e0-632d824f001a` processed 263 / 263, resolved 0 at Layer 2, escalated 263 to Layer 3, blocked 0, and used the accepted fail-closed policy snapshot.

## Active workstream

`CF-CHG-20260915-245` — M2.4.5 Enrichment Operations, Metrics & Coverage Expansion — is OPEN / IMPLEMENTATION IN PROGRESS.

The active Pilot branch is three commits ahead of accepted `main` and currently adds:

- `20260915072000_cf_245_enrichment_operational_ledger_v1.sql`;
- `20260915074500_cf_245_enrichment_reports_backlog_v1.sql`;
- `20260915082000_cf_245_field_admission_bounded_url_v1.sql`.

Pilot runtime already contains the CF-245 operational ledger/hourly reporting objects and bounded field-admission surface. This runtime state is ahead of accepted Pilot `main`, so merge/release reconciliation remains required before CF-245 can be accepted.

## Reconciled runtime findings — 15 September 2026

### Common operational telemetry

The previously identified observability gap has materially improved:

- `pipeline.layer2_enrichment_operational_ledger_v1` exists and reconciles the historical CF-093 deterministic run path;
- `pipeline.layer2_enrichment_hourly_v1` now returns populated hourly rows for the RMIT completion window instead of an empty report;
- the populated hours reconcile 254 terminal RMIT items across 20:00, 21:00 and 22:00 UTC with 762 Evidence rows represented, 254 acquisition/extraction attempts, 254 Layer 3 escalations, zero HTTP 429, zero HTTP 5xx and two retries;
- provider/extraction latency remains acquisition-dominant: the 21:00 UTC hour has p50/p95 provider response 9.114s / 24.812s versus extraction 1.605s / 2.248s;
- no new pipeline Jobs or operational-ledger events have occurred in the latest 24 hours; the latest deterministic event remains 2026-09-13 22:03 UTC.

This means telemetry wiring is now demonstrably present for the deterministic run path, but a fresh governed Layer 2 run is still required to prove the live scheduled/acquisition path end-to-end under CF-245.

### Bounded field admission / Search-visible coverage

A material governed admission transition has occurred in Pilot runtime:

- `pipeline.layer2_field_admissions` contains 262 `official_course_url` decisions;
- 260 are `admitted`, canonical-changed and Search-admission-eligible;
- 2 are `unchanged`, with zero canonical change and Search-admission eligibility retained;
- latest admission decision: 2026-09-14 21:16 UTC;
- the admission function remains service-role only and preserves Evidence, exact CRICOS identity, Layer 4 operational block and Search source-gate checks.

Current Search/consumer coverage is now:

- Search courses: 33,105;
- regulatory tuition: 26,457;
- intake coverage: 161;
- English requirement coverage: 161;
- official course links: 384;
- provider-current tuition: 161;
- website-admitted scholarships: 0.

Compared with the CF-245 planning baseline, this is +151 intakes, +151 English-requirement courses, +374 official links and +151 provider-current tuition courses. Do not infer that every delta was caused solely by the bounded official-URL admission wave; the runtime counts are authoritative outcomes, while causal attribution must follow the admission/source records.

### Provider budget and controls

September provider-attempt totals remain:

- Firecrawl: 6,629 attempts; 6,091 succeeded; 538 non-success; 0 HTTP 429; 23 HTTP 5xx; latest attempt 2026-09-13 22:03 UTC;
- ZenRows: 188 attempts; 1 succeeded; 187 non-success; no later RMIT fallback;
- Direct HTTP: 3,232 attempts; 2,428 succeeded; 804 non-success.

Firecrawl entitlement remains 11,000 monthly units with 250-unit stop reserve, leaving 4,371 nominal units / approximately 4,121 units before reserve.

Current provider controls are unchanged:

- Firecrawl: concurrency 5, 30 requests/minute, 90s timeout;
- ZenRows: concurrency 2, 60 requests/minute, 90s timeout;
- Direct HTTP: concurrency 1, 30s timeout.

### Execution-policy snapshot

All 50 enabled Layer 2 execution policies remain fail-closed with `max_concurrency=1`, `stale_after_minutes=30`, `max_paid_attempts_per_entity=2` and `direct_then_best_value` routing. Current batch-size distribution is 41 policies at 1, eight at 10 and one at 5.

No runtime/provider setting was changed from these observations.

## Tuning interpretation

The evidence continues to support acquisition/source behaviour as the diagnostic bottleneck rather than extraction concurrency. The comparable RMIT 12 September run resolved 213 / 263 at Layer 2 and 1,257 / 1,307 targeted fields, while the 13 September run resolved 0 / 263 at Layer 2 and 935 / 1,307 fields despite nearly identical extraction latency.

Do not increase scheduler frequency, dispatcher concurrency, paid-attempt limits or provider limits from this evidence. Do not alter provider routes, credentials, identity checks, Evidence rules, Layer 3/4 authority, canonical data, Search/Publication authority or UAT rules without separate governed evidence and approval.

## Current operational gate

1. Reconcile/accept the three CF-245 Pilot commits against current runtime migrations and open the implementation PR if not already done.
2. Prove the new ledger/hourly path on a fresh legitimately governed Layer 2 execution, including queue wait, execution duration, provider attempts, retries, Evidence, field admissions, Layer 3/4 and Search-visible deltas.
3. Reconcile the 262 current official-URL field-admission decisions to exact source records and Search projection outcomes; distinguish admitted, unchanged, rejected/deferred and not-yet-attempted candidates.
4. Continue AU/NZ backlog generation and bounded coverage expansion only after the first fresh end-to-end report remains internally consistent.
5. Keep runtime controls unchanged until comparable CF-245 evidence supports a tuning decision.

M2.4.4 remains CLOSED/PASS/FROZEN. M2.5 remains paused unless separately authorised.
