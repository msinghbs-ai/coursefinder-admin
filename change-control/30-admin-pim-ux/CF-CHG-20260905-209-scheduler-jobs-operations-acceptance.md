# CF-CHG-20260905-209 — Scheduler & Jobs Operations Acceptance

**Status:** CLOSED / TARGETED PASS  
**Milestone:** M2.4.5  
**Workstream:** H4 — Scheduler / Jobs operations  
**Type:** OPERATIONS / ADMIN-PIM UX / ACCEPTANCE  
**Initiated:** 5 September 2026  
**Primary owner:** 30-admin-pim-ux

## Objective

Reconcile the existing refresh scheduler, targeted refresh queue and Jobs workspace before introducing any new operator controls. H4 must preserve bounded execution, idempotency, auditability and retained Evidence/history.

## Findings

The scheduler and Jobs control planes already exist and are materially complete.

### Scheduling

The canonical Administration → Scheduling workspace reads `refresh_intelligence_overview` and shows:

- source/entity freshness policies;
- bounded target and country/layer context;
- freshness class and next-due state;
- targeted refresh request queue;
- request trigger/reason/status;
- downstream Search refresh signals.

The underlying M2.3/M2.4.2 scheduler contract provides:

- bounded source/profile/entity refresh targets;
- service-role scheduler execution;
- Layer 2 queued-request dispatch through the managed profile batch service;
- `L2BATCH:<batch_id>` reconciliation lineage in `revalidation_ref`;
- completed/failed request reconciliation;
- stale dispatch recovery after 45 minutes;
- cron dispatch at minutes 3, 18, 33 and 48 each hour;
- daily non-destructive housekeeping;
- retained governed Evidence, profile versions, provider-attempt history, run history and canonical history.

### Jobs

The canonical Jobs workspace is already server-paged and acceptance-backed. It exposes:

- Layer and run mode;
- status and failure class;
- job/source identity;
- discovered, selected, processed, accepted and rejected counts;
- create/update/unchanged/conflict counts;
- Evidence count;
- completion class;
- duration;
- cursor/resume state;
- expandable governed job detail.

## Retry / Replay / Reset decision

Generic retry, replay and reset are intentionally **not** added.

A cross-adapter retry button would be unsafe because replay semantics differ across authority ingestion, deterministic enrichment, AI interpretation and human-resolution workflows. Any future mutation must be adapter-specific and prove bounded scope, idempotency/replay safety, explicit operator confirmation, retained audit lineage, non-destructive Evidence/history handling and no implicit Publication or Search admission.

This is an accepted safety constraint, not an H4 gap.

## CF-209 acceptance

Pilot acceptance:

- `tests/uat/cf-209-scheduler-jobs-operations-contract.spec.mjs`
- `tests/uat/cf-209-scheduler-jobs-operations-deployed.spec.mjs`

Final corrected Pilot source commit:

- `85d0d8e6e5cff7fdd48505161e991be290ac454c`

Final evidence:

- CourseFinder Deployed UAT `33950842779` — SUCCESS;
- Pilot Frontend Build `33950842781` — SUCCESS.

## Change impact

No runtime schema, cron schedule, Edge Function, credential, Production resource, Publication state or Search admission state is changed by CF-209. This is reconciliation and acceptance hardening over existing scheduler/Jobs functionality.

## Gate

H4 is CLOSED / TARGETED PASS. Generic retry/replay/reset remains disabled by design; adapter-specific replay may be introduced only under a separate governed change with idempotency and audit proof.
