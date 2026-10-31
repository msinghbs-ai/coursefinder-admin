# StudySearch transformation record

**Mandate:** `2026-10-31-studysearch-transformation-mandate.md` (Platform Admin, 31 Oct 2026 10:23 AEDT; lodged verbatim).
**Owner of this record:** Claude, main integrator. Platform decisions: the Platform Admin.
**Status:** Phase 0, independent verification. Nothing in production has been changed under this mandate.
**This file is the canonical record for the programme.** Continuation files are dated and linked from here; history is never rewritten.
**Live project:** `fxcwkweaxjtknorudmwp` only.

Evidence labels used throughout:
- **Verified:** read live this session, with the query or object named.
- **Inferred:** follows from verified evidence, not observed directly.
- **Historical:** from an earlier report, not re-checked.
- **Not yet verified:** could not be checked from this session; the reason is given.

## 1. Understanding and constraints

**What StudySearch is:** the platform formerly called CourseFinder. It has three parts:
- an admin portal, the Cloudflare Worker `coursefinder-pilot`, which serves the React admin UI;
- a Supabase database with scheduled jobs (140 active `cron` jobs) and 78 edge functions;
- two consumer APIs that live integrations read every day:
  - **Website API v2** (`website-api-v2`), used by the Wix website;
  - **Zoho API v2** (`zoho-api-v2`), used by Zoho Creator and CRM;
  - plus the older routes `wix-course-api`, `website-course-api` and `zoho-course-api`.

**Protected throughout (unchanged by this programme unless separately approved):**
- consumer endpoints, routes, response shapes, keys and permissions;
- sync behaviour;
- provider and course identifiers;
- search, filter and paging behaviour;
- published visibility;
- the Worker, the Supabase project and its object names.

CLAUDE.md G3 already freezes the consumer API; the daily `consumer-api-guard` job and spec s57 enforce it. Rebranding never renames technical identifiers for its own sake.

**Standing holds carried in from the AER production-closure mandate (30 Oct):**
- no new paid entry-requirement reads;
- no B5 tranches;
- no QUT resumption;
- no automatic admission.

## 2. Phase 0 baseline (31 Oct 2026, 10:24 to 10:28 AEDT)

### 2.1 Releases and deployment parity

