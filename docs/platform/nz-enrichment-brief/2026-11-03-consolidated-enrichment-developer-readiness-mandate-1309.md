# StudySearch — Consolidated Autonomous Enrichment and Developer Data Readiness Mandate
**Platform Admin — 3 November 2026**

## 1. Executive direction

Continue parallel engineering, but consolidate compatible improvements into substantial releases delivering complete, sustainable enrichment capabilities.

The priority is actual verified data enrichment across providers, courses, scholarships, academic entry requirements and rankings, measured against the Wix developer's 2 November PDF and 3 November email.

StudySearch must independently discover, read, validate, enrich, review and publish eligible data.

Claude develops and validates the platform. Claude must not become the permanent data reader, per-record dispatcher or operator.

Preserve the canonical Admin operating model, Pilot development rules, G1–G4, source evidence, Layer 4 governance, country configuration and production cost safeguards.

## 2. Latest engineering baseline

Reconcile against production before proceeding.

Reported state:

- v2.15.423 deployed; full regression 1,589 passed, zero failed/skipped.
- v2.15.424 page-proof lane and field backlog built; full test run underway, not confirmed deployed.
- Two automatic planning cycles started.
- Cycle 1: five plans completed, 18 field values filled, six review items created.
- Course discovery: 117 pages found from 561 searched, consuming 372 Firecrawl credits.
- Cycle 2: 17 automatic plans started.
- IQ-00064: four of five page-search steps falsely completed with work outstanding.
- Approximately 22,500 stored course pages have verified identity and are candidates for description/deadline extraction.
- Rankings: 47 of 53 published universities have at least one current QS/THE ranking; 45 have both.
- ARWU has no accepted edition.

Do not confuse reported engineering progress with independently verified production acceptance.

## 3. Immediate P0 — Fix IQ-00064

Treat premature completion of held plan steps as a release blocker.

Required behaviour:

1. A lane cannot become idle-paused while eligible plan work remains assigned.
2. A step waiting for a disabled, budget-held or unavailable lane must remain held, not completed.
3. When the dependency becomes eligible, the step must resume automatically.
4. A plan cannot reach `done` while required work remains incomplete unless the remaining work has a valid, explicit terminal disposition.
5. Each step must retain remaining-item count, checkpoint, hold reason and restart eligibility.
6. Repeated retries must be bounded and idempotent.
7. Parent and child task states must reconcile.
8. Monitoring must detect apparent completion with unfinished work.

Reconcile previously affected plans.

Measure the number of prematurely completed steps over the previous seven days.

Recover eligible unfinished work using governed platform scheduling, not ad hoc per-course SQL dispatching.

Verify the correction through real subsequent scheduler cycles.

Do not start the 24-hour self-sustainability acceptance test before this issue is resolved.

## 4. Consolidated release architecture

Develop the following streams concurrently, then integrate according to dependencies.

### Release A — Autonomous orchestration and source discovery

Bundle:

- IQ-00064 correction.
- Automatic re-planning.
- Resumable standing gap queue.
- Source-page proof acquisition.
- E16 course identity reconciliation.
- Free stored-page candidate retry.
- Bounded approved source discovery.
- Correct lane hold/resume.
- Retry and cancellation.
- Manual and automatic deduplication.
- Provider fairness.
- Operational backlog measurements.
- Real worker outcome and failure reporting.
- Integration queue feedback.

The reported 9,841 courses whose candidate addresses were never retried must be assessed through the existing evidence-safe page-finding mechanism.

Do not automatically release unrelated held work or override manually locked sources.

### Release B — Complete course enrichment

Bundle:

- Course descriptions.
- Application deadlines.
- Intake months and exact dates.
- Fee amount, year, basis and currency.
- English requirements.
- Delivery mode.
- Duration.
- Campus assignment.
- Official course URLs.
- Study level and study area.

Integrate these into the same gap-detection, reader, scheduler, validation, admission and publication mechanisms.

Prioritise courses with verified stored pages.

Avoid new Firecrawl spending for data that can be extracted from existing evidence.

### Release C — Provider, academic entry and scholarships

Bundle:

- Provider descriptions.
- Provider source URLs.
- Provider-level and course-level AER.
- IB, A Levels, equivalent qualifications and country-specific rules.
- Undergraduate and postgraduate requirements.
- Source and qualification completeness.
- Scholarship provider coverage.
- Research/HDR scholarships.
- Award amounts, dates and eligibility.
- Nationality/residency restrictions.
- Scholarship-course relationships.
- Layer 4 review and safe supersession.

### Release D — Rankings and consumer API

