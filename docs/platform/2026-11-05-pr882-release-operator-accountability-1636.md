# Platform Admin decision — PR #882 Release, Intake Recovery and Operator Accountability (5 Nov 2026, 16:36 AEDT)

Recorded verbatim as received. Updates the conditional release authorisation for PR #882 (v2.15.482). Status: in progress — see processes/intake-dates.md §9–§10.

```text

StudySearch — PR #882 Release, Intake Recovery and Operator Accountability

Platform Admin decision — 5 November 2026

This updates the existing conditional release authorisation for PR #882 (v2.15.482).

PR: https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/882

The requirement is not merely to automate intake enrichment. The platform must make its work, progress, decisions, failures and results visible to an authorised human operator.

Automation without operational visibility is not complete.

1. Release conditions

Authorise PR #882 once:

- GitHub CI is green.
- Full required tests pass.
- Production function hashes and schema contracts match.
- Existing admission, manual-lock and consumer API controls pass.
- Deployment and forward-recovery procedures are verified.

Keep unrelated discretionary releases on hold.

Do not delay safe data-integrity containment while developing optional UI improvements.

2. Required intake corrections

Complete the existing PR #882 scope:

- Fair processing across eligible universities.
- Correct academic-calendar precedence.
- Normalisation of equivalent semester and term names.
- Course-specific evidence validation.
- Rejection of unsupported testimonial or pathway evidence.
- Governed withdrawal of incorrect intake values.
- Existing deterministic retry and revisit protections.

Reconcile the five earlier UNSW admissions individually.

Withdraw only values confirmed unsupported, preserving history and unaffected valid values.

Verify Website API v2 after each governed correction.

3. Make automation progress visible in the Admin UI

Extend the existing:

Layer 2/3 Operations → Intake Run & Validate → Process results

Do not create a new dashboard or duplicate monitoring mechanism.

Provide a persistent Automation Progress section displaying the platform's actual scheduled activity.

A. Current operational status

Show:

- Automation enabled, paused, running, waiting or failed.
- Last successful execution.
- Currently running job and run ID.
- Last run start/completion time.
- Next scheduled execution.
- Batch size and configured scope.
- Current university being processed.
- Processing rate.
- Pending eligible work.
- Held or blocked work.
- AI and Firecrawl usage.

Distinguish a healthy idle job from one that has stalled.

Do not display a successful job execution as successful data enrichment when zero values were admitted.

B. Processing funnel

For every run, show:

1. Courses eligible.
2. Courses selected.
3. Courses examined.
4. Evidence found.
5. Dates extracted.
6. Dates validated.
7. Values admitted.
8. Values published.
9. Values refused or held.
10. Values awaiting the next revisit.

These counts must reconcile with persisted run records and catalogue data.

C. University-level progress

Show one row per university:

University| Eligible| Processed| Admitted| Published| Held| Last run| Next revisit

Include UNSW, Melbourne, Sydney, Newcastle and all other universities in the approved scope.

A university never reached by the selector must display Not processed, not zero eligible.

Support provider and course drill-down to official evidence, reader result, failure reason and next permitted action.

D. Historical results

Provide selectable views for:

- Latest run.
- Last 24 hours.
- Last 7 days.
- Last 30 days.

Show actual changes over each interval, including previously admitted values later withdrawn.

Distinguish net data gain from gross processing activity.

E. Failures and recovery

Every failure or hold must display:

- Failure category.
- Exact reason.
- Affected university and course.
- Evidence version.
- Last attempt.
- Next action.
- Next scheduled revisit.
- Existing integration issue, if applicable.
- Whether the platform can recover automatically.
- Whether a person must intervene.

Do not hide a failed operation behind a green scheduler status.

4. Operator controls

Reuse existing governed controls to provide:

- Preview — identify eligible work before execution.
- Run Now — start an authorised bounded cohort.
- View Progress — inspect the active execution.
- Verify Publication — compare catalogue and consumer values.
- View History — inspect previous runs and decisions.
- Review Blockers — open the relevant recovery or Layer 4 case.
- Pause/Resume — where permitted by the existing job and role policy.

All controls must enforce permissions, concurrency, spending and audit rules.

Do not create unrestricted SQL execution or a second scheduler.

Results must survive browser refresh and be usable on mobile.

5. Continuous progress measurement

Extend the existing process-results observer.

After scheduled intake execution, persist:

- Run ID and timestamps.
- Provider and course scope.
- Selected and completed counts.
- Extracted and admitted values.
- Publication verification.
- Skips and failure classifications.
- Cost.
- Next scheduled work.
- Backlog remaining.

Measure data movement, not merely job status.

If processing produces zero admitted values despite genuinely eligible work, record a zero-yield condition and route it to the existing integration queue.

Use stable failure fingerprints to prevent duplicate incidents.

Do not generate a new issue for expected absence of evidence.

6. Proactive operational accountability

The operator should see problems before reporting missing data manually.

Use existing monitoring and alerts to identify:

- Jobs overdue or stalled.
- Eligible backlog not progressing.
- Repeated zero-yield runs.
- One university monopolising processing.
- Calendar editions becoming stale.
- Publication mismatches.
- Repeated deterministic failures.
- AI or Firecrawl budget restrictions.
- Significant changes in source coverage.
- Pending human decisions blocking downstream work.

For each alert, show the affected count, evidence, last successful stage and next action.

Keep the alerts in the existing Operations and Work queue mechanisms.

Do not create another notification system.

7. Admin repository accountability

Maintain the existing process record:

"docs/platform/processes/intake-dates.md"

The record must explain:

- Purpose and automation owner.
- Source and reader mechanisms.
- Registered jobs and schedules.
- Configuration and limits.
- Actual admission and publication results.
- Failure classifications.
- Unresolved blockers.
- Revisit rules.
- PR, release and issue references.
- Production acceptance evidence.

Detailed per-run and per-course records belong in the database.

The Admin repository maintains the versioned operational design, decisions, material incidents and periodic verified summaries.

Do not create thousands of Git commits for individual intake rows.

Ensure UI measurements and repository summaries derive from the same persisted source records.

8. UI validation before acceptance

Add database-backed UI tests proving:

- A running job displays progress.
- Completed runs retain their outcomes.
- All universities display their actual processing state.
- A zero-yield run is clearly identified.
- A held item shows its next action.
- A publication mismatch is visible.
- Counts reconcile with the database.
- Results persist after refresh.
- Role restrictions operate correctly.
- Mobile layouts remain usable.

Use production-representative database constraints and fixtures.

Do not rely on synthetic counters.

9. Production acceptance

After the authorised release:

1. Verify PR #882 deployment.
2. Reconcile the five earlier UNSW values.
3. Confirm governed withdrawals and consumer correction.
4. Run the bounded intake validation across UNSW, Melbourne, Sydney and Newcastle.
5. Verify provider fairness and admitted/published values separately.
6. Observe the next unattended scheduled cycle.
7. Open the Admin UI and confirm its progress and history match actual production records.
8. Record results in the existing execution register and intake process record.

If the UI visibility improvement needs an additional change beyond PR #882, prepare a small follow-up PR rather than inserting untested UI changes into a green release candidate.

Do not declare the overall intake automation operationally complete until its monitoring and reporting are visible and verified.

10. Permanent platform standard

Apply this operational visibility contract to future:

- Provider descriptions.
- Course descriptions.
- English requirements.
- Fees.
- Academic entry requirements.
- Scholarships.
- Course Link discovery and recovery.

Each automation must have:

Current state → Progress → Actual data gains → Failures → Next action → Scheduled revisit → Historical evidence.

Do not implement another hidden automation whose success can only be assessed by Claude querying production tables.

Definition of done: The platform operates unattended, while the human operator can independently see what it is doing, what it has achieved, what it missed and why, and what happens next.
```
