# AER throughput investigation (mandate 08:16 §8)

4 November 2026. Development agent, for the Integration Controller. All production work was read only, on Supabase project `fxcwkweaxjtknorudmwp`, between 08:19 and 08:43 AEDT. The remedy is on Pilot branch `cf247-aer-throughput` and has not been merged, released or switched on.

## 1. Summary

- **Where the flow stops.** It stops at Layer 4 review. 605 AER items are waiting: 564 course reads and 41 matrix runs. The completeness gate (E13, D-R3) holds 395 of the course reads whole. The other 169 are complete and are waiting for a person. Nobody has decided an AER item since **1 Nov 19:47**, so nothing can reach the active catalogue. "0 admissions overnight" means no reviewer was working, not that a job failed. The 169 complete reads have been admissible all along.
- **Why the queue looks full of decidable work.** It isn't. The readiness job gates only 20 items a run (`layer4.gate_batch`), and it re-gates the same oldest items every cycle. As a result, **376 of the 395 held reads have never been gated** and are listed as `judgement_ready`. This one defect causes three problems:
  - Technical recovery never sees those items: `aer_technical_recovery_v1` acts on `technical_blocked` items only.
  - `wc.aer_fair_on` would free almost no room, because it counts `judgement_ready` items as decisions.
  - Human-assisted recovery (v2.15.463) cannot find the shared-page reads among the parked work.
- **Why technical correction doesn't drain E13 holds.**
  - Technical recovery only records. It does not re-read anything.
  - The scheduled correction (D-R2, the held step of `aer-scheduled-read`) re-reads the same stored page with the same reader, and spends the **same daily cap of 200** as new reads.
  - Overnight, 93 of the 200 reads were corrections. Of the 103 corrections now closed, **10 replaced the held read and 90 were refused**. 63 still dropped printed minimums and 15 were cut at the row limit.
  - 207 of the holds cannot be fixed by any re-read: 162 are cut at the row limit and 45 are on a shared page.
- **Publication.** Zoho has no academic entry requirements at all. `api.website_v2_course_item` `entry_requirements` is English only. Academic AER reaches consumers only through `public.website_v2_course` (`entry`) and `public.website_v2_provider` (`entry_matrix`). Changing that is a decision under G3.

## 2. The ten universities

Source = `entry_matrix_sources` (and the free-discovery inventory outcome). Read = courses with an entry read (any state). Technical block = waiting course reads the gate holds, with the gate class. Review-ready = waiting course reads that are gate-complete, plus matrix runs that pass D-R3. Admitted = courses with active entry rows, and active matrix rows. Published (web) = active course rows in the search projection, and `entry_matrix` rows on the provider payload. Published (Zoho) = academic rows in `zoho_edge_course_lookup_v1`.

| University | Source | Read | Technical block (reason) | Review-ready | Admitted | Published (web) | Published (Zoho) |
|---|---|---|---|---|---|---|---|
| CDU | 1 read (inventory: attachable) | 8 (1 waiting, 7 skipped) | 1 matrix run held by D-R3 | 1 course | 0 | 0 | 0 |
| UniSQ | 1 read (attachable) | 8 (7 waiting, 1 skipped) | 2 (1 dropped minimums, 1 shared page) | 5 | 0 | 0 | 0 |
| UNE | 1 read (general only) | 8 (2 waiting, 6 skipped) | 1 (dropped minimums) | 1 | 0 | 0 | 0 |
| Torrens | 1 read (general only) | 8 (7 waiting, 1 skipped) | 4 (3 dropped minimums, 1 shared page) | 3 | 0 | 0 | 0 |
| ACU | none (unverified link) | 5 (2 waiting, 3 skipped) | 0 | 2 | 0 | 0 | 0 |
| CQU | none (unverified link) | 8 (3 waiting, 5 skipped) | 2 (dropped minimums) | 1 | 0 | 0 | 0 |
| Deakin | none (site blocked) | 8 (6 waiting, 2 skipped) | 4 (dropped minimums) | 2 | 0 | 0 | 0 |
| JCU | none (rendered only) | 8 (8 waiting) | 1 (dropped minimums) | 7 | 0 | 0 | 0 |
| RMIT | 36 read | 310 (303 waiting, 79 skipped, 1 filled) | 214 (94 row limit, 91 dropped minimums, 27 shared page, 2 row level) | 89 | 1 course (1 row); 380 matrix rows | 1 course; 380 matrix rows | 0 |
| UWA | 1 read | 8 (7 waiting, 1 skipped) | 2 (dropped minimums) + 1 matrix run held by D-R3 | 5 | 0 | 0 | 0 |

