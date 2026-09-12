# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Exact next action |
|---|---|---|---|---|
| M245-FU-032 | CF-093 / large-university Layer 2 | UQ 382-course and RMIT 500-course consequential Layer 2 acceptance complete under Preview-bound discovery, terminal-negative accounting, exact-scope handoff and completion-anchored dedupe | **CLOSED / PASS FOR L2** | Retain UQ/RMIT Jobs/Evidence/metrics as large-university acceptance baseline. |
| M245-FU-033 | CF-093 / repository-runtime migration currentness | PR #72 carries immutable applied migration identities; freshness UAT references applied `20260912031356`; completion dedupe source is `20260912035500` | **CLOSED / RECONCILED** | Preserve immutable applied history; recheck only when new runtime migrations are added. |
| M245-FU-034 | CF-093 / Codex | Exact PR head `a7283139a9e6088933be68fa69f75d2e9eb71fbe` has PASS build `34681032426` and Cloudflare preview, but Codex code-review quota is exhausted | **BLOCKED / TOOL QUOTA** | Obtain exact-head Codex review when quota permits. Quota exhaustion is neither technical approval nor failure; do not merge before the governed review gate is satisfied or formally changed. |
| M245-FU-035 | CF-093 / Layer 3 | 53 current Evidence items are `layer3_required` (3 UQ + 50 RMIT), with 0 existing interpretations. Owning CF-038 is CLOSED/PASS; runtime profile is enabled/unpaused and Pilot-qualified; `layer3-interpret` v9 requires a real user JWT | **AUTHENTICATED LIVE GATE** | Run a deliberately bounded live-provider sample only through an authorised authenticated user/session. Do not use service-role SQL or bypass `auth.getUser()`. Record calls/tokens/cost/latency/validator outcomes and lineage. |
| M245-FU-039 | Layer 3 metadata | Runtime profile/environment `uat_ref` still says `pending-live-provider-uat` despite CF-038 CLOSED/PASS and accepted real-provider benchmark | **METADATA DRIFT** | Reconcile via governed forward change if required by the bounded acceptance; do not directly mutate privileged runtime state. |
| M245-FU-037 | CF-093 / RMIT replay-dedupe evidence | RMIT completion-anchored 30-minute replay/dedupe window elapsed before a second authenticated invocation | **EVIDENCE LIMITATION / NON-BLOCKING FOR L2** | Do not launch another 500-course run solely to recreate expired timing. Retain UQ live replay/dedupe proof + targeted UAT; repeat naturally on a future governed run. |
| M245-FU-038 | CF-093 / CI legacy debt | Intermediate failed run `34677940824` exposed stale unrelated historical assertions as well as the corrected CF-093 migration-reference defect | **SEPARATE DEBT** | Route stale baseline UAT cleanup under owning QA/release governance; do not rewrite unrelated historical tests inside CF-093. |
| M245-FU-036 | CF-093 / AU qualification wave | Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW | **QUEUED AFTER L3/MERGE GATES** | Perform normal profile/policy/discovery-config qualification only; do not fabricate missing configuration. |
| M245-FU-031 | H4 / CF-092 | Scheduled Tasks configuration, audited schedule editing and bounded Layer 1–2 run control | CLOSED / PASS | Historical accepted base for CF-093. |
| M245-FU-029 | Architectural hardening / CF-241 | Four-phase tooling/typing/domain/PIM hardening + forward CF-239 runtime reconciliation | CLOSED / PASS | Retain accepted baseline. |
| M245-FU-028 | UI improvements / CF-242 | Scholarship/QILT/PRISMS/QS/THE/Provider Compare maturity | CLOSED / PASS | Retain accepted baseline. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Update source/target migration manifest after each material accepted change; Production remains unprovisioned. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route material items through Change Control/work-item governance. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Retain targeted → bounded → nominated broad acceptance routing. |
| M245-FU-011 | H10 | Milestone meeting preparation | ACTIVE | Maintain achieved/failed/next, exact heads, UAT/runtime evidence and blockers. |
| M245-FU-012 | H10 | Interaction/time evidence | ACTIVE | User-confirm billable hours separately from technical status. |
| M245-FU-090 | Ranking import recovery | QS ranking recovery / latest-edition acceptance | ACTIVE / INDEPENDENT | Continue under its owning Change Control. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle + Wix handover versioning | OPEN / GOVERNED | Continue separately; do not couple to CF-093 acceptance. |

## Current priority — 12 September 2026

1. Authenticated bounded Course Layer 3 live-provider acceptance for eligible UQ/RMIT Evidence.
2. Record Layer 3 telemetry and reconcile stale Layer 3 UAT metadata through forward governance if required.
3. Exact-head Codex review when code-review quota permits.
4. Keep exact-head CI/UAT/runtime clean; merge/release only when all required gates pass.
5. Continue normal AU university qualification wave after CF-093 closes.

M2.5 remains paused and Production remains unprovisioned.
