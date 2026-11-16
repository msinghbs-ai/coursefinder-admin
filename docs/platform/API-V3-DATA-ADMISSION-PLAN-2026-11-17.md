# API v3 data admission: field lanes and 48-hour backend plan (17–18 Nov 2026)

**Requested by:** the Platform Admin, 16 Nov 2026 16:26 AEDT (target: data admission delivery on 20 Nov 2026).
**Owner:** S2 - SS Build session (PRs A to E, #1162, AER route and REQ-19, consolidated by the Platform Admin 16 Nov 2026 16:52). **Change control:** CF-247. **Register:** `docs/integrations/CONSUMER-REQUESTS.csv` (REQ-19, -52, -53, -57, -65, -67, -75, -76).
**Measured:** read only, project `fxcwkweaxjtknorudmwp`, 16 Nov 2026 16:27–16:40 AEDT (`set transaction read only`, 20 s limit).
**Unchanged:** PR 1 cutover (Mon 16 Nov 22:30), PR 2 cutover (Tue 17 Nov 22:30), the paste-file split (Wed 09:15) and Phase 5 (Wed 09:30).
**Status 16 Nov 2026 23:45 AEDT:** PR A and PR B ran live at 21:50 (Pilot #1184; section 3). PR 2 was cut over at 23:31 by this session under the Platform Admin's override of 21:23 (Pilot #1185). PR 1 is held for its tick-budget fix until Tue 17 Nov 22:30, by its own session. PR 3 is built (Pilot #1188) and its merge waits for the live rehearsal.

**Tuesday 17 Nov:**
- 07:30 AER round 3;
- 08:05 telemetry;
- 13:15 PR E;
- 22:30 PR 1 cutover, by its own session.

**Wednesday 18 Nov:** 13:30 PR C and PR D. The Tue 09:45 and 11:30 PR A/B slots are done.

## 1. Where each field stands

The schema for every field is already live (`20261115190000_api_v3_additive_schema`, 15 Nov). Every table and column is empty.

| Field | Live object | Rows today | Allowed values (live CHECK) | Owner |
|---|---|---|---|---|
| `study_load` (REQ-52, O25) | `catalogue.courses.study_load`, `study_load_source`, `study_load_evidence_id` | 0 of 35,700 active courses | `full_time` · `part_time` · `both`; source `register` · `provider_page` · `manual` | S2-CF |
| `empty_reason_code` (REQ-53) | `catalogue.courses.empty_reason_code` | 0 | `not_published_by_provider` · `not_listed_on_register` · `online_only_no_campus` · `pending_extraction` · `source_unavailable` | S2-CF |
| `campuses.is_primary` (REQ-75, R32, D-4) | `catalogue.campuses.is_primary`, `primary_basis` (at most one per provider) | 0 of 4,341 active campuses | basis `cricos_head_office` · `provider_stated` · `highest_course_count` · `manual` | S2-CF |
| `provider_accreditations` (REQ-57, R30, D-3) | `catalogue.provider_accreditations` | 0 | body `AACSB` · `EQUIS` · `AMBA`; status `active` · `expired` · `revoked` · `under_review` | S2-CF |
| `grade_scale_conversions` (REQ-18, -19, -28) | `ref.grade_scale_conversions` | 0 | normalised 0–100 per country, qualification and scale | **This session** (since 16 Nov 16:52; PR E, section 6) |
| `destination.*` (REQ-65, -67, -68) | `destination.editions`, `study_rules`, `city_profiles`, `career_outcomes` | 0 editions | edition status `draft` → `published`; terms `approved` · `pending` · `restricted` | Data and reference (scope decision open) |
| `ref.api_field_dictionary` (REQ-76, R33) | `ref.api_field_dictionary` | 1,923 (16 Nov) | loaded by Pilot #1162 (merged, migration `20261116110000`); 2 fields held for the paste file | **This session** (took over #1162) |

### What the data supports (measured)

- **Primary campus.** 1,556 CRICOS providers hold a registered head-office address. For **381**, it matches exactly one of their active campuses (same street line and postcode). For 7, it matches several. For 659, only the postcode matches one campus. 824 providers have a single campus.
- **Campus-null reasons.** 5,639 active courses have no campus. By their course page:
  - 395 are online-only;
  - 1,184 have a page that could not be read (blocked, fetch failed, refused, robots);
  - 731 have no page bound or not yet read;
  - 2,333 have a page that is not this course (identity mismatch or refused, not a course page);
  - 996 have a page that was read and names no campus.
- **Study load.** 2,671 courses already have a filled duration, intake or delivery reading whose stored quote or value states "full-time" or "part-time". Delivery mode is not study load (REQ-52 rule: never derived from online or on-campus).
- **Registrations are not accreditations.** `catalogue.provider_registrations` holds 3,103 regulator registrations (CRICOS 1,556, IRCC DLI 1,130, NZQA 417). None is a business-school accreditation, so AACSB, EQUIS and AMBA must come from each body's official list. (No live table holds 36,075 registrations; the nearest counts are 35,700 courses and 36,288 entry requirements.)

## 2. Field lanes in `pipeline.field_execution_registry` (PR 3, tonight)

PR 3 (Mon 16 Nov from 23:15) registers each field below as a declared lane: field, execution mode, owner, the function that fills it, and the `ref.api_field_dictionary` path it serves. **No new standalone cron job.** A lane is scheduled only through `coverage-lane-dispatch`, and only after its filling function has passed its own rolled-back dry run. Until then the lane is declared and `disabled`. New lanes start in shadow, under the same 24-hour rule as the legacy jobs.

| Lane | Execution mode | AI | Filling function (built in section 3) | Enabled when |
|---|---|---|---|---|
| `campus_is_primary` | Deterministic SQL (D-4 rule) | No | `security.campus_primary_apply_v1()` | PR A merged |
| `course_empty_reason` | Deterministic SQL | No | `security.course_empty_reason_apply_v1()` | PR A merged |
| `course_study_load` | Staged-attribute derivation, then targeted fallback | Stage 2 only | `security.course_study_load_stage1_v1()`; stage 2 through the existing `enrich_ai` reader | PR B merged |
| `provider_accreditations` | Reference list, then targeted extraction | Extraction only | `security.provider_accreditation_apply_v1(list)` | PR C merged |
| `grade_scale_conversions` | Deterministic SQL over a reference seed | No | `security.entry_grade_normalise_v1` (PR E) | scales approved by the Platform Admin |
| `destination_editions` | Reference seed, draft; published only with approved terms | No | `security.destination_import_v1` (PR E, drafts) | REQ-68 terms for publication |
| `api_field_dictionary` | Reference sync | No | `security.api_field_dictionary_sync_v1` (#1162, merged) | re-sync with PR D fields |

## 3. 48-hour sequence

Each PR follows the Pilot rules: md5-guarded edits, `-- Replaces:` / `-- Retires:`, G2 settings for every size or window, G3 consumer API check before and after, a `// Guards:` spec, the test register, and admin documents in the same release cycle.

Each PR's rolled-back live dry run (`begin … raise exception`, 20 s per statement) must show:

- what the run would write: counts by value and basis;
- no consumer API drift (`security.consumer_api_check_v1()`, 75 functions, 48 relations);
- no change to the website and Zoho v2 sync feeds: no `updated_at` is touched, and the sync deltas count the same before and after;
- that manual locks are respected (`manual_lock_guard`).

| When (AEDT) | PR | What | Expected result (from section 1) |
|---|---|---|---|
| Mon 16 Nov 23:15 | PR 3 (dispatcher, shadow) | `pipeline.field_execution_registry` with the lanes above (declared, disabled), plus `coverage-lane-dispatch` for the legacy coverage lanes | 0 rows written to any field. **Built 23:25 as Pilot #1188 (14 worker lanes in shadow, 7 field lanes disabled); merge waits for its live rehearsal.** |
| **Done Mon 16 Nov 21:50** (planned Tue 09:45) | **PR A** (release v2.16.15) | `security.campus_primary_apply_v1()`: `is_primary` = true, basis `cricos_head_office`, only where the registered head-office street line and postcode match exactly one active campus; a manual override always wins; else `is_primary` stays false. `security.course_empty_reason_apply_v1()`: campus-null reason per course, from its page state (mapping in section 4). Both are idempotent and record each change in `pipeline.admin_control_events` | `is_primary` on **381** providers; `empty_reason_code` on **5,639** courses **Live: 356 providers** (7 several matches and 1,193 no match left null; 354 counted by telemetry, 2 have no active course); **5,639 courses** (not published 5,104, online only 395, pending extraction 104, not on register 29, source unavailable 7) |
| **Done Mon 16 Nov 21:50** (planned Tue 11:30) | **PR B** (release v2.16.16) | `security.course_study_load_stage1_v1()`: `study_load` from stored readings that state full-time and/or part-time (source `provider_page`, `study_load_evidence_id` = the reading's evidence). Both stated → `both`. Delivery mode is never used. The stage 2 fallback is a lane on the existing `enrich_ai` reader (a study-load question added to the course-other-fields read, no new route), limited by its own setting | about **2,671** courses at stage 1; stage 2 runs on the existing lane under its caps **Live: 2,521 courses** at stage 1 (full time 1,413, part time 183, both 925; all with evidence); stage 2 off |
| **Done Mon 16 Nov 23:31** (planned Tue 22:30) | PR 2 cutover | Pilot #1185 under the Platform Admin's override of 21:23: 20 rules live, 20 legacy jobs off and retiring, G3 drift [] | — |
| Wed 18 Nov 09:15 / 09:30 | paste split; Phase 5 | unchanged | — |
| **Wed 18 Nov 13:30** | **PR C** (release v2.16.17) | Accreditations: the AACSB, EQUIS and AMBA official lists for AU, NZ and CA are read once through the on-demand gate (`security.on_demand_open_v1`, the estimate and credit given to the Platform Admin first). `security.provider_accreditation_apply_v1(list)` matches each listed school to a provider by exact official name or domain only; an unmatched or ambiguous name goes to Layer 4 and is never guessed. `source_url`, `verified_at` and `content_hash` are kept | rows only for exact matches (the AU lists hold tens of schools) |
| Wed 18 Nov, after PR C | **PR D** (v3 read path) | `website_v3_*` provider and course payloads read `is_primary` / `primary_basis`, `accreditations[]`, `study_load` and `empty_reason_code` (v3 is open to additions until go-live, Decision 277); the v3 contract specs and the field dictionary are re-synced | v3 serves the four fields; v2 unchanged |
| Thu 19 Nov | Measure and fix | Coverage before and after per field; Layer 4 items from PR C; the 08:15 report carries the counts | — |

## 4. Rules used (proposed for confirmation)

- **D-4 primary campus.** Uses `cricos_head_office` (exact street and postcode match to one campus) and `manual` only. `highest_course_count` and "first in list" are not used. A provider with no exact match keeps no primary campus (v3 shows null). Close to the brief's recommended option ("the provider's own statement only"), because the registered head-office address is the provider's own statement on the register. 824 single-campus providers are **not** marked unless their address matches (see decision 2).
- **Campus-null reason mapping.** One code per course; it explains why the course has no campus:

  | Page state | Code |
  |---|---|
  | online-only delivery | `online_only_no_campus` |
  | page blocked, fetch failed, refused, robots | `source_unavailable` |
  | no page bound or not yet read; page not this course | `pending_extraction` |
  | page read, no campus named | `not_published_by_provider` |
  | course not on its register (where the register lists campuses) | `not_listed_on_register` |

  A course with a campus has no code. The code is recomputed when the page state changes.
- **Study load.** Only from stated evidence (REQ-52): "full-time" → `full_time`, "part-time" → `part_time`, both → `both`. Never from delivery mode, a timetable or the CRICOS listing alone.

## 5. Decisions (Platform Admin, Mon 16 Nov 2026 16:52)

All API v3 and AER items for 20 Nov are consolidated in this session (S2 - SS Build): PRs A to D, Pilot #1162, the AER route and REQ-19.

1. **D-4, confirmed.** `is_primary` is true only on an exact registered head-office match to exactly one active campus (`primary_basis cricos_head_office`), or `manual`; otherwise null. PR A, Tue 09:45, about 381 providers.
2. **Single-campus providers (824): no** for 20 Nov. No new basis value and no paste file.
3. **REQ-19 owned here; common scale decided:** `normalised_0_100` is the **position on the qualification's own official scale**. 0 is the scale's minimum and 100 its maximum, flipped where lower is better. It is not an equivalence or ATAR claim. Schema and rules are in section 6 (PR E).
4. **Destination (REQ-65/67/68):** seed **draft** editions now, so the pipeline and the v3 schema are proven. They stay unpublished until Study Square approves terms. The publication guard (Pilot #1161) refuses anything else.
5. **Field dictionary (#1162): taken over and merged** (Pilot #1162, 16 Nov 2026 17:05 AEDT).
   - Migration re-versioned to `20261116110000`; the live head was `20261116100000`, so the old version would never have applied.
   - Paste file moved to admin `docs/paste/`.
   - Rolled-back live rehearsal: function bodies byte-identical, G3 unchanged.
   - Live read-back: 1,923 rows (759 website, 1,164 Zoho), function md5s match the file.
   - Drift against the live reference action shows only the two documented exceptions: `contract_version`, which the edge function strips, and `ranking_systems[].editions`, held for the paste file.
6. **AER route:** see `docs/platform/layer4-clearance-and-model-benchmark-2026-11-16.md` §6 (Qwen3 30B stopped on AER v1 entry reading; Mistral Small 3.2 provisional on the v2 shadow; long-page section reading; round 3).

## 6. PR E: grade scales (REQ-19) and destination draft editions (Tue 17 Nov, 13:15 AEDT)

**Live, 16 Nov (read only):**
- `catalogue.provider_entry_matrix`: 5,542 active rows, 22 providers, 521 qualification names.
  - 4,314 rows hold one number with a stated scale. The 25 largest qualification names hold 1,921 of them.
  - Scale labels: `points` 4,262, `none` 492, `percentage` 425, `gpa` 196, `letter` 139, `aggregate` 23, `rank` 5.
  - `points` covers different native scales (HKDSE, SAT out of 1600, Abitur 1.0 to 4.0 where lower is better), so a value is normalised per qualification, never per label.
- `catalogue.course_entry_requirements`: 36,288 rows with no grade scale, so they are out of scope for now.
- `ref.grade_scale_conversions` exists (country, qualification, board, scale, raw band, `normalized_0_100`) and is empty. Nothing reads it.

**Schema (additive; v3 surface, not frozen; G3 untouched):**

| Object | Purpose |
|---|---|
| `ref.qualification_scales` (new) | One official scale per qualification and board. Holds the scale code, minimum, maximum, `higher_is_better`, pass value, step, `source_url` (required), the source title and when it was checked. Status `draft` · `approved` · `retired`, with who approved it. |
| `ref.qualification_aliases` (new) | Maps each printed matrix qualification name (for example "Hong Kong - HKDSE", "HKDSE") to one qualification code. Basis `exact_name` or `manual`; approved before use. |
| `ref.grade_scale_conversions` (existing) | Band scales only (letter, division, level grades): one row per printed band, giving its position. A unique key on country, qualification, board, scale, band. |
| `catalogue.entry_grade_normalisations` (new) | Beside the matrix, keyed by matrix row. Holds the qualification code, scale, raw value, `normalised_0_100`, basis (`linear_scale` · `band_table`) and rule version `grade-norm-v1`, or a reason code when null. |

**Rule (`security.entry_grade_normalise_v1`, deterministic, zero AI, idempotent, writes only changes; lane `grade_scale_conversions`, no new cron job):** a value is written only when all of these hold:
1. The printed qualification name has an exact, approved alias.
2. Its scale is `approved` and has an official `source_url`.
3. The row's scale is stated (not `none`).
4. `min_grade` is one number, or an exact band label of an approved band table.
5. The number lies within the scale's minimum and maximum.

The value is `(v - min) / (max - min) x 100`, or `(max - v) / (max - min) x 100` where lower is better, rounded to one decimal. When any condition fails, the value is null with a reason: `no_alias`, `scale_not_approved`, `scale_not_stated`, `not_single_number`, `out_of_range` or `band_not_found`.

**Seed:** the scales of the largest matrix qualifications, each from its issuing body's official page, as `draft`:
- HKDSE, STPM, CBSE, ISC, SAT, ACT, Abitur;
- Sri Lanka and Singapore A Levels, South Africa NSC, French Baccalaureat;
- CSAT, Gaokao, Vietnam HSGC, Kenya KCSE;
- Norway, Sweden, UEC, British Columbia, Matrikulasi.

The Platform Admin approves them from one list (scale, minimum, maximum, direction, source). Nothing is normalised from a draft scale.

**API v3 (in PR D, if scales are approved by then):** `min_grade_normalised` and `normalisation_basis` beside `min_grade` and `scale` on v3 entry rows. Null means not held. The field dictionary is re-synced for the new fields.

**Destination drafts:** one small AU draft edition per domain (study rules, city profiles, career outcomes) from official sources, loaded with `security.destination_import_v1`. Terms are `pending` and status `draft`. The publication guard must refuse to publish them.

## 7. Daily admittance telemetry (Platform Admin 16 Nov 2026 20:17; Pilot #1183, migration `20261116170000`)

**Contract (the single source for reporting live admittance to the developers):**
- **Where it is recorded:** `pipeline.field_coverage_daily`, one row per day (Melbourne date), country and field, with `total` and `filled`.
  - `security.field_coverage_record_v1` writes it inside the existing `platform-health` job. That check runs every 3 hours, and the last value of a day stands. 120 days are kept.
  - **No new job, table or column.** The rollup scheduler (PR 1) is not involved.
- **What is counted:** `security.api_v3_field_coverage_v1()`, with indexed aggregates only. "Admitted" means:

  | Field | REQ | Eligible (denominator) | Admitted |
  |---|---|---|---|
  | `v3_study_load` | REQ-52 | active courses | `study_load` held |
  | `v3_empty_reason` | REQ-53 | active courses with no campus | `empty_reason_code` held |
  | `v3_campus_primary` | REQ-75 (D-4) | providers with an active campus | one campus marked primary |
  | `v3_accreditations` | REQ-57 (D-3) | providers with active courses | an active AACSB, EQUIS or AMBA accreditation |
  | `v3_grade_normalised` | REQ-19 | active entry matrix rows | 0 until PR E adds its normalisation table; PR E replaces this line |
  | `v3_destination` | REQ-65, 67, 68 | destination rows (AU) | rows in a published edition with approved terms |
  | `p_entry_matrix` | core | providers with active courses | an active entry matrix row |
  | `p_registrations` | core | providers with active courses | a regulator registration |

  Existing fields (`official_url`, `description`, `academic_entry`, `english`, `intakes`, `provider_tuition`, `registered_tuition`) keep their own definitions (`pipeline.course_attribute_coverage`, state `admitted`).
- **Daily gain:** `security.api_v3_daily_admittance_v1(date)` returns `admitted`, `yesterday_admitted`, `daily_admitted_gain` (today minus yesterday), `eligible` and `pct`, per field, with REQ ids.
- **Sheet:** the tab `API_v3_Daily_Admittance` in `StudySearch_Pipeline_Telemetry_Live` keeps one row per field per day as history. The 08:05 refresh task appends to it, and its summary feeds the 08:15 report.
- **Cost:** the new counts take 1.1 s, and the whole recording pass takes 1.06 to 2.8 s. Dry run, 16 Nov.
- **Gain for the new fields** first appears on 17 Nov, once there is a 16 Nov row to compare.

**Baseline, 16 Nov 2026 20:49 AEDT (live, read only):**

| Field / table | REQ | Admitted | Eligible | Complete | Gain, last 24 h | Next scheduled fill |
|---|---|---|---|---|---|---|
| `courses.study_load` | REQ-52 | 0 | 35,700 active courses | 0.0% | 0 | PR B, Tue ~11:30 (about 2,671 with stated evidence) |
| `courses.empty_reason_code` | REQ-53 | 0 | 5,639 courses with no campus (AU 31, CA 1,604, NZ 4,004) | 0.0% | 0 | PR A, Tue 09:45 |
| `campuses.is_primary` | REQ-75 (D-4) | 0 | 1,692 providers with an active campus | 0.0% | 0 | PR A, Tue 09:45 (about 381 by registered head office) |
| `provider_accreditations` | REQ-57 (D-3) | 0 | 1,882 providers | 0.0% | 0 | PR C, Wed 13:30 |
| `grade_scale_conversions` (normalised entry rows) | REQ-19 | 0 | 5,542 active matrix rows (4,314 single numbers) | 0.0% | 0 | PR E, Tue 13:15 (draft scales); values after your approval, PR D Wed |
| `destination.*` | REQ-65, 67, 68 | 0 published | 0 rows | — | 0 | PR E, Tue 13:15 (AU drafts, unpublished until REQ-68) |
| `ref.api_field_dictionary` | REQ-76 | 1,923 current | 1,923 fields | 100% | +1,923 (loaded 16 Nov) | re-sync in PR D |
| `official_course_url` | core | 23,983 | 35,700 | 67.2% | +3 | continuous |
| `course_descriptions` | core | 14,217 | 35,700 | 39.8% | +3,352 | continuous (prompt v3) |
| `course_entry_requirements` (admitted academic entry) | core | 1,326 | 35,700 | 3.7% | 0 | AER v1 off; round 3 Tue 07:30 decides v2 |
| `course_entry_requirements` (courses with any row) | core | 11,687 | 35,700 | 32.7% | — | as above |
| `entry_matrices` (providers) | core | 22 | 1,882 | 1.2% | 0 | AER v1 off |
| `course_fees`: provider tuition / registered tuition | core | 10,790 / 25,200 | 35,700 / 25,380 | 30.2% / 99.3% | 0 / 0 | continuous |
| `provider_registrations` (providers) | core | 1,882 | 1,882 | 100% | 0 (3,103 registrations) | continuous |
