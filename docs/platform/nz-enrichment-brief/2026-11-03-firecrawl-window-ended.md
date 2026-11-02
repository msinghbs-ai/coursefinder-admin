# Firecrawl unlimited window — ended and normal limits restored

**Date:** 3 November 2026, 01:35 AEDT (Integration Controller)
**Authority:** Platform Admin 2 Nov 16:39 (temporary Firecrawl authority, to credit expiry); direction 2 Nov 23:24 §1 and §4 ("revert to normal approved limits and verify the actual settings"); mandate 3 Nov 00:03 §7 ("Respect normal budgets after temporary authorisation expires").

## What was done

Ended early (before the vendor period rolls at 02:57 AEDT) so no uncapped spend carries into the new billing period. Each setting was restored only where it still held the window value. Audit: `pipeline.admin_control_events` #28683 (`firecrawl_unlimited_window_ended`), reversing #28625, #28629, #28631, #28658, #28668.

| Setting | Window | Restored |
|---|---|---|
| firecrawl.daily_budget_on | false | **true** |
| firecrawl.target_only | false | true |
| firecrawl.central_refresh_days | 1 | 30 |
| firecrawl.find_retry_refused | true | false |
| firecrawl.search_stop_after | 1000 | 30 |
| firecrawl.autobuild_per_day | 200 | 25 |
| firecrawl.ondemand_credits_per_day | 20000 | 2000 |
| firecrawl.find_credits_per_run / read_credits_per_run | 500000 | 15000 |
| firecrawl.read_statuses | + "read" | needs_render, blocked, fetch_failed |
| firecrawl.scholarship_cap_per_uni | 5000 | 150 |
| firecrawl.scholarship_min_courses | 0 | 30 |
| firecrawl.map_limit_scholarships | 100000 | 5000 |
| firecrawl.search_results_scholarship_discover / _search | 20 / 20 | 6 / 5 |
| pipeline.batch.central_find / coverage_find_site / course_link_search_queue | 50 / 50 / 200 | 4 / 5 / 20 |
| scholarship_layer_settings.firecrawl_cap | 100000 | 60000 |
| firecrawl.run_concurrency | (12 already) | 12 |

Jobs `coverage-discover` and `coverage-discover-2` paused again (as before the window). `coverage-read` / `coverage-read-2` stay active (active before the window). No Firecrawl run was still running (last re-read run fd98d679 finished `done` 2 Nov 14:30 UTC).

## Live verification (01:36 AEDT, read back)

- daily_budget_on true; target_only true; per-run credits 15000; read_statuses three values; scholarship_min_courses 30; scholarship firecrawl_cap 60000.
- coverage-discover, coverage-discover-2 inactive; 0 runs with status `running`.

## Note on the release branch

Branch `cf247-firecrawl-window-restore` (migration `20261103000500`) was prepared as the release route, but its full suite was cut off by the 90-minute background limit (971/1498, 0 failures) under host load. The same restore was applied directly through the governed settings path with the audit event above. The migration is now a no-op against live and is **not** being shipped (shipping it would only add a duplicate event). The branch stays unmerged for reference; no PR opened.

## Spend in the window (2 Nov 16:39 → 3 Nov 01:35)

Vendor balance read at 23:15 AEDT: 294,481 credits left. The re-read run fd98d679 continued at concurrency 6 until 01:30 AEDT, so the final window total is to be taken from the vendor usage page rather than estimated here. The remainder of the grant lapses at 02:57 unused, as directed ("Do not increase concurrency merely to consume expiring Firecrawl credits"). AI spend in the window about US$0.3.

## Window report (scheduled restore check, 3 Nov 03:21 AEDT)

The scheduled restore task fired after expiry. Re-read at that time: nothing left to restore. `coverage-read` / `coverage-read-2` were **active** before the window (event #28625 `jobs_before`), so they correctly stay active; `pdesc.firecrawl_reads_max` is 20 (never raised).

Firecrawl runs started under the authority (`pipeline.firecrawl_runs`):

| Run | Use | Status | Items | Outcomes | Credits |
|---|---|---|---:|---|---:|
| f3333324 | find course pages on provider sites | done 2 Nov 18:19 | 8,632 | 3,389 found on the provider site; 3,932 site but no title match; 1,105 no results; 206 already refused | 15,054 |
| f933a2da | read pages (first attempt, concurrency 24) | stopped 16:54 | 244 | 9 course pages, 168 other pages, 65 not found | 305 |
| fd98d679 | re-read held course pages | done 3 Nov 01:30 | 14,056 | 13,042 course pages read; 864 other page; 52 not found; 41 blocked; 35 thin; 22 errors or time-outs | 14,128 |
| **Total in runs** | | | **22,932** | | **29,487** |

Scheduled jobs (scholarship discovery and listing reads, central finds, on-demand) also spent credits during the window outside these runs; the vendor usage page gives the full total.

Job failures during the window: admission and search-refresh time-outs 17:05–17:46 while concurrency was 50. Concurrency was cut to 24 then 12, and the re-read was paused 17:49–19:45; recovered by 18:56 (see the 2 Nov progress records). One hidden time-out of `search-refresh-requested` at 23:36 is logged as IQ-00044.

## UNSW scholarship recovery restore (3 Nov 03:42 AEDT, event #28686)

- `scholarship_layer_settings.firecrawl_cap` already 60000 (#28683).
- UNSW discovery row: website and site origin set back from `https://www.scholarships.unsw.edu.au` to `https://www.unsw.edu.au` (the before value in #28668). Its mapped status and the 72 scholarship pages already found are kept, and the 5 UNSW listing sources stay active. Branch `cf247-scholarship-recovery` (F4) maps every recorded source for a provider, so the scholarships sub-site is covered by its listing sources rather than by swapping the website.
