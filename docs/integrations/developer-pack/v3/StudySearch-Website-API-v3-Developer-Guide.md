---
title: "StudySearch Website API v3 — Developer Guide"
subtitle: "website-api-v3 · Version 3 · Issue 1 · 20 November 2026 · Pilot (ready for integration)"
---

| | |
|---|---|
| **For** | The developers of the StudySearch website (Wix): Course Finder, University Finder, Scholarship Finder and the destination pages |
| **API** | One HTTPS address for Website API v3, ten actions |
| **Environment** | Pilot (live). Production uses the same endpoint address with a separate key, issued at go-live |
| **Your key** | Your existing Website API v2 key works at the v3 address. It is never written in this guide or the files that come with it |
| **Files with this guide** | `StudySearch-Website-API-v3.openapi.json` (OpenAPI 3.1), `StudySearch-Website-API-v3.postman_collection.json` (Postman; set the variable `apiKey`) and `StudySearch-Website-API-v3-Field-Dictionary.csv` (every field v3 returns, with its type, whether it can be null and what it means) |

# 1. What v3 is

Website API v3 is **Website API v2 plus additions**, at its own address. Every v2 action, filter, field, error and page shape works the same way in v3. Nothing is renamed or removed. v3 adds:

- one new action, `destination` (city, study-rule and careers data for the destination pages);
- new fields on courses, providers and scholarships (section 7.11 lists every one);
- a field dictionary covering all 910 fields v3 returns (the CSV file with this guide).

**Website API v2 keeps running unchanged.** You can move one page or one sync job at a time. Nothing forces a switch date.

Four rules apply to every response, as in v2:

1. **Null means not held.** A value the platform does not hold is `null` or an empty list. Nothing is filled with a default, an estimate or a value from another record. Several v3 fields go further and say *why* a value is missing (`empty_reason_code`, `start_date_status`, `nationality_eligibility_status`).
2. **Only published data is returned.** A provider the platform has switched off is not returned, with its courses and scholarships.
3. **Additive only.** Until the website goes live on v3, fields, filters and actions may be added to v3 (never renamed or removed). From the date the website goes live on v3, v3 is frozen in the same way as v2. Ignore fields you do not use.
4. **Third-party material carries attribution.** Rankings, logos and every destination figure come with `attribution`. Show it with them.

# 2. Quick start

1. Keep your existing key in Wix Secrets Manager. Call the API from Wix backend code only, never from the browser.
2. Change the address to `website-api-v3` and read `api_version` (`"website-v3"`).
3. Call `reference` and keep the vocabularies (section 7.1).
4. Run a full load with `sync` (section 6) into your Wix collections (section 9). Store `next_cursor` after each page.
5. Schedule a delta: every 5 to 15 minutes, send the stored cursor to `sync` and apply what comes back.
6. For Course Finder search, call `search` live from your backend with a 15-minute response cache (section 5).
7. For destination pages, call `destination` daily and cache the reply (section 7.10).
8. Run the acceptance tests in section 12 and send us any failure with its `request_id`.

# 3. Endpoint and key

```
POST https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/website-api-v3
Content-Type: application/json
Authorization: Bearer <your key>
```

- Every request body includes an `action`. There is no `contract` field: the address is the version.
- The key can also be sent as the header `x-cf-token`. Keep it in backend-only configuration. Never put it in browser code, page source, CMS records, repositories, screenshots, tickets or ordinary logs.
- Each key has one limit across v2 and v3 together: **300 requests a minute, all actions together**. Over the limit you get HTTP 429 with a `Retry-After` header.
- If a key is exposed, tell us: we disable it and issue a new one (a key cannot be recovered, only replaced).

**Moving from v2.** Change the address from `website-api-v2` to `website-api-v3` and read `api_version: "website-v3"`. Requests and v2 fields are identical. Run one full `sync` load at the v3 address so your copy carries the v3 fields, then keep that cursor (section 6).

# 4. Requests and responses

**Request**

```json
{
  "action": "search",
  "filters": { "country_codes": ["AU"] },
  "page": 1,
  "page_size": 20,
  "sort": "relevance"
}
```

- `page` starts at 1. For the list actions `page_size` is 1–50 (default 20); `sync` pages are covered in section 6. `page` and `page_size` must be whole numbers; `filters` must be an object.
- Send `Accept-Encoding: gzip`. Replies are then compressed to about a ninth of their size.
- Every response carries `api_version: "website-v3"` and a `request_id`. Quote the `request_id` when you report a problem.
- An error reply is `{ api_version, error: { code, message, detail }, request_id }`; `detail` says what was wrong where it can. An error never carries a database message.
- List actions return `{ total, page, page_size, items, filters_not_applied }`. A filter key the API does not recognise is listed in `filters_not_applied`; it is never silently ignored.
- Detail actions return `{ item }`.

