# AU completion wave: check-ins

Mandate: Platform Admin, 26 Oct 2026 19:19 ("Heartbeat mandate — AU completion wave").
- **Cadence:** every 30 minutes, 07:00–19:00 AEDT. Overnight checks at 00:30 and 04:00.
- **Record:** `2026-10-26-au-completion-week.md`.
- **Definitions** (as in the 26 Oct workbooks): the 11 core fields; "automatic" = published provider, every missing core field in an automatic lane; "blocked" = everything else not complete.
- **Pace sources:** `pipeline.course_coverage_daily_by_country` (14 days) and today's observed change.

## 26 Oct 19:2x (first check-in, baseline for the next)

- **Values admitted since 17:00, AU:**

  | Field | Admitted | Note |
  |---|---|---|
  | Fees | +85 courses | another 371 fee rows written unverified; 400 of those await the re-apply paste |
  | English | 0 | |
  | Intakes | 0 | |
  | Links | 0 | |

- **Wave status:**
  - Published providers in lanes: 0 of 1,056 (paste not applied).
  - Courses touched: 0 of 9,454.
  - Fee schedules found / read: 243 / 0.
  - Entry-matrix first runs: none. The reader is staged and off, waiting for confirmation.
- **Queue health:**
  - `provider-facts` has not read the 243 AU schedule pages. Cause: the AU tuition proof list was empty until 19:1x. It is fixed; the next run is at 19:30.
  - `scholarship-course-attribute-full`: last run failed on a database deadlock (not an AU lane).
  - Other AU lanes moving. Fee reader queue: 348 done, 34 leased, 151 queued, 4 failed.
- **Spend:**
  - Firecrawl 961 / 25,000 today.
  - AI: fee reader US$1.24 / 5; enrich US$0.02 / 25; course match US$0.01 / 5; others US$0.
- **Gate:** 1 value admitted that failed a gate, which is red.
  - Course: Swinburne 087852C, Bachelor of Education. Fee US$36,300 for 2027, fee `ba434cf0…`.
  - Written live at 17:50 by the university adapter reading. The bound page's proof (`exact_title`) is not accepted for AU tuition.
  - It is the only such fee since R1 (24 Oct) in any country. The writer path is to be found.
- **ETA track** (snapshot 18:47: complete 5,439, automatic 310, blocked 20,354; target date Thu 29 Oct):

  | Outcome | Status | Arithmetic |
  |---|---|---|
  | All 11 fields ≥ 7,500 | **AT-RISK. MISSES: 7,500 by 29 Oct (projected at most 5,463)** | Needs +2,061 in 3 days (687 a day). The binding field is intakes: 14-day pace +111 (7.9 a day), today 0. Even if every new intake completed a course, that is at most +24 by Thursday. At that pace 7,500 is reached no earlier than mid-July 2027 |
  | Automatic ≥ 8,000 | **AT-RISK. MISSES: 8,000 by 29 Oct (projected about 515)** | 310 now; the paste adds 205 (the eligible courses whose missing fields are all in automatic lanes). 8,802 of the 9,454 eligible courses have a field marked "not on the course page": intakes 5,215, tuition 4,616, delivery 3,390, English 1,996. Publishing alone does not move them; only provider-level sources (fee schedules, calendars, English policies) and a delivery rule do. Delivery has no lane at all |
  | Blocked < 10,000 | **AT-RISK. MISSES: 10,000 by 29 Oct (projected about 20,150)** | 20,354 now; the paste moves about 205. Each remaining row carries a cause (workbook "Action needed" column). Owners are being added to the Thursday re-run |

- **Paste-ready files awaiting the Platform Admin:**
  - `docs/platform/pastes/PASTE-20261026-au-publish-eligible-providers.sql` (08:00);
  - the fee re-apply paste for the 400 held items, being prepared tonight.

## 26 Oct 19:3x: Platform Admin decisions (19:27), Swinburne fee quarantined, the gate hole's cause

- **Quarantined** at 19:27: fee `ba434cf0…` (Swinburne 087852C, $36,300 for 2027). Status `unverified`, logged in `admin_control_events` (`fees / quarantine`).
  - Its 2026 fee ($34,200, written 8 Oct, before R1) has the same proof. It is not touched, since the decision named one row; it is reported here.
- **Cause of the hole (two parts):**
  1. **The adapter fee branch never checks tuition identity.** `security.adapter_overwrite_v1` (job `adapter-overwrite`, every 10 minutes) checks `coverage_identity_allowed(…, 'intakes')` and `(…, 'english')` before admitting those values, but has no tuition check before admitting the fee.
  2. **Courses with CRICOS codes bypass the write-time check.** For AU courses that have both CRICOS codes, `adapter_overwrite_v1` writes through `public.svc_coursefacts_apply_record`, not `security.coverage_apply_course_v1`. R1's write-time check lives only in `coverage_apply_course_v1`.
  - The adapter also **supersedes the course's current fee before writing**, so a refused write would leave the course with no fee.
- **The same class exists elsewhere:** 23 functions write `catalogue.course_fees`. Only 2 check tuition identity, and 3 jobs write fees without the check (`fee-period-settle`, `provider-rule-admit`, `provider-basis-rule-admit`). Fixing one path is not enough.
- **Fix decided (CF-247 gate hotfix, own PR tonight):**
  - one write-time gate at the table, a trigger on `catalogue.course_fees`, for every writer:
    - an international provider fee written or changed to `active`, for a course whose bound page proof the country's tuition list does not accept, is stored `unverified` with one Layer 4 item (the R1 shape);
    - exempt: manual bindings and a person's own decision (signed-in admin call, or the manual-edit flag);
    - setting `fees.identity_gate_on`;
  - plus the adapter's fee branch checks tuition identity before superseding anything;
  - contract test: every fee writer, the adapter included, passes the same check.

