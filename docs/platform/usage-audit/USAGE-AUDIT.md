# StudySearch – Usage audit: what is not being used (screens, scripts, jobs, data)

**Status:** COMPLETE (15 Oct 2026). Captured 12, 13, 14 and 15 Oct. The final report and the decision list are at the end of this page. Nothing has been changed or removed: each item waits for the Platform Admin's decision.
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

### Day 4 (15 Oct, captured 21:37 Melbourne; last 24 hours)
Table counters: `table-day4-2026-10-15T1037Z.txt` (compared with day 3). Only changes from earlier days are listed.

**Edge functions: 9 called (day 3: 10)**
- `coverage-sweep` 12,441; `provider-asset-access` 261; `evidence-link-index` 121; `layer1-operations-control` 71; `prisms-au-etl` 9; `zoho-course-api` 9 (day 3: 86); `qilt-au-etl` 8; `evidence-storage-dedupe` 1.
- **`wix-course-api`: first calls.** 44 calls in one burst, 15 Oct 08:00–08:16 Melbourne: 37 succeeded, 3 refused for a missing or wrong key (401), 2 service busy (503), 1 bad request (400), 1 not found (404). This looks like the developer trying the API. There is no regular sync yet (no calls in the 13 hours since).
- `website-course-api` (the older API): still no calls in 4 days.

**Scheduled jobs: 92 active, 33,250 runs, 61 failures**
- Failures are all deadlocks between `firecrawl-targets` (54) and `firecrawl-panel-figures` (7), as on days 2 and 3.
- Paused on purpose by the flag unit (Decision 261, 15 Oct): `coverage-read`, `coverage-reidentify`, `scholarship-read` and `coverage-find-site`. They restart by themselves when a trial run finds work.
- Switched off earlier: `course-link-reverse`, `onboarding-pilot-snapshot` and `coverage-read-2`.
- Not run in 24 hours, by design: the monthly and fourth-quarter document checks, `statistics-edition-discovery` (5th of the month), `enrich-focus-refresh` and `hygiene-check` (weekly).

**Screens (signed-in calls)**
- Most used: `admin_read` 771, the credit banner 143, Layer 1 statistics candidates 98, the dashboard waiting list 45, Jobs 39, Layer notices 38. New: the logo editor (8 calls).
- Still no call in 4 days: Pipeline settings register, Priority queue, Users & roles, Go-live checklist, Data model, Datasets registry editing.

**Tables: 433 (10 new on 15 Oct: flags, logos, register); 154 with no reads and no writes in 24 hours; 177 read but not written**
- **106 tables have had no reads and no writes at all since the 12 Oct baseline.** Together they take about 32 MB. The largest: `layer1_register_row_state` 9.7 MB, `layer2_scholarship_discovery_candidates` 2.8 MB, `adapter_shadow_reads` 2.4 MB, `directory_pages` 2.1 MB, `ca_course_scope_keys` 1.7 MB. 20 of them are named by no database function, and 15 of those by no screen or edge function either.
- Newly idle (48 idle on day 4 that were not idle all 3 windows): the remaining Layer 3 routing tables, the Layer 4 screen tables (screens not opened today), `register_replay_*`, `publishing.*` and several scholarship settings tables.

**What reads the retired tables: pinned on day 4**
Counters read just before and just after each scheduled run.

| Table | Size | Reads a day | Reader | How it was pinned |
|---|---|---|---|---|
| `layer3_fact_handoffs` | 18 MB | 4.4–5.2 million | `provider-english-defaults` (every 10 min, `provider_english_plan_v1`): about 36,000 reads a run; `policy-auto-approve` about 1,300 a run | 144 runs × 36,000 = 5.2 million, matching the daily growth |
| `layer3_work_items` | 75 MB | 2.0–2.6 million | `provider-english-defaults` about 18,000 a run; `policy-auto-approve` about 900; `provider-fee-profiles-apply` about 950 | Same |
| `layer3_interpretations` | 203 MB | 5.2–8.4 million, in bursts | `adapter-overwrite` (every 10 min, `adapter_overwrite_v1`) when it has a batch: 88 long runs (up to 70 s) from 14 Oct 21:50 to 15 Oct 16:40 Melbourne, then quiet. Only 17 reads between 21:37 and 21:47 | No other job touching the table runs long; reads stop when its long runs stop |
| `layer2_course_discovery_candidates` | 3 MB, empty | 0.8 million | `course-coverage-build` (hourly at :47, `course_coverage_build_v1`): 22,380 reads a run, about 540,000 a day; the rest from `retention-worker` (`retention_tick_v1`) | Before and after the 21:47 run |
| `layer2_scope_wave_items` | 37 MB, empty | none | nothing | No reads in 4 days |

## Final report (15 Oct 2026)

**How to read it:** *Keep* = in use or needed on demand. *Retire* = switch off and mark `retiring` in the component register; dropped by paste file after 14 days if nothing used it (Decision 260). *Delete* = nothing uses it; goes on the next paste file. *Purge* = keep the table but empty it (after an export to Storage), because its rows are large and no longer read. Nothing below has been done.

