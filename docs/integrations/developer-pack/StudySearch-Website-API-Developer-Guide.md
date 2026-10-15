---
title: "StudySearch Website API — Developer Guide"
subtitle: "Contract website-search-v2 · Version 2 · 15 October 2026 · Pilot"
---

| | |
|---|---|
| **For** | The developers of the StudySearch website (Wix): Course Finder, University Finder and Scholarship Finder |
| **API** | One HTTPS endpoint, contract `website-search-v2`, nine actions |
| **Environment** | Pilot (live). Production uses the same endpoint address with a separate key, issued at go-live |
| **Your key** | Sent to you separately by a secure channel. It is never written in this guide or the files that come with it |
| **Files with this guide** | `StudySearch-Website-API.openapi.json` (OpenAPI 3.1) and `StudySearch-Website-API.postman_collection.json` (Postman; set the variable `apiKey`) |

# 1. What the API gives you

The API is the only way the website reads StudySearch data. It returns courses, universities and colleges (providers), scholarships, rankings, logos and the vocabularies for your filters, for Australia, New Zealand and Canada.

Four rules apply to every response:

1. **Null means not held.** A value the platform does not hold is `null` or an empty list. Nothing is filled with a default, an estimate or a value from another record.
2. **Only published data is returned.** A provider the platform has switched off is not returned, with its courses and scholarships. Every record you receive reads `publication_status: "published"`.
3. **Additive only.** Fields, filters and actions are added, never renamed or removed, within this contract. Ignore fields you do not use. A breaking change would come as a new contract with its own guide.
4. **Third-party material carries attribution.** Rankings and logos come with `attribution` and `terms_status`. Both are approved for display (`terms_status: "approved"`). Show the attribution with them. If `terms_status` ever reads `management_decision_pending`, stop displaying that item.

# 2. Quick start

1. Store the key in Wix Secrets Manager. Call the API from Wix backend code only, never from the browser.
2. Call `reference` and keep the vocabularies (section 7.1).
3. Run a full load with `sync` (section 6) into your Wix collections (section 9). Store `next_cursor` after each page.
4. Schedule a delta: every hour, send the stored cursor to `sync` and apply what comes back.
5. For Course Finder search, call `search` live from your backend with a 15-minute response cache (section 5).
6. Run the acceptance tests in section 12 and send us any failure with its `request_id`.

# 3. Endpoint and key

```
POST https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/wix-course-api
Content-Type: application/json
Authorization: Bearer <your key>
```

- Every request body includes `"contract": "website-search-v2"` and an `action`.
- Keep the key in backend-only configuration. Never put it in browser code, page source, CMS records, repositories, screenshots, tickets or ordinary logs.
- Each key has its own limit: **60 requests a minute per action**. Over the limit you get HTTP 429 with a `Retry-After` header.
- Your key works with this contract only. If a key is exposed, tell us: we disable it and issue a new one (a key cannot be recovered, only replaced).

# 4. Requests and responses

**Request**

```json
{
  "contract": "website-search-v2",
  "action": "search",
  "filters": { "country_codes": ["AU"] },
  "page": 1,
  "page_size": 20,
  "sort": "relevance"
}
```

- `page` starts at 1. `page_size` is 1–50 (default 20).
- Every response carries `contract_version: "website-search-v2"` and a `request_id`. Quote the `request_id` when you report a problem.
- List actions return `{ total, page, page_size, items, filters_not_applied }`. A filter key the API does not recognise is listed in `filters_not_applied`; it is never silently ignored.
- Detail actions return `{ item }`.

**Errors**

| HTTP | Code | Meaning |
|---|---|---|
| 400 | `INVALID_INPUT` | A malformed filter, page, page size, sort, cursor or missing identifier |
| 400 | `INVALID_ACTION` | The action is not in the contract |
| 401 | `AUTHENTICATION_REQUIRED` | Missing or invalid key |
| 404 | `NOT_FOUND` | The course, provider or scholarship identifier was not found |
| 429 | `RATE_LIMITED` | Over 60 a minute for that action; wait for `Retry-After` |
| 503 | `SERVICE_UNAVAILABLE` | A bounded service failure; retry later |

On 429 or 5xx keep serving your last good copy and retry on the next run.

# 5. Recommended integration

