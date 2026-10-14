# StudySearch – Usage audit: what is not being used (screens, scripts, jobs, data)

**Status:** IN PROGRESS. Day 1 taken 12 Oct 2026, 21:12 Melbourne. Daily captures follow on 13, 14 and 15 Oct; the final report and the list to retire come on 15 Oct.
**Change control:** CF-247
**Asked by:** Platform Admin, 12 Oct 2026: "Find which is not being used first, and scripts and data whose details are not changed for a few days."
**Rule:** nothing is changed or retired because of this audit until the Platform Admin decides on the final list. This page only measures.

## How it is measured

| What | Signal | Source | Limit |
|---|---|---|---|
| Screens | Which admin functions signed-in people call (each screen reads through its own functions) | Supabase API logs (24-hour window, captured daily) | `admin_read` serves many screens and its body is not logged, so screens using it show only as `admin_read`. The UAT and screenshot runs also sign in. |
| Edge functions (scripts) | Invocations | Edge function logs (24 hours, daily) | One day is short for monthly and on-demand functions; three days narrows this down. |
| Scheduled jobs | Runs and failures over 7 days | `cron.job_run_details` | A job can run successfully and still do nothing. Its output tables (below) show that. |
| Data | Last change per table, and reads and writes since the baseline | Timestamp columns; `pg_stat_user_tables` counters, baseline in `table-baseline-2026-10-12T1012Z.txt` | A table whose reads and writes do not move over 3 days is used by nothing. |

## Day 1 findings (12 Oct 2026, last 24 hours or 7 days)

### Edge functions: 89 deployed, 10 called in 24 hours
- **Called:**
  - `coverage-sweep` (19,818 calls) is the main worker.
  - Lower volume: `evidence-link-index` (144), `provider-asset-access` (106), `layer1-operations-control` (79), `qilt-au-etl` (10), `prisms-au-etl` (10), `zoho-course-api` (3), `evidence-storage-dedupe` (1).
  - `layer3-model-routing` (1,452) and `layer3-work-dispatch` (351) stopped at 11 Oct 21:56 UTC, when Layer 3 was retired. They are already on the Platform Admin's deletion list.
- **Not called in 24 hours (79):**
  - About 45 `layer1-ca-*` college catalogue readers, probes and audits. The probes and audits (`*-probe`, `*-audit`, `qc-*`, `cpic-probe`, `ircc-nvit-probe`) look like one-off investigation scripts.
  - `layer3-provider-control`, `layer3-contact-benchmark`, `layer3-cf245-tuition-benchmark`, `layer3-work-interpret` and `layer3-intake-benchmark`.
  - `statcan-ca-psis-etl` and the `ranking-*` functions.
  - `provider-contact-discover-scheduled` and `provider-contact-enrich-apollo`.
  - `website-course-api` and `wix-course-api`: no consumer calls in 24 hours. Confirm with the website and Wix owners.
  - `admin-user-management`, `platform-environment-control` and `toolset-runner`.
  - Several of these are on demand or monthly. The 3-day captures separate those from the unused.

### Scheduled jobs: 91, all running
- **Failing often (7 days):**
  - `coverage-admit` (76 of 467)
  - `coverage-admit-intakes` (76 of 467)
  - `platform-health` (75 of 467)
  - `firecrawl-targets` (20)
  - `scholarship-course-attribute` (4)
  - `provider-onboarding` (3)
- **Not run in 7 days (by design):**
  - `provider-document-check-monthly`
  - `statistics-edition-discovery` (5th of the month)
  - `provider-document-check-weekly-q4` (Mondays in the fourth quarter; first run tonight)
- **Running, but possibly doing nothing** (their output has not changed for days; to verify):
  - `better-page-revert` (every 5 min; `page_link_repairs` last changed 7 Oct)
  - `search-refresh-requested` (every 10 min; `search_refresh_signals` last changed 2 Oct)
  - `link-refresh` (every 10 min; policies last changed 1 Oct)
  - `coursefinder-m2-3-refresh-intelligence-tick` (hourly)
  - `course-link-reverse`, `coverage-reextract`, `coverage-reidentify` and `university-reread-requests` (every minute)

