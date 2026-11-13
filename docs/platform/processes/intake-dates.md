# Process record: intake dates (start date, year, application deadline)

**Mandate:** process record mandate, Platform Admin 5 Nov 2026 08:42 (`../2026-11-05-process-record-mandate-0842.md`).
**Scope of this record:** the top 10 Australian universities by active courses (setting `run_now.cohort_top_au_universities`).
**Measured:** 5 Nov 2026, 08:43–08:57 AEDT, read-only on production (release v2.15.479). Hand-written for this first issue; to be generated (see "Keeping this current").

## 1. What the process is

| Step | Component | Schedule | What it needs |
|---|---|---|---|
| 1 Intake months | University adapters read stored course pages | Adapter read cycle | A course page bound to the course |
| 2 Calendar | Approved central key-dates page (`pipeline.provider_policy_proposals`, kind `intake_calendar`) read into dated periods (`security.calendar_dated_periods_v1`) | When a calendar is approved | The university's own teaching calendar |
| 3 Dates | Job `intake-dates-apply` → `security.intake_dates_apply_v1` (plan `intake_dates_plan_v2`) | Hourly at :26, 200 intakes per run, whole platform (`batch.intake_dates_apply`) | Step 1 + Step 2 + the course page names the study period (rule of 2 Nov) + page identity (E16) |
| 4 Admission | Job `coverage-admit-intakes` | Every 10 minutes | Step 3 result |

## 2. Result (top 10 universities)

| University | Active courses | Courses with intake months | Intake rows | With start date | With deadline | With year |
|---|---|---|---|---|---|---|
| UNSW Sydney | 667 | 467 | 1,310 | 0 | 0 | 626 |
| The University of Sydney | 655 | 77 | 173 | 0 | 0 | |
| Monash University | 582 | 330 | 607 | 0 | 0 | |
| UTS | 530 | 302 | 547 | 0 | 0 | |
| RMIT University | 507 | 327 | 604 | 0 | 0 | |
| Adelaide University | 498 | 256 | 484 | 0 | 0 | |
| Flinders University | 476 | 248 | 458 | 0 | 0 | |
| The University of Newcastle | 457 | 196 | 411 | 0 | 2 | |
| The University of Melbourne | 441 | 182 | 379 | 0 | 0 | |
| Swinburne University | 410 | 221 | 426 | 0 | 1 | |
| **Total** | **5,223** | **2,606** | **5,399** | **0** | **3** | **626** |

Step 1 works: 5,399 intake months on 2,606 courses, every one with stored page evidence. Steps 2 and 3 produce almost nothing.

## 3. What was missed, and why (job records in `pipeline.course_intake_dates`)

| Outcome or reason | Intake rows | Root cause |
|---|---|---|
| Filled (year only, UNSW) | 626 | The UNSW calendar gives month, not day, for 2027 terms; no deadline in any calendar |
| Course page names no study period (month only) | 1,787 | Rule of 2 Nov (no month-to-period inference). **But see 4.1: even without the rule, the calendars hold no future start for that month** |
| Page not proved to be the course's own (E16) | 751 | Course page binding not proved (Course Link backlog; reconciliation paused since 4 Nov 19:27) |
| No stored reading of the page's intake wording | 230 | Adapter stored the month without the page wording |
| Named period does not start in this month | 80 | Page and calendar disagree |
| Page refused for this course | 51 | Page refused by identity check |
| Named period's starts are past | 29 | Only 2026 dates in the calendar |
| **Never examined** | **1,845** | The hourly job takes 200 rows across the whole platform; top-10 rows wait |

## 4. Root causes

### 4.1 The calendar reading is the blocker (platform defect)

For the 1,787 month-only rows, the stored calendars were checked for a future dated start in the same month:

| University | Month-only rows | Calendar has one future start that month | No future calendar start that month |
|---|---|---|---|
| Monash | 369 | 195 (**from the wrong calendar: Monash Indonesia**) | 174 |
| RMIT | 310 | 0 | 310 |
| UTS | 288 | 2 | 284 |
| Melbourne | 215 | 0 | 215 |
| Newcastle | 194 | 28 (92 more with several starts) | 74 |
| Swinburne | 192 | 0 | 192 |
| Flinders | 123 | 0 | 123 |
| Adelaide | 50 | 0 | 50 |
| Sydney | 36 | 0 | 36 |
| UNSW | 10 | 6 | 4 |

Dated starts held per university: 2 to 6 for most (37 UTS, 26 Adelaide, 16 Swinburne), mostly 2026 and already past. Examples: Flinders semester 1 = 13 Mar 2026, semester 2 = 7 Aug 2026; Melbourne semester 1 = 23 Feb 2026, semester 2 = 3 Aug 2026; RMIT one start (16 Nov 2026). **2027 calendars are attached (RMIT 2027 HE, UTS 2027, Newcastle 2027 PDF, Swinburne 2027 PDF) but their 2027 dates are not extracted.** Application deadlines extracted: **0 at every university.**

### 4.2 Wrong calendar documents approved (platform defect)

- Monash: Monash Indonesia key dates and Study Abroad (inbound) key dates. Neither is the Australian teaching calendar.
- Melbourne: Ormond College and Trinity College residential key dates beside the university semester dates.
- Adelaide: an online "how to apply" page and a senior college page beside the academic calendar.

### 4.3 No learning reader for calendars or intakes (design gap)

Fees have an AI reader with findings and versioned reading notes (`fee_reader_findings`, `fee_reader_recipes`, v2.15.309). Intakes and calendars do not: adapters are regex patterns and `term_months` maps set by hand, and the calendar reader is deterministic. A new calendar layout (PDF wall calendar, year tabs, "Teaching Period" tables) silently yields nothing, and nothing records it as a finding.

### 4.4 No revisit (platform defect)

A skipped row is not looked at again under the same rule and calendar (`intake_dates_plan_v2`). If the page binding is later proved, or the page is re-read, the row stays skipped until a new calendar is approved or the rule changes.

### 4.5 Course page binding (known backlog)

751 rows wait on E16 page proof. Course Link reconciliation (Decision 179) moved 531 on 4 Nov and paused at 19:27.

## 5. Revisit schedule (current, as built)

