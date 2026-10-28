---
title: "StudySearch Website API v2 — Developer Guide"
subtitle: "website-api-v2 · Version 2 · Issue 5 · 29 October 2026 · Pilot"
---

| | |
|---|---|
| **For** | The developers of the StudySearch website (Wix): Course Finder, University Finder and Scholarship Finder |
| **API** | One HTTPS address for Website API v2, nine actions |
| **Environment** | Pilot (live). Production uses the same endpoint address with a separate key, issued at go-live |
| **Your key** | Sent to you separately by a secure channel. It is never written in this guide or the files that come with it |
| **Files with this guide** | `StudySearch-Website-API-v2.openapi.json` (OpenAPI 3.1) and `StudySearch-Website-API-v2.postman_collection.json` (Postman; set the variable `apiKey`) |

# 1. What the API gives you

The API is the only way the website reads StudySearch data. It returns courses, universities and colleges (providers), scholarships, rankings, logos and the vocabularies for your filters, for Australia, New Zealand and Canada.

Four rules apply to every response:

1. **Null means not held.** A value the platform does not hold is `null` or an empty list. Nothing is filled with a default, an estimate or a value from another record.
2. **Only published data is returned.** A provider the platform has switched off is not returned, with its courses and scholarships. Every record you receive reads `publication_status: "published"`.
3. **Additive only.** Fields, filters and actions are added, never renamed or removed, within v2. Ignore fields you do not use. A breaking change would come as `website-api-v3` at a new address, with its own guide, and v2 would keep running alongside it.
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
POST https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/website-api-v2
Content-Type: application/json
Authorization: Bearer <your key>
```

- Every request body includes an `action`. There is no `contract` field: the address is the version.
- Keep the key in backend-only configuration. Never put it in browser code, page source, CMS records, repositories, screenshots, tickets or ordinary logs.
- Each key has its own limit: **300 requests a minute, all actions together**. Over the limit you get HTTP 429 with a `Retry-After` header.
- Your key works with this address only. If a key is exposed, tell us: we disable it and issue a new one (a key cannot be recovered, only replaced).

**Moving from the earlier address.** Until now the API was reached at `wix-course-api` with `"contract": "website-search-v2"` in every body. That address and its key keep working, unchanged, until you have moved; we will agree the switch-off date with you. The answers are the same at both addresses. To move: store the new key, change the address, drop the `contract` field, and read `api_version` instead of `contract_version`. Your stored sync cursor works at the new address, so no new full load is needed.

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

- `page` starts at 1. For the list actions `page_size` is 1–50 (default 20); `sync` pages are covered in section 6.
- Send `Accept-Encoding: gzip` (most HTTP clients do this by default). Replies are then compressed to about a ninth of their size.
- Every response carries `api_version: "website-v2"` and a `request_id`. Quote the `request_id` when you report a problem.
- An error reply is `{ api_version, error: { code, message, detail }, request_id }`; `detail` says what was wrong where it can.
- List actions return `{ total, page, page_size, items, filters_not_applied }`. A filter key the API does not recognise is listed in `filters_not_applied`; it is never silently ignored.
- Detail actions return `{ item }`.

**Errors**

| HTTP | Code | Meaning |
|---|---|---|
| 400 | `INVALID_INPUT` | A malformed filter, page, page size, sort, cursor or missing identifier |
| 400 | `INVALID_JSON` | The body is not a JSON object |
| 400 | `INVALID_ACTION` | The action is not one of the nine |
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
  "action": "sync",
  "cursor": "<next_cursor from your last reply; leave out for a full load>",
  "page_size": 600
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
| `page_size` | 1–600 (default 600). A page holds at most about 1.7 MB of JSON (about 0.15 MB compressed), so large items (provider details, scholarships) come fewer to a page |

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

- A page may hold fewer than `page_size` items when they are large. Keep going while `has_more` is true.
- The platform checks every item for changes every minute in a rolling pass; a full pass takes about 90 minutes. A change appears in a later delta.
- A removal comes as `change: "remove"`: for example a provider switched off (with its courses, logo and rankings) or a scholarship no longer published.
- **Logos:** each logo link is valid for 365 days (`url_expires_at`). Copy the file into Wix Media and serve your copy; never link to the signed URL from a visitor page. The platform sends a logo again with a new link 30 days before the old one ends, and whenever the file changes (`content_hash`).

## 6.1 Full load: what to expect

Measured on Pilot on 17 October 2026.

| Measure | Full load |
|---|---|
| Items | About 41,900 (courses 37,300; providers 1,885; scholarships 1,100; logos 1,550; ranking sets 56; reference 1) |
| Calls | About 86 at the default page size (600) |
| Data | About 113 MB of JSON in total, about 15 MB compressed with `Accept-Encoding: gzip`; the largest page about 1.7 MB (the first page 150 KB compressed) |
| Reply time | Under a second a page; the platform builds a page in under 0.3 seconds |
| Elapsed time | About 1 to 2 minutes (one page at a time) |
| After the full load | A delta is usually one call; the platform checks every item for changes within about 90 minutes, and a change appears in the next delta after that |

## 6.2 What we expect from your sync job

1. **Run it as a scheduled backend job that can resume.** Save `next_cursor` after each page is written. If the job stops (for example at a Wix time limit), the next run carries on from the saved cursor.
2. **One cursor at a time.** Each call needs the previous reply's cursor; do not start a second full load while one is running.
3. **Stay within 300 calls a minute.** On 429, wait for `Retry-After` and send the same cursor again.
4. **Write each page in one bulk save,** upserting by `id`; delete by `id` on `remove`.
5. **After the full load, run a delta every 5 to 15 minutes.** Run a full load again only to rebuild your collections.
6. **Copy each new or renewed logo into Wix Media** in the run that receives it.

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
{ "action": "reference" }
```