Notes:
- RMIT's one admitted course row is a domestic ATAR (`2026 ATAR 73.00`), so no international academic course requirement is admitted for any of the ten.
- The coverage ledger (`pipeline.aer_provider_coverage`) records 326 UWA and 168 CDU course reads waiting. The live items show 7 and 1. The ledger is stale or misattributed and should not be used for this report.
- 1,424 providers have no AER source attempt. `coverage-discover` and `coverage-discover-2` are paused (event 3 Nov 12:31): "Held off since the Firecrawl window ended 3 Nov 01:35 (#28683); re-applied after v2.15.423 so jobs.held_off now keeps them off (IQ-00060)". They were not restarted. Firecrawl spend needs a decision; the balance is 2,099 credits.

## 3. Where the flow stops, stage by stage (all AER)

| Stage | Count | Evidence |
|---|---|---|
| Waiting in Layer 4 | 605 (564 course, 41 matrix) | `layer4_review_items` pending |
| Gate-complete course reads (a person can approve) | 169 | `course_entry_gate_v1` per item, 08:27 |
| Held whole by E13 | 370: 162 row limit, 45 shared page, 163 dropped minimums | the same |
| Held for rows only (Approve except) | 25 | the same |
| Held but classified `judgement_ready` | 376 of 395 (`gate_checked_at` null) | `layer4_item_readiness`, 08:28 |
| Classified `technical_blocked` | 37 (19 course, 18 matrix) | the same |
| AER decisions since 1 Nov 19:47 | 0 | `layer4_decisions` |
| Overnight reads (17:13–02:13) | 107 new, 93 corrections; cap reached, refused from 03:13 | `aer_schedule_runs` |
| Corrections closed | 103: 10 superseded, 90 refused, 2 requested | `aer_read_supersessions` |
| Scheduled check outcomes | 85 row limit, 58 shared page, 18 row level, 6 manual lock: "for a person" | `aer_schedule_checks` |

**Root causes, by class:**

1. **Code defect in readiness (orchestration).** The gate is starved by its batch and by the order items are classified in. Held reads are reported as decisions.
2. **Recovery design.** The automatic correction re-reads with a deterministic reader that produces the same result (about 10% yield). It is charged to the cap for new reads, and it is the only automatic action. Row-limit and shared-page holds have no automatic path. They are routed "for a person", but no person receives them.
3. **Activation and authority.** No AER reviewer has acted for 2.5 days. Admission requires a person (Layer 4 is preserved). The fairness switch (`wc.aer_fair_on`) is off, and while cause 1 stands it would change nothing.
4. **Concentration.** RMIT holds 303 of 564 course reads, 214 of them held. Under `wc.aer_fair_on` its share (10% of 600 = 60) would stop new RMIT reads once readiness is correct.
5. **Consumer gap (G3).** Zoho and `api.website_v2_course_item` carry no academic AER.

**What `wc.aer_fair_on` would change:**
- Today, almost nothing. Distinct `judgement_ready` items are about 568 (545 + 23), against the limit of 600.
- After the readiness fix: about 217 ready decisions (169 + 25 + 23), plus reads in progress. That leaves roughly 380 places for new reads, taken university by university. RMIT would be excluded by its 60 share, and 10% of the limit is kept for universities with nothing waiting.
- It does not change the daily cap. It ships off and needs a decision (more AI reads and more Layer 4 items).

## 4. Remedy built (Pilot `cf247-aer-throughput`, commit `a612eaca`, migration `20261104470000_cf247_aer_throughput.sql`, md5 `971e5782665a2ae41a508e7ad5489aab`)

