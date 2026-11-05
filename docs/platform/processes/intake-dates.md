# Process record: intake dates (start date, year, application deadline)

**Mandate:** process record mandate, Platform Admin 5 Nov 2026 08:42 (`../2026-11-05-process-record-mandate-0842.md`).
**Scope of this record:** the top 10 Australian universities by active courses (setting `run_now.cohort_top_au_universities`).
**Measured:** 5 Nov 2026, 08:43–08:57 AEDT, read-only on production (release v2.15.479). Hand-written for this first issue; to be generated (see "Keeping this current").

## 1. What the process is

| Step | Component | Schedule | What it needs |
|---|---|---|---|
| 1 Intake months | University adapters read stored course pages | Adapter read cycle | A course page bound to the course |
| 2 Calendar | Approved central key-dates page (`pipeline.provider_policy_proposals`, kind `intake_calendar`) read into dated periods (`security.calendar_dated_periods_v1`) | When a calendar is approved | The university's own teaching calendar |
| 3 Dates | Job `intake-dates-apply` → `security.intake_dates_apply_v1` (plan `intake_dates_plan_v2`) | Hourly at :26, 200 intakes per run, whole platform (`batch.intake_dates_apply`) | Step 1 + Step 2 + the course page names the study period (rule of 2 Nov) + page identity (E16) |
| 4 Admission | Job `coverage-admit-intakes` | Every 10 minutes | Step 3 result |

## 2. Result (top 10 universities)

| University | Active courses | Courses with intake months | Intake rows | With start date | With deadline | With year |
|---|---|---|---|---|---|---|
| UNSW Sydney | 667 | 467 | 1,310 | 0 | 0 | 626 |
| The University of Sydney | 655 | 77 | 173 | 0 | 0 | |
| Monash University | 582 | 330 | 607 | 0 | 0 | |
| UTS | 530 | 302 | 547 | 0 | 0 | |
| RMIT University | 507 | 327 | 604 | 0 | 0 | |
| Adelaide University | 498 | 256 | 484 | 0 | 0 | |
| Flinders University | 476 | 248 | 458 | 0 | 0 | |
| The University of Newcastle | 457 | 196 | 411 | 0 | 2 | |
| The University of Melbourne | 441 | 182 | 379 | 0 | 0 | |
| Swinburne University | 410 | 221 | 426 | 0 | 1 | |
| **Total** | **5,223** | **2,606** | **5,399** | **0** | **3** | **626** |

Step 1 works: 5,399 intake months on 2,606 courses, every one with stored page evidence. Steps 2 and 3 produce almost nothing.

## 3. What was missed, and why (job records in `pipeline.course_intake_dates`)

| Outcome or reason | Intake rows | Root cause |
|---|---|---|
| Filled (year only, UNSW) | 626 | The UNSW calendar gives month, not day, for 2027 terms; no deadline in any calendar |
| Course page names no study period (month only) | 1,787 | Rule of 2 Nov (no month-to-period inference). **But see 4.1: even without the rule, the calendars hold no future start for that month** |
| Page not proved to be the course's own (E16) | 751 | Course page binding not proved (Course Link backlog; reconciliation paused since 4 Nov 19:27) |
| No stored reading of the page's intake wording | 230 | Adapter stored the month without the page wording |
| Named period does not start in this month | 80 | Page and calendar disagree |
| Page refused for this course | 51 | Page refused by identity check |
| Named period's starts are past | 29 | Only 2026 dates in the calendar |
| **Never examined** | **1,845** | The hourly job takes 200 rows across the whole platform; top-10 rows wait |

## 4. Root causes

### 4.1 The calendar reading is the blocker (platform defect)

For the 1,787 month-only rows, the stored calendars were checked for a future dated start in the same month:

| University | Month-only rows | Calendar has one future start that month | No future calendar start that month |
|---|---|---|---|
| Monash | 369 | 195 (**from the wrong calendar: Monash Indonesia**) | 174 |
| RMIT | 310 | 0 | 310 |
| UTS | 288 | 2 | 284 |
| Melbourne | 215 | 0 | 215 |
| Newcastle | 194 | 28 (92 more with several starts) | 74 |
| Swinburne | 192 | 0 | 192 |
| Flinders | 123 | 0 | 123 |
| Adelaide | 50 | 0 | 50 |
| Sydney | 36 | 0 | 36 |
| UNSW | 10 | 6 | 4 |

