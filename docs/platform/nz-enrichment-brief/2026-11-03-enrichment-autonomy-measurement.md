# Enrichment autonomy measurement: does StudySearch enrich data unattended?

**Date:** 3 November 2026, measured 09:33–10:08 AEDT (production `fxcwkweaxjtknorudmwp`, read-only).
**By:** Workstream F (production assurance).
**Authority:** Platform Admin direction 3 Nov 2026 09:32, `2026-11-03-platform-led-enrichment-autonomy-mandate-0932.md` (sections 4, 5 automatic mode, 7, 9 and 11).
**Scope:** the scheduler, workers and throughput. The UI controls are audited separately.
**Method:** I only read data. Nothing was written, no worker was called and no AI or Firecrawl was used. Heavy reads ran only in the :x6 minutes. The time windows are the last 24 hours and the last 7 days, ending 3 Nov 10:00 AEDT. Times are AEDT unless marked UTC.

---

## 1. Answer to the principal question

> *If Claude stops working now, does StudySearch continue discovering, enriching, validating and publishing eligible data correctly?*

**No, not for most of the required fields.** If Claude stopped now, this is what would happen:

| Part of the chain | What happens with no Claude |
|---|---|
| Publication and projection (Website API v2, Zoho) | **Works unattended.** 2,253 course changes reached the website delta and 1,098 reached Zoho in 24 h. The last changes were at 09:50 and 10:00. |
| Intakes (dates from stored calendars) | **Works unattended, slowly.** About 13 filled per hour from the 200-row hourly batch. |
| Fees, intakes, English, links from new pages | **Throttled to almost nothing.** The Firecrawl plan has about 3,600 credits above its reserve for the next 30 days (about 120 a day). The configured daily budget is 25,000. Every worker that needs a new page now returns *idle*. |
| Course description | **Broken: there is no reader.** The field register says `reader = none`. 163 of 35,690 active courses have a description. |
| Provider description | **Pilot only.** It covers 5 fixed universities, Australia only, with a lifetime AI ceiling of US$1. The picker times out (IQ-00055). Nothing has ever been published. |
| Academic entry requirements (AER) | **Works only with manual pushes.** No scheduled job queues course reads. Matrix runs have been idle since 30 Oct 07:14. Both use hand-picked provider lists, and Canada is not in scope. |
| Scholarships | **Works but throttled, and recently needed a manual stop-gap.** On 3 Nov at 00:23 the integrator parked 1,054 pending providers. The picker fix (v2.15.413) has not yet been seen working on live data. |
| Rankings | **Manual.** Editions are imported by hand. No job checks for a new edition. Only name linking runs every hour. |
| New work creation | **Stalls between cycles.** Each provider had one enrichment plan between 21 and 29 Oct. No new plan can start until 4 Nov 14:41. The standing gap queue timed out in 2 of its 4 runs in the last 24 h. |

In the last 24 h, **94% of Firecrawl credits (29,676 of 31,641)** were used by runs that the integrator (Claude) started by hand. The same runs did **13,042 of the 13,102 course-page reads** in that period. They also produced 2,635 of the 2,668 official-link items now waiting in Layer 4. So the last day's throughput is not evidence that the platform runs on its own.

---

## 2. Status by field

Status codes:

- **A** = works unattended.
- **T** = works but throttled (budget or source limit, not a failure).
- **M** = works only with manual pushes.
- **B** = broken.

