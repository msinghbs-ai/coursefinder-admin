# PR #875 AER selector fix: readiness against current production

Validator: agent E (independent validation). Decision 19:14 §8 (Platform Admin, 5 Nov 2026).

- **Branch:** `cf247-aer-selector-fix`, head `9205087d`, based on v2.15.475 (`06585fb4`). Inspected read-only; the branch was not modified.
- **Production:** `fxcwkweaxjtknorudmwp`. Light catalogue reads only, 19:19–19:44 AEDT on 5 Nov 2026, outside the forbidden minutes.

**Verdict: needs rebase** (renumber the migration and refresh its fixture). The functions it edits are unchanged in production and its edits apply cleanly. Its migration version would be applied out of order, and its own fixture no longer reproduces the defect it fixes.

## What it changes

Migration `20261104620000_cf247_aer_selector_fix.sql` makes three md5-guarded edits and one row update.

1. **`security.aer_recovery_rule_v1(uuid)`.** A row-limit cut counts as `changed_conditions` only when a row limit that applies to it changed after its last read.
2. **`security.aer_schedule_held_v1(integer)`.** Items the rule made eligible are scanned first.
3. **`security.progress_measure_v1(text,timestamptz)`**, branch `aer_technical_correction`. The measure counts corrected reads.
4. **One row.** `pipeline.progress_transitions` key `aer_technical_correction` gets producer `{aer-scheduled-read}` (was `{work-continuity}`).

Fixture files: `tests/fixtures/aer-selector-fix/` (`run.sh`, `seed.sql`, `stubs.sql`, `fixtures.sql`). No spec, workflow, UI or consumer API file is changed.

## Checks

### 1. The md5s it guards still match production

| Function | md5 the migration requires before | Live md5, 5 Nov 2026 19:19 AEDT | Result |
|---|---|---|---|
| `security.aer_recovery_rule_v1(uuid)` | `b194475a46186bc674a3364816a8b06b` | `b194475a46186bc674a3364816a8b06b` | match |
| `security.aer_schedule_held_v1(integer)` | `c866167b55d2494c366fd2700a518ff8` | `c866167b55d2494c366fd2700a518ff8` | match |
| `security.progress_measure_v1(text,timestamp with time zone)` | `40c0c972abc353be8f6eee35c79750e9` | `40c0c972abc353be8f6eee35c79750e9` | match |
| `security.course_entry_max_rows_v1(uuid)` (precondition) | present; fixture expects `8d3555d998355422a1309dda0fbb0fc8` | `8d3555d998355422a1309dda0fbb0fc8` | match |
| `security.aer_technical_recovery_v1()` (called by the fixture) | `08322eb59fc9081ed7a684bddcfc6b64` | `08322eb59fc9081ed7a684bddcfc6b64` | match |

- **Production row:** `pipeline.progress_transitions` key `aer_technical_correction` still has producer `{work-continuity}`, so the row update would apply.
- **Columns the new definitions read:** all exist with the types used.
  - `pipeline.aer_read_supersessions`: `requested_at`, `closed_at`, `state`, `outcome`, `new_item_id`.
  - `pipeline.work_items`: `unresolved_blocker` (jsonb), `failure_class`, `entity`, `work_kind`.
  - `pipeline.aer_schedule_runs`: `refusal`, `ran_at`.
  - `pipeline.platform_toolset_settings`: `value` (jsonb), `updated_at`.
- **Main since the base:** no migration from v2.15.476 to v2.15.485 touches the three functions. Their live md5s equal the md5s guarded on 4 Nov.

### 2. Migration version: sorts, but out of order

- **No collision.** `20261104620000` is not in production's migration history and no file on main uses it.
- **Out of order.** The version sorts before nine versions already applied in production: `20261104630000`, `20261104640000`, `20261105000000`, `20261105010000`, `20261105020000`, `20261105040000`, `20261105060000`, `20261105070000`, `20261105080000` and `20261105090000`. The latest applied is `20261105090000`, v2.15.485.
- **Deploy behaviour.** `deploy-on-merge.yml` applies each added file in name order through `scripts/ci/apply-migration.sh`. That script has no ordering check, so the file would apply, but the history would hold a version older than the releases before it. A fresh rebuild from the files (`db-baseline-rebuild-test`) would then run it before the intake migrations. That rebuild is harmless here, because none of those later migrations touch these functions or this row. It still breaks the rule that the history follows release order.
- **Required:** renumber to a version after `20261105090000`. The Integration Controller assigns it; agent ranges `20261106100000`–`20261106499999` are reserved, so the Controller should pick one outside them. Rebase on main.

### 3. It applies cleanly after `20261105090000`

