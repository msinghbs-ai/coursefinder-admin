# Test turnaround review (3 Nov 2026)

Short, timeboxed review of build and test turnaround for StudySearch / CourseFinder, for the Integration Controller. Read-only apart from one small test change on branch `cf247-test-turnaround` (not merged).

## Review 1: where the time goes, and the smallest change

### Where the time is actually spent (measured)

**Local full suite** (Integration Controller logs `c422` to `c440`, list reporter, 1 worker, shared 2-CPU machine):

- 1,580 to 1,685 tests, 12.7 to 21.8 minutes per run (median about 15 minutes). The spread follows machine load from other agents' runs, not test growth.
- Releases are landing roughly every 20 minutes, so one full run per release is now the main limit on release pace.
- Breakdown of run c440 (15.6 minutes wall time, 900 s of summed test time):
  - Browser tests (any spec that opens a page; 917 tests): about 832 s, **92 %**. The average is under 1 s per test, so no single test is the cause; the cost is the number of browser tests run one after another.
  - Source-only checks (768 tests): about 68 s, **8 %**. Of this, **about 60 s is eight specs each running `npm run build`** on the same unchanged code (7.5 to 10.8 s each). Every other source check takes milliseconds.
  - Start-up and overhead (dev server, worker, reporters): about 35 s (wall time minus summed test time).
  - Largest single file: `cf-247-toolsets-limits-contract` at 75 s, almost all browser tests.

**CI** (last 60 runs, REST API):

- Pilot Frontend Build: median 69 s for a pull request and 68 s for a push to main (maximum 114 s). Step timings for one PR run: install 5 s, build 4 s, test discovery 4 s, two targeted contracts 2 s, Chromium install 10 s (cache miss), smoke 4 s. Most of the rest is setup and caching.
- Release History Contract about 26 s, Deploy on merge about 21 s, Deployed UAT about 66 s.
- **CI is not the bottleneck.** It never runs the full suite, so its time cannot be compared with the 15-minute local run.

### Codex findings

| # | Finding | Verdict | Evidence |
|---|---|---|---|
| 1 | `playwright.config.mjs` sets `workers: 1` and `fullyParallel: false` | **Agree** | Both are set in the config on main. |
| 2 | Source and browser tests share one configuration, and most registered tests are source checks | **Agree on the shared configuration; disagree on "most"** | There is one config with two projects, and the dev server starts for every run. By file, 219 of 409 specs are source-only. By test, source checks are a minority: 768 against 917 browser tests in c440. Some files, such as `toolsets-limits`, mix both. |
| 3 | `cf-247-toolsets-limits-contract` compiles `coverage-sweep/adapters.ts` seven times | **Agree, but it costs almost nothing** | There are seven separate `esbuild` calls (lines 229, 313, 364, 469, 497, 513 and 945), plus three other `esbuild` compiles in the same file. Each `adapters.ts` compile measured about 70 ms, so all seven together take about 0.5 s per run. **The duplicate compile that does cost time is `npm run build`, run by eight specs (about 60 s per run).** |
| 4 | Frontend CI runs build, targeted contracts and smoke, not the full suite | **Agree** | `pim-build.yml` runs build, `--list`, two contracts (CF-245, CF-085) and `smoke.spec.mjs`. Setup and build take about 70 s in all; the full suite runs only locally, at about 15 minutes. |
| 5 | Recent releases add permanent migration-specific contracts that repeat the central guards | **Agree in part** (see "Repeated central-guard checks" below) | Many per-change specs check again that `-- Replaces:` / `-- Retires:` lines exist, that a `comment on table` exists, or that the consumer API is not touched. These checks take milliseconds each, so removing them would make maintenance easier but **would not make runs measurably faster**. |
| 6 | The JSON reporter can identify slow tests, retries and setup overhead | **Agree, with one limit** | `uat-artifacts/results.json` records each result's `duration`, `retry`, `status` and `startTime`, plus `stats.duration`. Slow tests and retries can be read from it directly. Setup overhead can only be found by subtraction (`stats.duration` minus summed test time); dev server start-up is not reported separately. |

### Assessment by priority

**1. Avoid repeat full-suite runs during iteration (largest benefit).**
- Each full run costs about 15 minutes, and the logs show more than one full run for some releases (for example `suite394`/`394b`, `suite395`/`395b`/`395c`).
- Recommendation:
  - while iterating, run the specs a change touches plus the central guards (`s32`, `s42`, `s57`, `s120`, `m245`/`s70`) and the smoke test, which takes about 1 to 2 minutes;
  - keep exactly **one** full run on the final integrated, rebased revision before merge, as now.
