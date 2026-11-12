# StudySearch API v3 – field definition

Version 0.2, 12 November 2026. Status: release 1 built (Pilot #1085). It is **not released**: both v3 URLs refuse every key until it is released.

> **Deployed state, 12 Nov 2026 22:10 AEDT (read this before section 1).** What is live is the WP-0 copy, not the release-1 design below:
> - **Live:** edge function `website-api-v3` (version 1, Pilot #1084) and the `public.website_v3_*` functions, which wrap the unchanged v2 functions. R28 `intakes[].start_date_status` (#1084, migration `20261113180000`). R23 provider `campuses[]` one item per campus with `campus_id`, `campus_name`, `course_count`, and R24 scholarship `nationality_eligibility_status` (Pilot #1088, merge `514cb3bd`, migration `20261113190000`; the applied statements equal the file, md5 `80d0fe37…`).
> - **Also live (12 Nov 2026 22:50 AEDT):** R29 scholarship linked-course paging (Pilot #1091, migration `20261113200000`); R31 provider `scholarships_page_url` and `scholarships_last_reviewed_at`, and O26 search `description_excerpt` (Pilot #1092, migration `20261113210000`). Note: the deployed O26 length is fixed at 240 characters by the build brief; #1085 made it a setting.
> - **Also live (12 Nov 2026 23:30 AEDT):** O20 `quote` and `source_url` on entry rows (Pilot #1093); O22 search filter `has_academic_entry` with optional `edu_country` (Pilot #1097); the scholarship detail fields `description`, `award_type`, `sponsor`, `programme`, `award_code`, `benefits[]`, `application {method, url, rolling}`, `award_duration`, `academic_year`, `excluded_nationality_codes[]`, `nationality_regions[]` (Pilot #1098, migration `20261113240000`; the v3 home of the v2 draft #1077); OET and CELPIP as English tests (Pilot #1099; data, in v2 and v3).
> - **Not live (draft Pilot #1085):** `zoho-api-v3`, the dispatchers `website_v3_call` / `zoho_v3_call`, schema `api_v3` and the release switch `api.v3_released` (no setting row on live).
> - **So, today:** `website-api-v3` has no release gate. It answers any valid website key. The website has not switched to it, so under Decision 277 v3 is still open (additions only) and not yet frozen.
> - **v2 unchanged:** `api.website_v2_provider_campuses` and `api.website_v2_scholarship_item` are at their 5 Nov definitions (md5 `57115d3b…`, `d1792cc7…`). Monash: v2 returns 8 merged campus items, v3 returns 9 named campuses with course counts.
> - **Decision for the Platform Admin:** whether v3 keeps the #1084 shape (no gate; go-live is the website switching) or takes #1085's gate and Zoho copy. Until that is decided, sections 1 and 6 below describe #1085, not what is deployed.

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

