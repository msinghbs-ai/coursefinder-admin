# Deployed UAT recovery (23 Nov 2026)

**Lane:** `S1-Build` (Platform Admin 23 Nov 2026 22:10 AEDT: targeted recovery of the acceptance failures; find the cause from production evidence first, make only confirmed minimal fixes, never change production data to satisfy a test).
**Runs:** full acceptance (`deployed-uat.yml`, tier `acceptance`, live-acting off) 45157925569 (UAT2 as Pipeline Operator, 12 failed / 60 passed) and 45160460395 (UAT2 as Platform Admin, 13 failed / 59 passed). Baseline before the password change and before s1011: 45065672209 (22 Nov 2026 20:18 UTC), 11 failed / 61 passed, the same 11 tests.
**Method:** production Postgres logs (statement timeouts by function and by statement), live function definitions and timings read in rolled-back dry runs. No interactive SQL.

## 1. Sign-in and role

- The UAT account's password was changed through a reset on 22 Nov 2026 22:52 UTC; every deployed sign-in failed until the Platform Admin updated the `UAT_PASSWORD` secret (23 Nov 2026 21:33 AEDT targeted run green).
- The deployed specs assume more than one role: most screens are checked at Platform Admin level, while the Layer 1 operations and permission checks assert what a Pipeline Operator (rank 4) sees. One account cannot satisfy both. Platform Admin decision (23 Nov 22:10): role-specific UAT accounts, rank 6 Platform Admin for full administrative acceptance, rank 4 Pipeline Operator for operational access and permission regression, rank 2 Counsellor for Counsellor workflows. Creating the two further accounts and their repository secrets is for the Platform Admin; the specs are mapped to them once the secret names are set.
- s1011 (row-level security on 93 tables) is not a cause: the statement timeouts below hit the same functions before it went live (10:05 UTC), and no error in the window names row-level security.

## 2. The five active failures (Platform Admin 22:10)

