# Capacity proposals: decision paper (D8)

Lane D8, CF-247. Prepared 30 Oct 2026 for the Platform Admin's instruction of 30 Oct 2026 08:45:

> "Do not change production schedules or capacity yet. Return a concise table for each proposal: current job and schedule; observed overlap/load evidence; proposed schedule/capacity change; consumer/operator impact; expected reduction in calls or contention; rollback path; dependencies and risks. Identify which proposals are independent and which must be sequenced. No implementation until Platform Admin selects specific proposals."

**Nothing was changed.** I ran read-only queries only. No schedule, setting, job, workflow, deploy or capacity was touched. This paper builds on `2026-10-30-edge-capacity-assessment.md` (proposals P1 to P7). Where fresh evidence changes a proposal, the change is marked **Revised** and the reason is given.

## 1. Evidence used and the window

| Source | Window |
|---|---|
| `cron.job`, `cron.job_run_details`, `pipeline.mode_outcome_ledger`, `pipeline.queue_watch_state`, `pipeline.platform_toolset_settings`, `pipeline.automation_catalogue`, `pipeline.component_register`, `pipeline.job_idle_watch` | **W24:** 28 Oct 21:49 to 29 Oct 21:49 UTC (29 Oct 08:49 to 30 Oct 08:49 AEDT) |
| Same tables, close look | **W3:** 29 Oct 18:49 to 21:49 UTC (30 Oct 05:49 to 08:49 AEDT) |
| Supabase logs (`function_edge_logs`, `edge_logs`) | W24 |
| GitHub Actions run list (`Coursefinder-Pilot`) and `.github/workflows` | 29 Oct 05:30 UTC to 29 Oct 21:30 UTC |

Project `fxcwkweaxjtknorudmwp` only. The ledger figure "empty call" here means `items` was 0 or null. The assessment parsed each call's detail instead, so the two measures differ slightly.

### 1.1 Where things stand now (W24)

- **Cron:** 146 jobs, 140 active, 40,490 runs. They used **2,663 job-minutes in 1,440 minutes**, so on average **1.85 cron sessions are busy at once** on a 2-core database (the assessment measured 1.7 over 72 h). Each hour averages 6.5 to 8.4 runs over 1 s active per minute, with peaks of 15 to 19.
- **45 failed runs, all statement time-outs at 120 s.** They fall on a few minutes:

| Minute ends in | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|---|---|---|---|---|---|---|---|---|---|---|
| Cron time-outs | **31** | 9 | 0 | 0 | 0 | 0 | 0 | 5 | 0 | 0 |
| Busy job-minutes | **969** | 156 | 246 | 122 | 250 | 84 | 277 | 213 | 277 | 69 |
| Average length of runs over 5 s | **42.9 s** | 24.9 | 24.8 | 18.1 | 20.8 | 13.7 | 27.4 | 26.5 | 23.8 | 10.6 |

  - The 9 at minute 1 are all enrich-plan-auto (:41).
  - The 5 at minute 7 are waste-guard (:17) four times and the daily l4-rule-low-agreement (:37) once.
  - By job: coverage-ai-match-prepare 14, enrich-plan-auto 9, coverage-admit 6, coverage-admit-intakes 5, adapter-overwrite 5, waste-guard 4, l4-rule-low-agreement 1, coverage-bind 1.
- **New finding: the :x0 minute slows everything that starts in it.** Job 96 (coverage-ai-match-prepare) has a p50 of **95.5 s** on minutes ending in 0 and **42 to 46 s** on minutes ending in 2, 4, 6 and 8. **All 14 of its time-outs started on a minute ending in 0.** website-sync-check averages 29.1 s at :x0 and 11.6 to 20.9 s elsewhere; fee-reader averages 24.8 s and about 15 s. One coverage-admit time-out (07:20 AEDT) was waiting on the `search_course_documents_writer` advisory lock. The admission jobs also queue behind each other when they start together.
- **Edge (`coverage-sweep` and the other functions):** about 19,150 calls (about 800 an hour). 5xx counts: 503 188, 502 59, 500 50, 546 29. The bursts were on 29 Oct from 21:00 to 02:00 AEDT. Since 03:00 AEDT there have been 3 to 6 an hour. About half of all calls finish at seconds 7 to 14 of the minute, so the start-of-minute fan-out is still there.
- **Worker ledger:** 18,049 calls and 1,831 worker-minutes. 16,846 calls (93%) and 1,522 worker-minutes (83%) returned no items.
- **Admin reads:** the deployed suite still drives the high-volume hours: 3,775, 3,923, 4,614 and 7,030 calls an hour on 29 Oct, then 1,168 and 2,040 at 00:00 to 01:59. **The 08:00 AEDT hour on 30 Oct had 3,223 calls in 49 minutes with 0 time-outs** (see 1.2).

