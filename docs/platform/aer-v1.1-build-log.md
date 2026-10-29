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
- [~] Stored copies for all 5 pilots: **— SUPERSEDED 27 Oct 2026 12:3x (Platform Admin 12:27): no five-provider stored-copy expansion under the AER freeze; see "AER next actions retired, 27 Oct 12:3x" below. Not executable work.**
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

### 27 Oct 2026 06:28 — Checkpoint 1: D5 merged and verified (#713)

- **Merged 06:24:57** (squash `b94c2df7`).
- Just before the merge, the entry-matrix functions it runs against were unchanged:

  | Function | md5 |
  |---|---|
  | `svc_entry_matrix_next` | `f992b7fc…` |
  | `svc_entry_matrix_record` | `e1a130e2…` |
  | `entry_matrix_review_apply_v1` | `f1152d19…` |
  | `admin_entry_matrix_reread` | `ca394b60…` (#711) |

- `deploy-on-merge` succeeded (worker only, no migration). Worker version 213: all 17 files byte for byte the repo's, `index.ts` at v0.48.6.
- Release currentness, run by hand on `b94c2df7` (run 40386670555): passed.
- **Recovery reads wait** (mandate C: after D4 and D5 are both verified). Kuwait and Mexico stay failed, and RMIT stays out of scope.
- **Recovery mechanism gap, recorded:** the queue takes RMIT runs in creation order, so a hand-started call cannot be aimed at named runs. It would also take the 7 held and 9 unread pages, which the mandate forbids before D4. Targeted recovery needs either a run filter on the hand-started call (a small tooling change, decided separately) or waiting for D4 so that every queued RMIT page may run.

## 27 Oct 2026 06:35 — D4 triage on the stored pages and design (decided before code)

**Triage** (manifests from the stored copies; held reads from `previous_results`):

| Page | Pattern | Evidence |
|---|---|---|
| Denmark | repeated band values skipped | 8 of 22 omitted: band rows whose cell repeats the row above ("Average of 7" at 70% and 75%) |
| Colombia, Nepal, Nigeria | merged "case-by-case" column misread or left out | Colombia's 9 case-by-case cells: grades outside the quote, then bands missing; Nepal's and Nigeria's case-by-case columns (6 cells each) left out |
| Indonesia | grades placed under the wrong printed column | 4-column table; SMA2 given the band-row grades of the Ijazah columns |
| Norway | grades not matching their cells | single column of bare numbers (1, 2.0 … 5.0); 9 rows `grade_not_in_cell` |
| Pakistan, Philippines | **rows returned for cells that publish no minimum** | every published minimum read correctly (5 of 5, 7 of 7), plus 6 rows for Bachelor lines that are all "Not applicable" (`not_a_table_row`) |

All are one defect class: the reader's rows do not correspond one to one with the table's published cells (omitted, misplaced or extra). Pakistan and Philippines are included because their evidence is this class (extra rows).

**Design (one reader-correctness PR, structure-driven, no country-specific code):**
1. **Cell list.** When the stored page has a band table the manifest can read, the worker adds the table's published cells to the reader's request, deterministically from the manifest: for each cell, its level, band, printed column and whole table line, in printed order. The prompt asks for exactly one row per listed cell (that column as the qualification, that level and band, the line as the quote) and no row for any other cell of that table. The quote basis and the page text are unchanged.
2. **No-minimum filter.** A row whose quoted table line publishes no minimum at all (every qualification cell blank or "Not applicable") is dropped before the guard as `no_minimum_published`. Nothing is proposed from it, and nothing expected is removed.
3. **Unchanged:** the completeness guard (still the independent check), whole-run approval, identity, D1, D2, D3 and D5. Expected counts are not lowered.
- Regression on the stored pages: the cell list for every named pattern, and a replay of the actual held reads of Pakistan and Philippines through the no-minimum filter and the guard.

### 27 Oct 2026 06:48 — D4 (#714), written before merge

Authority: Platform Admin 27 Oct 2026 05:46 (consolidated mandate B: D4 as one separate reader-correctness PR). Triage and design recorded 06:35, before code.
- **Worker v0.48.7, prompt `entry-matrix-v0.1.4`:**
  - **Cell list:** when a one-slice stored page has a band table the manifest can read, the reader's request lists the published cells in printed order (level, band, printed column, cell, whole line) and asks for exactly one row per listed cell. A cell list in each slice of a multi-slice page would ask for cells twice, so multi-slice pages are read as before.
  - **No-minimum filter:** `entryDropNoMinimum` drops, before the guard, a row whose quoted table line publishes no minimum (every qualification cell blank or "Not applicable"), as `no_minimum_published`.
  - `entryManifestDetail` returns the manifest unchanged plus those empty lines (s133 fingerprints still pass).
- **Unchanged:** the completeness guard (the independent check), whole-run approval, identity, D1–D3 and D5. No expected count is lowered.
- **Evidence (s134, on the stored pages and the actual held reads):**
  - Denmark: all 22 cells listed, including "Average of 7" on three band rows (65/70/75%);
  - Colombia, Nepal and Nigeria: the merged case-by-case cells listed on each band row (9/6/6);
  - Indonesia: three printed columns at 50%. Norway: its 11 cells;
  - a read that follows the list passes the guard on all eight pages;
  - Pakistan and Philippines: the held reads, replayed, lose only their six "Not applicable" rows and are complete (5/5, 7/7);
  - the other six held reads, replayed, stay held. Nothing incomplete passes without a new read.
- **Gates:** suite 1,050 passed, 0 failed, 0 skipped; worker build OK. No database change, so no database dry run applies; the stored-page tests and replays are the pre-merge evidence.

### 27 Oct 2026 06:59 — D4 (#714) verified; controlled RMIT recovery; AER stopped at new defect classes

Authority: Platform Admin 27 Oct 2026 05:46 (consolidated mandate B and C).

**D4 post-merge (#714, squash `ba1cce46`, merged 06:49:32):**
- `deploy-on-merge` succeeded (run 40390185784), worker only.
- Worker version 214: all 17 deployed files byte for byte the repo's at `ba1cce46` (`coverage-sweep-worker-v0.48.7`).
- Release currentness, run by hand on `ba1cce46` (run 40390267777): passed.
- The entry-matrix functions were unchanged just before the merge.

**Recovery (all logged in `admin_control_events`):**
- 06:54:10: the re-read function's md5 was checked (`ca394b60…`, as guarded). D3 re-read Kuwait and Mexico (D5) and Denmark and Colombia (D4). Their earlier failed results were kept with state, error and attempts used (1, 1, 3, 3), each linked by `earlier_index`. These four failed reads proposed nothing, so nothing was superseded.
- In the same transaction:
  - `entry-matrix-read` was switched off;
  - RMIT was put back in `entry.providers`.
- The last scheduled call (fired 06:54:00) reached the worker after the commit and took the first four runs.
- Hand-started calls at 06:54:39 (2) and 06:55:45 (3), limit 4 each. Qatar was enqueued at 06:55:51 through the existing `entry_matrix_enqueue_v1`.
- The 12 complete pages were not re-read. The 3 D2 pages stayed terminal, with no retry.
- Reads ended about 06:57. RMIT queue: 0 leased.

**Outcome: 36 RMIT pages**

| Outcome | Pages | Detail |
|---|---|---|
| **Complete, in review (earlier, not re-read)** | 12 | Bangladesh 11, Cambodia 11, Canada 24, China 22, Germany 11, Hong Kong 11, India 33, Japan 11, Kenya 9, Malaysia 22, Mauritius 13, New Zealand 11 |
| **Complete, in review (this recovery)** | 13 | Colombia 11, Denmark 22, Indonesia 25, Kuwait 11, Mexico 6, Nepal 11, Pakistan 5, Philippines 7, Saudi Arabia 2, South Korea 22, Taiwan 26, UAE 2, USA 24 |
| **Non-country, terminal hold (D2)** | 3 | Foundation equivalencies, International Baccalaureate, Global Assessment Certificate. No retry |
| **Legitimate source hold** | 0 | |
| **Still defective: guard (new class G1)** | 3 | Sri Lanka, Thailand, United Kingdom. The guard's column match ignores one-character words, so two columns that differ only by one tie, and a correctly read row is refused as `qualification_not_resolved`. Examples: "Sri Lanka **O** Levels" vs "**A** Levels", "Matayom **5**" vs "**6**", Scottish Higher "(**3** subjects)" vs "(**4**)". The held rows were checked and name the right column. Held, with attempts left (2, 2, 2) |
| **Still defective: parser (new class P2)** | 1 | Singapore. A repeated header row in the table body ("Level of study \| Australian standard \| …", with an empty last cell) is counted as 2 data cells. Expected 11, published 9; the reader read the 9. This predates D5: Singapore's manifest is in the s133 unchanged-34 set. Held, 1 attempt left |
| **Still defective: reader, scale (new class R2)** | 1 | Norway. The page prints bare numbers (1, 2.0 … 5.0). The reader now quotes all 11 cells correctly, but gives a numeric value with scale "none", which the reader check refuses as `value_without_scale`. Failed (3 attempts) |
| **Still defective: reader, D4 class not resolved on this page** | 2 | Nigeria: the merged case-by-case column (6 cells) was left out on all 3 attempts despite the cell list; failed. Vietnam: 18 of 31 listed cells returned (short read, held by the guard); 2 attempts left |
| **Not read (lane paused before its turn)** | 1 | Qatar: enqueued 06:55:51, 0 attempts |

**Checks:**
- **Silent partial reads: 0.** Every page that is not complete is held by the guard or terminal.
- 363 proposed rows, 363 distinct identities, 0 duplicate identities across RMIT runs.
- Active entry-matrix rows (any provider): 0. Review items: 25 pending; none approved.
- Cost of the recovery reads: at most US$0.157 (the sum over the 21 runs touched, which includes earlier attempts on the retried runs).

**Stop under the mandate.** The recovery exposed three new defect classes (G1 guard column tie, P2 repeated header row, R2 bare-number scale). D4 also did not resolve Nigeria or Vietnam. The mandate authorises D5 and D4 only: no D6+ was started.
- The lane stays paused.
- The 6 held pages are not given further attempts.
- Qatar is not read.
- AER expansion is frozen under this mandate.
- The fixes these classes need are named here, for a Platform Admin decision.

**Lane state at 06:59:**
- `entry-matrix-read` is off.
- UTS and WSU have 0 queued runs (drained), so this does not stall them.
- The change returning `entry.providers` to UTS and WSU only was attempted three times from 06:56 and cancelled each time before it ran. RMIT is therefore still listed in the setting, but nothing reads it: the job is off and no call is started by hand.
- The job goes back on only after RMIT is out of scope.

### 27 Oct 2026 07:02 — RMIT lane paused, scheduled reader restored for UTS and WSU

- 07:02:15: `entry.providers` was set back to UTS and WSU only (event 21716). The three earlier attempts from 06:56 had been cancelled before they ran.
- 07:02:22: `entry-matrix-read` was switched back on, for UTS and WSU only (logged).
- RMIT is paused, with 6 held runs and Qatar left as they stand. No further attempts are made under this mandate.

## Layer 4 Triage — 26 Oct Night Run

Lodged 27 Oct 2026 08:49 AEDT. Triage results approved by the Platform Admin on 27 Oct at 08:47. The decisions were made through the extension on 26 Oct, 20:46–21:51 AEDT.

| University | Items | Decisions | Queue |
|---|---|---|---|
| University of Auckland | 45 | 15 course links: keep held page. 1 course link: use new page (Master of Civil Engineering). 10 scholarships: publish. 1 not a scholarship (Manaaki story page). 16 not for international. 2 first-run approvals | Empty |
| Massey University | 35 | 5 scholarships: publish. 28 not for international. 2 first-run approvals | Empty |
| University of Canterbury | 7 | 1 scholarship: publish (Manaaki). 4 not for international. 2 first-run approvals | Empty |
| University of Otago | 16 | 8 course links: keep held page. 3 scholarships: publish. 3 not for international. 1 adapter: rebuild. 1 first-run approval | Empty |
| University of Queensland | 27 | 2 scholarships: publish. 23 not for international. 2 first-run approvals | Empty |
| RMIT University | 22 | 1 scholarship: publish (Vietnam PhD). 18 not for international. 2 first-run approvals. **1 blocked** (below) | 21 of 22 decided |
| UTS | 18 | 10 scholarships: publish. 7 not for international. 1 first-run approval | Empty |
| AUT | 40 | 34 course links: keep held page. 4 course links: use new page (conjoints and paramedic). 2 first-run approvals | Empty |
| Lincoln University | 3 | 1 scholarship: publish (CSC China). 1 not for international. 1 first-run approval | Empty |
| **Total** | **213** | 33 scholarships published; 100 not for international; 1 not a scholarship; 57 course links kept; 5 moved to a new page; 1 adapter rebuild; 15 first-run approvals; 1 blocked | |

**Checked against live (27 Oct, 08:4x):**
- 134 scholarship review decisions were recorded on 26 Oct, 20:46–21:51 AEDT. That equals the scholarship decisions above, and each university matches: Auckland 27, Massey 33, Canterbury 5, Otago 6, Queensland 25, RMIT 19, UTS 17, Lincoln 2.
- In the same window, 217 Layer 4 inbox decisions were recorded.
- None of these universities has a pending scholarship review, apart from the RMIT item below.

**Blocked: RMIT Australia Awards Scholarships** (scholarship review 1965, https://www.rmit.edu.au/scholarships/international-scholarships/australia-awards-scholarships)
- Publish is the right decision: the scholarship is explicitly for international students and covers full tuition and benefits.
- The publish path returned HTTP 500 timeouts on 8 tries. The failure is specific to this record, not to the session.
- **Not retried** through the extension.
- Logged in the audit trail as **"approved pending technical resolution"** (`admin_control_events` 21727, 27 Oct 08:49). The review stays `pending` until the platform fix.
- Owner: the platform team, at the Wednesday morning platform health check.

**Auto-admit bootstrap:**
- 6 shapes proven across 7 universities, through the 15 first-run approvals.
- About 10 remaining first runs per shape release automatically on the next hourly run. About 60–90 more courses are expected to be auto-approved; this is to be measured on that run, not assumed.

**Scholarship pattern:** about 74% of held scholarships were "not for international", which is expected (domestic-targeted awards). International eligibility detection is working, and no tuning is needed.

**Found during the check, not in the triage scope:**
- 23 scholarship reviews are pending under the provider record **"RMIT University Pathways, RMIT UP"**. 22 of them are rmit.edu.au scholarship pages, such as the Vietnam PhD (STEM) page, the UniLodge page and CPP.
- These are RMIT's own scholarship pages filed under the RMIT UP record. They are an identity question about which provider owns them, for the Platform Admin, not a triage miss.

**Next actions in the 08:47 note that this record does not act on** *(both SUPERSEDED 27 Oct 12:3x, Platform Admin 12:27; see "AER next actions retired" below)*: "Continue AER schema PR (additive columns to `provider_entry_matrix`)" and "Continue stored copies for 5 pilot providers".
- The Platform Admin mandate of 27 Oct 08:15 froze AER: no D6+, RMIT paused, no recovery reads, and no change to `entry-matrix-read`.
- The entry-matrix schema has been live since #706.
- These two actions look like they come from an earlier plan, so they wait for the Platform Admin to confirm.

### 27 Oct 2026 12:3x — AER next actions retired (superseded, not pending)

Authority: Platform Admin 27 Oct 2026 12:27 ("The following are superseded, not pending"). The current mandates are 27 Oct 08:15 (AER frozen) and 12:27.

| Next action | Status | Evidence |
|---|---|---|
| "Continue AER schema PR (additive columns to `provider_entry_matrix`)" | **Superseded** | The schema has been live since #706, merged and verified, as recorded in this log's "06:00 status": "Schema merged and live (additive, switched off): #706". No schema PR is open or needed |
| "Continue stored copies for 5 pilot providers" (this log's 06:00 status: "[~] Stored copies for all 5 pilots") | **Superseded** | The AER freeze (08:15, items 1 and 3). The provider scope stays as follows: RMIT paused and out of `entry.providers`; UTS and WSU only, unchanged; VU and Federation not activated; no PDF work. RMIT's 36 pages are all stored. Its outcome table is in "27 Oct 06:59" above |

- Neither item is executable work.
- The earlier entries are kept as written; only a pointer to this entry was added beside them.
- AER remains frozen:
  - no D6+;
  - no further RMIT reads;
  - no five-provider stored-copy expansion;
  - no PDF work;
  - no VU or Federation activation.
- The 8 defective RMIT runs stay held and Qatar stays unread. This is recorded as a bounded pilot with named defects, not a stalled lane.

### 27 Oct 2026 14:38–14:39 — RMIT pilot: 25 complete runs individually reviewed and admitted

Authority: Platform Admin mandate 27 Oct 2026 14:35, P2.1. The AER freeze is lifted for the RMIT pilot closure only.

**Review method (each run separately):**
- Each run's proposed rows were taken from live and recomputed offline against its stored source page. The fixtures under `tests/fixtures/entry-matrix/rmit-stored/` are the same sha256 as each run's stored copy.
- The checks used the current code (worker v0.48.7 `entry.ts`):
  - manifest;
  - reader checks;
  - completeness guard;
  - a one-to-one match of each row with a manifest entry (same level, band and line, and grade within the cell);
  - distinct identities;
  - one country per run;
  - no value without a scale;
  - not a non-country table.
- **Result: all 25 complete.** Rows equal expected equal matched on every run, with 0 dropped and 0 unexplained.
- Two notes, neither a gate failure:
  - **Kuwait:** the 11 rows are correct cell for cell, but 8 quotes leave out the "%" printed in the cell ("Minimum average of 75." for "Minimum average of 75%."). The existing quote gate compares normalised text, so it passes. Recorded; not changed.
  - **USA:** the page heading says "USA". The run's verdict is complete with the reader's own country name. Replaying it with the reference name "United States of America" fails only the heading check, which is a replay artefact.

**Admission** through the governed Layer 4 path (`layer4_review_decide`, approve; one decision each, with the per-run reason). Bangladesh was admitted at 14:38:27 and the other 24 by 14:39:26.

| | |
|---|---|
| Runs admitted | **25 of 25** (whole-run; no exclusions, no partial admission) |
| **Active entry-matrix rows (RMIT)** | **363** (25 countries), 363 distinct identities |
| Duplicate active identities (any provider) | 0 |
| Pending RMIT entry-matrix items | 0. The 1 pending item platform-wide is UTS's |
| Consumer API | Not touched; entry-matrix tables are not in the consumer baseline |
| Cost | US$0. No reads |

**Recording defect (named, not fixed under this mandate):**
- A run's Layer 4 item keeps the `proposed_value` sample from the read that created it. After later re-reads (D3, or retries), the item's sample is stale. For example, Bangladesh's item shows 12 sample rows from its first read, 6 of them with no band, from before the band fix.
- So each decision row's `final_value` records that stale sample. The admitted rows themselves are correct: 11 active, one per published cell, from the run.
- This is an audit-trail accuracy issue for the platform team.

### 27 Oct 2026 16:10 — AER PR A (G1, P2, R2), written before merge

Authority: Platform Admin 27 Oct 2026 14:35 (Priority 2: PR A covers the Sri Lanka, Thailand and UK column tie, the Singapore repeated header and the Norway scale; stored pages and regression fixtures; D1–D5 kept). Scale rule: Platform Admin answer at about 15:00: "hold every bare-number column whose scale is not printed or otherwise explicitly evidenced on the official source. Do not infer or invent a generic 'points' scale."

- **Worker v0.48.8, prompt unchanged (`entry-matrix-v0.1.4`):**
  - **G1 (guard):** when two columns tie on the word score, the tie is broken by the same score over every word, single characters included. A column is accepted only if it is then strictly the best; otherwise the row stays `qualification_not_resolved`. The first version compared the new score with the old one and never resolved; this was caught by the replay before commit.
  - **P2 (manifest):** a body row whose non-blank cells all repeat their column headings is the header printed again, not a row of minimums.
  - **R2 (source hold):** a qualification column whose every published cell is a bare number, with no scale printed in the heading, the column heading or a grading row, holds the page before any AI read as `held_unparsed: no printed scale: bare numbers in <columns>`. This is terminal, with no retry. No scale is inferred.
- **Evidence (s135, stored pages and the actual held reads, nothing read again):**
  - **Sri Lanka and Thailand:** the held reads, replayed, are complete (13/13, 13/13).
  - **United Kingdom:** the held read is now fully explained, with 0 unexplained rows, but it is 29 of 31 because the read left 2 cells out. A new read is needed (D3).
  - **Singapore:** 9 minimums (11 before), and its held read is complete (9/9). Page text is unchanged.
  - **Foundation equivalencies:** P2 also removes its three repeated header rows (24 to 21). It is still held by D2.
  - **R2 flags exactly three columns on the 36 pages:**
    - Norway;
    - China "Gao Kao (National College Entrance Examination, NCEE) - Beijing";
    - Germany "Abitur/Fachhochschulreife".
  - **Unchanged pages:** every other stored page keeps its manifest byte for byte (32 pages).
  - **The 25 admitted runs:** all stay complete with their own rows, 363 rows, one identity per row. China and Germany are the only ones R2 would hold on a new read.
  - **Tie negatives:** a tie no word can break stays not resolved, and a row naming the other tied column is refused as `wrong_column`.
- **Specs:** s129, s131, s133 and s134 expectations updated where v0.48.8 changes a line they quote or a manifest they fingerprint (Singapore and Foundation equivalencies move to s135).
- **Gates:** local suite 1,055 passed, 0 failed, 0 skipped (`@deployed` excluded). Build OK. No database change, so no database dry run applies.
- **Not in this PR:**
  - Nigeria and Vietnam (PR B).
  - Recovery: D3 runs after deploy verification, for the affected runs only.
  - The 20 China/Germany rows: these are quarantined by the separate manual paste `PASTE-20261027-aer-unscaled-quarantine.sql` (md5 `49a49ab1…`; dry run passed; not yet applied).

### 27 Oct 2026 16:40 — AER PR A (#715) verified; recovery pastes prepared (not applied)

- **Merge:** squash `c9d333a2`. All checks green before merge (build-and-smoke, Workers Builds).
- **Post-merge:** deploy-on-merge succeeded (run 40454662386), and the deployed UAT run also succeeded. Worker version 215: all 17 deployed files are byte for byte the repo's at `c9d333a2` (`coverage-sweep-worker-v0.48.8`).
- **Recovery (D3, affected runs only):** two pastes for the Platform Admin, `PASTE-20261027-aer-pr-a-recovery-open.sql` (md5 `f9d36c13…`) and `…-close.sql` (md5 `61a2a5d6…`).
  - **Open:**
    - holds Vietnam until PR B (state failed with the reason, history kept);
    - re-queues Norway through the guarded D3 function, so it will be held before any AI read under R2;
    - adds RMIT to `entry.providers`.
  - **Close:** restores UTS + WSU once the runs have settled.
  - **Dry run (rolled back), with a real claim call:** the worker would take exactly Norway, Qatar, Singapore, Sri Lanka, Thailand and the UK.
    - The 25 complete runs, the 3 D2 pages and Nigeria are not claimable.
    - No RMIT source is due for fetching.
    - Close restored UTS + WSU.
- **Recorded, not acted on (new class candidate, Nigeria):** six Nigeria cells read "This qualification does not give you entry to this program". The manifest counts them as published minimums, so a complete read would propose them as minimum grades.
  - No other stored page has such a cell, and none of the 25 admitted runs carries one.
  - This is raised with the Platform Admin before PR B. It is not added to PR B silently.

### 27 Oct 2026 21:51 — AER PR A recovery-open paste verified (read only)

Applied at 21:50:00 AEDT (events 22140 re-read and 22141 open).

- **`entry.providers`:** UTS, WSU and RMIT.
- **Vietnam:** held (failed, "held: AER PR B…", history kept).
- **Norway:** re-queued through the guarded D3 function (1 run; 0 rows and 0 items superseded).
- **Claimable:** exactly the six runs, all queued: Norway, Qatar, Singapore, Sri Lanka, Thailand and the UK.
- **Untouched:** the 25 complete runs are done; Nigeria and the 3 D2 pages are failed and not claimable.
- **Fetching:** all 36 RMIT sources are read, so none is due for fetching.
- **State before any read:** RMIT active rows 343, no new proposed rows, worker v0.48.8.
- **Reads start:** at the next scheduled `entry-matrix-read` call (every 5 minutes). The close paste is applied once none of the six is queued or leased.

### 27 Oct 2026 22:2x — Decision 268 lodged (governed actions; SQL break-glass); AER PR A recovery settled; RMIT scope exception owned

Authority: Platform Admin 27 Oct 2026 21:57 (final consolidated mandate) and 22:00 (correction, and option 3). Decision: `docs/coursefinder-design-reference-v1.4.md` Decision 268, lodged before any code.

**Correction to the record.** The 21:57 mandate said the AER PR A recovery had never opened. It had.
- The open paste was applied at 21:50:00 AEDT (event 22140 re-read Norway; event 22141 opened the recovery).
- The deployed worker v0.48.8 then read the six runs.
- No record here says the recovery was never opened.

**Recovery outcome (all six settled at 22:05:20; nothing admitted):**

| Run | Outcome | Attempts | Tonight's cost (USD) |
|---|---|---|---|
| Norway | held before any AI read: `held_unparsed: no printed scale` (terminal) | 1 | 0 |
| Singapore | complete 9/9; 9 rows proposed; Layer 4 item bcd9f55b pending | 3 | 0.0035 |
| Sri Lanka | complete 13/13; 13 proposed; item 8a803c95 pending | 2 | 0.0037 |
| Thailand | complete 13/13; 13 proposed; item f56bd767 pending | 2 | 0.0035 |
| Qatar | complete 2/2; 2 proposed; item 9adbeada pending | 1 | 0.0012 |
| United Kingdom | held after its third and last attempt: `held_incomplete: 2 of 31 published minimums not read` (failed, history kept: 3 earlier results). This is the reader leaving cells out (the omitted-cell class PR B addressed); no fix is started. | 3 | 0.0150 |

- **Total model cost:** US$0.027.
- **RMIT entry-matrix rows:** 343 active (none changed), 37 proposed (all tonight; 4 pending Layer 4 items), 20 quarantined (unchanged), 167 superseded.
- **Duplicates:** 0 proposed rows duplicate an active identity, and 0 duplicate each other.
- **Untouched:** Vietnam (held for PR B), Nigeria, the three D2 pages and the 25 earlier complete runs.

**Temporary operational exception (owned; not a steady state).**
- RMIT stays in `entry.providers` (with UTS and WSU) until the Platform Admin approves the governed closure in the UI.
- **Verified live at 22:0x that no RMIT read can start before then:**
  - no RMIT run is queued or leased, and none is claimable (0);
  - all 36 sources are `read` and each has a run for its current content, so nothing is queued afresh;
  - RMIT has 36 sources, more than the attach limit (`entry.attach_per_provider`, 3);
  - a done run is never claimed again; only the logged D3 re-read, a Platform Admin action, can re-queue it.
- **The one remaining path is the 30-day refresh** (`entry.matrix_refresh_days`, 30). It first falls due on 25 Nov 2026 at 21:59 AEDT (earliest direct read 26 Oct 21:59). The governed closure must be approved before then.
- Owner: Platform Admin.

**In-flight branches and PRs (actual state).** There are no open PRs on the code repo; `main` is at `c9d333a2` (#715).
- **Remote branches:**
  - `cf247-aer-pr-a-structure` is merged (#715) and can be deleted.
  - `cf247-aer-v11-schema` is an earlier AER branch, not touched tonight.
- **Lost local work:**
  - The PR B reader changes (Nigeria no-entry cells, omitted-cell follow-up, Vietnam table keys; s137) were never committed or pushed. They were lost when the session environment was replaced.
  - The measurement-only "awaiting Layer 3" branch (migration `20261027003000`, s136) was committed locally but never pushed, opened as a PR or merged. Its migration was only dry-run, so nothing was applied. It was lost the same way.
  - Under the mandate neither is rebuilt; both are recorded as not built.

**Retired from the active next-action lists (paste era; superseded by Decision 268):**
- the PR A recovery close paste (`PASTE-20261027-aer-pr-a-recovery-close.sql`): replaced by the governed closure;
- "verify after the Platform Admin applies the paste" follow-ups;
- the plan to present PR B's D3 recovery as a paste pair (PR B is frozen);
- the UNSW faculty-mapping build (frozen);
- further fee-window or withdrawal pastes (separate decisions).

**Next:** the governed-action vertical slice under Decision 268. Its first and only action adopts and closes this recovery on the Platform Admin's UI approval. After closure, work stops.

### 27 Oct 2026 23:3x — Decision 268 vertical slice (v2.15.360): governed action runner and its first action, written before merge

Authority: Platform Admin 27 Oct 2026 21:57 (final consolidated mandate) and 22:00 (correction; the first action adopts and closes the recovery already open). Decision 268 was lodged at 22:2x, before any code.

- **Database** (migration `20261027003000_cf247_governed_action_aer_recovery_close.sql`, md5 `4c9f4e49…`; no new table, reader, status or consumer field):
  - **`public.admin_governed_action(text, jsonb)`**. Only a Platform Admin can call it: the server checks the session and role rank 6. One allowlisted action (`aer_pr_a_recovery_close`) with fixed parameters; no SQL text is ever taken from a request. Three requests:
    - `read`;
    - `preview`: the live snapshot, a dry run of the action's own step that is rolled back, an action hash, and an approval that expires after `governed.approval_minutes` (15). The preview is logged.
    - `approve`. It holds one lock per action and needs a reason and an idempotency key; a repeated key returns the first result and runs nothing. It then revalidates: the preview must be the same Platform Admin's, unexpired and matching the hash, and the live state must be unchanged. A refusal changes nothing and is recorded with its reason. The run itself and its five post-checks happen together, followed by a linked audit event. A failure leaves nothing changed and is recorded, and the action pauses after `governed.max_attempts` (3) failures.
  - **`security.governed_aer_close_snapshot_v1()`** (read only): the six runs' outcomes and the cost since the recovery opened, the counts, the scope, the five held pages, and ten preconditions:
    - the open event (22141);
    - RMIT's scope (UTS, WSU and RMIT);
    - the six settled runs;
    - nothing claimable;
    - 343 active rows;
    - 20 quarantined;
    - 37 proposed;
    - the 4 pending Layer 4 items;
    - Vietnam, Nigeria and the three D2 pages held;
    - six entry-lane function md5s.
  - **Task kind `governed_action`:** each approval is one `pipeline.admin_jobs` row, written only as `done`, `failed` or `cancelled` (refused). These are existing states; the row is never queued, so the task runner never takes it. A unique index on its idempotency key backs the repeated-click rule.
  - **Settings:** `governed.approval_minutes` and `governed.max_attempts`, both shown on the Settings page.
- **The action:** on approval it takes RMIT out of `entry.providers`, restoring UTS and WSU. It admits nothing, touches no run, row or item, and leaves the 37 proposed rows with Layer 4 review.
- **UI:** `GovernedActions.jsx` (md5 `221e97c9…`) is a section of Layer 2/3 › Operations shown only to Platform Admins; it is not a new page. It shows:
  - the six outcomes, attempts and cost;
  - the proposed, active and quarantined counts;
  - the reading scope now and after;
  - the pages left as they are.

  **Preview against the live system** lists every precondition (expected and now), the dry run, the hash and the expiry. **Approve and run** needs a reason and carries the key made with the preview. Done, Refused and Failed are shown with the post-checks, the audit event and the history.
- **SOP:** Platform Admin SOP 1.54 replaces the "paste file" duty with "A governed action ready to review", and adds "Break-glass only: SQL for a change that drops or deletes, or an operation no governed action covers". UI catalogue v1.10.
- **Release:** v2.15.360 / package 0.1.287 (manifest, release notes, changelog, guide and SOP review markers).
- **Also fixed:** Edit in list saved a duration twice when its inputs were disabled while saving (a blur in current Chromium). One save at a time per cell (`ListEdit.jsx`). The list-edit spec showed it in this environment; it also failed on `main`.
- **Spec:** s138 (`// Guards:` Decision 268); release-history spec raised to v2.15.360. G2 is covered by s32 and G3 by s57, as their central guards.
- **Live dry run (rolled back), run as the Platform Admin on the live database:**
  - the migration applied;
  - the preview passed all ten checks, and its dry run gave scope UTS and WSU with RMIT out;
  - an approval with a mismatched hash was refused ("the approval does not match the preview");
  - the real approval ran (`done`), and all five post-checks were true: scope restored, RMIT out, UTS and WSU in, counts unchanged, runs unchanged;
  - the same click again returned the same task, marked repeated, and ran nothing;
  - the history showed 2 tasks, and the audit trail preview, refused, executed.
  - Afterwards, live was unchanged: RMIT still in scope and none of the new objects present.
- **Not run after deployment:** the action waits for the Platform Admin's approval in the UI.

### 27 Oct 2026 23:5x — Decision 268 slice (#716) merged, deployed and verified; governed action ready for the Platform Admin's approval

- **Merge:** squash `f33e4702`. All PR checks were green (build-and-smoke, release-history-contract, Workers Builds).
- **Post-merge workflows, all successful:** Deploy on merge (40498032373), Release Currentness Deployed (40498032344, run automatically because the release files changed), Release History Contract, CourseFinder Deployed UAT and Pilot Frontend Build.
- **Live database matches the repository:**
  - the migration-history row for `20261027003000` has md5 `4c9f4e49…`, the file's;
  - `public.admin_governed_action` and `security.governed_aer_close_snapshot_v1` are present;
  - task kind `governed_action`, the idempotency index and the settings (`governed.approval_minutes` 15, `governed.max_attempts` 3) are in place.
- **Not run:** 0 governed-action tasks and 0 governed-action events. RMIT is still in `entry.providers` (the owned exception) until the Platform Admin approves in the UI.
- **Live preconditions now:** all ten pass. Counts: 343 active, 37 proposed in 4 pending Layer 4 items, 20 quarantined. Recovery cost US$0.0269. Refresh risk from 25 Nov 2026 21:59 AEDT.
- **Next:** the Platform Admin previews and approves on Layer 2/3 › Operations › Governed actions. After the closure, the verification is recorded and work stops.

### 27 Oct 2026 22:47 — AER PR A recovery closed through the governed UI action (Decision 268); verified; work stopped

- **Approval and closure (actual times, AEDT):**
  - preview by the Platform Admin at 22:46:24 (event 22685, action hash `0c11d809…`; dry run rolled back with scope UTS and WSU);
  - approved and run at 22:46:54 (reason "Approval l2l3"); task `c24fe0d7-8771-4bb9-bf7a-6f832f840169`, state `done`, audit event 22686 (`executed`).
- **Ran exactly once:** 1 governed-action task (done) and 2 governed-action events (preview, executed); 0 refused, 0 failed, 0 queued.
  - Idempotent: a repeat with the same approval key returns the first task marked repeated (unique index `admin_jobs_governed_idempotency_uq` live); a new approval is refused as "already done". No repeat was run against live for this check.
- **Scope:** `entry.providers` is now UTS and WSU (before: UTS, WSU and RMIT). RMIT is out of scope; UTS and WSU are in. The setting's change reason names the governed action.
  - **The RMIT scope exception recorded at 22:2x is closed.**
- **Post-checks in the task result, all true:** scope restored, RMIT out of scope, UTS and WSU in scope, counts unchanged, runs unchanged.
- **RMIT rows, unchanged:** 343 active, 20 quarantined (status `unverified`), 37 proposed, 167 superseded. No entry-matrix row changed after the preview.
- **Nothing admitted:** the 37 proposed rows remain in their four Layer 4 items, all pending (Qatar 2, Singapore 9, Sri Lanka 13, Thailand 13). They remain a separate Layer 4 review task.
- **The six recovery runs kept their outcomes and history.** Last changed 21:54–22:05, before the closure.
  - Qatar, Singapore, Sri Lanka and Thailand are complete.
  - Norway is held before any AI read.
  - The UK is held after its third attempt (2 of 31 not read).
  - Previous results are retained.
- **No new read and no new cost:** 0 entry-matrix runs created or changed since the preview; 0 RMIT runs queued or being read.
- **Recovery cost, reconciled:** US$0.0268956 (US$0.027).
  - The cumulative cost of the six runs is US$0.0561392.
  - Less their cost when the recovery opened at 21:50, that leaves Singapore 0.0034884, Sri Lanka 0.0037492, Thailand 0.0034916, Qatar 0.0012016, the UK 0.0149648 and Norway 0.
- **Consumer API (G3):** unchanged. 73 functions and 48 relations match the 18 Oct baseline (0 changed, missing or new).
- **Other activity in the same minutes:** 33 Layer 4, scholarship-review and adapter decisions by Platform Admin users between 22:46:59 and 22:49. None of them touch RMIT or the four items.
- **Time correction:** the earlier entries labelled "23:3x" and "23:5x" were written at 22:39 (change control before merge) and 22:43 (merged, deployed and ready) AEDT. The 21:50 recovery-open time stands.
- **Stopped:** no PR B, no further recovery, no other governed action and no new reader. Further governed actions are separate decisions.

### 28 Oct 2026 21:2x — Track C Step B (bounded RMIT slice): decision lodged before code

- **Mandate:** Platform Admin, 28 Oct 2026 20:36: deliver Track C Step B (B1–B5) as one bounded RMIT slice, under `ENTRY-REQUIREMENTS-IMPLEMENTATION.md` 2.3–2.5.
- **Decision record:** `docs/platform/ENTRY-REQUIREMENTS-STEP-B-DECISION-2026-10-28.md`.
- **Course:** RMIT Bachelor of Engineering (Honours) BH126 (course `09431698…`, CRICOS 0100714), India.
  - The page prints "2027 Guaranteed ATAR 75.00" and VCE prerequisites, but no percentage band.
  - **Platform Admin decision (28 Oct):** no mapping from the ATAR to a band. The ATAR is stored as published, and India resolves honestly to step 5 (contact RMIT). The band-ladder rule is proved by rolled-back fixtures only.
  - **Platform Admin decision (28 Oct):** B4 is the developer pack only. The consumer course page is website-team integration, not claimed live.
- **Build:**
  - B1 rides the existing Enrich fields lane (new field `entry_requirements`, not in the field registry; stored page only; AU strong identity proofs). It runs one count-guarded slice read for BH126. Rows go to Layer 4 (`course_entry_first_read`, human admission).
  - Resolver `security.entry_resolve_v1`, five rules, active rows only.
  - B5 sections in the existing Provider drawer and Course detail blade.
  - B2/B3 consumer keys with `edu_country`, as a paste-reviewed held PR (never auto-merged).
- **Excluded:** PR B, other countries, quarantine work, PDF/JS/new providers, Step C, scholarship fields and the 37 proposed matrix rows.

### 28 Oct 2026 21:3x — Track C Step B platform PR #717 (v2.15.361), written before merge

- **PR:** #717 (`cf247-track-c-step-b-slice`), release v2.15.361, worker v0.49.0.
- **Time correction:** the decision record was lodged at 20:54 AEDT (admin `63126bd3`), not 21:2x as its entry says.
- **Migration** `20261028001000_cf247_entry_step_b_course_read_resolver.sql`:
  - **B1:** field `entry_requirements` on the existing Enrich fields lane. It is not in the field registry; AU source rule `{ai_stored}`; AU identity `cricos_code` / `adapter_code` / `manual`.
    - `security.enrich_entry_record_v1` applies the B1 rules. Rows land `proposed`, with Layer 4 `course_entry_first_read`.
    - `security.course_entry_review_apply_v1` (decide branch and trigger) admits a read or quarantines it.
  - **Resolver** `security.entry_resolve_v1` (five rules, active rows only).
  - **`public.admin_entry_requirements`:** bounded reads and the one-course read (Platform Admin).
  - **Settings:** `entry.course_read_countries`, `entry.max_rows_per_course`, `entry.min_confidence`, `entry.course_page_chars`, `entry.level_equivalents`.
  - **One count-guarded slice read** for BH126.
  - **md5-guarded edits:** `svc_enrich_ai_record` (`c3685d7a…`), `svc_enrich_ai_next` (`0ad1ad53…`), `layer4_review_decide_impl` (`a438f594…`).
- **Worker v0.49.0:** one entry call per course with the pinned entry model; each row's quote must be on the page.
- **UI:** Provider drawer and Course detail blade sections (`EntryRequirements.jsx`).
- **Tests:** s114, s139 and s140.
- **Live dry run (rolled back, `db-apply-migration` on the scratch branch;; 28 Oct 2026):**
  - the slice item was enqueued (1, `queued` / `enrich`);
  - **B1 fixture answer:**
    - ATAR kept as `minimum_grade` with basis "2027 Guaranteed ATAR", audience domestic, the band dropped as not printed;
    - the prerequisite kept (domestic);
    - the IELTS row dropped (`english_duplicate`);
    - a score whose basis was not in the quote dropped (`score_without_basis`);
    - Layer 4 item opened; item `review`; a second read while pending was refused (`already`);
    - approve admitted 2.
  - **BH126 India: step 5, contact the provider**, with the note that RMIT publishes an India band table but the course page prints no band.
  - **Fixture rules:**
    - rule 3 with a printed 75% band → AISSC 75%, ISC 75%, State Boards 80% (BH=BA);
    - rule 4 → case by case;
    - rule 2 → course row;
    - rule 1 → override;
    - a proposed override is ignored (step 2);
    - `ZZ` → `INVALID_INPUT`.
  - **Admin reads:**
    - India narrowed (34 of 34 rows, page size capped at 100);
    - all rows paged (50 of 569);
    - course view `can_read` with `cricos_code`.
  - **RMIT matrix unchanged:** 343 active, 37 proposed, 167 superseded, 20 quarantined.
- **Suite:** 1,077 passed, 0 failed, 0 skipped. **Build:** OK. **PR checks:** build-and-smoke, release-history-contract and Workers Builds all green.
- **Suite fixes in the same PR:** worker-version patterns in s127, s128, s129, s134 and s135 accept v0.49; s36 follows the per-call model check; SOPs reviewed (admin SOP 1.55: Course entry first read, Read from the stored page).
- **Live md5s** of the three edited functions verified just before merge: `svc_enrich_ai_record` `c3685d7a…`, `svc_enrich_ai_next` `0ad1ad53…`, `layer4_review_decide_impl` `a438f594…`. All match the guards.
- **Consumer API:** not touched (B2/B3 is a separate, paste-reviewed change).
- **Consumer PR (B2/B3), held:**
  - branch `cf247-track-c-step-b-consumer-api`, migration `20261028002000` (md5 `efe556c2…`), paste `docs/platform/pastes/PASTE-20261028-entry-consumer-api.sql`;
  - live dry run (rolled back):
    - course keys added: only `entry`; the rest identical;
    - provider keys added: only `entry_matrix`; the rest identical;
    - with an admitted fixture read, `entry` is min_score 75, basis "2027 Guaranteed ATAR", band null, one prerequisite;
    - IN resolution: step 5, contact the provider;
    - matrix: 343 rows, or 33 with IN (IN only);
    - invalid `edu_country` refused;
    - baseline re-taken: 75 functions, 48 relations.

### 28 Oct 2026 21:5x — #717 merged and deployed; the slice read was taken by the old worker; follow-up #718 written before merge

- **#717 merged 21:38** (squash `c6fd9207`). Post-merge workflows all passed:
  - Deploy on merge;
  - Release Currentness Deployed;
  - Release History Contract;
  - CourseFinder Deployed UAT;
  - Pilot Frontend Build.
- **Live matches the repository:**
  - migration-history md5 `2f0e922a…` equals the file's;
  - `security.entry_resolve_v1`, `public.admin_entry_requirements` and the `svc_enrich_ai_record` branch are present;
  - the worker has answered as v0.49.0 since 21:40:06 (mode ledger).
- **The slice read went wrong (recorded as found).** Deploy-on-merge applies migrations before it deploys functions. The count-guarded slice item was therefore taken at 21:39:10 by the **previous worker, v0.48.8**.
  - That worker asked the field as a generic one: "the page does not state it", US$0.0024, 0 rows.
  - No entry reader has read the page yet. Its no-value flag would also hold any new read.
  - The stored copy does hold entry text; the adapter read "You must have successfully completed the Victorian Certificate of Education (VCE) … Prerequisites …".
- **Unchanged:**
  - RMIT matrix 343 active, 37 proposed, 167 superseded, 20 quarantined;
  - `entry.providers` is UTS and WSU;
  - `course_entry_requirements` holds 0 rows.
- **#718 (worker v0.49.1, migration `20261028003000`), written before merge:**
  - the entry read uses the whole page text, not only `<main>` (a precaution);
  - `security.course_entry_read_enqueue_v1` (md5-guarded) releases the field's no-value hold and refuses loudly if the item gate drops the item;
  - no read is enqueued in it;
  - live dry run (rolled back): enqueue gave job queued, 2 items, flag released;
  - suite 1,078 passed, 0 failed, 0 skipped. Guards: s139.
- **Next:**
  - the slice re-read goes in its own migration (`20261028004000`), merged only after v0.49.1 answers live, so the old worker cannot take it;
  - **lesson recorded:** a migration that enqueues work for a new worker path must not ride the same merge as the worker.

### 28 Oct 2026 22:2x — #718 merged and verified; #719 (slice read once more) written before merge

- **#718 merged 22:03** (squash `3f264dc7`). Deploy on merge and CourseFinder Deployed UAT passed.
  - The migration-history md5 `204f3380…` equals the file's.
  - Worker v0.49.1 has answered live since 22:06:03 (mode ledger).
- **#719 (migration `20261028004000`):** the decided slice read once more.
  - Count-guarded: at most two items ever.
  - Live dry run (rolled back): 2 items, the newest queued, flag released.
  - Suite 1,079 passed, 0 failed, 0 skipped. Guards: s139.

### 28 Oct 2026 22:4x — Track C Step B: platform slice live; Layer 4 and consumer gates open; report lodged

- **Report:** `docs/platform/ui-audit/2026-10-28-track-c-step-b-report.md`.
- **#719 merged 22:16** (`3c681ac3`); history md5 `f0cffece…` equals the file.
- **The read on worker v0.49.1 at 22:18** (US$0.0045; B1 total US$0.0069) proposed 3 rows in Layer 4 item `cf71cca1…` (pending):
  - "2026 ATAR 73.00";
  - the VCE mathematics prerequisite;
  - the VCE English prerequisite.
- **Dropped:**
  - the 2027 Guaranteed ATAR 75.00 (the quote was paraphrased);
  - "… equivalent to the VCE with a minimum average of 65%" (`score_without_basis`). This is flagged for the Platform Admin's judgement; nothing was mapped.
- **BH126 / India resolves to step 5** (contact the provider).
- **Consumer change:**
  - held draft PR #720 (migration renumbered `20261028005000`, suite 1,082/0/0);
  - paste `docs/platform/pastes/PASTE-20261028-entry-consumer-api.sql` (file md5 `fd69acc1…`).
- **Unchanged:**
  - consumer API (0 drift);
  - RMIT matrix 343 / 37 / 167 / 20;
  - no matrix runs today;
  - `entry.providers` is UTS and WSU.
- **Not claimed:** "Track C Step B RMIT vertical slice live". Open gates: the Layer 4 decision, the consumer paste plus the #720 merge, and the worked example and developer guide reissue after both. B4 is website-team work.

### 28 Oct 2026 22:5x — Consumer paste verified (applied by the Platform Admin); #720 written before merge

- **Paste applied once by the Platform Admin** (22:43:58, baseline time). Migration history for `20261028005000`: 1 row, md5 `fd69acc1…`, equal to the held PR's file.
- **Definitions match the held PR:**
  - `website_v2_course(text)` with the added `entry` line removed equals the earlier live md5 `ad9ba388…`;
  - `website_v2_provider(text)` with the added `entry_matrix` line removed equals `2411c7e4…`;
  - the bodies of the two `edu_country` forms and the two payload helpers equal the file's;
  - grants are `postgres` and `service_role` only.
  - The SQL editor saved the two inserted lines with Windows line endings; they behave the same.
- **Only the approved keys:** the course item gains `entry`, the provider item gains `entry_matrix`, and nothing else changed (the rolled-back dry run before the paste compared every other key).
- **Live behaviour:**
  - `entry` without a country: all null or empty (no admitted rows yet);
  - `IN`: step 5, contact the provider;
  - provider matrix: 343 rows, or 33 with `in` (IN only);
  - `ZZ` / `IND`: `22023 INVALID_INPUT`.
- **Baseline re-taken:** 75 functions (the 4 `website_v2_course` / `_provider` forms included) and 48 relations, reason recorded. Drift now: 0 changed, 0 new, 0 relations.
- **#720** (draft until now): checks green (build-and-smoke, Workers Builds); suite on its branch 1,082 passed, 0 failed, 0 skipped. Merged under its consumer-change authority (Platform Admin 22:44); deploy-on-merge skips the migration (already in history) and deploys `website-api-v2`.

### 28 Oct 2026 22:5x — #720 merged and deployed; consumer change live; two Layer 4 / UI steps wait for a signed-in Platform Admin

- **#720 merged 22:46:42** (squash `09dca1b6`).
  - Deploy on merge: the migration was skipped (already in the history from the paste) and `website-api-v2` deployed. Live version 3 contains the `edu_country` handling.
  - Edge drift check (run `40684090246`, by hand): success, live equals the repo.
  - Release Currentness Deployed (run `40682704660`, by hand on `09dca1b6`): success.
  - CourseFinder Deployed UAT: success.
- **Not done by the agent, and why:** this session has no signed-in admin browser. Both the Layer 4 decision on item `cf71cca1` and "Read from the stored page" need the Platform Admin's own session. No SQL is used for them (decision 22:44).
- **Order required by the controls:** a read is refused while `cf71cca1` is pending ("a read of this course is already in progress or waits in Layer 4").
  1. **Layer 4, item `cf71cca1`:** Approve except row `dab50fa7-f931-45e2-871d-2861ae13e6c1` ("2026 ATAR 73.00"). This admits the two VCE prerequisites (`2561c0c6…`, `daa736b7…`) and marks the 2026 row inactive. (Reject is the alternative: all three inactive.)
  2. **Course BH126 › Academic entry requirements › Read from the stored page**, with a reason. This is the one bounded re-read.
  3. **The agent checks the read.** If it keeps the 2027 Guaranteed ATAR 75.00 and the 65% sentence with exact quotes, the Platform Admin approves that read in Layer 4 (the 2026 row excluded). Approving supersedes the reader's earlier active rows, so there are no duplicates. Otherwise it is the evidence gate.
- **Expectation, stated in advance:** the reader, prompt, model (temperature 0) and stored copy are unchanged since the 22:18 read. That read paraphrased the ATAR sentence (`quote_not_on_page`), and the B1 basis rule dropped the 65% sentence because the model gave a score whose basis words are not in the quote (`score_without_basis`). The same outcome is likely; if it repeats, Step B stops at the evidence gate as decided.

### 28 Oct 2026 23:5x — AER programme (consolidated mandate 23:22): Wave H sources and provider scope (Pilot PR, migration `20261028006000`)

- **Mandate:** Platform Admin, 28 Oct 2026 23:22, "complete the approved AER plan". Decision record (admin `1c2b24a3`): `docs/platform/ENTRY-REQUIREMENTS-PROGRAMME-DECISION-2026-10-28.md`, lodged before code.
- **Change:** one migration. Nothing dropped, deleted or renamed. Consumer API untouched. No new job, table or status.
  - **Sources:** 58 official entry-requirements sources for 26 planned providers, seeded as `found_via 'manual'`.
    - 47 HTML: Flinders, UWA, UOW, ANU (27 per-qualification pages), Melbourne (4), Swinburne (India page), Waikato, Massey, AUT, Otago, Lincoln, Unitec, MIT, Otago Polytechnic, Wintec, Ara, NMIT, SIT.
    - 11 PDFs: UNSW, Sydney, UQ, Adelaide, Curtin, WSU, Macquarie (3), Auckland (2). These park as `pdf_step_b` until the PDF route ships.
    - Count-guarded: exactly 58 new rows, or the migration fails.
  - **Scope:** `entry.providers` widened from UTS and WSU to the 29 planned providers that have a source.
    - Guarded on the live value being UTS and WSU. RMIT stays out, and the migration asserts it.
    - Reason recorded on the setting.
- **Honest gaps, recorded now:**
  - **ANU:** listing pages 2–4 are disallowed by robots.txt (`Disallow: /*?*`), so its source list is partial.
  - **Melbourne:** pages found by search only.
  - **Not seeded:** Monash (course-page route), QUT, EIT, NorthTec, UCOL, Toi Ohomai (its PDF is IELTS only) and Canterbury (contact provider).
  - **Step C:** Newcastle, Griffith, Victoria University of Wellington, and Whitireia and WelTec follow with it.
- **Evidence:**
  - Rolled-back live dry run: 58 new, 98 total, 58 found in scope, 11 PDFs; RMIT not in scope; Melbourne in scope.
  - Suite: 1,082 passed, 0 failed, 0 skipped.
  - Migration file md5 `03296de18fad7bbac07834c77f3dfa8a`.
- **Effect after merge:**
  - The `entry-matrix-read` job fetches the HTML sources, `batch.entry_matrix` at a time, robots respected.
  - Each read goes to Layer 4 as a first run (`entry.matrix_first_run_review` 1). Nothing is admitted without a person.
  - AI spend is capped by `guard_entry_matrix`.

### 29 Oct 2026 00:3x — AER programme: reader limits and refused-read fix (Pilot PR, migration `20261029001000`, worker v0.49.2)

- **Why:** the first Wave H reads after #721 went live (#721 history md5 `03296de1…` equals its file) showed two faults in the source route.
  - **Truncated answers:** two large pages (UWA and UOW) were read in slices whose answers stopped at the fixed 8,000-token limit ("Unterminated string in JSON"), and each retry used the same size.
  - **Firecrawl refusals:** pages a provider refuses to a direct read (AUT, Otago Polytechnic) fall back to Firecrawl. The budget check refused that as `not_due`, because the provider's central pages had been read within `central_refresh_days`. Each refusal also used up one of the page's tries.
  - Other Wave H reads ran normally: 4 first-run Layer 4 items were proposed by 00:20, and nothing was admitted.
- **Change:** nothing dropped, deleted or renamed. Consumer API untouched. No new job or status.
  - **Settings (G2):**
    - `entry.matrix_max_tokens` 16,000 (range 4,000–32,000 tokens);
    - `entry.matrix_slice_chars` 12,000 (range 4,000–24,000 characters).
    - `svc_entry_matrix_next` passes both (md5-guarded edit, `f992b7fc…`). Worker v0.49.2 uses them and names a cut-off answer `output_truncated`.
  - **Firecrawl:** `svc_fc_spend` (md5-guarded, `98aaa595…`) lets a seeded entry-requirements source that has never been read through the central refresh interval. This is the same principle as Decision 265 for a page a person added. The day total, shares, reserve, directory-site and other rules are unchanged.
  - **Tries:** `svc_entry_matrix_fetch_record` (md5-guarded, `90a5ff92…`) no longer counts `credits_refused`, `credits_reserve` or `no_firecrawl_key` as a try. The 3 Wave H sources already refused get their tries back (bounded at 20).
- **Gates unchanged:** quote on page, scale, completeness guard (RMIT only), whole-run Layer 4 first-run review and confidence.
- **Evidence:**
  - Rolled-back live dry run: 3 sources reset; all three functions edited; setting reads 16,000.
  - New spec `cf-247-s141-aer-reader-limits-contract` (Guards line).
  - Suite on the PR branch: 1,085 passed, 0 failed, 0 skipped. Two specs (s131, s135) now anchor on the start of the slicing line, which gains the slice-size argument; their guards are unchanged. Register regenerated.

### 29 Oct 2026 01:xx — AER programme Steps B and C: the PDF route and the rendered read (Pilot PR, migration `20261029002000`, worker v0.50.0)

- **Decision record:** `ENTRY-REQUIREMENTS-PROGRAMME-DECISION-2026-10-28.md`, P4/P5 and sections 3–4 (admin `1c2b24a3`). Build order: `ENTRY-REQUIREMENTS-IMPLEMENTATION.md` 2.5, steps B and C.
- **Step B, PDF matrices:** `pdf.ts`, method `ruled-cells-v1`. It runs before any AI read.
  - **Extraction:** unpdf 0.12.1, the library the fee-schedule reader already uses. It keeps each text item's position and the PDF's own drawn rules: thin filled rectangles, stroked lines and the edges of filled boxes.
  - **Columns:** the edges of each table's rule segments.
  - **Rows:** the rules across each column. A cell merged over rows is repeated on each of those rows; a bar across the table is a heading.
  - **Proof:** every text item must sit inside one column and between two rules of that column.
  - **Fails closed:** an item across a column edge or a row rule, text outside the table's columns, or short cells side by side with no rules holds the **whole document** as `held_unparsed`, with the page and the text. Nothing of a held document is given to the model, and no partial table.
  - **What the model sees:** each table row is one line; each cell is named by its column header (`Header: cell`) and the country heading is kept (`§ COUNTRY`). The model never reads a value from a column position. The quote, scale, confidence and Layer 4 gates are unchanged.
  - **Fetch:** direct, with robots.txt respected and never through Firecrawl. Size cap `entry.pdf_max_bytes`. The PDF is stored whole (`.pdf.gz`, `application/pdf`).
  - **Stored copies:** a PDF source takes only a stored PDF (`entry_matrix_use_stored_v1`).
- **Proof against the stored PDFs** (fixtures from the official PDFs; source sha256 in `tests/fixtures/entry-matrix/pdf/README.md`):

| PDF | Result |
|---|---|
| VU | read: 6 tables, 153 rows, 4 columns; Cambodia's packed rows kept apart; merged qualification cells repeated |
| Federation | read: 55 rows; centred country cells and multi-paragraph cells in their own row (Global's IB 20 and 24 under the right columns) |
| WSU published table | read: 11 tables, 86 rows, 7 columns |
| Adelaide | read: 41 rows |
| Curtin | read: 37 rows; criteria paired with their own country |
| Macquarie postgraduate | read: two side-by-side tables split at their empty column |
| UQ | **held**: "page 3: columns of text with no drawn rules" (the misaligned table) |
| Macquarie undergraduate and pathways | **held**: columns of text with no drawn rules |
| UNSW | **held**: "page 1: "ACT" is in a column without row rules" |
| Sydney | **held**: "page 1: "38" lies inside the table but outside its columns" |
| Auckland (2 PDFs) | **held**: page 2 cells merged across columns ("No direct entry for secondary qualifications…" crosses a column edge) |

- **Step C, JavaScript-only pages:**
  - `entry.render_hosts` names the sites whose requirements the browser draws. Their sources are read once rendered through Firecrawl (rawHtml, waiting `entry.render_wait_ms`).
  - robots.txt is checked first, and the read is within the Firecrawl budget check.
  - The rendered copy is stored as HTML and read like any page. A rendered page with no minimum gives no rows: the resolver's step 5, contact the provider.
- **Switched on separately:** `entry.pdf_enabled` is 0 and `entry.render_hosts` is empty in this change (asserted). A separate change switches them on once worker v0.50.0 answers live; that is the deploy-order lesson of 28 Oct.
- **Change:** settings `entry.pdf_enabled`, `entry.pdf_max_bytes`, `entry.pdf_max_pages`, `entry.render_hosts`, `entry.render_wait_ms`. md5-guarded edits:
  - `entry_matrix_fire_v1` (`dd985f9a…`);
  - `svc_entry_matrix_fetch_next` (`8fa16c87…`);
  - `entry_matrix_use_stored_v1` (`9e411390…`);
  - `svc_entry_matrix_next` (`c2ac766d…`).
  - No new table, job or status. Nothing dropped or deleted. Consumer API untouched.
- **Evidence:**
  - Rolled-back live dry run: with the switch on, all 13 parked PDF sources return to found; the use-stored rule names PDFs; `pdf_max_pages` is passed; the render host test is true.
  - Specs: s142 (PDF column fidelity, against the fixtures and synthetic cases) and s143 (rendered read). Worker-version patterns in s127, s134, s139 and s141 accept v0.5x.
  - Worker-version patterns in s87, s89, s91, s128, s129 and s135 also accept v0.5x. s128 anchors on the storedText call, which now carries the PDF page limit; its guard is unchanged.
  - Suite on the PR branch: 1,097 passed, 0 failed, 0 skipped. Register regenerated (s142, s143).

### 29 Oct 2026 01:2x — #723 live and verified; AER Steps B and C switched on, Wave J seeded (Pilot PR, migration `20261029003000`)

- **#723 verified live** (merge `ed627894`):
  - migration history md5 `438c7757…` equals the file;
  - deploy on merge, Deployed UAT and the frontend build all succeeded;
  - while switched off, `entry.pdf_enabled` read 0, `entry.render_hosts` read `[]`, and 13 PDF sources stayed parked;
  - worker v0.50.0 answered live: ANU Vietnam was read by v0.50.0 at 14:14 UTC.
- **#722 verified live** (merge `f6ed4481`): history md5 `dd9dd556…` equals the file; worker v0.49.2 answered from 13:55 UTC.
- **This change** is settings and data only, with no reader code (the deploy-order lesson):
  - `entry.pdf_enabled` 1;
  - `entry.render_hosts` set to Victoria University of Wellington, Whitireia and WelTec, Newcastle and Griffith;
  - 4 Wave J sources seeded, count-guarded;
  - `entry.providers` widened from 29 to 33 providers (guarded on the live list; RMIT asserted out).
- **Tries given back, bounded:** reads stopped by the faults #722 fixed. Five sources refused for Firecrawl budget before the fix (Otago Polytechnic and four Melbourne pages), and two runs whose answers were cut off at the old fixed length (MIT and Wollongong).
- **Not seeded:** Canterbury, which publishes a checker app with no page to read. Its outcome is contact provider.
- **Evidence:**
  - Rolled-back live dry run: 4 new sources, 5 sources reset, 2 runs re-queued, scope 33, RMIT out; after a fire, 0 parked and all 13 PDFs found.
  - Suite: 1,100 passed, 0 failed, 0 skipped. s144 added; register regenerated.

### 29 Oct 2026 02:0x — #724 live; reader correction for the HTML route: numeric tables (Pilot PR, worker v0.50.1)

- **#724 verified live** (merge `9cca6401`):
  - history md5 `9ccb7631…` equals the file;
  - `entry.pdf_enabled` reads 1; `entry.render_hosts` holds the four hosts; scope is 33;
  - the PDF sources began fetching directly (Adelaide, Sydney and both Auckland PDFs stored within minutes).
- **Why:** Wave H reads by v0.49.2 dropped whole pages at the quote gate. The rows were tables of bare numbers, with nothing on the line saying what the numbers are:
  - ANU's rank-to-score pages, for example "80 | 8.5" (`quote_too_short`);
  - UWA's score-to-ATAR tables, quoted across lines (`quote_not_on_page`).
  - The gate is right: a bare cell proves nothing. The route needs the line to name its numbers.
- **Correction (structure-driven):** an HTML table whose data cells are all bare numbers, under a worded header row, gives each data cell named by its column header ("Program Required Entrance Rank: 80 | Indicative score required: 14.0"). The read is told so.
  - Tables with any worded cell are unchanged.
  - It is off for a provider under the completeness guard (RMIT), whose manifest compares quotes with the plain lines; RMIT's pinned text is unchanged (s135).
  - Every gate is unchanged: quote on page, band printed on the quoted line, scale and confidence.
- **Evidence:**
  - s145 against ANU's stored India page: the named line passes the gates; a bare cell and a band not printed are still refused.
  - Suite: 1,104 passed, 0 failed, 0 skipped. Register regenerated.
- **Next:** once v0.50.1 answers live, a separate change re-queues the ANU and UWA runs that ended with no rows for this reason (bounded), so they go to Layer 4 as first reads.

### 29 Oct 2026 02:3x — #725 live; ANU re-read; no endless retry on cut reads (Pilot PR, migration `20261029004000`)

- **#725 verified live** (merge `91b1298f`): worker v0.50.1 answered from 14:44 UTC. Deploy on merge, Deployed UAT and the frontend build all succeeded. No migration.
- **ANU re-read:** the 16 ANU runs that ended with no row and no Layer 4 item (bare-number tables) are queued again.
  - Bounded at 20, ANU only.
  - The earlier reading is kept in each run's history.
  - Runs whose rows wait in Layer 4 (11) are left to the Platform Admin.
- **No endless retrying:**
  - **The fault:** a read cut by the worker's call time after spending on the model (Wollongong: 2 cuts, US$0.095) was queued again without using a try.
  - **The fix:** `svc_entry_matrix_record` (md5-guarded, `e1a130e2…`) now counts such a cut as one of `entry.matrix_attempts`. A cut before any model call still waits without using a try.
  - **Slices:** `entry.matrix_slice_chars` is set to 20,000 (with a reason). The 16,000-token answer limit fits it, so large pages need fewer calls.
- **Evidence:**
  - Rolled-back live dry run: 16 ANU runs queued; the function edited; the setting reads 20,000.
  - s146 added.
  - Suite: 1,106 passed, 0 failed, 0 skipped. Register regenerated.

### 29 Oct 2026 02:5x — #726 live; admin Sources and reads in the Provider drawer (Pilot PR #727, release v2.15.362, migration `20261029005000`)

- **#726 verified live** (merge `b2c0659f`): migration history md5 `1acb4866…` equals the file. Deploy on merge, Deployed UAT and the frontend build all succeeded.
- **Admin experience (mandate item 1, bounded UI reads):**
  - Provider drawer › Academic entry requirements now lists the provider's sources and each one's latest read: fetch state, read state, rows proposed, rows not kept, hold or error text, and the Layer 4 item's status.
  - Holds and refusals are visible even when no row has been read (for example Auckland's `held_unparsed`).
  - Read only, at most 50 sources; no new screen, no direct table access; admission stays in Layer 4.
  - Server: `public.admin_entry_requirements(text,jsonb)` edited under an md5 guard (`961150b3…`, re-checked live before merge). Not part of the consumer API; G3 untouched.
- **Evidence:**
  - Rolled-back live dry run as a Platform Admin user returned the sources with their latest reads.
  - s147 added.
  - Suite: 1,108 passed, 0 failed, 0 skipped. `verify-release-contract` PASS. Register regenerated.

### 29 Oct 2026 03:0x — v2.15.362 live; an entry read stopped on its last try is closed (Pilot PR #728, migration `20261029006000`)

- **#727 verified live** (merge `d9f5c1bb`): migration history md5 `c2df15a5…` equals the file; `admin_entry_requirements` changed as intended. Deploy on merge, Deployed UAT, Release History Contract, Release Currentness Deployed and the frontend build all succeeded. Register (s147) and UI-CATALOGUE 1.12 committed (`0bb718da`).
- **Fault found while the reads drained:** a read whose worker stopped without reporting back, on the last of `entry.matrix_attempts`, kept its lease for ever. It was never picked again and never closed (Wollongong, leased since 14:49 UTC).
- **Fix:** the existing fire job (`security.entry_matrix_fire_v1`, md5-guarded edit, `85d54db5…`) closes such a run as failed with "stopped after N tries without a reply: <last error>". It then shows as a hold in the Provider drawer. Nothing is re-read or spent; no new job, setting or status.
- **Evidence:**
  - Rolled-back live dry run closed exactly one run (Wollongong, 3 tries, time budget); the live definition was unchanged afterwards.
  - s148 added.
  - Suite: 1,109 passed, 0 failed, 0 skipped.

### 29 Oct 2026 03:2x — #728 live; worker v0.50.2: Firecrawl-fallback entry pages kept as HTML, no-answer reason named (Pilot PR #729)

- **#728 verified live** (merge `94d538fc`):
  - Migration history md5 `644a3968…` equals the file. Deploy on merge, Deployed UAT and the frontend build all succeeded. Register (s148) committed (`b6c5c497`).
  - Working live: the fire job closed Wollongong ("stopped after 3 tries without a reply: time budget") and Western Sydney's PDF ("… the model returned no answer").
- **HTML Firecrawl-fallback route (a reader correction the route's acceptance needs, structure-driven):**
  - **The fault:** an entry page refused to a direct read was kept as Firecrawl markdown. The reader cannot quote its tables row by row: AUT read 0 rows, and Wintec lost 45, Otago Polytechnic 27 and Lincoln 17 rows as `quote_not_on_page`.
  - **The fix:** worker v0.50.2 keeps the page's own HTML (`rawHtml`), under the same budget check, robots rule and time-out. It is read with `table-rows-v1`, like a direct read.
- **No-answer reason:**
  - A model call that answers with no text now records the provider error, the finish reason and the slice.
  - Victoria University, Western Sydney and Manukau were recorded only as "the model returned no answer".
- **Unchanged:** the quote, scale, completeness and identity gates. No migration in this PR. The bounded re-read follows in its own PR once v0.50.2 answers live.
- **Evidence:**
  - Rolled-back live dry run of the follow-up: 5 markdown sources to fetch again (WSU HTML page, AUT, Melbourne IB, Otago, Griffith; none waits in Layer 4); 0 re-attached to a markdown copy; the no-answer runs re-queued.
  - s149 added.
  - Suite: 1,112 passed, 0 failed, 0 skipped.

### 29 Oct 2026 03:4x — #729 live; bounded re-read after worker v0.50.2 (Pilot PR #730, migration `20261029007000`)

- **#729 verified live** (merge `58ffd006`): Deploy on merge, Deployed UAT and the frontend build all succeeded. The deployed `coverage-sweep` bundle (version 221) carries `coverage-sweep-worker-v0.50.2` and `entryNoAnswerWhy`. No migration.
- **Re-read, merged separately after the worker was live (28 Oct deploy-order lesson):**
  - **No markdown copies:** an entry source no longer takes a stored markdown copy. This is an md5-guarded edit of `security.entry_matrix_use_stored_v1` (`1d009793…`).
  - **Markdown sources fetched again:** 5 sources whose reads wait on no person, bounded at 6: the WSU HTML page, AUT, Melbourne IB, Otago and Griffith. Griffith goes rendered (Step C).
  - **No-answer runs read once more:** 3 runs, bounded at 5: the VU PDF, the WSU PDF and Manukau. History is kept.
  - **Left to the Platform Admin:** sources whose rows wait in Layer 4.
- **Evidence:**
  - Rolled-back live dry run: 5 sources found, 0 re-attached to markdown; the no-answer runs re-queued.
  - s150 added.
  - Suite: 1,115 passed, 0 failed, 0 skipped.

### 29 Oct 2026 04:0x — #730 live; worker v0.51.0: wide PDF rows cell by cell, slices read at once, cut replies named (Pilot PR #731)

- **#730 verified live** (merge `dc153122`):
  - Migration history md5 `de2b8416…` equals the file. Deploy on merge, Deployed UAT and the frontend build all succeeded.
  - 5 markdown sources were fetched again as HTML, and 3 no-answer runs were re-queued. Register (s149, s150) committed (`bd75cfc5`).
- **What the re-reads showed (worker v0.50.2 naming):**
  - **WSU PDF:** read with 13 rows kept and 65 dropped as `quote_not_on_page`. The table has 7 columns, one requirement per study level. The model quoted the qualification together with one level's cell, which is not a substring of the whole row.
  - **VU PDF and Manukau:** "no choices; slice 2 of 2". The reply was cut by the 90-second call time-out while a 20,000-character slice's answer streamed.
- **Worker v0.51.0 (structure-driven, gates unchanged):**
  - A PDF table of 5 or more columns gives each proven cell on its own line, with the row's first cell. Only WSU among the fixtures is this wide.
  - A page's slices are read `entry.matrix_slice_concurrency` at a time (default 1 until the setting exists) and joined in slice order.
  - A reply that cannot be parsed is named ("reply unreadable").
- **Next, in its own PR after v0.51.0 is live:** the setting, smaller slices, and the bounded re-reads (UWA, WSU, Federation, the markdown copies with lost rows, VU, Manukau).
- **Evidence:**
  - s151 added; s142's WSU anchor updated with the same guard.
  - Suite: 1,118 passed, 0 failed, 0 skipped.

### 29 Oct 2026 08:3x — AER operations workspace: decision lodged before code (Platform Admin mandate 29 Oct 08:06)

- **Decision record:** `docs/platform/AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` (W1–W16). It supersedes the 28 Oct Step B B5 read-only limit for editing only.
- **Location:** a new menu page, Catalogue › Entry requirements, with four tabs:
  - Provider entry matrix;
  - Course entry requirements;
  - Sources, reads and holds;
  - Resolution inspection.
  The drawer sections stay read-only and become shortcuts into it.
- **Operator actions:** governed edits of active or unverified rows, add with stored evidence, and withdraw, quarantine or restore. All use the existing statuses only. Every action needs a reason and is audited before and after in `pipeline.manual_edit_log`. Writes check `updated_at`, and identity collisions are refused.
- **Roles:**
  - read: rank ≥ 1;
  - write: rank ≥ 3, as for Scholarships;
  - re-read: the existing Platform Admin mechanisms, bounded.
- **Unchanged:** Layer 4 stays the only admission route for AI rows. The consumer API and the resolver do not change.
- **Parked, not retried:** the earlier re-read step (settings and bounded re-reads, scratch `mig8.sql`). Its rolled-back dry run was cancelled at the approval prompt.

### 29 Oct 2026 10:xx — AER operations workspace, release v2.15.363, written before merge (Pilot PR #732, migration `20261029010000`)

**Mandate:** Platform Admin, 29 Oct 2026 08:06. **Decision record:** `AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` (W1–W16), lodged before code.

- **Navigation:** Catalogue › Entry requirements (`/entry-requirements`), placed after Scholarships. Its tabs are:
  - Provider entry matrix;
  - Course entry requirements;
  - Sources, reads and holds;
  - Resolution inspection.
- **Server:** `public.admin_aer(action, args)`. The other functions it adds are new and touch no existing object:
  - `security.aer_row_v1`;
  - `aer_numbers_in_quote_v1`;
  - `aer_band_in_quote_v1`;
  - `aer_conditions_v1`.
- **Reads (rank ≥ 1):**
  - summary and options;
  - matrix, course and source lists, with filters and whitelisted sorting on the server, at most 100 a page;
  - the row with up to 50 history entries;
  - course search and evidence options (20);
  - resolution inspection over the unchanged `security.entry_resolve_v1`.
- **Writes (rank ≥ 3):** update, add and lifecycle (withdraw, quarantine, restore).
  - Every write needs a reason and the row's `updated_at` as read; a stale value is refused (40001).
  - A band, minimum, value or score must be printed in the quote. A value needs its scale, and a score its printed basis.
  - An active identity collision is refused in plain words.
  - Each changed field writes one `pipeline.manual_edit_log` entry with before, after, reason and actor.
  - Proposed AI rows are never edited or activated. Restore is allowed only after a workspace withdrawal or quarantine. There is no delete and no new status.
- **Re-read (rank 6):** one source, through `admin_entry_matrix_reread`, or the failed run is re-queued. It is refused when the source is out of scope, AI is stopped, a read is waiting, or the source is held as unreadable.
- **UI:** `src/AerWorkspace.jsx` and `src/aer-workspace.css` (tokens only).
  - The shared `DataTable` and `FilterSelect` were moved unchanged to `src/DataTable.jsx`.
  - The drawer sections stay read only and link into the workspace.
  - Release ceremony: v2.15.363 / 0.1.290; guide and both SOPs reviewed; release notes; `verify-release-contract` PASS.
- **Docs:**
  - UI-CATALOGUE 1.13;
  - PIPELINE-LINEAGE (provider matrix row added, human edit path on both rows);
  - the Step B decision record marks its read-only limit superseded for editing.
- **Evidence before merge:**
  - **Rolled-back live dry runs as Curator `uat2` and Platform Admin:**
    - edit logged before and after (version 1 → 2);
    - stale, band, scale, reason, proposed-row and restore-of-proposed refusals;
    - withdraw (consumer India rows 33 → 32) and restore (→ 33);
    - add matrix row (active, by hand; reaches the consumer payload);
    - duplicate refused; wrong stored copy refused; grade not in quote refused;
    - conditions as parts (version 2); bad conditions refused;
    - course add, edit, quarantine and restore, with history add → edit → quarantine → restore;
    - re-read refused for Curator and for a held PDF; a VU failed run re-queued;
    - no-role refused.
  - **Defect caught:** the dry run found a variable clash in `aer_conditions_v1`. It was fixed, and s152 now guards it.
  - **Specs:**
    - s152 (server contract, 6 tests);
    - s153 (mocked browser: summary, combined filters, sorting, Columns, drawer, edit in list with session reason, stale and band refusals shown, withdraw, sources re-read, resolution, viewer has no controls, phone width);
    - s154 (deployed acceptance; live edit only under `@live-acting`).
  - **Specs updated, same guards:** s81 (menu 20 pages), the ui-standard table guard and m245.

### 29 Oct 2026 11:xx — v2.15.363 live; the workspace's deployed acceptance wired to run on deploy (Pilot PR #733)

- **#732 verified live** (merge `145626bb`):
  - Migration history md5 `c925e283…` equals the file.
  - `public.admin_aer` and its four helpers exist, with the conditions fix live. `authenticated` may execute and `anon` may not.
  - Deploy on merge, Deployed UAT (targeted; this merge's rule picked another spec), Release History Contract, Release Currentness Deployed and the frontend build all succeeded.
  - **Live read as Curator:** summary 75 ms; RMIT India active 33 rows in 60 ms; proposed 776 rows (100 a page) in 72 ms; held sources 15 in 44 ms.
  - Register (s152–s154) committed (`48356f2b`).
- **#733:** `deployed-uat.yml` runs s154 when the workspace, its migration or s154 changes, and s154 is in the acceptance tier. The live edit stays `@live-acting`. Suite: 1,130 passed, 0 failed, 0 skipped.
- **Not applied (left with the Platform Admin):** settings for slices read at once, and the workspace's refetch route for markdown-stored sources. Their rolled-back dry run was cancelled at the approval prompt, as was the earlier SQL re-read. They are not retried.
  - The re-reads they cover remain available as governed UI actions: Catalogue › Entry requirements › Sources, reads and holds › Read again, on sources stored as HTML or PDF.
  - The markdown-stored sources (Wintec, Otago Polytechnic, Lincoln, NMIT) and the slice settings need the Platform Admin's go-ahead.

### 29 Oct 2026 09:50 AEDT — #733 deployed acceptance passed; consolidated programme report filed

- **#733 deployed** (merge `7e58aac8`):
  - CourseFinder Deployed UAT (targeted) run `40781257332` succeeded, with commit status `deployed-uat/targeted/chromium-desktop` success. Frontend Build succeeded.
  - The live API log shows eleven `admin_aer` calls from the run's browser between 09:37:07 and 09:37:15 AEDT, all HTTP 200.
  - `pipeline.manual_edit_log` has no `entry_matrix` or `course_entry` entries, so the `@live-acting` edit was held (switch off) and no live row changed.
  - GitHub's job log and evidence download are refused through this session's proxy (403), so per-test lines are not quoted.
- **Consolidated report:**
  - `docs/platform/ui-audit/2026-10-29-aer-programme-consolidated-report.md`, with screenshots (mocked data, labelled) under `assets/2026-10-29-aer-workspace/` (commit `b60597fd`).
  - It covers the workspace (navigation, capabilities, controls, example governed edit and audit record, tests and deploy evidence), and Steps A, B and C, course-level, the resolver, the consumer API and the developer pack.
  - It also covers the provider-by-provider status of the 40 plus Federation, live counts, releases #721–#733, the Platform Admin actions and the external dependencies.
- **Not claimed:** AER complete; website rendering; any proposed row as admitted.

### 29 Oct 2026 — v2.15.364: reader settings, Read again as HTML, course-level programme, rendered no-table note (Pilot PR #734, written before merge)

- **Authority.** Platform Admin decision 29 Oct 2026 09:57 ("Continue the full AER programme"), items 1, 3 and 4. Decision addendum W12a, W17 and W18 recorded before code (`fb77a43d`).
- **Migration `20261029020000`:**
  - `entry.matrix_slice_concurrency` 6 (new) and `entry.matrix_slice_chars` 8,000;
  - `svc_entry_matrix_next` passes the concurrency (md5 `dc1bab7a` guarded);
  - Read again moves into `security.aer_reread_v1`, owner only (`admin_aer` md5 `d582b0c2` guarded). It fetches a markdown-stored web page again as HTML after superseding its proposed rows and pending item. Every earlier refusal is kept, and a page already waiting to be fetched is refused.
- **Migration `20261029030000`:**
  - the course-level programme: `course_entry_eligible_v1`, `cost_v1`, `programme_v1` and `batch_v1`; settings `entry.course_read_providers` (Monash, QUT and RMIT first, then the plan's AU providers), `entry.course_batch_size` 50 and `entry.course_read_cost_usd` 0.005;
  - `admin_aer` actions `course_programme`, `course_batch_preview` and `course_batch` (Platform Admin); `admin_aer` md5 `bc7fe780` (after `020000`) guarded;
  - the Step C note: `entry_rendered_note_v1`; `svc_entry_matrix_record` (`15fb11f8`) and `entry_matrix_review_apply_v1` (`f1152d19`) md5-guarded; an approved note admits and replaces nothing; backfill bounded at 5.
- **Rolled-back live dry runs (29 Oct):**
  - Settings 6 and 8,000; `svc` md5 after `3eb6ca3b`; `admin_aer` after `020000` `bc7fe780`, as computed.
  - Curator Read again refused. Wintec: refetch, 13 rows and 1 item superseded, source found. The same source a second time refused ("waiting to be fetched"). VU failed read re-queued. UWA re-read, 9 rows and 1 item superseded.
  - Three notes opened (Griffith, Victoria University of Wellington, Newcastle; `entry_matrix_first_run`). Approving a note admits 0 and supersedes 0.
  - Programme: 4,977 eligible AU courses in 21 providers (Monash 356, QUT 184, RMIT 334, UNSW 430, ANU 349, and others), read in 2.9 s. Cost a course US$0.005 (setting). Balance US$8.04, floor US$5.
  - Curator batch refused; preview 50 courses, US$0.25. Platform Admin batch of 3: one Enrich fields task, 3 queued items. A second batch refused while the first waits. A reason under 5 characters refused.
  - Consumer RMIT `entry_matrix` 343 unchanged.
- **Workspace (v2.15.364):**
  - Course entry requirements › Course-level reading: by provider, with Preview next batch and Read next batch (Platform Admin);
  - Sources › "Rendered, no table: in Layer 4" / "No matrix published (confirmed)";
  - the Read again message names the HTML refetch.
- **Specs:** s155 (settings and refetch) and s156 (programme and note, mocked browser), with m245 updated. Local suite 1,139 passed, 0 failed, 0 skipped (14.5 min). Register regenerated.
- **Consumer API:** unchanged (G3).

### 29 Oct 2026 — v2.15.364 live (#734, merge `60d2be1b`)

- **Deploy workflows:** Deploy on merge, Release History Contract, CourseFinder Deployed UAT (targeted; the workspace changed, so s154 ran), Release Currentness Deployed and Pilot Frontend Build all succeeded.
- **Migration history md5 equals the file:** `20261029020000` `7ae33c61`; `20261029030000` `ac325995`.
- **Live settings:** slice chars 8,000; slices read at once 6; courses a batch 50; estimated cost a course US$0.005. `svc_entry_matrix_next` md5 `3eb6ca3b`, as in the dry run.
- **Rendered no-table notes:** three are open in Layer 4 (pending): Griffith, Newcastle, and Victoria University of Wellington.
- **Consumer API:** RMIT `entry_matrix` 343, unchanged.
- **Next step:** the approved programme batch migration `20261029040000`. Its rolled-back dry run passed: all ten sources accepted (4 HTML refetches, 3 failed reads re-queued, 3 done reads re-read with 46 rows and 3 items superseded), and the first course batch of 50 Monash courses at an estimated US$0.25.

### 29 Oct 2026 — approved AER programme batch (Pilot PR #735, written before merge)

- **Authority.** Platform Admin decision 29 Oct 2026 09:57, items 2 and 3.
- **Migration `20261029040000`.** It reads exactly the ten named sources (count-guarded), one governed attempt each, through `security.aer_reread_v1`, the same mechanism as Read again. A refusal is recorded and not retried. It then queues one bounded course batch through `security.course_entry_batch_v1`. Actor: the Platform Admin. It logs `admin_control_events` `programme_batch`.
- **Rolled-back live dry run:**
  - HTML refetch: Lincoln (63 rows, 1 item superseded), NMIT (42, 1), Otago Polytechnic (18, 1), Wintec (13, 1);
  - re-read with 33 rows and 3 items superseded: Federation 11, UWA 9, Western Sydney PDF 13;
  - re-queued failed reads: Victoria University, Manukau, Wollongong;
  - course batch: 50 Monash courses, estimated US$0.25.
  - **Correction** to the #734 live entry: the re-read rows superseded are 33, not 46.
- **Earlier partial reads.** Federation and Western Sydney are superseded, not approved. Their replacement reads go to Layer 4 and stay unapproved until a complete read passes its source-anchored checks.
- **Spec s157.** Local suite: 1,141 passed, 0 failed, 0 skipped. Register `b4227bb6`.

### 29 Oct 2026 — programme batch outcomes; live visual acceptance; v2.15.365 (Pilot #736, written before merge)

- **#735 live** (merge `3b98257a`, md5 `02a434be` equals the file).
  - **All ten re-reads finished,** with rows kept rising from 169 to 1,179:
    - Western Sydney 367 (25 not kept);
    - Victoria University 147 (6);
    - Wollongong 175 (96);
    - Wintec 135 (24);
    - Manukau 68 (8);
    - Lincoln 71 (9);
    - Otago Polytechnic 71 (62);
    - UWA 50 (136);
    - NMIT 48 (2);
    - Federation 47 (35).
  - **Cost:** about US$0.46.
  - **Partial reads:** Federation, Wollongong, Otago Polytechnic and UWA are held for named source reasons. Federation and Western Sydney stay unapproved.
  - **First course batch:** 50 Monash courses. 48 are in Layer 4 with 197 rows, and 2 pages state no requirement. Cost US$0.45, about US$0.009 a course.
  - **Full course rollout:** the 4,926 remaining eligible courses would cost about US$45 against US$2.37 of OpenRouter headroom, so this needs a Platform Admin top-up or spend decision.
- **Live read-only visual acceptance.** The UI review screenshots workflow ran with the new `aer-tour`: 13 of 14 screens on live data at desktop and phone width, with no sideways scroll, no console error, 33 bounded reads and 0 writes.
  - **Found by looking:** the no-table pill and the cost were cut at their column edges, so v2.15.365 fixes them.
  - The phone shell banner clips its first letter. That is the shell notice, recorded and not changed.
  - The phone drawer step was not captured; the tour now taps a middle cell.
  - The screenshots and manifest are in admin `docs/platform/ui-audit/assets/2026-10-29-aer-workspace-live/` (`28200424`).
- **Layer 4 manifest** (`2026-10-29-aer-layer4-manifest.md`): 106 pending items, each classified once.
- **#736:** v2.15.365. s156 extended. Local suite 1,142 passed, 0 failed, 0 skipped; register regenerated.
- **Branches:** the 19 merged branches are verified landed. One deletion was refused by the proxy, recorded once. `cf247-zoho-dryrun` was fast-forwarded to main.

### 29 Oct 2026 — v2.15.365 live (#736, merge `869a4953`); programme report Part A filed

- **#736 deploy:** Release Currentness, Release History, Deployed UAT and Frontend Build all succeeded.
- **Live tour run 49 (from `main`):** 13 screens, no sideways scroll, no clipping, no console error, 33 bounded `admin_aer` reads and 0 writes.
  - The live phone drawer is still not captured. A mocked Pixel 7 probe opens it, so this is recorded as open work, not accepted.
- **Report:** `docs/platform/ui-audit/2026-10-29-aer-programme-consolidated-report.md` Part A (A1–A10). Manifest: `2026-10-29-aer-layer4-manifest.md` (106 pending items, each classified once).
- **Branches:**
  - `cf247-zoho-dryrun` is identical to main (`869a4953`).
  - Deleting the merged branches stays a Platform Admin action (proxy refusal, recorded once).
- **Not claimed:** AER complete; website display; course-level rollout complete; any proposed row as admitted.
- **Remaining Platform Admin decisions** (report A6):
  - the Layer 4 items;
  - 13 Read again clicks;
  - the OpenRouter top-up or spend decision for about US$45 of course reads;
  - a New Zealand identity rule for course reads;
  - branch deletion.

### 29 Oct 2026 — programme batch 2 (Pilot PR #737, written before merge)

- **Authority.** Platform Admin mandate 29 Oct 2026 12:23, B2 and B3; decision addendum W25 (`2222b60f`).
- **Migration `20261029050000`:**
  - the 13 approved Read again actions, one governed attempt each through `security.aer_reread_v1`: ANU ×9 read again; Melbourne ×3 and UTS fetched again as HTML;
  - one course batch through `security.course_entry_batch_v1` (next by priority), which the function refuses below the credit floor;
  - DP020 read once through `course_entry_read_enqueue_v1`, for the A3 verification.
- **Rolled-back live dry run:**
  - all 13 accepted: 9 re-reads (1 row and 1 item superseded each), 4 refetches (15, 9, 9 and 40 rows; 1 item each);
  - batch: 50 Monash courses, estimated US$0.44;
  - DP020 read queued.
- **Balance before:** US$7.05, floor US$5, measured US$0.0089 a course.
- **Spec s165.** Local suite 1,144 passed, 0 failed, 0 skipped (under the shared test lock). Register regenerated.
- **Also lodged:**
  - **A3:** migration `20261029060000` (W19), dry run passed. 92 of 2,535 RMIT pairs changed their explanation and 0 changed their rule. It ships with the UI release.
  - **B4:** NZ migration `20261029080000`, dry run passed: NZ eligible 421, weak 0, AU 4,977 unchanged.

### 29 Oct 2026 — v2.15.366: course evidence overlay, scholarships, label levels, priority countries, phone fixes, NZ course identity (Pilot PR #738, written before merge)

- **Authority.** Platform Admin mandate 29 Oct 2026 12:23, A1–A5 and B4. Decisions W19–W23 and W26 were lodged before code (`362cefe5`, `2222b60f`).
- **Lanes:** B (overlay, drawer, banner), A (scholarships, countries) and D (NZ identity) were built in separate branches; A3 by the integrator. Integrated on `cf247-aer-ux-release`; one import conflict resolved.
- **Migrations,** each md5-guarded against live definitions (rechecked just before merge) and each with a rolled-back live dry run that passed:
  - **`20261029060000` (W19).** Guards resolver `8281a03f` and `admin_aer` `744cb017`. A published label that names several levels counts for each.
    - Dry run: 2,535 RMIT course × country pairs; 92 changed only their explanation, 0 changed their rule.
    - DP020 for India now says "a band table exists, the course prints no band". DP020's page was read (#737): 4 rows, no band.
  - **`20261029070000` (W21).** Guards `admin_read` `f7f3ebde`, `scholarship_level_codes` `902fac0f` and `scholarship_sweep_apply_v1` `7189ffeb`.
    - `course_detail` carries `course_scholarships` again; DP020 shows its linked scholarships.
    - `postgraduate_research` maps to the research levels.
    - A page whose stated levels are not recognised makes no field-only link.
    - Nothing is re-applied or deleted.
  - **`20261029080000` (W26).** Guards `enrich_entry_record_v1` `b338ca23`.
    - NZ course reading on approved strong proofs (nzqa_code, adapter_code, manual); NZ eligible 421, weak 0; AU 4,977 unchanged; title-only and CRICOS refused.
    - NCEA and UE quotes are tagged domestic.
- **Defect found (A2) and reported at once:** 7,949 wrong research-scholarship links reach the website today (148 scholarships, 2,485 courses, 17 providers).
  - Paste file for the Platform Admin: `docs/platform/pastes/PASTE-20261029-scholarship-research-links-reapply.sql` (`de7ad4c0`). Run it after this release is live.
  - 4 scholarships with unusable pages (383 links) are left for a separate, commented-out decision.
- **UI:**
  - `Overlay.jsx`: a shared accessible dialog.
  - Course evidence overlay: the blade no longer embeds the history.
  - `aer-countries.js`: India, Nepal, Singapore, then A–Z.
  - The phone row tap no longer lands on a loading row; the drawer scrolls inside; the notice wraps beside its icon at phone width.
- **Specs:** s158, s160, s161, s162, s163 and s164; m245 updated. Local suite 1,166 passed, 0 failed, 0 skipped (shared test lock). Register regenerated.

### 29 Oct 2026 — v2.15.367: entry requirement reader v0.52.0, quotes read with the table structure that names them (Pilot PR to follow, written before merge)

- **Authority.** Platform Admin mandate 29 Oct 2026 12:23, B1 (with the 28 Oct 23:22 mandate and the 09:57 decision). Decision W24 lodged before code (`2222b60f`).
- **Lane C** (agent, own branch `cf247-aer-reader-corrections`, `59689c76`). Integrated onto main after v2.15.366 (no overlap: main had not changed the worker since the lane branched). The integrator's review found that a quote could cross into the next country's labelled row at Otago Polytechnic. The lane closed it before integration.
- **Worker `coverage-sweep-worker-v0.52.0`** (`entry.ts`, `pdf.ts`, `index.ts`):
  - A printed cell quoted with the structure that names it is on the page: a table's header line with one of its rows, or a PDF row's first cell with one other cell of that row.
  - A band given with its column header's words ("ATAR 70") is the printed cell only when the whole row is quoted.
  - A table with no header row carries the label printed just above it.
  - A quote never crosses a labelled row's boundary.
  - Quote on the page, scale, identity, completeness and whole-run admission are unchanged. There are no provider-specific grades and no paraphrase normalisation.
- **No migration.** The four sources are re-read once each in programme batch 3 (migration `20261029090000`, next PR), only after this worker is deployed and verified. Batch 3's rolled-back live dry run passed: four Read again actions accepted, superseding the v0.51.0 items (Federation 47 rows, Otago Polytechnic 71, Wollongong 175, UWA 50; none approved); one Monash course batch of 50, estimated US$0.43; balance US$6.54, floor US$5.
- **Batch 2 outcome (#737).** All 13 Read again actions finished, costing US$0.064 in total. ANU: 8 pages kept 11 or 12 rows each (was 1); the Croatian Matura page kept 0 of 8 (header and row quoted together, a form v0.52.0 now accepts). Melbourne: 2 pages kept 9 each; India State Board kept 1 of 8 (each row quote ran into the footnote). UTS kept 41 of 46. ANU Croatian Matura and Melbourne India State Board have used their one approved attempt and are held "re-read required" in the manifest. They are not retried.
- **Specs:** s159 (12 tests, stored-page fixtures for Otago Polytechnic, Wollongong and UWA, plus title and Federation PDF cases); m245 updated. Local suite 1,178 passed, 0 failed, 0 skipped (shared test lock). Register regenerated (326 specs, 1,274 tests).

### 29 Oct 2026 — AER programme batch 3: four corrected sources read once on v0.52.0, one course batch (Pilot PR to follow, written before merge)

- **Authority.** Platform Admin mandate 29 Oct 2026 12:23, B1 (re-read each corrected source once through the governed mechanism) and B3 (course batches within the existing headroom).
- **v2.15.367 delivered** (#739, `1a84e1a1`). Five deploy workflows passed. The deployed `coverage-sweep` (version 223) is `coverage-sweep-worker-v0.52.0`; `index.ts`, `entry.ts` and `pdf.ts` are byte-identical to main.
- **Migration `20261029090000`:**
  - Exactly four named sources (Federation PDF, Otago Polytechnic, Wollongong, UWA), one `security.aer_reread_v1` each. A refusal is recorded and not retried.
  - One `security.course_entry_batch_v1` (refused inside the function below the floor).
  - Logged as `programme_batch`. Nothing approved, dropped or deleted.
- **Rolled-back live dry run passed:**
  - All four accepted. Each supersedes its v0.51.0 item (rows 47, 71, 175 and 50; proposed only, never approved).
  - Monash batch of 50 accepted, estimate US$0.43.
- **Balance rechecked just before merge:** US$6.54, floor US$5 (unchanged), measured US$0.00858 a course.
- **Specs:** s166. Local suite 1,180 passed, 0 failed, 0 skipped. Register regenerated.

### 29 Oct 2026 — v2.15.368: live acceptance on real data, two display defects fixed, phone gate on targeted deployed runs (Pilot PR to follow, written before merge)

- **Authority.** Platform Admin mandate 29 Oct 2026 12:23, section C (deployed acceptance with real data) and A1/A4/A5.
- **Live tour** (UI review screenshots, `SCREENS=aer-tour`, read-only, extended to DP020 Course detail at desktop and phone width and the phone drawer close; snapshot `20261029-0307-run50`). Results on real data:
  - DP020 countries ordered India, Nepal, Singapore, then A to Z.
  - India: rule 5, "a band table exists, the course page prints no band".
  - 6 scholarships; evidence overlay with 24 timeline entries across 7 kinds; closed with Escape.
  - Phone drawer opens and closes; low-credit notice text starts inside the screen (no sideways scroll).
  - 0 console errors, 0 horizontal page scroll, largest list read 100, 0 writes.
- **Defects found by the tour and fixed** (display only, no data affected):
  - (1) The evidence timeline showed "Value: [object Object]" for a structured field fill (entry requirements). `CourseAudit.jsx` `fillValue` now tells it in words ("4 rows for review, 2 not kept"); cross-check values likewise.
  - (2) At phone width a long country name pushed the Course detail country selector past its card. `EntryRequirements.jsx` scopes a wrapping layout to that one control; the shared `.sd-actions` style is untouched.
  - Regression specs: s161 (structured value) and s163 (phone fit, long-name fixture). Both fail without the fix.
- **Deployed acceptance spec s167** (`@deployed`, read-only, runs targeted on deploy and in the acceptance tier). It covers DP020 at desktop and phone width (order, India through the resolver only, scholarships, overlay, no "[object Object]", selector inside its card) and the phone row drawer opening and closing, the banner, bounded reads and 0 console errors.
- **Deployed UAT workflow:** a targeted run whose spec holds phone checks (`@responsive`) now also runs the phone project. Before, the phone gate ran only in the wider tiers.
- **Proved on live before merge** (branch dispatch, live-acting off): desktop 2/2, phone 2/2. The two new defect assertions are proved by the post-merge targeted run against the deployed release.
- **Finding, reported, not fixed here:** the acceptance tier has 31 failing legacy deployed specs (a12, a13, a15, admin navigation, m2-3, data quality, layer 2 provider, course-detail polish, CF-061). They assert navigation and screens since changed. The weekly deployed run on main was already failing on 26 Oct. This is a G4 gap for a Platform Admin decision (repair or retire).
- **Finding (Read again):** `aer_reread_v1` re-read both stored copies of the Otago Polytechnic page, leaving two pending items for one source. The older (`f14ae480`) is marked stale in the manifest; about US$0.09 extra.
- **Specs:** s167 new; s161 and s163 extended; m245 updated. Local suite 1,182 passed, 0 failed, 0 skipped. Register regenerated.

### 29 Oct 2026 — AER course-level programme batch 4 (Pilot PR to follow, written before merge)

- **Authority.** Platform Admin mandate 29 Oct 2026 12:23, B3 (course batches within the existing headroom; the floor is not changed).
- **v2.15.368 delivered** (#741, `6602d09e`). Release History, Release Currentness, Frontend Build and Deployed UAT passed. The post-merge targeted Deployed UAT ran s167 on the deployed release: desktop 2/2 and phone 2/2. That run includes the two defect checks (no "[object Object]"; country selector inside its card).
- **Migration `20261029100000`:** one `security.course_entry_batch_v1`, refused inside the function below the floor, a refusal recorded and not retried; logged as `programme_batch`. Nothing read again, approved, dropped or deleted.
- **Rolled-back live dry run passed:** 50 Monash courses, estimate US$0.43.
- **Balance rechecked just before merge:** US$5.76, floor US$5 (unchanged), measured US$0.00859 a course. After this batch the headroom is under one batch, so course reading pauses at the floor (B3).
- **Specs:** s168. Local suite 1,183 passed, 0 failed, 0 skipped. Register regenerated.

### 29 Oct 2026 (Thu, Melbourne) – AER technical design and status deck
- Raised by the Platform Admin (16:23): review the repositories and prepare a presentation and technical design for academic entry requirements (stage, plan, how requirements are cross-referenced, with screenshots), in the milestone deck style, five pages.
- New `docs/platform/AER-TECHNICAL-DESIGN.md` v1.0 (router row added). It covers purpose and scope, current stage, architecture, data model, the five-rule resolver with a live worked example (RMIT, India), readers by source route, admin screens, consumer fields, settings, quality and testing, plan and risks. Screens are cropped from the 29 Oct live tour (`ui-audit/assets/2026-10-29-aer-design/`). The deck (5 slides) and a Word copy of the design were delivered to the Platform Admin; nothing changed on Pilot.
- Live figures read about 16:30 AEDT:
  - matrix rows: 343 active (RMIT, 24 countries), 2,186 proposed (26 providers), 20 quarantined, 765 superseded;
  - course rows: 695 proposed (184 courses);
  - sources: 102 for 34 providers (99 read, 3 refused);
  - matrix reads: 112 runs, about US$1.70.
- Live check: `security.entry_resolve_v1` for course 0100714 (BH126) and IN returns step 5 ("the course page prints no band"). The RMIT India Bachelor 65 % band rows are active (AISSC 65 %, ISC 65 %, State Boards 70 %).
- Finding: the quarterly edition check of decision 8 (`entry-matrix-edition-check`, `entry.edition_check_days`) is not scheduled; there is no such job or setting live. It is listed as plan item 7 in the design.

### 29 Oct 2026 — W27: one writer lock for search documents (scholarship paste deadlock), Pilot PR to follow, written before merge

- **Authority.** Platform Admin mandate 29 Oct 2026 16:59, Workstream 0. Decision W27 and the reconciliation report were lodged before code (`84cd25ac`; `docs/platform/ui-audit/2026-10-29-scholarship-deadlock-reconciliation.md`).
- **Reconciliation.**
  - The paste's first run deadlocked at 16:26 and rolled back in full.
  - Its second run committed at 16:57; the editor's "Failed to fetch" was the dashboard connection dropping after commit.
  - Live: 0 field-only links to non-research courses remain on applied scholarships (was 8,042). The 4 not-applicable scholarships keep 383 links (block C untouched). Hand links: 0. 2,605 search documents regenerated; DP020 shows 4 undergraduate/pathway scholarships.
  - The paste must not be run again: its precondition now reads 208.
- **Root cause.** The competing writer was job 39 `search-refresh-requested` → `search.refresh_course_documents_v3(true)`, a full rebuild (76 s), not Layer 4 review. No writer of `search.course_documents` coordinated with another, and each locked rows in plan order. Row ordering inside each call cannot help a transaction that refreshes 214 sets in turn.
- **Migration `20261029110000`** (md5-guarded):
  - `search.refresh_course_enrichment_scoped_v1` (`52bff5be`) and `search.refresh_course_documents_v3` (`40dc6d97`) wait for one transaction-scoped advisory lock (`-- fixed:`, G2).
  - `security.search_refresh_requested_v1` (`bb78c854`) only tries it and returns `held` (requests kept for the next run).
  - The scoped refresh locks its documents in ascending `course_id`.
  - No value, consumer API (G3), scholarship rule, admission gate or Layer 4 change. Nothing dropped.
- **Proof.**
  - `tools/concurrency/w27-search-writer-lock.sh` on a disposable local PostgreSQL 16 (local-only guard): before the fix, deadlock in all three cases (paste vs scheduled job, paste vs full rebuild, scoped writers with overlapping sets in opposing orders); after, none (job returns `held`; rebuild waits; scoped writers serialise).
  - Rolled-back live dry run: all three md5 guards matched, the DP020 scoped refresh ran, new md5s `fb55e935` / `402c1dae` / `6f3e46a7`.
- **Specs:** s171 (new); s32, s42, s57 and s120 pass. Local suite 1,187 passed, 0 failed, 0 skipped. Register regenerated.

### 29 Oct 2026 — W28: Read again targets the newest stored copy (Pilot PR to follow, written before merge)

- **Authority.** Platform Admin mandate 29 Oct 2026 16:59, Workstream 1 ("Correct Read again behaviour so it targets the newest stored source copy"). Decision W28 lodged before integration (`7af9067e`). Built by lane C on its own branch, integrated by the integrator.
- **Defect.** `security.aer_reread_v1` handed a finished read to `public.admin_entry_matrix_reread(array[source])`, which re-queues every run of the source. So Read again on Otago Polytechnic (`d74fcba4`) re-read both stored copies and left two pending items (`f14ae480` stale, `81d14690` current).
- **Migration `20261029120000`** (md5-guarded, live `7da10983`):
  - Only the run on the source's current stored copy is read again.
  - Older copies' runs keep their history. Their still-proposed rows and still-pending item are closed with the existing status `superseded`; decided items are untouched.
  - No new status, action or setting. Gates and the consumer API unchanged. `admin_entry_matrix_reread` (md5-pinned elsewhere) is unchanged.
- **Proof.**
  - Lane C's local Postgres test: the live definition re-queued 2 runs, the new one 1.
  - Rolled-back live dry run on `d74fcba4`: one run re-queued (`55ace659`, copy `370a12ce`), older run `0d4ca5a0` kept (done, history 1), 210 proposed rows and both items superseded. New md5 `26a70e31`.
- **Not done:** the existing duplicate `f14ae480` is left for the Layer 4 reviewer; no Read again was run on live.
- **Specs:** s169 (new, Otago two-copy fixture). Local suite 1,191 passed, 0 failed, 0 skipped. Register regenerated.
- **Inventory (lane C, read-only):** 102 sources (66 in reading scope plus RMIT's 36). Otago Polytechnic is the only source with a pending item on an older copy. 11 others have two stored copies, none with a stale pending item. 12 sources are held for a reader change; 3 Macquarie PDFs have never been read.

### 29 Oct 2026 — v2.15.369: W29 long course pages read in slices (worker v0.53.0), Pilot PR to follow, written before merge

- **Authority.** Platform Admin mandate 29 Oct 2026 16:59, Workstream 2 ("design bounded sectioned/sliced extraction … test against long-page fixtures before any paid re-read; do not blindly retry the same request"). Decision W29 lodged before integration (`c3f36374`). Built by lane D on its own branch, integrated by the integrator.
- **Diagnosis.** The three Monash course reads (`e58e7771`, `512b56fe`, `9cf18451`) failed on all three attempts with "Unterminated string in JSON" at 8,061–8,598 characters.
  - The worker's course entry read asked for the whole page in one call with a fixed 2,000-token answer, did not detect a cut answer, and recorded no cost on failure (estimated about US$0.10 unrecorded across 9 calls).
  - The page sizes were ordinary for Monash; the answers were long (many per-country minimums).
- **Worker `coverage-sweep-worker-v0.53.0`** (`course-entry.ts`, `index.ts`):
  - contiguous overlapping slices with recorded character coverage;
  - each answer limited by a setting; a cut, empty or unreadable answer fails its slice by name;
  - quotes checked on their slice; rows merged in page order; duplicates from overlaps kept once;
  - any failed slice holds the whole read (`held_partial` reason, existing failure path, no new status); a page longer than `entry.course_page_chars` is held before any call;
  - cost recorded on failed reads;
  - a one-slice page is asked exactly as before.
- **Migration `20261029130000`:** five settings (`enrich.course_entry_slice_chars` 12,000, `…_slice_overlap_chars` 600, `…_max_slices` 10, `…_max_tokens` 8,000, `…_slice_concurrency` 4, each with label, range, unit and `used_by`); `entry.course_page_chars` help text; `security.enrich_entry_record_v1` keeps the read's coverage (md5-guarded `0f4d8f90`).
- **Proof.** s170 (new; long-page fixtures, no network); s139 updated; s159, s32, s42, s120 and m245 pass (43/43). Rolled-back live dry run passed (record function → `857102dc`).
- **Not done:** no paid read. The three failed Monash courses need one separately approved re-read once v0.53.0 is live.
- **Also in this release:** the release notes record W27 (#743) and W28 (#744), which are already live.
- **Specs:** local suite 1,199 passed, 0 failed, 0 skipped. Register regenerated.

### 29 Oct 2026 — Workstream 4: deployed suite health (repairs and 6 retirements; one regression left red), Pilot PR to follow, written before merge

- **Authority.** Platform Admin mandate 29 Oct 2026 16:59, Workstream 4 ("repair legitimate failures without weakening assertions; formally retire obsolete tests through the test-governance process"). Built by lane E on its own branch, integrated by the integrator. Test and workflow files only; no product code.
- **Classification of the 31 acceptance-tier failures:**
  - Most were obsolete or drift after the v2.15.225–v2.15.301 screen changes (Layer 2/3 rename, Layer 4 Inbox, Datasets, insights on demand, contacts off the blade). They were repaired against the current canonical screens.
  - A shared helper bug was fixed: it checked for the tab bar before it was drawn.
- **Retired (6), recorded in the retirement log** (`ui-audit/2026-10-26-test-governance.md`, `594115c6`): m2-4-4-layer-status, course-detail-polish (3), m245 v2.15.74 release currentness, cf-092 scheduled-jobs config, admin-navigation "Source profiles…", cf-080 Layer 4 contact reconciliation. Deployed tests go from 97 to 89; `deployed-uat.yml` lists updated.
- **Left red, by rule:**
  - **(b) product regression:** `admin_layer23('universities')` returns 1.97 MB against the 700 KB budget (about 3.2 s). The budget is unchanged; server paging needs a decision.
  - **(b/d) intermittent statement timeouts** on five admin reads.
- **Evidence:** lane E acceptance run 40842662895 (live-acting off): desktop 68 passed, 1 failed (the regression), 1 flaky (timeouts). A phone run with the weekly-only specs (run 40840795858) gave about 75 passed per project.
- **Specs:** local suite 1,199 passed, 0 failed, 0 skipped. Register regenerated.

### 30 Oct 2026 — v2.15.370: W30 enrichment reliability and W32 AI answer limits (mandate 30 Oct 00:01, Workstreams 2 and 5)

- **Decisions:** W30 and W32 were lodged before code (`AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` §8, admin `cb1974b9`). Evidence: `ui-audit/2026-10-30-enrichment-health-reconciliation.md`.
- **Migration `20261030010000_cf247_enrich_reliability`** (md5-guarded edits of live definitions):
  - `public.svc_source_find_next` (was `57a32d94`): the candidate scan is worked out once per set. It had timed out at 8 s on 80 of 143 calls in 48 h.
  - `public.svc_coverage_read_next` (was `a8bfed7c`): the lease is re-checked on the locked row, so one claim per page. Jobs 49 and 159 had double-paid 767 of 3,083 scrapes in 7 days.
  - `security.provider_onboarding_job_v1` (was `ab742e1e`): tracks its own university's job.
- **Migration `20261030020000_cf247_reader_answer_limits`:** 12 `reading.answer_tokens.*` settings. Defaults are the values formerly fixed in code; the fee reader gets 32,000.
- **Worker `coverage-sweep-worker-v0.54.0`:**
  - answer limits come from settings, and a cut answer is held as `held_partial: output_truncated`;
  - cost is recorded on failed reads;
  - capture and proposal calls report `items` and `failed`.
- **Rolled-back live dry runs:**
  - W30: md5 guards matched; the source-finder call took 139 ms after the edit;
  - W32: 12 settings within range, and `svc_worker_settings_v1` returns all 12.
- **Tests:**
  - specs s172 and s173 are new; s170, s11 and m245 were adjusted (no assertion weakened);
  - full local suite 1,211 passed, 1 failed: the s173 version pin, fixed in `9c79fc2e` and re-run green, so effectively 1,212/0/0;
  - build OK; worker syntax check OK; TEST-REGISTER regenerated.
- **Unchanged:** the consumer API (G3), identity, quote, completeness and admission gates, and the floor. No paid read.

### 30 Oct 2026 — v2.15.371: W31 site re-maps keep code-proved course pages; W33 Universities list paging (mandate 30 Oct 00:01, Workstreams 3 and 4)

- **Decisions:** W31 and W33 were lodged before code (`AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` §8, admin `cb1974b9`).
- **W31 cause:** on 29 Oct the routine 30-day re-map and job 47 demoted or replaced 789 AU code-proved pages, 714 of them wrongly (eligible AU 4,977 → 4,156). No weak page became eligible.
- **Migration `20261030030000_cf247_coverage_bind_code_proof`:** an md5-guarded edit of `security.coverage_bind_v2` (was `bc1872ed`).
  - A page read with a `cricos_code`, `nzqa_code`, `adapter_code` or `manual` proof is never re-scored, demoted or released unless refused.
  - The release step releases only binder-owned rows.
- **Worker `coverage-sweep-worker-v0.54.1`:** in `extract.ts`, the labelled NZQA number rule no longer applies to a page of another known country (it still applies to NZ pages and to callers that give no country). College of the North Atlantic (CA) had 53 pages labelled `nzqa_code`.
- **Migration `20261030040000_cf247_universities_paging`:**
  - `admin_layer23('universities_page')` is added beside the existing actions (md5 guard `aaf0e7d8`);
  - settings `layer23.universities_page_size` (100) and `layer23.universities_tick_max` (2,000);
  - `AdaptersWorkspace.jsx` reads pages.
  - The old `'universities'` action is kept until the screen is live, then retired by a later md5-guarded edit.
- **Rolled-back live dry runs:**
  - W31 on 9 providers: 0 of 1,230 code-proved pages changed (10 other rows rebound normally);
  - W33: first page 83 KB in 1.0 s (was 1.97 MB); NZ ticks 404 rows.
- **Tests:** s174 (W33) and s175 (W31) are new; the performance spec waits for either action, with its budgets unchanged. UI catalogue 1.15; TEST-REGISTER regenerated.
- **Not done (BLOCKED):** recovery of the 714 displaced pages (decision paper R1, up to 714 Firecrawl credits); the past-year handbook currency decision; the admin-read timeout snapshots (decision).
- **Unchanged:** the consumer API (G3) and every gate. No paid read.
- **Full local suite:** 1,221 passed, 1 failed. The failure was `cf-247-nz-coverage-contract`, which calls `identity()` without a country. The rule was corrected to keep the old behaviour for callers that give no country, and the spec was re-run green with no assertion changed, so effectively 1,222/0/0. Build OK; worker syntax check OK.

### 30 Oct 2026 — AER bounded paid reads, step 1: B1 and B2 (Platform Admin mandate 30 Oct 06:53)

- **Migration `20261030050000_cf247_aer_validation_reads_b1_b2`.**
  - **B1 (ceiling US$0.05):** ANU Croatian Matura `87f40035`, ANU Bosnia-Herzegovina `6aee5653` (item `509c8f82`) and Melbourne India State Board `467c7a0c` (item `290bd250`), each read again on its newest stored copy through `aer_reread_v1`.
  - **B2 (ceiling US$0.10):** Monash `e58e7771`, `512b56fe` and `9cf18451`, each read once through `course_entry_read_enqueue_v1` by worker v0.54.1, which reads in slices.
- **Preconditions in the migration:**
  - each source's newest run is on its current copy, with nothing waiting;
  - the 3 courses are eligible, with exactly 3 failed items and no others;
  - no course read is waiting;
  - AI reading is allowed;
  - the balance is above the floor by both ceilings;
  - the worker is v0.54.x.
- **Post-checks:** 3 runs and 3 course reads queued.
- **Live dry run (rolled back):** all checks passed. Balance US$104.84, floor US$5, worker v0.54.1. As expected under W28, items `509c8f82` and `290bd250` were superseded by the newest-copy re-read.
- **Outputs** go to Layer 4 for a person. Nothing is admitted automatically.

### 30 Oct 2026 — AER paid step 1 verified (B1, B2) and step 3 queued (R1) (Platform Admin mandate 30 Oct 06:53)

- **B1, done at 07:14 AEDT. Actual spend US$0.0155 against the US$0.05 ceiling.** Each read is on its newest copy with worker v0.54.1. Rows kept now against before:

  | Source | Kept now | Kept before | Spend | New Layer 4 item |
  |---|---|---|---|---|
  | Melbourne India State Board | 9 of 9 | 1 | US$0.0050 | `dcf9300f` |
  | ANU Bosnia-Herzegovina | 5 of 5 | 1 | US$0.0028 | `987dac71` |
  | ANU Croatian Matura | 7 of 8 | 0 | US$0.0077 | `2b491c25` |

  - All three new items are pending, with 21 rows proposed. Nothing was admitted.
  - The partial items `509c8f82` and `290bd250` were superseded by the newest-copy re-read (W28).
- **B2 held, with no spend.** The three Monash course pages hold 104,282, 108,295 and 100,365 characters of text. That is above `entry.course_page_chars` (100,000), so each read was held before any AI call (`held_partial`, cost recorded as US$0). Nothing was proposed.
  - **Decision needed:** raise `entry.course_page_chars` to 115,000, which fits within 10 slices of 12,000 with overlap, then re-read the three courses (ceiling unchanged at US$0.10).
- **R1, migration `20261030060000`:** recovery reads for the verified manifest.
  - **A, 451 pages:** the same page, read again.
  - **B, 263 pages:** the previous page restored as ambiguous and read again.
  - A page becomes bound only when a fresh read finds the course's CRICOS code (`svc_coverage_read_record`, unchanged).
  - **Not touched:** 73 past-year handbook pages (the holds stay), 3 refused pages and 32 others.
  - **Ceiling:** one read attempt each (`read_attempts` set to 2), so at most 714 reads and at most 714 Firecrawl credits. No AI is called by a page read.
  - **Live dry run (rolled back):** A 451, B 263, 714 due.

### 30 Oct 2026 — v2.15.372: the AER review path (A1–A3) and bulk Read again on the newest copy (A5) (Platform Admin mandate 30 Oct 06:53)

- **Decisions:** §9 and §10 of `AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md`, lodged before merge (`d9514fb8`, `d9e5db47`).
- **Migration `20261030070000_cf247_aer_review_path`:** md5-guarded edits of `layer4_review_decide_impl` (`22f17fa1`), `entry_matrix_review_apply_v1` (`5531f019`), `course_entry_review_apply_v1` (`e2ae70b0`), `layer4_review_bulk_decide` (`e6a2ffdd`), `layer4_batch_decide_v1_impl` (`f8e9e973`), `layer4_inbox_kinds_v1` (`3f1fddbe`), `layer4_inbox_items_v1` (`cc42a3d5`) and `admin_layer4_inbox` (`272438c2`), plus five new review functions.
  - **A1:** Approve except. Excluded rows go `inactive` with "excluded by approve except (item, reviewer): reason", and the decision and events record their lineage.
  - **A2:** bulk and batch decide skip AER kinds and return `skipped_aer`.
  - **A3:** AER decisions need rank 6.
  - **Inbox:** AER items have their own kind, `aer_review`.
- **Migration `20261030080000_cf247_aer_bulk_reread_newest_copy`:** `admin_entry_matrix_reread` (`ca394b60`) now reads the newest copy only, and the governed snapshot (`55910cb4`) moves to Option A.
  - **Security fix:** the role check never fired inside the security-definer function. API callers must now be Platform Admin.
  - **Reported separately:** the same idiom in `admin_adapter_measures`.
- **Live dry runs (rolled back):**
  - Inbox: 242 AER items.
  - A3: Curator refused, both directly and through the Inbox.
  - A2: bulk skipped 184, batch skipped 2, pending unchanged.
  - A1: RMIT Qatar approve-except gave 1 row active and 1 excluded, with lineage, run `e07eeaf5` and hash `64edc4fe`.
  - A5: Curator refused; Otago Polytechnic re-queued 1 run (the newest copy), the older copy kept, 2 items superseded, unknown id skipped.
- **Tests:** specs s176 and s177; full local suite **1,238 passed, 0 failed, 0 skipped**; build OK; TEST-REGISTER regenerated.
- **Guides:** role guides updated for A1–A5 (`c78c83e9`). A4 is recorded as O9 in the website register (2.4). The API marker for "scale not stated" is the next decision; the developer guide is unchanged because the API is unchanged.
- **Open point:** approving a change item supersedes the active row whose new reading was excluded. Until it is decided, reviewers reject such change items.
- **Unchanged:** the consumer API.

### 30 Oct 2026 — R1 reconciled; v2.15.372 delivered; B3 batch 1 queued (Platform Admin mandate 30 Oct 06:53)

- **R1, settled at 07:34 AEDT.** Queued 714, against a manifest of A 451 and B 263.

  | Outcome | Pages |
  |---|---|
  | Bound again on a fresh CRICOS proof (A 440, B 237) | 677 |
  | Bound on exact title, not eligible for entry requirements | 2 |
  | Adapter-code proofs, still ambiguous (the reader promotes only on CRICOS) | 13 |
  | Needs render | 6 |
  | Fetch failed | 4 |
  | Blocked | 2 |
  | Identity mismatch | 3 |
  | Still waiting for their one attempt | 7 |

  - **Credits:** 3 Firecrawl credits used, against the 714 ceiling. No AI.
  - **Eligibility:** AU eligible is now 4,834 (4,157 before R1); NZ is 438.
  - No CRICOS or code-proof requirement was weakened, and no page was bound by hand.
- **v2.15.372 delivered** (#751, `b1cf6189`). Live md5s match the dry runs:
  - `admin_entry_matrix_reread` `e2566cb6`, snapshot `af76dcb7`;
  - decide `67966ceb`, apply `7c718987` and `25899209`, bulk `512226a0`, batch `d3135163`, inbox `3f2b49d5`, `08e7999c` and `ff6e116b`.
- **B3 batch 1, migration `20261030090000`:**
  - `entry.course_batch_size` changes from 50 to 200, within its range, with the reason recorded.
  - It queues the next 200 eligible AU courses by plan order: Monash 155 and QUT 45.
  - **Preconditions in the migration:** B3 scope total stays within 500; spend plus estimate stays within US$6; no read waiting; AI allowed; balance above floor by the estimate; worker v0.54.x.
  - **Post-checks:** every queued course is AU and eligible.
  - **Live dry run (rolled back):** estimate US$2.00 at US$0.0100 a course (measured US$0.0080, plus 25%); balance US$104.80.
