# Standing execution rules 9–10 and tonight's merges (decision record and response)

Platform Admin, 25 Oct 2026, 23:16 AEDT. CF-247.

## Rules as given (standing, every mandate)

1. **"MERGE YOUR OWN PRs."** A PR merges when:
   - the full suite is green;
   - the migration md5 has been verified against live;
   - a live dry run has passed, where applicable;
   - the change-control entries are written.

   Then: merge, deploy, confirm the live version string, and record the merge in the mandate file. The Platform Admin's review is retrospective, from the repo files. **Exception, unchanged:** destructive changes and consumer-API shape changes come as paste files and are never auto-merged.
2. **"LODGE EVERY RESPONSE IN THE ADMIN REPO."** The full response is written as a dated md in the right `docs/platform` folder before the chat reply. The chat reply is a pointer: the file path plus a three-line summary.

**Recorded:** `docs/platform/AGENT-OPERATING-MODEL.md` rules 9 and 10 (commit `abf35502`).

**Reading applied:** "full suite green" means no failures other than the named legacy ones (cf-091 and cf-103, desktop and mobile, failing on `main` since before CF-247). Any other failure blocks the merge.

## Merges under rule 9 (23:16–23:21)

| PR | Gates checked | Merge | Live confirmation |
|---|---|---|---|
| **#694 gate consolidation** (v2.15.352) | Suite 1,912 passed (4 legacy). Live md5 of all 8 edited functions = the guards (23:17). Live dry run passed (18:55; again as the base of SP-1's dry run). Change control written (19:05, 23:30) | `c478404e` (squash) | deploy-on-merge: `20261025002000` applied, history md5 `31410a56` matches the file. Release currentness on the deployed site passed. Post-merge md5: gate `6c23c9b7…`, AI-match prepare `049a7cab…` |
| **#696 SP-1** (v2.15.353) | Rebased on main after #694 (the base commit dropped; diff = SP-1 only). Suite 1,910 passed (4 legacy; 4 older contract tests updated to the renamed spend-check calls, 178 of 178 on re-run). Live md5 of all 8 edited functions = the guards (23:18). Live dry run on top of #694 passed. Change control written (23:30) | `859d2a7a` (squash) | deploy-on-merge: `20261025003000` applied, history md5 `5682b675` matches the file; coverage-sweep redeployed (version 206, 23:19:59). Release currentness passed. **The worker answers `coverage-sweep-worker-v0.47.0`** (23:20:57), and the Firecrawl panel shows its first named refusals: **20 `target_list_refused` in the first minute**, previously recorded as nothing |

**After SP-1, state is as designed:**
- `bind.no_page_on` = 0: proposals off; switching it on is the Platform Admin's step.
- Job `no-page-propose` scheduled hourly at :37 (scope refresh only while off).
- AI match scope live for Australian providers.
- `PIPELINE-LINEAGE.md` sections 2–4 updated in this commit (doc-as-code).

**Not merged tonight: #695 (Track C step A).** The Platform Admin's 18:54 instruction for Track C was "TONIGHT … NO merge", so the specific instruction stands for tonight. On 26 Oct it is rebased on SP-1:
- new md5 for `layer4_review_decide_impl` and `layer4_review_desk_v1_impl`;
- worker v0.48.0;
- migration timestamp after `20261025003000`.

It is then dry-run, suite-checked and merged under rule 9 (its reader stays off until Track B release 1). If you want it merged tonight instead, say so and it goes through the same gates.

## Rule 10 from here

Every response from 23:16 on is lodged before the reply; this file is the first under the rule. Tonight's earlier records (overnight outcomes, speed reconfiguration, Track C) were already in the repo.

## Activation (Platform Admin 23:24 "ACTIVATE NOW")

| # | Instruction | Done |
|---|---|---|
| 1 | Merge #694, then #696, under the new rule, with merge records | Already done at 23:17 / 23:21 (above), in that order. The suite state you accepted matches the gates applied |
| 2 | After #696: `bind.no_page_on` = 1 (logged) | **23:27**, `admin_toolsets_write` as the Platform Admin, reason logged in `admin_control_events`. The first run of `no-page-propose` is at 23:37 (hourly at :37); result below |
| 3 | Leave `bind.match_scope_top_n` at its default | Left at 100; the AU AI match scope is live (AI only) |
| 4 | Tranche 2 Part A: applied by the Platform Admin now; verify at 00:30 | Verification at the 00:30 checkpoint: 7 override rows, the 7 colleges included in the target cache, 18 fee pages re-queued and then fetched |

