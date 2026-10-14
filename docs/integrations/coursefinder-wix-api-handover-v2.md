# StudySearch Wix Developer API Handover

**Version 2 • Pilot • LIVE**

| **Date**            | 14 October 2026                                                                                                                                                                                                                               |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Environment**     | Pilot (a separate Production credential is issued at go-live; the endpoint address does not change)                                                                                                                                           |
| **Consumer**        | Wix / StudySearch website — Australia study page: Course Finder, University Finder, Scholarship Finder                                                                                                                                        |
| **Source of truth** | StudySearch platform (Pilot)                                                                                                                                                                                                                  |
| **Contract**        | website-search-v2 (new major version). v1 contracts wix-cache-v1 and website-search-v1 remain available unchanged                                                                                                                             |
| **Status**          | LIVE ON PILOT — website-search-v2 released 8 October 2026; this issue checked against the live Pilot platform on 14 October 2026. FULL INDEPENDENT HANDOVER. Display of rankings and logos is subject to management's decision on usage terms |
| **Supersedes**      | v1.1 (5 September 2026) and all earlier v2 drafts                                                                                                                                                                                             |
| **Platform name**   | StudySearch (formerly CourseFinder). The endpoint, function name, key, credential identity and contract names are unchanged                                                                                                                   |

# Changes since v1.1

- Introduces **website-search-v2**, a new major contract on the **same endpoint and the same Wix key**. The website selects it per request with "contract": "website-search-v2". Requests without it are answered by v1 exactly as today.

- v2 is designed from the StudySearch platform around the three website tools described by the website team on 15 September and 1 October 2026: Course Finder, University Finder and Scholarship Finder.

- New v2 actions: reference, course, providers, provider, rankings, scholarship. Reworked v2 actions: search, scholarships.

- **The provider Published switch controls what the website receives.** A provider switched off (or archived) by the Platform Admin is not returned by any action, together with its courses, campuses and scholarships. publication_status reads published on every course and provider returned. Scholarships are published only.

- **Course display code.** Every course carries display_code (the printed code, or a short StudySearch code such as UBC-MA-014 where the course has no printed code). Show it to visitors; keep course_id as the key.

- Canada is searchable (4,723 courses from 52 providers), alongside Australia and New Zealand.

- **QILT statistics** (student experience, graduate outcomes, employer satisfaction) are returned at provider grain on provider and course detail, by study level.

- **Institution type** (University, University College, Higher Education Institute, TAFE / Polytechnic, Private VET college, School, Wānanga, Other) is returned on every provider and on the provider of every course, with the institution_types filter on search and providers and the list in reference. Australia and New Zealand are typed from the regulators' registers; Canada is not typed yet (null).

- The platform is now called **StudySearch** (formerly CourseFinder). Endpoint, function name, key, credential identity and contract names are unchanged.

- Records v1 additions made after v1.1 was issued: search and scholarships actions (23 Sep); campus city, postcode, metro area and Home Affairs regional category; explicit tuition basis; presentable provider names; English entry summary; university-group filter (29 Sep).

- Adds a second, supported visitor path: live search calls from the Wix backend with a short response cache, alongside the cache-first sync of v1.1 (section 10).

- Adds current data coverage, so the website can plan which fields will often be empty (section 14).

- Adds **university rankings** (QS World University Rankings 2021–2027 and Times Higher Education World University Rankings 2016–2026, with indicator scores and edition history) and **university logos**. Every ranking and logo carries its source attribution and a terms_status; whether and how the website displays them is for management to decide.

- Returns the **scholarship fields requested by the website team** on 15 September and 1 October under the requested names, mapped to platform data, with nulls where the provider page does not state a value (section 13.5).

- Production cutover updated: the platform moves by project transfer, so the endpoint address stays the same; only the credential changes.

*Versioning rule: v1.0 and v1.1 remain historical evidence. This is the Version 2 handover for the website-search-v2 contract. Additive changes are reissued as Version 2 with a new date and a line in the change log (section 21). A breaking change starts Version 3.*

# 1. Purpose

Wix is a downstream presentation and search consumer. It must not connect directly to StudySearch database tables and must not receive Supabase service_role or other privileged keys.

v2 gives the website one contract for its three tools. The contract is the StudySearch platform's own; it is not a copy of the prototype tables used while the website was being built. The developer maps v2 fields to the Wix collections once; after release, v2 changes are additive only.

Rules that apply to every v2 response:

1.  StudySearch remains canonical. Every value comes from a stored source page or a government register.

2.  **Null means not held.** A field the platform does not hold for a record is null or an empty array. It is never filled with a default, an estimate or a value from another record.

3.  The provider Published switch, set by the Platform Admin, decides what the website receives. A provider switched off or archived is not returned, with all its courses, campuses and scholarships. Every course and provider returned reads publication_status: published; scholarships are published only.

4.  The key is used from Wix backend code only. No browser calls.

5.  Rankings and logos are third-party material. They are delivered with attribution and terms_status (management_decision_pending until management confirms usage terms). Do not display them publicly until the status changes or management instructs otherwise.

# 2. Developer quick start

1.  Keep using the existing Wix Pilot key. It is valid for v1 and v2. Do not request a Supabase key.

2.  Confirm the key is held in Wix Secrets Manager or other backend-only configuration.

3.  Call reference with the v2 envelope and cache the vocabularies (section 5).

4.  Call search with your real Course Finder filters; then course for one result's detail.

5.  Call providers, provider and rankings for University Finder; scholarships and scholarship for Scholarship Finder.

6.  Choose the visitor path for each tool: live search with a backend response cache, or cache-first sync (section 10).

7.  Map v2 fields to Wix collections (section 9). Ignore fields you do not use yet.

8.  Record contract version, last success, request ID and cursor in CF_SyncState.

9.  Run the acceptance tests in section 18 and send any failures with request IDs.

# 3. Endpoints

## Website endpoint (v1 and v2)

> POST https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/wix-course-api

Edge Function: wix-course-api. One endpoint, two contracts:

| **Contract**                     | **Selected by**                                     | **Actions**                                                                         |
|----------------------------------|-----------------------------------------------------|-------------------------------------------------------------------------------------|
| website-search-v2                | "contract": "website-search-v2" in the request body | reference, search, course, providers, provider, rankings, scholarships, scholarship |
| wix-cache-v1 / website-search-v1 | no contract field (default)                         | reference_bundle, sync_courses, lookup, search, scholarships                        |

v2 is live on Pilot. A request with no contract field, or any value other than website-search-v2, is answered by v1 exactly as before.

## Existing website interactive endpoint

> POST https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/website-course-api

Remains available for v1 interactive use. New work should use wix-course-api with the v2 contract.

# 4. Authentication

Store the StudySearch Wix API key in Wix Secrets Manager or backend-only configuration.

> Authorization: Bearer \<COURSEFINDER_WIX_PILOT_API_KEY\>

Pilot credential identity:

> coursefinder_website_wix_pilot_v1

The same credential authorises v1 and v2. Never place the raw key in browser code, page source, frontend fetch calls, public environment variables, CMS records, source repositories, screenshots, tickets or ordinary logs.

Do not request or use the Supabase service_role key. The raw Wix key is transferred out-of-band only.

## Key lifecycle rules

- consumer / integration name

- environment (Pilot, later Production)

- credential identity

- status: active, expiring, expired, revoked or disabled

- created / rotated timestamp

- optional expiry timestamp

- last-used / last-success signal where available

- rotation history / audit reference

- copy / secure-send action available only at creation or rotation while the raw value is transiently available

The raw secret must not be recoverable from the stored hash after the creation/rotation window. If a key is lost, rotate it; do not attempt to reveal the existing secret. Pilot and Production keys are always different credentials.

# 5. API request examples

## Request envelope

> {
>
> "contract": "website-search-v2",
>
> "action": "search",
>
> "filters": { },
>
> "page": 1,
>
> "page_size": 20,
>
> "sort": "relevance"
>
> }

page_size is 1–50 (default 20); page starts at 1. Every response carries contract_version: "website-search-v2" and request_id. List responses carry { total, page, page_size, items, filters_not_applied }; search and providers also echo the sort applied. Filter keys the platform does not recognise are listed in filters_not_applied; they are never silently ignored.

| **Action**   | **Identifier or parameters**                                  | **Returns**                                     |
|--------------|---------------------------------------------------------------|-------------------------------------------------|
| reference    | none                                                          | Vocabularies with counts                        |
| search       | filters, page, page_size, sort                                | Course list                                     |
| course       | course_id or course_code (source or StudySearch display code) | { item } course detail                          |
| providers    | filters, page, page_size, sort                                | Provider list                                   |
| provider     | provider_id                                                   | { item } provider detail with rankings          |
| rankings     | filters, page, page_size                                      | Ranking entries                                 |
| scholarships | filters, page, page_size                                      | Scholarship list                                |
| scholarship  | scholarship_id                                                | { item } scholarship detail with linked courses |

## Reference

> {"contract":"website-search-v2","action":"reference"}

## Course search (Course Finder)

> {
>
> "contract": "website-search-v2",
>
> "action": "search",
>
> "filters": {
>
> "country_codes": \["AU"\],
>
> "keyword": "business",
>
> "cities": \["Melbourne"\],
>
> "study_level_codes": \["masters_coursework"\],
>
> "intake_months": \[2\],
>
> "english_test_codes": \["IELTS"\],
>
> "english_score_max": 6.5,
>
> "tuition_annual_max": 45000
>
> },
>
> "page": 1,
>
> "page_size": 6
>
> }

On 14 October this returned 35 courses. english_score_max needs exactly one value in english_test_codes.

## Course detail

> {"contract":"website-search-v2","action":"course","course_code":"082960F"}
>
> {"contract":"website-search-v2","action":"course","course_code":"UNBC-BA-019"}

course_code accepts a source code, a StudySearch display code or a course_id.

## Provider list and detail (University Finder)

> {"contract":"website-search-v2","action":"providers","filters":{"country_codes":\["AU"\],"university_groups":\["go8"\]},"page":1,"page_size":6}
>
> {"contract":"website-search-v2","action":"provider","provider_id":"provider:cricos:00008c"}

## Rankings (University Finder)

> {"contract":"website-search-v2","action":"rankings","filters":{"system_codes":\["qs_wur"\],"edition_year":2027,"country_codes":\["AU"\]},"page":1,"page_size":20}

## Scholarship list and detail (Scholarship Finder)

> {"contract":"website-search-v2","action":"scholarships","filters":{"student_types":\["international"\],"published_only":true},"page":1,"page_size":10}
>
> {"contract":"website-search-v2","action":"scholarship","scholarship_id":"\<scholarship_id from the list\>"}

## Delta sync (cache-first path)

> {
>
> "contract": "website-search-v2",
>
> "action": "search",
>
> "filters": { "country_codes": \["AU"\], "changed_since": "2026-10-14T00:00:00Z" },
>
> "sort": "updated_asc",
>
> "page": 1,
>
> "page_size": 50
>
> }

# 6. Initial cache load

## Step A — reference data

Call reference and cache the vocabularies per country: study levels, study areas, subdivisions, cities and metro areas, intake months, English tests, regional categories, university groups, institution types, scholarship amount types and study stages, each with counts. Recommended refresh: once daily.

## Step B — providers

Page providers for each country in scope and upsert by provider_id. Store the latest ranking summary on the provider record. Recommended refresh: daily.

## Step B2 — logos

Logo links are signed and expire after 24 hours (logo.url_expires_at). Copy each logo into Wix Media during the provider refresh and serve the Wix copy. Re-copy only when logo.content_hash changes. Never hotlink the signed link from visitor pages. If signing ever fails, logo.url is null for that call and the rest of the response is unaffected; retry at the next refresh.

## Step B3 — rankings

Page rankings per system and edition you intend to use, or read provider.rankings\[\]. Editions change at most yearly; refresh weekly.