1. **Readiness gates never-gated entry reads first** (`security.layer4_readiness_tick_v1`, md5-guarded edit). An entry item with no gate result is classified again every run until it is gated, and it takes the gate before items that already have one. `layer4.gate_batch` stays at 20, which clears the 376 in about 10 hours at :22 and :52. The Controller may raise the batch. This changes records only. **Ships on** as a defect correction (mandate 08:16 §4 and §5). Nothing is read, decided or spent.
2. **Technical recovery records the gate class** (`security.aer_technical_recovery_v1`, md5-guarded edit, with the new helper `security.aer_e13_class_v1`). The classes are `row_limit`, `shared_page`, `drops_uncovered` and `row_level`, recorded with `reread_can_fix`. Human-assisted recovery's `aer_course_identity` generator finds shared-page holds by this class. **Ships on** (records only).
3. **E13 recovery from stored evidence** (`security.aer_e13_recover_v1`, run at the end of each `aer-scheduled-read` run inside technical recovery, isolated).
   - Picks only `technical_blocked` items held by the completeness gate whose class is `drops_uncovered`, and re-checks the gate before acting.
   - Requires the stored copy of the same page and reads with the scraper off, so there is no Firecrawl spend.
   - Uses the existing D-R2 corrected read, which replaces the held read only when the new read is complete.
   - Respects the limits on tries and on time between tries, and takes at most 2 holds per university in a run, fewest tries first. Reads are capped by `batch.aer_e13_recover` (10) per run and `aer.e13_recover_daily_max` (40) per day, separate from the cap of 200.
   - Stops when AI is stopped, when the run-as owner lacks the Platform Admin role, or when the balance would fall below the floor.
   - While it is on, the tick's held step yields to it (`security.aer_schedule_held_v1`, md5-guarded edit), so the cap for new reads is no longer spent on corrections.
   - `security.aer_e13_recover_v1(true)` previews a run without writing.
   - **Ships off** (`aer.e13_recover_on` = 0). It is AI spend outside the existing cap, which no mandate authorises: about US$0.24 a day at the defaults, with about 1 in 10 reads replacing its hold.

Nothing approves or rejects anything. The 600 limit, E13, D-R3 and the consumer API are unchanged, and nothing is dropped.

**md5 checks**

| Function | Before | After |
|---|---|---|
| `layer4_readiness_tick_v1` | `5ed0f7d1ba89c9248403fa4bce76d6fe` | `06e5f4394b0c2831404fc7a766d669c4` |
| `aer_technical_recovery_v1` | `3b8ea81abeae4b7d45f43e8cdb27ed26` | `370baa57bfb81fe58df767ad852ca9dd` |
| `aer_schedule_held_v1` | `0ea5886c2956255ea2d3f102c64b0166` | `2a0d51faada02e5e36dafb88749b4707` |

**Fixture.** `tests/fixtures/aer-throughput/run.sh` runs on PostgreSQL 16.
- The seed is production-shaped: 605 waiting items at 52 universities, with RMIT at 303. Gate classes are in live proportion, 376 holds have never been gated, 83 holds have one refused try and 2 have a try in progress, there are repeated matrix keys, and 26 reads have no stored copy of the same page.
- The run first reproduces the live starvation (376). It then applies the migration, then applies it again with no change.
- 28 assertions pass.

## 5. Decisions needed (one pack)

1. **Reviewer capacity.** 169 complete course reads and 23 matrix runs are admissible now, with no further development.
2. **`aer.e13_recover_on`.** Re-reads from stored evidence, at about US$0.24 a day and an expected yield of about 10%.
3. **`wc.aer_fair_on`**, after the readiness fix has been live for one day. It resumes new reads, taken in turn by university.
4. **Row-limit holds (162; RMIT 94).** A per-university value in `entry.max_rows_by_provider` (E13 retains rows read for a later authorised step). No re-read can release these.
5. **Consumer publication (G3).** Whether academic AER should be added to Zoho and to `api.website_v2_course_item`.
6. **Course page discovery.** Firecrawl for the 1,424 providers with no source attempt.

