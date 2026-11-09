<!-- Recorded verbatim from the Platform Admin's attachment received 5 Nov 2026 12:44 AEDT (session). Supersedes the earlier intake-calendar recovery directions of 5 Nov 2026 where they differ. -->

# StudySearch — Final Intake Recovery Strategy and Self-Sustainability Acceptance

**Platform Admin mandate — 5 November 2026**

This supersedes the earlier fragmented directions concerning intake-calendar recovery, zero-yield investigation and additional reader corrections.

## Executive decision

Approve one bounded intake-recovery implementation using the existing StudySearch architecture.

**Do not expand or refactor the wider enrichment platform.**

The objective is to demonstrate a complete, independently operating workflow:

Stored official course page + applicable university calendar → Validated intake dates → Authorised admission → Catalogue → Website publication → Automatic future processing and verification.

StudySearch must operate this workflow. Claude's responsibility is to correct the demonstrated engineering defects and verify the result, not manually process university records.

The general discretionary release hold remains active, except for this specifically authorised bounded intake recovery workstream, subject to the normal release gates.

## 1. Existing architecture is mandatory

Reuse:

- University and course adapters.
- Existing stored course-page evidence.
- Approved university calendar sources.
- Existing Layer 2 extraction and Layer 3 AI reading.
- Approved AI model profiles and Toolsets & limits.
- Existing intake planner and calendar reader.
- `intake-dates-apply`.
- `coverage-admit-intakes`.
- Existing calendar re-read and source-refresh mechanisms.
- Existing admission and Layer 4 controls.
- Existing Website API v2 and Zoho projections.
- Existing Run Now, Process results and Task manager controls.
- Existing recovery knowledge base and integration queue.

Do not create a new intake engine, AI controller, scheduler, approval interface or independent monitoring system.

Change only the smallest functions required to repair the verified end-to-end defects.

## 2. Correct known reader defects — R1 APPROVED

The existing official UNSW stored calendar contains 2027 dates, but the reader rejects them because the year is printed in the page heading instead of every individual date row.

Correct this by:

1. Recognising a verified academic year from its enclosing heading, table or document section.
2. Linking the year to the correct rows within that section.
3. Preserving the heading and date-row evidence together.
4. Separating the academic year from the normalised term or semester name.
5. Rejecting rows where the heading cannot be safely associated.
6. Distinguishing commencement dates from orientation, enrolment, census dates and application deadlines.

Mandatory regression evidence includes the recorded UNSW 2027 terms:

- Term 1 — 15 February 2027.
- Term 2 — 31 May 2027.
- Term 3 — 13 September 2027.

These are calendar interpretation examples, not blanket authority to assign those dates to all UNSW courses.

Test Sydney-style PDF calendars and other known layouts using existing stored evidence.

Do not weaken the requirement to prove an academic year.

## 3. Current official calendars — R2 APPROVED

Prioritise official 2027 calendar evidence.

First use the existing stored pages, including the reported 2027 RMIT, UTS, Newcastle and Swinburne documents.

Then acquire genuinely missing or stale current editions using up to **40 Firecrawl credits in total**, within existing approved vendor settings and authority.

Restrict this acquisition to the previously approved top-10 Australian university scope.

Before acquisition:

- Check for an already stored equivalent edition.
- Verify the official university source.
- Confirm the correct country, campus and institution.
- Exclude pathway colleges, residential colleges and unrelated offshore campuses.
- Confirm the document represents the applicable teaching calendar.
- Preserve source lineage and the old calendar edition.

Do not automatically replace manually locked or human-approved bindings where existing governance requires a decision.

Deduplicate source acquisition across universities, editions and courses.

Record actual credit usage and useful yield.

## 4. Correct calendar applicability, not just extraction

A valid calendar date may be assigned to a course only when the existing approved evidence and rules establish applicability.

Validate:

- Provider identity.
- Course identity.
- Intended course audience.
- Academic calendar type.
- Course level and study period.
- Calendar year.
- Period name.
- Source authority.
- Course-specific commencement exceptions.

A course with an explicit official commencement date takes precedence over a general calendar date.

For month-only wording, a date may be derived from an approved calendar only when exactly one valid commencement period matches the course, provider, month and year, with no conflicting source.

If multiple periods match, preserve month-only precision.

A course must not acquire an exact commencement date merely because the university has a term starting in that month.

Do not manufacture application deadlines from semester commencement dates.

## 5. Improve extraction using existing approved AI

Reuse existing pinned AI models and current spending limits to interpret unfamiliar calendar formats.

Support:

- Year headings covering subsequent table rows.
- PDF wall calendars.
- Semester, trimester and term tables.
- Academic-year tabs.
- Multiple calendar editions.
- Different date formats.
- Separate start and application deadlines.
- Different course-specific intake schedules.

