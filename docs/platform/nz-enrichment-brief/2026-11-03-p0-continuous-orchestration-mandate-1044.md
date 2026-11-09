StudySearch — P0 Continuous Orchestration Closure and Self-Sustainability Acceptance

Platform Admin execution mandate — 3 November 2026

Priority: P0 — platform autonomy and operational completion.

Latest reported production baseline: v2.15.418.

1. Primary objective

Finish the existing continuous enrichment orchestration so StudySearch independently:

1. Detects missing, stale and incomplete fields.
2. Selects eligible records.
3. Creates bounded enrichment work.
4. Executes through existing platform workers.
5. Reuses verified stored evidence first.
6. Acquires new evidence when authorised and within budget.
7. Applies existing validation and publication safeguards.
8. Routes unresolved evidence to Layer 4.
9. Retries transient failures.
10. Reconciles catalogue and consumer output.
11. Records progress and failures.
12. Continues the next eligible batch without Claude intervention.

Claude and its parallel agents must not manually enrich providers or courses.

Claude may develop, deploy, configure, investigate and perform bounded acceptance tests. Operational enrichment belongs exclusively to StudySearch.

2. Immediate blocker escalation

Before development, reconcile the current live state against v2.15.418 and the latest Admin execution register.

For every blocker, report:

- Issue ID.
- Root cause.
- Impacted country, provider and field.
- Affected backlog.
- Whether work is fully stopped or degraded.
- Existing workaround.
- Engineering owner.
- Expected corrective release.
- Whether Platform Admin authorisation is actually required.

Report genuine blockers immediately upon discovery.

Do not wait for the next four-hour checkpoint.

Use the existing integration queue. Do not create a second issue tracker.

If the blocker is a code defect within approved authority, fix it rather than asking for another general approval.

If it is an approval or cost boundary, state the exact decision required.

3. Parallel engineering workstreams

Deploy the established agent structure, with one main integrator coordinating releases.

Agent A — Orchestration and provider-plan lifecycle

P0.

Correct the existing enrichment-plan mechanism.

Investigate the reported reduction from approximately 420 to 2 plans per day.

Replace the unconditional 14-day provider hold with a safe eligibility model:

- Re-plan when new material gaps appear.
- Re-plan when new verified evidence becomes available.
- Re-plan when a failed step becomes retryable.
- Avoid duplicate work for unchanged inputs.
- Preserve completed steps where still valid.
- Honour source and spend limits.
- Prevent plan starvation.
- Prevent unbounded rescheduling loops.

Fix interactions between automatic and manual runs.

Cancellation must stop or safely cancel eligible child tasks and prevent new child tasks from being started.

No orphaned work.

Agent B — Field enrichment engine

P0.

Complete course descriptions and application deadlines as supported fields in the existing Enrich fields engine.

Do not build a second enrichment service.

Use the existing source priority:

1. Verified stored course page.
2. Existing source observations or trusted structured data.
3. Approved bounded source acquisition.
4. Existing AI extraction where permitted.
5. Layer 4 for evidence requiring human decisions.

Preserve course/provider identity, official source, quote, evidence hash, year, audience and source freshness.

Never fabricate descriptions, dates or requirements.

Verify that the Enrich fields UI can preview, start and monitor these fields.

Ensure both automatic plans and manual jobs use the same engine.

Agent C — Standing gap queue and scheduling

P0.

Repair standing-gap queue timeouts and processing starvation.

Investigate the existing queued Layer 2 Run on Demand requests.

Ensure the platform:

- Selects eligible work in bounded batches.
- Uses indexed pagination and durable checkpoints.
- Resumes after interruptions.
- Distinguishes idle, budget-held, failed and completed outcomes.
- Does not report success with zero work when eligible work remains and no valid hold applies.
- Does not repeatedly invoke disabled jobs.
- Does not duplicate scheduled or manually triggered tasks.

Retire a dead control only when an existing working control provides equivalent or better functionality.

Do not leave an inoperative Run Now button visible.

Agent D — AER, scholarships and provider descriptions

P1.

Complete scheduled course-level AER discovery and reading using configurable provider/country eligibility.

Retain D-R2/D-R3, E13, Layer 4 and source-completeness safeguards.

Verify provider-description processing progresses independently after v2.15.418.

Continue the eight-provider scholarship pilot using StudySearch's own jobs.

Verify the pipeline discovers, reads and routes awards without Claude re-queuing individual records.

Correct hidden AI-reader errors and investigate the NZ reader's repeated failures.

Do not bypass human admission or initiate unapproved paid reads.

Agent E — Operator controls and country portability

P1.

Finish the existing UI controls rather than introducing new dashboards.

Verify:

- Country and provider targeting.
- Multi-provider selection.
- Field selection.
- Preview.
- Stored-evidence-only mode.
- Budget estimation.
- Run Now.
- Automatic schedule.
- Pause/resume.
- Cancel.
- Retry failed.
- Progress.
- Evidence audit.
- Export results.

Make the role-appropriate controls operational.

