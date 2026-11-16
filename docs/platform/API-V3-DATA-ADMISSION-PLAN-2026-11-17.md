# API v3 data admission: field lanes and 48-hour backend plan (17–18 Nov 2026)

**Requested by:** the Platform Admin, 16 Nov 2026 16:26 AEDT (target: data admission delivery on 20 Nov 2026).
**Owner:** Course Module session (S2-CF). **Change control:** CF-247. **Register:** `docs/integrations/CONSUMER-REQUESTS.csv` (REQ-19, -52, -53, -57, -65, -67, -75, -76).
**Measured:** read only, project `fxcwkweaxjtknorudmwp`, 16 Nov 2026 16:27–16:40 AEDT (`set transaction read only`, 20 s limit).
**Unchanged:** PR 1 cutover (Mon 16 Nov 22:30), PR 2 cutover (Tue 17 Nov 22:30), the paste-file split (Wed 09:15) and Phase 5 (Wed 09:30).

## 1. Where each field stands

The schema for every field is already live (`20261115190000_api_v3_additive_schema`, 15 Nov). Every table and column is empty.

| Field | Live object | Rows today | Allowed values (live CHECK) | Owner |
|---|---|---|---|---|
| `study_load` (REQ-52, O25) | `catalogue.courses.study_load`, `study_load_source`, `study_load_evidence_id` | 0 of 35,700 active courses | `full_time` · `part_time` · `both`; source `register` · `provider_page` · `manual` | S2-CF |
| `empty_reason_code` (REQ-53) | `catalogue.courses.empty_reason_code` | 0 | `not_published_by_provider` · `not_listed_on_register` · `online_only_no_campus` · `pending_extraction` · `source_unavailable` | S2-CF |
| `campuses.is_primary` (REQ-75, R32, D-4) | `catalogue.campuses.is_primary`, `primary_basis` (at most one per provider) | 0 of 4,341 active campuses | basis `cricos_head_office` · `provider_stated` · `highest_course_count` · `manual` | S2-CF |
| `provider_accreditations` (REQ-57, R30, D-3) | `catalogue.provider_accreditations` | 0 | body `AACSB` · `EQUIS` · `AMBA`; status `active` · `expired` · `revoked` · `under_review` | S2-CF |
| `grade_scale_conversions` (REQ-18, -19, -28) | `ref.grade_scale_conversions` | 0 | normalised 0–100 per country, qualification and scale | **AER session** |
| `destination.*` (REQ-65, -67, -68) | `destination.editions`, `study_rules`, `city_profiles`, `career_outcomes` | 0 editions | edition status `draft` → `published`; terms `approved` · `pending` · `restricted` | Data and reference (scope decision open) |
| `ref.api_field_dictionary` (REQ-76, R33) | `ref.api_field_dictionary` | 0 | built by Pilot #1162 (open): 1,923 fields | **v3 integration session** (#1162) |

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
| `grade_scale_conversions` | Reference seed | No | (AER session) | REQ-19 decision and AER owner |
| `destination_editions` | Reference seed, published only with approved terms | No | (data and reference) | REQ-65/67 scope and REQ-68 terms |
| `api_field_dictionary` | Reference sync | No | `security.api_field_dictionary_sync_v1` (#1162) | #1162 merged |

## 3. 48-hour sequence

Each PR follows the Pilot rules: md5-guarded edits, `-- Replaces:` / `-- Retires:`, G2 settings for every size or window, G3 consumer API check before and after, a `// Guards:` spec, the test register, and admin documents in the same release cycle.

Each PR's rolled-back live dry run (`begin … raise exception`, 20 s per statement) must show:

- what the run would write: counts by value and basis;
- no consumer API drift (`security.consumer_api_check_v1()`, 75 functions, 48 relations);
- no change to the website and Zoho v2 sync feeds: no `updated_at` is touched, and the sync deltas count the same before and after;
- that manual locks are respected (`manual_lock_guard`).

| When (AEDT) | PR | What | Expected result (from section 1) |
|---|---|---|---|
| Mon 16 Nov 23:15 | PR 3 (dispatcher, shadow) | `pipeline.field_execution_registry` with the lanes above (declared, disabled), plus `coverage-lane-dispatch` for the legacy coverage lanes | 0 rows written to any field |
| **Tue 17 Nov 09:45** | **PR A** (release v2.16.15) | `security.campus_primary_apply_v1()`: `is_primary` = true, basis `cricos_head_office`, only where the registered head-office street line and postcode match exactly one active campus; a manual override always wins; else `is_primary` stays false. `security.course_empty_reason_apply_v1()`: campus-null reason per course, from its page state (mapping in section 4). Both are idempotent and record each change in `pipeline.admin_control_events` | `is_primary` on **381** providers; `empty_reason_code` on **5,639** courses |
| **Tue 17 Nov 11:30** | **PR B** (release v2.16.16) | `security.course_study_load_stage1_v1()`: `study_load` from stored readings that state full-time and/or part-time (source `provider_page`, `study_load_evidence_id` = the reading's evidence). Both stated → `both`. Delivery mode is never used. The stage 2 fallback is a lane on the existing `enrich_ai` reader (a study-load question added to the course-other-fields read, no new route), limited by its own setting | about **2,671** courses at stage 1; stage 2 runs on the existing lane under its caps |
| Tue 17 Nov 22:30 | PR 2 cutover | unchanged | — |
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

## 5. Decisions needed

1. **D-4:** confirm the primary-campus rule in section 4 (exact registered head-office match, or manual; else null).
2. **Single-campus providers (824):** mark their only campus as primary? The live CHECK has no basis for "only campus", so this needs a new basis value. A CHECK change is a paste file, so the recommendation is no for 20 Nov.
3. **REQ-19 / D-2 (grade scales):** the common scale is undecided, and `ref.grade_scale_conversions` belongs to the AER session. It is registered as a lane only; no rows until the AER owner seeds it under the decided scale.
4. **REQ-65 / -67 / -68 (destination):** scope, and Study Square's terms of use, are open. Editions can be seeded as `draft` from the 12 Nov destination source reviews, but are published only when `terms_status = approved`.
5. **REQ-76 (field dictionary):** Pilot #1162 belongs to the v3 integration session. Before it merges, it needs a migration version later than `20261116100000`, and its paste file moved to admin `docs/paste/` (two-repository rule).
