# S1-AER: AER v2 prompt v3.1 and round 5, standing validation renewal, and the five AER consumer data findings (18 Nov 2026)

**Session:** S1-AER. **Authority:** Platform Admin 18 Nov 2026 20:53 AEDT (decisions 1 to 4) and 22:26 AEDT (alert batch `88e5ff5b-3fb9-4613-80db-3ff0c96a6b06`).
**Live project:** `fxcwkweaxjtknorudmwp`. Database reads went through rolled-back GitHub Actions runs or read-only workflows. Edge logs were read with the read-only log query.
**Pilot:** #1311, #1313, #1317, #1320 (s674), #1321 (s675). Migrations `20261118243000` and `20261118270000`. Worker `coverage-sweep` v1.0.19. G3 75 functions and 48 relations.

## 1. Summary

| Item | Result |
|---|---|
| Prompt `aer-v2-course-v3.1` (every requirement row) and 180 s evaluation calls (s674) | Live. Prompt v3.1 is data on the three exact pinned models. Evaluation calls wait up to 180 s (was 90 s). |
| Round 5 replay (`aer-v3-replay.yml`) | **No model passes the unchanged gate.** Qwen3 30B time-outs fell from 27 to 11, but its quote fidelity fell to 25%. Nothing qualified or switched on. |
| Standing 7-day validation renewal | Recorded and automated: workflow `aer-validation-renew.yml`, daily 18:17 AEDT. Renews only on the named thresholds and validators. |
| 02:45 Thursday course-read check | Scheduled into this session (read only). |
| Five critical AER consumer data findings (s675) | Not defective data: 149 rows a person approved on 30 Oct. A re-record on 11 Nov detached the approvals. Link check and guard fixed; nothing quarantined. |

## 2. s674: prompt v3.1 and the 180-second evaluation call

- **Prompt v3.1 (migration `20261118243000`).** Same as v3 plus one section, "Tables and lists (read every row)":
  - one record for every printed requirement row or item, first to last, never sampled or merged;
  - completion-only rows kept, with `min_grade` null;
  - a final check that every row is a record or is in `seen_not_mapped`.

  It is held as three evaluation versions on the exact pins: `qwen/qwen3-30b-a3b-instruct-2507`, `mistralai/mistral-small-3.2-24b-instruct`, `xiaomi/mimo-v2.6-flash`. None allows fallbacks. Round-5 runs 45 to 47 are on frozen set 5.
