# Enrichment-health reconciliation (Workstream 1), 30 Oct 2026

**Mandate:** Platform Admin, 30 Oct 2026 00:01 AEDT, Workstream 1. This was read-only: nothing was changed, admitted, cleared or re-run.

**Report reconciled:** the hourly phone report sent about 23:20 AEDT on 29 Oct.

**Evidence:** read live from `fxcwkweaxjtknorudmwp` between 00:05 and 00:25 AEDT on 30 Oct. Every count is a dated query result.

**Companion:** the complete "needs a change" list is in `2026-10-30-gap-causes-needs-a-change.md`.

## 1. Summary

| Reported observation | What it actually is | Class |
|---|---|---|
| Layer 4 queue "grew from 7 to 304 during the hour" | Items **created in the 24 hours to 23:00 AEDT against the 24 hours before**, not one hour. 259 of the 304 are AER items from the authorised programme. Only 2 items were created in the 5 hours before the report, both now superseded. | Expected, with a mislabelled metric |
| 515 pending | 241 AER items and 274 other items. Not 515 defects. Breakdown in §2. | Mostly expected; about 50 possibly overtaken |
| No NZ or CA field gained a value | Every NZ and CA read in the window was an identity re-check of a page the gate already excludes, or found nothing new. | Expected (gated) |
| Nothing admitted from 28 pages | 19 identity mismatch, 6 read with no new value, 2 blocked, 1 fetch failed. | Expected (gated); no reader fault |
| AU official pages +3 | Three Kulin Institute courses. They are valid, on the provider's own domain, with exact-title identity. §5. | Expected |
| Gap-cause snapshot "11:00, about 80 minutes old" | The job runs at :55 and stamps the start of the hour. It was the 22:55 run, 25 minutes old. All 24 runs in the last 24 hours succeeded. | Monitoring label |
| 47 "needs a change" rows, only the largest in the phone report | Correct count. All 47 are now in the companion file. | Monitoring limit |
| Source finder failed on every call; adapter capture failed; one 115 s course-list read | Real. Under incident diagnosis in Workstream 2. | **Genuine problem** |
| Two reading lanes read the same pages | Jobs 49 and 159 run the identical command every 30 s and fetch the same URLs within a second. | **Genuine problem (duplicate paid work)** |
| Jobs ran; AI and Firecrawl within limits | True. This shows the jobs ran, not that they produced usable data. Spend inside limits is monitoring information, not permission for more work. | Monitoring information |

## 2. Layer 4 queue

### 2.1 Why "7 → 304"

The health check `layer4_grew` compares Layer 4 items **created** in the last 24 hours with the 24 hours before. The phone report called it "during the hour".

The 304 items created in the 24 hours to 23:00 AEDT:

| Kind | Created | Now |
|---|---:|---|
| `course_entry_first_read` (AER course reads, Monash and Federation batches) | 183 | pending |
| `entry_matrix_first_run` (AER provider matrices) | 76 | 53 pending, 23 superseded |
| `official_course_url` | 21 | pending |
| `course_english` | 17 | superseded |
| `course_intake` | 6 | superseded |
| `provider_current_tuition` | 1 | pending |

**AER total: 259 of the 304.** These came from the course-reading and matrix batches the Platform Admin authorised on 29 Oct.

**W28 contributed legitimate supersessions.** Read again on the newest stored copy closes the item for the older copy. The 23 superseded matrix items are older-copy or re-read runs, and they are not pending work.

### 2.2 The 515 pending items (00:20 AEDT)