### 1.2 Load added since the assessment (v2.15.373)

| Job (id) | Schedule | Since (UTC) | What a run does | Measured in W3 | Estimated load a day |
|---|---|---|---|---|---|
| admin-read-snapshots (346) | `* * * * *` | 29 Oct 21:18 | Checks three cached admin snapshots. It rebuilds platform notices every 5 min (`snapshots.platform_notices_every_minutes` 5) and field coverage and scholarship publishability every 10 min (settings 10). A rebuild also happens within a minute after a person's fix. One build at a time. | 32 runs: p50 0.2 s, p90 9.0 s, max 21.4 s. Rebuilds took 4.8 to 9.2 s (notices) and 18.4 to 21.4 s (all three). Observed on minutes ending in 3 and 8. | about 65 job-minutes (about 2.4% of cron busy time). No edge calls. |
| course-coverage-snapshot (345) | `2-59/5 * * * *` | 29 Oct 21:22 | Rebuilds coverage totals only when an hourly source build has changed, at most every `snapshot.course_coverage_min_interval_minutes` (10). It skips if busy, and a 2 s lock wait means it never queues behind a source build. | 6 runs: 1.1 to 3.1 s | about 5 job-minutes (negligible). No edge calls. |

- **The rebuild minute of admin-read-snapshots drifts.** A rebuild falls due at `generated_at` plus the interval, so it is not pinned to minutes 3 and 8. It can land on a :x0 minute. That would add 5 to 21 s of work to the busiest minute. The impact is small, and P1 makes it smaller.
- **It is already paying for itself.** In the 30 Oct 08:00 AEDT hour (*Deployed weekly run* plus six push runs), the admin p90 times were 0.7 s for `admin_platform_notices_read` (3.0 to 3.7 s at 00:00 to 01:59 AEDT) and 1.5 s for `admin_field_coverage` (3.2 to 4.8 s), with **0 admin 8 s time-outs**. The same hour still had a coverage-ai-match-prepare time-out at 21:20 UTC.

### 1.3 adapter-overwrite (112): one time-out in 18 runs (W3)

| Start (UTC) | Length | Result |
|---|---|---|
| 19:00 to 20:10 (8 runs) | 0.9 to 93.1 s | succeeded |
| **20:20:01** | **120.0 s** | **statement time-out** (`r.c->>'english_by' = 'adapter' …` in `adapter_overwrite_v1`) |
| 20:30, 20:40 | 104.2 s, 99.8 s | succeeded |
| 20:50 to 21:40 (6 runs) | 0.9 to 1.2 s (nothing new: gated), except 21:20 at **111.8 s** | succeeded |
| 21:50 | **112.3 s** | succeeded |

- **At 20:20:01 UTC, four jobs started within one second** and all hit 120 s together: coverage-admit, coverage-admit-intakes, coverage-ai-match-prepare and adapter-overwrite. website-sync-check took 39.8 s in that minute (p50 16.9).
- **This was not deployed-test load.** That AEDT hour had 199 admin calls in total. The nearest deployed run was a 1-minute push run that ended at 20:19:13 UTC.
- So the :x0 collision **causes time-outs on its own, without UAT traffic**. adapter-overwrite's successful runs are now 104 to 112 s, within 8 to 16 s of the limit. W24 for this job: p50 80.8 s, p90 96.7 s, 5 time-outs, all at :x0.

## 2. Proposals

Every table has the same seven rows.

### P1. Move the three admission jobs off minute :x0 and away from each other. **Revised minutes**

