# Next Chat — M2.4.4 Cross-layer Checkpoint

## Status

M2.4.4 is ACTIVE under `CF-CHG-20260830-048`.

Accepted entry baseline:
`96de9add3762a0594ebc371fba49d4d990ff4b45`.

Current corrective Pilot head:
`29cffeb1ad3824f7569d4b597e0103e3c880bb8a`.

## Completed entry work

Cross-layer cron inventory shows all current schedulers/housekeeping jobs latest-success.

First genuine gap corrected:
- stale legacy Layer 1 `regulatory_sync` `pipeline.jobs` recovery;
- migration `20260830021400_m2_4_4_layer1_legacy_stale_job_recovery`;
- exactly 1 stale job recovered;
- 0 stale legacy regulatory jobs remain;
- 0 governed Evidence/source-version/canonical-history deletions;
- Security 135 INFO / 0 WARN / 0 ERROR;
- Performance 169 INFO / 0 WARN / 0 ERROR.

## First actions next

1. Reconcile latest Admin/Pilot heads; do not overwrite parallel work.
2. Confirm migration `20260830021400...` remains deployed.
3. Continue M244-FU-001 by mapping Layer 1, Layer 2 and Layer 3 stale-recovery windows/ownership as one policy.
4. Reconcile M244-FU-002 scheduling/recheck orchestration and queued/running refresh-request duplication.
5. Inventory alert/threshold coverage for M244-FU-003.
6. Preserve A14 telemetry while checking provider/model operational paths.
7. Use targeted validation before nominating any bounded integration candidate.

## Boundaries

Production, broad Publication, Website/Zoho cutover, RMIT 212 promotion and deferred NZ L2 first-party enrichment remain outside this gate.
