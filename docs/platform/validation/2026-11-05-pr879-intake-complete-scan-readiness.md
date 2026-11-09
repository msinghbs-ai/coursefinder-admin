# PR #879 intake complete scan (preview paging): readiness against current production

Validator: agent E (independent validation). Decision 19:14 §8 (Platform Admin, 5 Nov 2026).

- **Branch:** `codex/intake-complete-scan`, head `10a58e70`, based on v2.15.479 (`820ac18f`). Inspected read-only; the branch was not modified.
- **Production:** `fxcwkweaxjtknorudmwp`. Light catalogue reads only, 5 Nov 2026 19:20–19:45 AEDT.
- **Disposition (ownership table):** retained, awaiting a Platform Admin decision. The intake workstream is closed except for P0 issues.

**Verdict: needs rework.** Renumbering alone is not enough. The paging is built on `security.intake_dates_plan_v2`, which main retired in v2.15.480 (calendar v2). Preview, cohort and job now all read `security.intake_dates_plan_v3`. As written, the PR would page and validate cohorts against the retired plan while the job applies v3. It would also bring the retiring function back into use. Porting the paging to v3 means touching the intake scheduler (`intake_dates_plan_v3`), which nobody may edit under the 19:14 ownership table. That needs a Platform Admin decision first.

## What it changes

Migration `20261105020000_intake_preview_paging.sql`:

1. **Plan v2 with a cursor.** It rewrites `security.intake_dates_plan_v2(uuid[],integer)` into a cursor-aware body, `security.intake_dates_plan_v2(uuid[],integer,uuid,uuid)`. The old signature becomes a wrapper. The rewrite is guarded on md5 `8e3e11c3b78e4e52ea0709e48a666ff6`.
2. **Two tables.** `pipeline.intake_preview_sessions` and `pipeline.intake_preview_rows`, with RLS on and all grants revoked.
3. **Three functions.**
   - `security.intake_preview_result_v1(uuid)`.
   - `public.admin_intake_preview_v1(text,jsonb)`: start, step and read a resumable preview. It pages each approved university through plan v2.
   - `public.admin_intake_preview_prepare_v1(uuid,text)`: fixes a cohort from a finished preview. It inserts into `pipeline.run_now_cohorts`, `pipeline.run_now_cohort_members` and `pipeline.intake_ui_requests` directly.
4. **Bridge edit.** It edits `public.admin_intake_run_read_v1(text,jsonb)` (guarded on md5 `fa7d47a39f1401e54e751fbfe4de29c9`) to advertise `paged_preview`.
5. **Settings.** It relabels `run_now.preview_rows_per_university` from "per university" to "per request". It rewrites that setting's `used_by` and adds to `run_now.preview_seconds`.
6. **Register.** Five component register rows.

Other files: `src/IntakeRunValidate.jsx`, `src/intake-run-api.js`, intake fixtures and benchmark, `tests/integration/intake-postgres.spec.mjs`, `tests/uat/intake-run-validate-ui.spec.mjs`, `.github/workflows/intake-run-validate-test.yml`, `playwright.intake.config.mjs`, `docs/platform/TEST-REGISTER.md`, and UI evidence (two PNGs, about 3 MB).

## Checks

### 1. Have the functions it changes changed in production since its base?

