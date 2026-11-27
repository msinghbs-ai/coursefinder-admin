# DOT batch 08: fees and intakes for UNE and TAFE Queensland (s1327)

S1-Build, 28 Nov 2026. Scoped exception approved by the Platform Admin / SS-Programme-Control, 28 Nov 2026 06:54 AEDT, for UNE and TAFE Queensland only.
- Pilot migration: `20261130223000`.
- Worker: `fee-schedule-etl` v0.9.0.
- DOT package: `StudySearch-AU-08-READY_FOR_PICKUP.zip`. Its 339 owner records match the hashes in the manifest.

## Fees (97 DOT records)

| Records | Route | Outcome |
|---|---|---|
| UNE 00003G, 82 records (annual: two full-time trimesters, "Annual course fees"; "Fees quoted cover full-time tuition for two full-time trimesters only") | Schedule `une_2027`, registered and qualified (Decision 162) | Rehearsed (rolled back): 82 applied, 3 older fees superseded, 0 skipped |
| TAFE Queensland 03020E, 2 records (higher education table "Cost (annual indicative)") | Schedule `tafeqld_he_2027`, registered and qualified (Decision 162) | Rehearsed (rolled back): 2 applied, 0 skipped |
| TAFE Queensland, 13 whole-of-course totals ("Cost (total)") | Parked | The fee mechanism records only annual fees; these tables are never read |

**Checked against DOT's records.** The worker's HTML reader, run on DOT's retained originals, gives:
- **UNE:** all 82 DOT amounts exactly, plus 12 more rows that DOT left out.
- **TAFE Queensland:** both DOT amounts exactly, plus 3 more rows that DOT left out.

The apply step is limited to DOT's checked course codes, and every other row is parked.

**What the mechanism keeps.** All of the existing checks still apply:
- the code must be bound to an active course of the provider;
- a course listed twice with different amounts is refused;
- a newer current fee year is not overwritten;
- a different amount in the same fee year goes to Layer 4.

## Intakes (242 DOT records)

**UNE (210: Trimester 1 on 22 February 2027 for 79 courses, Trimester 2 on 21 June 2027 for 76, Trimester 3 on 18 October 2027 for 55).**
- Approved UNE calendars give months only.
- A dated calendar proposal is waiting for a person's decision: `c914b027` (principal dates 2027, `provider-policy-calendar-dates-v2`).
- That proposal also holds 10 dates that are not trimester starts: teaching recommencing, mid-trimester breaks, Block C and trimester ends.
- It needs a person to edit and approve it so that it keeps only:
  - "22 February 2027 Trimester 1 Starts";
  - "21 June 2027 Trimester 2 Starts";
  - "18 October 2027 Trimester 3 Starts".
- The existing intake-date path then applies it.
- Not decided by S1-Build: it is a governed human approval.

**TAFE Queensland (32).**
- The dates are per course and per campus, from the price list's Start Date column.
- The calendar mechanism gives provider-wide study periods, so registering a TAFE Queensland calendar would assign every course the same dates.
- The 32 are parked until the intake owner has a per-course path.

## Live baseline before apply

UNE plus TAFE Queensland hold 870 active fees and 348 active intakes.
