# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Exact next action |
|---|---|---|---|---|
| M245-FU-032 | CF-093 / large-university Layer 2 | UQ 382-course consequential acceptance retried all 226 Preview-bound discovery Courses but only 5 produced selected current URLs; 115 current_page_not_found, 79 identity_mismatch, 27 ambiguous; final pg_net `5759` HTTP 500 fail-closed; no deterministic Layer 2 handoff | **BLOCKED / RECOVERY** | Qualify/correct UQ first-party discovery/search + identity confirmation from retained Jobs/Evidence; preserve CRICOS/detail verification and fail-closed semantics; rerun UQ only after failed binding is no longer active. RMIT remains gated. |
| M245-FU-033 | CF-093 / repository-runtime migration currentness | PR #72 uses repository migration filenames `20260912010000`–`20260912010400` while Pilot runtime already records the logical changes under immutable `20260911231544`, `20260911231600`, `20260911231845`, `20260911232205`, `20260911232239` identities | **BLOCKED BEFORE MERGE** | Reconcile repository source identity to runtime truth without deleting, rewriting or retimestamping applied Pilot migrations; rerun exact-head CI/UAT and Codex after any branch change. |
| M245-FU-034 | CF-093 / Codex | PR #72 exact head `692ba7ef93e19d833963d96dab2558b340eaea17` has PASS Frontend Build `34657854675` and successful Cloudflare preview, but no fresh Codex review result is present | **PENDING** | Request/obtain Codex review only on the final exact head after corrective work; no merge before clean result. |
| M245-FU-035 | CF-093 / Layer 3 | Existing pilot-qualified Course interpretation profile is available, but generic scheduler Layer 3 remains prohibited and UQ Layer 2 did not hand off | **GATED** | After clean UQ/RMIT Layer 2 Evidence, run only the existing Evidence/profile/model/revalidation contract applicable to eligible Evidence; retain live-provider UAT as its own gate. |
| M245-FU-036 | CF-093 / AU qualification wave | Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW | **QUEUED AFTER UQ/RMIT** | Perform normal profile/policy/discovery-config qualification in order; do not fabricate missing config to satisfy cohort membership. |
| M245-FU-031 | H4 / CF-092 | Scheduled Tasks configuration, audited schedule editing and bounded Layer 1–2 run control | CLOSED / PASS | Historical accepted base for CF-093; do not reopen unless a separate defect is reproduced. |
| M245-FU-029 | Architectural hardening / CF-241 | Four-phase tooling/typing/domain/PIM hardening + forward CF-239 runtime reconciliation | CLOSED / PASS | Retain accepted baseline. |
| M245-FU-028 | UI improvements / CF-242 | Scholarship/QILT/PRISMS/QS/THE/Provider Compare maturity | CLOSED / PASS | Retain accepted baseline. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Update source/target migration manifest after each material accepted change; target remains pending because no Production project exists. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route each material item through Change Control/work-item governance. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Keep targeted → bounded → nominated broad acceptance routing; avoid unnecessary full-suite repeats. |
| M245-FU-011 | H10 | Milestone meeting preparation | ACTIVE | Maintain achieved/failed/next, exact heads, UAT/runtime evidence and blockers. |
| M245-FU-012 | H10 | Interaction/time evidence | ACTIVE | User-confirm billable hours separately from technical status. |
| M245-FU-090 | Ranking import recovery | QS ranking recovery / latest-edition acceptance | ACTIVE / INDEPENDENT | Continue only under its owning current Change Control; generic ARWU/Diversity ETL remains deferred roadmap work. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle + Wix handover versioning | OPEN / GOVERNED | Continue separately; do not couple to CF-093 acceptance. |

## Current priority — 12 September 2026

1. CF-093 UQ discovery qualification recovery.
2. PR #72 repository/runtime migration identity reconciliation.
3. Fresh UQ consequential acceptance.
4. On UQ PASS, RMIT 500-course proof.
5. Bounded existing Layer 3 acceptance after clean Layer 2 Evidence.
6. Exact-head Codex/CI/UAT/runtime gate, then merge/deploy only if clean.

M2.5 remains paused and Production remains unprovisioned.
