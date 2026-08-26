# M2.4 Follow-ups / Carry-forward Register

**Purpose:** Prevent unresolved work from being lost when an individual issue blocks a sub-milestone.

## Rules

Every blocked, deferred or newly discovered item must record:
- ID;
- originating sub-milestone;
- date/time;
- problem;
- impact/security/data risk;
- evidence/run/commit reference;
- workaround if any;
- owner/workstream;
- next action;
- target sub-milestone;
- status.

Do not silently drop an item because another issue becomes the immediate focus.

## Seed follow-ups

| ID | Origin | Item | Target | Status |
|---|---|---|---|---|
| M24-FU-001 | M2.4 parent | Complete Go 7 deployed desktop/mobile acceptance and reconcile CF-CHG-20260826-040 before layering further UI changes on an unaccepted candidate. | M2.4.1 entry | OPEN |
| M24-FU-002 | M2.3 | NZ first-party Layer 2 Course enrichment remains deferred pending source qualification/onboarding. Do not represent as implemented during M2.4.2. | Future governed NZ L2 gate | DEFERRED |
| M24-FU-003 | M2.4.1 | Establish explicit AU/NZ regulatory source validation and record-count variance thresholds before unattended schedule enablement. | M2.4.1 | PLANNED |
| M24-FU-004 | M2.4.1/2 | Define transient-job/queue/nonce/temp cleanup and retained Evidence/log lifecycle so housekeeping cannot delete governed provenance. | M2.4.1/2 | PLANNED |
| M24-FU-005 | M2.4.2 | Capture full-run performance, provider economics, Evidence growth and Layer 3 fall-out before tuning schedules/concurrency. | M2.4.2 | PLANNED |
| M24-FU-006 | M2.4.2 | Add operational alerts for stuck jobs, stale sources, provider quota/spend thresholds and abnormal record-count shifts. | M2.4.2/4 | PLANNED |
| M24-FU-007 | M2.4 | Keep Guides, Runbooks, release notes and current-state files synchronized with accepted UI behaviour; documentation lag is a closure blocker. | Every sub-milestone | STANDING |
