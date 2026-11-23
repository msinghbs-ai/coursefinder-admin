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
| 1 | `admin_toolsets_read` HTTP 500 (admin-navigation, cf-073, a23 and others on Services & limits) | Statement timeout at the signed-in limit (8 s): 25 timeouts in 24 h, 13 of them before s1011. Live parts: 14-day scholarship AI spend read 2.0 s (39,309 of 74,684 wide rows from the heap), coverage AI-match spend 1.8 s (no `created_at` index, 125 MB scanned), `toolset_plan_status` 1.2 s (vendor usage by `acquisition_provider_id`, no index, 251,678 rows) | s1013: three covering indexes. Rehearsed: 133 ms, 14 ms, 18 ms; whole function 163 ms | Pilot s1013 |
| 2 | `cf-073` Acquisition route | The old address opens Services & limits; since v2.16.12 (15 Nov 2026) each service keeps its acquisition settings inside its Details fold, so `.l2p-shell` and the "Acquisition providers" heading appear only once a fold is opened. Its landing also called `admin_toolsets_read` (item 1) | Spec checks the direct route on today's screen (`[data-services-limits]`, the Firecrawl card, no workspace error, Back recovers); item 1 removes the 500 | Pilot s1013 |
| 3 | `data-quality` exceptions paging | Two pagers on the screen (the exceptions list and Field coverage below the filters); the locator matched both | Locator scoped to `.dq-exceptions .dq-pager`; the four page assertions unchanged | Pilot s1013 |
| 4 | `cf-061` QILT course detail | Data verified: RMIT Advanced Diploma of Accounting (113126B) is active and is row 22 of 53 for that search. The Courses keyword search took 2.5 to 3.5 s quiet and 7.2 to 8.2 s under load (the filter alone 4.3 s: `ilike '%…%'` over title, display title, provider name, code and stable key with no trigram index, `pg_trgm` not installed), beyond the test's 6 s wait and near the 8 s limit | Not a fixture or data problem. Needs a search change (trigram indexes and a predicate the planner can use), decision below | Open: Platform Admin decision |
| 5 | `s167` DP020 course detail | `admin_course_audit` timed out at 11:01:09 and 11:01:11 UTC, when the test opened the evidence overlay: it reads a course's evidence by `metadata->>'course_id'`, which no index serves (236,106 rows, 497 MB): over 15 s for DP020 | s1013: partial expression index (10 MB, built in 0.8 s). Rehearsed: read 2 ms, whole function 173 ms | Pilot s1013 |

## 3. Recorded findings (failing before 23 Nov; not changed in this pass)

| Spec | Finding | Owner |
|---|---|---|
| `layer2-provider` (2 tests), `m2-4-4-a26-a28` | They open a Fetchers tab that was folded into Services & limits on 3 Nov 2026 (SS-020 step 3, Decision 269, v2.15.455) | S1-Build |
| `admin-navigation` (deep link) | Expects `#models-services?tab=fetchers`; the same Decision 269 move | S1-Build |
| `m2-4-4-a23` | Its landing calls `admin_toolsets_read` (item 1 above) | S1-Build |
| `performance` (3 tests) | Courses page interaction 4.6 s against a 3 s budget; a courses page payload 412,855 bytes against 250,000; Adapters `admin_layer23` timeouts (21 in the last hour of runs) | S1-Build |
| `data-quality` (field coverage) | `admin_field_coverage` timed out once under the acceptance run | S1-Build |
| `layer1-operations` | Asserts the Pipeline Operator view; passes with an operator account (section 1) | S1-Build |
