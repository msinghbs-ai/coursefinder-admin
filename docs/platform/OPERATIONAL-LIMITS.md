# StudySearch platform operational limits

**Version:** 1.3 (1 Nov 2026: alerts delivered by push and e-mail (D12), re-read pilot (D13), refresh gap 25 minutes (D15); 1.2: monitoring, alerts and the weekly scorecard, v2.15.384; 1.1: operating targets, v2.15.383; figures below as at 13 Oct 2026)

**Figures as at:** 6:17 pm, Tue 13 Oct 2026 (Melbourne time), read from the live database (project fxcwkweaxjtknorudmwp)

**Owner:** Platform Admin

This document lists every budget and limit the platform works within, what was used against each, and every scheduled job with its schedule. The settings are changed on Models & services › Toolsets & limits (Platform Admin, with a reason that is logged). The jobs are on Scheduled jobs › Automations. The usage figures are a snapshot: the live figures are on Coverage & completeness › Progress and Toolsets & limits.

## Summary

- The scholarship Firecrawl share is **3,500 credits a day**. It was used up on 13 Oct, and about 23,600 scholarship requests waited until midnight. Scholarships are also held to 150 credits per university in 30 days and an overall cap of 60,000 credits (800 kept in reserve), of which 24,825 have been used.
- The Firecrawl day totals 15,000 billed credits, shared between five purposes. Budgets reset at midnight, Melbourne time.
- Adapter proposals were raised from 400 to 1,000 a day on 13 Oct at 6:04 pm (Platform Admin request).
- AI spend is watched, not stopped: OpenRouter is set to observe only, so the daily guards raise notices.
- 91 scheduled jobs: 89 running, 2 paused.

## Firecrawl daily budget

Resets at midnight, Melbourne time. "Refused" counts requests that waited because the share was used, or (central pages) because the page was not due to be read again.

| Budget | Limit (credits) | Used 13 Oct | Left | Refused 13 Oct |
|---|---|---|---|---|
| Total billed a day | 15,000 | 7,709 | 7,291 | – |
| Finding course pages (search) | 6,000 | 3,558 | 2,442 | 0 |
| Reading pages Firecrawl must read | 3,000 | 1,137 | 1,863 | 0 |
| Scholarships | 3,500 | 3,500 | 0 | 23,637 |
| Central pages | 1,500 | 23 | 1,477 | 2,429 (not due, not budget) |
| Other (website finder) | 1,000 | 1,000 | 0 | 10 |

## Other Firecrawl limits

| Limit | Setting | Used |
|---|---|---|
| Firecrawl account (plan balance) | Plan credits | 379,844 left; the period renews 3 Nov 2026 |
| Course-page search, monthly cap | 200,000 credits a month | 67,862 in October |
| Scholarships, overall cap | 60,000 credits, 800 kept in reserve | 24,825 |
| Scholarships, per university | 150 credits in 30 days (counted from joining onboarding) | – |
| Scholarships searched only for | Australian providers with 30 or more courses | – |
| Stop searching a university after | 30 searches with no correct course page | 27 stopped, 2 held (Adelaide, Victoria) |
| Central pages read again after | 30 days | – |
| Automatic adapter builds | 25 a day, 150 credits each | – |

## AI (OpenRouter)

Balance US$27.10 at 6:15 pm. Credit floor US$5. Mode: observe only (the guards raise notices but do not stop work).

| Use | Daily limit | Spent 13 Oct |
|---|---|---|
| Adapter proposals (adapter builder) | 1,000 proposals and US$5 a day | 420 proposals, US$0.15 |
| Adapter proposals (OpenRouter guard) | US$5 | under US$0.01 recorded by the guard |
| Read scholarship pages with AI | US$20 | US$0.00 |
| Central pages with AI | US$5 | US$0.00 |
| AI course-page matching | US$5 | under US$0.01 |

The adapter builder's own allowance (proposals and US$ a day) is set on Toolsets & limits › Firecrawl › Adapter builder; the OpenRouter guards are on Toolsets & limits › OpenRouter › Daily guards. The model that proposes adapters is qwen/qwen3-30b-a3b-instruct-2507.

## Other services

Both are on free plans and switched off in Models & services.

| Service | Plan credits | Kept back | Calls at once | Price per 1,000 credits |
|---|---|---|---|---|
| Serper (web search) | 2,500 (from 4 Oct, does not renew) | 100 | 5 | US$1.00 |
| ScrapingBee (pages that need a browser) | 1,000 (from 4 Oct, does not renew) | 50 | 5 | US$0.33 |

