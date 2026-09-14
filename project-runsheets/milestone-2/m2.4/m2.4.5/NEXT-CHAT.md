# M2.4.5 NEXT CHAT

## Active baseline — 15 September 2026

- Milestone: **M2.4.5 — Pre-Production Hardening**.
- M2.5 remains paused; no Production Supabase project exists.
- `CF-CHG-20260910-093` is **CLOSED / PASS / HISTORICAL ONLY**.
- Active operational-enrichment workstream: **`CF-CHG-20260915-245`**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Current Pilot main: **`f707e2d4b7221a185dcafb6ec2095ec4a94ad841`**.
- CF-245 PR #91: **MERGED**.
- CF-245 PR #92: **MERGED**.
- Visible accepted/recovery release remains **v2.15.79 / package 0.1.6** unless release governance changes it.

## What is now implemented

CF-245 has established:

- common enrichment operational ledger and hourly telemetry;
- AU/NZ enrichment backlog classification;
- bounded qualified RMIT official-course-URL admission;
- governed Search projection reconciliation;
- hourly coverage snapshot ledger;
- rank-gated `admin_read('enrichment_operations')` browser bundle;
- Enrichment Operations reporting in the Layer 2 workspace for coverage/backlog, hourly funnel, stop reasons, provider yield/latency, admissions, errors/cost and Jobs/Evidence drill-down.

Scheduled Tasks remains scheduler configuration/health. No scheduler frequency/concurrency, paid-attempt ceiling, provider routing, credentials, budgets or mutation-authority boundary changed.

## Current website/Search coverage

- Search courses: **33,105**;
- regulatory tuition: **26,457**;
- intake coverage: **161**;
- English requirement coverage: **161**;
- official course links: **421**;
- provider-current tuition: **161**;
- website-admitted scholarships: **0**.

## Fresh measurement evidence

Fresh RMIT batch `797da1cb-0689-4dc6-80e3-6dcf38792950` completed:

- 5 / 5 processed;
- 5 / 5 fetched/extracted;
- 15 correlated Evidence artifacts;
- 20 fields targeted / 11 resolved;
- 0 retries;
- 0 acquisition/runtime blockers;
- 5 vendor units / recorded cash cost USD 0;
- all 5 ended `layer3_required` with `layer3_unresolved_target_fields`;
- p50/p95 response about 2.9 s / 3.8 s;
- p50/p95 extraction about 2.0 s / 2.15 s.

Interpretation: acquisition is healthy. The limiter remains field/admission granularity and Layer 3 handling. Do not tune scheduler throughput from this sample.

## Security/CI state

- PR #92 final candidate CI `34905465257`: PASS.
- Post-merge frontend build `34905600072`: PASS.
- rank-4 pipeline-operator read: PASS.
- rank-3 curator negative path: PASS.
- authenticated/anon direct snapshot-table read: denied.
- hourly coverage snapshot schedule: minute 7 each hour.
- no new Supabase Security Advisor WARN/ERROR introduced by CF-245.

## Current blocker — deployed UAT

Deployed UAT `34905600101` failed on desktop because the changed-file router selected the older `m2-5-layer2-finalizer-fairness-deployed.spec.mjs` suite for the Layer 2 entry-file change.

The suite's source-contract test passed. Its browser assertion failed because `[data-l2-latest-terminal="true"]` was not found.

Do **not** treat this as proof of a CF-245 functional/security regression yet. Current classification is **UAT routing/currentness recovery required**.

Do not weaken the older fairness contract merely to get green CI.

## Exact continuation sequence

1. Reconcile the deployed Worker/UI with Pilot main `f707e2d4...`.
2. Add/select a dedicated **CF-245 Enrichment Operations deployed UAT** route so CF-245 changes are not validated by an unrelated finalizer-fairness suite.
3. Run targeted deployed desktop UAT.
4. If that dedicated UAT reveals a real CF-245 UI/runtime defect, fix it under the governed troubleshooting/bug-fix/recovery protocol.
5. Re-run targeted CI/UAT until green.
6. Allow real hourly snapshots to accumulate and confirm +hour coverage/throughput deltas; later capture daily publication attribution.
7. Continue bounded AU expansion only from qualified scope. NZ remains blocked until source/profile/discovery/policy qualification exists.
8. Keep scheduler frequency/concurrency/provider ceilings unchanged until comparable before/after evidence justifies a governed tuning event.

## Acceptance still open

CF-245 is not closed. Remaining gates are deployed Enrichment Operations acceptance, genuine hourly/daily operating history, bounded qualified AU expansion, representative NZ work only when qualification exists, and final targeted/bounded security/browser acceptance with continuity current.
