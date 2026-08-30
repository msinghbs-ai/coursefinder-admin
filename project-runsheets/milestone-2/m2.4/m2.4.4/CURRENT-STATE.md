# M2.4.4 Current State

**Status:** ACTIVE — IMPLEMENTATION COMPLETE / BOUNDED INTEGRATION NEXT  
**Updated:** 30 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Accepted starting point

- M2.4.3 CLOSED/PASS.
- Pilot `96de9add3762a0594ebc371fba49d4d990ff4b45`.
- Final M2.4.3 acceptance `33286437795` PASS.
- Security 135 INFO / 0 WARN / 0 ERROR.
- Performance 169 INFO / 0 WARN / 0 ERROR.
- Layer 3 interpret v5, provider-control v2, source-pattern-benchmark v9.
- Layer 3 housekeeping cron active every 15 minutes.
- A15 CLOSED/PASS and frozen.

## Entry focus

Inventory cross-layer housekeeping, schedulers, replay/recovery, alerts, telemetry and documentation before making feature changes.

## Boundaries

No Production, broad Publication, Website/Zoho cutover, RMIT 212 promotion or NZ L2 first-party expansion is authorised by M2.4.4.


## Entry reconciliation finding — legacy Layer 1 stale job recovery

Runtime inventory found one genuine stale legacy `pipeline.jobs` row:
- job `da22a5cf-9bff-4597-9193-9503aaad075c`;
- domain `regulatory`;
- job type `regulatory_sync`;
- state had remained `running` since 17 August 2026;
- all active cron schedulers were otherwise reporting successful latest executions.

Root cause:
- accepted Layer 1 housekeeping cleaned expired terminal `layer1_run_queue` rows only;
- Layer 2 already recovered stale `pipeline.jobs` rows for `layer2%`;
- Layer 3 already recovered stale reserved/calling interpretations;
- no equivalent bounded recovery existed for legacy Layer 1 `regulatory_sync` jobs.

Corrective Pilot source:
`29cffeb1ad3824f7569d4b597e0103e3c880bb8a`.

Migration reconciliation:
- deployed Supabase history: `20260830021159_m2_4_4_layer1_legacy_stale_job_recovery`;
- repository mirror: `20260830021400_m2_4_4_layer1_legacy_stale_job_recovery.sql`;
- function body reconciled; do not redeploy only to force timestamp equality.

Deployed validation:
- candidate query matched exactly 1 stale legacy regulatory job;
- housekeeping execution recovered exactly 1;
- remaining stale legacy regulatory running jobs: 0;
- governed Evidence deleted: 0;
- source versions deleted: 0;
- canonical history deleted: 0;
- Security Advisor remains 135 INFO / 0 WARN / 0 ERROR;
- Performance Advisor remains 169 INFO / 0 WARN / 0 ERROR.

The recovery excludes any job still owned by a live `layer1_run_queue` heartbeat.


## Cross-layer reconciliation result

M244-FU-001 through M244-FU-005 material work is complete.

- L1/L2/L3 stale recovery ownership/windows are non-overlapping and preserve governed history.
- general/L1/L2 scheduling is idempotent/target-bounded; no active L1–L3 duplicate refresh work exists.
- L3 alert gap corrected by deployed migrations `20260830071523` and `20260830072215`.
- `layer3_ops_alerts` is available through the governed `admin_read` boundary and retains the rank-4+ internal guard.
- current L3 alert conditions: 0.
- A14 active paths remain telemetry-bearing; unavailable historical/vendor usage is not inferred.
- private Evidence footprint observed at 6,248 objects / 3,781,700,044 bytes; no authorised storage threshold is configured.
- all seven operational cron jobs latest-success.
- Security Advisor 135 INFO / 0 WARN / 0 ERROR.
- Performance Advisor 169 INFO / 0 WARN / 0 ERROR.
- Guides reconciled: Operations Runbook v1.8, Data Operations Admin Guide v1.6, PIM Admin Guide v1.22.
- permanent M2.4.4 UAT source contract added to targeted/integration/acceptance tiers.

M244-FU-006 remains visible non-blocking timing-sensitive UAT hygiene evidence. A15/Apollo/RMIT/NZ boundaries remain unchanged.

## Next decision

