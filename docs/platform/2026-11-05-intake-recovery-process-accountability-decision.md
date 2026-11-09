<!-- Recorded verbatim from the Platform Admin's attachment received 5 Nov 2026 09:11 AEDT (session). Supersedes the short answers in 2026-11-05-intake-calendar-fix-decisions-0905.md where they differ. -->

# StudySearch — Approve Intake Recovery and Establish Permanent Process Accountability

**Platform Admin decision — 5 November 2026**

Approve the three decisions presented:

1. Build the bounded AI-supported academic-calendar reading fix.
2. Permit unique month-to-calendar-period matching under the safeguards below.
3. Resume Decision 179 Course Link reconciliation using existing authorised limits and governance.

These approvals do not lift the general discretionary release hold. Develop through PRs, complete production-representative tests and use the existing Integration Controller's controlled release process.

## 1. Correct the actual intake pipeline

The intended platform architecture already includes:

- Course and provider adapters.
- Official course-page acquisition.
- Stored source evidence.
- Central university policies and academic calendars.
- Layer 2 deterministic readers.
- Layer 3 approved AI readers.
- Admission and Layer 4 controls.
- Catalogue persistence.
- Website and Zoho publication.

Do not build another disconnected calendar reader.

Trace and correct the complete existing workflow:

Official course page → Course identity → Intake wording → Applicable academic calendar → Period or exact-date extraction → Evidence validation → Admission → Catalogue → Consumer publication.

The reader must distinguish:

- Intake month.
- Intake year.
- Exact commencement date.
- Application deadline.
- Named semester, trimester or term.
- General university academic dates.
- Course-specific exceptions.

Do not confuse semester enrolment, orientation, teaching commencement and application deadline dates.

Use current or future official evidence. Preserve historical dates without presenting them as upcoming intakes.

## 2. AI calendar reading — approved within existing budgets

Extend the existing approved reader and AI toolsets.

Read stored official academic-calendar pages first.

Use existing approved AI models only when deterministic extraction cannot interpret the source safely.

AI must produce structured evidence-backed proposals, not directly overwrite protected catalogue values.

Retain:

- Provider and calendar identity.
- Academic year.
- Period name.
- Start/end dates.
- Date meaning.
- Exact source quotation.
- Source URL and stored evidence version.
- Model and parser version.
- Extraction outcome.
- Applicable courses.
- Admission decision and publication result.

If the current approved calendar points to the wrong document, identify the correct official source and route the replacement through the existing approval mechanism.

Do not silently replace protected approved calendar bindings.

## 3. Unique month matching — approved

A course-page statement such as "February intake" may resolve to an exact calendar commencement date only when:

- The course belongs to the correct provider and calendar.
- The calendar year matches the intended intake year.
- The approved calendar contains exactly one eligible commencement period in that month.
- That date represents a suitable course commencement event, not orientation or an application deadline.
- No more specific course-level date contradicts it.
- The source and mapping are recorded.
- Existing admission rules permit the result.

If ambiguous, preserve the month-only intake.

Do not manufacture exact dates from general calendars.

Add regression tests for multiple periods, different years, wrong calendars, course-specific exceptions and missing academic-year evidence.

## 4. Resume Decision 179 Course Link reconciliation

Resume the previously approved university-by-university reconciliation.

Keep:

- Existing approved scope.
- Provider identity checks.
- Manual binding locks.
- Source evidence.
- Reversible transitions.
- Existing processing limits.
- Layer 4 admission authority.

Measure course identity resolved, stored pages newly usable and enrichment jobs newly eligible.

Moving an item between queues is not an admission.

Do not permit Course Link reconciliation to delay intake processing for providers whose identity is already verified.

## 5. Permanent process accountability

Effective for this change and subsequent development, every production process must have a maintained operational record in the existing Admin repository.

Do not create another competing execution register.

For each process record:

- Purpose and owner.
- Source inputs and required evidence.
- Registered job and schedule.
- Toolsets and models used.
- Settings, limits and spending controls.
- Reader and validation rules.
- Admission authority.
- Consumer destinations.
- Current coverage and backlog.
- Last successful execution.
- Latest run result.
- Failure classifications.
- Outstanding blocked work.
- Next eligible action.
- Scheduled recheck conditions.
- PR, migration, release and issue references.
- Measured admitted and published deltas.

Use the existing Admin execution register, lineage documentation and integration queue as the authoritative records, linked to each process.

