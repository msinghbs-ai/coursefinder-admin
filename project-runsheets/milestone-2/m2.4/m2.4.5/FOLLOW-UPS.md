# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Exact next action |
|---|---|---|---|---|
| M245-FU-032 | CF-093 / large-university Layer 2 | Historical UQ/RMIT acceptance remains reopened | **UQ RETRY PENDING** | Run a new authenticated UQ corrective acceptance on current head; RMIT only after UQ is clean. |
| M245-FU-033 | CF-093 / repo-runtime currentness | PR #72 exact head `4cb8da49d7f1c79c6caaad893c1c7361394c4d65`; accepted main unchanged | **CURRENT** | Preserve immutable migration identities and keep runtime/source aligned. |
| M245-FU-040 | CF-093 / reconstruction | Complete ordered PR-added CF-093 migration chain replay | **PASS** | Current-head run `34729795080` PASS; rerun after any migration change. |
| M245-FU-034 | CF-093 / Codex | Previous clean head `a035714...`; fresh review requested for `4cb8da49...` in comment `5649862311` | **PENDING / MERGE BLOCKER** | Reconcile current-head Codex before consequential retry. |
| M245-FU-044 | CF-093 / targeted recovery CI | Exact-head Targeted Recovery `34729795052` | **PASS** | Rerun after material implementation/test changes. |
| M245-FU-045 | CF-093 / exact-token provenance | Exact Preview provenance through provider attempt/job | **FORWARD-FIXED** | Confirm naturally during UQ corrective acceptance. |
| M245-FU-046 | CF-093 / write-time identity | Post-network/pre-Evidence bound-identity revalidation | **FORWARD-FIXED** | Confirm no stale writes in acceptance evidence. |
| M245-FU-047 | CF-093 / bound handoff | Missing/cancelled exact binding cannot fall through to unbound dispatch | **FORWARD-FIXED** | Keep fail-closed contract; verify if exercised. |
| M245-FU-048 | CF-093 / async dedupe | Every discovery-started profile requires reusable async completion | **FORWARD-FIXED** | Verify completion-aware dedupe after corrective run. |
| M245-FU-049 | CF-093 / terminal-only accounting | Terminal-only + mixed actionable/terminal completion | **FORWARD-FIXED** | Confirm naturally in corrective acceptance. |
| M245-FU-050 | CF-093 / terminal basis | Qualified terminal metadata/version basis | **FORWARD-FIXED** | Confirm only genuinely qualified terminal outcomes suppress rediscovery. |
| M245-FU-051 | CF-093 / title identity | Original + prefix-stripped exact title matching | **FORWARD-FIXED** | Confirm against corrective discovery Evidence. |
| M245-FU-052 | CF-093 / provider telemetry | Qualified `discovery_zero_results` preserved | **FORWARD-FIXED** | Confirm provider attempt is not refinalised as generic success. |
| M245-FU-053 | CF-093 / acceptance workflow | First UQ manual run failed at Playwright dispatch step after ~30s; no new UQ runtime binding/dispatch observed | **WORKFLOW CORRECTED / RETRY PENDING** | Current head adds explicit 120s test timeout. Start a new workflow_dispatch on current branch head; do not Re-run the failed older SHA. |
| M245-FU-054 | CF-093 / cancellation audit | First cancellation timestamp/reason preserved | **FORWARD-FIXED** | Verify idempotent replay if exercised. |
| M245-FU-041 | CF-093 / terminal-negative authority | Legacy unqualified negatives invalidated; no markers fabricated | **CORRECTED / ACCEPTANCE PENDING** | Remeasure UQ/RMIT from fresh authenticated Previews. |
| M245-FU-035 | CF-093 / Layer 3 | Separate JWT-protected Layer 3 contract | **PAUSED** | Recalculate only after deterministic L2 acceptance closes. |
| M245-FU-036 | AU qualification wave | Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW | **DEFERRED** | Resume after CF-093 closes; normal qualification only. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Update manifest only after accepted changes; Production remains unprovisioned. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route material items through Change Control. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Retain targeted → bounded → nominated broad acceptance. |
| M245-FU-011 | H10 | Meeting/status evidence | ACTIVE | Maintain exact heads, UAT/runtime evidence and blockers. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle | OPEN / GOVERNED | Continue separately. |

## Current priority — 13 September 2026

1. Reconcile fresh Codex on exact head `4cb8da49...`; current-head Targeted Recovery `34729795052`, Fresh Reconstruction `34729795080`, Frontend Build `34729795073` and Cloudflare deployment are PASS.
2. Start a **new** authenticated UQ corrective acceptance workflow_dispatch on current branch head. Do not use Re-run on the failed attempt because GitHub would rerun the original older SHA.
3. Capture Preview/dispatch evidence and follow UQ discovery to terminal; reconcile only newly selected/changed deterministic L2 and prove zero unauthorised Layer3/Layer4/Search/Publication side effects.
4. Run bounded RMIT corrective acceptance only after UQ is clean.
5. Layer 3, merge and release remain paused until CF-093 deterministic acceptance closes.

M2.5 remains paused and Production remains unprovisioned.