### Decisions for the Platform Admin
| # | Item | Recommendation | Why |
|---|---|---|---|
| D1 | 12 one-off probe and audit edge functions: `layer1-ca-*-probe` (7: cpic, mb-designation, sk-sitemap, qc-pdf, qc-pdf2, ab-alis, ircc-nvit), `layer1-ca-qc-audit`, `-qc-parse-audit`, `-qc-prefix-audit`, `-qc-strict-audit`, `layer1-ca-northern-code-audit` | **Delete** | Investigation scripts from August; no calls in 4 days; no job, function or screen calls them; Decision 260 says probes are not left deployed |
| D2 | Retired Layer 3 edge functions: `layer3-model-routing`, `layer3-work-dispatch`, `layer3-work-interpret`, `layer3-cf245-tuition-benchmark`, `layer3-intake-benchmark`, `layer3-contact-benchmark` | **Delete** | Layer 3 retired 11 Oct; no calls since; three are no longer in the repository |
| D3 | `layer3-provider-control` edge function | **Retire** | No calls; one screen still links to it, so the link goes first |
| D4 | Contacts import: `provider-contact-discover-scheduled`, `provider-contact-enrich-apollo`, `provider-contact-import`, `provider-contact-control` and the 9 `provider_contact_*` / `provider_directory_observations` tables | **Retire** | Unused since late August; no job calls them. Keep only if contact discovery is planned |
| D5 | `website-course-api` (the first website API) | **Retire** after the website owner confirms | No calls in 4 days; `wix-course-api` (v2) has replaced it and has started receiving calls |
| D6 | Read of `layer3_fact_handoffs` and `layer3_work_items` by `provider-english-defaults` and `policy-auto-approve` | **Change, then purge** | About 7.5 million reads a day of retired tables to answer "is there a Layer 3 item for this course". A code change to stop the reads; then export and purge the two tables (93 MB) |
| D7 | Read of `layer3_interpretations` by `adapter-overwrite` | **Change, then purge** | Same question, in bursts of up to 70 s a run. After the change, export and purge (203 MB) |
| D8 | Read of the empty `layer2_course_discovery_candidates` by `course-coverage-build` and `retention-worker` | **Change, then delete** | 0.8 million reads a day of an empty table (a per-course lookup that always finds nothing) |
| D9 | `layer2_scope_wave_items` (37 MB, empty, no reads) | **Delete** | Nothing reads or writes it; frees 37 MB |
| D10 | 15 tables named by no function, screen or edge function: `zz_qualify_scratch_v1`, `reading_restores_20261005`, `public._layer1_depth_uat_control`, `layer2_fanout_tasks`, `night_run_queue`, `night_run_rebatch`, `refused_host_changes`, `scholarship_reread_snapshots`, `layer2_provider_benchmark_observations`, `pilot_edge_execution_queue`, `scholarship_coverage_benchmarks`, `search.intent_aliases`, `evidence_links` (empty), `layer2_domain_refresh_policies`, `layer3_work_item_rebinds` | **Delete** | Untouched for 4 days and nothing can reach them |
| D11 | Idle groups still named by functions: the `workflow` schema (9 tables), Layer 2 trials and earlier phases (about 20: `layer2_auto_discovery_*`, `layer2_completeness_trial*`, `layer2_scale_qualification_runs`, `layer2_tuning_events`, `coverage_identity_*`, `directory_*`, `ca_course_scope_keys`), Layer 3 benchmarks (7), scholarship leftovers (9), `onboarding_cases` and its events, unused search embeddings (`search.course_embeddings`, `embedding_jobs`, `query_embedding_cache`, `profiles`) | **Retire** (tables with their functions) | No reads or writes in 4 days; their functions go with them, so each group is one paste file after 14 days |
| D12 | Jobs switched off: `course-link-reverse`, `onboarding-pilot-snapshot`, `coverage-read-2` | **Delete** (unschedule) | Off since 12–13 Oct and replaced |
| D13 | `coursefinder-m2-3-refresh-intelligence-tick` (hourly) | **Retire** | Belongs to the retired Layer 3 refresh scheduler; reads `layer3_interpretations` |
| D14 | `firecrawl-targets` and `firecrawl-panel-figures` deadlocks (about 60 failures a day) | **Fix** (separate change) | The only failing jobs; they deadlock with each other every day |

### Keep (no action)
- **Screens not opened in 4 days** (Pipeline settings register, Priority queue, Users & roles, Go-live checklist, Data model, Datasets registry editing): keep. They are admin tools used when something changes; one person's 4 days is not enough to judge them. Go-live checklist is needed for production.
- **On-demand or seasonal edge functions:** the Canadian college catalogue readers (`layer1-ca-*-programs`, `-catalogue`), `ranking-*`, `statcan-ca-psis-etl`, `statistics-edition-discovery`, `fee-schedule-etl` (monthly document checks), `layer1-register-etl`, `layer1-au-depth`, `layer1-nz-live`, `layer1-ca-live`, `layer1-au-cricos-facts`, `layer2-provider-control`, `admin-user-management`, `admin-evidence-access`, `toolset-runner`, `platform-environment-control`.
- **Jobs paused by the flag unit** (`coverage-read`, `coverage-reidentify`, `scholarship-read`, `coverage-find-site`): keep; they restart by themselves.
- **Idle reference, settings and audit tables:** `ref.*`, `catalogue.course_collections`, `provider_associations`, `outcome_benchmarks`, policies and cost model, `statistics_edition_rules` (monthly), the scholarship registers, `security.user_access_events` and `service_permissions`, rule admission history, `adapter_shadow_*` and `retention_*`.
- **`layer1_register_row_state` (9.7 MB):** keep until the register re-read is next run; it is how a re-read knows what changed.
- **`layer4_block_decisions`:** 20 million reads a day on 11 rows; a cheap hot-path lookup.
- **`layer3_openrouter_observations`, `layer3_provider_credential_resolve_service`, `layer3_routing_profile_service`:** in use despite the name (OpenRouter balance, key and model profile). Rename later.

### Space
D6, D7, D9 and D10 together free about 335 MB (Layer 3 tables 296 MB, `layer2_scope_wave_items` 37 MB, the small tables about 2 MB). D11 adds about 25 MB.