### Layer 3: what still runs
- `coverage-sweep` still calls `layer3_provider_credential_resolve_service` and `layer3_routing_profile_service`, 2,164 times each since 11 Oct 23:00. These fetch the OpenRouter key and model profile used by scholarship AI, adapter proposals and central pages AI. They are needed today and should be renamed (a code change).
- `layer3_openrouter_observations` holds the OpenRouter balance (since v2.15.258). It is in use despite its name.
- The Layer 3 working tables stopped changing on 11 Oct 21:56: `layer3_interpretations` (203 MB), `layer3_work_items` (75 MB), `layer3_fact_handoffs` and others. They are candidates for Storage & retention.

### Data
- **42 tables are empty.** Most belong to retired or never-used features: the `workflow` schema (import, export, review queue, suggestions), `layer4_override_decisions`, `layer4_publication_decisions`, `claims`, `onboarding_cases`, `scholarship_ai_runs` and `adapter_autobuilds`.
  - Some empty tables still take space: `layer2_scope_wave_items` (37 MB, 52 million writes in its life), `layer2_scale_qualification_items` (11 MB) and `layer2_provider_attempts` (9 MB).
  - Some empty tables are still read heavily, which means a job or screen still queries them: `layer2_course_discovery_candidates`, about 165 million reads in its life.
- **About 100 tables have not changed for more than 7 days.**
  - Reference and settings tables are meant to be static (`ref.*`, policies, settings).
  - Others are leftovers of earlier phases: `layer2_source_profiles` and their versions (1 Oct), `layer2_*` trials and benchmarks (August to September), `provider_contact_*` (29 Aug), `directory_*` (2 Oct), `coverage_identity_*` (2 Oct), `layer3_*` benchmarks, and `zz_qualify_scratch_v1` (a scratch table).
- **Reads and writes per table** are recorded in the baseline. The 3-day comparison will show which are touched by nothing at all.

### Screens (signed-in calls, 24 hours)
- **Opened:**
  - Onboarding: 591 calls
  - Credit banner: 132
  - Layer 1 statistics: 108
  - Jobs and tasks: 87
  - Dashboard waiting list: 71
  - Layer notices: 58
  - Scholarship extraction and AI review: 38
  - Adapters, Layer 4 review, scholarship coverage, archive, automations, refresh schedules, toolsets, websites: a few each
  - `admin_read`: 1,572 (several screens)
- **No call in 24 hours:**
  - Key dates, Reference sources and Datasets registry
  - Storage & retention, Pipeline settings and Priority queue
  - Users & roles, Go-live checklist and Data model (through `admin_read` or edge functions)
- One day with one person is too little to judge screens. The daily captures continue.

## Plan
| Date | Capture |
|---|---|
| 13 Oct, about 21:15 | Edge function calls, signed-in calls, cron runs (24 hours); table reads and writes against the baseline |
| 14 Oct, about 21:15 | Same |
| 15 Oct, about 21:15 | Same, then the final report: unused screens, scripts, jobs and tables, each with a recommendation (keep, retire, delete, purge) for the Platform Admin to decide. Anything that drops or deletes goes as a paste file. |

## Daily captures
(appended below each day)

### Day 2 (13 Oct, captured 21:16 Melbourne; last 24 hours)
Table counters: `table-day2-2026-10-13T1016Z.txt` (compared with the 12 Oct baseline). Only changes from day 1 are listed.

**Edge functions: 8 called (day 1: 10)**
- Called: `coverage-sweep` (15,182), `provider-asset-access` (114), `evidence-link-index` (110), `layer1-operations-control` (45), `qilt-au-etl` (6), `prisms-au-etl` (6), `platform-environment-control` (2), `zoho-course-api` (1).
- `layer3-model-routing` and `layer3-work-dispatch`: no calls for the second day (they stopped 11 Oct).
- `evidence-storage-dedupe`: not called this window. It runs once a day, so this is timing.
- Still no calls: `website-course-api`, `wix-course-api`, all `layer1-ca-*` readers, probes and audits, the other `layer3-*` functions, `ranking-*`, `statcan-ca-psis-etl`, `provider-contact-*`, `admin-user-management`, `toolset-runner`.

