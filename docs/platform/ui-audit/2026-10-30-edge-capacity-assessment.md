# Capacity and schedule assessment: edge capacity against job frequency

Lane N, CF-247. Prepared 30 Oct 2026 for the Platform Admin's request (30 Oct 2026 06:53).

This was a read-only assessment. Nothing in production was changed: no schedules, settings, bindings, deploys or capacity. Section 6 lists proposals only. Each one needs a decision before anyone applies it.

## 0. Sources and exact windows

| Source | Window (UTC) | Window (AEDT) |
|---|---|---|
| `cron.job`, `cron.job_run_details`, `pipeline.mode_outcome_ledger` (W72) | 2026-10-26 19:55 to 2026-10-29 19:55 | 27 Oct 06:55 to 30 Oct 06:55 |
| Supabase logs (`function_edge_logs`, `function_logs`, `edge_logs`, `postgres_logs`) (W24; the log tool allows at most 24 h per query) | 2026-10-28 20:00 to 2026-10-29 20:00 | 29 Oct 07:00 to 30 Oct 07:00 |
| Targeted log reads for the stuck drafts | 2026-10-27 16:40 to 22:10, and 2026-10-29 12:09 to 12:41 | |
| `pg_stat_activity`, `pg_settings`, `pg_roles` | point in time, 2026-10-29 19:57 | 30 Oct 06:57 |
| `pg_stat_statements` | cumulative since 2026-08-10 (never reset), so used for ranking only | |
| GitHub Actions run list (`Coursefinder-Pilot`) | 29 Oct 03:00 to 20:00 | |

Project `fxcwkweaxjtknorudmwp` (coursefinder_Pilot, ap-south-1, Postgres 17.6, ACTIVE_HEALTHY).

**Compute tier.** `get_project` does not report the tier. `max_connections` = 120, `shared_buffers` = 1 GB and `effective_cache_size` = 3 GB match the **Medium** add-on (4 GB RAM, 2 ARM cores). This is inferred, not read directly. Other relevant values: `max_worker_processes` 6, `cron.max_running_jobs` 32, `cron.use_background_workers` off, `pg_net.batch_size` 200. Statement time-outs are 2 min for the `postgres` role (cron), 8 s for `authenticated` and `authenticator` (admin screens), and 3 s for `anon`.

## 1. Cron jobs: inventory, rates and durations (W72)

- **144 jobs, 138 active.** The 6 inactive jobs are course-link-reverse, provider-calendar-defaults, provider-calendar-intakes, cron-history-trim, cron-history-retention and onboarding-pilot-snapshot.
- **120,204 runs** in 72 h: about **1,670 starts an hour (28 a minute)**.
- **Database busy time: 7,396 job-minutes in 4,320 wall-minutes.** On average 1.7 cron sessions are running at any moment, on a 2-core database. Seven jobs account for 5,072 of those minutes (69%).
- 1,235 runs took longer than 60 s.

### 1.1 Heaviest jobs (sorted by total busy time; complete per-job table in Appendix A)

| Job (id) | Schedule | Runs/h | p50 s | p90 s | max s | Time-outs | Busy min / 72 h |
|---|---|---|---|---|---|---|---|
| coverage-ai-match-prepare (96) | `*/2 * * * *` | 30 | 43.1 | 93.0 | 120.2 | 11 | 1,835 |
| website-sync-check (171) | `* * * * *` | 60 | 15.9 | 24.8 | 53.0 | 0 | 1,171 |
| fee-reader (256) | `* * * * *` | 60 | 3.2 | 19.3 | 39.0 | 0 | 608 |
| coverage-admit (59) | `*/10 * * * *` | 6 | 82.5 | 94.5 | 120.2 | 5 | 386 |
| coverage-admit-intakes (111) | `*/10 * * * *` | 6 | 78.6 | 91.0 | 120.2 | 4 | 370 |
| adapter-overwrite (112) | `*/10 * * * *` | 6 | 77.6 | 90.0 | 120.3 | 4 | 365 |
| zoho-sync-check (199) | `* * * * *` | 60 | 3.9 | 7.5 | 51.1 | 0 | 337 |
| nz-cop (232) | `*/10 * * * *` | 6 | 25.0 | 28.4 | 36.6 | 0 | 170 |
| link-refresh (80) | `*/10 * * * *` | 6 | 22.2 | 25.3 | 37.6 | 0 | 152 |
| provider-english-defaults (94) | `3-59/10 * * * *` | 6 | 16.9 | 22.4 | 36.1 | 0 | 132 |
| search-refresh-requested (39) | `6-59/10 * * * *` | 6 | 0.7 | 55.9 | 119.9 | 0 | 127 |
| waste-guard (175) | `17 * * * *` | 1 | 101.3 | 113.7 | 120.1 | 3 | 122 |
| platform-health (65) | `8-59/10 * * * *` | 6 | 13.6 | 20.7 | 35.9 | 0 | 107 |
| enrich-plan-auto (249) | `41 * * * *` | 1 | 84.1 | 120.0 | 120.0 | 9 | 97 |