| Object | What #879 assumes | Production now | Result |
|---|---|---|---|
| `security.intake_dates_plan_v2(uuid[],integer)` | md5 `8e3e11c3b78e4e52ea0709e48a666ff6`, the canonical plan | Still `8e3e11c3…`, but component register status **retiring**, retire after **19 Nov 2026**. No security or public function calls it any more (searched all definitions for `intake_dates_plan_v2(`). | Guard passes, but the PR revives a retiring function. |
| `security.intake_dates_plan_v3(uuid[],integer)` | not known to #879 | `1d531a835fcaa6996ac32f88d218eea8` (v2.15.485), the active plan | #879 does not use it. |
| `security.intake_ui_selection_v1(text,integer)` | the preview at v2.15.479 calls plan v2 | Edited twice on main after the base, both md5-guarded: v2.15.480 (`20261105020000`, from `a61e8114…`: plan v2 → plan v3) and v2.15.481 (`20261105040000`, from `36ecb3ad…`: rule label names plan v3). Live md5 `09b38c698f349b885bc0f3ddfeedb010`. | Changed since the base. |
| `security.run_now_cohort_create_v1(text,uuid,text,text)` | cohort from the plan the preview showed | Edited to plan v3 on main (v2.15.480, then v2.15.481). Live md5 `267203330312bdc0c7d554b569598e37`. | Changed since the base. #879 bypasses it (below). |
| `public.admin_intake_run_read_v1(text,jsonb)` | md5 `fa7d47a39f1401e54e751fbfe4de29c9` | `fa7d47a39f1401e54e751fbfe4de29c9` | Unchanged; the guard passes. |
| `public.admin_intake_cohort_prepare_v1(text,integer,text,text)`, `public.admin_intake_run_now_v1(uuid)` | not edited | `8a6d250362cba7319b3e18086073844e`, `d3f2c2445a955f9c6e71fe0a00ab0608` | – |
| `security.intake_ui_preview_v1(text,integer)` | not edited | `cb2d5034542e88955505d3cf567a7bec` | – |
| `pipeline.intake_preview_sessions`, `pipeline.intake_preview_rows`, `public.admin_intake_preview_v1`, `public.admin_intake_preview_prepare_v1` | new | Not in production | No name clash. |
| Setting `run_now.preview_rows_per_university` | relabelled "per request" | label "Run now: preview rows per university", 1–1000 rows, value 5, used by `security.intake_ui_selection_v1` | Conflicts (below). |

### 2. Does its paging approach still fit?

No, for four reasons.

1. **Wrong plan.** It pages `security.intake_dates_plan_v2`. Since v2.15.480, Preview (`intake_ui_selection_v1`), the cohort (`run_now_cohort_create_v1`) and the job (`intake-dates-apply`) all use `security.intake_dates_plan_v3`. Plan v3 covers every main teaching calendar, the unique-month rule, the next action and the revisit, focus rounds (v2.15.484) and the pilot share (v2.15.485). `admin_intake_preview_prepare_v1` also checks the cohort against `security.intake_dates_plan_v2(ids, batch.intake_dates_apply)`. A preview and cohort fixed this way would show and accept values that the job, reading v3, will not write. This is the kind of mismatch decision 19:14 §6 forbids: a new mechanism silently diverging from working automation.
2. **Revives retired functionality.** v2.15.480 marked plan v2 `retiring` (retire after 19 Nov 2026, replaced by v3) and nothing calls it now. #879 would make it a live dependency again, add a new signature registered `active`, and block the housekeeping drop. Decision 19:14 §6 says a new mechanism must not revive retired functionality.
3. **Duplicate cohort path.** `admin_intake_preview_prepare_v1` writes `pipeline.run_now_cohorts` and its members directly, instead of through `security.run_now_cohort_create_v1`, the shared, md5-guarded cohort creator that the Run now bridge uses. That is a second controller for the same table (decision 19:14 §6: no duplicate controllers). It also skips whatever checks the shared creator adds now or later.
4. **One setting, two meanings.** The PR relabels `run_now.preview_rows_per_university` as "rows per request" and overwrites its `used_by`. `security.intake_ui_selection_v1` still reads the same key as a per-university limit, so one setting would mean two things.

The idea itself is sound and still needed: production Preview stops at 5 rows per university (`run_now.preview_rows_per_university` = 5) of a 1,500-row scan budget. The idea is a resumable, bounded, per-university scan of the governed budget, with read snapshots and a fixed cohort only from a complete scan. Its tests (complete-scan fixture, benchmark, query plans) are reusable.

### 3. Migration version and merge conflicts

- **Version collision.** Production's history already holds `20261105020000` as `cf247_intake_calendar_v2`, which is also the file on main. `scripts/ci/apply-migration.sh` skips an applied version only when its recorded statements equal the file, and refuses otherwise (UR-13). Deploy would therefore refuse #879's migration ("already applied … recorded md5 differs"). If the file were merged alongside main's, the same name prefix would hold two files. It must be renumbered after `20261105090000`.
- **Conflicts with main.**
  - `.github/workflows/intake-run-validate-test.yml`: main added the calendar-v2, recovery-final and fairness steps. The ownership table also bars agents from editing existing workflows.
  - `docs/platform/TEST-REGISTER.md`: needs regeneration.
  - Likely also `tests/fixtures/intake-ui/benchmark.mjs`, `server.mjs`, `register.mjs` and `tests/integration/intake-postgres.spec.mjs`, which main's intake releases also changed.
