# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CLOSED / PASS; CF-245 ACTIVE  
**Reconciled:** 2026-09-15  
**Current Pilot main:** `f707e2d4b7221a185dcafb6ec2095ec4a94ad841`  
**CF-245 implementation:** PR #91 MERGED; PR #92 MERGED  
**Visible accepted release:** v2.15.79 / package 0.1.6  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Current operational truth

CF-093 remains CLOSED / PASS / HISTORICAL ONLY and must not be reopened.

CF-245 telemetry, backlog classification, bounded official-URL admission, Search projection reconciliation and Enrichment Operations Admin reporting are now merged into Pilot history.

Current Search/consumer coverage:

- 33,105 Search courses;
- 26,457 regulatory tuition;
- 161 intake coverage;
- 161 English requirement coverage;
- 421 official course URLs;
- 161 provider-current tuition coverage;
- 0 website-admitted scholarships.

## Why enrichment is not expanding automatically

Historical and fresh measurements agree that scheduler liveness/acquisition capacity is not the active limiter. The current bottleneck is unresolved field/admission granularity and subsequent Layer 3 handling.

Historical RMIT batch: 263 / 263 fetched/extracted; 789 Evidence artifacts; 1,307 fields targeted; 935 deterministic candidate fields; all 263 escalated to Layer 3; zero original admissions.

Fresh CF-245 RMIT batch `797da1cb-0689-4dc6-80e3-6dcf38792950`:

- 5 / 5 fetched/extracted;
- 15 correlated Evidence artifacts;
- 20 fields targeted / 11 resolved;
- 0 retries / 0 acquisition blockers;
- all 5 ended `layer3_required` because targeted fields remained unresolved;
- response p50/p95 about 2.9 s / 3.8 s;
- extraction p50/p95 about 2.0 s / 2.15 s.

No scheduler frequency/concurrency/provider tuning is justified by this evidence.

## AU/NZ backlog truth

### AU

- 516 currently queueable under existing profile/policy/URL scope;
- 2,005 require governed URL discovery;
- 28 have usable URL/profile but no enabled execution policy;
- 18,534 await discovery plus execution-policy qualification;
- 5,555 outside current qualified course-fact scope.

### NZ

- 0 currently queueable;
- 1,087 require discovery/policy qualification;
- 5,370 have no qualified course-fact scope.

NZ must not be enabled by copying AU assumptions.

## Gate F Enrichment Operations

Merged via PR #92. The Layer 2 workspace now has outcome-focused Enrichment Operations reporting for coverage/backlog, hourly funnel, stop reasons, provider yield/latency, admissions, cost/units/errors and Jobs/Evidence drill-down.

Security boundary:

- rank-4 pipeline operator read: PASS;
- rank-3 curator read: denied as designed;
- direct authenticated/anon snapshot-table read: denied;
- hourly coverage snapshots scheduled independently at minute 7;
- no scheduler/configuration mutation authority added.

CI:

- PR #92 final candidate `34905465257`: PASS;
- post-merge frontend build `34905600072`: PASS.

## Open blocker — deployed UAT

Deployed UAT run `34905600101` failed on the older M2.5 Layer 2 finalizer-fairness deployed suite. The workflow router selected that suite because `src/layer2-operations-entry.jsx` matched its generic changed-file rule.

The source-contract test passed. The browser assertion failed because `[data-l2-latest-terminal="true"]` was not found in the Layer 2 Operations workspace.

Current classification: **deployed-UAT routing/currentness recovery required; not yet evidence of a CF-245 functional/security regression**.

## Exact current gate

1. Route CF-245 changes to a dedicated Enrichment Operations deployed-UAT suite.
2. Verify deployed Worker/UI currentness against `f707e2d4...`.
3. Rerun targeted deployed desktop UAT.
4. If a real CF-245 defect appears, fix it under the troubleshooting/recovery protocol; do not weaken existing contracts.
5. Accumulate real hourly/daily coverage snapshots and publication attribution.
6. Continue bounded qualified AU expansion. Keep NZ blocked pending qualification.

M2.4.4 remains CLOSED/PASS/FROZEN. M2.5 remains paused unless separately authorised.
