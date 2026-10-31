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

## 10. Platform Admin decisions (31 Oct 2026, 11:24 to 11:30 AEDT, answered in session)

**Standing rule (Platform Admin, 31 Oct 2026 11:24):**
> "Consumer APIs require handover documentation and version control to avoid any confusions as previously created."

Every consumer API change, including ones that change no response field (region, timing, routing, caller behaviour), ships with:
- a developer guide issue with a version line (§13);
- a dated handover note for the website or Zoho owner saying what changes on their side, if anything;
- the Pilot release version and change-control reference;
- the consumer-API baseline re-taken with its approval line.

Nothing reaches a consumer without its document and version.

| # | Decision | Answer | What happens now |
|---|---|---|---|
| F2 | Website search latency | **Measure more first** | Time each step of a live request: the database time of auth, rate, the action and the log against the edge time. No change yet |
| F5 | All published entry scores (`min_scores[]`) | **Decide after more review** | No consumer change. Revisit when more courses are admitted |
| F1c | Rule 4 "low agreement, page wins" (automatic adapter admission) | **Keep paused, review first** | Pause the job on purpose and mark it paused in the job catalogue, so its failure is no longer an incident. Its value is reviewed before any restart. No automatic Rule 4 admission happens meanwhile |
| TD1 | Binding precision gate | **Dry-run list, then decide** | A provider-by-provider list of the bindings the gate would release, read only. The Platform Admin approves per country before anything is unbound. Manual bindings are never touched |

### 10.1 TD1 dry-run list (read only, 31 Oct 11:30 AEDT): the gate needs a third outcome

Under the §8.11 rules the gate would release **1,819 automatic bindings**:

| Country | Providers | Rule 1 (no identity, no stored copy) | Rule 2 only (shared non-course page) |
|---|---:|---:|---:|
| AU | 208 | 989 | 292 |
| CA | 11 | 325 | 0 |
| NZ | 28 | 213 | 0 |

The 3,027 manual bindings are untouched. **Verified.**

**Largest providers:**
- **Rule 1:** Alberta 157 (url_pattern), Macquarie 104, Monash 100, Victoria (CA) 85, UNSW 83, UTas 73, Manukau 70 (url_pattern), Flinders 61, UBC 54, NorthTec 51 (url_pattern), Newcastle 45, Melbourne 44.
- **Rule 2:** USC 36, UNE 16, CSU 16, TasTAFE 13.

**Finding: rule 1 is "unverified", not "wrong".** Its largest groups are course-shaped addresses on the provider's own course or handbook paths, which were never read, so there is no copy to prove identity:
- `coursehandbook.mq.edu.au/2026/courses/C000012`;
- `monash.edu/study/course/A3701`;
- `handbook.unsw.edu.au/postgraduate/programs/2026/5037`;
- `handbook.flinders.edu.au/courses/2026/baf`;
- `handbook.unimelb.edu.au/2026/courses/364aa`;
- `manukau.ac.nz/programme/…`.

Others are clearly not course pages:
- `experts.griffith.edu.au/…/teaching` (a staff profile);
- `livingheritage.lincoln.ac.nz/assets/download/647`;
- `auckland.ac.nz/arts-grad-careers-news`;
- `myportal.actheology.edu.au/FileDownload/…`;
- `international.cit.edu.au/about/faq/…`;
- `tastafe.tas.edu.au/contact`;
- `whitireia.ac.nz/…/graduation/…`.

