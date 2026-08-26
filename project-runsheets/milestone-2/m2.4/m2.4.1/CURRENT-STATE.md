# M2.4.1 — Current State

**Status:** ACTIVE — targeted UAT correction in progress  
**Change Control:** `CF-CHG-20260826-043`  
**Accepted starting Pilot:** `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`  
**Latest implementation Pilot:** `e6899a893bc89ec18bdf01a151c0e0ee77573946`  
**Latest harness-correction Pilot:** `b58d49294f6b9ad1921443d52c8641bbc2df35e6`

## Implemented

- Additive AU/NZ Layer 1 operations control-plane state for source authority/configuration, expected counts, variance thresholds, queue/idempotency, heartbeat/stuck state, reconciliation, retry/resume cursor, schedule projection and transient retention.
- Browser-facing Layer 1 v2.15.7 workspace structured around Source Health, Current/Next Job, Progress, Reconciliation, Evidence/Provenance, Schedule/Recheck and Blockers/Required Actions.
- Platform Admin source validation/configuration and governed queue/pause/retry controls behind rank gating and progressive disclosure.
- JWT-protected Layer 1 operations controller for AU CRICOS and NZ NZQA authority-domain/source validation and source-count discovery.
- Existing M2.3 scheduler substrate retained as cadence authority; no competing scheduler introduced.
- Security/performance corrections applied during implementation, including queue FK indexes and browser/private-helper grant reconciliation.

## UAT evidence

### Failed targeted run — invalid feedback-loop composition

Pilot `e6899a893bc89ec18bdf01a151c0e0ee77573946`:

- Frontend Build `32962485161`: PASS.
- Deployed UAT `32962485153`: FAIL.
- The workflow incorrectly resolved the targeted tier to 9 permanent suites, executing unrelated Layer 2/3/M2.3/Scholarship tests.
- Run duration was approximately 12 minutes and produced 12 failed / 12 passed logical tests before retries.
- New Layer 1 failures were deterministic navigation-scope failures: `openLayer1()` returned `.m-legacy-host` although the production Layer 1 workspace is the separate `role=dialog` `Layer 1 — Regulatory` surface.
- Anonymous Layer 1 contract negative passed.
- A stale Layer 3 test also hard-coded PIM v2.15.6 while the deployed runtime was correctly v2.15.7.

This run is evidence of a harness defect and is not a valid Stage A pass.

### Harness correction

Pilot `b58d49294f6b9ad1921443d52c8641bbc2df35e6`:

- `openLayer1()` now returns the actual Layer 1 regulatory dialog and verifies its heading.
- Stage A targeted suite is reduced to `tests/uat/layer1-operations-deployed.spec.mjs` only.
- Stage B integration retains Layer 1 plus immediate Admin navigation/Data Quality/performance/screen-state/release-note regression; unrelated Layer 2/3 feature suites remain acceptance-only unless directly affected.
- Targeted mobile remains disabled; integration/acceptance retain mobile.
- Playwright Chromium installation no longer invokes repeated `--with-deps` apt/font setup.
- npm/Playwright cache uses explicit restore/save; save executes even if tests fail.
- stale v2.15.6 assertion in Layer 3 credential UAT replaced with governed runtime-family assertion.

Current deployed run for `b58d4929…` is the active Stage A feedback check and must be green before further feature expansion.

## Current acceptance position

Not eligible for Stage B or Stage C yet.

Outstanding functional proof includes real AU/NZ validation, variance decisions, real queue/progress/reconciliation/Evidence lifecycle, interrupted retry/resume, hash/no-change replay, schedule-to-recheck execution, schedule failure visibility, stuck recovery and housekeeping retention proof.

M2.4.2 feature implementation remains blocked until M2.4.1 is CLOSED/PASS.