Carried to 08:00 (no action now):
- the ~60 matching-miss titles at the 8 NZ universities;
- Tranche 2 Part B from Monday's worst-named list;
- O8 / O9 from the Platform Admin.

### First run of `no-page-propose` (23:37, verified 23:39)

- The job succeeded and opened **10 Layer 4 first runs** (cap 10), universities first:
  - 9 "no page published": Newcastle, UTS, VU, Victoria University of Wellington, UNSW, Lincoln, RMIT, Auckland, Monash;
  - 1 conjoint rule: Waikato, 111 conjoint courses.
- Course rows: 45 no-page sample courses (5 per provider) and 111 conjoint courses, all `proposed`. **Nothing is recorded or held from search until a person decides**, and nothing is published by this lane.
- AI match scope: 104 Australian providers.
- The next 10 first runs open at 00:37, universities first (Otago, Massey, Canterbury, AUT and the remaining AU universities come next).

**For the Platform Admin:** each first run is in Layer 4 (task "No Page First Run" / "Conjoint Rule First Run") with its 5 sample courses and the provider's inventory size:
- approve if none of the samples has its own page;
- otherwise edit and approve with `{"has_page_course_ids": [...]}`.

At 60% confirmed, the provider is trusted.

## Merge under rule 9, 26 Oct 2026 (Platform Admin decision 08:25)

