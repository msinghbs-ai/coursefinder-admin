---
title: "StudySearch Zoho API v2 — Developer Guide"
subtitle: "zoho-api-v2 · First issue · 16 October 2026 · Pilot"
---

| | |
|---|---|
| **For** | The Zoho developers: the Zoho Creator counsellor app (course search) and the Zoho CRM sync (Institutes and Courses modules) |
| **API** | One HTTPS address for Zoho API v2, fifteen actions |
| **Environment** | Pilot (live). Production will have its own address and keys, issued at go-live |
| **Keys** | Two keys, one for Zoho Creator and one for the Zoho CRM sync, sent separately by a secure channel. They are never written in this guide or the files that come with it |
| **Files with this guide** | `StudySearch-Zoho-API-v2.openapi.json` (OpenAPI 3.1) and `StudySearch-Zoho-API-v2.postman_collection.json` (Postman; set the variable `apiKey`) |
| **Replaces** | The Zoho Developer Handover v1.0 (1 September 2026) for new work. The v1 address keeps working until you have moved (section 11) |

# 1. What the API gives you

Courses, universities and colleges (providers), campuses, provider contacts, scholarships, rankings, statistics (QILT and PRISMS) and the vocabularies for your filters, for Australia, New Zealand and Canada. For the CRM it also gives a change feed and CSV files keyed by CRICOS code, Australia first.

Five rules apply to every response:

1. **Null means not held.** A value the platform does not hold is `null` or an empty list. Nothing is filled with a default or an estimate.
2. **Only published data is returned.** A provider the platform has switched off is not returned, nor are its courses, campuses, contacts and scholarships. Every course reads `publication_status: "published"`.
3. **One address per version.** This guide covers `zoho-api-v2` only. Within v2, fields, filters and actions are only added, never renamed or removed: ignore fields you do not use. A breaking change would come as `zoho-api-v3` at a new address, with its own guide, and v2 would keep running alongside it.
4. **CRICOS codes are the keys for Australia.** Every Australian provider and course carries `cricos_provider_code` and `cricos_course_code`. Every one of the 1,546 Australian providers and 26,103 Australian courses has one, and no course code is shared.
5. **Third-party material carries attribution.** Rankings and logos come with `attribution` and `terms_status` (approved for display). Show the attribution with them.

# 2. Quick start

**Zoho Creator (counsellor search)**

1. Put the Creator key in a Zoho Connection (custom service, API key in the `Authorization` header as `Bearer <key>`). Never in Deluge source or widget JavaScript.
2. Call `reference` once a day and cache the vocabularies (section 7.1).
3. Call `search` live with the student's filters (section 5). Each result already carries intakes, English requirements, tuition, campuses and the scholarship count: no `course` call per result.
4. Call `course` or `courses` when a counsellor opens a course or a lead lists CRICOS codes.

**Zoho CRM (Institutes and Courses kept current)**

1. Put the CRM key in its own Zoho Connection.
2. Seed once from the CSV files (`export`, section 6.1), matching on CRICOS code, and keep the sync cursor that comes with the first page.
3. Then run `sync` on a schedule (every 15–60 minutes, section 6.2) and apply what changed.

# 3. Address and keys

```
POST https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/zoho-api-v2
Content-Type: application/json
Authorization: Bearer <your key>
```

| Key | For | Limit |
|---|---|---|
| Zoho Creator | Live search and detail from the counsellor app | 120 calls a minute |
| Zoho CRM sync | `export` and `sync` for the CRM modules (it may call every action) | 120 calls a minute |

- `x-cf-token: <your key>` is accepted instead of the `Authorization` header.
- There is no `contract` field: the address is the version.
- Each key's calls are counted and shown to StudySearch (calls, errors, times). Tell us if a key may have leaked: we switch it off and issue a new one.
- Do not use or ask for Supabase keys, database credentials or table access. This API is the supported way in.

# 4. Requests and responses

Every request is a POST with a JSON body. `action` chooses what you get. Optional fields can be left out.

```json
{ "action": "search", "filters": { "keyword": "nursing", "country_codes": ["AU"] }, "page": 1, "page_size": 20 }
```

Every JSON answer carries `api_version: "zoho-v2"` and a `request_id`. Lists return `total`, `page`, `page_size` and `items`; details return `item`. `filters_not_applied` lists filter keys that were not recognised (check spelling).

| HTTP | `error.code` | What to do |
|---|---|---|
| 200 | — | Use the result. A search with no results is 200 with `items: []` |
| 400 | `INVALID_JSON`, `INVALID_ACTION`, `INVALID_INPUT` | Fix the request; `error.detail` says what is wrong. Do not retry it unchanged |
| 401 | `AUTHENTICATION_REQUIRED` | Check the Connection's key and header |
| 404 | `NOT_FOUND` | The course, provider or scholarship is not held or not published |
| 429 | `RATE_LIMITED` | Wait the seconds in `Retry-After`, then retry |
| 503 | `SERVICE_UNAVAILABLE` | Retry later with a back-off; show a short message to the user |