| Tool | How | Why |
|---|---|---|
| University Finder, Scholarship Finder | Wix collections filled by `sync` | Fast pages with no API call during a visit |
| Course Finder | `search` called live from your backend, each response cached 15 minutes; course cards and detail from your `sync` copy | Search uses the platform's relevance and filters; the cache absorbs repeat searches |
| Filter lists | `reference`, refreshed daily | Vocabularies with counts |

**Schedule**

| Job | When |
|---|---|
| Full load with `sync` | Once at set-up, and again only if your copy is lost |
| Delta with `sync` | Hourly |
| `reference` | Daily |

**When a call or run fails**

1. Keep the last good copy in service.
2. Record the error, its `request_id` and the time.
3. Do not save a new cursor.
4. Retry on the next run.

Measured on Pilot (database time): filtered search 0.1–0.6 s; a search sorted by tuition across a whole country about 2 s (add another filter or cache it); course detail under 0.1 s; `reference` under 0.1 s (it is rebuilt every 15 minutes); a `sync` page about 0.5–1 s. Add 0.1–0.3 s for the network.

# 6. Sync: full load, then only what changed

`sync` keeps your Wix collections current with the fewest calls.

```json
{
  "contract": "website-search-v2",
  "action": "sync",
  "cursor": "<next_cursor from your last reply; leave out for a full load>",
  "page_size": 50
}
```

**How it works**

1. **Full load.** Call `sync` with no cursor. You get every item the API returns, in pages. Keep calling with `next_cursor` while `has_more` is true. The last page has `full_load_complete: true`.
2. **Changes.** From then on, send the stored cursor. You get only what is new, changed or removed since, and a new `next_cursor`.
3. **Save the cursor only after the page is written to Wix.** If a write fails, send the same cursor again: the same items come back, and upserting by id makes the replay safe.

**Request fields**

| Field | Meaning |
|---|---|
| `cursor` | The `next_cursor` from your last reply. Leave it out (or `null`) for a full load |
| `full_load` | `true` starts a full load again |
| `entities` | Optional, on a full load only: any of `reference`, `provider`, `logo`, `rankings`, `scholarship`, `course` (all six by default). A cursor keeps the entities it started with |
| `page_size` | 1–50 (default 50) |

**Reply fields**

| Field | Meaning |
|---|---|
| `items[]` | `{ entity, id, seq, change, item }`. `change` is `upsert` (store `item` by `id`) or `remove` (delete the record with that `id`; no `item`) |
| `has_more` | More items follow: call again with `next_cursor` |
| `next_cursor` | Opaque text. Store it as it is |
| `mode` | `full` or `delta` |
| `full_load_complete` | `true` on the last page of a full load |
| `checked_through` | When the platform last finished checking every item for changes (`null` until the first check after a full load has finished) |
| `as_of` | Time of the reply |

**Item shapes**

| Entity | `id` | `item` | Your collection |
|---|---|---|---|
| `course` | course_id | The search item (7.2) | CF_Courses |
| `provider` | provider_id | The provider detail (7.4) | CF_Providers |
| `logo` | provider_id | `{ provider_id, logo }` (7.7) | Logo on CF_Providers, file in Wix Media |
| `rankings` | provider_id | `{ provider_id, rankings[] }` (7.6) | CF_Rankings |
| `scholarship` | scholarship_id | The scholarship detail (7.5) | CF_Scholarships |
| `reference` | `reference` | The reference vocabularies (7.1) | CF_Reference |

**Good to know**

- A page may hold fewer than `page_size` items when they are large (a page of provider details holds 3). Keep going while `has_more` is true.
- A full load is about 40,400 items (15 October 2026): about 1,400 calls, roughly 25 minutes within the limit of 60 calls a minute.
- The platform checks every item for changes every minute in a rolling pass; a full pass takes about 90 minutes. A change appears in a later delta.
- A removal comes as `change: "remove"`: for example a provider switched off (with its courses, logo and rankings) or a scholarship no longer published.
- **Logos:** each logo link is valid for 365 days (`url_expires_at`). Copy the file into Wix Media and serve your copy; never link to the signed URL from a visitor page. The platform sends a logo again with a new link 30 days before the old one ends, and whenever the file changes (`content_hash`).

# 7. Actions and data

