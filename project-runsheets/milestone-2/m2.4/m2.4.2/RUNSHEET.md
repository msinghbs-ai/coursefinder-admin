# M2.4.2 — Layer 2 Full Enrichment, Operations Maturity & Performance

**Status:** PLANNED — START AFTER M2.4.1 ACCEPTANCE
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
