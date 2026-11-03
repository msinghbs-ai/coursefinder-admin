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

## Platform Admin decisions (3 November 2026, 20:29 AEDT)
1. **Refused pages with no held page: one needed list.** They move to one "Course page needed" list grouped by university, with add the page, search again, and no page exists. The refused page stays recorded and history is kept. Items where a held page is in dispute stay in Layer 4.
2. **CRICOS page differs: by university.** Checked one university at a time, starting with Adelaide. A proposed rule goes to the Platform Admin for approval. Wording is corrected for non-Australian providers.

## CRICOS-differs check by university (3 November 2026, 20:40 AEDT)
Read-only. Exact address patterns counted live; stored copies sampled through the existing evidence route. Samples are small, so any rule must be validated across its whole group first.

| University | Pattern | Exact matches | Stored sample | Result |
|---|---|---|---|---|
| Adelaide University | `adelaide.edu.au` to `adelaideuni.edu.au`, same path | 207 of 219 | 2 pairs | Proposed copy is the domestic view, shows no course CRICOS code, and its canonical is the held address. Held copy is the international view and shows the course's CRICOS code. The held page is better. |
| University of Canberra | Held ends `/2027`, proposed has no year | 100 of 104 | 2 proposed copies | Proposed copy's canonical is the address without a year, and it states the 2027 details. It will not date. |
| Simon Fraser | Held has a term (mostly Fall 2026), proposed has none | 59 of 105 | 2 proposed copies | Proposed copy shows the current Spring 2027 calendar. It will not date. The other 46 need separate review. |

The item reason says the proposed page shows the CRICOS code. In the Adelaide samples it does not, and Simon Fraser has no CRICOS code. The reason text is unreliable for these groups.

## Platform Admin rule decisions (3 November 2026, after 20:40 AEDT)
| University | Items | Rule |
|---|---|---|
| Adelaide University | 207 | Keep the held adelaide.edu.au page; stop raising this pattern |
| University of Canberra | 100 | Use the address with no year |
| Simon Fraser | 59 | Use the address with no term; the other 46 stay for separate review |

Carried out by the integrator as logged rules under Decision 263, after validating each whole group. Items that do not pass stay in Layer 4. Up to 159 Firecrawl credits approved for the re-reads.
