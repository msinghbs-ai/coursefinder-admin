# PR #889 Intake Automation Progress: independent pre-release validation

Validator: agent E. Decision 19:14 §8 (Platform Admin, 5 Nov 2026).

- **Branch:** `cf247-intake-progress-ui`, head `1a5f60ce`, base `cf77ef78` (v2.15.485). Migration `20261106400000_cf247_intake_automation_progress.sql`. Inspected read-only; the branch was not modified.
- **Production:** `fxcwkweaxjtknorudmwp`, read only (SELECT; no SET, no set_config).
  - Light catalogue reads between 20:43 and 21:00 AEDT.
  - One measure read at 20:56, a heavy-read minute (188 ms).
  - The parity check ran at 20:49.
- **Fixture:** run in my own database `e_pr889`, from an extracted copy of the branch.

**Verdict: ready with conditions.** The guarded md5s are live, and the existing chains are unchanged. The fixture tables match production apart from four production indexes. The exception block is sound. The conditions are:

1. The Controller and Platform Admin must expect one new P2 issue on the first reading. The release note does not mention it.
2. The changes to the self-sustainability totals need to be acknowledged.
3. The migration needs a `lock_timeout` and a deploy window.
4. Forward recovery must be written down.
5. #875 must be re-guarded on this change's result.

## (a) Guarded md5s are still live

Read 5 Nov 2026 20:43 AEDT.

| Function | Guard in the migration | Live | Result |
|---|---|---|---|
| `security.progress_measure_v1(text,timestamptz)` (edited) | `40c0c972abc353be8f6eee35c79750e9` | `40c0c972abc353be8f6eee35c79750e9` | match |
| `security.progress_read_v1()` (edited) | `f11ed22d149eb06aa10387e67467ec6f` | `f11ed22d149eb06aa10387e67467ec6f` | match |
| `security.intake_ui_scopes_v1()` | `94bae55f…` | `94bae55f4ecfeca5957f17a0327ba660` | match |
| `security.integration_issue_upsert_v1(jsonb,text)` | `f9d7bf1a…` | `f9d7bf1a6dbe94ba97c34f10817f56c1` | match |
| `security.admin_automation_control_v1(text,text,jsonb)` | `431aff60…` | `431aff603f21b8c8a030073b07a08259` | match |
| `public.admin_automation_control(text,text,jsonb)` | `b032f84e…` | `b032f84e705b926ce7026f209116111a` | match |
| `security.pipeline_num_v1(text,numeric)` | `09f9b155…` | `09f9b1551daf42b4a0c9795e6f30c6d4` | match |
| `security.current_role_rank()` | `d709d92d…` | `d709d92dbd7a648ccf78e594d68ca980` | match |
| `security.progress_zero_reason_v1(text,jsonb)` | `746d7bae…` | `746d7baedb0a79dc0a6fbfead82f67c2` | match |
| `security.toolset_setting(text,text)` (fixture only) | `678dbbc4…` | `678dbbc416c5188ab99b3526e68b0c4d` | match |

Other production state:

- The latest applied migration is `20261105090000`, so `20261106400000` sorts after it and collides with nothing.
- `progress_transitions_chain_check` is still `chain = ANY (ARRAY['scholarship','aer'])`.
- There are 16 transitions: 7 for AER and 9 for scholarships.

**After the migration (fixture):**

- `progress_measure_v1` = `e758d1c2d36f8f523c3fdbcc1b9dff2f`.
- `progress_read_v1` = `ad49a4f3a87c50101abb685be4d4d728`.
- Applying the migration a second time changes nothing.
- No `cron.job` row is added or changed.

## (b) Fixture tables against production (parity tool)

**Method:**

1. I captured a manifest of the fixture database after the migration (`pipeline.progress_transitions`, `progress_observations`, `integration_issues`, `course_intake_date_events`, their trigger functions and dependencies; 168 facts).
2. I ran the parity tool's compact check of that manifest against production (`check-sql --compact`, one read-only SELECT, 20:49 AEDT).
3. Production returned 11 differing facts, classified below.

