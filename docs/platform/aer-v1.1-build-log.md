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
