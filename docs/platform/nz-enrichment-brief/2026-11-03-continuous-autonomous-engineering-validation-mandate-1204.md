# StudySearch — Continuous Autonomous Engineering and Independent Validation

**Platform Admin consolidated execution mandate — 3 November 2026**

## 1. Primary objective

Complete and maintain a self-sustaining StudySearch platform.

**StudySearch performs enrichment. Claude performs engineering. ChatGPT performs independent validation.**

Use the existing canonical Admin operating model, Pilot development rules, integration feedback queue, release governance and Layer 4 playbook.

Do not create duplicate tracking systems, redundant workers, one-off enrichment scripts or additional dashboards where existing functionality can be extended.

Continue authorised engineering until production evidence satisfies the acceptance criteria.

## 2. Operating architecture

Maintain three independent responsibilities.

### StudySearch platform — operational execution

The platform must independently:

- Detect data gaps.
- Select eligible records.
- Schedule enrichment jobs.
- Reuse verified stored evidence.
- Acquire approved new evidence within budget.
- Process data through existing workers.
- Apply source, identity and completeness checks.
- Route unresolved evidence to Layer 4.
- Publish accepted values.
- Refresh Website API v2 and Zoho.
- Retry recoverable failures.
- Record completion, hold reasons and expenditure.
- Start the next eligible work batch.

Claude must not manually enrich individual records to make coverage numbers improve.

### Claude — development and integration

Claude and its specialist agents:

- Diagnose platform defects.
- Repair existing readers and schedulers.
- Implement missing controls.
- Run automated tests.
- Coordinate approved releases.
- Verify production behaviour.
- Maintain integration issue records.
- Prepare governance decisions and developer handovers.

Claude must not become the permanent job dispatcher.

### ChatGPT — independent assurance

A separate hourly ChatGPT validation task is now enabled.

It independently checks live evidence, production jobs, catalogue coverage, release state, reliability, budgets and consumer consistency.

Its findings must be assessed against the existing integration queue.

Use stable fingerprints to prevent duplicate issues.

Do not require ChatGPT to type into Claude's browser session. The engineering workflow must remain durable without a browser connection.

## 3. Reconcile the current production baseline

The recent release sequence includes v2.15.419 and work reported towards v2.15.422/v2.15.423.

Do not assume those later releases are deployed.

Verify:

- Actual live release.
- Migration checksums.
- Worker version.
- Changed function definitions.
- Scheduled jobs and enabled state.
- Current settings.
- Pending/active/finished tasks.
- Platform health.
- Integration issue queue.

The Platform Admin has completed the Layer 2 clean-up paste.

Independent Supabase checks verified:

- 0 obsolete Layer 2 requests queued.
- 0 obsolete Layer 2 schedules enabled.
- 1 closure audit event.

Do not rerun the paste or rollback.

## 4. P0 — Autonomous orchestration

Resolve every defect preventing the platform from independently processing its eligible backlog.

Priorities:

1. Enrichment plan re-planning and provider starvation.
2. Standing field-gap queue completeness and timeouts.
3. Automatic next-batch advancement.
4. Manual and automatic work deduplication.
5. Correct retry, cancellation and child-task lifecycle.
6. Hidden worker errors.
7. Legitimately idle versus stalled job classification.
8. Budget-aware processing without unnecessary blocking.
9. Operator control failures.
10. Country-independent scheduling configuration.

Use existing Enrich fields, Enrichment plan, Scheduled Jobs, Task manager and Platform health functionality.

Verify that a provider whose eligible gaps change becomes schedulable without waiting through an unrelated fixed cooldown.

Prevent endless retries and repeated work where source evidence has not changed.

## 5. P0 — Missing enrichment engines

Complete and verify production operation for:

- Course descriptions.
- Application deadlines.
- Provider descriptions.
- Intake dates.
- Course-level academic entry requirements.
- Scholarship source discovery and admission.
- Existing fee, English, campus, delivery and duration fields.
- Ranking edition discovery and reconciliation.

Use the existing shared enrichment architecture.

For every field establish:

- Actual eligible backlog.
- Records with verified stored source pages.
- Records requiring acquisition.
- Records waiting on Layer 4.
- Records not currently supported by official evidence.
- Actual processed and admitted rates.
- Remaining time based on measured throughput.

The platform must own execution and continuation.

Do not report engineering release completion as data-enrichment completion.

## 6. P0 — Source proof and acquisition

Prioritise verified stored evidence over paid page retrieval.

Treat missing page proof as a discoverable coverage gap, not a permanent silent skip.

Ensure source discovery is a functioning independent lane with:

- Provider and course identity checks.
- Bounded retries.
- Official source priority.
- Evidence retention.
- Budget enforcement.
- Country-aware eligibility.
- Safe publication boundaries.

A held-off job must remain off when disabled by an authorised person or governed restore.

A scheduler must not repeatedly reactivate deliberately paused jobs.

Correctly distinguish budget-held, source-held, manually disabled, failed and completed states.

Do not increase Firecrawl spending without approved authority.

## 7. Six-agent development ownership

Continue parallel engineering, with one integration controller.

**Agent A — AER**

Qualification-first matching, provider/course readers, D-R2/D-R3, E13 completeness, scheduled processing, Layer 4 safeguards and international qualification coverage.

**Agent B — Scholarships**

F1–F10, source pagination, provider coverage, nationality eligibility, admission controls, research scholarships and accurate closed/open status.

**Agent C — Descriptions and intakes**

Course descriptions, provider descriptions, application deadlines, calendar interpretation, stored-evidence processing and operator field selection.

**Agent D — Orchestration**

Enrichment plans, standing gap queue, scheduling, retries, work leases, next-batch progression, cancellations and manual controls.

**Agent E — Data integrity and housekeeping**

Supersession, rejected/held record protection, course-link integrity, evidence history, publication and country retirement rules.

**Agent F — Independent integration**

CI, deployment validation, job yields, consumer consistency, production resource protection, issue lifecycle and acceptance tests.

Prevent concurrent changes to the same function or migration family.

Agents may build independently. Only the integrator coordinates production releases.

## 8. Independent validation feedback loop

Every material defect follows:

Detect → Diagnose → Queue → Assign → Repair → Test → Deploy → Verify → Revalidate → Close.

The integration queue is the only engineering defect register.

Each issue must include:

- Stable ID and fingerprint.
- Severity.
- Impacted country/provider/field.
- Production evidence.
- Last observed timestamp.
- Root cause or explicit hypothesis.
- Assigned owner.
- Corrective change.
- PR/release.
- Regression guard.
- Production verification.
- Closure evidence.

A scheduler reporting success with no useful work must not be treated as healthy when eligible work remains.

A legitimately budget-held or complete job must not generate a false failure.

Reopen recurring problems using their existing issue identity.

Close issues only after subsequent production runs confirm the correction.

## 9. Prove manual operation

Use the existing Admin controls to demonstrate:

- Country/provider/field selection.
- Missing-field preview.
- Existing evidence and budget estimates.
- Run Now.
- Scheduling.
- Pause/resume.
- Retry.
- Cancellation.
- Progress and outcome visibility.
- Audit and result export.

Test real bounded cohorts.

If an authorised browser session is unavailable, report the exact operator test that remains unverified.

Do not claim a browser acceptance test passed without evidence.

## 10. Prove unattended execution

Configure representative authorised production cohorts using the platform controls.

Then stop all per-record interventions.

Verify at least two successive eligible cycles where the platform independently:

1. Detects work.
2. Creates tasks.
3. Executes workers.
4. Produces valid outcomes.
5. Routes reviews