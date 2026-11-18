# S1-AER: AER course machine re-validated, matrix level and completion rules, AER v2 replay round 4 (18 Nov 2026)

**Session:** S1-AER (continuing S2-BOOST-AER). **Mandate:** Platform Admin standing autonomous execution mandate, 18 Nov 2026 19:28 AEDT, steps 1 to 3.
**Live project:** `fxcwkweaxjtknorudmwp`. Every database read in this session went through rolled-back GitHub Actions runs (`db-migration-dry-run.yml` with a probe); no interactive Supabase tool was used.
**Pilot:** #1308 (S673), #1310 (S671 and S672). Live migration head `20261118239000`. G3 75 functions and 48 relations, read back after each deploy.

## 1. Summary

| Step | What | Result |
|---|---|---|
| 1 | AER course machine validation re-run (S673, migration `20261118237000`) | Validation 6 passed 20:09:59 AEDT. Admission is live again: the 20:24 run admitted 1 read (2 rows). Thresholds unchanged (0.8, 8). |
| 2 | Matrix rows: level printed over the table, "Year N equivalent", completion-only rows (S671, migration `20261118238000`) | 127 rows take a level, 225 rows are completion-only. Matrix reads that pass the rule: 0 to 2; both admitted at 20:24 (UTAS 29 rows, Deakin College 1 row). Matrix validation 12 passed. |
| 3 | AER v2 offline qualification replay, round 4 (S672, migration `20261118239000`, workflow `aer-v3-replay.yml` run 44273806589) | **No model passes the gate (Path B).** Nothing qualified or switched on. US$0.125 spent; switches back to 0; on-demand window closed. |

## 2. Step 1: AER course machine admission re-validated (S673)

- **Why it was in shadow:** `security.aer_machine_run_v1` admits only while a passing validation is younger than 7 days. The only pass was 11 Nov 15:40 AEDT, so admission ran as shadow from 18 Nov 15:40.
- **There was no validation workflow to trigger.** The 11 Nov validation ran inside a migration (`20261112001700`). The same route was used: a migration that runs `security.aer_machine_validate_v1()` under its live md5 (`945077fe…`), through PR, green CI, rolled-back live dry run and deploy on merge. No interactive prompt.
- **Before the change (rolled-back live run, 19:31):** passed; 396 would-admit reads re-checked, 0 regressions; 0 human non-approvals; 0 of 302 disagreements with past human decisions.
- **Read back (20:11):** validation 6, passed at 20:09:59 AEDT. 401 would-admit re-checked, 0 regressions, 188.5 shadow hours. `aer.machine_mode` 2 (not changed), confidence 0.8 and quote 8 unchanged, variant twins still held (Decision 276). One audit event.
- **Pace of admission (by rule, not changed):** the job re-checks a read only 6 hours after its last shadow check (a fixed rule in `aer_machine_run_v1`). The 90 reads recorded `would_admit` were checked in shadow this afternoon, so they are admitted as each 6-hour re-check comes round, by about 02:30 Thursday, within `aer.machine_daily_max` (1,000). The 20:24 run admitted 1 read.
- **Lapse again on 25 Nov 20:10 AEDT.** Nothing renews a validation automatically ("a passing qualification never switches anything on by itself").

## 3. Step 2: matrix parser rules (S671)

**Live facts behind it (19:35 to 19:50):** 77 first matrix reads wait. Of their 3,100 proposed rows, 1,142 have no study level and 562 no minimum. The level is printed once over the table, not in each row. The platform already maps "undergraduate" to bachelor (`security.entry_level_map_v1`, 384 active rows).

**Rules (deterministic, from the stored read; no fetch, no AI, no reader change, Decision 276):**
1. **Level from the heading or file title.** The stored page heading (`result.completeness.heading`) and the address's last path segment (a PDF's file name) are mapped word by word. A row with no level read takes the level only when:
   - exactly one level is named;
   - it is in `aer.matrix_level_inherit_codes` (bachelor, masters, doctorate, foundation);
   - no row of the read names a level of its own.
   Diploma and certificate are left out: in a heading they usually name the overseas qualification ("Hong Kong Diploma of Secondary Education"). The basis is kept in `provenance.level_from`.
2. **"Year 10/11/12 equivalent" is not a level.** It says what the qualification equals. Such a row is held as `level_equivalence_only` unless rule 1 applies (label kept as `provenance.equivalent_to`).
3. **Completion-only rows.** A row whose quote states a completion requirement and carries no score (no percentage, no number except a schooling year, grade, form or level or a duration, no score words) is a published requirement with no minimum. Nothing is written into its minimum; `provenance.completion_only` is recorded.

**How:** `security.aer_matrix_machine_exclusions_v1` replaced in place; `security.aer_matrix_machine_check_v1` and `security.aer_matrix_machine_admit_v1` edited under their live md5. Read-back md5: exclusions `51e0eb45…`, check `80636b9a…`, admit `debe928f…`. CREATE OR REPLACE only; no new function or table. Switches `aer.matrix_level_inherit_on` and `aer.matrix_completion_only_on` (0 restores 12 Nov exactly).

**Effect (rolled-back dry run, matched by the live read-back):**