AI must return structured proposals with exact source evidence.

Existing deterministic validation and admission controls remain authoritative.

For unfamiliar layouts:

1. Store the source pattern.
2. Record why the current reader failed.
3. Compare with existing validated extraction patterns.
4. Attempt approved interpretation.
5. Validate the extracted dates and applicability.
6. Record the successful or unsuccessful result.
7. Retain a regression case for future occurrences.

Do not let AI independently change production reader code, protected policies, model settings or admission permissions.

Use the current recovery knowledge base rather than building another learning mechanism.

## 6. Fix the actual next-stage hand-off

For each valid source-backed intake value, verify the complete processing chain:

Calendar read → Date proposal → Course match → Intake validation → Admission → Catalogue persistence → Search projection → Website API read-back.

Identify and correct any existing stage that silently drops or ignores a validated value.

Distinguish:

- Extracted.
- Validated.
- Eligible for admission.
- Admitted.
- Published.
- Verified by consumer read-back.

Do not report extraction or calendar auto-approval as an intake admission.

Examine the 13 calendar readings previously auto-approved without producing new dates.

Confirm that those readings were correctly scoped and determine what prevented their values from progressing.

## 7. Prioritise a bounded first data win

Use the top-10 Australian universities already approved for the intake pilot.

For initial production acceptance, select a small cohort of courses whose own official pages and applicable 2027 calendars provide the necessary evidence.

The platform must select this cohort using the existing governed selector.

Do not manually insert course IDs or override eligibility merely to demonstrate success.

Prioritise known, source-proven UNSW 2027 calendar cases where a corresponding course is eligible.

If UNSW has no valid course-to-term mapping, select another evidence-backed eligible course within the approved scope.

Keep the fixed cohort and report the actual eligible denominator.

Do not widen the scope, invent eligibility or modify protected admission authority to achieve a numerical target.

## 8. Self-sustaining scheduled operation

After the initial correction, StudySearch must independently:

1. Discover missing or stale intake values.
2. Find an applicable stored course page.
3. Find the current approved calendar.
4. Read and interpret valid future periods.
5. Validate the course-to-calendar relationship.
6. Apply existing admission rules.
7. Publish eligible values.
8. Verify consumer output.
9. Record failures and next actions.
10. Select the next eligible workload.

The normal scheduler must continue without Claude manually dispatching courses.

Use the existing configured scheduling and budgets.

Do not globally increase concurrency or spending limits.

For the reported backlog of 494 unread calendars, prioritise current, relevant editions through the existing eligibility and scheduling configuration. Do not process irrelevant calendars merely to clear the count.

Ensure that one university or calendar failure does not stall other eligible providers.

## 9. Durable failure handling and revisit

Every skipped or held intake must retain:

- Course and provider identity.
- Source URL and stored evidence ID.
- Evidence year/version.
- Reader version.
- Failure classification.
- Last attempt and result.
- Whether the failure is deterministic or transient.
- Next eligible action.
- Next scheduled revisit or change trigger.
- Related recovery or Layer 4 case.
- Subsequent outcome.

Use at least these classifications:

- No valid calendar source.
- Stale calendar edition.
- Wrong institution or campus.
- Course identity unresolved.
- Calendar interpretation failed.
- Academic year unproven.
- No matching commencement period.
- Multiple periods match.
- Course-level exception.
- Missing application deadline evidence.
- Admission held.
- Consumer publication failed.
- Waiting for next academic year.

Automatically reconsider when source evidence, applicable calendar edition, reader version, relevant settings or course identity changes.

Use bounded transient retries.

Never repeat an unchanged deterministic failure without a valid change trigger.

Do not create unnecessary human interventions for technical problems.

## 10. Admin UI — actual process validation

Extend the existing Layer 2/3 Operations interface.

Reuse Intake Run & Validate and Process results.

The operator must see:

- University and course scope.
- Stored evidence coverage.
- Current calendar editions.
- Valid future periods.
- Proposed intake values.
- Course-to-calendar applicability.
- Rejected and ambiguous candidates.
- Actual newly admitted values.
- Actual published values.
- Skipped and held items.
- Exact failure reasons.
- Last run and next revisit.
- AI and Firecrawl costs.
- Current scheduled processing status.

Provide existing governed Preview, Run Now, Results, Verify and History operations.

No second dashboard.

Run history must survive refresh.

Show university-level results and allow drill-down to individual evidence and dates.

Ensure mobile usability.

## 11. Pre-production gates

Learn from the previously failed v2.15.477 release.

Before deployment, validate against production-representative database constraints and function contracts.

Include:

- Foreign keys and allowed outcome codes.
- Triggers, grants and RLS.
- Existing admission rules.
- Production-compatible statement and lock limits.
- Source identity controls.
- Manual locks.
- API contracts.
- Calendar and course evidence joins.
- Realistic provider distribution.

Use database-backed integration tests, not just UI fixtures.

Mandatory test cases:

- UNSW year-in-heading extraction.
- Calendar year inherited from the wrong section — rejected.
- Date from an unrelated college — rejected.
- Wrong campus or offshore programme — rejected.
- Correct exact course start date.
- Unique approved month-to-period match.
- Multiple periods in a month — remains month-only.
- Missing year — rejected.
- Old calendar edition — not used for future dates.
- Explicit course date overriding general calendar.
- Validated data admitted.
- Held data remains protected.
- Publication matches the catalogue.
- Duplicate and repeated recovery prevented.

Do not merge or release if a known production constraint cannot be reproduced and verified under the established release gate.

## 12. One controlled implementation

Prepare one bounded PR containing the related reader correction, necessary hand-off repair, regression tests and existing UI/result updates.

Avoid unrelated refactoring.

Claude remains the sole Integration Controller.

The approved release sequence is:

1. Record the change in the Admin governance repository.
2. Build and test the bounded correction.
3. Independently review relevant production constraints.
4. Complete all required release gates.
5. Merge and deploy through the existing workflow.
6. Immediately execute the governed production acceptance test.
7. Return an evidence-backed verdict.

Do not create repeated corrective releases automatically after a failed production test.

A failure returns to the existing integration issue with its precise cause and a bounded remediation proposal.

## 13. Acceptance Gate A — Prove data admission

Target a 5–10-minute production validation window after deployment.

Demonstrate:

- Real eligible source evidence.
- Valid future commencement date extracted.
- Correct course-calendar mapping.
- Existing admission rules followed.
- At least one genuinely new, correct 2027 course start date admitted.
- The same date visible in Website API v2.
- Actual run and evidence visible in the Admin UI.
- No manual per-course SQL dispatch.
- No incorrect admissions.

A valid source-backed record that requires protected human approval must not be auto-approved to pass this gate.

If no eligible record exists within current authority, return BLOCKED with the exact evidence or decision needed.

Do not report PASS from calendar readings alone.

## 14. Acceptance Gate B — Prove unattended continuation

After Gate A, observe the next normal scheduled processing cycle.

Verify that StudySearch itself:

- Selects the next eligible intake work.
- Runs the required readers.
- Applies permitted values.
- Handles skipped records with durable reasons.
- Avoids duplicate deterministic attempts.
- Verifies published changes.
- Creates actionable issues for genuine failures.
- Schedules the next eligible revisit.

Claude may observe and report but must not manually dispatch individual courses.

If no eligible work exists at that cycle, record that fact and verify the scheduling and hold conditions rather than inventing throughput.

The initial production acceptance need not wait 24 hours.

The existing longer-running monitor should continue independently and detect later regressions.

## 15. Permanent process reporting

Maintain:

`docs/platform/processes/intake-dates.md`

Update it with verified:

- Production version and PR.
- Job and reader state.
- University-level stored-page coverage.
- Current calendar coverage.
- Future periods extracted.
- Course-to-calendar matches.
- New start dates admitted.
- New deadlines admitted.
- Website/Zoho publication.
- Failure reasons.
- Next scheduled revisits.
- Spend.
- Actual scheduled-run results.

Retain prior failed measurements and decisions.

Use the existing execution register, integration issues and database process results. Do not create a competing reporting system.

Include the bounded acquisition and reader corrections in the source, component and lineage records as required by the operating model.

## 16. Production result table

Return one concise university-level table:

| University | Current calendar | Future dates found | Matched courses | Newly admitted starts | Published starts | Held / reason |
|---|---|---:|---:|---:|---:|---|

Also report:

| Measure | Result |
|---|---|
| New production release | |
| PR reference | |
| Valid official calendars | |
| AI reads and cost | |
| Firecrawl credits consumed | |
| New exact start dates admitted | |
| New application deadlines admitted | |
| Website API values verified | |
| Failed or held items | |
| Gate A verdict | PASS / FAIL / BLOCKED |
| Next unattended run | |
| Gate B verdict | PASS / FAIL / BLOCKED |

Do not count previously populated values or a movement between queues as an admission.

## 17. Definition of completion

**The platform must prove it can reuse and interpret official evidence, produce correct intake dates, independently admit and publish eligible values, retain failed cases and continue unattended.**

Do not interpret another green PR, calendar auto-approval, AI read, scheduler run or lower backlog as completion.

No broad refactoring.

No new controller.

No new approval bypass.

No repeated failed releases.

No manual per-course dispatch.

**Build the smallest working correction, demonstrate one real published data gain, and let the existing platform continue independently.**