The 25 jobs that hand work to the `coverage-sweep` edge function (through `pipeline.svc_pilot_submit_nonce`) take about 0.1 s each in cron. Their real cost is in the edge runtime (section 3).

**The two 30-second read lanes do not run every 30 s.** Jobs 49 and 159 (`30 seconds`) ran 78 and 77 times an hour, not 120. Gaps of about 11 and 21 minutes appear between runs (job 49: 5,554 gaps of 30 s, 40 gaps of 1,251 to 1,275 s, 23 gaps of 644 to 659 s). This matches a controller pausing them while the queue is empty: `security.waste_idle_guard_v1` and queue-watch both call `cron.alter_job`. I did not confirm which one.

### 1.2 Failures and time-outs by hour (W72)

There were **41 failed runs**: **39 statement time-outs at 120 s**, 1 deadlock (course-relink, 28 Oct 11:04 AEDT) and 1 cancelled run (coverage-read, 27 Oct 13:00).

- **27 Oct 06:55 to 29 Oct 14:00 AEDT** (55 h): 2 time-outs.
- **29 Oct 14:00 to 30 Oct 03:00 AEDT** (13 h): 37 time-outs.

| AEDT hour (29 to 30 Oct) | 14 | 16 | 17 | 18 | 19 | 20 | 23 | 00 | 01 | 02 |
|---|---|---|---|---|---|---|---|---|---|---|
| Cron time-outs | 10 | 1 | 6 | 3 | 8 | 1 | 1 | 1 | 5 | 1 |

Time-outs by job: coverage-ai-match-prepare 11, enrich-plan-auto 9, coverage-admit 5, coverage-admit-intakes 4, adapter-overwrite 4, waste-guard 3, l4-rule-low-agreement 2, coverage-bind 1.

**The time-outs land on the :00, :10 and :30 minutes.** On 29 Oct the batches started at 14:30, 17:30, 19:10 and 01:00. At each of those, coverage-admit, coverage-admit-intakes, adapter-overwrite and coverage-ai-match-prepare (and once coverage-bind) all started in the same second and all hit 120 s together. Across W72, runs longer than 5 s start most often at minutes ending in 0: 3,737 runs averaging 40 s, with 30 of the 52 runs over 115 s. Minutes ending in 5 have 632 such runs averaging 13 s.

| Minute mod 10 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|---|---|---|---|---|---|---|---|---|---|---|
| Starts of runs over 5 s | 3,737 | 938 | 1,603 | 1,013 | 1,852 | 632 | 1,663 | 1,278 | 1,915 | 713 |
| Average duration, s | 40.2 | 21.3 | 23.7 | 17.1 | 20.4 | 13.1 | 27.0 | 25.5 | 22.0 | 9.8 |
| Runs over 115 s | 30 | 10 | 0 | 0 | 0 | 0 | 2 | 10 | 0 | 0 |

The hourly jobs also stack up:

- **:37**: no-page-propose, ranking-link, exit-awards-apply and fee-wording-rules (about 37 to 40 s each, plus the daily l4-rule-low-agreement at 03:37 UTC).
- **:41**: enrich-plan-auto, scholarship-audience, studysearch-codes and companion-read.
- **:47**: course-coverage-build, layer4-auto-admit, the cf245 snapshot and scholarship-fee-alignment.
- **:17**: waste-guard (101 s), adapter-build-readiness and policy-add-tests.