Dated starts held per university: 2 to 6 for most (37 UTS, 26 Adelaide, 16 Swinburne), mostly 2026 and already past. Examples: Flinders semester 1 = 13 Mar 2026, semester 2 = 7 Aug 2026; Melbourne semester 1 = 23 Feb 2026, semester 2 = 3 Aug 2026; RMIT one start (16 Nov 2026). **2027 calendars are attached (RMIT 2027 HE, UTS 2027, Newcastle 2027 PDF, Swinburne 2027 PDF) but their 2027 dates are not extracted.** Application deadlines extracted: **0 at every university.**

### 4.2 Wrong calendar documents approved (platform defect)

- Monash: Monash Indonesia key dates and Study Abroad (inbound) key dates. Neither is the Australian teaching calendar.
- Melbourne: Ormond College and Trinity College residential key dates beside the university semester dates.
- Adelaide: an online "how to apply" page and a senior college page beside the academic calendar.

### 4.3 No learning reader for calendars or intakes (design gap)

Fees have an AI reader with findings and versioned reading notes (`fee_reader_findings`, `fee_reader_recipes`, v2.15.309). Intakes and calendars do not: adapters are regex patterns and `term_months` maps set by hand, and the calendar reader is deterministic. A new calendar layout (PDF wall calendar, year tabs, "Teaching Period" tables) silently yields nothing, and nothing records it as a finding.

### 4.4 No revisit (platform defect)

A skipped row is not looked at again under the same rule and calendar (`intake_dates_plan_v2`). If the page binding is later proved, or the page is re-read, the row stays skipped until a new calendar is approved or the rule changes.

### 4.5 Course page binding (known backlog)

751 rows wait on E16 page proof. Course Link reconciliation (Decision 179) moved 531 on 4 Nov and paused at 19:27.

## 5. Revisit schedule (current, as built)

| Group | Next look | Gap |
|---|---|---|
| Never examined (1,845) | Hourly job, 200 rows per run across all providers | No priority for top universities |
| Skipped rows | Only when a calendar is re-approved or the rule changes | No time-based or change-based revisit |
| Calendars | Only when a person approves a new one | No yearly roll-over to the next year's calendar |

## 6. Keeping this current

To be generated from the database (job records, catalogue counts, calendar extraction) on a schedule and shown in the Admin UI, as the mandate requires. Until then this file is updated by hand at each measurement.

## 7. Activity log after v2.15.480 (unattended platform runs; Claude verifies only)

Where the platform keeps the evidence (per item, never overwritten): `pipeline.course_intake_date_events` (every intake decision, its reason, next action and revisit), `pipeline.calendar_reread_state` (every stored calendar document re-read), `pipeline.calendar_reader_findings` (what the reader could not prove), `pipeline.process_results` (dated measurements, hourly), and Layer 2/3 Operations › Process results in the Admin UI.

| Time (AEDT) | Run (by the platform) | What it did | Result |
|---|---|---|---|
| 11:20 | Release check | v2.15.480 live (migration 98991eb2, worker v0.59.7, nine functions = tested) | ok |
| 11:21 | Process results › Measure now (Admin UI) | Baseline | 5,399 intake rows; year 665; start date 0; deadline 3; never examined 1,688; valid calendars 21 (Monash 0, two set aside); future periods 61 |
| 11:21 | Intake Run & Validate › Preview (Admin UI, read only) | Top 10, size 20 | 0 eligible in 5 rows a university |
| 11:26 | Job intake-dates-apply | 200 UNSW rows (focus order) | 0 filled; 153 waiting for next academic year, 31 course identity unresolved, 16 evidence ambiguous |
| 11:53 | Job process-results | Measurement 2 | Same totals; 5 universities routed to a person (flag calendar_needs_correction) |
| 12:13 | Job calendar-reread | 20 stored calendar documents, no paid reads | Parser: no future dated start in any → all 20 to the AI queue; 19 read by 12:27 (cost US$0.0005–0.012 each); scopes found: UNSW Global pathway, Ormond and Trinity college, Macquarie English pathway |
| 12:25 | Job policy-auto-approve | calendar-v2 readings | 13 of 19 approved (focus universities) |
| 12:26 | Job intake-dates-apply | 200 UNSW rows again (calendar set changed) | 0 filled; 151 waiting for next academic year, 31 identity, 16 ambiguous, 2 reader correction |

### Why no dates yet (proven from the reads)

