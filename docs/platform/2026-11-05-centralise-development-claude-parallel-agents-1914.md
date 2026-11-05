<!-- Recorded verbatim by the Integration Controller. Received 5 Nov 2026 19:14 (Australia/Melbourne). Supersedes the 19:00 allocation of the Course Catalogue feature to Codex. -->

StudySearch — Centralise All Development Under Claude and Parallel Agents

Platform Admin decision — 5 November 2026

Effective immediately, discontinue Codex Cloud as a development contributor.

Claude is now responsible for coordinating and completing the entire StudySearch engineering programme using multiple parallel Claude agents.

This supersedes previous instructions assigning new work to Codex.

1. Central engineering ownership

Continue as the sole Integration Controller.

Use the maximum safe number of parallel Claude engineering agents, subject to resource limits and code ownership.

Assign separate agents to independent workstreams.

Each agent must own a clearly defined feature, code area and migration family.

Do not allow two agents to modify the same functions or migrations concurrently.

The Integration Controller alone:

- Prioritises work.
- Resolves dependencies.
- Reviews completed changes.
- Integrates branches.
- Controls production releases.
- Assigns release numbers.
- Verifies production outcomes.
- Maintains the execution register and integration queue.

No development agent merges, deploys or performs unauthorised production writes independently.

2. Reconcile all open PRs

Audit every open and draft PR in "msinghbs-ai/Coursefinder-Pilot".

For each record:

- PR number and title.
- Originating developer or agent.
- Feature purpose.
- Current branch and base.
- Files and migrations changed.
- Test status.
- Whether implementation actually started.
- Whether current main already supersedes it.
- Overlap with active work.
- Reusable tested code.
- Integration risks.
- Recommendation: retain, transfer ownership, supersede or close.

Closing obsolete PRs

Close without merging when a PR is:

- An unused work-package pointer.
- A duplicate implementation.
- Superseded by a verified release.
- No longer required.
- Abandoned before development started.

Before closing:

1. Verify no unique required implementation or migration will be lost.
2. Record the reason and replacement workstream.
3. Preserve useful specifications and test evidence in the Admin repository.
4. Add a clear closure comment.
5. Close the PR without merging.

Do not delete branches containing unique unmerged work until their disposition is verified under existing housekeeping rules.

Do not close useful completed features simply because Codex created them.

3. Immediate PR decisions

PR #886 — Course Catalogue columns

This was created as a Codex work-package pointer, and implementation was not started at the last checkpoint.

Verify its current state.

If still unimplemented, close #886 without merging after retaining the work package.

Assign the feature directly to a Claude UI engineering agent.

Required functionality:

- Select, hide and show columns.
- Reorder and resize columns.
- Server-side per-user saved layouts.
- Reset to default.
- Adapter status.
- City.
- Last modified.
- Last data admitted.
- Server-side sorting.
- Mobile-friendly fluid table.

Reuse the existing Course Catalogue and shared table components.

PR #877 — Provider descriptions

This contains substantial existing development.

Do not close it merely because Codex authored it.

Assign a Claude backend/integration agent to:

- Review the implementation.
- Reconcile current main.
- Correct remaining test failures.
- Verify existing reader and scheduler compatibility.
- Validate human-review and spending controls.
- Complete the feature through the normal integration gate.

Retain and integrate the useful work rather than rebuilding it.

Other open PRs

Reconcile all remaining PRs against current production.

Close obsolete or duplicate drafts without merging.

Retain separate held AER work where it is still required.

Do not automatically release anything merely because a PR has passed CI.

4. Parallel workstreams

Start the following independent Claude agent assignments.

Agent| Workstream| Responsibility
A| Developer API R23/R24| Campus names/course counts and scholarship nationality status
B| Provider descriptions| Complete and integrate existing PR #877
C| Course Catalogue UI| Implement customisable columns and saved per-user layouts
D| Intake Automation Progress UI| Show live process status, throughput, failures and history
E| Independent validation| Production-schema parity, regression tests, integration checks and release readiness

Use additional agents only where there is no code or migration ownership conflict.

Course descriptions and English requirements remain next in the prioritised backlog, using their existing work where available.

Do not start another general autonomy framework.

5. Prioritise confirmed developer requirements

The website developer's 5 November feedback confirms the current Wix integration is functioning and requests:

R23 — Campus names and course counts

Add the approved-design provider campus fields:

- "campus_id"
- "campus_name"
- "course_count"

R24 — Scholarship nationality status

Add:

