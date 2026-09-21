# M2.4.7 FOLLOW-UPS

| ID | Workstream | Status | Exact next action |
|---|---|---|---|
| M247-FU-020 | Scheduler execution invariant | ACTIVE / BLOCKING CONTROL | Execution-first. Change critical-path state or stop on a specific hard external blocker; do not repeat reconciliation as progress. |
| M247-FU-021 | Admission proof contract | ACTIVE / REQUIRED FOR GATE ADVANCEMENT | Claim DATA ADMISSION only with bounded IDs, L2/L3 transitions, deterministic admission or Layer-4 disposition, canonical and Search/API delta/no-op, Evidence lineage, provider/model telemetry and resource/quota headroom. |
| M247-FU-022 | Iteration carry-forward | ACTIVE / MANDATORY — RECONCILED 2026-09-21 | Historical “resume seven”, “pending item” and new-cohort instructions are superseded. Original 10-item cohort is Layer 4; separate item `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` is now `parked` at attempt_count 6. PR #99 candidate contract/CI is exact-head green at `9b05918...`; dispatcher task/profile/auth repair is the active Gitar slice. Next: exact-head verify that slice, then benchmark-version binding and deterministic admission. Do not execute the parked item or enqueue/benchmark a cohort yet. |
| M247-FU-016 | Monitoring integrity | ACTIVE | Actual provider-call authority is `sum(external_call_count)` across live interpretations plus benchmark runs; never use work-item attempts as provider calls. |
| RLS-ADVISORY | Security drift | TRACK SEPARATELY | Reported RLS-disabled catalogue/search gate tables remain advisory only. Do not auto-enable without governed policies and do not consume the admission run unless safe execution is affected. |

## Current proof boundary

**NO DATA ADMISSION PROVEN.** Qualification PASS, CI and durable Layer-4 handover are not admission. The next legitimate advancement is exact-head task/profile/auth-safe dispatcher completion, benchmark-version binding and deterministic admission implementation before any bounded runtime proof.

## 21 September 2026 carry-forward

- **M247-FU-020:** dispatcher/reservation slice PASS at repository and Pilot runtime. Exact task/profile reservation, in-transaction profile revalidation, one-at-a-time dispatch, full-call budget and non-stranding failure fallback are now deployed.
- **M247-FU-021:** NOT SATISFIED. No validated candidate-to-canonical-to-Search/API proof exists; DATA ADMISSION is not claimed.
- **M247-FU-022:** reconciled to PR #99 `c8866b573...`, CI `35555931223/#2479` + `35555931237/#157`, migration `20260921040446`, and dispatcher v5 hash `f72a0194...`. Runtime is 10 Layer 4 + 1 parked. Next executable unit is benchmark binding (slice 3), not a parked-item retry or cohort.
