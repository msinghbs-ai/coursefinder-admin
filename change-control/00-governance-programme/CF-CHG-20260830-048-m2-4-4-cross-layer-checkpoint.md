# CF-CHG-20260830-048 — M2.4.4 Cross-layer Operations, Housekeeping, Scheduling & Pre-blackout Acceptance

**Status:** ACTIVE  
**Category:** 00-governance-programme  
**Initiated:** 30 August 2026  
**Owner:** M2.4.4 workstream  
**Change class:** cross-layer operations / housekeeping / scheduling / replay / alerts / documentation / acceptance

## Trigger

M2.4.3 is CLOSED / PASS under `CF-CHG-20260829-047` at accepted Pilot `96de9add3762a0594ebc371fba49d4d990ff4b45`, final acceptance `33286437795`.

M2.4.4 is the next planned Milestone 2 checkpoint and may now begin under a dedicated control.

## Accepted starting baseline

- M2.4.0–M2.4.3 CLOSED / PASS.
- Layer 1 remains authoritative/regulatory.
- Layer 2 remains deterministic acquisition/extraction and Evidence authority.
- Layer 3 remains governed Evidence interpretation only.
- Layer 4 remains terminal human resolution.
- Search/Publication/Website/Zoho remain separately governed downstream consumers.
- Security Advisor baseline: 135 INFO / 0 WARN / 0 ERROR.
- Performance Advisor baseline: 169 INFO / 0 WARN / 0 ERROR.
- Layer 3 accepted Edge runtime: interpret v5, provider-control v2, source-pattern-benchmark v9.
- Layer 3 housekeeping cron active every 15 minutes.
- A15 contact intelligence CLOSED/PASS and frozen.

## Scope

M2.4.4 will reconcile and mature cross-layer operations before blackout:
1. housekeeping/retention across transient operational state without deleting governed Evidence/history;
2. scheduling and recheck orchestration across Layer 1, Layer 2 and Layer 3;
3. replay/recovery/idempotency boundaries;
4. stuck/stale job and source/provider/model alerting;
5. operational metrics/telemetry continuity including A14;
6. cross-layer admin/operator visibility and troubleshooting;
7. Guides, Runbooks, release-state and handoff documentation;
8. targeted validation, bounded integration and final pre-blackout acceptance.

## Out of scope

This change does not authorise:
- Production environment establishment or cutover;
- broad Publication;
- Website release/cutover;
- Zoho cutover;
- RMIT frozen 212-record canonical promotion;
- NZ first-party Layer 2 Course enrichment without source qualification/onboarding;
- weakening Layer authority, Evidence, privacy, model-quality thresholds, telemetry or accepted UAT semantics.

## Standing governance

Inherits:
- `PROJECT_INSTRUCTIONS.md`;
- Milestone 2 `STANDING-INSTRUCTIONS.md`;
- A1–A15;
- accepted M2.4.0–M2.4.3 closure evidence;
- Master Project Plan v1.78;
- Running Build v2.78;
- DB Architecture v2.10.44;
- Admin/PIM Design Decisions v1.20.

## Entry gate

Before material implementation:
- reconcile Admin/Pilot heads;
- reconcile deployed Supabase migrations, Edge functions, cron/jobs and advisors;
- review open M2.4 carry-forwards;
- inventory current housekeeping/scheduling/replay/alert contracts;
- identify only genuine cross-layer gaps;
- avoid duplicate controls already accepted in earlier sub-milestones.

## Acceptance discipline

Use targeted validation during implementation, bounded integration before promotion, then one nominated final desktop/mobile acceptance matrix. Preserve all failures and recovered flakes as evidence rather than suppressing them.


## Entry reconciliation / corrective housekeeping — 30 August 2026

Initial cross-layer inventory found one stale legacy Layer 1 `pipeline.jobs` record left `running` since 17 August 2026. Existing Layer 1 housekeeping only deleted expired terminal `layer1_run_queue` rows, while Layer 2 and Layer 3 already had bounded stale-execution recovery.

Corrective Pilot:
`29cffeb1ad3824f7569d4b597e0103e3c880bb8a`.

Migration reconciliation:
- deployed Supabase migration-history version `20260830021159_m2_4_4_layer1_legacy_stale_job_recovery`;
- repository mirror filename `20260830021400_m2_4_4_layer1_legacy_stale_job_recovery.sql`;
- reconciled function body is identical; timestamp mismatch is recorded history/filename alias, not authority to redeploy.

Correction:
- extends `public.svc_layer1_housekeeping()`;
- only targets `pipeline.jobs.job_type='regulatory_sync'`;
- requires age >45 minutes;
- excludes any live `layer1_run_queue` heartbeat within 30 minutes;
- marks abandoned jobs failed with explicit recovery provenance;
- preserves governed Evidence, source-operation versions and canonical history.

Runtime proof:
- 1 candidate before correction;
- 1 recovered;
- 0 stale legacy regulatory jobs after correction;
- 0 governed Evidence/source-version/canonical-history deletions;
- post-change Security Advisor 135 INFO / 0 WARN / 0 ERROR;
- post-change Performance Advisor 169 INFO / 0 WARN / 0 ERROR.

This is an M2.4.4 housekeeping correction only. It does not alter Layer authority or downstream consumer scope.


## Cross-layer implementation reconciliation — 30 August 2026

M244-FU-001–005 material implementation is complete.

### Recovery and retention

L1/L2/L3 recovery ownership was mapped and found non-conflicting. Governed Evidence, canonical history, retained source/profile versions and interpretation/benchmark history remain outside destructive housekeeping.

### Scheduling/recheck

General refresh creation plus L1/L2 dispatchers retain target-level active-work deduplication/idempotency. No queued/running L1–L3 refresh request existed at the checkpoint. Historical blocked L3 requests and L4 human-resolution queue state remain preserved.

### Genuine alert gap corrected

Layer 1 and Layer 2 already exposed governed operational health/alerts. Layer 3 lacked equivalent operator alert visibility.

Deployed:
- `20260830071523_m2_4_4_layer3_operational_alerts`;
- `20260830072215_m2_4_4_layer3_alert_admin_read_bridge`.

The new `layer3_ops_alerts` Admin read remains authenticated/rank-4+ and covers stale execution, enabled/paused/unqualified profile state, latest benchmark failure, repeated provider errors and recorded cost-ceiling breaches. It is read-only and cannot mutate canonical, Evidence, Search or Publication state.

Current Layer 3 alert-condition count: 0.

Storage observation: private Evidence 6,248 objects / 3,781,700,044 bytes. No governed capacity threshold is configured; no artificial threshold was introduced.

### A14 telemetry

Active Layer 2/3 paths retain applicable provider/model calls, latency, vendor units/tokens/cost and outcomes. Missing historical/vendor usage remains unavailable rather than inferred.

### Documentation and validation

Created:
- Operations Runbook v1.8;
- Data Operations Admin Guide v1.6;
- PIM Admin Guide v1.22.

Permanent M2.4.4 source-contract UAT is included in targeted, bounded-integration and acceptance tiers.

Runtime post-change:
- all seven operational cron jobs latest-success;
- Security Advisor 135 INFO / 0 WARN / 0 ERROR;
- Performance Advisor 169 INFO / 0 WARN / 0 ERROR.

Next gate: one bounded integration desktop/mobile candidate. Final acceptance is not nominated unless both platforms PASS.


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
