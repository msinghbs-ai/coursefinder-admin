# Website API v2 — developer request of 2 November 2026: assessment, proposed additive change and approval record

**Status:** PROPOSED — awaiting Platform Admin approval. **Nothing is deployed.** Nothing is merged, no consumer API baseline is re-taken and no production data was written.
**Mandate:** `2026-11-03-website-api-v2-developer-request-mandate-1146.md` (Platform Admin, 3 Nov 2026 11:46). **Change control:** CF-247. **Rules:** G3 (Decision 266, consumer API frozen), Decisions 257/258 (Website API v2 additive only).
**Prepared on:** Pilot branch `cf247-website-api-v2-campus-nationality` at `b5a9408d` (not merged; migration file md5 `e843fbe64d1d416e6034a2eec0ad2788`; `supabase/migrations/20261103180000_cf247_website_api_v2_campus_nationality.sql`, spec `tests/uat/cf-247-s239-website-api-v2-campus-nationality-contract.spec.mjs`, fixtures `tests/fixtures/website-api-v2-campus-nationality/`).
**Evidence:** live project `fxcwkweaxjtknorudmwp`, read-only SQL, 3 Nov 2026 11:48–12:17 AEDT (heavy reads in minutes :x6–:x8).
**Developer pack draft:** `docs/integrations/developer-pack/drafts/issue-8/` (Issue 8, marked PROPOSED — not live). The published Issue 7 pack is unchanged.

## 1. Classification of the five requests

| # | Request | Classification | Evidence (live, 3 Nov 2026) | Outcome |
|---|---|---|---|---|
| 1 | Campus names and course counts | **Missing API functionality** (data held) | `catalogue.campuses` holds a name and a stable key for every campus; the provider campus list merges every campus with the same city, postcode, state and regional class: 3,808 campuses returned as 3,296 items across 1,620 providers; 256 providers (AU 228, NZ 20, CA 8) lose campuses (University of Auckland 8 → 1; George Brown College 4 → 1). No name, identity or count is returned | Additive change prepared (§2), approval needed |
| 2 | Scholarship nationality eligibility | **Missing API functionality** (the status) **and missing or incomplete data** (the readings) | 1,148 published scholarships: 78 have nationality codes in the list the API returns, 1,070 an empty list; 16 more have an extracted nationality criterion the list does not carry; 0 have explicit "any nationality" evidence | Additive status prepared (§3); reading quality is platform enrichment work (§3.5) |
| 3 | Ranking history | **Existing API functionality requiring documentation** | `provider` detail `rankings[]` returns every accepted edition; `rankings` filters by `edition_year`. QS WUR accepted 2021–2027 (7 editions), THE WUR 2016–2026 (11 editions; 2015 rejected) | No API change; guide example (§4) |
| 4 | Academic entry requirements | **Existing API functionality requiring documentation** plus **platform enrichment requirement** | `entry`, `entry_matrix[]`, `edu_country` live since issue 5. Admitted: provider tables 663 rows, 13 providers; course rows 1,304 for 480 courses (13 providers). Awaiting Layer 4: 1,760 provider rows (15 providers), 2,168 course rows (499 courses) | No API change; hide-unavailable guidance; coverage reported separately (§5) |
| 5 | University-level costs | **Not supported because a reliable data basis is unavailable** | No institution-published cost-of-living or compulsory non-tuition cost is held at university level (no table or column). Held at course level only: CRICOS registered non-tuition fees (26,726 active rows, Australia only, a registered course total) and computed tuition ranges per provider (`provider_fee_ranges`, 1,219) — neither is an approved cost definition | `not available`; nothing added (§6) |

No field is proposed to compensate for a data-coverage gap.

## 2. Campus names and course counts — proposed additive change (C1)

### 2.1 Field contract (provider `campuses[]`, in `providers`, `provider` and the `sync` provider item)