### 1.3 Concurrency

Count of cron runs longer than 1 s that were active in each minute, by hour:

- 27 Oct 07:00 to 13:00 AEDT: average about 5.6 a minute, peak 14 to 15.
- 27 Oct 14:00 to 30 Oct 06:00 AEDT: average about 7.0 a minute, peak 16 to 19.

The step on 27 Oct at 14:00 AEDT is an increase in steady load, not a burst. The highest peak minutes were 19 (27 Oct 23:00, 29 Oct 05:00 and 29 Oct 14:00 AEDT) and 18. Peaks did not rise during the 29 Oct evening.

## 2. Database connections, slow statements and admin reads

**Connections.** At 06:57 AEDT there were 28 client backends out of 120. PostgREST had 19 idle, storage 4, and pg_cron 1 active (25 s). In W24 `postgres_logs` show **0** "connection slots" or "too many connections" errors and 0 lock time-outs. There were 6 deadlocks: 2 at 14:00, 2 at 16:00, 1 at 17:00 and 1 at 00:00. **Connection exhaustion is not the cause.**

**Slow statements by total time** (`pg_stat_statements` since 10 Aug, ranking only):

1. `coverage_ai_match_prepare_v1`: mean 34 s, 6,692 min in total.
2. `course_link_reverse_tick_v1`: now inactive.
3. `website_sync_check_v1`: mean 12.6 s.
4. PostgREST `svc_coverage_firecrawl()`: 412,264 calls, mean 565 ms. This is the worker's own lookup on every sweep call.
5. `pg_sleep`: 2,184 calls, mean 44 s. Some job or probe sleeps on purpose.
6. `zoho_sync_check_v1`, `fee_reader_tick_v1`, `firecrawl_targets_refresh_v1`, then the coverage-admission and adapter-overwrite functions (mean 39 to 43 s).

**Admin reads (W24, `edge_logs`, PostgREST `/rest/v1/rpc/admin_*`).** Admin calls that timed out return HTTP 500 at about 8.3 s, the 8 s `authenticated` limit. **63 timed out:**

| Function | Calls (200) | p50 ms | p90 ms | 8 s time-outs |
|---|---|---|---|---|
| admin_read | 8,044 | 385 | 1,268 | 37 |
| admin_platform_notices_read | 501 | 3 | 4,367 | 13 |
| admin_progress_read | 164 | 5 | 5,724 | 8 |
| admin_field_coverage | 153 | 275 | 4,059 | 5 |
| pipeline_jobs_page | no direct RPC calls in the window. It is reached, if at all, through `admin_read`. | | | |

| AEDT hour (29 to 30 Oct) | 13 | **14** | 15 | 16 | **17** | **18** | **19** | 20 to 23 | **00** | **01** | 02 to 06 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Admin RPC calls | 311 | **3,775** | 178 | 61 | **3,923** | **4,614** | **7,030** | 50 to 185 | **1,168** | **2,040** | 16 to 54 |
| Admin 8 s time-outs | 0 | 0 | 0 | 0 | 6 | 20 | 28 | 0 | 0 | 9 | 0 |
| Admin calls over 3 s (status 200) | 3 | 103 | 1 | 0 | 95 | 140 | 121 | 0 | 20 | 39 | 0 |
| Postgres statement time-out lines | 4 | **40** | 2 | 3 | **42** | **49** | **114** | 1 to 3 | 12 | **34** | 0 to 4 |

**Who made the admin calls.** In each high-volume hour the calls came from US addresses with a desktop Chrome or "Android 14; Pixel 7" user agent, using 26 to 30 different admin functions. That is the Playwright deployed UAT suite (desktop and phone projects) on GitHub-hosted runners. The run times match the GitHub Actions record exactly:

- 03:16 to 03:35 UTC (14:16 to 14:35 AEDT): 2 *CourseFinder Deployed UAT* runs and UI review screenshots.
- 06:11 to 08:35 UTC (17:11 to 19:35 AEDT): **12 *Deployed UAT* workflow_dispatch runs back to back** (10 failed), plus push-triggered runs at 06:24, 06:42, 06:57 and 08:50.
- 13:38 to 14:09 UTC (00:38 to 01:09 AEDT): 2 push-triggered Deployed UAT runs and the *Deployed weekly run* (failed).

