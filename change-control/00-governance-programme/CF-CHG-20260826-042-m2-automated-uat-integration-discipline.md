# CF-CHG-20260826-042 — M2 Automated UAT, Navigation & Integration Discipline

**Status:** APPLIED — GOVERNANCE BASELINE  
**Category:** 00-governance-programme  
**Initiated:** 26 August 2026 18:00 AEST (+10:00)  
**Origin:** M2.4 Go 7 post-stop review  
**Owner:** CourseFinder programme governance

## Trigger

Go 7 changed the accepted Admin information architecture, but inherited permanent UAT suites still hard-coded removed `Layer 2 Operations` and floating `M2.3 Intelligence` launch paths. The new navigation tests passed, while the full matrix accumulated approximately 45–50 second deterministic selector waits and retries across many suites. Repeated full matrices during active development disrupted momentum and made UI integration changes unnecessarily expensive.

## Decision

Adopt `project-runsheets/milestone-2/EXECUTION-ADDENDA-A1-A6.md` as permanent M2 execution governance.

Key decisions:

- automated UAT remains mandatory;
- active development uses targeted validation first;
- coherent slices use bounded integration regression second;
- the complete deployed desktop/mobile matrix runs only for a nominated acceptance candidate;
- accepted operational features and permanent UAT use primary navigation, not floating launchers/hidden Settings paths;
- shared navigation/test adapters replace distributed hard-coded launch logic;
- CI should evolve toward targeted → integration → acceptance tiers;
- UX/performance screenshot auditing is a separate lightweight evidence workflow;
- A-level addenda are permanent rules, while Go identifiers remain execution checkpoints.

## M2.4 consequence

Insert mandatory M2.4.0 cleanup/integration rebase before M2.4.1. M2.4.1 Layer 1 and M2.4.2 Layer 2 user-directed plans remain authoritative after cleanup.

Current Pilot post-Go7 commits through `c63442ea9ae44382b88f17fd0e01974cf5c6b469` are unaccepted working state until M2.4.0 reconciles them and nominates one accepted SHA.

## Implementation evidence

- `project-runsheets/milestone-2/EXECUTION-ADDENDA-A1-A6.md`;
- `project-runsheets/milestone-2/m2.4/m2.4.0/RUNSHEET.md`;
- `project-runsheets/milestone-2/m2.4/prompts/*`;
- updated `PROJECT_INSTRUCTIONS.md`;
- updated M2 `STANDING-INSTRUCTIONS.md`;
- updated M2.4 plan/current-state/follow-ups/next-chat/runsheet.

## Validation

Governance validation only. No runtime/schema/security authority is changed by this record. M2.4.0 will provide the technical acceptance evidence for the cleaned navigation/test architecture.

## Rollback

Revert this governance record and referenced instruction/plan documents. Runtime code is unaffected by this Change Control itself.

## Closure

**Status:** APPLIED — M2.4.0 is the mandatory next technical gate; full-matrix-as-development-loop is no longer accepted practice.