| | |
|---|---|
| **Current job and schedule** | coverage-admit (59) `*/10 * * * *`; coverage-admit-intakes (111) `*/10 * * * *`; adapter-overwrite (112) `*/10 * * * *`. All three start at :x0:00 to :x0:01, together with coverage-ai-match-prepare (96, `*/2`), website-sync-check, fee-reader, nz-cop and link-refresh. |
| **Observed overlap/load evidence** | W24: the three jobs used 442 job-minutes and had **16 of the 45 time-outs**, all at :x0. At :x0, job 96 runs about twice as long (p50 95.5 s against about 44 s) and has all 14 of its time-outs there. W3: the 20:20 UTC four-way time-out happened with no UAT load (section 1.3). Evidence of lock queuing: coverage-admit time-out waiting on `pg_advisory_xact_lock(hashtext('cf247:search_course_documents_writer'))`. |
| **Proposed schedule/capacity change** | **Revised:** coverage-admit `3-59/10`, coverage-admit-intakes `5-59/10`, adapter-overwrite `9-59/10`. This keeps the order admit, then intakes, then overwrite. All three move to odd minutes, so none starts with job 96. The assessment's minutes `1`, `5` and `7` are **not** recommended. Minute 1 would put coverage-admit on top of enrich-plan-auto at :41 (109 s average, 9 time-outs). Minute 7 would put adapter-overwrite on top of waste-guard at :17 (108 s, 4 time-outs) and the :37 and :47 hourly groups. Minutes 3, 5 and 9 are the three quietest odd minutes that have no heavy hourly job. Applied by `cron.alter_job` in a migration. No batch size changes. |
| **Consumer/operator impact** | Consumer API shape is unchanged (G3). Admitted values land 3 to 9 minutes into each 10-minute block instead of at the start, so values on the website can arrive up to 9 minutes later. Operators see new next-run times on the Automation screen. The catalogue descriptions ("Runs only when new input has arrived…") stay correct. The admission time-out stacks show `zoho_course_search_v2` / `zoho_edge_course_search_v2` being called inside admission. Less contention at :x0 may also help Zoho reads at those moments (not measured). |
| **Expected reduction in calls or contention** | No change in edge calls (these are database jobs). The :x0 minute drops from four long jobs to one (job 96). **Expected: most of the 31 :x0 time-outs a day go away** (16 admission plus 14 for job 96 plus 1 coverage-bind). If job 96 at :x0 falls back to its normal ~44 s, that alone saves about 120 job-minutes a day. Less waiting on the search-documents writer lock. Estimated total saving: 150 to 200 job-minutes a day (6 to 8% of cron busy time). Measure after 24 h. |
| **Rollback path** | One statement per job, in a follow-up migration: `cron.alter_job(59, schedule := '*/10 * * * *')` and the same for 111 and 112. Nothing is dropped and no data changes. |
| **Dependencies and risks** | Low risk. (1) Minute 3 is shared with provider-english-defaults (20 s), the :23 scholarship-discover-refill (26 s), field-gap-queue every 6 h (68 s), the daily consumer-api-guard at 18:23 UTC (12 s) and some admin-read-snapshots rebuilds (5 to 21 s). All are light. (2) adapter-overwrite at :x9 runs about 80 to 110 s, so it ends during the next :x0 minute alongside one job-96 run. That is one partner instead of three. (3) The migration needs `-- Replaces:` and `-- Retires:` lines (s42). Catalogue rows already exist (G1). Commands keep their `pipeline_num_v1` calls (G2, s32). (4) It must be decided before P2, P5 and P7, because they choose minutes around it. |

### P2. Run coverage-ai-match-prepare (96) less often