**Revised gate (for the Platform Admin's decision per country; still not implemented):**

| Outcome | Rule | Action |
|---|---|---|
| **Release** | No identity and no copy, *and* the address is not a course or programme path of the provider (profiles, news, downloads, FAQs, contact, events, portals) | Back to search |
| **Verify** | No identity and no copy, on a course-shaped path | Keep bound. Read once through the existing read lane, then prove identity. This is a paid read, held under the closure mandate's ingestion hold until you lift it for this purpose |
| **Re-role** | Shared by 3+ courses on a fee, course-list, application or ESOS page | Stop being the course page; keep it as a fee source where it is one |

**Next step:**
- A provider-by-provider dry-run with the three outcomes. It needs a course-path pattern per provider: the provider's own course URL shape from its bound, proven pages.
- **Then:** you approve per country; the verify reads need the spend hold lifted for them.

### 10.2 Platform Admin decisions, full text (31 Oct 2026 11:28 AEDT; supersedes the short answers in §10 where they differ)

> **StudySearch — Platform Admin Decisions.** Proceed under the existing operating model and record these decisions in `coursefinder-admin` before further execution.
>
> **F2 — Website search performance.** Decision: Measure more first. Do not modify the consumer API, routing, headers or deployment region yet.
> - Measure the latency contribution of each database call, network round trip, authentication check and usage-log operation.
> - Compare execution from US East and Mumbai using equivalent workloads.
> - Evaluate database query optimisation, regional execution and reducing sequential calls.
> - Present before-and-after estimates, implementation risk and the recommended smallest effective change.
>
> Any consumer API change must include a developer-guide issue, version line, compatibility assessment and handover note. Preserve Website and Zoho functionality.
>
> **F5 — Multiple published entry scores.** Decision: Review before approving. Do not add the proposed field yet.
> - Investigate the 24 affected courses, confirm whether all published scores are valid alternatives, and examine their source evidence and consumer presentation requirements.
> - Propose an additive, backwards-compatible structure that preserves the existing entry-score field. Include examples for ATAR, IB and other applicable qualifications.
> - Return the proposed schema, sample API response and consumer impact for approval.
>
> **F1c — Automatic adapter admission.** Decision: Keep paused; review first. Do not restart automatic admissions or simply increase the execution timeout.
> - Review the 1,185 adapters, assess Rule 4 decision quality, and determine which adapter outputs are safe for automatic admission.
> - Design bounded batching, checkpointing, failure recovery and validation without enabling automatic admission.
> - Present a dry-run analysis, expected impact and controlled activation proposal for approval.
>
> **TD1 — Unproven course-page bindings.** Decision: Produce a dry-run list, then decide. Do not mass-rebind, delete or invalidate existing records.
> - Generate an evidence-based list of the 1,564 bound pages without identity proof or a stored copy. Classify shared URLs, generic pages, suspected mismatches and potentially valid pages.
> - Include provider, course, URL, binding method, evidence status, proposed action and risk classification.
> - Provide the projected impact on course coverage and existing admitted values. Preserve manual bindings and historical provenance.
> - Await approval before executing binding corrections.
>
> **Execution and reporting.**
> 1. Record all four decisions in the existing StudySearch transformation record in the Admin repository.
> 2. Continue authorised, read-only investigations and routine operational work.
> 3. Before each material action, explain what you will do, why, expected impact and rollback considerations.
> 4. Provide progress updates throughout the session, showing completed work, findings, current activity and next action.
> 5. Commit investigation results, evidence and recommendations to Admin.
> 6. Do not treat these decisions as permission to make consumer API changes, reactivate admissions or perform mass corrections.

**How the work maps to these decisions:**

| Decision | Authorised now (read only or routine) | Held for approval |
|---|---|---|
| F2 | Per-step latency measurement: database time of `website_api_v2_auth`, `_rate`, the action and `_log`; edge execution time from logs; the cross-region estimate. The Mumbai-versus-US-East comparison needs an invocation from each region (a read-only probe call with a scoped key), so it is planned and asked for before it runs | Any change to the edge function, routing, headers or region |
| F5 | Review of the 24 courses: evidence quotes, stored copies, whether each score is an alternative entry route; a proposed additive `min_scores[]` schema with ATAR, IB, A Level and pathway examples, a sample response and consumer impact | Adding the field |
| F1c | Dry-run Rule 4 analysis over the 1,185 adapters, in bounded slices: which fields it would admit, agreement and read shares, a sample against pages; a batching, checkpoint and recovery design with admission disabled | Any reactivation or admission |
| TD1 | The full per-binding dry-run list of the 1,564 (and the shared-URL group), with every field asked for, the classification and the risk; projected impact on coverage and on admitted values | Any binding correction |

**About F1c and the prepared release:**
- v2.15.378 (built, held, not pushed) would set the already-failing job `l4-rule-low-agreement` to inactive.
- It would also correct its catalogue description, which wrongly says it "sends values to review" (it admits), and remove the harmless anonymous grant (F6).
- It restarts nothing and admits nothing; it makes "paused" explicit instead of a daily failure.
- **It is a production change, so it waits for the Platform Admin's go-ahead (rule 3 above).**

## 11. Execution register (from 31 Oct 2026 11:32)

**From here on, work is tracked by StudySearch task ID** in the single canonical register `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md` (Platform Admin, 31 Oct 2026 11:32).
- This record keeps the evidence, cited by the register.
- The F/TD identifiers above remain as references.
- New entries in this record lead with the SS task ID.

## 12. SS-007 (ref TD1): binding identity audit, dry-run list (31 Oct 2026 11:34 AEDT, read only)

**The list:** `docs/platform/ui-audit/2026-10-31-ss007-td1-binding-dry-run.csv`, 2,377 rows. It holds every automatic binding of an active course that is either unproven (no identity basis and no stored copy: the 1,564) or on a URL shared by 3 or more courses. Manual bindings are excluded and untouched.

**Columns:** country, provider, course code and title, URL, binding method, identity basis, stored copy, read status, courses on the URL, classification, proposed action, risk, admitted page fields, official URL admitted, course id.

**Source:** one read-only query over `pipeline.coverage_course_pages`, `catalogue.courses`, `catalogue.providers` and `pipeline.course_attribute_coverage` (live, 11:33).

| Classification | Proposed action | Risk | AU | NZ | CA | Total |
|---|---|---|---:|---:|---:|---:|
| Generic or wrong page (profile, news, download, FAQ, contact, event, portal, search, policy) | **Release** to search | Low | 106 | 38 | 10 | **154** |
| Potentially valid, never read (course-shaped path on the provider's site) | **Verify** (read once, then prove identity) | Medium | 700 | 140 | 172 | **1,012** |
| Suspected mismatch, unclassified by address | **Person-check** | High | 176 | 32 | 143 | **351** |
| Shared list, fee, enrolment or application page (3+ courses) | **Re-role** (stop being the course page; keep as a fee source where it is one) | Medium | 299 | 3 | 0 | **302** |
| Shared course page (one page for variants, with identity) | **Keep** | None | 555 | 3 | 0 | **558** |

**Spot checks (8 random rows per class):**
- **Release:** all 8 not course pages (newsletter redirect, staff profile, magazine, portal downloads, search results, figshare file).
- **Verify:** about 6 of 8 real course pages; 2 wrong (CIT English course on a nursing page; a course-category page). This is why they are verified, not kept.
- **Person-check:** mixed. Valid Alberta and UBC programme pages sit beside a UTas person profile and an NT awards page.
- **Re-role:** all enrolment, fee or application pages.

**Projected impact** (an upper bound: "admitted page fields" counts admitted English, intakes, provider tuition, deadline and description values on the course, from any source):

| Action | Courses | Courses with admitted page fields (fields) | Official URL admitted | Coverage effect if approved |
|---|---:|---:|---:|---|
| Release | 154 | 65 (71) | 5 | Bound pages −154; the courses return to search. Their admitted values are reviewed, not deleted |
| Verify | 1,012 | 472 (498) | 42 | None until read. Each read either proves the binding (stays bound) or turns it to mismatch. Paid reads are held by the closure mandate until lifted for this |
| Person-check | 351 | 202 (204) | 2 | None until a person decides |
| Re-role | 302 | 116 (154) | 292 | Official course page −302 (those 292 currently show a fee or enrolment page as the course page); fee sourcing kept |
| Keep | 558 | — | — | None |

**Not done:** no binding, flag, value or provenance was changed. This is a dry run only.

**Status:** SS-007 is **Awaiting decision**.

## 13. SS-011 (ref F2): website search latency, measurements (31 Oct 2026 11:36 AEDT, read only; no regional probe)

**Database time of the per-request calls** (rolled back, 5 runs each, live):

| Call | Database time |
|---|---:|
| `website_api_v2_auth` | 1.4 ms |
| `website_api_v2_rate` | 1.2 ms |
| `website_api_v2_log` | 0.6 ms |
| Search, AU "business", page of 6 | 0.6 s |
| Search, broad (no filters or AU only) | 3.0–3.8 s (§8.6) |

**Verified.**

**Network cost per request is small.**
- The lightest action (`scholarship`, one indexed lookup) has an API p50 of 266 ms over 7 days. That includes the auth, rate and action round trips; the log is outside the measured time.
- So each round trip from the edge to the database is at most about 90 ms. **Inferred** from `pipeline.api_requests.elapsed_ms`.
- **This corrects §8.7:** cross-region round trips explain a few hundred milliseconds per request, not the 13.5 s p95.

**The slow searches are historical** (`pipeline.api_requests`, website `search`, status 200, 7 days). **Verified:**

| API time | Calls | Average items | Average size | When |
|---|---:|---:|---:|---|
| < 1 s | 127 | 47 | 109 KB | 24–27 Oct |
| 1–2 s | 36 | 41 | 101 KB | 24–27 Oct |
| 2–4 s | 61 | 47 | 132 KB | 24–27 Oct |
| 4–8 s | 30 | 43 | 119 KB | 24–29 Oct |
| **8–18 s** | **74** | 49 | 132 KB | **24–26 Oct only** |

- No website search was made in the last 2 days; the last was 29 Oct 08:50.
- Response size does not differ between fast and slow calls.
- The 8–18 s calls cluster in 24–26 Oct, a period of heavy pipeline load. Search speed depends on database load and cache state more than on network.

**Revised assessment:**
- The website search slowness was real but is not observed now. There is too little recent traffic to know the current p95.
- The smallest effective change is probably on the database side (broad searches of 3–4 s), not region or routing.

**Next measurements (read only):**
1. The query plan of a broad search (`EXPLAIN`, no `ANALYZE`) to find the 3–4 s cost.
2. A daily p50/p95 trend line for website `search`, so the next real traffic shows whether it is fixed.

No consumer change is proposed yet.

## 14. SS-008 (ref F1c): Rule 4 quality and batching, dry-run analysis (31 Oct 2026 11:36 to 11:39 AEDT, read only)

**Method:** `security.adapter_qualify_one_v1` (verified: it writes nothing) was run for **all 1,185 enabled adapters** in time-bounded slices. Rule 4's own selection was applied:
- read share ≥ 0.5 and agree share < 0.9;
- the field is not already admitted;
- not a CA fee;
- no hold.

Nothing was admitted or changed.

| Measure | Result | Label |
|---|---|---|
| Fields Rule 4 would admit today | **1**: `delivery` for one AU adapter (`17d97fba…`), from **2 pages read** (1 agree, 1 differ) | Verified |
| Total qualification time for 1,185 adapters | About 128 s (slices: about 11 + 10.3 + 24.6 + 24.0 + 24.0 + 17.6 + 16.3 s); over the 120 s limit, as observed | Verified |
| Slowest adapters | 7.6 s (372 pages), 6.6 s (355), 5.2 s (289), 3.7 s (154), 3.0 s (388) | Verified |
| Rule 4 admissions to date (`admin_control_events`, `rule_4`) | **22** adapter-field admissions for 22 providers, all between **13 and 23 Oct 2026**; 12 of them in the 16 Oct run | Verified |
| Rule 4 runs since 24 Oct (`layer4_rule_runs`) | 24, 25, 26 and 28 Oct: **0 admitted** each; 29 and 30 Oct failed (time-out) | Verified |
| Adapters with admission on (any rule) | 827 of 1,185; Rule 4 holds: 0 | Verified |

**Assessment:**
- **Rule 4 has done its work.** Its useful output was in its first runs (13–23 Oct). It now finds nothing, or one field on 2 pages.
- **Quality concern:** the rule has no minimum page count. A field read on 2 pages, agreeing on 1, qualifies as "low agreement, page wins". A 2-page sample is not evidence for automatic admission. **Inferred.**
- **Batching, checkpoints and recovery would add a moving part** (cursor, setting, 4 runs a day) to a rule that currently produces about 1 low-quality admission. That is against the mandate's "avoid introducing additional operational complexity".

**Options for the decision** (presented to the Platform Admin as DECISION REQUIRED — SS-008 after SS-005):

| Option | What | Complexity |
|---|---|---|
| A | Keep paused (v2.15.378) and **retire** Rule 4 under housekeeping after the 14-day hygiene window. Adapter fields are admitted only by the other rules and Layer 4 review | Lowest |
| B | Keep paused; if ever restarted, first add a minimum page count (for example 20 pages, a setting) and route candidates to Layer 4 instead of admitting | Low, later |
| C | Batched restart with checkpoints and the current thresholds | Highest; not recommended |

**Recommendation: A.** The one current candidate (2 pages) is the kind of admission the rule should not make.

## 15. SS-005 and SS-006: v2.15.378 completed (verified 31 Oct 2026 11:46 to 11:48 AEDT)

- **Merge:** PR #768 squash-merged as `96daf97a`. Change control admin `ab26d82e`.
- **Local full suite:** 1,287 passed, 0 failed, 0 skipped.
- **Pre-merge live state (11:44):** job active; old description; anon EXECUTE true.
- **Post-deploy live state (11:46):**
  - `l4-rule-low-agreement` inactive;
  - catalogue description begins "PAUSED (Platform Admin 31 Oct 2026, StudySearch decision F1c";
  - `admin_ui_error_report`: anon EXECUTE false, authenticated true;
  - migration head `20261031020000`.
- **Post-merge workflows, all success:** Deploy on merge `41151938573`, Release Currentness Deployed `41151938691`, CourseFinder Deployed UAT `41151939131`, Release History Contract `41151938640`, Pilot Frontend Build `41151938638`.

## 16. SS-009 (ref F5): multiple entry scores, review findings (31 Oct 2026 11:42 AEDT, read only)

**The 24 courses** (active `catalogue.course_entry_requirements` with more than one `min_entry_score`):
- **All 24 are Monash University courses**, admitted in the 31 Oct review session.
- Monash course pages print a table of **alternative entry routes**: ATAR; International Baccalaureate (IB); GCE A Level; Advanced Placement; and the pathway programmes (Monash University Foundation Year, Monash Advanced Preparation Program, Monash diplomas, Trinity College Foundation Studies, UNSW Foundation Program).
- **Each row is a separate, valid way in, not a duplicate requirement.** **Verified** from the admitted rows' bases and quotes (for example `0101331`: ATAR 75; GCE A Level 8; IB 26; MUFY 67.5%; MAPP 67.5; Diploma of Arts Part 2 55%).

**How the API chooses today** (`security.entry_course_payload_v1`): the single `min_score` and `min_score_basis` come from `minimum_grade` rows, international audience first, then **the most recently updated row**. **Verified.**
- Which route is shown depends on which row a reviewer touched last:
  - 14 of 24 courses show a non-ATAR route (usually IB);
  - 8 show ATAR;
  - **2 return `null` although scores are admitted** (`021276J`, `111153D`: their rows are not of kind `minimum_grade`).
- The reply is truthful (the basis names the route) but arbitrary and incomplete.

**Data-quality notes for the review:**
- A few rows carry a weak basis that does not name the route ("7.25", "70%"; `117723D`).
- Two courses have duplicate rows ("70% average" twice in `021276J`; "Minimum 60% average" twice in `085441E`).
- These should be corrected in the AER workspace before any consumer field lists every route.

**Next:** the additive schema proposal, a sample response and consumer impact (SS-009, then Awaiting decision).

### 16.1 SS-009 proposal: additive `entry.min_scores[]` (for approval; not built)

**Principles:**
- **Additive and backwards-compatible.** `min_score` and `min_score_basis` stay exactly as they are, including today's choice rule (international audience first, then the most recently updated row).
- **No inference.** Each route is shown as printed. No route code, conversion or ranking is derived; `basis` carries the provider's own words.
- **Only admitted (active) rows,** as for every entry field.

**Schema** (inside the course detail's `entry`; always present; `[]` when none is held):

| Field | Type | Notes |
|---|---|---|
| `score` | number | The minimum as printed (for example `75`, `26`, `67.5`) |
| `basis` | string | The route and wording exactly as printed (for example "ATAR 75", "International Baccalaureate Diploma Programme 26", "Monash University Foundation Year 67.50%"). Always shown with the number |
| `audience` | string | `international`, `domestic` or `all`, as recorded at review |
| `quote` | string | The source text the row was admitted from |
| `as_at` | date | When the source stated it |

**Order:** `international`, then `all`, then `domestic`; within each, by `basis`. Stable across calls.

**Sample** (course `0101331`, Bachelor of Arts and Bachelor of Criminology, Monash; live values 31 Oct):

```json
"entry": {
  "min_score": 26, "min_score_basis": "International Baccalaureate Diploma Programme 26",
  "min_scores": [
    { "score": 26,   "basis": "International Baccalaureate Diploma Programme 26", "audience": "international", "quote": "International Baccalaureate Diploma Programme 26", "as_at": "2026-10-05" },
    { "score": 8,    "basis": "GCE A Level 8", "audience": "all", "quote": "GCE A Level 8", "as_at": "2026-10-05" },
    { "score": 67.5, "basis": "Monash Advanced Preparation Program 67.50%", "audience": "all", "quote": "Monash Advanced Preparation Program 67.50%", "as_at": "2026-10-05" },
    { "score": 55,   "basis": "Monash University Diploma of Arts (Sociology or Psychology stream) Part 2 - 55%", "audience": "all", "quote": "…", "as_at": "2026-10-05" },
    { "score": 67.5, "basis": "Monash University Foundation Year 67.50%", "audience": "all", "quote": "Monash University Foundation Year 67.50%", "as_at": "2026-10-05" },
    { "score": 75,   "basis": "ATAR 75", "audience": "domestic", "quote": "ATAR 75", "as_at": "2026-10-05" }
  ],
  "benchmark_band": null, "prerequisites": [], "selection_tasks": [], "requirements_note": null, "resolution": null
}
```

**Website wording (for the guide):** "Entry scores published for this course: [basis] …"; one line per item, international first.
- Never convert between routes.
- Never present the list as "or equivalent".
- Never compare it with the student's results.

**Consumer impact and compatibility assessment:**
- **Website API v2 `course`:** one new key inside `entry`. Existing keys and values are unchanged. Clients that ignore unknown fields are unaffected (developer guide §5 and acceptance test 18 already require that).
- **Size:** at most about 1 KB a course; `sync` does not carry `entry`.
- **Zoho API v2:** unchanged (it carries no entry requirements).
- **Other consumer routes** (`wix-course-api`, `website-course-api`): unchanged; they do not return `entry`.
- **Courses affected today:** 41 with admitted scores (24 with more than one).

**Delivery, if approved (per the consumer API rule, §10):**
1. Governed paste for the payload function `security.entry_course_payload_v1` (md5-guarded, count guard, baseline re-taken).
2. Pilot PR with a contract spec.
3. Developer guide **issue 7** with a §7.9 table, an example, the §13 version line and an acceptance test.
4. **Handover note to the website developer**, saying what to render and that nothing existing changes.
5. Change control.

**Prerequisite (curator work, no approval needed):** before the field ships, fix the few weak or duplicate rows in the AER workspace (§16):
- "7.25" and "70%" bases with no route named (`117723D`);
- duplicate rows in `021276J` and `085441E`.

**Separate small question:** whether `min_score` for the 2 courses whose rows are not `minimum_grade` (`021276J`, `111153D`) should stay `null`. Recommendation: leave it, since `min_scores[]` would show their routes.

## 17. SS-007: conditional approval (Platform Admin, 31 Oct 2026 11:53), recorded before execution

> **APPROVED — SS-007 Option 2, subject to the controls below.** Proceed with the controlled remediation of 154 incorrect/generic automatic bindings and the re-roling of 302 shared fee, enrolment or application pages.
>
> **1. Mandatory verification.** Before changing each binding:
> - Verify the classification using available source evidence, not URL patterns alone.
> - Confirm that the binding is automatic, not manual.
> - Identify any admitted values depending on that binding.
> - Preserve existing values, evidence and provenance.
> - Keep genuine course pages unchanged.
> - Re-role fee sources only where their source classification is supported.
>
> If a binding is uncertain, mark it Held — Person Review rather than changing it.
>
> **2. Controlled execution.**
> - Process provider by provider in bounded, count-guarded batches.
> - Record before-and-after binding states.
> - Make changes reversible.
> - Do not delete admitted field values.
> - Do not trigger unrestricted searches, AI enrichment or paid reads.
> - Verify each completed batch before continuing.
> - Stop if unexpected changes or consumer regressions occur.
>
> **3. Consumer API protection.** The Website and Zoho integrations must remain operational. Although the API structure will not change, some official course URLs will become null or change their source classification. Follow the standing consumer-change governance requirements as applicable: developer-guide issue; version line; compatibility assessment; developer handover note; before-and-after verification. Do not introduce breaking API changes.
>
> **4. Explicit exclusions.** This approval does not include:
> - the 1,012 verification reads;
> - any paid page acquisition;
> - the 351 person-check bindings;
> - changes to the 558 genuine shared-page bindings;
> - manual binding changes;
> - automatic Rule 4 admissions;
> - deletion of admitted course data.
>
> **5. Completion evidence.** Record:
> - number successfully released and re-roled;
> - number held after verification;
> - actual coverage changes;
> - affected consumer-visible URLs;
> - admitted values flagged for review;
> - rollback records;
> - before-and-after Website and Zoho checks;
> - Admin and Pilot commit/PR references.
>
> Update `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md` and the StudySearch transformation record. Do not mark SS-007 complete until independently verified.
>
> **6. Continue execution sequence.** After SS-007: SS-008 (present the Rule 4 quality assessment and retirement recommendation); SS-009 (present the multiple-entry-score assessment and additive API proposal); SS-010 (continue read-only enrichment recovery design); SS-011 (complete website search performance analysis).

**Execution plan:**
1. **Model investigation** (read only): how a binding, a page rejection, the admitted official URL and a fee source are stored; which existing governed mechanism releases or re-roles a binding without a new status or a delete.
2. **Per-binding verification** against source evidence (the URL's own title in the provider's site map, HTTP status, stored copy where present), not the URL pattern alone. Uncertain rows are marked **Held — Person Review**.
3. **Design:** a governed, reversible function with a before/after audit table, provider-scoped and count-guarded. Lodged here, then a Pilot migration, a rolled-back live dry run, the full suite, and shipped under change control.
4. **Execution:** provider by provider, each batch verified before the next. Consumer before/after checks; the handover note and developer-guide line.

### 17.1 SS-007: model investigation before execution (31 Oct 2026 11:53 to 11:56 AEDT, read only). A new approval gate found

**How bindings and links work** (verified live; `PIPELINE-LINEAGE.md` row "Official course page link"):
- A binding is `pipeline.coverage_course_pages.status`: `bound`, `mismatch` or `ambiguous`. There is no other status, and the guardrail is no new status values.
- **The consumer's official link:** `catalogue.courses.course_url` and `catalogue.course_links` (`link_type 'official_course'`), projected into `search.course_documents.official_course_url`.
  - Filled only from **proven** bindings by job `course-url-fill` (`security.course_url_fill_v1`).
  - Each fill is logged in `pipeline.course_url_fills`.
- **Guard 3 of that job:** when a binding stops being `bound`, it **takes the fill back on its own**. It stamps `retracted_at` with the reason "page no longer bound", keeps the URL in the log, and empties `courses.course_url` unless a manual lock exists. **This is the existing governed, reversible retraction path.**
- **Guard 4 of that job:** if more than `course_url.max_retraction_pct` (5%) of the last 30 days' fills are taken back, it **switches itself off** (`course_url.fill_enabled` = 0).
  - Today: 21,011 fills, 631 retracted (3.0%).
- **Fee pages** are registered as `pipeline.provider_fact_sources` kind `fee_schedule`, with a person decision.

**What the approved remediation would touch** (live, 11:55):

| Action | Courses | URLs | Official links currently filled from these bindings | Manual URL locks | URLs that are fee pages | Already a registered fee source |
|---|---:|---:|---:|---:|---:|---:|
| Release | 154 | 121 | **0** | 2 | 0 | 0 |
| Re-role | 302 | 67 | **292** | 0 | 15 | **14** |

**Findings:**
1. **Releasing the 154 changes nothing a consumer sees**: none had an official link filled. Its only effects are truthfulness of the coverage record and making the courses eligible for page search again.
2. **The consumer-visible fix is the re-role group:** 292 courses show a list, fee or enrolment page as their official course link.
   - Retracting them through guard 3 takes the 30-day rate to about 4.4%, under the 5% stop, so the fill job keeps running (margin about 127).
3. **"Re-role as fee source" is almost already done.** 14 of the 15 fee-page URLs are registered fee sources. The other 52 URLs are course lists or enrolment and application pages, which are not fee sources and would simply stop being the course page.
4. **There is no hold that keeps a course out of every automated lane.** Courses whose binding is `mismatch` or `ambiguous` are picked up by several jobs:
   - `security.course_link_search_enqueue_v1` / `course_link_search_tick_v1` (paid web search);
   - `security.search_pass_advance_v1` / `public.svc_search_pass_bind`;
   - `public.svc_coverage_reidentify_next`;
   - `public.svc_coverage_read_next` (paid page read);
   - `security.coverage_ai_match_prepare_v1` (AI match).

   The only per-course hold (`no_page_hold_v1`, "confirmed no page") is honoured by AI match alone and asserts something untrue here.
   - So any release or re-role would put these courses back into capped but **paid and AI** search lanes. The approval excludes that ("Do not trigger unrestricted searches, AI enrichment or paid reads").

**Status:** SS-007 is Awaiting decision on how released courses are held (DECISION REQUIRED — SS-007, second gate). Nothing has been changed.

## 18. SS-007: remediation hold built, correction prepared (31 Oct 2026 12:38 to 13:10 AEDT)

**Authority:** Executive Execution Mandate, 12:38. Option C; build the hold, tests, dry runs and change control; the production re-role waits for explicit approval; the 154 release candidates stay held.

### 18.1 Central enforcement, reusing existing controls

**Finding:** every automated lane already passes through one of four existing controls, so there is no need for five independent checks.

| Lane | Existing control the hold is added to |
|---|---|
| Re-binding by any lane (search pass, course link search steps 2 and 2c, site-map binder, Firecrawl find, re-identification) | Binding guard trigger `coverage_page_refused_host` on `pipeline.coverage_course_pages`: a held course's row is returned unchanged (`return old`) unless a person has locked its URL by hand |
| Page reader (paid; jobs `coverage-read` and `coverage-read-2` are paused anyway) | It reads only `bound`/`ambiguous` pages, and the guard keeps a held course `mismatch` |
| Worker-sent course search (paid) | The one stop gate `security.search_stop_gate_v1` returns `remediation_hold` |
| The link-search tick's own send path (off: `send_via` = `worker`) | One more condition on its queue read |
| AI match preparation | Beside the no-page hold, in both places |

**The mechanism:**
- **One indexed table:** `pipeline.course_remediation_holds`, with a partial unique index of one open hold per course.
- **One check:** `security.course_held_v1`, a single index probe.
- **Re-identification:** it already skips refused pages, and the correction adds a `page_rejections` row.

### 18.2 Per-binding verification of the 302 (source evidence)

**Live, 12:50:**
- The 302 sit on 67 pages.
- Every page has 3 to 36 different qualifications bound to it.
- None is manual or locked by hand.
- 292 were bound by search (CRICOS code or title). Ten have no stored copy (fetch failed or blocked).

**Classification** (the page's role, together with the set of courses on it):

| Class | Courses | Pages | Providers | Links shown today | Action |
|---|---:|---:|---:|---:|---|
| A. Fee schedule | 99 | 15 | 11 | 99* | Batch A (re-role) |
| B. Application, enrolment or ESOS page | 33 | 8 | 8 | 26* | Batch A |
| C. Course list page | 45 | 6 | 6 | 42* | Batch A |
| D. School international page (year-level courses) | 114 | 36 | 36 | 104 | **Held: person review** |
| E. One programme page for its ELICOS levels | 11 | 2 | 2 | 11 | **Held: person review** |

\*These are URL fills. The links actually shown to consumers in batch A are **167** (126 on the bound page itself plus 41 on other spellings of the same page). Across all 302 courses, **282** show a link today. The "292" in §17.1 counted URL fills, not shown links.

### 18.3 Correction of the earlier model (§17.1)

- **What consumers see:** the projection (`search.refresh_course_enrichment_core_v1`) takes the official link from **`catalogue.course_links`** (active, with an approved source gate), **not** from `courses.course_url`.
- **Guard 3 alone does not fix it:** it empties `courses.course_url` but leaves the link active. In the dry run, 126 active links remained after guard 3 ran.
- **So the correction also:**
  - sets the matching active official link to the existing status `unverified`, as `link_refresh_tick_v1` does;
  - takes reviewed other spellings of the same page (`also_links`);
  - requests a search refresh.

### 18.4 Release v2.15.379

**Migration `20261031030000_cf247_ss007_remediation_hold`** (spec s188):
- **md5-guarded edits:**

| Function | Before | After |
|---|---|---|
| Binding guard | `efd59e2a` | `33351b50` |
| Stop gate | `6e08df75` | `d7679a05` |
| AI match preparation | `ab2dd5dc` | `23d433d2` |
| Link-search tick | `13b0771d` | `ffc9fb64` |

- **New:**
  - the table;
  - `course_held_v1`;
  - `binding_remediation_apply_v1` (postgres only; count guard before any change; batch limit from setting `remediation.max_batch_courses`, 50);
  - `binding_remediation_lift_v1` (restore or release).
- **No hold is created.** The post-check refuses one.

**Dry runs, live and rolled back:**

| Run | Result |
|---|---|
| Whole file | Applied, post-check passed, after-md5s as pinned |
| Count guard | Refused a TasTAFE batch because one course had become inactive: "16 pass, 17 expected; nothing changed" |
| Batch A (177, 25 providers) | Re-roled in 0.4 s. Evidence and identity kept on all 177. 1,526 admitted attributes on these courses recorded (not changed) |
| Re-bind attempt | Stays `mismatch` |
| Gate | Returns `remediation_hold` |
| Enqueue then gate | 177 queued, 0 sendable |
| Read-lane eligible | 0 |
| Re-identify eligible | 0 |
| Job `course-url-fill` | Took back 167 fills and emptied 177 course URLs. Rate 3.0% → 4.1%; the job stays on |
| Scoped search refresh | Published links 167 → 0 |
| Website sample `course:cricos:00003g:000431k` | `official_url` UNE fee page → null; only `freshness` also moved. Restore brought it back identical |

### 18.5 Prepared for approval (decision pack D1)

- **Paste:** `docs/platform/pastes/PASTE-20261031-ss007-batch-a-re-role.sql`, 25 blocks, one per provider, with exact course lists and counts.
- **Handover:** `docs/integrations/handover/2026-10-31-SS-007-official-link-corrections-HANDOVER.md`, covering consumer impact, the compatibility assessment, version control and before/after checks.
- **Course list:** `docs/platform/ui-audit/2026-10-31-ss007-batch-a-official-links.csv`.

## 19. SS-004: interim verification (31 Oct 12:55)

Since the v2.15.377 deploy (11:03):

| Job | Runs | Failures | Duration |
|---|---|---:|---|
| `waste-guard` | 2 | 0 | 25.8 s and 25.1 s |
| `coverage-ai-match-prepare` | 57 | 0 | median 26.0 s, max 73.4 s |

In the 24 h before, the same jobs failed 12 of 24 and 10 of 720 runs. The 24 h and 7 d acceptance checks are still pending. The 73.4 s maximum is watched against the 120 s limit.

## 20. SS-010: enrichment recovery, measured (31 Oct 13:00, read only)

- **TD2 (futile re-queues):** Enrich items skipped "no correct course page": 2,204 (29 Oct), 1,648 (30 Oct), 167 (31 Oct so far). They cost $0 and are noise.
  - **Proposed:** extend `security.enrich_item_held_v1` to hold a course while its page is `mismatch` (decision pack D5a).
- **TD3 (withdrawn 23 Oct "read again"):** 2,023 course-fields (delivery 1,330, campus 375, duration 219, international 99); 1,704 are on active courses:

| State now | Course-fields |
|---|---:|
| Refilled | 110 |
| Proven page with a stored copy (ready) | 67 |
| Bound page with no copy (paid read, held) | 665 |
| Bound page with a copy but no identity | 16 |
| No bound page | 846 |

  - **Proposed:** re-queue the 67 once, count-guarded, estimated under US$1 (D5b). The rest wait for the verification-read and search decisions.

## 21. SS-011: latency root cause (31 Oct 12:55 to 13:00, read only; no regional probe)

**`pipeline.api_requests`, 14 days, website searches, 24 to 26 Oct excluded:**

| Search request | Requests | Average size | p50 | p95 |
|---|---:|---:|---:|---:|
| 50 items | 24,869 | 119 KB | 3.1 s | 6.9 s |
| 1 to 20 items | 597 | — | 0.8 s | 4.8 s |
| After more than 10 minutes idle | — | — | 4.5 s | — |

**In the database:**
- Page of 50 items 2.2 s, 20 items 1.6 s, 1 item 1.1 s; under light load, 0.4 to 1.2 s for 1 to 20 items.
- `api.website_v2_course_item` ×50 took 547 ms. Within it:

| Call | Time for 50 items |
|---|---:|
| Display code (called 3 times) | 145 ms |
| Published check (provider view, once per item) | 104 ms |
| Tuition | 76 ms |
| Ranking | 47 ms |

- The base query sorts and counts every matching document on each request.

**Conclusion:**
- The main contributors are the 50-item page size and per-item building, plus the full sort and count.
- The edge's sequential calls and cross-region round trips (at most about 90 ms each) are secondary.
- The 24 to 26 Oct spike was a separate, temporary event.
- **Options:** decision pack D6.

### 18.6 v2.15.379 live (verified 13:25 AEDT)

- **PR:** #769, squash-merged as `a8319590`.
- **Post-merge workflows (all success):**

| Workflow | Run |
|---|---|
| Deploy on merge | `41159867542` |
| Release History Contract | `41159867528` |
| Pilot Frontend Build | `41159867545` |
| CourseFinder Deployed UAT | `41159867625` |
| Release Currentness Deployed | `41159867538` |

- **Local full suite:** 1,294 passed, 0 failed, 0 skipped.

**Live checks:**
- Migration head `20261031030000`.
- Function md5s:

| Function | md5 |
|---|---|
| Binding guard | `33351b50` |
| Stop gate | `d7679a05` |
| AI match preparation | `23d433d2` |
| Link-search tick | `ffc9fb64` |

- Remediation functions are not executable by `authenticated` or `service_role`.
- Setting `remediation.max_batch_courses` = 50.
- **No data changed:** 0 holds; 0 `binding_remediation` rejections; unverified official links still 12, as before.

**Paste checked against the live function:** block 1 of the batch A paste (AEI, 6 courses) was run inside a rolled-back transaction. It re-roled 6, set 6 links unverified, held none for review, and the gate returned `remediation_hold`.

**SS-007 status:** Awaiting decision (pack D1, D2). It is not complete until batch A is executed and independently verified.


## 22. D1–D6 approved (Platform Admin, 31 Oct 2026 13:30), recorded before execution (13:30)

**Full text:** `2026-10-31-studysearch-d1-d6-approval.md`, kept verbatim.

| # | Decision | Boundaries |
|---|---|---|
| D1 | Batch A **approved** | Provider by provider; count guards; preserve URLs, values, evidence and rollback; no paid processing; reconcile with the 177 manifest; Website and Zoho before/after; developer handover |
| D2 | Batch B **retain** | Retain all 125 unchanged; document why |
| D3 | Rule 4 **logical retirement** | No deletes |
| D4 | `entry.min_scores[]` **approved** | Additive only; G3; developer guide issue 7 |
| D5 | **Approved** | (a) Hold mismatch-page courses out of the enrichment queues; (b) reprocess the 67, with a ceiling of US$1 |
| D6 | Search optimisation **approved** | Contract equivalence required before deploy |

**Execution order:** D1, D2, D5, D6, D3, D4, SS-004, operations.

**D1 stop conditions:**
- changes beyond the manifest;
- a manual binding is touched;
- new paid processing;
- a consumer regression.

## 23. D1 executed: SS-007 batch A (31 Oct 2026 13:31 to 13:36 AEDT)

**Before (13:31, live):**
- 177 manifest courses are bound to the 29 pages. 173 of them have a search document.
- The Website item shows a link for 167. md5 of all other item content: `900cd49d`.
- Zoho `zoho_v2_course` on 8 UNE courses showed the UNE fee pages.

**Execution:** `security.binding_remediation_apply_v1`, one call per provider, in 5 calls of 1 to 9 providers each:

| Calls | Providers | Re-roled | Links set unverified | Held back |
|---|---:|---:|---:|---:|
| 1 | 6 | 40 | 36 | 0 |
| 2 | 9 | 39 | 36 | 0 |
| 3 | 6 | 35 | 32 | 0 |
| 4 | 3 | 27 | 27 | 0 |
| 5 (USC) | 1 | 36 | 36 | 0 |
| **Total** | **25** | **177** | **167** | **0** |

Approval text on every hold row: "Platform Admin 31 Oct 2026 13:30 decision pack D1 (SS-007 batch A)".

**Reconciliation against the manifest (13:36):**
- 177 open holds at 25 providers, exactly the manifest's course ids.
- 167 links unverified, exactly the manifest's shown links. The 10 without one were EIC 4, NetFit 3 and TasTAFE 3, all showing no link before.
- No manual binding touched.
- All 177 are `mismatch` on their original URL with their evidence id unchanged.
- 177 `binding_remediation` page rejections.
- Unverified official links: 12 → 179.
- No link-search queue row is open for a held course.

**Consumer change:** waits for the search refresh, which runs every 10 minutes with a 30-minute gap. 23 requests are pending. The after-checks are in §23.1.

## 24. D2: SS-007 batch B retained (31 Oct 2026 13:40)

All 125 bindings are retained unchanged, per the Platform Admin's D2 decision.

**List:** `docs/platform/ui-audit/2026-10-31-ss007-batch-b-retained.csv`, with each course, its page, class, decision and residual uncertainty.

| Class | Courses | Pages | Why retained | Residual identity uncertainty |
|---|---:|---:|---|---|
| School international page (year-level courses such as "Senior Secondary 11–12") | 114 | 36 | A school publishes one international page for all its CRICOS courses; there is no course-specific official page to prefer | The page identifies the school's programme, not one year level. Identity rests on the CRICOS code printed on the page (all 114 have it, with a stored copy) |
| One programme page for its ELICOS levels (MEI General English I–V and EAP I–III; Greenwich Cambridge preparation) | 11 | 2 | The page is the programme's own page and describes every level | Levels are not documented separately, so a level-specific fact (duration or entry level) may not be on the page |

**Not done:** no release, re-role, hold or link change for these courses.

### 23.1 D1 consumer verification (31 Oct 2026 13:39 AEDT)

**Search refresh:** all 23 requests were processed by job `search-refresh-requested`.

| Check | Before | After |
|---|---|---|
| Website item `official_url` on the 173 documents | 167 | **0** |
| All other item content (md5 excluding `official_url` and `freshness`) | `900cd49d` | `900cd49d` (unchanged) |
| Zoho `zoho_v2_course`, 8 UNE courses | fee pages | null; key still present |
| Website search, UNE, `has_official_url=true` | — | 105 of 130 |
| Consumer API drift | none | none (`consumer_api_check_v1`: 75 functions, 48 relations) |

**No new processing on held courses since 13:31:**
- 0 re-bound or leased bindings.
- 0 new Enrich items.
- 0 vendor usage rows of any search, read or AI purpose.
- 3 old TasTAFE link-search rows (queued 22 Oct) remain queued. The stop gate returns `remediation_hold` for them, so they cannot be sent.

**Result:** 167 incorrect published course URLs → 0. Courses held for remediation: 177. Rollback is available per course (`binding_remediation_lift_v1`). `courses.course_url` is taken back by job `course-url-fill` at its next run (1 Nov 13:23).

**Developer handover:** the handover note is updated with the result and the course list CSV. It is for the website and Zoho developers through the Platform Admin.

## 25. D5: SS-010 enrichment efficiency (31 Oct 2026 13:40 to 13:55)

### 25.1 D5b: the 67 withdrawn values, re-measured before acting

The set was re-measured live before acting. It is now 65, because 2 no longer have a proven page. My §20 count of "ready" checked only Enrich fills, not values that reached the course by other routes.

| State | Course-fields | Action |
|---|---:|---|
| Field already holds a value again (adapter or other admitted source since 23 Oct) | 50 | None: recovered |
| Re-read on the current proven page after the withdrawal; the reader found nothing ("page does not state it", "page names no campus", "only a site-wide line mentions international"). Held by the existing same-input hold | 14 | None: verified no value. Reprocessing the same copy would only repeat the answer |
| Waiting for the provider campus list (an open Enrich item) | 1 | None: already in the queue |

- **Reprocessed:** 0.
- **AI spend:** US$0 (ceiling US$1).
- **Recovery yield:** 50 of 65 values are back. 14 are verified not on the page; 1 is waiting.

### 25.2 D5a: mismatch-page hold

**Change:** v2.15.380, migration `20261031040000_cf247_ss010_enrich_mismatch_hold`, spec s189.
- One md5-guarded edit of the central enrichment hold `security.enrich_item_held_v1` (`66be0efc` → `688da7ae`).
- It holds a course while its page binding is `mismatch`; manual bindings are excepted. The hold ends by itself when a page is bound again.

**Evidence (live, 4 days):**

| Page binding | Enrich items | Filled | Sent to review |
|---|---:|---:|---:|
| `mismatch` | 11,332 | 0 | 0 |

**Dry run (rolled back):** of 19,512 distinct course-fields tried in 4 days, 9,264 were held before the change and 16,797 after.


## 26. D6: SS-012 search performance, v2.15.381 live (31 Oct 2026)

**Baseline (record §21):**
- Website searches of 50 items: p50 3.1 s and p95 6.9 s at the edge over 14 days.
- In the database, a broad 50-item search took 0.7 to 2.2 s, depending on load.
- Building items: 536 ms for 50 (median of 8 interleaved runs).

**Two changes were tried:**

| Change | Result | Shipped |
|---|---|---|
| Item builder: display code once, keyed published check | 50 items: median 536 → 280 ms (−48%). Output identical on 34 searches and 400 items | **Yes** |
| Search sort and count rewrite (window replaced by count plus top-N; then a limited window) | Identical output, but no faster and often slower under live load | **No.** Discarded on the evidence |

**Release:**
- PR #771, `d9c06e1c`.
- Migration `20261031050000_cf247_d6_course_item_speed`: G3 approval line, baseline re-taken.
- `api.website_v2_course_item` md5 `15129314` → `8f2a0ac9`.
- Local suite 1,300 passed, 0 failed, 0 skipped.
- Post-merge workflows: all success.

**Live verification after deploy:**
- Consumer drift: none.
- Fingerprint of 5 searches (50 items each, all content except `freshness`): `0a1fd5be` before and after. **Byte-identical.**
- Zoho `zoho_v2_course` returns normally.
- Database time for a 50-item search, 12 runs on 4 searches after deploy: median 552 ms. The pre-deploy runs of the same searches in this session were 735 to 985 ms.

**Edge p50 and p95 after the change:** not yet measurable. There has been no website search traffic since 26 Oct. They will be reported from `pipeline.api_requests` once traffic returns.

**Recommendation sent with the handover:** the website can request 20 items per page where practical (1 to 20 items: p50 0.8 s against 3.1 s). Pages of 50 remain supported.

## 27. D3: SS-008 Rule 4 retired logically (v2.15.382, verified 14:24)

- **Migration:** `20261031060000_cf247_d3_rule4_retired`.
- **Dependencies checked before retiring:** no function, edge function, screen, setting or job other than the inactive job refers to it.
- **Live:**
  - job `l4-rule-low-agreement` inactive;
  - job and function `retiring` in the component register (replaced by Layer 4 review; retire after 14 Nov 2026);
  - catalogue "RETIRED (Platform Admin 31 Oct 2026, D3…";
  - `service_role` cannot execute the function.
- **Kept:** the 22 historical admissions (13 to 23 Oct) with their evidence. Nothing is dropped or deleted.
- **Destructive clean-up:** the job and function are dropped by paste after the retirement date, through the existing approval process.

## 28. D4: SS-009 `entry.min_scores[]` (v2.15.382, verified 14:24)

- **Release:** PR #772, `115e40b3`.
- **Migration:** `20261031070000_cf247_d4_entry_min_scores` (G3 approval line; baseline re-taken). `security.entry_course_payload_v1` md5 `80fdfabb` → `691bbba7`.
- **Local suite:** 1,306 passed, 0 failed, 0 skipped. Post-merge workflows: all success.

**Live verification:**

| Check | Result |
|---|---|
| Courses with `min_scores` | 41, 116 items |
| Courses with more than one route | 24 |
| `0101331` | 6 items, first IB 26 (international) |
| `0100714` | 1 item; `min_score` 73 and `resolution` unchanged |
| Zoho `zoho_v2_course` | Carries the key |
| Drift | None |

**Entry-score coverage:**
- **Before:** each of the 24 multi-route courses showed one route chosen by audience and last update, and 2 courses with scores showed `min_score` null.
- **After:** all 116 published routes are returned on the 41 courses.

**Weak labels:** the "weak" `basis` labels found in §16 (`117723D`: "7.25", "70%") have quotes that name the route ("UNSW Foundation Program 7.25", "Monash University Foundation Year 70%"). The guide therefore tells the website to show `quote`. The two "duplicates" (`021276J`, `085441E`) are different routes with the same label (University graduates and VET graduates) and are both kept. No admitted value was edited.

**Developer guide issue 7 (31 Oct 2026):**
- §7.9 table row, a "Several entry scores" section with a rendering rule and example, acceptance test 24, and the §13 line.
- Rebuilt: .md, .docx, .pdf (17 pages).
- **Handover:** `docs/integrations/handover/2026-10-31-D4-entry-min-scores-HANDOVER.md`.
- **Zoho guide:** not reissued. It does not describe `entry`; the key is additive.


## 29. Consolidated results of D1–D6 (31 Oct 2026, 14:24 AEDT)

| Measure | Baseline | After change | Result |
|---|---|---|---|
| Incorrect published course URLs (batch A) | 167 | **0** | Corrected; 177 bindings held. Batch B (115 shown links on school and ELICOS pages) retained by decision |
| Unproductive enrichment attempts a day | 1,600 to 2,200 (11,332 in 4 days, 0 filled) | 0 new items on mismatch-page courses since D5a deployed (14:0x) | Per-day figure due at 24 h (1 Nov) |
| Withdrawn values eligible for recovery | 67 (re-measured 65) | 50 recovered by other sources; 14 verified not on the page; 1 waiting | No reprocessing needed; US$0 of the US$1 ceiling |
| Website search latency | Edge p50 3.1 s and p95 6.9 s (50 items); database 50-item search about 0.7 to 0.99 s in this session | Item build −48% (536 → 280 ms); database 50-item search median 552 ms; output byte-identical | Edge p50/p95 pending website traffic (none since 26 Oct) |
| Rule 4 active admissions | Disabled | Disabled and retired (`retiring`, EXECUTE revoked) | Verified |
| Multiple entry-score coverage | 24 multi-route courses showed one route; 2 showed null | 41 courses return all 116 published routes | Verified Website and Zoho |
| Scheduled job failures | 12 of 24 `waste-guard` and 10 of 720 AI-prep runs failed in the 24 h before the F1 fix | 0 failed of 5,722 job runs since 11:03 | The 24 h check is due 1 Nov 11:03 and the 7-day check 7 Nov; no pass is claimed yet |

**Spend today on D1–D6:** US$0 (no paid search, read or AI call was made by these changes).

**Open items:**
- **SS-007:** the 154 releases and 1,012 verification reads await their own evidence and decision. Independent re-verification of batch A is still to do.
- **SS-004:** observation windows (24 h and 7 d).
- **SS-012:** edge latency, once website traffic returns.
- **SS-008:** the drop paste after 14 Nov.

## 30. SS-014: review of existing operational automation and the first improvements (31 Oct 2026 14:30 to 15:10 AEDT)

**Method:** the existing controls were reviewed before anything new was built. Live reads only, apart from the v2.15.383 change.

| Area | Existing control (verified) | Verified baseline | Gap found | Action (this session) |
|---|---|---|---|---|
| Job reliability and recovery | Platform health check (`platform-health`, every 10 min, 15 checks); job catalogue; F1 fix (v2.15.377) | Failed job runs a day: 29 Oct 30, 30 Oct 40, 31 Oct 9 (all before 11:03); since 11:03, 0 of 5,722 | Alerts flapped: **62** "job failed" issues opened and closed by themselves in 4 days, none acknowledged. An hourly or daily job could never become critical (needed 3 failures within one hour) | **Fixed in v2.15.383:** a failure stays open until the job runs cleanly; critical on 3 consecutive failures at any schedule; thresholds are settings |
| Failure alerts and escalation | Issues list in the Admin (Platform health); acknowledgement with a note | No outbound channel: no e-mail, chat or webhook. Critical issues reach a person only if the Admin is opened | Escalation depends on someone looking | **Decision needed** (see below) |
| AI cost controls | Budget check: Firecrawl reserve; OpenRouter "24 h spend" against US$14; credit floor US$5 | Real OpenRouter spend from the credit balance: 28 Oct US$0.45, 29 Oct US$4.18, 30 Oct US$6.02, 31 Oct US$0.06 (to 15:00) | The spend figure counted Layer 3 only (US$0) while enrichment, AI match and entry reads spend on the same account. The health detail showed the remaining credit (US$98.93) as the day's spend. The ceiling was in code | **Fixed in v2.15.383:** all routes measured from the credit balance; ceiling is setting `budgets.ai_daily_ceiling_usd` |
| Firecrawl cost controls | Monthly limit 500,000 credits with a 2,000 reserve; scholarship cap 60,000; daily purposes | Month to date 245,528; daily 6,156 / 3,098 / 922 / 739 (28 to 31 Oct) | None found | None needed |
| Enrichment queue efficiency | Central enrichment hold; standing gap queue | 1,600 to 2,200 futile items a day | Fixed by D5a (v2.15.380) | Measure at 24 h (1 Nov) |
| Evidence-backed page matching | Binding guard, page rejections, remediation hold (v2.15.379), course-url-fill guards 3 and 4 | 167 wrong links corrected (D1) | 154 release candidates and 1,012 unproven bindings still need their own decision | No change (decided scope) |
| Incremental source refresh | `link-refresh`, `course-relink`, re-read cadences, `search-refresh-requested` | Search refresh ran 13:36; documents updated 14:30 | None found | None |
| Review backlog visibility | Layer 4 Inbox counts by kind; AER outcome register | 1,141 pending; oldest 21 Oct (10 days) | Visible in the Admin, not escalated | Target below; human work |
| Data freshness and publication | Reference bundle check; consumer snapshot (hourly, 13 probes); search probe (3 s) | All ok at 14:28 | None found | None |
| Consumer API monitoring | `consumer-api-guard` (daily drift, hard flag); consumer snapshot; `api_requests` log | 7 days: 1,510 requests, 0 errors (5xx), p95 9.7 s (includes the 24–26 Oct spike); drift none | Edge latency has no target | Target below |
| Release verification and rollback | Full local suite; md5-guarded migrations; post-merge Deploy, Release History, Release Currentness, Deployed UAT; deployed weekly run | 5 releases today, every post-merge workflow green, live md5s verified | None found | None |

**Operating targets** (from these baselines; recorded in `docs/platform/OPERATIONAL-LIMITS.md` §Operating targets):

| # | Measure | Target | Measured by |
|---|---|---|---|
| T1 | Failed runs of active scheduled jobs | 0 a day; any failure visible until fixed; 3 in a row is critical | Platform health (cron check) |
| T2 | AI spend, all routes | US$14 or less a day; credit US$10 or more | Platform health (budgets check) |
| T3 | Firecrawl | Within 500,000 a month, keeping the 2,000 reserve | Platform health (budgets check) |
| T4 | Futile Enrich items (mismatch pages) | Under 100 a day | `field_enrich_items` (agent weekly) |
| T5 | Layer 4 review backlog | Oldest pending item under 14 days | Layer 4 Inbox |
| T6 | Consumer API | 0 server errors; no contract drift; search p95 under 3 s for pages of 20 | `consumer-api-guard`; `api_requests` |
| T7 | Data freshness | Search refresh requests processed within 40 minutes; reference bundle under 2 hours old | Platform health |
| T8 | Releases | Full suite green; every post-merge workflow green; live md5 verified; a before-md5 rollback on record | Change control |