| Fact | Kind | Meaning |
|---|---|---|
| `constraint progress_transitions_chain_check` | different | **Expected:** the migration widens the check to include `intake`. |
| `index course_intake_date_events_run_idx` | missing in production | **Expected:** the migration creates it. |
| `index integration_issues_aer_ref_uq` (**unique**) | in production only | **Fixture gap.** Not in the fixture. |
| `index integration_issues_correlation_idx`, `integration_issues_next_action_idx` | in production only | **Fixture gap** (performance only). |
| `index progress_observations_key_at_idx` | in production only | **Fixture gap.** The observations view's benchmark runs without the production index, so production should be as fast or faster. |
| `execute security.intake_failure_class_trg_v1()` | different | Production grants EXECUTE on this trigger function; the fixture grants it to nobody. It has no effect on trigger firing. |
| `role authenticator`, `schema pipeline/security USAGE service_role`, `session search_path` | different | Environment of the local fixture, not table shape. |

**Matching facts:** every column (type, nullability, default), every check, primary key, unique key and foreign key, the triggers (`intake_failure_class`, `ops_guard_issue`), RLS enablement, and the trigger function md5s.

**Impact:**

- The missing unique index `integration_issues_aer_ref_uq` does not affect this PR. Its issues never set `aer_root_cause_ref`.
- **Recommended, not blocking:** add the four indexes to `tests/fixtures/intake-progress/parity-tables.sql`.

## (c) Scholarship and admission-requirement observer outputs are unchanged

**Structural check:** I removed the inserted intake block from the new `progress_measure_v1`. The remainder hashes to `40c0c972abc353be8f6eee35c79750e9`, exactly the live definition. Every existing branch is therefore byte for byte unchanged.

**The PR's own regression, rerun in `e_pr889`:**

- **PASS:** all 19 existing measure keys give identical output before and after (md5 `d1b0640d…`).
- **PASS:** the observer's readings of the scholarship and AER chains are identical: transitions, observations, stall issues, layer and workstream.

**One existing measure does change.** `first_run_verify` reads all transitions, so its `eligible` count rises from 16 to 19. It is the job-output contract of `first-run-verify` itself, not a scholarship or AER transition.

**Observer edit:** only the `intake` chain gets a different layer (`Layer 2`) and workstream (`A8`). The scholarship and AER layer and workstream expressions are unchanged.

## (d) Side effect on `security.self_sustainability_v1`

`self_sustainability_v1(integer)` (live `1965a719…`) aggregates over all of `pipeline.progress_transitions`. With three intake rows added:

| Output | Effect |
|---|---|
| `transitions` | Gains `intake_selection`, `intake_admission` and `intake_publication`. |
| `queue_continuity.stalled_transitions` | Counts intake stalls. A stalled intake transition turns this measure `not_met`. |
| `unattended_operation` | Three inputs now include intake: `v_created` (summed created), `v_technical` (count of `technical_failure` zeros) and `v_noelig`. An intake technical zero turns it `not_met`. Intake output can turn `eligible_data_processed` true. |
| `scheduled_job_reliability.justified_idle_transitions` | Counts justified intake zeros. |
| `source_to_admission_yield`, `admission_to_publication_yield` | Unchanged. They read the named scholarship and AER keys only. |

**Who depends on these totals (live callers):**

- **Only caller:** `security.ops_report_v1`. It is called by `security.ops_controller_tick_v1`, which writes hourly and daily `pipeline.ops_checkpoints` reports, and it is referenced by `ops_cost_report_v1`.
- **No alerting:** no `cron.job` command reads `self_sustainability_v1` or `ops_report_v1` directly. The Pilot UI (`src/`) and edge functions do not read `self_sustainability` or `ops_checkpoints`. No alert or flag is raised from these verdicts. The effect is reporting only: the operations scorecard now includes intake.

**A second consumer of the transition table.** `security.release_first_run_register_v1` picks a job's transition with `j.name = any(t.producer_jobs) order by chain, step limit 1`.

