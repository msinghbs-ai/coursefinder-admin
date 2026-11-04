<!-- Platform Admin correction, received 4 Nov 2026 20:02 AEDT; recorded verbatim before code. -->

StudySearch — Immediate Production Validation (5–10 Minutes)

Platform Admin correction — 4 November 2026

Replace the previous course-intake pilot mandate with the following validation timing requirements. All other source, admission, budget and governance safeguards remain unchanged.

1. Mandatory 10-minute acceptance gate

Every new autonomous capability must demonstrate an actual production outcome within 5–10 minutes of deployment.

Do not wait for the next hourly scheduled execution.

Do not require a 24-hour observation before initial operational acceptance.

After deployment, the Integration Controller must immediately invoke the existing authorised job through its governed run-now mechanism, using a small bounded workload.

This is an immediate validation execution, not manual per-course dispatch.

The normal scheduler must subsequently continue the same work without Claude.

2. Intake pilot — first application

Use the approved 20-course intake pilot.

The job must independently select eligible courses with verified stored official evidence.

Within the validation window, demonstrate:

1. Work selected automatically.
2. Existing stored evidence read.
3. Intake month/year or exact start date extracted.
4. Official source quotation validated.
5. Existing admission rules applied.
6. Valid intake records admitted.
7. Website API v2 publication verified.
8. Zoho consistency verified wherever supported.
9. Actual new data count reported.

Do not count jobs created, pages read or items queued as successful publication.

3. Immediate execution and verification

Use this sequence after each relevant release:

Minute 0–2: Verify deployment, function definitions, migration and active configuration.

Minute 2–5: Run the existing authorised intake worker against the bounded pilot. Capture selected, processed, skipped, refused and admitted counts.

Minute 5–8: Verify catalogue records and Website API v2/Zoho read-back.

Minute 8–10: Record PASS, FAIL or BLOCKED with actual numbers and evidence.

These are execution targets, not reasons to bypass resource or admission controls.

If the job cannot complete in the window, return BLOCKED with the exact dependency or performance cause.

4. Automatic fail-fast behaviour

If the first immediate execution produces no valid data:

- Identify why.
- Check whether the selected cohort contains eligible source-backed intake values.
- Diagnose the most important specific blocker.
- Correct only the issue preventing the pilot from succeeding.
- Re-run the same bounded validation after the fix.

Do not expand to other enrichment fields.

Do not build additional autonomy infrastructure unless it is required to resolve the demonstrated blocker.

If an admission requires human authority, report BLOCKED — HUMAN DECISION instead of manufacturing an automated PASS.

If there are no valid intake dates in the cohort, report BLOCKED — NO ELIGIBLE EVIDENCE rather than inventing values.

5. Two levels of verification

Level A — Immediate operational acceptance (mandatory)

Completed within 5–10 minutes of deployment.

Proves the capability can execute correctly and produce a verified downstream result under its existing authority.

Level B — Continuous reliability monitoring (non-blocking)

The existing scheduler subsequently monitors normal execution, recovery, publication and regressions.

A 24-hour observation may support a stronger reliability claim but must not delay the initial operational verdict or authorised expansion.

Regression automatically reopens the existing issue.

6. Reporting

At the end of the immediate validation, report only:

Measure| Result
Release| 
Pilot courses selected| 
Valid source-backed intake values| 
Newly admitted values| 
Newly published Website values| 
Zoho values checked| 
Failed/skipped with reasons| 
AI/Firecrawl spend| 
Production acceptance| PASS / FAIL / BLOCKED
Next automatic scheduled run| 

Include links to production evidence and the existing execution-register entry.

Do not report that an autonomous capability is complete merely because a migration deployed or a job ran successfully.

7. Continued operation

After an immediate PASS, allow the existing scheduler to process further eligible courses within the approved limits.

No Claude intervention should be required for ordinary selection, extraction, validation, admission or publication.

The existing operations observer must detect and reopen genuine regressions automatically.

Final direction: Build → Deploy → Run immediately → Verify data → Accept or fail, within 10 minutes.

Stop using prolonged observation periods as a substitute for immediate end-to-end validation.