**Finding: the database time-outs, both admin reads and cron jobs, line up with deployed UAT runs.** Every hour with more than 10 Postgres statement time-outs was an hour with a deployed UAT run. A UAT run sends 15 to 30 times the normal admin read volume (3,800 to 7,000 an hour against 50 to 300). Whenever that overlapped the :00, :10 or :30 job cluster, both sides timed out. Outside UAT hours there were 0 to 4 time-outs an hour.

## 3. Edge runtime and worker calls

### 3.1 Worker call volume by mode (W72, `pipeline.mode_outcome_ledger`)

54,257 worker calls (about 754 an hour) used **5,344 worker-minutes**. Only 47 calls in 72 h had a status other than 200 in the ledger. The ledger records only calls that finished; calls refused by the runtime (502, 503, 546) never reach it.

| Mode | Calls | /h | p50 ms | p90 ms | Calls that found nothing |
|---|---|---|---|---|---|
| read | 11,067 | 153.7 | 1,519 | 8,645 | 9,860 (89%) |
| discover | 8,562 | 118.9 | 3,665 | 8,163 | 8,539 (99.7%) |
| ai_match | 4,278 | 59.4 | 4,684 | 9,522 | 4,183 (98%) |
| link_search | 4,276 | 59.4 | 7,281 | 13,100 | 3,876 (91%) |
| reidentify | 4,271 | 59.3 | 5,719 | 10,229 | 3,780 (89%) |
| cricos_peo | 4,271 | 59.3 | 4,236 | 8,068 | **4,271 (100%)** |
| reextract | 4,224 | 58.7 | 3,995 | 7,839 | **4,224 (100%)** |
| scholarship_discover | 3,635 | 50.5 | 7,307 | 13,908 | |
| scholarship_recheck | 2,124 | 29.5 | 5,967 | 11,822 | |
| other 21 modes | 7,549 | | | | |

"Found nothing" means the call's own detail showed no providers, rows, picks or items.

**38,733 of the 40,949 calls in the seven polling modes (94.6%) found nothing.** Those empty calls used **2,994 worker-minutes, 56% of all worker time**. Each one still boots a worker and makes at least one database call (`svc_coverage_firecrawl()`, mean 565 ms).

`queue_watch_state` at 07:04 AEDT agrees: course_page_discover and course_page_read are `nothing_left`, ai_page_match is `done`, and credential_read is `nothing_left`.

Per-hour ledger totals were steady at 690 to 830 calls and 57 to 117 worker-minutes all through W72. There was no surge in volume on the evening of 29 Oct. Two changes did show up:

- **discover** average time stepped up from about 4.1 s to about 6.4 s at 17:57 AEDT on 29 Oct and stayed there (17:57 to 21:00: 6.2 s; 21:00 to 01:00: 6.4 s; 01:00 to 07:00: 6.4 s).
- **course_list_read** average went from 8 s to 53 s, p90 117 s, between 21:00 and 01:00.

### 3.2 Edge runtime errors by hour (W24, `function_edge_logs`, `function_logs`)

Almost all traffic is `coverage-sweep` (about 750 to 950 calls an hour).

| AEDT hour | 07 to 13 | 14 | 15 to 17 | 18 | 19 | 20 | **21** | **22** | **23** | **00** | **01** | 02 | 03 to 06 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| All 5xx | 3 to 8 | 20 | 6 to 8 | 14 | 14 | 14 | **31** | **49** | **41** | **34** | **17** | 15 | 3 to 9 |
| 502 | 0 | 0 | 0 | 6 | 3 | 1 | **12** | **27** | 0 | **10** | 0 | 0 | 0 |
| 503 | 1 to 4 | 9 | 5 to 6 | 5 | 4 | 11 | **13** | **12** | **32** | **21** | **16** | 12 | 3 to 6 |
| 546 (CPU time exceeded) | 0 to 2 | 4 | 0 | 0 | 0 | 0 | **5** | **7** | **7** | 0 | **1** | 0 | 0 to 3 |
| p90 duration, ms | 10 to 14 k | 16 k | 12 k | 10 k | 12 k | 10 k | 10 k | 11 k | **16 k** | 12 k | 11 k | 11 k | 11 to 12 k |

