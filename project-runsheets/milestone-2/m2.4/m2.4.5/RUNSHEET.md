# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CLOSED / PASS; CF-245 ACTIVE  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-15  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Current Pilot main: `f707e2d4b7221a185dcafb6ec2095ec4a94ad841`.
- CF-245 implementation PRs: #91 MERGED; #92 MERGED.
- Visible accepted release remains v2.15.79 / package 0.1.6 until release governance changes it.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- CF-093: CLOSED / PASS / HISTORICAL ONLY; do not reopen.
- Production Supabase: not provisioned.
- Current operational authority: `CF-CHG-20260915-245`.

## CF-245 Gate status

- [x] Gate A — historical zero-mutation cause reconciled: unresolved targeted fields drove whole-item Layer 3 escalation; scheduler capacity was not the cause.
- [x] Gate B — common enrichment operational ledger/hourly telemetry merged and live.
- [x] Gate C — AU/NZ backlog classification live.
- [x] Gate D — bounded qualified RMIT official-course-URL admission complete: 260 changed + 2 unchanged; fail-closed exception retained.
- [x] Gate E — governed Search projection applied; current official URL coverage 421 with no collateral final projection delta.
- [x] Gate F implementation — Enrichment Operations reporting merged via PR #92, with rank-gated browser read path and private telemetry tables.
- [ ] Gate F deployed acceptance — blocked by deployed-UAT suite routing/currentness recovery, not yet proven as a CF-245 functional defect.
- [ ] Gate G — tuning not authorised; no scheduler/provider limits changed.
- [ ] Gate H — closure remains open pending deployed UAT, real hourly/daily history and further bounded qualified expansion.

## Current Search/website coverage

- Search courses: 33,105.
- Regulatory tuition: 26,457.
- Intakes: 161.
- English requirements: 161.
- Official course URLs: 421.
- Provider-current tuition: 161.
- Website-admitted scholarships: 0.

## Fresh CF-245 measurement cohort

Batch `797da1cb-0689-4dc6-80e3-6dcf38792950`:

- 5 / 5 processed;
- 5 / 5 fetched/extracted;
- 15 correlated Evidence artifacts;
- 20 fields targeted / 11 resolved;
- 0 retries;
- 0 acquisition/runtime blockers;
- 5 vendor units / recorded cash cost USD 0;
- all 5 ended `layer3_required` / `layer3_unresolved_target_fields`;
- p50/p95 response about 2.9 s / 3.8 s;
- p50/p95 extraction about 2.0 s / 2.15 s.

Conclusion: acquisition is healthy. Field/admission granularity and Layer 3 handling remain the limiter. Do not increase scheduler frequency/concurrency from this evidence.

## Gate F implementation/security evidence

- PR #92 final candidate CI `34905465257`: PASS.
- Post-merge Pilot Frontend Build `34905600072`: PASS.
- rank-4 `pipeline_operator` Enrichment Operations read: PASS.
- rank-3 `curator` read: rejected as designed.
- authenticated/anon direct snapshot-table SELECT: denied.
- hourly snapshot job: minute 7 each hour.
- no new Supabase Security Advisor WARN/ERROR introduced by CF-245.

## Deployed UAT recovery

Deployed UAT run `34905600101` failed because the generic changed-file router selected `m2-5-layer2-finalizer-fairness-deployed.spec.mjs`. Its source-contract assertion passed; the deployed UI assertion failed because `[data-l2-latest-terminal="true"]` was not found.

This is currently classified as **UAT routing/currentness recovery required**. Do not weaken the fairness test, security rules or enrichment authority boundaries to make it pass.

## Exact next action

1. Add/select a dedicated CF-245 Enrichment Operations deployed-UAT route.
2. Verify deployed Worker/UI currentness against Pilot main `f707e2d4...`.
3. Rerun targeted deployed desktop UAT and fix only a demonstrated CF-245 runtime/UI defect if one appears.
4. Let genuine hourly snapshots accumulate and verify +hour coverage/throughput deltas.
5. Continue bounded AU qualification/coverage expansion; NZ remains blocked pending source/profile/discovery/policy qualification.
6. Do not tune scheduler frequency/concurrency/provider ceilings until comparable evidence justifies it.