| | |
|---|---|
| **Current job and schedule** | coverage-ai-match-prepare (96) `*/2 * * * *`. `batch.ai_match_prepare_universities` 200 and `batch.ai_match_prepare_courses` 1000 (range 1 to 5,000; `used_by` "coverage-ai-match-prepare (every 2 minutes)"). |
| **Observed overlap/load evidence** | W24: 720 runs, p50 45.7 s, p90 96.8 s, **655 job-minutes (25% of all cron busy time)**, 14 time-outs (all at :x0). Its consumer, mode `ai_match`, made 1,421 calls, and 93.9% of them returned nothing. queue-watch at 21:49 UTC: `ai_page_match` `done`, pending 0, `jobs_paused` = coverage-ai-match. The time-outs fail inside per-run setup functions (`enrich_focus_v1`, `coverage_country`, `page_match_bonus_v1` "during startup"), which points to a fixed cost per run. |
| **Proposed schedule/capacity change** | `*/2` → `*/4 * * * *`. **Alternative:** keep the schedule and halve `batch.ai_match_prepare_courses` 1000 → 500 on Settings › Pipeline settings, with a reason. That needs no migration, but the fixed setup cost means it probably saves less. |
| **Consumer/operator impact** | No consumer API effect. New candidate pages wait up to 2 extra minutes before AI matching. That is invisible while the queue is `done`. The `used_by` line must say "every 4 minutes". |
| **Expected reduction in calls or contention** | No edge calls are saved directly. **After P1:** about 360 fewer runs at ~46 s each, which is **about 275 job-minutes a day (about 10% of cron busy time)**. **Before P1:** `*/4` still starts at :00, :20 and :40, so half the :x0 collisions (and their time-outs) remain. The batch alternative's saving is unknown until measured. |
| **Rollback path** | `cron.alter_job(96, schedule := '*/2 * * * *')`, or set the batch back to 1000 on the Settings screen. |
| **Dependencies and risks** | Low risk. **Sequence after P1.** Otherwise the saving is smaller and it still collides at :x0. G2: update the `used_by` text in the same change. Risk: if a large page backlog appears, AI matching keeps up at half the rate until it is reverted. Owners should confirm why `ai_match` ran 59 times an hour while queue-watch lists coverage-ai-match as paused. |

### P3. Retire the second read lane, coverage-read-2 (159)

| | |
|---|---|
| **Current job and schedule** | coverage-read (49) and coverage-read-2 (159), both `30 seconds`, both sending `{"mode":"read","limit": batch.coverage_read}` (60, range 10 to 200, `used_by` "coverage-read, coverage-read-2 (every 30 seconds)"). `component_register`: coverage-read-2 is `active`. Switched on by `20261023027000_cf247_read_lane_settings.sql`. |
| **Observed overlap/load evidence** | W24: about 85 and 87 runs an hour (paused for 12 gaps over 700 s and 14 gaps of 40 to 700 s while the queue was empty). Mode `read`: 4,052 calls (169 an hour), 245 worker-minutes, **89.1% returned nothing**. queue-watch `course_page_read`: `nothing_left`, about 1 page an hour. Both lanes fire on the same 30 s phase and add to the start-of-minute burst. The 29 CPU-limit (546) errors in W24 come from read calls (assessment). |
| **Proposed schedule/capacity change** | `cron.alter_job(159, active := false)`. In the same change, set `component_register` coverage-read-2 → `retiring`, `replaced_by` coverage-read, `retire_after` +14 days (Decision 260). Update the `batch.coverage_read` `used_by` text to "coverage-read (every 30 seconds)". The job is unscheduled by a paste file after 14 days. |
| **Consumer/operator impact** | None visible to consumers. Read capacity stays at 60 pages every 30 s (7,200 an hour) against about 1 an hour needed now. Operators see the job as off and retiring. |
| **Expected reduction in calls or contention** | **About 85 fewer edge calls an hour (about 10% of sweep traffic)** and about 120 worker-minutes a day. One fewer call in each 30-second burst. It does **not** fix the 546s, which come from single large pages. |
| **Rollback path** | `cron.alter_job(159, active := true)` and set the register row back to `active`. |
| **Dependencies and risks** | Low risk. **Independent** of the other proposals. (1) The assessment says W30 made read claims exclusive, so one lane is safe. I did not re-verify that. (2) Job 159 is not in `pipeline.job_idle_watch`, so the waste guard will not switch it back on. Several functions do call `cron.alter_job` (`admin_automation_control_v1`, `flag_jobs_v1`, `flag_requeue_v1`, `admin_flags`), so confirm none of them re-activates 159. (3) If a large onboarding backlog arrives, read speed halves until rollback. |

### P4. Poll empty lanes less often

