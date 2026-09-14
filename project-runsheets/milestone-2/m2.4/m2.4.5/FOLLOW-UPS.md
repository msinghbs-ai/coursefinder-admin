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
| M245-FU-036 | AU qualification wave | Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW | **AVAILABLE FOR SEPARATE GOVERNED WORK** | Open/use a separate Change Control if this wave is resumed; do not reopen CF-093. |
| M245-FU-061 | Runtime operations | Metrics and performance monitoring | **ACTIVE** | Track real governed workload throughput, latency, retries, Evidence/yield, budget, 429/5xx and terminal outcomes. |
| M245-FU-062 | Country/source expansion | Canada and future countries/sources | **FUTURE / NEW CHANGE CONTROL REQUIRED** | Create a new Change Control per material onboarding wave; reference CF-093 only as historical baseline evidence. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Production remains unprovisioned. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route material items through Change Control. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Retain targeted → bounded → nominated broad acceptance. |
| M245-FU-011 | H10 | Meeting/status evidence | ACTIVE | Maintain exact heads, runtime/UAT evidence and blockers. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle | OPEN / GOVERNED | Continue separately. |

## Current priority — 14 September 2026

1. CF-093 is **CLOSED / PASS** and must not be reopened for future country/source work.
2. Continue evidence-led operational metrics from accepted Pilot v2.15.79.
3. Open a new Change Control for Canada or any future material country/source onboarding wave.
4. Keep dispatcher/provider settings steady until comparable governed evidence supports a change.
5. M2.5 remains paused and Production remains unprovisioned.