# Course link growth review (3 November 2026, 19:45 AEDT)

Read-only review. No items, settings or data changed. No credits used.

## Answer
The rise is by design, not a fault. Since the E16 binding check went live, each page it refuses raises a course-link item for a person. Items arrive far faster than they are closed.

| Measure | Figure |
|---|---|
| Pending `official_course_url` items | 3,179 (one per course, no duplicates) |
| Raised 2 Nov / 3 Nov to 19:42 | 2,404 / 759 |
| Raised and still pending, last 24 hours | about 1,010 |
| Closed, of those raised since 1 Nov | 18 |
| Same proposal raised again after a decision | 2 |
| Active courses with no link and no pending item | 9,545 of 11,758 with no link |

The Course link pill shows 3,320 because it also holds 141 other items (fee checks and similar).

## What the items are
| Type | Pending | Last 24 h | Last 3 h | Held page |
|---|---|---|---|---|
| Binding refusal | 2,479 | 659 | 200 | 227 have one |
| CRICOS page differs from held page | 502 | 351 | 1 | All |
| Old year in the address | 188 | 0 | 0 | All |
| Other | 10 | 0 | 0 | — |

## Findings
1. **Refusals are doing their job.** Of 12 random samples, about 9 are clearly wrong pages (a flyer PDF, a different award, a different level). About 3 could be the course's own page, such as Master of Arts Greek and Roman Studies, so the check should not be loosened without testing.
2. **Most items ask a person to confirm a correct refusal.** 2,252 of the 2,479 have no held page. Nothing is at risk, because the page is already refused and recorded in `pipeline.page_rejections`. What the course really needs is a correct page.
3. **886 of the 2,479 proposed pages (36%) are already the official page of another course.** Sibling is the largest group: 391 of 627.
4. **The next wave could be large.** 9,545 courses could still raise an item as search reaches them. Not all will, because some will bind correctly or find nothing. E16 routes one item per course, so the realistic ceiling is thousands more.
5. **CRICOS items are concentrated.** Adelaide University 219, Simon Fraser 105, University of Canberra 104: 428 of 502 (85%). Most of the 24-hour rise here came in short bursts and has stopped for now. Simon Fraser is Canadian, so the wording about a CRICOS code is wrong for it. Adelaide's new domain may be a cause, but this has not been tested.
6. **This is not a defect in approval.** The E16 direction of 2 Nov 07:21 says to route unproved cases to Layer 4 and not to bypass approval just to clear the queue. Any change to routing needs a Platform Admin decision.
7. **Decision 179 already describes the better shape:** one "Course page needed" queue where an operator adds the link, sends it for another search, or marks no page exists.

Credit spend by these search lanes was not measured here.

## Recommendation
Keep the check. Change what reaches a person:
- A refused page with no held page stays refused and recorded, and raises no item of its own. Nothing is admitted by this.
- The course joins one "Course page needed" list, grouped by university, with honest choices (add the page, search again, no page exists). The 2,252 existing items convert to it, keeping their history.
- Items stay in Layer 4 when a held page is in dispute (227 plus the CRICOS and old-year groups).
- CRICOS items for the three large universities are checked as one rule per university. Automatic rules still follow Decision 263.