| Action | Parameters | Returns |
|---|---|---|
| `reference` | none | Vocabularies with counts (7.1) |
| `search` | `filters`, `page`, `page_size`, `sort` | Course list (7.2) |
| `course` | `course_id` or `course_code` | `{ item }` course detail (7.3) |
| `providers` | `filters`, `page`, `page_size`, `sort` | Provider list (7.4) |
| `provider` | `provider_id` | `{ item }` provider detail with rankings and statistics (7.4) |
| `rankings` | `filters`, `page`, `page_size` | Ranking entries (7.6) |
| `scholarships` | `filters`, `page`, `page_size` | Scholarship list (7.5) |
| `scholarship` | `scholarship_id` | `{ item }` scholarship detail with linked courses (7.5) |
| `sync` | `cursor`, `full_load`, `entities`, `page_size` | Pages of items to store (section 6) |

## 7.1 reference

```json
{ "contract": "website-search-v2", "action": "reference" }
```

Per country (AU, NZ, CA): study levels, study areas, subdivisions (states, provinces, regions), cities with metro areas, intake months and English tests, each with course counts. Also: regional categories, institution types with provider counts, university groups, ranking systems with editions, scholarship amount types, study stages and student types, and the sort values for courses and providers. `generated_at` says when the counts were built (every 15 minutes).

## 7.2 search (Course Finder)

```json
{
  "contract": "website-search-v2",
  "action": "search",
  "filters": {
    "country_codes": ["AU"],
    "keyword": "business",
    "cities": ["Melbourne"],
    "study_level_codes": ["masters_coursework"],
    "intake_months": [2],
    "english_test_codes": ["IELTS"],
    "english_score_max": 6.5,
    "tuition_annual_max": 45000
  },
  "page": 1,
  "page_size": 6
}
```

This returned 35 courses on 15 October 2026. All filters are optional and combine with AND.

| Filter | Type | Notes |
|---|---|---|
| `keyword` | text | Title, provider name or course code |
| `country_codes` | list | `AU`, `NZ`, `CA` |
| `study_level_codes` | list | From `reference`, e.g. `bachelor`, `masters_coursework` |
| `study_area_codes` | list | ASCED narrow fields from `reference`, e.g. `asced-0603` (Nursing) |
| `subdivision_codes` | list | e.g. `AU-VIC`, `NZ-AUK`, `CA-ON` |
| `cities`, `postcodes` | list | A campus city or metro area, any letter case |
| `regional_categories` | list of numbers | Australian Home Affairs category 1, 2 or 3 |
| `provider_ids`, `university_groups` | list | Groups: `go8`, `atn`, `iru`, `run` |
| `institution_types` | list | From `reference`: `university`, `university_college`, `higher_education_institute`, `tafe_polytechnic`, `private_vet`, `school`, `wananga`, `other` |
| `delivery_modes` | list | `on_campus`, `online`, `blended`, `on_campus_and_online` |
| `intake_months` | list of numbers | 1–12 |
| `english_test_codes` + `english_score_max` | list + number | Courses whose minimum overall score for that test is at or below the score. Give exactly one test code with a score |
| `tuition_annual_min`, `tuition_annual_max` | number | Annual tuition in the course's own currency; use with `country_codes` |
| `has_intake`, `has_english`, `has_official_url`, `has_tuition`, `has_scholarship` | true/false | Only courses holding that value |
| `changed_since` | timestamp | Courses changed since then (`sync` is the simpler way to keep a copy) |

**Sort:** `relevance` (default with a keyword), `title_asc` (default otherwise), `tuition_annual_asc`, `tuition_annual_desc`, `duration_asc`, `updated_asc`. Ties are broken by course_id, so paging is stable. Courses with no tuition held sort last under the tuition sorts.

**Course fields (search items and `sync` course items)**

| Field | Notes |
|---|---|
| `course_id`, `title` | `course_id` is the key to store |
| `display_code`, `display_code_kind`, `display_code_label` | **The code to show visitors**: the printed code (kind `own`, for example a CRICOS course code) or a StudySearch code such as `UBC-MA-014` (kind `studysearch`). It never changes |
| `course_code` | The source system's code. Do not show it; show `display_code` |
| `provider { provider_id, name, legal_name, institution_type, university_groups[], ranking_summary, logo }` | As in 7.4 |
| `campuses[] { city, postcode, subdivision_code, metro_area, regional_category, regional_category_name, is_primary }`, `campus_city`, `campus_metro_area` | The searched city first. Postcode, metro area and regional category are held for Australia; New Zealand and Canadian campuses mostly have a city and region only |
| `study_level { code, name }`, `study_area { code, name }` | |
| `duration_months`, `delivery_modes[]` | From the register or the course page. A duration given in semesters is not converted: `duration_months` is null |
| `tuition { amount, currency, basis, basis_label, annual_amount, annual_is_derived, year, source }` | See 7.8 |
| `intakes[] { label, month, year, start_date, application_deadline }` | Months for most courses; dates mostly null |
| `entry_requirements { summary, basis }`, `english_requirements[] { test_code, test_name, min_overall_score, min_band_score, source }` | English only. Academic entry is not held and never implied |
| `official_url` | The provider's own course page |
| `scholarship_count` | Linked published scholarships |
| `subdivision_codes[]`, `publication_status`, `freshness` | `subdivision_codes` are the course's states or provinces from its campuses; a Canadian course with no campus (often online) takes its provider's province. The `subdivision_codes` filter uses the same values |

