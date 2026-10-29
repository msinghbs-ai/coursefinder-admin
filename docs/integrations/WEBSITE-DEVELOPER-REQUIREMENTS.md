# StudySearch – Website developer requirements register

**Version:** 2.4 (30 Oct 2026; O9 no-scale wording recorded; developer guide issue 5 unchanged)
**Change control:** CF-247 · **Decisions:** 257 (website API v2), 258 (institution type)
**Owner:** Platform Admin. **Who updates it:** any chat that changes the website API or the data behind it, in the same change-control entry.
**Developer document:** `docs/integrations/developer-pack/StudySearch-Website-API-v2-Developer-Guide.md` (the master; Word, PDF, OpenAPI and Postman files beside it are what the developer receives, rebuilt with `build.sh`). The Version 2 handover (`coursefinder-wix-api-handover-v2.md`) is now the internal history and long-form reference as at 14 Oct 2026; it is no longer sent.
**How it works now:** `docs/platform/SYSTEM-REFERENCE.md` §4b (website API v2) and §4c (institution type).

This page is the single list of what the website developer has asked for, what the platform returns today, and what is still open. Start here before changing anything the website reads.

## Rules for any change the website reads

1. **Additive only.** `website-search-v2` keeps every field, filter and action it has. New fields and filters are added; nothing is renamed or removed. A breaking change needs a new contract (Version 3) and a Platform Admin decision.
2. **The provider Published switch is the control.** A provider switched off or archived is not returned by any action, with its courses, campuses and scholarships (`security.provider_hidden_v1`).
3. **Nothing is inferred.** null means not held. No defaults, no estimates, no currency conversion.
4. **Guard and record.** Every replaced website function is md5-guarded in its migration. `tests/uat/cf-247-website-api-v2-contract.spec.mjs` and `cf-247-institution-type-contract.spec.mjs` must pass.
5. **Reissue the developer pack** for any change the developer can see: edit the guide master, add a line to its section 13 (Changes to this guide), update `gen_api.py` if a field, filter or action changed, run `build.sh`, and check every example live. Update this register and System reference §4b in the same entry.
6. Keep repository names, commit hashes, internal tools and keys out of the developer pack. Keys go to the developer by a secure channel only.

## Requests and status

Sources: the website team's requests of 15 September and 1 October 2026, and later follow-ups.