| Group | Next look | Gap |
|---|---|---|
| Never examined (1,845) | Hourly job, 200 rows per run across all providers | No priority for top universities |
| Skipped rows | Only when a calendar is re-approved or the rule changes | No time-based or change-based revisit |
| Calendars | Only when a person approves a new one | No yearly roll-over to the next year's calendar |

## 6. Keeping this current

To be generated from the database (job records, catalogue counts, calendar extraction) on a schedule and shown in the Admin UI, as the mandate requires. Until then this file is updated by hand at each measurement.

## 7. Activity log after v2.15.480 (unattended platform runs; Claude verifies only)

Where the platform keeps the evidence (per item, never overwritten): `pipeline.course_intake_date_events` (every intake decision, its reason, next action and revisit), `pipeline.calendar_reread_state` (every stored calendar document re-read), `pipeline.calendar_reader_findings` (what the reader could not prove), `pipeline.process_results` (dated measurements, hourly), and Layer 2/3 Operations › Process results in the Admin UI.

| Time (AEDT) | Run (by the platform) | What it did | Result |
|---|---|---|---|
| 11:20 | Release check | v2.15.480 live (migration 98991eb2, worker v0.59.7, nine functions = tested) | ok |
| 11:21 | Process results › Measure now (Admin UI) | Baseline | 5,399 intake rows; year 665; start date 0; deadline 3; never examined 1,688; valid calendars 21 (Monash 0, two set aside); future periods 61 |
| 11:21 | Intake Run & Validate › Preview (Admin UI, read only) | Top 10, size 20 | 0 eligible in 5 rows a university |
| 11:26 | Job intake-dates-apply | 200 UNSW rows (focus order) | 0 filled; 153 waiting for next academic year, 31 course identity unresolved, 16 evidence ambiguous |
| 11:53 | Job process-results | Measurement 2 | Same totals; 5 universities routed to a person (flag calendar_needs_correction) |
| 12:13 | Job calendar-reread | 20 stored calendar documents, no paid reads | Parser: no future dated start in any → all 20 to the AI queue; 19 read by 12:27 (cost US$0.0005–0.012 each); scopes found: UNSW Global pathway, Ormond and Trinity college, Macquarie English pathway |
| 12:25 | Job policy-auto-approve | calendar-v2 readings | 13 of 19 approved (focus universities) |
| 12:26 | Job intake-dates-apply | 200 UNSW rows again (calendar set changed) | 0 filled; 151 waiting for next academic year, 31 identity, 16 ambiguous, 2 reader correction |

### Why no dates yet (proven from the reads)

| # | Cause | Evidence | Next action |
|---|---|---|---|
| R1 | **Reader correction needed**: the year is printed in a heading, not in the row, and the AI did not quote the heading; the validator drops an unproven year. It also put the year in the period name ("term 1 2027"), so it no longer matches "Term 1" on course pages | UNSW academic calendar: 42 starts read, 0 kept a year; 8 are 2027–2028 (Term 1 2027 = 15 Feb, Term 2 = 31 May, Term 3 = 13 Sep). Sydney wall calendar PDF: 7 starts, 0 years | Bounded reader fix: take the year from the nearest preceding heading on the stored page (as the dated parser does), strip the year from the period name. Needs a PR and release authorisation |
| R2 | **Stale edition**: the stored copy is the 2026 calendar | Melbourne and Sydney key-dates pages: years read, nothing after 2026 (finding next_year_missing) | Fresh read of the official 2027 pages (Firecrawl, about one credit a page). Platform Admin decision (credits 1,982 left) |
| — | Not yet read | 494 stored documents still waiting (20 a run, hourly at :13), including RMIT, UTS, Newcastle and Swinburne 2027 calendars | Unattended; next cycle 13:13 |

## 8. Final intake recovery (mandate 5 Nov 2026 12:44): the bounded change, v2.15.481

Mandate recorded verbatim in `docs/platform/2026-11-05-final-intake-recovery-strategy-mandate-1244.md`. One PR on the existing architecture: no new engine, controller, scheduler or screen.

| Part | What the platform now does | Where the evidence is kept |
|---|---|---|
| R1 year from its section | Calendar reader calendar-v2.1: a start's year is taken from its quote, else the heading above it, an ancestor heading, the document title, or the year tabs above repeated term blocks (UNSW). A year from a neighbouring section or a note is rejected (`year_from_wrong_section`); a quote found in blocks of different years is rejected (`year_ambiguous`); no year is ever assumed. A deadline is a date only when its own row prints the year. | `pipeline.calendar_reader_findings`; each reading's `year_quote` and `year_basis` |
| Re-read on a reader change | Only main teaching calendars of the top 10 whose intake rows miss a date, most missing first; the rest are set aside as "not needed" and woken when needed | `pipeline.calendar_reread_state` (reader_version, state, reason) |
| §9 durable classes | Every decision carries one of the 13 mandated classes, deterministic or not, the change that brings it back, evidence year, reader and related case. Deterministic failures have no timer; held rows and course-level exceptions keep a timer so a removed lock or a person's decision is seen | `pipeline.course_intake_dates`, `pipeline.course_intake_date_events` |
| §6 publication check | Each admitted value is compared with the Website API v2 source (read only) after each apply and before each measurement; a missing value is `consumer_publication_failed` (checked again up to 3 times) | same tables, `publication_state` |
| R2 bounded refresh | A stale edition of a needed main calendar is handed to the existing provider-facts reads; at most 40 credits in total, one request open at a time, one run at a time, reservation = larger of 5 and the most an earlier read of that address used; stored equivalent edition checked first; never college, pathway, offshore or a person's binding; once per address; old edition kept | `pipeline.calendar_refresh_requests` (reason, old edition, credits from `pipeline.firecrawl_calls`, outcome, yield) |
| §10 Process results | Intake recovery block: admitted and published by university, source, rule, year and precision; skipped and failed by class with reason and next look; refresh credits and yield; reader progress; jobs. Recorded hourly as process `intake-recovery` and committed daily with the checkpoint | `pipeline.process_results`; Admin UI › Intake Run & Validate › Process results |

### Tests before release (production-parity PostgreSQL, live definitions md5-checked)