| | |
|---|---|
| **Current job and schedule** | All `* * * * *`: coverage-reextract (57, `batch.coverage_reextract` "pages a minute"); cricos-peo (147, "providers a minute"); coverage-discover (48) and coverage-discover-2 (79) ("sites a minute"); course-link-search-worker (81, "searches a minute"). |
| **Observed overlap/load evidence** | W24 ledger: `reextract` 58 calls an hour, **100% empty**, 104 worker-min; `cricos_peo` 59 an hour, **100% empty**, 114 worker-min; `discover` 119 an hour (two lanes), **99.2% empty**, 272 worker-min; `link_search` 59 an hour, 94.1% empty, 189 worker-min. queue-watch: `course_page_discover` `nothing_left`; `course_page_search` `moving`, 730 pending at about 1 an hour (check it maps to `link_search`). All of these fire at second 0 of every minute. |
| **Proposed schedule/capacity change** | As in the assessment: coverage-reextract `*/5`; cricos-peo `*/10`; coverage-discover-2 off and `retiring` (same housekeeping as P3); coverage-discover stays `* * * * *` behind the existing queue-watch gate pattern of credential-read (270); course-link-search-worker `*/2`. Update the `unit` and `used_by` text of each affected setting in the same change ("a minute" becomes "a run"). Optional G2-native form: a cadence setting read in the command, like `fees.run_every_minutes` for fee-reader, so operators can change the rate on Settings without a migration. |
| **Consumer/operator impact** | No consumer API effect. Any new work on these lanes waits up to 2, 5 or 10 minutes. Discover resumes within one queue-watch cycle (15 min) when work appears. Each lane's effective rate falls (for example cricos-peo becomes 2 providers every 10 minutes), so the settings' units must be updated or operators will misread them. |
| **Expected reduction in calls or contention** | **About 250 fewer edge calls an hour (about 31% of sweep traffic)** and an estimated 540 worker-minutes a day (about 30% of 1,831). The second-0 burst falls by about 5 calls a minute. This is the main lever against 502 and 503 refusals. |
| **Rollback path** | One `cron.alter_job` per job back to `* * * * *`, coverage-discover-2 back to `active := true`, the gate removed from job 48's command, and the setting texts restored. |
| **Dependencies and risks** | Medium-low risk. **Independent** of P1, P2, P5, P6 and P7. It can go with P3 (both edge-side), but on its own it is easier to measure. The discover gate relies on queue-watch (`4-59/15`) being current, and the `not exists` fallback covers a missing key. G2: no number in commands. The gate's numbers stay inside `pipeline_num_v1` defaults. s42: Replaces/Retires lines, a register row for discover-2. Edge pressure is calm right now (3 to 6 5xx an hour since 03:00 AEDT), so this is not urgent. |

### P5. Spread the hourly groups. **Revised; low value now**

