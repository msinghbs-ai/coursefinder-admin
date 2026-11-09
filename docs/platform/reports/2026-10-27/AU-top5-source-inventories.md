# Top five AU universities: source inventories

Prepared 27 Oct 2026 from the live CourseFinder database (read-only queries). Per-field states from `pipeline.course_attribute_coverage` (built 26 Oct 2026 19:47 UTC). Workbook: `AU-top5-source-inventories.xlsx` (Read me, Providers, Ranked actions, one sheet per university, Sources).

## Summary table

| | Sydney | UNSW | Macquarie | ANU | Melbourne | All five |
|---|---|---|---|---|---|---|
| Active courses (denominator) | 655 | 667 | 461 | 423 | 441 | 2647 |
| Advertised: official page in place | 402 (61%) | 467 (70%) | 272 (59%) | 421 (100%) | 386 (88%) | 1948 (74%) |
| Not advertised / no usable page | 253 (39%) | 200 (30%) | 189 (41%) | 2 (0%) | 55 (12%) | 699 (26%) |
| of which: page needs a rendered read | 62 (9%) | 0 (0%) | 0 (0%) | 0 (0%) | 13 (3%) | 75 (3%) |
| of which: page address no longer works | 155 (24%) | 84 (13%) | 138 (30%) | 0 (0%) | 2 (0%) | 379 (14%) |
| of which: held, page is for another course | 21 (3%) | 79 (12%) | 35 (8%) | 2 (0%) | 33 (7%) | 170 (6%) |
| of which: no-page record (conjoint/no page) | 7 (1%) | 26 (4%) | 14 (3%) | 0 (0%) | 5 (1%) | 52 (2%) |
| Re-link finished with no page | 202 (31%) | 131 (20%) | 68 (15%) | 2 (0%) | 45 (10%) | 448 (17%) |
| International fee admitted | 0 (0%) | 298 (45%) | 0 (0%) | 365 (86%) | 323 (73%) | 986 (37%) |
| English filled | 613 (94%) | 431 (65%) | 371 (80%) | 400 (95%) | 281 (64%) | 2096 (79%) |
|   from central policy | 608 (93%) | 422 (63%) | 112 (24%) | 400 (95%) | 124 (28%) | 1666 (63%) |
|   page disagrees with central | 3 (0%) | 7 (1%) | 46 (10%) | 0 (0%) | 0 (0%) | 56 (2%) |
| Intakes filled | 70 (11%) | 465 (70%) | 93 (20%) | 21 (5%) | 182 (41%) | 831 (31%) |
| Undergraduate with page, calendar intakes withdrawn 22 Oct | 91 (14%) | 4 (1%) | 0 (0%) | 0 (0%) | 16 (4%) | 111 (4%) |
| Delivery mode filled | 374 (57%) | 470 (70%) | 111 (24%) | 401 (95%) | 383 (87%) | 1739 (66%) |
| Delivery taken back 23 Oct | 147 (22%) | 66 (10%) | 34 (7%) | 4 (1%) | 34 (8%) | 285 (11%) |
Percentages are shares of each university's active courses. A high "missing" count is not a failure rate: compare the recoverable share in "Ranked actions".

## Per university

### The University of Sydney (655 active)
- **Pages:** 402 advertised (official page in place). 253 not: 155 page addresses return 404 (mostly guessed from the address pattern), 62 pages need a rendered read, 21 held as another course's page, 7 no-page records, 3 read but not admitted, 5 with no page. Re-link has finished with no page for 202.
- **Tuition:** 0 admitted. The fee page (sydney.edu.au, HTML, 2026) gives "no values": 41 table rows, no course codes. The 26 Oct fee reader read 41 rows but could not find their quotes on the page. Matching would have to be by title, and courses carry no faculty, so the number of matches can't be counted yet.
- **Intakes:** 70 filled. Approved calendar: Feb and Aug, from an own-domain page with dated quotes ("Semester 1 | 23 February 2026"). 91 undergraduate courses with a page lost their calendar intakes on 22 Oct ("Page-only months"). 246 postgraduate or research courses with a page are also outside the 19 Oct "Undergraduate only" rule.
- **English:** 613 filled, 608 of them from the central policy (IELTS 6.5, no band below 6.0). The policy covers undergraduate, postgraduate and research. 42 held (non-award, diploma, double degrees). 3 course pages disagree with the central rule.
- **Delivery:** 374 filled. 147 values were taken back on 23 Oct, and most of those courses now have a dead (404) or unrendered page.
- **Entry requirements:** no source registered.
- **Top actions:** (1) calendar months for postgraduate courses, 246 (Platform Admin: reverse 19 Oct and make an exception to 22 Oct); (2) calendar months for undergraduates, 91 (Platform Admin: exception to 22 Oct); (3) rendered re-read of 62 bound pages (Platform Admin starts "Read pages again", then the checks run automatically); (4) English rule for held course types, 42 (Platform Admin).

