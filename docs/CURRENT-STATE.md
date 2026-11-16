# StudySearch – current state (read this first)

**Purpose:** one page a new coding session reads before anything else, so it starts from the live system and not from chat history. It says where each exact fact lives and what is in flight right now.
**Rule (Platform Admin, 16 Nov 2026 09:20):** every version bump, migration, or UI or scheduler change updates this page in the same release cycle, with the documents it points to. A fact here carries the time it was read; check the live system before relying on a figure older than a day.
**Last updated:** 16 Nov 2026 12:26 AEDT (sections 3 to 5), 09:25 AEDT (rest), by the Course Module session (S2-CF), from Pilot `main` 8f53f8fd (#1173) and a read-only query of project `fxcwkweaxjtknorudmwp`.

## 1. Start here

1. This page, then `docs/README.md` (which document is current in each family).
2. Pilot `CLAUDE.md` (working rules G1 to G4, housekeeping, cron dispatchers, the UI map rule, the two-repository rule). This repository's `CLAUDE.md` mirrors the two-repository rule.
3. The live system: Supabase project `fxcwkweaxjtknorudmwp` only. The organisation's other project, `coursefinder-demo`, is unrelated and is never targeted.
4. Open Pilot PRs and branches. `main` is not always what is deployed mid-change.

## 2. Where each exact fact lives

| Question | Source of truth | How to get it exactly |
|---|---|---|
| Live schema (tables, functions, policies) | The live database | Pilot workflow "Database schema dump" (branch `db-schema-dump/<run id>`, md5 per file); one function: workflow "Database function snapshot". Checked-in migrations are not complete: at least one live function has no migration file. |
| Migrations applied | `supabase_migrations.schema_migrations` | Compare its newest version with the newest file in Pilot `supabase/migrations/` |
| Scheduled jobs and dispatchers | `cron.job`, `pipeline.automation_catalogue`, `pipeline.rollup_targets`, `pipeline.admission_rules` | Read live; shadow reports: `security.rollup_shadow_report_v1(days)`, `security.admission_rule_shadow_report_v1(hours)` |
| Components and what is retiring | `pipeline.component_register` | Pilot branch `component-register-snapshot` (daily); `docs/platform/COMPONENT-REGISTER.md` is an older copy (15 Oct 2026) |
| UI routes, tabs, sub-tabs, folds, drawers | `docs/UI-MAP.md` (generated) | Pilot `node scripts/ui-map.mjs --mirror <this repo>`; guarded by spec `s557` |
| What each screen shows and does | `docs/platform/UI-CATALOGUE.md` (written by hand; v1.18 at v2.15.494, behind the v2.16 screens), in-app Guides | Trust `docs/UI-MAP.md` for names and places |
| Admin and operator SOPs | `docs/sops/` (mirror of Pilot `src/guide/sops.js`) | Pilot `node scripts/export-sops.mjs --check-mirror <this repo>/docs/sops` |
| Tests and what each guards | `docs/platform/TEST-REGISTER.md` (generated) | Pilot `node scripts/test-register.mjs` |
| Settings and UI simplification plan (decisions, phases, progress) | `docs/platform/ui-audit/ui-ux-settings-audit-2026-11-15.md` | Read §6 to §8; the live counts in it carry their read time |
| Settings | `pipeline.platform_toolset_settings` | Settings › Settings on the admin screen; never a number in code (G2) |
| Consumer API (frozen) | Pilot `tests/uat/consumer-api-baseline.json`, spec `s57` | `docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md` before touching anything the website or Zoho reads |
| Paste files waiting to be run | `docs/paste/README.md` | Section 4 below |
| Task status and evidence | `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md`; consumer requests: `docs/integrations/` | One register; no second tracker |

## 3. Live system as read (16 Nov 2026 09:22 AEDT; release, migration and test rows 12:25 AEDT)

| Measure | Value |
|---|---|
| Visible release | v2.16.13 (package 0.1.435), Pilot `main` 6bfadf01 |
| Newest migration applied live | `20261116080000` (same as the newest file in Pilot `supabase/migrations/`) |
| Migrations applied | 2,036 |
| Scheduled jobs (`cron.job`) | 191 active, 11 switched off |
| Components marked retiring | 46 settings, 30 functions, 14 screens, 8 jobs, 5 tables, 1 edge function |
| Tests | 679 specs, 3,215 tests (3,123 local, 92 deployed track) |
| UI | 20 pages, 48 tabs, 17 sub-tab bars, 178 folds, 39 drawers and dialogs |

## 4. Dispatchers, pending cutovers and pending paste files

Rule: Pilot `CLAUDE.md`, "Cron dispatchers" (register each legacy job byte for byte, 24-hour shadow cycle, then cutover; `cron.unschedule` by paste file after 14 days).

| Dispatcher | Jobs | State as read | Shadow since | Next step | Owner |
|---|---|---|---|---|---|
| Consolidation PR 1, `rollup-scheduler` | 26 report and cache targets (`pipeline.rollup_targets`) | **Shadow**: 26 of 26 in shadow; 2,542 due-records in 24 hours, nothing run by it; legacy jobs still running | 15 Nov 2026 22:22 AEDT | **Cutover Mon 16 Nov 2026 22:30 AEDT** | The session that prepared PR 1. Do not touch from another session. |
| Consolidation PR 2, `admission-rule-runner` (lanes `-b`, `-c`) | 20 admission rules (`pipeline.admission_rules`) | **Shadow**: 20 of 20 in shadow; 574 due-records since start; legacy jobs still running | 15 Nov 2026 23:29 AEDT | **Cutover Tue 17 Nov 2026 22:30 AEDT** | The session that prepared PR 2. Do not touch from another session. |
| Consolidation PR 3, `pipeline.field_execution_registry` and `coverage-lane-dispatch` | Not scoped yet (the `calendar-reread` worker lane is named for it) | **Not built** | — | **Pulled forward 24 hours (Platform Admin 16 Nov 2026 10:59, for the 20 Nov delivery):** scope, build and merge in shadow from **Mon 16 Nov 23:15 AEDT**, once the PR 1 cutover is verified live. PR 2 and its 22:30 Tue cutover are not touched. Cutover no sooner than 24 hours after its shadow starts, and only after the PR 2 cutover is verified | Course Module session (S2-CF) |

Pending paste files (run by the Platform Admin; details and md5 in `docs/paste/README.md`):

| File | Run on or after |
|---|---|
| `docs/paste/PASTE-20261115-cron-legacy-jobs-drop.sql` | Part A any time; Part B from 29 Nov 2026 |
| `docs/paste/PASTE-20261116-retired-settings-drop.sql` | 29 Nov 2026 |

## 5. Open work in the repositories

| Item | State |
|---|---|
| Pilot #1162, API v3 field dictionary sync (REQ-76) | Open |
| Split Pilot `docs/paste/` (41 files) | **Approved, Platform Admin 16 Nov 2026 10:10 (option 1).** After the PR 2 cutover (Tue 17 Nov 22:30 AEDT) is verified: the SQL files that specs or database fixtures read or run move to Pilot `tests/fixtures/` (all 18 guard specs keep their assertions, no cross-repository CI); every file a person runs moves to this repository's `docs/paste/` only; a Pilot guard then refuses any new `PASTE-*.sql` in Pilot. Queued for Wed 18 Nov 2026 09:15 AEDT, separate from the PR 3 queue. Never create a new `PASTE-*.sql` in Pilot. |
| UI/UX and settings simplification audit and plan | **Committed 16 Nov 2026 10:25 AEDT:** [`docs/platform/ui-audit/ui-ux-settings-audit-2026-11-15.md`](platform/ui-audit/ui-ux-settings-audit-2026-11-15.md), verbatim as supplied by the Platform Admin (decisions §6, UnoPim specs §7, progress to v2.16.12 §8). Phase 4 (Dispatcher Panels) waits for the PR 1 to 3 cutovers. |
| `cron-governance-audit-2026-11-15.md`, `rollup-scheduler-pr1-scope.md` | **Not yet in this repository.** The session that wrote them is committing them to `docs/platform/` before it closes (Platform Admin 16 Nov 2026 10:21). Until then, Pilot migrations and PRs #1157 and #1159 cite them as "project doc claude/…". |

### Order of work to the 20 Nov data admission delivery (Platform Admin 16 Nov 2026 10:59)

| When (AEDT) | Work |
|---|---|
| Mon 16 Nov 22:30 | PR 1 cutover (unchanged) |
| Mon 16 Nov 23:15 | PR 3 scope, build and merge in shadow |
| Tue 17 Nov 22:30 | PR 2 cutover (unchanged) |
| Wed 18 Nov 09:15 | Pilot paste-file split (option 1) |
| Wed 18 Nov 09:30 | **Phase 5 before Phase 4:** Review & Evidence DataGrid, first slice on Layer 4 › Inbox, with shared views `AER Audit Samples`, `Official URLs`, `Provider Blockers`, personal views and the quote-versus-value drawer. Phase 4 (Dispatcher Panels) follows Phase 5 |

### Course description readings (fixed 16 Nov 2026, release v2.16.13, Pilot #1174)

- **Cause:** new readings pause while 1,500 first descriptions wait in Layer 4 (`enrich.course_description_pending_global_max`); 1,831 waited, 1,167 of them held by a rejection memory that counted platform supersessions as a person's refusal.
- **Fix:** migration `20261116080000`: the three rejection-memory tests leave out `superseded`; rule `cdesc-machine-v2`, so every waiting item is evaluated again. Dry run rolled back first; consumer API drift none.
- **As read 12:25 AEDT:** 1,486 waiting (below 1,500 from 12:24); 492 admitted by v2, all read back; 0 still `rejected_before_course`; 1,052 not yet evaluated again (done by about 13:05).
- **Readings:** resume when `field-gap-queue` next queues them (hourly at :23). The 12:23 run timed out during the re-evaluation load; the 13:23 run is checked at 13:35.
- **Known:** refreshed declines keep the ledger label `cdesc-machine-v1` (updated in place; their stamp is v2).

## 6. Known gaps (not resolved, do not work around silently)

- `docs/platform/UI-CATALOGUE.md` and the `docs/README.md` row for it are behind the v2.16 screens.
- `docs/platform/COMPONENT-REGISTER.md` is the 15 Oct 2026 copy; the daily snapshot is on a Pilot branch, not here.
- This page is written by hand from live reads. Sections 3 and 4 should be generated from the live database at each release; until then, the reader checks the time on each section.