## Scheduled jobs

Times are Melbourne time (the database schedules are in UTC). 89 running, 2 paused: coverage-read-2 (second course-page reader) and onboarding-pilot-snapshot (replaced by progress-snapshot on 13 Oct).

### Every minute or faster

| Job | What it does |
|---|---|
| provider-onboarding | Onboard universities |
| admin-jobs | Task manager tasks |
| course-link-search | Find course pages by CRICOS code |
| course-link-search-worker | Search for course pages |
| course-link-reverse | Match known course pages by CRICOS code |
| coverage-discover, coverage-discover-2 | Discover course pages (two workers) |
| coverage-read | Read course pages (every 30 seconds) |
| coverage-reextract | Re-read saved pages |
| coverage-reidentify | Identify course pages again |
| coverage-ai-match | AI course-page matching |
| firecrawl-runs | Firecrawl runs |
| firecrawl-targets | Firecrawl target lists |
| scholarship-ai-extract | Read scholarship pages with AI |
| layer1-run-driver | Register run driver |
| university-reread-requests | University read-again requests |
| cricos-peo | Read CRICOS contacts (internal) |

### Every 2 to 5 minutes

| Job | Every | What it does |
|---|---|---|
| coverage-ai-match-prepare | 2 min | Prepare AI course-page matching |
| retention-worker | 2 min | Data retention |
| coverage-find-site | 3 min | Find provider websites |
| provider-contact-page | 3 min | Find provider phone and email |
| coverage-bind | 5 min | Match pages to courses |
| better-page-revert | 5 min | Return to the better course page |
| central-find | 5 min | Find central pages |
| central-ai | 5 min | Read central pages with AI |
| scholarship-read | 5 min | Read scholarship pages |
| firecrawl-panel-figures | 5 min | Firecrawl panel figures |

### Every 10 to 15 minutes

| Job | Every | What it does |
|---|---|---|
| adapter-overwrite | 10 min | Adapter values replace older ones |
| coverage-admit | 10 min | Admit official page and English |
| coverage-admit-intakes | 10 min | Admit intakes from course pages |
| provider-basis-rule-admit | 10 min | Admit tuition under provider fee rules |
| provider-calendar-defaults | 10 min | College intakes from the approved calendar |
| provider-calendar-intakes | 10 min | Answer semester-only intakes from calendars |
| provider-english-defaults | 10 min | Apply approved English policies |
| fee-period-settle | 10 min | Settle fee periods from page wording |
| provider-facts | 10 min | Find and read fee schedules, English policies and calendars |
| link-refresh | 10 min | Refresh course links |
| search-refresh-requested | 10 min | Refresh search for changed courses |
| evidence-link-index | 10 min | Index evidence links |
| scholarship-discover | 10 min | Discover scholarships |
| scholarship-nationality | 10 min | Scholarship nationality from wording |
| platform-health | 10 min | Platform health checks |
| scholarship-listing | 15 min | Read scholarship listing pages |
| scholarship-course-attribute | 15 min | Course scholarship attribute |
| firecrawl-credit | 15 min | Check the Firecrawl balance |
| openrouter-balance | 15 min | Read the OpenRouter balance |
| admin-summary-snapshots-refresh | 15 min | Admin summary figures |

### Hourly and every 2 hours

| Job | Minute past the hour | What it does |
|---|---|---|
| platform-resource-observe | :00 | Resource usage reading |
| coursefinder-layer1-regulatory-scheduler | :05 | Register refresh scheduler |
| progress-snapshot | :09 | Snapshot progress |
| coursefinder-cf245-enrichment-hourly-admin-cache | :12 | Admin figures cache |
| scholarship-discover-refill | :23 | Line up providers for scholarship discovery |
| provider-fee-profiles-apply | :26 | Apply provider fee profiles |
| provider-rule-admit | :29 | Admit facts under provider rules |
| scholarship-auto-publish | :29 | Publish scholarships automatically |
| layer1-auto-ingest | :34 | Register auto-ingest |
| coursefinder-m2-3-refresh-intelligence-tick | :36 | Refresh policies |
| exit-awards-apply | :37 | Exit awards take parent values |
| fee-wording-rules | :37 | Apply approved fee wording rules |
| ranking-link | :37 | Link ranked universities to providers |
| scholarship-audience | :41 | Scholarship audience from wording |
| host-pages-apply | :42 | Hosted courses take host page values |
| course-coverage-build | :47 | Coverage by attribute |
| coursefinder-cf245-enrichment-coverage-snapshot | :47 | Enrichment coverage snapshot |
| scholarship-fee-alignment | :47 | Scholarship fee alignment |
| consumer-reference-bundle-refresh | :50 | Rebuild API reference data |
| course-completeness-build | :52 | Completeness score |
| course-field-source-build | :55 | Who supplied each course value |
| provider-fee-ranges-refresh | :57 | University fee ranges |
| evidence-filter-options-refresh | :04, every 2 hours | Evidence filter options |
| layer2-onboarding-snapshot | :53, every 2 hours | Provider onboarding figures |

