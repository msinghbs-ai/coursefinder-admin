# Process record: Course Link reconciliation (Decision 179)

**What it does:** for one university at a time, `security.course_link_reconcile_v1(provider, limit, apply)` classifies each waiting Course Link review item (`field_code official_course_url`). Items with no usable course page move to the Course page needed queue (Decision 179, `security.course_page_needed_convert_v1`); superseded items are closed with a reversible supersession; the rest stay in Layer 4 with their class and reason. Count first (apply false), then apply. Audited in `pipeline.admin_control_events`.

**What it does not do:** it does not prove a course page belongs to its course (E16). The 751 top-10 intake rows skipped for E16 (see `intake-dates.md`) are unblocked only when a proved page is bound, through the Course page needed queue or the binding rules.

**Authority:** Decision 179; resumed by the Platform Admin 5 Nov 2026 ~09:05 ("Resume now", UNSW last).

## Runs

| When (AEDT) | University | Examined | Moved to Course page needed | Kept in Layer 4 (reason) | Other classes (stay in Layer 4) |
|---|---|---|---|---|---|
| 4 Nov 18:26 | Victoria University | 89 | 89 | 0 | |
| 4 Nov 18:56 | Swinburne | 85 | 85 | 0 | |
| 4 Nov 18:56 | UTS | 89 | 87 | 2 (held page when raised) | |
| 4 Nov 19:26 | Victoria University of Wellington | 76 | 73 | 3 (held page) | |
| 4 Nov 19:26 | NorthTec | 72 | 70 | 2 | |
| 4 Nov 19:26 | Eastern Institute of Technology | 66 | 64 | 2 | |
| 4 Nov 19:26 | UCOL | 63 | 63 | 0 | |
| 5 Nov 09:05 | Adelaide University | 205 | 164 | 5 (held page when raised) | rule_d263_fail 34, held_page_dispute 5, manual_binding 2 |
| 5 Nov 09:05 | University of Melbourne | 72 | 32 | 7 (held page when raised) | old_year_address 27, active_page_refused 7, e16_unclear 5, cricos_page_differs 1 |
| 5 Nov 09:05 | RMIT | 71 | 60 | 11 (held page when raised) | evidence_not_linked 10, evidence_missing 1 |
| 5 Nov 09:05 | University of Sydney | 48 | 26 | 2 (held page now 1, when raised 1) | old_year_address 19, others 3 |
| 5 Nov 09:05 | Flinders | 39 | 25 | 11 (held page now 2, when raised 9) | active_page_refused 5, others 9 |
| 5 Nov 09:05 | Monash | 34 | 30 | 1 (held page when raised) | cricos_page_differs 3, evidence_missing 1 |

**Totals:** 868 moved across 13 universities. Course Link pending: 2,958 (4 Nov 17:08) → 2,427 (4 Nov 19:27) → 2,092 (5 Nov 09:06).

## Missed, and why

- **Kept in Layer 4 (held page):** the course held a page when the item was raised, or holds one now. Decision 179 does not move these; a person decides.
- **old_year_address, active_page_refused, cricos_page_differs, e16_unclear, held_page_dispute, rule_d263_fail:** not a Decision 179 case; they stay in Layer 4 with their class.
- **evidence_not_linked / evidence_missing:** the stored copy is not linked; the item stays waiting.

## Next revisit

Remaining universities in order of waiting items, UNSW last, in the next allowed database windows. Items raised after a run are picked up when the university is run again.
