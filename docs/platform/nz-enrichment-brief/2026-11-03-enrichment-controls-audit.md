# Enrichment controls audit: what an operator can run today, and what runs by itself

**Date:** 3 November 2026, 09:33 to 10:10 AEDT
**Author:** Workstream F (integration, scheduling, UI testing and production assurance)
**Direction answered:** Platform Admin, 3 Nov 2026 09:32, `2026-11-03-platform-led-enrichment-autonomy-mandate-0932.md`, sections 2, 3, 6, 7 and 10
**Code read:** Pilot `main` at `8ddbcae9` (v2.15.415)
**Production read:** Supabase `fxcwkweaxjtknorudmwp` only. All SQL was read-only (function definitions, settings, `cron.job`, `cron.job_run_details`, run tables). Heavy reads ran at 09:46 to 09:48 and 09:56 to 09:58 Sydney time. No `admin_*` or `svc_*` function was called, nobody signed in to the website, no AI or Firecrawl was used, and nothing was written.

This is an audit. It enriches no data and changes nothing in production. A control is called **operational** only when production shows real work done after it was used. Source code that exists is not enough.

---

## 1. Summary for the Platform Admin

**The short answer to "If Claude stops now, does StudySearch keep enriching?":** partly. Some fields keep moving on their own. Others have no engine, a stalled engine, or an engine that only a person (or Claude) can start.

**Working without Claude (production evidence in the last 24 hours to 7 days):**
- The standing **Fill the gaps** queue (job `field-gap-queue`, every 6 hours). It created 50 tasks and 63,614 items in 14 days and filled values in seven fields in the last 7 days. Two of its last four runs timed out (2 Nov, 06:23 and 12:23 UTC).
- Scholarship discovery, listing, AI reading and hourly publishing (jobs running every 1 to 15 minutes, no failures in 24 hours).
- Provider entry matrices for AER (`entry-matrix-read`, every 5 minutes), within a fixed list of 33 providers.
- Intake start dates and deadlines from approved calendars (`intake-dates-apply`, hourly).
- Ranking links to providers (`ranking-link`, hourly).

**Not working, or not able to run without a person:**
1. **Course description has no engine at all.** No reader, no job, no control. Coverage is 163 of 25,380 active Australian courses (0.6%) and 0 in New Zealand and Canada.
2. **Scheduled jobs › "Run on demand" does nothing useful for Layer 2.** No function drains Layer 2 refresh requests. 206 have been queued since 24 Sep to 15 Oct. No Layer 2 request has completed since 28 Sep. "Run on demand" has never been used (0 events).
3. **The provider description reader has failed every hour since 2 Nov 21:56 UTC.** The worker returns HTTP 500 (a statement time-out in `svc_provider_description_next`), but the cron job still reports *succeeded*. Its scope is also fixed in settings: Australia only, universities only, a named list of 5 providers, and a lifetime AI ceiling of US$1.
4. **Automatic enrichment plans have almost stopped.** They fell from about 420 a day (27 and 28 Oct) to 2 a day since 30 Oct, because `plans.redo_days` (14) holds every university already planned. No **manual** plan run has ever been recorded (0 rows with `mode='manual'`).
5. **AER course-level reading has no automatic job.** It runs only when a Platform Admin presses "Read next batch". Entry reading covers AU and NZ only (`entry.countries`). Canada is not included.
6. **Rankings cannot be refreshed automatically.** Each edition is a file a person uploads. The last import was September 2026.
7. **Australian page search is limited to the top 50 focus providers in shared code** (`security.enrich_focus_v1`). Official course links for any other Australian provider are found only through a "refind" wave or by a person.

**The existing controls are close to what the mandate asks for.** Enrich fields and Enrichment plan already do preview, estimate, run now, cancel and progress. The gaps are: the fields they cover, run-now and dedupe across tasks, retry and export, and the reader engines missing for three fields. No new dashboard is needed.

---

## 2. How to read the matrix

Each execution capability is marked:
- **yes**: it works in the deployed UI and is backed by the server.
- **partial**: it exists but with a limit, which is named.
- **no**: it does not exist.
- **not shown**: the code exists but production has no record of it being used.

The 11 capabilities are the ones listed in section 3 of the mandate: preview missing values, show stored evidence, estimate spend, stored-evidence-only or new acquisition, run now, schedule recurring, pause/resume, cancel safely, retry failed, monitor progress, export results.

Roles are by rank: 1 Viewer, 2 Counsellor, 3 Curator, 4 Pipeline Operator, 5 PIM Admin, 6 Platform Admin (`src/nav-map.js` `ROLE_NAMES`).

---

## 3. Controls inventory (the 10 points for each control)

### 3.1 Layer 2/3 › Enrich fields

| Point | Finding |
|---|---|
| 1. UI location | Layer 2/3 Build & enrich › **Enrich fields** tab (`#layer-2-discovery?tab=enrich`). `src/EnrichFields.jsx`, cards `layer2.enrich.start`, `.tasks`, `.sources`, `.telemetry`. The Fee reader (`src/FeeReader.jsx`) sits below it. |
| 2. Role | Opens at rank 3. **Preview** at rank 3. **Start task** at rank 4 (server: `public.admin_enrich_fields('start')` requires rank 4). **Field sources** change at rank 6. |
| 3. Actions | Choose countries **or** universities, choose fields, allow AI, allow scraper, Preview, Start task (with a reason), open a task's items filtered by field and result, change field sources per country. |
| 4. Scope | Country: yes (AU, NZ, CA from `catalogue_country_codes_v1`). Subdivision: **no**. One provider: yes. Multiple providers: yes (picker). All eligible: yes (tick every country). Course or cohort: **no**. Fields (from `security.enrich_fields_v1`): campus, duration, level, delivery, field of study, international, provider address, English (IELTS), intakes (months only), campus region. **Not covered:** course description, official link, fees, intake dates, AER, scholarships, rankings, provider description. |
| 5. Backing | `public.admin_enrich_fields` creates `pipeline.admin_jobs` (kind `enrich_fields`) plus `pipeline.field_enrich_items`. These are worked by `admin-jobs` (every minute) through `security.enrich_fields_slice_v1`. |
| 6. Deployed state | Deployed. `admin-jobs` is active, with 1,440 successful runs in 24 hours. AI guard `openrouter.guard_enrich_fields` = US$25 a day. `batch.enrich_fields` = 1,200. `enrich.ai_calls_at_once` = 20. |
| 7. Manual run works | **Yes.** 281 person-started `enrich_fields` tasks completed in 14 days (19,484 items, US$14.99 AI). The last was on 30 Oct. |
| 8. Automatic | Yes, through the standing queue (3.4) and plans (3.2). |
| 9. Evidence and cost | Stored pages first, then adapter values, then AI on the stored page, then a new scraper read only if ticked. Preview shows *Missing*, *Stored page* and *Adapter already read*. **No spend estimate before Start.** The telemetry card shows AI spend in the last 24 hours, the guard and the Firecrawl shares. |
| 10. Defects and gaps | (a) No spend estimate on Preview. (b) A manual task does **not** skip items already queued in another open task. The unique key is per task (`job_id, provider_id, course_id, field`), so a manual run and the standing queue can work the same course and field at once. The standing queue skips items in flight, but a manual start does not. (c) No retry for failed items. (d) No export. (e) Kind `enrich_fields` has `can_pause=false`. (f) Manual start does not exclude unpublished providers (the standing queue does). (g) Only 10 fields. |