### Daily

| Time | Job | What it does |
|---|---|---|
| 2:13 am | scholarship-ai-backfill | AI re-check of refused scholarship pages |
| 3:17 am | coursefinder-data-quality-overview-refresh | Data quality overview |
| 6:17 am | evidence-storage-dedupe-daily | Remove duplicate evidence files |
| 6:37 am | scholarship-reread-cadence | Re-read published scholarships monthly |
| 7:17 am | scholarship-publication-review | Nightly publication review |
| 7:33 am | provider-priority-refresh | Rank providers by size |
| 7:41 am | scholarship-savings | Work out scholarship savings |
| 7:51 am | scholarship-course-attribute-full | Course scholarship attribute (full sweep) |
| 2:17 pm | coursefinder-layer1-housekeeping | Layer 1 housekeeping |
| 2:17 pm | l4-rule-unofficial-source | Review rule: unofficial source |
| 2:27 pm | coursefinder-layer2-housekeeping | Layer 2 housekeeping |
| 2:27 pm | l4-rule-fee-year-align | Review rule: fee year |
| 2:37 pm | cron-history-retention | Trim job history |
| 2:37 pm | l4-rule-low-agreement | Review rule: sources disagree |
| 2:41 pm | campus-regional-class-refresh | Campus regional category |
| 3:12 pm | coursefinder-platform-capacity-observation | Capacity reading |
| 3:23 pm | cron-history-trim | Trim scheduler run history |

### Weekly and monthly

| When | Job | What it does |
|---|---|---|
| Tuesday 8:23 am, October to December | provider-document-check-weekly-q4 | Fee documents check (weekly) |
| 2nd of the month, 8:23 am | provider-document-check-monthly | Fee documents check (monthly) |
| 5th of the month, 1:41 pm | statistics-edition-discovery | New statistics editions |

## Operating targets (SS-014, 31 Oct 2026)

Set from verified production baselines (transformation record §30). Since v2.15.384 the weekly scorecard on Platform health measures all eight; T8's suite and workflow results stay on the Admin release record.

| # | Measure | Target |
|---|---|---|
| T1 | Failed runs of active scheduled jobs | 0 a day. A failure stays on the health list until the job runs cleanly; 3 failures in a row are critical (settings `health.job_failure_*`) |
| T2 | AI spend, all OpenRouter routes | US$14 or less a day (setting `budgets.ai_daily_ceiling_usd`); credit US$10 or more |
| T3 | Firecrawl | Within 500,000 credits a month, keeping the 2,000 reserve |
| T4 | Futile enrichment items (mismatch pages) | Under 100 a day |
| T5 | Layer 4 review backlog | Oldest pending item under 14 days |
| T6 | Consumer API | 0 server errors; no contract drift; search p95 under 3 s for pages of 20 |
| T7 | Data freshness | Search refresh requests processed within 40 minutes; reference bundle under 2 hours old |
| T8 | Releases | Full suite and post-merge workflows green; live checksums verified; rollback definition on record |

## Monitoring, alerts and the weekly scorecard (SS-014, v2.15.384)

### Health checks

- **Job and frequency:** `platform-health` runs every 10 minutes and writes `pipeline.platform_issues`.
- **Run time:** median 21.3 s before v2.15.384; see record §31.4 for after.
- **Critical:**
  - a job whose last 3 runs all failed;
  - a queue stalled past 2 hours;
  - a queue whose job is missing or paused by a person;
  - search refresh stalled (past 90 minutes, or its job missing, paused, failing or not running);
  - budget floors;
  - consumer API probes failing.
