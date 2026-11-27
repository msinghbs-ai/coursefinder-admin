# IQ-00615 Consumer Search Performance (s1305)

S1-API-Frontend-Delivery, 27 Nov 2026, from SS-Programme-Control's 12:08 AEDT assignment. Pilot migration `20261130140000` (renumbered from s1302 and 20261130130000: S1-Data-Gaps took both first), spec `cf-247-s1305-consumer-search-trigram-contract`.

## Finding
The `search_master_page2` failure was not a probe timeout, pagination or ordering fault. It was a symptom of slow consumer free-text search.

| Question | Answer, measured on the live database |
|---|---|
| Is the probe the cause? | No. `security.consumer_api_snapshot_v1` runs its reads in one loop under one 6,000 ms budget (`admit.consumer_snapshot_budget_ms`), cheap reads first and the two free-text searches last. When `search_bachelor_au` takes 3.4 to 7.7 s, the next read, `search_master_page2`, starts after the budget and is skipped. In the last 14 recorded runs, the slow "before" runs skipped it every time and the faster "after" runs ran it (1.3 to 2.1 s). |
| Is pagination the cause? | No. Page 2 of `master` returned the same 7,157 bytes (md5 `1d6d5fcd`) in every run that executed it. Page 2 is not dearer than page 1 once the cache is warm. |
| Is it consumer-visible? | Yes. `pipeline.api_requests`, 7 days: website v2 search p50 3.7 s, p95 10.0 s, max 26.4 s (992 calls); website v3 search p50 4.6 s, p95 17.3 s, 25 server errors (520 calls); Zoho v2 search p95 11.2 s (33 calls). |
| What is slow? | The frozen `api.zoho_course_search_v2` (behind `zoho_edge_course_search_v2`, `zoho_v2_course_search`, `website_v2_course_search`, `website_v3_course_search_core`) matches text as `search_tsv @@ q OR course_title ILIKE '%q%' OR provider_name ILIKE '%q%' OR lower(course_code) = q OR lower(course_stable_key) = q`. The two ILIKE arms had no index, so the planner read every Australian row of `search.course_documents` (24 to 26 thousand rows, 10.6 thousand heap blocks, 56 thousand buffer hits for one count) and detoasted `search_tsv` on each. |
| Why is it worse cold? | The live heap is 115 MB against 62 MB compact (46% dead space; about 9.0 million updates and 1.1 million deletes since the table was built), so a cold cache reads far more. |
| Result correctness | Unchanged. Count and md5 of the matching course keys were equal before and after for bachelor (5,627), master (4,508), engineering (2,357) and nursing (360). The probe's page-2 md5 `1d6d5fcd` and the bachelor page md5 `8d633cd8` were equal on the live function before and in the rehearsal after. |

## Fix (G3 kept)
Migration `20261130140000`: GIN trigram indexes `course_documents_title_trgm_idx` (course_title, 5.1 MB) and `course_documents_provider_name_trgm_idx` (provider_name, 3.6 MB) on `search.course_documents`, a fresh ANALYZE, and one recovery knowledge row. The other three arms already had indexes. No function, column, grant or result changes; the consumer API check (75 functions, 48 relations, no drift) runs before and after inside the migration, and `s57` is untouched (index-only; precedent `course_documents_title_lower_idx`). The probe, its budget and its acceptance check are unchanged: nothing was raised, reordered or weakened. S1-Build is informed because the same table serves the v2 reads they own.

## Measured before and after
Same expressions, same inputs, 5 rows a page, Australia. Before is live now (warm); after is the rolled-back rehearsal (the migration run inside the live transaction, then the real functions timed).

| Read | Before | After | Same result |
|---|---|---|---|
| Zoho `bachelor`, page 1 | 2,306 ms | 678 ms | yes |
| Zoho `master`, page 2 (the probe case) | 1,733 ms | 596 ms | yes |
| Website v2 `master` (keyword) | 1,785 ms | 555 ms | yes |
| Cold, recorded before-runs (`bachelor`) | 3.4 to 7.7 s | see production read-back | |

Predicate alone on a copy of the live table (cold, Australia): bachelor 671 to 123 ms, master 674 to 101 ms, engineering 596 to 46 ms, nursing 748 to 10 ms, no match 544 to 0.4 ms.

The remaining 550 to 680 ms is in the frozen function itself (the blocked-course set, about 143 ms a call, then counting and paging). Reducing it further needs a change to a frozen function and the Platform Admin's approval; it is not needed for the check and is not part of this change.

## Recurrence-prevention lesson
Recorded in the recovery knowledge as `consumer_search:unindexed_free_text:latency` (authority release, not automatic):
1. A probe skipped on its time budget is a latency finding on the read before it. Read that read first.
2. Never raise the budget or statement timeout, reorder the reads or count a skip as a pass; that hides what consumers see.
3. Any consumer search that ORs `ILIKE '%q%'` arms, or other expressions, over `search.course_documents` needs a trigram or expression index for each arm. Read EXPLAIN with Buffers on the real predicate.
4. The earlier fix (s720: smaller pages and a time budget) made the evidence bounded but did not touch the cause; the issue regressed three times.
5. `search.course_documents` is rewritten heavily and carries 46% dead space; keep its autovacuum running and watch its heap against the compact size.