### 3.2 Layer 2/3 › Enrichment plan (provider-level plans)

| Point | Finding |
|---|---|
| 1. UI location | Layer 2/3 › **Enrichment plan** (`#layer-2-discovery?tab=plan`). `src/EnrichPlan.jsx`, cards `layer2.plan.limits`, `.needs`, `.list`, `.university`. |
| 2. Role | View at rank 3. **Run now** and **Cancel the run** at rank 4. **Switch automatic on/off** at rank 6. |
| 3. Actions | List universities by missing values (country filter, search), open a plan, tick steps, see each step's Firecrawl and AI estimate, Run now with a reason, cancel the open run, switch automatic plans on or off. |
| 4. Scope | Country filter: AU, NZ or CA, but only to list. **Running is one provider at a time.** No multiple-provider or all-eligible manual run. Automatic: all eligible, priority countries first (`plans.priority_countries` = `["NZ"]`). Steps: website and central pages, find course pages, build or admit adapter, fill missing fields (6 fields: campus, duration, level, delivery, field of study, international), scholarships (only when the provider has **zero** scholarships). |
| 5. Backing | `public.admin_enrich_plan`, `security.enrich_plan_v1`, `enrich_plan_start_step_v1`. Jobs `enrich-plan-auto` (hourly at :41, `security.enrich_plan_auto_v1`) and `enrich-plan-run` (every 5 minutes, `security.enrich_plan_tick_v1`). |
| 6. Deployed state | Automatic **on** (`enrich_plan_control.auto_enabled = true`, since 21 Oct). Both jobs are active with 0 failures in 24 hours. On-demand allowance: 2,000 Firecrawl credits a day and US$10 AI a day. `plans.auto_open_max` = 40, `plans.auto_per_run` = 20, `plans.redo_days` = 14. |
| 7. Manual run works | **Not shown.** `pipeline.enrich_plan_runs` has **0** rows with `mode='manual'`, ever. |
| 8. Automatic | **Partial.** 1,591 automatic runs done, 984 of them ending "needs a person". Child tasks did real work: 863 course-page searches, 436 field fills, 310 provider fills and 1,386 scholarship scans. **But it has nearly stopped:** 420 on 27 Oct, 418 on 28 Oct, 195 on 29 Oct, then 2 a day on 30 Oct, 31 Oct and 2 Nov. Every university planned in the last 14 days is held until `plans.redo_days` passes. Nothing re-plans a university because a gap changed. |
| 9. Evidence and cost | **Best of the existing controls.** It shows a per-step estimate in credits and US$ (from the last 30 days of use), refuses Run now above the on-demand allowance left today, records the actual credits and US$ when done, and shows "fields gained". Automatic steps wait for room in each Firecrawl share and are skipped after `plans.step_wait_hours` (48). |
| 10. Defects and gaps | (a) Manual Run now has never been used, so it is unproven. (b) **Cancel the run does not cancel child tasks.** `admin_enrich_plan('cancel')` sets the run to cancelled, but the `admin_jobs` it started carry on. (c) One provider per run. (d) The steps do not cover AER, descriptions, intake dates, fees or rankings. (e) The scholarship step only fires at zero scholarships. (f) The 14-day hold stops automatic plans even when new gaps appear. (g) No export. |

### 3.3 Scheduled jobs workspace

There are two different things under **Scheduled jobs › Automations**. They are mounted together in `src/mature-main.jsx`: `<Automations/>` then `<RefreshWorkspace/>`, where `RefreshWorkspace` is `src/ScheduledJobsWorkspace.jsx`.

**(a) Automations** (`src/Automations.jsx`)

| Point | Finding |
|---|---|
| 1. UI location | Scheduled jobs › Automations, the top part (`#scheduled-jobs`). |
| 2. Role | Tab at rank 4. Controls need rank 5 or the job's `control_rank` (up to 6). |
| 3. Actions | Pause or resume one job or a whole area, **Run now**, change how often it runs, change batch size (the setting, not the job). |
| 4. Scope | One cron job at a time, with whatever scope that job has. No field, country or provider choice. |
| 5. Backing | `public.admin_automation_control` calls `security.admin_automation_control_v1`. `run_now` does `execute j.command` inside the caller's transaction. `set_every` calls `cron.alter_job`. |
| 6. Deployed state | Deployed. |
| 7. Manual run works | Pause and resume used 5 times (24 Oct). **Run now from here: not shown** (no `run_now` event in 21 days). |
| 8. Automatic | n/a (this is the cron list itself). |
| 9. Evidence and cost | None. Run now runs the job's command once. |
| 10. Defects and gaps | Run now leaves `cron.job.schedule` unchanged (correct). **Overlap protection is up to each job's own function.** Some have one (`intake_dates_apply_v1` takes an advisory lock; `field_gap_queue_tick_v1` refuses while its previous task is open; fire functions use a 4-minute fire guard). Others have none. Run now runs in the browser request, so a long job can hit the request time-out. |

**(b) Refresh schedules and one-off runs** (`src/ScheduledJobsWorkspace.jsx`)

| Point | Finding |
|---|---|
| 1. UI location | Scheduled jobs › Automations, the lower section "Refresh schedules and one-off runs". |
| 2. Role | List at rank 3 (server). **Edit schedule** and **Run on demand** at rank 4. |
| 3. Actions | Edit cadence (whole days), next run and enabled state. Run on demand (Layer 1 and 2 only). |
| 4. Scope | One `pipeline.refresh_policies` row. There are **13 policies**: 3 Layer 1 registers (CRICOS; NZQA; Education Counts), 10 Layer 2 sources (PRISMS, QILT ×4, DFAT and Study Australia scholarships, and RMIT, UQ and Federation course pages; Federation is disabled). AU and NZ only. No enrichment field is represented. |
| 5. Backing | `public.scheduler_policy_run_now_v1` calls `security.scheduler_policy_run_now_v1_browser_bridge`. It inserts a `pipeline.refresh_requests` row (`trigger_type='manual_governed'`) unless one is already `queued` or `running` for the same layer, country, source, profile and entity. The cron job `coursefinder-m2-3-refresh-intelligence-tick` (hourly at :36) creates due requests. |
| 6. Deployed state | Deployed. The tick ran 24 times in 24 hours with no failures. |
| 7. Manual run works | **No.** `pipeline.refresh_policy_action_events` has **0 rows**, so Run on demand has never been used. More importantly, **no database function drains Layer 2 requests.** Only `svc_layer1_schedule_complete` and `layer1_regulatory_scheduler_tick_impl` (Layer 1) and two retired Layer 3 services update `refresh_requests`. Layer 2 requests: 5 completed (last 28 Sep), 206 queued (3 freshness, 1 important date, 202 Layer 4 returns, oldest 24 Sep). Layer 3: 200 queued, 1,655 cancelled, 50 blocked. Layer 4: 1,703 queued. |
| 8. Automatic | Layer 1: yes (69 completed, last 29 Oct). Layer 2: **no.** |
| 9. Evidence and cost | None. |
| 10. Defects and gaps | **The run itself is not delivered for Layer 2.** Pressing Run on demand would also often report "An active request already exists ... it was not duplicated" because of stale queued rows. The surface is a legacy M2.3 refresh model that the enrichment engines do not use. The screen says "the regular schedule is unchanged", and that part is true. |

