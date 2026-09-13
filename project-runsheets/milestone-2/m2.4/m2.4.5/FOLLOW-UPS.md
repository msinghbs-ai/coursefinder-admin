# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Exact next action |
|---|---|---|---|---|
| M245-FU-032 | CF-093 / large-university Layer 2 | Historical UQ/RMIT acceptance remains reopened | **READY FOR CORRECTIVE ACCEPTANCE** | Run authenticated UQ corrective acceptance first; RMIT only after UQ is clean. |
| M245-FU-033 | CF-093 / repo-runtime currentness | PR #72 exact head `a035714aa5bd9b4d88ae47a59c877b3514a1f287`; accepted main unchanged | **CURRENT** | Preserve immutable migration identities and keep runtime/source aligned. |
| M245-FU-040 | CF-093 / reconstruction | Complete ordered PR-added CF-093 migration chain replay | **PASS** | Retain exact-head run `34726688865`; rerun after any migration change. |
| M245-FU-034 | CF-093 / Codex | Exact-head review comment `5649541094`, reviewed `a035714aa5` | **PASS / CLEAN** | Reopen only if acceptance requires an implementation change, then request Codex again on the new exact head. |
| M245-FU-044 | CF-093 / targeted recovery CI | Exact-head Targeted Recovery `34726688848` | **PASS** | Rerun after material implementation/test changes. |
| M245-FU-045 | CF-093 / exact-token provenance | Exact Preview provenance through provider attempt/job | **FORWARD-FIXED / CODEX CLEAN** | Confirm naturally during UQ corrective acceptance. |
| M245-FU-046 | CF-093 / write-time identity | Post-network/pre-Evidence bound-identity revalidation | **FORWARD-FIXED / CODEX CLEAN** | Confirm no stale writes in acceptance evidence. |
| M245-FU-047 | CF-093 / bound handoff | Missing/cancelled exact binding cannot fall through to unbound dispatch | **FORWARD-FIXED / CODEX CLEAN** | Keep fail-closed contract; verify if exercised. |
| M245-FU-048 | CF-093 / async dedupe | Every discovery-started profile requires reusable async completion | **FORWARD-FIXED / CODEX CLEAN** | Verify completion-aware dedupe after corrective run. |
| M245-FU-049 | CF-093 / terminal-only accounting | Terminal-only + mixed actionable/terminal completion | **FORWARD-FIXED / CODEX CLEAN** | Confirm naturally in corrective acceptance. |
| M245-FU-050 | CF-093 / terminal basis | Qualified terminal metadata/version basis | **FORWARD-FIXED / CODEX CLEAN** | Confirm only genuinely qualified terminal outcomes suppress rediscovery. |
| M245-FU-051 | CF-093 / title identity | Original + prefix-stripped exact title matching | **FORWARD-FIXED / CODEX CLEAN** | Confirm against corrective discovery Evidence. |
| M245-FU-052 | CF-093 / provider telemetry | Qualified `discovery_zero_results` preserved | **FORWARD-FIXED / CODEX CLEAN** | Confirm provider attempt is not refinalised as generic success. |
| M245-FU-053 | CF-093 / acceptance workflow | Nested result status / exact deployment / exact-head evidence | **READY / CONSEQUENTIAL RUN PENDING** | Dispatch maintained UQ acceptance workflow or equivalent normal authenticated Admin/PIM path; do not substitute direct DB execution. |
| M245-FU-054 | CF-093 / cancellation audit | First cancellation timestamp/reason preserved | **FORWARD-FIXED / CODEX CLEAN** | Verify idempotent replay if exercised. |
| M245-FU-041 | CF-093 / terminal-negative authority | Legacy unqualified negatives invalidated; no markers fabricated | **CORRECTED / ACCEPTANCE PENDING** | Remeasure UQ/RMIT from fresh authenticated Previews. |
| M245-FU-035 | CF-093 / Layer 3 | Separate JWT-protected Layer 3 contract | **PAUSED** | Recalculate only after deterministic L2 acceptance closes. |
| M245-FU-036 | AU qualification wave | Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW | **DEFERRED** | Resume after CF-093 closes; normal qualification only. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Update manifest only after accepted changes; Production remains unprovisioned. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route material items through Change Control. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Retain targeted → bounded → nominated broad acceptance. |
| M245-FU-011 | H10 | Meeting/status evidence | ACTIVE | Maintain exact heads, UAT/runtime evidence and blockers. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle | OPEN / GOVERNED | Continue separately. |

## Current priority — 13 September 2026

1. Run the authenticated UQ corrective acceptance on exact head `a035714...` and capture Preview/dispatch evidence.
2. Reconcile only newly selected/changed deterministic UQ Layer 2 work and prove exact-token/fingerprint/dedupe plus zero unauthorised Layer3/Layer4/Search/Publication side effects.
3. Run bounded RMIT corrective acceptance only after UQ is clean.
4. If acceptance exposes a reproducible implementation defect, forward-fix it and rerun Targeted Recovery, full reconstruction, Frontend Build, Cloudflare currentness and Codex on the new exact head.
5. Layer 3, merge and release remain paused until CF-093 deterministic acceptance closes.

M2.5 remains paused and Production remains unprovisioned.