## Step C — courses (cache-first path only)

Page search with sort: "updated_asc" and the country filter until page × page_size \>= total. Upsert by course_id; never identify courses by title. Write in bulk from backend code.

## Step D — scholarships

Page scholarships (published only, or all with the website applying publication_status). Upsert by scholarship_id.

# 7. Incremental refresh

After a full load, store the completed sync timestamp in CF_SyncState. On the next run, pass changed_since and page all results before advancing the stored cursor.

Use an overlap window, recommended 5 minutes, so timestamp-boundary changes are not missed. Upserts must be idempotent by stable ID, so replay is safe. Do not advance the cursor on a partially failed run.

A record counts as changed when its source data or its search projection changes. Deltas are often large because the platform refreshes data daily (on 14 October, 11,745 Australian courses had changed since the previous day), so page deltas the same way as a full load. A hidden or archived provider is not returned in a delta: compare the providers list at each daily refresh and remove those no longer returned.

# 8. Recommended Wix schedule

| **Job**                                 | **Frequency**             | **Purpose**                                                                  |
|-----------------------------------------|---------------------------|------------------------------------------------------------------------------|
| Reference refresh                       | Daily                     | Vocabularies and counts for filters                                          |
| Provider refresh                        | Daily                     | University Finder list and detail cache; logo copy when content_hash changes |
| Rankings refresh                        | Weekly                    | Ranking editions and indicator scores                                        |
| Course delta refresh (cache-first path) | Hourly where plan permits | Changed courses only, via changed_since                                      |
| Scholarship refresh                     | Daily                     | Scholarship list, eligibility and linked courses                             |

A manual admin refresh may call the same backend functions. Do not create one job per provider or filter.

# 9. Wix collections

## CF_Courses

- course_id (upsert key)

- course_code (source value)

- display_code, display_code_kind (show display_code to visitors)

- title

- provider_id, provider_name

- country_code, subdivision_codes

- campus_city, campus_metro_area, campuses (JSON: city, postcode, subdivision_code, metro_area, regional_category)

- study_level_code / name, study_area_code / name

- duration_months, delivery_modes

- tuition_amount, tuition_currency, tuition_basis, tuition_annual_amount, tuition_annual_is_derived, tuition_year, tuition_source

- intake_months, intakes (JSON)

- entry_summary, english_requirements (JSON)

- official_url

- scholarship_count

- publication_status

- source_updated_at, projection_updated_at

- raw_contract_version

## CF_Providers

- provider_id (upsert key)

- name, legal_name, website

- country_code, campuses (JSON)

- course_count, study_levels_offered, study_areas_offered

- university_groups

- scholarship_count

- ranking_summary (JSON: latest QS and THE rank and edition)

- logo_wix_media_id, logo_content_hash, logo_source_url, logo_attribution, logo_terms_status

- outcomes_state, outcomes (JSON, when admitted)

- publication_status

## CF_Rankings

- provider_id + system_code + edition_year (upsert key)

- system_name, publisher, edition_year

- rank_display, rank_low, rank_high, is_tied, overall_score_display

- indicators (JSON)

- methodology_url, source_url, attribution, terms_status

## CF_Scholarships

- scholarship_id (upsert key)

- name, provider_id, provider_name, provider_cities, campus_city

- amount_value, amount_type, amount_currency, amount_is_maximum, amount_note

- application_deadline, application_open_date, deadline_is_rolling, current_status

- study_levels, study_stages, student_type, study_load, academic_minimum (JSON), min_academic_score, automatic_consideration, citizenship_eligibility, gender

- scholarship_type, value_classification, scholarship_percentage, last_verified_date, reference_code, age_min, age_max, study_area_codes

- eligibility_summary, renewable

- course_count, official_url

- publication_status

## CF_Reference

- Vocabularies and counts returned by reference

## CF_SyncState

- contract version

- last successful full sync

- last successful delta cursor

- last attempted sync

- status

- imported / updated / error counts

- last request ID

# 10. Performance architecture

v2 supports two visitor paths. Choose per tool.

## Path A — live search with a backend response cache (recommended for Course Finder)

> Visitor path:
>
> Browser -\> Wix backend -\> response cache (hit) -\> page
>
> Browser -\> Wix backend -\> StudySearch search (miss) -\> response cache -\> page

Cache each response by normalised filters + sort + page for 15 minutes. The Pilot rate limit is 60 requests per minute per action for the Wix credential; tell us expected normal and peak searches per minute so the Production limit can be set to match.

| **Measured on live Pilot (8 Oct, database time)**         | **Time**                                                    |
|-----------------------------------------------------------|-------------------------------------------------------------|
| Filtered course search (keyword, city, level and similar) | 0.1–0.6 s                                                   |
| Course search sorted by tuition across a whole country    | about 2 s — narrow by country plus another filter, or cache |
| Course detail                                             | about 0.02–0.07 s                                           |
| Scholarship list (50 per page) / detail                   | 0.2–0.5 s                                                   |
| Provider list (50 per page)                               | about 1.5 s                                                 |
| First call after a quiet period                           | 2–4 s; the response cache absorbs it                        |
| Reference (about 45 KB)                                   | 2–4 s — call once a day and cache                           |

Add 0.1–0.3 s for the network and the endpoint itself.

## Path B — cache-first sync (recommended for University and Scholarship Finder, optional for courses)

> Refresh path:
>
> Wix scheduled backend job -\> StudySearch v2 API -\> Wix bulk upsert -\> cache current
>
> Visitor path:
>
> Browser -\> Wix backend/data query -\> Wix cached collection

Under Path B the website makes no StudySearch calls during a visitor session. Use Wix indexes for the high-value filters and bulk operations for writes. Loading every course into the browser and filtering there does not scale to the full catalogue and is not supported.

# 11. TTL, stale-serving and failure behaviour

- Reference TTL: 24 hours.

- Provider and scholarship TTL: 24 hours.

- Search response cache (Path A): 15 minutes.

