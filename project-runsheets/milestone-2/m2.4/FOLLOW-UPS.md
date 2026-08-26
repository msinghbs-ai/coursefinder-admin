# M2.4 Follow-ups / Carry-forward Register

**Purpose:** Prevent unresolved work from being lost when an individual issue blocks a sub-milestone.

## Rules

Every blocked, deferred or newly discovered item must record ID, origin, date/time, problem, impact/security/data risk, evidence/run/commit reference, workaround if any, owner/workstream, next action, target sub-milestone and status.

Do not silently drop an item because another issue becomes the immediate focus.

## Current follow-ups

| ID | Origin | Item | Target | Status |
|---|---|---|---|---|
| M24-FU-001 | Go 7 / M2.4 | Initial full deployed Go 7 acceptance failed because inherited permanent suites referenced removed `Layer 2 Operations` / floating `M2.3 Intelligence` launch paths. Shared primary-navigation adapters now own permanent traversal; final acceptance `32958795547` passed desktop/mobile on `ba846abb…`. | M2.4.0 | CLOSED / PASS |
| M24-FU-008 | Go 7 stop | Post-Go7 Pilot working commits were reconciled through targeted/integration/final acceptance. Current accepted Pilot checkpoint is `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`. | M2.4.0 | CLOSED / PASS |
| M24-FU-009 | Go 7 / CI | Repeated full matrices were replaced by targeted → integration → acceptance tiers under A1/A4. M2.4.0 exercised all three stages successfully. | M2.4.0 | CLOSED / PASS |
| M24-FU-010 | Go 7 / UI | Floating operational launchers were removed from accepted navigation/permanent UAT. Any retained internal bridge is hidden/quarantined implementation detail and must not reappear as a second operator architecture. | M2.4.0 | CLOSED / QUARANTINED |
| M24-FU-011 | Go 7 / UAT | Workspace opening is centralised in shared navigation adapters; deterministic navigation waits were reduced to bounded/fail-fast handling. | M2.4.0 | CLOSED / PASS |
| M24-FU-012 | Go 7 / evidence | Page-content/performance screenshot auditing is separated from full functional acceptance under the lightweight M2.4 UX audit workflow. | M2.4.0 | CLOSED / PASS |
| M24-FU-013 | M2.4.0 performance | First desktop Course navigation contended with Course filter metadata and breached the unchanged 3,000 ms `courses_page` budget. UI sequencing now prioritises Course page data; retained integration evidence measured 1,985 ms without widening the threshold. | M2.4.0 | CLOSED / PASS |
| M24-FU-002 | M2.3 | NZ first-party Layer 2 Course enrichment remains deferred pending source qualification/onboarding. Do not represent as implemented during M2.4.2. | Future governed NZ L2 gate | DEFERRED |
| M24-FU-003 | M2.4.1 | Establish explicit AU/NZ regulatory source validation and record-count variance thresholds before unattended schedule enablement. | M2.4.1 | PLANNED / PRIORITY |
| M24-FU-004 | M2.4.1/2 | Define transient-job/queue/nonce/temp cleanup and retained Evidence/log lifecycle so housekeeping cannot delete governed provenance. | M2.4.1/2 | PLANNED / PRIORITY |
| M24-FU-005 | M2.4.2 | Capture full-run performance, provider economics, Evidence growth and Layer 3 fall-out before tuning schedules/concurrency. | M2.4.2 | PLANNED |
| M24-FU-006 | M2.4.2 | Add operational alerts for stuck jobs, stale sources, provider quota/spend thresholds and abnormal record-count shifts. | M2.4.2/4 | PLANNED |
| M24-FU-007 | M2.4 | Keep Guides, Runbooks, release notes and current-state files synchronized with accepted UI behaviour; documentation lag is a closure blocker. | Every sub-milestone | STANDING |

## M2.4.0 evidence summary

- targeted SHA `ecc81dfbf5e6e985eb84b4974c50b0657aac10a0`, run `32954022764` — desktop/mobile PASS;
- integration SHA `70244120258cf47d25575bc8af4dbb71fee0daf3`, run `32958008107` — desktop/mobile PASS;
- final acceptance SHA `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`, build `32958795576`, deployed UAT `32958795547` — desktop/mobile PASS.

Review M24-FU-003, M24-FU-004 and standing M24-FU-007 at the start of M2.4.1.