| Item | Finding | Label |
|---|---|---|
| Pilot `main` | `6f006619`, v2.15.375 (PR #765). No open PRs | Verified (GitHub API) |
| Deploy on merge for `6f006619` | success; Release Currentness Deployed and CourseFinder Deployed UAT (targeted) success | Verified (workflow runs `41050259514`, `41050259866`, `41050259817`) |
| Database migration head | `20261030290000` (matches main) | Verified (`supabase_migrations.schema_migrations`) |
| Consumer API baseline | 123 objects; 0 functions differ from baseline; re-taken 30 Oct 22:44:48 (D5, approved) | Verified (empty search path, as the guard runs) |
| `consumer-api-guard` job | Daily at 05:23 AEDT; last run succeeded today; 0 failures in 7 days | Verified (`cron.job_run_details`) |
| Last full deployed safe run | 30 Oct on `a8e02461` (before v2.15.375): success. A new full run on `6f006619` was started today at 10:26 | Verified; new run `41144480924` in progress |
| Worker live version string | Asserted by the green Release Currentness run. Not read directly: this session's egress proxy refuses `*.workers.dev` | Not yet verified (directly) |
| Edge functions | 78 active. Consumer functions `website-api-v2` v3, `zoho-api-v2` v5, `wix-course-api` v7 and `zoho-course-api` v14 were deployed from CI. About 20 others, including consumer `website-course-api` v3, were deployed by hand at some point | Verified (list); content parity rests on the daily Edge drift check (green 30 Oct): Inferred |
| v2.15.376 (AER course outcome register, closure decision C1) | Built on branch `cf247-v2-15-376`, not merged; its full live dry run did not complete on 30 Oct | Verified |

### 2.2 Scheduled jobs (last 24 h)

41,285 runs; 28 failed; 6 running at the time of reading.

| Job | Schedule | Result | Duration | Since | Label |
|---|---|---|---|---|---|
| `waste-guard` | hourly at :17 | 10 of 24 succeeded; 14 hit the 120 s statement limit (latest 10:17 today) in `third_party_host_v1` | Successful runs: median 115.7 s, max 119.5 s, so **every run sits at the limit** | 29 Oct 14:17 AEDT | Verified |
| `coverage-ai-match-prepare` | every 2 min | 708 of 720 succeeded; 11 timeouts (via `enrich_focus_v1` and `pipeline_num_v1`) | median 47.7 s, max 119.5 s | 29 Oct 14:30 AEDT | Verified |
| `l4-rule-low-agreement` | daily 03:37 | 0 of 1 (2 of 3 failed in 7 days; last success 28 Oct); timeout in `uni_adapter_excluded` | 120 s | 29 Oct 14:37 AEDT | Verified |
| `coverage-read-2` | every 30 s | 1,621 of 1,623; 2 "job canceled" | 0.0 s | 30 Oct | Verified, low impact |
| `website-sync-check`, `health-hourly` | every minute, hourly | All successful | `website-sync-check` median 16.8 s, max 46 s | | Verified |

**All three timeout jobs began failing within 20 minutes on 29 Oct (14:17 to 14:37 AEDT).**
- That points to one shared cause: data growth, a query-plan change or a shared helper. It is not three separate faults. **Inferred.**
- The nearest releases are #739 and #740, entry-requirement reader work merged at 13:47 and 14:00 AEDT. **Verified (GitHub merge times).** Whether they or their read load contributed is not yet known; the plan analysis will show it.
- The cause is not yet established; Phase 1 starts with plan analysis.

### 2.3 Consumer APIs (last 7 days, `pipeline.api_requests`)

| API | Calls (7 d / 24 h) | 5xx | 4xx | p50 | p95 | Label |
|---|---:|---:|---:|---:|---:|---|
| Website v2 | 1,420 / 17 | 0 | 17 (input validation, auth) | 1.6 s | 9.8 s | Verified |
| Zoho v2 | 86 / 56 | 0 | 6 | 1.3 s | 6.3 s | Verified |

**Slowest actions:**

| Action | p50 | p95 | Max |
|---|---:|---:|---:|
| Website `search` (330 calls) | 2.0 s | **13.5 s** | 17.8 s |
| Website `providers` | 2.9 s | 8.6 s | |
| Website `scholarships` | | 6.1 s | 13.5 s |
| Zoho `export` | 5.3 s | 10.4 s | |

The older routes (`wix-course-api`, `zoho-course-api`) are not logged in this table. **Not yet verified.**

### 2.4 Data and identity

| Country | Active courses | Bound page | Bound with stored copy | Mismatch | Ambiguous | No page | Manual bindings |
|---|---:|---:|---:|---:|---:|---:|---:|
| AU | 25,380 | 18,225 (71.8%) | 17,201 | 3,907 | 1,433 | 1,815 | 1,115 |
| NZ | 6,495 | 3,230 (49.7%) | 3,015 | 2,567 | 3 | 695 | 920 |
| CA | 3,814 | 3,057 (80.2%) | 2,732 | 748 | 4 | 5 | 778 |

**Verified** (`pipeline.coverage_course_pages`, `pipeline.evidence_artifacts`). Binding *precision* is not yet verified: the TD1 sample of shared and unproven bindings has not been run.

### 2.5 Human review (Layer 4)

**1,141 pending.** **Verified** (`pipeline.layer4_review_items`).

| Kind | Pending | Age | Decided in 7 days |
|---|---:|---|---:|
| Course entry first read (AER) | 953 | all < 2 days | 44 |
| Provider tuition validation | 75 | 71 at 2–7 days, 4 at 7–30 days | 413 |
| No page, first run | 55 | < 2 days | 78 |
| Provider table, first run (AER) | 41 | 26 < 2 days, 15 at 2–7 days | 38 |
| Others (conjoint rule, course URL, English, AER change, tuition) | 17 | | |

**First human AER review session, 31 Oct 01:29 to 02:10 AEDT:**
- **Decided:** 57 items: 56 approved (13 of them with edits) and 1 rejected.
- **Measured pace:** 42.5 s per item.
- **Result now live:**
  - 179 course-level rows active for 44 courses (previously 0);
  - 628 provider-table rows active for 13 providers (previously 343, RMIT only).
- **Verified through the consumer path:** for example, `public.website_v2_course` for `0100714` now returns `min_score` 73 with basis "2026 ATAR".
- **Remaining AER effort at the measured pace:** about 997 items × 42.5 s ≈ **11.8 h**. This is an estimate from one session.

### 2.6 Cost (7 days, AI)

| Use | US$ |
|---|---:|
| Enrich fields | 13.98 |
| Entry tables | 1.69 |
| Course matching | 0.62 |
| **Total** | **about 16.30** |

**Verified** (`field_enrich_items`, `entry_matrix_runs` and `coverage_ai_match` cost columns, by UTC day). Daily spend peaked at US$7.02 on 29 Oct.

**Cost is not the constraint; yield is.**
- 30 Oct diagnostic: AU enrich 811 values filled from 34,429 window items. **Historical.**
- Firecrawl credit use and account-level guards: **Not yet verified.**

### 2.7 Security advisers (30 Oct 23:26 UTC lint)

**Verified** (Supabase advisers):

| Finding | Count | Detail |
|---|---:|---|
| Callable without signing in | 1 | `public.admin_ui_error_report` (an error reporter; it may be meant to work before sign-in; to be confirmed) |
| Mutable search path | 2 | `security.provider_presentable_name`, `security.place_presentable` |
| Callable by signed-in users | 169 | |
| RLS enabled, no policy | 421 (INFO) | |

**The 169 functions callable by signed-in users are expected for this admin portal,** because each is meant to check the caller's role inside.
- D6 (30 Oct) proved that such a check can silently not apply: any signed-in user could read `admin_adapter_measures`.
- **A sampled audit of these checks is warranted. Inferred.**

### 2.8 Consumer data presentation

**Finding:** `entry.min_score` carries one score per course. **Verified** (`public.website_v2_course`; `catalogue.course_entry_requirements`).
- For 24 of the 41 courses with admitted scores, the page publishes several: ATAR, IB, A Level, pathway programmes.
- The API returns one of them, with its basis. Course `0101331` returns `min_score` 26, basis "International Baccalaureate Diploma Programme 26", while ATAR 75 is admitted but not returned.
- **The reply is truthful but incomplete.**
- Exposing all of them needs an additive consumer field, so it is a G3 approval matter.

### 2.9 Branding dependencies (first scan)

| Where | Finding | Classification |
|---|---|---|
| Admin UI text (`src/`) | No user-visible "CourseFinder" string found; 20 files already say "StudySearch" | User-facing: largely done |
| Browser storage keys and events (`coursefinder:pim:…`, `coursefinder:provider-logo-refresh`, 6 files) | Renaming would reset every user's saved screen choices | Technical: retain |
| Release history text (v2.15.79 and earlier) | Historical | Retain |
| Worker name `coursefinder-pilot`, host `coursefinder-pilot.techm.workers.dev` | Deployment identifier; deployed tests and the release check use the host | Assess dependencies before any change |
| Repositories `coursefinder-admin`, `Coursefinder-Pilot` | Referenced by CI, docs and agents | Propose separately; no rename |
| Database (`catalogue`, `pipeline`, `security`), edge functions, API names | Technical and consumer contracts | Retain |
| Admin docs | 622 files mention CourseFinder, 65 mention StudySearch; most are historical records | Active docs: controlled update; history: retain |

**Verified** (repository grep, 31 Oct). The inventory is not yet classified file by file.

## 3. Highest-priority findings

| # | Finding | Impact | Label |
|---|---|---|---|
| F1 | Three scheduled jobs time out at 120 s since 29 Oct; `waste-guard` runs at the limit even when it succeeds | Waste detection and AI-match preparation are unreliable; failures hide real work | Verified |
| F2 | Website `search` p95 13.5 s, `providers` p95 8.6 s | Slow pages on the live website | Verified |
| F3 | AER review is the main consumer-value lever, now measured at 42.5 s per item; about 12 h of review remain | Each approved provider table answers for all of that provider's courses | Verified (pace); Inferred (remaining effort) |
| F4 | Page identity: NZ 49.7% bound; 7,222 mismatches across AU, NZ and CA; binding precision not sampled | Ceiling for every course field | Verified (counts); Not yet verified (precision) |
| F5 | `min_score` returns one of several published scores for 24 of 41 courses | Incomplete consumer data | Verified |
| F6 | One anonymous-callable admin function; 2 mutable search paths; role checks inside 169 functions not audited | Security hygiene | Verified (lint); Inferred (risk) |
| F7 | About 20 edge functions were deployed by hand; parity rests on the drift check | Traceability | Verified (origin); Inferred (risk) |
| F8 | Admin INDEX last updated 26 Oct | New agents read a stale state | Verified |

## 4. Phased roadmap

**Phase 0: independent verification (today).** Finish the baseline:
1. **F1:** `EXPLAIN` plans, without `ANALYZE`, on rolled-back samples of the three timeout jobs; establish the shared cause.
2. **F2:** search plans.
3. Result of the full deployed safe run `41144480924`.
4. Firecrawl spend.
5. **F8:** INDEX reconciliation, a governance-only change.

**Phase 1: immediate stabilisation (small, reversible, one change each):**
- **F1 fix:** an index or query fix inside the failing *pipeline* functions, decided by the plans. Never a raised timeout.
- **Ship v2.15.376,** the AER course outcome register (already built, additive, admin-only). It gives operators one outcome per course and an hourly coverage history.
- **TD2:** stop mismatch and no-copy pages from queueing futile Enrich attempts.
- **F6:** decide on `admin_ui_error_report`; fix the 2 search paths; sample 20 role checks.

**Phase 2: efficiency and automation:**
- **TD1:** binding precision sample, then course-specific proof gates.
- **TD3:** bounded, count-guarded recovery of withdrawn values.
- **TD4/TD5:** reports that separate admissions, withdrawals, source-silent, wrong-page and no-copy states.
- **A yield measure:** admitted values per US$ and per review hour, replacing run counts.

**Phase 3: StudySearch rebranding (presentation and active documentation first):**
- Complete the file-by-file classification from §2.9.
- Retain storage keys, schema, API and deployment names.
- Propose the Worker display name and the repository names separately, with a dependency check first.

**Phase 4: operational maturity:**
- Service-level targets from the observed baselines above, for example:
  - mandatory jobs: 0 timeouts in 7 days;
  - Website search p95 under an agreed figure;
  - review queue age under an agreed figure.
- Runbooks per automation (owner, health signal, stop condition, recovery).
- Weekly report.
- Spend forecast.

## 5. Approvals required (genuine gates)

| Item | Why it is a gate |
|---|---|
| Any change inside a consumer API function (for example, rewriting `website_v2_course_search` for speed, F2) | G3: the consumer API is frozen. An index on the tables it reads changes no shape; whether it counts as "beside" or needs approval is your call |
| An additive field for all published entry scores (F5) | G3 consumer change: paste file and your explicit approval |
| Revoking anonymous access to `admin_ui_error_report` | Could stop error reports from the sign-in page; confirm the intent first |
| Lifting any ingestion hold (QUT, B5, recovery reads) | Spend and review-load gate from the closure mandate |
| Worker or domain rename; repository rename | Infrastructure and integration dependencies |
| Drops or deletes | Paste files only (CLAUDE.md) |

## 6. Activity log

- **10:24 to 10:28 AEDT:** Phase 0 read-only baseline (sections 2.1 to 2.9).
- **10:26:** dispatched the full deployed safe run on `6f006619` (`deployed-weekly.yml`, run `41144480924`; live-acting specs held, as default).

## 7. F1 root cause (Phase 0, verified 10:28 to 10:33 AEDT; rolled-back dry runs only)

**`waste-guard`** runs `security.waste_guard_v1()`, which is `waste_idle_guard_v1` (30 ms), `waste_flipflop_guard_v1` (16 ms) and `enrichment_flags_refresh_v1`. The last one takes essentially all of the 115 to 120 s. **Verified** (timed in a rolled-back transaction).

**Cause:** provider-level checks are evaluated once per row, not once per provider. **Verified:**

| Section of `enrichment_flags_refresh_v1` | Per-row check | Rows | As written | Check computed once per provider | Same result |
|---|---|---:|---:|---:|---|
| Outside focus (AU courses with gaps) | `enrich_focus_v1(provider)`, about 0.9 ms a call | 9,145 courses | 13.2 s | **3.8 s** | 9,145 = 9,145 |
| Page not found (`coverage_ai_match` grouped by course) | `course_search_off_v1(provider)`, about 1.1 ms a call | 53,807 rows | **over 28 s** (stopped at the test cap) | **11.0 s** | 6,475 courses (the new form; the old form could not finish inside the cap) |

The two clearing updates repeat the pattern over open flags (25,933 open, 86,176 in total).

**Why it started on 29 Oct:** `coverage_ai_match` grew 8% since then (49,730 → 53,807 rows). Successful runs already took a median of 115.7 s. The job did not break suddenly; it crept up to the 120 s limit. **Inferred** from the growth and the at-limit timings.

**Planner note:** written as a plain subquery or CTE, the per-provider step is folded back into the per-row join and gains nothing; it timed out in both forms. It must be `MATERIALIZED`. **Verified.**

**`coverage-ai-match-prepare`:**
- `coverage_ai_match_prepare_v1` has the same flaw: `enrich_focus_v1`, `course_list_read_v1` and `bind_match_scope_v1` are evaluated for every active course in its "missing" step.
- Median 47.7 s, spikes to 120 s. **Verified** (definition md5 `b7db293c`); fix not yet timed.

**`l4-rule-low-agreement`:**
- A different shape: `l4_rule_low_agreement_v1` runs `adapter_qualify_one_v1` for every enabled adapter in one daily call. It times out in `uni_adapter_excluded`, called per course and field.
- It needs bounded batching across runs (a setting), not the per-provider fix. Lower priority: a daily rule, last success 28 Oct. **Verified** (definition).

**Proposed F1 change (Phase 1, one release):**
- Rewrite the per-row provider checks in `security.enrichment_flags_refresh_v1` (md5 `ae577625`) and `security.coverage_ai_match_prepare_v1` (md5 `b7db293c`) as a `MATERIALIZED` per-provider map, joined back.
- Same rules, same writes, same settings; md5-guarded.
- **Proof of identical output:** in one rolled-back transaction, run the old and the new form, capture the rows each would write, and compare them exactly.
- Not touched: the timeout, the schedule, any consumer object.
- `l4-rule-low-agreement`: designed separately.

## 8. Progress (31 Oct, from 10:33 AEDT)

### 8.1 Full deployed safe run on current main: passed

**Run `41144480924`** (`deployed-weekly.yml` on `6f006619`, started 10:26). **Verified** (`deployed-weekly-results` branch, `weekly/2026-10-31.md`):
- desktop 80 of 80 passed;
- phone 81 of 81 passed;
- 0 failed, 0 skipped;
- 10 live-acting specs held (switch off, as default).

### 8.2 F1 fix built and proven (v2.15.377 candidate, not yet merged)

Migration `20261031010000_cf247_f1_provider_checks_once` makes md5-guarded edits:

| Function | md5 | Change |
|---|---|---|
| `security.enrichment_flags_refresh_v1` | `ae577625` → `3bbec96c` | 4 provider checks |
| `security.coverage_ai_match_prepare_v1` | `b7db293c` → `ab2dd5dc` | 3 provider checks in one scope list |

**Each check now runs once over a materialised list of distinct providers.**
- A first attempt with a plain `IN (select … where check)` was still slow. Postgres pushes the check below the `DISTINCT`, so it runs per row again.
- The list is therefore materialised first, then checked. **Verified.**

**Equality, old against new (rolled back):**

| Section | Old | New | Differences |
|---|---:|---:|---:|
| Outside focus (all AU courses) | 9,145 | 9,145 | 0 |
| Page not found (17,888 AI-match rows, 400 providers*) | 2,128 | 2,128 | 0 |
| Clear outside-focus flags (check inverted for a non-empty set) | 11,297 | 11,297 | 0 |
| Clear page-not-found flags (check inverted) | 5,932 | 5,932 | 0 |
| AI-match provider scope (6,799 courses, 300 providers) | 142 | 142 | 0 |

*The old form cannot finish the whole table inside a 28 s test window. That is the defect itself.

**Timings (rolled back, job arguments):**

| Function | Before | After |
|---|---:|---:|
| `enrichment_flags_refresh_v1` | 115–120 s | **15.3 s** |
| `coverage_ai_match_prepare_v1` | median 47.7 s | **19.4 s** |

The remaining 19 s is per-course logic that cannot be hoisted (page-match bonus, no-page hold). It is now well inside the 2-minute schedule.

**Spec s186** guards it. It checks:
- md5 pins;
- materialised provider lists only;
- no per-row provider check;
- the same truth table;
- no time-out, schedule, setting, data or consumer change.

### 8.3 v2.15.376 (course outcome register): shipping

- **Live dry run (rolled back, 10:41):**
  - 31,875 courses equal to the in-scope count; built in 4.5 s;
  - admitted-course 44 = 44 courses with active rows.
- **Local full suite:** 1,279 / 0 / 0.
- **Change control:** admin `352b5d17`.
- **PR:** #766, opened by the ship step at 10:47.

### 8.4 v2.15.376 live (verified 10:49 AEDT)

- **Merge:** PR #766 squash-merged as `43f30791`.
- **Post-merge workflows, all success:** Deploy on merge, Release Currentness Deployed, CourseFinder Deployed UAT (targeted, runs s185), Release History Contract.
- **Live:**
  - migration head `20261030300000`;
  - `pipeline.aer_course_outcomes` holds 31,875 rows; first build by the migration at 10:48:54, taking 18.7 s;
  - job `aer-outcome-register` is active and catalogued;
  - `anon` cannot execute `public.admin_aer_outcomes`;
  - the read returns 31,875.

**Course outcome register, first live build:**

| Outcome | Courses |
|---|---:|
| Excluded (outside the read scope, or reads held) | 10,423 |
| Identity unresolved or mismatched | 10,230 |
| Awaiting Layer 4 review | 4,924 |
| Admitted provider resolution | 3,840 |
| No official course URL | 2,327 |
| Verified: no requirement on the page | 80 |
| Admitted course requirement | 44 |
| Source unreadable | 7 |

### 8.5 F6 narrowed

`public.admin_ui_error_report` refuses any caller without a signed-in user before writing ("sign in required", 42501). **Verified** (definition).
- The anonymous `EXECUTE` grant is therefore harmless.
- Revoking it is hygiene with no behaviour change: it is within standing authority and no longer an approval gate.
- It will ship with the two search-path fixes in a later hygiene release.

### 8.6 F2 (search latency): first timings

Direct database timings of `public.website_v2_course_search`, page 1 of 20 (31 Oct 10:48):

| Search | Time |
|---|---:|
| No filters | 3.5 s |
| AU only | 3.0 s |
| Keyword "business" | 3.8 s |
| "nursing" in Melbourne | 2.3 s |
| Narrow filter sets | 0.9 s |

The API p95 is 13.5 s, so most of that time is outside these single calls (edge function, concurrency, cold paths). **Not yet verified** where. Any change inside the function is a G3 approval matter.

### 8.7 F2: probable main cause, cross-region round trips

| Fact | Evidence |
|---|---|
| The database is in **`ap-south-1` (Mumbai)** | `get_project`: region `ap-south-1`. **Verified** |
| Website calls come from Wix servers in Virginia (`asOrganization` Wix.Com, `cf.region` Virginia); the edge function runs in **`us-east-1`** (`x_sb_edge_region`) | Edge log attributes, `website-api-v2` deployment v3. **Verified** |
| Edge execution, logged sample of 17 calls | p50 4.4 s, p95 5.4 s, max 6.5 s. **Verified** (`function_edge_logs`, last 24 h) |

**Inferred:**
- Every database call the function makes crosses between Virginia and Mumbai, probably over 200 ms each way.
- The API's 13.5 s p95 for `search` is broad-search query time (3 to 4 s) plus several cross-region round trips per request (key check, rate limit, query, usage log), plus load.
- **Round trips per request (verified, `supabase/functions/website-api-v2/index.ts` at `43f30791`):**
  1. `website_api_v2_auth` (line 102);
  2. `website_api_v2_rate` (line 115);
  3. the action's function (line 168);
  4. logo URL signing in Storage, when logos are returned (line 60);
  5. `website_api_v2_log` (line 85), which is **awaited before the response is sent**.

  That is 4 to 5 sequential calls from `us-east-1` to Mumbai on every request.

**Options (all need the Platform Admin, G3, and the website team where the caller changes):**
1. Run the function in the database's region: Supabase supports choosing the invocation region per request (an `x-region` header) or in the calling client. The Wix backend would send it. No response changes.
2. Reduce the round trips inside `website-api-v2`: send the usage log after the response (`EdgeRuntime.waitUntil`) and fold auth and rate into one call. This is an edge-function change to a consumer object, with no response change.
3. Make broad searches cheaper in the database: an index or plan work beside the consumer tables; possibly within authority.

**Recommendation:**
- Measure the round-trip count first (read the function code; one rolled-back timing per step).
- Then option 1 is the smallest change with the largest effect. It changes no contract, but the caller must send the region, so the website team is involved.

### 8.8 v2.15.377 (F1) live and verified (11:19 AEDT)

- **Merge:** PR #767 squash-merged as `5dc76dcc`.
- **Post-merge workflows, all success:** Deploy on merge `41148001770`, Release Currentness Deployed `41148001766`, CourseFinder Deployed UAT `41148001785`, Release History Contract, Pilot Frontend Build.
- **Live:** migration head `20261031010000`; `enrichment_flags_refresh_v1` `3bbec96c`; `coverage_ai_match_prepare_v1` `ab2dd5dc`.
- **Change control:** admin `89ca7882`.

**Before and after (`cron.job_run_details`, verified):**

| Job | Before | After the deploy (about 11:03) |
|---|---|---|
| `waste-guard` | 09:17 and 10:17 failed at 120.0 s; 08:17 succeeded in 119.1 s; 14 of 24 failed on 30–31 Oct | **11:17 succeeded in 25.8 s** |
| `coverage-ai-match-prepare` | median 47.7 s, runs of 109.4 s, 11 time-outs in 24 h | 11:04 37.3 s; 11:06 21.0 s; 11:08 26.2 s; 11:10 27.1 s |

**Acceptance (from the mandate's definition of success):** `waste-guard` and `coverage-ai-match-prepare` are to have 0 time-outs over the next 24 h and 7 days. They are re-checked in the next session and the Monday report.

**Still open from F1:** `l4-rule-low-agreement` (daily, a different shape; needs batching across runs). It is designed next.

### 8.9 F1c: `l4-rule-low-agreement`, a decision for the Platform Admin (not implemented)

**Measured (rolled back, 11:21):**
- `security.l4_rule_low_agreement_v1` runs `adapter_qualify_one_v1` for each of **1,185 enabled adapters** in one daily call.
- The first 8 averaged 45 ms (max 101 ms).
- The whole call exceeds the 120 s limit: last success 28 Oct; failed 29 and 30 Oct.

**It admits data.** When an adapter reads a field on at least half the pages and agrees with held values on fewer than 90%, it sets `admit = true` for that field ("Rule 4 (daily): low agreement, page wins") and starts an adapter apply.
- **Since 29 Oct no Rule 4 admission has happened**, because the job fails before finishing.
- Fixing the time-out restarts automatic admissions. That is why this needs your decision, not a routine fix.

**Option (proposed):**
- Each run qualifies the next bounded slice of adapters: a cursor and a setting `batch.l4_rule_low_agreement_adapters`, for example 300.
- The job runs 4 times a day, so every adapter is still checked daily. The rule itself is unchanged.
- **Alternative:** leave it failing until the rule's value is reviewed; record it as paused, with a catalogue note so the failure is not noise.

### 8.10 F6: decisions (11:25 AEDT)

- **Mutable search path, 2 functions: accepted, not changed.**
  - `security.provider_presentable_name(text)` and `security.place_presentable(text)` are `IMMUTABLE`, `SECURITY INVOKER` SQL helpers.
  - They are called by consumer functions, per row in searches:
    - `website_edge_course_search_v1`, `website_edge_scholarship_search_v1`;
    - `website_v2_providers`, `website_v2_rankings`;
    - `api.website_v2_course_item`, `api.website_v2_scholarship_item`, `api.website_v2_provider_campuses`, `api.website_v2_reference_build`.
  - **Verified** (definitions and `consumer_api_functions_v1`).
  - A `SET search_path` clause stops Postgres inlining a SQL function, which could slow consumer search. The lint's risk is low for invoker-rights helpers that run with the caller's own rights. **Inferred.**
  - Left as they are; listed here as accepted, with the reason.
- **`admin_ui_error_report` anonymous grant:** to be revoked as hygiene in the next functional release (no behaviour change, §8.5). Not worth a release of its own.
- **169 functions callable by signed-in users:** a sampled role-check audit stays in the Phase 2 list.
- **Documentation gap:** `SYSTEM-REFERENCE.md` §4b (Website API v2) was last updated on 15 Oct and does not describe the entry-requirement fields (`edu_country`, `entry`, `entry_matrix`, `scale_stated`). To be refreshed in the Phase 3 documentation pass.

### 8.11 Phase 2 TD1 (binding precision): live measure and sample (11:23 AEDT, read only)

**Bound pages without proof (active courses; `pipeline.coverage_course_pages`), verified:**

| Country | Bound | No identity basis | No stored copy | Neither | Pattern-guessed, unproven | On a URL shared by 3+ courses (automatic) | Shared URLs |
|---|---:|---:|---:|---:|---:|---:|---:|
| AU | 18,225 | 1,068 | 1,024 | **1,024** | 98 | **983** | 240 |
| NZ | 3,230 | 242 | 215 | **215** | 121 | 28 | 10 |
| CA | 3,057 | 332 | 325 | **325** | 168 | 14 | 9 |

**Sample:** the 30 most-shared automatic URLs. Classified by address and the course titles bound to them; a person should confirm each against the page.

| Class | URLs | Bindings | Examples |
|---|---:|---:|---|
| Legitimate shared course page (one page for several variants) | 13 | about 160 | UWA, UTS, Federation, UOW, Adelaide and JCU PhD/MPhil pages; RMIT Science honours; Collarts fashion double degree; Murdoch B1411 |
| Fee table matched by its CRICOS list | 5 | 58 | USC 2026 **and 2025** fees; CSU course fees; UNE 2026 and 2027 fees |
| Provider course list, international or ESOS page | 9 | 68 | TasTAFE `/international` (16); AIM `/courses`; IIPM `/courses`; Harward; MEI ELICOS; Envirotech; Friends' School; UNSW College `/esos` |
| Application form | 1 | 6 | AEI application form |
| No identity proof, not a course page | 3 | 27 | Whitireia **graduation event page (12 courses)**; `stapps.cdu.edu.au/f` (8); Auckland catalogue browse page (7) |

**About 17 of 30 sampled shared URLs (57%) are not course pages.** Each serves its bound courses as their "official course page" and as the source page for their fields. **Inferred** from the sample; a person-checked sample of 50 is still the agreed gate (30 Oct diagnostic TD1).

**Proposed gate (decision for the Platform Admin; not implemented):**
1. `bound` requires an identity proof, or a stored copy with the course's code or exact title on it. Bindings with neither (1,564) return to search; manual bindings are untouched.
2. A page shared by 3 or more courses is bound only when the page names each course (code or exact title). Fee lists, course lists and application or ESOS pages are found by URL pattern, kept as **fee sources**, and stop being the course page.
3. **Bounded and reversible:** count-guarded, by country, one provider at a time; a dry-run list first. Values admitted from these pages are reviewed, not deleted (CLAUDE.md: nothing deleted by a migration).

**Why it matters:** the page binding is the ceiling for every course field. The 30 Oct diagnostic found most CA and NZ paid reads ended "mismatch". Precision should come before any spend increase.

## 9. Phase 3 plan: StudySearch rebranding (classification, 31 Oct 11:25 AEDT; nothing renamed yet)

**Naming rule:**
- **StudySearch** is the platform's name. **CourseFinder** is its former name.
- **"Course Finder"** (two words) is also the name of a *website feature*, alongside University Finder and Scholarship Finder (developer guide §1, §7.2). It is not the old platform name and is **never renamed**.

**Inventory, verified by repository grep on 31 Oct:**

| Where | References | Classification | Action |
|---|---|---|---|
| Admin UI text (`src/`) | Browser title is already "StudySearch PIM Admin"; no screen shows "CourseFinder"; 20 files say StudySearch | User-facing | Done. A guard test against "CourseFinder" in visible strings is added in Phase 3 |
| Browser storage keys and events (`coursefinder:pim:…`, `coursefinder:provider-logo-refresh`, 6 files) | Technical | Retain: renaming resets every user's saved screens and columns |
| Release history before v2.15.80 (`src/release-history-legacy.js`) | Historical | Retain |
| Pilot `package.json` / `wrangler.jsonc` name `coursefinder-pilot`; Worker host `coursefinder-pilot.techm.workers.dev` | Deployment identifiers | Retain. A display name or custom domain is a separate, dependency-checked proposal (deployed tests, the release check and the CI base URL use the host) |
| Pilot `supabase/` (227 files: migrations, functions) | Applied migrations are history; object names are technical | Retain. Never edit applied migrations |
| Pilot `tests/` (30), `.github/` (8), `docs/` (7) | Mostly technical identifiers (base URL, repo names) | Retain identifiers; reword prose in Phase 3 |
| Repositories `coursefinder-admin`, `Coursefinder-Pilot` | Referenced by CI, docs, agents and project instructions | Propose separately. No automatic rename |
| Supabase project name `coursefinder_Pilot` | Display name only | A cosmetic rename is possible; propose with the repository question |
| Admin `change-control/` (114 files), `project-runsheets/` (44), `docs/daily-updates/` (31), `docs/uat/` (75) | Historical records | Retain (audit history is never rewritten) |
| Admin `docs/platform/` (40), `docs/integrations/` (6), `docs/01-governance/` (3), other active guides | Active documentation | Controlled update in Phase 3: "StudySearch (formerly CourseFinder)" on first mention, then StudySearch; technical names kept in code formatting |
| Developer pack | Already "StudySearch Website API v2"; "Course Finder" there is the website feature | No change |
| Consumer APIs, database schemas, edge functions, secrets, environment variables | Contracts and technical names | Retain (G3; mandate §2) |

**Phase 3 order:**
1. Active admin docs and the README/INDEX headings (documentation only).
2. A UI guard test.
3. Report and dashboard headings. The hourly report is already "StudySearch hourly stats".
4. Proposals for the Worker display name, a custom domain and repository names, each with a dependency list, for the Platform Admin.
