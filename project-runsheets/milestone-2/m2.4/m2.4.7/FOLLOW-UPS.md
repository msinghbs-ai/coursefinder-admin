# M2.4.7 FOLLOW-UPS

| ID | Workstream | Status | Exact next action |
|---|---|---|---|
| M247-FU-020 | Scheduler execution invariant | ACTIVE / BLOCKING CONTROL | Execution-first. Change critical-path state or stop on a specific hard external blocker; do not repeat reconciliation as progress. |
| M247-FU-021 | Admission proof contract | ACTIVE / REQUIRED FOR GATE ADVANCEMENT | Claim DATA ADMISSION only with bounded IDs, L2/L3 transitions, deterministic admission or Layer-4 disposition, canonical and Search/API delta/no-op, Evidence lineage, provider/model telemetry and resource/quota headroom. |
| M247-FU-022 | Iteration carry-forward | ACTIVE / MANDATORY — RECONCILED 2026-09-20 | Historical “resume seven” and “create first cohort” instructions are superseded. Original bounded 10-item cohort has already drained to Layer 4. Current bounded target is existing work item `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` only. At 2026-09-20 05:37 UTC provider headroom was 25/day and 10/minute, but dispatcher request `6632` failed HTTP 500 with `work reservation failed: service_role required`; item remained pending/unreserved at attempt_count=5, so no retry burn or provider call occurred. Correct only the service-owned dispatcher authentication/currentness defect, exact-head validate/deploy, then re-dispatch this same item. Do not enqueue a new cohort or benchmark. |
| M247-FU-016 | Monitoring integrity | ACTIVE | Actual provider-call authority is `sum(external_call_count)` across live interpretations plus benchmark runs; never use work-item attempts as provider calls. |
| RLS-ADVISORY | Security drift | TRACK SEPARATELY | Reported RLS-disabled catalogue/search gate tables remain advisory only. Do not auto-enable without governed policies and do not consume the admission run unless safe execution is affected. |

## Current proof boundary

**NO DATA ADMISSION PROVEN.** Qualification PASS and durable Layer-4 handover are not admission. The next legitimate advancement is correction of the dispatcher service-role execution defect followed by one bounded re-dispatch of the existing pending item and FU-021 proof.
