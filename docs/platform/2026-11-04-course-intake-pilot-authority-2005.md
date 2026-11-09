<!-- Platform Admin decision, received 4 Nov 2026 20:05 AEDT; recorded verbatim before code. Supplies the course intake pilot definition referenced by the 20:02 correction. -->

StudySearch — Course Intake Pilot Authority and Immediate Execution

Platform Admin decision — 4 November 2026

This message supplies the missing pilot definition and authorises its implementation.

Record it in the existing Admin repository and execution register before development.

Do not wait for another copy of the earlier mandate.

1. Approved pilot

Target: Course Intake Dates.

Scope: 20 automatically selected eligible courses.

The pilot must use existing official stored evidence and approved academic calendars.

Select courses through existing eligibility rules, prioritising missing or incomplete:

- Intake month.
- Intake year.
- Exact course start date.
- Application deadline.

Use a fixed cohort for comparison and audit.

Include multiple providers and different evidence patterns where eligible.

Do not invent course IDs, dates or source evidence.

2. Existing operational jobs

Production already has:

- "intake-dates-apply": hourly at :26, maximum 200 rows per run.
- "coverage-admit-intakes": every 10 minutes, maximum 300 per run.

Reuse these existing jobs and their authoritative functions.

Do not create another intake extraction engine or duplicate scheduler.

Confirm their current contracts and dependencies against the live database.

3. Governed Run Now — approved

Build the smallest reusable Run Now capability that safely invokes an existing catalogue job.

Requirements:

- Use an existing authorised job identity.
- Validate operator permissions.
- Check job catalogue registration.
- Respect existing pause, budget and concurrency controls.
- Select eligible work automatically.
- Apply a pilot batch cap of 20 courses.
- Prevent duplicate in-flight execution.
- Record requester, reason, run ID, start, finish and result.
- Return processed, admitted, skipped and failed counts.
- Avoid direct per-course SQL dispatching.

Prefer extending the existing task-management Run Now mechanism rather than creating a new one.

Do not expose arbitrary SQL execution or allow a job to bypass its normal restrictions.

Run the normal intake pipeline with a bounded selector. Do not construct a test-only publishing path.

4. Validation target

Immediately after deployment, execute the 20-course pilot through Run Now.

Verify:

1. Automatic work selection.
2. Correct source identity and stored evidence.
3. Correct month, year and exact-date extraction.
4. Correct application deadline association.
5. Existing validation and admission controls.
6. New active intake values.
7. Website API v2 publication.
8. Zoho consistency where supported.
9. No manual-value overwrite.
10. No unauthorised expenditure.

A newly published value must be supported by actual official evidence.

5. Acceptance

Target: 10 newly verified intake values published from the fixed 20-course cohort.

Return:

- PASS: At least 10 eligible new values correctly admitted and published, zero incorrect values, with the governed autonomous path working.
- FAIL: Eligible work exists but a technical defect prevents processing, admission or publication.
- BLOCKED: Source evidence, current admission policy, existing operational caps or human authority prevents the proposed target.

If the cohort contains fewer than 10 genuinely eligible values, report the evidence-backed denominator and mark the numerical target unmet. Do not substitute unrelated courses to manufacture success.

Every validation result must be recorded against the exact cohort and corresponding source evidence.

6. Timing

The validation gate is 5–10 minutes after the relevant deployment.

Do not wait for the next scheduled hourly run.

Sequence:

- Verify deployment and configuration.
- Execute authorised Run Now.
- Check catalogue changes.
- Verify website and Zoho read-back.
- Record verdict.

If execution exceeds the bounded window, return BLOCKED with the exact cause and next action.

Normal scheduled processing continues separately.

7. Autonomous continuation

Once the pilot passes, retain the authorised scheduler as the operational executor.

Use the existing progress observer and recovery knowledge base to:

- Detect new eligible intake gaps.
- Select subsequent batches.
- Recognise previously verified extraction patterns.
- Skip deterministic failures.
- Recover transient failures within existing limits.
- Verify admission and publication.
- Reopen integration issues on regression.

Do not make Claude responsible for selecting or dispatching individual courses.

8. Development boundary

This is one small, targeted operational improvement.

Do not expand into AER, scholarships, descriptions, provider lifecycle or another autonomy framework.

Keep critical incidents and normal platform monitoring operating independently.

Report the result through the existing Admin execution register.

Deliverable: A production-verified 20-course intake pilot, a governed reusable Run Now control and an immediate PASS / FAIL / BLOCKED verdict backed by real data.

No 24-hour wait is required for initial operational acceptance.