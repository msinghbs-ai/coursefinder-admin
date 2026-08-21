# CF-CHG-20260821-018 — M1 Data Quality Readiness operational gate

**Status:** **BLOCKED — DEPLOYED EXCEPTION/PAGING/COURSE DRILL-DOWN PASS; EVIDENCE DETAIL NAVIGATION PENDING**  
**Category:** `30-admin-pim-ux`  
**Initiated:** 21 August 2026 14:47 AEST (UTC+10)  
**Last updated:** 21 August 2026 22:28 AEST  
**Origin chat/workstream:** `M1-DATA-QUALITY-READINESS — Completeness, Freshness, Exceptions & Decision-Queue Gate`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Admin operational UX / governed read contract / data-quality semantics / performance / UAT

## 1. Trigger and objective

Completeness is an operational product feature, not a passive field-presence percentage. The pre-existing Course-only Completeness view used a historical six-signal percentage and could not distinguish regulatory source gaps, country-specific non-applicability, unattempted Layer 2 enrichment, stale observations, suppressed values, ambiguity or rejection.

This control introduces a governed Data Quality / Readiness workspace across Provider, Course, Campus, Scholarship and enrichment without manufacturing values or collapsing source authority, Search admission and publication state.

Required readiness domains:

- identity completeness;
- regulatory completeness;
- geography / delivery;
- taxonomy;
- regulatory fee;
- current Provider fee;
- Course URL;
- Intake;
- English requirement;
- Scholarship;
- evidence;
- verification / freshness;
- Search admission;
- publication readiness.

## 2. Governing semantic decision

A single equal-weight cross-domain completeness percentage is **not exposed as the authoritative Data Quality measure**.

The accepted model reports readiness by domain and always distinguishes:

`present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`

Rules:

1. `present` and legitimate numeric `zero` are ready states;
2. `not_applicable` is excluded from the applicable denominator;
3. `source_null` is used only where governed source evidence proves the authority supplied no value/relationship;
4. absence before accepted enrichment is `not_yet_enriched`, not source-null;
5. suppressed, stale, ambiguous and rejected remain distinct operational states;
6. canonical identity, Search projection/admission and publication state remain separate authorities;
7. no canonical Provider/Course/Campus/Scholarship identity or factual value is rewritten by this workspace;
8. no synthetic Campus, fee, URL, Intake, English requirement, Scholarship or Review item is created to improve readiness.

Durable contract:

`docs/coursefinder-data-quality-readiness-contract-v1.0.md`

## 3. Related accepted controls

Retained and not reopened:

- `CF-CHG-20260820-012` — lifecycle / publication / readiness / Search separation;
- `CF-CHG-20260820-014` — Completeness Profiles are policy context, not truth;
- `CF-CHG-20260820-015` — accepted PIM operational browser/performance baseline;
- `CF-CHG-20260821-016` — Pipeline Operations read boundary;
- `CF-CHG-20260821-017` — Evidence workspace/private-boundary baseline.

## 4. Accepted country/source classifications

Existing CRICOS completeness evidence is reused rather than reclassified:

- 34 AU Course→Campus gaps are authoritative CRICOS Course Location source absences;
- 191 AU registered Tuition Fee gaps are authoritative source absences;
- 131 AU registered tuition values are legitimate numeric zero;
- no synthetic Campus or fee is created.

For NZ:

- NZQA is the accepted Layer 1 Provider + Qualification identity authority;
- the accepted NZ Layer 1 contract does not contain a CRICOS-equivalent registered total-course tuition dimension, so NZ regulatory tuition is `not_applicable`;
- absent NZ Course geography/delivery is `not_yet_enriched`, not CRICOS-style source-null.

Scholarship verification/freshness is not inferred from `updated_at`; without a dedicated governed verification timestamp it remains `not_yet_enriched`.

## 5. Initial inventory

At initiation:

- all canonical: 3,085 Providers / 43,461 Courses / 3,922 Campuses / 4 Scholarships;
- AU+NZ: 1,955 Providers / 33,105 Courses / 3,922 Campuses / 4 Scholarships;
- Search Course documents: 33,105;
- Course links: 10;
- Course intakes: 18 rows / 10 distinct Courses;
- Course English requirement rows: 32 / 10 distinct Courses;
- AU+NZ Provider-current fee rows: 10;
- `workflow.review_queue`: 0 rows.

These counts demonstrate why an equal-weight percentage would conflate regulatory completeness, enrichment coverage and downstream admission/publication.

## 6. Implemented read contract

Browser boundary remains:

`public.admin_read(text,jsonb)`

Added operations:

- `data_quality_overview` — one bounded aggregate RPC;
- `data_quality_exceptions` — one bounded/paged exception RPC.

Private implementation:

- `security.admin_data_quality_read(text,jsonb)`;
- `security.data_quality_course_base(text)`;
- `security.data_quality_provider_base(text)`;
- `security.data_quality_campus_base(text)`;
- `security.data_quality_scholarship_base(text)`;
- `security.data_quality_overview_impl(jsonb)`;
- `security.data_quality_exceptions_impl(jsonb)`.

The browser does not receive direct execution rights on private base/implementation helpers. No page-level N+1 entity/detail RPC pattern is used.

## 7. Supabase implementation

Live migrations:

- `20260821050044 — m1_data_quality_readiness_v1`;
- `20260821050313 — m1_data_quality_readiness_course_base_fast_v1`;
- `20260821050457 — m1_data_quality_readiness_overview_fast_v2`;
- `20260821050825 — m1_data_quality_readiness_exceptions_fast_v2`;
- `20260821050846 — m1_data_quality_readiness_runtime_memory_v1`.

The live Supabase migration ledger is the current authoritative migration record. This control does not introduce a one-off repository migration-storage convention where several immediately preceding accepted PIM/Evidence/Pipeline migrations are also live-ledger-only.

## 8. Representative live AU+NZ results

### Identity

- Course 33,105 / 33,105 ready;
- Provider 1,955 / 1,955 ready;
- Campus 3,922 / 3,922 ready;
- Scholarship 4 / 4 ready.

### Regulatory

- Course 33,105 / 33,105 present;
- Provider 1,955 / 1,955 present.

### Geography / delivery — Course

- present: 26,614;
- source-null: 34;
- not-yet-enriched: 6,457;
- readiness: 80.39%.

### Taxonomy — Course

- present: 26,648;
- not-yet-enriched: 6,457;
- readiness: 80.50%.

### Regulatory tuition — Course

- present positive: 26,326;
- zero: 131;
- source-null: 191;
- not-applicable: 6,457;
- applicable: 26,648;
- readiness: 99.28%.

### Layer 2/provider enrichment coverage

- current Provider fee: 10 present / 33,095 not-yet-enriched;
- Course URL: 10 present / 33,095 not-yet-enriched;
- Intake: 10 Courses present / 33,095 not-yet-enriched;
- English: 10 Courses present / 33,095 not-yet-enriched;
- Scholarship applicability: 500 present / 32,605 not-yet-enriched.

### Evidence/Search/publication

- Evidence: governed evidence lineage is present for the accepted Provider/Course/Campus/Scholarship substrate;
- Search admission: 33,105 / 33,105 AU+NZ Courses present in the accepted projection;
- publication readiness is not inferred from Search; absent channel/canonical progression remains not-yet-enriched.

## 9. Exception drill-down contract

`data_quality_exceptions` accepts:

- entity type;
- domain;
- optional state;
- optional country;
- optional query;
- limit up to 200;
- offset.

Each result can expose, where governed data exists:

- canonical entity identity/stable key;
- Provider context;
- country;
- domain/state;
- source/source label;
- evidence ID;
- real Review ID if an exact-domain open Review exists;
- verification/update timestamps.

Controlled backend UAT proved AU Course → Regulatory fee → `source_null` returns total **191**, with source/evidence linkage and paging.

The deployed browser now independently proves the same 191-record population and all four bounded pages.

## 10. ACL/security UAT

PASS:

- `public.admin_read`: authenticated yes / anon no;
- `security.admin_data_quality_read`: authenticated yes / anon no;
- private Data Quality base/implementation helpers: authenticated no / anon no;
- authenticated assigned Admin role can read overview/exceptions;
- sampled existing dispatcher routes remain functional;
- advisor review introduced no Data Quality-specific table/index security finding.

No generic mutation, retry/replay/reset action is introduced by this control.

## 11. Performance UAT

The first ~9 second spilling aggregate implementation was rejected and optimised before promotion.

Accepted controlled samples:

- AU+NZ overview warm: ~836.6 ms, zero temp spill;
- AU regulatory-fee source-null exception page, 50 rows: ~155.8 ms, zero temp spill;
- earlier final cold overview after spill removal: ~4.0 s.

`work_mem=128MB` is scoped to private Data Quality aggregate/exception functions rather than applied globally.

## 12. Pilot frontend and source promotion

### Data Quality v1.0

Pilot PR #18 added:

- `src/data-quality-entry.jsx`;
- `src/data-quality.css`;
- Data Quality runtime root/marker in `index.html`;
- capture routing from the mature `Completeness` navigation item;
- one overview RPC and one paged exceptions RPC;
- responsive loading/error/empty states;
- entity/Evidence navigation from exception rows where authorised/data-backed.

Production build run `32450608567` / run #103: **PASS**.

### Legacy-score label correction

Initial deployed browser UAT found the historical six-signal Course percentage still labelled generically `Readiness` / `Min readiness`, which could be confused with the governed Data Quality domain model.

Pilot PR #19 changed presentation only:

- `Readiness` → `Legacy presence`;
- `Min readiness` → `Min legacy presence`.

PR #19 production build run `32479758645` / run #105: **PASS**.

Current Pilot `main`:

`72721c57d2a11a5fb79288c9eadf4e14602a2e14`

## 13. Deployed authenticated browser UAT

Detailed evidence:

- `docs/uat/coursefinder-m1-data-quality-readiness-technical-acceptance-2026-08-21.md`;
- `docs/uat/coursefinder-m1-data-quality-readiness-browser-evidence-2026-08-21.md`.

### 13.1 Deployment and Catalogue — PASS

Authenticated screenshots prove the actual runtime `coursefinder-pilot.techm.workers.dev` is serving:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · governed`

Browser regression:

- AU Course Catalogue: **26,648**;
- all-country Course Catalogue: **43,461**;
- CRICOS tuition renders, including legitimate `AUD 0`;
- no visible Catalogue permission/RPC failure.

### 13.2 Legacy score relabel — PASS

The 22:08 AEST screenshot proves the deployed Course catalogue displays:

- `LEGACY PRESENCE`;
- `MIN LEGACY PRESENCE`.

The semantic-labelling defect found in the first browser pass is closed.

### 13.3 Data Quality workspace overview — PASS

The 22:08 AEST screenshot proves the deployed `Data Quality & Readiness` workspace renders under AU+NZ scope.

It visibly presents:

- `No composite completeness score` policy;
- all nine governed metric states;
- identity/regulatory/geography/taxonomy/regulatory-fee domain cards;
- Course geography **26,614 present / 34 source-null / 6,457 not-yet-enriched / 80.39%**;
- Course taxonomy **26,648 present / 6,457 not-yet-enriched / 80.50%**;
- Course regulatory fee **26,326 present / 191 source-null / 6,457 not-applicable / 131 zero / 99.28%**.

### 13.4 Regulatory-fee Exceptions — PASS

The 22:23–22:24 AEST screenshots directly prove:

- `Exceptions & decision context` loads;
- context remains `Regulatory fee · Course · Source-null` under AU+NZ scope;
- total is **191 records**;
- Source is shown as `CRICOS Providers, Courses and Locations`;
- Evidence links are exposed for rows where an evidence ID is returned.

All four bounded pages are browser-proven:

- **1–50 of 191**;
- **51–100 of 191**;
- **101–150 of 191**;
- **151–191 of 191**.

This closes both exception-total and paging UAT without relying only on backend tests.

### 13.5 Canonical Course drill-down — PASS

The 22:26 AEST screenshot proves a canonical Course opened from the exception workflow.

The Course detail renders canonical identity plus Fee semantics, Publication & Search state, Intake/English, taxonomy lineage, Fees, Campus, Evidence and Regulatory Facts. Real Evidence artifacts/IDs and Evidence links are visible on the Course.

This proves exception → canonical Course navigation and preservation of provenance context.

It does **not** prove that an Evidence detail page was opened. Because a prior UAT fix changed the expected route to use `evidence_id`, that final browser route remains explicitly unclaimed until directly shown.

### 13.6 Browser-time RPC telemetry — PASS for current windows

The 22:07–22:08 overview interaction correlates with 11 successful:

`POST /rest/v1/rpc/admin_read` → HTTP 200

The later 22:21–22:26 Exceptions/Course interaction also correlates with repeated successful `admin_read` HTTP 200 traffic, including requests around 22:22:39, 22:22:42, 22:22:51, 22:23:40, 22:24:01, 22:24:22, 22:24:59, 22:25:24, 22:25:33 and 22:25:42 AEST.

There is no new HTTP 500 or Postgres statement-timeout aligned with the latest interaction. The most recent statement-timeout remains the earlier 21:53 event already recorded.

The API log does not expose `p_operation`; individual requests are therefore not falsely attributed. Screenshot evidence supplies route-level proof and telemetry independently proves the governed read boundary is completing successfully during the same period.

## 14. Remaining acceptance gate

Only one deployed-browser check remains before closure:

1. click a **real Evidence link** shown in the exception/Course flow and prove the deployed **Evidence detail** workspace loads for that `evidence_id`.

Review navigation remains conditional. `workflow.review_queue` had zero rows at implementation; no Review item is to be manufactured for UAT.

## 15. Rollback

This change is additive/read-only.

Rollback path:

1. revert the Data Quality frontend promotion/follow-up commits if browser rollback is required;
2. remove `data_quality_overview` / `data_quality_exceptions` branches from `public.admin_read` if database rollback is required;
3. retire the private Data Quality helpers.

Do not delete or rewrite canonical, Evidence, Search, publishing or Review data to revert this workspace.

## 16. Documentation impact

Completed:

- Data Quality semantic contract v1.0;
- technical UAT;
- deployed browser UAT record;
- Change Control/REGISTER status maintenance.

Held until final Evidence-detail PASS:

- PIM Admin Guide accepted-baseline update;
- Running Build accepted-baseline bump;
- Master Project Plan accepted-gate update;
- any architecture version change beyond documenting the already-proven governed read surface.

Zoho contract: unchanged.

## 17. Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 21 Aug 2026 14:47 AEST | PROPOSED / IMPLEMENTING | Data Quality Readiness gate initiated after Admin/Pilot/live Supabase reconciliation. | CF-CHG-018 |
| 21 Aug 2026 15:00–15:18 AEST | IMPLEMENTING / UAT | Governed read contract implemented and initial spilling aggregate rejected/optimised. | migrations `20260821050044`–`20260821050846` |
| 21 Aug 2026 15:23 AEST | TECHNICAL PASS | Semantics, ACL, dispatcher regression and controlled performance pass. | technical UAT |
| 21 Aug 2026 15:27 AEST | BUILD PASS | Pilot PR #18 production build passes. | run `32450608567` |
| 21 Aug 2026 15:29 AEST | SOURCE PROMOTED | Data Quality v1.0 source promoted to Pilot main. | Pilot PR #18 |
| 21 Aug 2026 ~21:55 AEST | DEPLOYMENT / CATALOGUE PASS | Live Worker marker, Platform Admin context, AU 26,648 and all-country 43,461 browser counts proven. | browser evidence |
| 21 Aug 2026 ~21:55 AEST | BROWSER UAT DEFECT | Historical score still labelled generic `Readiness`; remediation required. | browser evidence |
| 21 Aug 2026 22:00 AEST | BUILD PASS / SOURCE PROMOTED | PR #19 relabel passes build and merges to Pilot main `72721c57...`. | run `32479758645` |
| 21 Aug 2026 22:08 AEST | DATA QUALITY OVERVIEW BROWSER PASS | Deployed `Legacy presence` labels, Data Quality AU+NZ workspace, nine-state vocabulary and governed domain counts including regulatory-fee source-null 191 proven. | browser evidence |
| 21 Aug 2026 22:08 AEST | GOVERNED RPC PASS | Fresh interaction correlates with 11 `admin_read` HTTP 200 calls, no new 500/timeout and no recurring legacy `ui_*` route use. | Supabase telemetry |
| 21 Aug 2026 22:10 AEST | BLOCKED — NARROWED GATE | Overview gate complete; exception-page paging and Course/Evidence drill-down remain. | CF-CHG-018 |
| 21 Aug 2026 22:23–22:26 AEST | EXCEPTION / COURSE BROWSER PASS | Deployed regulatory-fee Source-null Exceptions reports 191; all four pages through 151–191 proven; canonical Course detail opens and retains real Evidence links. | browser evidence |
| 21 Aug 2026 22:23–22:26 AEST | GOVERNED RPC PASS | Fresh Exceptions/Course activity completes through `admin_read` HTTP 200 with no new 500 or statement timeout. | Supabase telemetry |
| 21 Aug 2026 22:28 AEST | BLOCKED — SINGLE REMAINING CHECK | Exception total, paging and canonical Course drill-down are closed. Only direct Evidence detail navigation from a real `evidence_id` remains. | CF-CHG-018 |

## 18. Closure

**Final status:** **BLOCKED — DEPLOYED EXCEPTION/PAGING/COURSE DRILL-DOWN PASS; EVIDENCE DETAIL NAVIGATION PENDING**  
**Closed at:** N/A  
**Outcome:** Data Quality semantics, live DB/RPC, ACL, performance, build, source promotion, deployed bundle, Catalogue regression, legacy-score relabel, AU+NZ domain overview, 191-record exception population, complete paging, canonical Course navigation, provenance-link presentation and current browser telemetry all pass. Closure is withheld only for direct deployed proof that a real Evidence link opens the Evidence detail workspace using the governed `evidence_id` route.