## 6. The daily cap's day boundary (Controller's first-run audit lead, 4 Nov)

**Lead:** at 08:13 Sydney the cap still read "reached". If the cap counted UTC days, reading could not resume before 11:00 Sydney.

**Ruled out.** `security.aer_schedule_tick_v1` counts the cap over a rolling window, not a calendar day:

```sql
select sum(course_reads + corrections) from pipeline.aer_schedule_runs where ran_at > now() - interval '1 day'
```

The code marks this line `-- fixed: the daily cap is counted over the last 24 hours`.

- At 08:13 the window held the runs from 17:13 (3 Nov) to 02:13 (4 Nov): 200 reads.
- Room returns run by run as runs leave the window. The first 20 places come back at the **17:13 Sydney** run, when the 17:13 run of 3 Nov drops out. That is later than 11:00, not earlier.
- New reads also stay stopped while the raw count is 600 or more (605 now, with `wc.aer_fair_on` off). The held corrections are exempt from that stop, but they are inside the cap.
- The rolling window is the recorded design, so it is not a defect and no change is made. With `aer.e13_recover_on` on, corrections move to their own budget and the 200 is left for new reads.

## 7. Load windows

- Heavy reads ran at 08:26:08, 08:26:33, 08:27:01 and 08:28:38 (the last finished at :28:38, inside minute :28).
- Light catalogue reads ran at 08:19–08:22, 08:30–08:33 and 08:43.
- No reads were made in the blocked windows (08:35–08:42 and :47–:48).
- No slips.

## 8. After v2.15.465: verification, review queue and routing (direction 10:00 §3–§4)

Production was read only, between 11:09 and 11:19 AEDT. The heavy reads ran at 11:16:11 and 11:18:02.

### First readiness runs

| Run | Gates | Notes |
|---|---|---|
| 09:52 | 20 | It re-gated 18 matrix runs that already had a gate. That points to the old ordering still being live at 09:52. |
| 10:22 | 20 | Never-gated items first. |
| 10:52 | 20 | Never-gated items first. |

- Since 09:37, 42 course reads moved into gate classes: 5 complete, 21 dropped minimums, 11 row limit, 4 row level and 1 shared page.
- **Still never gated:** 471 course reads and 3 matrix runs. At `layer4.gate_batch` 20 that is about 12 hours. Raising the setting to 60 would clear it in about 4 hours, with no spend.
- **Correction to §2:** the earlier "165 complete reads gated" was wrong. The query used `min(gate_checked_at)`, which ignores nulls, so most complete reads had in fact never been gated either. The 376 held reads never gated stands.

### The 605, by the gate itself (11:16)

**Course reads (564):**

| Class | Count | Route |
|---|---|---|
| Complete | 169 | Review |
| Row level | 25 | Review with Approve except (rows to leave out) |
| Row limit | 162 | Authority decision; QUT's 38 reads are qualification tables to map as a matrix source |
| Shared page | 45 | Identity confirmation |
| Dropped minimums | 163 | Recovery from the stored copy, else a request for the rows |

**Matrix runs (41):**