- Course data target freshness (Path B): 1 hour.

- Serve stale-on-failure: yes, with monitoring.

- Never clear or replace a working cache before a successful replacement or delta completes.

On a failed call or sync:

1.  keep the last-known-good cache active

2.  record failure status, request ID and error class

3.  do not advance the delta cursor

4.  retry on the next schedule or an authorised manual run

5.  alert support if failure persists beyond the agreed freshness target

# 12. Schema and database extension strategy

Do not mirror StudySearch's internal database schema in Wix. The API contract is the anti-corruption layer between canonical platform data and the website.

1.  Canonical database changes remain internal.

2.  Decide whether the new fact is approved for website publication.

3.  Extend the versioned website contract with an additive field or new resource.

4.  Wix ignores unknown fields until its cache schema and UI are ready.

5.  Wix adds the new field or collection and deploys code to consume it.

6.  Only make a breaking change under a new major contract version.

## Handover versioning for extensions

Every future handover is a full independent document, starting with Changes since previous version.

- coursefinder-wix-api-handover-v2 (this document, reissued with a dated change log for additive changes)

- coursefinder-wix-api-handover-v3 (breaking change only)

# 13. Data contract — website-search-v2

## 13.1 Course Finder — search filters

All filters are optional and combined with AND.

| **Filter**                                                | **Type**            | **Notes**                                                                                                                                                                                       |
|-----------------------------------------------------------|---------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| keyword                                                   | string              | Title, provider name, course code                                                                                                                                                               |
| country_codes                                             | string\[\]          | AU, NZ, CA                                                                                                                                                                                      |
| study_area_codes                                          | string\[\]          | ASCED narrow-field codes from reference, e.g. asced-0603 (Nursing)                                                                                                                              |
| study_level_codes                                         | string\[\]          | e.g. bachelor, masters_coursework                                                                                                                                                               |
| subdivision_codes                                         | string\[\]          | e.g. AU-VIC                                                                                                                                                                                     |
| cities / postcodes                                        | string\[\]          | City matches campus locality or metro area, any letter case                                                                                                                                     |
| regional_categories                                       | int\[\]             | **New.** Home Affairs category 1, 2 or 3 at campus grain                                                                                                                                        |
| provider_ids / university_groups                          | string\[\]          | Groups: go8, atn, iru, run                                                                                                                                                                      |
| institution_types                                         | string\[\]          | Institution type codes from reference: university, university_college, higher_education_institute, tafe_polytechnic, private_vet, school, wananga, other. A course matches through its provider |
| delivery_modes                                            | string\[\]          | on_campus for most courses; online, blended and on_campus_and_online where the course page states it                                                                                            |
| tuition_annual_min / tuition_annual_max                   | number              | Stated or derived annual figure, in the course's own currency (AUD, NZD or CAD; no conversion). Combine with country_codes                                                                      |
| intake_months                                             | int\[\]             | **New.** 1–12; any intake month held                                                                                                                                                            |
| english_test_codes + english_score_max                    | string\[\] + number | **New.** Courses whose minimum overall score for that test is at or below the score. english_score_max needs exactly one test code                                                              |
| has_intake / has_english / has_official_url / has_tuition | boolean             | Only courses holding that field. has_tuition is **new**                                                                                                                                         |
| has_scholarship                                           | boolean             | **New.** At least one linked published scholarship                                                                                                                                              |
| changed_since                                             | ISO timestamp       | **New.** Delta sync                                                                                                                                                                             |

sort: relevance (default with a keyword), title_asc (default otherwise), tuition_annual_asc, tuition_annual_desc, duration_asc, updated_asc. Ties break on course_id so paging is stable. Courses with no tuition held sort last under the tuition sorts. Any other sort value returns 400 INVALID_INPUT.

## 13.2 Course Finder — course fields

| **Field**                                                                                                                                       | **Card / detail** | **Notes**                                                                                                                                                               |
|-------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| course_id, course_code, title                                                                                                                   | card              | course_code is the source value: CRICOS, NZQA or a program code, but for many Canadian courses a source system ID. Do not show it; show display_code                    |
| display_code, display_code_kind, display_code_label                                                                                             | card              | **New.** The code a person reads: the printed code (kind own, label e.g. CRICOS course code) or a StudySearch code such as UBC-MA-014 (kind studysearch). Never changes |
| provider { provider_id, name, legal_name, institution_type, university_groups\[\], ranking_summary, logo }                                      | card              | Presentable name; legal name kept; institution_type, ranking_summary and logo as in 13.4                                                                                |
| campus_city, campus_metro_area, campuses\[\]                                                                                                    | card              | Searched city shown first; each campus has city, postcode, subdivision, metro area, regional category                                                                   |
| study_level, study_area                                                                                                                         | card              | Code and name                                                                                                                                                           |
| duration_months, delivery_modes\[\]                                                                                                             | card              | From the register                                                                                                                                                       |
| tuition { amount, currency, basis, basis_label, annual_amount, annual_is_derived, year, source }                                                | card              | Basis always stated; see 13.3. null where no tuition is held                                                                                                            |
| intakes\[\] { label, month, year, start_date, application_deadline }                                                                            | card              | Months for most courses; dates mostly null                                                                                                                              |
| entry_requirements { summary, basis }                                                                                                           | card              | English only (basis english_only); academic entry is not held and never implied                                                                                         |
| official_url                                                                                                                                    | card              | The provider's own course page, identity-checked                                                                                                                        |
| scholarship_count                                                                                                                               | card              | **New.** Linked published scholarships                                                                                                                                  |
| english_requirements\[\] { test_code, test_name, min_overall_score, min_band_score, source }                                                    | card              | One row per test held; source course_page or university_policy                                                                                                          |
| description                                                                                                                                     | detail            | **New.** Course description where held                                                                                                                                  |
| other_matches                                                                                                                                   | detail            | **New.** Number of other courses sharing the same course_code; look them up by course_id                                                                                |
| english_note                                                                                                                                    | detail            | e.g. check the course page, where a university policy does not list courses that need more                                                                              |
| tuition_history\[\]                                                                                                                             | detail            | Every year held, latest first, each with basis and source                                                                                                               |
| scholarships\[\] { scholarship_id, name, official_url, amount_note, amount_is_maximum, application_deadline, saving_per_year, saving_currency } | detail            | saving_per_year only where computed from the provider's annual international tuition                                                                                    |
| provider_outcomes_state, provider_outcomes                                                                                                      | detail            | **Admitted.** The provider's QILT statistics (13.4), provider grain, never per course. Empty where the provider has none (all New Zealand and Canadian providers today) |
| publication_status, freshness                                                                                                                   | both              |                                                                                                                                                                         |

