<!-- Platform Admin decision, received 4 Nov 2026 21:59 AEDT; recorded verbatim. Engineering release hold in force from 21:59. -->

StudySearch — Immediate Safe Engineering Hold and PR-First Development

Platform Admin decision — 4 November 2026

Effective immediately, switch from continuous self-directed development and deployment to PR-first, bounded feature delivery.

This is a hold on discretionary engineering releases, NOT a production shutdown.

1. Safely stop the current release loop

Stop:

- Starting additional discretionary feature development.
- Automatically merging new development PRs.
- Repeated fix → deploy → fail → fix release cycles.
- Incrementing releases solely to address issues that could have been caught in integration testing.
- Starting unrelated platform improvement workstreams.

Keep operational:

- Existing production schedulers and authorised data processing.
- Consumer APIs and search publication.
- Monitoring, alerts and independent validation.
- Existing safeguards, manual locks and expenditure limits.
- Read-only investigation and documentation.

Do not disable production automation as part of this engineering hold.

2. Reconcile in-flight work

Immediately inspect v2.15.478 and the pending AER selector release.

If a deployment has already begun, allow it to reach a safe, known outcome and verify production health.

If the changes have not merged, leave them as PRs.

Do not automatically deploy v2.15.478 or v2.15.479 merely because their tests pass.

Retain all branches, commits, tests and findings.

Do not roll back a healthy production release simply to return to an earlier version.

Emergency fixes for confirmed P0 integrity, security or availability incidents remain permitted under the existing emergency governance and must be narrowly scoped and documented.

3. Adopt Codex PR-first development

Codex may develop complete vertical features independently on isolated branches.

Claude remains the sole Integration Controller.

For each feature:

1. Record the exact acceptance objective.
2. Define the backend and frontend contract.
3. Build the complete working capability.
4. Test against production-representative database fixtures.
5. Verify actual constraints, roles, permissions and function signatures.
6. Benchmark critical queries.
7. Demonstrate the end-to-end path in an isolated test environment.
8. Open or update the feature PR.
9. Have Claude independently review the integration and operational risks.
10. Merge and deploy only after the complete gate passes and the release is authorised.

No release number is assigned until integration.

Do not split frontend and backend into separate incomplete deliverables unless a genuine independent dependency requires it.

4. Correct the pre-production test gap

Investigate why v2.15.477 passed tests but failed against the production outcome constraint.

Ensure the relevant constraints, enum/check values, triggers, permissions, function signatures and execution behaviour are reproduced in integration fixtures.

Do not copy production user data into development.

Add regression coverage for the exact failing "ran" outcome and the refused path.

Prove that invalid results are rejected before deployment.

5. Resolve the UNSW-only selection problem in tests

Before another intake production run:

- Validate top-10 university eligibility.
- Check the scan limit does not unfairly exclude providers.
- Show eligible courses by university.
- Explain why nine universities have no selected candidates.
- Verify selection duration against production-compatible limits.
- Ensure that a 20-course cohort is possible without changing the approved source-evidence rules.

A single-university result is acceptable only when evidence demonstrates that no other scoped university has eligible data. An incomplete scan is not proof of absence.

6. Complete PR #872

Treat PR #872 as the active intake feature delivery.

Include its required secure backend bridges and complete UI integration.

Use the existing Run Now and intake processing functions.

Verify:

- University scope.
- Real preview.
- Fixed cohort.
- Run Now.
- Durable progress and result.
- Admission.
- Website/Zoho read-back.
- Mobile compatibility.

Use actual integration tests, not only synthetic frontend tests.

7. New release gate

A PR cannot merge until:

- Full required suite passes.
- Production-representative integration tests pass.
- Relevant database constraints match production.
- Critical query performance is acceptable.
- Permissions and spending controls are verified.
- Existing admission and consumer API guards pass.
- The exact production acceptance procedure is documented.
- The Integration Controller authorises that bounded release.

After deployment, run the governed 5–10-minute acceptance test.

A failed production acceptance test reopens the same feature issue. It does not automatically authorise another release.

If the pre-production environment cannot reproduce a production dependency, explicitly record that limitation and keep the release held unless approved through the existing exception process.

8. Continuous validation remains active

The existing platform observer must continue checking actual data throughput, failures, recovery yield, admission and publication.

Record failures in the existing integration queue.

Do not automatically turn every new issue into a software deployment.

Distinguish operational recovery from a genuine code defect.

9. Immediate response required

Report:

1. Current live production version and health.
2. Exact status of v2.15.478 and v2.15.479.
3. Which PRs are open and safe to retain.
4. Confirmation that discretionary automated releases have stopped.
5. Confirmation that production schedulers and monitoring remain active.
6. Root cause of the test/production constraint mismatch.
7. Integration status and dependencies of PR #872.
8. The single next bounded PR required for a successful intake admission.

Do not initiate another discretionary deployment in response to this message.

The next development goal is not a higher release number.

It is one verified, end-to-end Course Intake capability with production-compatible testing, a usable Admin UI and measurable published data.