| Class | Count | Route |
|---|---|---|
| Complete | 2 | Review |
| Held only for rows to leave out | 22 | Review with Approve except |
| Held for dropped published rows | 17 | Matrix source (Human-assisted recovery's `aer_read_held`) |

The "23 ready matrix runs" in the 10:00 figures were runs that readiness labelled `judgement_ready` without ever gating them. 21 of the 41 matrix runs are ANU's.

**Admissible now:** 169 complete course reads + 2 complete matrix runs = **171 items**. Another 47 can be decided with Approve except: 25 course reads and 22 matrix runs. The total ready for a reviewer is 218.

### Row-limit assessment

**RMIT (94 reads):**
- Rows per read: median 9, 90th percentile 12, maximum 19.
- The rows that were cut are mostly alternative admission routes: 97 prior qualification, 88 subject prerequisite, 85 portfolio or interview, 67 minimum grade.
- None of the 349 cut rows records an audience.
- None of the 94 reads kept the rows it read, so any change means new AI reads (about US$0.57 for all 94).

**Recommendation:** a pilot of `entry.max_rows_by_provider` = RMIT 20 on 10 reads, as a Platform Admin decision. The pilot's audience check must pass before any wider use. It was not piloted in code.

**QUT (38 reads):** a median of 68 rows a read, maximum 117. These are country qualification tables printed on course pages. They should be mapped as QUT's matrix source, not given a higher row limit.

### `wc.aer_fair_on` projection

| Measure | Today | Once every item is gated |
|---|---|---|
| Room under the 600 limit | about 87 | about 382 |
| Ready decisions counted | 513 `judgement_ready` (labels, not gated) | about 218 (gated) |

- Each university's share is 60. RMIT, with 91 ready, would be at its share and get no new reads.
- AUT (25 ready), Monash (23) and ANU would keep headroom.

**Recommendation:** evaluate activation after gating completes. The switch was not changed.

### Remedy

Pilot branch `cf247-aer-review-queue`, migration `20261104490000`:
- the review packet and review card;
- the reviewer-ready queue and ownership claims;
- routing, and lane `aer_item`'s intervention generator;
- the E13 pilot bounds;
- the fairness projection.

Details are in the migration header.

## 9. RMIT settlement (direction 12:16)

Production was read only from 12:17 to 12:43 AEDT. The heavy read ran at 12:26:11.

**Load-window slip:** one light catalogue read ran at 12:42:55, inside the 12:35–12:42 no-read window. It was an md5 and hook-register check, after the container restarted.

### The 303 RMIT items (live gate at 12:26)

| Class | Count | What it contains |
|---|---|---|
| Ready for authorised admission | 91 | 89 complete reads; 2 that need some rows left out (Approve except) |
| Technically blocked, recovery possible | 27 | Dropped minimums, no corrected read tried yet, stored copy of the same page exists |
| Needs evidence, input or a decision | 184 | See below |
| Stale | 1 | The course is now bound to another page |

**The 184 needing evidence, input or a decision:**

| Reason | Count | Next action |
|---|---|---|
| Row limit | 93 | Row boundary (authority) |
| Shared page | 27 | Identity confirmation |
| Dropped minimums, corrected read already refused on the same stored copy | 58 | Repeats on unchanged evidence: rows from a person, no further re-read |
| Refused for the row limit | 4 | Every printed requirement was kept (8–9 rows read); waits for the row boundary |
| Refused on the page's identity proof | 2 | Identity confirmation |

**Stored-class view:** the product view reads stored gate classes only. 279 of the 303 had not yet been gated by readiness at 12:18, so it shows them as recoverable ("not yet checked") until job layer4-readiness reaches them.

### Diploma of Commerce (111278B, item a7849f66)

- **What happened:** two corrected reads ran on the same stored copy (a0ffab81): 3 Nov 17:13 (enrich item 265315) and 4 Nov 12:17 (enrich item 270218, the Platform Admin's Re-read). Both returned the same result.
- **Why it is still held:**
  - The current reader does resolve the score_without_basis drop: the VCE English prerequisite comes back as a subject prerequisite row.
  - Each read found 9 requirements against a limit of 6, so E13 held the read whole ("held_partial: over_row_limit"). It kept all 9 rows (`value.rows_read`).
- **A third re-read** would repeat the same refusal.
- **An `aer_item` rows request** would resume the same refused read. Branch `cf247-aer-review-queue` does not raise one for this item (route `row_limit_stored`).
- **Next action:** the RMIT row-boundary decision (`entry.max_rows_by_provider` RMIT ≥ 9).
  - Then **one** corrected read through the Inbox's Re-read from stored evidence (`course_entry_correction_v1`), about US$0.006.
  - Or an authorised step that proposes the 9 stored rows with no AI read (not built).
- **For the reviewer:** 3 of the 9 rows are "no prerequisite" or "no selection task" statements, or a STAT route, to leave out.

### Lifecycle candidate (§9)

Graduate Certificate in Supply Chain and Logistics Management (084996M).

The automatic part is already done: the held read c88caacd was corrected on 4 Nov at 00:14, and the replacement item 5146f300 is review-ready. It has 3 proposed rows, the gate is complete, there are no active rows and no lock, and the course is in the search projection.

| Step | Action | Check |
|---|---|---|
| 1 | Before the decision | `security.course_entry_gate_v1('5146f300-3ae9-4380-8cc7-306ad2aa5f4c')->>'complete' = 'true'`; 3 proposed rows; no lock |
| 2 | The Platform Admin approves it: Layer 4 › Inbox › RMIT › Entry requirements › Ready to decide › the card › **Approve all rows**, with a reason | — |
| 3 | After the decision | The item is approved; one `layer4_decisions` row; one `inbox_decide` audit event; 3 `course_entry_requirements` rows active; field item filled |
| 4 | Consumer verification | `public.website_v2_course('course:cricos:00122a:084996m')->'item'->'entry'->>'requirements_note'` is not null. Zoho carries no academic AER (the G3 decision is open). |

### Counts for the execution register (§10)

After release, run `security.aer_progress_counts_v1(<since>, '8e1adb6c-e069-43db-9584-bd054255e702')`.

The same query works before release:

```sql
with dec as (select d.* from pipeline.layer4_decisions d join pipeline.layer4_review_items i on i.id = d.review_item_id join catalogue.courses c on c.id = i.entity_id
              where d.created_at >= :since and i.field_code = 'course_entry_first_read' and c.provider_id = '8e1adb6c-e069-43db-9584-bd054255e702')
select (select count(*) from pipeline.admin_control_events e where e.area = 'layer4' and e.action = 'inbox_decide' and e.created_at >= :since and e.target like 'aer_review:%'
          and e.detail->>'provider_id' = '8e1adb6c-e069-43db-9584-bd054255e702') submitted,
       (select count(*) from dec) saved,
       (select count(*) from catalogue.course_entry_requirements x where x.status = 'active' and x.provenance->>'review_item_id' in (select review_item_id::text from dec)) admitted_rows,
       (select count(distinct x.course_id) from catalogue.course_entry_requirements x join search.course_documents s on s.course_id = x.course_id
         where x.status = 'active' and x.provenance->>'review_item_id' in (select review_item_id::text from dec)) published_courses;
```

## 10. AER technical recovery selector (mandate 16:32 §4–§6)

Production was read only from 17:10 to 17:27 AEDT. The heavy reads ran at 17:16:09 and 17:26:07. No load-window slips.

Branch `cf247-aer-recovery-selector`, commit `6648be5a`, migration `20261104550000` (md5 `60780eb3…`). Spec s282. Fixture `tests/fixtures/aer-recovery-selector`: 31 assertions, which first reproduce the live lane (407 holds parked with no next time).

### What the 16:32 observer measured

The observer's "AER technical correction" (`progress_measure_v1`) counts work items in lane `aer_technical`.

| Measure | 16:32 | 17:02 | What it actually counts |
|---|---|---|---|
| processed | 234 | 234 | Items whose `last_attempt_at` falls in the 24-hour window. These are re-checks of readiness, not corrected reads and not AI spend. |
| created | 0 | 0 | Items recovered |
| eligible | 35 | 65 | Items whose backoff was due again |
| parked | 154 | 151 | 132 / 129 `technical_hold` with no next time, plus 22 duplicates |

### Diagnosis

**`aer_technical_recovery_v1` (lane `aer_technical`, run by `aer-scheduled-read` at :13):**
- It never recovers anything. It reports every technically blocked item as failed, class `technical_hold`, under policy `retry_backoff`, a transient class.
- Each item is re-checked at 10, 20 and 40 minutes, then parked with "attempts used up (3)", no next time and no reason. 94 items were re-checked at 17:13.
- **This treats deterministic holds as transient.**

**The held step (`aer_schedule_held_v1`), the only automatic re-read:**
- It has asked no read since 03:13. The rolling daily cap is full until the 18:13 run.
- When it does run, it allows a second read of an unchanged copy after `aer.schedule_held_retry_days` (14).

**Corrected reads in the last 24 hours:** 82 scheduled. 10 replaced their read; 71 were refused, 69 of them on a copy that had not changed. AI spend was about US$0.006 a read.

### The lane's work items, item by item (17:16)

| Class | Items | Detail |
|---|---|---|
| Row limit | 118 | 104 cut and never re-read; 14 whose corrected read was refused for the row limit on the same copy |
| Unchanged evidence | 27 | Corrected read refused on the same copy |
| Human-assisted, unchanged-evidence repeats | 17 | Refused on the same copy, with an `aer_item` rows request open |
| Human-assisted, shared pages | 26 | 16 with `aer_course_identity` raised |
| Human-assisted, matrix runs | 18 | Held by D-R3 |
| Decisions | 14 | Rows a person leaves out (Approve except); not technical holds |
| Duplicates | 22 | — |
| **Genuinely recoverable** | **33** | Dropped minimums, never re-read, with a stored copy of the same page |

The observer's "eligible" items were re-checks that had fallen due. None of them was work that could succeed.

### Remedy

Six guarded changes:

| Function | Before | After |
|---|---|---|
| `aer_technical_recovery_v1` | `370baa57` | `08322eb5` |
| `aer_schedule_held_v1` | `2a0d51fa` | `c866167b` |
| `aer_e13_recover_v1` | `1bd8be8b` | `a81a54b1` |
| `har_aer_item_generate_v1` | `22cb0e54` | `b25b89a1` |
| `layer4_aer_recovery_detail_v1` (lifecycle-owned) | `dbf06336` | `5d08d39e` |
| `layer4_reread_repeat_v1` (lifecycle-owned) | `80c53ac4` | `19b6d24e` |

- **One shared rule, `aer_recovery_rule_v1`.** It reuses `layer4_reread_repeat_v1` and its change keys. Every hold keeps its class, last attempt, evidence used and current, reader revision, next action, next time or authority blocker, why an identical retry is prohibited, and its intervention.
- **The lane** reports each hold once per condition:
  - Deterministic holds are parked with no attempt counted.
  - Human cases wait for review with their reference.
  - Transient cases keep bounded retries.
  - Recoverable cases are deferred to the scheduled read.
  - A changed copy, reader or entry setting makes a held item eligible again automatically.
- **The held step and the E13 pilot** read only what the rule makes eligible.
- **The generator** raises identity items only. A person's rows would resume the same refused read, because `har_aer_item_resume_v1` re-runs `course_entry_correction_v1` on the same copy.
- **The panel:** a row-limit repeat now recommends the row-limit decision (Platform Admin). It no longer offers Open human input or the same re-read.

### Before and after (fixture on the production-shaped seed)

| | Before (live 16:32) | After |
|---|---|---|
| Holds re-checked per hourly run | about 94 | 0 for unchanged conditions; only items whose condition changed, plus bounded transient retries |
| Holds without a next action | 129 + 22 | 0 |
| Corrected reads refused on an unchanged copy (24 h) | 69 | 0 possible; the held step and the E13 pilot now refuse to select them |
| Successful corrections | 0 counted | 1 end to end in the fixture: held → corrected read → E13 passes → review-ready → approval → active row → published |

### Unattended in production

The 18:13 `aer-scheduled-read` run has room for 20 reads under the cap and will ask 10 corrected reads at most. 9 are eligible under the current code and the new rule alike: all first reads, Auckland University of Technology and University of Auckland.
- The first is AUT Bachelor of Medical Laboratory Science (AK3432), item `aad88dcf`.
- The 24-hour yield has been about 12%, so expect about one replacement.
- Any replacement then needs a human decision before it is admitted.

### Still open

**The 17 open `aer_item` rows requests:** human input on them would resume the same refused read. The resume path needs a version that uses the supplied rows; it is owned by Human-assisted recovery and the lifecycle work.

**Decisions:**
1. The RMIT row limit (118 holds wait on it).
2. `aer.e13_recover_on`.
