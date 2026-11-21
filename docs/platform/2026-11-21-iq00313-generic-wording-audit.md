# IQ-00313: start days taken from general course-page wording (S1-Fix-IQ00313, 21 Nov 2026)

**Status:** recorded before merge. Pilot spec s925, migration `20261121170000`, Pilot #1453. Rolled-back live dry run passed 21 Nov 2026 11:16 AEDT (file md5 `6e562e2d`). Live on deploy, no switch and no shadow (standing mandate, 21 Nov 2026 10:07 AEDT).
**Directive:** Platform Admin, 21 Nov 2026 10:57 AEDT, P0.
**Session:** S1-Fix-IQ00313.

## 1. What was found

| Item | Value |
|---|---|
| Course | Edith Cowan University, Bachelor of Science (Occupational Therapy) Honours |
| CRICOS | 086244B (course `fbd8ea85-8bcd-47e7-9cbf-88a1aad89201`) |
| Intake | February (intake `301b33a0-98e0-43f1-8cf2-744507d98413`) |
| Published value | 22 February 2027, start precision "day" |
| Written by | job `intake-dates-apply`, rule `calendar-v3`, run of 21 Nov 2026 09:26 AEDT (22:26 UTC on 20 Nov) |
| Calendar used | ECU `2027-Academic-Calendar.pdf`, Semester 1 starts 22 Feb |
| Course wording behind it | "Semester 1 Most courses start in Semester 1 each year, usually in the last week of February" |

**Why it is wrong.** The sentence is about most ECU courses, not this one. It names Semester 1, so the planner matched Semester 1 to the calendar and took its first day. Nothing on the course page says that this course starts on that day.

**What is supported.** The course lists a February intake, and the calendar's next February start is in 2027. So "February 2027" (year and month, `2027-02`) is supported. The day is not.

## 2. The audit

The audit read, live at 11:05 AEDT, every active intake that holds a start day admitted by a calendar-v3 rule.

| Rule | Day admissions | Wording changed when general sentences are removed | Backed only by general wording |
|---|---|---|---|
| `calendar-v3` | 1,647 (171 in the last 7 days) | 22 | **3** |
| `calendar-v3-nearest-start` (Rule B) | 1,901 (107 in the last 7 days) | 13 | 0 |
| **Total** | **3,548** | 35 | **3** |

**The three intakes backed only by general wording.** All are ECU February intakes and all read 22 February 2027:

| CRICOS | Course | Intake | Admitted (AEDT) |
|---|---|---|---|
| 086244B | Bachelor of Science (Occupational Therapy) Honours | `301b33a0` | 21 Nov 09:26 |
| 060895C | Bachelor of Social Work (Honours) | `f60ca583` | 21 Nov 04:26 |
| 083819C | Bachelor of Speech Pathology Honours | `275b1fa8` | 15 Nov 01:26 |

**Kept as course-specific.** The other 32 rows whose wording changed still name the period or month in a course-specific sentence once the general sentences are removed. Examples:
- University of Tasmania: "Location Hobart Semester 1".
- Monash: "Semester two (July) Apply directly to Monash using course code …".
- The University of Queensland: "Closing Date To commence study in semester 1 …".
- ECU 079123C: "Semester 1: Study full-time at City Campus".

**One case for a decision (not changed).** Massey University MY0418 (Master of Veterinary Medicine (Level 9)), July intake, 12 July 2027 (calendar-v3, 13 Nov). Its wording describes the university's semesters in general ("Semesters One: late February to June Semester Two: July to early November"). The stored text is cut into overlapping windows. Only the first window carries "most courses", so the rule does not catch the second. The fix below does not change this row. A person decides whether it is also general wording.

## 3. The fix (s925, live on deploy)

1. **Course-specific wording** (`security.intake_wording_specific_v1`). The planner removes general sentences before it looks for study periods. These are:
   - sentences about most, many, some, all, several, "a lot of" or "a number of" courses, programs, degrees, units or students (083819C also carries "A lot of our courses start in Semester 2", found by the first dry run);
   - hedged sentences ("usually", "generally", "typically", "normally", "in most cases") that do not say "this course" or "this program".
2. **No start day from general wording** (`security.intake_dates_plan_v3`, md5-guarded edit `020a047e` → `cf7fff50`). When the period or the month is named only in general wording, no route takes a start day. This covers the named period, the unique month and Rule B nearest start. The intake takes the year of the calendar's next start in that month within the horizon (year and month), or it stays month only. A year that was withdrawn before is not admitted again.
3. **Start-day withdrawal** (`security.intake_date_day_withdraw_v1`). This is the existing withdrawal, for the start day only.
   - It reverts the day only while the catalogue still holds the value the process admitted.
   - It keeps the year, the month, the evidence, the readings, every event, the cohort stages and every lock.
   - It places no hold, so the 7,585 locks stay as they are.
   - It writes a `withdrawn` event whose before value is the rejected day, so no route admits that day again.
4. **Remediation, once, in the same migration.** The same rule finds the rows again when the migration runs. The migration stops if the three ECU intakes are not among them, or if more than 25 rows match. Then, in one transaction:
   - each row is taken back to year and month;
   - the stored Website and Zoho items are reconciled;
   - the Website v2 item, the stored Website item and the Zoho item are checked to show no start day;
   - the edited planner is run on these courses and must plan no day;
   - the operation is recorded as `IQ-00313-GENERIC-WORDING-20261121` in `pipeline.admin_control_events`.
5. **Guards in the migration.** Consumer API 75/48 with 0 drift before and after. Manual locks and active cron jobs unchanged. Nothing is dropped or deleted. No setting is added and no job is added.

## 4. Acceptance

- Live read-back after deploy:
  - the three intakes read February 2027 with no start day in the catalogue, the Website v2 item, the stored Website item and the Zoho item;
  - the withdrawn events exist;
  - 7,585 locks; G3 75/48; active jobs ≤ 140, 0 unregistered; US$0 AI and 0 Firecrawl credits.
- Two clean unattended `intake-dates-apply` cycles after deploy, with no new day admission from general wording.

## 5. Results

To be appended after the merge and the read-back.
