# Intake dates: calendar reader v2 — design (5 Nov 2026)

Authority: decisions `2026-11-05-intake-calendar-fix-decisions-0905.md`. Evidence: `processes/intake-dates.md`.
Branch: `cf247-intake-calendar-v2` (pilot repo). PR-first; full gate; the Platform Admin validates in the UI.

## Defects traced (code and live data, 5 Nov 09:10–09:25)

| # | Defect | Where |
|---|---|---|
| D1 | The AI calendar reader asks only for the **month** each period starts: every AI-read calendar holds 0 dated starts and 0 deadlines | `coverage-sweep` `CENTRAL_AI_PROMPT.intake_calendar`, `centralAiParsed` |
| D2 | The dated parser (`calendar-dates-v1`, 2 Nov) was never applied to stored calendars ("no re-read") | migration 20261102080000 |
| D3 | The AI reader sees only the first 24,000 characters of a document (long PDFs cut, later years lost) | `central_ai` mode |
| D4 | The date step uses only the **latest approved** calendar per university; wrong documents won (Trinity/Ormond colleges, UNSW Global, Monash Indonesia, Monash Study Abroad) | `calendar_dated_periods_v1` |
| D5 | Month-only course pages never take a date (rule of 2 Nov) | `intake_dates_plan_v2` |
| D6 | A skipped row is never looked at again under the same rule and calendar | `intake_dates_plan_v2` |
| D7 | No record of what the process did, missed and why, and no UI view of it | — |

## Design

1. **Calendar reader v2 (worker).** The AI returns, for each study period, the start (year, month, day exactly as printed, with the quote) and application deadlines (date, who they apply to, quote), plus the calendar's **scope** (main teaching, offshore campus, college or residence, study abroad inbound, pathway or foundation, research only, other). Every value must be on the page: the quote is on the page; the month, day and year are in the quote (the year may come from the heading just above). Long documents are read in slices (settings). Dropped values become **findings** stored with the proposal. Parser label `ai:<model>:calendar-v2`.
2. **Learning loop.** The next read of the same university's calendars receives the latest findings as notes (as the fee reader's recipes and findings do).
3. **Re-read stored calendars (no Firecrawl).** Job `calendar-reread` queues each stored calendar document not yet read by v2 for the existing `central-ai` worker job. Existing auto-approval for focus universities applies unchanged.
4. **All valid calendars.** `calendar_dated_periods_v2`: per document, its latest approved reading; documents whose scope is not main teaching, or whose address matches the excluded words setting, are set aside with the reason (never deleted).
5. **Unique-month rule (decision 2).** When the course page names no period, the month takes the date only when exactly one dated start in that month lies ahead in the main calendars. Setting `intake_dates.month_unique_match` (1, as decided). Ambiguous months stay month-only.
6. **Revisit.** Each record keeps the calendar set it was decided against and a next revisit time (`intake_dates.revisit_days`). A row is looked at again when its calendar set changes or its revisit time passes. Focus universities first.
7. **Process results.** `pipeline.process_results` keeps each measurement (what it did, how many, missed by reason, next revisit), recorded by job `process-results`; shown on Layer 2/3 Operations › Process results with validation samples (course, before/after, page quote, calendar quote and document); a daily workflow writes the generated record to the repository.

## Not changed

Consumer API shapes (G3); the E16 page check; manual locks; Firecrawl spend; admission authority (values reach the catalogue only through `intake_dates_apply_v1` and its guards).
