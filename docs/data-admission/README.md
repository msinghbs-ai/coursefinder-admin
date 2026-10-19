# Data admission running sheet

Platform Admin, 20 Oct 2026 07:02: "Keep an running sheet for data admission per uni in the admin repo and make it daily schedule."

| File | What it is |
|---|---|
| `RUNNING-SHEET.md` | Today's summary, the change since the previous day, what needs a person (largest first) and every university with active courses |
| `daily/YYYY-MM-DD.csv` | The full sheet for each day (kept, so changes can be traced) |

**Source.** `security.admission_sheet_v1()` in the StudySearch Pilot database (read only; migration `20261020030000`). One row per university with active courses: country, courses, stage, admitted adapter fields, courses holding an official page, intakes, English, page fee and a scholarship (search projection), scholarships published, held scholarship pages, flags, Layer 4 items and the next action in plain words.

**Schedule.** A scheduled task runs every morning (06:4x Melbourne): it reads the function, runs `scripts/data-admission/build_sheet.py`, commits both files and checks the push.

**Stages.** Admitting (adapter on, fields admitted); Adapter built, not admitting yet; Onboarding running; CRICOS data only (1–4 courses, no credits spent); Stopped: too few course pages; Stopped: no website; Stopped for another reason.