## 13.3 Tuition rules

- basis is always stated: annual, indicative_annual, course_total, per_session or unspecified (the provider page gives a figure without saying what it covers). basis_label keeps the provider's own wording.

- source is provider_current (the provider's current fee page, preferred when held) or regulatory_registered (the CRICOS registered course total).

- annual_amount is the stated annual figure, or is derived from a course total only for courses of 12 months or more, and then annual_is_derived is true. Per-session and unspecified figures have no annual_amount.

- A whole-course total is never presented as per year.

- An amount under 1,000 is treated as not held, because provider pages use \$0, \$1 or similar as placeholders.

- Currency is the course's own: AUD, NZD or CAD. There is no conversion; filter by country before filtering by tuition.

- New Zealand and Canada have no fee register, so tuition there comes from provider pages only.

## 13.4 University Finder — providers and provider

Filters: keyword, country_codes, subdivision_codes, cities, regional_categories, university_groups, study_level_codes (offered), study_area_codes (offered), has_scholarship, ranked_in (qs_wur, the_wur), qs_rank_max, the_rank_max, has_logo, provider_ids, institution_types. Sort: name_asc (default), qs_rank_asc, the_rank_asc, course_count_desc. Detail (provider) adds description, rankings\[\] and outcomes.

| **Field**                                                                                                                                                                                                                                                  | **List / detail** | **Notes**                                                                                                                                                                                                                                                                                                                                                                                                                                         |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| provider_id, name, legal_name, website                                                                                                                                                                                                                     | list              |                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| institution_type { code, name, basis }                                                                                                                                                                                                                     | list              | **Added 14 Oct.** The type from the regulators' registers: Australia from the TEQSA National Register (university, university college, institute of higher education) and the CRICOS institution type with the provider's courses (a government provider offering VET is TAFE); New Zealand from the NZQA organisation type. basis names the rule, or reads Set by a person. null when not held (Canada; a few Australian providers no rule fits) |
| campuses\[\] { city, postcode, subdivision_code, metro_area, regional_category }                                                                                                                                                                           | list              |                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| course_count, study_levels_offered\[\], study_areas_offered\[\]                                                                                                                                                                                            | list              | With course counts                                                                                                                                                                                                                                                                                                                                                                                                                                |
| university_groups\[\]                                                                                                                                                                                                                                      | list              | Official member pages                                                                                                                                                                                                                                                                                                                                                                                                                             |
| scholarship_count                                                                                                                                                                                                                                          | list              | Published scholarships                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ranking_summary { qs_wur { edition_year, rank_display, rank_low }, the_wur { … } }                                                                                                                                                                         | list              | Latest accepted edition of each ranking; null where not ranked                                                                                                                                                                                                                                                                                                                                                                                    |
| rankings\[\] { system_code, system_name, publisher, edition_year, rank_display, rank_low, rank_high, is_tied, overall_score_display, indicators\[\] { code, label, value_display, rank_display }, methodology_url, source_url, attribution, terms_status } | detail            | Every accepted edition held, latest first (13.6)                                                                                                                                                                                                                                                                                                                                                                                                  |
| logo { url, url_expires_at, mime_type, content_hash, updated_at, source_url, attribution, terms_status }                                                                                                                                                   | list              | Signed link valid 24 hours; copy to Wix Media (13.7). null where no approved logo. A dark variant and brand colour are not held                                                                                                                                                                                                                                                                                                                   |
| outcomes_state, outcomes\[\] { survey, survey_name, metric_code, metric_name, study_level, study_level_name, value, unit, ci_low, ci_high, national_benchmark, reference_year, responses, grain }                                                          | detail            | **Admitted 14 Oct.** QILT statistics at provider grain: Student Experience, Graduate Outcomes (incl. longitudinal) and Employer Satisfaction surveys, by study level (UG, PGC, PGR, ALL), 2023–2025. Up to 60 rows per provider. Not held by field of study                                                                                                                                                                                       |
| publication_status                                                                                                                                                                                                                                         | both              |                                                                                                                                                                                                                                                                                                                                                                                                                                                   |

An average tuition figure is not returned: the platform holds a mix of registered totals, annual and per-session figures and will not publish an average without a sound basis. The website may compute and label its own from search results.

## 13.5 Scholarship Finder — scholarships and scholarship

Filters: keyword, country_codes, provider_ids, cities, subdivision_codes, university_groups, amount_types (fixed_amount, percentage_tuition, full_tuition), open_only, published_only (accepted; every result is published anyway), study_level_codes, study_area_codes; **new**: student_types (international, domestic, both), study_stages (commencing, current), automatic_consideration, nationality_codes, course_id. Location filters match the provider's campuses. Results are ordered by name.

| **Field**                                                                                                                      | **List / detail** | **Notes**                                                                                                                                                        |
|--------------------------------------------------------------------------------------------------------------------------------|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| scholarship_id, name, provider { provider_id, name, cities\[\], country_code, logo }, university_id, campus_city, official_url | list              |                                                                                                                                                                  |
| amount_value, amount_type, amount_currency, amount_is_maximum, amount_note                                                     | list              | amount_is_maximum true for "up to" values; never used for a saving                                                                                               |
| application_deadline, application_open_date (ISO), deadline_is_rolling, current_status                                         | list              | Dates only where the provider page states one. current_status: open, closed, opening_soon or check_provider (no date stated)                                     |
| study_levels\[\], study_area_codes\[\]                                                                                         | list              | **New.** Derived from the scholarship's linked courses (study_levels_source: linked_courses); empty or null where no course is linked                            |
| study_stages\[\], student_type, study_load                                                                                     | list              | **New in v2 payload.** study_stages are commencing / current students; student_type is international, domestic or both                                           |
| academic_minimum { value, scale, text }                                                                                        | list              | **New.** As the provider states it (atar, gpa_7, gpa_4, wam, percentage); converted to a percentage only where the page states one                               |
| automatic_consideration, citizenship_eligibility\[\], gender                                                                   | list              | **New in v2 payload.** citizenship_eligibility is empty where no nationality is named                                                                            |
| eligibility_summary, renewable                                                                                                 | list              | Provider's own words                                                                                                                                             |
| course_count / linked_courses\[\] { course_id, course_code, title, saving_per_year, saving_currency, saving_basis }            | list / detail     | **New.** Up to 200 linked courses in detail (linked_courses_truncated shows when there are more); saving_per_year from the course's annual international tuition |
| description, award_tiers\[\]                                                                                                   | detail            | Provider's description and any tiered award values                                                                                                               |
| publication_status                                                                                                             | both              |                                                                                                                                                                  |

The website's match score should use min_academic_score (0–100), which is filled only where the provider states a percentage or a weighted average mark (WAM, 0–100). ATAR and GPA minimums stay in academic_minimum with their scale and are not converted.

## Requested scholarship fields — mapping

Every field the website team listed is returned under the requested name. Held counts are of the 1,100 published scholarships returned by the API at 14 Oct 2026.

| **Requested field**                                                           | **v2 source and rule**                                                                     | **Held now**                                                 |
|-------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| scholarship_id, name, official_url / official_scholarship_url                 | Platform identity; the provider's own page                                                 | 1,100                                                        |
| provider.name, university_id                                                  | Provider (provider_id)                                                                     | 1,100                                                        |
| campus_city                                                                   | Provider's primary campus city; provider.cities\[\] lists all                              | 1,100                                                        |
| amount_value + amount_type (percentage_tuition / fixed_amount / full_tuition) | Award amount or percentage; 100% of tuition returns full_tuition                           | 1,063 (fixed 849, percentage 155, full tuition 59)           |
| amount_note                                                                   | Provider's wording, e.g. renewable yearly, one-off                                         | where stated (37 awards are described in words only)         |
| scholarship_percentage                                                        | Award percentage                                                                           | 214                                                          |
| value_classification                                                          | full_tuition / partial_tuition / fixed_amount / not_stated, derived from the award         | 1,100                                                        |
| scholarship_type / scholarship_type_bucket                                    | provider_scholarship (register-only government scholarships are no longer returned)        | 1,100                                                        |
| study_levels / study_levels_list                                              | Levels of linked courses                                                                   | 869                                                          |
| study_area_codes                                                              | ASCED fields of the linked courses                                                         | 769                                                          |
| min_academic_score (0–100)                                                    | Stated percentage or WAM only                                                              | 45                                                           |
| academic_minimum { value, scale, text }                                       | As stated: GPA, ATAR, WAM                                                                  | 129                                                          |
| application_deadline / application_closing_date (ISO)                         | Next closing date stated on the page                                                       | 592                                                          |
| application_open_date (ISO)                                                   | Opening date stated on the page                                                            | 421                                                          |
| deadline_is_rolling                                                           | Page says rolling / open until filled                                                      | 8 true                                                       |
| current_status                                                                | open / closed / opening_soon / check_provider, from the stated dates                       | 193 open, 72 opening soon, 327 closed; others check_provider |
| automatic_consideration                                                       | true where considered automatically; false where an application is required                | 255 true, 47 false                                           |
| citizenship_eligibility / eligible_countries_list                             | Nationalities named by the scholarship; student_type gives international / domestic / both | 73 nationality lists; 1,091 student types                    |
| age_min / age_max                                                             | Stated age limits                                                                          | none stated (null)                                           |
| renewable                                                                     | From award duration: annual or program duration = true; one-off or first year = false      | 391 recurring, 126 one-off                                   |
| reference_code                                                                | Not held: national scholarship registers are no longer used                                | null                                                         |
| last_verified_date                                                            | Date the record was last updated                                                           | 1,100                                                        |

## 13.6 Rankings — rankings action and provider rankings

Filters: system_codes (qs_wur, the_wur), edition_year (default latest accepted), country_codes, provider_ids, rank_max. Items: provider { provider_id, name, logo }, system_code, system_name, publisher, edition_year, rank_display (as published, e.g. 201–250), rank_low, rank_high, is_tied, overall_score_display, indicators\[\], methodology_url, source_url, attribution, terms_status. Only rankings matched to a StudySearch provider are returned; publisher entries with no matching provider are not.

| **Ranking**                                      | **Editions held**             | **Indicators (latest edition)**                                                                                                                                                                       |
|--------------------------------------------------|-------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| QS World University Rankings                     | 2021–2027 (7 editions)        | academic reputation, employer reputation, citations per faculty, faculty–student ratio, international faculty and student ratios, international research network, employment outcomes, sustainability |
| Times Higher Education World University Rankings | 2016–2026 (11 editions)       | overall, teaching, research, citations, international outlook, industry income                                                                                                                        |
| ShanghaiRanking ARWU                             | registered, no edition loaded | returned once an edition is loaded                                                                                                                                                                    |

Rank values are returned exactly as published, including bands and ties; nothing is re-ranked or interpolated. Each item's attribution names the publisher, ranking and edition. terms_status is management_decision_pending until management confirms usage terms.

## 13.7 Logos

- One primary logo per provider, as approved by a platform curator from the provider's own website.

- Formats: SVG, PNG or JPEG as published by the provider; no recolouring or resizing by the platform.

- logo.url is a signed link valid for 24 hours; copy to Wix Media at refresh and re-copy when content_hash changes.

- logo_url_dark and brand_color are not held and return null.

- Each logo carries source_url, attribution and terms_status (management_decision_pending until management confirms usage terms).

# 14. Data coverage at handover (live Pilot, 14 Oct 2026)

Counts are courses or records the v2 API returns holding a value now. Coverage grows as automated admission runs; nulls elsewhere are expected.

| **Course field**                              | **Australia (26,103)** | **New Zealand (6,474)** | **Canada (4,723)** |
|-----------------------------------------------|------------------------|-------------------------|--------------------|
| Official course page                          | 18,385                 | 3,000                   | 2,678              |
| English requirements                          | 13,895                 | 1,810                   | 1,593              |
| Intake months                                 | 9,269                  | 1,967                   | 848                |
| Official page + English + intakes together    | 7,255                  | 1,259                   | 599                |
| Registered tuition (regulator)                | 25,707                 | —                       | —                  |
| Provider-page tuition                         | 7,465                  | 966 (NZD)               | 326 (CAD)          |
| Any tuition (has_tuition)                     | 25,716                 | 966                     | 326                |
| At least one linked scholarship               | 9,397                  | 1,060                   | 846                |
| Study area (field of study)                   | 26,103                 | 6,053                   | 4,601              |
| Study level                                   | 26,103                 | 6,233                   | 2,671              |
| Duration (duration_months)                    | 26,103                 | 2,929                   | 1,319              |
| Delivery mode                                 | 26,078                 | 3,868                   | 3,204              |
| At least one campus                           | 26,069                 | 2,603                   | 2,332              |
| Campus with a city                            | 26,068                 | 1,928                   | 1,807              |
| Region held (subdivision_codes, state filter) | 26,068                 | 1,111                   | 2,332              |
| Providers with courses                        | 1,546                  | 287                     | 52                 |

Since 8 October: Canada roughly doubled (new provincial and college sources), and official pages, English and intakes grew in every country. On 14 October New Zealand and Canadian courses gained study area, duration, delivery mode and campuses read from their own course pages.

| **Scholarships (published only)** | **Now**                                           |
|-----------------------------------|---------------------------------------------------|
| Returned by the API               | 1,100 (Australia 901, New Zealand 141, Canada 58) |
| Open to international students    | 1,096                                             |
| Linked to at least one course     | 869                                               |
| Provider logo available           | 1,029                                             |

| **Institution type (providers with courses)** | **Australia** | **New Zealand** | **Canada** |
|-----------------------------------------------|---------------|-----------------|------------|
| University                                    | 45            | 8               | —          |
| University College                            | 8             | —               | —          |
| Higher Education Institute                    | 137           | —               | —          |
| TAFE / Polytechnic                            | 16            | 17              | —          |
| Private VET college                           | 935           | 258             | —          |
| School                                        | 302           | —               | —          |
| Wānanga                                       | —             | 3               | —          |
| Other                                         | 98            | 1               | —          |
| Not held (null)                               | 5             | —               | 52         |

Campuses held: Australia 3,984 (registered locations, with city, postcode, metro area and regional category); New Zealand 168 and Canada 78, named on the providers’ own course pages and linked to courses on 14 October 2026. A New Zealand or Canadian campus carries a city where the page names one (NZ 95 of 168, Canada 44 of 78); postcode is mostly null; metro area and regional category apply to Australia only. A New Zealand campus carries a region (subdivision_code) only where it is in the provider’s own city, otherwise null; a Canadian campus carries its province. Duration stated in semesters returns duration_months null (294 New Zealand and Canadian courses). QILT statistics are returned for 116 Australian providers.

| **Rankings and logos**                                   | **Held now**               |
|----------------------------------------------------------|----------------------------|
| Providers with at least one accepted ranking (QS or THE) | 79                         |
| QS 2027 ranked Australian providers                      | 38, each with 9 indicators |
| Providers returned with an approved logo                 | 49                         |

# 15. Out of scope and gated items

| **Item**                                     | **Position in v2**                                                                                                                                                                                                                                                                                                                   |
|----------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Rankings (QS, THE)                           | Included (13.6). Display is subject to management's decision on usage terms; terms_status shows the position                                                                                                                                                                                                                         |
| University logos                             | Included (13.7). Display is subject to management's decision on usage terms; keep the initials fallback for providers without a logo                                                                                                                                                                                                 |
| Logo dark variant, brand colour              | Not held; null                                                                                                                                                                                                                                                                                                                       |
| Academic entry requirements, specialisations | Not held; not returned                                                                                                                                                                                                                                                                                                               |
| Average tuition per provider                 | Not returned (no sound basis)                                                                                                                                                                                                                                                                                                        |
| Publishing                                   | Controlled by the provider Published switch. A provider switched off or archived disappears from every action with its courses and scholarships; remove it from the Wix cache at the next refresh. There is no separate course switch; a course reads published while its provider is published                                      |
| Register-only scholarships                   | Scholarships known only from a national register (for example Australia Awards) are not returned; scholarships come from provider pages                                                                                                                                                                                              |
| Known data-quality items                     | A few provider-page fees are wrong at source (for example a foundation programme showing about A\$230,000 a year); report odd values with the course_id and they are corrected at source. A course length is admitted only from words about the course itself, never from a fee basis such as “fee displayed is for 1 year of study” |
| Provider statistics (QILT)                   | Included at provider grain (13.4) for 116 Australian providers. Not held by field of study; no equivalent loaded for New Zealand or Canada                                                                                                                                                                                           |
| Institution type                             | Included (13.4) for Australia and New Zealand, from the TEQSA, CRICOS and NZQA registers. Canada is not typed yet (null). The national VET register (training.gov.au) is not used yet                                                                                                                                                |
| Matching prototype table shapes              | Not provided. Map v2 fields once in the Wix backend                                                                                                                                                                                                                                                                                  |

# 16. Wix platform considerations

- Scheduled-job frequency and quantity

- CMS item quotas

- Read/write quotas

- Request payload limits

- Backend timeouts

- Index limits

Design assumptions: backend-only calls, a response cache for live search, bulk cache writes, paged results (50 maximum), small CMS items, delta updates rather than full rewrites, and sync-state monitoring.

# 17. Error handling

| **HTTP**  | **Meaning**                                                                                                                   |
|-----------|-------------------------------------------------------------------------------------------------------------------------------|
| 200       | Success                                                                                                                       |
| 400       | INVALID_INPUT (malformed filter, page, page_size, sort, or missing identifier) or INVALID_ACTION (action not in the contract) |
| 401       | AUTHENTICATION_REQUIRED — invalid or missing key                                                                              |
| 404       | NOT_FOUND — course, provider or scholarship identifier not found                                                              |
| 429       | RATE_LIMITED — honour Retry-After                                                                                             |
| 503 / 5xx | Bounded service failure                                                                                                       |

On 429 or 5xx, do not clear Wix caches; serve last-known-good.

# 18. Developer testing and acceptance

| **\#** | **Test**               | **Expected result**                                                                                                                                                                    |
|--------|------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1      | Authentication success | Existing key returns 200 for reference with the v2 envelope                                                                                                                            |
| 2      | Authentication failure | Invalid key returns 401 and no data                                                                                                                                                    |
| 3      | v1 unchanged           | The same request without contract returns the v1 payload unchanged                                                                                                                     |
| 4      | Reference              | Vocabularies returned for AU, NZ and CA; cached with request ID                                                                                                                        |
| 5      | Keyword relevance      | keyword nursing, cities Melbourne: 109 courses on 14 Oct, nursing titles first; total stable across pages                                                                              |
| 6      | New filters            | The section 5 search example: every item has a February intake, an IELTS minimum at or below 6.5 and annual tuition at or below 45,000 (35 courses on 14 Oct)                          |
| 7      | Canada                 | country_codes \[CA\] returns 4,723 Canadian courses, each with a display_code (a StudySearch code such as SHER-BA-001 where no printed code exists)                                    |
| 7a     | Display code lookup    | course with course_code UNBC-BA-019 returns that course; display_code_kind is studysearch                                                                                              |
| 8      | Course detail          | course_code 082960F returns English by test, tuition with basis and linked scholarships; an unknown code returns 404                                                                   |
| 9      | University Finder      | providers with university_groups \[go8\] and sort qs_rank_asc returns 8 providers; provider returns detail with rankings                                                               |
| 9a     | QILT statistics        | provider provider:cricos:00025b returns outcomes_state admitted with 48 QILT rows, each with study_level_name and survey_name                                                          |
| 9b     | Institution type       | providers with country_codes \[AU\] and institution_types \[university\] returns 45 providers, each with institution_type code university; reference lists the eight types with counts |
| 10     | Scholarship Finder     | scholarships with student_types \[international\] returns 1,096 records with the requested fields in 13.5 under their requested names, nulls where not held                            |
| 10a    | Rankings               | rankings with system_codes \[qs_wur\], edition_year 2027, country_codes \[AU\] returns 38 providers with rank_display, indicators, attribution and terms_status                        |
| 10b    | Logos                  | providers with has_logo true returns 49 providers whose logo.url opens within 24 hours; the copy in Wix Media is served to visitors                                                    |
| 11     | Nulls                  | A field not held is null or empty, never a placeholder value                                                                                                                           |
| 12     | Delta sync             | changed_since with sort updated_asc returns only changed records; replay creates no duplicates                                                                                         |
| 13     | Rate limit             | 429 handling honours Retry-After                                                                                                                                                       |
| 14     | Frontend secret scan   | Key absent from browser bundles, page source, public CMS and client-side requests                                                                                                      |
| 15     | Schema tolerance       | An unknown optional field is ignored safely                                                                                                                                            |
| 16     | Production replay      | Tests 1–15 repeated with the Production key at go-live                                                                                                                                 |

# 19. Support and troubleshooting

- Wix environment

- contract (v1 or website-search-v2) and action called

- UTC/AEST timestamp

- StudySearch request ID

- HTTP status

- handover version

- filters sent (no personal data)

- current CF_SyncState status/cursor

- whether the issue affects live search, scheduled sync or cached reads

Never include the raw API key in support evidence.

# 20. Production cutover

- The StudySearch platform moves to customer-owned accounts by project transfer. The endpoint address stays the same.

- A separate Production Wix credential is created with an explicit owner and expiry/rotation policy, and sent by secure channel.

- Store it in Wix backend Secrets Manager in place of the Pilot key.

- Repeat the acceptance tests in section 18 with the Production key.

- Complete initial cache loads and delta-sync acceptance.

- The Pilot credential is revoked after the Production tests pass.

- Agree a retirement date for v1 once the website runs on v2.

- The next standalone handover version records the Production credential identity and any contract changes.

# 21. Change log (Version 2)

| **Date**    | **Change**                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 8 Oct 2026  | website-search-v2 released on Pilot: eight actions, rankings and logos (usage terms pending management), requested scholarship fields, Canada opened, operator-entered course links released                                                                                                                                                                                                                                                                               |
| 14 Oct 2026 | Course display_code added and accepted by the course action; course publication_status follows the provider Published switch; scholarships published only and read from provider pages (reference_code null); platform renamed StudySearch; QILT provider statistics admitted (provider and course detail); institution_type added to providers and course providers, with the institution_types filter and the reference list; coverage and acceptance values re-measured |
| 14 Oct 2026 | Section 14 re-measured after New Zealand and Canadian courses were enriched from their own course pages: study area, study level, duration, delivery mode and campuses added for New Zealand and Canada; a New Zealand campus region is returned only where it is proven (otherwise null); campus sentence and the delivery_modes note in 13.1 updated. No field, filter or action changed                                                                                 |
| 14 Oct 2026 | Two New Zealand course durations that had been read from a fee line were withdrawn (duration_months now null for them; New Zealand total 2,929); durations stated in semesters stay null. No field, filter or action changed                                                                                                                                                                                                                                               |