- **Method.** I ran the branch's own fixture on an extracted copy of the branch (`git archive`; local PostgreSQL 16, database `e_pr875`, kept). Its setup loads the live definitions and confirms all five md5s above.
- **Applied once.** `security.aer_recovery_rule_v1(uuid)`, `security.aer_schedule_held_v1(integer)` and `security.progress_measure_v1(...)` were each applied. The producer row was updated (`UPDATE 1`).
- **After md5s.** `605cba4a9b49d1cfebee8ada5414b561`, `483fbcead73c7996d02c372fd6128108` and `4f10e10e25c30f35f05f7ba1bbb2a4d8`, exactly as the migration states.
- **Applied again.** All three were already applied and `UPDATE 0`, so the migration is idempotent.
- **Content.** The edited text is matched against the live definition by md5, so its position in the sequence does not affect it. Nothing between v2.15.475 and v2.15.485 touches these functions or this row. Applying the renumbered migration after `20261105090000` is therefore content-identical to applying it at its original point.

### 4. Its own fixture no longer reproduces the defect

The branch's `tests/fixtures/aer-selector-fix/run.sh` fails today at its "before" step:

```
ERROR before: expected the row-limit cuts classed changed_conditions (production 109), found 0
```

- **Cause.** `seed.sql` pins the entry settings' `updated_at` to fixed dates (3 Nov 2026 09:07 UTC). The earlier fixture creates the items relative to `now()`. On 4 Nov the settings were newer than the items; on 5 Nov they are older, so the defect no longer appears. The fixture is date-dependent and will keep failing.
- **Not in CI.** The fixture is not run by any workflow (no workflow file is changed), so CI would not show this.
- **Required:** anchor the seed times relative to `now()`, or the item times to the fixed dates. Re-run the before and after parts. Add the fixture to a workflow, so a red fixture cannot pass silently.

### 5. Its fixture tables are simplified

- **Method.** The new parity tool compared the fixture database with production (Pilot PR for the tool, manifest `intake-lessons-admin-jobs-manual-locks.json`, part `pipeline.progress_transitions`).
- **Missing in the fixture.**
  - 20 of the 26 production columns of `pipeline.progress_transitions`.
  - The checks `progress_transitions_chain_check`, `progress_transitions_key_check` and `progress_transitions_zero_reason_check`.
  - The foreign key `progress_transitions_issue_id_fkey` to `pipeline.integration_issues`.
  - RLS enablement.
  - Production's role time-outs (`anon` 3 s, `authenticator` lock 8 s).
- **Impact.** Low for this migration, which only updates `producer_jobs` on an existing row. It is the same kind of gap that let the intake releases pass, so the fixture should be rebuilt from the manifest: `node scripts/prod-parity-capture.mjs fixture …`.

### 6. Other required checks

| Check | Result |
|---|---|
| Governed suite and skips | No spec or test is added or changed, so there is nothing new to skip. The branch has not had a full CI run against current main. It needs one after the rebase. |
| Bounded performance | Edit 2 adds a correlated subquery on `pipeline.work_items` to the held step's `ORDER BY` (lane, entity, kind, failure class, stage; `limit 1`). It runs once per waiting item scanned, and the scan is bounded by the step's own limit. I did not run `EXPLAIN` on production; that is a heavy read and needs a :x6–:x8 window. **Required:** run `EXPLAIN (ANALYZE, BUFFERS)` of `security.aer_schedule_held_v1(40)` in a heavy-read window, or on a fixture at production scale, before release. |
| Budget and role protection | No cap, spending limit, setting, job, enqueue or grant changes. The three functions keep their signatures, so their grants are unchanged. |
| Admission rules | No admission authority or gate changes. The rule only reclassifies row-limit cuts that cannot be read usefully again. |
| Consumer API | None of its objects is touched (consumer API check below: no drift). |
| Housekeeping | Has `-- Replaces:` and `-- Retires: nothing`. Drops nothing. |
| G1 | The new producer `aer-scheduled-read` is catalogued in `pipeline.automation_catalogue` ("Entry requirements: scheduled reading", hourly at :13), read 19:44 AEDT. |
| G2 | No operational number is added. The row limit is still read from `entry.max_rows_per_course` / `entry.max_rows_by_provider`. |

## Forward recovery (if released and wrong)

The migration records its before and after md5s. To recover forward:

1. Issue a new migration that restores the three before-definitions (`b194475a…`, `c866167b…`, `40c0c972…`), with each `CREATE OR REPLACE` md5-guarded on the after-md5s above.
2. Set the producer row back to `{work-continuity}`.

No data is written by this change except the producer row, so nothing else needs repair.

## Required action

1. Renumber the migration after `20261105090000`. The Integration Controller assigns the version.
2. Rebase on main.
3. Fix the date-dependent seed.
4. Wire the fixture into CI and rebuild its `progress_transitions` stub from the production manifest.
5. Run the held-step plan in a heavy-read window.
6. Then run the full governed CI and release through the normal gate.
