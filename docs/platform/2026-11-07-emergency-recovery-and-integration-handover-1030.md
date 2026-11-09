# Platform Admin directive: Emergency Production Recovery and Integration Handover (7 Nov 2026 10:30 Sydney)

Recorded verbatim by Claude (incoming Integration Controller) before acting. Received in chat as an attachment plus the supplementary mandate below. Recording is not acceptance of authority: ownership, production controls and every release remain subject to the existing protocol.

## Part 1: attachment (verbatim)

StudySearch — Emergency Production Recovery and Integration Handover

Platform Admin directive — 7 November 2026

Incoming Integration Controller: Claude Sonnet 5.5 — High reasoning effort
Outgoing Integration Controller: Codex — formally stopped
Operating mode: Active Remediation
Priority: P0 production integrity, P1 monitoring recovery and controlled release delivery

1. Mandate and authority

You are nominated as the sole StudySearch Integration Controller, replacing Codex.

The objective is to restore reliable platform operations, integrate the completed engineering changes, deliver them safely to production and independently verify their outcomes.

Do not begin another broad development programme or recreate existing solutions.

Follow the canonical governance documents:

- "msinghbs-ai/coursefinder-admin/docs/platform/AGENT-OPERATING-MODEL.md"
- Admin operating index, execution register, controller checkpoint and Admin #382
- "msinghbs-ai/Coursefinder-Pilot/CLAUDE.md"
- Applicable current decisions, load policy and release requirements

The Admin repository remains the authoritative source for governance, operational evidence and handover.

The Pilot repository remains the sole production execution repository.

Existing approval boundaries remain effective.

2. Confirmed Codex handover — do not repeat

The Platform Admin confirms the following outgoing-controller report:

Codex stopped: 2026-11-06 23:18:14 UTC.

Weekend scheduled execution disabled:
"Automation_0a2ea05fa5e08191b96d4341b0c2cf90"

Monday scheduled handover disabled:
"Automation_af49e809a9f081918404af049e370634"

Both disabled states were verified by Codex.

In-flight Codex operations: None attributable to Codex.

Historical GitHub run: "34749286102" has zero jobs and a deleted workflow definition. Its disposition is documented; do not insist on record deletion unless independently required for safety.

Atomic ownership: Codex never acquired ownership, so no fictitious release was recorded.

Handover: "CODEX CONTROLLER RELEASED" recorded in Admin #382.

Admin commit:
"5056dbdc6f6abc621075082e9609b2c9395dfbae"

Checkpoint validation and continuity CI passed.

These are predecessor-reported facts to verify against current durable evidence, not reasons to repeat the handover process.

No additional Codex acknowledgement is required.

3. Immediate ownership acquisition

Independently reconcile:

1. Admin #382 release acknowledgement.
2. Latest canonical controller checkpoint.
3. Atomic coordination ref "studysearch-controller".
4. Current running or queued production-changing workflows.
5. Live Pilot main, migrations and Worker versions.
6. Production entry-point security-control adoption.
7. Existing GitHub, Supabase and Cloudflare permissions.

Establish legitimate exclusive controller ownership using the existing atomic protocol.

Do not treat nomination, a passing checkpoint or expired lease as sufficient production authority.

Resolve the account-control problem

Codex reported:

- GitHub environment protection/access APIs returning HTTP 403.
- Production workflow and environment controls not fully configured.
- Cloudflare deployment fencing not independently verified.
- Supabase direct-write credential restrictions outstanding.

First determine whether your existing authorised account connections can complete the required changes.

If possible, complete the documented, minimum-privilege controls while preserving recovery.

If an external account owner must act, provide one exact actionable instruction identifying:

- Which console and resource to open.
- Which setting or permission to change.
- The required safe configuration.
- Which existing service or credential must remain operational.
- How to verify enforcement and recovery.

Do not repeatedly attempt inaccessible operations.

Do not bypass security controls, but do not pause independent safe engineering.

The first substantive outcome must be either verified ownership and executable production controls, or an exact account-level blocker that the Platform Admin can resolve.

4. Take complete ownership of existing PRs

Review the actual current commits, not their historical descriptions.

PR| Responsibility
#892| Authoritative test evidence, phone regression and readiness reporting
#893| English requirements, genuine PostgreSQL scenarios
#894| Course descriptions, Layer 4 review and bounded admission
#895| Production controller ownership enforcement
#896| Incorrect application-deadline integrity correction
#897| Alert collector validation and required build checks
#890| Website API changes — G3 approval hold
#875| AER selector — existing hold

The Codex PRs contain meaningful development work and passing test evidence.

