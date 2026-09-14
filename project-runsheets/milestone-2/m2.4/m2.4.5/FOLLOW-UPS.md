# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Exact next action |
|---|---|---|---|---|
| M245-FU-032 | CF-093 / large-university L2 | UQ/RMIT corrective acceptance | **CLOSED / SUPERSEDED BY ACCEPTED IMPLEMENTATION** | Historical only; do not reopen CF-093. |
| M245-FU-033 | CF-093 / repo-runtime currentness | Accepted runtime/repository state | **CLOSED / PASS** | Preserve immutable applied migration identities and accepted v2.15.79 baseline. |
| M245-FU-061 | Runtime operations | Metrics and performance monitoring | **ACTIVE / PARTIAL PASS** | Hourly telemetry and coverage snapshots are live. Accumulate genuine +hour/+day history and explicit publication attribution. |
| M245-FU-063 | CF-245 telemetry | Historical item telemetry interpretation | **CLOSED / RECONCILED** | Lifecycle timestamp model accepted; preserve it. |
| M245-FU-064 | CF-245 admission | Field-level admission/fall-out visibility | **ACTIVE / PARTIAL PASS** | Fresh 5-course run confirmed unresolved field granularity drives Layer 3 fall-out. Extend attribution to subsequent bounded cohorts. |
| M245-FU-065 | CF-245 demand | AU/NZ missing/stale enrichment backlog | **PASS / LIVE CLASSIFICATION** | Keep runtime classification refreshed; AU has 516 currently queueable, NZ 0. |
| M245-FU-066 | CF-245 coverage | Controlled AU/NZ expansion | **ACTIVE** | Continue only bounded qualified AU cohorts; NZ remains blocked pending source/profile/discovery/policy qualification. |
| M245-FU-067 | CF-245 publication | Evidence-to-consumer reconciliation | **PARTIAL PASS** | Search is reconciled at 421 official URLs, 161 intake, 161 English, 161 provider tuition. Add per-run publication attribution after real elapsed snapshots. |
| M245-FU-068 | CF-245 Admin reporting | Enrichment Operations report/dashboard | **IMPLEMENTED / MERGED; DEPLOYED ACCEPTANCE OPEN** | PR #92 merged. Repair deployed-UAT routing/currentness and run dedicated CF-245 deployed acceptance. |
| M245-FU-069 | CF-245 tuning | Evidence-led dispatcher/provider tuning | **BLOCKED / NOT AUTHORISED** | Fresh cohort had 0 retries/0 acquisition blockers and sub-4s p95 response. Do not tune throughput controls yet. |
| M245-FU-070 | CF-245 bounded URL admission | Qualified RMIT official course URL replay | **PASS / BOUNDED** | 260 changed + 2 unchanged; one fail-closed exception retained. Extend only through qualified cohorts. |
| M245-FU-071 | CF-245 repository/runtime reconciliation | Runtime/repository reconciliation | **CLOSED / PASS** | PR #91 merged and migration history reconciled. Current Pilot main is `f707e2d4...` after PR #92. |
| M245-FU-072 | CF-245 Search currentness | Final official URL projection | **PASS** | 37-row final projection applied with no collateral field delta. |
| M245-FU-073 | CF-245 fresh cohort | Fresh governed 5-course measurement run | **PASS FOR MEASUREMENT** | Batch `797da1cb-...`: 5/5 processed, 15 Evidence, 20 targeted, 11 resolved, 0 retries/blockers; all 5 Layer 3-required. Use as current comparison point. |
| M245-FU-074 | CF-245 deployed UAT | Wrong deployed suite selected by changed-file router | **ACTIVE / BLOCKER** | Add/select dedicated CF-245 Enrichment Operations deployed suite, verify deployed currentness, rerun targeted desktop UAT. |
| M245-FU-075 | CF-245 deployed UAT | Older finalizer-fairness UI assertion failed | **INVESTIGATING / DO NOT WEAKEN CONTRACT** | Confirm whether missing `data-l2-latest-terminal` is deployment/currentness or unrelated pre-existing UI state before any code change. |
| M245-FU-062 | Country/source expansion | Canada and future countries/sources | **FUTURE / NEW CHANGE CONTROL REQUIRED** | Do not mix Canada/future-country onboarding into CF-245 AU/NZ operational completion unless separately approved. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Production remains unprovisioned. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route material items through Change Control. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Retain targeted → bounded → nominated broad acceptance. |
| M245-FU-011 | H10 | Meeting/status evidence | ACTIVE | Maintain exact heads, runtime/UAT evidence and blockers. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle | OPEN / GOVERNED | Continue separately. |

## Current priority — 15 September 2026

1. CF-093 remains CLOSED / PASS / historical only.
2. Pilot main is `f707e2d4b7221a185dcafb6ec2095ec4a94ad841`; PR #91 and #92 are merged.
3. Fix deployed-UAT suite routing/currentness for CF-245; do not weaken the older fairness test.
4. Rerun targeted deployed desktop UAT for Enrichment Operations.
5. Accumulate genuine hourly/daily coverage history and publication attribution.
6. Continue bounded qualified AU coverage expansion; keep NZ blocked pending qualification.
7. Keep scheduler/provider throughput tuning blocked until comparable evidence justifies it.
8. Keep M2.5 paused and Production unprovisioned.
