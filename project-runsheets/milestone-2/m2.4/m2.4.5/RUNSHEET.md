# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

## Latest accepted H4 enhancement — CF-CHG-20260910-093 CLOSED / PASS — 11 September 2026

- Scheduled Tasks Phase A operator maturity plus the bounded Phase B target builder are accepted at Pilot `cfc4702ba57a58ea31936dcabbd96fdd765194e2` / visible v2.15.78.
- Universal governed sequence is `Job / Dataset -> Country -> Scope Type -> Target -> Processing Mode -> Preview -> Run now / Schedule`; Preview cannot be bypassed where required by the accepted execution contract.
- Current executable target-builder slice is AU Course Facts only, server-authorised Country/State-Territory/University-Provider, Acquisition + deterministic Layer 2 only.
- Profile-version, deterministic execution-policy and <=1,000-course/profile checks fail closed at preview and dispatch; live scope is revalidated at dispatch.
- Final UQ acceptance covered 382 courses, deduplicated repeat dispatch and produced governed Layer 2 Evidence without generic L3/L4/Search/Publication effects.
- Post-merge Release History `34579029903`, Frontend Build `34579029934`, and Deployed UAT `34579029850` all PASS.
- Broader generic orchestration and unsupported recurring construction are not authorised by this closure. Production remains unchanged; M2.5 stays paused.


**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-244 ARCHITECTURAL HARDENING + CF-241 CLOSED / PASS  
**Opened:** 2026-09-03 10:28 AEST  
**Updated:** 2026-09-11 AEST
**Change Control:** CF-CHG-20260903-087; latest closure CF-CHG-20260910-093
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Latest additive H4 enhancement — CF-092 CLOSED / PASS — 10 September 2026

- Prior CF-209 Scheduler/Jobs closure remains historical rollback baseline and is not overwritten.
- Pilot PR #66 merged at `9305eb3a004d12724ec26b6bab65e1d4b1ab2239`; visible Admin release **v2.15.76**.
- Scheduled Tasks is now a primary Data Operations route before Evidence with friendly schedule columns, paged policy visibility, audited editing, queue/Job results and Jobs/Evidence/Layer follow-through.
- Direct run-on-demand is bounded to executable Layer 1–2 schedules; Layer 3 remains Evidence/profile/model-qualified.
- Preview acceptance `34468684736` PASS; final-head build `34469936532` PASS; release-history `34469936531` PASS.
- Post-merge build `34470101950` PASS and deployed UAT `34470101936` attempt 2 PASS after an attempt-1 transient legacy CF-102 `course_detail` HTTP 500 that did not reproduce.
- Production unchanged; M2.4.5 remains ACTIVE for other current governed work.

## Latest accepted hardening/runtime gate — CF-244 / CF-241

- Four-phase tooling/typing/domain/PIM hardening is CLOSED / PASS.
- CF-241 forward runtime reconciliation is CLOSED / PASS.
- Accepted Pilot main: `4a927057e86935f8c5e101e434355da0b8f9bf7d`.
- Exact-head Architectural Refactor Guardrails `34223507733` PASS.
- Post-merge Pilot Frontend Build `34224432855` PASS.
- Post-merge CourseFinder Deployed UAT `34224432694` PASS.
- Governed Evidence and Layer 2 dispatcher routes are restored; Course PIM/consumer boundaries remain preserved.
- H11 Provider Assets is also CLOSED / PASS under CF-101/102 with 49/49 approved primary AU/NZ university logos.
- This does **not** close M2.4.5 as a whole. H12/H13 and continuous/open follow-ups remain governed below.
- Production remains untouched and M2.5 remains paused.

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

### H11 — Provider Logo Completeness & University Source Discovery — CLOSED / PASS
- governed university cohort: 41 AU + 8 NZ;
- accepted coverage: 49/49 approved primary logos;
- Provider/Course/Compare display follow-through accepted under CF-102;
- first-party official assets remain preferred authority;
- Hotcourses/IDP own branding/placeholders remain non-canonical and are excluded;
- reopen only under a new defect/freshness/change record.

### H12 — ARWU & University Diversity Statistics — ACTIVE NEXT
- add/complete ARWU as a first-class editioned ranking system alongside QS/THE;
- reconcile current CF-093–100 implementation before adding anything;
- support bounded AU/NZ real-data proof and multi-year history without overwriting prior editions;
- preserve exact/tied/banded/unranked semantics where publisher data requires them;
- add University Diversity Index / HDI only as a separate contextual dataset, not a QS/THE/ARWU score;
- retain diversity rank, nationalities represented, international-student count, source/geography and observation year/edition where authorised;
- distinguish publisher ranking from contextual diversity statistics in UI/API semantics;
- preserve Provider crosswalk, Evidence and source/version semantics;
- define consumer admission separately from Admin/PIM visibility.

### H13 — Ranking Acquisition Adapters: Parser + API/Parse.bot — PARTIAL / BACKFILL PENDING
- file-first parser, multi-file transport and same-edition country extension are implemented through CF-098–100;
- established QS/ARWU Parse.bot APIs are authenticated/qualified;
- remaining work is bounded historical backfill/replay with Evidence/staging/manual Apply preserved;
- normalise file-parser and API output into the same staging/validate/apply contract;
- retain raw Evidence, request/source metadata, adapter/parser version, validation result, latency/vendor units/rate/cost telemetry;
- fail closed on auth failure, schema drift, missing edition or Provider identity ambiguity;
- preserve manual Apply/acceptance before canonical ranking observations.

## Gate order — reconciled 8 September 2026

1. **H12 — ARWU & University Diversity Statistics — ACTIVE NEXT.**
2. **H13 — bounded historical ranking acquisition/backfill/replay — QUEUED NEXT.**
3. Close any remaining CF-090 ranking-import recovery dependency needed by H12/H13.
4. H7 migration/telemetry reconciliation throughout.
5. H8/H9 continuous intake/testing.
6. H10 meeting pack continuously maintained.
7. H14 external-consumer API key lifecycle remains separately OPEN/GOVERNED under CF-207.
8. Final nominated M2.4.5 acceptance after remaining open gates are reconciled.
9. Resume M2.5 P0 only after M2.4.5 closure.

Closed workstreams must not be repeated without a new defect/change record: H1, H3, H4, H5, H6 and H11.

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

## Historical priority note — 2026-09-03 12:59 AEST

User-directed execution order was H11 → H12 → H13. H11 has since completed under CF-101/102. The active continuation therefore begins at H12 rather than repeating H11.

## 2026-09-03 12:59 AEST — H13 established Parse.bot API contract

CF-092 replaces the earlier assumption that QS/ARWU require generated Parse.bot scrapers.

H13 uses user-supplied established APIs:
- QS: scraper `e3ecc5de-f530-478a-b464-867d43099420`, endpoint `get_world_rankings`;
- ARWU reference page `0f6d2cb9-c7eb-4f31-9216-f7be578e9f96`, API execution scraper `9a025ecd-9ccb-4cf6-a454-be52e290b946`, endpoint `get_arwu_rankings`, snapshot header version 10;
- target edition range: **2015–2026 inclusive** for both.

Do not generate replacement QS/ARWU scrapers. Both established APIs must converge with uploaded Evidence parsing through the same staging/validate/reconcile/dry-run/manual-Apply contract.

QS exact year/pagination parameter semantics must be verified from the established endpoint response/metadata before implementing any remaining 2015–2026 loop; do not invent parameter names.
