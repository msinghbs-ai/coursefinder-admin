# CF-247 — Continuous Validation, Integration Feedback and Parallel Agent Execution

**Priority:** P1  
**Execution mode:** Autonomous, parallel, continuously validated  
**Scope:** All previously mandated Layer 4 acquisition remediation, adapter recovery, provider retirement, country lifecycle management and dependent housekeeping.

## 1. Continuous execution mandate

Do not treat development, validation, integration and production verification as separate activities performed only at the end.

Operate a continuous feedback cycle:

**Discover → Diagnose → Develop → Test → Integrate → Deploy → Validate → Record feedback → Create remediation tasks → Repeat**

Continue this cycle until all defined acceptance criteria are met or a genuine external or governance blocker prevents further progress.

Do not report a workstream as complete merely because code has been committed, tests have passed locally or a deployment has succeeded.

Completion requires verified operational behaviour in the deployed platform.

## 2. Maximum safe parallel-agent development

Use the maximum effective number of parallel development agents supported by the available environment.

Divide work into independently owned workstreams with explicit responsibilities and file ownership.

| Agent | Responsibility |
|---|---|
| A1 — Root Cause | Investigate all acquisition and adapter failures, analyse logs, classify root causes |
| A2 — Layer 2 | Provider websites, course links, Firecrawl discovery, PDFs and evidence binding |
| A3 — Adapters | Adapter capture, qualification, field admission and Layer 3 handoff |
| A4 — Layer 4 | Inbox reconciliation, settlement logic, duplicate prevention and reviewer workflow |
| A5 — Provider Lifecycle | Provider retirement, scholarship/AER dependencies, restoration and housekeeping |
| A6 — Country Lifecycle | Country-wide retirement orchestration, eligibility rules and cascading dependencies |
| A7 — Scheduling | Scheduled jobs, queue management, retries, leasing, concurrency and cancellation |
| A8 — Integration | End-to-end integration testing, database contracts, API and consumer compatibility |
| A9 — UI and Monitoring | Operational dashboards, lifecycle previews, progress reports and error visibility |
| A10 — Quality and Governance | Regression testing, security, change control, documentation and release readiness |

These are logical workstream assignments, not an assumption that ten independent agents are always available.

The coordinating agent must assign actual parallel workers according to tool and resource limits, and may split further when dependencies permit.

### Parallel development controls

- One owning agent per code area or migration family.
- Use isolated branches or worktrees where supported.
- Keep migration dependencies explicit.
- Prevent concurrent edits to the same production function without integration coordination.
- Coordinate shared schema changes before dependent work is merged.
- Rebase and integrate frequently.
- Do not allow multiple agents to deploy conflicting production changes.
- Do not allow agents to independently consume the full Firecrawl budget.
- Maintain one release controller responsible for production deployment and reconciliation.

Agents must continue independent work while another workstream is blocked.

## 3. Establish a persistent integration feedback queue

Create or extend the existing project integration work queue.

Every observed failure, regression, missing dependency or unresolved acceptance criterion must automatically produce or update a trackable remediation item.

Each item must include:

- Stable issue ID.
- Affected layer or subsystem.
- Provider, course or country IDs where applicable.
- Detected timestamp.
- Exact failure and expected result.
- Source of detection.
- Relevant logs, evidence and test references.
- Root-cause classification.
- Severity and impact.
- Owning workstream.
- Dependencies and blocking relationships.
- Fix commit or migration.
- Deployment version.
- Verification outcome.
- Retry count and latest observation.
- Current status.

Use a deterministic issue fingerprint to group repeated manifestations of the same defect without concealing affected entities.

Do not create a fresh duplicate issue every time a scheduled test detects an unchanged problem.

Suggested queue lifecycle:

`Detected → Triaged → Assigned → In progress → Code ready → Integration testing → Deployed → Production verification → Closed`

Failed validation returns the issue to `In progress` or `Triaged` with new evidence.

A fix is not complete until its associated issue passes production verification.

## 4. Continuous validation layers

Run validation at several levels.

### V1 — Development validation

On relevant commits:

- Static analysis and type checks.
- Unit tests.
- SQL migration checks.
- Function contract checks.
- Security and permission tests.
- Existing regression suites.

### V2 — Integration validation

On merge or integration candidates:

- Layer 1 → Layer 2 handoff.
- Layer 2 → Adapter evidence flow.
- Adapter → Qualify → Admission.
- Adapter → Layer 3 fallback.
- Layer 3 → Layer 4 review.
- Layer 4 decision → operational reconciliation.
- Provider retirement → dependent entity archival.
- Country retirement → complete dependency cascade.
- Restoration → controlled reactivation.
- Search/cache/API consistency.

### V3 — Deployment validation

After each deployment:

- Confirm migration state.
- Confirm function and worker versions.
- Check scheduled automation compatibility.
- Run deployed API smoke tests.
- Check production error logs.
- Check queue processing and leases.
- Verify no unexpected Firecrawl or AI expenditure.
- Compare operational metrics against the pre-deployment baseline.

### V4 — Continuous production validation

Use the existing scheduler and monitoring infrastructure to validate:

- New and recurring acquisition failures.
- Unresolved course links and missing websites.
- Adapter qualification progress.
- Layer 4 backlog movements.
- Stale onboarding runs.
- Drafts stuck in capture/proposal.
- Failed Layer 2/3 work items.
- Duplicate or orphan queue entries.
- Incorrect retired-entity publication.
- Scheduled jobs running against retired entities.
- Country/provider lifecycle inconsistencies.
- Search and consumer API leakage.
- Firecrawl expenditure anomalies.

Use incremental queries and event-triggered checks wherever possible rather than repeatedly scanning the entire database.

## 5. Automatic feedback-to-development loop

When any validation fails:

1. Record the observed failure with evidence.
2. Identify the earliest failing pipeline stage.
3. Check for an existing issue with the same root cause.
4. Create or update the integration queue item.
5. Assign it to the appropriate development workstream.
6. Reproduce the failure in a controlled environment.
7. Implement the smallest systemic correction.
8. Add a regression test.
9. Run affected integration tests.
10. Merge through the release controller.
11. Deploy under existing release governance.
12. Verify the original failed production condition.
13. Close the issue only after successful verification.

If the same issue reappears after closure, reopen the original item and record it as a regression.

Do not merely record recurring problems in reports while leaving them unassigned.

## 6. Continuous reconciliation of the Layer 4 queue

Maintain a persistent baseline of the expanded acquisition and retirement cohort.

Reconcile the original cases and any newly discovered cases separately.

Track:

- Original unresolved cases.
- New cases created.
- Cases recovered by evidence acquisition.
- Cases recovered through adapter repair.
- Cases resolved through Layer 3.
- Provider departures archived.
- Cases superseded because of retirement.
- Genuine human decisions remaining.
- Temporary operational blockers.
- Regressions and reopened cases.

After each successful remediation or deployment, re-evaluate the relevant queue entries.

Use event-driven reconciliation where possible.

Ensure the Layer 4 queue is not repopulated by obsolete onboarding states, completed jobs or retired records.

## 7. Automated acceptance tests for retirement integrity

Continuously verify lifecycle invariants.

For an archived provider:

- No active publication.
- No active provider-specific enrichment.
- No scheduled discovery or scraping.
- No new adapter admissions.
- No inappropriate pending Layer 4 tasks.
- No active consumer search records.
- All dependent scholarship and AER relationships handled.
- Historical records retained.

For a retired country:

- No active country-specific Layer 1 ingestion.
- No eligible Layer 2/3 execution for that country.
- No unauthorised AI or Firecrawl requests.
- All dependent providers excluded from active publication.
- Related courses, scholarships and AER handled.
- Country-specific jobs disabled or safely quiesced.
- Shared functions remain operational for active countries.
- No retired-country records appear in active consumer APIs.
- Audit, evidence and restoration records remain intact.

A failing lifecycle invariant must automatically open or update an integration remediation issue.

Do not automatically retire an active country in response to a test failure.

## 8. Release and deployment strategy

Use small, independently verifiable releases.

Each release must identify:

- Included issue IDs.
- Schema and migration dependencies.
- Affected functions and UI components.
- Expected operational effects.
- Known risks.
- Verification steps.
- Rollback or forward-recovery procedure.

Prefer automated integration gates and canary validation before wider activation.

If a deployment introduces an operational regression:

- Stop the affected release lane.
- Preserve unaffected development workstreams.
- Roll back or apply a verified forward fix.
- Reconcile any partial writes.
- Reopen the affected integration queue items.

Do not repeatedly deploy unverified fixes simply to reduce the backlog.

## 9. Progress reporting

Provide an integrated progress checkpoint after each development and verification batch, including:

| Metric | Required reporting |
|---|---|
| Parallel workstreams | Active, completed and blocked |
| Integration queue | Open, in progress, verifying, closed and reopened |
| Code changes | Commits and merged changes |
| Automated tests | Passed, failed and skipped |
| Deployments | Version and verification status |
| Layer 4 backlog | Original, new, resolved and remaining |
| Providers recovered | Verified count |
| Provider retirement | Archived/restored and reconciled |
| Country lifecycle | Implementation and test status |
| Firecrawl usage | Credits and budget remaining |
| Regressions | Newly detected and reopened |
| External blockers | Specific cause and affected scope |

Differentiate code completion from deployed and verified completion.

Use existing Admin dashboards and durable repository reports as the authoritative progress record.

## 10. Continuous improvement of validation itself

Periodically inspect the monitoring and testing system for blind spots.

If a production issue escaped existing tests, determine why and add a targeted test or invariant.

If a repeated operational failure is not being detected automatically, extend detection coverage.

If a known bug keeps regenerating Layer 4 work, fix the generation or reconciliation mechanism rather than repeatedly closing the resulting reviews.

Retire obsolete tests and monitoring rules only after proving that equivalent or better coverage remains.

## 11. Final completion gate

The coordinating agent may declare the remediation programme complete only when:

1. All original cases have a verified and auditable disposition.
2. No unresolved recoverable technical failures remain without assigned remediation.
3. All required integrations pass.
4. Provider and country retirement dependency tests pass.
5. The deployed platform has passed production verification.
6. Previously resolved Layer 4 failures are not being regenerated.
7. No unexpected work is running for retired entities.
8. No retired records leak into active search or consumer APIs.
9. The integration feedback queue has no open P0/P1 defects attributable to this programme.
10. Remaining exceptions are genuine external, budget or human-policy blockers, explicitly reported and tracked.
11. Documentation, change controls and operational runbooks are updated.
12. A defined post-release observation window has completed without recurrence of the critical defects.

If the completion gate fails, feed the result back into the integration queue and continue the remediation cycle.

**Execution directive:** Maximise safe parallel development, continuously validate integrated changes, automatically turn failures into actionable work, and maintain verified progress until the complete programme passes acceptance. Do not stop at implementation, deployment or a partially reduced Layer 4 backlog.

## 13. Integration Controller and Operating Modes (Platform Admin chat, 2 Nov 2026 16:58, verbatim)

Appoint one Integration Controller with overall responsibility for coordinating parallel development agents, maintaining the central integration feedback queue, managing dependencies and controlling production releases.
The Integration Controller must:

* Maximise safe parallel-agent execution.
* Assign and prioritise remediation issues.
* Prevent conflicting development and deployments.
* Continuously validate integrated changes.
* Automatically return failed validation to the development queue.
* Verify production fixes before closing issues.
* Maintain consolidated progress reporting.

Operating Mode 1 — Active Remediation
Continue development, integration, testing, deployment and validation until all programme acceptance criteria pass. Do not stop because individual workstreams have completed.
Operating Mode 2 — Steady-State Monitoring
After successful programme acceptance, transition to scheduled monitoring that detects new failures, regressions, queue anomalies and lifecycle inconsistencies.
Automatically create or reopen integration issues when problems are detected. Resume active remediation for issues within the approved operational authority; escalate changes that require separate approval.
Completion authority: Only the Integration Controller may declare the overall remediation programme complete, based on verified production evidence and the documented acceptance criteria.
Record both operating modes in the canonical Admin operating model and implement their monitoring, reporting and escalation rules.