W24 totals for coverage-sweep:

- **503: 187.** About 10.1 s each, spread across every mode. The runtime waited about 10 s for a free worker and gave up.
- **502: 58.** About 10 ms each, with no function version recorded, so no worker was started (a BOOT_ERROR-type failure).
- **500: 50.**
- **546: 30.** WORKER_RESOURCE_LIMIT. `function_logs` shows 20 "CPU Time exceeded" lines between 21:19 and 01:04 AEDT.
- **520: 2.**

`function_logs` shows **0** BOOT_ERROR, SERVICE_DEGRADED or memory lines in W24, so the runtime does not log the cause of the 502s and 503s.

**What the evening errors have in common:**

1. **Every 546 is a read-mode call.** All 30 had a 29-byte body, which is exactly `{"mode": "read", "limit": 60}` from jobs 49 and 159. Read calls find nothing 89% of the time. When one does have pages, it ran out of CPU time. That suggests the size of each page, not the batch of 60. The 546s started at 21:19 AEDT, about 3 h 20 min after W29 went live at 17:57 (`entry.course_page_chars` 100,000; course pages are no longer cut short). **I could not prove the link to W29.** It needs a check of read-mode page sizes in the worker.
2. **The 502s arrive in synchronised bursts of 6 to 13 requests within about 50 ms:** 18:00:08, 21:40:08, 22:06:15, 22:07:03, 22:29:00 and 00:05:02. Those are the moments when the every-minute submissions all reach the runtime together. About 9 sweep calls are fired at second 0 of every minute, and 12 to 15 on minutes ending in 0 or 5. The bursts stopped after coverage-sweep v226 was deployed (about 00:39 to 00:54 AEDT; v223 to v224 had been deployed at about 17:57).
3. **The 503s cluster at second 10 to 20 of a minute**, about 10 s after the burst. Over the evening they rose from about 5 an hour to 32 an hour at 23:00, then fell to about 3 to 5 an hour after 03:00.
4. **The database was quiet from 21:00 to 23:59** (1 to 3 statement time-outs an hour, no UAT traffic). **The evening degradation is on the edge-runtime side, not the database side.**
5. Supabase's public status page shows **no incident** for Edge Functions in ap-south-1 on 28 to 30 Oct (the last listed is 12 Oct). So the most likely cause is this project's own burst pattern meeting the per-project worker limits. That is inferred and has not been confirmed with Supabase.

### 3.3 Most likely cause of the 29 Oct evening degradation

From the evidence available, in order of confidence:

1. **Edge worker saturation from synchronised per-minute fan-out, with no headroom.** About 750 to 950 calls an hour are fired mostly at second 0 of each minute. 56% of the worker time does nothing, and each call holds a worker for 3 to 8 s even when idle. Any slowdown in a call's own database lookups widens the overlap: discover went from about 4 s to 6.4 s at 17:57, and course_list_read reached 53 s on average between 21:00 and 01:00. The runtime then refuses new calls: 502 when it cannot start a worker, 503 after a 10 s wait. Observed: 502 and 503 bursts at second 0 to 20, and a rising p90 at 23:00 (16 s).
2. **CPU-limit kills on read calls (546), from 21:19.** Likely tied to larger pages since W29 (100,000 characters). Not proven.
3. **Deployment churn.** The 18:00 burst came 3 minutes after the v224 deploy. The 502 bursts ended after v226. This is a contributing factor, not the main cause: the 21:40 to 22:29 bursts were hours after any deploy.

**The 29 Oct afternoon and 00:00 to 01:00 problems were a separate cause:** database time-outs during deployed UAT runs (section 2), made worse by the :00, :10 and :30 job cluster.

**Impact on drafts.** The edge refusals also left adapter drafts stuck. The Kulin capture call at 12:10:15 UTC on 29 Oct got a 503 after 10.1 s. On 27 Oct, draft 6780a06b's capture got a 502 after 73 s. See `STUCK-DRAFTS-RECONCILIATION.md`. W30 already lists edge-runtime failures as "external, not coded around".