## 7.3 course (detail)

```json
{ "contract": "website-search-v2", "action": "course", "course_code": "082960F" }
```

`course_code` accepts a source code, a StudySearch display code (e.g. `UNBC-BA-019`) or a `course_id`. The detail has every search field plus: `description`, `tuition_history[]` (every year held, latest first), `scholarships[] { scholarship_id, name, official_url, amount_note, amount_is_maximum, application_deadline, saving_per_year, saving_currency }`, `english_note`, `other_matches` (other courses sharing the same source code), and `provider_outcomes_state` with `provider_outcomes[]` (the provider's QILT statistics, as in 7.4).

## 7.4 providers and provider (University Finder)

```json
{ "contract": "website-search-v2", "action": "providers",
  "filters": { "country_codes": ["AU"], "university_groups": ["go8"] },
  "sort": "qs_rank_asc", "page": 1, "page_size": 6 }
{ "contract": "website-search-v2", "action": "provider", "provider_id": "provider:cricos:00025b" }
```

**Filters:** `keyword`, `country_codes`, `subdivision_codes`, `cities`, `regional_categories`, `university_groups`, `institution_types`, `study_level_codes` and `study_area_codes` (offered), `has_scholarship`, `ranked_in` (`qs_wur`, `the_wur`), `qs_rank_max`, `the_rank_max`, `has_logo`, `provider_ids`. **Sort:** `name_asc` (default), `qs_rank_asc`, `the_rank_asc`, `course_count_desc`.

| Field | List / detail | Notes |
|---|---|---|
| `provider_id`, `name`, `legal_name`, `website` | list | `name` is the presentable name |
| `institution_type { code, name, basis }` | list | From the regulators' registers (TEQSA, CRICOS, NZQA). `null` for Canada and a few Australian providers |
| `campuses[]` | list | As for courses |
| `course_count`, `study_levels_offered[]`, `study_areas_offered[]` | list | With course counts |
| `university_groups[]`, `scholarship_count` | list | |
| `ranking_summary { qs_wur, the_wur }` | list | Latest edition of each: `edition_year`, `rank_display`, `rank_low`; `null` where not ranked |
| `logo` | list | 7.7 |
| `description`, `rankings[]` | detail | `rankings[]` as in 7.6, every edition held |
| `outcomes_state`, `outcomes[]` | detail | QILT statistics for Australian providers, by study level (UG, PGC, PGR, ALL): `survey`, `survey_name`, `metric_code`, `metric_name`, `study_level`, `study_level_name`, `value`, `unit`, `ci_low`, `ci_high`, `national_benchmark`, `reference_year`, `responses`. Provider level only, never per course. Empty for New Zealand and Canada |

An average tuition per provider is not returned: there is no sound basis for one.

## 7.5 scholarships and scholarship (Scholarship Finder)

```json
{ "contract": "website-search-v2", "action": "scholarships",
  "filters": { "student_types": ["international"] }, "page": 1, "page_size": 10 }
{ "contract": "website-search-v2", "action": "scholarship", "scholarship_id": "<scholarship_id from the list>" }
```

**Filters:** `keyword`, `country_codes`, `provider_ids`, `cities`, `subdivision_codes`, `university_groups`, `amount_types` (`fixed_amount`, `percentage_tuition`, `full_tuition`), `open_only`, `study_level_codes`, `study_area_codes`, `student_types` (`international`, `domestic`, `both`), `study_stages` (`commencing`, `current`), `automatic_consideration`, `nationality_codes`, `course_id`. Results are ordered by name. Every scholarship returned is published.

| Field | Notes |
|---|---|
| `scholarship_id`, `name`, `official_url`, `provider { provider_id, name, cities[], country_code, logo }`, `university_id`, `campus_city` | |
| `amount_value`, `amount_type`, `amount_currency`, `amount_is_maximum`, `amount_note`, `scholarship_percentage`, `value_classification` | `amount_is_maximum` is true for "up to" amounts |
| `application_deadline`, `application_open_date`, `deadline_is_rolling`, `current_status` | Dates only where the page states one. `current_status`: `open`, `closed`, `opening_soon` or `check_provider` |
| `study_levels[]`, `study_area_codes[]` | From the linked courses |
| `study_stages[]`, `student_type`, `study_load` | |
| `academic_minimum { value, scale, text }`, `min_academic_score` | `min_academic_score` (0–100) only where the provider states a percentage or WAM; ATAR and GPA stay in `academic_minimum` with their scale |
| `automatic_consideration`, `citizenship_eligibility[]`, `gender`, `age_min`, `age_max`, `renewable`, `eligibility_summary` | |
| `course_count`; in detail `linked_courses[] { course_id, course_code, title, saving_per_year, saving_currency, saving_basis }` | Up to 200 linked courses (`linked_courses_truncated` when there are more) |
| `description`, `award_tiers[]` (detail), `last_verified_date`, `publication_status` | `reference_code` is not held (null) |

## 7.6 rankings

```json
{ "contract": "website-search-v2", "action": "rankings",
  "filters": { "system_codes": ["qs_wur"], "edition_year": 2027, "country_codes": ["AU"] },
  "page": 1, "page_size": 20 }
```

**Filters:** `system_codes` (`qs_wur`, `the_wur`), `edition_year` (default latest), `country_codes`, `provider_ids`, `rank_max`.

Each item: `provider { provider_id, name, country_code, logo }`, `system_code`, `system_name`, `publisher`, `edition_year`, `rank_display` (exactly as published, e.g. `201–250`), `rank_low`, `rank_high`, `is_tied`, `overall_score_display`, `indicators[] { code, label, value_display, rank_display }`, `methodology_url`, `source_url`, `attribution`, `terms_status`.

Held: QS World University Rankings 2021–2027 and Times Higher Education World University Rankings 2016–2026, for the providers matched to StudySearch. Nothing is re-ranked or interpolated. Show `attribution` with every ranking.

## 7.7 Logos

`logo { url, url_expires_at, mime_type, content_hash, updated_at, source_url, attribution, terms_status }`, or `null` where no approved logo is held.

- One primary logo per provider, from the provider's own website, as published (SVG, PNG or JPEG; not recoloured or resized).
- `url` is a signed link valid for 365 days. Copy the file to Wix Media and serve your copy. Copy it again when `content_hash` changes or when `sync` sends the logo again.
- If signing fails for a call, `url` is `null` for that call only; the rest of the response is unaffected.
- A dark variant and a brand colour are not held.

## 7.8 Tuition rules

- `basis` is always stated: `annual`, `indicative_annual`, `course_total`, `per_session` or `unspecified`. `basis_label` keeps the provider's own words.
- `source` is `provider_current` (the provider's current fee page, preferred) or `regulatory_registered` (the Australian CRICOS registered course total).
- `annual_amount` is the stated annual figure, or is derived from a course total only for courses of 12 months or more (then `annual_is_derived` is true). Per-session and unspecified figures have no annual amount.
- A whole-course total is never presented as per year. An amount under 1,000 is treated as not held (provider pages use $0 or $1 as placeholders).
- Currency is the course's own (AUD, NZD or CAD). There is no conversion: filter by country before filtering by tuition.

# 8. What is held now

Courses or records the API returns holding a value (14 October 2026; coverage grows daily).

| Course field | Australia (26,103) | New Zealand (6,474) | Canada (4,723) |
|---|---|---|---|
| Official course page | 18,385 | 3,000 | 2,678 |
| English requirements | 13,895 | 1,810 | 1,593 |
| Intake months | 9,269 | 1,967 | 848 |
| Any tuition | 25,716 | 966 | 326 |
| Study area | 26,103 | 6,053 | 4,601 |
| Study level | 26,103 | 6,233 | 2,671 |
| Duration (months) | 26,103 | 2,929 | 1,319 |
| Delivery mode | 26,078 | 3,868 | 3,204 |
| At least one campus | 26,069 | 2,603 | 2,332 |
| At least one linked scholarship | 9,397 | 1,060 | 846 |
| Providers with courses | 1,546 | 287 | 52 |

Scholarships returned: 1,100 (Australia 901, New Zealand 141, Canada 58); 1,096 open to international students. Providers with an approved logo: 49. QS 2027 ranked Australian providers: 38. QILT statistics: 116 Australian providers. Institution type: held for Australian and New Zealand providers (null for Canada).

# 9. Your Wix collections (suggested)

| Collection | Key | Holds |
|---|---|---|
| CF_Courses | `course_id` | The course item (7.2). Show `display_code` |
| CF_Providers | `provider_id` | The provider detail (7.4), with the Wix Media id and `content_hash` of its logo |
| CF_Rankings | `provider_id` + `system_code` + `edition_year` | Ranking entries (7.6) |
| CF_Scholarships | `scholarship_id` | The scholarship detail (7.5) |
| CF_Reference | — | The `reference` reply |
| CF_SyncState | — | `next_cursor`, last full load, last delta, last `request_id`, counts and errors |

Do not mirror the platform's own database; map the fields you need once and ignore the rest.

# 10. Support

Send: the action and request body (no key), the `request_id`, the HTTP status, the time (with time zone) and whether it affects live search, a scheduled sync or your cached pages. Never include the key.

# 11. Production

- At go-live you receive a separate Production key by secure channel; the endpoint address does not change.
- Replace the Pilot key in Wix Secrets Manager, run the acceptance tests again, then run a full load with `sync`.
- The Pilot key is disabled after the Production tests pass.

# 12. Acceptance tests

Counts are as measured on Pilot on 15 October 2026 and grow as data is added.

| # | Test | Expected |
|---|---|---|
| 1 | Key | `reference` with your key returns 200 with `contract_version: "website-search-v2"` |
| 2 | Wrong key | An invalid key returns 401 and no data |
| 3 | Reference | Vocabularies for AU, NZ and CA; eight institution types |
| 4 | Course search | The example in 7.2 returns 35 courses; each has a February intake, an IELTS minimum at or below 6.5 and annual tuition at or below 45,000 |
| 5 | Keyword | `keyword` nursing with `cities` Melbourne returns 109 courses, nursing titles first, the same total on every page |
| 6 | Canada | `country_codes` CA returns 4,723 courses, each with a `display_code` |
| 7 | Display code | `course` with `course_code` UNBC-BA-019 returns that course; `display_code_kind` is `studysearch` |
| 8 | Course detail | `course_code` 082960F returns English by test, tuition with basis and linked scholarships; NOPE-XX-999 returns 404 |
| 9 | University Finder | `providers` with `university_groups` go8 and sort `qs_rank_asc` returns 8 providers |
| 10 | Provider detail | `provider` provider:cricos:00025b returns 48 QILT rows and its rankings |
| 11 | Institution type | `providers` with `country_codes` AU and `institution_types` university returns 45 providers |
| 12 | Scholarships | `scholarships` with `student_types` international returns 1,096 records |
| 13 | Rankings | `rankings` with QS, edition 2027, AU returns 38 entries, each with `attribution` and `terms_status: "approved"` |
| 14 | Logos | `providers` with `has_logo` true returns 49 providers; each `logo.url` opens and `url_expires_at` is about a year ahead; your page shows the Wix Media copy |
| 15 | Sync full load | `sync` with no cursor: `mode` full and `has_more` true; following `next_cursor` to the end gives `full_load_complete: true` |
| 16 | Sync changes | The last `next_cursor` sent again returns only what changed since (often nothing); sending it twice gives the same items |
| 17 | Errors | An unknown action returns 400 `INVALID_ACTION`; a 429 is handled by waiting for `Retry-After` |
| 18 | Nulls and new fields | A value not held is null or empty, never a placeholder; an unknown field in a response is ignored safely |
| 19 | Key safety | The key is absent from browser bundles, page source, CMS records and browser network requests |

# 13. Changes to this guide

Changes within `website-search-v2` are additive. Each one reissues this guide with a new date and a line here.

| Date | Change |
|---|---|
| 15 October 2026 | First issue of the developer guide, with the OpenAPI file and Postman collection. It replaces the Version 2 handover of 14 October 2026; the contract is unchanged. Developer key added; `reference` now rebuilt every 15 minutes; `sync` pages may hold fewer items than `page_size` |
| 15 October 2026 (afternoon) | A Canadian course with no campus now lists its provider's province in `subdivision_codes` (all 4,723 Canadian courses have one; 2,332 before). Intake months are no longer repeated in `intakes[]` (a month was listed twice for 410 courses) |
