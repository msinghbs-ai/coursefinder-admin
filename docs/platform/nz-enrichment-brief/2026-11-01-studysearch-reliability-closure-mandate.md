# StudySearch — Reliability Closure and Production Acceptance (Platform Admin, 1 Nov 2026 08:57 AEDT)

Saved verbatim from the Platform Admin's message.

---

StudySearch — Reliability Closure and Production Acceptance

Continue from StudySearch v2.15.386.

The D12–D16 tranche has been deployed. Do not reopen completed decisions unless current production evidence demonstrates a regression.

Primary objective

Resolve the remaining production reliability issues and progress SS-015 towards operational acceptance.

Prioritise measurable reliability improvements rather than introducing additional features.

1. SS-004 — Investigate remaining job failures

Independently investigate:

- Two read-job cancellations reported at 15:00 and 15:30.
- Two admission-job timeouts around 17:10.
- Any additional failures since the latest report.

Determine whether the admission jobs compete for the same row locks, and whether read-job cancellations are caused by scheduling, timeout, resource contention or external cancellation.

Identify the smallest safe remediation.

Where changes are permitted under existing governance, implement, test, deploy and independently verify them.

Do not weaken admission controls, data integrity or concurrency protections merely to eliminate failures.

2. Complete scheduled verification

Perform the pending checks when their observation windows are complete:

- SS-004: 24-hour and seven-day reliability.
- SS-007: Independent Batch A integrity verification.
- SS-010: Mismatch requeue suppression.
- SS-012: Consumer search performance.
- SS-014: Health-check runtime and classification accuracy.
- D15: Refresh wait p95 and maximum delay.
- D13: Direct-read pilot results when pages become eligible.

Record observed results only. Do not claim success for incomplete windows.

3. Validate alert delivery

D12 is live, but the Platform Admin has not yet confirmed receiving the test notifications.

Verify the delivery platform's recorded results and distinguish them from confirmed recipient receipt.

Continue monitoring critical-alert deduplication, delivery failures, acknowledgements and recovery notices.

Do not create repeated test alerts unnecessarily.

4. Assess operational acceptance

Update SS-015 against T1–T8 in "OPERATIONAL-LIMITS.md".

For every target, show:

- Target threshold.
- Actual measurement.
- Observation period.
- Pass, Fail or Insufficient Data.
- Evidence reference.
- Corrective action if required.

Do not declare StudySearch production-ready until the required acceptance conditions have been demonstrated.

5. Execution autonomy

Complete authorised technical investigation and routine remediation without asking for repeated approvals.

Escalate only genuine governance, destructive, expenditure or consumer-impact boundaries.

If a verification window is incomplete, continue other authorised work. Do not wait idly for future scheduled observations.

6. Governance and reporting

Maintain the Admin execution register, transformation record and relevant operational reports.

Before material changes, explain the purpose, impact and rollback.

Provide milestone updates with exact Pilot/Admin references.

The next report should concentrate on:

1. Remaining job failures and fixes.
2. Operational acceptance evidence.
3. Direct-read pilot yield.
4. Refresh performance.
5. Alert delivery.
6. Outstanding genuine risks.

Proceed with SS-004 reliability remediation and SS-015 verification without requesting another general GO.
