# CourseFinder Operations Runbook — M2 Production Addendum v1.0

**Status:** CURRENT ADDENDUM  
**Date:** 25 August 2026  
**Parent runbook:** `docs/coursefinder-operations-runbook-v1.2.md`  
**Change Control:** `CF-CHG-20260825-031`

## Purpose

This addendum introduces Production preparation and the Layer 1–3 operational cadence required after M2.1 closure. It should be read with `docs/coursefinder-production-environment-build-operations-guide-v1.0.md`.

## Daily checklist

- verify Production/Pilot environment before acting;
- check Layer 1 source freshness and failed authoritative runs;
- check Layer 2 scheduled batches, failed provider routes and unresolved identity/fee guards;
- check paid provider consumption and abnormal cost spikes;
- check Layer 3 queue age, failure/retry rate and token/API cost;
- check Layer 4 backlog age;
- check Evidence Storage utilisation/growth;
- inspect Supabase Auth/Edge/Postgres/Storage errors relevant to the last 24 hours;
- review failed GitHub deployment/UAT runs;
- confirm Search/publication state has not changed unexpectedly.

## Weekly checklist

- provider success versus factual-resolution rate;
- completeness uplift by source/provider/country;
- stale sources and sources that require profile updates;
- storage growth forecast and retention exceptions;
- privileged role membership/expiry;
- new Supabase Security Advisor findings;
- database/performance regressions;
- bug backlog by severity;
- backup presence and latest restore evidence.

## Monthly checklist

- recovery/restore exercise according to accepted RPO/RTO plan;
- vendor/API credential rotation review;
- storage retention/dedup/tiering review;
- broad performance benchmark;
- cost review for Supabase, Cloudflare, scraper vendors and AI providers;
- Change Control cleanup and residual-risk review;
- role/access recertification;
- security regression test of browser-executable RPCs/functions.

## Incident priorities

### SEV1

Security compromise, unauthorised publication, data corruption, loss of canonical integrity, or complete Production outage.

Immediate actions:

1. contain affected mutation/deployment/source route;
2. preserve logs/Evidence/audit state;
3. disable affected provider/profile/function only as narrowly as possible;
4. determine last known-good deployment/migration;
5. execute governed rollback;
6. open incident Change Control and evidence record;
7. do not resume until security/integrity regression UAT passes.

### SEV2

Major Admin/data workflow unavailable, privileged-access defect, repeat incorrect canonical application or systematic source/provider failure.

### SEV3/4

Bounded functional/cosmetic/documentation issues without material security or canonical-data impact.

## Layer-specific first checks

| Layer | First checks |
|---|---|
| Layer 1 | source URL/file/API, source date/version/hash, last job, reconciliation counts, raw Evidence |
| Layer 2 | Source Profile version, selected route, Provider Attempt, HTTP/provider result, Native/Normalised Evidence, extractor result, safety guard |
| Layer 3 | input Evidence IDs, model/profile/prompt version, structured output, validation rule result, token/cost, retry/escalation |
| Layer 4 | source/Evidence context, prior L2/L3 decisions, reviewer role, final audited decision |

## Storage operations

Current measured Pilot Evidence baseline on 25 Aug 2026 is ~1.67 GiB across 1,583 objects. Initial broad L2 enrichment should be budgeted at 45–60 GiB total additional planning envelope for one pass across the current 43,461-Course catalogue including discovery/retry/Scholarship headroom.

Operational thresholds:

- 60% quota — warning/forecast review;
- 75% — retention/dedupe/tiering action plan required;
- 90% — block uncontrolled broad crawl until capacity action is approved.

Never delete Evidence that is referenced by canonical provenance, review, UAT, Change Control or hold requirements.

## Release rule

Production promotion requires:

- migration/schema reconciliation;
- security advisor review;
- browser-executable RPC/function inventory;
- database/API/RBAC/storage/desktop/mobile UAT;
- rollback target;
- deployment SHA and evidence artifacts;
- explicit PASS/BLOCKED/DEFERRED gate state.
