# StudySearch – Website and Zoho API v3: field contract

**Version:** 0.1 (12 Nov 2026) · **Change control:** CF-247 · **Decisions:** 277 (API v3 beside a frozen v2), 266 (consumer API frozen)
**Asked by:** Platform Admin, 12 Nov 2026 21:13: "API v3 is getting prepared - any new field that needs programming or missing in v2 should defined, added to v3 and be ready for website and zoho, refer to developer requriements in admin repo".
**Inputs:** `WEBSITE-DEVELOPER-REQUIREMENTS.md` v2.11 (R23, R24, R28, O13–O31), `2026-11-12-destination-sources-aer-api-gap-review.md`, `2026-11-12-destination-sources-course-api-gap-review.md`, the F-SCH developer field contract (Pilot #1077, held under the v2 freeze).

## 1. What v3 is

- **Website API v3** (`website-api-v3`, `public.website_v3_*`) and **Zoho API v3** (`zoho-api-v3`, `public.zoho_v3_*`) return everything v2 returns, with the same keys and meanings, plus the fields below.
- v2 stays frozen (G3, Decision 266). Nothing in this contract changes v2.
- v3 is open to additions until the website (and Zoho) go live on it (Decision 277). At go-live the Platform Admin records the date and v3 joins the frozen surface. So **every field the website or Zoho will need is defined now**, even where the data is not held yet: the developers map each field once, and the data programmes fill it later without a v4.
- Rules carried from v2: the provider Published switch decides what is returned; null (or an empty list) means not held; nothing is inferred, converted or estimated; the API never decides eligibility.
- The same API keys work on v3 (website key for `website-api-v3`, Zoho key for `zoho-api-v3`). Every call is logged as on v2.

## 2. Fields

**Status:** **Held** = the data is in the platform today and v3 release 1 returns it. **Defined** = the field is in v3 from release 1 and returns null or [] until its data programme fills it. Zoho column: where Zoho v3 returns the same field.

### 2.1 Course (actions `course`, `search`, `sync` course items; Zoho course lookup and search)

| # | Field | Type | Meaning | Status | Source / data programme | Zoho |
|---|---|---|---|---|---|---|
| R28 | `intakes[].start_date_status` | enum | Why `start_date` is null, from the closed list in the requirements register (`known`, `no_official_calendar`, `month_only`, `not_on_course_page`, `course_page_not_verified`, `next_year_calendar_pending`, `not_yet_read`, `own_calendar`, `conflicting_evidence`, `held_for_review`, `rolling`) | Held | `pipeline.course_intake_dates` (`next_action`, `reason`) | Yes |
| O26 | `summary` (search items) | text | The course description cut at a sentence end, at most `website.v3_summary_chars` characters; null when no admitted description | Held (10% of courses, growing about 1,370 a day) | Admitted description (F-CDESC) | Yes |
| O20 | `entry_matrix[].quote`, `entry_matrix[].source_url`; `entry.resolution.rows[].source_url` | text | The printed words of the requirement and the official page it was read from | Held | Admitted AER rows and their evidence | Yes |
| O21 | `entry_matrix[].qualification_code` | text | The qualification's code (for example `CBSE_XII`, `GCE_A`) where the row is linked to one; the printed `qualification` is unchanged | Held (39 qualifications) | `ref.aer_qualifications` | Yes |
| O22 | `has_academic_entry` (search items); filters `has_academic_entry`, `edu_country` on `search` | boolean; filter | Whether an admitted academic requirement exists for the course (for `edu_country` when given) | Held | `security.entry_resolve_v1` | Yes |
| O19 | `entry_matrix[].condition_type`; `entry.conditions[]` {`type`, `text`, `quote`, `source_url`} | enum; list | `grade` (today's rows) or a non-grade condition: `credential_check` (APS, NAWA, UNEDasiss), `foundation_required` (Studienkolleg, preparatory year), `entrance_exam` | Held for `grade`; others Defined | AER v2 country packs | Yes |
| O25 | `study_load`; filter `study_loads` | enum `full_time`, `part_time`, `both` | Study load the course page states | Defined | Enrich fields reader, new catalogue field | Yes |
| O17 | `teaching_languages[]` | ISO 639-1 codes | Languages the course is taught in | Defined | Course page reader | Yes |
| O15 | `english_requirements[].level` {`framework`, `level`} | object | A requirement stated as a level (CEFR B2, Sweden English 6, TOPIK 4, JLPT N2, TDN 4); `score` may then be null | Defined | English policy and course page readers | Yes |
| O13, O14 | `english_requirements[].language` | ISO 639-1 | The language the test examines (`en` for today's five tests); the test list grows in `reference` (no new key per test) | Held for `en`; more tests Defined | `ref.english_tests` grows | Yes |
| O16 | `english_waivers[]` {`basis`, `country_codes[]`, `quote`, `source_url`} | list | Waiver of the language test by country of previous education (`country_of_education`) or English-medium study (`english_medium_study`) | Defined | English policy reader | Yes |
| O18 | `admission_tests[]` {`test_code`, `requirement`, `min_score`, `quote`, `source_url`} | list | SAT, ACT, GMAT, GRE, UCAT, GAMSAT, LNAT, and others; `requirement` `required`, `optional`, `test_optional` | Defined | Course page reader; reference list | Yes |
| O23 | `application` {`route_code`, `route_name`, `route_url`, `places_limited`} | object | National or central application route (UCAS, uni-assist, OUAC …) and limited places; the deadline stays in `intakes[]` | Defined | Country reference data | Yes |
| O27 | `work_rights` {`stream`, `length_months`, `regional_extension_months`, `basis`, `as_at`} | object | Post-study work right from the official rule for the course's level and campus region (485, PSWV, PGWP) | Defined | Official rule tables as reference data (Decision 261) | Yes |
| O28 | `field_of_study_codes[]` {`scheme`, `code`, `name`} | list | The field-of-study code in each scheme (`ASCED`, `CIP`, `NZSCED`); `study_area` is unchanged | Held for ASCED; CIP and NZSCED Defined | Crosswalk reference data | Yes |
| O30 | `study_area_outcomes[]` {`measure`, `value`, `year`, `source`} | list | Outcomes for the course's study area (QILT study area) | Defined (needs QILT written permission) | QILT study-area data | Yes |

### 2.2 Provider (actions `provider`, `providers`, `sync` provider items; Zoho provider search and campus lookup)

| # | Field | Type | Meaning | Status | Source | Zoho |
|---|---|---|---|---|---|---|
| R23 | `campuses[]` items gain `campus_id`, `campus_name`, `course_count` | list | One item per campus, its name and how many published courses it teaches | Held | Campus register | Yes (campus lookup) |
| O29 | `recognition[]` {`register`, `listed`, `status`, `as_at`} | list | Official listings that decide visa or work rights (NZQA, DLI with PGWP status, ILEP, CROHO, MQA …) | Defined | Each destination's register (O24) | Yes |

### 2.3 Scholarship (actions `scholarships`, `scholarship`, `sync` scholarship items; Zoho scholarship search and lookup)

| # | Field | Type | Meaning | Status | Source | Zoho |
|---|---|---|---|---|---|---|
| R24 | `nationality_eligibility_status` | enum `restricted`, `unrestricted`, `unknown`, `under_review` | Whether the scholarship is limited by nationality; an empty list is never `unrestricted` | Held (live 12 Nov: restricted 154, unknown 1,048) | Scholarship nationality reader | Yes |
| F-SCH | `excluded_nationality_codes[]`, `nationality_regions[]` | lists | Nationalities excluded; regions kept as regions | Held | Same | Yes |
| F-SCH | `description`, `award_type`, `sponsor`, `programme`, `award_code`, `benefits[]`, `application` {`method`, `url`, `rolling`}, `award_duration`, `academic_year` | mixed | The verified scholarship details stored beside the consumer table | Held (award type 944, benefits 1,006 of 1,202) | F-SCH extraction v3 | Yes |

### 2.4 Reference (action `reference`; Zoho filter options and reference bundle)

| # | Field | Status |
|---|---|---|
| O21 | `qualifications[]` {`code`, `name`, `country_code`, `level`} | Held |
| O13, O14 | `language_tests[]` {`code`, `name`, `language`, `scale`} (today's five English tests; grows) | Held |
| O15 | `language_level_frameworks[]` {`code`, `levels[]`} (CEFR, TOPIK, JLPT, TDN, Sweden English) | Defined |
| O18 | `admission_tests[]` {`code`, `name`} | Defined |
| O23 | `application_routes[]` {`code`, `name`, `url`, `country_code`} | Defined |
| R28 | `start_date_statuses[]` (the closed list with its meaning) | Held |
| O24 | New destinations appear in `countries[]` as their data is loaded; no new key | Not an API change |

## 3. Not in v3 (by decision)

R11 logo dark variant and brand colour (not held), R13 average tuition and R27 university-level costs (no sound basis), R14 prototype table shapes (by decision), O31 coverage of existing fields (data work, not an API change).

## 4. Build

| Release | What | Guard |
|---|---|---|
| v3.0 | `website-api-v3` and `zoho-api-v3`; every action of v2 with the same answers; every field in section 2 present (Held fields filled, Defined fields null or []); its own sync change stream so a change to a v3-only field reaches `sync` | Contract test `cf-247-website-api-v3-contract` asserts every v2 key is kept and every section 2 key is present; v2 contract tests unchanged |
| v3.x | Each Defined field filled as its data programme admits data | No key change; a new enum value or a new key is a contract change under Decision 277 until go-live |
| Go-live | The Platform Admin records the date; v3 joins the frozen surface (G3, `tests/uat/consumer-api-baseline.json`, `consumer-api-guard`) | s57 |

Developer communication: the v3 developer guide (website) and Zoho guide are issued from this contract when v3.0 is live; section 13 lists the v3 additions against v2.

Held PRs this contract absorbs (they were prepared for v2, which is now frozen): Pilot #945 and #954 (R23, R24), Pilot #1077 (F-SCH scholarship fields and R24). Their content is built in v3; they are not merged into v2.

## History

| Version | Date | Change |
|---|---|---|
| 0.1 | 12 Nov 2026 | First issue: every field missing from v2 defined for v3 (Held or Defined), for the website and Zoho (Platform Admin 21:13). |