Nominate one bounded integration desktop/mobile candidate from the latest Pilot head. Do not create another candidate while that run is active. Final acceptance may be nominated only after both integration platforms PASS.


## Bounded integration candidate nominated — 30 August 2026

- candidate SHA: `55f867bc371fb961f38631129e746fad9d9ec00b`;
- implementation source before marker: `7ef74a0b787e50e46d4cf11300a0e27391f13e54`;
- stage: bounded integration desktop/mobile;
- decision rule: both commit-status contexts must be success before one final acceptance marker is created;
- duplicate candidate rule: do not create another integration marker while this candidate is active;
- workflow run ID: pending GitHub Actions publication at this checkpoint.


## Bounded integration failure evidence — run 33299250997

Candidate `55f867bc371fb961f38631129e746fad9d9ec00b` is terminal FAIL and remains immutable evidence.

Desktop:
- 44 passed;
- 2 failed after retry;
- M2.4.4 source-contract test failed because its checked-in assertion searched for unescaped `p_operation='layer3_ops_alerts'` while the migration correctly stores the PL/pgSQL replacement string using doubled SQL quotes;
- inherited performance test also exceeded the unchanged 3,000 ms Course-page interaction budget: 3,313 ms, then 3,962 ms on retry.

Mobile:
- skipped because desktop failed;
- published integration mobile context is failure/skipped, not an independently executed product failure.

Corrective source:
- `8494293f118bb9f8f3a5884ca4bde1a3331831f1`;
- correction changes only the M2.4.4 checked-in test assertion to verify the stable `layer3_ops_alerts` contract token;
- no runtime, authority, Security, Evidence, Course-path or 3,000 ms performance budget was weakened.

The inherited Course performance failure is preserved and must be re-tested under the unchanged budget before promotion.


## Replacement bounded integration candidate — 30 August 2026

- corrective source: `8494293f118bb9f8f3a5884ca4bde1a3331831f1`;
- targeted deployed UAT: `33300234103` PASS;
- replacement integration candidate: `a256283bb5751dda727d8a6e4ae057abbffdcbbf`;
- decision rule: desktop and mobile must both PASS under unchanged budgets;
- first candidate/run `55f867bc... / 33299250997` remains immutable FAIL evidence;
- do not create another integration candidate while `a256283b...` is active.


## Active long-running gate handoff

Replacement bounded integration `a256283bb5751dda727d8a6e4ae057abbffdcbbf` is the **only active candidate**.

At handoff:
- GitHub has not yet published terminal integration desktop/mobile commit-status contexts;
- workflow run ID is therefore not yet trustworthy/available through the connected status surface;
- do not create another integration candidate;
- first inspect this exact SHA;
- if desktop+mobile both PASS, record its run ID/results then nominate one final acceptance candidate;
- if either fails, retain the run as immutable evidence and correct only the exact defect/contract.


## Replacement bounded integration — PASS

Candidate `a256283bb5751dda727d8a6e4ae057abbffdcbbf` completed as PASS in deployed UAT run `33300281890`.

- desktop: PASS;
- mobile: PASS;
- corrective targeted run `33300234103`: PASS;
- first candidate `55f867bc371fb961f38631129e746fad9d9ec00b` / run `33299250997` remains immutable FAIL evidence;
- unchanged 3,000 ms Course interaction budget was retained.

Post-integration runtime reconciliation:
- all seven active operational cron jobs latest-success;
- Security Advisor: 135 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 169 INFO / 0 WARN / 0 ERROR;
- no active Layer 1–3 refresh requests; seven retained Layer 4 human-resolution requests remain queued;
- Layer 3 stale reserved/calling executions: 0.

Decision: bounded integration gate PASS. Exactly one final M2.4.4 acceptance candidate is authorised next under CF-CHG-20260830-048.


## Final acceptance candidate — nominated

- marker: `6c480ed3b248f3b118f21dea80bb4d742ab8c282`;
- source lineage: replacement integration `a256283bb5751dda727d8a6e4ae057abbffdcbbf`;
- integration run `33300281890`: desktop PASS / mobile PASS;
- decision rule: final acceptance requires desktop PASS + mobile PASS plus clean closing reconciliation;
- do not create another acceptance candidate while this marker is active.