| §11 case | Result |
|---|---|
| UNSW year-in-heading (year tabs): Term 1 15 Feb 2027, Term 2 31 May 2027 admitted, day precision; Term 3 13 Sep 2027 proved in the reader test on the stored page | pass |
| Year from the wrong section rejected ("changing in 2028" note; 2026 block) | pass |
| College rejected; offshore rejected | pass |
| Exact course start date; explicit course date overrides the calendar | pass |
| Unique month; multiple periods; missing year; old edition not used | pass |
| Validated data admitted; held data protected (and admitted after the lock is removed) | pass |
| Publication matches the catalogue (and a missing value is recorded as a failure) | pass |
| Duplicate recovery prevented (re-read once per reader; refresh once per address) | pass |

Independent constraint review (separate reviewer, read only) found six concerns; all were fixed before release: held rows never coming back after a lock is removed; deadlines taking the section's year; refresh credits able to pass 40 (now one open request, a reservation from the address's earlier use, a run lock, and the setting capped at 40); unlimited publication retries and unsafe casts; a heading line starting a two-line quote; yield never settled for a dated-parser reading. The `intake-dates-apply` job was confirmed active before the change (re-scheduling does not switch anything on).

### Gate A route (no manual dispatch)

calendar-reread (:13, reader v2.1) → central-ai (every 5 minutes) → policy-auto-approve (:x5) → intake-dates-apply (:26) and publication check → process-results (:53). Verified in the Admin UI and through Website API v2.

### Gate A — first unattended cycle after v2.15.481 (5 Nov 2026)

| Time (AEDT) | Run (by the platform) | Result |
|---|---|---|
| 13:43 | Deploy check | ok: migration 55da2185 = file; 7 functions = tested md5s; 0 failed runs, 0 HTTP errors |
| 14:13 | calendar-reread (reader calendar-v2.1) | 20 documents (18 to the AI, 2 dated by the parser); 483 set aside as not needed; refresh asked 0 (0 credits) |
| ~14:20 | central-ai | UNSW academic calendar read by calendar-v2.1: Teaching period T1 = 15 Feb 2027, T2 = 31 May 2027 (year from the year tabs); T3 13 Sep kept without a year (finding year_not_printed); UNSW key-dates page: no values |
| 14:25 | policy-auto-approve | UNSW calendar-v2.1 reading approved |
| 14:26 | intake-dates-apply + publication check | UNSW 200 rows: **2 filled** (Master of Industrial Research: February 2027 → 15 Feb 2027, May 2027 → 31 May 2027; day; unique-month rule; published); 151 academic_year_unproven; 31 course_identity_unresolved; 16 no_matching_commencement_period |
| 14:31 | Website API v2 read-back (`api.website_v2_course_item`) | intakes: February 2027 start 2027-02-15; May 2027 start 2027-05-31 |
| 14:50 | Admin UI › Process results › Intake recovery (v2.15.481) | UNSW Sydney · approved calendar (calendar-v3-unique-month) · 2027 · day · admitted 2 · start dates 2 · deadlines 0 · published 2 |

**Gate A: met.** Genuinely new 2027 start dates (before: no year, no date), admitted by the platform's own job, published in Website API v2, visible in the Admin UI; no manual dispatch.
Caveat recorded: the page wording behind this course's February and May intakes is a student testimonial ("commenced … in February 2023"); the dates equal UNSW's official 2027 terms, but the intake months rest on that earlier extraction.

**Why 151 UNSW rows are still held (proven):** an old approved reading of the UNSW key-dates page (parser ai:gpt-4.1-mini, "Term 1 March 2023") still supplies the period "term 1". Course pages naming "Term 1" therefore take the named-period path and find no 2027 "term 1"; the calendar-v2.1 reading names the same terms "teaching period t1/t2". Next action (proposal, not executed): see the integration report of 5 Nov 2026 14:55.

### Gate B — next scheduled cycle (5 Nov 2026, 15:13–15:26)

| Time (AEDT) | Run (by the platform) | Result |
|---|---|---|
| 15:13 | calendar-reread (calendar-v2.1) | 11 documents (9 to the AI, 2 dated by the parser); all 27+4 relevant documents now read by v2.1; 483 not needed. Refresh: **1 request** — Monash principal dates (`monash.edu/students/admin/dates/principal-dates`), 5 credits reserved of 40 (handed to the provider-facts read) |
| 15:25 | policy-auto-approve | 7 calendar-v2.1 readings approved: Melbourne (2), Sydney (3, incl. wall calendar), Newcastle (2026 and 2027 PDFs) |
| 15:26 | intake-dates-apply + publication check | next 200 UNSW rows (focus order): **3 filled and published** (Diploma in Computer Science: January → 4 Jan 2027, May → 31 May 2027, August → 14 Aug 2028; day); 138 academic_year_unproven; 38 course_identity_unresolved; 21 no_matching_commencement_period |
| — | Repeat check | **0** of the 200 rows were rows decided at 14:26 (calendar set unchanged): no unchanged failure was repeated |

**Gate B: met** — the platform continued on its own schedule: reader, AI, approval, admission, publication and a bounded refresh, with no manual action.