Remove unsupported AU/CA hardcoding from shared scheduling and selection logic, using existing country configuration.

Keep current country enablement unchanged unless authorised.

Agent F — Independent validation and integration

P0/P1.

Independently test Agents A–E.

Own:

- Existing integration queue.
- Hidden failures.
- Zero-yield detection.
- No-progress and starvation monitoring.
- Production regression.
- Database load protection.
- Consumer read-back.
- Release integrity.
- Self-sustainability acceptance evidence.

Do not close an issue because a deployment succeeded. Require a real subsequent platform-run result.

4. Mandatory manual-mode acceptance

Use an authorised operator account and the existing Admin controls.

Test representative bounded cohorts for:

- Course descriptions.
- Intake dates/application deadlines.
- Course-level AER.
- Scholarships.
- Provider descriptions.
- Enrichment plans.

For each test:

1. Preview the actual gap.
2. Confirm source evidence and estimated spend.
3. Start Run Now.
4. Verify the request is executed, not merely queued.
5. Verify the expected worker performs the job.
6. Validate evidence and field changes.
7. Verify Layer 4 routing where necessary.
8. Check API projection and Wix output.
9. Test safe retry and cancellation.

If authenticated operator UI access is unavailable to the agent, mark that acceptance portion unverified and provide exact operator steps. Do not falsely declare a UI test passed.

5. Mandatory unattended-mode acceptance

Select a bounded, representative AU cohort with stored evidence.

Configure its existing automatic plan through authorised platform controls.

After the initial configuration, Claude must not push individual items, invoke record-specific readers or manually re-queue work.

Observe the platform's scheduled activity and evidence.

Verify that it independently:

- Detects eligible gaps.
- Creates jobs.
- Advances through multiple batches.
- Handles successes and failures.
- Respects locks and cost limits.
- Recovers from worker interruptions.
- Routes Layer 4 cases.
- Publishes permitted values.
- Refreshes consumer projections.
- Reconciles completed work.
- Starts subsequent eligible batches.

Include at least one genuine scheduler cycle, one next-batch transition and one controlled retry test.

Then run a 24-hour unattended soak test.

Do not claim 24-hour acceptance until the full interval has elapsed and its recorded evidence has been assessed.

Development and unrelated safe work may continue concurrently.

6. Production load and budget protection

Stored-evidence enrichment must not be blocked merely because external Firecrawl credits are unavailable.

Separate:

- Stored-evidence processing.
- New paid source acquisition.
- AI extraction.
- Layer 4 admission.

Each lane must have independently measurable work, cost and hold reasons.

Current Firecrawl information indicates a 5,000-credit monthly plan versus settings that assume substantially higher daily expenditure.

Do not increase spending without explicit approval.

Do not stop stored-evidence workers because paid acquisition has exhausted its allowance.

Use measured concurrency and prevent the earlier admission-timeout incidents from recurring.

7. Acceptance thresholds

The platform must demonstrate:

- No known eligible work permanently stranded by the 14-day hold.
- No unprocessed Layer 2 on-demand requests without a valid explicit disposition.
- No silent failed job reported as successful.
- No false zero-yield failure when a job is legitimately idle.
- Automatic advancement through multiple eligible batches.
- Working manual Run Now and retry for the supported test cohort.
- Correct cancellation and child-task handling.
- Every processed value retains evidence.
- No unauthorised Layer 4 admission.
- No incorrect link or fee reactivation.
- No regression in Website API v2 or Zoho.
- No material contention caused by uncontrolled parallel runs.
- Clear country-specific configuration.
- All remaining exceptions classified and assigned.

Acceptance requires actual production evidence, not just code, mocked tests or scheduled-job existence.

8. Release and reporting

Continue authorised parallel engineering and use one integrator.

For each release:

- Admin decision traceability.
- Full green regression.
- Live dependency and checksum verification.
- Controlled deployment.
- Live function and configuration verification.
- Independent scheduled-run evidence.
- Integration-queue reconciliation.

Provide immediate escalation for P0/P1 blockers, security concerns, unexpected cost, stalled queues and required decisions.

At each material checkpoint report:

- Current production version.
- Open/closed/reopened issues.
- Field-specific eligible backlog.
- Actual records processed and admitted per hour.
- Number of jobs independently started by StudySearch.
- Number of jobs manually initiated by Claude.
- Idle, held, failed and retrying work.
- Worker latency and database contention.
- Spend and remaining approved budgets.
- Next corrective release.
- Exact acceptance tests passed or remaining.

The count of manual enrichment actions performed by Claude during the unattended test must be zero.

9. Definition of completion

Do not call StudySearch self-sustaining merely because its scheduled jobs are enabled.

Completion requires demonstrated independent movement of real data, reliable operator controls, observable recovery from failures and safe continuous progression.

When this is proven, produce:

Platform Self-Sustainability Acceptance Report

Store it in the canonical Admin repository with live evidence, issue references, release versions, operator walkthroughs and remaining limitations.

Begin by resolving the P0 orchestration blockers. Do not start new feature development that distracts from making the existing platform operate independently.