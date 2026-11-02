# AU catalogue export: field mapping, data dictionary and field states (2 Nov 2026)

**Authority:** Platform Admin 2 Nov 2026 11:10 (`nz-enrichment-brief/2026-11-02-au-export-and-wix-enrichment-closure.md` §1, §3, §4) and 11:18 (`2026-11-02-au-export-wix-readiness-direction.md`: snapshot method, production impact, source-held / admitted / held / consumer-visible).
**Code:** Pilot repo branch `cf247-au-catalogue-export`: `.github/workflows/au-catalogue-export.yml`, `scripts/export/` (queries, driver, derived sheets, workbook), spec `tests/uat/cf-247-s219-au-catalogue-export-contract.spec.mjs`, fixtures `tests/fixtures/au-catalogue-export/`.
**Status:** built and tested on fixtures. **The export has not run against production yet.** It is complete only when the workflow has run, every manifest check passes and the artifact can be downloaded.

## 1. What the export holds

Every Australian course held in the catalogue. "Australian" means the provider's country is AU. Lifecycle and publication status do not filter anything: inactive and unpublished courses are included. Measured at 11:26 on 2 Nov: 26,912 AU courses (25,380 active, 1,532 inactive; every one has course `publication_status` `unpublished`, which the projection does not read), 1,556 AU providers, and 23,732 AU courses in `search.course_documents` (the Website API v2 population).

Each one-to-many table is its own dataset with its own stable ids. Nothing is flattened. Null stays empty in the CSV, and an empty string is written as `""`. Columns the export adds start with `x_`.

| # | Dataset (sheet) | Source table | Key (keyset order) | Rows measured 2 Nov 11:26 |
|---|---|---|---|---:|
| 1 | courses (01 Courses) | `catalogue.courses` + provider, level, field | `id` | 26,912 |
| 2 | course_fees (02) | `catalogue.course_fees` + source label | `id` | 179,621 |
| 3 | course_intakes (03) | `catalogue.course_intakes` + source, campus | `id` | 28,437 |
| 4 | course_entry_requirements (04) | `catalogue.course_entry_requirements` | `id` | 2,649 |
| 5 | english_requirements (05) | `catalogue.course_english_requirements` + `ref.english_tests` | `id` | 27,134 |
| 6 | course_scholarships (06) | `scholarship.course_mappings` + scholarship | `id` | 101,422 |
| 7 | scholarship_master (07) and six child sheets (award tiers, criteria, criterion groups, application windows, offering cycles, identifiers) | `scholarship.scholarships` and children | `id` | 1,804 scholarships |
| 8 | provider_rankings (08) | `catalogue.provider_rankings` + `ref.ranking_sources` | `id` | **0** (no AU ranking row is held) |
| 9 | provider_entry_matrices (09) | `catalogue.provider_entry_matrix` | `id` | 2,335 |
| 10a | course_links | `catalogue.course_links` | `id` | 20,247 |
| 10b | course_campuses | `catalogue.course_campuses` + campus | `(course_id, campus_id, delivery_mode)` | 48,732 |
| 10c | course_identifiers (source identities) | `catalogue.course_identifiers` | `id` | 26,912 |
| 10d | course_pages_held | `pipeline.coverage_course_pages` | `course_id` | 24,240 |
| 11 | website_api_v2_field_reconciliation | derived | `(course_id, consumer_field)` | 25 rows per course in the API population |
| 12 | field_state_reconciliation | derived | `(course_id, field)` | 16 rows per AU course |
| 13 | data_dictionary_and_coverage | derived | `(dataset, column)` | one row per exported column |
| S | search_course_documents, layer4_course_review_items, providers | projection rows, Layer 4 course items, AU providers | | 23,732 / ≤ 24,890 / 1,556 |
| R | reference sheets | study levels, fields of study, English tests, ranking sources, enrichment and country gates, sources | | small |

Scholarship scope: scholarships of AU providers, plus any scholarship linked to an AU course (it may belong to a provider in another country).

## 2. Source-held, admitted, held or rejected, and consumer-visible

- **Source-held:** every row in a child dataset is a stored value from a source. `source_id` with `x_source_label`, or `source_url`, names the source. `evidence_id` is kept as stored.
- **Admitted / held / retired:** `x_admission_state` maps the row status: `active` → admitted; `unverified` or `proposed` → held (stored, not admitted); `inactive`, `superseded`, `withdrawn` or `deprecated` → retired. For scholarship links, `mapping_state` is shown as stored.
- **Rejected:** rejection is a Layer 4 decision, not a row status. The rows are in `layer4_course_review_items`, and the latest decision for each field is in `field_state_reconciliation`.
- **Consumer-visible:** `x_consumer_visible` copies the live consumer rule for each dataset (below). A course is served only when it has a projection row **and no active Layer 4 search block**: the live `api.website_v2_course_item` (read 2 Nov 11:56) returns null for a blocked course. 3,180 AU courses had a search block at 11:26, counting courses of hidden providers. `x_in_website_api_v2` / `x_course_in_website_api_v2` mean "has a projection row", which is the population the reconciliation counts against.

