# Stream C: Website/Zoho API performance and regression, and Gate A release integrity

SS-015 accelerated acceptance. Read-only. Measured 2 Nov 2026, 05:45 to 06:45 AEDT.
Supabase project `fxcwkweaxjtknorudmwp` only. No writes, PRs or pushes. No `@live-acting` spec was run, and no load was put on production.

Release under test: **v2.15.400**, Pilot `main` = `1f7d41aaa368807c1044f07a1d43f9290086ef53`.
Note: the SHA in the brief (`1f7d41aa368807c…`) is missing one `a`. Queried with that SHA, the GitHub API returns 0 runs. The runs below are for the correct SHA.

---

## 1. Gate A verdict, line by line

| # | Gate A line | Verdict | Evidence |
|---|---|---|---|
| A1 | Latest production version verified | **Pass** | Release Currentness Deployed run **41317922285** (job 124881809080) on `1f7d41aa`: `release-contract: PASS candidate v2.15.400 / package 0.1.327; recovery v2.15.79 @ 32be4e96`. It also logged "Deployed frontend serves v2.15.400 (attempt 1/80)" and `release-notes-deployed.spec.mjs` 1 passed. Release History Contract **41317922289** passed. Local `m245-release-history-v21575-persistence-contract` passed ("v2.15.400 is the release candidate"). I could not make my own fetch of the site: the agent proxy returned 403. |
| A2 | Complete test suite green, with no failures or skipped required tests | **Pass** | Re-run in this stream on a fresh local clone of `main` @ `1f7d41aa`, using an uncommitted config on port 5197, `--grep-invert "@deployed\|@live-acting"`. Listing: **1,406 tests in 329 files**, the same as the integrator's figure. Result: **1,406 passed, 0 failed, 0 skipped, 0 flaky, exit 0, 36.5 min**. The git-based checks ran against a real clone, not vacuously. Port 5197 was released afterwards. CI on the release commit runs only smoke tests: Pilot Frontend Build **41317922322** (smoke, 1+2 passed) and Release History Contract (1 passed). The full suite figure therefore rests on the local run. |
| A3 | Deployed API, desktop and applicable phone UAT pass | **Insufficient Evidence** | Post-merge StudySearch Deployed UAT **41317922267** (tier `targeted`) ran **3 tests**, all from `layer1-operations-deployed.spec.mjs` (desktop only), and all passed. The phone step did not run (`mobile=false`; the targeted set has no `@responsive` spec). Release Currentness ran 1 deployed spec (desktop). No deployed run on any of the 27 releases since 31 Oct ran the phone project (runs 41146646602 to 41317922267: every one targeted, 1 to 3 desktop tests). The last full deployed run was **Deployed weekly run 41144480924** (31 Oct, on `6f006619` = v2.15.375): desktop 80/80, phone 81/81, 0 skipped, live-acting held 10. The scheduled weekly run for Mon 2 Nov 05:17 AEDT had still not started at the last check, about 06:40 AEDT. There is no scheduled run in the workflow's history at all; all 6 runs were manual dispatches. Today's `main` has **81 safe deployed tests on desktop and 82 on phone** (37 files). The new one since the last weekly run is `cf-247-s185-aer-course-outcome-register-deployed`. |
| A4 | Migration and live-function checksums match | **Pass, with notes** | 358 versions are live and 359 files are in git from `20261010006400` on (§3). Every version is present on both sides, except one no-op in git only. Since **20261101000000**, the md5 of the live `statements` equals the md5 of the git file **byte for byte for all 12**. Across the whole post-baseline range: 344 of 358 match exactly, and 8 more match under the CR-strip rule of `scripts/ci/apply-migration.sh`. 3 differ only by a trailing newline. 3 have git files edited after they were applied (header comments and dollar-quote style; executable SQL is the same). Consumer function checksums: 75 of 75 equal the `pipeline.consumer_api_baseline` md5 (§4). |
| A5 | Consumer API contracts remain intact | **Pass** | `consumer-api-guard` (cron job 213, `23 18 * * *` UTC) last run on **1 Nov 18:23 UTC** (05:23 AEDT 2 Nov): `succeeded`. Runs on 29, 30 and 31 Oct also succeeded. No `consumer_api_drift` flag has ever been raised, and there are no `consumer_api_drift` control events. A read-only re-check that mirrors the guard found 0 changed, 0 missing and 0 added functions out of 75, and 0 relation or column drift out of 48. Baseline last captured 31 Oct 03:22 UTC (D4, approved). Edge files: sha256 of all 5 consumer `index.ts` files equals `tests/uat/consumer-api-baseline.json`. Local contracts passed: `s57` (3), `website-api-v2-contract` (5), `institution-type-contract`, `s49-zoho-api-v2` (8), `s113` entry additive, `s32`, `s42`, `s120`, `s70`: 49 passed. The git-based checks in `s49` were also re-run inside the real repo, because they pass vacuously outside a git checkout. All were clean. |
| A6 | No unresolved deployment drift | **Pass, with notes** | Edge drift check **41252370744** (31 Oct 23:24 UTC, `9396b085`): success, so live equals git for every listed function and there are no unlisted live functions. No edge function was deployed after it: the newest live `updated_at` is coverage-sweep, 31 Oct 23:46 AEDT. Git has no `supabase/functions` change from `9396b085` to `1f7d41aa`. The database has no live migration missing from git. The only git-only file is the documented no-op (§3). Deploy-on-merge did not trigger for `64d98034` or `1f7d41aa`, which change no migrations or functions. The last deploy was `8f15da35` (run 41310238843, success). |

