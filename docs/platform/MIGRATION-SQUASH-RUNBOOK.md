# Canonical migration squash: runbook

**Window:** Thu 19 Nov 2026, 01:30–03:30 AEDT (14:30–16:30 UTC Wed 18 Nov). **Owner:** S1-Build (Platform Admin 17 Nov 2026 18:02 and 18:25).
**Precedent:** Pilot #452 (10 Oct 2026, "baseline proven; old migrations archived"), which moved 1,053 files to `supabase/migrations-archive` and
made `supabase/live-capture/baseline/` the starting point for any new project.

## 1. What the squash is, and is not

| It does | It does not |
|---|---|
| Takes a fresh schema dump of production (`fxcwkweaxjtknorudmwp`) and makes it the canonical baseline in `supabase/live-capture/baseline/` | Change anything in the production database |
| Proves the dump rebuilds a database identical to production, including the 7 consumer functions that hold carriage returns, byte for byte | Edit `supabase_migrations.schema_migrations` (the history keeps every row) |
| Moves every applied migration file up to the cut-off into `supabase/migrations-archive/` (history only) | Re-apply anything: Deploy on merge applies only files *added* under `supabase/migrations/` |
| Repoints every spec, script and fixture that reads a moved file, so no guard is dropped | Change the consumer API (G3 stays 75 functions, 48 tables) |

Rollback: revert the squash PR. Production is untouched either way.

## 2. Facts read on 17 Nov 2026 (re-read in the window)

| Item | Value (17 Nov 2026, AEDT) |
|---|---|
| Migrations in production history | 2,069 rows (19:40 AEDT); 722 files still in Pilot `supabase/migrations/` (from `20261010006400`) |
| Live head | `20261117200000` at 19:40 AEDT (more will land before Thursday) |
| Consumer functions with carriage returns | 7: `api.website_v2_course_item(uuid,text[],text[])` 54, `public.website_v2_course(text,text)` 14, `public.website_v2_course(text)` 1, `public.website_v2_provider(text,text)` 10, `public.website_v2_provider(text)` 1, `public.website_v2_providers(jsonb,integer,integer,text)` 98, `public.zoho_edge_scholarships_v1(text)` 28 (count of `\r` in `pg_get_functiondef`) |
| Functions with `\r` anywhere | 41 |
| Current baseline `schema.sql` | md5 `e267e6a0…` (10 Oct), 304 lines with `\r`; no `.gitattributes`, so git keeps the bytes as committed |
| Pilot files that read a migration file by path | 602 files, 617 distinct migration paths; 46 files list the migrations folder (guards with a `FIRST` version, for example s32 `20261013012900`, s42 `20261015030000`) |

## 3. Carriage-return rule (why the 7 functions matter)

