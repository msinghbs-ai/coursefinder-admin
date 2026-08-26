# M2.4.2 — Layer 2 Full Enrichment, Operations Maturity & Performance

**Status:** ACTIVE
**Parent:** M2.4

## Objective

Turn Layer 2 into a mature, simplified, production-shaped enrichment operation and execute broad enrichment across the accepted scope while measuring performance, cost, completeness, storage and fall-out.

## Scope

### Operational simplification
- one Layer 2 Enrichment workspace for routine operations;
- suppress experimental/trial/probe controls from the normal path;
- retain advanced source/provider qualification behind privileged diagnostics;
- show source/profile, route policy, schedule, batch size, provider health, spend, Evidence growth and unresolved domains.

### Full enrichment execution
- enumerate eligible Courses/Scholarships by country/provider/source profile;
- automatic batch/queue generation;
- Direct HTTP first where sufficient;
- governed Firecrawl/other fallback only when required;
- enforce per-provider/per-entity budgets, concurrency and reserve limits;
- execute broad AU enrichment across approved source profiles;
- preserve explicit NZ first-party L2 deferral until source qualification is accepted rather than fabricating coverage;
- capture unresolved domains for Layer 3 rather than hiding gaps.

### Progress, jobs and evidence
- progress bar for batch and individual jobs;
- processed/resolved/unchanged/failed/L3-required counts;
- current provider/attempt, latency, retry state and estimated remaining workload where measurable;
- direct drill-through to Native/Normalised Evidence, candidate and canonical consequence;
- job summary and downloadable/reportable run evidence without secret exposure.

### Performance and economics
- throughput/pages per minute/hour;
- provider success and factual-resolution rates;
- deterministic extraction success by domain;
- paid fallback rate;
- provider units/cost per processed and resolved entity;
- Evidence bytes/entity and storage growth;
- DB/API/Edge/browser latency and slow paths;
- retry/throttle/error patterns;
- Layer 2→Layer 3 fall-out rate.

### Scheduling, rechecks and housekeeping
- source/profile-specific refresh cadence;
- stale data detection and targeted recheck rather than blanket recrawl;
- hash-based unchanged detection/dedup where valid;
- resume failed batches safely;
- clean transient queue/probe/nonce/temp state after terminal jobs;
- archive/prune operational logs according to policy while retaining governed Evidence;
- stuck-job detection and recovery;
- provider credit/quota threshold alerts;
- daily/weekly operational health summary.

### UI/UX evolution
- refine UX using actual full-run performance and failure evidence;
- management summary → queue → entity/job detail → diagnostics;
- progress, ETA only where defensible, last heartbeat and next action;
- clear distinction between resolved, unchanged, missing, failed, L3-required and blocked;
- simplify scheduling/recheck controls;
- mobile-friendly monitoring/review; advanced config may remain desktop-first;
- maintain release notes, Admin Guide and Operations Runbook with every accepted behaviour change.

## Addendum A8 — Operator-first Layer 2 Sync (27 August 2026)

This addendum is part of the active M2.4.2 gate and is subordinate to the standing A1–A7 governance/UAT contract.

### Operator intent
Routine enrichment must not require an operator to understand profile IDs, acquisition routes, bounded trials, provider credentials or internal batch primitives.

The normal Layer 2 journey becomes:

`Country → University / catalogue provider → Scope preview → Sync / Recheck → Progress → Results / fall-out`

### Required routine controls
- Country selector contains only countries with authorised Layer 2 profiles; deferred countries remain visible as deferred where useful but cannot be silently enabled.
- University / catalogue-provider selector is filtered by selected country and represents the governed canonical provider/source-profile scope, not the acquisition vendor.
- Scope preview shows total catalogue records, deterministically queueable records, source-limited records, current profile/version, last success, schedule and active-run state before execution.
- Primary action is one management-friendly `Sync now` / `Discover & sync` control. If governed URLs are missing, the UI must state that discovery is required and use the accepted deterministic discovery substrate rather than infer canonical URLs.
- Existing active/concurrent-run protection remains authoritative; the UI must not create duplicate runs.
- Acquisition vendor selection is automatic under the accepted route policy by default. Manual vendor selection belongs under Advanced controls and must not be required for normal sync.
- Progress/result state must remain visible after launch and link to Jobs/Runs, Evidence and Data Quality.

### Acquisition-provider configuration correction
- Fix provider editing so concurrency/rate/timeout changes are persisted, re-read from the server and visibly confirmed after save.
- Do not claim a provider setting saved merely because the request returned without an exception.
- Provider editor must validate allowed concurrency/rate/timeout bounds client-side and server-side.
- Firecrawl is the representative persistence UAT case because its current stored concurrency remained `2` after the reported edit attempt.
- Routine profile concurrency and acquisition-provider concurrency are separate controls and must be labelled as such.

### Progressive disclosure
Normal operator surface:
- country;
- university/catalogue provider;
- eligible/blocked counts;
- last/next run;
- sync/recheck action;
- progress and result summary.

Advanced surface only:
- profile JSON/versioning;
- acquisition vendor credentials;
- route priority/fallback;
- acquisition-provider concurrency/rate/timeout;
- provider qualification/probes/trials;
- destructive or diagnostic recovery controls.

### UAT extension
Stage A for this slice must prove:
- selector filtering and scope preview;
- deferred NZ cannot be launched as Course enrichment;
- primary sync action is disabled/redirected to discovery when no governed URLs are queueable;
- duplicate active run protection remains visible/enforced;
- Firecrawl concurrency edit persists after close/reopen/server re-read;
- invalid provider concurrency is rejected rather than silently coerced;
- no acquisition credential/secret is exposed;
- no Layer 1 identity mutation occurs.

Stage B must add desktop/mobile coverage for the simplified selector/sync journey, Jobs/Evidence/Data Quality regression and immediate Layer 3 fall-out contracts.

## Automated UAT

- route selection/fallback/budget guards;
- successful and failed batches;
- rate-limit/retry handling;
- identity mismatch zero-uplift;
- safe candidate apply;
- no Search/Publication side effect unless separately authorised;
- Evidence lineage and private access;
- replay/idempotency and unchanged-hash path;
- queue resume and cleanup;
- schedule/recheck;
- performance thresholds at representative scale;
- role/rank/anon/secret negative tests;
- desktop/mobile deployed UAT;
- regression of M1/M2.1/M2.3/M2.4.1 invariants.

## Exit gate

M2.4.2 closes only when Layer 2 can be run and monitored as a routine enrichment service, broad accepted enrichment has been executed/measured, performance/cost/storage are known, unresolved domains are cleanly handed to Layer 3, and the UI/operations documentation reflects actual operating evidence.