# Website API v3 – build brief from the consumer request consolidation

**Version:** 1.1 (12 Nov 2026; reconciled with `API-V3-FIELD-DEFINITION.md`)
**Change control:** CF-247 · **Decisions:** 266 (consumer API frozen), 277 (Website API v3 beside a frozen v2)
**Owner:** Platform Admin. **Built by:** any continuous build session, through the single integrator.
**Companion files (this folder):** `CONSUMER-REQUESTS-REGISTER-2026-11-12.csv` (all 83 requests, REQ-01 to REQ-83), `NEXT-SESSION-PROMPT.md` (paste into a build session).
**Register of record:** `docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md` (repo items R1–R34, O1–O31). This brief does not replace it; it says what goes into v3 and in what order.


> **Read with `API-V3-FIELD-DEFINITION.md` (v0.1, release 1 built on Pilot #1085, not released).** That document is the v3 field contract and wins on field names. Since this brief was written:
> - **D-1 is settled by the build:** Zoho gets `zoho-api-v3` beside a frozen `zoho-api-v2` (option a). WP-4 items are Z1–Z4 in the register.
> - **Already in v3 release 1:** WP-0 (copy, dispatchers, release switch `api.v3_released`), WP-0.3 R28, WP-1.1 R23, WP-1.2 R24, WP-1.7 O26. D-5 is therefore answered (rebuilt in v3; close the v2 draft).
> - **Update 12 Nov 2026 22:10 AEDT:** WP-0 (Pilot #1084, with R28) and WP-1.1 R23 / WP-1.2 R24 (Pilot #1088, merge `514cb3bd`, migration `20261113190000`) are merged and live on `website-api-v3`. The v2 drafts Pilot #945 and #954 are closed unmerged (D-5); Admin draft #386 (v2 Issue 8 for R23/R24) is closed as superseded. #1085 (Zoho v3, dispatchers, `api.v3_released`, O26) is still a draft, so D-1 is built but not deployed. Next in order: WP-1.3 R29.
> - **Update 12 Nov 2026 22:50 AEDT:** WP-1.3 R29 (Pilot #1091, merge `90092e42`), WP-1.4 R31 and WP-1.7 O26 (Pilot #1092, merge `e09beb14`) are merged and live. Still to build: WP-1.5 (O20), WP-1.6 (O22), WP-2.1 (OET, CELPIP), WP-6 guide; WP-1.8, WP-3 and the Zoho items wait for their decisions. #1085 is still a draft.
> - **Update 12 Nov 2026 23:30 AEDT:** WP-1.5 O20 (Pilot #1093), WP-1.6 O22 (Pilot #1097; duplicate #1094 closed), WP-2.1 OET and CELPIP (Pilot #1099) and the F-SCH scholarship detail fields (Pilot #1098; v2 draft #1077 closed) are merged and live. Remaining without a decision: WP-6 v3 developer guide. Waiting for decisions: WP-1.8 (D-4), WP-3 (D-2, D-3), Zoho items, and whether OET letter grades may be stored.
> - **Still to build in v3 (as first written):** WP-1.3 R29 paging, WP-1.4 R31, WP-1.5/1.6, WP-2.1 OET/CELPIP, Z1, Z3, Z4; after decisions: R30 (D-3), R32 (D-4), study load and admission tests (D-2).
> - Live check 12 Nov 2026: no `website_v3_call` or `zoho_v3_call` on the production database yet, and no `api.v3_released` setting row. Release 1 is built but not deployed.

---

## 1. Why this brief exists

On 12 Nov 2026 the Platform Admin asked for every field request since the project started to be collected from email, checked against the live system, and turned into one build list. The sources were:

- emails from Divya (Zoho), Raghav (website), Sujata and Saurabh, 14 May to 11 Nov 2026;
- Raghav's PDFs: API data request (14 Sep), NZ audit response (20 Oct), Australia data gaps (24 Oct), Australia data team handoff (2 Nov);
- the Platform Admin's own replies and commitments (28 Aug field handover, 3 Nov six commitments).

Each request was checked against the deployed consumer functions (`website_v2_*`, `api.website_v2_*`, `zoho_v2_*`) and live data on 12 Nov 2026. Result: 83 requests, 34 delivered, 20 partly delivered, 18 open, 9 needing a new field, 2 declined.

Decision 277 (12 Nov 2026, 21:00) puts every new consumer field into Website API v3. v3 is open to additions and merges on green until the website goes live on it. This brief is the v3 build list.

## 2. Rules every v3 change follows

1. **v2 is not touched.** Nothing in `website-search-v2`, `website_v2_*`, `api.*`, `website_api_v2_*` or the Zoho functions is altered, dropped, renamed or retyped. The G3 guard and S57 must stay green.
2. **v3 is a copy.** Own edge function `website-api-v3`, own database functions `public.website_v3_*` (and `api.website_v3_*` helpers if needed), same data, keys, authentication, rate limit and request log as v2. v3 starts as v2 plus repo R28 (`intakes[].start_date_status`).
3. **Additions only, merged on green.** Until the website goes live on v3, a v3 addition does not need the G3 approval line or the comms hold.
4. **Record each addition** in `WEBSITE-DEVELOPER-REQUIREMENTS.md` (status column and History) and in the v3 developer guide's change list.
5. **Null means not held.** No defaults, estimates or currency conversion. Every new field states its null meaning (see WP-6).
6. **Data first, then API.** Where a field needs new data (a new table or reader), the data design is a Platform Admin decision; the API exposure follows once data is admitted. These items are marked **Decision needed** below.
7. **Standard release gates apply:** full suite 0 failed / 0 skipped, md5-guarded functions, dry run on live, immediate production acceptance on a bounded workload, change-control entry.

## 3. Work packages

### WP-0 Create the v3 copy (prerequisite)

| Item | What | Acceptance |
|---|---|---|
| WP-0.1 | `website-api-v3` edge function: copy of `website-api-v2` with `API_VERSION = "website-v3"` and calls to `website_v3_*` | Same nine actions; every v2 contract test passes against v3 with only `api_version` different |
| WP-0.2 | `public.website_v3_*` functions as wrappers over the v2 functions, so v3 starts identical | Byte-equal `items` for 20 sampled courses, providers and scholarships |
| WP-0.3 | Repo R28 `intakes[].start_date_status` (already approved, v3 only) | Values exactly as the R28 table in the register |
| WP-0.4 | v3 key issue path and the v3 developer guide skeleton (`developer-pack/StudySearch-Website-API-v3-Developer-Guide.md`) | Guide lists v3 additions in its change list |

### WP-1 Expose data already held (no new data; merge on green)

| v3 item | Request(s) | Repo item | Change in v3 | Data held today (12 Nov) |
|---|---|---|---|---|
| WP-1.1 Campus names and course counts | REQ-45, REQ-49, REQ-81 | R23 (draft branch `cf247-devapi-r23-r24`, built for v2) | Provider `campuses[]`: add `campus_id`, `campus_name`, `course_count`. Rebuild the R23 branch as `website_v3_*`; do not merge it into v2 | All 4,341 campuses named; Zoho provider detail already sends name and count |
| WP-1.2 Nationality eligibility status | REQ-05 | R24 (same draft branch) | Scholarship: `nationality_eligibility_status` = `restricted` / `unrestricted` / `unknown` / `under_review`; empty list never means unrestricted | 144 of 1,202 published name countries |
| WP-1.3 Scholarship linked-course paging | REQ-73 | **R29 (new)** | `scholarship` action takes optional `courses_page`, `courses_page_size` (1–200); returns `linked_courses_total`, keeps `linked_courses_truncated`. No paging = first 200, as v2 | 176 of 1,053 linked scholarships exceed 200; max 563; about 22,300 links cut today |
| WP-1.4 Scholarships page link and last reviewed date per provider | REQ-46 | **R31 (new)** | Provider: `scholarships_page_url`, `scholarships_last_reviewed_at` | `pipeline.scholarship_listing_pages` (url, read_at) |
| WP-1.5 Source on entry matrix | REQ-28 | O20 | `entry_matrix[]` items gain `quote`, `source_url`; `resolution.rows[]` gains `source_url` | Held; not returned |
| WP-1.6 Academic entry in search | REQ-28 | O22 | `search` filter `has_academic_entry`; optional `edu_country` on `search` | 1,289 matrix rows, 16 providers, 83 countries |
| WP-1.7 Description excerpt in search items | REQ-61 | O26 | Search items: `description_excerpt` (first 240 characters, whole words) | 3,391 active courses with a description |
| WP-1.8 Primary campus | REQ-75 | **R32 (new)** | Provider `campuses[]`: `is_primary` (true for the campus the provider names as main, else null). Never "first in list" | Data rule needed: see Decision D-4 |

### WP-2 New reference rows (small data change, then API)

| v3 item | Request(s) | Repo item | Change | Note |
|---|---|---|---|---|
| WP-2.1 OET and CELPIP | REQ-55 | O14 | Two rows in `ref.english_tests`; readers pick them up from the English policy pages; returned in `english_requirements[]` with `test_code` `OET` / `CELPIP` | O14 lists more tests (LanguageCert, Michigan, CAEL and others): add OET and CELPIP first, as asked on 11 Nov |

### WP-3 New fields that need a data design (Decision needed before build)

| v3 item | Request(s) | Repo item | Proposed shape | Why a decision |
|---|---|---|---|---|
| WP-3.1 Study load | REQ-52 | O25 | Course `study_load` = `full_time` / `part_time` / `full_or_part_time` / null | New catalogue field and reader; the destination Courses rule depends on it |
| WP-3.2 Admission tests | REQ-54 | O18 | Course `admission_tests[] {test_code, min_score, scale, required, quote, source_url}`; codes UCAT, GAMSAT, GMAT, GRE first | New entry kind or table; reader and review |
| WP-3.3 Business school accreditations | REQ-57 | **R30 (new)** | Provider `accreditations[] {body: AACSB/EQUIS/AMBA, scope, source_url, checked_at}`; `triple_crown` worked out, not stored | New provider table; source is each body's official list (about 50–60 providers) |
| WP-3.4 Qualification list by country | REQ-18, REQ-28 | O21 | `reference.qualifications[] {country_code, code, name, scale}` | Country packs (Decision 276) are the home |
| WP-3.5 Common grade scale | REQ-19 | — | `min_academic_score_pct` (0–100) beside the printed score, only where a published conversion exists | Conversion rules per country are policy |

### WP-4 Zoho path (Decision needed: D-1)

Decision 277 covers the Website API only. Zoho reads `zoho_v2_*`, which is frozen. These Zoho requests have no path until D-1 is decided:

| Zoho item | Request(s) | Change |
|---|---|---|
| Z-1 Scholarship summary in course search | REQ-31 | Search items gain `scholarships[] {scholarship_id, name, amount_type, amount_value, currency}` (top 5) |
| Z-2 English test columns in the course export | REQ-34 | Add TOEFL, CAE, DET (overall and band) columns |
| Z-3 Export countries | REQ-35 | `zoho.sync_countries` setting from `["AU"]` to `["AU","NZ"]` (setting only, no code; still a consumer change) |
| Z-4 Country of previous education on course detail | REQ-28 | `edu_country` on `course`, as Website v2 already has |

### WP-5 Data work, not API (tracked, not built here)

REQ-02, 05, 07, 08, 16, 39, 53, 60, 61, 62, 63, 64, 69, 70, 71 and repo O31: fields exist in the API but coverage is low. These are enrichment, scholarship reading and intake programme work.

### WP-6 Developer guide for v3

| v3 item | Request(s) | Repo item | What |
|---|---|---|---|
| WP-6.1 Field dictionary | REQ-76 | **R33 (new)** | v3 guide gains one table: every field, type, allowed values and its null meaning (`unknown`, `not_applicable`, `not_collected`) |
| WP-6.2 Answers already due | REQ-30, REQ-11, REQ-25, REQ-26, REQ-29, REQ-33 | — | Section "Where to find it": the four scholarship link rules; study_levels instead of six flags; server-side English and intake filters; provider_name search; scholarship value field names; multi-CRICOS provider lookup |

## 4. Order

1. WP-0 (copy and R28), then WP-1.1 and WP-1.2 (the two 3 Nov commitments still open), then WP-1.3.
2. WP-1.4 to WP-1.7 and WP-2.1.
3. WP-6 guide issue with everything above.
4. WP-3 items one at a time, each after its decision.
5. WP-4 after D-1.

## 5. Decisions needed from the Platform Admin

| # | Decision | Options | Recommendation |
|---|---|---|---|
| D-1 | How Zoho gets new fields | (a) Zoho API v3 beside a frozen Zoho v2, same rules as Decision 277; (b) Zoho reads Website API v3 for detail and keeps zoho-v2 for sync and export; (c) Zoho stays on v2 and asks for approved v2 additions | (a): same model as the website, one rule for both consumers |
| D-2 | Data design for WP-3.1 study load and WP-3.2 admission tests | Approve the shapes above, or change them | Approve; both are on the destination template for all 28 countries |
| D-3 | Accreditations (WP-3.3) in scope | Yes as provider table / No | Yes: small, official lists, asked by the website |
| D-4 | Primary campus rule (WP-1.8) | Provider's own "main campus" statement only / metro area with most campuses / leave null | Provider's own statement only; else null |
| D-5 | R23 and R24 draft branch | Rebuild in v3 / close the v2 draft | Rebuild in v3; close the v2 draft with a note |

## 6. Comms (once WP-0 to WP-1.3 are live in v3)

- **Raghav:** v3 address and guide; campus names and counts; nationality status; scholarship course paging; Ranking Journey can be switched on (history with bands, ties and accepted editions is already in v2, repo R25); use course detail to check one course's scholarships.
- **Divya:** answers in WP-6.2 (no API change needed for five of her 3 Nov questions); WP-4 once D-1 is decided.

## 7. Evidence (12 Nov 2026, live)

- Deployed: `website-api-v2` v3, `zoho-api-v2` v5; no `website_v3_*` function or v3 edge function yet.
- Scholarship item already returns `study_levels_source`, `deadline_is_rolling`, `age_min`, `age_max`, `reference_code`, `renewable`, `min_academic_score` with scale (REQ-74, REQ-78 delivered in v2).
- `website_v2_scholarship` caps `linked_courses` at 200 (`limit 200`) with `linked_courses_truncated`.
- `api.website_v2_provider_campuses` returns city, postcode, subdivision, metro area and regional category only.
- `zoho_v2_export_page` course columns: `ielts_overall, ielts_band, pte_overall` only; `zoho.sync_countries` = `["AU"]`.
- `website_v2_provider_rankings` returns `rank_display`, `rank_low`, `rank_high`, `is_tied`, accepted editions only; NZ universities QS 2021–2027, THE 2016/17–2026.
- Provider contacts exist: 3,054 contact points and 31 named contacts at 11 providers (Zoho provider detail and export).

## History

| Version | Date | Change |
|---|---|---|
| 1.4 | 12 Nov 2026 | O20, O22, OET/CELPIP and the F-SCH scholarship fields live (Pilot #1093, #1097, #1099, #1098). |
| 1.3 | 12 Nov 2026 | R29, R31 and O26 live in v3 (Pilot #1091, #1092). |
| 1.2 | 12 Nov 2026 | WP-0, R23 and R24 live on `website-api-v3` (Pilot #1084, #1088); v2 drafts #945, #954 and Admin #386 closed (D-5); #1085 still draft. |
| 1.1 | 12 Nov 2026 | Reconciled with the v3 field definition: D-1 and D-5 settled by the build; built and remaining items listed at the top. |
| 1.0 | 12 Nov 2026 | First issue: 83 consumer requests consolidated; v3 work packages WP-0 to WP-6; decisions D-1 to D-5. |