Bundle:

- QS and THE edition reconciliation.
- ARWU edition availability and licensed ingestion controls.
- Historical provider identity.
- Ranking freshness checks.
- Approved campus name/ID/course-count API additions.
- Approved scholarship nationality-status API addition.
- Wix and Zoho validation.
- Developer PDF/email coverage reconciliation.
- Versioned developer handover.

Do not deploy consumer-visible changes before G3 approval.

Do not unnecessarily hold data enrichment while API approval is pending.

## 5. Platform Admin decisions — adopt the following policy

### D1 — Paid search

Keep the new paid course page-search lane **disabled** at present.

Continue:

- Stored-page reading.
- Existing page candidate retries.
- Official direct reads that incur no additional Firecrawl cost.
- Approved source discovery within existing settings.

Report how many records remain impossible to process without additional paid acquisition.

Provide a quantified Firecrawl credit requirement and projected yield before requesting a budget change.

Do not interpret this decision as disabling other previously authorised Firecrawl jobs.

### D2 — Delivery mode and duration absence

Do not treat a single page lacking delivery or duration information as permanent proof that the provider does not publish it.

Differentiate:

- Not found on the current page.
- Found on another stored official page.
- Requires source discovery.
- Evidence pending.
- Explicitly not stated by the provider.
- Not applicable.
- Source identity unresolved.

Make absence classifications evidence-aware and re-evaluate when new source material arrives.

Do not repeatedly read unchanged pages after a verified negative result.

### D3 — `not stated` classification

Maintain an explicit, configurable classification catalogue.

Use source evidence and field-specific extraction rules.

Never classify a field as genuinely unavailable solely because an adapter returned no value.

Retain evidence, reader version, confidence, result reason and next eligibility date or evidence-change trigger.

Changes to admission policy remain governed.

### D4 — Ranking coverage

For overall ranking availability, classify a university as having current ranking coverage when it has at least one accepted, display-authorised edition from a supported ranking system.

Report separately:

- QS current coverage.
- THE current coverage.
- QS + THE combined coverage.
- ARWU current coverage.
- Historical edition coverage.
- Universities with no current accepted ranking.
- Missing ranking imports.

Do not describe the general coverage indicator as proof that all ranking systems are complete.

Do not invent ARWU data or import unlicensed material.

### D5 — Course description admission

Continue Layer 4 review for course descriptions under the current trust policy.

Do not bypass review to accelerate published counts.

Evaluate a future evidence-based trust policy using measured extraction accuracy, identity precision and independent validation.

Submit any change to the established admission rules for explicit authorisation.

### D6 — Scheduled AER reading

Include the scheduled AER reader in Release C.

Preserve its existing safeguards and confirm the production backlog, reader concurrency, current Layer 4 capacity, retry cost and run-as permissions.

Proposed operational settings:

- Retain the 600-item Layer 4 back-pressure threshold pending evidence of review throughput.
- Retain the proposed maximum of two controlled re-read attempts, subject to existing cost authority.
- Align the manual Read Next Batch selector with the same configurable eligibility rules as automatic scheduling.
- Use only the authorised service identity and verified role permissions already defined by the platform.

Do not activate or spend against a configuration whose approval is still required.

Escalate any exact remaining activation decision as one consolidated request.

### D7 — Validation feedback

Use the existing Admin integration queue as the primary durable feedback destination.

ChatGPT's hourly independent validation is active.

Its findings must be reconciled using existing issue IDs and stable fingerprints.

If direct integration is unavailable, use an Admin report as an interim evidence source, with a documented path for the Integration Controller to ingest it.

Do not claim automatic Claude-to-ChatGPT communication unless that integration is demonstrated.

## 6. Accelerated data processing strategy

Prioritise maximum safe enrichment from verified stored evidence.

The reported backlog includes approximately:

| Field | Missing | Previously reported daily admission |
|---|---:|---:|
| Intakes | 20,723 | 154 |
| English requirements | 13,569 | 14 |
| Fees | 23,349 | 196 |
| Campus | 5,663 | 207 |
| Course-level AER | 24,287 | 0 |
| Course descriptions | 33,879 | No measured rate |
| Application deadlines | 34,042 | No measured rate |

These figures may cover different eligible populations. Verify the denominator and country scope of each before comparing them.

The current projected completion rates are not acceptable as an operational target where recoverable work and existing evidence are available.

Investigate why processing is slow rather than simply increasing concurrency.

Prioritise:

1. Existing verified stored pages.
2. High-confidence extraction yielding multiple missing fields.
3. Unblocked provider/course identity.
4. Existing official policy and calendar pages.
5. Automatic next-batch advancement.
6. Layer 4 throughput capacity.
7. Cost-controlled acquisition for unresolved sources.

Do not bypass evidence validation or allow workers to overload Supabase.

## 7. Field-level coverage and validation

Use the original developer PDF plus the latest email as the developer readiness baseline.

For every field report:

- Eligible records.
- Existing populated values.
- Source-proven missing records.
- Waiting for source proof.
- Queued.
- Processing.
- Held by budget.
- Held by validation.
- Layer 4 pending.
- Admitted.
- Published.
- Website API visible.
- Actual changes in the past 24 hours and seven days.
- Measured throughput.
- Blocking issue.
- Responsible engineering workstream.

Show AU separately from NZ and CA.

Do not mistake total database population for API-visible availability.

## 8. Self-learning and continuous improvement

Use platform outcomes to improve the existing reader and adapter architecture.

Track:

- Per-reader yield.
- Per-provider source identity accuracy.
- Repeated skip reasons.
- Parser-specific failures.
- Newly observed official page patterns.
- Source discovery recall.
- Cost per valid field.
- Admission rejection causes.
- Regression after reader changes.

Validated failed cases should become durable regression examples.

Readers may automatically reuse approved rules and adapt their eligible work selection based on verified evidence.

Unreviewed AI changes must not directly rewrite production extraction policy, provider identity, Layer 4 decisions or publication rules.

Agent-built improvements require normal code review, regression tests and production validation.

## 9. Consolidated release and integration rules

Continue parallel development without unnecessary dependency blocking.

Only the Integration Controller may integrate and release.

Do not ship every individual fix as a separate version unless a production incident demands immediate correction.

Each substantial release must include:

- Complete relevant reader-to-publication integration.
- Settings and job catalogue updates.
- Regression tests.
- Existing operator controls.
- Failure recovery.
- Production instrumentation.
- Measurable enrichment acceptance.
- Change-control and recovery instructions.

A complete release candidate may ship as soon as it satisfies its gates; do not impose artificial release waiting periods.

Critical security, integrity, corruption or availability issues remain eligible for emergency standalone fixes.

## 10. Production acceptance

After each consolidated release, verify:

1. Correct live version and function/migration checksums.
2. Scheduled reader and planner operation.
3. Consecutive automatic batch creation and execution.
4. Correct held/resume behaviour.
5. Actual source-backed field updates.
6. Layer 4 routing and admission.
7. Publication and consumer projection.
8. Wix and Zoho read-back.
9. Failed-item recovery.
10. Budget, concurrency and lock protection.

A release that passes tests but does not produce valid independent data movement remains operationally unaccepted.

After IQ-00064 is resolved and verified, run the full 24-hour unattended self-sustainability test.

## 11. Immediate blocker escalation

Raise new P0/P1 blockers immediately.

For each include:

- Existing or new issue ID.
- Severity.
- Affected field and country.
- Number of affected records.
- Verified evidence.
- Root cause.
- Engineering owner.
- Remediation.
- Release dependency.
- Required approval, if any.
- Production acceptance test.

Do not ask for routine approval already provided by standing authority.

Do not conceal a genuine budget, admission or API change approval requirement.

## 12. Reporting

Report progress by substantial capability rather than by the count of releases.

Use:

| Capability | Development | Integrated | Live | Data gain | Accepted | Blockers |
|---|---|---|---|---|---|---|

Include verified:

- Independently created plans.
- Completed versus falsely completed steps.
- Actual filled fields.
- Newly admitted values.
- Newly published values.
- API-visible improvements.
- Remaining evidence-backed backlog.
- Source identity failures.
- Layer 4 queue and throughput.
- Firecrawl/AI spend.
- Active and resolved integration issues.

Provide four-hour consolidated engineering checkpoints during active remediation.

Immediately escalate genuine blockers.

## 13. Definition of completion

StudySearch passes only when:

- Eligible data gaps independently become work.
- Work continues through successive scheduler cycles.
- Held tasks remain recoverable.
- Workers use verified evidence correctly.
- Valid data reaches Layer 4 or authorised publication.
- Field coverage measurably improves.
- Unrecoverable gaps have explicit reasons.
- Wix and Zoho output remains compatible.
- Manual controls work.
- Cost and identity safeguards remain enforced.
- The unattended 24-hour acceptance test passes.

**Deliver sustainable, substantial enrichment capabilities—not a stream of isolated releases. Prioritise correcting IQ-00064, exploiting the approximately 22,500 verified stored pages, and proving measurable improvements against the developer's data gaps.**