**Overall: Gate A is not yet met.** A3 lacks evidence for v2.15.400: no full deployed desktop run and no phone run. All other lines pass on evidence. A2 was independently re-verified in this stream: 1,406 of 1,406 passed.

### Deployed specs: what ran and what was held

- **Post-merge on `1f7d41aa`.**
  - Deployed UAT 41317922267, desktop: `layer1-operations-deployed.spec.mjs`, 3 safe tests: the AU/NZ operator journey; the Administration boundary for Layer 1 source configuration; an anonymous browser cannot run Layer 1 contracts.
  - Release Currentness 41317922285, desktop: `release-notes-deployed.spec.mjs` (1).
  - Phone: none.
  - Held as `@live-acting` by `--grep-invert @live-acting`, from that spec: 3 tests (NZQA validation, CRICOS validation, the AU Statistics QILT/PRISMS filter).
- **Last full run.** Weekly 41144480924, 31 Oct (v2.15.375): desktop 80 passed, phone 81 passed, 0 failed, 0 skipped. Live-acting switch off, 10 held.
- **The 10 `@live-acting` tests on `main` today**, held in every run above:
  1. `cf-068-qs-xhr-layer1-deployed`: QS 2026 rows, and QS 2027 challenge (2 tests)
  2. `cf-076-ranking-import-ux-deployed`: parse an uploaded import, and validate an edition (2 tests)
  3. `cf-090-ranking-import-recovery-deployed`: THE 2026 recovery (1 test)
  4. `cf-247-s154-aer-workspace-deployed`: governed edit and put back (1 test)
  5. `layer1-operations-deployed`: NZQA, CRICOS, AU Statistics (3 tests)
  6. `screen-state-persistence-deployed`: course filters persist (1 test)

---

## 2. API performance, 1 Nov 09:25 AEDT to 2 Nov ~05:49 AEDT

Two sources:
- `pipeline.api_requests`, written by the v2 functions only;
- Supabase `function_edge_logs` (edge time and status, all consumer functions; window 31 Oct 22:25Z to 1 Nov 18:49Z).

No load was generated. There were no extra single calls, because the logs were enough.

| Consumer (function) | Action | Calls (DB / edge) | 5xx (DB / edge) | p50 | p95 | Max | Notes |
|---|---|---|---|---|---|---|---|
| Website search (`website-api-v2`, `search`) | search | 0 / 0 | – | – | – | – | **Insufficient Data.** The last website search was 28 Oct 21:50 UTC. |
| Website sync (`website-api-v2`, `sync_delta`) | sync_delta | 7 / 6 | 0 / 0 | 3,384 ms (edge 4,109) | 5,150 ms (edge 5,598) | 5,150 ms (edge 5,971) | Average 45 items, 379 KB. 14-day: p50 3,020, p95 5,725, so within the usual range. |
| Website course v1 (`wix-course-api`, `website-course-api`) | – | – / 0 | – | – | – | – | **Insufficient Data.** No traffic. v1 does not log to `api_requests`. |
| Zoho v2 (`zoho-api-v2`) | search | 18 / – | 0 | 672 ms | 10,222 ms | 10,222 ms | 18 calls, so p95 is the single slowest call: 1 Nov 08:22Z, 20 items, 47 KB. Excluding it, the max is 2,721 ms. 14-day: p50 977, p95 4,823. |
| Zoho v2 (`zoho-api-v2`) | reference | 1 / – | 0 | 1,443 ms | – | – | |
| Zoho v2, all (edge) | – | 19 / **20** | 0 / **1** | edge 900 ms | edge 3,523 ms | edge 10,461 ms | **1 × 503 at 1 Nov 11:30:16Z**, in 6 ms, with no function id: the platform refused the request before the worker booted, and there is no `api_requests` row. Deluge retried and got 200 4 s later (worker booted in 27 ms). |
| Zoho v1 (`zoho-course-api`) | – | – / 4 | – / 0 | edge 1,229 ms | edge 2,532 ms | 2,708 ms | Not in `api_requests`. |

