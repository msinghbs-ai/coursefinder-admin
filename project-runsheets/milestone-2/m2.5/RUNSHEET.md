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


## Readiness implementation checkpoint — 1 September 2026

Non-billable platform maturity foundation is implemented in Pilot under `CF-CHG-20260901-051`.

Completed foundation:
- PM-A1 environment-specific source/capability gates;
- PM-A4 reversible Layer 4 block ledger;
- PM-A6 scraper environment gate;
- PM-A7 AI profile environment gate;
- PM-A8 capacity policy/observations;
- PM-A9 class-based retention policy + dry-run;
- PM-A11 platform UAT catalogue + permanent M2.5 CI contract;
- PM-A12 serving/ingestion/concurrency workload profiles.

No Production project/resource was created.

Runtime validation after M2.5 migrations:
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 174 INFO / 0 WARN / 0 ERROR;
- zero Production source/scraper/AI gate rows.

Capacity baseline:
- DB ~611 MB;
- Evidence Storage ~4.62 GB / 8,623 objects;
- Evidence planning utilisation ~7.18%;
- cumulative temp activity ~216.6 GB;
- HIGH integrity follow-up: 205 unmatched Storage objects + 18 regulatory Evidence rows without current object matches.

The integrity finding is not authority to purge data.


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


## A17 — Course Skills, Career Pathways & Labour-Market Intelligence

M2.5 now carries the accepted design and implementation backlog under `CF-CHG-20260901-062`.

Authoritative design artifacts:
- `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A17-COURSE-SKILLS-CAREER-LABOUR-MARKET-INTELLIGENCE.md`;
- `docs/coursefinder-course-skills-career-labour-market-design-v0.1.md`;
- `docs/coursefinder-career-skills-demo-operator-guide-v0.1.md`;
- `docs/coursefinder-career-skills-implementation-guide-v0.1.md`.

M2.5 implementation sequence:
1. A17-P1 reference schema and OSCA/NOL/concordance adapters;
2. A17-P2 official labour-market/pathway adapters (JSA/Tahatū) with time-series provenance;
3. A17-P3 first-party Course learning outcomes/career/accreditation Evidence;
4. A17-P4 Layer 3 skills normalisation and occupation candidates;
5. A17-P5 Layer 4 review + Course blade + comparison UX;
6. A17-P6 governed consumer projection only after explicit publication acceptance.

Production boundary: A17 design is accepted, but no broad career/skills consumer publication is authorised by this runsheet alone.


## A30 — Provider Contacts Database Management

M2.5 now carries the accepted Provider Contacts management design under `CF-CHG-20260902-080`.

Authoritative design artifacts:
- `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A30-PROVIDER-CONTACT-DATABASE-MANAGEMENT.md`;
- `docs/coursefinder-provider-contact-database-management-design-v1.0.md`;
- DB Architecture `v2.10.47`;
- Admin/PIM Decisions `v1.28`;
- Admin Navigation IA `v1.6`.

Initial import contract:
- 17-column Provider-contact CSV;
- 306 rows;
- 42 source university names / 41 current institution names;
- 291 named staff / 15 team contacts.

Implementation sequence:
1. A30-P1 additive managed-contact/version/import/audit schema + secured RPC/server boundaries;
2. A30-P2 CSV v1 parser, Provider crosswalk and dry-run/idempotency;
3. A30-P3 Catalogue → Provider Contacts grid/drawer + Provider deep-links;
4. A30-P4 individual create/edit/verify + soft-delete/restore + version/audit history;
5. A30-P5 filtered/full export with privilege checks, audit and CSV-injection safety;
6. A30-P6 targeted DB/API/browser/security/performance UAT;
7. A30-P7 documentation/release notes + bounded integration nomination.

A15 acquisition observations/Evidence remain intact. No Search/Website/Wix/Zoho contact publication or Production deployment is authorised by design acceptance alone.

A30 Layer 4 reconciliation is implemented: exact repeats auto-skip; non-identical duplicate candidates, Provider ambiguity and manual/import conflicts park in Layer 4 without blocking deterministic APPLY. Review-pending batches use applied_with_review_pending and close back to applied after the last human decision.
