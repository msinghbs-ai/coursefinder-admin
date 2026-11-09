StudySearch — Platform-Led Enrichment, Manual Controls and Self-Sustainability Acceptance

Platform Admin executive direction — 3 November 2026

This mandate supersedes any instruction directing Claude or its agents to manually enrich individual providers, courses, scholarships, rankings or entry requirements.

1. Fundamental operating requirement

StudySearch is the data-enrichment engine. Claude is the engineering and validation controller.

Do not use Claude agents to substitute for missing operational automation.

Do not have Claude repeatedly select providers, fetch their pages, extract fields, execute individual admission jobs or push data into the catalogue as the normal enrichment process.

Claude agents may inspect the system, perform bounded acceptance tests through its supported controls, diagnose defects, develop fixes, validate releases and produce reports.

The operational platform must continue enriching and reconciling data when Claude is not running.

2. Audit the existing operator controls first

Inspect the deployed UI, its role guides, underlying functions, settings and actual scheduler state.

Specifically audit:

- Layer 2/3 → Enrich fields.
- Layer 2/3 → Enrichment plan.
- Scheduled Jobs workspace.
- Provider-level enrichment plans.
- Scholarship acquisition and discovery controls.
- AER source, reader, coverage and review controls.
- Intake date and course description enrichment.
- Ranking ingestion and refresh.
- Coverage & completeness.
- Platform health and integration queue.
- Layer 4 review.

The repository already implements:

- "src/EnrichFields.jsx"
- "src/ScheduledJobsWorkspace.jsx"
- "public.admin_enrich_fields"
- "public.admin_enrich_plan"
- "scheduler_policy_run_now_v1"
- Enrichment-plan scheduled jobs

Reuse them.

For each control record:

1. Exact UI location.
2. Applicable role.
3. Available action.
4. Supported country/provider/course/field scope.
5. Backing function and scheduled job.
6. Current deployed/enabled state.
7. Whether a manual run works.
8. Whether automatic execution works.
9. Evidence and cost controls.
10. Missing capability or defect.

Do not report a feature as operational merely because its source code exists.

Do not create another dashboard when an existing control can be repaired or extended.

3. Required manual enrichment capability

The operator must be able to select:

Scope

- Country.
- State or subdivision where appropriate.
- One provider.
- Multiple providers.
- All eligible providers.
- A course or bounded course cohort where supported.

Data fields

- Course description.
- Official course link.
- Tuition and associated fees.
- Intake month/year/start date/deadline.
- Academic entry requirements.
- English entry requirements.
- Scholarships.
- Rankings.
- Provider description.
- Other existing supported enrichment fields.

Execution

- Preview coverage and eligible missing values.
- Show existing stored evidence.
- Estimate new Firecrawl/AI expenditure.
- Select stored-evidence-only or permit authorised new acquisition.
- Run now.
- Schedule a recurring job.
- Pause or resume.
- Cancel safely.
- Retry failed items.
- Monitor progress.
- Export execution and evidence results.

Check what is already supported. Extend existing controls only for actual gaps.

Field-specific jobs must use the existing platform engines. Do not duplicate extraction logic inside an Admin control.

4. Required automatic enrichment capability

StudySearch must automatically:

1. Discover coverage gaps across the active catalogue.
2. Classify gaps by field, provider, country and evidence availability.
3. Reuse verified stored evidence first.
4. Prioritise eligible gaps according to existing configured policy.
5. Create or resume bounded enrichment work.
6. Execute through existing platform workers.
7. Respect concurrency, cost, retry and source limits.
8. Route ambiguous evidence to Layer 4.
9. Publish supported values through existing admission gates.
10. Reconcile Website API v2 and Zoho output.
11. Close completed work with evidence.
12. Reschedule unresolved or newly stale records appropriately.

An integration queue item must not require Claude to act as the normal dispatcher.

The platform scheduler and configured workers own operational execution.

5. Self-sustainability acceptance test

Perform a controlled end-to-end test using representative Australian providers and courses.

Test at least:

- University description.
- Course description.
- Intake date.
- AER academic requirement.
- Scholarship discovery.
- Ranking refresh, where supported.

For each, validate two modes.

Manual mode

The authorised operator selects an eligible scope in the existing UI, previews the expected work and starts it.

Verify:

- Job created.
- Scope correct.
- Execution actually begins.
- Stored evidence used where available.
- Real work completed.
- Admission rules respected.
- Layer 4 receives unresolved evidence.
- Catalogue updated where authorised.
- API output reconciled.
- Audit and cost recorded.

Automatic mode

Configure a bounded eligible cohort under existing automation authority.

After the initial configuration, stop issuing per-record instructions.

Verify that StudySearch independently:

- Identifies work.
- Starts the relevant jobs.
- Processes records.
- Handles retries.
- Detects hidden failures.
- Publishes only accepted data.
- Updates coverage.
- Schedules subsequent work.

The acceptance test fails if Claude must continually prompt individual jobs to progress.

6. Keep manual and automatic control consistent

Manual and automatic runs must use the same core enrichment, evidence, Layer 4 and publication mechanisms.

They may have different schedules and separately configured budget allowances.

Manual execution must not bypass data integrity rules.

Automatic execution must not bypass approval gates.

Support predictable deduplication, locking and supersession when a manual run overlaps an automatic job.

A manual "Run now" should accelerate a bounded job without permanently changing its recurring schedule.

7. Country scalability

Demonstrate that the orchestration mechanism supports AU, NZ and CA using shared engines with country-specific configuration.

A country added to the active catalogue must become eligible for relevant gap checks and schedules through the approved onboarding process.

Do not hardcode Australia-specific provider selection into the shared orchestration layer.

Where a country-specific adapter does not exist, report that explicitly and route the work to the integration queue.

8. Continuous delivery role of Claude

Continue six engineering agents:

A — AER mechanisms and controls.

B — Scholarship acquisition mechanisms and controls.

C — Description processing mechanisms and controls.

D — Intake mechanisms and controls.

E — Layer 4, housekeeping and evidence.

F — Integration, scheduling, UI testing and production assurance.

These agents repair the platform.

They do not become the permanent enrichment workforce.

Once a mechanism is fixed, the platform must process its corresponding backlog through its own workers.

9. Performance and operational targets

Measure:

- Eligible backlog per field.
- Active jobs per field.
- Actual records processed per hour.
- Accepted records per hour.
- Records awaiting Layer 4.
- Failed/retried records.
- Idle due to budget or source limits.
- Source and AI consumption.
- Time since last successful work.
- Manual versus automatic job throughput.

Use these measurements to forecast completion rather than selecting arbitrary project dates.

Do not increase concurrency if it causes more production failures.

10. Required output

Produce a Platform Enrichment Control and Autonomy Acceptance Report in Admin.

Include a matrix of every required field against:

- Existing UI control.
- Manual execution support.
- Automatic execution support.
- Production verification.
- Known limitations.
- Corrective engineering task.

Provide a demonstrable operator workflow such as:

Select Australia → Select course descriptions → Preview missing fields → Use stored evidence → Run now → Monitor → Verify admitted values.

Also demonstrate the corresponding unattended automatic workflow.

For unavailable capabilities, fix the underlying existing system and its control surfaces rather than adding one-off Claude scripts.

11. Completion definition

The platform passes only when:

- Manual enrichment can be launched by an authorised operator.
- Automatic enrichment progresses without an active Claude session.
- Missing fields are discovered without manual provider-by-provider investigation.
- Existing evidence is reused.
- Paid tools obey configured controls.
- Layer 4 governance is enforced.
- Incorrect data is contained.
- Website and Zoho output is reconciled.
- Progress and failures are visible through existing Admin features.
- AU/NZ/CA compatibility is demonstrated.
- No Claude-operated manual enrichment loop is necessary.

The principal acceptance question is: If Claude stops working now, does StudySearch continue discovering, enriching, validating and publishing eligible data correctly?

If not, identify the exact broken component and correct it.

Do not declare the programme complete until this test passes.