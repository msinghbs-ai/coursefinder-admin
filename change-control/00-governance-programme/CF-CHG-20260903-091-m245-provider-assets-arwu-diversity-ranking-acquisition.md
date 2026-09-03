# CF-CHG-20260903-091 — M2.4.5 Provider Assets, External Discovery, ARWU & Diversity Ranking Addenda

**Status:** ADDED TO M2.4.5 BACKLOG / DESIGN-REVIEW ACTIVE  
**Initiated:** 2026-09-03 12:47 AEST  
**Category:** 00-governance-programme  
**Parent:** CF-CHG-20260903-087  
**Related:** CF-083 / A32, CF-081 / A31, CF-090, CF-063, CF-084  
**Runtime mutation:** NONE in this change  
**Production:** remains PAUSED at M2.5 P0

## Trigger

Add the following to the M2.4.5 pre-production achievement list:

1. Provider/university logo completeness, with one governed primary logo for each canonical university/Provider where a first-party asset can be proven.
2. Review Hotcourses Abroad sitemap/navigation as an efficient discovery/reconciliation source for Provider, ranking and related source discovery.
3. Add **Academic Ranking of World Universities (ARWU)** to Statistics & Rankings, beginning with the 2025 edition and supporting multi-year editioned history.
4. Add **University Diversity Index / Hotcourses Diversity Index (HDI)** to Statistics & Rankings as a distinct contextual dataset.
5. Support ranking ingestion through both:
   - uploaded/raw parser Evidence; and
   - governed API/Parse.bot fetch where an Admin-configured Parse API endpoint is available.
6. Keep ranking/API acquisition source-aware, editioned, evidence-backed and cost/telemetry governed.

## Repository reconciliation finding

The supplied incomplete-reconciliation note is now historical rather than current.

Repository truth already shows:
- CF-083 / A32 is registered and cross-referenced;
- current DB Architecture is **v2.10.50**, which preserves v2.10.49;
- current Admin/PIM Decisions is **v1.31**, which preserves v1.30;
- Master Plan v1.81 and Running Build v2.81 include CF-083/A32;
- Standing Instructions include A32;
- M2.5 CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT include CF-083/A32.

Therefore this change does **not** roll the current router back to v2.10.49/v1.30.

## External-source review

Hotcourses Abroad currently exposes a rankings hub containing:
- Times Higher Education World University Rankings;
- QS World University Rankings;
- Academic Ranking of World Universities;
- Hotcourses Diversity Index.

The Hotcourses Diversity Index exposes, by institution, at least:
- diversity rank;
- number of represented nationalities;
- international-student count;
- source attribution.

The site states its HDI inputs are sourced from official government sources for the UK, USA, Australia and New Zealand.

### Authority rule

Existing A31/Decision 68 remains binding:
- Hotcourses/IDP/commercial aggregators are **reconciliation/discovery signals by default**;
- they are not automatically canonical CourseFinder Scholarship, Provider, ranking or logo truth;
- official publisher / first-party / government evidence remains preferred;
- any direct reuse of Hotcourses-derived ranking/HDI values requires explicit source/reuse approval and retained Evidence.

The Hotcourses sitemap/navigation may nevertheless be used to:
- discover candidate Provider pages;
- discover ranking/index endpoints;
- discover missing first-party source URLs;
- compare completeness;
- create review candidates.

It must not create/merge Provider identity by itself.

## New M2.4.5 workstreams

### H11 — Provider Logo Completeness & University Source Discovery
- target one approved primary logo for every in-scope canonical university/Provider where first-party evidence is obtainable;
- prefer official SVG/PNG/brand assets and deterministic organisation-logo markup;
- retain candidate asset, source URL, Evidence, mime, hash, dimensions where available, approval state and freshness;
- never use logo similarity as Provider identity;
- keep failed/blocked asset retrieval in review rather than weakening security controls;
- use Provider first-party pages as canonical asset authority;
- evaluate Hotcourses sitemap/navigation only as a discovery/reconciliation accelerator;
- measure Provider logo coverage: expected / discovered / acquired / approved / blocked / missing;
- surface logo source/evidence and primary-asset state in Provider Admin/PIM;
- define refresh cadence separately from volatile Course/Scholarship acquisition.

