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

### 26 Oct 2026 22:38–22:47 — AER v1.1: countries paste applied; six pages re-read; RMIT band-ladder defect found; extraction stays paused

Authority: Platform Admin 26 Oct 2026 22:38 ("apply the countries paste once, exactly as written … keep extraction paused until every acceptance check passes … stop and record the defect before coding").

**Pause time reconciled.** The first reads ran 21:59–22:05 and the reader was paused at 22:05:15 (control event). Earlier notes saying "23:2x" or "23:0x" are clock errors on my part. That includes the pause reason and the paste header, which is left unedited because the paste is applied as written.

**1. Countries paste: applied once, 22:42:00.** `docs/platform/pastes/PASTE-20261026-ref-countries-for-entry-matrix.sql`, file md5 `edc5ffa8…`, applied exactly as written. Its control event records the Platform Admin's id, as the paste is written; the agent ran it under the 22:38 authority.
- Guards checked first: exactly AU,CA,DE,GB,IE,IN,NZ,US; no earlier `countries_paste` event.
- After:

  | Check | Result |
  |---|---|
  | Countries | 249 (8 + 241) |
  | Code-list md5 | `8c4bd9d5…` |
  | All 241 rows: code, alpha-3, numeric, name, official name | md5 `8469d52f…`, the same as the file byte for byte |
  | Bangladesh, China, Cambodia, Malaysia (and Viet Nam) | present, `seed_only` |
  | Ingestion or student-search flags on for the new rows | 0 |

- **Consumers (G3):** the shape fingerprints match before and after for the Zoho country filter, the Zoho reference bundle, the Zoho AU provider search, website scholarships and website rankings.
  - The country lists still return the same 3 countries (AU, NZ, CA): they list only countries with courses.
  - Content hashes differ only by `generated_at`.
  - `consumer_api_check_v1`: no drift (73 functions, 48 relations).

**2. Six pages re-read** through `admin_entry_matrix_reread` (logged).
- 6 runs re-queued; 12 earlier proposed rows and 2 pending items superseded; each earlier result kept in `previous_results`. No row was ever active.
- The scheduled job `entry-matrix-read` was switched off (logged), and `entry.matrix_enabled` was set to 1 only for the hand-started worker call, then back to 0 (both logged). No new runs were queued.
- Every row carries worker v0.48.1 and prompt `entry-matrix-v0.1.1`. Re-read cost US$0.029.
- Side effect: the worker's fetch step stored 6 more RMIT pages (stored copies only, no AI read). 10 RMIT pages now hold stored copies with no run.

| Page | Before (proposed / dropped) | After (proposed / rejected) | Published on the page | Reconciliation |
|---|---|---|---|---|
| RMIT Bangladesh | 0 / 11 | 11 / 0 | 11 minimums (HSC: Foundation, Fast Track, 3 diploma bands, 6 bachelor bands) | 11 = 11 |
| RMIT China | 0 / 8 | 22 / 0 | 22 (Gao Er 2, Gao San 11, Gao Kao 9) | 22 = 22 |
| RMIT Canada | 8 / 14 | 22 / 2 | 24 (Year 11 2, OSSD 11, Dogwood 11) | 22 + 2 rejected = 24. The OSSD Foundation and Fast Track rows ("Completion of Ontario Secondary School Diploma") were quoted from the footnote row, so they were rejected as `grade_not_in_quote`. That is correct |
| RMIT Cambodia | 0 / 2 | 4 / 0 | 2 minimums + 1 merged "case-by-case, C grade average" cell spanning both level groups | 2 + 1 rule per level group (2) = 4 |
| UTS | 4 / 19 | 40 / 5 | One page, many countries | 40 rows across 39 countries, 40 distinct identities |
| WSU | 0 / 0 | 0 / 0 | — | Not published |

- **Countries per RMIT page:** each page names one country and gives one. Bangladesh, China and Cambodia went from 0 to 1. Parity holds on all four.
- **Carry-down:** every one of the 59 RMIT rows quotes its whole table line, starting with its level label ("Bachelor degrees | 70% | Not applicable | Minimum CGPA of 4.2"). Every band row's Australian-standard band is in its quote.
- **UTS rejections stay rejected:**
  - Malaysia UEC and Viet Nam: paraphrased quotes, `quote_not_on_page`;
  - GB A Levels and US: grade not in the quote, `grade_not_in_quote`;
  - "International Baccalaureate": not a country, `unknown_country`.
- **WSU:** "not published", not an extraction miss. The HTML page states no country minimums ("International students are required to meet the same standards as Australian residents"). It links a "Download Entry Qualifications Table" PDF, which is likely where WSU's minimums are. That PDF is not seeded: adding it would widen scope. It is noted for the PDF reader.