### 3.4 Coverage & completeness › Attributes (standing queue, stalled fields, provider descriptions)

| Point | Finding |
|---|---|
| 1. UI location | Coverage & completeness › **Attributes** (`#coverage?tab=attributes`). `src/FieldCoverage.jsx` cards: Stalled fields, Every field by country, **Fill the gaps (standing queue)**, Cross-check differences, Delivery wording, **Provider descriptions**. |
| 2. Role | Page at rank 1. **Check now** and **Fill now** at rank 4. Switch the queue, change targets and **Release holds and fill** at rank 6. **Read these again** (provider descriptions) at rank 5. |
| 3. Actions | Standing queue: Check now, switch on or off. Stalled fields: Fill now or Release holds and fill **per country and field**. Provider descriptions: view metrics, and Read these again for dead-letter and held providers only. |
| 4. Scope | Stalled fields: one country × one field, for Enrich fields fields only. Standing queue: all countries, all Enrich fields fields. Provider descriptions: **no scope choice.** The scope is in settings (`pdesc.countries` = AU, `pdesc.provider_types` = university, `pdesc.provider_keys` = 5 named providers). |
| 5. Backing | `public.admin_field_coverage` (`run_now`, `fill_now`, `release_and_fill`, `queue_set`) calls `admin_enrich_fields('start')`. Job `field-gap-queue` (`23 */6 * * *`). Provider descriptions: `public.admin_provider_descriptions` (`metrics`, `retry` only) and job `provider-description-read` (`6,16,26,56 * * * *`, `security.provider_description_fire_v1`). |
| 6. Deployed state | Standing queue on (since 20 Oct). Provider description reader on (`pdesc.enabled` = 1). |
| 7. Manual run works | Fill now: the source is Enrich fields (works, see 3.1). Read these again: used once (2 Nov 21:47 UTC). It re-queued ACU, Monash and Charles Darwin, **which have not moved since** (see 8). |
| 8. Automatic | Standing queue: **yes, with real work.** 50 tasks, 63,614 items and US$28.97 in 14 days. Filled in the last 7 days: delivery 496, international 495, intakes 315, campus 252, English 190, duration 100, field of study 81, level 4. Two of its last four runs failed with a statement time-out (2 Nov 06:23 and 12:23 UTC). Provider descriptions: **no.** Each hourly call since 2 Nov 21:56 UTC returned HTTP 500 (`svc_provider_description_next: canceling statement due to statement timeout`), while cron records success. Two descriptions (UQ, Wollongong) are pending in Layer 4. AI spend so far is US$0.004 of a US$1 lifetime ceiling. |
| 9. Evidence and cost | Standing queue: stored pages first, `gaps.scraper_reads_per_day` = 200, AI guard shown, `gaps.recheck_days` = 60. Provider descriptions: stored About page first, `pdesc.firecrawl_reads_max` = 20, `pdesc.ai_usd_max` = US$1 (lifetime, not daily), `pdesc.pending_max` = 10 Layer 4 items. |
| 10. Defects and gaps | (a) The provider description worker has a time-out that is hidden by a "succeeded" cron status. (b) Provider description has no operator scope or run control; scope is a settings list of 5. (c) The standing queue scan times out at the current catalogue size. |

### 3.5 Scholarship acquisition and discovery controls

| Point | Finding |
|---|---|
| 1. UI location | Scholarships › **Coverage** (`src/ScholarshipCoverage.jsx`): provider rows, tick several, **Find scholarships now**, per-provider panel (add or remove a listing page, read now, hold, publish, sign off). Layer 2/3 › **Scholarships** (`ScholarshipLayer` layers 1 and 2): countries switched on, sources, discovery and reading limits. Provider record: Scholarship search on or off (`admin_provider_sch_search`). Task manager: cancel. |
| 2. Role | Coverage at rank 3. Layer 2/3 › Scholarships at rank 4. Starting a scan needs a Task manager role (`useCanRunTasks`, rank 4 on the server). |
| 3. Actions | Find scholarships now (one or several providers), read a scholarship again, check scholarships for a course, hold or publish, listing pages, switch search per provider. |
| 4. Scope | One provider, several ticked providers, one course, one scholarship. **No country-wide or all-eligible manual run.** Countries come from the scholarship layer settings. |
| 5. Backing | `admin_jobs('start', kind 'scholarship_provider_scan' / 'scholarship_course_check' / 'scholarship_reread')`, `admin_scholarship_coverage_write`. Jobs: `scholarship-discover` (every 10 minutes), `-discover-refill` (hourly), `-listing` (every 15 minutes), `-ai-extract` (every minute), `-auto-publish` (hourly), `-recheck` (every 2 minutes), `-publication-review` (nightly). `scholarship-read` is **off**. |
| 6. Deployed state | All listed jobs are active with 0 failures in 24 hours. Firecrawl `daily_share_scholarships` = 3,500 and `scholarship_cap_per_uni` = 150. AI guard US$20 a day. |
| 7. Manual run works | **Yes.** 22 person-started provider scans in 14 days (last 30 Oct). |
| 8. Automatic | **Yes**, through the jobs above and 1,386 plan-started scans (last 30 Oct). |
| 9. Evidence and cost | The confirm dialog says only "about one credit a page". **No per-run estimate and no stored-evidence-only option.** A scan maps the site through Firecrawl. |
| 10. Defects and gaps | (a) No estimate before a scan. (b) Cancel removes the "first in line" mark but cannot stop pages already sent. Pause is not available. (c) No country or cohort selector. (d) **Australia-specific priority in shared orchestration:** `security.scholarship_discovery_refill_v1` gives `cc = 'AU'` priority 4 with reason "largest_unsearched", and other countries priority 1. |

### 3.6 AER (academic entry requirements): source, reader, coverage and review