- "restricted"
- "unrestricted"
- "unknown"
- "under_review"

Preserve the existing consumer response shape and fields, except for the explicitly proposed additive changes.

These changes require Platform Admin G3 approval before deployment.

Prepare the final approval package, production-representative tests and developer guide Issue 8.

Do not interpret this engineering mandate as approval to change the live consumer API.

6. Mandatory automation compatibility assessment

Before implementing a feature, inspect the existing:

- Readers and adapters.
- Scheduled jobs.
- Triggers and functions.
- Evidence storage.
- AI models and toolsets.
- Retry and recovery rules.
- Admission controls.
- Layer 4 ownership.
- Existing Admin UI functionality.
- Consumer publication mechanisms.
- Prior decisions and active automation plans.

Document:

Reuses → Changes → Replaces → Retires → Conflicts → Protects → Validates.

A new mechanism must not inadvertently overwrite existing working automation or revive retired functionality.

Prefer extending existing code.

Do not create duplicate schedulers, controllers, readers or dashboards.

7. Complete vertical features

Every agent must deliver a functional end-to-end feature, not a superficial UI or isolated backend function.

Required:

- Backend implementation.
- Admin UI where applicable.
- Existing scheduled operation.
- Governed manual Run Now where applicable.
- Persistent processing results.
- Evidence and failure reasons.
- Admission integration.
- Consumer publication verification.
- Production-schema parity tests.
- Responsive UI tests.
- Operational documentation.

If the feature does not require a UI or data write, document the applicable exclusions.

Do not defer essential backend bridges to another release without a genuine dependency.

8. Independent pre-production validation

The validator agent must independently assess each proposed release.

Use production-representative constraints, grants, RLS, triggers and function signatures.

Test the actual processing path and integration boundaries.

Learn from the failed intake releases where simplified database fixtures passed but production rejected the operation.

Require:

- Full governed suite green.
- No unapproved skipped tests.
- Production function-hash compatibility.
- Representative integration fixtures.
- Bounded performance.
- Existing budget and role protection.
- Admission-rule preservation.
- No unexpected consumer API changes.
- Clear forward-recovery instructions.

Do not use production as the primary debugging environment.

9. Controlled integration and releases

The existing engineering hold remains in force.

Claude may develop and prepare PRs without separate approval.

A production release must have the required authorisation under the current governance.

For each release:

1. Identify the capability and related issues.
2. Complete independent integration review.
3. Run all required gates.
4. Confirm the authorised release scope.
5. Assign the next release number.
6. Merge and deploy through the established workflow.
7. Run immediate production validation.
8. Verify actual data and Admin UI behaviour.
9. Record PASS, FAIL or BLOCKED.
10. Keep continuous monitoring active.

Do not repeatedly deploy speculative fixes.

A failed production acceptance test does not automatically authorise another discretionary release.

10. Continuous progress and accountability

Maintain one consolidated view in the existing Admin execution register.

Show for each workstream:

- Agent owner.
- Branch and PR.
- Development status.
- Tests and integration results.
- Production release status.
- Data or UI capability delivered.
- Actual admission/publication results where applicable.
- Failures and blockers.
- Next action.

Each automation must expose operational visibility in the existing Admin interface:

Current state → Work processed → Data admitted → Data published → Failures → Next action → Historical evidence.

Keep detailed run history in the database and durable design/decision records in the Admin repository.

Do not generate excessive repository commits for routine per-item events.

11. Immediate execution order

1. Record this ownership change in the Admin repository.
2. Reconcile every open PR.
3. Close unimplemented or superseded PRs without merging, where appropriate.
4. Preserve useful completed Codex contributions.
5. Assign parallel Claude agents with exclusive code ownership.
6. Complete intake's outstanding production acceptance and return it to normal background operation.
7. Prepare R23/R24 for final G3 approval.
8. Complete provider descriptions.
9. Complete Course Catalogue customisable columns.
10. Complete Intake Automation Progress UI.
11. Continue course descriptions and English requirements as the next bounded capabilities.

Do not let one blocked workstream stall unrelated development.

12. Required response

Provide one consolidated table:

Workstream| Agent| PR| Status| Tests| Release blocker| Next milestone

Also provide a separate PR housekeeping summary:

- Retained.
- Transferred to Claude.
- Superseded.
- Closed without merge.
- Awaiting decision.

Completion means all active features have a clear owner, obsolete PRs are safely closed, useful existing work is preserved, and parallel development is progressing under one Integration Controller.

Do not claim completion merely because agents were assigned or PRs were opened.