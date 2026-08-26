# CF-CHG-20260826-042 — M2 Automated UAT, Navigation & Integration Discipline

**Status:** APPLIED — GOVERNANCE BASELINE / VALIDATED BY M2.4.0  
**Category:** 00-governance-programme  
**Initiated:** 26 August 2026 18:00 AEST (+10:00)  
**Validated:** 26 August 2026 20:43 AEST (+10:00)  
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
- CI uses targeted → integration → acceptance tiers;
- UX/performance screenshot auditing is a separate lightweight evidence workflow;
- A-level addenda are permanent rules, while Go identifiers remain execution checkpoints.

## M2.4 consequence

M2.4.0 was inserted as the mandatory cleanup/integration rebase before M2.4.1. M2.4.1 Layer 1 and M2.4.2 Layer 2 user-directed plans remain authoritative after cleanup.

## Implementation evidence

- `project-runsheets/milestone-2/EXECUTION-ADDENDA-A1-A6.md`;
- `project-runsheets/milestone-2/m2.4/m2.4.0/RUNSHEET.md`;
- `project-runsheets/milestone-2/m2.4/prompts/*`;
- updated `PROJECT_INSTRUCTIONS.md`;
- updated M2 `STANDING-INSTRUCTIONS.md`;
- Pilot `tests/uat/support/navigation.mjs` shared primary-navigation adapters;
- Pilot `.github/workflows/deployed-uat.yml` targeted/integration/acceptance tier resolution;
- Pilot `.github/workflows/m2-4-ux-audit.yml` lightweight audit separation.

## Technical validation — M2.4.0

The governance model has now been exercised end-to-end rather than remaining a paper rule.

### Targeted stage

Working implementation SHA `ecc81dfbf5e6e985eb84b4974c50b0657aac10a0`, run `32954022764`:

- desktop `98131600073` — PASS;
- mobile `98131600295` — PASS.

### Bounded integration stage

Integration marker SHA `70244120258cf47d25575bc8af4dbb71fee0daf3`, run `32958008107`:

- desktop `98143894774` — PASS;
- mobile `98143894861` — PASS.

A real performance regression was discovered during this stage rather than hidden by retry or threshold relaxation. Desktop first `courses_page` originally exceeded the unchanged 3,000 ms budget. The implementation was corrected by sequencing Course page data before filter metadata; retained integration evidence then measured `courses_page` at 1,985 ms. The threshold remained 3,000 ms.

### Full acceptance stage

One acceptance SHA was nominated only after targeted and integration were green:

`ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`

- build `32958795576` — PASS;
- full deployed UAT `32958795547` — PASS;
- desktop `98146317262` — PASS;
- mobile `98146317373` — PASS.

This validates A1/A4 in practice: active development did not repeatedly invoke the complete permanent matrix, and the final full matrix ran only after the bounded gates were satisfied.

## Navigation/test outcome

- permanent acceptance no longer depends on the removed `Layer 2 Operations` alias or floating intelligence/provider launchers;
- shared navigation adapters own workspace opening;
- accepted Layer 1 traversal uses primary `Data Operations → Layer 1 — Regulatory` rather than exposing generic Settings as the normal operator path;
- Platform Settings/destructive authority remains separately privileged;
- deterministic navigation failure handling is bounded;
- the coupled page-content/UX audit is separated from permanent functional acceptance.

## Security / authority outcome

This governance change and its M2.4.0 implementation introduced no database DDL and did not weaken RLS, grants, role/rank enforcement, Edge authentication, Vault/provider credential boundaries, private Evidence or Layer/Search authority merely to achieve PASS.

## Rollback

Governance rollback would require reverting this record and A1–A6 plus the associated CI/test architecture. Runtime semantics are otherwise unaffected by the governance record itself. The accepted M2.4.0 browser/runtime has its own rollback path documented under CF-CHG-20260826-040 and the M2.4.0 runsheet.

## Closure / standing status

**Status:** APPLIED — GOVERNANCE BASELINE / VALIDATED BY M2.4.0.  
This Change Control remains a standing programme baseline rather than being retired after one milestone. Its staged-testing rules apply to M2.4.1 and later work unless explicitly superseded by newer accepted governance.