### H12 — University Statistics & Rankings Expansion: ARWU + Diversity
- add ARWU as a first-class editioned ranking system alongside QS and THE;
- initial target: **Academic Ranking of World Universities 2025**;
- support multi-year ARWU history without overwriting prior editions;
- preserve exact/tied/banded/unranked semantics where publisher data requires them;
- add University Diversity Index / HDI as a separate contextual statistics/ranking dataset, not as a QS/THE/ARWU score;
- retain HDI dimensions such as diversity rank, nationalities represented, international-student count, geography/source and observation year/edition when available;
- distinguish publisher ranking from contextual diversity statistics in UI/API semantics;
- add ARWU and Diversity cards/views/filters/history to **Statistics & Rankings** and Provider detail/Compare where approved;
- preserve Provider crosswalk/evidence/versioning and no title-only identity matching;
- define consumer admission separately from Admin/PIM visibility.

### H13 — Ranking Acquisition Adapters: Upload Parser + API/Parse.bot
- every supported ranking dataset must have an ingestion route for uploaded/raw Evidence where feasible;
- add governed API fetch support for QS/THE/ARWU/HDI when an approved endpoint is available;
- allow Parse.bot-generated APIs to act as an acquisition adapter only after credential + endpoint qualification;
- store Parse.bot scraper_id / endpoint_name or equivalent endpoint configuration in governed non-secret extraction/source profile configuration; keep API key in Vault;
- allow Admin to configure ranking endpoint/edition/year/source without code edits;
- support multi-year fetch by explicit edition/year input rather than destructive overwrite;
- normalise API and file-parser output into the same ranking staging/validation/apply contract;
- retain raw Evidence, request/source metadata, content hash, response status, parser/adapter version and validation result;
- record vendor units, rate limits, latency and estimated/actual cost where available;
- fail closed on schema drift, identity ambiguity, missing edition, authentication failure or unexpected response shape;
- keep manual Apply/acceptance gate before canonical ranking observations are admitted;
- update Production migration inventory whenever new Edge/RPC/secret/profile requirements are introduced.

## UI/UX outcome

Statistics & Rankings should present separate, consistently themed cards/workspaces for:
- QS;
- THE;
- ARWU;
- Diversity Index / HDI;
- existing QILT/PRISMS contextual statistics where applicable.

Cards must show source, edition/year, accepted observation coverage, import/fetch health and actionable Admin controls without greying out merely because an edition has not yet been populated.

## Acceptance

CF-091 is planning/governance only until implementation begins.

H11 acceptance requires measurable logo/source-discovery coverage and bounded browser/Evidence proof.

H12 acceptance requires ARWU + HDI schema/read/UI semantics and bounded real-data proof.

H13 acceptance requires:
1. parser route;
2. API/Parse.bot route;
3. same staging/validation/apply contract;
4. edition/year replay;
5. Evidence + telemetry;
6. negative auth/schema-drift tests;
7. targeted browser/API UAT.

No Hotcourses-derived value is promoted as canonical merely because it is scrapeable.


## Execution priority — 2026-09-03 12:59 AEST

CF-091 is now the immediate M2.4.5 implementation focus.

Order:
1. H11 Provider Logo Completeness & University Source Discovery;
2. H12 ARWU & University Diversity Statistics;
3. H13 Ranking Acquisition Adapters.

The current Parse.bot 401 blocks only live Parse.bot qualification inside H13. It does not block H11, H12 or uploaded-file/parser work.


## Established Parse.bot API adapter decision — 2026-09-03 12:59 AEST

