# Platform Admin mandate, 6 Nov 2026 11:00 Sydney, verbatim

# StudySearch — Authoritative Test Evidence and Faster PR Release Gates

**Platform Admin mandate — 6 November 2026**

Improve the existing StudySearch testing and release process to eliminate unnecessary repeated full-suite executions.

This is a bounded CI and release-engineering improvement, not a new testing framework.

Do not interrupt the current PR #889 release. Implement this as a separate PR after the current release reaches a safe state.

## 1. Audit existing test execution

Review:

- Pilot CLAUDE.md and Admin operating model.
- GitHub Actions workflows.
- Full local suite and CI test commands.
- `scripts/test-register.mjs`.
- `docs/platform/TEST-REGISTER.md`.
- Release ceremony and version bump scripts.
- Production-schema parity fixtures.
- Existing deployment checks.
- Current release acceptance contracts.

Identify why tests and test-register generation currently require repeated executions.

Document which repeated runs provide genuinely new verification and which are redundant.

## 2. Establish one authoritative test-results artifact

Generate a structured, immutable CI evidence bundle for each validated source revision.

Include:

- Source commit SHA.
- Relevant code and test dependency fingerprint.
- Test suite and environment versions.
- Test names and governed rule references.
- Total passed, failed and skipped.
- Test start/completion timestamps.
- Database schema-parity outcome.
- Relevant integration and UI test results.
- Build result.
- Release-contract result.
- CI workflow/run references.

Store the bundle as a normal GitHub Actions artifact with the required retention policy.

Do not create a competing test register or release ledger.

## 3. Generate the test register from the same evidence

The governed test register must use the results from the authoritative test run.

Avoid rerunning the suite solely to generate a different output format.

Make JSON or another structured results format part of the original test execution.

Ensure the register can be regenerated reproducibly from the retained results.

If evidence is incomplete or stale, fail the release gate rather than silently labelling it complete.

## 4. Safe test-result reuse

Allow existing successful test evidence to be reused only when the relevant source and execution contracts are unchanged.

Changes to the following invalidate the applicable evidence:

- Application or Worker code.
- SQL migrations or database contracts.
- Tests and fixtures.
- Dependencies or lockfiles.
- Build configuration.
- Security, permissions or deployment configuration.
- Relevant environment or runtime requirements.

For changes limited to release notes, changelog text or other explicitly classified non-executable metadata, reuse the previously validated full-suite evidence where the dependency fingerprint is unchanged.

Run the required lightweight release-contract and governance checks against the final candidate commit.

Do not bypass branch protection or mandatory GitHub checks.

A passing test from an unrelated branch, outdated schema or different executable build cannot be reused.

## 5. CI as the source of truth

Claude and Codex should consume the same CI evidence.

The Integration Controller must be able to inspect one report showing:

- PR and source revision.
- Test evidence validity.
- Production-parity validity.
- Required checks.
- Release readiness.
- Remaining blockers.

The final merge remains subject to the established release gates.

No test may be silently skipped or treated as passed because a previous run succeeded under different conditions.

## 6. Performance and resource efficiency

Measure the present baseline:

- Total test execution time.
- Number of full-suite executions per PR.
- Duplicate test execution.
- CI minutes.
- Claude/manual intervention needed.
- Number of failures detected before release.

Optimise repeated work first.

Use targeted checks during development and the full mandatory suite at the integration gate.

Do not trade production correctness for reduced execution time.

## 7. Production acceptance remains separate

The CI evidence bundle proves development and release readiness.

It does not establish successful production operation.

After deployment, continue to verify:

- Live version and migrations.
- Guarded function hashes.
- Required Worker and UI behaviour.
- Real admission and publication results.
- Production errors and regressions.

Record these against the same release evidence reference.

## 8. Acceptance

Prove the improvement with three cases:

1. Code change invalidates earlier test evidence and requires the applicable tests.
2. Release-notes-only change reuses the valid full-suite result while still passing all required final release checks.
3. Test fixture or database-schema change invalidates affected results.

Demonstrate that the test register remains accurate and that required GitHub branch protection is preserved.

Report actual reduction in redundant runs and elapsed release-validation time.

**Definition of done:** Each code revision has one authoritative, reproducible test evidence bundle that can safely support subsequent release metadata changes without unnecessary full-suite reruns.

Do not merge or deploy this improvement until its existing governed tests pass and the Integration Controller authorises the release.