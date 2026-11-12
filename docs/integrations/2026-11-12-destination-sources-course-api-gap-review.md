# Destination data sources: course fields missing from Website API v2 (review)

| | |
|---|---|
| Date | 12 November 2026 |
| Reviewed | `Study-Square-destination-data-sources_1.xlsx`: Read me (Courses rule, Data rule), Template map, Country overview, and the course rows of all 28 country sheets |
| Against | Website API v2 as live on 12 Nov 2026 (`website_v2_course`, `website_v2_course_search`) and the catalogue behind it, measured over the 34,041 courses the API serves (`search.course_documents`) |
| Scope | Course fields other than academic entry and tests. Entry, language and admission tests and the application route are already reviewed in `2026-11-12-destination-sources-aer-api-gap-review.md` (O13–O24) and are not repeated here |
| Status | Review only. Nothing in the API is changed. Each item that changes what the website reads needs Platform Admin approval under Decision 266 (G3). Items are tracked as O25–O31 in `WEBSITE-DEVELOPER-REQUIREMENTS.md` |

## 1. What the spreadsheet asks of a course

- **Courses rule (Read me):** only on-campus, full-time courses at bachelor's level and above. Fully online, distance and part-time courses are left out on every destination.
- **Every country sheet:**
  - "Study mode filter: on-campus, full-time courses only" → `courses (study_mode)`, To load, on all 28 destinations.
  - "Courses, fees, English and entry requirements, intakes" → `courses` (Australia, Loaded) or `<cc>_courses` (To load).
- **"Work rights shown for every course"** on 23 country sheets.
  - The right depends on the course: its level, its field of study, its length, or whether it is on an official list.
  - Examples: Australia Temporary Graduate visa (485) length by qualification, with a regional extension; New Zealand Post-Study Work Visa by qualification (`nz_pswv_qualifications`); Canada PGWP fields of study by CIP code (`ca_pgwp_cip_eligible`); USA STEM OPT by CIP code (`us_stem_cip`); Ireland ILEP listing and NFQ level; Denmark state-approved programmes; Sweden at least two semesters; Malta MQF level.
- **Course recognition** on non-AU/NZ/CA sheets: Germany accredited programmes, Netherlands CROHO register, Malaysia MQA register, UAE federal accreditation, Ireland ILEP, Denmark state approval.
- **Outcomes:** QILT Student Experience and Graduate Outcomes are loaded at institution and study-area grain (`qilt_institution_metrics`, `qilt_area_benchmarks`). UK "Undergraduate courses with satisfaction, continuation, graduate jobs" is at course grain.

## 2. What the API returns today (live, 12 Nov 2026)

- **Course detail fields:**
  - `description`, `study_level`, `study_area` (ASCED code and name), `duration_months`, `delivery_modes[]`, `campuses[]` (with `regional_category`), `intakes[]` (with `start_date`, `application_deadline`), `tuition` and `tuition_history[]`, `english_requirements[]`, `entry`, `scholarships[]`, `official_url`.
  - At provider grain: `provider_outcomes[]` (QILT), `provider.institution_type` and `provider.ranking_summary`.
- **Search results** (`website_v2_course_search`) carry no description.

**Coverage of the fields that exist,** across the 34,041 courses served:

| Field | Courses with a value | Share |
|---|---:|---:|
| Study area | 33,823 | 99% |
| Duration | 27,510 | 81% |
| Tuition (sample of 1,000) | 723 | 72% |
| Delivery mode | 21,321 | 63% |
| English requirements | 20,482 | 60% |
| Intakes | 13,360 | 39% |
| Official course link | 13,032 | 38% |
| Description | 3,388 | 10% (about 1,370 a day are being admitted; see F-CDESC) |
| Exact start date | 2,519 | 7% |
| Academic entry | 875 | 3% (AER programme) |
| Application deadline | 281 | 1% (R28 explains why) |

## 3. Missing fields and data

| # | Missing | Why the website needs it | API today |
|---|---|---|---|
| O25 | **Study load: full time / part time** (`study_load` or `attendance_modes[]`) | The Courses rule filters every destination to full-time, on-campus study. For international students, CRICOS registration implies full time, but the field is not stated per course for New Zealand or Canada, and part-time variants exist | `delivery_modes[]` (on campus, online, blended) only. No study-load field in the catalogue either (`catalogue.courses` has `delivery_mode`, no attendance column) |
| O26 | **Description in search results** (`description` or a short `summary` on search items) | Course Finder cards show a text excerpt. Today the website fills it with its own generic text (the clipped examples of 11 Nov were Website-side) | Detail only (`description`). Search items have no description field |
| O27 | **Post-study work right per course** (`work_rights {stream, length_months, basis, regional_extension_months}`), derived from level, campus region and the official rules | Shown for every course on 23 sheets. For Australia the inputs are held (`study_level`, `campuses[].regional_category`), but the 485 rule table (`psw_base_durations`, `psw_regional_locations`) lives only in the website's prototype database | Not returned. The rule tables are not in the platform |
| O28 | **Field-of-study code in the scheme each country's rule uses**: CIP (Canada PGWP, USA STEM OPT); NZSCED or the NZQF level (New Zealand); ASCED is held for Australia | PGWP and STEM OPT eligibility is decided by CIP code. Without it, "eligible for post-study work" cannot be shown for Canada or the USA | `study_area` carries an ASCED-style code for every country. No CIP or NZSCED crosswalk |
| O29 | **Official recognition / listing flags** (`recognition[] {register, listed, as_at}`): NZQA-approved, PGWP-eligible institution (DLI with PGWP status), ILEP, CROHO, MQA, state-approved (DK), accredited (DE, AE) | Decides work rights and visa eligibility on several destinations | Not returned. For AU, CRICOS registration is implied by the course existing. Canada DLI PGWP status is held in the prototype (`ca_institutions`), not the platform |
| O30 | **Course-level or study-area outcomes**: QILT by study area (`qilt_area_benchmarks`); UK Discover Uni at course grain | The template shows satisfaction and graduate outcomes beside the course | `provider_outcomes[]` at provider grain only (R8); `national_benchmark` is null on every row |
| O31 | **Coverage gaps in fields that already exist** (table above), notably description 10%, official link 38%, intakes 39%, exact start 7%, deadline 1% | A field that exists but is mostly null reads as missing on the website | Platform data work (F-CDESC, intake programme, link recovery), not an API change. Reported here so the developer knows null means "not held yet" |

## 4. Not missing (checked)

- **Provider category** (TEQSA "Australian University", etc.): returned as `provider.institution_type` with `basis` (R9).
- **Rankings** (QS, THE): returned (R6, R25).
- **Scholarships**: returned per course (R3, R7).
- **Campus region for the regional 485 extension**: returned as `campuses[].regional_category`.
- **Course level** (bachelor's and above for the Courses rule): returned as `study_level.code`, and the website filters on it.

## 5. Suggested order (for the Platform Admin)

1. **O26 description on search items.** The data is held and is growing daily. It is an additive field, but needs approval under Decision 266.
2. **O25 study load.** It is a new catalogue field read from the course page by the existing Enrich fields reader, then returned in the API (additive). It is the gate for the Courses rule on every destination.
3. **O27 / O28 work rights.** Bring the official rule tables (485, PSWV, PGWP CIP list, STEM CIP list) into the platform as reference data, add the CIP / NZSCED crosswalk, then return a derived `work_rights`. Each is official reference data, loaded under Decision 261 (registers first).
4. **O30 study-area outcomes.** QILT study-area data needs the same written permission as the provider data.
5. **O29 recognition flags.** These come with each new destination's register (O24).