Quote the `request_id` when you report a problem.

# 5. Zoho Creator: live course search

This answers the two questions in your email of 14 October.

**1. Details in the search results.** Each `search` item has the course's intakes (month and, where held, year and start date), English requirements by test (overall and lowest band), tuition (amount, year, basis, annual amount), campuses (city, state, postcode, metro area), study level, study area, duration, delivery modes, the official course link and the scholarship count. Filtering by English score, band and intake month happens on our side, so the page you get back is already filtered: there is no need to call `course` for each result.

**2. The provider in the search.** Send the provider name as text in `filters.provider_name` (part of the name is enough: "Queensland" finds The University of Queensland and others). If you have the CRICOS provider code, send `filters.provider_cricos_codes` instead; it is exact. `keyword` also matches provider names as well as course titles and codes.

| Filter | Type | Meaning |
|---|---|---|
| `keyword` | text | Words in the course title, provider name or a course code |
| `provider_name` | text | Part of the provider's name |
| `provider_cricos_codes` | list | CRICOS provider codes, for example `["00025B"]` |
| `provider_ids` | list | StudySearch provider ids (`provider:cricos:00025b`) |
| `country_codes` | list | `AU`, `NZ`, `CA` |
| `subdivision_codes` | list | States and regions, for example `AU-VIC` |
| `cities`, `postcodes` | list | Campus city (or metro area) and postcode |
| `regional_categories` | list | 1 major city, 2 regional city, 3 regional centre or other |
| `study_level_codes`, `study_area_codes` | list | From `reference` |
| `institution_types`, `university_groups` | list | From `reference` |
| `delivery_modes` | list | `on_campus`, `online`, `blended`, `on_campus_and_online` |
| `intake_months` | list of 1–12 | Courses with an intake in any of these months |
| `english_test_codes` | list | `IELTS`, `PTE`, `TOEFL_IBT`, `CAE` |
| `english_score_max` | number | The student's overall score: courses whose overall requirement is at or below it (needs exactly one test) |
| `english_band_max` | number | The student's lowest band: courses whose every band requirement is at or below it (needs exactly one test) |
| `tuition_annual_min`, `tuition_annual_max` | number | Annual tuition range in the course's currency |
| `has_intake`, `has_english`, `has_tuition`, `has_official_url`, `has_scholarship` | true | Only courses that have this |
| `changed_since` | date-time | Courses changed since then |

`sort`: `relevance` (default with a keyword), `title_asc` (default without), `tuition_annual_asc`, `tuition_annual_desc`, `duration_asc`, `updated_asc`. `page_size` is 1–50.

Example: Nursing in Australia, IELTS 7.0 overall with no band under 6.5, intake in February or July (107 courses on 16 October):

```json
{ "action": "search", "filters": { "keyword": "nursing", "country_codes": ["AU"], "english_test_codes": ["IELTS"],
  "english_score_max": 7, "english_band_max": 6.5, "intake_months": [2, 7] }, "page": 1, "page_size": 10 }
```

Course detail: `{"action": "course", "cricos_course_code": "082960F"}` (or `course_id`). Several at once (up to 50, in the order asked; ones not found are listed in `not_found`): `{"action": "courses", "identifiers": ["082960F", "0100879"]}`.

Recommended cache: `reference` once a day (it holds countries, states, cities, study levels and areas, institution types, university groups, ranking systems and scholarship vocabularies, with counts). Do not cache search results for more than 15 minutes.

# 6. Zoho CRM: Institutes and Courses kept current

Australia is in the CRM feed now; New Zealand and Canada can be switched on later without a change to your side (the `reference` answer lists the countries under `sync.countries`).

| CRM module | Entity | Key to match on | Count (16 Oct) |
|---|---|---|---|
| Institutes | `provider` | `cricos_provider_code` (also `provider_id`) | 1,546 |
| Courses | `course` | `cricos_course_code` (also `course_id`); link to the institute by `provider.cricos_provider_code` | 26,103 |
| Campuses (optional) | `campus` | `campus_id`; link by `cricos_provider_code` | 3,957 |
| Contacts (optional) | `contact` | `contact_id`; link by `cricos_provider_code` | 2,788 |

