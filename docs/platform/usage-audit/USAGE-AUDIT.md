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
