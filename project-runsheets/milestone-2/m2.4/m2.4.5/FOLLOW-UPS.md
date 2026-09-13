# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Exact next action |
|---|---|---|---|---|
| M245-FU-032 | CF-093 / large-university L2 | UQ/RMIT corrective acceptance | **BLOCKED** | Obtain clean exact-head Codex verdict, deploy exact repo worker, then dispatch NEW UQ acceptance; RMIT only after UQ clean. |
| M245-FU-033 | CF-093 / repo-runtime currentness | PR #72 exact head `4e67e32289235a88297502e90c8181f25639f300` | **CLEAN** | Preserve applied migration identities `20260913063252` / `20260913063321`; no alias reintroduction. |
| M245-FU-040 | CF-093 / reconstruction | Complete ordered CF-093 migration replay | **PASS** | Run `34743276592` passed through applied `063252` + `063321`; rerun after any further migration change. |
| M245-FU-034 | CF-093 / Codex | Fresh exact-head review | **EXTERNAL BLOCKER / MERGE BLOCKER** | Codex reports repo environment prerequisite; enable/create environment then obtain clean verdict for `4e67e322...`. |
| M245-FU-044 | CF-093 / targeted recovery CI | Exact-head targeted contracts | **PASS** | `34743276597` passed including identity-freshness and handoff queueable-provenance regressions. |
| M245-FU-045 | CF-093 / Frontend + smoke | Exact-head build/local browser smoke | **PASS** | `34743276603` passed; Cloudflare exact-head preview also deployed. |
| M245-FU-055 | CF-093 / continuation recovery | failed/candidate remain bounded-retryable | **FIXED / TESTED** | Preserve terminal-status-only consumption. |
| M245-FU-056 | CF-093 / detail identity drift | Fail closed before candidate write | **FIXED / TESTED** | Deploy exact repo worker only after Codex clean. |
| M245-FU-057 | CF-093 / Preview resolver provenance | Selected candidate must carry exact Preview token | **APPLIED / TESTED** | Applied migration `20260913063252`; verify naturally in UQ acceptance. |
| M245-FU-058 | CF-093 / terminal freshness | Layer 1 identity changes invalidate terminal freshness | **APPLIED / TESTED** | Applied migration `20260913063252`; verify naturally in UQ acceptance. |
| M245-FU-059 | CF-093 / mixed handoff | Preserve pre-existing queueable URLs outside discovery subset | **APPLIED / TESTED** | Applied migration `20260913063321`; verify naturally in UQ acceptance. |
| M245-FU-060 | CF-093 / worker deployment | Pilot Edge v29 predates latest repo fixes | **BLOCKED BY CODEX** | After clean review, deploy exact worker with `verify_jwt=false`, retain one-time nonce, verify source/SHA. |
| M245-FU-053 | CF-093 / UQ workflow | NEW workflow_dispatch required | **TOOLING BLOCKER AFTER DEPLOYMENT** | Connected GitHub toolset has reads/reruns but no new dispatch action; use authorised GitHub UI/API dispatch when worker/review gates are clean. Do not use direct SQL/RPC. |
| M245-FU-035 | CF-093 / Layer 3 | Separate governed Layer 3 | **PAUSED** | Recalculate only after deterministic L2 acceptance closes. |
| M245-FU-036 | AU qualification wave | Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW | **DEFERRED** | Resume after CF-093 closes. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Production remains unprovisioned. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route material items through Change Control. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Retain targeted → bounded → nominated broad acceptance. |
| M245-FU-011 | H10 | Meeting/status evidence | ACTIVE | Maintain exact heads, runtime/UAT evidence and blockers. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle | OPEN / GOVERNED | Continue separately. |

## Current priority — 13 September 2026

1. Satisfy Codex repo-environment prerequisite and obtain clean exact-head review for `4e67e322...`.
2. Deploy/verify exact repo discovery worker to Pilot while retaining `verify_jwt=false` and the custom nonce boundary.
3. Dispatch a **new** authenticated UQ corrective acceptance via maintained workflow on that exact reviewed/deployed head; RMIT only after UQ clean.
4. Keep Layer 3, merge and release paused until consequential acceptance closes.

M2.5 remains paused and Production remains unprovisioned.