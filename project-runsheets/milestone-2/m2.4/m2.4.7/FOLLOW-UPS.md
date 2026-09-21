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

### Migration-ledger reconciliation — 21 September 2026 14:12 AEST

Gitar aligned the repository migration filename to the already-applied Pilot ledger without changing SQL bytes. PR #99 exact head is now `e7b6d5b3ab345511c99fa66e35e65b89fab4d581`; Pilot Frontend Build `35560006737/#2480` and Release History Contract `35560006759/#158` both PASS. Repository file `20260921040446_cf247_task_profile_scoped_reservation.sql` now matches runtime migration `20260921040446`. Dispatcher v5/hash, queue counts and zero-call telemetry are unchanged. Slice 2 remains closed; slice 3 benchmark binding is next.


### CF-247 Slice 3A1 — 21 September 2026 15:00 AEST

PR #99 remains draft and mergeable at exact head `d3e48fa6c33cbe03cec66f3af0d3e3df50686a66`. Gitar added only the shared strict tuition response-schema export, stable candidate-validator/schema contract identifiers, and deterministic assertions in the existing required contract test. Independent diff review confirmed two files changed and no validator behaviour, benchmark execution, migration, dispatcher, interpreter, admission, Layer 4 or Search authority changed. Exact-head Pilot Frontend Build `35562558006/#2481` and Release History Contract `35562557856/#159` PASS.

This is repository/contract foundation only; it is not a runtime deployment or DATA ADMISSION. Pilot remains: dispatcher ACTIVE v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`; interpreter ACTIVE v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`; tuition benchmark ACTIVE v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. Runtime is unchanged at 10 Layer-4-required + 1 parked; target `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` remains parked at attempt 6; Evidence 32,040; course fees 79,730. No provider call, retry, canonical or Search/API delta was caused by this slice.

Next executable unit is Slice 3A2 only: make the tuition benchmark consume the shared schema/validator and align positive/null fixtures to single-target candidate-bound semantics. Do not start binding persistence/predicate work, retry the parked item, run a benchmark, create a cohort or expand Layer 2 in that unit.

### CF-247 Slice 3A2a — 21 September 2026 17:08 AEST

PR #99 remains draft at exact head `59b7a0759d5e87a709c47586f17ed952fa12f7a0` ([commit](https://github.com/msinghbs-ai/Coursefinder-Pilot/commit/59b7a0759d5e87a709c47586f17ed952fa12f7a0)). After the prior Gitar stop, a narrower, independently verified unit replaced only the benchmark's duplicate response schema with the shared schema export and added a deterministic source assertion; two files changed. Gitar's local contract/build passed; exact-head Pilot Frontend Build `35571407034/#2482` and Release History Contract `35571407041/#160` both PASS. No deployment or benchmark execution. Pilot functions remain dispatcher v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`, interpreter v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`, benchmark v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. Fresh queue read: 10 `layer4_required`, 1 `parked`; bounded item remains parked at attempt 6. No provider call, retry or admission was triggered; fresh broader resource, canonical and Search/API counts were not measured. **NO DATA ADMISSION PROVEN.** Next run: complete 3A2 shared-validator adoption and candidate-bound control fixtures only, then independently verify exact-head CI. Binding persistence/predicate remains 3B; do not retry the parked item, benchmark or expand L2.

- 2026-09-21 20:04 AEST: FU-020 remains open; Slice 3A2c is exact-head CI-verified at Pilot `463821f`, but benchmark v11 remains deployed and no execution/admission occurred. FU-021 remains unproven. FU-022 carry-forward: next unit 3A2d known-positive provider scoring; then 3B exact binding. A separate `463821f` Gitar review fix marks transport errors inconclusive; do not count transport as semantic PASS. Queue 10 Layer-4-required + 1 parked. No parked-item retry or larger L2 wave.
