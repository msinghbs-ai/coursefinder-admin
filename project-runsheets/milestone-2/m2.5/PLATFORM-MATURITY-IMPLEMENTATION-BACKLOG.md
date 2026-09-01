# M2.5+ Platform Maturity Implementation Backlog

**Status:** DESIGN-APPROVED BACKLOG / IMPLEMENTATION NOT AUTOMATICALLY AUTHORISED  
**Issued:** 1 September 2026  
**Design:** `docs/coursefinder-platform-maturity-design-v1.0.md`  
**Change Control:** `CF-CHG-20260901-050`

## Implementation checkpoint — 1 September 2026

Runtime implementation is now controlled by `CF-CHG-20260901-051`. The design baseline remains CF-050.

Implemented foundation in Pilot:
- PM-A1 / PM-004+005: environment-specific source/capability gate deployed; AU CRICOS and NZ NZQA Provider/Course Pilot states reconciled; zero Production rows;
- PM-A4 / PM-018: append-only operational/publication/Search/quarantine block ledger and secured decision/read helpers deployed; cross-consumer enforcement/UI remains follow-up;
- PM-A6 / PM-011: Layer 2 acquisition-provider environment gate deployed; Direct HTTP + Firecrawl reconciled Pilot-qualified;
- PM-A7 / PM-009: Layer 3 profile environment gate deployed; three benchmark-PASS profiles reconciled Pilot-qualified;
- PM-A8 / PM-015+016: capacity policy, daily observations and secured snapshot deployed; notification destination remains unset;
- PM-A9 / PM-017: class-based retention policy and dry-run-only read deployed; destructive purge remains unauthorised;
- PM-A11 / PM-006: platform UAT catalogue deployed and permanent M2.5 contract test wired into CI;
- PM-A12 / PM-007+020: four workload profiles deployed with unchanged hard budgets.

Current capacity/integrity finding:
- DB ~611 MB;
- Evidence Storage ~4.62 GB / 8,623 objects (~7.18% of 60 GiB planning envelope);
- 205 unmatched Storage objects and 18 regulatory artifact rows without a matching object require lineage reconciliation before any cleanup.

Still open:
- Admin UX for the new controls — CF-058 source/server implementation complete; source/build CI pending and deployed browser acceptance blocked by FU-015;
- notification delivery/escalation;
- purge executor (only if separately authorised after dry-run/integrity proof);
- block enforcement in each owning operation/consumer — COMPLETE / TARGETED PASS under CF-057;
- Production-specific qualification/canary/restore/load UAT after Production exists.


| ID | Feature | Current truth | Target gate | Priority |
|---|---|---|---|---|
| PM-001 | Scholarship relationship visibility | typed scopes/course links exist; scheduled ETL accepted | M3 consumer/admin maturity | P1 |
| PM-002 | Unit/subject Scholarship mapping | no mature unit entity | Future architecture | P3 |
| PM-003 | Provider collections/G8 | schema designed; no accepted runtime/filter implementation found | M3 | P1 |
| PM-004 | Country/source onboarding control plane | framework exists; AU/NZ mature; other-country Production status not standardised | M2.5 | P0 |
| PM-005 | Environment-specific source enablement | Production does not exist yet | M2.5 | P0 |
| PM-006 | Formal UAT catalogue/dashboard | permanent suites exist, summary not exposed as platform capability | M2.5/M4 | P1 |
| PM-007 | Performance/SLO dashboard | hard gates exist; telemetry distributed | M2.5 | P0 |
| PM-008 | Layer 2 mechanism/runbook | implemented | M2.5 documentation/ops | P1 |
| PM-009 | Layer 3 AI provider/model onboarding wizard | profiles/benchmarks exist; no generic mature admin flow | M2.5 foundation / later UX | P1 |
| PM-010 | Layer 4 intervention drawer maturity | append-only override accepted; extend expiry/revert/conflict/bulk safety | M2.5/M4 | P1 |
| PM-011 | Scraper plug-in onboarding | provider profiles exist; needs generic qualification UI/UAT | M2.5 foundation | P1 |
| PM-012 | Manual Provider create | not mature accepted routine flow | Future platform maturity | P2 |
| PM-013 | Manual Course create | not mature accepted routine flow | Future platform maturity | P2 |
| PM-014 | Existing field edit workflow | Layer 4 field override exists | M2.5/M4 hardening | P1 |
| PM-015 | Storage/capacity dashboard | no consolidated accepted operator dashboard | M2.5 | P0 |
| PM-016 | Storage notifications | no consolidated threshold/notification policy | M2.5 | P1 |
| PM-017 | Retention/purge policy | bounded housekeeping exists; no full class-based retention framework | M2.5/M4 | P0 |
| PM-018 | Provider/Course manual block | Course publication blocked state exists; mature Provider/course operational block UX incomplete | M2.5/M4 | P0 |
| PM-019 | Consumer caching/version invalidation | Zoho bundle/cache direction exists; generic version contract incomplete | M3 | P0 |
| PM-020 | Production-load vs ingestion-load sizing | Pilot contention measured | M2.5 | P0 |

## Implementation addenda

### PM-A1 — Country & Source Onboarding Maturity
Implement environment-specific country/source state machine, source approval, Production canary, count/variance and UAT evidence.

### PM-A2 — Provider Collections / G8
Implement `institution_collections` + Provider membership runtime, official-source ingestion, Provider display and filters.

### PM-A3 — Scholarship Relationship Operations
Expose scope/course links, relationship reason/confidence/Evidence, coverage and revalidation.

### PM-A4 — Manual Intervention & Blocking
Harden Layer 4 edit/revert/expiry/conflict, Provider/Course block/unblock and cascade controls.

### PM-A5 — Manual Entity Creation
Provisional Provider/Course create, duplicate detection and later authoritative reconciliation. Keep Search/Publication off by default.

### PM-A6 — Scraper Onboarding Framework
Generic scraper/provider registration, credentials, quota/cost, qualification, Evidence capability and Production-enable gate.

### PM-A7 — AI Onboarding Framework
Generic AI provider/model/task profiles, schema, benchmarks, thresholds, costs and Production-enable gate.

### PM-A8 — Storage, Capacity & Notification
DB/Evidence/temp/backup growth dashboard, thresholds, forecast and notifications.

### PM-A9 — Retention, Purge & Housekeeping
Class-based retention, dry-run, immutable exclusions, holds, bounded deletion and reclaim reporting.

### PM-A10 — Consumer Cache & Dataset Versioning
Version endpoint/bootstrap bundles, cache invalidation contract and cache-safe Website/Zoho API design.

### PM-A11 — Platform UAT Catalogue
Make accepted test domains and environment-specific Production UAT traceable in Admin/release governance.

### PM-A12 — Performance & Workload Isolation
Keep hard gates, add workload profiles for normal API serving, scheduled refresh, major re-ingestion and concurrent Admin/UAT.
