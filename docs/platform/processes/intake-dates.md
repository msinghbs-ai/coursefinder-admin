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