## 4. Correlation summary

| Window (AEDT) | Admin UAT load | DB statement time-outs | Cron 120 s time-outs | Edge 5xx | Main cause |
|---|---|---|---|---|---|
| 29 Oct 14:00 to 14:59 | 3,775 calls | 40 | 10 | 20 | UAT plus the :30 cluster |
| 29 Oct 17:00 to 19:59 | 3,923 / 4,614 / 7,030 | 42 / 49 / 114 | 17 | 14 an hour | UAT (12 dispatches) plus clusters |
| **29 Oct 21:00 to 23:59** | 50 to 54 | 1 to 3 | 1 | **31 / 49 / 41** | **Edge saturation (502 bursts, 503, 546)** |
| 30 Oct 00:00 to 01:59 | 1,168 / 2,040 | 12 / 34 | 6 | 34 / 17 | Both: weekly deployed run, the 01:00 cluster, edge 503s |
| 30 Oct 03:00 to 06:59 | about 50 | 0 to 2 | 0 | 3 to 9 | Normal |

## 5. What this means in plain terms

- The database has spare connections but little spare CPU. Cron keeps on average 1.7 sessions busy on 2 cores. When the deployed UAT suite runs (thousands of admin reads an hour) during the busy :00, :10 and :30 minutes, admin screens and the heaviest jobs both hit their time limits.
- The edge workers spend more than half their time checking empty queues. Most of these checks are fired in the same second each minute. Once anything slows down, the runtime refuses calls (502 and 503), and some reads exceed the CPU limit (546).
- None of this needs more capacity yet. Spreading the start minutes and polling empty queues less often should remove most of the pressure. A larger compute tier is the fallback if the changes below do not.

## 6. Proposed bounded changes: for decision, not applied

Each proposal is independent and reversible, and none touches the consumer API (G3).

- **Applying.** Schedule changes would be applied by `cron.alter_job` in a migration (G1 catalogue rows already exist for every job named). Setting changes go through Settings › Pipeline settings, with a reason (G2).
- **Measuring.** Each one is measured by re-running the section 1 and 3 queries over the next 24 h.
- **Housekeeping.** Where a job is switched off, the same change marks it `retiring` in `pipeline.component_register` (Decision 260).

### P1. Move the three admission jobs off minute :00 and off each other (largest DB effect, low risk)

| Job (id) | Now | Proposed |
|---|---|---|
| coverage-admit (59) | `*/10 * * * *` | `1-59/10 * * * *` |
| coverage-admit-intakes (111) | `*/10 * * * *` | `5-59/10 * * * *` |
| adapter-overwrite (112) | `*/10 * * * *` | `7-59/10 * * * *` |

Exact change: `select cron.alter_job(59, schedule := '1-59/10 * * * *'); select cron.alter_job(111, schedule := '5-59/10 * * * *'); select cron.alter_job(112, schedule := '7-59/10 * * * *');`

- **Effect.** Each of these three jobs runs about 80 s. Today all three start together with coverage-ai-match-prepare at :00, and they were 13 of the 39 time-outs. Moving them to odd minutes keeps them apart from each other and from the even-minute coverage-ai-match-prepare. The quietest minutes (ending in 5, average 13 s; ending in 1 and 7) take one each. The order admit, then intakes, then overwrite is kept.
- **Risk.** Low. Admission and overwrite results land 1 to 7 minutes later than now. Check first whether adapter-overwrite relies on admissions from the same minute; the new order keeps it after both.

### P2. Run coverage-ai-match-prepare every 4 minutes instead of every 2 (largest single job)

| Job (id) | Now | Proposed |
|---|---|---|
| coverage-ai-match-prepare (96) | `*/2 * * * *` | `*/4 * * * *` |

Exact change: `select cron.alter_job(96, schedule := '*/4 * * * *');`. Alternative with the same intent: halve the batch with `batch.ai_match_prepare_courses` 1000 → 500 (range 1 to 5,000), keeping the schedule.

- **Effect.** About 900 fewer job-minutes in 72 h, around 12% of all cron busy time. This job alone was 25% of cron busy time and had 11 time-outs. The consumer of its output (ai_match) found nothing on 98% of 4,278 calls, and queue-watch reports ai_page_match `done`, so the queue is over-supplied.
- **Risk.** Low. New pages wait up to 2 minutes longer before AI matching.