| Point | Finding |
|---|---|
| 1. UI location | Catalogue › **Entry requirements** (`src/AerWorkspace.jsx`): tabs Provider entry matrix, Course entry requirements (with **Course-level reading**, `CourseProgramme`), **Sources, reads and holds** (Read again), Resolution inspection, plus the outcome register (Download CSV). `src/AerCoverage.jsx` (coverage by provider). Course detail › Entry requirements › **Read from the stored page** (one course, `src/EntryRequirements.jsx`). Layer 4 › Inbox (AER items). |
| 2. Role | Read at rank 1. Edit rows at rank 3. **Read again**, **Read next batch** and **Read from the stored page** at rank 6. Layer 4 AER decisions at rank 6 only. |
| 3. Actions | Preview next batch (course count and estimated US$), Read next batch (with a reason), Read again one source, read one course, download the outcome register CSV. |
| 4. Scope | Course-level reading: **one provider or "next by priority"**, batch size `entry.course_batch_size` = 50. One course. One source. Countries `entry.countries` and `entry.course_read_countries` = AU and NZ. **Canada is not eligible.** Provider matrix reading is limited to the `entry.providers` list (33 providers). Course reading is limited to `entry.course_read_providers` (41 providers). |
| 5. Backing | `public.admin_aer` (`course_batch_preview`, `course_batch`, `reread`, `coverage`), `security.course_entry_batch_v1`, `public.admin_entry_requirements`. Jobs: `entry-matrix-read` (every 5 minutes), `aer-reconcile` (hourly), `aer-outcome-register` (every 5 minutes), `programme-discover` and `programme-read` (both returned "0 rows" on every run in 24 hours). |
| 6. Deployed state | `entry.matrix_enabled` = 1, `entry.pdf_enabled` = 1, `entry.matrix_gate` = 1, AI guard US$2 a day. |
| 7. Manual run works | **Yes.** Course entry items in `field_enrich_items` in the last 7 days: 498 filled, 499 in review, 120 skipped, 51 failed (last fill 1 Nov). |
| 8. Automatic | Provider matrices: yes (288 runs in 24 hours, no failures), within the 33-provider list. **Course-level: no automatic job.** It moves only when a Platform Admin asks for a batch. |
| 9. Evidence and cost | **Good.** Stored official page only, a preview with count and cost, cost a course measured, OpenRouter floor shown, and every read goes to Layer 4. |
| 10. Defects and gaps | (a) No scheduled course-level reader. (b) Scope is fixed by provider allowlists in settings rather than by eligibility rules. (c) Canada is excluded. (d) The single-provider picker cannot take a country or several providers. |

### 3.7 Intake dates and course descriptions

| Point | Intake (month, year, start date, deadline) | Course description |
|---|---|---|
| 1. UI location | Months: Enrich fields (field "Intakes (start months)"), Coverage › Stalled fields (Fill now). Dates and deadlines: **no operator control.** Job only, visible on Automations. Calendars are approved in Layer 2/3 › Adapter builder (1.3) or Universities. | **None.** `src/course-coverage.jsx` labels it "No reader yet". |
| 2. Role | Rank 4 to start (Enrich fields). Rank 6 to approve calendars. | n/a |
| 3. Actions | Start an Enrich fields task for intakes. Run now on `intake-dates-apply` from Automations. | n/a |
| 4. Scope | Months: country or providers. Dates: all providers with an approved calendar. | n/a |
| 5. Backing | Months: `enrich_fields_slice_v1` (AI on the stored page), `coverage-admit-intakes` (adapter values, every 10 minutes). Dates: `intake-dates-apply` (`security.intake_dates_apply_v1`, hourly, advisory lock). `provider-calendar-defaults` and `provider-calendar-intakes` are **off**. | None. `catalogue.courses.description` exists but nothing writes to it. |
| 6. Deployed state | `intake_dates.apply_enabled` = true. All active jobs show no failures in 24 hours (`coverage-admit-intakes`: 2 failures in 144). | n/a |
| 7. Manual run works | Months: yes (through Enrich fields). Dates: not shown. | No. |
| 8. Automatic | Months: yes, with **low yield**: 315 filled against 14,333 "not stated" in 7 days. Dates: running (16 runs in 24 hours); real work not separately measured in this audit. | No. AU 163 of 25,380, NZ 0 of 6,495, CA 0 of 3,815. |
| 9. Evidence and cost | Stored page first. Dates carry the page wording and the calendar document. | n/a |
| 10. Defects and gaps | No operator control for dates and deadlines. Monash alone has 330 active intakes without a start date. | **No engine.** This is the largest single field gap. |

### 3.8 Ranking ingestion and refresh

| Point | Finding |
|---|---|
| 1. UI location | Rankings & statistics › **Datasets** (`src/StatisticsDatasets.jsx` and `RankingImportPanel` in `src/mature-main.jsx`). Rankings › QS or THE: link a ranked university (`admin_ranking_link`). |
| 2. Role | Datasets tab at rank 4. Linking at rank 3. |
| 3. Actions | Upload an edition file (QS, THE, ARWU) with source and licensing note, process it, link institutions to providers. |
| 4. Scope | One system and edition at a time. Not by country or provider. |
| 5. Backing | `ranking.manual_imports`, job `ranking-link` (hourly, `ranking_link_auto_v1`), job `statistics-edition-discovery` (monthly, 5th, 02:41). |
| 6. Deployed state | Both jobs active. Edition candidates: 1 applied, 5 known. |
| 7. Manual run works | Yes, historically. The last imports were THE 2022 to 2024, uploaded in Sep 2026. |
| 8. Automatic | Linking: yes (24 runs in 24 hours, no failures). **Acquisition: no.** A new edition must be uploaded by a person. This is by design (licensing), but there is no reminder or queue item when a new edition is found. |
| 9. Evidence and cost | No AI and no Firecrawl. |
| 10. Defects and gaps | No "new edition found → task for a person" link. Ranking is not part of Enrichment plan. |

### 3.9 Platform health, Work queues and Integration queue

| Point | Finding |
|---|---|
| 1. UI location | Platform health › Health checks, **Work queues** (`src/QueueWatch.jsx`), **Integration queue** (`src/IntegrationQueue.jsx`, with **Pipeline yield**). |
| 2. Role | Checks and queues at rank 3. Integration queue at rank 5. |
| 3. Actions | Check now (work queues). The integration queue is read only. |
| 4. Scope | Platform-wide. |
| 5. Backing | `queue-watch` (every 15 minutes), `integration-validate` (21 and 51 past each hour), `admin_pipeline_yield`. |
| 6. Deployed state | Both jobs active with no failures in 24 hours. |
| 7. Manual run works | n/a (monitoring). |
| 8. Automatic | Yes. |
| 9. Evidence and cost | Pipeline yield shows stage by stage, so "ran but did nothing" is visible. |
| 10. Defects and gaps | **The provider description failure (3.4) is a "job succeeded, worker failed" case.** Check whether Work queues and Integration queue raised it. Neither has a provider-description or course-description lane in this audit's reading of the code. An integration item cannot start or redirect work. This is correct per the mandate (§4), but it means each item still needs an engineer. |