**Errors**

| HTTP | Code | Meaning |
|---|---|---|
| 400 | `INVALID_INPUT` | A malformed filter, page, page size, sort, cursor, `edu_country` or missing identifier |
| 400 | `INVALID_JSON` | The body is not a JSON object |
| 400 | `INVALID_ACTION` | The action is not one of the ten |
| 401 | `AUTHENTICATION_REQUIRED` | Missing or invalid key |
| 404 | `NOT_FOUND` | The course, provider or scholarship identifier was not found |
| 429 | `RATE_LIMITED` | Over 300 a minute for your key; wait for `Retry-After` |
| 503 | `SERVICE_UNAVAILABLE` | A bounded service failure; retry later |

On 429 or 5xx keep serving your last good copy and retry on the next run.

# 5. Recommended integration

| Tool | How | Why |
|---|---|---|
| University Finder, Scholarship Finder | Wix collections filled by `sync` | Fast pages with no API call during a visit |
| Course Finder | `search` called live from your backend, each response cached 15 minutes; course cards and detail from your `sync` copy | Search uses the platform's relevance and filters; the cache absorbs repeat searches |
| Course and provider pages with entry requirements | `course` and `provider` with `edu_country`, cached by item and country for a day | `sync` does not carry entry requirements |
| Destination pages | `destination` per country, cached for a day | Figures change with dataset editions, not by the minute |
| Filter lists | `reference`, refreshed daily | Vocabularies with counts |

**Schedule**

| Job | When |
|---|---|
| Full load with `sync` | Once at set-up at the v3 address, and again only if your copy is lost |
| Delta with `sync` | Every 5 to 15 minutes |
| `reference`, `destination` | Daily |

**When a call or run fails:** keep the last good copy in service, record the error with its `request_id` and the time, do not save a new cursor, and retry on the next run.

**Response times** (measured on Pilot, 20 November 2026, database time): the example search in 7.2 about 0.9 s at v3 (0.4 s at v2); course detail with `edu_country` about 1.2 s; provider detail under 1 s; a scholarship list about 0.4 s; `destination` under 0.1 s; a `sync` page about 0.2–1 s. Add 0.1–0.3 s for the network. Cache `search` as advised; v3 search is slower than v2 because each item carries the extra fields.

# 6. Sync: full load, then only what changed

`sync` works exactly as in v2.

```json
{
  "action": "sync",
  "cursor": "<next_cursor from your last reply; leave out for a full load>",
  "page_size": 600
}
```

1. **Full load.** Call `sync` with no cursor. Keep calling with `next_cursor` while `has_more` is true. The last page has `full_load_complete: true`.
2. **Changes.** From then on, send the stored cursor. You get only what is new, changed or removed since, and a new `next_cursor`.
3. **Save the cursor only after the page is written to Wix.** If a write fails, send the same cursor again: the same items come back, and upserting by id makes the replay safe.

| Request field | Meaning |
|---|---|
| `cursor` | The `next_cursor` from your last reply. Leave it out (or `null`) for a full load |
| `full_load` | `true` starts a full load again |
| `entities` | Optional, on a full load only: any of `reference`, `provider`, `logo`, `rankings`, `scholarship`, `course` (all six by default) |
| `page_size` | 1–600 (default 600). A page holds at most about 1.7 MB of JSON, so large items come fewer to a page |

| Reply field | Meaning |
|---|---|
| `items[]` | `{ entity, id, seq, change, item }`. `change` is `upsert` (store `item` by `id`) or `remove` (delete the record with that `id`) |
| `has_more`, `next_cursor` | More items follow: call again with `next_cursor` (opaque text; store it as it is) |
| `mode`, `full_load_complete` | `full` or `delta`; `true` on the last page of a full load |
| `checked_through`, `as_of` | When the platform last finished checking every item; time of the reply |

| Entity | `id` | `item` | Your collection |
|---|---|---|---|
| `course` | course_id | The search item (7.2), with the v3 course fields except `description_excerpt` | CF_Courses |
| `provider` | provider_id | The provider detail (7.4), with the v3 provider fields | CF_Providers |
| `logo` | provider_id | `{ provider_id, logo }` (7.7) | Logo on CF_Providers, file in Wix Media |
| `rankings` | provider_id | `{ provider_id, rankings[] }` (7.6) | CF_Rankings |
| `scholarship` | scholarship_id | The scholarship detail (7.5), with the v3 scholarship fields | CF_Scholarships |
| `reference` | `reference` | The reference vocabularies (7.1) | CF_Reference |