| Field | Type | Meaning |
|---|---|---|
| `campus_id` | string | The campus's stable public identifier (the StudySearch campus key, e.g. `campus:cricos:00122a:point-cook-campus-raaf-williams-base`). Never changes for a campus; use it as the key |
| `campus_name` | string or null | The campus name as stored (for Australian campuses the CRICOS location name; New Zealand and Canada from the provider's own pages). `null` where no name is held (0 on 3 Nov 2026) |
| `course_count` | integer ≥ 0 | Distinct courses the API returns (published provider, active course, not held back by Layer 4) linked to this campus. A course offered at three campuses counts once at each. `0` is a real value: the campus is held but no returned course is linked to it |

Unchanged: `city`, `postcode`, `subdivision_code`, `metro_area`, `regional_category`, `regional_category_name` — same keys, same values. The same campuses are included as before (a city is held and the campus is not inactive).

**Behaviour change (additive in shape):** one item per campus by stable identity. Campuses that share a city or postcode are no longer merged. With the three new keys removed, the distinct items equal the items returned before for all 1,620 providers (checked live). A consumer that de-duplicated by city keeps working; the list can be longer.

Items are ordered by campus name (blank names last), then `campus_id` (today: no order guarantee; `jsonb_agg(distinct …)` order).

### 2.2 Affected functions

| Function | Change | Before md5 (live, 3 Nov 2026) | After md5 (fixture) |
|---|---|---|---|
| `api.website_v2_provider_campuses(uuid)` | whole replacement, md5-guarded (`replace_once`) | `57115d3b8ddbc40729ec04078ee15d41` | `698afad0bc236a314fb356632938c403` |
| `public.website_v2_providers`, `public.website_v2_provider`, `public.website_v2_sync` (provider items) | none: they call the function above | unchanged | unchanged |
| Edge functions (`website-api-v2`, `wix-course-api`) | none: pass-through | unchanged (baseline file keeps its hashes) | unchanged |

Read and guarded but not changed: `security.place_presentable(text)` `a7b720fc9b34203d0a23315376fd483a`; view `security.layer4_search_blocked_courses` `35cdaa19a775ffaaf60fc2be302affec`.

### 2.3 Validation against the Admin campus/course view (live, read-only)

Admin (Providers › detail › Campuses, `security.admin_provider_detail`) counts every `course_campuses` link, including campuses with no city and courses no longer active. The API count is the same rule restricted to what the API returns. All 49,331 links on campuses the API returns: 47,907 counted; 1,424 links (904 courses) are to inactive courses, which the API does not return. No link was to another provider's course or to a Layer 4-held course. The sum of `course_count` over all providers is 47,907.

| Country | Provider | Items before → after | Σ course_count | Admin links on the same campuses | Courses returned for the provider | Difference explained |
|---|---|---|---|---|---|---|
| AU | TAFE NSW | 55 → 57 | 721 | 756 | 105 | 35 links to inactive courses |
| AU | RMIT University | 5 → 6 | 590 | 592 | 507 | 2 links to inactive courses (Melbourne 439→438, Brunswick 31→30) |
| AU | The University of Queensland | 5 → 5 | 441 | 441 | 383 | none |
| NZ | University of Auckland | 1 → 8 | 359 | 359 | 458 | none (99 courses have no campus link) |
| NZ | Ara Institute of Canterbury | 2 → 7 | 86 | 86 | 178 | none |
| NZ | Te Wānanga o Aotearoa | 7 → 7 | 4 | 4 | 85 | none |
| CA | George Brown College | 1 → 4 | 36 | 63 | 49 | 2 Admin campuses have no city (10 links, not returned before or after); the rest are inactive courses |
| CA | University of British Columbia | 2 → 4 | 317 | 317 | 575 | none |
| CA | Conestoga College | 6 → 7 | 139 | 142 | 270 | 3 links to inactive courses |

The count is always the held links, never the provider's catalogue. In the nine samples no campus count equals the provider's whole catalogue. Across all providers, 891 Australian campuses at providers with more than one campus have a count equal to the provider's whole returned catalogue: these providers register every course at every location on CRICOS (for example the state school departments), and each link is held. That is the published registration, not a fallback. Campuses with `course_count` 0: AU 1, NZ 46, CA 13.

**Not collapsed by city or postcode:** University of Auckland's eight campuses all have city Auckland; George Brown's four all have Toronto. Note for data quality (not an API matter): 5 New Zealand campus pairs at 2 providers look like the same campus held twice ("City" / "City Campus", "Grafton" / "Grafton Campus", "Newmarket" / "Newmarket Campus" at Auckland; "Hamilton" / "Hamilton campus", "Tauranga" / "Tauranga campus"). They have different stable keys, so they are returned as two campuses each, as held. They belong to the platform's campus identity work (merge through the governed campus process), not to the API.

### 2.4 Performance (live, read-only; database time)

| Sample | Before (merged) | After (prepared) |
|---|---|---|
| 50 providers with the most campuses, AU | 38 ms total, max 7.9 ms | 298 ms total (≈6 ms each), max 21 ms (Department of Education, 208 campuses) |
| 50, NZ | 8 ms, max 0.5 ms | 80 ms, max 11.9 ms |
| 50, CA | 6 ms, max 0.3 ms | 61 ms, max 9.9 ms |

The count is one grouped read per provider (never one read per campus). An earlier draft that anti-joined the whole Layer 4 view took 52 ms for the largest provider (the view was built each call); the prepared version checks the view per course link (15 ms in EXPLAIN ANALYZE). Impact: a `providers` page of 50 of the largest Australian providers gains about 0.3 s of database time; a typical page under 0.1 s. `provider` detail gains at most about 0.02 s. `sync` serves stored items, so the full load is not slower to serve, but provider items grow: provider campus JSON across all providers 560 KB → 1,184 KB (+0.6 MB on about 113 MB uncompressed for a full load).

### 2.5 Course search and detail `campuses[]` — assessment (not prepared)

The course item already returns one entry per campus link (no merging) with `is_primary`; adding `campus_id` and `campus_name` there would be additive and would let Wix join a course to a provider campus. It is **not prepared** because it is not clearly the same scope of safety: the same builder (`api.website_v2_course_item`) also feeds Zoho (`public.zoho_v2_course_search`, `security.zoho_sync_item_v1`), so the change would reach the Zoho consumer too, and it would touch about 37,300 course items in every Wix full load. **Recommendation:** approve C1 now; decide course `campuses[]` `campus_id`/`campus_name` separately (decision P3 below), with the Zoho owner informed. No `course_count` on course campuses (it has no meaning there).

### 2.6 Exact before and after JSON (live, 3 Nov 2026)

University of Auckland (`provider:nzqa:7001`), before:

```json
"campuses": [ { "city": "Auckland", "postcode": null, "metro_area": null, "subdivision_code": "NZ-AUK", "regional_category": null, "regional_category_name": null } ]
```

After (prepared; first three of eight shown):

```json
"campuses": [
  { "city": "Auckland", "postcode": null, "campus_id": "campus:studysearch:e096aba7-e1eb-4903-9a63-2bfb71e9a8b8:city", "metro_area": null, "campus_name": "City", "course_count": 53, "subdivision_code": "NZ-AUK", "regional_category": null, "regional_category_name": null },
  { "city": "Auckland", "postcode": null, "campus_id": "campus:studysearch:e096aba7-e1eb-4903-9a63-2bfb71e9a8b8:city-campus", "metro_area": null, "campus_name": "City Campus", "course_count": 219, "subdivision_code": "NZ-AUK", "regional_category": null, "regional_category_name": null },
  { "city": "Auckland", "postcode": null, "campus_id": "campus:studysearch:e096aba7-e1eb-4903-9a63-2bfb71e9a8b8:grafton", "metro_area": null, "campus_name": "Grafton", "course_count": 7, "subdivision_code": "NZ-AUK", "regional_category": null, "regional_category_name": null }
]
```

RMIT University (`provider:cricos:00122a`), before: 5 items (Brunswick, Bundoora, East Bendigo, Melbourne, Point Cook). After: 6 items; Melbourne becomes two campuses, "RMIT University - 124 Latrobe Street, Melbourne" (`course_count` 438) and "Melbourne Cricket Education Academy - 124 La Trobe St MELBOURNE VIC 3000" (1). Full before/after for all three examples: `docs/integrations/developer-pack/drafts/issue-8/examples/campuses-before-after.json`.

## 3. Nationality — proposed additive status (N1)

### 3.1 Field contract (`scholarships` items, `scholarship` detail, `sync` scholarship items)

`nationality_eligibility_status`: string, always present, one of:

| Value | Rule (first that applies) | Source evidence | Live count (3 Nov 2026) |
|---|---|---|---|
| `under_review` | An open Layer 4 item on who the scholarship is for (fields `nationalities`, `nationality`, `citizenship_eligibility`, `audience`, `student_type`, status pending), or a pending AI review whose reason is "who it is for is not proven by a quote on the page" | Layer 4 queue state | 0 |
| `restricted` | `citizenship_eligibility` names at least one country or region code; or an active extracted nationality criterion names countries (with its quote) even where the list is still empty; or the scholarship is for domestic students only | Nationality reading phrases (e.g. "citizen of India"), extracted criteria with `human_text` quotes, student type criteria | 94 (AU 82, NZ 10, CA 2); 16 of them with an empty list; 14 with a region code |
| `unrestricted` | No code, and the nationality reading holds an explicit "any nationality" phrase | An explicit quote such as "open to students of all nationalities" | 0 (no reader writes this evidence yet) |
| `unknown` | Otherwise: nothing on nationality is held | — | 1,054 |

**An empty list is never `unrestricted`.** Domestic-only awards: 0 published today (726 are for both, 422 for international students); the rule is in place. International-student eligibility without a nationality ("open to international students") is `unknown` for nationality, with `student_type` `international`: it says who may apply by residency status, not that every nationality is eligible.

**Region codes keep their region meaning.** `citizenship_eligibility` may hold `R-ASEAN`, `R-SASIA`, `R-PACIFIC`, `R-EUROPE`, `R-MENA`, `R-LATAM` and others (11 region terms). They are never expanded into countries; a scholarship "for students from South Asia" stays `R-SASIA`.

`citizenship_eligibility` and `eligible_countries_list` are unchanged.

### 3.2 Affected function

| Function | Change | Before md5 | After md5 (fixture) |
|---|---|---|---|
| `api.website_v2_scholarship_item(uuid)` | one md5-guarded edit (one inserted key after the two lists) | `d1792cc7161101ce8c22abad70ecbd36` | `04532402307717c6dab17567551364e1` |

`public.website_v2_scholarships`, `public.website_v2_scholarship` and `sync` call it; the filter is unchanged.

### 3.3 Before and after JSON (live values, 3 Nov 2026)

| Scholarship | Before | After adds |
|---|---|---|
| Faculty of Engineering Research Scholarship for South Asia (The University of Sydney) | `"citizenship_eligibility": ["R-SASIA"], "eligible_countries_list": ["R-SASIA"], "student_type": "international"` | `"nationality_eligibility_status": "restricted"` |
| University of Auckland China High Achievers Scholarship | `["CN"]`, `["CN"]` | `"restricted"` |
| UTS Southeast Asia International Scholarship | `[]`, `[]` (criterion "Be a citizen of one of the following countries in the Southeast Asia region…" held) | `"restricted"` (list stays `[]`) |
| University of Auckland MBChB Graduate Entry – International Student Scholarship | `[]`, `[]`, `"student_type": "international"` | `"unknown"` |

### 3.4 Existing `nationality_codes` filter — verified (read-only)

- The filter matches exactly the list the API returns: every published scholarship has a nationality reading, and both the list and the filter use it. There is no disagreement between the list and the filter.
- **False exclusions against the extracted source criteria:** 16 scholarships whose extracted criteria name countries but whose list is empty are never found by the filter (e.g. "UTS Southeast Asia International Scholarship": criteria ID, KH, LA, MM, MY, PH, SG, TH, TL, VN; filter VN does not return it). 19 more have criteria naming more countries than the list (227 country pairs missed; e.g. a scholarship for "India, Sri Lanka, Bangladesh, Bhutan, Nepal or Pakistan" lists only IN).
- **Region:** filter `VN` does not return `R-ASEAN` scholarships (14 hold a region). This is by design (no expansion); the website should also send the region code for the student's region (guide draft §7.5).
- **False restrictions:** at least 4 University of Wollongong awards say "be either a citizen of India or an international student" and are listed `IN` (open to every international student); 3 awards "for citizens of South Asia, Southeast Asia or China" are listed `R-SASIA` only; one says "preference will be given to" and is listed as a restriction.
- **Meaning to document:** the filter returns scholarships that name the nationality; it does not return `unknown` or `unrestricted` ones. A "scholarships I may be eligible for" view combines the filter with `unknown` items shown as "check eligibility with the provider".

### 3.5 Platform enrichment requirement (not an API change; not done by Claude)

Improve the existing job `scholarship-nationality` (`security.scholarship_nationality_read_v1`, reader `scholarship-nationality-v1`, every 10 minutes) so that it: takes the countries of active extracted nationality criteria with their quotes (closes the 16 + 19); reads alternatives ("or an international student") and preference wording as not restrictive; writes explicit "any nationality" evidence (key `ANY`) when the page states it; and routes unclear wording to Layer 4 (which makes `under_review` meaningful). This is a separate CF-247 change through the scholarship pipeline and Layer 4. Scholarship records are not enriched by hand.

## 4. Rankings — reconciled, no change

| System | Accepted editions | Providers with an accepted entry (not hidden) | From the first edition | With a missing year |
|---|---|---|---|---|
| QS World University Rankings | 2021–2027 (2024 and 2025 each have a superseded re-load) | 72 | 64 | 6 (e.g. University of the Sunshine Coast 2022–2025, 2027; Toronto Metropolitan University 2022, 2023, 2025–2027) |
| THE World University Rankings | 2016–2026 (2015 rejected) | 77 | 57 | 2 (University of Guelph no 2018; St. Francis Xavier University 2022, 2025, 2026) |

The developer's statement (QS from 2021, THE from 2016) matches the accepted editions; each institution's history depends on when it was ranked.

**Adelaide University** (`provider:cricos:04249j`): QS 2026 (=82), QS 2027 (79), THE 2026 (133), all exact name matches. Nothing earlier is linked to it. The University of Adelaide (`provider:cricos:00123m`; QS 2021–2025, THE 2016–2025) and the University of South Australia (`provider:cricos:00121b`; QS 2021–2025, THE 2016–2025) are archived and hidden, so their rankings are not returned. Their history is not attributed to Adelaide University, and must not be.

The existing API satisfies the request: `provider` `rankings[]` (every accepted edition) and `rankings` with `edition_year`. Attribution and `terms_status` (approved) unchanged. Guide example added in the draft (§7.6).

## 5. Academic entry requirements — no API change

`entry`, `entry_matrix[]`, `edu_country` and the existing metadata are unchanged; no parallel API. Coverage (live, 3 Nov 2026), separate from any release: admitted provider tables 663 rows (13 providers); admitted course rows 1,304 (480 courses, 13 providers); awaiting Layer 4: 1,760 provider rows (15 providers) and 2,168 course rows (499 courses); sources read 99 pages for 33 providers. The AER programme (source discovery, reconciliation, readers, D-R2/D-R3, governed Layer 4 admission) continues as platform work; this proposal promises nothing about coverage. Guide draft adds hide-unavailable rendering guidance.

## 6. University-level costs — not available

No institution-published cost-of-living or compulsory non-tuition cost is held as separately evidenced platform data. What is held is course-level: provider tuition (`tuition`, with currency, basis and year, unchanged) and, for Australia, the CRICOS registered non-tuition fee and estimated total course cost (a registered course total, not a living cost; not returned). No average tuition is introduced (R13 stands). A future cost feature needs its own approved definition (category, audience, location, currency, effective year, source, basis).

## 7. Impact analysis

| Area | C1 campuses | N1 nationality status |
|---|---|---|
| Compatibility | Existing keys and values unchanged; more items where campuses shared a city (256 providers); order defined | One new key; every other field identical (fixture: 11 scholarships byte-identical apart from the new key) |
| Performance | +≈6 ms per provider (max 21 ms); a 50-provider page of the largest +≈0.3 s | Two indexed EXISTS checks per scholarship; negligible |
| Cache | Wix collections: provider items change once (new keys and items) — the sync change check sends about 1,600 provider upserts in the next pass; no cursor reset | About 1,150 scholarship upserts once |
| Pagination | Unchanged (campuses are inside the provider item; the providers list is paged as before) | Unchanged |
| Visibility | Same campuses; counts only returned courses (hidden providers, inactive courses and Layer 4 holds excluded) | Published scholarships only, as before |
| Zoho | Not affected (Zoho does not read provider campuses) | Not affected (Zoho scholarships use their own function) |
| Edge functions | None changed; edge baseline file unchanged | None |

## 8. Test plan, release and rollback

**Done on the branch (no deploy):** fixture harness `tests/fixtures/website-api-v2-campus-nationality/run.sh` (live definitions loaded and md5-checked; the migration refuses without approval and changes nothing; with approval it applies, a second run changes nothing; campus identity, counts, exclusions, blank names, unchanged existing values; every nationality case including region, criteria-only, domestic-only, explicit any, open review, closed review); targeted specs s239, s32, s42, s57, s120, website-api-v2 contract and institution type contract: 38 passed.

**After approval (mandate §7):** record the decision and field contracts here and in the design reference decision log; replace the PENDING line with the approval line and add the baseline re-take; create the approval setting; run the full suite; re-read live md5s (they must still be the "before" values above); dry-run in a rolled-back transaction on live and compare `providers`, `provider`, `scholarships`, `scholarship`, `rankings`, `sync`; deploy through the release; verify representative payloads and Wix read-back; reissue the developer pack as Issue 8 (draft prepared).

**Rollback:** forward recovery by a migration that restores the two "before" definitions (texts in `tests/fixtures/website-api-v2-campus-nationality/live/`), md5-guarded on the "after" values, with a baseline re-take. Wix keeps working (new keys are ignored; extra campus items stay until the next sync).

## 9. Approval record (to be completed by the Platform Admin)

Decisions requested:

- **P1 — C1 provider campuses:** approve the additive `campus_id`, `campus_name`, `course_count` and one item per campus (no city/postcode merging). Yes / No.
- **P2 — N1 nationality status:** approve the additive `nationality_eligibility_status` with the four definitions in §3.1. Yes / No.
- **P3 — course `campuses[]`:** add `campus_id` and `campus_name` to course search/detail campuses (also reaches Zoho). Recommended: decide later, after P1 is live. Yes / Later / No.
- **P4 — nationality reader improvement (§3.5)** as platform enrichment work. Yes / No.

On approval, the migration's first line becomes:

```
-- Consumer API change approved: Platform Admin, <date time> (Website API v2 developer request, mandate 3 Nov 2026 11:46; decisions P1 and P2 in admin docs/platform/nz-enrichment-brief/2026-11-03-website-api-v2-change-proposal.md §9): additive campus_id, campus_name, course_count on provider campuses[] (one item per campus) and nationality_eligibility_status on scholarships; no removal, rename or retype
```

and its last step becomes `select security.consumer_api_rebaseline_v1('<decision>: additive provider campus fields and nationality_eligibility_status; approved Platform Admin <date time>');`.

The approval gate setting (created by the Platform Admin's approval paste, not by the migration):

```sql
insert into pipeline.platform_toolset_settings(toolset_key, key, label, kind, value, min_value, max_value, unit, section, used_by, help, reason)
values ('pipeline', 'api.v2_campus_nationality_approved', 'Website API v2 campus and nationality fields: approved', 'number', '1', 0, 1, 'flag',
        'Website API', 'migration 20261103180000 (approval gate)', '1 = the Platform Admin approved the additive change (proposal §9). The migration refuses to apply otherwise.',
        '<Platform Admin approval, date time>');
```

| Field | Value |
|---|---|
| Approved by | |
| Date and time | |
| Decisions | P1 ☐ P2 ☐ P3 ☐ P4 ☐ |
| Conditions | |
| Release version | (set at release) |
