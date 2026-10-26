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

## 27 Oct 00:3x overnight check-in (since 19:45)

Heartbeat run at 00:36 AEDT. Coverage figures as computed at 23:47.

**Values admitted since 19:45 (AU):**

| Field | Admitted | Total now |
|---|---|---|
| Fees (courses with a live international tuition fee) | +27 courses (47 new live fee rows; 22 more held unverified by the gate) | 8,454 |
| English | 0 | 16,917 |
| Intakes | +1 | 9,391 |
| Links | 0 | 18,622 |

- Gate: the trigger `course_fee_identity_gate` is enabled and `fees.identity_gate_on` is 1. Every one of the 47 live rows was written through it. The 22 held rows (and their Layer 4 items) are the gate working.
- **No value admitted that failed a gate.** Entry matrix: 0 active rows (nothing admitted; every RMIT approval needs a complete verdict).

**Wave status:**
- **Publish paste:** not applied (yours, 08:00). 0 of 1,056 providers published by it, so no published-provider lanes yet.
- **Fee schedules:** found 284 (was 244), read 167 (was 37). Provider-facts is reading AU fee-schedule pages. Fee reader queue: 711 done (135 new since 19:45), 1 leased, 4 failed.
- **Fee re-apply paste:** done and lodged (`PASTE-20261026-au-fee-reapply.sql`): 372 pairs, net +315 live, regenerated after the 20:46 rejections. Waiting for you at 08:00. Nothing more to finish on it.
- **Countries paste:** applied 22:42 under your 22:38 authority (249 countries, consumers unchanged).
- **Entry matrix:**
  - UTS and WSU lanes on;
  - RMIT halted since 00:06 (defect D1, fix awaiting your go);
  - VU and Federation halted for the PDF reader;
  - runs: 8 done, 29 queued (RMIT, held by the pause);
  - #708, #709 and #710 merged and verified live tonight.

**Queue health:**
- AU lanes moving.
- Layer 4 pending: 778.
- `scholarship-course-attribute-full` (not AU) still fails on a database deadlock, the same cause as at 19:45. Named, owner me, looked at tomorrow.

**Spend (AI day from 11:00 AEDT; Firecrawl day from 00:00 AEDT):**

| Item | Spent | Guard |
|---|---|---|
| Fee AI | US$2.32 | 5 |
| Entry-matrix AI | US$0.18 | 2 |
| Enrich fields | US$0.08 | 25 |
| Course match | US$0.01 | 5 |
| Firecrawl since midnight | 4 credits used (26 billed) | 25,000 |

No spend stop hit.

**ETA, Thursday targets:**
- **All 11 fields:** 5,537 (was 5,439 at 19:45: +98 in 4 h 50 min).
  - The floor of 5,540 needs +3, and the 08:00 fee re-apply paste completes 27. **The floor is on track.**
  - The 5,600 target needs +63. At tonight's pace (about 20 an hour, but bursty and mostly from fee writes) it would be reached Tuesday, and at the 14-day pace (about 56 a day) by Wednesday. **On track.**
- **Automatic:** 267 (was 310). Per-lane rates are measured after the publish paste.
- **Blocked:** 20,299 (was 20,354). The cause-and-owner workbook re-run is due Thursday.

**Red:**
- **RMIT entry-matrix lane halted at 00:06** for defect D1 (the reader keeps "Not applicable" as a band; the completeness guard correctly holds those reads). Cause named; the fix awaits your go. No silent partial read.
- **Pastes awaiting you at 08:00:** retirements, then publish, then fee re-apply (standing; unchanged).

## 27 Oct 04:0x overnight check-in (since 00:36)

Heartbeat run at 04:02 AEDT. Coverage figures as computed at 03:47.

**Values admitted since 00:36 (AU):**

| Field | Admitted | Total now |
|---|---|---|
| Fees | 0 (0 new live, 0 held by the gate) | 8,454 |
| English | 0 | 16,917 |
| Intakes | 0 | 9,391 |
| Links | 0 | 18,622 |

- Gate: trigger enabled, `fees.identity_gate_on` 1. No value admitted that failed a gate.
- Entry matrix: 0 active rows.

**Wave status:**
- **Fee-schedule lane: drained, not stalled.** All 284 pages found in this wave are processed: 167 read, 117 failed, 0 left to read. Nothing has changed since 00:30:21.
  - 110 of the 117 failures are `target_list_refused`: the direct read was blocked and the scraper is refused because the provider is not on the Firecrawl target list. **Named cause; the decision is yours** (add these providers to the target list, or leave them to the course-page fee reader).
  - The other 7 are 404 or no content.
