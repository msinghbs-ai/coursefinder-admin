# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CLOSED / PASS; OPERATIONS + METRICS CONTINUE  
**Reconciled:** 2026-09-14 AEST  
**Accepted Pilot main:** `7196c5d2fade8830ec371c663b008e8a47e01f74`  
**Visible accepted release:** v2.15.79 / package 0.1.6  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## CF-093 final disposition

`CF-CHG-20260910-093` is **CLOSED / PASS** and is now historical evidence only. It must not be reopened for Canada, another country, another provider cohort, routine onboarding, operational tuning or a future defect. Any such work receives a new Change Control ID and may reference CF-093 as prior architecture/acceptance evidence.

Accepted implementation/recovery evidence includes:

- Pilot PR #72 through PR #90 implementation/recovery path completed;
- v2.15.79 promoted as accepted/recovery release;
- six-university Preview-bound discovery terminal at **1,676 / 1,676 distinct courses accounted for**;
- RMIT deterministic Layer 2 batch `74b4b16f-20f0-4b61-a9e0-632d824f001a` terminal `partial` at **263 / 263 processed**;
- deployed UAT run `34819914624` recovered from the initial NZQA HTTP 500 without weakening the test: replacement job `103960817860` **PASS**;
- current commit status `coursefinder/deployed-uat/targeted/chromium-desktop = success`.

## Accepted authority baseline

- Layer 1 identity/regulatory authority unchanged.
- Layer 2 deterministic, Evidence-preserving, Preview-bound and fail-closed.
- Exact Preview token/fingerprint/binding/identity provenance retained.
- Layer 3 remains separately governed; generic scheduler auto-approval remains prohibited.
- Layer 4 human authority remains separate.
- Search/Publication remains separately governed.
- Rank/ACL/RLS/private-helper/service-role boundaries retained.
- Applied migration history remains immutable and forward-only.

## Current operational focus

Continue evidence-led M2.4.5 operations and metrics outside CF-093 closure. Track real governed workloads for:

- throughput and queue/execution latency;
- provider response and extraction p50/p95;
- retries and terminal outcomes;
- Evidence counts and field-resolution yield;
- provider unit/budget consumption;
- HTTP 429/5xx/error rates;
- recurrence of NZQA/`admin_read` runtime errors.

Hold dispatcher/provider settings steady until comparable governed evidence supports a change. No synthetic production-like load is required merely to populate metrics.

## Exact next gate

1. Continue M2.4.5 operational monitoring from the accepted v2.15.79 baseline.
2. Route Canada, future country/source onboarding, provider cohort expansion, operational tuning that changes behaviour, or future defects through a **new Change Control ID**.
3. Keep M2.5 paused unless separately authorised.

M2.4.4 remains CLOSED/PASS/FROZEN.