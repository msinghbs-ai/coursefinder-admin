# StudySearch API v3 – field definition

**Current document status (13 November 2026):** Website API v3 is deployed and responds to a valid key, but the Wix developer has not switched to it; Zoho API v3 is not yet deployed in the last verified repository status. The detailed release-1 design based on unmerged Pilot #1085 in sections 1–6 below is **historical/proposed**, not the deployed v3 contract. Read the dated deployed-state notes and new S2-CF/S2-Intakes addenda first; verify against live before describing any proposed field as released. **Document revision 0.3 (13 November 2026).**

> **Deployed state, 12 Nov 2026 22:10 AEDT (read this before section 1).** What is live is the WP-0 copy, not the release-1 design below:
> - **Live:** edge function `website-api-v3` (version 1, Pilot #1084) and the `public.website_v3_*` functions, which wrap the unchanged v2 functions. R28 `intakes[].start_date_status` (#1084, migration `20261113180000`). R23 provider `campuses[]` one item per campus with `campus_id`, `campus_name`, `course_count`, and R24 scholarship `nationality_eligibility_status` (Pilot #1088, merge `514cb3bd`, migration `20261113190000`; the applied statements equal the file, md5 `80d0fe37…`).
> - **Also live (12 Nov 2026 22:50 AEDT):** R29 scholarship linked-course paging (Pilot #1091, migration `20261113200000`); R31 provider `scholarships_page_url` and `scholarships_last_reviewed_at`, and O26 search `description_excerpt` (Pilot #1092, migration `20261113210000`). Note: the deployed O26 length is fixed at 240 characters by the build brief; #1085 made it a setting.
> - **Also live (12 Nov 2026 23:30 AEDT):** O20 `quote` and `source_url` on entry rows (Pilot #1093); O22 search filter `has_academic_entry` with optional `edu_country` (Pilot #1097); the scholarship detail fields `description`, `award_type`, `sponsor`, `programme`, `award_code`, `benefits[]`, `application {method, url, rolling}`, `award_duration`, `academic_year`, `excluded_nationality_codes[]`, `nationality_regions[]` (Pilot #1098, migration `20261113240000`; the v3 home of the v2 draft #1077); OET and CELPIP as English tests (Pilot #1099; data, in v2 and v3).
> - **Also live (13 Nov 2026 11:40 AEDT):** `zoho-api-v3` (Pilot #1107, migration `20261113290000`): a copy of `zoho-api-v2` calling `public.zoho_v3_*`, one function per action, same keys, rate limit and log (`v3:<action>`). `search` adds R28, `description_excerpt` and `scholarships_top[]` (Z1); `course` adds R28 and, with `edu_country`, the Website v3 entry (Z4); `courses` adds R28; `scholarships`, `scholarship` and `rankings` are the Website v3 answers; the other actions, `sync` and `export` are v2 unchanged.
> - **Not built, closed (draft Pilot #1085, closed 13 Nov):** the dispatchers `website_v3_call` / `zoho_v3_call`, schema `api_v3`, the release switch `api.v3_released`, and the null placeholder keys. Each part's disposition is on the PR.
> - **So, today:** `website-api-v3` has no release gate. It answers any valid website key. The website has not switched to it, so under Decision 277 v3 is still open (additions only) and not yet frozen.
> - **v2 unchanged:** `api.website_v2_provider_campuses` and `api.website_v2_scholarship_item` are at their 5 Nov definitions (md5 `57115d3b…`, `d1792cc7…`). Monash: v2 returns 8 merged campus items, v3 returns 9 named campuses with course counts.
> - **Decided (Platform Admin 13 Nov 2026 10:25):** v3 keeps the deployed shape. No global gate; a consumer goes live by switching its address, under the comms rule. Sections 1 and 6 below still describe the superseded #1085 design where they mention a dispatcher or release switch.

Mandate: Platform Admin, 12 Nov 2026 21:12: "API v3 is getting prepared - any new field that needs programing or missing in v2 should defined, added to v3 and be ready for website and zoho".

## 1. What v3 is

- **New addresses beside v2.** The website uses `website-api-v3`. Zoho uses `zoho-api-v3`. Both use the same keys, rate limits and call log as v2; calls are logged as `v3.<action>`.
- **v2 does not change.** `website-api-v2` and `zoho-api-v2` keep running exactly as they are (Decision 266).
- **v3 is v2 plus additions.**
  - Every v2 action, argument, field, filter, error and page shape is the same in v3. Nothing is renamed or removed.
  - The website and Zoho can switch one screen or one sync at a time.
  - `api_version` reads `website-v3` or `zoho-v3`.
- **Null means not held.**
  - Every field defined for v3 is present on every item from release 1, so the developers build against the final shape once.
  - A field the platform cannot fill yet is `null`. It fills in as the data is admitted, with no new release needed.
- **One release switch.**
  - The release switch is pipeline setting `api.v3_released` (Settings › Pipeline settings › Website API). It is off.
  - Until it is turned on, both v3 URLs answer `403 V3_NOT_RELEASED`.
  - Turning it on is the release step. It is taken with the release authorisation and the developer communication, under the standing rule for Wix and Zoho changes.
- **How it is built.**
  - Each v3 URL calls one dispatcher: `public.website_v3_call` or `public.zoho_v3_call`.
  - The dispatcher calls the unchanged v2 function and adds the v3 fields from schema `api_v3`. The v3 answer can therefore never disagree with v2 on a v2 field.

## 2. Fields in v3 release 1 (data held, filled now)

| Entity | Field | Type and values | Source on the platform | Request |
|---|---|---|---|---|
| Scholarship | `description` | text | the scholarship description (until now only on `scholarship` detail) | F-SCH developer field contract |
| Scholarship | `award_type` | `scholarship` · `bursary` · `tuition_waiver` · `fee_discount` · `research_funding` · `grant` · `stipend` · `other` · null | `scholarship.award_details`, from verified passages (F-SCH detail fill) | F-SCH |
| Scholarship | `sponsor`, `programme`, `award_code` | text · null | `scholarship.award_details` | F-SCH |
| Scholarship | `benefits[]` | `{type, amount, currency, percentage, is_maximum}` | `scholarship.coverage` (verified detail rows) | F-SCH |
| Scholarship | `application` | `{method: separate_application · automatic_consideration · nomination · null, url, rolling}` | `scholarship.application_windows`, `award_details` | F-SCH |
| Scholarship | `award_duration` | `{value, unit}` · null | `scholarship.coverage` | F-SCH |
| Scholarship | `academic_year` | text · null | `scholarship.scholarships` | F-SCH |
| Scholarship | `nationality_eligibility_status` | `restricted` · `unrestricted` · `under_review` · `unknown` (an empty list is never `unrestricted`) | nationality readings and criteria; `under_review` while a Layer 4 nationality item is pending | R24 |
| Scholarship | `excluded_nationality_codes[]`, `nationality_regions[]` | country codes; regions as the source names them (never expanded) | nationality criteria | F-SCH |
| Provider | `campuses[]` | one item per campus, never merged by city: v2 keys plus `campus_id`, `campus_name`, `course_count` | `catalogue.campuses`, returned courses linked to each campus | R23 |
| Course | `intakes[].start_date_status` | closed list of 11 values (section 2.1) | course intakes and the intake planner's last decision | R28 |
| Course | `description_excerpt` | text, cut at a full word (length: setting `api.v3_description_excerpt_chars`, 280) | the served course description | O26 |
| Reference | `v3` | the closed lists: `start_date_statuses`, `nationality_eligibility_statuses`, `award_types`, `application_methods` | fixed in v3 | — |

### 2.1 `start_date_status` (R28)

The values are `known`, `no_official_calendar`, `month_only`, `not_on_course_page`, `course_page_not_verified`, `next_year_calendar_pending`, `not_yet_read`, `own_calendar`, `conflicting_evidence`, `held_for_review` and `rolling`. Their meanings and what to show visitors are in WEBSITE-DEVELOPER-REQUIREMENTS.md, section "Intake start-date status".

| Status | Live 12 Nov 2026 21:3x (AU active intakes, 24,625) |
|---|---|
| no_official_calendar | 10,575 |
| known | 4,420 |
| course_page_not_verified | 3,144 |
| month_only | 2,765 |
| next_year_calendar_pending | 1,491 |
| conflicting_evidence | 1,079 |
| not_yet_read | 779 |
| own_calendar | 250 |
| held_for_review | 91 |
| not_on_course_page | 31 |

## 3. Fields defined in v3, null until the platform holds them

Each of these needs a reader, a register or a data programme before it can be filled. The key is already present (null) on every v3 item. Its type is fixed here, so the website and Zoho can build the display now.

| Entity | Field | Defined type | What must be built first | Item |
|---|---|---|---|---|
| Course | `teaching_language` | ISO 639-1 code, e.g. `en` | a course-page reader for the language of instruction | O17 |
| Course | `study_load` | `full_time` · `part_time` · `both` | an attendance field in the catalogue (the Courses rule keeps full-time on-campus today) | O25 |
| Course | `post_study_work` | `{scheme, months, basis, source_url}` (485, PSWV, PGWP, OPT) | country rule tables plus the course's level and field code | O27 |
| Course | `field_of_study_codes` | `[{scheme: ASCED·CIP·NZSCED, code}]` | code crosswalks per country | O28 |
| Course | `recognition` | `[{scheme: NZQA·DLI·ILEP·CROHO·MQA…, status, source_url}]` | the official registers | O29 |
| Course | `admission_tests` | `[{test, required: required·optional·test_optional, min_score, quote, source_url}]` | an admission-test reader | O18 |
| Course | `entry_conditions` | `[{kind: APS·NAWA·UNEDasiss·foundation·entrance_exam, applies_to: country codes, quote, source_url}]` | an AER v2 condition reader | O19 |
| Course | `application_route` | `{route: UCAS·uni-assist·OUAC·…·direct, url, limited_places}` | country route reference data | O23 |
| Provider | `logo_dark`, `brand_colour` | logo object as `logo` · `#rrggbb` | brand assets are not held | R11 |
| Provider | `accreditations[]` | `[{body: AACSB·EQUIS·AMBA, scope, source_url, checked_at}]` | a provider accreditation table from each body's official list (decision D-3) | R30 |
| Provider | `campuses[].is_primary`, `campuses[].primary_basis` | boolean · null; `registered_address` · `city_match` · `manual` · null | a primary-campus table, rule and manual override (decision D-4); registered head office matches one campus for about 31 of 45 AU universities | R32 |

## 4. Later v3 releases (data held, extra programming needed)

These items are candidates for release 2. Each adds a key or filter to v3 only, and each is recorded here before it is built.

| Item | Change in v3 | Notes |
|---|---|---|
| O20 | `quote` and `source_url` on `entry_matrix[]` items; `source_url` on `entry.resolution.rows[]` | data held; needs matching each served row to its admitted record |
| O22 | `has_academic_entry` filter on `search` (optionally `edu_country`) | parity with `has_english` |
| O16 | `english_waivers[]` by country of previous education | AER v2 reader |
| O13, O14, O15 | more language tests in `ref` and level-type requirements (CEFR, TOPIK, JLPT…) | reference data and reader |
| O21 | qualification codes and a list per country of education in `reference` | reference data |
| Zoho export | v3 columns in the `export` CSV | release 1 serves the v2 CSV; the v3 fields come through `search`, `course(s)`, `provider(s)`, `scholarship(s)` and `sync` |
| R21 | lighter standard logo copy | waits for the formats Wix accepts |
| R29 | `scholarship`: `courses_page`, `courses_page_size` (1–200), `linked_courses_total`; no paging = first 200 as v2 | 176 of 1,053 linked scholarships exceed 200 (max 563) |
| R31 | provider `scholarships_page_url`, `scholarships_last_reviewed_at` | data held in `pipeline.scholarship_listing_pages` |
| Z1 | Zoho `search` items: scholarship summary (top 5: id, name, amount_type, amount_value, currency) | Divya, 3 Nov 2026 (REQ-31) |
| Z3 | Zoho `export` and `sync` countries beyond AU (setting `zoho.sync_countries`) | Divya, 3 Nov 2026 (REQ-35); setting, released with v3 |
| Z4 | Zoho `course`: `edu_country`, as website `course` | REQ-28 |

## 5. Not in v3 by decision

The following stay out of v3:

- R13 and R27: university-level average tuition and costs. There is no sound basis.
- R14: prototype table shapes.

## 6. Release checklist (when authorised)

1. Measure the v3 timings against v2 on the live project (search, scholarships and sync pages).
2. Issue the v3 developer guide: the v2 guide plus sections 2 and 3, with an OpenAPI file and a Postman collection.
3. Record the release authorisation. Set `api.v3_released` = 1 with that reason.
4. Add the v3 functions to the consumer API baseline and to the G3 list in CLAUDE.md. From release on, v3 is frozen like v2: fields are only added.
5. Confirm the first website and Zoho calls in Operations › API usage, where they are logged as `v3.<action>`.

## S2-CF course developer fields — planned v3 additions and acceptance (13 November 2026)

**Source of truth:** [Developer requirements register](../WEBSITE-DEVELOPER-REQUIREMENTS.md#s2-cf--course-module-developer-requests-and-api-v3-delivery-13-november-2026), specifically REQ-21, -36, -48, -51, -52, -53, -58 and -61. S2-CF is the Course Module Claude workstream; this section specifies **planned** behaviour and acceptance, not proof that fields or routes are currently deployed. Website API v3 already has R28 intake status, O26 description excerpt and O22 `has_academic_entry` filtering. Website API v2 and Zoho v2 remain unchanged/frozen. Draft Pilot #1085 is **not** the deployed Website v3 implementation and its website dispatcher, schema and switch must not overwrite live v3.

| Developer requirement | Proposed v3 change or data correction | Implementation boundary |
|---|---|---|
| REQ-21, applicant prior qualification | New v3 search inputs for **country of prior education, awarding board/qualification system, prior qualification/level, and score with explicit scale** (percentage, GPA, WAM). Design input names and output evidence only after comparing existing AER reference/resolution and API v3 signatures. No implicit equivalence conversions or personal applicant profile storage | AER owns equivalence/policy and safe match/unknown/held; S2-CF owns Course search integration, non-destructive filter behaviour and API/UX |
| REQ-36, Sujata's 30 fields | One original-field→canonical→v3 list/search/detail/sync→UI→missing-reason matrix using the actual source request (not an invented field list); cross-workstream AER and Scholarship facts referenced rather than duplicated | Canonical developer register; acceptance contract, no new programme |
| REQ-48/51, intakes, English, duration | Per-course real presence and evidence, prioritise Massey and Canterbury; historical missing coverage counts are not current | Existing source/read/admit/projection paths |
| REQ-52, full-time/part-time | `study_load` planned type: `full_time | part_time | both | null`; **not proven live**; source evidence and clear applicability required | Do not derive from online/on-campus or school schedule |
| REQ-53, study/delivery mode | Existing delivery-mode concept needs AU/NZ/CA data-quality/projection checks; missing counts from the S2-CF report are dated | Do not conflate mode with study load; use current canonical enum where supported |
| REQ-58, NZ/CA course state | Retain source-backed **course-campus** subdivision/province; avoid provider head-office default; represent multiple legitimate campus regions, and add a new field only where existing v3 campus payload cannot express them | Avoid fabricated single state for multi-campus courses |
| REQ-61, descriptions and official URL | Full source-grounded canonical description in detail; short whole-word `description_excerpt` in search; official exact-course URL only where verified, otherwise null and explicit gap reason | Distinguish canonical vs projection vs Website/Zoho visibility; no generic provider URL fallback |

**Admin acceptance with every new field:** Reuse the *actual deployed* Course Catalogue/Detail and Layer 2/3 → Operations → Data Delivery (and AER workspace where applicable). Add an optional field-specific column and compact **Present / Missing / Held / Not applicable** facet when it helps operators identify actionable gaps; provider/country/level/campus drill-down, source evidence, last attempt, next job, and canonical → Website v3 / Zoho v3 parity. Do not put 30 permanent columns on one screen or invent navigation. Verify role and deployed UI component. Server-side paging and bounded reads remain mandatory.

**Zoho v3 integration:** Rebuild only the distinct, still-needed Zoho v3 contract from draft #1085 against the **deployed Website v3 head**. Reuse admitted canonical facts and stable identifiers; keep Zoho v2 unchanged. Avoid the superseded #1085 website dispatcher / release-gate / schema approach. Check Zoho v3 search, course, sync and export separately; report any unsupported filters or columns rather than silently returning empty/misleading data. Close the superseded draft after accounting for each unique Zoho requirement. The actual developer cutover, new endpoints/keys and v3 API freeze require the canonical developer notification and go-live process.

**Course description recovery:** S2-CF reports 3,247 descriptions on 13 Nov 09:05 AEDT and no new reads after its cap was restored to 8,000/day; another dated developer snapshot says 3,391. Reconcile timestamp and populations before updating a live baseline. Diagnose planner/queue eligibility immediately, reuse stored/paid evidence, and prepare a **versioned source-grounded prompt v2** only after a breakdown of 5,190 check-held readings and ~25% existing prompt acceptance. No silent lowering of protected identity/claim, manual lock or publication checks; prove targeted regression and admission gains. Schedule execution through existing jobs; use the authorised on-demand request path when explicitly requested, observing the vendor-account floor and safety policies.

## S2-Intakes — Course intakes, deadlines and date evidence (13 November 2026)

**Owner:** F-INT / S2-Intakes; source: [Developer request register REQ-25, -48, -51, -69 and R28](../WEBSITE-DEVELOPER-REQUIREMENTS.md#s2-intakes--course-intake-module-developer-requests-and-v3ui-acceptance-13-november-2026). The information below is a **v3 design / implementation contract**; this document does not prove new fields, functions, filters, UI or Zoho v3 are deployed. S2-CF owns the rest of course data; AER owns academic entry and country/qualification matching. Consumer v2 remains frozen.

### Deployed baseline and proposed delta

| Entity / operation | Existing / verified in repository | Required design or proof | Status |
|---|---|---|---|
| Website v3 `course`, `search`, `sync` | `intakes[].start_date_status` via `security.intake_start_date_status_v1`; existing intake display fields | Keep existing stable list of 11 reasons. Independently confirm that year, month, exact day and deadline appear correctly with correct course/campus/term and that list/detail/sync remain consistent | R28 **deployed**; coverage incomplete |
| Website v3 intake deadline | Deadline may be absent/null; no verified independently coded reason | Add `intakes[].application_deadline_status` **if existing fields cannot explain unknown/rolling/not-applicable**, and source URL, last verified time and local deadline timezone where actually held. Proposed closed values: `known`, `rolling`, `not_published`, `not_yet_read`, `source_unverified`, `conflicting_evidence`, `held_for_review`, `not_applicable`, `unknown`. Finalise type/keys after checking the live v3 item shape and canonical source data; do not emit fabricated status/date | **Proposed, not live** |
| Website v3 search | Existing intake-month filtering | Check whether course/student requires an intake year or exact-date/availability filter; add only scoped filters with clear semantics and source-backed result. An unsupported input must be rejected or explicitly reported unapplied, not silently ignored | Existing month filter delivered; extras pending evidence |
| Zoho v3 `search`, `course`, `sync`, `export` | `zoho-api-v3` **not deployed** in the 13 Nov S2-CF repo check; draft #1085 stale | Reuse source-backed v3 intake and deadline semantics in Zoho v3 alongside current Website v3, not by replaying an old website v3 dispatcher. Independently test each Zoho v3 response and CSV export columns; preserve Zoho v2 unchanged | **Not live** |
| Admin UI | Existing `IntakeRunValidate.jsx`, `AutomationProgress.jsx`, `DataDelivery.jsx` and Course Catalogue entry points | Optional `Year`, `Intake month`, `Exact start date`, `Application deadline`, `Start-date reason`, `Deadline reason` columns plus provider/country/course/campus/year/status/Present-Missing-Held-Not applicable filters. Include source/year, local timezone where given, next retry, previous/current canonical and Website/Zoho v3 verification | **Required acceptance, do not claim UI implemented** |

### Canonical database grain, provenance and lifecycle

- Trace already present `catalogue.course_intakes`, `pipeline.course_intake_dates`, approved academic calendars, course pages, `pipeline.important_dates` and official stored evidence. Verify real table/column types, readers/writers and provider-vs-course identity before any migration; create no parallel intake catalogue.
- The effective grain for a verified value is **exact course + qualifying provider + applicable campus/offering/variant + study period/intake year + audience and source edition when relevant**, not a generic provider/year month. Keep distinct school calendars, research rolling starts, intake months, application deadlines and source validity periods; never infer one from another.
- For each candidate date retain evidence URL/artefact ID, captured hash, official wording, issuer, edition or year, observed/verified time, stated timezone where applicable, source-to-course association, decision reason, reviewer/machine actor, prior value, supersession, next recovery and consumer publication eligibility. Null/unknown are not false dates.
- Prefer additive metadata on existing verified structures where needed and consistent with `pipeline.important_dates` rather than speculative new tables. Avoid duplicating year and source references in multiple conflicting rows. Preserve audit, manual locks, withdrawal and current G1–G4 rules.
- Reuse the existing `intake-dates-apply`, course/selected-provider Run & Validate and scheduler. A technical time-out or incomplete read should be divided into bounded resumable work, idempotently; green cron with zero data retained is not acceptance. Never count F-AER academic admissions as F-INT dates.
- Validate displayed month/year, exact date, published deadline, rolling and null reasons against trusted course/course-calendar evidence. Before publishing exact dates verify that the specific course is offered in that intake at the relevant campus or programme route; historical calendars do not prove present offerings.

### Per-field UI and consumer acceptance

For each relevant request show **eligible denominator → source available → read/validated → admitted active → Website v3 → Zoho v3 → verified HTTP/sync**, with per-24h/7d retained gains, corrections/withdrawals, missing/held reasons and next action. Existing Data Delivery and Intake Run & Validate are the primary operator journey; optional columns must not impose a large default grid, and filters must be server-side with bounded latency. An operator must be able to select Massey or Canterbury, drill down to the exact course/intake and see why its exact date or deadline is absent.

Acceptance is **source-backed new retained intake values and independently confirmed consumer parity**, not PR count, application of a new setting, successful AER admission or speculative filling of month-only rows. API v3 additions remain pre-go-live until developer integration; do not declare Wix/Zoho live usage without actual verified requests and communications.

## S2-Scholarship — Scholarship fields, website/Zoho v3 and Admin operator coverage (13 November 2026)

**Owner:** S2-Scholarship (F-SCH), under Operating Model v1.19. Canonical developer request mapping: [S2-Scholarship in the consumer register](../WEBSITE-DEVELOPER-REQUIREMENTS.md#s2-scholarship--scholarship-developer-fields-v3-and-admin-ui-delivery-13-november-2026) and dated REQ-01–83 reference. S2-CF/Integration Controller owns shared Website v3/Zoho v3 wrappers; no concurrent edits to the same API functions. This is design and acceptance, **not** a claim that Zoho v3 or missing Admin columns exist.

### Existing deployed v3 versus remaining requirements

| Field group / request IDs | Website v3 status and canonical data | Required S2-Scholarship work and Zoho v3 | UI acceptance in existing components |
|---|---|---|---|
| Award identity, descriptions, sponsorship/programme/code — REQ-01, -41 | Website v3 scholarship fields `description`, `award_type`, `sponsor`, `programme`, `award_code` in deployed PR #1098; published description reported 822/1,202 | Complete verified source-grounded fields, exact award owner and identity; Zoho v3 parity after its actual contract is deployed | Optional award type, description present/missing, official source and provider filters |
| Award benefits, value, tiers, duration — REQ-03/-04/-08/-29/-64/-71 | Website v3 `benefits[]`, `award_duration`, `academic_year` in #1098; benefit detail reported 1,015/1,202, duration 418/1,202 | Verify mixed fees/cash/allowances and period, tiers, amount/currency/basis; protect unknown value. Resolve 77 long-page reads and contradictory notes; Zoho v3 outputs where contract requires them | Benefit presence/type, monetary or unspecified, conflicting note, duration and missing field |
| Application, deadlines, rolling, renewals — REQ-02/-14/-15/-16/-72/-78 | Website v3 `application {method,url,rolling}` in #1098; reports 878/1,202 with method | Verify application source, automatic/nomination flags, round-specific dates, expiry/timezone, renewal and status, then Zoho v3 parity | Application method, Open/Closed/Upcoming/Unknown and deadline anomaly filters |
| Nationality, eligibility, study mode/stage — REQ-05/-06/-09/-10/-11/-44, R20/R24 | Website v3 `nationality_eligibility_status` in #1088 and `excluded_nationality_codes[]`, `nationality_regions[]` in #1098; named nationalities 144/1,202 reported | Distinguish international status from nationality, country region, exclusion, domestic-only, under-review and unknown; source-prove restrictions; reconcile current API filter and Zoho behaviour, no guesswork | Country/region, student type, eligibility status and missing-verified-evidence facets |
| Study area, academic qualifications and tests — REQ-07/-17/-18/-19/-20 | Existing criteria partially present; study area and scholarship-specific qualification/English sources incomplete | Define validated applicant filter fields with qualification name/system, grade/scale, waiver/alternative and audience, **not** generic course English as automatic scholarship rule. Coordinate protected Z8/D-2 decisions and Zoho v3 | Level/area/study load, merit scale, qualification and evidence coverage; unknown vs no requirement |
| Linked courses, provider page source — REQ-12/-30/-46/-73; R29/R31 | Website v3 R29 paged detail and R31 source URL/date already deployed; data scope incomplete | Show exact confirmed course links vs derived candidate associations, source and total counts. Zoho v3 search/detail/sync must preserve stable IDs and explain filter/match semantics | Association verified/derived/held, linked course count, source provenance, stale source and pagination |
| Zoho search scholarship summaries — REQ-31 / Z1 | Zoho v3 not verified deployed as of latest repo check | S2-CF/Zoho v3 owner builds search summary using only admitted/visible scholarship data; coordinate F-SCH fields and cross-consumer tests | Existing Data Delivery consumer parity/drill-down; never claim Zoho served when only v3 design exists |
| Receiving sponsorship flag — REQ-13/Z9 | Meaning/data not held | Await developer clarification; do not infer a boolean from scholarship sponsor or scholarship presence | Not held / requires definition, no invented switch |

### Long-page recovery, quality and readmission contract

**Reported 13 Nov checkpoint:** 1,655 active scholarships / 1,578 detail read / 77 unresolved; among 77, 50 token cutoffs and 44 no-answer events **overlap**. Source-grounded completion counts for the **1,202 published denominator**: description 822, application method 878, duration 418, named nationality 144, award type 952, benefits 1,015. These are Claude-reported, not independently refreshed production results. Current eligibility reader first live cycle: 9 domestic, 6 refused, zero new admissions. `sch_elig.readmit_on` remains off in the report; no published gain from the shadow restoration.

**Architecture and DB:** reuse existing `scholarship.scholarships`, approved detail/benefit/application/criteria source structures, `pipeline.scholarship_ai_extractions`, verified evidence hashes, source editions, `pipeline.scholarship_admission_log`, governed withdrawal and claim/provenance data. Verify the actual existing field and schema names from the live release and lineage before migrating. Split long stored pages into bounded, correctly scoped award and linked-terms sections; AI extraction captures multiple fields at once, records prompt/model/evidence version and returns material claims linked to exact source spans. Merge by stable provider + named award + round/edition, not text similarity alone. Reuse settled paid answers and no duplicate admission on retries. Long-page recovery is an existing F-SCH engineering fix, not a new pilot or another alternate scholarship engine.

**`sch_elig.readmit_on`** must be an auditable release/setting action only after check of actual historical withdrawal actor/reason, exact current official single-award page and unambiguous proof, manual locks/rejections, source/edition, course links, same-ID restore, unpublished status and ability to withdraw again if a later official source contradicts it. Do not revive multi-award listings or generic how-to-apply pages. A tested possible restoration (Sydney Bowel Cancer, 17 derived/linked courses) is not automatically published, and must not be counted as consumer-visible. Consult any true protected decision before wider activation.

**Admin UI acceptance:** verify deployed Scholarships Catalogue, Scholarship Detail, Provider and Data Delivery route/role/queries; add optional column/filter facets for completeness per developer field (present/missing/held/unknown/not applicable), country/sponsor/award type, eligible nationality, application method and status, benefit type/amount/duration, verified/derived course links, source/verification date and technical recovery reason. Show per-field history, next action, last run, actual credits/spend, canonical → Website v3 → Zoho v3 (unknown if unverified), never a large permanently visible grid or a second dashboard. Use server-side pagination and measured UI performance.

**Consumer acceptance:** v2 remains unchanged; v3 uses the current deployed Website v3, not the superseded #1085 dispatcher/gate. New fields are additive and contract-tested before pre-go-live integration; the actual developer switching/communications and later freeze are controlled separately. Record API list/detail/sync and pagination including page 2+; test authenticated HTTP and Zoho independently once available. A field is **not delivered** solely because its JSON key exists.