| PR | Gates checked | Merge | Live confirmation |
|---|---|---|---|
| **#698 SP-2a** (v2.15.356) | Suite 1,948 passed (4 legacy: cf-091, cf-103). No existing function edited; the one it calls (`no_page_review_apply_v1`) verified unchanged at `55c019a7…` before merge. Live dry run passed (0 before approval; 5 auto-admitted after one simulated approval; 30 s). Change control written (26 Oct 09:00) | `5aa3ede2` (squash) | deploy-on-merge: `20261026002000` applied, history md5 `a6259617` matches the file. Release currentness passed. Live bodies of `no_page_auto_admit_v1`, `course_list_check_v1` and `no_page_sample_check_v1` match the file byte for byte. 8 settings (on 1, audit 1 in 10), job `layer4-auto-admit` at :47, catalogued. First run by hand: 0 auto, 16 new-shape, 26 list not verified, 10 sample not confirmed, 8 no list |
| **#699 test governance** (no release; tests, config, `CLAUDE.md`) | Full suite 990 passed, 0 skipped, 0 failed: the first merge with no carve-out. No live function edited; no migration (no dry run applies). Change control written (26 Oct 11:00) | `f5bc071c` (squash) | Post-merge workflows succeeded (release currentness, release history, runtime health, deployed UAT, frontend build). `deploy-on-merge` correctly did not run (no migration or function) |
| **#702 hotfix v2.15.357** (Layer 4 first runs under their university) | Full suite 997 passed, 0 skipped, 0 failed. Live md5 of the three edited functions matched the guards just before the merge. Live dry run passed. Change control written (26 Oct 13:20) | `a3e295cf` (squash) | `deploy-on-merge`: `20261026003000` applied, history md5 `4150d640` matches the file. Release currentness passed (v2.15.357). The new blocks are live byte for byte; all 60 first runs carry their university |
| **#703 v2.15.358** (AU week step 1: CRICOS end dates; read-only AU publish eligibility) | Full suite 1,001 passed, 0 skipped, 0 failed. No existing function edited; new objects confirmed absent live just before the merge. Live dry run passed twice (second run idempotent). Change control written (26 Oct 17:3x) | `3e31bacd` (squash) | `deploy-on-merge`: `20261026004000` applied, history md5 `c9bdaeb0` matches the file. Release currentness passed (v2.15.358). Both function bodies live byte for byte; first run: 1,372 course end dates, 16 provider registrations ended, 0 inconsistencies |
| **#704** (AU week step 6: entry-matrix reader staged for the AU top 20, off; no release) | Full suite 1,003 passed, 0 skipped, 0 failed. Live md5 of `entry_matrix_enabled_v1` `a238a2c2…` matched the guard just before merge. Live dry run passed (switch simulated on: 20 enabled, NZ 0). Change control written (26 Oct 18:4x) | `7a6f73cd` (squash) | `deploy-on-merge`: `20261026005000` applied, history md5 `59df4a0c` matches the file. Edit live; 20 listed, 0 enabled, job inactive |
| **#705 v2.15.359 hotfix** (tuition identity gate at the table for every fee writer) | Full suite 1,005 passed, 0 skipped, 0 failed. Live md5 of `adapter_overwrite_v1` `c96ca02c…` matched the guard just before merge. Live dry run passed. Change control written (26 Oct 19:45) | `054cfcda` (squash) | `deploy-on-merge`: `20261026006000` applied, history md5 `d3ab7249` matches the file. Release currentness passed (v2.15.359). Trigger body and adapter edit live byte for byte |
| **#706** (AER v1.1 schema: six additive columns, three indexes, row identity; no release) | Full suite passed. Additive only (Platform Admin 21:50 "Schema approved"). Live dry run passed. Change control written 26 Oct 22:3x, after the merge (late against rule 9) | `0dc6086d` (squash) | `deploy-on-merge`: `20261026007000` applied, history md5 `c4efbc41` matches the file. Live 31 → 37 columns, 3 indexes, trigger |
| **#707** (AER v1.1: entry reader reads table rows whole; admin re-read; worker v0.48.1; no release) | Full suite 1,012 passed, 0 skipped, 0 failed. No existing function edited. Live dry run passed (2 runs re-queued, 8 rows and 1 item superseded, previous result kept; rolled back). Change control written 26 Oct 22:3x, straight after the merge (late against rule 9) | `b0a0e0a9` (squash) | `deploy-on-merge`: `20261026008000` applied, history md5 `bff1c614` matches the file. Worker version 208: `index.ts` and `entry.ts` live byte for byte. Reader still off |
| **#708** (AER v1.1 RMIT benchmark-band fix; worker v0.48.2; no release) | Full suite 1,017 passed, 0 skipped, 0 failed. Live md5 of `entry_matrix_review_apply_v1` `e3f02aaa…` and `entry_matrix_identity_tg` `86ddafc3…` matched the guards just before the merge. Live dry run passed (unsafe Bangladesh approval refused; 11 rows → 11 identities). Change control written 26 Oct 23:05, before the merge (merged 23:06:42) | `832b5717` (squash) | `deploy-on-merge`: `20261026009000` applied, history md5 `8dd0ceba` matches the file. Both edited functions live byte for byte; worker version 209 byte for byte. RMIT acceptance live: 68 rows, 68 identities |
| **#709** (AER v1.1 source-anchored completeness guard; worker v0.48.3; no release) | Full suite 1,024 passed, 0 skipped, 0 failed. Live md5s of `svc_entry_matrix_next` `4b5a59da…`, `svc_entry_matrix_record` `d80183c6…` and `entry_matrix_review_apply_v1` `76cce959…` matched the guards just before the merge. Live dry run passed. Change control written 26 Oct 23:35, before the merge (merged 23:36:33) | `e15166bc` (squash) | `deploy-on-merge`: `20261026010000` applied, history md5 `7b712633` matches the file. Edited functions verified byte for byte by reverting the edits; worker version 210 byte for byte. Release currentness run by hand on `e15166bc`: passed. RMIT acceptance under the guard: 68 of 68 published rows, all complete |
| **#710** (AER v1.1 completeness guard at admission; no release) | Full suite 1,025 passed, 0 skipped, 0 failed. Live md5 of `entry_matrix_review_apply_v1` `9386a7be…` matched the guard just before the merge. Live dry run passed. Change control written 27 Oct 00:02, before the merge (merged 00:03:50) | `cb062640` (squash) | `deploy-on-merge`: `20261026011000` applied, history md5 `9cee3b80` matches the file. Edit verified byte for byte by reverting it. Release currentness run by hand on `cb062640`: passed. Live rolled-back tests: column excluded or removed → refused; whole read → 22 active |
| **#711** (AER v1.1 RMIT D1–D3; worker v0.48.4; no release) | Full suite 1,032 passed, 0 skipped, 0 failed. Live md5 of `admin_entry_matrix_reread` `cec71585…` matched the guard just before the merge; the other entry-matrix functions were unchanged since #710. Live dry run passed. Change control written 27 Oct 05:15, before the merge (merged 05:24:24) | `de31e8c1` (squash) | `deploy-on-merge`: `20261027001000` applied, history md5 `7328012c` matches the file. Re-read edit verified by reverting it; new function body byte for byte. Worker version 211, all 17 files byte for byte. Release currentness run by hand on `de31e8c1`: passed. D1 (Hong Kong 11/11) and D2 (3 pages held terminally before any AI read) proven live; D5 found |