Persist detailed per-item execution history in the platform database and expose it through the Admin UI.

Publish concise, dated production checkpoints into the Admin repository through the existing reporting mechanism.

Do not overwrite previous failure evidence when a new run succeeds.

## 6. Process results UI — required

Extend the existing Layer 2/3 Operations workspace.

For intake and calendar processing, the operator must see:

- Providers and courses eligible.
- Stored course-page coverage.
- Approved calendar coverage.
- Calendar year and freshness.
- Extracted intake values.
- Rejected or ambiguous evidence.
- Skipped courses and exact reasons.
- Current processing state.
- Admitted records.
- Website/Zoho publication status.
- Last attempt and its outcome.
- Next scheduled revisit.
- AI/Firecrawl usage and cost.

Provide Preview, governed Run Now, Results, Verify and authorised recovery controls using existing backend operations.

Include direct links to the stored official evidence and relevant Layer 4 item.

The UI must reflect actual saved operational results, not synthetic counts or temporary browser state.

## 7. Learn from newly encountered page formats

When an existing reader encounters unfamiliar source wording or a new calendar format:

1. Preserve the source and failure example.
2. Classify why parsing failed.
3. Check existing verified extraction patterns.
4. Reuse an applicable authorised pattern.
5. Use an approved AI reader where permitted.
6. Validate the proposed interpretation against source evidence.
7. Record success or failure.
8. Add verified reusable cases to the existing recovery knowledge base.
9. Re-evaluate previously held items when a reader or evidence version changes.

Repeated deterministic failures against unchanged conditions must not be retried.

Do not allow unreviewed AI output to change production extraction policy or admission authority.

New parser or policy changes require governed tests and release review.

## 8. Revisit and freshness

Every held or missing intake value must have a next-action classification:

- Awaiting official calendar.
- Calendar needs correction.
- Course identity unresolved.
- Evidence ambiguous.
- Reader correction needed.
- Human decision required.
- Budget or operational limit.
- Not published by provider.
- Waiting for next academic year.
- Ready for scheduled recovery.

Set the next check through existing configurable scheduling rules.

Trigger reconsideration when official evidence, calendar edition, relevant settings or reader version changes.

Do not repeatedly read unchanged sources without a valid recovery trigger.

## 9. Correct pre-production validation

Preserve the lesson from v2.15.477 and PR #872:

A successful PR test is not sufficient if the test database omits production constraints.

Use production-equivalent schema contracts, triggers, grants, job outcomes, relevant time-outs and real admission functions in isolated integration tests.

Prove course-page/calendar joins, AI output validation, intake persistence, Layer 4 routing and consumer projections.

Benchmark with realistic university-scale data.

Do not merge a PR with an unresolved production backend dependency.

## 10. Required production proof

For the existing top-10 Australian university cohort, report:

| Measure | Before | After | Change |
|---|---:|---:|---:|
| Eligible courses | | | |
| Course pages stored | | | |
| Valid calendar sources | | | |
| Current/future calendar periods extracted | | | |
| Intake months supported | | | |
| Exact commencement dates supported | | | |
| Application deadlines supported | | | |
| Values admitted | | | |
| Values published to Website API v2 | | | |
| Zoho values verified | | | |
| Held or skipped | | | |
| Next scheduled rechecks | | | |

Break down the results by university.

Include the reason each university remains incomplete.

After an authorised release, execute a bounded governed run and verify the actual data result within the 5–10-minute acceptance target.

Do not count successful extraction as admission or successful admission as publication.

## 11. Operational ownership

Claude and Codex develop and correct the platform.

StudySearch must operate the approved readers, select eligible work, retry recoverable failures, apply authorised admissions and verify publication through its own scheduled workers.

The Platform Admin makes protected policy and human admission decisions.

**Do not require the Platform Admin to discover and report missing data formats or broken hand-offs university by university.**

The existing operations observer must detect these failures, record the root cause and route the appropriate next action.

## Completion

The feature is accepted only when:

- Course-page and calendar evidence are correctly connected.
- Future academic dates are extracted and validated.
- Eligible intake values reach the catalogue.
- Consumer publication is independently verified.
- Failed and skipped cases have durable reasons.
- Revisit scheduling works unattended.
- The Admin UI displays real results.
- The Admin repository holds the process design and verified outcomes.

A successful deployment, AI extraction, lower queue count or added documentation alone is not completion.