A full load is about 41,000 items in about 86 calls at the default page size, about 1 to 2 minutes one page at a time, about 15 MB compressed. Logos: each link is valid for 365 days (`url_expires_at`); copy the file into Wix Media and serve your copy. Destination data is not in `sync`: use the `destination` action.

# 7. Actions and data

| Action | Parameters | Returns |
|---|---|---|
| `reference` | none | Vocabularies with counts (7.1) |
| `search` | `filters`, `page`, `page_size`, `sort` | Course list (7.2) |
| `course` | `course_id` or `course_code`; optional `edu_country` | `{ item }` course detail (7.3) |
| `providers` | `filters`, `page`, `page_size`, `sort` | Provider list (7.4) |
| `provider` | `provider_id`; optional `edu_country` | `{ item }` provider detail (7.4) |
| `rankings` | `filters`, `page`, `page_size` | Ranking entries (7.6) |
| `scholarships` | `filters`, `page`, `page_size` | Scholarship list (7.5) |
| `scholarship` | `scholarship_id`; optional `courses_page`, `courses_page_size` | `{ item }` scholarship detail with linked courses (7.5) |
| `sync` | `cursor`, `full_load`, `entities`, `page_size` | Pages of items to store (section 6) |
| `destination` **(new)** | `filters`, `page`, `page_size` | Localities, study rules and career outcomes (7.10) |

## 7.1 reference

```json
{ "action": "reference" }
```

As in v2. Per country (AU, NZ, CA): study levels, study areas, subdivisions, cities with metro areas, intake months and English tests (including `OET` and `CELPIP`), each with course counts. Also: regional categories, institution types, university groups, ranking systems with editions, scholarship amount types, study stages and student types, and the sort values. `generated_at` says when the counts were built (every 15 minutes).

The closed value lists of the new v3 fields are fixed and listed in section 7.11 and the field dictionary. They are not returned by `reference` in this issue.

## 7.2 search (Course Finder)

```json
{
  "action": "search",
  "filters": {
    "country_codes": ["AU"], "keyword": "business", "cities": ["Melbourne"],
    "study_level_codes": ["masters_coursework"], "intake_months": [2],
    "english_test_codes": ["IELTS"], "english_score_max": 6.5, "tuition_annual_max": 45000
  },
  "page": 1, "page_size": 6
}
```

This returned 36 courses on 20 November 2026, the same at v2 and v3. All filters are optional and combine with AND.

| Filter | Type | Notes |
|---|---|---|
| `keyword` | text | Title, provider name or course code |
| `country_codes` | list | `AU`, `NZ`, `CA` |
| `study_level_codes`, `study_area_codes` | list | From `reference` |
| `subdivision_codes` | list | e.g. `AU-VIC`, `NZ-AUK`, `CA-ON` |
| `cities`, `postcodes` | list | A campus city or metro area, any letter case |
| `regional_categories` | list of numbers | Australian Home Affairs category 1, 2 or 3 |
| `provider_ids`, `university_groups` | list | Groups: `go8`, `atn`, `iru`, `run` |
| `institution_types` | list | `university`, `university_college`, `higher_education_institute`, `tafe_polytechnic`, `private_vet`, `school`, `wananga`, `other` |
| `delivery_modes` | list | `on_campus`, `online`, `blended`, `on_campus_and_online` |
| `intake_months` | list of numbers | 1–12 |
| `english_test_codes` + `english_score_max` | list + number | One test code with a score, on that test's own scale: `IELTS`, `PTE`, `TOEFL_IBT`, `CAE`, `DET`, `OET`, `CELPIP` |
| `tuition_annual_min`, `tuition_annual_max` | number | Annual tuition in the course's own currency; use with `country_codes` |
| `has_intake`, `has_english`, `has_official_url`, `has_tuition`, `has_scholarship` | true/false | Only courses holding that value |
| `has_academic_entry` **(new)** | true/false | Only courses with academic entry requirements held. Add `edu_country` inside `filters` to require a requirement for that country of prior education |
| `changed_since` | timestamp | Courses changed since then |

**Sort:** `relevance` (default with a keyword), `title_asc` (default otherwise), `tuition_annual_asc`, `tuition_annual_desc`, `duration_asc`, `updated_asc`. Ties are broken by course_id, so paging is stable.

