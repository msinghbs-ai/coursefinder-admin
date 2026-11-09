# Implementation specification: bulk Read again targets only the newest stored copy

Lane I, Workstream 5 (lodged 30 Oct 2026; decision paper A5). This is a specification only. Nothing was implemented, deployed or dry-run. All live facts below come from read-only SELECTs on `fxcwkweaxjtknorudmwp`.

## 1. Why this is needed

- **W28** changed `security.aer_reread_v1` (live md5 `ad0fbd3563ed483160dd645e08796bd5`) so the single-source Read again re-queues only the run on the source's current stored copy. The run is chosen by:

  `order by (content_hash is not distinct from v_src.content_hash) desc, created_at desc, id desc limit 1`

  Runs on older copies are not re-queued. Their still-proposed rows and still-pending Layer 4 item are closed as `superseded`. Decided items are left alone.
- **The bulk function `public.admin_entry_matrix_reread(uuid[], text)` is unchanged** (live md5 `ca394b60216ef06dfc2ce9db265e8efe`). It loops over every `done` or `failed` run of each given source and re-queues all of them, including runs on older copies. A bulk re-read of a source with two copies therefore asks the AI twice, once for a copy that is no longer current. It can also leave two current review items for one source, which is exactly what the W28 mandate forbids.
- **Live exposure:** 13 of the 99 sources have more than one run, and all 13 have older-copy runs in `done` or `failed` that the bulk function would re-queue. One older-copy Layer 4 item is still pending (the Otago Polytechnic `f14ae480` case that W28 left for the reviewer).
- **Callers:**
  - No frontend code (`src/`) and no edge function calls the bulk function. W28 removed its only database caller (`aer_reread_v1`).
  - It is reached only by a Platform Admin through SQL or RPC (role rank 6 or above).
  - It is also the documented route for re-reading `held_unparsed` runs after a reader change: `aer_reread_v1` refuses those runs.

## 2. Required behaviour (W28 rules, bulk form)

For each distinct source in `p_source_ids`, processed in ascending id order so that locks are always taken in the same order:

1. **Lock the source row** (`for update`). An unknown id is skipped and reported as `not_found`. It does not raise, so one bad id does not stop the batch.
2. **Select the newest-copy run** with the same expression as W28, copied verbatim:

   `order by (content_hash is not distinct from v_src.content_hash) desc, created_at desc, id desc limit 1`

   - If there is no run, skip with `never_read`.
   - If the newest run is `queued` or `leased`, skip with `already_waiting`. Its older runs are not touched either.
3. **Close older copies, as W28 does:**
   - Set `proposed` rows on runs other than the newest to `superseded`, but only where that run's item is null or `pending`. Use `status_reason = 'older stored copy; read again on the newest copy: ' || reason`.
   - Set those runs' `pending` Layer 4 items to `superseded`.
   - Do not change the older runs themselves (state, result, `previous_results`, `review_item_id`) and do not re-queue them.
4. **Re-read the newest run only, and only when it is `done` or `failed`.** Use exactly today's bulk steps:
   - supersede its proposed rows first, then its pending item;
   - append to `previous_results` with the same keys as today (D3: `state`, `error`, `attempts_used`, `earlier_index`);
   - re-queue the run.

   `failed` runs, including `held_unparsed`, stay re-readable here. That is the bulk function's purpose after a reader change, and it differs from `aer_reread_v1` on purpose.
5. **Unchanged:**
   - the role check (Platform Admin), the reason of 5 characters or more, and the non-empty array check;
   - no scope or AI-limit check is added, as today;
   - the markdown-copy refetch is not added (that stays a single-source action).
6. **One event** in `pipeline.admin_control_events` (`entry_matrix`, `reread`), as today. Add only these to `detail`:
   - `runs` (the ids re-queued);
   - `older_rows_superseded` and `older_items_superseded`;
   - `skipped` (`[{source, why}]`).
7. **Return value is additive.** Keep `ok`, `runs` (count), `rows_superseded` (all rows) and `items_superseded` (all items). Add `older_items_superseded` and `skipped`. This function is not part of the consumer API (G3), and no key is renamed or removed.

No new status, setting, table or job is added. Nothing is dropped.

## 3. Migration shape (`2026103xxxxxxx_cf247_aer_bulk_reread_newest_copy.sql`)

- **Header:**
  - `-- Replaces: public.admin_entry_matrix_reread (same name and signature, md5-guarded replacement)`
  - `-- Retires: nothing`
  - a decision reference (W3x, Platform Admin approval of the bulk question that W28 left open).