Per country (AU, NZ, CA): study levels, study areas, subdivisions (states, provinces, regions), cities with metro areas, intake months and English tests, each with course counts. Also: regional categories, institution types with provider counts, university groups, ranking systems with editions, scholarship amount types, study stages and student types, and the sort values for courses and providers. `generated_at` says when the counts were built (every 15 minutes).

## 7.2 search (Course Finder)

```json
{
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

This returned 35 courses on 29 October 2026. All filters are optional and combine with AND.

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
| `english_test_codes` + `english_score_max` | list + number | Courses whose minimum overall score for that test is at or below the score, on that test's own scale. Give exactly one test code with a score. Test codes: `IELTS`, `PTE`, `TOEFL_IBT`, `CAE`, `DET` (Duolingo English Test, 10–160); `reference` lists the codes held for each country with course counts |
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
{ "action": "course", "course_code": "082960F" }
```

`course_code` accepts a source code, a StudySearch display code (e.g. `UNBC-BA-019`) or a `course_id`. The detail has every search field plus: `description`, `tuition_history[]` (every year held, latest first), `scholarships[] { scholarship_id, name, official_url, amount_note, amount_is_maximum, application_deadline, saving_per_year, saving_currency }`, `english_note`, `other_matches` (other courses sharing the same source code), and `provider_outcomes_state` with `provider_outcomes[]` (the provider's QILT statistics, as in 7.4). With `edu_country` (7.9) it also carries `entry`, the course's academic entry requirements and the requirement that applies to a student from that country; without it, `entry` holds the course's own published requirements.

## 7.4 providers and provider (University Finder)

```json
{ "action": "providers",
  "filters": { "country_codes": ["AU"], "university_groups": ["go8"] },
  "sort": "qs_rank_asc", "page": 1, "page_size": 6 }
{ "action": "provider", "provider_id": "provider:cricos:00025b" }
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
| `entry_matrix[]` | detail | Academic entry requirements the provider publishes by country of prior education (7.9); narrowed to one country with `edu_country` |

An average tuition per provider is not returned: there is no sound basis for one.

## 7.5 scholarships and scholarship (Scholarship Finder)

```json
{ "action": "scholarships",
  "filters": { "student_types": ["international"] }, "page": 1, "page_size": 10 }
{ "action": "scholarship", "scholarship_id": "<scholarship_id from the list>" }
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
{ "action": "rankings",
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


## 7.9 Academic entry requirements

`course` and `provider` take an optional **`edu_country`**: the two-letter ISO country code of the student's country of prior education, for example `"IN"` for India. Keep the student's choice in their session and send it with both calls. Any other value is refused with `400 INVALID_INPUT`. `search` does not take it.

```json
{ "action": "course", "course_code": "0100714", "edu_country": "IN" }
{ "action": "provider", "provider_id": "provider:cricos:00122a", "edu_country": "IN" }
```

**Course detail: `entry`** (always present; `null` means not held):

| Field | Notes |
|---|---|
| `min_score`, `min_score_basis` | The course's minimum entry score and the words the course page prints with it, for example `75` and `"2027 Guaranteed ATAR"`. Show the basis with the number |
| `benchmark_band` | The provider's band this course names, only where the course page prints one. Never worked out from a score |
| `prerequisites[]`, `selection_tasks[]` | `{ text, quote }` as published |
| `requirements_note` | Other published entry conditions |
| `resolution` | Only when `edu_country` is sent; see below |

**`resolution`**: the requirement that applies to a student from that country. It is worked out in a fixed order, and the first rule that applies is used:

1. a rule the course page states for itself;
2. the provider's row for this course and country;
3. the course's band, looked up in the provider's table for the country;
4. the provider's minimum for the country and the course level;
5. otherwise, contact the provider.

| Field | Notes |
|---|---|
| `step`, `rule` | 1–5: `course_override`, `course_country_row`, `band_ladder`, `provider_minimum`, `contact_provider` |
| `outcome` | `minimum_published`, `case_by_case` or `contact_provider` |
| `rows[]` | `qualification`, `study_level`, `min_grade`, `scale`, `band`, `conditions`, `quote`, `as_at`, `edition`, `case_by_case` |
| `note` | Why no table row applied, when `step` is 5 |

Show it like this:

- **`minimum_published`:** show each qualification with its minimum, for example "All India Senior School Certificate: minimum average of 75%".
- **`case_by_case`**, or a row with `case_by_case` true: show **"This qualification is considered case by case"**. Never show "no data", and never treat it as met.
- **`contact_provider`:** show **"Requirements for your qualification aren't published — contact the provider"**, with the provider's website.

The API looks requirements up. It never decides whether a student is eligible.

**Provider detail: `entry_matrix[]`** (admitted rows; narrowed to `edu_country` when sent): `country`, `study_level` (the provider's own label), `qualification`, `min_grade`, `scale`, `band`, `course_code` (only on rows for one course), `conditions`, `as_at`. A row with `min_grade` null has `scale` `"none"`: it is considered case by case.

**Worked example (Pilot, measured 29 October 2026, admitted rows only):** RMIT University, Bachelor of Engineering (Honours), CRICOS `0100714`, for a student from India.

```json
{ "action": "course", "course_code": "0100714", "edu_country": "IN" }
```

```json
"entry": {
  "min_score": null, "min_score_basis": null, "benchmark_band": null,
  "prerequisites": [], "selection_tasks": [], "requirements_note": null,
  "resolution": {
    "country": "IN", "step": 5, "rule": "contact_provider", "outcome": "contact_provider", "rows": [],
    "note": "The provider publishes a band table for this country, but the course page prints no band to enter it with.",
    "contact": "https://www.rmit.edu.au"
  }
}
```

The provider publishes an India table, but this course's page prints no band to enter it with, so the answer is step 5: show "contact the provider". The same provider's table:

```json
{ "action": "provider", "provider_id": "provider:cricos:00122a", "edu_country": "IN" }
```

```json
"entry_matrix": [
  { "country": "IN", "study_level": "Bachelor degrees", "qualification": "All India Senior School Certificate (AISSC) – 10+2",
    "min_grade": "Minimum average of 65%", "scale": "percentage", "band": "65%",
    "conditions": { "best_n": null, "alternatives": [], "subject_minimums": [] }, "as_at": "2026-10-26" },
  { "country": "IN", "study_level": "Bachelor degrees", "qualification": "State Boards of Education (Higher Secondary Certificate, HSC)",
    "min_grade": "Minimum average of 70%", "scale": "percentage", "band": "65%",
    "conditions": { "best_n": null, "alternatives": [], "subject_minimums": [] }, "as_at": "2026-10-26" }
]
```

33 rows for India (343 for all countries). A course that names its band (for example "65%") resolves at step 3 to the rows of that band; this course names none.

**Integrating:**

- **Website (Wix):** let the student choose their country of prior education once (for example on the course page or in their profile), keep it in their session, and send it as `edu_country` with `course` and `provider` from your backend code, as for every call (the key never reaches the browser). Render `entry.resolution` with the three rules above; show `as_at` with each row. `sync` does not carry entry requirements: fetch them with `course` and `provider` when the page is shown (or cache them by course and country).
- **Zoho:** Zoho's own API (`zoho-api-v2`) is unchanged and carries no entry requirements. A Zoho workflow that needs them for a lead calls Website API v2 `course` with the lead's country of prior education, with a key issued for that use.
- **Other consumers:** treat `entry` and `entry_matrix` as optional; a value not held is `null` or empty, never a placeholder.

Coverage grows as each provider's published table is admitted by a person (section 8).

# 8. What is held now

Courses or records the API returns holding a value (29 October 2026; coverage grows daily).

| Course field | Australia (23,732) | New Zealand (6,474) | Canada (3,814) |
|---|---|---|---|
| Official course page | 17,893 | 3,043 | 2,664 |
| English requirements | 16,032 | 2,356 | 2,009 |
| of which Duolingo English Test (DET) | 405 | 0 | 248 |
| Intake months | 9,374 | 2,140 | 1,613 |
| Any tuition | 23,564 | 1,414 | 680 |
| Study area | 23,732 | 6,225 | 3,774 |
| Study level | 23,732 | 6,254 | 3,814 |
| Duration (months) | 23,732 | 2,338 | 1,324 |
| Delivery mode | 23,712 | 2,980 | 2,507 |
| At least one campus | 23,701 | 2,339 | 2,088 |
| At least one linked scholarship | 9,136 | 1,456 | 990 |
| Providers with courses | 1,279 | 287 | 52 |

Scholarships returned: 1,114 (Australia 898, New Zealand 151, Canada 65); 1,111 open to international students. Providers with an approved logo: 1,463. QS 2027 ranked Australian providers: 38. QILT statistics: 116 Australian providers. Institution type: held for Australian and New Zealand providers (null for Canada).

Academic entry requirements (7.9): provider tables admitted for 1 provider (343 rows across its countries); more providers' tables are being read and wait for a person's approval before they are returned. Course-level entry rows admitted: none yet. A course or provider without admitted rows returns `entry` and `entry_matrix` empty, and resolution step 5.

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

Counts are as measured on Pilot on 29 October 2026; they change as data is corrected and grows.

| # | Test | Expected |
|---|---|---|
| 1 | Key | `reference` with your key at the new address returns 200 with `api_version: "website-v2"` |
| 2 | Wrong key | An invalid key returns 401 and no data |
| 3 | Reference | Vocabularies for AU, NZ and CA; eight institution types |
| 4 | Course search | The example in 7.2 returns 35 courses; each has a February intake, an IELTS minimum at or below 6.5 and annual tuition at or below 45,000 |
| 5 | Keyword | `keyword` nursing with `cities` Melbourne returns 107 courses, nursing titles first, the same total on every page |
| 6 | Canada | `country_codes` CA returns 3,814 courses, each with a `display_code` |
| 7 | Display code | `course` with `course_code` UNBC-BA-019 returns that course; `display_code_kind` is `studysearch` |
| 8 | Course detail | `course_code` 082960F returns English by test, tuition with basis and linked scholarships; NOPE-XX-999 returns 404 |
| 9 | University Finder | `providers` with `university_groups` go8 and sort `qs_rank_asc` returns 8 providers |
| 10 | Provider detail | `provider` provider:cricos:00025b returns 48 QILT rows and its rankings |
| 11 | Institution type | `providers` with `country_codes` AU and `institution_types` university returns 45 providers |
| 12 | Scholarships | `scholarships` with `student_types` international returns 1,111 records |
| 13 | Rankings | `rankings` with QS, edition 2027, AU returns 38 entries, each with `attribution` and `terms_status: "approved"` |
| 14 | Logos | `providers` with `has_logo` true returns 1,463 providers; each `logo.url` opens and `url_expires_at` is about a year ahead; your page shows the Wix Media copy |
| 15 | Sync full load | `sync` with no cursor: `mode` full and `has_more` true; following `next_cursor` to the end gives `full_load_complete: true` |
| 16 | Sync changes | The last `next_cursor` sent again returns only what changed since (often nothing); sending it twice gives the same items |
| 17 | Errors | An unknown action returns 400 `INVALID_ACTION`; a 429 is handled by waiting for `Retry-After` |
| 18 | Nulls and new fields | A value not held is null or empty, never a placeholder; an unknown field in a response is ignored safely |
| 19 | Key safety | The key is absent from browser bundles, page source, CMS records and browser network requests |
| 20 | Entry, contact provider | `course` with `course_code` 0100714 and `edu_country` IN returns `entry.resolution` with `step` 5 and `outcome` `contact_provider`; your page shows "contact the provider" |
| 21 | Entry, provider table | `provider` with `provider_id` provider:cricos:00122a returns 343 `entry_matrix` rows; with `edu_country` IN, 33 rows, all `country` IN |
| 22 | Entry, invalid country | `edu_country` ZZ or IND returns 400 `INVALID_INPUT` |

# 13. Changes to this guide

Changes within Website API v2 are additive. A change to the API (a new field, filter, action or behaviour) reissues this guide with a new date and a line here. Data grows between issues; the counts in this guide are measures on the date shown.

| Date | Change |
|---|---|
| 15 October 2026 | First issue, with the OpenAPI file and Postman collection. Changes from the Version 2 handover of 14 October 2026: a developer key; `reference` rebuilt every 15 minutes; `sync` pages may hold fewer items than `page_size` |
| 15 October 2026 (issue 2) | `sync` pages hold up to 200 items (was 50; default 200), and a page also stops at about 550 KB. A full load is about 250 calls, about 5 minutes (was about 1,400 calls, about 25 minutes). Sections 6.1 and 6.2 added: what to expect from a full load, and what we expect from your sync job |
| 16 October 2026 (issue 3) | Website API v2 at its own address, `website-api-v2`, with its own key: no `contract` field; responses carry `api_version: "website-v2"` instead of `contract_version`; errors add `message` and `detail` (and `INVALID_JSON`); 300 calls a minute per key, all actions together. Same actions, fields and answers. The earlier address keeps working until you have moved |
| 17 October 2026 (issue 4) | `sync` pages hold up to 600 size units (was 200; default 600): a full load is about 86 calls, about 1 to 2 minutes (was about 260 calls, about 5 minutes); a caller that sends a smaller `page_size` keeps getting smaller pages. Replies are compressed when you send `Accept-Encoding: gzip` (about 15 MB for a full load instead of about 113 MB). New English test code `DET` (Duolingo English Test, overall score 10–160) in `english_requirements`, the `english_test_codes` filter and `reference` |
| 29 October 2026 (issue 5) | `course` and `provider` take an optional `edu_country` (the student's country of prior education). The course detail gains `entry` (the course's academic entry requirements and, with `edu_country`, the requirement that applies, worked out in a fixed order with "case by case" and "contact the provider" outcomes); the provider detail gains `entry_matrix[]` (the provider's published requirements by country). Section 7.9 added; acceptance tests 20 to 22 added |