- **Fixture database name.** The fixture uses the shared fixed database `intake_ui_fixtures`. I did not run it, so as not to collide with other agents' local databases. Its results on its own branch are recorded in its `docs/ui-evidence/intake-complete-scan-results.*`; they test against plan v2.

### 4. Other required checks

| Check | Result |
|---|---|
| Production-representative fixtures | It builds on the intake-ui fixture, which has a partial parity layer (`tests/fixtures/intake-ui/parity.mjs`). Its new tables are new, so production holds nothing to compare. The tables it writes (`run_now_cohorts`, `run_now_cohort_members`, `intake_ui_requests`) were checked against production (section 5). |
| Budget and role protection | It reads `run_now.pilot_cap`, `run_now.cohort_scan_rows`, `run_now.preview_seconds` and `batch.intake_dates_apply` from settings (G2 respected). Execute on the new public functions goes to `authenticated`, with a role-rank check of 3 or more. No spending path. |
| Admission rules | Preview writes snapshots only, and the cohort still runs through `admin_intake_run_now_v1` and the job. But the plan mismatch (point 1 above) means the preview no longer reflects what the job would admit. |
| Consumer API | None touched. |
| Housekeeping | `-- Replaces:` names plan v2 (now wrong: v2 is already replaced by v3). `-- Retires: nothing`. Table comments present. No drop. |

### 5. Shapes of the tables it writes, in production now

Read 5 Nov 2026 19:44 AEDT. `admin_intake_preview_prepare_v1` inserts these columns:

- `pipeline.run_now_cohorts(job, label, selection_rule, selection, requested_by, reason)`;
- `pipeline.run_now_cohort_members(cohort_id, course_id, provider_id, pick, pattern, fills, evidence)`;
- `pipeline.intake_ui_requests(cohort_id, requested_by, preview_token, scope, size, reason)`.

The production columns, not-null columns without a default, and constraints are listed below. Every required column is supplied and no check is violated. The direct insert still duplicates the shared creator (point 3 above).

| Table | Production columns (`!` = not null without default) | Constraints | #879 insert |
|---|---|---|---|
| `pipeline.run_now_cohorts` | id, job!, label!, selection_rule!, selection, requested_by!, reason!, created_at | `run_now_cohorts_job_fkey` → `pipeline.automation_catalogue(jobname)` | job `'intake-dates-apply'` (catalogued), label, rule, selection, `auth.uid()`, reason: satisfies all |
| `pipeline.run_now_cohort_members` | cohort_id!, course_id!, provider_id!, pick!, pattern!, fills!, evidence! | FK `cohort_id` → `run_now_cohorts(id)` | all seven supplied: satisfies all |
| `pipeline.intake_ui_requests` | cohort_id!, requested_by!, preview_token!, request_key, scope!, size!, reason!, created_at | FK `cohort_id`; UNIQUE `preview_token`; UNIQUE `request_key` | `preview_token = 'page:'||session` is unique per session; `request_key` left null: satisfies all |

No triggers on the three tables.

## Recommendation

This goes to the Platform Admin, because it touches the closed intake scheduler.

- **Option A: port to plan v3.** Rework the paging onto plan v3. This needs either a cursor variant of `security.intake_dates_plan_v3` (scheduler edit; Platform Admin approval) or paging in the preview layer only, with plan v3 called on bounded course-id slices, which needs no scheduler edit. Create cohorts through `security.run_now_cohort_create_v1`. Add a new setting for rows per request instead of relabelling the per-university one. Then renumber, rebase, and keep the shared intake workflow untouched (a new workflow file instead).
- **Option B: close #879 without merging.** Preserve its specification, fixture, benchmark and evidence in the admin repository for a future intake-preview work package.

Do not release as is.

## Forward recovery

Not applicable; this should not be released in its current form. If a reworked version is released, it adds new tables and functions and changes no existing definition except where it is md5-guarded. Recovery is a new migration that restores the guarded definitions and switches the UI back to the existing 5-row preview (`admin_intake_run_read_v1` without `paged_preview`).
