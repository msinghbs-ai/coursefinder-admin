# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

## Current H4 corrective gate — CF-CHG-20260910-093 REOPENED / SOURCE-RUNTIME RECONCILED — 12 September 2026

- Pilot corrective PR #71 merged exact clean head `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575` to `main` as **`63c7107cfce2d8f607fc378af4881d0ba28ca879`** solely to reconcile repository source with already-applied Pilot runtime migrations; visible release remains **v2.15.78** because PR #71 contained no browser UI source change.
- Latest immutable Pilot runtime/source migration is `20260911120131 cf_093_scheduler_operator_reason_and_route_chain_finalizer`; repository source and deployed runtime lineage are now aligned.
- Pre-merge exact-head Frontend Build `34597632959` PASS and Codex review clean in comment `5634309865`.
- Post-merge Frontend Build `34655200676` PASS; CourseFinder Deployed UAT `34655200754` PASS; Cloudflare Workers build `50ce255a-8c17-4319-a649-ef2113178254` PASS / Worker version `529075ea-affa-4a5e-951a-15e53689c8e2`.
- Universal governed sequence remains `Job / Dataset -> Country -> Scope Type -> Target -> Processing Mode -> Preview -> Run now / Schedule`; Preview cannot be bypassed where required by the execution contract.
- Current executable intent remains AU Course Facts only, server-authorised Country/State-Territory/University-Provider scopes, Acquisition + deterministic Layer 2 only, authenticated rank-4 execution.
- Generic asynchronous discovery is fail-closed; generic L3/L4, Evidence reprocess, NZ Layer 2, recurring country/state, unsupported recurring university and implicit Search/Publication remain disabled.
- Security Advisor remains the known 191 INFO / 0 WARN / 0 ERROR baseline.
- **CF-CHG-20260910-093 remains REOPENED.** Remaining closure blocker is consequential acceptance: RMIT/UQ have governed execution policies but are discovery-backed; Nova Higher Education and Stamford International College are fully queueable but are qualification-only profiles with execution-policy gap 1. Every inspected AU State/Territory scope remains discovery-backed with policy gaps. Do not manufacture policy/configuration or weaken authority merely to make UAT pass.
- Production remains unchanged; M2.5 stays paused at P0.


**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-CHG-20260910-093 REOPENED / CONSEQUENTIAL ACCEPTANCE BLOCKED  
**Opened:** 2026-09-03 10:28 AEST  
**Updated:** 2026-09-12 AEST
**Change Control:** CF-CHG-20260903-087; active corrective gate CF-CHG-20260910-093
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

### H12 — ARWU & University Diversity Statistics — PARKED / SUPERSEDED AS NEXT GATE
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

## Current gate order — reconciled 12 September 2026

1. **CF-CHG-20260910-093 repository/runtime reconciliation is PASS.** PR #71 merged as `63c7107cfce2d8f607fc378af4881d0ba28ca879`; post-merge Frontend Build `34655200676`, deployed UAT `34655200754`, and Cloudflare Worker build `50ce255a-8c17-4319-a649-ef2113178254` all PASS.
2. **CF-CHG-20260910-093 consequential acceptance remains the current blocking closure gate.** Wait for a genuinely governed policy-qualified fully queueable deterministic Layer 2 target produced by a legitimate operational lifecycle; do not manufacture configuration merely to obtain acceptance.
3. **Near-term ranking continuation remains QS-focused after CF-CHG-20260910-093 closes.** Reconcile the current QS hardening/recovery state and any open QS Change Control against Pilot/runtime truth before selecting implementation work.
4. **H12 ARWU / University Diversity generic dataset work is PARKED** by the 10 September roadmap decision and must not be resumed without a newer explicit governed change.
5. **H13 generic historical ranking backfill/replay remains parked/conditional** except where a current QS-specific governed change explicitly requires bounded replay.
6. H7 migration/telemetry reconciliation continues throughout.
7. H8/H9 continuous intake/testing.
8. H10 meeting pack continuously maintained.
9. H14 external-consumer API key lifecycle remains separately OPEN/GOVERNED under CF-207.
10. Final nominated M2.4.5 acceptance only after the remaining current open gates are reconciled.
11. Resume M2.5 P0 only after M2.4.5 closure.

Closed workstreams must not be repeated without a new defect/change record: H1, H3, H5, H6 and H11. H4 base Scheduler/Jobs is historically accepted, but CF-CHG-20260910-093 remains reopened for consequential target-builder acceptance.

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

Historical only / superseded. User-directed execution order at that time was H11 → H12 → H13. H11 later completed under CF-101/102. The former statement that continuation began at H12 is no longer active authority; current continuation is governed by the 12 September gate order above, with CF-CHG-20260910-093 consequential acceptance first and QS next only after closure.

## 2026-09-03 12:59 AEST — H13 established Parse.bot API contract

CF-092 replaces the earlier assumption that QS/ARWU require generated Parse.bot scrapers.

H13 uses user-supplied established APIs:
- QS: scraper `e3ecc5de-f530-478a-b464-867d43099420`, endpoint `get_world_rankings`;
- ARWU reference page `0f6d2cb9-c7eb-4f31-9216-f7be578e9f96`, API execution scraper `9a025ecd-9ccb-4cf6-a454-be52e290b946`, endpoint `get_arwu_rankings`, snapshot header version 10;
- target edition range: **2015–2026 inclusive** for both.

Do not generate replacement QS/ARWU scrapers. Both established APIs must converge with uploaded Evidence parsing through the same staging/validate/reconcile/dry-run/manual-Apply contract.

QS exact year/pagination parameter semantics must be verified from the established endpoint response/metadata before implementing any remaining 2015–2026 loop; do not invent parameter names.

## 2026-09-12 13:49 AEST — CF-CHG-20260910-093 governance reconciliation execution

**Intent:** reconcile Admin PR #34 with Pilot PR #71/main runtime truth after exact-head Codex identified governance inconsistencies; make no Pilot schema/runtime/configuration changes.

**Starting state:** Pilot PR #71 already merged exact clean head `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575` as `63c7107cfce2d8f607fc378af4881d0ba28ca879`; Frontend Build `34655200676`, Deployed UAT `34655200754` and Cloudflare Workers build `50ce255a-8c17-4319-a649-ef2113178254` were PASS. CF-CHG-20260910-093 remained reopened because no legitimate policy-qualified fully queueable deterministic Layer 2 target existed.

**Actions:** retained immutable migration/source lineage through `20260911120131`; corrected the workflow matrix to make discovery-containing scopes fail closed and only fully queueable deterministic Layer 2 executable; moved QS continuation behind CF-CHG-20260910-093 closure; strengthened rollback wording so applied migration source cannot be removed/reverted and any semantic rollback is forward-only; hardened NEXT-CHAT exact-head/recovery pickup instructions. No execution policy, source profile, route or runtime configuration was created.

**Outcome:** governance reconciliation materially advanced; CF-CHG-20260910-093 remains **REOPENED / CONSEQUENTIAL ACCEPTANCE BLOCKED**. Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human resolution, Search/Publication separation and rank/ACL boundaries remain unchanged. Generic async discovery remains fail-closed.

**Follow-up:** authoritative Register must state the same reopened blocker; after all governance files are reconciled, read Admin PR #34 exact `head_sha`, run current Admin CI, request exact-head Codex re-review, and merge governance only if clean. Consequential acceptance remains deferred until a legitimate target appears through normal operational lifecycle.
