# AER held items: what the live system shows (18 Nov 2026)

**Session:** S2-BOOST-AER. **Read:** live project `fxcwkweaxjtknorudmwp`, read-only, 18 Nov 2026 17:15 to 17:50 AEDT.
**Status:** findings only. Nothing was changed in the database, the worker or the admission rules. AER v1 stays frozen (Decision 276).
**Why this exists:** three directives of 18 Nov (16:56, 17:02, 17:04 AEDT) set out to clear the "1,874 shared-page" AER course items, the 83 held provider matrices and about 1,620 incomplete reads. The live figures change what each of those can deliver, so they are recorded here before any rule is built.

## 1. Course entry items waiting in Layer 4 (2,578)

Latest machine-rule outcome per waiting item (`pipeline.aer_machine_admissions`, rule `aer-machine-v1`):

| Why the machine rule declined | Items |
|---|---|
| The reader dropped a printed requirement that no waiting row covers (incomplete read) | 1,541 |
| The same, and rows were also cut at the row limit | 76 |
| 5% audit sample (always a person's) | 491 |
| Stored page is also the page of another programme (alone) | 175 |
| Shared page and a dropped requirement | 44 |
| Shared page and rows cut (with or without a drop) | 11 |
| Every waiting row fails a row rule | 102 |
| No bound course page now | 37 |
| Identity basis not admitted | 18 |
| Rows cut at the limit only | 3 |

- **"1,874 shared page" is not the shared-page count.** The shared-page class is **230 items on 161 pages at 79 providers**; 209 of them share with exactly one other programme. The larger figure is mostly incomplete reads, as `docs/CURRENT-STATE.md` already noted at 14:22 (237 on 172 pages).
- **About 1,620 items need a corrected read**, which needs a qualified AER model. The AER v1 routes are recorded as off with no qualified model (`docs/CURRENT-STATE.md`, 16 to 18 Nov); the route switches were not re-read live in this session.

## 2. The 230 shared-page items are not faculty or handbook pages

Every pair (the held course and each other programme bound to the same address) was listed with its identity basis and binding status. They fall into these kinds:

| Kind | Example | What it means |
|---|---|---|
| Qualification ladder on one page | Diploma and Advanced Diploma of Business; Graduate Certificate and Master of Public Administration; Associate Degree and Bachelor of Music; a degree and its Honours year | Two different qualifications, both bound by CRICOS code. Their requirements differ by level. A person or a per-qualification read decides. This is the largest kind. |
| Major or stream siblings | Bachelor of Science (Biology) (Honours) with eight other majors; Doctor of Philosophy by faculty group | One award, several registered streams on one page. |
| Pace or duration twins | (Standard) and (Accelerated); (Extended); 34 weeks and 52 weeks; 1 year and 2 years | The same qualification registered twice. 41 items. See section 3. |
| The other binding was already refused | Certificate IV in Baking (bound by hand) with Certificate III in Baking (status `mismatch`) | The identity check has already refused the other course. The item is still held because the course's own basis is `manual`, which is not in `entry.shared_page_own_bases`, or it carries a hand lock. Roughly 15 items. |

A heading, anchor or tab splitter separates very few of these: the pages are a course's own page, not a page with one section per course.

## 3. Pace and duration twins cannot be passed automatically

The directive of 17:04 asked for variant twins to pass automatically. A twin rule was written as a read-only query and run against live before anything was built:

- A pair is a twin when the two titles are equal once pace and duration marks are removed (standard, accelerated, extended, full year, semester, band 1, band 2, and a printed number of weeks or years), and both are bound on a strong identity basis.
- Two row guards: no waiting row names a pace mark, and no two waiting minimum-grade rows for the same audience and country carry different minimums.

| Of the 41 twin items | Items |
|---|---|
| A waiting row names a pace mark (the page prints a requirement for one variant) | 6 |
| Two waiting rows carry different minimums (the page prints two requirements) | 14 |
| Pass both guards | 23 (22 with no other hold) |

- **Half of the twin pages demonstrably print a different requirement for each variant.** That is the reason the shared-page hold exists.
- **The guards are not enough for the other half.** In several pairs one twin's read shows the conflict and the other twin's read of the same page does not (for example Graduate Certificate in Technology Practice, Standard and Accelerated). The page is the same; the second read simply captured one value. The 23 also include pairs whose requirements differ by nature (a 1-year and a 2-year Master of Project Management; Extended and Standard foundation programmes).
- **Result:** an automatic twin pass would put the wrong entry requirement on live courses that API v3 reads, for at most 22 of 2,578 items. It was not built.

**What would be correct for twins:** a read that is told which variant it is reading for and returns the variant with each row (an AER v2 record field), so a row is admitted only to the variant the page names. That depends on a qualified AER v2 model (section 5).

**What is safe and deterministic now:** treating a binding the identity check refused (`mismatch`) as no claim on the page for a course bound by hand, as it already is for courses bound by code or exact title (rule of 8 Nov 2026). It needs the reason for the hand-lock exception in that rule confirmed first. Yield about 15 items.

## 4. Provider matrices (83 items, 3,302 proposed rows, 60 providers)

All 83 runs were read by `openai/gpt-4.1-mini` (63 fetched directly, 20 through Firecrawl).

| Finding | Figure |
|---|---|
| Completeness check answered "not applicable" (no table with an "Australian standard" column, or the stored copy is a PDF) | 82 of 83 runs |
| Completeness check answered "incomplete" (columns left out) | 1 run |
| Rows with no mapped study level | 1,191 |
| of which the read carried no level at all | 893 rows, 22 providers |
| of which the label is a school-year equivalence ("Year 12 equivalent", "Year 10 equivalent" and the like) | about 195 rows |
| Rows with neither a grade nor a value | 997 |
| of which the row is a completion requirement with no score ("Successful completion of …") | most |
| Rows with a grade in words and no number (letter grades, "3 passes", "'B' average") | about 500 |

Rows the reader dropped (448 across the runs): quote not on the page 183, unknown country 90, grade not in the quote 69, band not in the quote 31, value without a scale 17, low confidence 16, quote too short 16, other 26.

What this means for a parser:
- **The level is usually printed in the table, not missing.** For the 893 rows it sits in a column heading or the heading over the table; a deterministic reader can carry it when exactly one level is named there, using the platform's own study-level list.
- **"Year 12 equivalent" is not a study level.** It says what the overseas qualification equals. It belongs in the row's conditions, and such a table is an equivalence table, not a course-level matrix.
- **A completion requirement has no minimum to find.** "No minimum" is the correct reading of those rows; the machine rule should class them, not treat them as a parsing failure.
- **Showing a read complete** for tables without an "Australian standard" column needs a manifest for the general country-by-level table shape, and the PDF grid reader's cell list for PDFs.

## 5. What each directive item can deliver

| Item | Waiting | Realistic yield | Depends on |
|---|---|---|---|
| Shared-page twins and bindings (s670) | 230 | about 15 by a deterministic rule; twins and ladders need a variant-aware read | Section 3 |
| Provider matrices (s671) | 83 items, 3,302 rows | Largest deterministic gain: level from the table, equivalence and completion classes, a general completeness manifest | A migration to `security.aer_matrix_machine_check_v1`, replaced in place |
| Incomplete reads (s672) | about 1,620 | The largest block of courses | A model passing the AER v2 qualification gate; a pass never switches the route on by itself |

Nothing in this document changes a threshold, a rule or a switch.