## 26 Oct 19:45 check-in, with the gate fix merged, the fee paste ready and the rebaseline

**Gate hole: fixed and live.** v2.15.359, #705 (`054cfcda`), merged under rule 9.
- Before the merge:
  - suite 1,005 passed;
  - the live md5 of `adapter_overwrite_v1` matched the guard;
  - live dry run: a title-proved AU fee becomes unverified with a Layer 4 item; a CRICOS-proved fee stays active; a person's edit stays active; a full adapter run admits 0 gate-failing fees.
- After the merge:
  - history md5 `d3ab7249` matches the file;
  - release currentness passed;
  - the trigger body is live byte for byte (`19946970…`);
  - the adapter edit is live; `fees.identity_gate_on` is 1.
- **Cause, as found:** the adapter fee branch had no tuition check, and the CRICOS-code write path bypassed R1's check. Now every writer goes through one gate at the table; test s125.

**Fee re-apply paste, ready for the morning:** `docs/platform/pastes/PASTE-20261026-au-fee-reapply.sql`.
- 386 of the 400 held items (pair-list md5 `ccff9166…`):

  | Case | Items |
  |---|---|
  | Course has no live fee | 80 |
  | Same amount already live | 70 |
  | Other fee year | 236 |

- 14 stay with a person: 10 where the same year already shows a different amount, and 4 with no stored fee row.
- Rolled-back dry run: 386 live, 386 items approved, 386 decision rows, 1 control event.
- Completes 27 courses (international tuition was their only missing field).

**Check-in values:**
- **Values admitted since 19:22, AU:**

  | Field | Admitted | Total now |
  |---|---|---|
  | Fees | +113 courses | 8,427 |
  | English | 0 | 16,917 |
  | Intakes | 0 | 9,390 |
  | Links | 0 | 18,622 |

- **Wave status:**
  - Published providers in lanes: 0 of 1,056; courses touched 0 of 9,454 (paste not applied).
  - Fee schedules found / read: 244 / 37. Reading started after the tuition-list change.
  - Entry matrix: off, staged.
- **Queue health:** all AU lanes moving. Fee queue: 576 done, 1 leased, 0 queued, 4 failed.
  - `scholarship-course-attribute-full` (not AU) last run failed on a database deadlock. It will be looked at tomorrow.
- **Spend:** Firecrawl 1,040 / 25,000; fee AI US$1.89 / 5.

**Rebaseline: proposed Thursday targets, with the arithmetic**

| Outcome | Now | Proposed for Thu 29 Oct | Arithmetic |
|---|---|---|---|
| All 11 fields | 5,439 | **5,600** (floor 5,540; up to about 6,100 only if top-20 calendars are approved on Tuesday) | Floor: +27 from the fee paste, plus tuition at the 14-day pace (56 a day; about 45% of tuition fills complete a course) for 3 days = about 76 |
| | | | Upside: fee-schedule wave at today's observed rate (about 200 fees a day) = about +270; delivery reader (Wednesday) up to the 116 published courses missing only delivery; top-20 calendars could reach some of the 740 published courses missing only intakes |
| | | | Intakes stay the binding field: 7.9 a day over 14 days |
| Automatic work | 310 | **Stated per lane**, no single number | Measured Tuesday after the paste, from the eligible providers' current states: official page 2,349, fees 2,907, English 2,522, intakes 2,664, delivery 0 (no lane until the reader lands). The Thursday test is that each lane drains at a measured rate, with its own date at that rate |
| Blocked | 20,354 | **0 rows without a named cause and owner** (not a size target) | The Thursday workbook re-run gives every not-complete, not-automatic course its cause and owner; the 10,000 line is retired, as you decided |

**Lever stack (your order):**
1. AU fee schedules: found / read reported in each check-in.
2. Delivery reader: build this week. First finding: the "Enrich fields" AI already reads delivery from course pages; the 3,390 eligible "not on page" rows are pages it found silent. Before building, I check whether those pages really are silent or the reader misses a pattern, so the build targets the real gap.
3. Calendar mark-file for the AU top 20 by course count: tomorrow.
4. English mark-file: with you already.

**Red / awaiting you:**
- two paste files for the morning: the publish paste and the fee re-apply paste;
- the 563 held register departures (Layer 1 operations).

## RMIT entry-matrix lane — for the 00:30 check (as at 00:06, lane paused; numbers unchanged while paused)

| Measure | Count |
|---|---|
| Pages (besides the 4 acceptance pages) | 32 |
| Attempted | 8 pages, 12 AI reads |
| Complete | 2 (India 33/33, Japan 11/11) |
| Guard-held | 6 (Hong Kong, IB: D1 "Not applicable" as a band; Colombia, Denmark, Indonesia: column left out; Foundation equivalencies: D2) |
| Retried | 4, once each |
| Failed | 0 |
| Admitted | 0 |
| In review | 6 RMIT items, all complete verdicts |
| Silent partial reads | **0** |

**Red: RMIT lane halted at 00:06** for defect D1. Fix proposed; awaiting the Platform Admin's go.
