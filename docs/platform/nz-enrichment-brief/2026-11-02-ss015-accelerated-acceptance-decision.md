<!-- Recorded verbatim: Platform Admin, received 2 Nov 2026 05:45 AEDT (chat). Supersedes the SS-015 "two complete weeks" gate (record §31.6); earlier criterion kept below in the register for audit. -->

StudySearch — SS-015 Accelerated Production Acceptance Decision

Platform Admin direction — 2 November 2026

1. Decision: Replace the two-week gate

I am directing an amendment to the SS-015 production acceptance criteria.

The requirement for two consecutive complete calendar weeks before production acceptance is withdrawn as a mandatory project gate.

The original mandate specified 24-hour and seven-day operational measurements. The later two-week condition was recorded in transformation record §31.6 without a corresponding explicit Platform Admin requirement for that duration.

Do not continue treating 16 November 2026 as a fixed project-completion dependency.

Record this as a superseding Platform Admin decision in the canonical Admin repository, preserving the earlier criterion in decision history for audit.

Check whether any external contractual, security or regulatory requirement independently mandates a longer observation period. If one exists, identify it rather than silently overriding it.

2. Replacement SS-015 acceptance criteria

Use risk-based, evidence-supported acceptance.

Gate A — Release integrity

- Latest production version verified.
- Complete test suite green, with no failures or skipped required tests.
- Deployed API, desktop and applicable phone UAT pass.
- Migration and live-function checksums match.
- Consumer API contracts remain intact.
- No unresolved deployment drift.

Gate B — Data integrity

- No known uncontained P0 incorrect published data.
- E1, E14 and E15 remediation remains verified.
- E13 prevents incomplete academic-entry reads from being admitted.
- Incorrect provider, course, variant and audience bindings are blocked.
- Representative country and provider validation passes.
- Held enrichment gaps are distinguished from published defects.

Gate C — Operational reliability

Complete a 24-hour production observation after the last relevant critical reliability fix.

Measure actual critical scheduled-job runs, failure rates, queue movement, refresh processing, budgets and API behaviour.

The window must include all critical job types. If a low-frequency essential job does not run during the window, exercise it safely using an approved fixture or scheduled validation and disclose the limitation.

Do not mark an unobserved job as passed.

A new P0/P1 reliability regression resets the relevant observation clock.

Gate D — Stress and recovery

Use isolated or non-destructive tests to verify:

- Concurrent scheduler executions.
- Idempotency and duplicate prevention.
- Lock contention and timeout handling.
- Queue backlog and controlled recovery.
- Safe bounded retry.
- Failed AI/source acquisition.
- Alerts, deduplication and escalation.
- Recovery from an interrupted operation.
- Migration failure refusal and rollback.
- Isolated restore rehearsal.

Do not inject failures into live production data or disable production protection controls.

Gate E — Operational handover

- Critical UI workflows are verified.
- Effective permissions are tested and limitations disclosed.
- Monitoring and on-call ownership are defined.
- Recovery instructions are usable.
- Costs and budgets are enforced.
- No unresolved P0 defect remains.
- Every residual P1 has a documented containment and explicit acceptance decision.
- P2 and data-coverage gaps are assigned to normal operations.

3. Continue seven-day monitoring without blocking initial acceptance

Retain seven-day trend reporting for SS-004, SS-014 and SS-015 as a post-acceptance operational assurance measure.

Track the original T1–T8 targets without changing their numeric thresholds merely to produce a pass.

Distinguish:

1. Accelerated acceptance evidence.
2. Seven-day reliability trend evidence.
3. Outstanding exceptions and actual failures.

Do not relabel an insufficient-data result as a pass.

A serious breach after acceptance must trigger normal incident response, containment and, if necessary, withdrawal of acceptance for the affected capability.

4. Parallel verification — execute immediately

Use independent available agents/workflows for:

A — Critical jobs, scheduling and concurrency.

B — Data integrity, bindings and entry requirements.

C — Website/Zoho API performance and regression.

D — Operational UI and six-role acceptance.

E — Alerting, backup and recovery.

F — QA, evidence reconciliation and final acceptance report.

One integrator coordinates production changes, releases and final evidence.

Run test streams concurrently where safe.

Do not hold the whole project for the completion of one test stream unless it is a genuine release blocker.

5. Stop validation loops

For each failure, establish:

- Severity and real consumer/operational impact.
- Root cause.
- Exact affected cohort.
- Permanent prevention control.
- Regression test.
- Repair or containment.
- Actual acceptance outcome.

Do not reopen completed corrections without new evidence.

Do not allow routine missing data, held scholarships or enrichment coverage to prevent platform handover when the catalogue safely withholds unsupported values.

Do not change admission rules or activate unapproved bulk operations to accelerate the schedule.

6. Target completion

Target accelerated release-candidate assessment by 3–4 November 2026.

Target operational GO/NO-GO by 4–5 November 2026, contingent on:

- The final 24-hour critical-job window.
- Full acceptance gates A–E.
- No uncontained P0 defects.
- Correctly classified residual issues.
- Working operational monitoring and escalation.

These are delivery targets, not automatic acceptance dates.

If any gate fails, provide the smallest exact blocking scope, corrective action and evidence needed for retest.

Do not automatically reintroduce a seven-day or two-week blocking window without a new Platform Admin decision.

7. Tracking and evidence

Update the existing StudySearch execution register rather than creating a new tracker.

For SS-015, show:

- Original gate and its provenance.
- Superseding decision and timestamp.
- Gate A: Pass/Fail/Insufficient Evidence.
- Gate B: Pass/Fail/Insufficient Evidence.
- Gate C: Pass/Fail/Insufficient Evidence.
- Gate D: Pass/Fail/Insufficient Evidence.
- Gate E: Pass/Fail/Insufficient Evidence.
- Exact supporting test, log, screenshot or audit reference.
- Residual risk and operational owner.
- Project GO/NO-GO recommendation.

Keep the 7-day trend under ongoing operations, not as a silent delivery blocker.

8. Execution

Record the revised decision immediately.

Reconcile current production and identify which gate requirements already have usable evidence.

Do not repeat tests solely because their results were recorded before this instruction, provided the tested version and environment remain applicable.

Complete only the missing validation and corrective work.

Run parallel test streams immediately and continue authorised development without routine confirmation.

Return a consolidated checkpoint showing:

1. Current gate A–E status.
2. Remaining genuine production blockers.
3. Completed engineering and UI acceptance.
4. Current catalogue integrity.
5. Estimated earliest evidence-supported GO/NO-GO.
6. Post-handover monitoring arrangements.

The objective is prompt, safe operational acceptance of the existing working platform—not another prolonged observation programme.