| Dataset | `x_consumer_visible` rule (from the live function) |
|---|---|
| courses | projection row and no search block |
| course_fees | course served; `status` active; audience international or all; `fee_type` tuition or `provider_current_tuition` (course detail `tuition_history`). Also `x_in_projection_tuition_options` (the provider tuition options: also inside valid dates, source gate approved) and `x_is_projection_regulatory_fee` (the one CRICOS registered total the projection shows) |
| course_intakes | course served; active; source has an approved `course_intake` gate |
| english_requirements | course served; active; inside valid dates; source has an approved `course_english` gate |
| course_entry_requirements | course served; active; a kind the entry object reads. `min_score` and `benchmark_band` show only the first eligible row |
| course_scholarships | course served; mapped; scholarship active, published or internal, audience international or international and domestic; scholarship gate approved |
| scholarship_master | active, published, no scholarship search block. Truncation: `x_mapped_courses`, `x_linked_courses_truncated` (the scholarship detail lists 200 linked courses by title) |
| provider_entry_matrices | active (provider entry matrix) |
| course_links | this URL is the projection's `official_course_url` and the course is served. Also `x_projection_candidate` |
| course_campuses | course served (the course item lists every campus row) |

## 3. Website API v2 consumer fields: current value, source field and null meaning

Sources: the live `api.website_v2_course_item` (md5 `8f2a0ac921c4507673c1232cf2ecc8aa`), `public.website_v2_course(text)` (md5 `50d22c3c…`) and `(text,text)` (md5 `1c10b34f…`), and `api.website_v2_tuition` (md5 `174d6629…`). Bodies were read live on 2 Nov 11:56. The repository copies under `supabase/live-capture/functions/` are from 10 Oct and are out of date for the course item.

| Consumer field | Projection column (`search.course_documents`) or live read | Database source | Null means |
|---|---|---|---|
| `course_id` | `course_stable_key` | `courses.stable_key` | never null |
| `course_code` | `course_code` | `courses.course_code` | no code held |
| `display_code`, `display_code_kind`, `display_code_label` | live: `security.course_display_code_v1` | course identifiers and code | no display code held |
| `title` | `course_title` | `courses.canonical_title` | never null |
| `description` (detail) | live: `catalogue.courses.description` | `courses.description` | not held |
| `country_code` | `country_code` | provider country | never null |
| `provider.provider_id`, `legal_name`, `name` | `provider_stable_key`, `provider_name` | `providers.stable_key`, `coalesce(display_name, canonical_name)` | never null |
| `provider.institution_type`, `university_groups`, `ranking_summary`, `logo` | live functions on the provider | provider tables | not held |
| `campuses[]` (city, postcode, subdivision, is_primary, metro area, regional category) | live: `course_campuses` + `campuses` + `pipeline.campus_regional_class` | course_campuses | empty array: no campus held |
| `study_level.code`/`name` | `study_level_code` | `ref.study_levels` | no level held |
| `study_area.code`/`name` | `primary_field_code`/`primary_field_name` | `ref.fields_of_study` | no field held |
| `duration_months` | live: `courses.duration_value`, `duration_unit` | courses | no duration, or a unit other than weeks, months or years |
| `delivery_modes` | `delivery_modes` | campus delivery modes, else `courses.delivery_mode` | empty: none held |
| `tuition` {amount, currency, basis, basis_label, source, year, annual_amount, annual_is_derived} | `provider_tuition_options`, `regulatory_tuition_amount` | course_fees (provider current tuition ≥ 1,000, latest year; else CRICOS registered total ≥ 1,000) | null: no qualifying fee |
| `intakes[]` (label, month, year, start_date, application_deadline) | `intake_options` (distinct by those five keys) | course_intakes | empty: none admitted; `start_date`/`application_deadline` null: not held |
| `entry_requirements.summary`/`basis` | `english_requirement_options` | English requirements | null: no English requirement |
| `english_requirements[]` | `english_requirement_options` | course_english_requirements | empty: none admitted |
| `entry` (two-argument form) | live: `security.entry_course_payload_v1` | course_entry_requirements | nulls and empty lists: not held |
| `official_url` | `official_course_url` | course_links (E16-2 choice) | no approved link |
| `scholarship_count`, `scholarships[]` (detail) | `scholarship_options` | course_mappings + scholarships | 0 / empty: none linked and visible |
| `tuition_history[]` (detail) | live: course_fees | course_fees | empty: none |
| `subdivision_codes` | `subdivision_codes` | campus subdivisions | empty: none |
| `publication_status` | live: provider hidden check | providers | `published` unless the provider is not active or not published |
| `freshness` | `updated_at`, `source_updated_at` | projection | n/a |

