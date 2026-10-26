# AER v1.1 (academic entry requirements): build log

Mandate: Platform Admin, 26 Oct 2026 21:26, "AER (Academic Entry Requirements) v1.1 Design". Stand-alone, additive, 8 weeks. Pilot: RMIT, UTS, Victoria University, Federation University, Western Sydney University; 79 countries; acceptance is a row-by-row diff against the 24 Oct 2026 customer spreadsheet.
- Standing rules apply: suite-green before merge, lodge before reply, decisions before code, settings-keyed, G3, G4.
- Updated weekly.
- Design lineage: `ENTRY-REQUIREMENTS.md` (draft 1.1) and `ENTRY-REQUIREMENTS-IMPLEMENTATION.md` (Track C).

## Week 0 (26 Oct 2026, 21:3x): decisions before code

No code tonight. This entry reconciles the mandate with what is already live, because much of AER v1.1 already exists as Track C step A (#695, v2.15.355, 26 Oct). Building it again would leave two parallel models; the housekeeping rule allows one approach at a time.

### 1 What already exists (live, empty, reader off)

| AER v1.1 item | Live today | Gap to v1.1 |
|---|---|---|
| Table `provider_entry_matrix` | `catalogue.provider_entry_matrix`, 0 rows | Has `provider_id`, `course_id` (null = provider-wide), `country_code`, `qualification_name`, `min_grade` (+ numeric `min_value`), `grade_scale`, `conditions` jsonb, `edition`, `as_at`, `source_url`, `quote` (mandatory, ≤ 300 characters), `provenance`, `status`, `benchmark_band`, `matrix_kind`, `level_label` / `study_level_id`. **Missing:** `routes` jsonb, `valid_to`, `withdrawal_reason` (today `status_reason`), `row_hash`, `version`; status vocabulary differs (see section 2) |
| Table `course_entry_requirement` | `catalogue.course_entry_requirements`, 0 rows | Has `kind`, `min_grade`, `status`, `quote`, provenance. **Missing:** `subject`, `min_level`; v1.1's kinds (`prerequisite`, `selection_task`, `portfolio`, `audition`, `interview`) differ from the live check (`subject_prerequisite`, `portfolio_interview`, …): map, do not rename |
| Discover / store before extract | `pipeline.entry_matrix_sources`, stored copies; direct read with robots.txt respected, Firecrawl only when refused; replay from storage; an unchanged page (same hash) is never read twice | Matches. The edition probe (weekly hash check) is a schedule on top |
| Extract with a quote | Worker mode `entry_ai` (v0.48.0), pinned model `entry.matrix_model`, quote-on-page, `entry.matrix_min_confidence` 0.85 | Per-pattern prompts (band ladder / per course / generic postgraduate) still to map |
| Human gate | Layer 4 kinds `entry_matrix_first_run` / `entry_matrix_change`, `entry.matrix_first_run_review` 1 | 20% sampling audit (v1.1) not yet; the review card needs the quote beside the stored copy, threshold highlighted, splits expandable |
| Scope switch | `entry.matrix_enabled` 0; `entry.providers` staged with the AU top 20 (#704); job `entry-matrix-read` inactive | Federation is not in the top 20 |

### 2 Decisions proposed (needed before the schema PR)

| # | Topic | Proposal | Why |
|---|---|---|---|
| D1 | Tables | **Extend** the two live tables with additive columns (`routes`, `valid_to`, `withdrawal_reason`, `row_hash`, `version`; `subject` and `min_level` on course rows). No new tables of the same name, no rename | The names collide; the mandate requires additive-only |
| D2 | Status | Keep the live vocabulary (`proposed`, `active`, `unverified`, `superseded`, `inactive`). Map v1.1 `quarantined` to `unverified` + reason and `withdrawn` to `inactive` + `valid_to` + `withdrawal_reason`, or add `quarantined` / `withdrawn` to the check | Changing a check constraint needs a drop and re-create, which migrations may not do (it would come as a paste). Your call: map (recommended) or paste |
| D3 | Study level | v1.1's enum `foundation \| diploma \| bachelor \| postgrad` has no masters or PhD, but the admin grid shows Masters and PhD columns. Proposal: keep `study_level_id` (the platform's study levels) plus `level_label` as published, and add `masters` / `doctorate` to the AER level set | The UI mock-up and the enum disagree |
| D4 | Row identity | v1.1 says editing a condition keeps the identity, but the hash includes "sorted conditions JSON", which changes it. Proposal: `row_hash` = SHA-256 of provider + country + level + band + course_id + the **condition keys** (board / era names, sorted), not their values. Editing a grade bumps `version` (delta); adding a board is a new identity (seed) | Makes the two stated rules consistent |
| D5 | "Staging" | There is no staging database. The org's other project, `coursefinder-demo`, is never targeted. Proposal: weeks 1–2 deploy additive and switched off to the live project, as every CF-247 change does: no rows written, no feed change, settings at 0 | The mandate says staging and no production writes |
| D6 | Consumer feed | Adding an `entry_matrix` collection to the website / Zoho feed is a consumer API change (G3). It needs your explicit approval recorded in the migration, the baseline re-taken and the developer guide reissued, and comes to you as a paste-reviewed PR. **Not before week 8**, as in your timeline | CF-247: consumer-API changes are yours |
| D7 | Zoho Creator form | The counsellor form is built in Zoho Creator by the Zoho developer, not on the platform. The platform delivers the feed, the 5-rule order as a documented reference implementation (about 30 lines, with fixtures), and the admin grid | Consumer owns resolution and display (your split) |
| D8 | Register clock | v1.1 has register sync weekly (Mon 02:00). You decided monthly for CRICOS and NZQA on 8 Oct; CRICOS publishes about monthly. Proposal: keep monthly ingestion, add a weekly cheap freshness check (the publisher hash, already done by the 30-day verification), and run the new end-date job (v2.15.358) daily as now | Avoids silently overturning an earlier decision |
| D9 | Tuesday's top-20 switch | Your 21:12 plan switches the entry-matrix reader on for the AU top 20 Tuesday about 08:30. AER v1.1 week 1–2 says "no production writes". Rows from the reader land `proposed` and reach nobody until a person approves them in Layer 4. Choose one: **(a)** go ahead Tuesday with the top 20 (pilot data comes earlier, nothing reaches consumers); **(b)** switch on for the 5 AER pilot providers only (set `entry.providers` to the 5; Federation added); **(c)** hold until the schema PR lands | The two mandates conflict on this point |
| D10 | Contract test | "s125 pattern for entry_matrix": a table-level gate (as for fees) puts every write of an `active` matrix row through the same checks: quote present, source page stored, run approved in Layer 4 or a person's write. Plus tests: no hard delete (withdrawn rows keep `valid_to` + reason), and a delta holds only changed rows (`version` / `row_hash`) | As mandated |

### 3 Missing input (red)

- **The 24 Oct 2026 customer spreadsheet is not in the repo or the project.** It is the pilot's ground truth (79 countries, acceptance diff). Please attach it, or say where it lives. Until then the diff harness can be built but not run.

### 4 Plan, once D1–D10 are settled

| Week | Platform work | Gate |
|---|---|---|
| 1–2 (from 27 Oct) | Schema PR: the additive columns (D1, D4), indexes (`row_hash`; `status`; `(provider_id, country_code, study_level, benchmark_band, status)`), table gate and contract tests (D10), generated TypeScript types; per-pattern prompt config; diff harness against the spreadsheet | Your schema review (additive only) |
| 3–4 | RMIT band ladder: first runs to Layer 4; review card (quote beside stored copy, threshold highlighted, splits expandable, URL clickable); 20% sampling audit setting | Your reader-config and Layer 4 mock-up sign-off |
| 5–6 | UTS (per course) and VU (postgraduate by country); diff report #1 | Customer diff #1 |
| 7 | Federation and WSU; full 5-provider diff | Customer sign-off |
| 8 | Feed collection (D6, with your approval), seed and delta; admin grid; reference resolver for the website and Zoho developers | Your feed integration check |

**Status:** week 0 — decisions lodged; awaiting D1–D10 and the spreadsheet.

## 26 Oct 2026 21:3x: sprint mandate received (AU wave + AER pilot, Tue 27 Oct to Fri 7 Nov)

Mandate: Platform Admin 21:29. The 8-week AER timeline is compressed into a 10-working-day sprint.
- **The file as received ends mid-sentence:** "THURSDAY 29 OCT (Day 3): … 12:00: Victoria University reader config mapped (post". Days 3 (from 12:00) to 10 are missing; please resend them.
- The plan below covers Tuesday and Wednesday as written, and Thursday to 12:00.

**What the sprint mandate settles from week 0:**
- **D9 (Tuesday's top-20 switch):** option (a), conditional. The entry-matrix reader goes on for the AU top 20 at **14:00 Tuesday, if you approve the calendar mark-file**. Rows land `proposed` and reach no one until approved in Layer 4.
- **Pilot readers:** RMIT config Tuesday 17:00 and first run Wednesday 08:00 to Layer 4, with a 20% sampling audit Wednesday 14:00. UTS config Wednesday 17:00 and first run Thursday 08:00. VU config Thursday 12:00.

**Still open, and how I proceed so the 09:00 schema PR is not blocked:**
- **D1–D4 (extend the live tables; status mapping; levels; row identity):** the 09:00 PR is built on my week-0 recommendations:
  - additive columns on `catalogue.provider_entry_matrix` and `catalogue.course_entry_requirements`;
  - `quarantined` / `withdrawn` mapped onto the live statuses, with `valid_to` and `withdrawal_reason`;
  - `masters` / `doctorate` added to the AER level set;
  - `row_hash` over the condition keys.

  It is **not merged until your schema review** (your action "review schema PR, verify additive-only"). Change any of D1–D4 in that review.
- **D5 ("staging"):** there is no staging database. The PR goes to the live project additive and switched off (no rows written, no feed change), as in week 0, unless you name another target. `coursefinder-demo` is never used.
- **D6 (feed collection), D7 (Zoho form), D8 (register clock):** not needed before week 2 of the sprint. Your answers are still needed.
- **Pilot ground truth:** the 24 Oct customer spreadsheet is still missing. The diff harness is built against its expected shape, so it can run the moment the file arrives.

**Correction carried into the sprint:** the fee re-apply paste is now **372 fees** (regenerated 21:5x after 15 Layer 4 rejections), not 386.

Counts to check after each 08:00 paste:
- retirements: +563;
- providers published by the paste: 1,056, with AU published net 224 → 1,279;
- fees made live: 372, net +315 after the one-current rule.

## 26 Oct 2026 21:4x: red-line decisions received (Platform Admin 21:39)

**Recorded as decided:**

| # | Decision | Status |
|---|---|---|
| 1 | Spreadsheet: you are sourcing it. Diff framework (schema, query, expected columns) by **Wed 28 Oct 12:00** | Planned |
| 2 | Extend the live tables. Add `routes` jsonb, `valid_to` date, `withdrawal_reason` varchar(500), `row_hash` char(64), `version` int default 1; indexes `row_hash` unique, `status`, composite. Additive, switched off | Schema PR Tue 09:00 |
| 3 | No staging: PR against live, additive and off; no merge until your schema review | Accepted |
| 4 | Reader for the **5 pilot providers only**; the top 20 waits for pilot sign-off (Fri 7 Nov) | **Done 21:4x:** `entry.providers` set to the pilot. `entry.matrix_enabled` stays 0 and the job stays inactive until 14:00 Tue after calendar approval. Logged in `admin_control_events` |
| 5 | Identity = SHA-256(provider + country + level + band + sorted condition keys); a grade edit bumps `version` | See red line R1 |
| 6 | Levels `foundation \| diploma \| bachelor \| postgrad`; grid columns Foundation / Diploma / Bachelor / Postgrad | Accepted |
| 7 | Status mapping: `quarantined` → `unverified` with a provenance flag; `withdrawn` → `inactive` with `valid_to` | The check constraint can only be widened by a drop and re-create, which migrations do not do. **Mapping used**, documented here |
| 8 | Monthly register sync stands. Weekly AER liveness = edition probe (page hash plus a suspension-notice scan) | Accepted |
| 9 | Feed collection pre-approved: definition now; consumer notice Fri 30 Oct; seed not before **Mon 3 Nov** | The approval is recorded in the migration (`-- Consumer API change approved: Platform Admin 26 Oct 2026 21:39 …`); the baseline is re-taken; the developer guide is reissued with the notice |
| 10 | Platform delivers data layer, reference resolver, seed format and delta spec; Zoho builds the form; handoff **Thu 6 Nov** | Accepted |
| 11 | Fee paste: 372 made live, net +315 | Accepted |

**Pilot provider ids** (`entry.providers`):

| Provider | Id(s) |
|---|---|
| RMIT | `8e1adb6c…` |
| UTS | `9d22a19e…` |
| **Victoria University** | **two catalogue records**: `bac82321…` (280 active courses, `vu.edu.au`) and `0f5373c8…` (35 courses, `vu.edu.au/international`). Both included; one equivalency page serves both |
| Federation | `9cc8ef21…` (added) |
| WSU | `1719c3ba…` |

**Red lines in the decisions (proposals; say if you disagree before 09:00):**
- **R1 — identity must include `course_id`.** Decision 5's hash leaves out `course_id`, and decision 2 makes `row_hash` unique. UTS publishes per-course rows: two courses with the same country, level and board would get the same hash, and the second insert would fail. **Proposal:** identity = provider + **course_id (empty for provider-wide rows)** + country + level + band + sorted condition keys. A grade edit still only bumps `version`.
- **R2 — the composite index uses the live column names.** The live table has `study_level_id` (platform levels) and `benchmark_band`, not `study_level` / `band`. **Proposal:**
  - index `(provider_id, country_code, study_level_id, benchmark_band, status)`;
  - the AER level (decision 6) is a new column `aer_level` with a check for the four values, filled from `study_level_id` / `level_label`;
  - nothing renamed.

  This is a sixth added column, beyond the five in decision 2.
- **R3 — "delta webhook spec" (decision 10).** The existing feed is pull, by cursor; there is no webhook transport today. **Proposal:** the handoff gives the cursor-pull delta spec (same as courses and fees); a webhook would be a new consumer API surface, needing its own decision.
- **R4 — your file is cut off again.** It ends at "WEDNESDAY 28 OCT (Day 2): … 14:00: Federation + WSU reader configs mapped (generic postgrad)." Thursday 29 Oct to Friday 7 Nov are missing. I work to the plan as far as it goes plus the dated items in the decisions (consumer notice Fri 30 Oct, seed Mon 3 Nov, Zoho handoff Thu 6 Nov, pilot sign-off Fri 7 Nov). Please resend the rest.

## 26 Oct 2026 21:5x: "EXECUTE NOW" received (Platform Admin 21:45). Executing

Full execution authority overnight; a red line halts only its own lane. The Platform Admin delegates the three pastes ("APPLY COUNT-GUARDED WHEN READY"). Until now the standing rule had been "the paste is mine to apply"; this message changes that for these three files tonight.

Order of work:
1. pastes: re-check the guards on live, then retirements → publish → fees, verified after each;
2. schema PR (6 columns, indexes, identity) → suite → merge;
3. reader on for the 5 pilots, with stored copies first;
4. extractions (RMIT first);
5. calendar mark-file with auto-approval at confidence > 0.8;
6. delivery classification.

Status at 06:00 here.

**22:0x — paste lane HALTED (red line).**
- The guards were re-checked on live and passed:
  - publish list 1,056, md5 `a37d52ad…`;
  - fee pairs 372, md5 `26a3bb63…`;
  - retirements 563, md5 `78357842…`.
- My call to apply paste 1 (retirements) was **declined by the session's permission layer**. Nothing was written, and I have not retried.
- The three pastes stay as lodged, for the Platform Admin to apply. The other lanes continue.

**22:1x — Platform Admin 21:48 "HALT — Schema PR contains destructive operations". Correction of fact, and the schema SQL for review.**
- **No schema PR had been opened or run.** The statement declined at 22:0x was **paste 1 (the 563 retirements)**, run as one DO block. It is destructive by design:
  - it calls `security.layer1_plan_finish_v1`, which sets 563 courses inactive, writes retirement rows, and `delete`s the 563 departed keys from `pipeline.layer1_register_row_state`;
  - it then updates `pipeline.layer1_run_queue` (with a WHERE) and inserts a control event.
- That is why it was a paste for the Platform Admin. The decline was correct. Nothing was written, and the paste lane stays halted.
- **The schema SQL, written for review and not executed:** `20261026007000_cf247_aer_v11_entry_matrix_columns.sql`. It holds only the 6 approved `add column if not exists` statements and the 3 approved `create index if not exists`. There is no DROP, DELETE, TRUNCATE, UPDATE, trigger or function. It runs only after the Platform Admin's go.
- **Two points to settle before running it:**
  1. A plain unique `row_hash` blocks Track C's change runs: a changed page inserts the new rows and marks the old ones `superseded`, so the same identity briefly exists twice. The alternative is a partial unique `(row_hash) where status = 'active'`.
  2. With no trigger, `row_hash` stays empty. The identity function is a separate, later item for approval.

## 26 Oct 2026 22:3x–23:2x: night execution (Platform Admin 21:50)

**Schema: LIVE.** #706 (`0dc6086d`), migration `20261026007000`.
- Before merge: suite 1,008 passed; live dry run passed.
- After merge: history md5 `c4efbc41` matches the file.
- The 6 columns are live (31 → 37 columns), as are the 3 indexes (`row_hash` unique where status = 'active') and the identity trigger. Nothing dropped or renamed.
- **Identity, as built** (agent's note, for your review): SHA-256 of provider | course | country | study_level_id | band | sorted condition keys, **plus the row's own `qualification_name` as one of the keys**. The live reader writes one row per qualification: India "CBSE" and "State Board HSC" are two rows. Without the qualification they would share an identity and the second could never be active.
  - A grade edit bumps `version`: tested 1 → 2.
- **Status mapping** (decision 7; the check constraint is unchanged):
  - quarantined = `unverified` with `provenance.aer_flag = 'quarantined'`;
  - withdrawn = `inactive` with `valid_to` and `withdrawal_reason`.

**Reader: ON for the 5 pilots** (`entry.matrix_enabled` 1, job `entry-matrix-read` every 5 minutes, scope `entry.providers` = the pilots). Logged.

**Stored copies:** 40 equivalency sources seeded (`found_via` manual, logged):

| Provider | Sources |
|---|---|
| RMIT | all **33 country pages** and 3 special pages from its own index (Foundation equivalencies, Global Assessment Certificate, IB) |
| UTS | international entry scores page (1) |
| WSU | international entry requirements page (1) |
| VU | PDF (1) |
| Federation | PDF (1) |

- RMIT's index lists **33 countries, not 79**. The spreadsheet's other countries are not published by RMIT. In the diff they show as "not published by provider", not as a miss.
- **Red line, lane halted: VU and Federation publish PDF only.** Step A reads HTML. PDFs go to `pdf_step_b` (the PDF reader, Track C step B, not built). Both PDFs are seeded and will be stored and read when step B lands. **The VU and Federation extraction lanes are halted for that reason.** RMIT, UTS and WSU continue.

**Calendar mark-file:** `docs/platform/reports/2026-10-26/AU-top20-calendar-MARK-FILE.xlsx` (your format plus the levers).
- **Finding:** all 20 already have an approved calendar, so there is nothing to approve. Intakes are held by three rules:
  1. job `provider-calendar-defaults` is **off** (E2, 24 Oct "do not switch on"). The rule as it stands fills only 1 course in these 20.
  2. A course that ever had an intake row is skipped, even if every row was withdrawn: **429** undergraduate courses.
  3. Universities get default months only at undergraduate levels (your 19 Oct "Undergraduate only"): **1,291** postgraduate courses.
- 5 providers (Monash, Macquarie, ANU, Griffith, QUT) have no default months.
- 5 rows have confidence above 0.8, but **auto-approval had nothing to approve**. The levers are rule decisions (yours), so nothing was switched.

**Delivery classification:** `docs/platform/reports/2026-10-26/AU-delivery-classification.md`. Of the 3,390:
- 752 (22%) genuinely silent, as the reader judged;
- 333 (10%) recoverable with a tighter prompt;
- 2,305 (68%) need the right course page first.

**FIX, not BUILD.** Recoverable is under 20%, so no re-run was queued.

## 26 Oct 22:3x — Red line: extraction lane halted; fix merged (#707); countries paste lodged

**Red line hit: "Extraction produces fewer countries than the provider's page lists".** The reader was paused at **22:05** (`entry.matrix_enabled` 0, logged). The job `entry-matrix-read` stays scheduled but does nothing while the switch is 0. (The pause reason I logged says "23:2x"; that was a clock error on my part. The event time is 22:05:15.)

First runs, 21:59–22:05: 6 runs, 12 rows proposed (RMIT Canada 8, UTS 4), 2 Layer 4 items, US$0.02.

| Cause | Rows dropped | What fixes it | Whose |
|---|---|---|---|
| `ref.countries` holds only 8 countries (AU, CA, NZ, IN, DE, GB, IE, US), so Bangladesh, China, Cambodia, Malaysia and others have no country to attach to | 30 | Paste `docs/platform/pastes/PASTE-20261026-ref-countries-for-entry-matrix.sql`: 241 ISO countries, seed-only, every flag false. **Yours**: the Zoho and website filter lists read `ref.countries` unfiltered, so this is consumer-visible (G3) | Platform Admin |
| RMIT names the level once per group of table rows, so the model's whole-row quote was not on the plain text | 21 of 22 RMIT rows | **Merged #707**: worker v0.48.1 reads each table row as one line, carrying the level down. Quotes are checked against the same text | Done |
| UTS: 2 quotes not on the page, 1 grade not in its quote | 3 | Correct drops (paraphrased quotes). No change | — |
| WSU: the page gave 0 rows | — | The page lists no country minimums (it points to course pages). Treated as "not published", not a miss | — |

**Countries paste** (trial-run and rolled back on live):
- guards: exactly 8 existing countries, 241 inserted, code md5 `8c4bd9d5e0388eb838086364e17836fc`;
- result: 249 countries;
- no consumer function's shape changes. The filter lists gain countries, every one with flags false.

**#707** (`b0a0e0a9`): worker v0.48.1, prompt `entry-matrix-v0.1.1`, `public.admin_entry_matrix_reread`.
- Checks:
  - suite 1,012 passed;
  - live dry run passed;
  - history md5 `bff1c614`;
  - worker live byte for byte.
- Re-read keeps every earlier result in `previous_results`. It supersedes proposed rows and pending items only.

**Once you apply the countries paste:**
1. I re-read the 6 runs (`admin_entry_matrix_reread`).
2. I switch the reader back on for the pilots.
3. I check the countries extracted per RMIT page against the page's own table.

The RMIT lane stays halted until then. UTS and WSU likewise. VU and Federation wait for the PDF reader (step B).