| Kind | AU | NZ | CA | Total | Older than 3 days | Created in the last 24 h | Classification |
|---|---:|---:|---:|---:|---:|---:|---|
| `course_entry_first_read` (AER) | 184 | — | — | 184 | 0 | 183 | Actionable new evidence (2 providers) |
| `entry_matrix_first_run` (AER) | 38 | 15 | — | 53 | 0 | 52 | Actionable, except Otago Polytechnic `f14ae480` (older copy, reject per the manifest) |
| `entry_matrix_change` (AER, RMIT) | 4 | — | — | 4 | 0 | 0 | Actionable governed decisions |
| `provider_current_tuition_validation` | 74 | 9 | 37 | 120 | 88 | 0 | 12 sit on courses that already have an active fee newer than the item; possibly overtaken |
| `provider_current_tuition` | 53 | 15 | 1 | 69 | 63 | 1 | 19 sit on courses with an active fee (3 newer than the item); 1 course inactive; possibly overtaken |
| `no_page_first_run` | 30 | 19 | — | 49 | 33 | 0 | Actionable first-run governance (one per provider) |
| `official_course_url` | 21 | 1 | — | 22 | 1 | 21 | Every course already has an active link, so these await correction against the existing link |
| `conjoint_rule_first_run` | 9 | 2 | — | 11 | 11 | 0 | Actionable first-run governance |
| `course_english` | 3 | — | — | 3 | 3 | 0 | Actionable |
| **Total** | 416 | 61 | 38 | **515** | 199 | 257 | |

**Reading the table:**
- **AER 241:** 240 actionable and 1 stale.
- **Non-AER 274:**
  - 151 tuition items are older than 3 days, and 31 of them are probably overtaken by a fee admitted since;
  - 22 official-URL items await a check against a link that already exists.
- **Claimed or assigned: 0.** No reviewer has claimed any item. Kimi Work's review is not affected by anything in this reconciliation.
- **Held incomplete reads are not Layer 4 items.** A read cut short is held before any row is proposed, under W29. The 16 skipped and 3 failed course reads appear in the AER workspace, not in this queue.

**Nothing was cleared.** Overtaken candidates go to reviewers as a classification (role guides 4.6), not as a bulk action.

## 3. The 28 pages read (22:11–23:11 AEDT)

| Outcome | Pages | Next step | Admitted |
|---|---:|---|---:|
| `identity_mismatch` | 19 | Page refused by the identity gate; no proposal | 0 (correct) |
| `read` | 6 | Read, and every field either already held a value or the page gave none | 0 |
| `blocked` | 2 | Site refused | 0 |
| `fetch_failed` | 1 | Retried on schedule | 0 |

Zero admissions is the identity gate plus no new values. It is not human-review latency, and it is not a reader or completeness failure.

The pages were scraped twice because of the duplicate reading lanes (§6.2), so the 28 represent fewer distinct pages and twice the scrape cost.

Nothing was admitted to improve the metric.

## 4. NZ and CA: why no value was gained

| | NZ | CA |
|---|---:|---:|
| Reads in the last 24 h | 61 | 96 |
| … identity mismatch | 53 | 94 |
| … needs render | 5 | — |
| … read | 2 | 2 |
| … fetch failed | 1 | — |
| Bound pages (all time) | 2,968 | 2,724 |
| Pages in identity mismatch | 2,538 | 729 |
| Bound but never read | 24 | 88 |
| Read with every field empty | 355 | 1,427 |

**Classification:**
- **No eligible new source data:** most reads re-check pages the gate already excludes.
- **Reads that found no values:** 4.
- **Proposals awaiting review:** NZ has 15 matrix first runs; no NZ course has been read, because course reading is stopped at the floor.
- **Values held by identity gates:** the large NZ mismatch count comes from `degree_name` proofs (Auckland, Canterbury, Waikato, Lincoln), which are not admitted for fee. CA mismatches come from `adapter_title` (Lethbridge, UBC) and `nzqa_code` (College of the North Atlantic, which is anomalous).
- **Genuine reader or binding failures:** the CA `nzqa_code` bindings, which Workstream 4 is investigating.

## 5. The three new AU official pages

Admitted by job `coverage-admit` at 23:10 AEDT on 29 Oct:

| Course | Provider | URL | Identity basis |
|---|---|---|---|
| Graduate Diploma of Management (Learning) | Kulin Institute | `vocationalinstitute.com.au/bsb80120-…` | `exact_title` (title search) |
| Diploma of Leadership and Management | Kulin Institute | `vocationalinstitute.com.au/bsb50420-…` | `exact_title` |
| Advanced Diploma of Leadership and Management | Kulin Institute | `vocationalinstitute.com.au/bsb60420-…` | `exact_title` |

**Assessment:** valid, not duplicated, and on title-based evidence.
- The domain is the provider's registered website.
- The national training code in each address matches the qualification title.
- Each course has exactly one official link.
- `exact_title` is admitted for official pages by the current identity settings.
- The pages were bound on 28 Oct at 23:08 AEDT, so they are not part of the 29 Oct 14:15 re-binding wave (Workstream 4), and they are unrelated to the source-finder failures.

Over the last 6 hours, 10 AU official pages were admitted in total: 7 on CRICOS-code identity and these 3 on exact title.

## 6. Genuine problems (passed to the workstreams)

1. **Source finder and adapter capture failing (Workstream 2, agent G).**
   - `source_find`: 3 calls in the window, 2 failed, about 17 s average.
   - 1,360 jobs are waiting, and none has been processed since 23:31.
   - The `course_page_search` lane has 1,415 waiting, with a p90 wait of about 8,200 minutes.
   - `course_list_read`: 2 calls averaging 60.5 s, one of them 115 s.
2. **Duplicate paid work (Workstream 2).**
   - Reading jobs `coverage-read` (49) and `coverage-read-2` (159) run the identical command every 30 seconds and fetch the same URLs within a second. Pages show `read_attempts = 2`, and one Auckland URL was fetched 4 times.
   - Over 24 h: 767 scrape calls for 451 URLs.
   - The course-link search repeated the same 381 queries about every 12 minutes: 680 calls and 1,360 units.
   - AI page matching rose from about 10 to 970 calls an hour.
   - Spend stays inside the configured limits, but much of it is repeated work. The correction goes through a decision (W30) before code.
3. **Identity mismatch growth (Workstream 4, agent H):** 1,210 AU pages; CA `nzqa_code` bindings.
4. **Possibly overtaken tuition and URL items:** 31 tuition and 22 URL items (§2.2), for reviewers to classify.
5. **Data:** George Brown College (Canada) is recorded under AU (gap report, data note 1).

## 7. Monitoring limitations and proposed corrections (Workstream 7)

| Limitation | Proposed correction | Needs |
|---|---|---|
| Snapshot labelled with the hour start | The hourly report states the **run time** (from `cron.job_run_details`, job 294) and the age at reading. It flags the data stale when the last successful run is more than 75 minutes old. | Report prompt only (done, §8) |
| The "Why values are missing" panel shows the hour-start label as "Snapshot …" | Show the last successful run time beside it. | **Decision** (a panel change) |
| `layer4_grew` reads as hourly | The report says "created in the last 24 h vs the 24 h before" and gives the pending total separately. | Report prompt only (done) |
| Phone report truncates "needs a change" | It gives the count, the 3 largest rows, and "complete list: Settings › Pipeline › Why values are missing (live) and the dated repository report". | Report prompt only (done) |
| "Job ran" is read as "data produced" | The report gives, for each reader, calls, failures, waiting jobs and the last successful processing time, and states "ran, no usable output" when calls succeeded but nothing was produced. | Report prompt only (done) |
| Source finder, adapter capture and slow reads were absent | Added from `pipeline.mode_outcome_ledger` (failure rate, longest call) and the lane queue (waiting, last processed). | Report prompt only (done) |
| Spend reads as permission | The spend line ends "monitoring only: not authority to start work". | Report prompt only (done) |

## 8. Changes made in this workstream

- **Hourly phone report prompt** (scheduled task "StudySearch hourly stats"): corrected as in §7. Reporting only; no platform change.
- Both reconciliation documents (this file and the gap report).
- **No change on live, nothing admitted, nothing cleared.**