Child Change Control CF-092 defines the H13 API path:
- use existing QS `get_world_rankings` API;
- use existing ARWU `get_arwu_rankings` API with snapshot v10;
- target editions/years 2015–2026;
- do not generate replacement ranking scrapers;
- preserve shared parser/API staging → validate → reconcile → dry-run → manual Apply;
- retain the current 401 as a credential blocker only.

ARWU's supplied reference-page scraper ID and API execution scraper ID differ and are intentionally retained as separate supplied identifiers pending live API verification.


## H11 implementation advance — 2026-09-03 13:39 AEST

Pilot H11 foundation is implemented and live-read verified.

Implementation:
- Pilot migration `20260903213000_cf_091_h11_provider_asset_coverage.sql` committed at `53ea54af4fcbc941248fe506bd4360f07ce9f3f4`;
- browser API helper commit `11405c9d27fb61b74aca3857a71f6fb8cf45e5fb`;
- Provider Assets Administration workspace / Provider-detail asset context commit `bfadc963b49b59e255c270c7ed8126b4bf040275`;
- Admin release v2.15.48 notes commit `f81a6af5072f67d2f1feb71df58e50f6b6c3fd36`.

Live Pilot proof:
- AU active canonical Provider baseline: expected 1,546; discovered 7; acquired 7; approved 2; blocked 1; missing 1,539; needs review 4.
- Charles Sturt is the single accepted-but-unpromoted blocked case retained from the known source-CDN HTTP 403.
- Provider-detail reads now expose managed logo source/Evidence/hash/verification context through the governed `admin_read` boundary.
- Security Advisor after the change reports existing INFO findings only; no new WARN/ERROR finding was introduced by this surface.

Important scope correction: `catalogue.providers.provider_type_id` is currently null across the active Provider catalogue. The H11 read contract therefore labels the present denominator as active canonical Providers matching the selected country/filter and explicitly does **not** call it a university-only denominator. A governed university scope/type crosswalk is still required before the final H11 university completeness percentage can be asserted.

H11 status: **FOUNDATION IMPLEMENTED / LIVE READ PASS / SOURCE BUILD+DEPLOYED UAT RUNNING**. Broad first-party acquisition remains the next H11 data-population step; Hotcourses remains discovery/reconciliation only.


## H11 targeted acceptance + H12 source confirmation — 2026-09-03 13:43 AEST

- Added permanent targeted H11 deployed acceptance spec `tests/uat/cf-091-h11-provider-assets-deployed.spec.mjs` at Pilot commit `a3b533e821b5af980b46e8c50db2808a80e1ec2b`.
- The spec asserts the source contract, Administration → Provider Assets route, coverage matrix, expected/approved/missing metrics, scope warning and deployed Provider rows.
- New CI for that head: Frontend Build `33712208434`; Deployed UAT `33712208435`.
- Current Hotcourses rankings index independently exposes Times Higher Education, QS, Academic Ranking of World Universities 2025 and Hotcourses Diversity Index. This supports H12 discovery/reconciliation, but Hotcourses remains a secondary discovery/reconciliation source rather than ranking identity authority.


## H11 completion advance — 2026-09-04 06:25 AEST

Child CF-101 completes the H11 data-population and runtime acceptance objective.

Accepted university cohort:
- AU 41 / 41;
- NZ 8 / 8;
- total approved primary logos 49 / 49;
- no remaining Provider;
- no approved asset missing Storage path, content hash or MIME;
- no duplicate approved primary;
- no accepted known Hotcourses/IDP own-brand/placeholder/subject-image false positive.

Hotcourses policy for CourseFinder H11 is now explicit: exact university-owned marks may be used as operator-approved fallback copies with source provenance retained; Hotcourses/IDP branding itself is never canonical Provider branding.

H11 runtime acceptance is PASS. Final H11 governance status will become CLOSED / PASS when the current targeted Frontend Build and deployed browser UAT for CF-101 both pass.
