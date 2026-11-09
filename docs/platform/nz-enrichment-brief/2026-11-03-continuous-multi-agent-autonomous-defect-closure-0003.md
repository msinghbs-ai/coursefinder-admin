StudySearch — Continuous Multi-Agent Development, Validation and Autonomous Defect Closure

Platform Admin executive mandate — 3 November 2026

1. Objective

Continue the six-agent StudySearch development programme established overnight.

Move from discrete development assignments to a sustainable engineering cycle:

Detect → Diagnose → Queue → Assign → Repair → Test → Release → Verify → Revalidate → Close.

Do not stop merely because one release completes.

The objective is to eliminate recurring manual data-quality investigations, maintain a working platform and complete operational handover as quickly as the evidence permits.

Continue development and validation concurrently wherever safe.

Use the current canonical Admin operating model, Pilot working rules, change-control decisions, active Layer 4 playbook and execution register.

No new architectural framework or duplicate tracking platform is authorised.

2. First priority — Finish v2.15.409

The latest reported state is:

- Version v2.15.409 has completed 1,498 tests.
- Zero failed and zero skipped.
- Merge is under way.
- Integration queue contains 27 known issues awaiting reconciliation and activation.

Do not assume deployment completed merely because the merge started.

Immediately:

1. Confirm PR merge and deployment workflows succeeded.
2. Verify the live version, migration checksum and expected functions.
3. Reconcile all 27 issues against the latest production state.
4. Confirm issue IDs, severity, owners and deduplication.
5. Activate the approved twice-hourly integration check only after verifying production readiness.
6. Exercise a synthetic issue through detect, classify, assign, resolve and close.
7. Confirm existing issues are not duplicated.
8. Record the exact deployed state in Admin.

If the release fails, fix that release before building dependent changes.

3. Permanent six-agent ownership

Agent A — Academic Entry Requirements

Deliver:

- D-R2 controlled replacement of pending reads.
- D-R3 completeness gate for provider matrix runs.
- Correction of the 170 incomplete course reads reportedly bypassing E13.
- Qualification-first global IB/A Levels/GAC handling.
- Country, provider, qualification and programme coverage checks.
- Reader regression across representative AU/NZ providers.

A corrected read must preserve earlier evidence, supersede its pending predecessor safely and require governed approval.

Never approve incomplete reads automatically.

Do not treat a read as complete merely because the worker returned success.

Acceptance requires source completeness, correct identity and consumer applicability, not simply a reduction in Layer 4 pending counts.

Agent B — Scholarship Coverage

Deliver F1–F10 and the permanent provider coverage mechanism.

Validate:

- All official scholarship listing sources.
- Every pagination page and continuation.
- One distinct candidate per actual award.
- Duplicate/edition handling.
- Research, faculty, international and undergraduate/postgraduate awards.
- Correct closing dates and status.
- Correct benefit and eligibility extraction.
- Provider/course associations.
- Discovery-to-admission-to-publication reconciliation.
- Hidden failed runs and zero-yield detection.

Use UNSW as a regression cohort, not as the only provider being repaired.

A provider is not complete just because the discovery job returned success.

Track whether the source catalogue was exhaustively traversed and which pages or awards remain unresolved.

Keep changes to non-university eligibility, the 30-course threshold and other policy-gated settings disabled until explicitly approved.

Agent C — University and Course Descriptions

Deliver:

- Correct official About-page selection.
- Evidence-backed provider descriptions.
- Verified stored-course-page reuse.
- Up to 1,200-character support where authorised.
- Preservation of original evidence and provenance.
- Detection of incomplete or truncated extracts.
- Review routing for unsupported descriptions.

Do not manufacture university descriptions from general knowledge.

Do not silently substitute promotional material from an unrelated provider page.

Reuse stored evidence before initiating paid acquisition.

Agent D — Intake Calendar and Date Accuracy

Deliver:

- Correct interpretation of "Semester 1 and 2".
- Correction and regression of the UWA misreading.
- Persistence of year, start date and deadline where explicitly available.
- Handling of month-only, rolling and unknown-date cases.
- Course/campus/intake identity checks.
- Safe updates without overwriting more specific existing verified dates.

A semester label is not permission to invent a calendar date.

Validate existing populated intake rows and compare source evidence with the Website API.

Agent E — Layer 4, Housekeeping and Source Protection

Deliver:

- Stop course-url-fill modifying values currently protected by Layer 4.
- Preserve manual locks, source history and review decisions.
- Prevent duplicate pending items.
- Audit superseded links and rejected evidence.
- Route unresolved data into the correct existing Layer 4 kind.
- Verify records safely withheld from consumers.
- Reconcile source evidence before and after corrections.

Missing course links, fees and descriptions are not automatically release blockers.

Incorrect published values are release blockers until safely contained.

Never physically delete source evidence or bypass governed admission to clear the queue.

Agent F — Integration, QA and Operational Closure

Own:

- Integration queue v2.15.409.
- Hidden job-failure detection.
- Zero-yield classification.
- Stalled and repeated job detection.
- Cross-layer validation.
- Full regression and release readiness.
- Website and Zoho API compatibility.
- Production checksum verification.
- SS-015 evidence.
- Operational progress reporting.

Agent F must independently test the corrections from Agents A–E.

A developer's own test pass alone is insufficient to close a production issue.

4. Continuous integration queue

Use the existing integration queue as the single operational defect register.

Each item must contain:

- Permanent issue ID.
- First detected and last observed timestamps.
- Affected provider/course/source identifiers.
- Country and layer.
- Failure category and severity.
- Reproducible evidence.
- Root-cause classification.
- Assigned workstream.
- Linked decision and authorisation.
- PR and release version.
- Regression test.
- Production verification.
- Revalidation outcome.
- Final disposition.

Use stable fingerprints to deduplicate recurring findings.

Do not generate a new issue on every hourly run for the same unresolved defect.

Do not automatically close an issue because the pipeline's next invocation succeeds.

Close only when its root cause is fixed or an accepted containment is verified.

If a supposedly closed issue recurs, reopen its existing ID and report the regression.

5. Continuous validation coverage

Validate every material layer boundary:

Layer 1 → Layer 2

- Provider/course registry identity.
- Active versus retired provider.
- Official source discovery.
- Provider scope.

Layer 2 → Layer 3

- Correct website and programme.
- Page completeness.
- Evidence availability.
- Pagination completeness.
- Reader success versus actual yield.

Layer 3 → Layer 4

- Full candidate-set preservation.
- Identity and provenance.
- Unambiguous qualification/audience.
- Dropped-row diagnostics.
- Review creation and deduplication.

Layer 4 → Catalogue

- Approved decisions only.
- Exact authorised edits.
- Manual locks preserved.
- Rejected and superseded values excluded.
- Evidence history retained.

Catalogue → Search projection

- Correct active value.
- Correct provider/course association.
- No held value incorrectly published.
- Freshness within the existing limit.

Search projection → Wix/Zoho

- Contract compatibility.
- Correct stable IDs.
- Values and types preserved.
- No unsupported URL, fee, entry or scholarship eligibility.
- Correct interpretation of unavailable versus under-review information.

Create regression coverage for a newly identified failure class once at the appropriate boundary, rather than duplicating assertions for every affected provider.

6. Continuous development policy

Agents may investigate and implement independent authorised changes concurrently.

One main integrator controls:

- Shared migrations.
- Integration conflicts.
- Production releases.
- Database writes.
- Configuration activation.
- Final acceptance evidence.

Each issue should progress through:

Detected → Triaged → In development → Test passed → Release queued → Deployed → Live verified → Revalidated → Closed.

Blocked issues must identify the exact missing authority or evidence.

Avoid agents waiting idle for another workstream when they can safely complete independent work.

However, do not start dependent changes against an unverified release.

7. Resource-aware operation

