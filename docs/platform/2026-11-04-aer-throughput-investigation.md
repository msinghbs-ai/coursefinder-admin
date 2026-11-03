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