| # | Spec | Root cause (evidence) | Fix | Status |
|---|---|---|---|---|
| 1 | `admin_toolsets_read` HTTP 500 (admin-navigation, cf-073, a23 and others on Services & limits) | Statement timeout at the signed-in limit (8 s): 25 timeouts in 24 h, 13 of them before s1011. Live parts: 14-day scholarship AI spend read 2.0 s (39,309 of 74,684 wide rows from the heap), coverage AI-match spend 1.8 s (no `created_at` index, 125 MB scanned), `toolset_plan_status` 1.2 s (vendor usage by `acquisition_provider_id`, no index, 251,678 rows) | s1013: three covering indexes. Rehearsed: 133 ms, 14 ms, 18 ms; whole function 163 ms | Live (s1013, Pilot #1510) |
| 2 | `cf-073` Acquisition route | The old address opens Services & limits; since v2.16.12 (15 Nov 2026) each service keeps its acquisition settings inside its Details fold, so `.l2p-shell` and the "Acquisition providers" heading appear only once a fold is opened. Its landing also called `admin_toolsets_read` (item 1) | Spec checks the direct route on today's screen (`[data-services-limits]`, the Firecrawl card, no workspace error, Back recovers); item 1 removes the 500 | Live (s1013, Pilot #1510) |
| 3 | `data-quality` exceptions paging | Two pagers on the screen (the exceptions list and Field coverage below the filters); the locator matched both | Locator scoped to `.dq-exceptions .dq-pager`; the four page assertions unchanged | Live (s1013, Pilot #1510) |
| 4 | `cf-061` QILT course detail | Data verified: RMIT Advanced Diploma of Accounting (113126B) is active, row 22 of 53. The Courses keyword search took 2.5 to 3.5 s quiet and 7.2 to 8.2 s under load: one `ilike '%…%'` OR across courses and providers read every course (filter alone 734.7 ms, `pg_trgm` not installed) | s1014 (approved 22:55): `pg_trgm`, four trigram indexes, keyword test as one lookup per column. See section 4 | Pilot s1014 |
| 5 | `s167` DP020 course detail | `admin_course_audit` timed out at 11:01:09 and 11:01:11 UTC, when the test opened the evidence overlay: it reads a course's evidence by `metadata->>'course_id'`, which no index serves (236,106 rows, 497 MB): over 15 s for DP020 | s1013: partial expression index (10 MB, built in 0.8 s). Rehearsed: read 2 ms, whole function 173 ms | Live (s1013, Pilot #1510) |

## 3. Recorded findings (failing before 23 Nov; not changed in this pass)

| Spec | Finding | Owner |
|---|---|---|
| `layer2-provider` (2 tests), `m2-4-4-a26-a28` | They open a Fetchers tab that was folded into Services & limits on 3 Nov 2026 (SS-020 step 3, Decision 269, v2.15.455) | S1-Build |
| `admin-navigation` (deep link) | Expects `#models-services?tab=fetchers`; the same Decision 269 move | S1-Build |
| `m2-4-4-a23` | Its landing calls `admin_toolsets_read` (item 1 above) | S1-Build |
| `performance` (3 tests) | Courses page interaction 4.6 s against a 3 s budget; a courses page payload 412,855 bytes against 250,000; Adapters `admin_layer23` timeouts (21 in the last hour of runs) | S1-Build |
| `data-quality` (field coverage) | `admin_field_coverage` timed out once under the acceptance run | S1-Build |
| `layer1-operations` | Asserts the Pipeline Operator view; passes with an operator account (section 1) | S1-Build |

## 4. s1013 live and s1014 measurements

**s1013 read-back (live, 23 Nov 2026 22:58 AEDT, production load):**
- Migration head: `20261123233000`.
- All four indexes present.
- `admin_toolsets_read`: 769 ms. It was timing out at 8 s.
- `admin_course_audit` for DP020: 212 ms. It was over 15 s.
- G3 75/48 with no drift; 7,585 manual locks; 133 active cron jobs.

**s1014 rehearsal (rolled back, live, scheduled jobs running).** Each case was called through `admin_read('courses_page')` twice; times are the first and second call.

| Case | Before (ms) | After (ms) | Total | Same ids, same order | 113126B row |
|---|---|---|---|---|---|
| Code `113126B` | 1,471 / 314 | 315 / 63 | 1 | yes | 1 |
| Provider `RMIT` | 6,456 / 3,660 | 1,035 / 207 | 515 | yes | 1 |
| Title `Advanced Diploma of Accounting` | 4,059 / 3,031 | 783 / 168 | 53 | yes | 22 |
| Partial `Accounting` | 2,942 / 988 | 642 / 152 | 716 | yes | |
| No keyword (default) | 725 / 154 | 535 / 174 | 44,734 | yes | |
| AU + `Accounting`, by provider | 1,750 / 734 | 930 / 529 | 538 | yes | |
| NZ page 2, provider descending (no keyword) | 770 / 195 | 1,024 / 413 | 6,536 | yes | |
| CA + `Nursing` page 2, course descending | 878 / 376 | 794 / 443 | 216 | yes | |

The NZ and CA rows do not go through the keyword path. Their EXPLAIN ANALYZE plan is the same before and after (16.9 ms and 14.5 ms), so their spread is load.

**Plans:**
- The keyword filter took 734.7 ms as a sequential scan of 44,734 courses and 3,106 providers.
- With the trigram indexes it takes 27.0 ms: one bitmap index scan per column on `courses_title_trgm_idx`, `courses_display_title_trgm_idx`, `courses_code_trgm_idx` and `courses_stable_key_trgm_idx`, providers read on their own (3,106 rows), and the existing identifier prefix index.

**Indexes (size, build time):**

| Index | Size | Build time |
|---|---|---|
| Title | 5,496 kB | 6.9 s |
| Display title | 5,496 kB | 4.2 s |
| Code | 2,552 kB | 1.6 s |
| Stable key | 5,136 kB | 4.0 s |

Each is built under a lock retry. GIN maintenance applies to course writes only.

**Source record:**
- `public.admin_toolsets_read` existed live only.
- s1014 keeps its exact production definition (md5 `df2380c6`, guarded before and after) in source.

## 5. s1014 live and acceptance after it (23 Nov 2026 23:30 to 23:50 AEDT)

**s1014 read-back (Pilot #1511, `5df82e85`; Deploy on merge and Security gates green):**
- Migration head: `20261123235000`.
- `pg_trgm` 1.6 with 4 trigram indexes; `admin_course_page_fast_base` md5 `22eb2f5e`; `admin_toolsets_read` md5 `df2380c6`, unchanged.
- G3 75/48 with no drift; 7,585 manual locks; 136 active cron jobs.
- The eight representative lists are identical to the baseline (totals, ordered ids, 113126B rows).
- The live plan uses all four trigram indexes. Warm timings: title search 245 ms, no keyword 165 ms.

**Full acceptance 45174909735 (UAT2 as Platform Admin, live-acting off):** 62 passed, 9 failed, 1 flaky. Before s1013 the same run had 13 failed. CF-073, s167 and both Data Quality tests now pass, and the `admin_toolsets_read` 500s are gone.

| Remaining | Cause | Action |
|---|---|---|
| admin-navigation, layer2-provider ×2, a26–a28, a23 | Deployed specs still opened the Fetchers tab merged into Services & limits (Decision 269) and the registry now in Details folds (v2.16.12); the source contracts (`ss020`) already reflect the move | Pilot: specs follow the current screens through one shared helper; no assertion removed |
| performance (core workspaces) | Waited for `admin_read('dashboard')`; the Dashboard reads `admin_read('platform_health')` since v2.16.35 | Pilot: measures the read the Dashboard makes; same budget |
| performance (CRICOS interactions) and cf-061 | The Courses list returns 77 fields a row, 412,855 bytes a page (budget 250,000); under the suite's parallel load it took 3.3 to 4.8 s, so cf-061's 6 s wait missed by about a second (the data is correct: 113126B row 22 of 51 with the screen's arguments, 227 ms warm) | Open, S1-Build: server-side payload |
| performance (Adapters) | `admin_layer23('universities_page')` 6.8 s against 3 s | Open, S1-Build |
| layer1-operations | Asserts the Pipeline Operator view; UAT2 is Platform Admin | Needs the rank 4 UAT account (Platform Admin) |

## 6. Acceptance after the spec fixes (Pilot #1512, 24 Nov 2026 00:20 AEDT)

**Run:** 45180623329, UAT2 as Platform Admin, live-acting off. 65 passed, 7 failed. The run before tonight's work had 13 failures; the one after s1014 had 9.

**Now passing:** admin-navigation, a23 and a26–a28. CF-061 now finds the RMIT row and fails one step later.

| Remaining | Finding | Needs |
|---|---|---|
| cf-061 | RMIT row found; the course's QILT outcome card (`.ci-outcome-card`) is not shown | Check the course's QILT provider-context data against the card's rule (S1-Build) |
| layer2-provider ×2 | The text "Credentials stay write-only" no longer exists anywhere in `src/`, and Scrape.do is not listed in the embedded registry | A decision on the equivalent credential-boundary check on today's screen. The assertion is security-relevant, so it is not loosened without one |
| performance ×3 | Courses list `courses_page` latency and payload (412,855 bytes against 250,000: `last_admitted` 168,857 bytes, carrying full before and after values for a 160-character tooltip; `field_states` 69,336); `admin_layer23('universities_page')` 7.7 s cold, 1.3 s warm | A decision on trimming the list payload; trace the Adapters cold path (S1-Build) |
| layer1-operations | Asserts the Pipeline Operator view | The rank 4 UAT account (Platform Admin) |

## 7. Decisions of 24 Nov 2026 00:30 and s1016

**Course list payload (approved: cap the tooltip and send only the shown columns).** Measured live, rolled back:
- One 50-row page carried 412,855 bytes. `last_admitted` was 168,857 of them: whole before and after values, up to 13,409 characters, for a tooltip that shows 160. `field_states` was 69,336, although the default columns read none.
- s1016 sends the 160-character preview, and only the field states a caller names.

| Case | Bytes |
|---|---|
| Preview cap alone (live on deploy) | 256,105 |
| Default columns, once the screen names its keys | 186,869 |
| Every field-state column shown | 230,374 |

- Same course ids and order; callers that name no keys keep every field state.
- The screen side belongs to S1-API-Frontend-Delivery (master plan hand-off, 24 Nov 2026). Until it ships, the payload check stays about 6 KB over its 250,000-byte budget.

**Credential check (approved: assert the real boundary).**
- Since v2.16.12, Firecrawl has its own service card. Scrape.do (registered, switched off, credential saved) is listed in the Other page services fold, and the page-level "Credentials stay write-only" notice no longer exists.
- The deployed check now asserts:
  - the Firecrawl card is shown;
  - Direct HTTP and Scrape.do are listed, each showing only whether its credential is set;
  - no password field holds a value;
  - no secret text appears.
- The drawer check is unchanged: it shows "Configured in Vault" or "Not configured", and its key field is write-only.

## 8. Role-specific accounts wired (24 Nov 2026 09:55 AEDT)

- Secrets set by the Platform Admin 24 Nov 09:05: `SS_UATR4_Email`, `SS_UATR4_PWD` (rank 4 Pipeline Operator), `SS_UATR2_Email`, `SS_UATR2_PWD` (rank 2 Counsellor). Passed to `deployed-uat.yml` (preflight requires them) and `deployed-weekly.yml` as `UAT_R4_*` and `UAT_R2_*`.
- `loginAsUatUser(page, rank)` picks the account and asserts the role pill (Pipeline Operator, Counsellor).
- `layer1-operations` (Platform Admin boundary for Layer 1 source settings) runs as rank 4: passes (integration run 45277046831).
- Failures seen in the same run come from the v1.1 Admin shell (s999, Pilot #1519, 07:44 AEDT) and are handed to S1-API-Frontend-Delivery: admin-navigation, A21 Layer navigation, layer2-provider (2), a13 tablet filter, performance (3).
