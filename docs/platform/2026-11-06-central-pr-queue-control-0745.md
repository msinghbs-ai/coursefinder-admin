<!-- Recorded verbatim by the Integration Controller. Received 6 Nov 2026 07:45 (Australia/Melbourne). -->

StudySearch — Central PR Queue Control and Safe Housekeeping

Platform Admin direction — 6 November 2026

Continue parallel Claude-agent development, but stop unnecessary growth of the integration queue.

The objective is to finish working features, not accumulate PRs or release numbers.

1. Establish one authoritative PR queue

Reconcile all open and draft PRs against current main and production.

For each PR record:

- Author and current owner.
- Purpose and workstream.
- Whether implementation is complete.
- Whether useful code is already in main.
- Current tests and CI.
- Migration and function dependencies.
- Overlap with other PRs.
- Required approval.
- Next action.

Use the existing Admin execution register.

2. Codex PR housekeeping

Codex is no longer an active development contributor.

Review every remaining Codex-created PR.

Close without merging only when the PR is obsolete, duplicated, superseded or contains no needed implementation.

Preserve useful work and tests.

Do not remove a completed feature because Codex authored it.

Do not delete branches containing unique unmerged code.

Record closure reasons and replacement PR references.

3. Limit new PR creation

Before creating a PR, check whether:

- The feature already has a PR.
- Another Claude agent owns the same functions.
- The implementation is already in main.
- The change can be completed within the existing feature PR.
- It conflicts with a queued migration or automation plan.

Prefer updating the existing PR over opening another one.

Do not create a separate PR solely for small corrections found before the feature merges.

4. Release order

First complete the already-authorised PR #891 production acceptance.

Then prioritise:

1. #889 — Intake Automation Progress.
2. #877 — Provider descriptions.
3. #890 — R23/R24 API, after G3 approval.
4. #875 — AER selector, after its hold is separately resolved.

This is the preferred sequence, subject to confirmed dependencies and P0 production incidents.

Only one production release at a time.

Do not automatically merge any PR not covered by an existing explicit authorisation.

5. Parallel development

Continue independent engineering workstreams where code ownership does not overlap.

Do not block development simply because another feature awaits deployment.

Use a separate agent for integration and independent validation.

Ensure each PR includes the complete vertical capability, tests, operational visibility and acceptance procedure.

6. Queue-size control

Adopt these operating rules:

- One active implementation PR per bounded capability.
- No duplicate PR for the same unresolved defect.
- No speculative releases to discover production behaviour.
- No new general framework while an existing mechanism can be extended.
- No stale branch left without a documented disposition.
- No deletion of useful unmerged work.
- No release merely because CI is green.

Mark blocked PRs with the exact blocker and owner.

Do not keep re-running full suites on unchanged held branches.

7. Required report

Return one table:

PR| Owner| Development| CI| Merge blocker| Decision| Next action

Include totals for:

- Open PRs.
- Ready for integration.
- Awaiting Platform Admin approval.
- Blocked by code or tests.
- Superseded.
- Closed without merge.

Confirm which existing Codex PRs were retained, transferred or safely closed.

Do not perform destructive branch deletion unless the code and dependencies have been reconciled and the existing repository housekeeping rules permit it.

The goal is a controlled flow of completed capabilities through one Integration Controller, not another growing backlog of disconnected development.
