# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Exact next action |
|---|---|---|---|---|
| M245-FU-032 | CF-093 / large-university L2 | UQ/RMIT corrective acceptance | **CLOSED / SUPERSEDED BY ACCEPTED IMPLEMENTATION** | Historical only; do not reopen CF-093. |
| M245-FU-033 | CF-093 / repo-runtime currentness | Accepted runtime/repository state | **CLOSED / PASS** | Preserve immutable applied migration identities and accepted v2.15.79 baseline. |
| M245-FU-040 | CF-093 / reconstruction | Ordered migration replay | **CLOSED / PASS** | Re-run only under a future Change Control if a new migration change requires it. |
| M245-FU-034 | CF-093 / Codex | Exact-head review | **CLOSED** | Historical assurance evidence retained. |
| M245-FU-044 | CF-093 / targeted recovery CI | Targeted contracts | **CLOSED / PASS** | Historical evidence retained. |
| M245-FU-045 | CF-093 / Frontend + smoke | Build/browser smoke | **CLOSED / PASS** | Historical evidence retained. |
| M245-FU-055 | CF-093 / continuation recovery | Bounded retry behaviour | **CLOSED / ACCEPTED** | Preserve behaviour as platform baseline. |
| M245-FU-056 | CF-093 / detail identity drift | Fail closed before candidate write | **CLOSED / ACCEPTED** | Preserve behaviour as platform baseline. |
| M245-FU-057 | CF-093 / Preview resolver provenance | Exact Preview token provenance | **CLOSED / ACCEPTED** | Preserve behaviour as platform baseline. |
| M245-FU-058 | CF-093 / terminal freshness | Layer 1 identity invalidates terminal freshness | **CLOSED / ACCEPTED** | Preserve behaviour as platform baseline. |
| M245-FU-059 | CF-093 / mixed handoff | Preserve valid pre-existing queueable URLs | **CLOSED / ACCEPTED** | Preserve behaviour as platform baseline. |
| M245-FU-060 | CF-093 / worker deployment | Reviewed/deployed worker currentness | **CLOSED / ACCEPTED** | Future worker changes require their own Change Control where material. |
| M245-FU-053 | CF-093 / UQ workflow | Historical workflow-dispatch blocker | **CLOSED / NO LONGER ACTIVE** | Do not revive this blocker or CF-093. |
| M245-FU-035 | Layer 3 | Separate governed Layer 3 | **SEPARATE WORKSTREAM** | Route future Layer 3 work under its own active/new Change Control. |
| M245-FU-036 | AU qualification wave | Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW | **AVAILABLE FOR SEPARATE GOVERNED WORK** | Fold relevant AU coverage work into CF-245 only where it serves approved operational-enrichment scope. |
| M245-FU-061 | Runtime operations | Metrics and performance monitoring | **ACTIVE / PARTIAL PASS** | Common ledger/hourly reporting exists; prove it on a fresh CF-245 governed execution and add daily publication/coverage attribution. |
| M245-FU-063 | CF-245 telemetry | Recent successful acquisitions appeared to have no item telemetry and zero canonical mutation authorisation | **RECONCILED / PASS FOR HISTORICAL COHORT** | Pre-created run items were hidden by created-at-only inspection; preserve lifecycle timestamp reporting and validate on a fresh run. |
| M245-FU-064 | CF-245 admission | `canonical_mutation_authorised=false` reason visibility | **PARTIAL PASS** | Historical stop reasons are measurable. Add field-level admission/publication attribution for fresh runs and retain unresolved-domain reason granularity. |
| M245-FU-065 | CF-245 demand | AU/NZ missing/stale enrichment backlog | **PASS / LIVE CLASSIFICATION** | AU: 516 queueable, 2,005 discovery-blocked, 28 policy-blocked, 18,534 discovery+policy, 5,555 outside qualified scope. NZ: 0 queueable; 1,087 discovery/policy; 5,370 outside qualified scope. Keep refreshed from runtime. |
| M245-FU-066 | CF-245 coverage | Pilot-sized refresh-policy footprint | **ACTIVE** | Expand only bounded qualified AU cohorts after PR/runtime reconciliation; NZ remains blocked pending source/profile/discovery/policy qualification. |
| M245-FU-067 | CF-245 publication | Evidence-to-consumer reconciliation | **PARTIAL PASS** | Search projection now verified at 421 official URLs, 161 intake, 161 English, 161 provider tuition. Add explicit per-run publication-delta attribution. |
| M245-FU-068 | CF-245 Admin reporting | Enrichment Operations report/dashboard | **ACTIVE / NEXT IMPLEMENTATION GATE** | Build outcome-focused Enrichment Operations view using ledger/backlog/admission/publication data, with Jobs/Evidence drill-down. |
| M245-FU-069 | CF-245 tuning | Evidence-led dispatcher/provider tuning | **BLOCKED UNTIL COMPARABLE FRESH METRICS** | Do not change frequency/concurrency/routing/retries/cost ceilings until fresh before/after evidence exists. |
| M245-FU-070 | CF-245 bounded URL admission | Qualified RMIT official course URL replay | **PASS / BOUNDED** | 262 decisions = 260 admitted + 2 unchanged; one extra candidate correctly remained unadmitted because regulatory code was not observed. Extend only through separately qualified cohorts. |
| M245-FU-071 | CF-245 repository/runtime reconciliation | Runtime migrations ahead of Pilot main | **ACTIVE / PR #91** | Complete review/CI for `cf-245-enrichment-ops@2feb5be5...`, merge only when green, then recheck migration/runtime currentness. |
| M245-FU-072 | CF-245 Search currentness | Final official URL projection after bounded replay | **PASS** | Governed Search refresh applied; verified official URL coverage 421 with no collateral field delta in final 37-row projection. |
| M245-FU-062 | Country/source expansion | Canada and future countries/sources | **FUTURE / NEW CHANGE CONTROL REQUIRED** | Do not mix Canada/future-country onboarding into CF-245 AU/NZ operational completion unless separately approved. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Production remains unprovisioned. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route material items through Change Control. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Retain targeted → bounded → nominated broad acceptance. |
| M245-FU-011 | H10 | Meeting/status evidence | ACTIVE | Maintain exact heads, runtime/UAT evidence and blockers. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle | OPEN / GOVERNED | Continue separately. |

## Current priority — 15 September 2026

1. CF-093 remains CLOSED / PASS / historical only.
2. Complete PR #91 CI/review and reconcile the three already-applied CF-245 migrations into accepted Pilot history.
3. Implement Gate F Enrichment Operations Admin reporting; keep Scheduled Tasks focused on scheduler health/configuration.
4. Run one fresh bounded governed enrichment cohort and prove end-to-end telemetry and publication attribution.
5. Continue bounded AU coverage expansion only from qualified scope; do not enable NZ or tune scheduler/provider limits from idle ticks.
6. Keep M2.5 paused and Production unprovisioned.