| Measure | Before | After |
|---|---|---|
| Rows that take a level | 0 | 127 (Lincoln 59, Adelaide 39, UTAS 29) |
| Completion-only rows | 0 | 225 |
| Reads passing the rule | 0 | 2 (admitted at 20:24: UTAS 29 rows with bachelor from the address, Deakin College 1 completion row) |
| All rows held | 15 | 14 |
| Held by the D-R3 gate | 55 | 54 |

- **Why the gain in reads is small:** 54 reads are stopped by the D-R3 gate before any row rule. The reader dropped published rows (unknown country, quote not on the page, grade not in the quote), so a country is left with no row. Only a corrected read can fix that; the gate is not loosened.
- **Not inherited, by the guards:** Macquarie undergraduate PDF (one row names "International Foundation Year"), UTAS's second page and UWA (no level in the heading or address), equivalence tables (ALG, TAFE Queensland, South Sydney College: no level named).
- **Matrix validation:** its only pass (11 Nov 21:48) would have lapsed at 21:48 tonight; re-run in the same migration, validation 12 passed. `aer.matrix_machine_mode` not changed.

## 4. Step 3: AER v2 offline qualification replay, round 4 (S672)

**Setup (same as round 3):** frozen set 5 (50 cases), prompt `aer-v2-course-v3` (same sha-256), `reading.aer_v2_page_chars` 60,000, `reading.aer_v2_max_tokens` 12,000, long-page sections on for the run only, worker `coverage-sweep` v1.0.18. The exact pinned IDs, each `allow_fallbacks: false`:
- `qwen/qwen3-30b-a3b-instruct-2507`
- `mistralai/mistral-small-3.2-24b-instruct`
- `xiaomi/mimo-v2.6-flash`

**Route:** migration `20261118239000` opened proposals `aer-v2-course-v3-*-r4` and three queued runs (36 to 38). The new workflow `aer-v3-replay.yml` (dispatch only) did the rest:
1. Opened on-demand window `639066c5` (OpenRouter only, 0 Firecrawl).
2. Turned the three run switches on.
3. Asked worker mode `aer_v3_eval` (10 calls, 20:13 to 20:37 AEDT).
4. Scored the runs with `security.ai_eval_score_v1`.
5. Turned the switches back to 0 and closed the window.

It also releases a part-answered run's lease when a call finishes (lesson 7), so the round took 24 minutes instead of about 75.

| Model (pinned) | Right of 50 (round 3) | Source integrity | Error points | False positives | Time-outs | Cost |
|---|---|---|---|---|---|---|
| `xiaomi/mimo-v2.6-flash` | 14 (12) | 60% | 26 | 2 | 11, plus 2 cut answers | $0.069 |
| `mistralai/mistral-small-3.2-24b-instruct` | 11 (13) | 85.7% | 22 | 2 | 11 | $0.033 |
| `qwen/qwen3-30b-a3b-instruct-2507` | 3 (2 in round 2) | 100% (on 3 right) | 54 | 0 | 27 | $0.023 |

- **Gate, unchanged:** source integrity 100%, error rate at most 10 points, no false positives. **No model passes.** Path B: nothing qualified, the AER v2 shadow and the AER v1 entry routes stay off, and no held read is re-read. Evidence is recorded as `pending` in `pipeline.ai_route_qualifications` (runs 36 to 38).
- **Spend:** answers US$0.125. AER v3 spend over all time is US$1.372 of the US$2 cap (`ai_eval.aer_v3_max_usd`). OpenRouter balance US$11.02 to US$10.86 over the window (all lanes).
- **What this shows:** round 4 reproduces round 3. The blockers are the same:
  1. The 90-second per-call time-out. It is a fixed code value, not a setting; Qwen timed out on 27 of 50.
  2. Quotes not found on the page.
  3. Missed rows. Accuracy stays at or under 28%.

  Re-running the same prompt and limits will not qualify a model, and the about 1,620 incomplete reads stay held.

## 5. Decisions for the Platform Admin (nothing changed for these)

1. **AER v2 qualification next step.** Options:
   - (a) Revise prompt v3 for the rows it misses, using person-decided cases (benchmark lesson 3), then run round 5 with `aer-v3-replay.yml`. Recommended.
   - (b) Give the evaluation calls a longer time-out than 90 seconds. This changes a fixed code value in the worker.
   - (c) Stop AER v2 replays until the Phase 5 audit samples exist.
2. **Validation lapse.** Both AER validations lapse every 7 days: course reads on 25 Nov 20:10 AEDT, matrices on 25 Nov 20:12. Choose between:
   - re-running each by a recorded decision, as done today;
   - a standing rule that lets the Integration Controller re-validate on the same terms.

## 6. Housekeeping and records

- **Specs:** S671, S672, S673 (Pilot `tests/uat/cf-247-s67{1,2,3}-*.spec.mjs`). `TEST-REGISTER.md` regenerated: 786 specs, 3,635 tests. This also picks up the s670 gap noted at 19:00.
- **Decision 276:** amendments S671 and S673 added in `docs/coursefinder-design-reference-v1.4.md`.
- **Migration numbers:** `20261118234000` was also used by open Pilot #1307 (S2-Build). S673, S671 and S672 were renumbered to `237000`, `238000` and `239000` before merge.
- **Freeze:** all three migrations were merged and applied before Thursday's 01:15 to 03:30 AEDT freeze.
