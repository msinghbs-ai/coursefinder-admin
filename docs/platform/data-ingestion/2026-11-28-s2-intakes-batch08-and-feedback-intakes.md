# S2-Intakes: DOT batch 08 intakes and reported intake feedback (28 Nov 2026)

S2-Intakes (Claude Code, Opus 5.5), 28 Nov 2026 11:55–13:00 AEDT.
- Instructions: PC-20261128-0931-S2-Intakes and addendum PC-20261128-1018-S2-Intakes (SS-Programme-Control, M3/Chats S2-Intakes document), plus the 07:06 AEDT relay (DOT batch 08).
- Live reads only, except the one change below.

## DOT batch 08 package

`StudySearch-AU-08-READY_FOR_PICKUP.zip` (Drive file `1obH3Uio5LWSbIv7HQdLyhmiNHc6bGKW1`). All 28 files match the manifest's sha256. It holds 242 intake records: UNE 210 and TAFE Queensland 32.

## UNE (210 records): calendar proposal `c914b027`

**Live state.** The proposal is `proposed`. The machine qualifier refuses it with `platform_admin_rejected_address`: a person rejected that address earlier, so only a person can approve it.

**The defect.**
- The reading held 15 dated "starts". Only three are trimester starts:
  - 22 Feb 2027, "Trimester 1 Starts";
  - 21 Jun 2027, "Trimester 2 Starts";
  - 18 Oct 2027, "Trimester 3 Starts".
- The other 12 rows are orientation days, mid- and end-of-trimester intensive and assessment periods, and "Teaching Recommences" block starts.
- The Admin screen (Academic calendars) edits months only, not dates. So "edit the proposal to keep the three starts" could not be done there.

**The fix, at the source: Pilot branch `s2-intakes-une-calendar-teaching-starts`.**
- Parser change: the dated table parser (`coverage-sweep` `policy.ts` `calendarStarts`) no longer takes a row about orientation, an intensive or assessment period, or recommencing teaching as a teaching start (decision §1).
- Regression case: added to `cf-247-s541`, using the UNE rows. The result is exactly the three trimester starts.
- Migration `20261201053000`:
  - It puts the stored copy of that one document back on the existing calendar re-read: no fetch, no Firecrawl, no AI.
  - The re-read refreshes `c914b027` in place, and its status stays `proposed`.
  - Rolled-back rehearsal passed: run `46090420395`, md5 `0a51d0be`.

**The person's action after the re-read.** Admin › Academic calendars › University of New England › proposal for `principal-dates-2027`, then Approve.
- The existing intake planner (`intake-dates-apply`, hourly at :26) then dates the month-only UNE intakes whose month equals a trimester start month (Rule B, strict same month).
- Measured before:
  - 178 UNE intakes are held "the course page names no study period (month only)";
  - 7 are held "year not printed";
  - 8 are held by E16 identity.
- Not approved by S2-Intakes.

## TAFE Queensland (32 records)

The dates are per course and per campus, from the price list's Start Date column.
- The calendar mechanism holds provider-wide study periods. Registering one TAFE Queensland "calendar" would give every course the same dates, which is wrong.
- The planner's course-page date route (`intake_dates.page_date_admit`) reads the course's own page, not a price list.
- **Held:** there is no existing per-course price-list date path. Building one is new engineering and needs a decision.
- No calendar was registered.

## ANU 070333K: 30 September application deadline

- The course has no intake row.
- The only deadline field is `catalogue.course_intakes.application_deadline`, which belongs to an intake. A deadline is never stored as a commencement, and an intake is never created from a deadline.
- **Held:** "no intake row; the deadline is kept as evidence only".

## Reported feedback

| Course | Live state (28 Nov 12:00 AEDT) | Outcome |
|---|---|---|
| VU 092944A | Feb, Apr, Jul and Sep active, month only. The four reported dates (15 Feb, 26 Apr, 26 Jul, 27 Sep 2027) match these months. The January intake stays withdrawn. | Held by E16 (`course_identity_unresolved`) until the Platform Admin decides S1-DG-8. No date entered by hand. |
| VU 115486F | Feb, Apr, Jul and Sep active, month only. | Held "no stored reading of the page's intake wording" (`reader_correction_needed`). |
| VU 092820B | January and July `calendar_default` rows are withdrawn. No active intake. | Withdrawal preserved. No evidence-backed successor yet. |
| WSU 064020M | March and July active, month only. | Held "no valid academic calendar: the approved calendars are set aside" (`calendar_needs_correction`). Nothing is applied from another institution's or campus's calendar. |
| RMIT 077512F | Active "February" with start 2027-03-01, and "July" with start 2027-07-19. Both are pre-s994 Rule B nearest-start admissions. | The date is the official Semester 1 start. The label is the course page's own word. 483 active rows across RMIT 221, Monash 220, ACU 41 and UOW 1 have a label month that differs from the start month, and they were kept by the Platform Admin's decision (23 Nov 17:49, s994). Correcting the label (to the term, for example "Semester 1") is a bulk change to live rows and needs a decision. Not changed. |

## Planner cycles

`intake-dates-apply` runs through the admission-rule runner every hour at :26.
- Last four runs: 21:26, 22:26, 23:26 and 00:26 UTC on 27–28 Nov. All succeeded, in 44–50 s.
- In the last six hours they recorded 385 decisions and 0 fills.
- So the cycles are unattended but not yet result-bearing. The next result-bearing cycle depends on the UNE approval.

## Spend

$0. Read-only queries and one rolled-back rehearsal. No Firecrawl, no AI, no container.

## Test register

`cf-247-s541` gained one test; its guard is unchanged.
- The sandbox could not regenerate the register: `npx playwright test --list` needs `react` and `lucide-react`, which cannot be installed without network.
- S1-Build's next release regenerates it.