- **Information, not critical:** a queue whose job the flag unit paused after idle runs. The flag unit switches it on again when work waits. It becomes critical after 2 hours.
- **Search refresh:**
  - a warning after `health.search_refresh_slow_minutes` (40, = T7), naming the cause (the refresh gap or another writer);
  - critical after `health.search_refresh_stalled_minutes` (90).

### Alerts (job `platform-alerts`, every 10 minutes, at :00 to :50)

| Rule | Setting (Pipeline settings › Alerts) | Value |
|---|---|---|
| Lowest severity that alerts | `alerts.min_severity` | 3 = critical only |
| An issue must stay open | `alerts.confirm_minutes` | 15 minutes (flap guard) |
| One alert per check within | `alerts.cooldown_minutes` | 60 minutes |
| Reminder while open and unacknowledged | `alerts.reminder_hours` | 12 hours |
| Recovery notice | `alerts.recovery_notice` | On |
| Delivery retries | `alerts.max_attempts`, `alerts.retry_minutes` | 5 attempts, 10 minutes doubling |
| Not collected while on | `alerts.collect_within_minutes` | 120 minutes, then critical |
| **External delivery** | `alerts.delivery_enabled` | **On (D12, 31 Oct 2026 23:05)**: the hourly "Work queue alerts" scheduled task (at :59) takes platform alerts and sends them by push and e-mail. Expected delay up to about 75 minutes (15 qualify + up to 10 job + up to 60 task) |
| Webhook | `alerts.webhook_enabled` plus vault secret `studysearch_alert_webhook_url` | Off |
| Test mode | `alerts.test_mode` | Off |

- **Acknowledging:** a Platform Admin acknowledges an issue on Platform health, with a reason that is logged. This stops its reminders. If the issue rises in severity, the acknowledgement is cleared.
- **Work-queue alerts are separate:** they stay in `pipeline.queue_watch_alerts`. The hourly "Work queue alerts" scheduled task (push and e-mail) delivers them.
- **Destination:** the existing task (D12); no webhook or new credentials. Test record: transformation record §32.1.

### Re-read pilot (D13, job `reread-pilot`, daily 05:41)

- **What it does:** exhausted course pages get one direct read, with no Firecrawl and no AI.
- **Limits (Pipeline settings › Re-read and retry):** at most 25 a day (also the approved ceiling); at least 30 days after the last attempt; once per page.
- **Stops by itself:** on a Firecrawl read or on Layer 4 growth.
- **Measures:** `security.page_reread_pilot_summary_v1()`.

### Search refresh gap (D15)

- `search.refresh_min_gap_minutes` is 25 (was 30) from 31 Oct 2026 23:19.
- The longest automatic wait is about 30 minutes, inside T7 (40).
- Revert to 30 if backlog, overlap or failures rise.

### Weekly operational scorecard (job `ops-scorecard`, daily 06:29 Melbourne)

- **What it records:** the week so far against T1 to T8, plus throughput, page identity, incidents and recovery, in `pipeline.ops_scorecards`. It finalises the last week once after the week ends.
- **Where it shows:** Platform health.
- **Target values:** settings under Pipeline settings › Operating targets.
- **Basis:** each target says whether it was observed for the whole week, observed so far, or only measured at report time.
- **Job reliability (T1):** recorded day by day, because the scheduler keeps only about three days of run history.

## Watch points

- firecrawl-targets failed 18 times in the 24 hours to 13 Oct 6:17 pm (out of about 1,440 runs), and firecrawl-panel-figures failed once. All were database deadlocks with another job. Each run is picked up the next minute, so nothing is lost; if it keeps happening, space the two jobs apart.
- The scholarship share and the Other share were both used up on 13 Oct. The adapter AI allowance was used up at 403 of 400 proposals before it was raised to 1,000.

## Change history

| Version | Date | Change |
|---|---|---|
| 1.0 | 13 Oct 2026 | First issue (Platform Admin, 18:17: "Give me all budgets and their correspondence usage and jobs and their schedules"; 18:20: "Save the above as platform operational limits in google docs and in admin docs as well"). |
| 1.1 | 31 Oct 2026 | Operating targets T1 to T8 (SS-014, v2.15.383). |
| 1.2 | 31 Oct 2026 | Monitoring, alerts and the weekly scorecard (SS-014A to D, v2.15.384; mandate 31 Oct 2026 19:22). |
| 1.3 | 1 Nov 2026 | Alerts delivered by the existing task (D12); re-read pilot (D13); refresh gap 25 minutes (D15). |