Preserve correct implementation.

Do not automatically reject, recreate or rewrite their work merely because it originated from Codex.

Dependency reconciliation

The documented release candidate order is:

#895 → #896 → #894 → #893

#892 is incorporated into the relevant release lineage. #897 is stacked on #893.

Independently validate the current Git graphs, commits, migration dependencies and Worker versions before choosing the final merge sequence.

Do not merge the same changes twice or deploy a stacked PR against an incompatible baseline.

Do not clear #890 or #875 without their existing approval conditions.

5. Non-negotiable engineering quality

Every merged change must satisfy the canonical release requirements.

Verify:

1. The applicable Admin decision and change-control record.
2. Exact current main and PR commit hashes.
3. No unresolved dependency or merge conflict.
4. Complete governed test suite with zero failed, skipped or flaky tests.
5. Genuine PostgreSQL fixtures and assertions with errors propagated correctly.
6. Correct migration ordering and compatibility.
7. Live function hashes immediately before applicable migration.
8. Identity, provenance, admission and lifecycle protection.
9. Consumer Website and Zoho contract compatibility.
10. Desktop and phone tests for applicable interfaces.
11. Current deployment configuration and rollback/forward-recovery.
12. No unauthorised spending, automatic admission or destructive operation.

Do not suppress failures, weaken guards or modify tests solely to achieve green CI.

A green PR is not proof that its merged version is safe.

After integration, validate the actual main commit and deployed version.

6. P0 — Application-deadline integrity

Three confirmed application deadlines were populated from source evidence that described course commencement dates instead of application-closing dates.

These values remain present in consumer-facing database projections.

The exact correction is covered by #896 and the existing D-382 decision.

Perform only the specifically authorised correction after verifying the applicable decision scope, ownership, operation reservation and migration guards.

Preserve:

- Other course and intake fields.
- Original source evidence.
- Human review locks.
- Audit history.
- Unrelated application deadlines.
- Consumer API contracts.

Verify before and after against the canonical database and Website/Zoho projections.

Do not widen the correction to the remaining suspected cohort without individual evidence and authorisation.

Keep the P0 issue open until production integrity is confirmed.

7. P1 — Alert collector and watchdog recovery

The GitHub Platform watchdog is correctly detecting failure of the alert-collection process.

Verified failed run:
"42262985796"

Observed error:
"alerts are not being collected: 75 waiting since 03 Nov 18:20 (longer than 120 minutes)"

Latest Codex baseline:

- 83 pending alerts.
- 80 overdue.
- All 83 unattempted.
- No actual destination delivery verified.

Existing Claude alert collector

Task identifier:
"trig_01Eo7QrJXR24e774gNzLUvTi"

Task name:
"Work queue alerts"

Expected schedule:
"59 * * * *" UTC

Preserve the existing notification recipient and channel.

You are operating in the Claude environment, so first inspect the actual task configuration, recent executions and failure history using your authorised account access.

Determine whether the task:

- Still exists.
- Is enabled.
- Has valid account permissions.
- Is executing on schedule.
- Can reach the guarded collector operations.
- Can complete event take, delivery and confirmation.

Do not assume that Codex's inability to access the Claude task means the task itself is defective.

Recovery

Use #897's verified collector protocol tests as evidence, not as proof of delivery.

Recover the existing collector only after its production execution pathway is authorised and fenced.

Do not create a duplicate collector, duplicate notification channel or unfenced legacy SQL path.

Do not bulk-mark events delivered or acknowledged.

Acceptance requires:

1. Real collector execution.
2. Actual notification transport delivery.
3. Recipient receipt confirmation.
4. Correct event confirmation and acknowledgements.
5. Pending and overdue backlog reduction.
6. No duplicate notification storm.
7. Independent Platform watchdog PASS on a fresh run.

Do not disable the watchdog to make CI green.

8. Controlled release delivery

Once ownership, security and release gates are satisfied:

1. Complete the required production fencing.
2. Merge the appropriate validated PR.
3. Verify the exact merged main commit.
4. Confirm the deployment workflow ran successfully.
5. Verify live migration and function versions.
6. Run relevant deployed tests.
7. Check production queues, jobs and consumer behaviour.
8. Record observed outcomes.
9. Continue with the next dependent release only after acceptance.

Use the documented load-policy windows and production recovery procedures.

If a release fails, stop further dependent releases, investigate and repair or recover.

Do not leave main knowingly broken.

9. Existing capability acceptance

After urgent P0/P1 recovery, complete the outstanding operational acceptance:

- Provider-description execution and governed publication.
- Course-description proposal, review and admission.
- English requirements, including university and course-group evidence.
- Layer 4 lifecycle, timestamps and review controls.
- Course Catalogue desktop and phone functionality.
- Process results and operational observability.
- AER coverage and evidence recovery.
- Scholarship coverage, admission and publication.
- Reader exhaustion, retry classification and related integration issues.

Human-authorised admissions remain human-authorised.

Vendor cost limits and Firecrawl reserve requirements remain effective.

No consumer API contract change without applicable G3 authority.

10. Prevent another unfinished delivery cycle

The previous weekend execution produced multiple passing PRs but zero production releases.

Do not repeat that failure.

Use existing agents and branches where useful, but focus on integrating and delivering the existing work.

Do not create unrelated PRs, duplicate architecture, parallel controller frameworks or excessive documentation.

Every development task must have a defined deployment or operational acceptance objective.

Do not close an issue because code was written or tests passed.

Stop producing redundant checkpoints that do not reflect a material change in verified state.

Maintain the required canonical execution evidence, but prioritise working production outcomes.

11. Status reporting

Provide concise checkpoints containing:

- Controller ownership: verified or blocked.
- External account controls: completed or exact missing action.
- PRs merged, with main commit.
- Production releases and migrations verified.
- Complete test results.
- P0 deadline integrity status.
- Alert collector backlog, real deliveries and watchdog outcome.
- Remaining genuine blockers.
- Next executable action.

Clearly distinguish:

Implemented → Tested → Merged → Deployed → Production-verified.

Never report an earlier stage as completed delivery.

12. Immediate response requirement

Begin by independently verifying the Codex handover and existing account access.

Then state:

1. Can Claude lawfully and technically acquire exclusive ownership?
2. Can Claude operate the required GitHub, Cloudflare and Supabase production controls?
3. What precise account-owner action, if any, is unavoidable?
4. Which PRs are genuinely ready for the first controlled release?
5. What is the next executable production-safe action?

Do not request another Codex acknowledgement.

Do not promise that production deployment will succeed if external permissions are still unavailable.

Continue all work that is safe and authorised.

13. Definition of completion

The assignment is complete only when:

- Exclusive controller ownership is verified.
- Required production security controls are enforced.
- Ready changes are correctly integrated.
- Main CI is green for the actual merged code.
- Production versions and migrations are verified.
- Three confirmed incorrect application deadlines are corrected.
- The alert collector delivers notifications correctly.
- The independent watchdog passes.
- Applicable UI and consumer acceptance succeeds.
- Remaining holds and issues are accurately recorded.

Platform Admin direction: Take ownership, preserve the completed engineering work, fix the critical production failures and deliver a verified, reliable StudySearch platform. Do not substitute another handover or checkpoint exercise for actual delivery.
## Part 2: Additional Mandate — Acknowledgement, Progress and AI Handover (verbatim)

This instruction supplements the preceding StudySearch recovery mandate.

1. Acknowledge the complete mandate before execution. Confirm every workstream received, applicable constraints, ownership responsibilities, release order, outstanding decisions and acceptance criteria. Identify any missing or conflicting instructions immediately.

2. Maintain a single authoritative session journal in the existing Admin repository. Record all substantive progress messages, decisions, commands affecting production, tool results, PR changes, test outcomes, deployments, failures, blockers and next actions. Preserve timestamps, evidence links and execution identifiers. Do not store secrets or unnecessary raw logs. Extend existing records rather than creating another competing register.

3. Record progress at every material milestone, including ownership acceptance, completed fixes, PR merges, release verification, incident recovery and newly discovered blockers. While actively executing, provide consolidated progress updates at least hourly where supported. Do not claim background execution or updates when the session is inactive.

4. At the end of each session, publish and validate a complete checkpoint and handover in the Admin repository. Include:

   - Completed, ongoing and outstanding work.
   - PRs, commits, migrations and production versions.
   - Tests and actual operational results.
   - P0/P1 incident status.
   - Decisions or actions required from the Platform Admin.
   - Next safe executable actions.

5. Finish every session response with a concise, copy-ready status summary and links to the exact Admin records. Use the headings: "Completed", "In progress", "Blocked", "Production verified", "Next action", and "Handover link".

6. AI-independent continuity: The records must allow ChatGPT, Codex or another authorised AI to independently review, validate and resume work without access to Claude's conversation history. Do not require the Platform Admin to manually relay technical details.

Important: Record facts as verified, distinguish proposed work from completed work, and never report successful deployment or incident closure based solely on passing CI.

The Admin repository is the permanent audit trail; chat messages are only summaries and links.
