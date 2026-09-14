# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CLOSED / PASS; CF-245 IMPLEMENTATION IN PROGRESS  
**Reconciled:** 2026-09-15 08:22 AEST  
**Accepted Pilot main:** `7196c5d2fade8830ec371c663b008e8a47e01f74`  
**Active CF-245 Pilot branch:** `cf-245-enrichment-ops` @ `2feb5be5d9bf39f0d677a323bafd30c7f8da1026`  
**Pilot PR:** #91 — OPEN / MERGEABLE / CI ACTIVE  
**Visible accepted release:** v2.15.79 / package 0.1.6  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## CF-093 final disposition

`CF-CHG-20260910-093` remains CLOSED / PASS / HISTORICAL ONLY. It must not be reopened for country/source onboarding, provider expansion, operational tuning or defects.

Its terminal deterministic baseline remains useful only as comparable evidence: the final RMIT batch `74b4b16f-20f0-4b61-a9e0-632d824f001a` processed 263 / 263, resolved 0 at Layer 2, escalated 263 to Layer 3, blocked 0, and used the accepted fail-closed policy snapshot.

## Active CF-245 implementation

Pilot branch `cf-245-enrichment-ops` contains three forward migrations already applied to Pilot runtime:

- `20260915072000_cf_245_enrichment_operational_ledger_v1.sql`;
- `20260915074500_cf_245_enrichment_reports_backlog_v1.sql`;
- `20260915082000_cf_245_field_admission_bounded_url_v1.sql`.

PR #91 was opened against accepted Pilot `main`. Frontend Build run `34904038556` started for head `2feb5be5d9bf39f0d677a323bafd30c7f8da1026`; final conclusion must be checked before merge.

Pilot runtime is therefore ahead of accepted Pilot `main`; CF-245 cannot be accepted until repository/runtime migration history, PR review/CI, targeted security/UAT and deployed runtime are reconciled.

## Gate A — why zero canonical mutation occurred

The opening interpretation that recent acquisition work created no `layer2_run_items` was incorrect. Those rows were pre-created before execution and later updated; queries bounded only by item `created_at` missed the active lifecycle. CF-245 reporting must use lifecycle/event timestamps.

The reconstructed acquisition cohort shows the dominant stop was not fetch failure or scheduler capacity. Item-wide Layer 3 escalation occurred whenever any targeted domain remained unresolved. Description remained unresolved across the cohort, while tuition/intake/English added overlapping fall-out. Identity mismatch was not the dominant cause.

The complete 263-item RMIT managed batch reconciles:

- 263 fetched/extracted items;
- 789 Evidence artifacts = 263 acquisition + 263 screenshot + 263 normalised extraction Evidence;
- 1,307 targeted fields;
- 935 deterministic candidate fields resolved;
- 263 original Layer 3 escalations;
- zero original field admissions;
- zero HTTP 429 / zero HTTP 5xx within the reconciled batch;
- recorded vendor units 263 / recorded cash cost USD 0.

This is an admission-granularity/demand-path problem, not evidence that scheduler frequency should be increased.

## Gate B/C — telemetry and demand state

`pipeline.layer2_enrichment_operational_ledger_v1` and `pipeline.layer2_enrichment_hourly_v1` are live in Pilot and make acquisition, Evidence, extraction, stop reason, latency, retry, cost/unit and Search-state dimensions queryable under service-role/private boundaries.

Current AU/NZ course-fact backlog classification is:

### AU

- 516 missing course-fact courses are currently queueable under existing profile/policy/URL scope;
- 2,005 require governed course-URL discovery;
- 28 have a usable URL but no enabled execution policy;
- 18,534 await both discovery and execution-policy qualification;
- 5,555 are outside the currently qualified course-fact profile scope.

### NZ

- 0 currently queueable;
- 1,087 are in the current scope but still require discovery/policy qualification;
- 5,370 have no qualified course-fact profile scope.

Scholarships remain a separate qualified scholarship-source/admission path and must not be inferred from course-fact acquisition.

## Bounded field admission and publication reconciliation

`pipeline.layer2_field_admissions` currently contains 262 `official_course_url` decisions:

- 260 `admitted` with canonical change;
- 2 `unchanged` / idempotent;
- no other stored decision status in the bounded replay.

An additional source-record candidate was not admitted because the regulatory code was not observed. This fail-closed exception remains unresolved rather than being weakened to increase throughput.

Official-URL admission requires exact CRICOS identity, Evidence URL equality, a qualified source admitting `official_course_url`, an approved Search source gate and no Layer 4 operational block. Tuition, intake, English and description candidates were not generically auto-approved.

The separate governed Search enrichment projection was previewed and applied after the final bounded URL replay. Verified current consumer/Search coverage is now:

- Search courses: **33,105**;
- regulatory tuition: **26,457**;
- intake coverage: **161**;
- English requirement coverage: **161**;
- official course links: **421**;
- provider-current tuition: **161**;
- website-admitted scholarships: **0**.

Relative to the CF-245 planning baseline this is +151 intake courses, +151 English courses, +411 official links and +151 provider-current tuition courses. These are runtime outcome deltas; field-level causal attribution must come from source/admission/publication records rather than assuming every increase was produced by the current replay.

## Provider/runtime controls

No scheduler/provider tuning was made during Gates A–E. Current accepted control intent remains fail-closed, provider/source bounded and Evidence-first. Scheduler frequency, execution-policy concurrency, paid-attempt limits, routing and credentials were not raised merely because earlier scheduler ticks found little/no work.

## Current gate

1. Finish PR #91 targeted review/CI and reconcile the already-applied Pilot migrations to repository `main`.
2. Build Gate F Enrichment Operations Admin reporting from the ledger/backlog/admission/publication data; Scheduled Tasks remains scheduler configuration/health only.
3. Run a fresh bounded governed Layer 2 cohort after repository reconciliation and prove queue → acquisition → Evidence → extraction → admission/fall-out → Search/publication in one measurement window.
4. Continue AU bounded expansion only from qualified scope; NZ remains blocked pending source/profile/discovery/policy qualification.
5. Do not tune frequency/concurrency/provider ceilings until comparable fresh-period evidence exists.

M2.4.4 remains CLOSED/PASS/FROZEN. M2.5 remains paused unless separately authorised.
