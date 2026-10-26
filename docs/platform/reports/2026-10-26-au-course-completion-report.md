# Australian courses: completeness by field and estimated completion

Date: 26 Oct 2026 (AEDT). Asked by the Platform Admin at 16:01: "prepare report on each course of Australia, extended with each data field and estimate how long for completion. Keep the report separate for the courses or providers with no courses. Prepare in 2 separate excel/worksheet."

Workbooks (in `docs/platform/reports/2026-10-26/`):
- `AU-courses-completion-report.xlsx`:
  - Read me;
  - Field pace;
  - By provider (1,546 providers);
  - Courses (26,103 rows, one per active Australian course, each field's state, the estimate and the main action needed).
- `AU-providers-with-no-courses.xlsx`: the 10 Australian providers with no active course.

Source: the live database. Each course's field state comes from `pipeline.course_attribute_coverage` (rebuilt hourly), and the fill rates from `pipeline.course_coverage_daily_by_country`. The workbooks use formulas (recalculated: 219,802 formulas, 0 errors). The report date in Read me drives every estimated date.

## Headline

| | Courses |
|---|---|
| Active Australian courses | 26,103 |
| All 11 core fields filled | 5,435 (20.8%) |
| Only automatic work left (they get a date) | 324; the latest date is 3 Jan 2028, driven by intakes |
| Need an action before they can finish (no date) | 20,344 |
| … provider not published (all automatic work skips unpublished providers) | 10,706 |
| … a value not on the course page, needing a university-level source (fee schedule, English policy, calendar) | 9,335 |
| … Layer 4 review | 290 |
| … a person decides (blocked, or website unknown) | 11 |
| … the register gives no value | 2 |

## Each field at the 14-day pace

The dates below are when each field's automatic backlog would clear if the last 14 days' pace held. The 7-day pace is much slower and is shown in the workbook.

| Field | Filled | Automatic backlog | Estimated date |
|---|---|---|---|
| English requirement | 64.8% | 1,342 | 2 Nov 2026 |
| International tuition (provider) | 31.6% | 3,483 | 30 Dec 2026 |
| Official course page | 71.3% | 3,217 | 24 Apr 2027 |
| Intakes | 36.0% | 3,440 | 3 Jan 2028; the 7-day pace is negative after wrong-page values were withdrawn |

These fields are complete or nearly so: duration, study level, field of study and open to international are at 100%; campus is at 99.9% and registered tuition at 99.3%. Delivery mode is at 63.5%; the rest is not on the course page or paused.

Course description, academic entry requirements and application deadline have no reader yet, so they have no date.

## What would move the dates most

1. **Publication.** 1,322 unpublished providers hold 10,706 courses that need an action, and their missing fields do not move at all while the provider is unpublished.
2. **University-level sources.** Tuition, intakes and delivery are often not stated on the course page. The fee reader is not switched on for Australia (`fees.countries` is New Zealand and Canada), and calendars and English policies are read per university.
3. **The pace itself.** Pages bound and values admitted per day fell sharply in the last week (speed record).

## Providers with no courses

Ten Australian providers have no active course. All are archived and unpublished, and every course they had left the register on 28 Sep 2026. Each waits in Layer 4 as "Provider left the register". Two of them, the University of Adelaide and the University of South Australia, merged into Adelaide University, which is published with 498 active courses. No completion date applies to any of the ten.
