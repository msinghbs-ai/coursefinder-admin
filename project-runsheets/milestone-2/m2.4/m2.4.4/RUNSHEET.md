# M2.4.4 RUNSHEET — Cross-layer Operations, Housekeeping, Scheduling & Pre-blackout Acceptance

**Status:** ACTIVE  
**Change Control:** `CF-CHG-20260830-048`  
**Started:** 30 August 2026

## Objective

Complete the cross-layer operational checkpoint after accepted Layer 1, Layer 2 and Layer 3 maturity without changing authority boundaries or silently entering Production scope.

## Starting accepted baseline

- Pilot `96de9add3762a0594ebc371fba49d4d990ff4b45`;
- M2.4.3 final acceptance `33286437795` PASS;
- Security 135 INFO / 0 WARN / 0 ERROR;
- Performance 169 INFO / 0 WARN / 0 ERROR;
- Layer 3 Edges v5/v2/v9;
- Layer 3 housekeeping cron active;
- A15 frozen CLOSED/PASS.

## Workstreams

### W1 — Cross-layer housekeeping
Inventory transient jobs/nonces/reservations/temp state, retention and stale recovery. Governed Evidence, audit, source versions, contact history and canonical history must not be deleted.

### W2 — Scheduling/recheck orchestration
Reconcile Layer 1 regulatory scheduler, Layer 2 refresh scheduler and Layer 3 housekeeping/revalidation boundaries. Prevent duplicate/conflicting scheduled work.

### W3 — Replay/recovery/idempotency
Verify safe replay, stale-work recovery, duplicate-run protection and state reconciliation across layers.

### W4 — Alerts and operational thresholds
Verify/implement operator-visible alerts for stuck jobs, stale sources, provider/model failures, storage/usage growth and budget/quota conditions where evidence exists.

### W5 — Telemetry and operator visibility
Preserve A14 provider/model calls, latency, units/tokens/cost and outcomes. Do not invent unavailable usage.

### W6 — Documentation/handover
Reconcile Admin/PIM Guide, Operations Runbook, Data Operations guide, release notes and current-state docs.

### W7 — Acceptance
Targeted validation → bounded integration desktop/mobile → one final pre-blackout acceptance matrix.

## Explicit exclusions

Production cutover, broad Publication, Website/Zoho cutover, RMIT 212 promotion and deferred NZ L2 enrichment are not authorised here.

## Closure condition

M2.4.4 closes only after:
- cross-layer runtime reconciliation complete;
- material gaps corrected without authority regression;
- guides/runbooks/current-state synchronized;
- Security/Performance advisor changes explained;
- bounded integration PASS;
- final acceptance desktop/mobile PASS;
- change-control and programme baselines reconciled.


## Entry reconciliation — first corrective housekeeping fix

Cross-layer cron inventory:
- general refresh scheduler: active / latest success;
- Data Quality snapshot refresh: active / latest success;
- Layer 1 regulatory scheduler: active / latest success;
- Layer 1 housekeeping: active / latest success;
- Layer 2 refresh scheduler: active / latest success;
- Layer 2 housekeeping: active / latest success;
- Layer 3 housekeeping: active / latest success.

A stale legacy Layer 1 `regulatory_sync` job from 17 August 2026 remained `running` because Layer 1 housekeeping did not cover legacy `pipeline.jobs`.

Implemented/deployed:
- Pilot `29cffeb1ad3824f7569d4b597e0103e3c880bb8a`;
- migration `20260830021400_m2_4_4_layer1_legacy_stale_job_recovery`;
- `svc_layer1_housekeeping()` now recovers only abandoned `regulatory_sync` jobs older than 45 minutes and excludes any live Layer 1 run-queue heartbeat;
- no Evidence, source-version or canonical-history deletion.

Validation:
- pre-fix stale candidates: 1;
- recovered: 1;
- post-fix stale candidates: 0;
- Security 135 INFO / 0 WARN / 0 ERROR;
- Performance 169 INFO / 0 WARN / 0 ERROR.

No browser-facing behaviour changed; no release-note version change required for this database-only housekeeping correction.
