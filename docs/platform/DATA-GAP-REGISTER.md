# Data gap register (CF-247 s927)

**Asked by:** Platform Admin, 21 Nov 2026 12:19 AEDT: "can we maintain gap registers which gets updated everyday at google drive Monitoring folder, shared with developers, with detailed institute being worked on and daily updates - removing them if data field is admitted, per country basis?"

**His answers (21 Nov 2026):**
- **Rows:** course × field.
- **Scope:** all open gaps, including "not published by the provider".
- **Sharing:** do not share yet. Nothing is shared until he says so, and then only the register files and the sheet, never the Monitoring folder (it also holds the hours and request registers).

## What runs

| Step | When (AEDT) | What | Where |
|---|---|---|---|
| 1 | 07:30 daily | GitHub workflow `Course field readiness` reads every active course read only (8 parts), then `scripts/telemetry/data-gap-register.mjs` compares with yesterday's state and writes the register files | Pilot branch `course-readiness-snapshot`, `monitoring/course-readiness/` |
| 2 | 08:07 daily | Scheduled task "Data gap register to Drive (08:07)" (`trig_019UmEjiuMzPiWfev6ospuFJ`, automatic approval) uploads the CSVs, keeps the latest only (closed files 14 days) and refreshes the sheet | Drive › Monitoring; Google Sheet `StudySearch_Data_Gap_Register` (`1GEbtc_I_EtubfJ7hDa4llp1QhDEHdiPhae8mDqcguGk`) |

Nothing writes to the database. The readiness SQL gained one read-only column (`raw`: the coverage state behind each non-admitted field).

## Files and tabs

| Output | One row per | Notes |
|---|---|---|
| `Data_Gap_Register_<CC>[_Part<n>]_<date>.csv` | open gap: course × field | Columns: country, institution, course_id, course title, field, gap, first seen, days open, provider_id. Parts under 2.9 MB. A row leaves on the day its field is admitted |
| `Data_Gap_Institutions_<CC>_<date>.csv` | institution × field with open gaps | Open gaps by gap type, "worked on now" (being checked or waiting for a person), admitted since the last register, oldest gap |
| `Data_Gap_Closed_<date>.csv` | gap closed since the last register | Why: Admitted, Course no longer active, Country scope not started, Fee itself not held |
| Sheet tab **Summary** | country × field × gap | Today, the last register, and the change as a formula; the not-started scopes; the meaning of each gap |
| Sheet tab **Institutions_Top** | institution | The 100 institutions with the most open gaps in each country |
| Sheet tab **Closed_Today** | country × field | Courses admitted since the last register |
| Sheet tabs **Files**, **Run_Log** | file / run | Links to today's CSVs; one line per run |

## Gaps

| Gap | Meaning | What happens next |
|---|---|---|
| Being checked | Read from the official page; checks running | Admitted when the checks pass |
| Waiting for a person | Held in Layer 4 for approval | Admitted when approved |
| Page not found yet | Website known; page for the course and field not found | Being searched for |
| No website on record | No website held | Website sourced first |
| Site blocked | Robots rules or a directory site | Another official source or a manual read |
| No reader yet | No reader switched on for the field (for example academic entry) | Waits for the reader |
| No scholarship found yet | No linked scholarship found | Scholarship pages being read |
| Not published by the provider | Read and not published there | Nothing to collect: show "Check with the provider" |

Not-started scopes have no rows; they are counted on Summary only. These are Canada academic entry, and destination fields for countries without an approved edition. `fee_basis` is its own gap only when the fee itself is held.

## Guard

Pilot spec `tests/uat/cf-247-s927-data-gap-register-contract.spec.mjs`.