- After this change, a future release that registers `intake-dates-apply` for first-run verification resolves to `intake_selection` (previously none).
- One that registers `process-results` resolves to `intake_publication`. This is arguably the intended effect, but it is new.
- No AER or scholarship job is a producer of an intake transition, so their mapping is unchanged.

**Condition:** the Controller acknowledges both changes: the scorecard and checkpoints now include intake, and the first-run mapping of the two intake jobs.

## (e) First-run behaviour in production (read-only estimate)

**Method:** the three new measures and the three intake checks, computed as plain SELECTs on current data at 20:56 AEDT. The window is the observer's `progress.window_hours` (24) and the stall limit `progress.stall_hours` (6).

| Transition | Eligible | Processed | Created | Zero reason | Stalled on first reading |
|---|---|---|---|---|---|
| `intake_selection` | 21,147 | 2,007 | 2,007 | none (created) | no |
| `intake_admission` | 2,007 | 2,007 | 26 (excluded 1,313) | none (created) | no |
| `intake_publication` | 397 | 908 | 908 | none (created) | no |

| Intake check | Today | Raised on first reading |
|---|---|---|
| publication mismatch (`consumer_publication_failed` rows) | 0 | no |
| monopoly (last 3 scheduled runs) | top provider The University of Sydney, 50 of 600 rows (8.3%; trips at ≥ 80%) | no |
| repeated deterministic failure (24 h) | **167 intake rows** | **yes**: `intake-progress:repeated-deterministic`, P2, A8, `root_cause_class = code_defect` |

- No `stall:intake%` or `intake-progress:%` issue exists today.
- **The release note (doc §7.3) is wrong about the first reading.** It predicts only `publication-mismatch` or `stall:intake_admission`. On current data neither trips, and the repeated-deterministic issue will be raised on the first `:02` or `:32` reading instead. That looks like a genuine signal: 167 rows failed deterministically again under the same calendar set and reader within a day. The issue is filed as `code_defect`.
- **Condition:** the Controller expects this issue, and owns or triages it on first reading.
- **Not a failure:** `intake_publication` shows processed (908) greater than eligible (397), because re-checks count as processed. This is a reporting oddity only.
- **Cost:** the three measures and the checks together took 188 ms in production (the PR measured 651 ms with `EXPLAIN ANALYZE` during an intake run). That is acceptable once every 30 minutes.

## (f) The exception block cannot swallow failures of the existing chains

- **Existing loop isolation.** `progress_read_v1` reads each transition in its own `begin … exception when others` block (live code). A failing transition records `measure_error` and the loop continues. This is unchanged.
- **Loop order.** The intake transitions are read inside this loop, ordered by `chain, step`, so `intake` falls between `aer` and `scholarship`. An intake measure error is recorded on its own row only.
- **The new block runs after the loop.** It wraps only `security.intake_progress_checks_v1()`, and only when intake transitions exist. Its `when others` catches only its own failures. Any `integration_issue_upsert_v1` writes it made are rolled back to its savepoint; the loop's updates, observations and stall issues stay. It cannot hide an existing chain's failure, because those happen, and are recorded, before it.
- **One caveat.** PL/pgSQL `when others` does not catch `query_canceled` (a statement timeout) or `assert_failure`. If either fired inside an intake measure or the intake checks, it would abort `progress_read_v1`, and also the rest of `first_run_verify_tick_v1`, whose own handlers are also `when others`. That would lose that tick's scholarship and AER readings. Today `postgres` has no `statement_timeout`, so this is theoretical. The reads took 188 ms.
- **Recommendation, not a condition:** if a timeout is ever set for the observer, give the intake block `set local statement_timeout` inside it, or measure intake last.

## (g) Rollback and forward recovery

The migration drops nothing. Recovery is forward only, and the PR documents none (doc §7 lists only release steps). Required:

1. **Stop the intake readings without touching the other chains.** Issue a migration that restores `progress_measure_v1` to `40c0c972…` and `progress_read_v1` to `f11ed22d…`, each guarded on `e758d1c2…` and `ad49a4f3…`.
   - With the old `progress_read_v1` and the intake rows still present, the old measure raises "no progress measure for transition" for each intake row. That is caught per transition and recorded as `measure_error`. It is noisy but harmless, and the intake rows would still count in `self_sustainability_v1`.
   - A clean removal of the three `progress_transitions` rows is a delete, so it must go to the Platform Admin as a paste file (no delete in a migration).
2. **Faster lever.** Setting `progress.on` = 0 stops all observer readings, scholarship and AER included. It is too broad except in an emergency.
3. **Issues raised by the intake checks** close through the existing controller (`condition_cleared_at`).
4. **The new read functions, settings and index** can stay: they are read only, or unused.

**Condition:** add this forward-recovery section to `docs/intake-automation-progress.md`.

## Deploy safety

- **Lock.** The migration runs `alter table pipeline.progress_transitions drop constraint …, add constraint …` (ACCESS EXCLUSIVE) and `create index … on pipeline.course_intake_date_events` (SHARE), with no `lock_timeout`.
  - `first-run-verify` (:02, :32) updates every `progress_transitions` row in one transaction.
  - `intake-dates-apply` (:26) writes `course_intake_date_events`.
  - If the ALTER waits behind a running observer, every reader of the table queues behind it.
- **Sizes.** The tables are small: 16 transition rows and about 2,000 event rows, so the hold itself is milliseconds.
- **Condition:** add `set local lock_timeout = '5s';  -- fixed: deploy-time safety` (as #887 does), and apply outside :02, :26, :32 and :53.

## (h) Conflict with held #875: documented correctly

- **The comment is correct.** The migration says #875 must be re-guarded on this change's result, and the doc (line 94) says whichever lands second must be re-guarded.
- **The guard works.** The fixture proves the migration refuses a `progress_measure_v1` that is not `40c0c972`.
- **#875's text still applies on top of this change.** I ran #875's own `edit_once` edit of `progress_measure_v1` on the fixture after #889 (before-md5 replaced by the current one). Both text edits applied exactly once. The result was `b5fc7aae44039565dc85644352f0c719`, not #875's stated `4f10e10e…`, so #875 failed its own after-check, as expected.
- **Required for #875 if #889 lands first:** before `e758d1c2d36f8f523c3fdbcc1b9dff2f`, after `b5fc7aae44039565dc85644352f0c719`. This holds only for this exact #889 build. I added it to the #875 readiness report.

## Other gates

| Check | Result |
|---|---|
| CI on `1a5f60ce` | Workers Builds, build-and-smoke and isolated-postgres (two runs): success |
| Local governed specs on the branch copy | s32, s42, s57, s120 and s340: 21 passed |
| Consumer API (G3) | s57 passes. No consumer function, table or edge function is touched. The new reads use `course_intake_dates.publication_state`, not consumer objects. |
| G2 | Six settings, each with label, range, unit and `used_by`. Code values are marked `-- fixed:` (cron hour arithmetic, the decision's named windows). |
| Housekeeping | `-- Replaces:` and `-- Retires: nothing` are present. No drop. No new job. |
| Budget and role protection | No spend path. The reads require rank 3. Pause and Resume use the existing `admin_automation_control`; the fixture covers role checks for ranks 2, 3, 4 and 5. |

## Conditions

1. **First-reading issue.** Expect `intake-progress:repeated-deterministic` (167 rows) on the first observer reading. Triage it; do not treat it as a release regression.
2. **Totals and mapping.** Acknowledge the `self_sustainability_v1` and `ops_checkpoints` total changes, and the first-run mapping of `intake-dates-apply` and `process-results` to intake transitions.
3. **Deploy lock.** Add `lock_timeout` and apply outside :02, :26, :32 and :53.
4. **Recovery doc.** Add the forward-recovery section above.
5. **Release order with #875.** Release #889 before #875, or re-guard whichever is second. The values are given in (h).
6. **Recommended, not blocking:** add the four production indexes to the fixture.