Contacts are of four types: `head_of_institution` (the principal executive officer from the public CRICOS register, 1,537), `general` (the international or general enquiry contact from the provider's own website, 1,224), and `team` and `staff` (international recruitment contacts held by StudySearch, 27).

## 6.1 First import: CSV

`{"action": "export", "entity": "provider"}` returns a CSV file (`text/csv`, header first, one row per item). Entities: `provider`, `campus`, `contact`, `course`. Add `"format": "json"` to get the CSV inside JSON instead.

Files come in pages of up to 3,000 rows. Each page is a complete CSV file with the header. Ask for `"page": 2`, `3` and so on while `x-has-more` is `true`; call one page at a time. On 16 October the course file is nine pages and the other files are one or two.

| Header (JSON field) | Meaning |
|---|---|
| `x-rows` (`rows`) | Rows in this page |
| `x-page`, `x-pages` (`page`, `pages`) | This page and how many there are |
| `x-total-rows` (`total_rows`) | Rows in the whole file |
| `x-has-more` (`has_more`) | `true` while there is another page |
| `x-complete` (`complete`) | `true` once the platform has built every item of that entity |
| `x-sync-cursor` (`sync_cursor`) | Where `sync` continues from: keep the one from the first page you export |

| File | Columns |
|---|---|
| provider | provider_id, cricos_provider_code, name, legal_name, institution_type, country_code, state, city, postcode, website, phone, email, course_count, campus_count, contact_count, qs_rank, the_rank, updated_at |
| course | course_id, cricos_course_code, title, provider_id, cricos_provider_code, provider_name, study_level, study_area, country_code, states, campus_cities, delivery_modes, duration_months, intake_months, ielts_overall, ielts_band, pte_overall, tuition_annual, tuition_currency, tuition_year, official_url, scholarship_count |
| campus | campus_id, provider_id, cricos_provider_code, provider_name, name, address_line1, address_line2, city, state, postcode, country_code, latitude, longitude, metro_area, regional_category, course_count |
| contact | contact_id, provider_id, cricos_provider_code, provider_name, type, name, title, team, email, phone, source, source_url, checked_at |

Lists inside a cell are separated by `; `. Import Institutes first, then Courses (so the institute lookup resolves), then Campuses and Contacts.

## 6.2 Staying current: sync

`sync` returns items in order, each with `entity`, `id`, `seq`, `change` (`upsert` with the full `item`, or `remove`) and a `next_cursor`.

1. **Full load (only if you did not seed from CSV):** `{"action": "sync", "full_load": true}`. Repeat with `{"action": "sync", "cursor": "<next_cursor>"}` while `has_more` is true. About 34,400 items for Australia; a page holds up to `page_size` items (at most 200) and is also limited by size, so a page of large items holds fewer. Always follow `has_more`, never count items.
2. **After a CSV seed:** use the `sync_cursor` from the first page you exported as your cursor. Changes made after that file was read then come through `sync` (some may repeat what a later file already holds; upserts by key make that harmless).
3. **Every 15–60 minutes:** send the stored cursor; apply each upsert by key and each remove (mark the record inactive in Zoho rather than deleting it); store the new `next_cursor` only after the page is written. Repeat while `has_more`.
4. `entities` limits a full load to some of `provider`, `campus`, `contact`, `course`.

What we expect from the sync job: one cursor at a time (never two runs in parallel), honour `Retry-After`, write pages in bulk, and keep the cursor in Zoho so a failed run resumes where it stopped.

# 7. Actions

| Action | Send | Returns |
|---|---|---|
| `reference` | — | Vocabularies with counts; `sync` (entities, countries, item counts) |
| `search` | `filters`, `page`, `page_size`, `sort` | Courses (section 5) |
| `course` | `cricos_course_code` or `course_id` | One course in full |
| `courses` | `identifiers` (up to 50) | Those courses, and `not_found` |
| `providers` | `filters` (`provider_name`, `provider_cricos_codes`, `country_codes`, `subdivision_codes`, `cities`, `institution_types`, `university_groups`, `has_logo`, ranking filters), `page`, `page_size`, `sort` | Providers with courses |
| `provider` | `cricos_provider_code` or `provider_id` | One provider with its campuses, contacts, rankings (with indicators) and QILT outcomes |
| `campuses` | `filters` (`provider_cricos_codes`, `provider_ids`, `country_codes`, `subdivision_codes`), `page`, `page_size` | Campuses with address, location and course count |
| `contacts` | `filters` (as campuses, plus `contact_types`), `page`, `page_size` | Contacts |
| `statistics` | `kind` `qilt` (filters `provider_cricos_codes`, `provider_ids`) or `prisms` (filters `subdivision_codes`, `sectors`), `page`, `page_size` | QILT measures per provider; PRISMS international enrolments per region, sector and study area |
| `rankings` | `filters` (`system_codes`, `edition_year`, `country_codes`, `rank_max`) | Ranking entries with attribution |
| `scholarships` | `filters` (`student_types`, `open_only`, `course_id`, `nationality_codes` and more) | Scholarships |
| `scholarship` | `scholarship_id` | One scholarship |
| `sync` | `cursor`, `full_load`, `entities`, `page_size` | Changes (section 6.2) |
| `export` | `entity`, `page`, optional `format: "json"` | One page of the CSV file and the sync cursor to continue from (section 6.1) |
| `report` | `cricos_course_code` or `course_id`, `field`, `note`, `reporter` (`name`, `email`, `ref`) | Records a counsellor's report of a value that looks wrong; StudySearch reviews it |

# 8. Data notes

- **Tuition.** `tuition` is the provider's current fee for international students: the latest year held (`year`), its `basis` and `annual_amount` (worked out from a whole-course fee where only that is published, with `annual_is_derived: true`). The registered total course fee from CRICOS is separate and never merged into it.
- **English.** Each requirement has `test_code`, `min_overall_score` and `min_band_score` (the lowest band asked). An empty list means not held, not "no requirement".
- **Statistics grain.** QILT measures belong to the provider (and student level); PRISMS counts belong to a region, sector and study area. Neither is a course fact: do not show them as one.
- **Scholarships.** `scholarship_count` and the scholarship list are what StudySearch has matched to the course; an empty list does not prove there is none.
- **Logos.** `logo.url` is a signed link valid for a year (`url_expires_at`). Copy the image into Zoho if you keep it; providers are sent again in `sync` before their link ends.
- **Canada** has fewer fields held than Australia and New Zealand. Show what is held.

# 9. What is held now (16 October 2026)

| | Australia |
|---|---|
| Providers / courses / campuses / contacts | 1,546 / 26,103 / 3,957 / 2,788 |
| Courses with intakes | 9,269 |
| Courses with English requirements | 15,901 |
| Courses with tuition | 25,716 |
| Courses with a matched scholarship | 9,397 |
| Courses with an official course link | 18,385 |
| QILT measures (all providers) / PRISMS rows | 3,068 / 2,270 |

Coverage grows as data is admitted; the CSV and `sync` carry it to you.

# 10. Acceptance tests

| # | Send | Expect |
|---|---|---|
| 1 | `{"action":"reference"}` | 200; `sync.countries` is `["AU"]` |
| 2 | Section 5 example | 200; `total` about 107; every item has `cricos_course_code` and `english_requirements` |
| 3 | `{"action":"search","filters":{"provider_name":"Queensland"},"page_size":2}` | 200; two items, `total` above 1,000 |
| 4 | `{"action":"course","cricos_course_code":"082960F"}` | 200; Bachelor of Nursing (Honours), The University of Queensland |
| 5 | `{"action":"courses","identifiers":["082960F","0100879","NOPE"]}` | 200; two items; `not_found` is `["NOPE"]` |
| 6 | `{"action":"provider","cricos_provider_code":"00025B"}` | 200; campuses and contacts listed |
| 7 | `{"action":"statistics","kind":"qilt","filters":{"provider_cricos_codes":["00025B"]}}` | 200; `total` 48 |
| 8 | `{"action":"export","entity":"provider"}` | 200; CSV with header and 1,546 rows; `x-pages` 1; `x-sync-cursor` present |
| 9 | `{"action":"sync","full_load":true,"page_size":5}` | 200; at least one item (up to five) and a `next_cursor` |
| 10 | `{"action":"search","page_size":500}` | 400 `INVALID_INPUT` |
| 11 | `{"action":"export","entity":"course","page":9}` | 200; 2,103 rows; `x-has-more` false |
| 12 | A wrong key | 401 `AUTHENTICATION_REQUIRED` |

# 11. Moving from v1

The v1 address (`zoho-course-api`) and its key keep working unchanged until you have moved. StudySearch will agree the switch-off date with you.

| v1 | v2 |
|---|---|
| `lookup` with `identifier` | `course` with `cricos_course_code` or `course_id` |
| `search` with top-level `query`, `country_codes`, `limit`, `offset` | `search` with `filters.keyword`, `filters.country_codes`, `page`, `page_size` |
| `has_intake`, `has_english` flags only in results | Intakes and English requirements in every result |
| `provider_options` | `providers` (with `filters.provider_name`) |
| `filter_options`, `reference_bundle` | `reference` |
| `scholarships` with `course_id` | `scholarships` with `filters.course_id` |
| `report` | `report` (same fields) |
| QILT and PRISMS "not admitted" | `provider` (QILT outcomes) and `statistics` |
| `publication_status` "unpublished" | Every returned course is `published` |

# 12. Support

Send the action, the JSON body (without the key), the HTTP status, the full response and the `request_id` to the StudySearch Platform Admin.

# 13. Changes to this guide

| Issue | Date | API change |
|---|---|---|
| First issue | 16 Oct 2026 | Zoho API v2 at its own address with its own keys: fifteen actions; search results with intakes, English (overall and bands) and tuition; provider name and CRICOS filters; CRICOS codes on every Australian course and provider; campuses, contacts and statistics; CSV export in pages (with the cursor to continue from) and sync for the CRM (Australia) |