| Field | Automatic status | Exact broken or limiting component |
|---|---|---|
| Course description | **B** | No reader exists: `pipeline.field_register.description` has `reader = 'none'`, and it is not in `security.enrich_fields_v1()`. No job, no worker mode, no admission path. |
| Official course link | **T**, with net loss | The Firecrawl vendor plan (5,000 credits a month) is below the configured `firecrawl.daily_budget_total` (25,000) and `daily_share_course_search` (13,000). Course-page search is also capped at 200 courses a day (`search.daily_picked_cap`). Layer 4 holds 2,668 items, and items come back after a decision (IQ-00039). |
| Tuition and fees | **T** | `fee-reader` has nothing to read (its queue is empty; the last read was at 01:36). New fee pages need Firecrawl, which is throttled as above. 135 tuition checks wait in Layer 4; the oldest is 8.6 days. AU fill fell over 7 days because of withdrawals. |
| Intakes (month, year, start date) | **A** (slow) for stored calendars; **T** for new pages | `intake-dates-apply` skips 93% of each 200-row batch. Page-based intakes depend on Firecrawl reads. |
| Application deadline | **B** | No reader: `field_register.deadline` has `reader = 'none'`. `course_intake_dates` keeps the deadline wording but fills no deadline field (0 filled in every country). |
| AER: course reads | **M** | The enqueuer `security.course_entry_read_enqueue_v1` is called only by `public.admin_entry_requirements`, `public.admin_aer` and `security.course_entry_correction_v1`. No cron job calls it. Scope is the fixed list `entry.course_read_providers` (41 IDs) and `entry.course_read_countries` (AU, NZ). Ingestion is on hold by decision. |
| AER: provider matrix runs | **M**, idle | `entry-matrix-read` runs every 5 minutes. Its last real work (`entry_ai`) was on 30 Oct at 07:14. It uses the fixed list `entry.providers` (33 IDs) and `entry.countries` (AU, NZ). It re-reads after 30 days; the first refresh is due around late November. The edition-check job does not exist (IQ-00008). |
| English requirements | **T** | Firecrawl throttling as above. The standing gap run filled 13 of 3,290 English items. It skipped 2,691 and 586 failed with worker errors (IQ-00053). |
| Scholarships: discovery | **T**, with a manual stop-gap on 3 Nov | `svc_scholarship_discover_next` timed out, so the integrator parked 1,054 rows (event #28680). Fix F1 shipped in v2.15.413 but is not yet proven on live data. 1,082 providers are pending and none are due before 11:10. 25 discovery calls failed with HTTP errors in 24 h. |
| Scholarships: listing | **T** | 132 listing pages are `suggested` and have never been read. The last listing read was at 01:52. |
| Scholarships: candidate, admission, publication | **A** | `scholarship-ai-extract`, `scholarship-auto-publish` and `scholarship-recheck` all run. 16 new scholarships in 24 h (8 published). The last AI extraction was at 06:02. |
| Rankings | **M** | No scheduled edition check or import exists: the `svc_ranking_*` import functions have no cron caller. `ranking-link` (hourly) only maps names. The website delta last changed rankings on 14 Oct. |
| Provider description | **M** (pilot) | Limited by `pdesc.provider_keys` (5 fixed keys), `pdesc.countries` (AU) and `pdesc.provider_types` (university). `pdesc.ai_usd_max = 1` is compared with the lane's **lifetime** spend, not a daily figure. `pdesc.pending_max = 10`. The picker times out (IQ-00055): 3 of 5 calls in 24 h failed. Ever published: 0. |
| Search projection, Website API v2, Zoho | **A** | `search-refresh-requested` timed out 9 of 144 times in 24 h (IQ-00032/IQ-00044), but its queue is empty (0 unprocessed). |

---

## 3. The automatic chain for each field

`cron.job` was read live. A *last real work* time is the last time a worker or function produced at least one item. It is not the last time the scheduler reported success.

### 3.1 Shared orchestration (every field)

| Link | Cron job (schedule, active) | Function | Measured |
|---|---|---|---|
| Gap discovery | `field-gap-queue` (`23 */6 * * *`, on) | `security.field_gap_queue_tick_v1` | 4 runs in 24 h, 2 failed (statement time-out in `insert into _gap`, 17:23 and 23:23 on 2 Nov). The 05:23 run on 3 Nov created a standing job of 12,528 items: about 1,253 filled (10%), 8,959 skipped, 2,243 failed and 73 sent to review. The next run is at 11:23. |
| Gap discovery (snapshot) | `enrich-coverage-snapshot` (hourly :07), `course-coverage-build` (:47), `gap-causes` (:55) | | Running. The register metrics for `academic_entry`, `deadline` and `p_description` read 0 because those fields have no reader. **The AER count is not measured here.** |
| Work creation | `enrich-plan-auto` (hourly :41, on); control `auto_enabled = true` | `security.enrich_plan_auto_v1` | 1,591 automatic plans (one per eligible provider), all created 21–29 Oct. Since then 2 a day at most. 0 open now. `plans.redo_days` (14) blocks new plans until 4 Nov 14:41, when 226 plans become eligible again. |
| Work execution | `enrich-plan-run` (*/5), `admin-jobs` (every minute) | `enrich_plan_tick_v1`, `admin_jobs_tick_v1` | 0 jobs queued or running now. Plan steps in 7 days: adapter 542 stopped; pages 405 done and 243 failed; scholarships 953 done; fields 319 done. |
| Queue health | `queue-watch` (4-59/15) | `security.queue_watch_run_v1` | At 09:34: `course_page_read` **failing** (24 of 30 failed in the last hour). `course_page_search` **capped** (200/200, 257 pending, 5,636 exhausted). `source_find` 1,163 pending at 1 an hour. Most other queues show *done* or *nothing_left*, even though the backlog is large. |
| Firecrawl budget | `firecrawl-credit` (*/15) | `firecrawl_credit_observe_tick_v1` | The vendor plan is **5,000 credits a month**. The period started 3 Nov 02:57. 5,595 were left at 10:00, about 3,596 above the reserve. |
| Layer 4 | `layer4-auto-admit` (:47), `no-page-propose` (:37), rules jobs | | 3,410 items pending (table in section 5). |
| Projection | `search-refresh-requested` (6-59/10), `website-sync-check` (each minute), `zoho-sync-check` (each minute) | | Website delta: 2,253 course, 186 provider and 41 scholarship changes in 24 h. Zoho: 1,098 course and 107 provider changes. |
| Monitoring | `integration-validate` (21,51), `platform-health` (8-59/10), `zero-yield-detect` (:21) | | Both are running and raise integration-queue items. `worker-outcome-check` is **paused**. |

### 3.2 Field chains

| Field | Discovery, then work | Worker (`coverage-sweep` mode) | Layer 4, then admission | Last real work |
|---|---|---|---|---|
| Official link | `course-link-search` (each min), `course-link-search-worker` (each min), `coverage-discover`/`-2` (**paused**), `coverage-find-site` (1-59/3), `coverage-ai-match` (each min), `course-relink` | `link_search`, `discover`, `find_site`, `ai_match`, `reidentify` | `official_course_url` items; `coverage-admit` (3-59/10, `official_url` and `english`) | link_search 2 Nov 12:21 (about 22 h ago); ai_match 06:33 |
| Tuition | `fee-reader` (each min, runs every 2 min), `provider-fee-profiles-apply`, `fee-period-settle`, `adapter-overwrite` | `fee_ai`, `adapter_apply` | `provider_current_tuition(_validation)` | fee_ai 01:36 (8.5 h ago); adapter_apply 2 Nov 17:50 |
| Intakes | `intake-dates-apply` (:26), `coverage-admit-intakes` (5-59/10), standing gap queue | `read`, `enrich_ai` | `course_intake` | Intake fill 09:00–10:00 (6 filled); enrich_ai 05:55 |
| English | `provider-english-defaults` (3-59/10), `coverage-admit`, gap queue | `read`, `enrich_ai` | `course_english` | enrich_ai 05:55 |
| AER course reads | **none (manual enqueue only)** | `entry_ai` | `course_entry_first_read`; gate `course_entry_gate_v1` | 30 Oct 07:14 |
| AER provider matrix | `entry-matrix-read` (4-59/5), `aer-reconcile` (:27), `aer-outcome-register` (*/5) | `entry_ai` | `entry_matrix_first_run` | 30 Oct 07:14 |
| Scholarships | `scholarship-discover` (*/10), `scholarship-discover-refill` (:23), `scholarship-listing` (7-59/15), `scholarship-read` (**paused**), `scholarship-ai-extract` (each min), `scholarship-recheck` (*/2), `scholarship-auto-publish` (:29), `scholarship-reread-cadence` (daily) | `scholarship_discover`, `scholarship_listing`, `scholarship_ai` | auto-publish and publication holds | AI 06:02; discover 05:41; listing 01:52; recheck worker not called since 30 Oct |
| Rankings | `ranking-link` (:37) only | none | `admin_ranking_link` | Name links hourly; data last changed 14 Oct |
| Provider description | `provider-description-read` (6,16,26,56) | `provider_description` | `provider_description` (2 pending) | Proposal 2 Nov 19:57; integrator retry 08:47 |
| Course description | **none** | **none** | **none** | never |

---

## 4. Throughput and backlog

### 4.1 Backlog, accepted per hour and forecast

Source: `pipeline.field_coverage_daily`, 3 Nov snapshot (active courses and providers). The 24 h and 7-day figures are net changes in filled values: admissions minus withdrawals.

There are two rates:

- **24 h rate:** includes the integrator's Firecrawl window, so it overstates what the platform does alone.
- **Unattended baseline:** the 6 days before that, (7-day change − 24 h change) ÷ 6. This is the better estimate of what the platform does on its own.

**Forecast assumption:** the rate stays as measured, the budget stays as configured, and Layer 4 keeps pace. "Never" means the rate is zero or negative.

| Field | Country | Missing / total | Change in 24 h | Accepted per hour (24 h) | Unattended baseline per day | Forecast at 24 h rate | Forecast at baseline |
|---|---|---:|---:|---:|---:|---:|---:|
| Course description | AU / NZ / CA | 25,217 / 6,495 / 3,815 | 0 | 0 | 0 | never | never |
| Official link | AU | 7,235 / 25,380 | +8 | 0.3 | −32.3 (withdrawals) | 904 days | never (net loss) |
| | NZ | 3,443 / 6,495 | 0 | 0 | +1.5 | never | 2,295 days |
| | CA | 1,087 / 3,815 | 0 | 0 | +10.7 | never | 102 days |
| Tuition | AU | 16,814 / 25,380 | +35 | 1.5 | −4.2 (withdrawals) | 480 days | never (net loss) |
| | NZ | 5,009 / 6,495 | +46 | 1.9 | +4.3 | 109 days | 1,157 days |
| | CA | 3,081 / 3,815 | +17 | 0.7 | +6.7 | 181 days | 462 days |
| Intakes | AU | 15,856 / 25,380 | +59 | 2.5 | +9.5 | 269 days | 1,669 days |
| | NZ | 4,296 / 6,495 | +43 | 1.8 | +2.7 | 100 days | 1,610 days |
| | CA | 2,146 / 3,815 | +55 | 2.3 | +0.2 | 39 days | no measurable progress |
| Deadline | all | 35,690 / 35,690 | 0 | 0 | 0 | never | never |
| English | AU | 9,031 / 25,380 | +9 | 0.4 | +2.2 | 1,003 days | 4,168 days |
| | NZ | 4,123 / 6,495 | +5 | 0.2 | +1.7 | 825 days | 2,474 days |
| | CA | 1,797 / 3,815 | +1 | 0.04 | +1.2 | 1,797 days | 1,540 days |
| AER (courses with a requirement) | AU / NZ / CA | 25,137 / 6,258 / 3,815 courses without | 0 automatic | 0 | 0 automatic | never | never |
| Scholarships (providers with any) | AU | 1,485 / 1,540 | 0 | 0 | 0 | never | never |
| | NZ | 282 / 289 | 0 | 0 | 0 | never | never |
| | CA | 38 / 52 | 0 | 0 | +0.2 | never | about 230 days |
| Provider description | AU / NZ / CA | 1,540 / 289 / 52 | 0 | 0 | 0 | never | never |
| Rankings | AU / NZ / CA | name links missing: QS 1 AU, 9 CA; THE 5 CA | 0 | 0 | 0 | no automatic import | |

Notes on the AER and scholarship rows:

- **AER:** the 480 courses that have a requirement (243 AU, 237 NZ, 0 CA) all came through the Layer 4 batch L4B. The Platform Admin's account made 523 inbox decisions and 457 AER approvals between 1 Nov 10:25 and 2 Nov 00:15.
- **Scholarships:** "eligible" is narrower than the totals. Only universities with at least 30 courses are counted (`firecrawl.scholarship_min_courses` 30; non-university admission off). The provider count is the honest measure here. Scholarship records grew by 16 in 24 h.

Forecasts this large mean the backlog will not close under present settings. **They are not dates to plan around.**

### 4.2 Worker activity (`pipeline.mode_outcome_ledger`)

| Mode | Items OK, 7 days | Items OK, 24 h | Failed, 24 h | Idle calls, 24 h | Last real work |
|---|---:|---:|---:|---:|---|
| enrich_ai | 20,045 | 8,676 | 173 (HTTP) | 8 | 05:55 (standing gap run only) |
| read | 17,222 | 4,810 | 1,153 | 657 | 09:20 |
| link_search | 16,589 | 824 | 170 (HTTP) | 221 | 2 Nov 12:21 |
| ai_match | 8,583 | 3,088 | 1 | 204 | 06:33 |
| reidentify | 7,254 | 2,344 | 0 | 218 | 06:31 |
| adapter_apply | 2,386 | 22 | 0 | 0 | 2 Nov 17:50 |
| scholarship_ai | 2,010 | 346 | 4 | 0 | 06:02 |
| source_find | 1,200 | 213 | 0 | 0 | 09:36 |
| fee_ai | 1,083 | 723 | 0 | 0 | 01:36 |
| discover | 352 | 4 | 0 | 285 (1,974 calls) | 3 Nov 02:11 |
| entry_ai | 168 | 0 | 0 | 0 | 30 Oct 07:14 |
| central_ai | 166 | 1 | 0 | 0 | 2 Nov 18:50 |
| scholarship_discover | 77 | 64 | 25 (HTTP) | 25 | 05:41 |
| scholarship_listing | 23 | 14 | 0 | 18 | 01:52 |
| provider_description | 5 | 5 | 3 (HTTP) | 0 | 2 Nov 19:57 |
| nz_cop | 0 | 0 (no calls since 31 Oct 02:50) | 19 in 7 days | | **never succeeded** |
| cricos_peo | 0 | 0 (1,008 calls) | 0 | 179 | never; its cron job is paused, but the mode is still called |

### 4.3 Scheduler success compared with real work

Every scheduled job in the chain reported success in 24 h, except four:

| Job | Failed runs in 24 h | Cause |
|---|---:|---|
| `search-refresh-requested` | 9 of 144 | statement time-out |
| `field-gap-queue` | 2 of 4 | statement time-out |
| `coverage-admit-intakes` | 2 of 144 | advisory-lock time-out |
| `coverage-admit` | 1 of 144 | |

Scheduler success does not mean work was done:

- `coverage-read` and `coverage-read-2` ran 2,324 times each, and the last calls returned `idle` with `firecrawlRemainingAboveReserve: 3596`.
- `provider-description-read` ran 70 times with no publication.
- `nz-cop` "succeeds" every 10 minutes, but its worker has never produced an item.

### 4.4 Source and AI consumption

**Firecrawl** (`pipeline.coverage_vendor_usage`):

| Use | 24 h credits | 7-day credits | Last use |
|---|---:|---:|---|
| fc_search (integrator run f3333324) | 15,054 | 15,054 | 2 Nov 18:18 |
| fc_read (integrator run fd98d679) | 14,622 | 14,622 | 3 Nov 01:30 |
| course_link_search | 608 | 13,914 | 2 Nov 12:21 |
| scrape | 784 | 3,417 | 06:32 |
| sch_scrape | 323 | 1,665 | 06:00 |
| map, list_scrape, sch_map | 222 | 1,334 | 09:36 |
| other | 28 | 578 | |
| **Total** | **31,641** | **50,584** | |

Without the integrator runs, scheduled use was about 1,965 credits in 24 h.

**AI** (`pipeline.ai_spend_ledger`): this ledger only starts on 2 Nov at 14:13, so it has no 7-day figure. 24 h total US$9.06:

| Lane | US$ | Calls |
|---|---:|---:|
| enrich_fields | 6.78 | 8,676 |
| fee_ai | 1.71 | 625 |
| course_match | 0.42 | 3,153 |
| scholarship_ai | 0.15 | 344 |
| provider_description | 0.004 | 5 |
| adapter_builder | 0.003 | 6 |
| central_ai | 0.002 | 1 |

**No AI spend since 06:33.** All AI lanes are idle because no work is waiting. Platform health reported US$12.46 against the US$14 daily ceiling (IQ-00054); the gap is spend before the ledger started.

**Idle because of budget, not failure:**

- Course-page reads: about 1,500 bound pages are due (676 fetch-failed, 270 never read, 105 robots, 51 blocked, 163 ambiguous fetch-failed) while the read worker answers `idle`.
- Course-page search: capped at 200 a day.
- Scholarship maps: same Firecrawl limit.

**Real failures, not throttling:**

- `enrich_ai` HTTP errors (IQ-00053).
- `scholarship_discover` HTTP 500s.
- The `provider_description` picker time-out (IQ-00055).
- `field-gap-queue` time-outs (IQ-00031).
- The `nz_cop` worker.

### 4.5 Active jobs now

| What | Count |
|---|---|
| `admin_jobs` queued, running or paused | 0 |
| Enrichment plans open | 0 |
| Firecrawl runs running | 0 |
| Entry-matrix runs queued | 0 (100 done, 12 failed, last 30 Oct) |
| Provider-description reads | 3 queued, 2 proposed |
| Fee-reader queue | empty |

---

## 5. Layer 4: waiting items

| Field code | Pending | Oldest | New in 24 h |
|---|---:|---:|---:|
| official_course_url | 2,668 | 2.7 days | 2,635 |
| course_entry_first_read | 499 (381 held by gate) | 4.9 days | 0 |
| provider_current_tuition_validation | 135 | 8.6 days | 106 |
| no_page_first_run | 55 | 3.4 days | 0 |
| entry_matrix_first_run | 40 (38 held by gate) | 5.3 days | 0 |
| conjoint_rule_first_run | 5 | 3.4 days | 0 |
| provider_current_tuition | 5 | 7.7 days | 4 |
| provider_description | 2 | 0.6 days | 2 |
| course_english | 1 | 3.5 days | 0 |

Layer 4 is a human gate by design. The self-sustainability risk is volume:

- Official-link items arrive in bursts after Firecrawl runs, and they come back after a decision (IQ-00039/IQ-00040). The automatic auto-admit path (`layer4-auto-admit`) covers only `no_page_first_run`.
- `pdesc.pending_max` (10) makes the provider-description reader wait for Layer 4, so slow review also stops that reader.

---

## 6. Work that depended on Claude acting as dispatcher (last 3 days)

Source: `pipeline.admin_control_events` 27544–28697 and `pipeline.firecrawl_runs`.

| When (AEDT) | Event | What Claude did | Effect on throughput |
|---|---|---|---|
| 2 Nov 16:48–16:54 | #28626, #28627, #28629 `firecrawl_run_start` (started "by the integrator (no user session)"), plus extend, resume, pause-for-load and two concurrency cuts | Started 3 Firecrawl runs (find course pages; read and re-read held pages), raised concurrency, paused and resumed | 29,676 credits. 13,042 pages read. Most of the last 24 h of link, intake, fee and English movement. 2,635 official-link Layer 4 items. |
| 2 Nov 16:40–3 Nov 01:35 | Unlimited-window settings (#28625 onwards); window ended #28683 | Changed about 20 Firecrawl and scholarship limits, then restored them | Temporary. Normal limits are back. |
| 3 Nov 00:23 | #28680 `scholarship_discover_picker_stopgap` | Parked 1,054 pending discovery rows for 6 h because the picker timed out | Discovery only kept moving because of this manual park. The fix (F1) is now deployed but not yet proven. |
| 3 Nov 08:47 | #28694 provider_descriptions `retry` (Integration Controller) | Re-queued 3 pilot universities | The pilot reader moved only after a manual re-queue. |
| 2 Nov 16:07 and 17:26 | #28623 `pdesc_pilot_enabled`, #28647 `intake_dates_enabled` | Switched on decided releases | One-off activations under the Platform Admin's decisions. These are correct and not a dispatcher loop. |
| 1 Nov 10:25–2 Nov 00:15 | 523 `inbox_decide` and 457 `aer_approve` under the Platform Admin's account (batch L4B) | Applied Layer 4 decisions in an approved batch | All AER now in the catalogue (480 courses) came from this batch. No automatic AER since. |
| 1–3 Nov | E1, E15, E16, H01, H11, H24 and intake-excluded-months withdrawals or repairs | Corrective housekeeping | Containment, not enrichment. It explains the negative AU link and fee baselines. |

The onboarding adapter events (adapter_builder_* and uni_adapter_*) run under the owner account but are automatic: the reason reads "Onboarding: …". They are not counted as manual.

**Measured split for the last 24 h:**

- **Firecrawl:** 94% from manual runs.
- **Page reads:** 99.5% from manual runs.
- **AI:** 75% came from the scheduled standing gap job (`enrich_fields`, US$6.78). That job is automatic.

---

## 7. Re-reads and stale data

| Area | Cycle | State |
|---|---|---|
| Course pages | `next_read_at`; `firecrawl.central_refresh_days` 30; `reread-pilot` (daily); `university-reread-requests` | The oldest page read is from 29 Sep. Re-reads that need Firecrawl are held by the budget. |
| Enrichment plans | `plans.redo_days` 14 | One pass a fortnight. There is no between-cycle trigger when a page changes. |
| Gap queue | `gaps.recheck_days` 60, every 6 h | Times out (above). |
| Entry matrix | `entry.matrix_refresh_days` 30 | The edition-check job does not exist (IQ-00008). |
| Provider description | `pdesc.recheck_days` 180 | Pilot only. |
| Scholarships | `scholarship-reread-cadence` (daily), `next_discover_at` | Runs. The recheck worker has not been called since 30 Oct. |
| Fees | Re-read when the stored page's content hash changes | Depends on page re-fetches, so it is throttled. |
| Rankings | none | No new-edition check. THE 2027 is not held (THE editions held: 2015–2026). |

---

## 8. Country coverage: AU, NZ and CA

| Mechanism | Country handling | Finding |
|---|---|---|
| Enrichment plans and gap queue | Country-neutral; `plans.priority_countries` = [NZ] | Shared engine, configured by setting. Pass. |
| Fees | `fees.countries` = [NZ, CA, AU] | Pass. |
| Scholarships | `scholarship.country_onboarding` lists AU, NZ and CA as enabled | Pass. The CA government register is held because EduCanada's robots.txt blocks automated readers. |
| AER | `entry.countries` and `entry.course_read_countries` = [AU, NZ], plus fixed provider-ID lists | **Canada is not configured. AER has no adapter or configuration for CA.** It should go to the integration queue (no IQ item exists). The hand-picked provider lists are not a country rule. |
| Provider description | `pdesc.countries` = [AU] and 5 fixed provider keys | A pilot, by decision. Not yet country-scalable. |
| Country gate job | Command `select security.country_scope_gate_v1(true, 'CA')` | **A country written into a job command.** It should be a setting under G2. |
| Country registers | `nz-cop` (NZ), `ca-dli-flag` (CA), CRICOS (AU) | Country adapters, as intended. **The `nz_cop` worker has never succeeded.** |
| Course adapters | Providers with a university adapter: AU 1,017 of 1,540; NZ 125 of 416; **CA 48 of 1,130** | CA depends almost entirely on generic page reads, which are throttled. |

No country is missing an adapter for every field. Two gaps should be raised as integration-queue items:

- Canada has **no AER configuration**.
- **The NZ code-of-practice reader does not work.**

---

## 9. Broken components, ranked by impact on self-sustainability

1. **Firecrawl budget does not match the vendor plan.** The plan is 5,000 credits a month (about 3,600 usable now). The settings assume 25,000 a day (`firecrawl.daily_budget_total`, `daily_share_*`). Every acquisition worker answers `idle` at the reserve. This is throttling, not failure, but it halts link, fee, intake, English, scholarship-map and description acquisition for the rest of the billing period. It needs a Platform Admin decision on budget or plan. Raising concurrency would not help.
2. **No reader for course description or application deadline.** For both, `field_register.reader` is `'none'`, and no job, worker mode or admission path exists.
3. **No automatic AER.** No scheduled caller of `course_entry_read_enqueue_v1`. Matrix runs idle since 30 Oct. Fixed provider lists. No CA. 539 items in Layer 4, 419 of them held by the new gates. Ingestion is still on hold by decision.
4. **Work creation stalls between cycles.** `enrich_plan_auto_v1` gives each provider one plan per 14 days, and all were used by 29 Oct. The `field_gap_queue_tick_v1` gap insert times out (2 of 4 runs). Gap discovery sees the backlog, but most queues report "nothing_left", so missing values whose evidence is not stored never become new acquisition work.
5. **Scholarship discovery needed a manual park.** The picker time-out was fixed in v2.15.413 but has not been seen working on live data. 1,082 pending providers are not due before 11:10. 132 listing pages are suggested but never read. `scholarship-read` is paused.
6. **Provider description is limited to the pilot.** 5 fixed keys, a lifetime US$1 ceiling (`pdesc.ai_usd_max` compared with all-time lane spend) and `pending_max` 10. The picker times out (IQ-00055). It cannot scale without settings and decisions.
7. **Hidden failures counted as success.**
   - `enrich_ai` HTTP errors (IQ-00053: 173 in 24 h).
   - The `nz_cop` worker has never succeeded.
   - `cricos_peo` is called 1,008 times a day with nothing to do while its job is paused.
   - `search-refresh-requested` has time-outs (9 in 24 h).
   - `worker-outcome-check` is paused.
8. **Rankings have no automatic refresh.** No edition check or import job. 15 CA and AU institutions are not name-linked.
9. **Layer 4 volume.** 2,668 official-link items arrive in bursts and come back after decisions (IQ-00039). Tuition checks are 8.6 days old. Without review capacity, gated readers such as provider description stop.

---

## 10. What would make the acceptance test pass

Section 11 of the mandate requires that automatic enrichment progresses with no Claude session. Today that holds only for publication, projection, intakes from stored calendars, and scholarship extraction and publication. To pass:

- **Budget:** the Platform Admin decides on the Firecrawl budget, and `firecrawl.daily_budget_total` and its shares are set to what the plan can pay for. The platform then paces work to that figure.
- **Missing readers:** course description and deadline readers are built into the existing Enrich-fields and coverage engines (not new scripts).
- **AER:** a scheduled, country-configured AER enqueuer gated by the existing Layer 4 rules, with CA added through `entry.countries`.
- **Work creation:** the gap queue's time-out is fixed, and acquisition work is created from gaps between plan cycles.
- **Scholarships:** F1 is confirmed live without a manual park, and suggested listing pages enter the read path.
- **Hidden failures:** the four in section 9, item 7, are visible on Platform health.
- **Rankings:** a new-edition check is added for the ranking systems held.

The next measurement should repeat sections 4.1–4.4 after 24 h with no Claude actions. It should look at `admin_control_events` with no integrator events after 10:08 on 3 Nov.