### 3.10 Layer 4 review

| Point | Finding |
|---|---|
| 1. UI location | Layer 4 Review › Inbox (`src/Layer4Inbox.jsx`), by university or by kind (provider description, AER, course link, held scholarship, and others). |
| 2. Role | Opens at rank 3. Decisions at rank 4. AER decisions at rank 6. |
| 3. Actions | Approve, reject or correct per item, and governed batches. |
| 4. Scope | Item, kind or university. |
| 5. Backing | Layer 4 inbox functions and `layer4-auto-admit` (hourly). |
| 6 to 8. | Running. Provider description: 2 pending. AER: about 499 items in review in 7 days. |
| 9. Evidence and cost | Each item shows its quote and stored page. |
| 10. Defects and gaps | Throughput is limited by people. Provider descriptions stop at `pdesc.pending_max` = 10 waiting items. |

### 3.11 Other places that start enrichment

- **Course detail › What happened › Read with AI** (`src/CourseAudit.jsx`, `admin_course_read_now`): one course, read again first in line, then fill missing fields with AI. Server-gated (`can_read_now`).
- **Provider record › Fill in from website** (`JobButton` kind `provider_fill`).
- **Layer 2/3 › Course sources** (`src/CourseSources.jsx`) and the job `source-find`.
- **Layer 2/3 › Operations** (`src/Layer23Operations.jsx`): pause, resume and run now for the jobs of each stage, and governed actions.
- **Scheduled jobs › Task manager** (`src/AdminTasks.jsx`): pause, resume and cancel tasks started by people or plans, plus background jobs.

---

## 4. Field matrix

### 4.1 Overview

| Field | Existing UI control | Manual (operator) | Automatic | Verified in production | Countries AU / NZ / CA |
|---|---|---|---|---|---|
| Course description | **None** | No | No | No engine. AU 0.6%, NZ 0%, CA 0% | None |
| Official course link | Enrichment plan "Find course pages", Course sources, provider Fill in, Course detail | Partial (one provider a run; task button) | Yes (`course-link-search` every minute; plan steps) | 1,555 page-find tasks in 14 days. Coverage AU 67%, NZ 44%, CA 70% | Shared engine, **AU limited to top 50 focus providers in code** (`enrich_focus_v1`) |
| Tuition and fees | Enrich fields › Fee reader (per provider: add, stop or resume a fee page, read again), fee schedule approvals (rank 6) | Partial (one provider, one page) | Yes (`fee-reader` every minute, `provider-fee-profiles-apply`, `fee-period-settle`) | Jobs succeed (1,440 a day). Yield not measured here | Shared reader with per-country rules (built for NZ, then CA) |
| Intake month | Enrich fields (Intakes), Stalled fields Fill now | Yes | Yes (standing queue, `coverage-admit-intakes`) | 315 filled, 14,333 not stated in 7 days | Shared |
| Intake year, start date, deadline | **None** (job only; calendar approvals) | No (Automations Run now only) | Yes (`intake-dates-apply` hourly) | Running. Monash: 330 intakes without a start date | Shared; depends on approved calendars |
| Academic entry requirements (AER) | Entry requirements › Course-level reading, Sources Read again, Course detail read | Yes (rank 6; one provider or next by priority) | Provider matrix yes; **course-level no** | 498 filled and 499 in review in 7 days (manual) | AU and NZ only (`entry.countries`); **CA not eligible** |
| English entry requirements | Enrich fields (English), adapters, policy defaults | Yes | Yes (standing queue, `provider-english-defaults`) | 190 filled, 10,066 not stated in 7 days | Shared |
| Scholarships | Scholarships › Coverage Find now, Layer 2/3 › Scholarships, Plan step | Yes (one or several providers) | Yes (discover, listing, AI, publish) | 22 manual and 1,386 plan scans; all jobs green | Shared, **AU priority hardcoded** in `scholarship_discovery_refill_v1` |
| Rankings | Rankings › Datasets import, link | Yes (file upload) | Linking yes; acquisition no | Last import Sep 2026 | System-wide (not by country) |
| Provider description | Coverage › Attributes › Provider descriptions (metrics, Read these again) | **Partial** (retry dead or held only) | **No (failing)** | HTTP 500 every hour since 2 Nov 21:56 UTC | **AU only, 5 named providers** (settings) |
| Campus, duration, level, delivery, field of study, international | Enrich fields, Stalled fields, Plan "Fill missing fields" | Yes | Yes | Delivery 496, international 495, campus 252, duration 100, field of study 81, level 4 filled in 7 days | Shared; CA rules in code (`enrich_fields_slice_v1`, `enrich_campus_list_apply_v1`) |
| Provider address, campus region | Enrich fields | Yes | Yes (standing queue) | Address 0 filled in 7 days | Shared; CA province rule in code |

### 4.2 Execution capabilities by control

Columns: P = preview coverage and missing values, E = show stored evidence, $ = estimate Firecrawl and AI spend, S = stored-evidence-only versus new acquisition, R = run now, Sch = schedule recurring, PR = pause and resume, C = cancel safely, Rt = retry failed, M = monitor progress, X = export results.

| Control (fields) | P | E | $ | S | R | Sch | PR | C | Rt | M | X |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Enrich fields (10 fields) | yes: Missing, stored page and adapter counts (`admin_enrich_fields('preview')`) | partial: count of stored pages; per-item quote after the run | **no** | yes: AI and scraper ticks | yes (rank 4) | partial: only through the standing queue (one global switch) | **no** (`can_pause=false`) | yes: Task manager cancel | **no** | yes: task rows, 15-second refresh, Task manager pulse | **no** |
| Enrichment plan (link, adapter fields, 6 fields, scholarships) | yes: per provider | no | **yes**: per step, against the allowance | partial: automatic waits for shares; manual uses on demand; no "stored only" switch | yes (rank 4), **not shown** | yes: automatic plans (on/off) | partial: automatic on/off only | **partial**: the run cancels, its child tasks do not | no | yes: steps and runs, 20-second refresh | no |
| Stalled fields and standing queue | yes: per country and field | no | partial: spend today and guard | yes (fixed order) | yes: Check now, Fill now | yes (6-hourly) | yes: switch on or off | via Task manager | partial: Release holds and fill (rank 6) | yes | no |
| Provider descriptions | yes: metrics | partial: stored About page counts | partial: ceiling and spend shown | yes (settings) | **no** | yes (job) | no | no | partial: Read these again (dead or held) | yes: metrics | no |
| AER course-level reading | yes: by provider | partial: the Layer 4 item shows the page | **yes**: preview with US$ | yes: stored page only | yes (rank 6) | **no** | no | no | partial: Read again per source | yes: programme table | **yes**: outcome register CSV |
| Scholarships › Coverage | yes: per provider | yes: per provider panel | **no** ("about one credit a page") | no | yes | yes (jobs) | partial: Automations only | partial | partial: read again | yes | no |
| Scheduled jobs › Automations | no | no | no | no | yes (`execute` inline) | yes (frequency) | yes | n/a | no | partial: last run and 24 hours | no |
| Scheduled jobs › Refresh schedules | no | no | no | no | **broken for Layer 2** | yes (whole days) | yes (enabled) | no | no | partial: queue list | no |
| Rankings › Datasets | partial | yes: file and source | n/a | n/a | yes (upload) | no | n/a | n/a | yes: re-process | yes | no |
| Intake dates | no | no | n/a | yes | Automations only | yes | Automations only | n/a | no | no | no |

