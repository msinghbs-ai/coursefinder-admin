# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / H1 TARGETED PASS — H2 UI TARGETED PASS / PARSE.BOT AUTH BLOCKED — H11-H13 ADDED  
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

### H11 — Provider Logo Completeness & University Source Discovery
- achieve governed primary-logo coverage for each in-scope canonical university/Provider where first-party evidence is obtainable;
- first-party official SVG/PNG/brand assets remain canonical authority; asset candidates retain source/Evidence/hash/approval/freshness;
- use external aggregators/sitemaps only as discovery/reconciliation accelerators unless reuse authority is explicitly approved;
- evaluate Hotcourses Abroad sitemap/navigation for missing Provider/source/ranking discovery;
- track expected/discovered/acquired/approved/blocked/missing logo coverage;
- surface Provider logo source/evidence/primary state in Admin/PIM.

### H12 — ARWU & University Diversity Statistics
- add ARWU as a first-class editioned ranking system alongside QS/THE;
- initial ARWU target: 2025, with multi-year history and exact/tied/banded/unranked semantics preserved;
- add University Diversity Index / Hotcourses Diversity Index as a separate contextual dataset, not a QS/THE/ARWU score;
- retain diversity rank, nationalities represented, international-student count, source/geography and observation year/edition where available;
- add ARWU + Diversity cards/history/filters to Statistics & Rankings and Provider/Compare surfaces where approved;
- retain Provider crosswalk, Evidence and source/version semantics.

### H13 — Ranking Acquisition Adapters: Parser + API/Parse.bot
- support uploaded/raw Evidence parser ingestion and governed API fetch for supported ranking datasets;
- allow Parse.bot-generated API endpoints only after credential + endpoint qualification;
- keep API key in Vault and endpoint/scraper configuration in governed non-secret source/extraction profiles;
- support explicit edition/year and multi-year fetch without destructive overwrite;
- normalise file-parser and API output into the same staging/validate/apply contract;
- retain raw Evidence, request/source metadata, adapter/parser version, validation result, latency/vendor units/rate/cost telemetry;
- fail closed on auth failure, schema drift, missing edition or Provider identity ambiguity;
- preserve manual Apply/acceptance before canonical ranking observations.

## Gate order

**Priority override — 2026-09-03 12:59 AEST:** execute **H11 onward first**.

1. **H11 — Provider Logo Completeness & University Source Discovery.**
2. **H12 — ARWU & University Diversity Statistics.**
3. **H13 — Ranking Acquisition Adapters: parser + API/Parse.bot.**
4. Complete/close CF-090 ranking-import recovery where it is a dependency of H12/H13.
5. Resume H2 only for the remaining Parse.bot credential/qualification blocker; do not let the 401 block H11/H12 or file-parser work in H13.
6. Then continue H3/H4 Scholarship and Scheduler/Jobs operational maturity.
7. H5 manual PIM pattern.
8. H6 publication safety/control design and bounded implementation.
9. H7 migration/telemetry reconciliation throughout.
10. H8/H9 continuous intake/testing.
11. H10 meeting pack continuously maintained.
12. Final nominated M2.4.5 acceptance.
13. Resume M2.5 P0.

H1 remains CLOSED / TARGETED PASS and must not be reopened without a new defect.

## 2026-09-03 10:45 AEST execution update

- H1 Administration IA/UI standardisation implemented under CF-088; v2.15.45 consolidates Users & Roles into canonical Administration and centralises Administration metadata/compact cards while preserving accepted deep links and rank boundaries.
- H2 runtime/source inventory started under CF-085. Scraper Config remains the single provider-control plane; provider enablement/credential/limits/routes are live, Parse.bot remains disabled, and no routing semantics have been changed.
- Targeted build/browser validation is running only; the full acceptance suite was not invoked.
- Production migration target state remains pending; no Production Supabase project was created.

## 2026-09-03 12:47 AEST addenda update

- CF-091 adds H11-H13 for Provider logo completeness, Hotcourses-assisted source discovery/reconciliation, ARWU + University Diversity Index and dual parser/API-Parse.bot ranking acquisition.
- Existing A31/A32 rule remains: Hotcourses and similar commercial aggregators are discovery/reconciliation by default, not automatic canonical authority.
- Repository reconciliation confirms CF-083/A32 bookkeeping is already complete and superseded by current DB Architecture v2.10.50 and Admin/PIM Decisions v1.31; do not roll current docs back to v2.10.49/v1.30.
- No runtime/schema/Production mutation is authorised by CF-091 planning.


## 2026-09-03 12:59 AEST priority update

User-directed execution order changed: **H11-H13 are now the immediate M2.4.5 workstream sequence**.

- H11 starts first.
- H12 follows immediately, using current ranking/statistics foundations and CF-090 recovery where needed.
- H13 follows, with file/parser path proceeding even while Parse.bot live qualification remains blocked by the current 401 credential result.
- H2 residual Parse.bot qualification is parked as a dependency only for Parse.bot-backed H13 execution.
- H3-H10 remain active backlog/continuous controls and are not cancelled.


## 2026-09-03 12:59 AEST — H13 established Parse.bot API contract

CF-092 replaces the earlier assumption that QS/ARWU require generated Parse.bot scrapers.

H13 now uses user-supplied established APIs:
- QS: scraper `e3ecc5de-f530-478a-b464-867d43099420`, endpoint `get_world_rankings`;
- ARWU reference page `0f6d2cb9-c7eb-4f31-9216-f7be578e9f96`, API execution scraper `9a025ecd-9ccb-4cf6-a454-be52e290b946`, endpoint `get_arwu_rankings`, snapshot header version 10;
- target edition range: **2015–2026 inclusive** for both.

Do not generate replacement QS/ARWU scrapers. Both established APIs must converge with uploaded Evidence parsing through the same staging/validate/reconcile/dry-run/manual-Apply contract.

QS exact year/pagination parameter semantics must be verified from the established endpoint response/metadata before implementing the 2015–2026 loop; do not invent parameter names.