**3. Defect found (separate from #707). RMIT lane fails acceptance.** Recorded before any code.
- **What:** the model leaves `benchmark_band` empty on every RMIT band-ladder row (0 of 59), although each quote holds the Australian-standard band (50%…90%). The rows are typed `provider_minimum`, not `band_ladder`.
- **Effect:** rows of one level and qualification share an identity:

  | Page | Rows | Identities |
  |---|---|---|
  | Bangladesh | 11 | 3 |
  | China | 22 | 6 |
  | Canada | 22 | 6 |
  | Cambodia | 4 | 3 |

  Approving any RMIT Layer 4 item would break the active-row identity rule: the approval fails, and nothing is admitted wrongly. Without the band, the rows also cannot say which RMIT score each grade equals.
- **Do not approve** the 4 pending RMIT items (Bangladesh, China, Canada, Cambodia). The UTS item can be reviewed.
- **Fix proposed (not built; needs your go):**
  - tell the reader that a column of Australian-standard scores is the benchmark band for each row;
  - check in the worker that a band given is in the quote, and drop a row whose quote shows a band it did not give (`band_missing`);
  - test on the four RMIT pages;
  - re-read through `admin_entry_matrix_reread`.

**4. Lanes.**
- Not re-enabled. The acceptance condition (all non-PDF pilot checks pass) is not met, because RMIT fails on the band defect.
- UTS and WSU pass their checks. Re-enabling them would read nothing new tonight: one page each, already read, unchanged.
- State: `entry.matrix_enabled` 0, job `entry-matrix-read` inactive, 0 open runs.
- VU and Federation stay halted for the PDF reader (`pdf_step_b`).

## 06:00 status — draft as at 26 Oct 22:47 (final line written at 06:00)

- [x] Schema merged and live (additive, switched off): #706.
- [~] Stored copies for all 5 pilots:
  - RMIT: 16 of 36 pages stored;
  - UTS and WSU: stored;
  - VU and Federation: PDF, waiting for step B.
- [~] RMIT extraction run, rows in the Layer 4 queue:
  - 12 of 36 pages complete under the guard, items pending;
  - 3 non-country pages held (D2);
  - 4 failed (D5 2, D4 2);
  - 17 held or unread;
  - lane out of scope 05:27 (D5).
- [~] UTS and VU runs:
  - UTS complete (40 rows, item pending review);
  - VU halted (PDF).
- [x] Calendar mark-file exported. No high-confidence row to approve (all 20 already approved).
- [x] Delivery classification report delivered.
- [ ] All three pastes applied with verified counts: yours at 08:00 (retirements, publish, fee re-apply). The countries paste was applied 22:42 under your 22:38 authority.

~~Status line (to stand at 06:00 unless changed overnight): halted — RMIT band-ladder defect (benchmark band not captured; fix proposed, awaiting go). VU and Federation are halted for the PDF reader.~~ (superseded 23:11)

~~Status line, 23:11: complete for the non-PDF pilots.~~ (withdrawn 00:08: a read could be incomplete without detection, and six Canada rows lacked level evidence)

~~Status line, 00:08: halted — RMIT lane paused for defect D1.~~ (superseded 05:30: D1 fixed and proven live, #711)

**Status line, 05:30 (to stand at 06:00): halted — RMIT lane out of scope for parser defect D5 (a footnote row wider than its header, or a short trailing row, makes a genuine country table unparsed: Kuwait, Mexico).**
- D1, D2 and D3 are live (#711).
- RMIT passed 12 of 36 pages (complete under the guard, in review).
- 3 pages held as non-country (D2, terminal by decision).
- 2 pages D5; 2 pages D4 (reader); 7 held with attempts left; 10 not yet read.
- UTS and WSU running. VU and Federation halted for the PDF reader.
- **Silent partial reads: 0. Active rows: 0.**

### 26 Oct 2026 23:05 — AER v1.1: RMIT benchmark-band fix (#708), written before merge (merged 23:06)

Authority: Platform Admin 26 Oct 2026 22:50 ("Build and release the narrow RMIT benchmark-band fix … merge its PR under rule 9 when every gate passes").

- **Defect (recorded 22:47):** RMIT rows carried no benchmark band, so rows of one level and qualification shared an identity. Bangladesh had 11 rows and 3 identities.
- **Second cause, found before coding:** RMIT's Foundation Studies and University Pathways Fast Track both map to the foundation study level and print no band. With the band alone, Bangladesh would give 10 identities for 11 rows.
- **Fix (PR #708, branch `cf247-entry-band`):**
  - **Worker v0.48.2, prompt `entry-matrix-v0.1.2`:**
    - each table line carries the band its "Australian standard" column prints;
    - a row whose whole-row quote shows that band but gives none is rejected (`band_missing`);
    - a band not in the quote (`band_not_in_quote`), different from the printed one (`band_mismatch`), or ambiguous between matching lines (`band_ambiguous`) is rejected;
    - the band kept is the printed one, never inferred.
  - **Migration `20261026009000_cf247_entry_matrix_band_identity.sql`** (two md5-guarded edits, nothing dropped):
    - `entry_matrix_identity_tg` (`86ddafc3…`): the row's level label joins the condition keys of the existing identity as `level: <label>`, as the qualification name did in #706. The hash function and status values are unchanged.
    - `entry_matrix_review_apply_v1` (`e3f02aaa…`): approval refuses a run whose proposed rows share an identity (raises; nothing changes).
  - **Tests:** s128 is new (carried-down label, band extraction, missing-band rejection, identity separation). s127 now accepts the new worker and prompt versions. The test register is regenerated.
- **Gates:**
  - suite 1,017 passed, 0 failed, 0 skipped;
  - worker build OK;
  - live dry run (rolled back): approval of the pending Bangladesh item refused ("proposed rows share an identity"). With the printed bands, Bangladesh has 11 rows and 11 identities (3 before). 0 active rows.
- **Next:**
  1. Verify live md5s just before the merge.
  2. Merge, then verify the deployed migration and worker.
  3. Re-read the four RMIT pages and run the acceptance checks.
  4. Restore only the eligible non-PDF lanes, if the controls allow it without the PDF lanes.

### 26 Oct 2026 23:11 — #708 merged and verified live; RMIT acceptance passed; RMIT, UTS, WSU lanes restored

- **Merge:** #708 squash `832b5717`.
  - Gates: suite 1,017 passed (0 failed, 0 skipped); live dry run passed; change control written before merge.
  - Live md5s just before merge: `entry_matrix_review_apply_v1` `e3f02aaa…`, `entry_matrix_identity_tg` `86ddafc3…`, both equal to the guards.
- **Deployed, checked against the repo:**
  - `deploy-on-merge` applied `20261026009000`; history md5 `8dd0ceba` matches the file;
  - `entry_matrix_identity_tg` live md5 `915df18e…` equals the guarded original with the edit applied, byte for byte;
  - `entry_matrix_review_apply_v1` live md5 `76cce959…`: reverting the edit gives `e3f02aaa…`;
  - `entry_matrix_row_hash_v1` unchanged (`a5127baf…`);
  - worker version 209: `index.ts`, `entry.ts` and `extract.ts` byte for byte.
- **Re-read of the four RMIT pages only** (`admin_entry_matrix_reread`, logged): the 59 earlier proposed rows and the 4 unsafe items were superseded, and each earlier result was kept in `previous_results`. The scheduled job stayed off and the reader setting was 1 only for the hand-started call.
- **First post-fix read of China: 13 of 22.** The whole Gao Kao column (9 rows) was left out by the model; nothing was dropped. One repeat read (logged) gave 22 of 22. **The omission does not repeat reliably, which makes it a completeness risk** (open item below).
- **Acceptance (live, worker v0.48.2 on every row):**

  | Page | Published (table rows with a minimum) | Proposed | Distinct identities | With band | Rejected |
  |---|---|---|---|---|---|
  | Bangladesh | 11 | 11 | 11 (3 before) | 9 band rows + 2 non-band | 0 |
  | China | 22 | 22 | 22 (6 before) | 18 + 4 | 0 (repeat read) |
  | Canada | 24 | 24 | 24 (6 before) | 18 + 6 | 0 |
  | Cambodia | 11 | 11 | 11 (3 before) | 9 + 2 | 1 (`band_missing`) |
  | **Total** | **68** | **68** | **68** | **54 + 14** | 1 |

  - **Canada** is now 24 proposed, not 22 + 2. The two OSSD rows the earlier read quoted from the footnote are now quoted from their own cells.
  - **Cambodia** is 11 rows, not the 4 expected. The merged "case-by-case, C grade average" cell spans all 9 band rows, and the fixed reader gives one row per band, each with its band in the quote: 9 rows plus Foundation and Fast Track. That matches the source table row for row. The earlier 4 was one row per level group with no band.
  - **No collapse remains** through a missing band or level: 68 rows, 68 identities, 0 rows whose quote shows a band they lack.
  - **Missing-band guard, live:** one Cambodia row ("Diploma/Associate degrees | 50% | … Assessed on a case-by-case basis …") came back without its band and was rejected as `band_missing` before it could be proposed.
- **Evidence:**
  - every proposed row's quote was checked on the stored page by the worker;
  - all 54 band rows quote their whole line, starting with the level label (the carry-down holds);
  - 6 Canada Foundation and Fast Track rows quote only their cell ("Completion of Ontario Secondary School Diploma"). Those quotes are on the page, but they do not prove which level. The reviewer should check those 6.
- **Unsafe items:**
  - the 4 pre-fix RMIT items, the 2 from the first re-read and China's 13-row interim item are superseded (7 in all);
  - a rolled-back probe tried to approve each of the 7: all were refused ("no entry matrix run for this review item");
  - the new approval guard refuses any run whose rows share an identity;
  - active rows: 0.
- **Lanes restored (logged):**
  - `entry.providers` narrowed to RMIT, UTS and WSU. Both VU records and Federation were taken out, so search discovery cannot add HTML pages for them;
  - `entry.matrix_enabled` 1; job `entry-matrix-read` active;
  - `entry_matrix_enabled_v1` is true for exactly 3 providers: RMIT, UTS and WSU.
  - VU and Federation stay halted for the PDF reader. WSU's linked Entry Qualifications Table PDF is not added.
- **Pending review:** 5 items (UTS 40 rows; RMIT Bangladesh, China, Canada, Cambodia). New RMIT pages will land as proposed rows with a Layer 4 item each. Nothing is admitted without review.
- **Open:**
  1. **Completeness risk.** The model can leave out a whole qualification column, and no gate detects it. Proposed guard (needs a go): compare the rows a read gives with the table's band rows and qualification columns, and hold a read that falls short. Until then, reviewers should count the rows against the page.
  2. The 6 Canada rows that quote only their cell.
  3. PDF reader for VU, Federation and WSU's linked table.

### 26 Oct 2026 23:35 — AER v1.1: source-anchored completeness guard (#709), written before merge

Authority: Platform Admin 26 Oct 2026 23:16 ("Build and release the source-anchored completeness guard … merge under rule 9 when every gate passes").

- **Containment, 23:16:49 (logged):** `entry.providers` was narrowed from RMIT, UTS and WSU to UTS and WSU. RMIT is paused at provider level; UTS and WSU are unchanged.
  - Before the pause, the 23:14 cycle read 3 RMIT pages: Germany 11 rows, Colombia 2, Mexico 6. Their review items have no verdict; the new guard refuses them.
  - 12 RMIT runs queued at 23:14 are frozen without being read.
- **Why:** after #708, a China read gave 13 of 22 published minimums (the whole Gao Kao column left out). Nothing was dropped, and it was proposed for review. Separately, 6 Canada rows quoted only their cell.
- **Fix (PR #709, branch `cf247-entry-completeness`):**
  - **Worker v0.48.3, prompt `entry-matrix-v0.1.3`:**
    - `entryManifest` builds, from the stored page, every minimum its band tables publish: qualification columns and headings, the band column, carried level labels, merged cells. Grading and calculation rows count as footnotes; a repeated copy of a table counts once.
    - `entryCompleteness` matches each kept row to exactly one entry. The quote must be the entry's table line, showing the level and the band; the grade must be in the entry's own cell; the level, band and column must be right; the country must be named on the page.
    - Any omitted column or row, misplaced cell, cell-only quote, duplicate or unexplained row holds the whole read. A band table the guard cannot read is held before any AI read.
  - **Migration `20261026010000_cf247_entry_matrix_completeness_guard.sql`:**
    - setting `entry.completeness_providers` (RMIT);
    - new function `security.entry_completeness_required_v1`;
    - md5-guarded edits:

      | Function | Guarded md5 | Change |
      |---|---|---|
      | `svc_entry_matrix_next` | `4b5a59da…` | each item says whether its provider is under the guard |
      | `svc_entry_matrix_record` | `d80183c6…` | a read under the guard without a complete verdict proposes nothing; the read is kept in `previous_results` and retried within `entry.matrix_attempts`; an unreadable page is failed, not re-read |
      | `entry_matrix_review_apply_v1` | `76cce959…` | approval (and the changed-page auto-admit) refused without a complete verdict |

    - No new states or statuses. Nothing dropped.
  - **Tests:** s129 is new. It covers:
    - China with Gao Kao omitted: 13 rows, held;
    - China complete: 22 rows, passes;
    - Cambodia's merged cell and carried labels;
    - Canada's footnote quote refused, and its whole-line OSSD rows passing;
    - cell-only quotes refused (6, `level_not_evidenced`);
    - wrong level and wrong column;
    - duplicates;
    - an unreadable table;
    - a repeated table.

    s127 and s128 now accept the new versions. The test register is regenerated.
- **Gates:**
  - suite 1,024 passed, 0 failed, 0 skipped;
  - worker build OK;
  - live dry run (rolled back):
    - 13-row China read held: 0 proposed, read kept, re-queued;
    - a read with no verdict held;
    - third held attempt failed;
    - complete 22-row read proposed and approved (22 active);
    - pre-guard Germany RMIT run refused;
    - UTS still approvable.
- **Next:**
  1. Verify live md5s just before the merge.
  2. Merge, then verify the deployed functions and worker and check release currentness.
  3. Re-read the four RMIT pages.
  4. Live negative and positive guard tests.
  5. Restart RMIT only if all four pass.

### 27 Oct 2026 00:02 — #709 merged and verified live; RMIT acceptance under the guard passed; RMIT restarted; #710 (complete admission) written before merge

**#709, merged 23:36:33** (squash `e15166bc`).
- Live md5s just before merge equalled the guards (`svc_entry_matrix_next` `4b5a59da…`, `svc_entry_matrix_record` `d80183c6…`, `entry_matrix_review_apply_v1` `76cce959…`), and the new objects were absent.
- `deploy-on-merge` applied `20261026010000`; history md5 `7b712633` matches the file.
- Each of the three edited functions, with its edits reversed, equals its guarded original byte for byte. The setting `entry.completeness_providers` holds RMIT.
- Worker version 210: every coverage-sweep file is byte for byte the repo's.
- **Release currentness:** it runs only when release files change, so it had not run for #706–#709. Run by hand on `e15166bc` (run 40325241884): passed.

**Acceptance reads, under the guard, 23:44–23:49.** The scheduled job was off. RMIT was in scope only for one hand-started call, and only the 4 re-read runs (the oldest) were taken. RMIT was out of scope again once they were leased. All logged.

| Page | Published (manifest from the stored page) | Matched | Proposed | Identities | Held or rejected |
|---|---|---|---|---|---|
| Bangladesh | 11 | 11 | 11 | 11 | 0 |
| China | 22 (Gao Er 2, Gao San 11, Gao Kao 9) | 22 | 22 | 22 | 0 |
| Canada | 24 (Year 11 2, OSSD 11, Dogwood 11) | 24 | 24 | 24 | 0 |
| Cambodia | 11 (2 + 9 rows of the merged case-by-case cell) | 11 | 11 | 11 | 0 |

- All 68 rows came in on the first attempt, with verdict `complete` (`manifest-v1`).
- **Canada's six short quotes are resolved.** All six Foundation and Fast Track rows now quote their whole table line, which starts with the level. Every quote of all 68 rows starts with its level label.
- **Cambodia's rejected row:** the read at 23:08 (before #709) rejected one row as `band_missing`. It repeated the Diploma 50% case-by-case row without its band, and the same row came in again with its band. That read is kept in `previous_results`. The acceptance read rejected nothing.

**Live rolled-back tests on the real China run (deployed functions).**
- **Negative:**
  - the Gao Kao column removed, 13 rows: held, 0 proposed, run re-queued, no item;
  - the same 13 rows with no verdict: held ("no complete verdict (missing)"), 0 proposed;
  - the superseded earlier item: approval refused.
- **Positive:** the complete 22-row read was proposed, and approval made 22 rows active with 22 distinct identities.
- **Gap found:** approving the complete read with the Gao Kao rows *excluded by the reviewer* admitted 13 rows. A complete read could be admitted in part. Closed by #710 below.

**RMIT restarted at 23:51** (logged):
- the 3 pages read at 23:14 before the guard (Germany, Colombia, Mexico) were re-read under it;
- `entry.providers` = RMIT, UTS, WSU; job `entry-matrix-read` active;
- 3 providers enabled; VU (both records) and Federation off;
- 15 RMIT runs queued. No approvals are pending tonight.

**#710 (PR, branch `cf247-entry-complete-admission`), written before merge.**
- Migration `20261026011000_cf247_entry_matrix_complete_admission.sql`, an md5-guarded edit of `entry_matrix_review_apply_v1` (`9386a7be…`): under the guard, approval admits only when the rows it would make active are exactly the rows the complete verdict matched. Excluding rows, or rows missing since the verdict, refuses the approval; the reviewer rejects the whole run instead. UTS is unchanged.
- Test s130; test register regenerated.
- Suite 1,025 passed, 0 failed, 0 skipped.
- Live dry run (rolled back, real China run):
  - Gao Kao excluded at approval: refused ("13 of the 22 rows the complete read matched would be admitted");
  - Gao Kao rows removed since the verdict: refused;
  - whole read: 22 active;
  - UTS: approvable.

### 27 Oct 2026 00:08 — #710 merged and verified live; RMIT lane under the guard; RMIT paused 00:06 for a band-normalisation defect

**#710, merged 00:03:50** (squash `cb062640`).
- Live md5 of `entry_matrix_review_apply_v1` just before merge equalled the guard (`9386a7be…`).
- `deploy-on-merge` applied `20261026011000`; history md5 `9cee3b80` matches the file. With the edit reversed, the live function equals the guarded original byte for byte (live md5 `f1152d19…`).
- Release currentness, run by hand on `cb062640` (run 40327511679): passed.
- **Live rolled-back tests on the real complete China run (deployed functions):**
  - negative, Gao Kao column excluded at approval: refused ("13 of the 22 rows the complete read matched would be admitted");
  - negative, Gao Kao rows removed since the verdict: refused;
  - positive, the whole read: 22 active, 22 identities.
  - Active rows after the tests: 0.

**RMIT lane, 23:51–00:06 (restart to pause).** Of the 32 RMIT pages besides the four acceptance pages:

| Measure | Count |
|---|---|
| Attempted (AI reads) | 8 pages, 12 reads |
| Complete | 2 (India 33 of 33, Japan 11 of 11). Items pending review |
| Held by the guard | 6 pages, 10 held reads, each kept whole in `previous_results` |
| Retried | 4 pages, once each (Colombia, Denmark, Foundation equivalencies, Hong Kong) |
| Failed | 0 (no run reached `entry.matrix_attempts`) |
| Admitted | 0 (no approvals; active rows 0) |
| Not yet attempted | 24 pages (23 queued runs, 1 stored page not yet queued) |
| **Silent partial reads** | **0**. Every read either matched its whole manifest or was held |

RMIT review items pending: 6 (Bangladesh, China, Canada, Cambodia, India, Japan), all with complete verdicts. RMIT AI spend to date: US$0.16.

**Holds, by cause:**
1. **Defect D1: "Not applicable" kept as a band** (Hong Kong, International Baccalaureate).
   - The reader gives `benchmark_band` = "Not applicable" for Foundation and Fast Track rows. The page prints that in the Australian-standard column to mean no band.
   - The #708 band check keeps it, because it is in the quote. The guard then correctly refuses the rows (`wrong_band`).
   - Every retry repeats it, so these pages would exhaust their attempts and end `failed`.
2. **Column left out by the reader** (Colombia, Denmark, Indonesia): whole qualification columns missing. These are the omission the guard exists to catch. Whether each column is a genuine minimum, or a column the manifest should not expect (for example a case-by-case column), is still to be checked against the stored pages.
3. **Defect D2: special pages that are not country equivalency tables.**
   - "Foundation equivalencies" has a table headed with "Australian standard" whose other columns are English requirement, academic requirement and prerequisites. The manifest counts them as qualification columns; the reader rightly skips English rows. That page will always be held.
   - The International Baccalaureate and Global Assessment Certificate pages name a qualification, not a country.
4. **Gap D3:** `admin_entry_matrix_reread` re-reads only `done` runs. A run that exhausts its attempts and ends `failed` cannot be brought back through the logged mechanism.

**Containment:** RMIT out of `entry.providers` at 00:06 (logged). All its runs stay `queued` with their attempts intact. UTS and WSU are unchanged; VU and Federation are out.

**Proposed (needs a go; not built):**
- **D1:** a band printed as "Not applicable" (or blank) is no band. It is normalised to null in the reader's band check, deterministically: no inference, and the guard's comparison is unchanged.
- **D3:** the logged re-read also takes `failed` runs, earlier results kept.
- **D2:** the manifest counts only qualification columns, not requirement-type columns (English, prerequisites). Special non-country pages are held as `unparsed`, not retried. Or they are taken out of the RMIT pilot by your decision.
- Then re-read the held pages under the guard and restart RMIT.

### 27 Oct 2026 05:15 — AER v1.1: RMIT D1–D3 (#711), written before merge; triage of Colombia, Denmark and Indonesia

Authority: Platform Admin 27 Oct 2026 04:58 ("Build D1–D3 and merge under rule 9 … Keep the three D2 pages in the pilot's evidence history, but hold them as non-country/unreadable sources without further automatic retries").

**Triage against the stored pages** (the manifest is built from each stored page, so it shows what the source publishes):

| Page | Column in the source? | What happened | Classification |
|---|---|---|---|
| Denmark | Yes (HHX/HTX and Folkeskolens: Foundation and Fast Track cells) | The reader read both columns but gave "Not applicable" as the band; the guard refused them (`wrong_band`) | **D1**: resolved by this change |
| Colombia | Yes: one merged "Assessed on a case-by-case basis…" cell across the 9 band rows | The reader gave 9 rows for it. On attempt 2 every grade was outside its quote (`grade_not_in_quote`); on attempt 3 every row lacked its band (`band_missing`). Both refusals are correct | **D4 (reader defect, recorded): merged case-by-case column misread.** Held with this evidence; not forced |
| Indonesia | Yes: 4 qualification columns, 25 minimums | The reader put band-row grades under the wrong qualification column (11 rows under SMA2, whose band cells are "Not applicable") and dropped others (`band_missing` 9, `band_mismatch` 11, `grade_not_in_cell` 9) | **D4 (reader defect, recorded): column misassignment on a 4-column table.** Held with this evidence; not forced |

D4 is not built (not authorised). Colombia and Indonesia stay held. Colombia has 1 attempt left and Indonesia 2. The guard refuses any partial read, and D3 brings them back once D4 is fixed.

**Fix (PR #711, branch `cf247-entry-d1-d3`):**
- **D1 (worker v0.48.4):**
  - a band given as the page's own "Not applicable" (or N/A, or a dash) is no band where the quoted line prints none in its band column; the quote keeps the source text;
  - on a line that prints a band, "Not applicable" or an absent band is `band_missing` (the missing-band guard is not weakened);
  - the #708 identity is unchanged: Foundation and Fast Track stay distinct by their level labels, with no band manufactured.
- **D2:**
  - under the completeness guard, a table that is not one country's is held as `held_unparsed` before any AI read:
    - requirement-type columns (English requirement, academic requirement, prerequisites: Foundation equivalencies);
    - or a heading (h1 and title) that names no country of `ref.countries` (International Baccalaureate, Global Assessment Certificate). The longest name wins ("Nigeria" over "Niger"); an alpha-3 code counts only as its own word ("USA");
  - the record function (#709) already makes `held_unparsed` terminal: state failed, no retry, the read kept;
  - new `public.svc_entry_country_refs_v1()` (service role) gives the worker the list;
  - from now on, verdicts record the page heading.
- **D3:** `admin_entry_matrix_reread` (md5-guarded `cec71585…`) also takes failed runs. The earlier result keeps its state, error, the attempts it used and `earlier_index` (its link to what came before). The run starts its own attempts again. Proposed rows and pending items are superseded as before, so nothing is proposed or admitted twice.
- **Tests:** s131 is new. It covers:
  - D1 "Not applicable" becoming no band, with the source text kept;
  - an absent band (null, empty, "Not applicable", "N/A") on a band line still refused;
  - Foundation and Fast Track identity separation with no band;
  - the D2 shapes (IB, GAC, Foundation equivalencies held; the RMIT country headings checked against the live 249-country list, fixture md5 `e5698bb8…`, equal to live);
  - D2 before the AI read and terminal;
  - D3 history and attempts;
  - #709 and #710 still enforced.

  s129 now accepts v0.48.4. The test register is regenerated.
- **Gates:**
  - suite 1,032 passed, 0 failed, 0 skipped;
  - worker build OK;
  - live dry run (rolled back): country refs 249. The real Colombia run, set failed after three held reads, came back through the re-read: queued, attempts 0, history 3 → 4 (state failed, error, attempts_used 3, earlier_index 3), 0 proposed.

### 27 Oct 2026 05:30 — #711 merged and verified live; D1 and D2 proven live; new parser defect D5; RMIT paused again

**#711, merged 05:24:24** (squash `de31e8c1`).
- Live md5s just before merge:
  - `admin_entry_matrix_reread` `cec71585…`, equal to the guard;
  - `svc_entry_matrix_next` `f992b7fc…`, `svc_entry_matrix_record` `e1a130e2…` and `entry_matrix_review_apply_v1` `f1152d19…`, unchanged since #710;
  - `svc_entry_country_refs_v1` absent.
- `deploy-on-merge` applied `20261027001000`; history md5 `7328012c` matches the file.
- The re-read function with its edits reversed equals `cec71585…` byte for byte. The body of `svc_entry_country_refs_v1` equals the file's (md5 `28125f63…`). It returns 249 countries and is executable by `service_role` only.
- Worker version 211: all 17 deployed files byte for byte the repo's (the coverage-sweep modules and the `_shared` register modules).
- Release currentness, run by hand on `de31e8c1` (run 40377612045): passed.

**Acceptance reads, 05:27 (scheduled job off; RMIT in scope for one hand-started call, then out at 05:27:47; all logged):**

| Check | Result |
|---|---|
| **D1 (Hong Kong)** | **11 of 11 complete** on its third attempt. Foundation and Fast Track carry no band, their quotes keep "… \| Not applicable \| …", and they have 2 distinct identities |
| **D1 (Denmark)** | The `wrong_band` refusals are gone: the HHX/HTX and Folkeskolens Foundation and Fast Track rows now read. The run is still held, for a different reason: the reader skipped 8 band rows whose cell repeats the band above ("Average of 7" at both 70% and 75%). Failed after 3 attempts; recoverable through D3 |
| **D2 (Global Assessment Certificate)** | `held_unparsed: not a country table: no country named in the page heading`. Held before any AI read, terminal (state failed), 0 retries left |
| **D2 (International Baccalaureate)** | Same reason; held before any AI read, terminal |
| **D2 (Foundation equivalencies)** | `held_unparsed: not a country table: requirement-type columns, not qualifications (English Requirement 1; Academic Requirement; Prerequisites)`. Terminal |
| **India / Japan / China** | Unchanged and still complete: 33/33, 11/11, 22/22 (Gao Kao 9 included), identities equal rows, items pending |
| **Newly complete under the guard** | Germany 11/11, Kenya 9/9, Malaysia 22/22, Mauritius 13/13, New Zealand 11/11. Each verdict now records its heading (for example "Germany \| Germany \| Academic Entry Requirements") |

**New parser defect D5 (mine, in the manifest; recorded before any code).**
- **What:** `entryManifest` checks every row's cell count against the header *before* it recognises a footnote row, and refuses a data row shorter than the header.
- **Kuwait:** held as `held_unparsed: a row has 4 cells, the header 3: Grading / Calculation System | …`. The footnote row is wider than the header.
- **Mexico:** held as `held_unparsed: a row has 3 cells, the header 4: Bachelor degrees | 80% | Not applicable`. Probably trailing empty cells left out of the HTML.
- Both are genuine country tables, now terminally held. D3 can bring them back once D5 is fixed.
- **Fix to propose (not built):**
  - recognise footnote rows before the width check;
  - pad a short row with blanks only when the missing cells are trailing and no merged cell from above spans them; otherwise stay `unparsed`. Padding the wrong way would make the manifest under-count, and a short read could then pass.
- **RMIT taken out of scope at 05:27:47 (logged)** so no further page can be falsely held while D5 is open.

**Reader defect D4 (recorded at 05:15), wider than first seen.**
- **Merged "+ first year at university" case-by-case column left out or misread:** Colombia (failed after 3 attempts), Nepal and Nigeria (held, 1 attempt used).
- **Column misassignment:** Indonesia (held, 2 attempts used) and Norway (`grade_not_in_cell`, held, 1 attempt used).
- **Repeated values across bands skipped:** Denmark (see above).
- Pakistan and Philippines are held with "6 rows not explained (not_a_table_row)": rows from outside the band table. Still to be triaged against their stored pages.
- Every one of these was held whole by the guard. **No silent partial read; 0 rows active.** No proposed row lacks a complete verdict.

**Per-page state, RMIT (36 pages):**

| State | Count | Pages |
|---|---|---|
| Passed (complete, in review) | 12 | Bangladesh, Cambodia, Canada, China, Germany, Hong Kong, India, Japan, Kenya, Malaysia, Mauritius, New Zealand |
| Source-held (D2, terminal by decision) | 3 | Foundation equivalencies, International Baccalaureate, Global Assessment Certificate |
| Parser defect D5 (terminal; recoverable by D3) | 2 | Kuwait, Mexico |
| Reader defect D4 (failed; recoverable by D3) | 2 | Colombia, Denmark |
| Held, attempts remaining (queued) | 7 | Indonesia (2 used), Nepal, Nigeria, Norway, Pakistan, Philippines (1 used each), Singapore (0; returned for time budget) |
| Not yet attempted (queued) | 9 | Saudi Arabia, South Korea, Sri Lanka, Taiwan, Thailand, United Arab Emirates, United Kingdom, USA, Vietnam |
| Stored, not yet queued | 1 | Qatar |

**Lanes:**
- RMIT out of scope (D5).
- `entry-matrix-read` active again at 05:29 for UTS and WSU only; 2 providers enabled.
- VU and Federation excluded.
- RMIT AI spend to date: US$0.21.

## 27 Oct 2026 05:50 — Consolidated mandate (Platform Admin 05:46): decisions before code

**Read-only stored-page inspection (tooling, before D5).**
- The mandate requires D5 and D4 tests to use the stored source pages.
- The stored copies are in private storage, and no existing mode returns an entry-matrix page's raw tables. `provider_facts_inspect` and `scholarship_inspect` cover other page kinds.
- **Decision:** add one read-only worker mode, `entry_inspect`, following the existing inspect-mode pattern, plus one service-role path function:
  - it returns, for at most 12 entry sources, the stored copy's `<h1>`, `<title>` and raw `<table>` markup (size-capped), with the content hash;
  - no AI call, no fetch from the web, no write;
  - it ships as its own small PR, so D5 stays one parser-only PR and its deployment evidence stays attributable.
- The fixtures are then saved from the stored copies, each recorded with its content hash.

**D5 design (decided before code), to be confirmed against the stored Kuwait and Mexico tables:**
1. A footnote row (grading or calculation) is recognised before any width check. It publishes no minimum, whatever its width.
2. A data row narrower than the header is accepted only when the missing cells are trailing **and** no merged cell from an earlier row covers those columns. The parser already carries merged cells, so a missing cell there means real loss. Each padded cell is blank and publishes nothing.
3. Any other width mismatch stays `unparsed` (fail closed): a data row wider than the header, or a short row whose missing cells are not trailing.
4. Completeness, identity, whole-run approval, D1 and D2 are untouched.
- Regression: every complete RMIT page's manifest must give the same entries before and after. This is checked on the stored copies of the 12 complete pages and against their proposed rows in the database, without re-reading them.

### 27 Oct 2026 05:57 — AER tooling: read-only `entry_inspect` (#712), written before merge

Authority: Platform Admin 27 Oct 2026 05:46 (consolidated mandate: D5 and D4 tests "must use the stored source pages"). Decision recorded 05:50, before code.
- **Worker v0.48.5:** read-only mode `entry_inspect`. For at most 12 entry-matrix sources it returns the stored copy's `<h1>`, `<title>` and raw `<table>` markup (capped at 120,000 characters), the content hash and the sha256 of the stored text. No AI call, no web fetch, no write.
- **Migration `20261027002000_cf247_entry_matrix_inspect_paths.sql`:** `public.svc_entry_matrix_inspect_paths(uuid[])`, read-only, service role only. Nothing dropped; the consumer API is not touched.
- **Test:** s132 (read-only: no AI, fetch, upload or record call; service role only). Test register regenerated.
- **Gates:**
  - suite 1,034 passed, 0 failed, 0 skipped;
  - worker build OK;
  - live dry run (rolled back): the paths for Kuwait and Mexico are returned with their content hashes.
- Kept apart from D5, so the parser PR stays one change with attributable evidence.

### 27 Oct 2026 06:23 — #712 merged and verified; stored pages captured; D5 (#713) written before merge

**#712 (read-only `entry_inspect`), merged 05:59:18** (squash `0c04c703`).
- Before the merge, the new function was absent live.
- `deploy-on-merge` applied `20261027002000`; history md5 `a510d9f9` matches the file. The function body is byte for byte the file's (md5 `ce67bb7d…`), and it is not executable by `authenticated`.
- Worker version 212: all 17 files byte for byte the repo's.
- Release currentness, run by hand on `0c04c703` (run 40382939223): passed.

**Stored pages captured (06:00):** `entry_inspect` returned the title, h1 and table markup of all 36 RMIT stored copies. Each was written to `tests/fixtures/entry-matrix/rmit-stored/` and its md5 checked against the database copy (36 of 36). With the live parser, every complete page reproduces its live expected count, and the D2 pages their holds.

**D5 design addendum (06:1x, before the final code):**
- Browsers show a short row's cells from the left. A cell missing in the middle therefore shifts the others; s129's "broken" case shows this.
- So a padded row is accepted only when its band cell is blank, "Not applicable", or the same shape as the band cells of the table's full rows ("80%").
- With no full row to compare, a short row is not understood (fail closed).
- Pre-existing behaviour noted, not changed: a blank label on the first data row is carried down from the header row (#707). It cannot pass silently, because no reader gives that level; out of D5's scope.

**D5 (PR #713, branch `cf247-entry-d5`), parser only, no migration:**
- Worker v0.48.6: a footnote row is recognised before any width check (Kuwait: `colspan="3"` under a three-column header).
- A data row whose trailing cells were left out is read with them blank (Mexico 80%), unless:
  - a merged cell from above spans a column past its end (new `covered` flag from `entryTables`), or
  - its band cell does not read as a band.

  Both stay `unparsed`, as does a wider data row.
- **Evidence (s133, on the stored copies):**
  - Kuwait reads 11 minimums, footnote recognised; Mexico reads 6, as printed;
  - a short read, an omitted column, an omitted band and a footnote row cannot pass;
  - 34 other pages keep their manifest and page text byte for byte (pre-D5 fingerprints);
  - the 12 runs complete under the guard stay complete with their own 189 proposed rows, one identity per row;
  - D1 and D2 unchanged.
- Suite 1,042 passed, 0 failed, 0 skipped; worker build OK. No database change, so no database dry run applies; the stored-page tests are the pre-merge evidence.