The G3 baseline (`pipeline.consumer_api_baseline`) stores `md5(pg_get_functiondef(...))` with the carriage returns. A dump read or written in text
mode, or a git line-ending conversion, turns `\r\n` into `\n` and the rebuilt function no longer matches (the Boost rebuild hit this: admin #554).
So, at every step:
- the dump is committed exactly as `supabase db dump` wrote it (no editor, no `dos2unix`, no `git add --renormalize`);
- the squash PR adds `.gitattributes` with `supabase/live-capture/baseline/*.sql -text` so no client converts it later;
- the proof counts `\r` inside each of the 7 function bodies in the committed `schema.sql` and compares with the live counts above, and the
  rebuild's G3 check compares the 75 md5 values.

## 4. Before the window (rehearsal, Wed 18 Nov 2026 daytime)

1. **Squash tool.** Add `scripts/migration-squash.mjs` to Pilot: given a cut-off version it moves `supabase/migrations/<v>_*.sql` with `v <= cut-off`
   to `supabase/migrations-archive/`, rewrites every `supabase/migrations/<moved file>` reference under `tests/`, `scripts/`, `src/` and
   `docs/` to `supabase/migrations-archive/<moved file>`, and refuses a file that is not in the production history.
2. **Guards that list the folder.** Add `tests/uat/support/migration-files.mjs` (lists `supabase/migrations-archive` then `supabase/migrations`,
   sorted by version) and switch the 46 folder-listing specs to it, so s32, s42, s57, s120 and the rest still check every migration from their
   `FIRST` version on. No assertion is removed or weakened.
3. **Dry squash on a branch** (`cf247-squash-rehearsal`, never merged): run the tool with the live head as cut-off; full CI must be green.
4. **Dump and proof:** run `db-schema-dump.yml` (production, read only; snapshot branch `db-schema-dump/<run>`), then the rebuild proof:
   admin `boost-test-rebuild.yml` from that dump on `coursefinder-boost-test` (option A, decided; never through the Supabase MCP write tool): all checks PASS and G3 75/48
   with no drift. Record the run ids here.
5. Post in `docs/CURRENT-STATE.md` section 4: migration freeze on Pilot `supabase/migrations/` from 01:15 to 03:30 AEDT Thursday (other lanes hold
   merges that add migrations).

### Decided: where the rebuild proof runs (Platform Admin 17 Nov 2026 20:06: option A)

**Option A.** The proof runs on `coursefinder-boost-test` through admin `boost-test-rebuild.yml` (input `dump_branch` = the window's `db-schema-dump/<run id>`, `dump_head` = the live head at the dump), for both the rehearsal and the window. Before each run, post in CURRENT-STATE that the project is being reset; `S2 - BOOST` re-seeds it after the rehearsal and right after the window closes at 03:30 AEDT Thursday.

Options considered:

`coursefinder-baseline-test` (the #452 proof project) no longer exists (project list read 17 Nov 2026 18:45 AEDT). The only throwaway project
is `coursefinder-boost-test` (`ucdaaqrpgcldnatavmib`), which `S2 - BOOST` now uses for experiments; `boost-test-rebuild.yml` resets it.

| Option | Effect |
|---|---|
| A. Use `coursefinder-boost-test`, agreed with `S2 - BOOST` (**chosen**) | No new cost. Their experiment data is wiped twice (rehearsal and window); they re-seed afterwards. |
| B. Create a new `coursefinder-baseline-test` project | Keeps Boost experiments intact; adds a Supabase project (spend, Platform Admin approval) and a one-off setup. |
| C. No rebuild; compare the dump with production text only | No cost, no disruption; weaker proof (formatting differences between the dump and `pg_get_functiondef` hide real drift). |

### Pre-staged 17 Nov 2026 (night, S1-Build; Platform Admin 23:07)

- **Squash tooling, Pilot #1234:** `tests/uat/support/migration-files.mjs` (`migrationNames()`, `migrationPath()`: the live folder plus files archived from `20261010006400` on; before the squash it returns exactly the live folder, 733 entries), the 46 folder-listing specs switched to it (no assertion changed; the baseline contract now counts only the 10 Oct archive, still 1,062), `scripts/migration-squash.mjs <cut-off> [--history <file>] [--allow <version>]... [--dry-run]`, guard spec s594. **Merged 18 Nov 2026 about 00:40 AEDT** (main `2fbd3601`; full CI green, 3,289 tests).
- **Rehearsal, Pilot draft #1235 (never merged, label `full-suite-evidence`):** first run at `20261118001000` (731 files, 1,079 references in 642 files: 609 tests, 30 workflows, 2 docs, 1 script); rebuilt after the PR 1 cutover at `20261118010000`: 734 files moved, 1,087 references repointed in 647 files; `20261118011000` (S2 - BOOST, above the cut-off) stays in the live folder. Local sample 304 of 307 passed (the 3 failures were s594 assuming a live migration, now fixed, and browser checks that fail the same way on unmerged main locally). Full CI result: see the results table.
- **Rehearsal finding 1 (fixed in Pilot #1237, squash tooling 2):** fixtures and specs that build a migration path at run time (`supabase/migrations/$m.sql`, `` `supabase/migrations/${f}.sql` ``, `new URL('migrations/…', root)`, a folder variable) are invisible to the literal rewrite; one such spec failed at load and stopped every test shard. #1237 adds `tests/fixtures/lib/migration-path.sh` (`migpath NAME`), switches 9 shell and 7 JavaScript fixtures to read either folder, and makes the path checks in s233, s506 and s507 accept either folder. It must also be merged before the window.
- **Left as they are on purpose:** `scripts/ci/apply-migration.sh`, `scripts/ci/dry-run-migration.sh`, `db-migration-test.yml`, `db-migration-dry-run.yml`, `deploy-on-merge.yml` and the `supabase/migrations/*…*` path filters and `deployed-uat.yml` greps read only the live folder, which is right: they handle new migrations.
- **Production history against the files** (read only, 17 Nov 23:30 AEDT and 18 Nov 00:45 AEDT; 735 versions against 734 files from `20261010006400` to `20261118010000`):
  - `20261031090000_cf247_ss014_operational_automation.sql` is a documented no-op that was never applied (its guard refused it at deploy; re-issued as `20261031091000`, Pilot #775). Archive it with `--allow 20261031090000`.
  - `20261107073928 cf247_course_description_promote_held` and `20261113004121 cf247_intake_wording_speed` are in the history with no file of that version (applied live, later checked in as `20261107120000` and `20261113302500`). The dump holds their effect; nothing to move. Logged as governance gaps.
- **Window command (step 4):** write the production versions from `20261010006400` to the cut-off to a file (read only), then `node scripts/migration-squash.mjs <head> --history <file> --allow 20261031090000`.
- **In the squash PR also:** add the new cut-off to `tests/uat/cf-247-baseline-contract.spec.mjs` (the live folder holds only files after it) and the new baseline md5s.

## 5. In the window (Thu 19 Nov 2026, 01:30–03:30 AEDT)

| Step | Action | Pass when |
|---|---|---|
| 0 | Read live: head version, `security.consumer_api_check` drift flag (read only), PR 1 cutover recorded live or held, no Pilot PR adding a migration merged since 01:15 | head known, no drift, PR 1 state recorded |
| 1 | `db-schema-dump.yml` on production | snapshot branch pushed; md5s printed |
| 2 | Count `\r` in the 7 consumer function bodies in the dumped `schema.sql` | 54, 14, 1, 10, 1, 98, 28 (or today's live counts, re-read in step 0) |
| 3 | Rebuild proof from this dump: admin `boost-test-rebuild.yml` on `coursefinder-boost-test` (post the reset in CURRENT-STATE first) | every check PASS; G3 75 functions, 48 tables, no drift |
| 4 | Squash PR: new `schema.sql`, `roles.sql`, `MD5SUMS` (and `roles-apply.sql` if `roles.sql` changed) copied byte for byte from the snapshot branch; `.gitattributes`; `node scripts/migration-squash.mjs <head>`; README "Baseline" section updated with the run ids | full CI green; `git diff --stat` shows only moves, the baseline files, `.gitattributes`, path rewrites and the README |
| 5 | Merge on green | Deploy on merge reports "No new migrations." and deploys no edge function |
| 6 | Read back | live head unchanged; history row count unchanged; G3 drift none; `md5sum supabase/live-capture/baseline/schema.sql` on main equals the snapshot |
| 7 | Record and hand back | tell `S2 - BOOST` in CURRENT-STATE that `coursefinder-boost-test` is free to re-seed; admin `docs/CURRENT-STATE.md` (canonical baseline = dump run id, cut-off, files archived), this runbook's results table, test register regenerated, engagement row |

If step 2 or 3 fails, stop: no squash PR, the window closes, report the figures. If CI fails on step 4 for a path that the tool did not rewrite,
fix the rewrite (not the assertion) or stop at 03:15.

The Boost ingestion blackout (`boost.ingest_blackout_start_epoch` 1795012200 to `boost.ingest_blackout_end_epoch` 1795019400) already keeps
`worker-boost-bulk-ingest` out of the window. Nothing else needs to be paused: the squash changes no database object.

## 6. Results

| Step | Run / PR | Result |
|---|---|---|
| Rehearsal dump | | |
| Rehearsal rebuild proof | | |
| Rehearsal squash branch CI | Pilot draft #1235 (tool at `20261118010000`: 734 moved, 1,087 references in 647 files) | running (rebuilt 18 Nov 00:55 AEDT on squash tooling 2, Pilot #1237) |
| Window dump | | |
| Window proof | | |
| Squash PR | | |
| Read back | | |