- 68 older AU fee-schedule rows (found 20 Oct) remain `found` with 0 attempts, outside this wave's scope. I'll look at them tomorrow.
- **Fee reader queue:** 711 done, 4 failed, 0 queued.
  - 1 item has been `leased` since 19:18 (lease expired 19:35, 3 attempts, "the model returned no answer"). Stuck at its attempt limit without being settled to failed. Named; one item; I'll look at it tomorrow.
- **Publish paste:** not applied (yours, 08:00). Fee re-apply paste: lodged and ready.
- **Entry matrix:**
  - UTS and WSU on;
  - RMIT halted since 00:06 (D1, awaiting your go);
  - VU and Federation halted (PDF);
  - runs: 8 done, 29 queued.

**Queue health:**
- `fee-reader`, `provider-facts`, `fee-period-settle` and the other fee jobs are all succeeding on schedule.
- Layer 4 pending: 778.
- `scholarship-course-attribute-full` (not AU): the same deadlock, as at 19:45 and 00:3x.

**Spend:**

| Item | Spent | Guard / budget |
|---|---|---|
| Fee AI (AI day from 11:00 AEDT) | US$2.32, unchanged since 00:36 | 5 |
| Entry-matrix AI | US$0.18 | 2 |
| Firecrawl since midnight | 25 used (45 billed) | 25,000 |

Firecrawl refusals today: reads 17, scholarships 96, central 39. No spend stop hit.

**ETA, Thursday targets:**
- **All 11 fields:** 5,539 (+2 since 00:3x; +100 since 19:45).
  - **Floor 5,540:** 1 short, met by the 08:00 fee re-apply paste (+27).
  - **Target 5,600:** needs +61. Overnight growth has stopped with the fee-schedule lane drained, so the target now rests on:
    - the morning pastes (+27);
    - the published-provider lanes after the publish paste;
    - the 110 target-list pages, if you add them.
  - **On track only if the morning pastes go in.**
- **Automatic:** 266. **Blocked:** 20,298.

**Red:**
- **RMIT entry-matrix lane halted** (D1, since 00:06), unchanged.
- **Pastes awaiting you at 08:00:** retirements, then publish, then fee re-apply.
- **Decision for you:** 110 AU fee-schedule pages refused by the Firecrawl target list. The cause is named, so this is not a stalled-lane red. It is the only remaining source of overnight fee growth.

## RMIT entry-matrix lane — 27 Oct 05:30 (after #711)

| State | Pages |
|---|---|
| Passed (complete, in review) | 12 |
| Source-held, terminal (D2: Foundation equivalencies, IB, Global Assessment Certificate) | 3 |
| Parser defect D5, terminal (Kuwait, Mexico) | 2 |
| Reader defect D4, failed (Colombia, Denmark) | 2 |
| Held, attempts left | 7 |
| Not attempted | 9 |
| Stored, not queued | 1 |

**Silent partial reads: 0. Active rows: 0.**

**Red:** RMIT out of scope since 05:27:47 for parser defect D5 (fix to propose; awaiting the Platform Admin's go). UTS and WSU running.

## RMIT entry-matrix lane — 27 Oct 06:59 (after D5 #713, D4 #714 and the controlled recovery)

| Outcome | Pages |
|---|---|
| Complete, in review (12 earlier + 13 this recovery) | 25 |
| Non-country, terminal (D2) | 3 |
| Still defective: guard column tie G1 (Sri Lanka, Thailand, UK) | 3 |
| Still defective: repeated header row P2 (Singapore) | 1 |
| Still defective: bare-number scale R2 (Norway) | 1 |
| Still defective: D4 class unresolved (Nigeria, Vietnam) | 2 |
| Not read, lane paused (Qatar) | 1 |

- **Silent partial reads: 0.** 363 proposed rows with 363 identities, 0 duplicates. Active rows: 0. Recovery cost at most US$0.157.
- **Red:**
  - AER is stopped at new defect classes (no D6+ without a Platform Admin decision).
  - `entry-matrix-read` is off. UTS and WSU are drained.
  - The change taking RMIT out of `entry.providers` was cancelled before it ran, three times. Detail: build log, 27 Oct 06:59.

## 27 Oct 07:3x: AU measurement and source-recovery checkpoint (mandate 05:46, checkpoint 3)

Full record: `docs/platform/ui-audit/2026-10-27-mandate-0546-response.md`.
- Intakes −596: all explained (supersession by the 22 Oct page-only withdrawal; no writer defect).
- Delivery 72.6% → 63.5%: baseline verified; the fall is the 23 Oct take-back.
- Five inventories done.
- Fee residue: cleared or assigned to the Platform Admin.
- **Admitted AU values moved under the mandate: 0.** Every lever is gated.
- **Red:** morning pastes pending (08:00); target-list proposal awaiting a decision; UNSW English approved from the India-campus page; AER frozen at new defect classes.
- Half-hourly heartbeat stood down under the mandate's three-checkpoint rule; the scheduled 07:00 check-in was not rescheduled.
