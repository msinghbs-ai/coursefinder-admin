# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Exact next action |
|---|---|---|---|---|
| M245-FU-032 | CF-093 / large-university Layer 2 | Historical UQ/RMIT batches retained; discovery acceptance remains reopened | **REOPENED / BLOCKED BY CODEX RECOVERY** | Do not redispatch until exact-token provenance, post-fetch identity revalidation, terminal accounting and handoff defects are forward-fixed. |
| M245-FU-033 | CF-093 / repository-runtime currentness | Runtime tracks `20260912005000`, `005948`, `100539`, `101339`; branch exact head `1a2caf...` | **ACTIVE / CURRENTNESS RECONCILED** | Preserve immutable migration identities; apply only new forward migrations for semantic corrections. |
| M245-FU-040 | CF-093 / reconstruction | Retroactive UQ bootstrap is now present in runtime history and limited UQ fixture replay passes | **P1 / PARTIAL PROOF ONLY** | Extend Fresh Reconstruction from the two-migration fixture to the complete ordered CF-093 migration chain. |
| M245-FU-034 | CF-093 / Codex | Fresh exact-head review returned further actionable P1/P2 findings | **ACTIVE / MERGE BLOCKER** | Resolve all exact-head findings with smallest safe forward-only changes; then request another exact-head Codex review. |
| M245-FU-044 | CF-093 / targeted recovery CI | CF-093 Targeted Recovery `34693956788` PASS on exact head | **PASS / RETAIN GATE** | Re-run after material fixes; green targeted CI alone is not acceptance while Codex/runtime findings remain. |
| M245-FU-045 | CF-093 / exact-token provenance | Handoff accepts candidates by course/profile/time without proving exact Preview-token provider-job provenance | **P1 / OPEN** | Join/validate accepted discovery outcomes through the provider attempt/job carrying the bound `scheduler_preview_token`. |
| M245-FU-046 | CF-093 / write-time identity | Binding identity can change after pre-fetch validation and before committed Evidence/candidate writes | **P1 / OPEN** | Revalidate immediately before first write or make the write path atomically token-aware. |
| M245-FU-047 | CF-093 / bound handoff | Missing/cancelled exact binding may fall through to unbound deterministic dispatch | **P1 / OPEN** | Fail closed whenever a Preview token was supplied and the exact active/handoff binding cannot be found. |
| M245-FU-048 | CF-093 / async dedupe | A direct completed profile can dedupe a sibling `discovery_started` profile that never produced a reusable handoff batch | **P2 / OPEN** | Require every async profile in the prior dispatch to have a reusable terminal handoff state before returning a completion anchor. |
| M245-FU-049 | CF-093 / terminal-only accounting | Terminal-only/mixed scopes can leave bindings active or roll back actionable siblings | **P2 / OPEN** | Add successful terminal-only completion/no-op accounting and consistent mixed-profile dispatch semantics. |
| M245-FU-050 | CF-093 / terminal basis | Worker candidate metadata/version does not yet satisfy hardened `current_page_not_found` freshness predicate | **P2 / OPEN** | Persist actual qualified result-page/zero-result basis and align predicate to deployed worker contract. |
| M245-FU-051 | CF-093 / title identity | Prefix-stripping can downgrade exact canonical-title matches | **P1 / OPEN** | Score exact matches against both original and prefix-stripped expected titles. |
| M245-FU-052 | CF-093 / provider telemetry | Qualified zero-result attempt can be overwritten from `extraction_failed/discovery_zero_results` to generic success | **P2 / OPEN** | Do not re-finish the retained zero-result provider attempt as ordinary success. |
| M245-FU-053 | CF-093 / acceptance workflow | Consequential acceptance has response-shape, exact-deploy-SHA and trigger-coverage gaps | **P1 / OPEN** | Assert `dispatch.result.status`; prove served commit equals `GITHUB_SHA`; trigger on all relevant implementation paths. |
| M245-FU-054 | CF-093 / cancellation audit | Idempotent cancel replay can overwrite original cancellation timestamp/reason | **P2 / OPEN** | Preserve first audit values when no binding state changes; record replay separately if required. |
| M245-FU-041 | CF-093 / terminal-negative authority | Legacy unqualified terminal negatives were invalidated by forward hardening | **CORRECTED / REVERIFY AFTER NEW FIXES** | Do not fabricate zero-result markers; remeasure UQ/RMIT scope after exact-head fixes land. |
| M245-FU-042 | CF-093 / async identity | Earlier stale continuation identity defect had forward hardening | **REOPENED AT WRITE-TIME BOUNDARY** | Keep existing pre-fetch checks and add post-fetch/pre-write bound identity proof. |
| M245-FU-035 | CF-093 / Layer 3 | Qualified JWT-protected contract remains separate; historical L3-required cohort predates reopened discovery | **PAUSED** | Recalculate only after CF-093 deterministic Layer 2 acceptance closes. |
| M245-FU-036 | AU qualification wave | Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW | **DEFERRED** | Resume after CF-093 closes; normal qualification only. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Update manifest after material accepted changes; Production remains unprovisioned. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route material items through Change Control. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Retain targeted → bounded → nominated broad acceptance. |
| M245-FU-011 | H10 | Meeting/status evidence | ACTIVE | Maintain achieved/failed/next, exact heads, UAT/runtime evidence and blockers. |
| M245-FU-012 | H10 | Interaction/time evidence | ACTIVE | User-confirm billable hours separately. |
| M245-FU-090 | Ranking import recovery | QS latest-edition acceptance | ACTIVE / INDEPENDENT | Continue under owning Change Control. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle | OPEN / GOVERNED | Continue separately. |

## Current priority — 13 September 2026

1. Resolve exact-head Codex P1/P2 findings with forward-only changes.
2. Upgrade reconstruction proof to replay the complete CF-093 migration chain.
3. Correct authenticated acceptance evidence for exact response shape, exact Cloudflare SHA and relevant exact-head triggers.
4. Re-run exact-head targeted CI/reconstruction/build and obtain clean Codex review.
5. Only then run bounded UQ/RMIT corrective rediscovery and changed deterministic Layer 2 reconciliation.
6. Resume bounded Layer 3 only after CF-093 closes.
7. Merge/release only when every exact-head runtime, UAT, security/authority and governance gate is clean.

M2.5 remains paused and Production remains unprovisioned.