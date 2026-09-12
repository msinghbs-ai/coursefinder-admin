# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Exact next action |
|---|---|---|---|---|
| M245-FU-032 | CF-093 / large-university Layer 2 | Historical UQ/RMIT deterministic batches retained; discovery acceptance reopened after terminal-basis hardening | **REOPENED / CORRECTIVE ACCEPTANCE** | After reconstruction sync, rediscover only UQ 54 + RMIT 27 through normal authenticated scheduler and reconcile changed actionable work. |
| M245-FU-033 | CF-093 / repository-runtime currentness | Forward migrations `20260912100539` and `20260912101339` applied/checked in; worker v1.3.9 Edge v27 deployed | **ACTIVE / CURRENT RUNTIME RECONCILED** | Preserve exact identities; do not rewrite/retimestamp applied history. |
| M245-FU-040 | CF-093 / reconstruction P1 | Immutable applied `20260912005948` fails fresh replay because UQ foundation lacks `discovery_strategy` | **P1 / SOURCE REMEDY PREPARED / HISTORY SYNC PENDING** | Bootstrap `20260912005000` now precedes `005948`; authorised CLI must run `supabase migration repair 20260912005000 --status applied --linked`, then prove migration-list parity and fresh db reset. Direct history SQL prohibited. |
| M245-FU-034 | CF-093 / Codex | Nine findings returned on predecessor head; eight forward-fixed/resolved; exact recovery head is `edb115cc...` | **ACTIVE / EXACT-HEAD REVIEW REQUIRED** | Review request `5645499063` is pending. Require a new technical outcome before merge; prior `a7283139...` reviews are not exact-head approval. |
| M245-FU-044 | CF-093 / targeted recovery CI | Dedicated recovery workflow added for exact-token, identity, zero-result, terminal freshness/dedupe and reconstruction contracts | **CLOSED / PASS ON CURRENT HEAD** | Runs `34689908598` and `34690059287` exposed stale assertions; exact-head run `34690128803` PASS. Retain gate for subsequent CF-093 changes. |
| M245-FU-041 | CF-093 / terminal-negative authority | Legacy unqualified `current_page_not_found` suppressed rediscovery | **CORRECTED / ACCEPTANCE REOPENED** | Current hardened snapshots: UQ 54 reopened / 77 terminal; RMIT 27 reopened / 210 terminal. No zero-result markers fabricated. |
| M245-FU-042 | CF-093 / async identity | Old continuation could bind newer run and process stale identity | **CORRECTED / VERIFY IN NEXT AUTHENTICATED RUN** | v1.3.9 + `20260912100539` require exact token and fingerprint revalidation before Evidence write. |
| M245-FU-043 | CF-093 / migration reconstruction proof | Current connector cannot execute official Supabase `migration repair` | **AUTHORISED OPERATOR ACTION PENDING** | Run official CLI repair, then `supabase migration list` and fresh `supabase db reset`; record evidence. Direct SQL history mutation prohibited. |
| M245-FU-035 | CF-093 / Layer 3 | Qualified JWT-protected contract inspected; historical 53-item L3-required cohort predates reopened discovery | **PAUSED BEHIND CF-093 RECOVERY** | Recalculate eligible L3 cohort after corrective discovery/L2 closes; then resume bounded authenticated acceptance if still required. |
| M245-FU-039 | Layer 3 metadata | Runtime `uat_ref=pending-live-provider-uat` remains descriptive drift | **DEFERRED** | Reconcile by governed forward change when Layer 3 resumes. |
| M245-FU-037 | CF-093 / replay-dedupe evidence | Earlier RMIT timing limitation superseded by corrective gate | **SUPERSEDED** | Corrective reopened-scope run should naturally verify current token/dedupe path if timing permits; do not rerun full 500 solely for timing. |
| M245-FU-038 | QA legacy debt | Earlier unrelated stale UAT assertions | **SEPARATE DEBT** | Route under owning QA/release governance. |
| M245-FU-036 | AU qualification wave | Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW | **DEFERRED** | Resume after CF-093 closes; normal qualification only. |
| M245-FU-031 | H4 / CF-092 | Scheduled Tasks configuration and bounded Layer 1–2 run control | CLOSED / PASS | Historical base for CF-093. |
| M245-FU-029 | Architectural hardening / CF-241 | Tooling/typing/domain/PIM hardening | CLOSED / PASS | Retain accepted baseline. |
| M245-FU-028 | UI improvements / CF-242 | Scholarship/QILT/PRISMS/QS/THE/Provider Compare maturity | CLOSED / PASS | Retain accepted baseline. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Update manifest after material accepted changes; Production remains unprovisioned. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route material items through Change Control. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Retain targeted → bounded → nominated broad acceptance. |
| M245-FU-011 | H10 | Meeting/status evidence | ACTIVE | Maintain achieved/failed/next, exact heads, UAT/runtime evidence and blockers. |
| M245-FU-012 | H10 | Interaction/time evidence | ACTIVE | User-confirm billable hours separately. |
| M245-FU-090 | Ranking import recovery | QS latest-edition acceptance | ACTIVE / INDEPENDENT | Continue under owning Change Control. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle | OPEN / GOVERNED | Continue separately. |

## Current priority — 12 September 2026

1. Official Supabase history repair for retroactive bootstrap + migration-list parity + fresh reconstruction proof.
2. Fresh exact-head Codex technical outcome for `edb115cc...`.
3. Authenticated corrective rediscovery: UQ 54 + RMIT 27 only.
4. Reconcile changed deterministic L2 work and prove no generic L3/Layer4 auto-approval/Search/Publication effects.
5. Resume bounded authenticated Layer 3 only after CF-093 recovery passes.
6. Merge/release only when every P1/P2 and exact-head gate is clean.

M2.5 remains paused and Production remains unprovisioned.