### UNSW Sydney (667 active)
- **Pages:** 467 advertised. 200 not: 84 handbook addresses return 404, 79 held as another course's page, 26 no-page records (21 conjoint), 10 with no page, 1 read but not admitted. Re-link has finished with no page for 131.
- **Tuition:** 298 admitted, all from course pages (adapter 279, page reader 19). The fee page (HTML, 2026) gives "no values": 327 table rows, no CRICOS codes. The fee reader found no rows. Match count can't be determined.
- **Intakes:** 465 filled (448 from the adapter). The calendar was set by hand from UNSW's own academic calendar: Term 1 Feb, Term 2 Jun (default months skip Term 3, Sep). The other approved calendars are UNSW College (a satellite page) and a "Term 1 March 2023" line. 4 undergraduate courses lost their intakes on 22 Oct.
- **English (quality risk):** 431 filled, 422 of them from the central policy. The approved source is the **UNSW Bengaluru (India campus) page**, IELTS 6.0 (5.5 each), approved 2 Oct with no decision note. On 17 Oct the Platform Admin rejected a later reading of the same page as "not the Sydney policy", but the 2 Oct approval still stands. 7 course pages disagree. 236 courses have no English (173 research degrees, which the source gives no default for). This needs a Platform Admin decision; it is not ranked as a recovery.
- **Delivery:** 470 filled. 66 values taken back on 23 Oct.
- **Top actions:** small ones only: 4 undergraduate calendar courses (Platform Admin), 3 stuck Layer 3 items, 1 Layer 4 review. The main item is the English source decision above.

### Macquarie University (461 active)
- **Pages:** 272 advertised. 189 not: 138 coursehandbook 2026 addresses return 404, 35 held, 14 no-page records, 1 read but not admitted, 1 with no page. Re-link has finished with no page for 68.
- **Tuition:** 0 admitted. The three central fee pages give no values and have no table, so there is no matching key. 271 course pages don't state a fee.
- **Intakes:** 93 filled. The only approved "calendar" is the English language programs block dates, so there are no default months.
- **English:** 371 filled: 112 from the central policy (UG/PG 6.5 from the HTML page; research 6.5 from a PDF schedule), 157 from the adapter or page reader. 46 course pages disagree with the central rule. 90 held, 76 of them double degrees.
- **Delivery:** 111 filled. 350 not stated: 162 on a page that was read, the rest on dead or wrong pages.
- **Top actions:** English rule for held course types, 90 (Platform Admin); Layer 4 review, 2.

### Australian National University (423 active)
- **Pages:** 421 advertised (2 held).
- **Tuition:** 365 admitted from course pages (adapter 351). The central fee pages give no values.
- **Intakes:** 21 filled. No calendar is approved (all three pages gave no values). 349 course pages don't state intakes. 51 are waiting for checks: 18 values being checked, 19 in Layer 4 review, 14 stuck in the retired Layer 3.
- **English:** 400 filled from the central policy (Decision 264: UG/PG/research 6.5, plus 4 named exceptions). 23 held (20 diploma or non-award).
- **Delivery:** 401 filled. 22 not stated (20 on a page that was read, 2 on a held page).
- **Top actions:** Layer 4 review of values already read from course pages, 45; English rule for held course types, 22 (Platform Admin); re-route 14 stuck Layer 3 items (Layer 4).

### The University of Melbourne (441 active)
- **Pages:** 386 advertised. 55 not: 33 held, 13 handbook pages need a rendered read, 5 no-page records, 2 dead addresses, 2 with no page. Separately, 29 courses that already have a page also have a bound handbook page waiting for a rendered read (42 in all).
- **Tuition:** 323 admitted. The approved 2027 international fee table (own-domain PDF, already parsed, 838 rows) is keyed by CRICOS code. 291 courses match it and 288 of those have a fee, so only 3 remain. The 2027 graduate table address now returns 404.
- **Intakes:** 182 filled. The calendar was set by hand from unimelb.edu.au semester dates: Mar and Jul. The other approved calendars are the Ormond and Trinity college pages (satellite). 16 undergraduate courses lost their intakes on 22 Oct. 188 postgraduate or research courses with a page are outside the 19 Oct rule.
- **English:** 281 filled (124 central, 149 adapter or page). The level map (Decision 265) last applied 0 new rows. 160 have no English; the per-course reasons weren't re-planned for this report.
- **Delivery:** 383 filled. 34 values taken back on 23 Oct.
- **Top actions:** calendar months for postgraduate courses, 188 (Platform Admin, 2 rules); rendered re-read, 42 (Platform Admin starts the job); Layer 4 review, 24; undergraduate calendar months, 16 (Platform Admin); fee-table courses with no fee, 3 (Layer 4).

## Not recoverable through an existing lane
- 549 page addresses are dead or belong to another course. Re-link has finished for most of them ("no address from the university's address forms" or "every candidate address was refused"). These are effectively register-only.
- 52 no-page records are waiting for review (no-page trust is still "first run", sample 0). Confirming them only cleans up the denominator.

## What could not be determined
- Whether a course is on the university's own course list. The course-list reader stores page counts only, not which course each address belongs to.
- When intake rows were written or withdrawn (`catalogue.course_intakes` has no timestamps).
- How many courses the Sydney and UNSW fee pages would match by title. The fee rows weren't kept, and the stored page text isn't reachable by SQL.
- Per-course reasons for Melbourne English (that level-map plan wasn't run here).
- Why the 3 Melbourne fee-table courses were skipped, and which admission step "Value found, being checked" items are waiting on.
- An HTML or PDF split for entry-requirements sources: none are registered for any of the five.