### P3. Merge the two 30-second read lanes into one

W30 makes `svc_coverage_read_next` claims exclusive, so two lanes no longer add safety.

| Job (id) | Now | Proposed |
|---|---|---|
| coverage-read-2 (159) | `30 seconds`, active | inactive (`cron.alter_job(159, active := false)`), `component_register` row → `retiring`, `replaced_by` = coverage-read (49) |
| coverage-read (49) | `30 seconds` | unchanged |
| `batch.coverage_read` | 60 | unchanged (the `used_by` line becomes "coverage-read (every 30 seconds)") |

- **Effect.** About 77 fewer read calls an hour, roughly 10% of all sweep calls. The read pair currently fires at :00 and :30 of each minute and adds to the burst. Capacity stays at 60 pages every 30 s (7,200 an hour), against an observed 1 page or fewer per call. 89% of read calls found nothing.
- **Risk.** Low. If a large backlog appears, read throughput halves until the lane is switched back on (one statement).
- **Does not fix the 546s.** Those come from single heavy pages, not the batch size. That needs a separate worker-side check of read-mode page size after W29.

### P4. Slow the polling lanes that found nothing for 72 hours, using the existing queue-watch gate

| Job (id) | Mode | Empty in W72 | Proposed |
|---|---|---|---|
| coverage-reextract (57) | reextract | 100% | `* * * * *` → `*/5 * * * *` |
| cricos-peo (147) | cricos_peo | 100% | `* * * * *` → `*/10 * * * *` |
| coverage-discover-2 (79) | discover | 99.7% | inactive; coverage-discover (48) stays. Same housekeeping as P3. |
| coverage-discover (48) | discover | 99.7% | keep `* * * * *`, but add the existing queue-watch gate used by credential-read (270): `... where exists (select 1 from pipeline.queue_watch_state s where s.key = 'course_page_discover' and s.pending > 0) or not exists (select 1 from pipeline.queue_watch_state s where s.key = 'course_page_discover')` |
| course-link-search-worker (81) | link_search | 91% | `* * * * *` → `*/2 * * * *` |

The gate adds no number to a job command, so it stays within G2.

- **Effect.** About 250 fewer edge calls an hour, roughly 30% of sweep traffic and about 1,450 of the 2,994 empty worker-minutes in 72 h. Fewer calls fire at second 0 of each minute (about 9 down to about 5 on normal minutes), which directly targets the 502 bursts and 503 waits.
- **Risk.** Medium-low.
  - Work that does turn up waits up to 5 to 10 minutes on these lanes.
  - The discover gate depends on queue-watch being current. It runs every 15 minutes at minute 4 and the `not exists` fallback covers a missing key.
  - Only the lanes listed change. Reidentify (89% empty) and ai_match (98% empty, already marked paused by queue-watch) are left for a later round.

### P5. Spread the hourly clusters at :37, :41 and :47

| Job (id) | Now | Proposed |
|---|---|---|
| ranking-link (84) | `37 * * * *` | `33 * * * *` |
| exit-awards-apply (115) | `37 * * * *` | `27 * * * *` |
| enrich-plan-auto (249) | `41 * * * *` | `43 * * * *` |
| layer4-auto-admit (341) | `47 * * * *` | `14 * * * *` |

- **Effect.** Each :37 and :47 job takes about 37 s. Splitting them roughly halves the number of heavy hourly jobs running together. enrich-plan-auto (9 time-outs, p50 84 s) moves to a minute with no other hourly job.
- **Risk.** Medium. I did not confirm ordering dependencies. layer4-auto-admit may expect course-coverage-build (:47) to have run first, and exit-awards-apply may expect ranking-link. Confirm with the owners of those jobs before applying.
- **enrich-plan-auto may still time out.** Its time-outs are in `fc_purpose_group_v1` and `enrich_unit_costs_v1`, and its p90 already equals the 120 s limit. Moving it reduces contention but may not be enough. A separate review of those two functions is recommended.

### P6. Stop deployed UAT runs piling onto live (test governance; no schedule or capacity change)

