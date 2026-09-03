# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PLANNING  
**Opened:** 2026-09-03 10:28 AEST  
**Change Control:** CF-CHG-20260903-087  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Objective

Finish Pilot/Admin/PIM operational maturity before Production provisioning. M2.4.4 remains frozen; this is a new additive pre-production hardening gate.

## Workstreams

### H1 — Admin IA/UI standardisation
- simplify primary menu/submenus;
- preserve canonical NAV/HIDDEN_ROUTES/PAGE_META;
- consistent cards, headers, statuses, spacing, breadcrumbs and responsive behaviour;
- no duplicate settings or popup-driven primary workflows.

### H2 — Scraper Config & routing
- one governed Scraper Config control plane;
- enable/disable, endpoint, credential status, quota, reserve, rate, concurrency, timeout and qualification state;
- routing policy shown as effective read state in Layer operations;
- source/routing changes require Evidence, cost and telemetry reconciliation.

### H3 — Scholarship PIM maturity
- server-paged grid;
- column order/visibility/width;
- filtering/search/sort;
- publication/review/freshness/source/evidence states;
- detail drawer and Provider/Course scope review links;
- responsive desktop/tablet/mobile acceptance.

### H4 — Scheduler & Jobs
- scheduled/due/active/terminal views;
- parent/child lineage;
- timestamps/heartbeats/retry/error;
- provider/vendor telemetry;
- safe manual trigger/retry controls where authorised;
- no hidden background activity.

### H5 — Manual PIM records
- define which entities can be manually created/edited;
- rank-gated CRUD;
- append-only audit/version history;
- soft-delete/restore where applicable;
- Evidence/source semantics explicit for manually maintained data.

### H6 — Publication controls
- disabled-by-default automation;
- explicit Platform/PIM Admin enablement;
- module/entity eligibility and mass-input/selection controls;
- preview/dry-run/approval;
- audit and rollback;
- no broad Website/Wix/Zoho/Search publication without separate consumer admission.

### H7 — Production migration inventory & telemetry
- update environment/migration manifest after every material schema/UI/Edge/Storage/secret/cron change;
- track DB migrations, Storage counts/bytes, Evidence references, Edge versions, cron, Vault/credential status, runtime bindings, advisors and deployment SHA.

### H8 — Bugs/Addenda/Features
- every material item gets timestamp, type, Change ID, implementation refs, UAT and outcome in WORK-ITEM-LEDGER.md.

### H9 — UAT acceleration
- static/build/schema;
- targeted unit/contract;
- bounded integration;
- targeted browser;
- frozen-invariant regression;
- one nominated M2.4.5 broader acceptance only.

### H10 — Milestone meeting readiness
- maintain MEETING-READINESS.md;
- record interaction timestamps and implementation evidence;
- distinguish interaction/session elapsed time from user-approved billable time.

## Gate order

1. H1/H2 foundations and duplication audit.
2. H3/H4 operational workspaces.
3. H5 manual PIM pattern.
4. H6 publication safety/control design and bounded implementation.
5. H7 migration/telemetry reconciliation throughout.
6. H8/H9 continuous intake/testing.
7. H10 meeting pack continuously maintained.
8. Final nominated M2.4.5 acceptance.
9. Resume M2.5 P0.

