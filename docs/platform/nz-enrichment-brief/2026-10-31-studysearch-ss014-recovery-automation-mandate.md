StudySearch — SS-014 Recovery and Automation Execution Mandate

Executive direction

Continue from v2.15.384 and the current StudySearch execution register.

The objective is to complete the remaining operational maturity improvements with measurable results, minimal maintenance, and no unnecessary approval cycles.

Read and comply with "AGENT-OPERATING-MODEL.md". Preserve existing production controls, approvals and consumer API compatibility.

Record this mandate and its decisions in the Admin repository before implementation.

1. Decisions

D12 — Critical alert delivery: APPROVED

Extend the existing Work Queue Alerts scheduled task to deliver platform-critical alerts using its established push and email channels.

Requirements:

- Reuse existing delivery infrastructure.
- Preserve existing work-queue notifications.
- Enable test mode first and validate delivery, deduplication and recovery notifications.
- Prevent repeated messages about the same incident.
- Verify that alert failures remain visible in the Admin portal.
- Activate production alerts only after the test confirms that the existing recipient and delivery path are correct.

Document the expected notification delay, which may be up to 75 minutes.

Do not provision external webhooks or new credentials.

D13 — Exhausted page reads: APPROVED FOR BOUNDED PILOT

Authorise a controlled direct-only re-read pilot for previously exhausted course pages.

Scope:

- Eligible only after 30 days since the last attempt.
- Start with a maximum of 25 pages per day.
- Maximum one additional attempt per eligible page during the pilot.
- No Firecrawl, external paid crawler or AI calls.
- Respect provider restrictions, rate limits and robots rules.
- Skip pages under identity, remediation or ingestion holds.
- Prevent repeated retries without new qualifying evidence or subsequent approval.
- Preserve source identity verification, evidence and admission controls.

Before activation, reconcile the pilot with the existing ingestion-hold mandate. If that mandate explicitly prohibits these reads, prepare the tested implementation but keep execution disabled until that specific hold is lifted.

Measure successful fetches, verified page identities, newly available fields, processing time and resource consumption.

Do not scale beyond the pilot limits automatically.

D14 — Idle-pause flag recovery: APPROVED

When an authorised operator manually re-enables a scheduled job, ensure its stale automatic idle-pause flag is reconciled appropriately.

- Confirm the operator action represents an intentional restart.
- Preserve audit history.
- Do not accidentally resume unrelated jobs.
- Verify that the automatic idle guard becomes effective again.
- Prove the logic through tests and a safe dry run.

D15 — Search refresh gap: CONDITIONALLY APPROVED

Reduce the existing refresh gap from 30 to 25 minutes, provided:

- No increased refresh backlog or overlapping executions occur.
- Scheduler load remains within operational capacity.
- No consumer API change is required.
- The change is reversible through the existing operational setting.

Monitor refresh wait p95, maximum wait, queue depth and failure rates.

If validation reveals additional contention, retain the existing 30-minute configuration and record the blocker.

D16 — Health-check optimisation: APPROVED

Keep the health-check frequency at 10 minutes.

Investigate optimisation of the shared scholarship-hold functions.

Requirements:

- Preserve all existing monitoring results and classifications.
- Verify any worker-facing dependencies.
- Compare old and new results against live data using safe dry runs.
- Measure scheduled cold-start performance, not only warm-session execution.
- Do not create a new parallel monitoring framework.

Proceed with a change only where a measurable improvement can be demonstrated without degrading worker performance.

2. Strict execution order

Order| Task| Expected result
1| D12| Critical push/email alerts working and verified
2| D14| Automatic idle-pause recovery fixed
3| D15| Refresh-gap setting safely optimised
4| D16| Health-check performance improved where justified
5| D13| Bounded page-read pilot, subject to existing ingestion holds
6| SS-004| Continue reliability verification
7| SS-015| Update operational acceptance assessment

Do not stop after each subtask.

Prepare independent work in parallel where beneficial, but deploy with controlled dependencies and regression testing.

3. Autonomous execution

Complete routine engineering work, tests, approved releases and production verification under the existing operating model.

Do not request another general GO.

Escalate only if:

- Implementation exceeds the approved scope.
- A protected consumer contract would change.
- Security would be weakened.
- Paid processing or expenditure would exceed limits.
- An existing hold or approval gate prevents execution.
- A destructive operation becomes necessary.
- Measured production behaviour differs materially from the expected result.

If a task is blocked, record it and continue to the next authorised task.

4. Verify substantial gains

Report:

Metric| Baseline| After implementation
Critical alert delivery| Admin-only platform health visibility| Confirmed push/email delivery
Exhausted course pages| 1,467| Pilot attempted, verified and recovered
Idle-pause control| Stale flag after manual restart| Correct automatic state
Refresh wait p95| 31 minutes| Measured result
Health-check duration| Approximately 22 seconds| Cold-run measurement
Job failures| Current observation window| Verified 24-hour/7-day result
Search API p95| 5.2 seconds on 71 requests| New measurement when traffic permits

Never report an unmeasured improvement as complete.

5. Operational maturity

StudySearch should recover automatically from transient failures within defined limits, while maintaining human oversight for sensitive decisions.

Review whether any new implementation introduces:

- Additional maintenance burden.
- Duplicate scheduled jobs.
- Unnecessary database reads.
- Unbounded retries.
- False-positive alerts.
- Uncontrolled expenditure.

Prefer improving existing mechanisms.

6. Progress and governance

Maintain the permanent SS-XXX execution register and transformation record in the Admin repository.

Before material production changes, explain the action, scope, risk and rollback.

Show meaningful progress at milestones, including verified outcomes and exact Admin/Pilot references.

Keep the Website and Zoho consumer APIs operational.

7. Final objective

Complete this authorised execution tranche, then provide:

1. Verified production improvements.
2. Before-and-after measurements.
3. Outstanding reliability and acceptance checks.
4. Remaining human intervention points.
5. Cost and operational implications.
6. Any genuine decisions still requiring approval.
7. Exact Admin and Pilot commit/PR references.

Proceed through the authorised tasks without stopping after each sub-phase.

The goal is a stable, efficient and increasingly self-sustaining StudySearch platform, not a growing collection of monitoring components.