**Course fields (search items and `sync` course items).** Every v2 field, plus the v3 fields marked **new**.

| Field | Notes |
|---|---|
| `course_id`, `title` | `course_id` is the key to store |
| `display_code`, `display_code_kind`, `display_code_label` | **The code to show visitors.** It never changes. `course_code` is the source system's code: do not show it |
| `provider { provider_id, name, legal_name, institution_type, university_groups[], ranking_summary, logo, accreditations[], accreditation_crown }` | As in 7.4; `accreditations[]` and `accreditation_crown` are **new** |
| `campuses[] { city, postcode, subdivision_code, metro_area, regional_category, regional_category_name, is_primary, primary_basis, locality }` | The searched city first. **New:** `primary_basis` and `locality` (7.11) |
| `study_level { code, name }`, `study_area { code, name }`, `duration_months`, `delivery_modes[]` | As in v2 |
| `study_load`, `study_load_basis` **(new)** | `full_time`, `part_time` or `both`; null when not held. `study_load_basis` says where it comes from (7.11) |
| `empty_reason_code` **(new)** | Why the campus or study mode is empty for this course; null when nothing needs explaining (7.11) |
| `description_excerpt` **(new, search only)** | The start of the course description, cut at a whole word, for result cards; null when no description is held |
| `tuition { amount, currency, basis, basis_label, annual_amount, annual_is_derived, year, source }` | See 7.8 |
| `intakes[] { label, month, year, start_date, start_date_status, application_deadline }` | **New:** `start_date_status` says why an exact start date is or is not given (7.11) |
| `entry_requirements { summary, basis }`, `english_requirements[] { test_code, test_name, min_overall_score, min_band_score, source }` | English by test |
| `official_url`, `scholarship_count`, `subdivision_codes[]`, `publication_status`, `freshness` | As in v2 |

## 7.3 course (detail)

```json
{ "action": "course", "course_code": "0100714", "edu_country": "IN" }
```

`course_code` accepts a source code, a StudySearch display code (e.g. `UNBC-BA-019`) or a `course_id`. The detail has every search field (except `description_excerpt`) plus: `description`, `tuition_history[]`, `scholarships[]`, `english_note`, `other_matches`, `provider_outcomes_state` with `provider_outcomes[]`, and `entry` (7.9). v3 adds:

| Field | Notes |
|---|---|
| `recognition[]` **(new)** | Official registrations of the course: `{ scheme, code, status, authority, source_url, evidence_date, checked_on }`. Australia: `CRICOS`, status `registered`. `[]` when none is held; never read it as "not recognised" |
| `field_of_study_codes[]` **(new)** | Field-of-study codes from the national register, best first: `{ scheme, level, code, name, rank, source_url, evidence_date }`. Australia: `ASCED` narrow fields. `[]` when none is held; never inferred or crosswalked |

```json
"recognition": [ { "scheme": "CRICOS", "code": "0100714", "status": "registered",
  "authority": "Australian Government (CRICOS)", "source_url": "https://data.gov.au/data/dataset/cricos",
  "evidence_date": "2026-09-26", "checked_on": "2026-11-18" } ],
"field_of_study_codes": [ { "scheme": "ASCED", "level": "narrow", "code": "0399",
  "name": "Other Engineering and Related Technologies", "rank": 1,
  "source_url": "https://data.gov.au/data/dataset/cricos", "evidence_date": "2026-10-01" } ]
```

## 7.4 providers and provider (University Finder)

```json
{ "action": "providers", "filters": { "country_codes": ["AU"], "university_groups": ["go8"] },
  "sort": "qs_rank_asc", "page": 1, "page_size": 6 }
{ "action": "provider", "provider_id": "provider:cricos:00122a", "edu_country": "IN" }
```

**Filters** and **sort** as in v2: `keyword`, `country_codes`, `subdivision_codes`, `cities`, `regional_categories`, `university_groups`, `institution_types`, `study_level_codes`, `study_area_codes`, `has_scholarship`, `ranked_in`, `qs_rank_max`, `the_rank_max`, `has_logo`, `provider_ids`; sort `name_asc`, `qs_rank_asc`, `the_rank_asc`, `course_count_desc`.

Every v2 provider field (`provider_id`, `name`, `legal_name`, `website`, `institution_type`, `campuses[]`, `course_count`, `study_levels_offered[]`, `study_areas_offered[]`, `university_groups[]`, `scholarship_count`, `ranking_summary`, `logo`; in detail `description`, `rankings[]`, `outcomes_state`, `outcomes[]`, `entry_matrix[]`), plus:

| Field | Notes |
|---|---|
| `campuses[]` **(changed in v3, detail)** | One item per campus, never merged by city: the v2 keys plus `campus_id`, `campus_name`, `course_count`, `is_primary`, `primary_basis` and `locality`. For example Monash returns 9 named campuses |
| `campuses[].is_primary`, `campuses[].primary_basis` **(new)** | The provider's main campus (at most one) and why (7.11) |
| `campuses[].locality` **(new)** | The city or urban area the campus postcode belongs to, as used by `destination`: `{ locality_id, name, geography_type, geography_code, boundary_vintage, match_share }`; null until matched |
| `accreditations[]` **(new)** | Business school accreditations held now: `{ body_code, accredited_unit_name, accredited_since, expires_at, source_url, verified_at }`. `body_code` is `AACSB`, `EQUIS` or `AMBA`. An expired one is not returned. `[]` when none is held |
| `accreditation_crown` **(new)** | `triple_crown` when AACSB, EQUIS and AMBA are all held, `double_crown` for any two, null otherwise. Use it instead of a hand-kept list |
| `scholarships_page_url`, `scholarships_last_reviewed_at` **(new)** | The provider's scholarships listing page we read, and when we last reviewed it |
| `restriction_mode`, `restriction_markets` **(new)** | Study Square's market restriction for this provider: `include` (Study Square represents it only for students from the listed markets), `exclude` (for every market except those listed) or `none` (no restriction). `restriction_markets` lists ISO 3166-1 alpha-2 country codes, empty when the mode is `none`. Both are null when no agreement is recorded or it has ended; null means not held, not "no restriction" |
| `entry_matrix[]` | As in v2, plus `quote` and `source_url` on each row **(new)** |

## 7.5 scholarships and scholarship (Scholarship Finder)

```json
{ "action": "scholarships", "filters": { "student_types": ["international"] }, "page": 1, "page_size": 10 }
{ "action": "scholarship", "scholarship_id": "<scholarship_id>", "courses_page": 2, "courses_page_size": 200 }
```

Filters as in v2. Every v2 field, plus (list and detail):

| Field | Notes |
|---|---|
| `description` | Now on list items too |
| `award_type` | `scholarship`, `bursary`, `tuition_waiver`, `fee_discount`, `research_funding`, `grant`, `stipend`, `other` or null |
| `sponsor`, `programme`, `award_code` | As the provider names them; null when not stated |
| `benefits[]` | One item per benefit: `{ type, amount, currency, percentage, is_maximum }` |
| `application` | `{ method, url, rolling }`. `method`: `separate_application`, `automatic_consideration`, `nomination` or null |
| `award_duration` | `{ value, unit }` or null |
| `academic_year` | The award round as stated; null when not stated |
| `nationality_eligibility_status` | `restricted`, `unrestricted`, `under_review` or `unknown`. An empty nationality list is never `unrestricted` |
| `excluded_nationality_codes[]`, `nationality_regions[]` | Country codes excluded; regions exactly as the source names them (never expanded) |
| **Detail only:** `linked_courses_total`, `linked_courses_page`, `linked_courses_page_size` | Linked-course paging. Send `courses_page` (from 1) and `courses_page_size` (1–200). Without them you get the first 200, as in v2 |

## 7.6 rankings, 7.7 logos, 7.8 tuition rules

Unchanged from v2. Rankings: QS World University Rankings 2021–2027 and Times Higher Education World University Rankings 2016–2026, as published, never re-ranked; show `attribution`. Logos: one per provider, a signed link valid 365 days; copy to Wix Media. Tuition: `basis` always stated; `source` is `provider_current` or `regulatory_registered`; a whole-course total is never shown as per year; no currency conversion.

## 7.9 Academic entry requirements

Unchanged from v2 (issue 7), with two additions: `entry_matrix[]` rows carry the provider's own words (`quote`) and the page (`source_url`), and `search` takes `has_academic_entry`. `course` and `provider` take an optional `edu_country` (two-letter ISO code of the student's country of prior education); anything else is refused with `400 INVALID_INPUT`.

The `entry.resolution` steps, outcomes (`minimum_published`, `case_by_case`, `contact_provider`), `scale_stated` and `min_scores[]` rules, and the wording to show, are exactly those of the v2 guide section 7.9. In short:

- **`minimum_published`:** show each qualification with its minimum, and `as_at`.
- **`case_by_case`**, or a row with no minimum on a scale: "This qualification is considered case by case".
- **`scale_stated` false:** "Published requirement: [min_grade]. The provider does not state a grading scale on this page; check the source or contact the provider."
- **`contact_provider`:** "Requirements for your qualification aren't published — contact the provider", with `contact`.

The API looks requirements up. It never decides whether a student is eligible. Coverage is still low (section 8): keep "contact the provider" as the normal path.

## 7.10 destination (new)

```json
{ "action": "destination", "filters": { "country_code": "AU", "section": "localities" }, "page": 1, "page_size": 20 }
```

**Filters** (all optional): `country_code`; `section` (`localities`, `study_rules` or `career_outcomes`; all three when left out); `postcode`; `locality_id`; `rule_category`. Only approved data is returned.

**Reply:** `{ localities[], study_rules[], career_outcomes[], totals { localities, study_rules, career_outcomes }, page, page_size, filters }`.

| List | Fields |
|---|---|
| `localities[]` | `locality_id`, `name`, `country_code`, `geography_type`, `geography_code`, `boundary_vintage`, `dataset_edition`, `attribution`, `metrics[] { key, category, value, unit, currency_code, reference_period, dataset_edition, source_url, attribution }` |
| `study_rules[]` | `rule_id`, `country_code`, `state_code`, `rule_category`, `title`, `summary`, `visa`, `numeric_threshold`, `currency_code`, `applicant_scope`, `effective_from`, `effective_to`, `edition`, `quote_on_page`, `source_url`, `evidence_date`, `attribution`, `applicability[] { entity_type, entity_id, entity_code, status, evidence_url, quote_on_page, verified_at }` |
| `career_outcomes[]` | `outcome_id`, `country_code`, `state_code`, `locality_id`, `geography_level`, `occupation_scheme`, `occupation_code`, `occupation_title`, `employment_count`, `employment_rate_pct`, `median_earnings`, `median_annual_earnings`, `earnings_period`, `currency_code`, `demand_rating`, `skill_shortage_status`, `reference_period`, `dataset_edition`, `source_url`, `attribution` |

**Joining:** a campus's `locality.locality_id` (7.4) matches `localities[].locality_id` and `career_outcomes[].locality_id`. Join on codes, never on names.

**Climate:** metrics with `category` `climate` are long-term averages (for example 30-year Bureau of Meteorology normals), not forecasts. Show `reference_period` and `attribution` with them.

**Held on 20 November 2026:** Australia 102 localities (population and climate), 6 study rules and 1,577 career outcomes. Other countries: empty lists until their data is approved.

## 7.11 What v3 adds: values and meanings

