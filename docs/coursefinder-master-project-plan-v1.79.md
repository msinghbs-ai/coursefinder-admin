# CourseFinder Master Project Plan v1.79

**Issued:** 1 September 2026  
**Status:** CURRENT  
**Supersedes:** v1.78  
**Programme position:** M1 FROZEN; M2.1–M2.4 CLOSED/PASS; M2.4.0–M2.4.4 CLOSED/PASS

## 1. Programme position

M2.4.4 Cross-layer Operations, Housekeeping, Scheduling & Pre-blackout Acceptance is **CLOSED / PASS** under `CF-CHG-20260830-048`.

Accepted Pilot:
`msinghbs-ai/Coursefinder-Pilot@95f2991e97e76e644bd74f73512b8bf2725fd4b7`.

Replacement final acceptance:
- build `33468512538` PASS;
- deployed acceptance `33468512515` PASS;
- chromium-desktop: 75 passed;
- chromium-mobile: 76 passed;
- both acceptance status contexts success.

Historical final candidate `41428941a1bae18f6e53ac37f81ae54ef5704b1a` / UAT `33460038608` remains immutable FAIL evidence.

## 2. Accepted M2.4.4 outcome

Accepted additions include:
- cross-layer housekeeping, replay/recovery and alert maturity;
- A16 international-contact disposition plus append-only Layer 4 governed intervention;
- scheduled Scholarship ETL/maintenance and canonical Scholarship decision support;
- canonical four-Layer Operations navigation and central Administration;
- responsive Provider/Course detail blades;
- quota-aware Firecrawl-first Layer 2 production with background scheduling;
- type-aware Evidence previews and exact screenshot lineage;
- A26 stable parent lineage from qualification → production wave → batch → Job → Evidence;
- A27 canonical Administration deep links with refresh/back/forward restoration;
- A28 production-oriented Layer 2/3 summaries and blocker semantics;
- timeout-safe Firecrawl continuation, lossless stale acquisition recovery and child heartbeat;
- FU-020 security reconciliation without blanket RLS changes.

## 3. Accepted runtime at closure

Layer 2 production parent:
- parent `c65e67a6-3b2e-47e3-832a-57118fe5cf5f`;
- wave `1bb1504d-7bad-42d9-b059-4adeaf9118c7`;
- route `scraper_first`;
- 261 queueable production Courses;
- 219 completed/dispatched;
- 0 failed;
- 42 scheduled remainder;
- no active production batch/provider attempt at closure.

The 42-Course remainder is governed scheduled background work and is not a reopened M2.4.4 gate.

## 4. Final advisor state

- Security Advisor: 146 INFO / 0 WARN / 0 ERROR.
- Performance Advisor: 172 INFO / 0 WARN / 0 ERROR.
- M244-FU-020: RESOLVED / RECONCILED.

## 5. Authority model

`Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 governed AI Evidence interpretation → Layer 4 governed human resolution`.

Search, Publication, Website and Zoho remain downstream governed consumers.

## 6. Explicit continuing boundaries

This closure does not authorise:
- Production environment cutover;
- broad Publication;
- Website production release/cutover;
- Zoho production cutover;
- RMIT frozen canonical promotion;
- deferred NZ first-party Layer 2 Course enrichment;
- autonomous Layer 3 canonical mutation.

## 7. Current architecture/design baselines

- DB Architecture: `docs/coursefinder-database-architecture-v2.10.44.md` plus accepted M2.4.4 migrations;
- Admin/PIM Decisions: `docs/coursefinder-admin-pim-design-decisions-v1.24.md` plus M2.4.4 closure evidence;
- Running Build: `docs/coursefinder-running-build-v2.79.md`.

## 8. Next programme gate

M2.4 is CLOSED/PASS. Assess the next authorised milestone from repository/runtime truth before starting material work. Do not reopen M2.4.2, M2.4.3 or M2.4.4 merely because standing governance or scheduled background work remains.
