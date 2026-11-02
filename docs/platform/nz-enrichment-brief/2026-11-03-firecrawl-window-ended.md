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

About 5,500 credits used from the 300k grant at the 23:15 reading (294,481 left); the rest of the grant lapses at 02:57 unused, as directed ("Do not increase concurrency merely to consume expiring Firecrawl credits"). AI spend in the window about US$0.3.