**Slowest calls in the window:**

| Time (UTC) | Consumer | Action | Duration | Size |
|---|---|---|---|---|
| 1 Nov 08:22 | zoho | search | 10,222 ms | 20 items |
| 1 Nov 10:04 | website | sync_delta | 5,150 ms | 1 item, 175 KB |
| 1 Nov 03:01 | website | sync_delta | 3,484 ms | 52 items, 541 KB |
| 1 Nov 10:04 | website | sync_delta | 3,445 ms | 36 items |
| 1 Nov 03:01 | website | sync_delta | 3,384 ms | 122 items |

**Against T6** (OPERATIONAL-LIMITS.md: "0 server errors; no contract drift; search p95 under 3 s for pages of 20"):

| T6 part | Result |
|---|---|
| Contract drift | **Met** (§4). |
| Server errors | **Not met, strictly.** The edge logged 1 platform 503 on `zoho-api-v2`. The application logged 0. |
| Website search p95 | **Cannot be assessed.** There was no website search traffic. |
| Zoho search p95 | 10.2 s on n = 18, which is above 3 s. This is one outlier on a 20-item page; the rest were at or below 2.7 s. The sample is too small for a p95. Treat it as a watch point, not a breach finding. |

**Against SS-012** (record §26, v2.15.381):
- **Baseline:** website search p50 3.1 s and p95 6.9 s at the edge over 14 days; database time for a 50-item search 0.7 to 2.2 s, falling to a median of 552 ms after the change.
- **Still not measurable:** edge p50 and p95 after the change. The website has sent no search since 28 Oct, so the §26 note "will be reported once traffic returns" still stands.
- **Pre-change 14-day figures in `api_requests`:** 19,622 searches, p50 3,137 ms, p95 7,060 ms, **22 × 5xx**, all before 28 Oct 21:50Z. These fit the §21 baseline.

---

## 3. Migration drift detail

**Totals:**
- Live `supabase_migrations.schema_migrations`: 1,705 rows; 358 from `20261010006400` (the baseline cut-over); maximum `20261101120000`.
- Git `supabase/migrations`: 359 files.
- Earlier history is in `migrations-archive` (1,062 files) and is replaced by the baseline. It was not compared, because it is out of scope for release integrity.