- **Change.** Add a GitHub Actions `concurrency` group shared by `deployed-uat` and `deployed-weekly.yml`, with `cancel-in-progress: false`, so only one deployed run touches live at a time. Avoid re-dispatching the deployed run in a loop: 12 runs in 2 h 24 min on 29 Oct, 10 of them failed. Optionally, start deployed runs away from minutes ending in 0.
- **Effect.** Removes the cause of 63 admin-read time-outs and most of the 37 cron time-outs on 29 to 30 Oct.
- **Risk.** Low. Deployed checks queue rather than overlap.
- **Governance.** This is a G4 change, so it needs the Platform Admin's decision and a register line.

### P7. Website and Zoho sync checks (decision needed on freshness)

website-sync-check (171) runs every minute with p50 15.9 s: 1,171 job-minutes, 16% of cron busy time. zoho-sync-check (199) adds 337 minutes. Changing website-sync-check to `1-59/2 * * * *` would save about 585 minutes in 72 h.

- **Risk.** Depends on how quickly the website must see changes. The consumer API's shape is unchanged (G3 allows this), but the Platform Admin should confirm that up to 2 minutes of extra lag is acceptable.
- **Recommendation.** Do this only after P1 to P4 if pressure remains.

### Not proposed

- **No compute or edge capacity change now.** The evidence points to bursts and wasted polling, not a shortage of capacity.
- **No change to `statement_timeout`.**
- **Do not move to cron second-offsets.** pg_cron cannot offset within a minute, except with `N seconds` interval jobs, whose phase cannot be controlled.

### Expected combined effect (P1 to P4, plus P6)

- **Edge.** About 330 fewer sweep calls an hour, roughly 40%. Per-minute bursts fall from about 9 to 13 calls to about 4 to 8.
- **Database.** About 900 job-minutes saved per 72 h (about 12%), mostly from P2. No more than one 80-second admission job starts in any minute.
- **Admin reads.** The UAT overlap is removed.

**How to tell it worked.** Hourly edge 5xx stays at 10 or fewer, cron time-outs stay at 2 or fewer a day, and admin 8 s time-outs are 0 outside UAT runs. Re-measure 24 h after each step.

## Appendix A. Per-job W72 statistics

The full per-job table (138 active jobs: schedule, runs an hour, p50, p90 and max duration, failures, time-outs and busy minutes) came from:

```sql
with w as (select timestamptz '2026-10-26 19:55Z' s, timestamptz '2026-10-29 19:55Z' e),
r as (select d.jobid, d.status, d.return_message, extract(epoch from (d.end_time-d.start_time)) dur
      from cron.job_run_details d, w where d.start_time>=w.s and d.start_time<w.e)
select j.jobid, j.jobname, j.schedule, j.active, count(r.*) runs, round(count(r.*)/72.0,1) per_h,
  round(percentile_cont(0.5) within group (order by dur)::numeric,2) p50,
  round(percentile_cont(0.9) within group (order by dur)::numeric,2) p90,
  round(max(dur)::numeric,1) mx, count(*) filter (where r.status='failed') fails,
  count(*) filter (where r.return_message ilike '%timeout%') tmo, round(sum(dur)::numeric/60,0) busy_min
from cron.job j left join r on r.jobid=j.jobid group by 1,2,3,4 order by busy_min desc nulls last;
```

Jobs not in section 1.1 each used 85 or fewer busy minutes in 72 h. Twenty-six of them run every minute, every 2 minutes or every 30 s and complete in 0.1 to 1.6 s at p50. Those are the edge submitters and light ticks.

## Appendix B. Log queries used

Hourly edge 5xx by status, and the 546 body length for each mode:

```sql
select formatDateTime(toTimeZone(timestamp,'Australia/Melbourne'),'%m-%d %H') aedt,
  countIf(log_attributes['response.status_code']='502') s502, countIf(log_attributes['response.status_code']='503') s503,
  countIf(log_attributes['response.status_code']='546') s546
from logs where source='function_edge_logs' group by aedt order by aedt;
```

Admin time-outs by hour: `edge_logs`, `request.path like '/rest/v1/rpc/admin%'`, status 500 with `response.origin_time` over 7,500 ms.