| # | Cause | Evidence | Next action |
|---|---|---|---|
| R1 | **Reader correction needed**: the year is printed in a heading, not in the row, and the AI did not quote the heading; the validator drops an unproven year. It also put the year in the period name ("term 1 2027"), so it no longer matches "Term 1" on course pages | UNSW academic calendar: 42 starts read, 0 kept a year; 8 are 2027–2028 (Term 1 2027 = 15 Feb, Term 2 = 31 May, Term 3 = 13 Sep). Sydney wall calendar PDF: 7 starts, 0 years | Bounded reader fix: take the year from the nearest preceding heading on the stored page (as the dated parser does), strip the year from the period name. Needs a PR and release authorisation |
| R2 | **Stale edition**: the stored copy is the 2026 calendar | Melbourne and Sydney key-dates pages: years read, nothing after 2026 (finding next_year_missing) | Fresh read of the official 2027 pages (Firecrawl, about one credit a page). Platform Admin decision (credits 1,982 left) |
| — | Not yet read | 494 stored documents still waiting (20 a run, hourly at :13), including RMIT, UTS, Newcastle and Swinburne 2027 calendars | Unattended; next cycle 13:13 |

## 8. Final intake recovery (mandate 5 Nov 2026 12:44): the bounded change, v2.15.481

Mandate recorded verbatim in `docs/platform/2026-11-05-final-intake-recovery-strategy-mandate-1244.md`. One PR on the existing architecture: no new engine, controller, scheduler or screen.

| Part | What the platform now does | Where the evidence is kept |
|---|---|---|
| R1 year from its section | Calendar reader calendar-v2.1: a start's year is taken from its quote, else the heading above it, an ancestor heading, the document title, or the year tabs above repeated term blocks (UNSW). A year from a neighbouring section or a note is rejected (`year_from_wrong_section`); a quote found in blocks of different years is rejected (`year_ambiguous`); no year is ever assumed. A deadline is a date only when its own row prints the year. | `pipeline.calendar_reader_findings`; each reading's `year_quote` and `year_basis` |
| Re-read on a reader change | Only main teaching calendars of the top 10 whose intake rows miss a date, most missing first; the rest are set aside as "not needed" and woken when needed | `pipeline.calendar_reread_state` (reader_version, state, reason) |
| §9 durable classes | Every decision carries one of the 13 mandated classes, deterministic or not, the change that brings it back, evidence year, reader and related case. Deterministic failures have no timer; held rows and course-level exceptions keep a timer so a removed lock or a person's decision is seen | `pipeline.course_intake_dates`, `pipeline.course_intake_date_events` |
| §6 publication check | Each admitted value is compared with the Website API v2 source (read only) after each apply and before each measurement; a missing value is `consumer_publication_failed` (checked again up to 3 times) | same tables, `publication_state` |
| R2 bounded refresh | A stale edition of a needed main calendar is handed to the existing provider-facts reads; at most 40 credits in total, one request open at a time, one run at a time, reservation = larger of 5 and the most an earlier read of that address used; stored equivalent edition checked first; never college, pathway, offshore or a person's binding; once per address; old edition kept | `pipeline.calendar_refresh_requests` (reason, old edition, credits from `pipeline.firecrawl_calls`, outcome, yield) |
| §10 Process results | Intake recovery block: admitted and published by university, source, rule, year and precision; skipped and failed by class with reason and next look; refresh credits and yield; reader progress; jobs. Recorded hourly as process `intake-recovery` and committed daily with the checkpoint | `pipeline.process_results`; Admin UI › Intake Run & Validate › Process results |

### Tests before release (production-parity PostgreSQL, live definitions md5-checked)

| §11 case | Result |
|---|---|
| UNSW year-in-heading (year tabs): Term 1 15 Feb 2027, Term 2 31 May 2027 admitted, day precision; Term 3 13 Sep 2027 proved in the reader test on the stored page | pass |
| Year from the wrong section rejected ("changing in 2028" note; 2026 block) | pass |
| College rejected; offshore rejected | pass |
| Exact course start date; explicit course date overrides the calendar | pass |
| Unique month; multiple periods; missing year; old edition not used | pass |
| Validated data admitted; held data protected (and admitted after the lock is removed) | pass |
| Publication matches the catalogue (and a missing value is recorded as a failure) | pass |
| Duplicate recovery prevented (re-read once per reader; refresh once per address) | pass |

Independent constraint review (separate reviewer, read only) found six concerns; all were fixed before release: held rows never coming back after a lock is removed; deadlines taking the section's year; refresh credits able to pass 40 (now one open request, a reservation from the address's earlier use, a run lock, and the setting capped at 40); unlimited publication retries and unsafe casts; a heading line starting a two-line quote; yield never settled for a dated-parser reading. The `intake-dates-apply` job was confirmed active before the change (re-scheduling does not switch anything on).

### Gate A route (no manual dispatch)

calendar-reread (:13, reader v2.1) → central-ai (every 5 minutes) → policy-auto-approve (:x5) → intake-dates-apply (:26) and publication check → process-results (:53). Verified in the Admin UI and through Website API v2.