The reconciliation sheet compares, for each course in the API population, 25 of these fields: the database value worked out from the exported rows by the projection rule, the projection value, and the value served. Comparison values are `equal`, `differs`, `both_null`, `db_only`, `projection_only`, `live_read` (the API reads the database directly) and `chosen_among_candidates` (several candidate links; the E16-2 page check, which the export does not re-run, picks one). Rows marked `differs` are data-quality exceptions, usually projection lag. `course_served` is false for blocked courses, and their `consumer_value` is empty.

## 4. Field states (sheet 12)

These are the states the stored data supports. Each course and field gets exactly one state, applied in this order:

| State | Meaning | Data used |
|---|---|---|
| quality_held | the course is withheld by an active Layer 4 search block, or only unverified rows are held | `x_website_search_blocked`; `x_admission_state` held (unverified) |
| available | an admitted value is held | admitted rows, or the course column |
| layer4_pending | no admitted value, and a real pending `pipeline.layer4_review_items` row for that course and field | field codes: `official_course_url`, `provider_current_tuition`, `provider_current_tuition_validation`, `course_intake`, `course_english`, `course_entry_first_read` |
| processing | rows stored as `proposed`, not admitted, and no pending item | entry requirements |
| rejected | no admitted value, and the latest Layer 4 decision is `rejected` | Layer 4 items |
| missing | not held. This says nothing about whether the source provides the value | none of the above |
| not_applicable | **never assigned**: no confirmed not-applicable decision is held, and a null is never read as not applicable | none |

## 5. Proposal: field-state metadata for Wix (G3: needs approval, not built)

Values stay as they are: numbers, dates, booleans, arrays and URLs are never replaced with text. A separate, additive `field_states` object would sit on the course item, keyed by consumer field. Each value would be one of: `available`, `not_provided_by_source`, `processing`, `awaiting_layer4`, `held_for_quality_verification`, `not_applicable`, `confirmed_unavailable`.

- `not_provided_by_source` and `confirmed_unavailable` need evidence the platform does not hold today: a page that was read and verified as not stating the value, or a recorded decision. Until that evidence exists, the honest state is "not held", and the API would leave the key out rather than guess.
- `not_applicable` needs a recorded decision. None exists today.
- Adding the object is a consumer API change: G3 approval, the paste-reviewed migration, a new baseline and the Wix handover all apply.

## 6. Production impact and snapshot method (measured before execution)

- **Read-only:** every statement is a select. Each one runs inside `BEGIN ISOLATION LEVEL REPEATABLE READ READ ONLY` with `statement_timeout` 30 s (an input), `lock_timeout` 5 s and `idle_in_transaction_session_timeout` 60 s. No row locks are taken. The cost is the held xmin.
- **Measure first:** counts and one timed calibration page run in the :x6–:x8 minutes, each in its own short read-only transaction. The estimate (rows, pages, queries, seconds) is written to the manifest before any data is read.
- **Single snapshot:** used when the estimate is within 180 s (an input). It is one continuous transaction through every dataset, started at the beginning of the longest quiet gap, with no waits inside. Past 300 s it is rolled back and the export falls back to per-dataset.
- **Per-dataset:** one short snapshot per dataset or page group, each committed before 45 s or before the next busy minute, with waits only between transactions. Each snapshot's `now()` and `txid_current_snapshot()` are recorded. Drift is reported: courses changed after the first snapshot, and child rows whose course is missing.
- **Busy minutes:** the start minutes of `coverage-admit`, `coverage-admit-intakes`, `adapter-overwrite` and `exit-awards-apply`, read from `cron.job` at start (from v2.15.403: :x3, :x5, :x9 and :37), plus :00–:05, :35–:42, :47–:48 and the 06:50–07:15 daily peak. If a job failed or timed out in the last 15 minutes, the export backs off.
- **Expected for AU:** about 548k rows in about 290 keyset pages of 2,000 rows, about 650 queries, each indexed and bounded. The estimated data time is 1–3 minutes, so the single snapshot is expected. The wall time is 5–20 minutes, mostly waiting for the measure minutes and the quiet gap. Every query was checked against the live schema with EXPLAIN only (planning, no execution) at 11:46. The scholarship master query was rewritten after it planned at about 21.9M cost units; the others planned at up to about 152k.

## 7. Limitations

- Provider rankings: no AU row is held, so the dataset is exported empty, with its columns.
- The official URL choice for courses with several candidate links and none primary depends on `security.course_page_check_v1` (E16-2). The export marks these rows `chosen_among_candidates` and does not re-run the check.
- The scholarship detail lists linked courses by title with no tie-break. Truncation is reported per scholarship, not as each course's position.
- `layer4_course_field_resolutions` held no rows on 2 Nov, so no confirmed not-applicable state exists.