| # | Request | Status | Where it is returned |
|---|---|---|---|
| R1 | One API for Course Finder, University Finder and Scholarship Finder | **Done** (8 Oct); nine actions from 14 Oct (sync added) | `website-search-v2`, same endpoint and key |
| R2 | Course search filters: keyword, country, state, city, study level, study area, intake month, English test and score, tuition range, regional category, university group, has scholarship | **Done** | `search` (handover 13.1) |
| R3 | Course fields: official link, intakes, English, tuition with its basis, campuses, scholarships | **Done**; coverage grows as data is admitted. New Zealand and Canada gained campuses, study area, duration and delivery on 14 Oct (O1) | `search`, `course` (13.2, 13.3); coverage in section 14 |
| R4 | A code to show visitors for every course | **Done** (14 Oct) | `display_code`, `display_code_kind`, `display_code_label`; `course` accepts it |
| R5 | Canada searchable | **Done** (8 Oct) | `country_codes` CA |
| R6 | University Finder: filters, rankings, logos | **Done**; rankings and logos **approved for display** (Platform Admin, 14 Oct 2026; `terms_status` approved, from Settings › Pipeline settings › Website API) | `providers`, `provider`, `rankings` (13.4, 13.6, 13.7) |
| R7 | Scholarship Finder with the website's field names | **Done**; `reference_code` is null (national registers no longer used) | `scholarships`, `scholarship` (13.5) |
| R8 | Provider statistics (QILT) | **Done** (14 Oct), provider grain only, Australia only | `outcomes` on `provider` and `course` detail |
| R9 | Institution type (university, TAFE, college) | **Done** (14 Oct) for Australia and New Zealand; Canada null | `institution_type {code, name, basis}`; filter `institution_types`; list in `reference` |
| R10 | Unpublished providers and courses must not reach the website | **Done** | Provider Published switch (rule 2) |
| R11 | Logo dark variant, brand colour | **Not held** | null |
| R12 | Academic entry requirements, specialisations | Academic entry: see **R19** (returned since issue 5). Specialisations: **not held** | `entry`, `entry_matrix` (R19); specialisations not returned |
| R13 | Average tuition per provider | **Not returned by decision** (no sound basis) | — |
| R14 | Website prototype table shapes | **Not provided by decision**; the website maps v2 fields once | — |
| R15 | Logos as file links Wix can store, with the longest practical validity (Platform Admin, 14 Oct 2026) | **Done** (14 Oct): signed links valid 365 days (`website.logo_link_days`), resent in the sync delta 30 days before they end | `logo.url`, `url_expires_at` (13.7); Step B2 |
| R16 | After a full load, later calls return only what changed, unless a full load is asked for (Platform Admin, 14 Oct 2026) | **Done** (14 Oct): action `sync` with a cursor; full load in pages, then new, changed and removed items | `sync` (13.8); acceptance tests 12a, 12b |
| R17 | A clean developer pack to send to the developers (Platform Admin, 15 Oct 2026) | **Done** (15 Oct): developer guide (Word, PDF), OpenAPI 3.1 file and Postman collection with no key; a separate developer key (`coursefinder_website_developer_pilot_v1`, own rate limit, v2 only), handed to the Platform Admin once | `docs/integrations/developer-pack/` |
| R18 | Duolingo English Test (DET) scores on courses (Raghav, 16 Oct 2026) | **Done** (17 Oct, migrations 20261017020000 and 030000, worker v0.27.1, policy parser v0.2.4): DET is an English test (10–160, overall only); read from approved English policy pages (job `policy-add-tests`, hourly, stored pages only) where the page's IELTS for the level matches the approved policy; 531 courses (Australia 347, Canada 184) at 4 universities on 17 Oct. Coverage grows as policies are approved and read; course pages and adapters do not read DET yet | `english_requirements` (`test_code` DET), filter `english_test_codes`, `reference` |
| R19 | Academic entry requirements by country of previous study (Raghav, 16 Oct 2026; replaces R12's academic part) | **Returned** (developer guide issue 5, 29 Oct 2026; consumer fields approved 25 Oct and shipped in Pilot #720). Coverage grows only as a person admits rows in Layer 4: on 29 Oct, one provider's table (343 rows) and no course rows were active. The website display is the website team's work and is not built | `edu_country` on `course` and `provider`; `entry` (with `resolution`) on `course`; `entry_matrix[]` on `provider` (guide §7.9). Planned name `academic_entry` was not used |
| R20 | Scholarship eligibility by nationality, searchable (Raghav, 16 Oct 2026) | **Planned**; 104 of 2,047 scholarships name nationalities today | `nationalities` (held) plus filter `nationality` on `scholarships` (additive) |
| R21 | Lighter logos for the full load (from Raghav's measures: 1,550 logos, 131 MB, 283 WebP) | **Planned**; waits for the formats Wix accepts | `logo.url` points to a standard copy; original kept |
| R22 | Fewer, faster full-load calls (from Raghav's measures: 257 calls, 2 min 53 s, largest page 628 KB) | **Done** (17 Oct, migration 20261017010000): sync pages up to 600 size units (`website.sync_page_max`); full load about 86 calls, about 1–2 minutes; replies compressed with `Accept-Encoding: gzip` (about 15 MB instead of 113 MB). O8 closed | `sync` (6, 6.1) |

## One path for the website (Platform Admin, 15 Oct 2026: "API first, platform after")

Website API v2 is the only path the website should use. From 16 Oct 2026 it has its own address, `website-api-v2` (own key, no contract field, every call logged; Platform Admin 11:43: "build the Website v2 URL as parallel without disturbing api v2 through v1 url with contract"). These are **marked for retirement once the developer is live on the new address**; nothing is removed now:

| Path | What it is | Retire when |
|---|---|---|
| `wix-course-api` without a contract (contract `wix-cache-v1`: sync_courses, reference_bundle, lookup, search, scholarships) | The first Wix path; answers the Wix key only | The website runs on v2 in Production and v1 calls have been zero for 14 days |
| Edge function `website-course-api` (contract `website-integration-v3.1-pilot`) | An earlier website path | Same; the usage audit showed no calls |
| `wix-course-api` with contract `website-search-v2` | The same answers as `website-api-v2` (same database functions), through the old address and key; not logged on Operations › API usage | The developer has moved to `website-api-v2` and the switch-off date is agreed |

Removal is a separate change: a paste file for the Platform Admin, never an applied migration.

## Build plan for R18–R22 (16 Oct 2026, Platform Admin 23:44: "Start planning developer latest request & create feature number for each of them. Keep all pending tasks, housekeeping and production readiness in mind. All operation and functions needs to be adhered while planning new features and bug fixes. Platform has to be self sustainable and improving.")

Status (17 Oct 2026): **R22 and R18 done**; R21 waits for the formats Wix accepts; R20 next; R19 waits for Raghav's example and the country choice. Each feature is built, tested and released on its own, in the order below. Figures measured live on 16 Oct 2026.

### Standard every feature meets (self-sustaining, production-ready)

| Area | Rule |
|---|---|
| Settings | Every number (batch size, re-read days, AI budget, limits) is a setting on Settings › Pipeline settings (G2); nothing hard-coded |
| Jobs | Every background step is a catalogued job or task type, visible in Task manager with Pause, Resume and Run now |
| Flags and move-on | Unreadable or unclear pages raise a flag with evidence (Decision 261); hard reasons hold at once, soft after 2 tries; no endless retries |
| Evidence | Values are read from stored pages (evidence first); the quote and page are kept and shown in the UI |
| Keeping current | Re-read when the stored page changes, and at least yearly; never a blind overwrite; manual values are never overwritten |
| Housekeeping | Each new table has a `comment on table`, a retention rule decided at build, a component register row, and its size on the daily storage record; the old approach is retired in the same change (Decision 260) |
| API | Additive only on v2 (rule 1); null means not held; contract tests extended; developer guide section 13 gets one line per API change |
| Release | Full test suite, dry run on live, md5-guarded functions, version pill notes for screen changes, change-control entry |
| Production | Tuned in Pilot; data admitted in Production only (operational data never flows back) |

### Features

| # | What gets built | Database change | How values are filled | Effort and running cost | Growth (database) | Waits on |
|---|---|---|---|---|---|---|
| R22 | Provider detail built directly by id (O8); sync page size raised back by setting; page byte cap kept | None | Not applicable | About 1 day; no running cost | None | Nothing |
| R21 | A standard logo copy per provider (one format and size, setting-driven), made by a job; `logo.url` serves it; original kept | Copy path on the logo record | Job converts new or changed logos; Task manager shows it | About 1 day; no AI | Under 1 MB (files about 30–50 MB in `provider-assets`) | Raghav: formats Wix accepts (PNG only, or PNG and WebP; SVG?) |
| R18 | DET added as an English test; rule reads DET scores from the stored English policy pages; AI re-read only where the rule is unsure | One row in `ref.english_tests`; DET rows in `catalogue.course_english_requirements` (27,225 rows, 14 MB today) | Text rule first, cheapest vetted model second, from stored pages (no new scraping) | About 1 day; under US$5 | About 5–10 MB | Nothing |
| R20 | Nationality list read for every published scholarship; filter `nationality` on `scholarships` | None (`scholarship.scholarships.nationalities` exists) | Existing jobs `scholarship-nationality` and `scholarship-audience` widened, then AI re-read of stored pages where the wording is unclear | About 2 days; about US$3–8 | Negligible | Nothing |
| R19 | Academic entry requirements by country of previous study: page finder, table parser plus AI with quote checks, Layer 4 review screen for unclear rows, API field | New table `catalogue.course_entry_requirements` (course, country of study, qualification, minimum, evidence) | Focus universities first; pages found and read through Firecrawl, then stored and parsed | About 4–5 days build, 1–2 weeks to fill; about 1,000–3,000 Firecrawl credits and US$10–30 | About 40–60 MB for focus universities | Raghav: one university example; Platform Admin: which countries of previous study come first |

### Order and gates

1. **Housekeeping headroom first:** run the D6–D10 paste file (about 270 MB) before R19 adds its table; register replay keys (step 3), discovery links (step 4) and Layer 3 history (step 5) are decided alongside.
2. **R22, then R21:** they make the developer's full load lighter with no new data (R21 once Raghav confirms formats).
3. **R18, then R20:** small, read from pages already stored.
4. **R19:** after Raghav's example and the country choice; build in Pilot, measure on a handful of universities, then fill.
5. After each: developer guide issue with a section 13 line (API changes only), this register updated, change-control entry.

## Open work (for the build chat)

| # | Item | Why it matters | Notes |
|---|---|---|---|
| O1 | ~~Recheck campus coverage for New Zealand and Canada in the API~~ **Done 14 Oct (v2.15.276, migration 20261014090000)** | Measured through the API: courses with a campus NZ 2,603, Canada 2,332 (with a city 1,928 and 1,807). Found and fixed on the way (Platform Admin decisions "Clear unproven NZ, keep CA" and "Refresh + delivery fix"): New Zealand campuses had taken the provider's head-office region (132 cleared; kept where the campus is in the provider's city); the search projection had not been refreshed, so study area, level and delivery from Enrich fields were not reaching the API (now NZ study area 6,053, delivery 3,868; Canada 4,601 and 3,204) | Handover section 14, the campus sentence and the 13.1 delivery note updated; reissued with a change-log line |
| O2 | Institution type for Canada — **Parked: pending data-enrichment task PE-1** (left empty, Platform Admin 14 Oct 20:39) | Canada is null (Platform Admin chose to leave it empty on 14 Oct) | Needs a Platform Admin decision on the source (for example IRCC DLI list and provincial registers) before any build |
| O3 | training.gov.au (national VET register) — **Parked: pending data-enrichment task PE-2** (left empty, Platform Admin 14 Oct 20:39) | Would confirm RTO status for Australian VET providers | Legacy web services need credentials; Platform Admin chose to ship without it |
| O4 | Five Australian providers have no institution type; Aviation Australia and Canning College are typed TAFE / Polytechnic — **Parked: pending data-enrichment task PE-3** (left empty, Platform Admin 14 Oct 20:39) | Visible to the website as null or as TAFE | Platform Admin to review; set by hand on Providers › Type, or change the rules on Settings › Pipeline settings |
| O5 | ~~Rankings and logos usage terms~~ **Done 14 Oct (v2.15.277)**: Platform Admin decision "Yes, approved to display" | Closed PE-4 | `terms_status` approved for rankings and logos; changed by a Yes/No setting with a reason |
| O6 | Filtered search timings | Institution type filter about 2.3 s cold (about 1.6 s without it). `reference` passed the 8 s limit under load (5.5–6.6 s): fixed 15 Oct with a copy rebuilt every 15 minutes | Watch; optimise only if the developer reports slowness |
| O8 | Provider detail is slow (about 0.5 s, up to 2.3 s in a sync page) | It builds the providers list to answer for one provider; sync pages hold 3 provider details so a page stays under the limit | Follow-up: build the provider detail directly by id; then raise the page back up. **Closed 17 Oct 2026 (R22)**: items are served from the stored copy; one provider detail builds in about 0.13 s |
| O7 | ~~Duration quality~~ **Done 14 Oct (migration 20261014100000, worker v0.23.2)** | Platform Admin decisions: "Undo and tighten rule" and "Keep null". The two New Zealand durations read from a fee line are withdrawn (items kept, reversible); the Enrich fields worker no longer admits a duration quote about the fee basis; 294 semester durations stay null in `duration_months` | Handover reissued: section 14 NZ duration 2,929, known data-quality line, change-log line |
| O9 | **Printed grade with no stated scale (Platform Admin decision A4, 30 Oct 2026): wording approved, API marker not built** | A provider page may print a grade (for example "minimum 75") without saying on what scale. The approved wording principle is: *"Published requirement: [grade]. The provider does not state a grading scale on this page; check the source or contact the provider."* The printed value and evidence are kept; no scale is inferred, normalised, or shown as a percentage, ATAR equivalent or converted band; it stays distinct from case by case and from no published requirement. | Today the API cannot tell this case apart: the reader assigns a scale, and `scale: "none"` already means "no minimum stated" (case by case). Until an additive marker exists, reviewers exclude such rows in Layer 4 (role guides 5.2), so none reaches the website. **Next decision:** an additive, website-visible marker (for example a row field `scale_stated: false`), which is a Website API v2 change under G3. When it is built, the developer guide gets the rendering rule and a §13 line; the website team renders it. |

## History

| Version | Date | Change |
|---|---|---|
| 2.4 | 30 Oct 2026 | O9: Platform Admin decision A4 (no-scale wording) recorded. No API change; developer guide issue 5 unchanged. |
| 2.3 | 29 Oct 2026 | R19 returned (guide issue 5, §7.9); R12 points to it. Guide §7.9 clarified without an API change: the `country`, `note` and `contact` fields of `resolution`, the four step-5 notes, when a row is case by case (no minimum on a scale), and examples (a provider row with scale `none`, a course without `edu_country`). No §13 line, since the API did not change. Operator-side roles: `docs/platform/AER-ROLE-GUIDES.md` section 6 |
| 2.2 | 17 Oct 2026 | R22 done (sync pages 600, gzip, about 86 calls); R18 done (DET from approved English policy pages, 531 courses; parser v0.2.4 also fixes "105 Overall ; 110 Speaking" read as 110); O8 closed; developer guide issue 4 (section 13 line, 6.1 measures, DET in 7.2 and section 8). |
| 2.1 | 16 Oct 2026 | Developer requests from Raghav's email numbered R18–R22 (Duolingo, academic entry by country, nationality eligibility, lighter logos, faster full load) with a build plan, the standard each feature meets, and the order and gates. R12's academic part moves to R19. |
| 2.0 | 16 Oct 2026 | Website API v2 at its own address, `website-api-v2` (Pilot PR #544, migration 20261016050000): its own key `website_developer_v2`, 300 calls a minute per key (setting `website.rate_per_minute`), every call logged on Operations › API usage; same nine actions and answers as the contract path, which is unchanged. Developer guide issue 3 (address, no contract field, `api_version`, error `message` and `detail`; figures re-measured) |
| 1.9 | 15 Oct 2026 | Faster Wix full load (Platform Admin 17:46, "Prepared items + bigger pages"): `sync` serves items stored by the change check; pages up to 200 items and about 550 KB; full load about 250 calls, about 5 minutes (was 1,426 calls, about 25 minutes). Guide issue 2: 6.1 what to expect, 6.2 what we expect from the sync job (Platform Admin 18:37); OpenAPI and Postman regenerated. |
| 1.8 | 15 Oct 2026 | Platform Admin 17:24: "Wix consumer developer Dont need to know fixes on the platform ... only detials about api changes from last version." Rule: the developer guide's section 13 lists API changes only (new field, filter, action or behaviour) against the previous issue; platform fixes and data corrections are not described to the developer; measured figures (section 8, examples, acceptance counts) are refreshed with each issue. Guide reissued: section 13 holds the first-issue line only; section 8 re-measured (15 Oct 2026). |
| 1.7 | 15 Oct 2026 | Developer pack refreshed and reissued (Platform Admin 17:02). Found while re-measuring: `reference` listed Sydney under Brisbane; each city now takes the metro area most of its campuses have, and two campuses with a wrong register state take the state their address names (migration 20261015090000). Acceptance counts refreshed (course example 78; providers with a logo 265 and rising). Contract unchanged. |
| 1.6 | 15 Oct 2026 | Bug fix (Platform Admin 12:31): Canadian courses with no campus take the provider's province in `subdivision_codes` (setting `search.region_from_provider_countries`, CA); intake months no longer repeated (guard on the table). Developer guide reissued with a change line. |
| 1.5 | 15 Oct 2026 | Developer pack (R17): guide, OpenAPI, Postman, developer key; rule 5 now reissues the pack; v1 and `website-course-api` marked for retirement; O6 note, O8 added. |
| 1.4 | 14 Oct 2026 | v2.15.277: R15 logo links 365 days, R16 sync action with cursor, R6 rankings and logos approved for display; O5 closed (PE-4). |
| 1.3 | 14 Oct 2026 | O2–O5 parked as pending data-enrichment tasks PE-1 to PE-4 (`docs/platform/FIELD-GAPS-AND-ENRICHMENT-PLAN.md` section 10); values stay empty until attended. |
| 1.2 | 14 Oct 2026 | O7 done: two fee-line durations withdrawn, worker rule tightened, semesters stay null. |
| 1.1 | 14 Oct 2026 | O1 done: New Zealand and Canadian campuses and Enrich fields values in the API, New Zealand campus regions only where proven; O7 added (duration quality). |
| 1.0 | 14 Oct 2026 | First issue: rules, requests R1–R14 with status, open work O1–O6 (after v2.15.276 institution type). |
