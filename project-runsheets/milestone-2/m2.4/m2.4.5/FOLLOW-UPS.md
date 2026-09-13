# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Exact next action |
|---|---|---|---|---|
| M245-FU-032 | CF-093 / large-university Layer 2 | Historical UQ/RMIT acceptance remains reopened | **BLOCKED BY CURRENT REVIEW FIXES** | Finish exact-head recovery, deploy reviewed worker, then run a new authenticated UQ corrective acceptance; RMIT only after UQ is clean. |
| M245-FU-033 | CF-093 / repo-runtime currentness | PR #72 branch head after new forward migration `8424cf893935df0b1115bd260e23454c74e36e92`; accepted main unchanged | **RECOVERY ACTIVE** | Preserve immutable migration identities; reconcile worker + reconstruction/test changes, then rerun exact-head gates. |
| M245-FU-040 | CF-093 / reconstruction | Full ordered CF-093 migration replay through final accepted migrations was PASS on `af5f9798...`; new migration `20260913062000` now requires inclusion | **RERUN REQUIRED** | Extend ordered replay through `20260913062000_cf_093_bound_resolution_identity_freshness_reconcile.sql` and rerun Fresh Reconstruction. |
| M245-FU-034 | CF-093 / Codex | Fresh review after `af5f9798...` raised three actionable findings | **PENDING / MERGE BLOCKER** | Address all current review findings, then obtain a clean review on the resulting exact head. |
| M245-FU-044 | CF-093 / targeted recovery CI | `34741811302` PASS on `af5f9798...`; branch changed afterward | **RERUN REQUIRED** | Rerun Targeted Recovery after worker/migration/test fixes land. |
| M245-FU-055 | CF-093 / continuation recovery | `failed` and nonterminal `candidate` must remain in bounded continuation | **FORWARD-FIXED IN REPO** | Retain terminal-status-only consumption and verify with exact-head targeted tests. |
| M245-FU-056 | CF-093 / detail-verification identity | Binding identity drift during candidate-detail verification is currently caught as transient candidate | **OPEN P1** | Rethrow/abort exact-binding identity-drift before `layer2_discovery_candidates_write`; preserve transient recovery only for genuine provider/network verification failure. |
| M245-FU-057 | CF-093 / exact Preview resolver provenance | Bound context can suppress discovery from a selected candidate created by another job/token | **FORWARD MIGRATION ADDED / TEST PENDING** | Validate `20260913062000` exact-token job/attempt predicate and cover it in targeted UAT/reconstruction. |
| M245-FU-058 | CF-093 / Layer 1 terminal freshness | Terminal negative can remain fresh after Layer 1 course code/title changes | **FORWARD MIGRATION ADDED / TEST PENDING** | Validate `20260913062000` expected-code/title match and prove identity change reopens discovery. |
| M245-FU-045 | CF-093 / exact-token provenance | Exact Preview provenance through provider attempt/job | **FORWARD-FIXED** | Confirm naturally during UQ corrective acceptance after current recovery closes. |
| M245-FU-046 | CF-093 / write-time identity | Post-network/pre-Evidence bound-identity revalidation | **FORWARD-FIXED; DETAIL CATCH FIX OPEN** | Keep pre-write revalidation fail-closed and close M245-FU-056. |
| M245-FU-047 | CF-093 / bound handoff | Missing/cancelled exact binding cannot fall through to unbound dispatch | **FORWARD-FIXED** | Keep fail-closed contract. |
| M245-FU-048 | CF-093 / async dedupe | Every discovery-started profile requires reusable async completion | **FORWARD-FIXED** | Verify completion-aware dedupe after corrective run. |
| M245-FU-049 | CF-093 / terminal-only accounting | Terminal-only + mixed actionable/terminal completion | **FORWARD-FIXED** | Confirm naturally in corrective acceptance. |
| M245-FU-050 | CF-093 / terminal basis | Qualified terminal metadata/version basis | **FORWARD-FIXED; IDENTITY FRESHNESS HARDENING ADDED** | Confirm only current-identity qualified outcomes suppress rediscovery. |
| M245-FU-051 | CF-093 / title identity | Original + prefix-stripped exact title matching | **FORWARD-FIXED** | Confirm against corrective discovery Evidence. |
| M245-FU-052 | CF-093 / provider telemetry | Qualified `discovery_zero_results` preserved | **FORWARD-FIXED** | Confirm provider attempt is not refinalised as generic success. |
| M245-FU-053 | CF-093 / acceptance workflow | First UQ manual run failed at Playwright dispatch step; no new UQ binding/dispatch observed | **WORKFLOW CORRECTED / RETRY DEFERRED** | Do not retry until current exact-head recovery + deployed worker currentness are clean. |
| M245-FU-054 | CF-093 / cancellation audit | First cancellation timestamp/reason preserved | **FORWARD-FIXED** | Verify idempotent replay if exercised. |
| M245-FU-041 | CF-093 / terminal-negative authority | Legacy/unqualified/stale-identity negatives must not suppress discovery | **CURRENT HARDENING ACTIVE** | Validate new identity-bound freshness migration, then remeasure UQ/RMIT from fresh authenticated Previews. |
| M245-FU-035 | CF-093 / Layer 3 | Separate JWT-protected Layer 3 contract | **PAUSED** | Recalculate only after deterministic L2 acceptance closes. |
| M245-FU-036 | AU qualification wave | Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW | **DEFERRED** | Resume after CF-093 closes; normal qualification only. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Update manifest only after accepted changes; Production remains unprovisioned. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route material items through Change Control. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Retain targeted → bounded → nominated broad acceptance. |
| M245-FU-011 | H10 | Meeting/status evidence | ACTIVE | Maintain exact heads, UAT/runtime evidence and blockers. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle | OPEN / GOVERNED | Continue separately. |

## Current priority — 13 September 2026

1. Complete the three fresh-review corrections: fail-closed detail-verification identity drift, exact Preview-token resolver provenance, and Layer 1 identity-bound terminal freshness.
2. Include new forward migration `20260913062000` in reconstruction and add targeted regression coverage; never edit applied migrations.
3. Rerun Targeted Recovery, Fresh Reconstruction, Frontend Build and verify Cloudflare exact-head currentness.
4. Obtain fresh exact-head Codex clean, then deploy/verify the exact repo worker while preserving the custom nonce/auth boundary (`verify_jwt=false`).
5. Start a new authenticated UQ corrective acceptance only after those gates are clean; RMIT follows only if UQ is clean.
6. Layer 3, merge and release remain paused until CF-093 deterministic acceptance closes.

M2.5 remains paused and Production remains unprovisioned.