- **Why the time-out change needed more than one number.**
  - A Supabase Edge Function call has a 150 s request idle time-out, so a 180 s model call can't be awaited inline. The wall clock of a paid-plan worker is 400 s.
  - First attempt, background tasks (`EdgeRuntime.waitUntil`, #1311):
    - Mistral's answers came back.
    - Qwen and MiMo answered nothing. The edge logs showed the coverage-sweep isolates retired with `EarlyDrop` 30 to 60 s after start, and once with `CPU Time exceeded`.
  - Final design (#1313, #1317): the replay workflow issues a one-time nonce and calls the worker directly with `stream: true`.
    - The worker answers as a stream: a space every 10 s, then the result. This keeps the request active within the 400 s wall clock.
    - Each answer is recorded as soon as it is given.
    - A call starts at most 8 examples (a CPU guard).
  - #1320 fixed a comment that had swallowed a line of the replay script. The S672 and S674 specs now parse both AER workflow scripts.

**Round 5 results (`aer-v3-replay.yml`, 22:47 to 23:07 AEDT; on-demand window `6c37d8fc`, OpenRouter only):**

| Model (pinned) | Right of 50 (round 4) | Quotes on the page | Error points | False positives | Time-outs (round 4) | Cost |
|---|---|---|---|---|---|---|
| `xiaomi/mimo-v2.6-flash` | 14 (14) | 54.6% | 12 | 4 | 6 (11) | $0.050 |
| `mistralai/mistral-small-3.2-24b-instruct` | 13 (11) | 85.7% | **8** | 2 | 2 (11) | $0.058 |
| `qwen/qwen3-30b-a3b-instruct-2507` | 7 (3) | 25% | 22 | 3 | 11 (27) | $0.049 |

- **Gate (unchanged):** 100% quotes on the page, at most 10 error points, no false positives. **No model passes.**
- **Mistral Small 3.2** now meets the error-point limit (8). Its quote fidelity (85.7%) and false positives (2) still fail.
- **Qwen3 30B:** the 180 s limit cut its time-outs from 27 to 11. Its answers under prompt v3.1 put quotes off the page (25%), so the fidelity on 3 answers in round 4 did not hold on more answers.
- **Missed rows:** the every-row section did not reduce them (Mistral false negatives 31).
- **Spend:** AER v3 spend over all time is US$1.529 of the US$2 cap (`ai_eval.aer_v3_max_usd`). OpenRouter balance was US$10.86 at 20:37 and US$10.37 at the end of round 5 (all lanes).

## 3. Standing rule: automatic 7-day validation renewal

- **Recorded in:** the AER runbook (`docs/platform/2026-11-12-aer-admission-mechanism.md`, item 3a), `docs/CURRENT-STATE.md` and Decision 276.
- **Workflow `aer-validation-renew.yml`** (Pilot) runs daily at 18:17 AEDT. It renews rules `aer-machine-v1` and `aer-matrix-machine-v1` once the last pass is `aer.validation_renew_after_days` (5) old.
- **It renews only when all of these hold:**
  - the thresholds are the named ones: course reads 0.8 confidence and an 8-character quote; provider tables 0.9 and 8;
  - the validators are the ones checked on 18 Nov (md5 `945077fe…` and `162cfa24…`);
  - the mode is 2 and admission is not suspended;
  - the result has 0 regressions.
- **Anything else is reported and fails the run.** Nothing is forced on.
- **Next renewal:** about 23 Nov 18:17 AEDT, ahead of the 25 Nov lapse.
- **Read-only status (21:56 AEDT):** both rules last passed at 20:10 AEDT. Since then, 1 course read and 2 provider tables were admitted. 90 course reads are recorded as would-admit and wait for their 6-hour re-check.

## 4. s675: the five critical AER consumer data findings

**What they are (live, read only, 22:40 to 22:58):**
- Root cause `consumer_unadmitted` at five providers, 149 active provider-table rows in all:
  - Auckland University of Technology: 56
  - Whitireia and WelTec: 44
  - Massey University: 36
  - Flinders University: 12
  - University of Otago: 1
- Each provider's 28 Oct reading was decided by a person on 30 Oct (approved, or edited and approved). The approved item names the run (`proposed_value.run_id`).
- The rows have not changed since 30 Oct (version 1).

**How they were flagged:**
- On 11 Nov at 19:15 to 19:20 AEDT, the qualification-first re-record of stored readings (migration `20261112070000`) recorded the same five runs again.
- `public.svc_entry_matrix_record` raised an `entry_matrix_change` item for each run and pointed the run at it. The approved items lost their run.
- The check follows run to item, so it read the person-approved rows as "not admitted" from 11 Nov 19:27 AEDT.
- **No row bypassed Layer 4, and no defective value is served.**

**Decision taken: no quarantine.** Withdrawing the 149 rows would remove person-approved entry requirements for five universities from the consumer API. That is the opposite of the alert's aim, because the rows are not defective. Pilot #1321 (migration `20261118270000`, md5-guarded in-place edits) changes two things instead:
1. `security.aer_current_findings_v1`: a row also counts as admitted when an approved entry-matrix item names its run. A row that no approval names is still a P0 finding.
2. `public.svc_entry_matrix_record`: a run a person approved is never recorded again (`already_decided`), so a new reading opens a new run.

The five pending change items stay for a person or rule `aer-matrix-machine-v1`; they hold the qualification rows the re-record proposed.

**Read-back:** rolled-back dry run, then live after the 23:27 AEDT `aer-reconcile` run: offending rows 0 (provider tables and course reads); findings 1516 to 1520 resolved ("no offending active row"); 0 P0 findings open; Platform health issue `aer:p0` resolved at 23:27:00 AEDT.

## 5. Open items

1. **AER v2 qualification is still blocked after round 5.** These are measured facts, not decisions taken:
   - Mistral now meets the error-point limit but not quote fidelity or false positives.
   - The every-row prompt section raised neither recall nor fidelity.
   - The cap has US$0.47 left.
2. **Thursday 02:45:** read-only check that the 90 would-admit course reads were admitted (scheduled into this session).
3. **The five `entry_matrix_change` items** wait in Layer 4 for a person: qualification rows of the 11 Nov re-record.