**Scheduled jobs**
- Failures fell sharply. `coverage-admit`, `coverage-admit-intakes` and `platform-health` (about 75 failures each over day 1's 7 days) had none in 24 hours.
- `firecrawl-targets` failed 30 times in 1,440 runs, and `firecrawl-panel-figures` once: database deadlocks with another job.
- Not run in 24 hours, by design: `provider-document-check-monthly` (2nd of the month) and `statistics-edition-discovery` (5th of the month).

**Screens (signed-in calls)**
- New since day 1: Progress (60 calls), Firecrawl credits by university (5), the scholarship skip rules (5), the retention screen (2), key dates and reference sources (1–2 each).
- Most used: Onboarding (1,194), `admin_read` (1,003), the credit banner (291).
- Still no call in 2 days: Datasets registry editing, Pipeline settings, Priority queue, Users & roles, Go-live checklist, Data model.

**Tables: no reads and no writes in 24 hours (128 of 393)**
- **Retired features:** the whole `workflow` schema except `review_queue`; `claims`; `onboarding_cases` and `onboarding_lifecycle_events`; `layer4_scope_rules`, `layer4_mass_operations`, `layer4_quality_findings`, `layer4_field_registry`; `scholarship_ai_run_items`.
- **Layer 2 trials and earlier phases:** `layer2_auto_discovery_*`, `layer2_completeness_trial*`, `layer2_fanout_tasks`, `layer2_field_admissions`, `layer2_scale_qualification_runs`, `layer2_shared_fetches`, `layer2_tuning_events`, `layer2_provider_probe_requests`, `layer2_provider_catalogue_submissions`, `layer2_scholarship_discovery_candidates`, `coverage_identity_*`, `directory_*`, `night_run_*`, `ca_*`.
- **Layer 3 benchmarks:** `layer3_benchmark_jobs`, `layer3_holdout_sets`, `layer3_intake_*`, `layer3_profile_activation_events`, `layer3_task_contract_freezes`, `layer3_work_item_rebinds`, `layer3_provider_credential_audit`.
- **Contacts import:** `provider_contact_import_*`, `provider_contact_observations`, `provider_contact_audit_events`, `provider_contact_dispositions`, `provider_contact_enrichment_attempts`, `provider_contact_provider_mappings`, `provider_directory_observations`.
- **Scholarship pipeline leftovers:** `scholarship_catalogue_runs`, `scholarship_coverage_benchmarks`, `scholarship_etl_schedules`, `scholarship_maintenance_runs`, `scholarship_page_searches`, `scholarship_reread_snapshots`, `scholarship_scope_acquisition_requests`, `scholarship_source_*`, `scholarship.registers` and `register_listings`.
- **One-off and scratch:** `reading_restores_20261005`, `zz_qualify_scratch_v1`, `public._layer1_depth_uat_control`, `register_replay_*`, `rule6_page_checks`, `site_hint_checks`, `refused_host_changes`, `retention_file_queue`, `retention_evidence_skips`.
- **Search features never used:** `search.course_embeddings`, `embedding_jobs`, `query_embedding_cache`, `intent_aliases`, `profiles`.
- **Static reference tables, expected to be idle:** `ref.languages`, `ref.regions`, `ref.provider_types`, `ref.ranking_sources`, `ref.identifier_schemes`, `ref.study_level_source_mappings`, `catalogue.course_collections`, `catalogue.outcome_benchmarks`, `catalogue.provider_rankings`, `catalogue.provider_associations`.
- **Also idle, worth a check before deciding:** `evidence_links` (2.2 million rows written in its life, untouched today), `layer1_register_row_state`, `layer1_course_retirements`, `catalogue.course_identifiers`, `catalogue.course_field_observations`, `source_provider_mappings`.

**Tables read but not written (154): the ones that matter**
- **Retired Layer 3 tables are still read heavily:** `layer3_interpretations` (8.2 million reads in 24 hours), `layer3_fact_handoffs` (3.6 million) and `layer3_work_items` (2.0 million). Something (a screen, job or view) still queries them. They must be traced before they can be purged.
- `layer4_block_decisions`: 19.7 million reads in a day against 11 rows ever written. It is a lookup on a hot path and cheap; keep it.
- `layer2_course_discovery_candidates` is empty but was read 806,000 times: an old query still runs against it.
- Reference and settings tables (countries, English tests, registrations, toolset settings) are read but rarely written, as expected.

### Day 3 (14 Oct, captured 21:32 Melbourne; last 24 hours to 21:16)
Table counters: `table-day3-2026-10-14T1032Z.txt` (compared with day 2; schemas `ranking` and `publishing` added). Only changes from earlier days are listed.

**Edge functions: 10 called (day 2: 8)**
- `coverage-sweep` 16,109; `evidence-link-index` 121; `layer1-operations-control` 89; `zoho-course-api` **86** (day 2: 1); `provider-asset-access` 44; new `layer1-provider-facts` 21 and `layer1-operations-scheduled` 4 (institution type, v2.15.276); `qilt-au-etl` and `prisms-au-etl` 9 each; `evidence-storage-dedupe` 1 (daily, as expected).
- **`wix-course-api`: still no calls.** The website has not started calling the API on Pilot (v1 or v2), although v2 was released on 8 Oct and the sync action added on 14 Oct. `website-course-api` also has none.
- `platform-environment-control` not called this window (it was called twice on day 2).

**Scheduled jobs: 97 (6 added on 14 Oct), 33,277 runs, 65 failures**
- Every failure is a deadlock between `firecrawl-targets` (58, day 2: 30) and `firecrawl-panel-figures` (7, day 2: 1). They are getting worse, not better.
- Switched off on purpose: `coverage-read-2` (second reader, paused 12 Oct) and `onboarding-pilot-snapshot` (replaced by progress snapshots, 13 Oct).
- New daily `provider-type-classify` (03:47 UTC) has not run yet: it was created after that time on 14 Oct.

**Screens (signed-in calls)**
- New: Enrich fields (14), Scholarship search flag (13), Layer 1 statistics candidates (98).
- Progress fell from 60 calls to 16; the credit banner (300) and `admin_read` (887) remain the most used.
- Several Layer 4 screens were opened once each (review desk, batches, mass operations, quality findings, departures).
- Still no call in 3 days: Pipeline settings register, Priority queue, Users & roles, Go-live checklist, Data model, Datasets registry editing.

**Tables: no reads and no writes in 24 hours: 132 of 399 (day 2: 128 of 393)**
- 17 of day 2's idle tables moved, mostly because of the 14 Oct releases (`ref.identifier_schemes`, `ref.provider_types`, `catalogue.course_identifiers`) or a screen opened once (`layer4_mass_operations`, `layer4_quality_findings`, `layer4_field_registry`). `register_replay_*`, `scholarship_etl_schedules` and `source_record_staging` had a few reads.
- Newly idle (21): the remaining Layer 3 routing tables (`layer3_route_budget`, `layer3_route_events`, `layer3_route_tiers`, `layer3_tier_audits`, `layer3_holdout_cases`, `layer3_profile_environment_gates`); environment and gate tables (`environment_source_gates`, `layer2_provider_environment_gates`, `layer2_profile_provider_routes`); `firecrawl_calls`, `integration_secret_registry`, `performance_workload_profiles`, `platform_uat_catalogue`, `production_migration_manifest`, `provider_document_checks`, `provider_fee_rows`, `statistics_dataset_registry`, `toolset_sample_items`, `uni_adapter_models`, `uni_adapter_previews`, `ref.currencies`.
- The day 2 groups (retired features, Layer 2 trials, Layer 3 benchmarks, contacts import, scholarship leftovers, one-off and scratch, unused search features) are still idle on day 3.

**Tables read but not written: 158**
- `layer3_interpretations` 8.35 million reads, `layer3_fact_handoffs` 3.57 million, `layer3_work_items` 2.00 million, `layer2_course_discovery_candidates` 0.81 million: the same as day 2, with no writes.
- `layer4_block_decisions` 20.1 million reads (hot-path lookup, 11 rows): keep.

**What still reads the retired tables (traced on day 3)**
- No view reads any of the four tables. `pg_stat_statements` shows only screen and one-off queries, because the reads happen inside functions called by jobs.
- `layer2_course_discovery_candidates` (13 functions): the steady reads match `course-coverage-build` (hourly, `security.course_coverage_build_v1`). About 33,600 reads a run against about 37,000 courses suggests a per-course lookup. Also `retention-worker` (`retention_tick_v1`, every 2 minutes) and the Layer 2 operations screen.
- `layer3_work_items` (32 functions) and `layer3_interpretations` (35 functions): the jobs that call them are `adapter-overwrite` (every 10 minutes), `provider-basis-rule-admit` (every 10 minutes), `provider-rule-admit` and `provider-fee-profiles-apply` (hourly), `course-coverage-build` (hourly), `platform-health` (every 10 minutes), `platform-resource-observe` (hourly) and `coursefinder-m2-3-refresh-intelligence-tick` (hourly). Screens: Layer 4 review desk and context, course field states, Task manager running-now and live activity, Services.
- `layer3_fact_handoffs` (6 functions): the requeue screen and its action, `provider_english_plan_v1`, and the retired Layer 3 fact services.
- Before any of these tables is retired, each function above must stop reading it (the rule jobs check "is there a Layer 3 item for this course"). Day 4 can pin the exact job by comparing the table's read counter before and after one run of each.