Previous production admission jobs timed out during heavy verification and Firecrawl activity.

Set explicit validation protections:

- Limit heavy production queries.
- Prefer stored evidence, bounded indexed reads and isolated fixtures.
- Avoid the known admission peak windows.
- Use adaptive Firecrawl concurrency.
- Respect normal budgets after temporary authorisation expires.
- Prevent parallel agents running competing large scans.
- Stop low-priority validation when database load or job latency rises.
- Distinguish capacity throttling from actual failed work.

Do not increase concurrency merely to consume expiring Firecrawl credits.

Use remaining budget only for authorised, useful work.

8. Automated testing and release gate

For each engineering change:

1. Confirm Admin decision traceability.
2. Run targeted regression.
3. Run the complete governed test suite.
4. Require zero failures and zero skipped required tests.
5. Verify migration and function checksums.
6. Perform a live dry run where required.
7. Merge and deploy under the existing approved authority.
8. Verify the live release.
9. Test the affected production behaviour.
10. Validate Website and Zoho where consumer output is involved.
11. Update Admin evidence and issue state.

Never classify a PR merge as a completed production fix without live verification.

If the release changes Layer 4 controls, verify compatibility before resuming review writes.

9. Continuous reporting

Provide one consolidated operational checkpoint every four hours during active overnight execution and after material releases.

Include:

- Current production version.
- Successful releases and verification evidence.
- Six-agent workstream progress.
- Integration issues: open, new, fixed, reopened, blocked.
- P0/P1 issues still uncontained.
- AER providers and rows discovered/extracted/admitted.
- AER incomplete-read count and Layer 4 status.
- Scholarships discovered/admitted/published, by country/provider.
- Scholarship source pagination completeness.
- University/course description coverage.
- Intake date coverage.
- Wix/Zoho field and contract health.
- Firecrawl and AI spend.
- Scheduled-job failures, timeouts and recovery.
- SS-015 Gates A–E.
- Next eligible changes for release.

Do not send repeated updates saying only that tests are running or agents are waiting.

Report meaningful progress, new blockers or decisions requiring intervention.

10. Avoid endless validation loops

Do not repeatedly reopen known gaps as new incidents.

For each gap:

- Identify the shared root cause.
- Correct the central mechanism.
- Validate the full affected cohort.
- Preserve valid data.
- Quarantine unresolved records.
- Assign normal enrichment gaps to Layer 4 or scheduled operations.
- Demonstrate that the same failure cannot silently recur.

Do not require every scholarship, description, intake date or academic requirement to be populated before production handover.

Completion means reliable mechanisms, correct published values and governed ongoing coverage work.

11. Acceptance and scope

Continue SS-015 accelerated acceptance independently of ordinary enrichment coverage.

Do not automatically restart observation windows for P2 defects.

Do not disguise real failures as clean runs.

Any exception-based acceptance must preserve the actual threshold result, cause, remediation, successful retest and explicit risk disposition.

Do not introduce unapproved API shape changes, paid acquisition, destructive corrections or autonomous Layer 4 approvals.

12. Overnight execution instruction

Reconcile the current actual state first.

Then:

1. Finish and verify v2.15.409.
2. Activate and test its integration queue as authorised.
3. Confirm all 27 known issues are represented once.
4. Continue A–E implementation and regression in parallel.
5. Add central hidden-failure and zero-yield checks.
6. Release ready independent fixes through the integrator.
7. Revalidate fixes against production and consumer outputs.
8. Keep unresolved issues assigned to an agent or approved operational owner.
9. Prepare a consolidated release and coverage report.
10. Continue the cycle while the execution environment supports unattended operation.

No further general authorisation is required for actions already within existing approved governance.

Stop only for a genuine approval boundary, unsupported evidence, safety risk, cost breach or production incident that requires intervention.

The desired outcome is a sustainably maintained StudySearch platform in which agents continually detect, repair and validate defects, rather than relying on the Platform Admin to discover data gaps manually.