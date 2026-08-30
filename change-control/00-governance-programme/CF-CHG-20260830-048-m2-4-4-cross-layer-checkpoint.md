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
- Master Project Plan v1.77;
- Running Build v2.77;
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

Migration:
`20260830021400_m2_4_4_layer1_legacy_stale_job_recovery`.

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