| | |
|---|---|
| **Current job and schedule** | :37 no-page-propose (44 s), ranking-link (84, 39 s), exit-awards-apply (115, 37 s), plus daily l4-rule-low-agreement 03:37 UTC. :41 enrich-plan-auto (249, 109 s). :47 course-coverage-build (39 s), layer4-auto-admit (341, 38 s). :17 waste-guard (175, 108 s), adapter-build-readiness (22 s). |
| **Observed overlap/load evidence** | W24: the :37 and :47 groups had **no time-outs** apart from the daily l4-rule-low-agreement. enrich-plan-auto timed out **9 of 24 times** at :41, a minute where it has no heavy hourly neighbour. Its time-outs are in its own functions (`fc_purpose_group_v1`, `enrich_unit_costs_v1`). waste-guard timed out 4 of 24 at :17 (in `site_few_course_pages_v1`). |
| **Proposed schedule/capacity change** | **Revised:** ranking-link `7 * * * *`, exit-awards-apply `27 * * * *` (ranking stays before exit-awards; the assessment's :33 and :27 would have reversed that order), layer4-auto-admit `57 * * * *` (stays after course-coverage-build at :47; the assessment's :14 would run it before). **Drop the enrich-plan-auto move**: moving it will not fix it. Its p90 already equals the limit, so it needs the separate function review (see `20261030010000_cf247_enrich_reliability.sql`, not assessed here). |
| **Consumer/operator impact** | No consumer API effect. Ranking links, exit awards and Layer 4 auto-admissions land at different minutes each hour. Layer 4 Review sees new auto-admits about 10 minutes later. |
| **Expected reduction in calls or contention** | Small. The :37 minute drops from three ~40 s jobs to one, and :47 from two to one. No time-outs to remove today. No edge calls. |
| **Rollback path** | `cron.alter_job` back to `37`, `37` and `47`. |
| **Dependencies and risks** | Medium risk for little gain. Ordering dependencies are unconfirmed (exit-awards on ranking-link; layer4-auto-admit on course-coverage-build; whether :52 course-completeness-build or :55 course-field-source-build read layer4's output). **Sequence after P1**, so the chosen minutes stay clear of admission minutes 3, 5 and 9 (:07, :27 and :57 are). **Recommend deferring.** |

### P6. Stop deployed test runs piling onto live

| | |
|---|---|
| **Current job and schedule** | `deployed-uat.yml`: on push to `main` and `workflow_dispatch`. Its concurrency group is `coursefinder-deployed-uat-${{ github.ref }}` with `cancel-in-progress: true`, so it is per branch and cancels the earlier run. `deployed-weekly.yml`: Monday 05:17 AEDT plus dispatch, group `coursefinder-deployed-weekly`. `ui-review-screenshots.yml` and `m2-4-ux-audit.yml` also hit the live site, each in its own group (or none). No group spans all of them. |
| **Observed overlap/load evidence** | **Revised from the assessment.** On 29 Oct, 06:11 to 08:35 UTC, the 12 dispatches came from one branch (`cf247-deployed-suite-health`) **one after another, not overlapping**: 4 to 16 min each, 10 failed. They overlapped only 3 one-minute push runs. The load came from **2.4 hours of continuous full-suite re-runs** (3,900 to 7,000 admin calls an hour), not from parallel runs. On 29 Oct at 21:18 to 21:30 UTC (30 Oct 08:18 to 08:30 AEDT), the weekly run (dispatched) did overlap push runs at 21:20 and 21:27. That hour had 3,223 admin calls and 0 admin time-outs, thanks to the snapshots, but job 96 timed out at 21:20 and adapter-overwrite ran 111.8 s. |
| **Proposed schedule/capacity change** | (a) One shared group, for example `coursefinder-deployed-live`, across `deployed-uat` (all branches), `deployed-weekly`, `ui-review-screenshots` and `m2-4-ux-audit`, with `cancel-in-progress: false`. (b) A working rule: after two failed deployed dispatches in a row, stop. Fix locally and re-run only the failing specs. This may need a spec-filter input on `deployed-uat`. (c) No database capacity change. |
| **Consumer/operator impact** | No consumer effect. Deployed checks queue instead of overlapping. GitHub keeps only one pending run per group, so an intermediate push's deployed run can be superseded by a newer one. Check that the release contract (`m245`/`s70`) does not need a deployed run for every release. |
| **Expected reduction in calls or contention** | (a) Caps live admin load at one suite at a time, about 3,200 to 3,900 calls an hour instead of up to 7,000. It does not cut total calls. (b) Removes loop volume like 29 Oct (about 2.4 h of continuous suite). Together these remove the overlap of test traffic with the :x0 cluster that caused the 29 Oct afternoon and 00:00 to 01:59 time-outs. Less urgent now that snapshots cut admin read cost. |
| **Rollback path** | Revert the workflow commit. |
| **Dependencies and risks** | Low risk. **Independent** of P1 to P5 and P7. Governed by G4: Platform Admin decision, a register line, and `cf-247-s120-test-governance-contract` must still pass. No test is added or retired. Risk: a queued deployed run reports later after a merge. |

### P7. website-sync-check every 2 minutes. **Needs a freshness decision**

| | |
|---|---|
| **Current job and schedule** | website-sync-check (171) `* * * * *`, `security.website_sync_check_v1(pipeline_num_v1('batch.website_sync_check', 600))` (range 100 to 3,000). zoho-sync-check (199) `* * * * *` is unchanged. |
| **Observed overlap/load evidence** | W24: 1,440 runs, p50 16.9 s, p90 26.5 s, max 53 s, **416 job-minutes (15.6% of cron busy time)**, 0 failures. It averages 29.1 s at :x0 against 11.6 to 20.9 s elsewhere. zoho-sync-check: 115 job-minutes, max 22 s. |
| **Proposed schedule/capacity change** | `1-59/2 * * * *`: odd minutes, never :x0, never with job 96's start. Two options. **(A)** keep batch 600: the full pass goes from about 90 to about 180 minutes. **(B)** set `batch.website_sync_check` to 1200 on Settings: the full pass stays at about 90 minutes, and each run takes roughly twice as long (about 35 s). |
| **Consumer/operator impact** | **The consumer API shape is unchanged (G3), but the website developer can see this.** The developer guide (`developer-pack/StudySearch-Website-API-v2-Developer-Guide.md`, line 162) and the Wix handover v2 (line 695) say "checks every item … every minute in a rolling pass; a full pass takes about 90 minutes". Option A changes the stated freshness and needs a guide reissue. Option B keeps the 90-minute promise, but "every minute" becomes "every 2 minutes". Deltas can arrive up to 1 minute later. |
| **Expected reduction in calls or contention** | Option A: about 208 job-minutes a day (8%). Option B: smaller, about 50 to 100 job-minutes a day from fewer fixed per-run costs and leaving :x0. Not measured. No edge calls either way. |
| **Rollback path** | `cron.alter_job(171, schedule := '* * * * *')`, and the batch back to 600 on Settings. |
| **Dependencies and risks** | Medium risk (external promise). **Sequence last, after P1 to P4 are measured.** It needs the Platform Admin to decide whether 1 extra minute of delta lag (and, under A, a 180-minute full pass) is acceptable, and whether the developer guide is reissued. G3: no shape change, `s57` and the consumer-api-guard are unaffected. G2: `used_by` currently reads "website-sync-check job". Add the cadence. |

## 3. Which proposals are independent and which must be sequenced

| Proposal | Independent? | Must follow | Why |
|---|---|---|---|
| **P1** | Yes; it is the base | none | It sets the admission minutes that other proposals plan around. |
| **P2** | No | **P1** | Before P1, `*/4` still starts on :00, :20 and :40 into the admission cluster. Its saving is only clear once :x0 is calm. |
| **P3** | Yes | none | Edge-side, one job. It can go with P1 or P4. |
| **P4** | Yes | none | Edge-side. It can go with P3. Kept separate so the effect on 502/503 can be measured. |
| **P5** | No | **P1** | Its target minutes must avoid P1's minutes 3, 5 and 9. Ordering dependencies need owner confirmation first. |
| **P6** | Yes | none | GitHub-side only. Governed by G4, not a database change. |
| **P7** | No | **P1 to P4 measured**, plus a freshness decision | It is the only proposal with a developer-visible effect. Use it only if pressure remains. |

**One proposal at a time on the database side.** P1, P2, P5 and P7 all change the same per-minute load profile. Apply them in separate steps with 24 h between each, so each saving can be measured. The edge-side pair (P3 and P4) and P6 can run in parallel with any of them without blurring the database measurement.

**Measuring each step.** Re-run the queries in section 1.1 over the following 24 h. Success means: cron time-outs at no more than 2 a day, no time-outs at :x0, job 96's p50 at :x0 within 10 s of other minutes, hourly edge 5xx at no more than 10, and admin 8 s time-outs at 0 outside deployed runs.

## 4. Recommendation: what to select first

1. **Select P1 (revised minutes 3, 5 and 9) first.**
   - 31 of the 45 time-outs a day start at :x0. That includes the adapter-overwrite time-out and all 14 for job 96.
   - The 07:20 AEDT evidence shows the collision fails on its own, without test load.
   - It changes three schedule strings, has no consumer effect, and is undone with one statement per job.
   - It also unlocks P2 and P5.
2. **Select P3 alongside it.**
   - It removes about 10% of edge calls, with read capacity still far above need.
   - It is independent and low risk, and it follows Decision 260 (the second lane retires instead of lingering).
3. **Select P6 part (b), the "no re-dispatch loop" rule, now.** Part (a), the shared group, can follow.
   - The 29 Oct load came from a serial retry loop, not parallel runs. The rule costs nothing.
4. **Then, after 24 h of measurement:**
   - P2 (now worth about 10% of cron time).
   - Then P4 when edge pressure returns, or as planned upkeep.
5. **Defer P5 and P7.**
   - P5 removes no time-outs today.
   - P7 changes a promise in the developer guide. Use it only if pressure remains after P1 to P4.
6. **Outside these proposals.** enrich-plan-auto (9 of 24 runs timed out) and waste-guard (4 of 24) fail because of their own work, not the schedule. Each needs its own function review.

No implementation will start until the Platform Admin selects specific proposals.