Values to verify (recorded, not changed): Diploma in Computer Science under UNSW may be a UNSW College (pathway) course; its August intake took the 2028 Semester 2 start (UNSW's 2028 model) because 2027 has no August start.

Totals since the deploy (both cycles): 5 values admitted and published (UNSW, day precision, 2027 ×4, 2028 ×1); held: academic_year_unproven 289 (no timer; waits for a calendar or reader change), course_identity_unresolved 69 (next revisit 19 Nov 2026), no_matching_commencement_period 37 (waits for a change); refresh credits 5 reserved of 40.

## 9. UNSW blockage and cross-university fairness (direction 5 Nov 2026 15:50; P0 IQ-00313)

Direction recorded verbatim in `docs/platform/2026-11-05-intake-recovery-unsw-blockage-fairness-1550.md`.

### Course identity audit of the five values published after v2.15.481

| Course | Value | Evidence on the bound page | Verdict |
|---|---|---|---|
| Master of Industrial Research (108474B) | February 2027 → 2027-02-15 | Only a student testimonial: "I commenced the Master of Industrial Research program in February 2023" | Unsupported (no offering statement) |
| Master of Industrial Research | May 2027 → 2027-05-31 | No May wording | Unsupported |
| Diploma in Computer Science (102393G, CRICOS 113046B) | January 2027 → 2027-01-04 | "Intakes January, May, August*", weekly class time 20–25 hours; bound to the Undergraduate Certificate page | Unsupported date: a diploma/pathway timetable; UNSW's main calendar has no August start in 2027, so another academic calendar applies |
| Diploma in Computer Science | May 2027 → 2027-05-31 | same | Unsupported date |
| Diploma in Computer Science | August → 2028-08-14 (UNSW 2028 semester model) | same | Unsupported |

All five came from the unique-month rule: correct UNSW calendar dates applied to courses without proof that the course follows that calendar.

### Governance and containment

| Time (AEDT) | Action | Evidence |
|---|---|---|
| 15:52 | P0 integration issue IQ-00313 opened (consumer-visible unsupported dates) | `pipeline.integration_issues` id 313 |
| 15:56 | Containment approved by the Platform Admin: `intake_dates.month_unique_match` 1 → 0 through the governed settings write | admin control event 28963 |
| 16:26 | Scheduled intake-dates-apply after containment | 200 UNSW rows looked at; **0 filled; 0 by the unique-month rule** (verified 16:29) |

Unique-month matching stays off until course-specific intake evidence, source identity and calendar applicability are validated in production.

### Root causes

| # | Cause | Affected function |
|---|---|---|
| S1 | **Provider starvation**: the plan ordered candidates by focus rank and course before the batch limit, so UNSW (rank 1) took every 200-row batch (14:26, 15:26, 16:26) while Melbourne, Sydney and Newcastle readings waited | `security.intake_dates_plan_v3` |
| S2 | **Obsolete edition blocks the current calendar**: an approved 2023 reading of the UNSW key-dates page ("Term 1 March 2023") supplies the period "term 1"; course pages naming "Term 1" match it and find no 2027 start; the 2027 reading names the period "teaching period t1" | `security.calendar_sources_v1`, `security.calendar_dated_periods_v2` |
| S3 | **A general calendar treated as course evidence**: the unique-month rule required no course-specific offering statement and no proof that the course follows the main calendar | `security.intake_dates_plan_v3` |

### Correction (PR #882, v2.15.482; not yet released)

Provider rounds (`intake_dates.provider_share` 25, least recently served first, then focus rank); obsolete editions set aside with the reason; one canonical period name on the calendar and the course page (Term 1 = Teaching period T1 = T1); a course-specific offering and calendar-applicability gate before admission; a governed Platform Admin withdrawal (reverts only admitted fields, keeps history, holds the course's intakes with the existing manual lock, reads back Website API v2). Pre-production: ten-university fixture (200 rows over 8 universities, at most 25 each, previously 200 for one; 1.4 s), all §6 regressions, the v2.15.480/.481 cases on the new migration, the #872 browser workflow; full suite 1,904 passed.

## 10. Releases v2.15.482–485 and final acceptance (PASS, 5 Nov 2026 19:26)

| Release | PR | Merge | Migration (md5) | What it changed |
|---|---|---|---|---|
| v2.15.482 | #882 | 0c613f83 | 20261105060000 (792cc0f4) | Provider rounds (`intake_dates.provider_share` 25); obsolete calendar editions set aside; canonical period names (Term 1 = T1); course-specific offering and calendar-applicability gate; governed Platform Admin withdrawal |
| v2.15.483 | #883 | 1ed711d9 | 20261105070000 (d11b9e92) | Hotfix: a withdrawal finds the admission from the latest `filled` event that no later withdrawal undid (re-decided rows) |
| v2.15.484 | #884 | 200d56da | 20261105080000 (954b3882) | Focus universities first within each round. **Not accepted (Platform Admin 18:00):** it used the 50-provider focus list, not the approved top-10 pilot |
| v2.15.485 | #885 | cf77ef78 | 20261105090000 (d6ba992e); plan `intake_dates_plan_v3` 1d531a83 | Pilot share: `intake_dates.pilot_batch_share` 60 % of each run is reserved for the pilot scope (`security.intake_ui_scopes_v1`, top 10); the remaining 40 % keeps the global scheduler eligible for every other provider; at most 25 rows per provider per round |

**P0 IQ-00313 (UNSW unsupported values).**
- All five unsupported values were withdrawn through the governed path and verified absent from Website API v2:
  - Diploma in Computer Science: Jan, May and Aug;
  - Master of Industrial Research: Feb and May.
- Each course's intakes are locked (`manual_locks` mode `value`).
- `intake_dates.month_unique_match` has been 0 since 15:56 (containment; admin control event 28963).
- Unique-month matching stays off until course-specific evidence, source identity and calendar applicability are validated in production.

**Pre-merge preview of #885 (18:56, read-only replica):** 200 rows, pilot 120 (UTS, Flinders, Monash, Newcastle 25 each; Adelaide 20), non-pilot 80 (Macquarie, UWA, Victoria 25 each; Bond 5). One round per provider, about 1 s. Of Newcastle's 25 rows, 6 would be filled.

**Admin bounded validation (19:06): BLOCKED by the Preview's scan limit, not by the rule.**
- Course intake Run & Validate, scope Newcastle, 20 courses: 0 eligible.
- The Preview scans only `run_now.preview_rows_per_university` = 5 rows per university. In those, only UNSW had eligible work (2 courses).
- The setting is the Platform Admin's decision and was not changed.
- Codex PR #879 (preview paging) addresses this limit; it is retained, awaiting decision.

**Unattended scheduled run, 19:26 (`intake-dates-apply`, 73 s, succeeded): PASS.** The selection matched the preview exactly.

| University | Pilot | Selected | Admitted | Published (Website API v2) | Main reasons held |
|---|---|---|---|---|---|
| The University of Newcastle | yes | 25 | **6** | **6** | no matching commencement period 11, identity unresolved 6, calendar interpretation 2 |
| University of Technology Sydney | yes | 25 | 0 | 0 | no matching commencement period 18, identity unresolved 7 |
| Flinders University | yes | 25 | 0 | 0 | calendar interpretation 13, identity unresolved 7, no matching period 5 |
| Monash University | yes | 25 | 0 | 0 | no matching commencement period 21, identity unresolved 4 |
| Adelaide University | yes | 20 | 0 | 0 | identity unresolved 19, no matching period 1 |
| Macquarie University | no | 25 | 0 | 0 | wrong institution or campus 25 |
| The University of Western Australia | no | 25 | 0 | 0 | academic year unproven 16, no matching period 6, identity 3 |
| Victoria University | no | 25 | 0 | 0 | identity unresolved 17, no matching period 8 |
| Bond University | no | 5 | 0 | 0 | no matching commencement period 5 |

Admitted values (all `calendar-v3`, Newcastle Academic Calendar 2027, Semester 1 start 2027-02-22):
- Bachelor of Medical Radiation Science (Honours)(Radiation Therapy);
- Bachelor of Psychological Science;
- Bachelor of Nutrition and Dietetics (Honours);
- Master of Professional Engineering: Civil, Mechanical, and Geospatial Engineering and Surveying.

All six return February 2027, 2027-02-22, from `api.website_v2_course_item` (read 19:29).

The Radiation Therapy course's application deadline 2027-02-22 was held before this run (`before_value`). It was not set by this run.

**Verdict.** The success condition of the 18:34 direction is met: a source-backed intake value was admitted and published outside UNSW.
- Pilot fairness: 5 of the 10 pilot universities processed in this run. UNSW, Sydney, RMIT, Melbourne and Swinburne were served in earlier rounds and come back in rotation.
- The intake development workstream is closed except for confirmed P0 issues (18:35), and the scheduler returns to normal background operation.
- Open items, not development:
  - IQ-00313 stays open until the containment decision;
  - IQ-00314 and IQ-00315 are transient 502s, triaged;
  - the Preview scan limit (#879) awaits the Platform Admin.

**Process results (Admin UI, measured 19:53 by job `process-results`, read 19:55):**
- `intake-dates-apply` last run 19:26 succeeded;
- Newcastle "start dates 6 of 411 intake rows";
- start dates in the Website API source: 10 (UNSW 4, Newcastle 6).

The acceptance result is visible in the existing Admin view.

**Milestone accepted (Platform Admin, 5 Nov 2026 20:03).** The Newcastle intake admission and unattended operation are accepted as the first bounded autonomy milestone. Intake stays under normal platform monitoring: the hourly `intake-dates-apply` job, `process-results` measurements and the integration queue. Discretionary intake development is not restarted.


## Feature acceptance addendum — 8 November 2026 (F-INT)
**Authority:** [F-INT acceptance contract](../STUDYSEARCH-FEATURE-ACCEPTANCE.md#f-int--intake-dates-deadlines-and-providercourse-specific-verification-p0-iq-00313-related-iq-00111). This is an incremental design/completion specification, not a second intake process or an assertion that every step is implemented.

**Existing product to reuse (Pilot `main` verified at review):**
- `src/IntakeRunValidate.jsx`: selected scope, bounded cohort size, Preview eligible courses, Fix previewed cohort, governed Run Now, Verify catalogue & publication, saved cohort restore and past run output. It currently consumes `caps.scopes` and `caps.universities`; confirm exact scope capability from the live server rather than assuming it accepts any course ID.
- `src/AutomationProgress.jsx` and `docs/intake-automation-progress.md`: persisted job state, university breakdown, stage counts, 24h/7d/30d history, holds, publication checks, net gain and generic progress observer. Its presence alone does not prove all stages have live measures; the 8 Nov Controller reported selected/admitted/published missing in the broader lane funnel.
- Existing `intake-dates-apply` / `coverage-admit-intakes`, user-scoped controls and approved pipeline settings. Reuse them; do not build another job processor or top-level screen.

**Operator journeys required for verified F-INT completion (substeps F-INT.01–.06):**
1. **One course (explicit):** search by exact course ID or CRICOS, select live intake(s), show official source, country/campus/audience/year and current hold/lock, choose `Preview only`, `Run Now` or `Verify only` according to role. No new value on unsupported dates. The platform refuses ambiguous identity, stale preview and invalid role with a plain reason.
2. **One university (explicit):** select provider ID from authorised university list, show all eligible records and their per-stage counts, choose bounded pages/batches within existing batch/time budget; include a coverage stamp so an apparently successful first page cannot be presented as full-university completion. Users may inspect what was excluded and why.
3. **Existing approved cohort:** preserve current top-Australian-university pilot and bounded preview. Avoid regressing versioned cohort acceptance.
4. **Track one run:** immutable run/cohort ID, actor/reason, snapshot, scheduled/manual type, progress by stage, attempts/leases, selected/examined/admitted/withdrawn/published, timestamps, error cause, next retry and link to actual consumer verification. On reload, the run is discoverable, including queued, running, failed, evidence-held, review-held and complete states.
5. **Verify after action:** prove canonical row, relevant manual hold, prior evidence, Website stored item, Zoho stored item, and authenticated consumer HTTP where available. Label those proofs separately and show `unknown` on unavailable checks.
6. **First-run and quality:** two scheduled unattended cycles with bounded output/progress logs, no partial-success masking, correct 2027/2028 range, per-course eligibility, Deakin/UQ regressions, 0-work explanation, exact source/campus/year, no duplicate re-entry; true desktop and mobile UAT for operator and Admin, view-only denial for unauthorised roles.

**Task ownership:** F-INT references the existing IQ-00313 and intake workstream; new code gaps become numbered substeps under those IDs in `STUDYSEARCH-EXECUTION-REGISTER.md`, with a single assigned code owner. New UI controls must also update `UI-CATALOGUE.md` in the same PR, and preserve G2 settings, G3 frozen consumers and G4 tests. Do not claim the new one-course or all-university journeys currently work without authenticated acceptance evidence.


## 11. Production-wide autonomous intake cutover — 9 November 2026
**Newest operator instruction:** [9 Nov time-boxed source→date→publication plan](../nz-enrichment-brief/2026-11-09-intake-autonomous-production-cutover-plan.md), with G0–G6 tasks and owners in the canonical [Execution Register](../STUDYSEARCH-EXECUTION-REGISTER.md#2026-11-09--same-day-intake-production-closure-gates-and-owners-f-int-iq-00313). This supersedes §10's *discretionary development closed* judgement: **one bounded Newcastle acceptance in November does not establish full provider-wide automation**. The 9 Nov live scheduler is currently green but produces no new exact dates, and the missing source/date pathways must be completed before declaring F-INT autonomous.

**Current live measured baseline:** active exact start dates 1,534; active month-only/no exact date 30,302; 84 active application deadlines. The current code requires an approved official teaching calendar for provider entry into `intake_dates_plan_v3`; course-page exact dates serve as a **contradiction check only**, not a source to admit. 179 approved calendar proposals across 78 providers; 67 proposed across 51; `central.auto_approve_calendar_dates=0`, `intake_dates.month_unique_match=0`. Some pending calendar pages are inappropriate institution/pathway sources and cannot be approved wholesale. `course_intake_dates` currently holds 8,793 source-revisit-worthy decisions with no next revisit. Latest actual fill was 8 Nov 08:26 UTC (19:26 Melbourne).

**Specific technical release issue:** #931 adds recheck/fingerprint support but alone does **not** add a valid date. Its migration ID `20261109020000` collides with provider-description PR #930's different migration `20261109020000`; correct to a unique monotonic ID, update tests and verify. The proposed 14-day revisit distribution is a paced recovery policy, **not** a way to meet a same-day production outcome. No release authority for #931 is implied by the #930-only manual release permission.

**Required operating design:** For each active course and intake, process known official course page, current relevant academic-year main-teaching calendar (only if applicable), unique explicit exact course-page date where source/identity/current course offering is proved, and negative/rejected-date memory. Use stored official pages first, direct reads then metered Firecrawl if budgeted; if no page or calendar, acquire it and retry/park the one provider while continuing others. Do not auto-use institution-wide semester day for a course not offered in it. Keep valid month-only values month-only. After admission: canonical row→Website/Zoho projections→actual consumer check, schedule repeat/refresh on source change.

**Acceptance & duration:** two unattended post-release `:26` cycles with positive *verified* retained net date gain on eligible sources, sound handling of false/retired dates and cross-provider progression. At existing 200 attempts/hour, a single scan of 30,302 active no-exact-date rows would need a lower bound of 152 hourly slots even without validation/source cost, so not every row can be processed by midnight at unchanged throughput; and not every month-only row has a truthful day. Do not promise a fixed full-population ETA before valid-source eligibility and real throughput are measured.

## 12. Swinburne hyphenated dates; calendar rules A and B; all study levels — 10 November 2026

**Swinburne (released and verified, 10 Nov 2026 ~22:05 AEDT).** Swinburne's page adapter stores start dates as `01-March-2027`; the page route, its hint and the plan's page-date guard read only `1 March 2027`. Migration `20261110110523_cf247_intake_hyphen_dates` (three md5-guarded edits; Pilot PR #999 holds the re-runnable form, the held recovery and fixture `tests/fixtures/intake-hyphen-dates`). A run limited to Swinburne's courses admitted **265 exact start dates at 148 courses** (1 Mar 129, 2 Aug 120, 21 Jun 10, 5 Jul 5, 1 Feb 1), each a start of the approved 2027 calendar on the same day (P1); 148 search documents refreshed; no other provider touched. Held: 36 page-only dates, 11 identity refusals, 2 past dates, 105 rows with no stored page wording. Two "November" intakes at Swinburne (098493G, 116706B) come from a "Study Expo 24-November-2026" banner: removal needs a signed-in Curator (Course edit → Remove intakes).

**Baseline for the calendar rules (read only, 10 Nov 2026 ~22:40 AEDT).** Month-only rows (active intakes with no start date):

| University | Undergraduate | No matching period | Year unproven | Postgraduate and other | No matching period | Year unproven |
|---|---:|---:|---:|---:|---:|---:|
| Monash | 314 | 303 | 0 | 293 | 245 | 1 |
| RMIT | 358 | 265 | 0 | 246 | 218 | 0 |
| QUT | 192 | 184 | 0 | 189 | 173 | 0 |
| Deakin | 217 | 46 | 164 | 234 | 62 | 140 |
| Melbourne | 31 | 27 | 0 | 348 | 306 | 0 |
| Swinburne | 44 | 0 | 0 | 116 | 0 | 0 |

What blocks each (approved calendars, dated starts from 10 Nov 2026): RMIT already has Semester 1 = 1 Mar 2027 and Semester 2 = 19 Jul 2027 proved, so only the month gap (February → 1 March) blocks it; Monash's summary page has one "Semester dates 2026–2028" heading over three columns and the 2027 column has no year; Deakin's 2027 trimester page has the year only in its address and title; QUT's approved calendar holds 2026 starts only and its teaching-periods page (full dates, stacked year headings) was last parsed on 4 Oct with no values.

**Decisions (Platform Admin, 10 Nov 2026 22:36; design reference Decisions 270, 271, 272).** Rule A (270): a year-less start takes its year only from one unambiguous edition year in the address, title, column header or nearest year heading; range headings never; weekdays must agree; otherwise no start, with the reason. Rule B (271): a stated month takes the single main-teaching start in that month, or else the single one within 35 days after the 1st (`intake_dates.nearest_start_days`); rolling or multiple-intake wording and calendars mixing families hold the row; opt-in per provider, shadow first, 30-row audit, then one provider at a time. Levels (272): all study levels; `calendar.university_levels` left unchanged because it belongs to the retiring college-defaults job (off since 22 Oct), which stays off.

**Safeguards found missing in the live planner (built inside Rule B):** no hold for rolling or "multiple intakes" wording on a course page (the planner's "rolling" refers to rolling application deadlines); calendars approved before the qualifier (9 Nov) are not re-checked for calendar families.

## 13. Rules A and B released; calendar status; activation one provider at a time — 11 November 2026

**Rule A (Decisions 270, 270a; Pilot #1003, #1008).** Reader `calendar-v2.3`: a start printed without a year takes it from its table column, a range heading over unlabelled columns (with weekday and academic-period evidence), the section, or the address; a printed weekday must agree; a column-resolved teaching start stands for its whole row. Live: Monash `summary-dates` approved 11 Nov 09:25 AEDT (Semester 1 = 1 Mar 2027, Semester 2 = 26 Jul 2027); RMIT 2027 and UNSW Term 1 2027 resolved.

**Calendar status (Pilot #1009).** Adapters › "Academic calendars by provider" (`public.admin_calendar_status_read`, read only): each provider with intake rows waiting for a date, its status (approved 2027; 2027 read, not approved; earlier edition only; stored, no 2027 start; read failed; none found), rows waiting and the latest qualifier verdict. 11 Nov: 8 / 17 / 0 / 40 / 8 / 0 providers. Course pages supply the month (7,472 of 9,365 month-only rows come from course pages); the approved calendar supplies the day.

**Calendar re-read.** `batch.calendar_reread` 20 → 100 (maximum 60 → 100), stored copies only. Measured: the first run took 60 because the worker capped the call at a fixed 60; worker v0.67.0 (Pilot #1012) passes the setting through.

**Rule B (Decision 271; Pilot #1010 shadow, #1011 planner).**

| Item | Detail |
|---|---|
| Rule | Where the course page names no study period: the one main-teaching start in the stated month, else the one within `intake_dates.nearest_start_days` (35) after the 1st. Rule `calendar-v3-nearest-start` |
| Never | Research degrees; rolling, flexible or continuous wording; a calendar line naming applications, census, orientation or enrolment; a blocked period word; a value withdrawn before; a differing full date on the course page; a course whose other intake months have no single main-teaching start or share the date |
| Who | Providers listed in `intake_dates.nearest_start_providers` only (ships `[]`). `intake_dates.month_unique_match` stays 0 (P0 IQ-00313) |
| Shadow | `pipeline.intake_nearest_start_shadow`: Monash 502, RMIT 475 would fill, none ambiguous; all providers 1,550 would fill, 524 ambiguous, 413 research degrees, 3,377 no future start yet |
| Audit | 40 rows: 21 right (Monash, RMIT 12/12), 10 unproven, 9 wrong; guards added for the wrong patterns |
| Dry run | Monash listed, rolled back: 381 filled by Rule B, 35 held by the course-level check |

**Switching Rule B on for a provider (Platform Admin; Operating Model v1.11).**
1. Open Settings › Pipeline settings, section Intake dates, setting "Intake dates: providers using the nearest start".
2. In "Add a provider", type the first letters of the university's name (for example `monash`) and pick it from the matches; it is added as a named chip. No provider id is typed (Pilot #1021: list settings of provider ids are chosen by name; the setting still stores the ids).
   **From 11 Nov 2026 (Decision 275) the usual route is Layer 2/3 Operations › Process results › "Nearest start (Rule B): which universities qualify": the platform tries every university (job `intake-rule-b-qualify`) and "Approve all qualified" adds every university that passed, in one recorded update with a reason. "Check now" queues one university or all. Steps 1 to 2 remain for an exception.**
3. Reason: `Decision 271: Rule B for Monash; shadow 502 rows, audit 12/12; scoped lift of P0 IQ-00313 for Monash only`. Save.
4. Leave "Intake dates: a month takes the date of the only start that month" (`intake_dates.month_unique_match`) at 0.
5. The next `intake-dates-apply` run (hourly at :26) plans Monash's rows again; about 381 dates fill over the following runs (200 rows a run, shared across universities). The agent then verifies filled against predicted and re-checks a sample against the official pages.
6. To stop: remove the provider's chip with its × (an empty list shows "Empty means none"; accepted from Pilot #1012, migration 20261111140000). New fills stop at the next run; filled rows go through the governed withdrawal.

**Monash switched on (11 Nov 2026 12:20) and validated.** 381 Rule B dates exactly as the shadow predicted (1 Mar 2027, 26 Jul 2027). Found and fixed on the way: the hourly apply timed out on the search writer lock (Pilot #1013); a type error in the Rule B helper (Pilot #1015); the named-period route took a later year's start for "Semester one (February)" (47 values, withdrawn; Pilot #1017). The hourly job serves rows with a page date first, so a newly listed provider is planned with the apply's own bounded mode for that provider's courses (`security.intake_dates_apply_v1(limit, course_ids)`).

**RMIT switched on (11 Nov 2026 14:37) and validated.** First pass: 14 Rule B dates against a shadow of 475, because the RMIT adapter kept only "adapter pattern: February" as the page wording, so the offering check held 445 rows ("the course page does not state February as an intake"). Fixed in Pilot #1020/#1022: coverage-sweep worker v0.68.0 keeps the page's own words around the adapter's reading ("... Next intake: February, July"; RMIT's 299 stored pages read again by the adapter, no Firecrawl), and `intake_dates.nearest_start_hold_levels` stops Rule B dating vocational and pathway levels (Certificate I to IV, Diploma, Advanced Diploma, vocational short course, Non AQF Award, Foundation), which follow their own calendar. RMIT was paused from the list for the minutes between the re-read and the hold going live (#1020's migration collided with #1019's version and was re-issued as 20261111235900 in #1022). Result at 15:4x: 401 RMIT intakes dated by Rule B (221 February -> 1 Mar 2027, 180 July -> 19 Jul 2027), all higher education (bachelor, honours, associate degree, graduate certificate and diploma, coursework masters); 56 vocational and pathway rows held; no research degree; no other provider touched; none published yet. One University Pathways Fast Track date (January -> 4 Jan 2027, course unpublished) could not be withdrawn: the first withdrawal's hold lock on the same course blocks the second. Clear it on the course's edit screen, or leave it while the course stays unpublished.

## 14. S2-Intakes — Next-year named July intake matching decision (13 November 2026)

**Platform Admin decision (S2-Intakes, 13 November 2026): APPROVED WITH GUARDS.** Correct the existing source-grounded planner so an explicitly offered, continuing **July / Semester Two** intake can match the **next eligible year's July teaching start**, instead of being skipped merely because February / Semester One of that year occurs earlier. This is a targeted correction to **intake-period identity and annual rollover**, not blanket permission to assign a university-wide date to unproved course offerings or reinterpret an intake with an explicitly stated past year.

**Affected reported cohort:** 116 held candidate July rows: University of Canterbury 110 (approved Semester Two 2027 lecture start **19 July 2027**) and Massey University 6 (approved Semester Two 2027 semester/lecture start **12 July 2027**). The reported 116 are **candidates, not 116 guaranteed admissions**. Existing live-reported baseline: Canterbury 151 exact starts (149 on 22 February, 2 on 19 July), Massey 11 exact starts (10 on 22 February, 1 on 12 July); NZ exact starts increased 82→244 in the previous session. Keep each figure timestamp-qualified in the current F-INT execution record. Official calendars: `https://www.canterbury.ac.nz/study/study-support-info/dates-and-timetables/key-university-dates` and `https://www.massey.ac.nz/study/key-dates-for-semesters-exam-periods-other-events/`.

**Required admission invariants:**
1. **Period/month first, year second:** for an intake row whose proven course-page wording names July (including "Semester 1 or 2 (February or July)"), resolve the **July/Second Semester** offering to a verified July teaching-start row. Do not choose February merely because it is chronologically earlier. February remains a separate February row; same academic year may contain two independent intakes.
2. **Next future annual occurrence only:** use the next valid official calendar edition and named teaching period after the requested current/past window *only* when the current official course source proves ongoing/recurring applicability or the course's distinct new-year offering. An explicit past-only year, discontinued course, cancelled round, source only describing 2026, or stale/unproved next-year course offering must **not** be silently converted into a 2027 intake.
3. **Existing truth gates unchanged:** exact course/provider/CRICOS identity, proven offering, campus/level/audience, programme calendar family, verified official start and calendar qualification, source year/quote, edition and time zone, manual locks and prior withdrawals. Preserve researched/flexible/rolling and vocational/pathway exceptions, non-standard calendars, page identity conflicts and ambiguous multiple-period cases. A course with an explicit own start date retains that date over general calendar inference.
4. **Event and date-type separation:** do not turn applications-close, orientation, exams, enrolment, add/drop, refunds or a generic date mention into an intake. The separate **ten source-month anomalies** (nine Massey, one Otago) extracted from "Applications close on 19 February" require a course-page parser/source correction and must not become eligible from this rollover rule.
5. **Narrow engineering change:** inspect the existing planner's year/period selection and rejection reason; change the shared owning comparison, not a new parallel rule, job, blanket setting, per-provider exception list or generic "nearest future start" fallback. A source-backed explicit period may be used only when it is unambiguous, even if a calendar also lists exam periods.
6. **Proof before release:** rolled-back simulation on exact 116 IDs, per-provider before/after values, targeted regressions for July 2026 passed → July 2027 where recurring, February vs July, explicit old-year no rollover, unsupported 2027, alternative/nonstandard calendar, course identity/campus mismatch, application deadline as month, manual lock and unaffected providers. No source or admission integrity regression; exact-head CI, guards, single integration release and downstream Website v3/Zoho v3 read-back.
7. **Real completion:** report candidate rows, newly admitted **retained** July 2027 dates, correctly held and exact reasons, withdrawals/corrections, official evidence for each date, actual scheduler runtime and consumer parity. The change does not satisfy F-INT.07/.08 until separate proposed deadline-status/source fields and useful optional Admin columns/filters are implemented and verified.

**This recorded scoped approval covers development of the above rule correction through the normal release route.** It is not a new budget, automatic provider-policy switch, permission to modify frozen consumer v2, authorisation for unsupported annual assumptions, or a request to start an unrelated on-demand Firecrawl campaign.

### Outcome of next-year July decision — 13 November 2026

**Release:** Pilot [#1120](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1120), migration `20261113331500`, regression `s542`, reported merged/deployed and confirmed by independent read-only Supabase data check. The scoped, reversible setting `intake_dates.next_cycle_period_providers` lists Canterbury and Massey, and the existing `security.intake_dates_plan_v3` matches only a candidate's relevant calendar period for the named month, without altering unrelated provider fingerprints.

**Observed outcome, confirmed at the active canonical level:** the 116 candidate July rows were processed and source-backed dates retained: **110 Canterbury → 19 July 2027; 6 Massey → 12 July 2027; 0 held among the candidate set**, with prior July date totals 2→112 at Canterbury and 1→7 at Massey. Independent read-only query of all matching providers confirms **261** exact start-date rows at Canterbury and **17** at Massey. Countrywide `catalogue.course_intakes` for active courses/intakes shows **NZ 360/4,258** with exact starts; **AU 4,469/24,228**; **CA 0/2,955**. The session reports complete Website v3 and Zoho v3 read-back (116/116 each), 0 withdrawn/changed, no Firecrawl or AI for the on-demand planner run, and four successive clean hourly runs, latest ~70 seconds. API read-back is based on the session report, not independently repeated from an authenticated consumer endpoint by this separate reviewer.

**Regression result reported in #1120:** the other 301 Canterbury/Massey candidates unchanged; the ten identified application-deadline-derived intake rows remain undated; 300 rows from 40 other providers keep identical decisions and fingerprints. Source identity, locks, campus/level, audience, explicit-year/withdrawn history, nonstandard calendars and other policies remain in force.

**Next P0 intake reader integrity:** at least **nine Massey and one Otago** recorded months may be derived only from `Applications close on ...` quotations, despite lacking legitimate course-commencement proof. Independent query also found additional candidate intake records with application-only `page_quote` snippets for other months and providers; those are audit candidates, **not automatically proven invalid** without examining their other official offering evidence. Correct the shared producing **course-page extraction / AI month parser**, including `security.enrich_parse_intakes_v1` and any actual worker/adapter source, so an application deadline cannot become an offered intake. Keep separate valid deadline extraction; preserve genuine start-month evidence if independently present. Examine all existing affected records by ID and source, prevent re-admission of the same unsupported quote, and use the governed repair/withdrawal workflow for bad month rows with appropriate locks/approvals. Regression fixtures: application-only wording, mixed application + valid study start, year heading and separate offer, "applications close for study next year", valid rolling or nonstandard offerings, identity/edition and negative unchanged rows. Verify resulting canonical course/intake list and Website/Zoho v3 search/detail/sync after correction.

**Remaining F-INT.07/.08:** new v3 deadline status, actual source URL/edition/time zone where stored and useful optional Intake Run & Validate / Course Catalogue / Data Delivery columns and filters remain **not delivered**. Coordinate shared API v3 functions with S2-CF integration owner; v2 remains frozen. Do not count the successful July fix as completion of developer deadline or UI requirements.