### 4.3 Country support (AU, NZ, CA)

The mechanism is mostly shared: one set of tables, workers and settings, with country lists held in settings. Country-specific behaviour found **in code** in shared orchestration:

| Function | What is hardcoded | Effect | Correction |
|---|---|---|---|
| `security.enrich_focus_v1` (used by `course_link_search_eligible_v1`, `svc_course_link_search_next`, `coverage_ai_match_prepare_v1`, `svc_coverage_discovery_next` and 6 others) | `coverage_country(...) <> 'AU'` | Australian providers outside the top 50 focus list (`enrich.focus_top_n`) never get course-page search or discovery unless they are in a "refind" wave. NZ and CA always do. | Replace the literal with a setting, `enrich.focus_countries` (default `["AU"]`), so the rule is configuration. Or retire the focus gate once the credit window allows. |
| `security.enrich_focus_refresh_v1` | `d.country_code = 'AU'` | The focus list is built for AU only. | The same setting. |
| `security.scholarship_discovery_refill_v1` | `case when q.cc = 'AU' then 4 else 1 end` | AU gets a different priority and reason in the shared refill. | Move to a setting, `scholarship.refill_priority_by_country`. |
| `security.enrich_fields_slice_v1`, `security.enrich_campus_list_apply_v1` | `cc = 'CA'` rules (institution rule; province) | Country rules in code. Acceptable as adapters, but they belong in country rules. | Move to `pipeline.field_source_rules` or a country rule table when next touched. |
| `security.enrich_entry_record_v1` | `cc = 'NZ'` NCEA and UE means domestic | Country rule in code. | Move to `entry.domestic_audience_words` per country. |

Country eligibility held in **settings** (configurable, but CA is missing):

| Setting | Value |
|---|---|
| `entry.countries`, `entry.course_read_countries`, `aer.eligible_countries` | AU, NZ |
| `pdesc.countries` | AU |
| `plans.priority_countries` | NZ |

**Missing adapters to report:** course description (no reader in any country), and AER and provider description for CA (not eligible). Per §7 of the mandate, these should be integration queue items.

---

## 5. Manual Run now, the recurring schedule, and overlaps

| Run-now path | Changes the recurring schedule? | Overlap with automatic runs |
|---|---|---|
| Scheduled jobs › Refresh schedules › **Run on demand** (`scheduler_policy_run_now_v1`) | **No.** It writes `before_state` and `after_state` with `policy_unchanged:true`; cadence and `next_due_at` are untouched. | Deduplicated: no new request when one is `queued` or `running` for the same layer, country, source, profile and entity. The policy row is locked `for update`. **But Layer 2 requests are never processed** (see 3.3). |
| Scheduled jobs › Automations › **Run now** (`admin_automation_control_v1('run_now')`) | **No.** It runs `execute j.command` once. Only `set_every` alters the cron job. | **No central lock.** It relies on each job's own guard: advisory lock (`intake_dates_apply_v1`), open-task check (`field_gap_queue_tick_v1`), 4-minute fire guard (`entry_matrix_fire_v1`, `provider_description_fire_v1`). Jobs without a guard can overlap. |
| Enrichment plan › **Run now** | Does not touch `enrich_plan_control` or the cron jobs. | One open run per provider, manual or automatic (`a plan is already running for this university`). The automatic picker skips providers with an open run. The manual run is charged to its own on-demand allowance. |
| Enrich fields › **Start task**, Stalled fields › **Fill now** | n/a | **Not deduplicated across tasks.** The standing queue skips items in flight, but a manual start creates a second item for the same course and field if another task holds it. Both may then spend AI on it. |
| Coverage › **Check now** (standing queue) | No. | Refuses while the previous standing task is open (`previous run still open`). |

**Plain answer:** a manual Run now never changes a recurring schedule on any path. Overlap protection is per engine, and it is missing for Enrich fields manual tasks and for Automations Run now on jobs without their own guard.

---

## 6. Defects and gaps, ranked by how much they block self-sustainability

Each corrective task extends an existing control or engine. None needs a new dashboard.