**Version sets:**
- **Git only:** `20261031090000_cf247_ss014_operational_automation.sql`. The header says it was refused by its own md5 guard and rolled back, with nothing applied, and that it is kept as a `select 1` no-op (PR #775, `60317717`). The applied version is `20261031091000`.
- **Live only:** none.

**md5 of the live `statements[1]` against the git file, 20261101xxxxxx (all 12 identical):**

| Version | md5 |
|---|---|
| 010000 | ad911b82982ac2d1a00967993a47a943 |
| 020000 | 7de50f0f89677948f47e4f647a29bb5e |
| 030000 | b7b704f1819278d74beac763b8e2ef07 |
| 040000 | 6cf51b4d393970d6bdcd943888985580 |
| 050000 | 27cd42661e40149e4fc4e32e47aa2613 |
| 060000 | b37b7a6d6e1adfc1574c1c342a0280e7 |
| 070000 | 9d5258667957653c33c850a7ec406969 |
| 080000 | 1e80b0a915a9ccca157ce1f69746e279 |
| 090000 | 1b75ffeed0dc9e72538a049c0e082ddb |
| 100000 | 09f81312954bdb0dfabdee5b906d8218 |
| 110000 | ff3b310dc437f800870f1933abed752a |
| 120000 | 214aae7e68a58ed3d7f0b14db4fdf351 |

The day aggregate `ca7035059ae11e2eb9283b1f5b9e529e` is the same on both sides.

**Whole post-baseline range, compared day by day.** 18 of 23 day aggregates are identical. The 14 versions on the other 5 days resolve as follows:

| Class | Versions | Live md5 → git md5 | Cause |
|---|---|---|---|
| CR line endings (live has CRLF; matches after `replace(statements[1], E'\r','')`, the rule `apply-migration.sh` uses) | 20261010006400 to 20261010007000 (7 files), 20261028005000 | e.g. 006400 `8cc7eeea…` raw → `bac1fd50…` without CR = git `bac1fd50…`; 028005000 `548f14a3…` → `fd69acc1…` = git | Pasted applies (20261028005000 is the Platform Admin's paste-reviewed consumer change) |
| Trailing newline only | 20261014032122, 20261014034927, 20261014040646 | git with the final `\n` stripped = live (`55dc0600…`, `aacbbefd…`, `31b20fbf…`) | Ad hoc MCP applies on 14 Oct |
| Git file edited after apply | 20261021150000 (3 header comment lines), 20261022014000 (header lines, and the dollar-quote tag `$o$` → `$function$` in one edit block, so s42 reads it as function text), 20261022029000 (header note added; the 90-day recheck is shown as `security.pipeline_num_v1('contact.recheck_days', 90)`, the text that `20261022032000` later brought live) | live `738d0e59…` / `a7e6dcc7…` / `5a4adbf7…` ≠ git `38f60f67…` / `dd53ee6f…` / `34c3731e…` | Edited for the G2/s42 contracts before `apply-migration.sh` gained its "applied file changed" refusal. The live objects are unaffected: 029000's change was applied by 032000. |

---

## 4. Consumer API (G3)

| Check | Result |
|---|---|
| `pipeline.consumer_api_baseline` | 75 functions and 48 relations; captured 31 Oct 2026 03:22 UTC (reason: D4 additive `entry.min_scores[]`, approved 31 Oct 13:30). Digest of all baseline rows: `0a6fdf944d4561d2e2e6538140e22e79`. |
| Live functions compared with the baseline (search_path `''`, as the guard runs) | 0 changed, 0 missing, 0 added |
| Relations and columns | 0 drift |
| Guard job `consumer-api-guard` (jobid 213, `select security.consumer_api_check_v1()`; md5 of its definition `a5a09318ad900cc245b4a8d161ea94c4`) | 1 Nov 18:23Z succeeded (also 31, 30 and 29 Oct). No drift flag and no drift event. |

**Edge functions.** Baseline file note last updated 30 Oct (D5).

| Function | sha256 of `index.ts` in git (= baseline) | Live version | Last live deploy | Live drift check |
|---|---|---|---|---|
| website-api-v2 | `a833301f…3a4660` | v3 | 28 Oct 22:47 AEDT | match (run 41252370744) |
| wix-course-api | `c7e1182b…71a0ee` | v7 | 15 Oct | match |
| website-course-api | `463457cb…99ba413` | v3 | 15 Sep | match |
| zoho-api-v2 | `187f5e70…c8bde264` | v5 | 19 Oct | match |
| zoho-course-api | `c6216157…036b192` | v14 | 3 Oct | match |

Live `ezbr_sha256` bundle hashes are recorded by `list_edge_functions` but are not comparable with source hashes. The source comparison is the drift-check workflow's.

**Observation.** Run outside the guard, a re-check under the session's default `search_path` reports 3 false "changed" functions: `api.query_embedding_cache_get`, `api.query_embedding_cache_put` and `api.vector_candidates`. This is because `pg_get_functiondef` prints `vector` rather than `extensions.vector`. The guard and the rebaseline both run with `search_path ''`, so they agree. Any manual or CI re-check must set `search_path ''`.

---

## 5. Drift, regressions and gaps: severity and smallest fix

| # | Finding | Severity | Smallest fix |
|---|---|---|---|
| F1 | **No full deployed run (desktop or phone) on v2.15.400.** Post-merge UAT was targeted to 3 desktop tests. The last full and phone run was v2.15.375 (31 Oct). The scheduled weekly run (Mon 05:17 AEDT) had not started by about 06:40, and the cron has never fired in this workflow's history. | **High for Gate A** (blocks A3) | Dispatch `deployed-weekly.yml` on `main` with live-acting **off** (`gh workflow run deployed-weekly.yml --ref main`). Separately, check why the schedule trigger has not fired. Accept A3 when desktop is 81/81 and phone 82/82 with 0 skipped, and 10 held. |
| F2 | Brief's release SHA is mistyped (`1f7d41aa368807…` should be `1f7d41aaa368807…`). | Low (evidence hygiene) | Use the full SHA `1f7d41aaa368807c1044f07a1d43f9290086ef53` in the acceptance record. |
| F3 | One platform 503 on `zoho-api-v2` (1 Nov 11:30:16Z, 6 ms, before the worker booted); Zoho's retry succeeded. T6 says "0 server errors". | Low | No code change. Record it as a platform cold-start rejection. Optionally, have T6 count application 5xx (`api_requests`) separately from platform 5xx (edge log), and confirm Divya's Deluge client retries once on 503. |
| F4 | Zoho search p95 10.2 s on 18 calls (one 20-item outlier). | Low (watch) | Re-measure on 7 days of Zoho traffic before judging against T6's 3 s. Check the 08:22Z query's filters if it repeats. |
| F5 | No website search or v1 course traffic since 28 Oct, so the SS-012 edge p50/p95 after the change are still unmeasured. | Medium (acceptance evidence gap, not a defect) | Mark the website API performance part of SS-015 **Insufficient Data**. Ask the website developer for a short run of normal searches (20-item pages), or carry it as an open item for the first week of traffic. |
| F6 | 3 applied migration files were edited after apply (20261021150000, 20261022014000, 20261022029000). Live and git history text differ; live objects are unaffected. | Low (governance record) | Add a "history text differs, objects equal" line for these 3 versions to the migration README (or the test register), so a future checksum audit has an explained exception list. Do not re-apply or rewrite. |
| F7 | 11 migrations differ only in line endings or a trailing newline. | Info | Have any checksum audit use the `apply-migration.sh` rule (`replace(statements[1], E'\r','')`) and also a trailing-newline normalisation. |
| F8 | `s49` git checks pass vacuously outside a git checkout (`|| true`). | Low (test robustness) | In `s49`, assert `git rev-parse` succeeds before the `git grep`/`git diff` checks (G4: change with register regeneration). In this stream they were confirmed clean in the real repo. |
| F9 | The consumer re-check is sensitive to `search_path`. | Info | Note it in the G3 runbook. The guard is unaffected. |

**Regressions found:** none in consumer API shape, function checksums or edge sources. No application 5xx in the window.

Not in scope for this stream but seen: 4 raised hard flags `idle_paused` on jobs (`flag-recheck`, latest 1 Nov 18:50Z). These belong to the stream covering jobs.

## Deployed UAT on v2.15.401 (integrator, 2 Nov 07:05 AEDT)

**Run:** `deployed-weekly.yml` run **41343856629**, dispatched by hand on main `c9338a91` (v2.15.401), live-acting **off** (the 10 live-acting tests held).

| Project | Result |
|---|---|
| Desktop (`chromium-desktop`, @deployed) | **81 passed**, 0 failed |
| Phone (`chromium-mobile`, @deployed) | **81 passed, 1 flaky**, 0 failed: `performance-deployed.spec.mjs:27` "exact CRICOS lookup, detail, paging and browser back stay interactive" took 20.6 s on the first try and passed in 14.7 s on the retry |

**Verdict for the line "Deployed API, desktop and applicable phone UAT pass": Pass.** One phone performance test is flaky, disclosed here. It is a timing budget on the phone viewport; no function failed.

**Gate A: Pass (6 of 6).**

**Follow-up (P2):** the Monday 05:17 schedule did not fire. Check the scheduler for `deployed-weekly.yml` before next Monday.

## Deployed UAT on v2.15.403, with the admission stagger live (2 Nov 11:27–11:38 AEDT)

**Run:** `deployed-weekly.yml` run **41367254350**, main `6fab70cf` (v2.15.403, PR #795), live-acting off. Authorised by Decision 4 (2 Nov 10:56).

| Project | Result |
|---|---|
| Desktop | **81 passed**, 0 failed, 0 flaky |
| Phone | **82 passed**, 0 failed, 0 flaky |

Admission runs during the run (new minutes): adapter-overwrite 11:29, 31.3 s; coverage-admit 11:33, 48.3 s; coverage-admit-intakes 11:35, 32.9 s; provider-english-defaults 11:33, 33.2 s. **0 failures.**

**Gate A on v2.15.403: Pass (6 of 6).** The 07:00 conflict between the deployed run and admission did not recur under the stagger. This is one window; the Gate C retest windows continue.