| Field | Values | Show |
|---|---|---|
| `study_load` | `full_time`, `part_time`, `both`, null | "Full time", "Part time", "Full or part time"; nothing when null |
| `study_load_basis` | `provider_page` (read from the course page), `register` (stated by a register), `register_rule` (full time because international students on a student visa must study full time) | Optional source note |
| `empty_reason_code` | `not_published_by_provider`, `online_only_no_campus`, `not_listed_on_register`, `pending_extraction`, `source_unavailable`, null | Use it to explain or hide the empty campus or study-mode block, rather than showing a blank |
| `campuses[].primary_basis` | `cricos_head_office` (the registered head office matches this campus), `highest_course_count` (no single head-office match; the campus with most of the provider's courses), null | Label the main campus |
| `intakes[].start_date_status` | `known`, `month_only`, `no_official_calendar`, `not_on_course_page`, `course_page_not_verified`, `next_year_calendar_pending`, `not_yet_read`, `own_calendar`, `conflicting_evidence`, `held_for_review`, `rolling` | Show `start_date` only when `known`; otherwise the month, with "exact date not published" or "check with the provider" |
| `nationality_eligibility_status` | `restricted`, `unrestricted`, `under_review`, `unknown` | Filter only on `restricted` and `unrestricted`; treat the others as "check eligibility with the provider" |
| `accreditation_crown` | `triple_crown`, `double_crown`, null | "Triple Crown", "Double Crown"; for one body, list `accreditations[].body_code` |
| `award_type` | as in 7.5 | |
| `application.method` | as in 7.5 | |

Fields **not in v3** (not held, no key returned): admission tests (UCAT, GAMSAT, GMAT, GRE), teaching language, post-study work by course, application routes, a dark logo and brand colour. Keep these page sections hidden or use your own static text.

# 8. What is held now, and the gaps

Measured on Pilot on 20 November 2026 (Melbourne date). The counts are courses and providers in the catalogue; the API returns the published ones (search returns 24,013 Australian, 6,514 New Zealand and 3,814 Canadian courses; 1,625 providers; 1,070 scholarships). Coverage grows daily; the numbers below are a snapshot.

**Courses**

| Course field | Australia (25,703) | New Zealand (6,514) | Canada (3,814) |
|---|---|---|---|
| Official course page | 18,268 (71%) | 3,066 (47%) | 2,737 (72%) |
| English requirements | 16,456 (64%) | 2,393 (37%) | 2,017 (53%) |
| Intake months | 9,566 (37%) | 2,221 (34%) | 1,706 (45%) |
| Exact application deadline | 56 | 33 | 214 |
| Provider's current tuition | 8,576 (33%) | 1,496 (23%) | 732 (19%) |
| Registered tuition (CRICOS, Australia only) | 25,522 (99%) | — | — |
| Description | 12,475 (49%) | 1,795 (28%) | 1,521 (40%) |
| Duration | 25,703 (100%) | 2,546 (39%) | 1,574 (41%) |
| Delivery mode | 16,693 (65%) | 2,741 (42%) | 2,360 (62%) |
| At least one campus | 25,672 (100%) | 2,692 (41%) | 2,290 (60%) |
| **Study load (new)** | 25,637 (100%) | 2,340 (36%) | 1,453 (38%) |
| **Reason for an empty campus (new)** | 31 of 31 | 3,817 of 3,822 | 1,524 of 1,524 |
| Course-level academic entry | 919 (4%) | 481 (7%) | 0 |
| **CRICOS recognition and ASCED codes (new)** | about 23,100 | — | — |

**Providers**

| Provider field | Australia (1,544) | New Zealand (290) | Canada (52) |
|---|---|---|---|
| **Main campus (new)** | 1,464 | 105 of 107 with a campus | 45 of 45 |
| **Business accreditation (new)** | 25 | 7 | 8 |
| Academic entry table by country | 18 | 8 | 0 |
| Logo | 1,280 | 245 | 45 |
| Description | 947 | 223 | 41 |

**Scholarships** (published): Australia 826, New Zealand 113, Canada 131.

**Main gaps, and what happens next**

| Gap | Size today | Next |
|---|---|---|
| Course pages not yet found | 9,348 courses, at 447 providers whose website is known (AU 310, NZ 133, CA 4) | Being found and read continuously; fills official page, English, intakes, fees and description together |
| Providers with no website on record | 71 Australian providers (326 courses) | Websites being sourced; their courses stay without page data until then |
| Read, awaiting checks | About 1,950 official pages, 2,200 English, 2,800 intakes, 3,600 fees and 2,500 descriptions | Admitted as they pass the platform's checks |
| Not published by the provider | For example 5,400 English, 9,600 intakes and 11,600 fees | The provider's page does not state it: show "check with the provider" |
| Academic entry | 1,400 courses and 26 providers' tables | A new entry reader is being prepared; most courses will show "contact the provider" for now |
| Waiting for a person's approval | About 1,950 items, mainly academic entry (1,065 courses, 84 provider tables), official links (267), descriptions (159), fees (145) and durations (102) | Returned as soon as approved |
| Destination data | Australia only; 3 of 7 Australian datasets still to be published | Other destinations follow country by country |

Until a value arrives, keep the page section hidden or use the "check with the provider" wording: never show a placeholder.

# 9. Your Wix collections (suggested)

| Collection | Key | Holds |
|---|---|---|
| CF_Courses | `course_id` | The course item (7.2). Show `display_code` |
| CF_Providers | `provider_id` | The provider detail (7.4), with the Wix Media id and `content_hash` of its logo |
| CF_Rankings | `provider_id` + `system_code` + `edition_year` | Ranking entries (7.6) |
| CF_Scholarships | `scholarship_id` | The scholarship detail (7.5) |
| CF_Reference | — | The `reference` reply |
| CF_Destination | `country_code` + `section` | The `destination` reply, refreshed daily |
| CF_SyncState | — | `next_cursor`, last full load, last delta, last `request_id`, counts and errors |

# 10. Support

Send: the action and request body (no key), the `request_id`, the HTTP status, the time (with time zone) and whether it affects live search, a scheduled sync or your cached pages. Never include the key.

# 11. Going live on v3

1. Run the acceptance tests in section 12 against v3 with your key.
2. Run a full `sync` load at the v3 address into new or cleared collections, then switch your delta job to the v3 cursor.
3. Switch page by page; v2 keeps answering meanwhile.
4. Tell us the date the live website reads v3. From that date v3 is frozen like v2 (additions only).
5. At Production go-live you receive a separate Production key; the address does not change.

# 12. Acceptance tests

Counts as measured on Pilot on 20 November 2026; they change as data grows.

| # | Test | Expected |
|---|---|---|
| 1 | Key | `reference` at `website-api-v3` returns 200 with `api_version: "website-v3"` |
| 2 | Wrong key | An invalid key returns 401 and no data |
| 3 | Same as v2 | The 7.2 search returns the same total at v2 and v3 (36) |
| 4 | Keyword | `keyword` nursing with `cities` Melbourne returns 120 courses, the same total on every page |
| 5 | Canada | `country_codes` CA returns 3,814 courses, each with a `display_code` |
| 6 | Display code | `course` with `course_code` UNBC-BA-019 returns `display_code_kind` `studysearch` |
| 7 | Study load | Every search item and course detail carries `study_load` and `study_load_basis` (a value or null) |
| 8 | Recognition | `course` 0100714 returns `recognition[]` with one CRICOS item and `field_of_study_codes[]` with ASCED 0399; a Canadian course returns `[]` for both |
| 9 | Main campus | `provider` provider:cricos:00008c returns 9 named campuses with `campus_id` and `course_count`, at most one `is_primary` true |
| 10 | Accreditation | `provider` provider:cricos:00008c returns `accreditation_crown` `triple_crown`; a provider without accreditations returns `accreditations: []` |
| 11 | University Finder | `providers` with `university_groups` go8 and sort `qs_rank_asc` returns 8 providers; `institution_types` university with AU returns 45 |
| 12 | Scholarships | `scholarships` with `student_types` international returns 1,049 records, each with `nationality_eligibility_status` |
| 13 | Linked-course paging | `scholarship` with `courses_page` 2 returns `linked_courses_page` 2 and the same `linked_courses_total` as page 1 |
| 14 | Rankings | `rankings` with QS, edition 2027, AU returns 38 entries, each with `attribution` |
| 15 | Entry, contact provider | `course` 0100714 with `edu_country` IN returns `entry.resolution.step` 5; your page shows "contact the provider" |
| 16 | Entry, provider table | `provider` provider:cricos:00122a returns 380 `entry_matrix` rows; with `edu_country` IN, 33 rows, each with `quote` and `source_url` |
| 17 | Entry filter | `search` with `has_academic_entry` true returns only courses with entry requirements held |
| 18 | Destination | `destination` with `country_code` AU returns `totals` of 102 localities, 6 study rules and 1,577 career outcomes; NZ returns zeros |
| 19 | Sync | A full load ends with `full_load_complete: true`; course items carry `study_load`; the last cursor sent again returns only changes |
| 20 | Errors | An unknown action returns 400 `INVALID_ACTION`; `edu_country` IND returns 400 `INVALID_INPUT`; a 429 is handled by waiting for `Retry-After` |
| 21 | Nulls | A value not held is null or empty, never a placeholder; an unknown field is ignored safely |
| 22 | Key safety | The key is absent from browser bundles, page source, CMS records and browser network requests |

# 13. Changes to this guide

Changes within Website API v3 are additive. A change to the API (a new field, filter, action or behaviour) reissues this guide with a new date and a line here.

| Date | Change |
|---|---|
| 20 November 2026 (issue 1) | First issue of Website API v3: Website API v2 plus the `destination` action; course `study_load`, `study_load_basis`, `empty_reason_code`, `description_excerpt` (search), `intakes[].start_date_status`, `recognition[]`, `field_of_study_codes[]`, `campuses[].primary_basis` and `campuses[].locality`; provider named `campuses[]` with `campus_id`, `campus_name`, `course_count`, `is_primary`, `accreditations[]`, `accreditation_crown`, `scholarships_page_url`, `scholarships_last_reviewed_at`; `entry_matrix[]` `quote` and `source_url`; search filter `has_academic_entry`; scholarship `description`, `award_type`, `sponsor`, `programme`, `award_code`, `benefits[]`, `application`, `award_duration`, `academic_year`, `nationality_eligibility_status`, `excluded_nationality_codes[]`, `nationality_regions[]` and linked-course paging; English tests `OET` and `CELPIP`. With the field dictionary (CSV), OpenAPI file and Postman collection |
| 24 November 2026 | Provider items: `restriction_mode` and `restriction_markets` (Study Square market restriction; null when not held) |
