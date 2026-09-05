# CF-CHG-20260905-209 — Scheduler & Jobs Operations Acceptance

**Status:** IMPLEMENTED / ACCEPTANCE ADDED / CI PENDING  
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

A cross-adapter retry button would be unsafe because replay semantics differ across authority ingestion, deterministic enrichment, AI interpretation and human-resolution workflows. Any future mutation must be adapter-specific and prove:

1. bounded scope;
2. idempotency/replay safety;
3. explicit operator confirmation;
4. retained audit lineage;
5. no destructive Evidence/history cleanup;
6. no implicit Publication or Search admission.

This is an accepted safety constraint, not an H4 gap.

## CF-209 acceptance

Pilot acceptance added:

- `tests/uat/cf-209-scheduler-jobs-operations-contract.spec.mjs`
- `tests/uat/cf-209-scheduler-jobs-operations-deployed.spec.mjs`

The contracts lock:

- canonical Scheduling routing;
- policy/request/Search-signal visibility;
- bounded Layer 2 scheduler dispatch;
- stale recovery and non-destructive housekeeping;
- server-paged Jobs read path and telemetry;
- absence of generic retry/replay/reset controls.

## Change impact

No runtime schema, cron schedule, Edge Function, credential, Production resource, Publication state or Search admission state is changed by CF-209. This is a reconciliation and acceptance hardening change over existing scheduler/Jobs functionality.

## Gate

H4 is functionally implemented. Mark CLOSED / TARGETED PASS only after the new CF-209 source/deployed acceptance has successful CI/runtime evidence. Until then status remains IMPLEMENTED / ACCEPTANCE PENDING.
