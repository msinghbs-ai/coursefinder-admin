# M2.4 Current State

**Status:** ACTIVE — M2.4.0 CLEANUP / INTEGRATION REBASE REQUIRED BEFORE FEATURE EXPANSION  
**Updated:** 26 August 2026 18:00 AEST  
**Active Change Controls:** CF-CHG-20260826-040, CF-CHG-20260826-042

## Accepted baseline

- M1 CLOSED/PASS/FROZEN.
- M2.1 CLOSED/PASS.
- M2.2 CLOSED/PASS.
- M2.3 CLOSED/PASS with NZ first-party Layer 2 expansion deferred.
- Last fully accepted pre-M2.4 Pilot runtime: `260ed6a0d19b80ad666d74b90aa13e735e802a6a`.

## Go 7 working state

PIM Admin v2.15.6 streamlined information architecture is implemented in working source:

1. Overview;
2. Catalogue;
3. Data Operations;
4. Insights;
5. Quality & Review;
6. Decision Tools;
7. Governance & Platform;
8. Help & Guides.

The navigation-specific Go 7 tests passed, but full deployed UAT on `eabb7d99f93acf6260c06b33c852ed4b0bb6fd8a` failed because inherited permanent suites still searched for removed `Layer 2 Operations` and floating `M2.3 Intelligence` launch paths. The failures accumulated approximately 45–50 second selector waits/retries across many tests, creating a long disruptive matrix.

This is classified as **test/integration architecture liability**, not permission to restore floating launchers or legacy menu labels.

## Post-stop Pilot working tree

The Pilot repository subsequently contains test/audit work through `c63442ea9ae44382b88f17fd0e01974cf5c6b469`, including shared-compatibility/navigation test changes and page-content audit work. These commits are **UNACCEPTED WORKING STATE** until M2.4.0 reconciles them. Do not assume their full deployed acceptance simply because they are on `main`.

## Permanent execution correction

The programme now inherits:

- `project-runsheets/milestone-2/EXECUTION-ADDENDA-A1-A6.md`;
- mandatory M2.4.0 cleanup gate;
- targeted → integration → one nominated full acceptance matrix;
- primary-navigation-only permanent UAT;
- shared navigation/test adapters;
- lightweight UX/performance evidence collection separate from full functional acceptance.

## Existing M2.4 plan preserved

After M2.4.0 PASS:

1. M2.4.1 — Layer 1 Regulatory Operations Maturity & Automation;
2. M2.4.2 — Layer 2 Full Enrichment, Operations Maturity & Performance;
3. M2.4.3 — Layer 3 AI Operations Maturity;
4. M2.4.4 — Cross-layer Operations, Housekeeping, Scheduling & Pre-blackout Acceptance.

M2.4.1/2 remain the core user-directed plan; they are delayed only until cleanup removes the integration liability.

## Documentation/evidence already retained

- Admin Navigation IA v1.4;
- M2.4 Data Operations Admin Guide v1.1;
- Go 7 performance/content audit and retained screenshots;
- Milestone 2 meeting progress record;
- M2 Standing Instructions;
- A1–A6 execution addenda;
- dedicated M2.4 prompt pack.

## Immediate next gate

Execute **M2.4.0 only**:

1. reconcile all post-Go7 Pilot commits and latest CI state;
2. inventory obsolete navigation/floating-launcher dependencies;
3. introduce/finish shared navigation adapters;
4. migrate permanent suites without weakening their functional/security assertions;
5. remove/quarantine floating operational launchers from accepted architecture;
6. run targeted desktop/mobile tests;
7. run bounded affected integration suites;
8. only then nominate one SHA for one full deployed desktop/mobile acceptance matrix;
9. reconcile CF-CHG-040 and current governance to the accepted checkpoint;
10. hand off to M2.4.1.

Do not start new Layer 1/2 feature implementation and do not launch a full permanent matrix as the first next action.
