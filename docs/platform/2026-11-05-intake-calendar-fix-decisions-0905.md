# Intake dates: calendar fix decisions (Platform Admin, 5 Nov 2026 ~09:05 AEDT)

Evidence: process record `processes/intake-dates.md` (measured 08:43–08:57). Asked and answered in the session.

| # | Question | Decision |
|---|---|---|
| 1 | Build one bounded fix, PR-first, full gate before any merge: an AI calendar reader that learns from findings (as the fee reader), calendar source checks, revisit of skipped rows when their inputs change, and a Process results view in the UI kept in sync with the admin repo | **Yes, build it.** The Platform Admin validates it in the UI before it is called done |
| 2 | Month-only rule (2 Nov ~14:50): once calendars hold future dates, may a month on the course page take the date when exactly one calendar period starts in that month? | **Allow unique match only.** Two or more starts in the month stay month-only; nothing is guessed |
| 3 | Resume Course Link reconciliation (Decision 179) for the remaining universities, UNSW last | **Resume now.** Count then apply per university, recorded in the process record |

## Bounds

- The engineering hold stays for all other work; #875 stays held.
- The AI reader reads stored calendar evidence with a pinned, qualified model; no new vendor spend increase without approval. A passing test never switches admission on by itself: the new reader's dates are admitted only through the existing intake-dates job and its guards (manual locks, same-month, E16).
- Wrong calendar documents are not deleted: they are marked not-a-teaching-calendar with a reason and stop being used.
- Delivery is not acceptance (process record mandate 08:42): the release is reported with what it did, how many, what was missed and why, and the next revisit.
