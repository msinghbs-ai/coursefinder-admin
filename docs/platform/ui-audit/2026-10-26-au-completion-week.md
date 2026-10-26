# AU completion week (expedited)

Date: 26 Oct 2026 (AEDT), opened 17:0x
Mandate: Platform Admin, 26 Oct 2026 17:01, "AU completion wave, EXPEDITED". This is the week's primary track.
Change control: CF-CHG-20260915-247
Standing rules: rule 9 (merge own PRs when the suite is green), rule 10 (lodge before replying), G2 (settings-keyed), G3 (consumer API frozen), G4 (tests governed). Destructive and consumer-API changes go to the Platform Admin as paste files and are never auto-merged.

## 1 Baseline (26 Oct workbooks, `docs/platform/reports/2026-10-26/`)

| Measure | 26 Oct |
|---|---|
| AU active courses | 26,103 |
| All 11 core fields complete | 5,435 (20.8%) |
| In automatic work (finish held by intakes, est. 3 Jan 2028) | 324 |
| Blocked: provider unpublished | 10,706 |
| Blocked: value not on the course page (fee schedules, English policies, calendars) | 9,335 |
| Blocked: Layer 4 review | 290 |
| Blocked: website unknown | 11 |
| Blocked: register has no value | 2 |
| No reader yet | description, academic entry requirements, application deadline |

Field rates: English 64.8% (est. 2 Nov), international tuition 31.6% (30 Dec), official page 71.3% (24 Apr 2027), intakes 36.0% (3 Jan 2028; no measurable progress in the last 7 days). Duration, study level, field of study and open-to-international are complete; campus 99.9%; registered tuition 99.3%.

## 2 Week outcome targets (re-run Thursday, report all three)

| Outcome | Baseline | Target |
|---|---|---|
| All 11 fields complete | 5,435 | 7,500–9,000 |
| In automatic work | 324 | 8,000+ (the real deliverable) |
| Can't date | 20,344 | under 10,000, every remaining row with a named cause and owner |

The completed count lags as lanes fill. Pace is reported as measured; no date is promised that the arithmetic does not support.

## 3 Step status

