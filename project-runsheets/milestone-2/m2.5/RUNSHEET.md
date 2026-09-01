# M2.5 RUNSHEET — Clean Production Stack Deployment, Restore & Security Acceptance

**Status:** ACTIVE / READINESS — PRODUCTION NOT PROVISIONED  
**Change Control:** `CF-CHG-20260901-049`  
**Opened:** 1 September 2026  
**Planned engineering baseline:** 12 h  
**Blackout:** 16–30 September 2026 inclusive — no planned delivery

## Objective

Create and accept a clean Production trust boundary from the closed M2.4 Pilot baseline without promoting Pilot in place.

## Accepted source baseline

- Pilot `95f2991e97e76e644bd74f73512b8bf2725fd4b7`;
- M2.4.4 final build `33468512538` PASS;
- final acceptance `33468512515` PASS;
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 172 INFO / 0 WARN / 0 ERROR;
- Master Project Plan v1.81;
- Running Build v2.81.

## Platform maturity design inputs

M2.5 inherits the design baseline from `CF-CHG-20260901-050`:
- `docs/coursefinder-platform-maturity-design-v1.0.md`
- `docs/coursefinder-uat-performance-baseline-v1.0.md`
- `project-runsheets/milestone-2/m2.5/PLATFORM-MATURITY-IMPLEMENTATION-BACKLOG.md`

Only PM items allocated to M2.5 become implementation requirements here. M3/M4/future items remain deferred.

## Entry inventory

Supabase projects visible:
- `coursefinder_Pilot` — ap-south-1 — ACTIVE_HEALTHY;
- `coursefinder-demo` — ap-southeast-2 — ACTIVE_HEALTHY;
- unrelated `ARR` — inactive;
- no CourseFinder Production project.

Visible organisation:
- `techM` / `rszbvkqopqfvjldvfnbh`.

## Gate sequence

### P0 — Provisioning decision
- explicit Production organisation;
- quoted/confirmed Supabase project cost;
- approved Production region;
- final Production project name;
- no resource creation before these are confirmed.

### P1 — Clean Production Supabase
- create separate Production project;
- record ref/region/plan;
- enable mandatory Auth security settings including leaked-password protection;
- establish Production-only secrets/Vault;
- configure private Evidence Storage.

### P2 — Schema/runtime deployment
- deploy accepted migrations in controlled order;
- reconcile schema/extensions/grants/RLS/RPCs/views/functions;
- deploy Edge Functions/Cron with Production secrets;
- never copy Pilot secret material blindly.

### P3 — Data establishment
- authoritative Layer 1 seed/re-ingestion;
- governed reference/config seed;
- decide which retained operational/history data is migrated vs regenerated;
- no assumption that Pilot operational history becomes Production truth.

### P4 — CI/CD + Cloudflare
- protected GitHub Production environment;
- SHA-bound deployment;
- Production Cloudflare environment/origin/WAF/auth;
- no direct developer bypass around protected deployment path.

### P5 — Security acceptance
- Auth/RBAC/session;
- RLS/grants/views/SECURITY DEFINER;
- anon/negative paths;
- private Evidence;
- secrets/log leakage;
- advisors;
- CF-CHG-022 leaked-password gate.

### P6 — Backup/restore/DR
- backup evidence;
- restore rehearsal;
- RTO/RPO assumptions documented;
- rollback/reversion tested.

### P7 — Monitoring/operations
- health/status;
- jobs/heartbeats;
- vendor cost/quota;
- Evidence/storage;
- alerts;
- operational runbook.

### P8 — Production candidate acceptance
- targeted validation;
- bounded integration;
- exactly one nominated Production desktop/mobile acceptance matrix;
- final runtime/advisor/documentation reconciliation.

## Explicit exclusions

M2.5 does not automatically authorise:
- broad Publication;
- Website production cutover;
- Zoho production cutover;
- M4 final handover;
- RMIT frozen promotion;
- deferred NZ first-party L2 expansion.

## Current blocker

Paid Production project creation cannot proceed until explicit organisation/cost/region confirmation is captured.