| # | Defect or gap | Blocks | Corrective engineering task (smallest change) | Owner |
|---|---|---|---|---|
| 1 | **Course description has no reader, no job and no control.** AU 0.6%, NZ and CA 0%. | A whole field, in every country | Add a `course_description` field to `security.enrich_fields_v1` (source `ai_stored`, quote-backed, Layer 4 for first admission as for provider descriptions). This brings it into Enrich fields, Stalled fields, the standing queue and Plan at once. Reuse the provider description gates (`pdesc.*` style settings: max characters, superlatives, claim words). | C |
| 2 | **Provider description worker times out every hour** (`svc_provider_description_next`, HTTP 500 since 2 Nov 21:56 UTC) **while cron reports success**. | Provider description; hides failure | Fix the query in `svc_provider_description_next` (it scans for 5 providers and should be indexed by `state, next_try_at`). Add a `provider_description` lane to `queue-watch` and Pipeline yield so a 500 from the worker raises Stuck. | C, then F |
| 3 | **Scheduled jobs › Refresh schedules › Run on demand is not delivered for Layer 2** (206 queued since September, no drain function). | Trust in the Scheduled jobs workspace | Either (a) mark the 10 Layer 2 policies `retiring` in `pipeline.component_register`, hide Run on demand for Layer 2 and point the row to the engine's own control, or (b) add a Layer 2 drain that maps each policy to its engine. (a) is smaller and honest. Close stale `queued` requests through a paste file. | F |
| 4 | **Automatic enrichment plans have nearly stopped** (2 a day since 30 Oct) because of the flat 14-day hold. | Automatic progress for links, adapters and scholarships | In `enrich_plan_auto_v1`, also allow a provider whose missing count rose or whose last plan ended `needs_person` that was since resolved. Make the redo window per step. Count "providers eligible but held by redo" on the Plan limits card. | F |
| 5 | **AER course-level reading has no automatic job**, and Canada is not eligible. | AER in automatic mode; CA | Add job `course-entry-read` calling `course_entry_batch_v1(null, batch, ...)` behind a switch (`entry.course_auto_enabled`, default off) with a daily US$ cap. Replace the provider allowlists with eligibility rules. Add CA to the country settings when its adapter exists, and raise an integration item until then. | A |
| 6 | **Australian top-50 focus hardcoded** in shared course-link and discovery orchestration (`enrich_focus_v1`). | Official course link for most AU providers | Replace `'AU'` with the setting `enrich.focus_countries`. Show the focus rule on Layer 2/3 › Course sources. | F |
| 7 | **Enrich fields manual tasks are not deduplicated** against other open tasks. | Cost; double writes | In `admin_enrich_fields('start')`, skip a course and field whose latest item is `queued`, `waiting`, `ai`, `leased` or `review` (the same rule as `field_gap_queue_tick_v1`), and exclude hidden providers. Preview shows "already in a task: n". | F |
| 8 | **Enrichment plan Cancel leaves child tasks running.** | Cancel safely | In `admin_enrich_plan('cancel')`, call `admin_jobs('cancel')` for each step `ref` that is still running, and stop or retry onboarding. | F |
| 9 | **No spend estimate before Enrich fields Start or Find scholarships now.** | Cost control | Add `est_credits` and `est_usd` to `admin_enrich_fields('preview')` from `security.enrich_unit_costs_v1` (already used by Plan). Add the same to the scholarship confirm. | F, B |
| 10 | **No retry of failed items, no export** in Enrich fields and Plan. | Operability | Add `retry` (failed items in a finished task go into a new task) and `export` (CSV of items with source and quote, in pages, as the AER outcome register does). | F |
| 11 | **Standing queue scan times out** (2 of the last 4 runs). | Automatic gap discovery | Split the `_gap` build per field or country, or read from `pipeline.course_attribute_coverage`, which is already counted hourly. | E |
| 12 | **Intake start date and deadline have no operator control**, and the two calendar jobs are off. | Manual mode for intake dates | Add a "Dates from calendars" row to Stalled fields with Fill now calling `intake_dates_apply_v1` scoped to one provider (new argument), and show `course_intake_dates` outcomes. | D |
| 13 | **Provider description scope is a fixed list** (AU, universities, 5 providers) with a **lifetime** US$1 ceiling. | Scale | Make the scope eligibility-based (country and provider-type settings), make the ceiling daily, and add Run now for chosen providers to the Provider descriptions card (rank 5). | C |
| 14 | **Ranking edition found but no task raised.** | Rankings freshness | When `statistics-edition-discovery` finds a new candidate, raise a Layer 4 or Dashboard item "New edition: upload". | F |
| 15 | **Australian priority hardcoded in scholarship refill.** | Country fairness | Move to a setting. | B |

---

## 7. Operator walkthrough for the acceptance test (manual mode)

**Who:** the Platform Admin (rank 6), signed in to the deployed Admin.
**When:** outside Sydney minutes :35 to :42 and :47 to :48, so the run does not compete with heavy jobs.
**Each step uses a reason** beginning `Acceptance test 3 Nov (manual)` so the integrator can find it.
**The scopes are small on purpose.** Each was chosen from production on 3 Nov.

After each step, tell the integrator the time you pressed the button. The integrator then runs **read-only** checks only. The integrator does not press anything.

### 7.1 University (provider) description

**Status: not possible in the UI today as a chosen scope.** There is no Run now for a chosen provider. The only control re-queues held or dead-letter providers, and the reader is failing (defect 2).

What you can do now:
1. Open **Coverage & completeness › Attributes**. Scroll to **Provider descriptions**.
2. Read the figures. Expect "Reader on", 2 in Layer 4, Remaining 3, Last run around 2 Nov 22:56 UTC.
3. Open **Layer 4 Review › Inbox** and choose kind **Provider description**. You should see **The University of Queensland** and **University of Wollongong**. Approve or reject each one against its quoted About page, with a reason.

What the integrator checks afterwards:
- `pipeline.layer4_review_items` (`field_code='provider_description'`): the status changed, with the actor and time.
- `catalogue.providers.description` for the two providers is set only if approved.
- `public.website_v2_*` read-back (consumer API unchanged in shape).
- Edge log: `provider_description` calls still return 500 until defect 2 is fixed.

**Gap named:** a provider description Run now for chosen providers (defect 13), and the worker time-out (defect 2).

### 7.2 Course description

**Status: not possible.** There is no reader, job or control. See defect 1.

### 7.3 Intake (month) at Monash University

1. Open **Layer 2/3 Build & enrich › Enrich fields**.
2. Under **Universities**, type `Monash` and choose **Monash University**. Leave countries empty.
3. Under **Fields**, tick **Intakes (start months)** only.
4. Under **Sources**, tick AI may read stored pages. **Leave the scraper unticked** (stored-evidence-only).
5. Press **Preview**. Expect about 252 missing and about 508 courses with a stored page (582 active courses). There is **no cost estimate** (defect 9).
6. Type the reason and press **Start task**. Expect "Task started: N item(s) to settle".
7. Watch the task under **Enrich fields tasks**, and in **Scheduled jobs › Task manager**.
8. When it finishes, open the task and filter Result **Filled**. Each row shows the month, the source "AI reads the stored page" and the words on the page. Examples of courses without intakes: *Master of Advanced Study (Engineering Research)*, *Master of Engineering Science (Research)*.

What the integrator checks afterwards:
- **Job created:** `pipeline.admin_jobs` kind `enrich_fields`, your reason, `args.provider_ids` = Monash, `args.fields` = `["intakes"]`, `args.scraper` = false.
- **Scope correct:** every `field_enrich_items` row for the job has Monash's provider ID and field `intakes`.
- **Execution began:** item states move from `queued`; `admin-jobs` runs are green.
- **Stored evidence used:** `source` = `ai_stored`; no `coverage_vendor_usage` with `purpose` like enrich in the window.
- **Real work:** count of `filled` against `skipped` (expect a low fill rate; see §4.1).
- **Admission rules:** `catalogue.course_intakes` gained rows only where filled; locked values were untouched (`pipeline.manual_locks`).
- **Layer 4:** intakes do not go to Layer 4 (by design).
- **Catalogue and API:** `search.refresh_requests` and `website_v2_*` read-back for 2 filled courses.
- **Audit and cost:** `admin_job_events`, `field_enrich_items.cost_usd` sum, and the OpenRouter ledger.
- **Overlap:** whether a standing-queue item for the same course was open at the same time (defect 7).

### 7.4 Intake start date and deadline

**Status: not possible as an operator-scoped run.** The only manual lever is **Scheduled jobs › Automations › Intake dates (job `intake-dates-apply`) › Run now**, which runs the whole platform's batch once.

If you choose to press it: expect no change to the schedule. The integrator checks `pipeline.course_intake_dates` rows with `applied_at` in the window, `catalogue.course_intakes.start_date` for Monash examples (*Master of Business Administration*, *Bachelor of Art History and Curating*), and that `cron.job` schedule `26 * * * *` is unchanged.

**Gap named:** defect 12.

### 7.5 AER academic requirement at Monash University