| Step | What | Status | Detail |
|---|---|---|---|
| 1 | Register-sync fix: CRICOS end dates recorded | **done**: v2.15.358 merged (#703), post-fix verification passed | section 4 |
| 2 | Eligibility re-run, then ONE count-guarded publish paste | **ready for 08:00**: `docs/platform/pastes/PASTE-20261026-au-publish-eligible-providers.sql`, 1,056 providers | section 7 |
| 3 | Fee reader AU scope + AU fee-schedule discovery overnight | **running but blocked by policy**: AU's tuition proof list is empty (decision needed) | section 10 |
| 4 | MARK-FILE: AU English-policy and calendar approvals | **lodged**: `docs/platform/reports/2026-10-26/AU-policy-approvals-MARK-FILE.xlsx` | section 6 |
| 5 | Description reader: build started | **started**: draft branch `cf247-provider-description-reader` (not for merge yet) | section 9 |
| 6 | Entry-matrix reader: AU top 20 switch staged, off | **staged** (#704, live, off) | section 9 |
| — | Workbook generator as a catalogued weekly job (Fridays) | pending (Tuesday) | section 9 |

## 4 Step 1: register-sync fix (decisions before code)

### What the live data shows (checked 26 Oct 17:2x)

- The CRICOS register is current. The source check at 25 Oct 23:41 UTC found the publisher's file unchanged since the 30 Sep edition (hash `5eaf3ef2…`, 25,540 active courses, 431 expired). Next monthly ingestion is 18 Nov.
- The 30 Sep run found **563 courses no longer on the register** and stopped at its safety limit (511). Its retirement has been **held for a Platform Admin approval since 30 Sep** (run `b8a541af…`, Layer 1 operations). Those 563 courses are still active in the catalogue.
- Nothing records an end date. All 1,556 CRICOS provider registrations read `active` with no `valid_to`. That is why "deregistered" could not be separated from "current" on 25 Oct.
- What the 30 Sep edition says about the AU catalogue (active providers, active courses):

| Group | Providers | Active courses | Not on the register any more |
|---|---|---|---|
| Published, every course on the register | 201 | 12,266 | 0 |
| Published, some courses gone | 22 | 2,662 | 172 |
| Published, no course on the register | 1 | 2 | 2 |
| Unpublished, every course on the register | 1,068 | 7,067 | 0 |
| Unpublished, some courses gone | 249 | 4,078 | 361 |
| Unpublished, no course on the register | 5 | 28 | 28 |

### Decision: what "ended" means and where it is recorded

- **A CRICOS course registration has ended** when its course code is not in the latest accepted register edition. Its `valid_to` is the last date a register edition listed it. CRICOS publishes no end date of its own, so this is the closest true date; it is stated as "last listed" wherever it shows.
- **A CRICOS provider registration has ended** when none of its courses is in the latest edition. Status `ended`, `valid_to` = the last date any of its courses was listed. A provider that comes back (a course listed again) is restored: status `active`, `valid_to` cleared. Nothing is deleted.
- Recorded in `catalogue.provider_registrations` and `catalogue.course_registrations` (`valid_to`, provider `status`). The existing mirror trigger copies the provider dates to `catalogue.provider_identifiers`.
- **Consumer API:** no shape changes. Zoho reads the CRICOS code from `provider_registrations` and orders by status only among `inactive / cancelled / archived`. `ended` is outside that list, so Zoho's output does not change. The website does not read registration dates.
- **Course retirement stays where it is.** The 563 held courses are not retired by this change. Retiring them is the existing Platform Admin approval; it is offered as an optional part of the publish paste (step 2).
- **Safety guard:** nothing is ended when the latest edition lists less than `layer1.register_end_dates_min_share` (0.9) of the tracked course codes, so a truncated file cannot end hundreds of registrations.
- **Ongoing:** job `layer1-register-end-dates` (daily, catalogued) re-applies the rule after each edition; every run is recorded in `pipeline.register_end_date_runs`.
- Scope: CRICOS (AU) tonight. NZQA departures use the seen-tracking path and are not changed.

### Decision: eligibility for the publish paste (step 2)

An unpublished, active AU provider is **eligible to publish** when all hold:

1. its CRICOS registration is current (not ended) and at least `publish.eligible_min_current_courses` (1) of its courses is on the latest edition;
2. its site answers: provider discovery `mapped`, with at least `publish.eligible_min_site_pages` (1) course page kept.

Live dry run (26 Oct 17:1x, rolled back): 1,372 course end dates (563 last listed 28 Sep; 809 already retired, found gone 27 Sep), 16 provider registrations ended (6 with no course on the register, 10 archived including UniSA and the old University of Adelaide), 1,540 current. A second run in the same transaction changed nothing. Eligibility: 1,056 providers / 9,454 courses to publish; 266 held with a cause.

Every other unpublished AU provider gets a named cause and owner: registration ended (owner: register; nothing to publish), no website on record (owner: website check), site gave no course pages (owner: discovery review), site not checked yet (owner: discovery). The check is a read-only function, `security.au_publish_eligibility_v1()`.

## 5 Step 3: fee reader AU scope (done 17:1x, overnight running)

**Decision.**
- `fees.countries` gains AU.
- `fees.provider_types` gains `higher_education_institute` and `university_college`. Both exist only in AU (136 and 8 published providers).
- `private_vet` and `school` stay out tonight. The setting is shared with NZ, and adding `private_vet` would also start NZ's 383 private providers.
  - AU's private_vet and school providers are unpublished anyway, so automatic work skips them until the publish paste is applied.
  - Widening the setting to them is a Tuesday decision, with the numbers (section 8).
- Both changes are logged in `admin_control_events` under the mandate.

**First 15 minutes (the NZ precedent was 338 schedule pages in 15 minutes):**
- 217 new AU fee-schedule pages were found by the central-page search.
- 267 stored AU fee pages are queued for the AI fee reader. These are the CRICOS-code reader's 543 pages, most of them "no values" for that reader. 40 have been read already.
- 94 AU fee rows have been read so far.

**Spend, against the existing stops:**

| Measure | Used | Limit |
|---|---|---|
| Firecrawl credits today | 884 | 25,000 |
| Central-pages share of Firecrawl | well inside | 2,500 |
| Fee reader AI | US$0.11 for 15 pages (about US$0.0074 a page) | US$5 a day |

- The new pages are fetched by job `provider-facts` under the central-pages share. 217 pages is well inside that share.
- AI cost: about 480 pages × US$0.0074 is about US$3.60, inside the cap.
- If the queue grows past the cap, the reader stops at US$5 and resumes after midnight AEDT. That is the existing stop working as designed, not a throttle. It is reported at the next check with numbers.

## 6 Step 4: MARK-FILE (lodged)

File: `docs/platform/reports/2026-10-26/AU-policy-approvals-MARK-FILE.xlsx`. It holds every AU proposal waiting today, 35 rows:
- 5 English policies;
- 30 intake calendars.

Columns: provider, proposed value, courses filled if approved now, courses at the provider still missing the field, evidence quote, system check, proposal id. Mark column B approve or reject.

**Plain finding: this file fills few courses now, 27 at most.**
- English: 10.
- Calendars: 17.

Why so few:
- 4 of the 5 English defaults will be **refused by the system's own check**: the default disagrees with most of the provider's course pages.
  - Deakin: 0 agree, 239 differ.
  - CSU: 5 agree, 49 differ.
  - ECU: 75 agree, 78 differ.
  - Excelsia: 12 agree, 24 differ.

  Those rows are marked "recommend reject".
- Most calendars either have no "trimester / semester / term 1" period (no default months) or are for providers whose courses have no bound official page yet.
- Several calendars carry only 2023–2025 dates; those are marked "likely out of date".

**How the marks are applied:**
- one row at a time, through the same decision as the Policies screen;
- count-guarded: the total applied must equal the marks, or nothing is applied;
- logged under the Platform Admin with the note "MARK-FILE 26 Oct 2026".

## 7 Step 1 merged; step 2 publish paste ready

**v2.15.358 merged under rule 9 as #703 (`3e31bacd`).**

Before the merge:
- full local suite: 1,001 passed, 0 skipped, 0 failed;
- the new objects were confirmed absent live (no existing function is edited);
- the live dry run was run twice; the second run changed nothing.

**Post-fix verification, against live, before any paste existed:**
- `deploy-on-merge` applied `20261026004000`; its history md5 `c9bdaeb0` matches the file.
- Release currentness passed (v2.15.358).
- Both function bodies are live byte for byte (md5 `da069bff…`, `9af271a1…`).
- First run:
  - 1,372 course end dates (563 last listed 28 Sep; 809 found gone 27 Sep);
  - 16 provider registrations ended, mirrored to `provider_identifiers`;
  - 1,540 current.
- Consistency: 0 ended providers with a listed course, and 0 current providers with no listed course.
- AU active courses unchanged at 26,103. Job catalogued and active.
- The 16 ended providers:
  - 10 archived (incl. UniSA and the old University of Adelaide);
  - 5 unpublished: Nova Institute of Technology, Advance English, Infiniti College, Girton Grammar School, St Peters International College;
  - **1 published: Inspire College**. It has 2 active courses, both off the register since 28 Sep. They leave with the held retirement below.

**Eligibility re-run (after verification):** 1,322 unpublished AU providers.

| Verdict | Cause | Owner | Providers | Courses |
|---|---|---|---|---|
| Publish | registered and site answers | Platform Admin: publish paste | 1,056 | 9,454 |
| Hold | site gave no course pages | Discovery review | 147 | 1,101 |
| Hold | no website on record | Website check | 104 | 564 |
| Hold | site not checked yet | Discovery | 10 | 26 |
| Hold | CRICOS registration ended | Register: nothing to publish | 5 | 28 |

**The paste:** `docs/platform/pastes/PASTE-20261026-au-publish-eligible-providers.sql`.
- One transaction, publishing exactly 1,056 providers. Provider id-list md5 `a37d52ad…`.
- Guard 1: every provider is still unpublished and eligible at apply time.
- Guard 2: exactly 1,056 rows change, or everything rolls back.
- It writes the manual edit log, one search refresh and one control event.
- **Verified by a rolled-back dry run on live:**
  - 1,056 published;
  - AU hidden providers 276 (the 266 held + 10 archived);
  - AU active courses under published providers go from 14,930 to **24,384**.
- It is the Platform Admin's to apply. The agent never applies it.

**Separate, the Platform Admin's: the held retirement.**
- The 30 Sep register run left 563 courses that are no longer on the register still active (run `b8a541af`, held over the automatic limit).
- 318 of them sit under providers in the paste, so publishing makes them visible until the retirement is approved.
- The approval is the existing Layer 1 operations "approve departures" action. It is not in the paste, because it retires courses and the mandate asked for one publish paste.

## 8 Tuesday 08:00 readiness

| Item | State |
|---|---|
| Publish paste | Ready, verified (section 7). After you apply it, I verify every row against the list and record the counts here |
| Entry-matrix reader, AU top 20 | Staged live (#704): `entry.providers` holds the 20, the gate honours it, 0 providers enabled. On your confirmation: `entry.matrix_enabled` 1 and job `entry-matrix-read` active |
| Fee reader AU | Running overnight; morning numbers in section 5 |
| MARK-FILE | Waiting for your marks; applied count-guarded on return |
| Layer 4 first runs | 60 waiting; six shape leaders to approve still unlock the rest (auto-admit record) |
| Decision Tuesday | Whether `fees.provider_types` adds `private_vet` and `school` once the paste is applied: it brings AU's ~1,000 newly published private providers into the fee reader, and NZ's 383 private providers with them |

## 9 Steps 5 and 6, and the workbook job

**Step 6, merged under rule 9 as #704 (`7a6f73cd`).**
- Before the merge:
  - suite 1,003 passed;
  - the live md5 of `security.entry_matrix_enabled_v1` was `a238a2c2…`, matching the guard;
  - the live dry run with the switch simulated on gave exactly 20 providers and NZ 0.
- After the merge:
  - history md5 `59df4a0c` matches the file;
  - the edit is live;
  - `entry.providers` holds 20, `entry.matrix_enabled` is 0, and the job is inactive.
- **0 providers are enabled now.** This is the Platform Admin's switch on Tuesday.

**Step 5, description reader: build started.**
- Draft branch `cf247-provider-description-reader` (migration `20261027001000`, not merged) holds:
  - the settings (`description.enabled` 0, 400 characters, banned words, pinned model, AU universities);
  - `pipeline.provider_descriptions`;
  - the queue;
  - the worker interface. The record function re-checks every rule itself: length, words not allowed, at least one quote, quotes on the stored page.
- Reality versus the spec (doc-as-code):
  - the about page gets its own table, rather than a new kind in `provider_fact_sources`, because that check constraint cannot change without a drop;
  - provenance lives in that table, not in new columns on `catalogue.providers` (G3).
- Still to build:
  - the `provider_description` worker mode, patterned on `entry_ai`;
  - the AI spend guard row (`security.ai_spend_today_v1`, md5 `f18af72f…`);
  - the inactive job;
  - test s125.
- It lands Wednesday with the Wollongong acceptance test.

**Workbook generator as a weekly job:** Tuesday. Proposed shape: a scheduled GitHub workflow on Fridays that runs the two generators against live and commits the workbooks to `docs/platform/reports/<date>/`, catalogued in `pipeline.automation_catalogue`.

**Fee reader at 18:3x (step 3, overnight):**
- 153 of 267 stored AU fee pages read;
- 194 rows admitted, 27 to Layer 4, 20 conflicts, 93 with no matching course;
- fee AI spend US$0.55 of 5;
- Firecrawl 908 of 25,000.
- The 231 newly found schedule pages are fetched by job `provider-facts` at 20 pages every 10 minutes (`batch.provider_facts_read`), so about 2 hours. No setting was changed.

## 10 Progress check, 26 Oct 19:1x, and a correction to step 3

**Field rates (coverage snapshot 18:47). No measurable movement yet; none was expected before the paste:**

| Field | Baseline | Now |
|---|---|---|
| English | 64.8% | 64.8% (16,917) |
| International tuition | 31.6% | 31.7% (8,286) |
| Official page | 71.3% | 71.3% (18,622) |
| Intakes | 36.0% | 36.0% (9,390) |
| Delivery | — | 63.5% |
| Description | — | 0.6% (163) |
| Academic entry, deadline | — | 0% (no reader yet) |

AU published providers: 224 (the paste is not applied yet).

**Correction: the fee reader's AU output is not reaching the catalogue.** I reported step 3 as "running" at 18:3x. The reader runs, but its results are held. The cause is a policy setting, not a fault:
- `coverage_admission_countries.identities->'tuition'` for **AU is an empty list**. It was set that way when AU tuition was taken only from the CRICOS register (registered tuition, 99.3%). NZ and CA have their lists.
- **Effect 1:** every AU fee the reader admits is written unverified with a Layer 4 item, by the apply-time identity check (R1, `identity_basis_reverify`). Since 17:16 that is **436 AU Layer 4 items across 23 providers**:

  | Proof on the course's bound page | Items | Providers |
  |---|---|---|
  | CRICOS code | 395 | 19 |
  | Exact title | 33 | 10 |
  | Adapter code or title | 8 | 1 (Flinders) |

  International tuition moved by +37 courses only. The Layer 4 queue is now 782, up from about 320.
- **Effect 2:** `security.tuition_chase_enabled` is false for every AU provider. So the **243 new AU fee-schedule pages found tonight are never fetched**: job `provider-facts` skips them. My "about 2 hours" estimate in section 9 was wrong.
- No live fee was removed or changed. Spend so far: fee AI US$1.04 of 5; Firecrawl 960 of 25,000.

**Decision needed (Platform Admin): which proofs AU accepts for international tuition.**
- Recommended: `cricos_code`, `adapter_code`, `manual`. A CRICOS code on the page is AU's strongest identity proof; it is already accepted for AU English, intakes and official page.
- Optionally also `exact_title` and `adapter_title`. These are the same as for AU English and intakes, but carry more risk for money values.
- Once set:
  - the schedule pages start reading (20 every 10 minutes);
  - new fees go live through the normal checks (confidence, title similarity, outlier ratio, no conflicting fee);
  - the 436 held items need a count-guarded re-apply. I prepare it as a paste after your decision, because it writes live fees in bulk.
- Until you decide, I leave the reader running. Its results stay in Layer 4, which is safe but adds review load. The alternative is to switch AU back out of `fees.countries` tonight; say if you want that.