- *Estimate:* each full run avoided saves about 15 minutes of machine time and makes concurrent agents' runs less noisy.

**2. Reuse compiled outputs (done on the branch).**
- The eight `npm run build` calls now go through a build-once helper (see "Change made on the branch" below).
- The `adapters.ts` recompiles are not worth changing: about 0.5 s per run.

**3. Run source-only checks with two workers in their own project.**
- **Not safe as things stand.** Before the change on the branch, the eight build specs each wrote to the shared `dist/` folder, and two workers could have run two `vite build`s into it at once.
- Other shared resources checked:
  - The esbuild temp files are already named per process (`${process.pid}`), so they are safe.
  - No source spec opens a port. The source specs that mention `createdb` or `PGPORT` (`s216`, `s219`) only read workflow text; they do not touch the local Postgres fixture databases.
- Even with the branch change in place, the benefit is small. Source checks are about 8 s of runtime once the builds are shared, and the machine has 2 CPUs shared with other agents.
- *Estimate:* under 10 s saved per run. **Not recommended now.**
- What matters more for safety: every concurrent run on port 5173 with `reuseExistingServer` can pick up **another worktree's dev server**. Agents already work around this with per-worktree `pw-<port>.config.mjs` files. A `PW_PORT` environment option in the main config would make this the standard.

**4. Cancel superseded PR build runs in CI.**
- Safe to add `concurrency: { group: pim-build-${{ github.ref }}, cancel-in-progress: true }`, limited to `pull_request` events. For pushes to main, the group would need to be unique per run or cancelling turned off.
- Do not add it to `deploy-on-merge.yml`, `deployed-weekly.yml` or the other serial controls; they correctly keep `cancel-in-progress: false`.
- *Measured benefit is about nil.* In the last 60 runs, every PR branch had one PR build (plus Release History), and a run takes about 70 s. Worth doing only as hygiene.

**5. Repeated central-guard checks (candidates only; nothing retired).**
- Of the 70 specs added since 30 Oct, about 30 check again what a central guard already covers. Examples:
  - `s199` lines 12 to 15: checks that the `-- Replaces:` / `-- Retires:` lines exist (already covered by `s42`) and that no consumer API name appears (already covered by `s57`).
  - `s184` lines 49 to 51: checks that `Replaces` / `Retires` say "nothing" and that `comment on table` exists (`s42`).
  - Similar checks appear in `s186` to `s189`, `s194`, `s195`, `s197` to `s200` and `s212`.
- Across all specs outside the central guards: 86 check `-- Replaces:`, 83 mention `pipeline_num_v1` and 53 check consumer API names.
- **Not a candidate:** `s190`, which records an *approved* consumer API change (a rebaseline with specific checksums). That check is specific to the change, not a repeat of `s57`.
- These checks take milliseconds, so retiring them is about governance (rule 11: no more per-change checks of centrally guarded rules), not speed. Suggested approach: in the quarterly prune, drop the presence-only lines. Keep a specific value, such as a named function in `-- Replaces:`, only where it is a fact about that change.

### Change made on the branch

**What changed** (branch `cf247-test-turnaround`, commit `e9db3367`, based on main `65940aaf`):
- New file `tests/uat/support/build-once.mjs`. The first call in a worker runs `npm run build`; later calls in the same worker reuse its output. If the build fails, every caller still fails.
- Eight specs now call it instead of running their own build: `cf-061`, `cf-065`, `cf-088`, `cf-142-143`, `m2-5-evidence-lineage`, `m2-5-jobs-workspace`, `m2-5-platform-maturity` and `m245-ui-improvements`.
- The checks themselves, the test names and the `// Guards:` lines are unchanged, so the test register does not change.

**Before and after** (same machine, same 8 specs, 1 worker, load average about 5 to 7 both times):

| Run | Result | Wall time |
|---|---|---|
| Before | 8 passed, 0 skipped | **167 s** (each build 13 to 25 s under load) |
| After | 8 passed, 0 skipped | **25 s** (one build at 16.6 s; the other seven tests take milliseconds) |

- `s120` (test governance) still passes, 6 of 6.

**Whole-suite projection:**
- Quiet-machine cost of these eight tests in c440 was about 67 s. After the change, about 9 s (one build).
- *Estimate:* **about 58 s saved per full run (about 6 % of 15.6 minutes); more under load.**
- The full suite was **not** re-run on the branch within the timebox. The one full run on the integrated revision will confirm the pass count.

**Recovery:** revert the commit (`git revert e9db3367`). Nothing else depends on it.