1. Open **Catalogue › Entry requirements › Course entry requirements**. Scroll to **Course-level reading**.
2. In **Provider**, choose **Monash University** (it is in the course-read list).
3. Press **Preview next batch**. Expect up to 50 courses and an estimated US$ figure (about US$0.005 a course). If a refusal shows (for example the OpenRouter floor), stop and note it.
4. Press **Read next batch**, give the reason, and confirm **Ask**.
5. Watch the *Reading*, *Waiting in Layer 4* and *Admitted* columns for Monash. Examples of Monash courses with a stored page and no AER: *Master of Business Administration*, *Master of Engineering Science (Research)*.
6. In **Layer 4 Review › Inbox**, kind AER (**Course entry first read**), decide one or two items, one at a time, against the quote.

What the integrator checks afterwards:
- `field_enrich_items` (field `entry_requirements`) and the course entry runs for Monash in the window: count against the preview.
- Stored page only (no new Firecrawl).
- Layer 4 items created, one per course.
- Admitted rows only after your decision (`catalogue.course_entry_requirements` status).
- The outcome register (`aer-outcome-register`) moved the courses from *no requirement* to *awaiting review* or *admitted*.
- Cost against the preview estimate.
- Consumer API AER read-back for an admitted course.

### 7.6 Scholarship discovery at Australian Catholic University and Charles Darwin University

1. Open **Scholarships › Coverage**. Search for **Australian Catholic University** (8 active scholarships) and **Charles Darwin University** (3). Both were last scanned on 12 Oct.
2. Tick both rows and press **Find scholarships now**. The confirm says "about one credit a page". There is no estimate (defect 9).
3. Follow the task in **Scheduled jobs › Task manager**. Its result line shows pages read, new scholarships, course links changed and credits.
4. Afterwards, open each provider's panel on Coverage. New scholarships appear held or published under the hourly publishing rules. Spot-check one against its page.

What the integrator checks afterwards:
- `admin_jobs` kind `scholarship_provider_scan` with both provider IDs.
- `scholarship_pages` and candidates requested and read; `coverage_vendor_usage` credits against the cap of 150 per university.
- Scholarship AI extractions; publish decisions by `scholarship-auto-publish`; held items in Layer 4 (Held scholarship).
- `scholarship-course-attribute` sync, and `website_v2_*` scholarship read-back.
- Audit: job events and the reason.

### 7.7 Ranking refresh

**Status: partly possible.** Upload is manual by design. Linking is automatic.

1. Open **Rankings & statistics › Datasets**. Under ranking imports, review the latest editions held (THE 2022 to 2024 were uploaded in Sep 2026).
2. **Only if you hold a licensed new edition file:** choose the system and edition, fill in the source and licensing note, upload, and process.
3. Otherwise, open **Rankings › QS** or **THE**, filter **Australia** and **Not linked**, and link one university to its provider.

What the integrator checks afterwards:
- `ranking.manual_imports` row and status; observations count for the edition.
- `ranking-link` run after the upload and `observation_provider_links` added.
- The provider's best rank in Enrichment plan and the website rankings field (if display is allowed in the Website API settings).

**Gap named:** no task is raised when a new edition is found (defect 14).

### 7.8 One more manual check: Enrichment plan Run now (never used before)

1. Open **Layer 2/3 › Enrichment plan**. Filter **Australia** and search **Charles Darwin University**. Press **Open plan**.
2. Read each step's *Why*, *Fills* and estimate. Untick anything over the on-demand allowance. Give the reason and press **Run now**.
3. Watch the steps move. Do **not** press Cancel during the test, because of defect 8.

What the integrator checks afterwards: an `enrich_plan_runs` row with `mode='manual'`, the steps' child `admin_jobs` with `plan_mode='manual'`, `coverage_vendor_usage.on_demand_run` = that run, and estimate against actual.

---

## 8. Automatic mode: what can be observed today without touching anything

| Field | Unattended today? | Evidence to watch (read-only) |
|---|---|---|
| Campus, delivery, duration, field of study, international, English, intake months | Yes (standing queue every 6 hours; plans) | New `enrich_fields` task with `args.standing` every 6 hours; `filled` per field per day; `field-gap-queue` failures |
| Official course link | Yes, except AU outside the top 50 | `course_page_find` tasks; `course-link-search` runs; coverage per country |
| Scholarships | Yes | discover, listing, AI and publish runs; new published scholarships per day |
| AER provider matrices | Yes (33 providers) | `entry_matrix_runs` states |
| AER course-level | **No** | Nothing moves without a person |
| Intake dates | Yes | `course_intake_dates` applied per hour |
| Provider description | **No (failing)** | Edge log 500s |
| Course description | **No** | None |
| Rankings | Linking only | `ranking-link` |

The acceptance test's automatic mode cannot pass for course description, provider description or AER course-level reading until defects 1, 2 and 5 are fixed.

---

## 9. Evidence log (read-only queries, 3 Nov 2026)

| Time (AEDT) | What was read |
|---|---|
| 09:33 to 09:45 | `cron.job` (all 155 jobs, schedules, active); function definitions for `admin_enrich_fields`, `admin_enrich_plan`, `enrich_plan_v1`, `_auto_v1`, `_tick_v1`, `_start_step_v1`, `_priority_v1`, `field_gap_queue_tick_v1`, `scheduler_policy_run_now_v1` and its browser bridge, `scheduler_policies_list_v1` and its bridge, `refresh_scheduler_tick_impl`, `admin_automation_control_v1`, `admin_jobs` (cancel and pause), `provider_description_fire_v1`, `intake_dates_apply_v1`, `entry_matrix_fire_v1`, `enrich_focus_v1`, `admin_aer` (course batch), `admin_field_coverage` (fill now); `pipeline.platform_toolset_settings` (pipeline, openrouter and firecrawl keys); `refresh_policies`, `refresh_requests`, `refresh_policy_action_events` counts; `admin_job_kinds`; control tables |
| 09:46 to 09:48 | `admin_jobs` by kind, origin and state (14 days); `enrich_plan_runs` by mode and state; `cron.job_run_details` (24 hours) for 25 jobs; `field-gap-queue` run messages (3 days); plans per day; `field_enrich_items` by field and state (7 days) |
| 09:56 to 09:58 | `admin_control_events` (21 days); course description and URL coverage by country; `provider_description_reads`, Layer 4 provider description items, AI ledger; edge log for `provider_description`; Monash sample counts; scholarship counts and last scans for 5 AU universities; ranking imports and edition candidates |

Function checksums (md5 of `pg_get_functiondef`) at the time of reading: `admin_enrich_fields` `184f74ae…`, `admin_enrich_plan` `bd460fcd…`, `enrich_plan_tick_v1` `0ba546e2…`, `enrich_plan_auto_v1` `f9409768…`, `field_gap_queue_tick_v1` `d909e54d…`, `scheduler_policy_run_now_v1` `9f94cb69…`, `provider_description_fire_v1` `8f5918c9…`, `intake_dates_apply_v1` `d15c04c6…`, `entry_matrix_fire_v1` `869da9fb…`.
