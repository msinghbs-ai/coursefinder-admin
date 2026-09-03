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
