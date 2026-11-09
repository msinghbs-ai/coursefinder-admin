<!-- Platform Admin decision, received 4 Nov 2026 22:55 AEDT; recorded verbatim before integration. Authorises PR #872 only; the engineering hold stays in force for everything else. -->

StudySearch — Authorised Integration and Production Acceptance of Codex PR #872

Platform Admin decision — 4 November 2026

The Codex development task is complete.

Authorisation: Release PR #872 only, subject to the existing mandatory integration and production-safety gates.

PR: https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/872

Development commit: "50a75671"

The engineering hold remains active for all unrelated discretionary releases.

1. Confirm development handover

Read the canonical operating model, Pilot CLAUDE.md and PR #872's complete handover.

Independently verify:

- Development commit and current PR head.
- All required checks and database-backed tests.
- The 20-course end-to-end test evidence.
- Production-schema parity fixtures.
- University selection and zero-count reporting.
- Database performance results.
- Backend RPC security and permissions.
- Admin UI functionality and responsive tests.
- Consumer API contract compatibility.

Do not accept the Codex report alone as sufficient verification.

2. Reconcile related PRs

PR #872 already incorporates the Run Now outcome-code fix from draft PR #874.

Verify the incorporated implementation is identical and ensure the migration is applied exactly once.

Do not separately merge #874.

PR #875 contains unrelated AER changes. Leave it untouched and on hold.

Rebase PR #872 on the current main branch if necessary.

Resolve only genuine integration conflicts.

3. Final release gate

Before merging:

1. Run the full required test suite.
2. Confirm no failed or skipped required tests.
3. Verify production database constraints against the test fixtures.
4. Confirm guarded production function hashes.
5. Validate migration ordering and dependencies.
6. Verify Auth, RLS, grants and protected API contracts.
7. Check SQL execution plans and time-out limits.
8. Confirm cohort selection respects configured bounds.
9. Confirm AI/Firecrawl spending and manual locks remain protected.
10. Confirm rollback or forward-recovery procedures.

Critical regression: v2.15.477 failed because the test database omitted production's job-outcome foreign-key constraint. Explicitly verify that the invalid "ran" and "refused" values cannot recur.

If a gate fails, stop the deployment, retain the PR and report the exact blocker. Do not begin another release cycle automatically.

4. Merge and deploy

When the complete pre-production gate passes:

- Assign the next available release number.
- Record the release in the Admin execution register.
- Merge PR #872 through the established release workflow.
- Allow the normal deployment workflow to complete.
- Verify the live Worker version, migrations and relevant function definitions.

This authorisation applies only to PR #872 and the incorporated Run Now correction.

Do not resume unrelated feature releases.

5. Immediate production validation — maximum 10-minute target

Start the acceptance window when deployment completes.

Use the authenticated StudySearch Admin UI.

Step A — Verify UI

Open Layer 2/3 Operations → Intake Run & Validate.

Confirm:

- Screen loads successfully.
- Authorised operator has access.
- Read-only roles cannot execute writes.
- Scope, batch and evidence preview controls work.
- No browser RPC permission or contract errors.

Step B — Preview cohort

Select the top 10 Australian universities by active course count.

Display all 10 universities with:

- Active course count.
- Rows evaluated.
- Eligible course count.
- Exclusion reason where zero.
- Official evidence availability.

Select the approved bounded 20-course cohort.

Do not widen scope or manually select course IDs to manufacture a result.

Step C — Execute Run Now

Inspect the evidence before committing the cohort.

Record the cohort ID and authorised reason.

Execute Run Now exactly once through the Admin UI.

Confirm:

- Server accepted the request.
- Real job executed.
- Persisted outcome code is valid.
- Run ID, time and counts are visible.
- No duplicate execution.
- Existing admission and budget protections enforced.

Do not use direct SQL to substitute for the UI execution.

Step D — Verify actual intake admission

Compare exact before-and-after production catalogue values.

For every changed intake validate:

- Provider and course identity.
- Official source.
- Stored evidence.
- Intake month and year.
- Exact start date where stated.
- Application deadline where stated.
- Existing admission rules.
- Manual locks.
- Source freshness.

Never count an unchanged value as a new admission.

Step E — Verify consumer publication

Read actual Website API v2 responses for the affected courses.

Check supported Zoho values separately.

Identify each value as:

- Newly admitted and published.
- Admitted but not published.
- Unchanged.
- Unsupported by the consumer.
- Failed validation.

Do not report consumer publication solely from internal projection tables.

Step F — Verify persistence

Refresh the Admin UI.

Confirm the same cohort, execution record, source evidence, status and result remain available.

Inspect on mobile.

Do not repeat Run Now if an earlier execution completed.

6. Production acceptance verdict

Use the existing target of at least 10 newly verified, correctly published intake values from the fixed 20-course cohort.

Return one of:

PASS

- Complete authorised execution.
- At least 10 genuinely new eligible values published.
- Zero incorrect values.
- No duplicate processing.
- All relevant UI and API checks pass.

FAIL

- A technical defect prevents an otherwise eligible workflow from completing correctly.

BLOCKED

- Legitimate source, admission, budget, authority or operational limitations prevent completion.

If the cohort has fewer than 10 eligible values, report the actual denominator. Do not widen the cohort silently.

The 10-minute gate is a target, not permission to bypass safeguards. If the operation cannot complete in that window, record the actual state and reason.

7. Report one concise result

Metric| Production result
PR merged| 
Release version| 
Deployment verified| 
Universities evaluated| 
Cohort courses| 
Eligible source-backed values| 
Intake values newly admitted| 
Website values newly published| 
Zoho values verified| 
Failed or skipped| 
AI/Firecrawl spend| 
UI persistence verified| 
Acceptance verdict| PASS / FAIL / BLOCKED

Include run ID, cohort ID, release reference and production evidence links in the existing Admin register.

8. Post-release control

If PASS:

- Keep the normal intake scheduler operating.
- Confirm the same eligible work selection and verification are available for unattended processing.
- Retain continuous monitoring.
- Do not automatically increase batch sizes or spending limits.

If FAIL or BLOCKED:

- Keep production in a safe state.
- Record the exact issue and root cause.
- Do not automatically merge another corrective PR.
- Return the problem to the existing integration queue and prepare one bounded remediation proposal.

Final objective: Deliver the first demonstrably working StudySearch autonomous enrichment capability, controllable and verifiable through its Admin UI.

Success is actual source-backed intake admission and publication, not deployment or test completion.