- **Guard:** `pg_temp.edit_n`, or a whole-body replacement guarded by `md5(pg_get_functiondef('public.admin_entry_matrix_reread(uuid[],text)'::regprocedure)) = 'ca394b60216ef06dfc2ce9db265e8efe'`. Re-read the md5 just before the merge (AGENT-OPERATING-MODEL rule).
- **Grants:** keep the existing grants (`grant execute … to authenticated`, which s127 asserts).
- **Post-check:** the new definition contains the W28 ordering string. A `do` block asserts that the pin was updated (section 4).

## 4. The md5 pin in `security.governed_aer_close_snapshot_v1`

**How it pins today:**
- The snapshot (live md5 `55910cb4111d48c54f48add915993923`, from migration 20261027003000) holds a constant `c_md5` jsonb. That jsonb maps six entry-reading functions to their md5 "as they were when the recovery ran". It includes `"public.admin_entry_matrix_reread(uuid[],text)": "ca394b60216ef06dfc2ce9db265e8efe"`.
- At call time it computes `md5(pg_get_functiondef(k::regprocedure))` for each key and adds the check "The entry-reading functions are unchanged since the recovery ran" (`ok = v_md5 = c_md5`).
- `public.admin_governed_action` (`aer_pr_a_recovery_close`) uses the snapshot on `read` and `preview`. `preview.ok` requires `snapshot.ok`, and the action hash is `md5(snapshot::text)`.

**Live state now (read-only):**
- The governed action already ran once, `done` on 27 Oct 2026 11:46 UTC.
- The snapshot already returns `ok = false`. Three of the six pinned functions have changed since (`entry_matrix_fire_v1`, `svc_entry_matrix_next`, `svc_entry_matrix_record`).
- The scope check also fails: `entry.providers` now lists 33 providers, not 3.
- So the pin is a historical record. Changing the bulk function would only add a fourth mismatch.

**How the pin is updated under change control (Platform Admin decides which option; the default is option A):**

- **Option A (recommended): retire the drift check for the completed action and leave the history untouched.** In the same migration as the bulk change:
  - make an md5-guarded edit of `security.governed_aer_close_snapshot_v1`, guarded on `55910cb4111d48c54f48add915993923` with each edit applied exactly once;
  - keep `c_md5` as recorded, because that is the evidence of what was approved;
  - change only the md5 check row so that, once a `done` job exists for `aer_pr_a_recovery_close`, it reports `'ok', true, 'note', 'action completed <finished_at>; functions changed since by later change control'`. Before completion the check stays strict.

  This needs a line in the migration: `-- Governed snapshot change approved: <Platform Admin, date, why>`. Also add an entry in the admin repo `docs/platform/AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` (doc-update pattern: the same entry in every file of the runsheet set).
- **Option B: re-pin.** Make the same md5-guarded edit, replacing only the `admin_entry_matrix_reread` value in `c_md5` with the new definition's md5, computed in the migration after the replacement. Doing it in the migration, not as a typed literal, avoids transcription errors.
  - This does not make the snapshot `ok` (three other functions still differ).
  - It rewrites the record of what was approved, so it needs the same approval line.
- **Not acceptable:** changing the bulk function and leaving the snapshot silently out of date with no record, or editing the snapshot without the md5 guard.

**Under either option:**
- The migration's post-check asserts the snapshot's new md5 and the bulk function's new md5. The handback records both, read back from live after the deploy.
- `tests/uat/cf-247-s138-governed-action-runner-contract.spec.mjs` reads the 20261027 migration file, so it is unaffected. The new spec guards the edit.

## 5. Tests (G4)

- **New spec `cf-247-s1xx-aer-bulk-reread-newest-copy-contract.spec.mjs`**, starting with `// Guards: CF-247 decision W3x …`. It checks:
  - the md5 guard values (`ca394b60…`, `55910cb4…`);
  - that the W28 ordering string appears verbatim in both `aer_reread_v1` (from 20261029120000) and the new bulk body;
  - a row model of the rules, using s169's Otago two-copy fixture: a two-source batch with one source `already_waiting`, one unknown id and one source with two copies gives exactly one run re-queued per readable source, the older-copy pending item superseded, and decided items untouched;
  - that `held_unparsed` stays re-readable in bulk;
  - that the return keys are additive;
  - that nothing is dropped, and the `Replaces:` and `Retires:` lines are present.
- **Regenerate the test register** (admin repo `docs/platform/TEST-REGISTER.md`, using `node scripts/test-register.mjs`) in the same change.
- **Before merge:**
  - run a local Postgres test of the live definition before and after;
  - run a rolled-back live dry run on one two-copy source (expect exactly one run re-queued and the older pending item superseded);
  - run the full suite;
  - re-read the deployed md5 after the merge.

## 6. Out of scope

- The markdown refetch in bulk.
- Scope and AI-limit checks in bulk. Adding them would change who can re-read `held_unparsed` runs.
- Closing Otago `f14ae480`, which W28 left for the Layer 4 reviewer.
