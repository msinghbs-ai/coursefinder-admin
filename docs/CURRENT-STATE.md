# StudySearch – current state (read this first)

**Purpose:** one page a new coding session reads before anything else, so it starts from the live system and not from chat history. It says where each exact fact lives and what is in flight right now.
**Rule (Platform Admin, 16 Nov 2026 09:20):** every version bump, migration, or UI or scheduler change updates this page in the same release cycle, with the documents it points to. A fact here carries the time it was read; check the live system before relying on a figure older than a day.
**Last updated:** 17 Nov 2026 22:50 AEDT (S2 - BOOST: Boost extraction through `coverage-sweep` and the Models & services route is live, Pilot #1223, migration `20261117235000`, worker v1.0.9, s587; #1219 read back and run-2 passed through GitHub Actions; section 5 › S2 - BOOST lane), 17 Nov 2026 22:50 AEDT (Pilot #1222: the deployed Layer 1 role-boundary test follows the approved gates; Deployed UAT still red because the UAT account's password was changed at 22:17 AEDT; section 5), 17 Nov 2026 22:25 AEDT (S2 - BOOST, Platform Admin decisions of 21:18: Boost priority matrix moved to Settings › Pipeline settings over the single category list, one admitted row per course in a batch; Pilot #1219, migration `20261117223000`, s586 added, s581 retired; section 5 › S2 - BOOST lane), 17 Nov 2026 20:30 AEDT (squash rebuild proof decided: option A on `coursefinder-boost-test`; S2 - BOOST re-seeds after the rehearsal and after Thursday 03:30; sections 4 and 5), 17 Nov 2026 21:30 AEDT (release v2.16.26, Pilot #1217, Wave 2 decisions: one category list, source retention in one place, Curators open Layer 1, evidence and Layer 4 items side by side; migration `20261117213000`; section 5), 17 Nov 2026 20:15 AEDT (release v2.16.25, Pilot #1214, Wave 2 addenda: parser badge and Re-infer Parser Spec on Layer 1 sources, target record type in the wizard; migration `20261117203000`; section 5), 17 Nov 2026 19:45 AEDT (S1-Build Wave 2, Pilot #1212, migration `20261117200000`: staging retention in housekeeping-daily (dry run), 7-year evidence floor, ops telemetry views, live dry-run workflow; squash runbook and schedule; sections 3 to 5), 17 Nov 2026 19:00 AEDT (release v2.16.24, Pilot #1211, Parallel Wave 2: Layer 1 source induction wizard and Platform health › Country & category completeness; migration `20261117193000`; section 5), 17 Nov 2026 18:40 AEDT (S2 - BOOST: Boost priority matrix `country_category_boost` live, Pilot #1209, migration `20261117183000`, guard spec s581; first Boost test-project experiments, run-1; section 5 › S2 - BOOST lane), 17 Nov 2026 17:15 AEDT (S1-Build: `worker-boost-bulk-ingest` live, Pilot #1205, migration `20261117163500`; window, blackout, housekeeping and tick-lock gate; qualification SQL; section 5), 17 Nov 2026 17:00 AEDT (releases v2.16.22 and v2.16.23, Pilot #1204 and #1206: clean greeting without a name, Go-live checklist row for custom SMTP, and Admin invitations and resets through Resend with a write-only API key in Vault; migrations `20261117163000` and `20261117170000`; section 5), 17 Nov 2026 16:15 AEDT (Boost test rebuild PASS on every check, run 44019730363; section 5), 17 Nov 2026 16:15 AEDT (release v2.16.21, Pilot #1203: Resend invite on Users & roles, warning with Copy HTML on Links & Email Templates; the `#0b6e5f` StudySearch PIM Admin emails applied to Supabase Auth by `supabase-auth-config.yml` run 44021389741; section 5), 17 Nov 2026 15:35 AEDT (release v2.16.20, Pilot #1202: Users & roles › Links & Email Templates; migration `20261117152700`), 17 Nov 2026 15:30 AEDT (S1-Build: Supabase Auth applied, Boost bucket and tables live, four low-yield jobs paused, Boost rebuild root cause fixed; section 5), 17 Nov 2026 14:05 AEDT (release v2.16.19, Pilot #1197: Destination data page, Layer 4 kind Campus locality, `campuses[].locality` on API v3 providers; migration `20261117131500`). Before it: 17 Nov 2026 14:40 AEDT (S2-Build step 1, Pilot #1196: destination G-1 career grain and the destination field dictionary, migrations `20261117060000` and `20261117061000`; ABS loader runtime note in section 5), 17 Nov 2026 09:20 AEDT (AER benchmark round 3: Path B, Mistral failed the gate; Pilot #1191 and #1192; all AER entry reading stays off; benchmark report §6.1), 17 Nov 2026 08:50 AEDT (release v2.16.18, Pilot #1193 and #1194: destination data schema pack and API v3 `destination` action; migration `20261117040000`; bulk ingestion readiness checklist in section 5). Before it: 17 Nov 2026 07:15 AEDT (release v2.16.17, Pilot #1190: RM1A-3 register end dates; migration `20261117010000`; 2,051 applied), 17 Nov 2026 07:20 AEDT (Boost rebuild run 43940610220: schema complete, later steps FAIL with causes fixed; section 5), 17 Nov 2026 06:30 AEDT (PR 3 `coverage-lane-dispatch` in shadow since 06:21, Pilot #1188, 13 lanes; `coverage-ai-match` left out; section 4), 17 Nov 2026 03:30 AEDT (Boost rebuild: schema step stopped at its limit with one cause found and fixed; re-run waits; section 5), 17 Nov 2026 01:05 AEDT (release v2.16.16 live, Pilot #1189: invite and reset links to the admin sign-in, catalogue CSV export; no migration; Supabase dashboard paste doc pending; sections 3 to 5), 16 Nov 2026 23:45 AEDT (PR 2 cut over live 23:31 AEDT by S2 - SS Build under the Platform Admin's override of 21:23, Pilot #1185; PR 3 built in shadow as Pilot #1188, not merged: its live rehearsal waits for an approval; API v3 PR A/B fills live 21:50; sections 3 to 5), 16 Nov 2026 23:20 AEDT (PR 1 fix live 23:14 AEDT, Pilot #1187; fresh 24-hour shadow from 23:15 AEDT; cutover review Tue 17 Nov 23:20 AEDT; Boost test rebuild from the schema dump running, run 43863252704; sections 4 and 5), 16 Nov 2026 22:50 AEDT (PR 1 no longer blocks PR 3 or PR 2; PR 1 fix and new shadow, cutover Tue 22:30; section 4), 16 Nov 2026 22:50 AEDT (PR 1 cutover held: shadow fails the no-tick-over-budget criterion; section 4), 16 Nov 2026 21:25 AEDT (Boost setup steps 1 to 4: test project `coursefinder-boost-test` created; rebuild workflow waits for one secret; bucket paste file; sections 4 and 5), 21:05 AEDT (Cloudflare Worker Boost built and tested locally, nothing deployed or applied; section 5), 20:50 AEDT (Pilot #1181 finder fix, #1182 Course page needed settle, #1183 API v3 daily admittance telemetry; Layer 4 quick wins and the paths taken; Tue A/B gates; sections 3 and 5), 19:45 AEDT (Pilot #1180 live; official URL resolution of 856 items, Layer 4 4,916, new paste file; sections 3 to 5), 18:10 AEDT (Pilot #1162 field dictionary, #1178 AER routes and #1179 worker v1.0.6 merged; decisions of 16:52 in section 5), 16:45 AEDT (API v3 data admission plan in section 5), 16:40 AEDT (Layer 4 clearance and AER benchmark round 2 in section 5), 13:36 AEDT (course description readings in section 5), 13:25 AEDT (release v2.16.14: sections 2 to 5), 12:45 AEDT (AI token efficiency check in section 5), 12:26 AEDT (sections 3 to 5), 09:25 AEDT (rest), by the Course Module session (S2-CF), from Pilot `main` 8f53f8fd (#1173) and a read-only query of project `fxcwkweaxjtknorudmwp`.

## 1. Start here

1. This page, then `docs/README.md` (which document is current in each family).
2. Pilot `CLAUDE.md` (working rules G1 to G4, housekeeping, cron dispatchers, the UI map rule, the two-repository rule). This repository's `CLAUDE.md` mirrors the two-repository rule.
3. The live system: Supabase project `fxcwkweaxjtknorudmwp` only. The organisation's other project, `coursefinder-demo`, is unrelated and is never targeted.
4. Open Pilot PRs and branches. `main` is not always what is deployed mid-change.

## 2. Where each exact fact lives

| Question | Source of truth | How to get it exactly |
|---|---|---|
| Live schema (tables, functions, policies) | The live database | Pilot workflow "Database schema dump" (branch `db-schema-dump/<run id>`, md5 per file); one function: workflow "Database function snapshot". Checked-in migrations are not complete: at least one live function has no migration file. |
| Migrations applied | 2,045 (20:45 AEDT) |
| Scheduled jobs and dispatchers | `cron.job`, `pipeline.automation_catalogue`, `pipeline.rollup_targets`, `pipeline.admission_rules` | Read live; shadow reports: `security.rollup_shadow_report_v1(days)`, `security.admission_rule_shadow_report_v1(hours)` |
| Components and what is retiring | `pipeline.component_register` | Pilot branch `component-register-snapshot` (daily); `docs/platform/COMPONENT-REGISTER.md` is an older copy (15 Oct 2026) |
| UI routes, tabs, sub-tabs, folds, drawers | `docs/UI-MAP.md` (generated) | Pilot `node scripts/ui-map.mjs --mirror <this repo>`; guarded by spec `s557` |
| What each screen shows and does | `docs/platform/UI-CATALOGUE.md` (written by hand; v1.18 at v2.15.494, behind the v2.16 screens), in-app Guides | Trust `docs/UI-MAP.md` for names and places |
| Admin and operator SOPs | `docs/sops/` (mirror of Pilot `src/guide/sops.js`) | Pilot `node scripts/export-sops.mjs --check-mirror <this repo>/docs/sops` |
| Tests and what each guards | `docs/platform/TEST-REGISTER.md` (generated) | Pilot `node scripts/test-register.mjs` |
| Settings and UI simplification plan (decisions, phases, progress) | `docs/platform/ui-audit/ui-ux-settings-audit-2026-11-15.md` | Read §6 to §8; the live counts in it carry their read time |
| AI spend and yield by service and model tier; page-to-catalogue funnel | Google Sheet `StudySearch_Pipeline_Telemetry_Live`, tabs `Model_Tier_&_Token_Efficiency` and `Layer_Lifecycle_Funnel` (refreshed 08:05 AEDT daily) | `security.telemetry_model_tier_v1(24)`, `security.telemetry_layer_funnel_v1(24)` (read only) |
| Settings | `pipeline.platform_toolset_settings` | Settings › Settings on the admin screen; never a number in code (G2) |
| Consumer API (frozen) | Pilot `tests/uat/consumer-api-baseline.json`, spec `s57` | `docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md` before touching anything the website or Zoho reads |
| Paste files waiting to be run | `docs/paste/README.md` | Section 4 below |
| Task status and evidence | `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md`; consumer requests: `docs/integrations/` | One register; no second tracker |

## 3. Live system as read (16 Nov 2026 09:22 AEDT; release, migration and test rows 13:14 AEDT)

| Measure | Value |
|---|---|
| Visible release | **v2.16.26** (package 0.1.448; Pilot #1217, commit `64dc0c13`, deploy-on-merge green 17 Nov 20:25 AEDT; Curators open Layer 1, one category list, wizard retention set in `pipeline.source_retention_policies`, evidence captures and Layer 4 items side by side). Before it: **v2.16.25** (package 0.1.447; Pilot #1214, commit `6a3aa0ff`, deploy-on-merge green 17 Nov 19:27 AEDT; Layer 1 sources show their parser and the wizard takes a target record type). Before it: **v2.16.24** (package 0.1.446; Pilot #1211, commit `6797ac20`, deploy-on-merge green 17 Nov 18:54 AEDT; Layer 1 › + Add source is a six-step induction wizard; Platform health gains Country & category completeness). Before it: **v2.16.23** (package 0.1.445; Pilot #1206, commit `7ec9bfbd`, deploy-on-merge green 17 Nov 16:52 AEDT; Email delivery provider on Links & Email Templates: Supabase built-in or Resend, sender name, from email, write-only API key). Before it: **v2.16.22** (package 0.1.444; Pilot #1204, `4c1b262f`, 16:29 AEDT; clean greeting without a name, Go-live checklist row `auth_custom_smtp`) and **v2.16.21** (package 0.1.443; Pilot #1203, main `ebebc0b5`, deploy-on-merge green 17 Nov 16:00 AEDT; Resend invite on the user row, warning and Copy HTML for Supabase Dashboard while `SB_MANAGEMENT_TOKEN` is not set; no migration). Before it: **v2.16.20** (package 0.1.442; Pilot #1202, main `f9065e08`, deploy-on-merge green 17 Nov 15:25 AEDT; Users & roles gains the tab Links & Email Templates: Admin Site URL, guide link, Invite User and Reset Password emails, saved with a reason; copied to Supabase Auth only when the edge function secret `SB_MANAGEMENT_TOKEN` is set, which it is not yet). Before it: **v2.16.19** (package 0.1.441; Pilot #1197, main `f8327605`, deploy-on-merge green 17 Nov 14:00 AEDT; Admin UI fitout RM0F: Destination data page with five tabs, Layer 4 Inbox kind Campus locality, adapted Course, Provider and Data delivery screens, `campuses[].locality` on API v3 providers; record in `docs/Roadmap/2026-01/DESTINATION-DATA-UI-AND-INGESTION-SPEC.md` v1.2 section 6). Before it **v2.16.18** (package 0.1.440; Pilot #1193 `76ff6b36` and #1194 `63deb84e`, deploy-on-merge green 17 Nov 08:43 AEDT; destination data schema pack and API v3 `destination` action; record in `docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md` v1.6). Before it **v2.16.17** (package 0.1.439; Pilot #1190, main `5430d822`, deploy-on-merge green 17 Nov 07:08 AEDT; RM1A-3: CRICOS registrations on the latest edition no longer end-dated; record in `docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md` v1.4). Before it **v2.16.16** (package 0.1.438; Pilot #1189, main `e301578e`, deployed 17 Nov 00:53 AEDT: deploy-on-merge, deployed UAT and release currentness green; edge function `admin-user-management` redeployed). Before it v2.16.15 (#1186). Worker coverage-sweep v1.0.6 |
| Newest migration applied live | `20261117235000` (Pilot #1223, S2 - BOOST: Boost extraction; rolled-back live dry run passed, md5 `075f0e6a`, with G3 75 functions, 48 relations, no drift inside it; deploy on merge run 44075576598, 22:37 AEDT; read back live 22:38 AEDT: history md5 `075f0e6a` equals the file, 2,077 applied, G3 75 and 48 with no drift, controls check 0 flags). Before it: `20261117233000` (Pilot #1221). Before that: `20261117223000` (Pilot #1219, S2 - BOOST; rolled-back live dry run passed on the PR, md5 `02ea5343`; deploy on merge run 44067300044, 22:13 AEDT, reports it applied with history md5 `02ea5343` equal to the file; the migration's own post-checks passed or it would not have been recorded. **Direct read-back by S2 - BOOST is pending**: the Supabase connector asked for a confirmation that was not answered, so the live objects and G3 were not re-read in that session). Before it: `20261117221000` (Pilot #1218). Before that: `20261117213000` as read 20:26 AEDT (Pilot #1217, Wave 2 decisions; history md5 `7f2f3b43` equals the file; 2,073 applied; G3 guard 75 functions, 48 tables, no drift). Before it: `20261117203000` as read 19:29 AEDT (Pilot #1214, Layer 1 parser line items; history md5 `1a4f999b` equals the file; 2,070 applied; G3 guard 75 functions, 48 tables, no drift). Before it: `20261117200000` (Pilot #1212, S1-Build Wave 2; applied 17 Nov 19:3x AEDT; history md5 `5e3173b7` equals the file; 2,069 applied; G3 75 functions, 48 relations, no drift). Before it: `20261117193000` as read 18:55 AEDT (Pilot #1211, induction wizard and completeness report; history md5 `d019e3f8` equals the file; 2,068 applied; G3 guard 75 functions, 48 tables, no drift). Before it: `20261117183000` (Pilot #1209, S2 - BOOST: Boost priority matrix; deploy on merge run 44039205199, applied 17 Nov 18:30 AEDT; history md5 `f91660be` equals the file; 2,067 applied; G3 75 functions, 48 relations, no drift). Before it: `20261117180000` (Pilot #1201, S2-Build). Then, as recorded earlier: `20261117170000` as read 16:53 AEDT; then `20261117163500` (Pilot #1205, Boost bulk ingestion) applied 17:01 AEDT after it, a lower version applied later (history md5 `93725fc9` equals the file; 2,065 applied as read 17:10; G3 75 functions, 48 relations, no drift). For `20261117170000` (Pilot #1206, Admin email delivery; history md5 `d4f1ddd8` equals the file; 2,065 applied; G3 guard 75 functions, 48 tables, no drift). Before it: `20261117163000` (Pilot #1204, Go-live checklist row; md5 `3592f607` equals the file). Earlier: `20261117152700` (Pilot #1202, Admin links and email templates; applied 17 Nov 15:25 AEDT; history md5 `efcb85cf` equals the file; 2,062 applied; G3 guard 75 functions, 48 tables, no drift). Before it: `20261117152300` (Pilot #1199, S1-Build), `20261117150000` (Pilot #1200, S2-Build) and `20261117131500` (Pilot #1197, destination Admin UI; applied 17 Nov 14:00 AEDT; history md5 equals the file; 2,058 applied). Before it: `20261117061000` (Pilot #1196, destination field dictionary: 2,071 current v3 fields, 148 of them `destination`) and `20261117060000` (Pilot #1196, G-1 career grain: key `career_outcomes_area_key`; importer body md5 `abf58405…`, read body md5 `40b256e6…`), applied 17 Nov 14:3x AEDT and read back. Before them: `20261117051700` (Pilot #1195, S1-Build: four low-yield jobs paused for bulk ingestion). Before it: `20261117040000` (Pilot #1194, destination schema pack; applied 17 Nov 08:43 AEDT; history md5 equals the file; 2,053 applied). `20261117030000` (Pilot #1193) was refused by the deploy step before anything ran and is not in the history; its file was reissued as `20261117040000`. Before it: `20261117020000` (Pilot #1191, AER v3 benchmark round 3). Before it: `20261117010000` (Pilot #1190, RM1A-3; applied 17 Nov 07:08 AEDT; 2,051 applied). Before it: `20261116220000` (Pilot #1188, PR 3 shadow; applied 17 Nov 06:21 AEDT). Before it: `20261116210000` (Pilot #1187, PR 1 fix; read 23:33 AEDT). `20261116190000` (Pilot #1185, PR 2 cutover) was applied after it at 23:31 AEDT (a lower version applied later; the deploy applies any version not yet in the history). `20261116180000` (#1184, API v3 PR A/B fill rules) 21:33 AEDT. Earlier: `20261116170000` (Pilot #1183, API v3 daily admittance; read 20:45 AEDT). Before it: `20261116160000` (#1182), `20261116150000` (#1181), `20261116143000` (#1180) |
| Migrations applied | 2,042 (18:49 AEDT) |
| Scheduled jobs (`cron.job`) | 191 active, 11 switched off |
| Components marked retiring | 46 settings, 30 functions, 14 screens, 8 jobs, 5 tables, 1 edge function |
| Tests | 713 specs, 3,371 tests (3,279 local, 92 deployed track; 17 Nov 22:45 AEDT, Pilot main `b3c16254`) |
| UI | 21 pages, 55 tabs, 24 sub-tab bars, 178 folds, 39 drawers and dialogs (v2.16.24: Platform health gains Country & category completeness) |

## 4. Dispatchers, pending cutovers and pending paste files

Rule: Pilot `CLAUDE.md`, "Cron dispatchers" (register each legacy job byte for byte, 24-hour shadow cycle, then cutover; `cron.unschedule` by paste file after 14 days).

| Dispatcher | Jobs | State as read | Shadow since | Next step | Owner |
|---|---|---|---|---|---|
| Consolidation PR 1, `rollup-scheduler` | 25 report and cache targets (`pipeline.rollup_targets`; `layer2-onboarding-snapshot` stays on its own job) | **Shadow, fix live (16 Nov 2026 23:14 AEDT, Pilot #1187, migration `20261116210000`, main `396abc5f`)**. Read back live: tick md5 `36a8d4f314788d4a292bac677b568858`, shadow report md5 `465b6b4fa6cf9365f94036fb2adf77cf`; `housekeeping-daily` runs `select security.housekeeping_daily_v1(); select security.rollup_runs_trim_v1();`; `layer2-onboarding-snapshot` target disabled; 25 enabled targets, none live; 26 legacy jobs unchanged and active; no consumer API drift flag raised. The held 22:35 review (20 of 1,427 ticks over 60 s, all after the dispatch loop) is what the fix answers | **Fresh 24-hour shadow from 16 Nov 2026 23:15 AEDT** (first tick under the fix) | **Cutover review Tue 17 Nov 2026 23:20 AEDT** (scheduled), once the full 24-hour cycle ends at 23:15. Acceptance: all_match over 25 targets; no tick over 60 s since the fix; lag within one tick; no tick failure. The 22:44 target of 22:30 falls 45 minutes inside the cycle: the cutover waits for the full cycle unless the Platform Admin accepts the shorter window | The session that prepared PR 1. Do not touch from another session. |
| Consolidation PR 2, `admission-rule-runner` (lanes `-b`, `-c`) | 20 admission rules (`pipeline.admission_rules`) | **Live since 16 Nov 2026 23:31 AEDT** (Pilot #1185, migration `20261116190000`, main `3fa05b38`), cut over by S2 - SS Build under the Platform Admin's override of 16 Nov 21:23. Gate read 23:30 AEDT: shadow window 24.0 h, all 20 match, 0 minutes over capacity, 20 legacy jobs active with the registered md5 and schedule. Read back 23:33–23:36: 20 live, 20 legacy jobs off (`active = false`), 20 retiring (retire after 30 Nov 2026), 3 runner lanes on, 21 control events; first live runs 6 succeeded, 0 failed; G3 drift [] (75/48) | 15 Nov 2026 23:29 AEDT | **Done.** The other session's Tue 17 Nov 22:30 slot finds it cut over (the Platform Admin cancels it). `cron.unschedule` paste file `PASTE-20261116-admission-rule-legacy-unschedule.sql` on or after 1 Dec 2026 | S2 - SS Build (cutover); the session that prepared PR 2 |
| Consolidation PR 3, `pipeline.field_execution_registry` and `coverage-lane-dispatch` (lanes `-b`, `-c`) | 13 coverage worker lanes (course-link-search-worker, coverage-find-site, coverage-reextract, coverage-reidentify, provider-contact-page, provider-facts, companion-read, course-list-read, credential-read, policy-add-tests, programme-discover, programme-read, source-find), plus 7 API v3 field lanes declared disabled and never dispatched | **Shadow since 17 Nov 2026 06:21 AEDT** (Pilot #1188, migration `20261116220000`, main `d2afabfc`, spec `s567`). Two rolled-back rehearsals at 06:16–06:18, both passed with G3 equal: the full migration and the exact functions. Read back 06:23: all 13 lanes match their live job; 7 field lanes disabled; 3 dispatchers on and catalogued; 8 settings; shadow records arriving; G3 drift [] (75/48). **Left out:** `coverage-ai-match`, switched off on live 17 Nov 06:00 AEDT with no recorded reason (the Platform Admin chose 06:15 to take 13 and add it in a later change once it runs again); `calendar-reread` (S2-Intakes); `coverage-read` and `coverage-read-2` (30-second schedules) | — | Cutover review Wed 18 Nov 06:45 AEDT (scheduled): needs 24 h shadow, all 13 match, PR 1 cut over and verified | S2 - SS Build |

**Scheduled gates (S1-Build, Platform Admin 17 Nov 2026 18:02):**
- **PR 1 cutover review: Tue 17 Nov 23:20 AEDT** (scheduled; the cutover migration is numbered above the live head and lands before the squash).
- **Canonical migration squash: Thu 19 Nov 01:30–03:30 AEDT**, by [`docs/platform/MIGRATION-SQUASH-RUNBOOK.md`](platform/MIGRATION-SQUASH-RUNBOOK.md); rehearsal Wed 18 Nov 10:30 AEDT (scheduled). **Migration freeze:** no Pilot PR that adds a file under `supabase/migrations/` merges between 01:15 and 03:30 AEDT Thursday. The squash changes no database object: it makes a fresh schema dump the canonical baseline, archives the applied migration files and repoints the specs. It must keep the 7 consumer functions that hold carriage returns byte for byte. **Decided (Platform Admin 17 Nov 2026 20:06, option A):** the rebuild proof runs on `coursefinder-boost-test` (`ucdaaqrpgcldnatavmib`) through admin `boost-test-rebuild.yml`, for the rehearsal (Wed 10:30) and the window (Thu 01:30); each run resets that project. `S2 - BOOST` re-seeds it after the rehearsal and right after the window closes at 03:30 AEDT Thursday (see the S2 - BOOST lane below).

**Platform Admin 16 Nov 2026 22:44 AEDT, dispatcher order changed:**
- **PR 1 does not block PR 3 or PR 2.** PR 3 (from 23:15 AEDT tonight) and PR 2 (Pilot #1185, merge after 23:28 AEDT tonight) proceed independently of PR 1.
- **PR 1** gets its three fixes now:
  - the history clean-up moves to `housekeeping-daily`;
  - each live target's due minute is recorded before it runs;
  - `layer2-onboarding-snapshot` stays on its own job.
- **PR 1 timing:** a fresh 24-hour shadow starts when the fix is live, and the cutover targets **Tue 17 Nov 2026 22:30 AEDT**.
- **PR 1 fix live 16 Nov 2026 23:14 AEDT** (Pilot #1187, read back above). The shadow started at 23:15 AEDT, so the full 24-hour cycle ends **Tue 17 Nov 23:15 AEDT** and the cutover review is scheduled for 23:20 AEDT.

Pending paste files (run by the Platform Admin; details and md5 in `docs/paste/README.md`):

| File | Run on or after |
|---|---|
| `docs/paste/PASTE-20261115-cron-legacy-jobs-drop.sql` | Part A any time; Part B from 29 Nov 2026 |
| `docs/paste/PASTE-20261116-retired-settings-drop.sql` | 29 Nov 2026 |
| `docs/paste/PASTE-20261116-admission-rule-legacy-unschedule.sql` (the 20 legacy admission rule jobs, PR 2; guarded) | 1 Dec 2026 |
| `docs/paste/PASTE-20261117-supabase-invite-email-template.md` (Supabase Auth: Site URL, Redirect URLs, Invite user and Reset password templates for v2.16.16) | **Steps 1 to 3 done 17 Nov 2026 14:33 AEDT** by admin workflow `supabase-auth-config.yml` (run 44009123373, read back; section 5 › S1-Build). Step 4 (a test invitation and reset to an address you control) is the Platform Admin's |
| `docs/paste/PASTE-20261116-staging-boost-bucket.sql` (private Boost bucket) | **Done 17 Nov 2026 14:37 AEDT** by Pilot #1199 (migration `20261117152300`, same values and check); nothing to paste |
| `docs/paste/PASTE-20261116-api-field-dictionary-number-arrays.sql` | Any time (Pilot `20261116110000` is live); then a small migration loads the 2 held fields |
| `docs/paste/PASTE-20261116-l4-lift-false-link-refusals.sql` | Any time: lifts 59 false course-link refusals of live pages verified valid (Layer 4 report §7.3); stops unless exactly 59 rows match |

## 5. Open work in the repositories

### S2 - BOOST lane: priority matrix and Boost test-project experiments (17 Nov 2026; Platform Admin 18:02)

Lane: the Boost worker (`worker-boost-bulk-ingest`), the promotion function, qualification seeds and Boost test-project benchmarks. `S1-Build` keeps the PR 1 cutover, Thursday's squash and `housekeeping-daily`.

**Action for S2 - BOOST (Platform Admin 17 Nov 2026 20:06):** S1-Build uses `coursefinder-boost-test` for the squash rebuild proof, and `boost-test-rebuild.yml` resets the project (application schemas dropped and rebuilt from the production dump; reference data copied; test cron jobs switched off). Two resets:
- **Rehearsal, Wed 18 Nov from 10:30 AEDT** (S1-Build posts here when the rebuild run finishes);
- **Squash window, Thu 19 Nov 01:30–03:30 AEDT.**

Do not run experiments on the project during those runs. Re-seed it (qualification rows, experiment batches, any test settings) after the rehearsal rebuild and again **right after the window closes at 03:30 AEDT Thursday**. Keep the re-seed steps in your lane notes so they can be repeated.

**Platform Admin decisions, 17 Nov 2026 21:18, and what changed (Pilot #1219, migration `20261117223000`, guard spec s586; merged 22:13 AEDT). Where the bullets further down differ, this block is current.**

- **Decision 3, where the matrix lives.** The Boost priority matrix is 18 settings on **Settings › Pipeline settings › Boost**, each changed on the screen with a reason:
  - `boost.matrix.country_weight.<CC>`: AU 100, NZ 95, CA 90, UK 50, IE 45, US 40 (range 0 to 100).
  - `boost.matrix.category_weight.<category key>` (range 0 to 1), one per category of the single list.
  - `boost.matrix.tier_1` (AU, NZ, CA) and `boost.matrix.tier_2` (UK, IE, US); `boost.matrix.country_aliases` (GB=UK); `boost.matrix.lane_categories`.
  - **A change that breaks the matrix is refused.** A deferred check on the settings table (`boost_matrix_check`, function `security.boost_matrix_settings_guard_v1`) refuses a change to a `boost.matrix.*` setting when a tier 2 cell would reach a tier 1 cell or a weight goes below 0. The screen shows "Boost priority matrix not saved: …".
  - The row `country_category_boost` in `pipeline.environment_settings` is kept, marked `not_applicable`, and no longer read. Per-cell overrides (there were none) were not carried over.
- **Decision 2, the categories.** The matrix has no category list of its own. It reads `ref.enrichment_categories` (S1-RM-Design, migration `20261117213000`; [`platform/ENRICHMENT-CATEGORIES.md`](platform/ENRICHMENT-CATEGORIES.md)).

  | Category | Weight | Boost lane |
  |---|---|---|
  | Recognition & registration | 1.00 | `provider_accreditations` |
  | Campus & location | 0.95 | |
  | Fees | 0.90 | `course_fees` |
  | Entry requirements | 0.85 | `aer_entry` |
  | Intakes & deadlines | 0.80 | `study_load` |
  | Course basics | 0.75 | `course_description` |
  | Provider profile | 0.70 | |
  | Scholarships | 0.65 | |

  - **How the weights were carried.** Six categories took the weight of the old matrix key they replace (by the crosswalk `ref.enrichment_category_fields.boost_category`). Course basics and Provider profile had no single old key and took the two weights left over (0.75 and 0.70). These are starting values; change them on the screen.
  - Lowest tier 1 cell is CA Scholarships 58.5; highest tier 2 cell is UK Recognition & registration 50.
  - **For S1-RM-Design:** the Boost matrix now reads the single list, so the crosswalk column `ref.enrichment_category_fields.boost_category` has no reader in the Boost lane. It was not touched; retiring it is yours.
- **Decision 4, order only.** `security.boost_promote_v1` does not read the matrix (guarded by s586). The matrix orders the Boost queue; `security.boost_lane_category_v1(lane)` gives a lane's category.
- **Decision 5, the admitted count.** `security.boost_promote_v1` now admits one row per course in a batch (the earliest); later rows for the same course are refused with the note "an earlier row of this batch fills this course's study load". What is written to the catalogue is unchanged. The function was replaced only after the migration confirmed the live definition was md5 `15be1ce6`.
- **Verification of #1219, completed 17 Nov 22:07 to 22:12 AEDT.** Read back live: head `20261117223000`, 18 `boost.matrix.*` settings, matrix check `ok` with 48 cells (AU Recognition & registration 100 rank 1; CA Scholarships 58.5 rank 24; UK Recognition & registration 50 rank 25), old row `not_applicable`, the deferred check present, promotion function md5 `c9239d35`, 0 qualified models, G3 75 functions and 48 relations with no drift. **Run-2 on the test project (GitHub Actions run 44071755287, admin workflow `boost-test-experiment.yml`): PASS.** The promotion function was copied from production (same md5 on both). 60 rows admitted for the 60 courses with no study load at 1,000 and at 5,000 rows (5,922 later rows for the same courses refused, none admitted); 19 for 19 at 50 rows; nothing admitted with no model qualified; 0 held courses and 0 `updated_at` values changed; G3 on the test project 75 and 48. Timings (database time, medians): 1,000 rows 36.5 ms load and 101.9 ms promote; 5,000 rows 183 ms and 374.7 ms, worst promotion 0.42 s.
- **Database and test-project runs are non-interactive (Platform Admin 17 Nov 2026 22:05).** No tool that asks for confirmation is used for a change. Routes:
  - **Production change:** a Pilot migration, dry run by the label `live-dry-run` (Pilot workflow `db-migration-dry-run.yml`), applied by deploy on merge. Production G3 through Actions is read by that workflow's probe, as the database owner; the read-only role of the Management API may not run `security.consumer_api_check_v1` (seen in run 44071755287).
  - **Test project:** admin workflow **Boost test project experiment** (`.github/workflows/boost-test-experiment.yml`, inputs `label` and `reseed`): production read only, then on `coursefinder-boost-test` only: re-seed, promotion function from production, `sql/boost-experiments/admitted-count.sql`, verdict; results on branch `boost-experiment/<run id>`.
- **Decision 1, Boost extraction through `coverage-sweep` and Models & services: live 17 Nov 2026 22:37 AEDT** (Pilot #1223, migration `20261117235000`, worker `coverage-sweep` v1.0.9, guard spec s587; deploy on merge run 44075576598).
  - **Route** `boost_extract` ("Boost extraction (study load)", area Boost) in Models & services: one pinned model, `qwen3-30b` (`qwen/qwen3-30b-a3b-instruct-2507`, the central model), daily caps USD 1 and 1,500 calls. No separate worker holds an OpenRouter key; the Cloudflare Worker is not deployed.
  - **Job** `boost-extract`, `2-59/5 * * * *`, catalogued, no number in its command. It runs only when `security.boost_extract_gate_v1` allows: the switch `boost.extract_on` (ships **on**), then the overnight Boost gate (01:05 to 04:50 Melbourne, not in the squash blackout, not beside `housekeeping-daily`, dispatcher locks). Read live: closed now, open Wed 01:10, closed Thu 01:45.
  - **What a run does** (mode `boost_extract`, `boost.ts`): claims up to `batch.boost_extract` (20) courses with no study load that have a stored course page, country by country in the order of the Boost priority matrix (study load is Intakes & deadlines: AU 80, NZ 76, CA 72); reads each stored page; sends only the text around "full-time" and "part-time" (at most `reading.boost_extract_section_chars`, 6,000) to the route's model; checks the answer against the whole page (allowed value, quote on the page, quote states the load it claims); writes one result file per run to Storage `staging-boost/inbound`. A page with neither word gets its "not stated" row with no model call. `worker-boost-bulk-ingest` (unchanged) loads and settles the file.
  - **Nothing is admitted.** `pipeline.boost_model_qualifications` is empty, so every row is shadow or refused and the catalogue is not written. Qualifying a model for admission stays a separate, deliberate step after the benchmark.
  - **Lane:** `study_load` only. The other Boost lanes (`course_fees`, `aer_entry`, `course_description`, `provider_accreditations`) are not read by this worker yet.
  - **The queue is small and almost all Australian.** Read live 22:40 AEDT: 2,380 active courses have no study load and a stored course page: AU 2,360, NZ 18, CA 2. (33,502 active courses have no study load; the rest have no stored course page for Boost to read.) At 20 courses a run the queue takes about three nights; `batch.boost_extract` goes to 200.
  - **Ledger and progress:** `pipeline.boost_extract_items` (one row per course and stored page, with outcome, batch, file, whether a model was called, cost); `security.boost_extract_progress_v1()`. It holds 6 `released` rows from the migration's own claim check; they are read by the job like any other.
  - **Read back live 22:38 AEDT:** route enabled, cascade `[qwen3-30b]`, not held, USD 0 spent; job active; 5 settings as above; 0 rows claimed; 9 register rows; promotion function md5 `c9239d35` (unchanged); 0 models qualified for admission; G3 75 and 48, no drift.
  - **First run:** Wed 18 Nov 01:07 AEDT. Not yet observed: the worker mode has passed the type check, the guard spec and the unit checks of `boost.ts`, but has made no live model call. The first night's figures (courses read, model calls, verified, rejected, failed, cost) are to be read from the ledger and the route's spend on Wednesday morning and recorded here.
- **Benchmark plan (Qwen3 30B, Mistral Small 3.2, MiMo v2.6 Flash; all three are allowed models in the catalogue).** Live model calls run on production, where the key and the route are; the test project has neither. To build before Thursday: a benchmark mode that asks each candidate model, pinned one at a time through the platform AI evaluation framework, for the same fixed set of stored pages, writes nothing to the catalogue and reports per model the verified rate, the rejected and failed kinds, tokens and cost per verified field. NZ and CA can supply only 18 and 2 study-load pages, so their cohorts will be small until more of their course pages are stored.
- **Test project re-seed (after the rehearsal of Wed 18 Nov 10:30 AEDT and after Thu 19 Nov 03:30 AEDT).** Dispatch **Boost test project experiment** with `reseed` on and a new label (`run-3`, `run-4`); it re-seeds from [`paste/boost-test-reseed.sql`](paste/boost-test-reseed.sql), copies the promotion function from production and repeats the admitted-count run. Not during S1-Build's rebuild runs (the workflow shares no lock with `boost-test-rebuild.yml`; check that run has finished first).

- **Already live before this session (Pilot #1205, S1-Build; re-read 18:10 AEDT, unchanged):** `security.boost_promote_v1` (md5 `15be1ce6`), `security.boost_ingest_gate_v1` (md5 `9406870c`), job `worker-boost-bulk-ingest` (`*/5 * * * *`, active, catalogued, no number in its command) and the 11 `boost.*` settings. Gate read live: now = outside the window; Wed 01:10 = open; Thu 19 Nov 01:31 = blackout. The promotion function and the job were therefore not landed again.
- **Boost priority matrix as first landed, 17 Nov 2026 18:30 AEDT; store and categories superseded at 22:13 AEDT, see the block above** (Pilot #1209, migration `20261117183000`, guard spec s581; deploy on merge run 44039205199). One row `country_category_boost` in `pipeline.environment_settings` (category `boost`, `admin_edit`, status `configured`, not required for production).
  - **Cell weight** = country weight x category weight, or the cell's own weight under `cells` (key `COUNTRY.category`). Weight 0, or a country or category not listed, means not qualified for Boost work.

    | Country weight | | Category weight | |
    |---|---|---|---|
    | AU | 100 | `identity_registers` | 1.00 |
    | NZ | 95 | `geo_localities` | 0.95 |
    | CA | 90 | `tuition_fees` | 0.90 |
    | UK | 50 | `admissions_entry` | 0.85 |
    | IE | 45 | `intakes_delivery` | 0.80 |
    | US | 40 | `study_rules` | 0.75 |
    | | | `careers_outcomes` | 0.70 |
    | | | `scholarships_accred` | 0.65 |

  - **Tiers:** `[[AU, NZ, CA], [UK, IE, US]]`. Every cell of the first tier must outweigh every cell of the second (lowest first-tier cell CA `scholarships_accred` 58.5, rank 24; highest second-tier cell UK `identity_registers` 50, rank 25). `security.boost_country_category_check_v1()` refuses a setting that breaks this; run it after any edit.
  - **Read by:** `security.boost_country_category_matrix_v1()` (48 cells in priority order) and `security.boost_country_category_weight_v1(country, category)` (one cell; `GB` resolves to `UK`). Service role only.
  - **What it does not do.** It orders work only. It qualifies no model and does not change promotion, the gate or the job. Nothing reads it yet: the queue exporter (`scripts/boost-export-queue.sql`) is to order its queue by it when the Boost Worker is deployed.
  - **Starting values are a first setting, not a measured result.** The category order is the order of the instruction. `lane_category` maps four Boost lanes (`study_load` to `intakes_delivery`, `course_fees` to `tuition_fees`, `aer_entry` to `admissions_entry`, `provider_accreditations` to `scholarships_accred`); `course_description` has no category. Both are for the Platform Admin to confirm.
  - **Where the values sit (G2 note).** The instruction named `pipeline.environment_settings`, so the matrix is there and not in `pipeline.platform_toolset_settings`; it does not show on Settings › Pipeline settings. Editing it today is a SQL update followed by the check function.
  - **Read back live 18:31 AEDT:** head `20261117183000`, 2,067 applied; check `ok`, 48 cells; 3 register rows; 0 qualified models; no execute for anon or authenticated; promotion and gate md5 unchanged; G3 75 of 75 functions, 48 of 48 relations, no drift.
- **Boost test project experiments, run-1 (17 Nov 2026 18:22 AEDT; project `coursefinder-boost-test`, `ucdaaqrpgcldnatavmib`).**
  - **Cohort:** 69 real production course ids from 12 real providers (4 each AU, NZ, CA; the largest by course count), copied read-only: 60 courses with no study load and 9 that hold one. Titles and other fields were not copied. Production holds no UK, IE or US courses yet.
  - **Input:** synthetic worker result rows generated in SQL (no model was called): 70% `study_load`, 10% each `course_fees`, `aer_entry`, `course_description`; 80% verified, 12% rejected, 8% failed; 10% of study-load answers empty; 75% of rows from the model qualified in the test, 25% from an unqualified one. This mix is an assumption, not an observation.
  - **Method:** each batch size three times; staging insert, then `security.boost_promote_v1` (the production function, same md5) in one transaction; medians below. Timings are database time on the test project and exclude the edge function, Storage reads and network.

    | Batch rows | Nothing qualified: load / promote (ms) | rows/s | One model qualified: load / promote (ms) | rows/s |
    |---|---|---|---|---|
    | 50 | 2.5 / 6.7 | 5,471 | 2.2 / 13.5 | 3,182 |
    | 250 | 9.4 / 16.7 | 9,585 | 9.5 / 35.7 | 5,417 |
    | 500 | 18.3 / 29.6 | 10,430 | 18.3 / 58.1 | 6,571 |
    | 1,000 | 35.4 / 59.9 | 10,471 | 36.4 / 88.1 | 8,044 |
    | 2,000 | 73.3 / 122.2 | 10,243 | 74.3 / 183.6 | 7,797 |
    | 5,000 | 234.9 / 313.2 | 9,122 | 255.3 / 413.5 | 7,517 |

  - **Promotion outcome, 1,000-row batch.** Nothing qualified: 800 shadow, 200 refused, 0 admitted, 0 courses changed (shadow isolation holds at every size, 50 to 5,000). One model qualified for `study_load`: 352 rows admitted, 360 shadow, 288 refused; 60 of the 60 eligible courses filled.
  - **Zero-regression checks, every run:** 0 of the 9 courses that already held a study load changed; 0 `updated_at` values changed; G3 on the test project after the runs 75 functions, 48 relations, no drift. The test qualification row was removed and the cohort restored to its starting state (60 without a study load).
  - **Tuning read.** Throughput is flat from 500 to 5,000 rows, so the live values (`boost.ingest_rows_per_call` 500, `boost.promote_rows_per_run` 1,000) are not the limit; the worst promotion run took 0.42 s against the 5 s target. No setting was changed in production.
  - **Finding for the promotion function.** When a batch holds several verified rows for one course, every one is marked `admitted` although only the first writes (352 admitted rows for 60 courses). The catalogue is right; the admitted count overstates. A fix would mark the later rows refused ("already filled in this batch"). Not changed: it alters `security.boost_promote_v1` and needs its own dry run.
  - **Not measured, and why.** Model routing, field-level accuracy, token cost per admitted field and the Layer 4 escalation rate need real model output. The Boost Cloudflare Worker (`workers/cf-boost-extractor`) is not deployed and no AI-provider key is held by this session or the test project, so no figure is given for them. The test project also has no migration 20261117163500 objects (file ledger, gate, service calls) and no edge function, so the file path of `worker-boost-bulk-ingest` itself was not exercised.
  - **Evidence:** table `public.boost_experiment_runs` on the test project (36 rows, label `run-1`) and the 52,800 staged rows of batches `exp-*`.
- **Open items of 18:40 AEDT: all five decided by the Platform Admin at 21:18 and all five delivered** (block at the top of this section). Still open: the first night's telemetry; the benchmark mode; the re-seeds after the rehearsal and the squash.

### S1-Build Wave 2: staging retention, 7-year evidence floor, operations telemetry, live dry run (Platform Admin 17 Nov 2026 17:59, 18:02 and 18:25)

- **Live 17 Nov 2026 19:3x AEDT (deploy on merge run 44044011237; history md5 `5e3173b7` equals the file)** (Pilot #1212, migration `20261117200000`, guard spec s583; numbered s583 because #1209 and #1211 hold s581 and s582). Read back live: head `20261117200000`, 2,069 applied; all 7 settings at their defaults (pruning off); housekeeping-daily calls the retention step and stays active; the evidence purge carries the 7-year floor; the three retention classes, both tables (row-level security on) and 6 register rows present; views closed to anon and authenticated; `admin_ops_telemetry` not executable by anon. G3: 75 of 75 consumer functions equal their baseline md5, 48 of 48 relations, no drift flag.
- **Staging retention in `housekeeping-daily`** (03:47 AEDT) through `security.staging_retention_v1`:
  - applied Layer 1 staging rows (`pipeline.source_record_staging`, status `processed`) after 90 days, or the source's own period (`pipeline.source_retention_policies`, set by the Platform Admin with `public.admin_source_retention_set`, with a reason); never for a source with a Layer 1 run in progress;
  - Boost staging rows settled as shadow, proposed or refused after 90 days; admitted rows stay;
  - before a row goes, its hash, source and dates are written to `pipeline.staging_hash_ledger`, kept `retention.raw_hash_keep_years` (7);
  - published editions (`destination.editions`, `pipeline.layer1_dataset_editions`) and evidence are never touched (new retention classes `applied_source_staging`, `staging_hash_ledger`, `published_editions`);
  - **dry run until `retention.staging_prune_on` is 1** (the class catalogue requires a dry run first). Each night's report is an Admin event (area retention, action `staging_retention_dry_run`). Nothing is due tonight: the 3 `processed` Layer 1 rows carry no `processed_at` (so they are kept), and there are no Boost rows.
- **Evidence purge aligned (Platform Admin 18:25):** `security.retention_evidence_candidates_v1`, used by the retention estimate and the retention worker for category `evidence_unreferenced`, never offers evidence younger than `retention.raw_hash_keep_years` (7 years). Before this, unreferenced evidence could be purged after 7 days (last run 8 Oct 2026, 2,280 records).
- **Telemetry (read only, for S1-RM-Design's Ops report):** `pipeline.ops_l1_apply_latency_v` (each Layer 1 apply run: seconds, records, chunks of `layer1.register_apply_chunk`, ms per chunk), `pipeline.ops_l4_escalation_by_source_v` (per source: evidence captured, Layer 4 items raised, escalation rate, pending and aged), `pipeline.ops_boost_vs_pr3_throughput_v` (per Melbourne day: Boost files, rows loaded, settled and admitted beside PR 3 live runs, daytime runs, failures and time; shadow rows while PR 3 is in shadow). All closed to anon and authenticated; read through `public.admin_ops_telemetry()` (Curator and above). Look-back `telemetry.window_days` (30); aged Layer 4 item `telemetry.l4_aged_days` (7).
- **Settings** (Settings › Pipeline settings › Housekeeping): `retention.staging_prune_on` 0, `retention.staging_keep_days` 90, `retention.boost_staging_keep_days` 90, `retention.raw_hash_keep_years` 7, `batch.staging_prune_rows` 1000, `telemetry.window_days` 30, `telemetry.l4_aged_days` 7.
- **Rolled-back live dry run without prompts:** Pilot workflow `db-migration-dry-run.yml` (script `scripts/ci/dry-run-migration.sh`). A PR labelled `live-dry-run`, or a manual run with the project ref typed to confirm, runs each new migration on the Pilot inside a transaction that always ends in an exception: nothing is kept, no history row. For #1212 it caught a real error first (an alias), then passed (run 44039326181 and the re-run after rebasing).
- **Telemetry caveat:** the escalation rate divides Layer 4 items raised in the look-back by evidence captured in the same look-back. Register-style sources capture once and raise many items later, so their rate can exceed 1 (IRCC 117.9; items with no evidence source 2,623). The Ops report should show items and evidence side by side, not the rate alone.
- **Open:** a Settings screen for the per-source periods and the Ops report screen are S1-RM-Design's (the RPCs are ready). Turn pruning on after reading a nightly dry-run report.

### S1-Build lane: Supabase Auth, Boost prerequisites and paused jobs (17 Nov 2026; Platform Admin 13:11 and 14:12)

- **Supabase Auth (project `fxcwkweaxjtknorudmwp`), applied 14:33 AEDT** by admin workflow `supabase-auth-config.yml` (#547; run 44009123373) through the Management API, read back:

  | Setting | Before | Live now |
  |---|---|---|
  | `site_url` | `https://coursefinder-pilot.techm.workers.dev` (set by the Platform Admin) | unchanged |
  | `uri_allow_list` | empty | `https://coursefinder-pilot.techm.workers.dev/`, `https://coursefinder-pilot.techm.workers.dev/**` |
  | `mailer_subjects_invite` | You've been invited | You're invited to StudySearch Admin |
  | `mailer_subjects_recovery` | Reset your password | Reset your StudySearch Admin password |
  | Invite and Reset password templates | Supabase defaults | match `docs/paste/PASTE-20261117-supabase-invite-email-template.md` byte for byte |

  The workflow prints only these fields and the templates' md5, never the rest of the Auth configuration. Still to do (Platform Admin): step 4 of the paste doc, a test invitation and a password reset to an address you control, then delete the test user.
- **Boost staging prerequisites, live 14:37 AEDT** (Pilot #1199, migration `20261117152300`, guard spec s578): the private Storage bucket `staging-boost` (service role only, 52,428,800 bytes, `application/x-ndjson`, `application/json`, `text/plain`, 0 objects), and `pipeline.boost_inbound_staging` and `pipeline.boost_model_qualifications` (row-level security on, no read for anon or authenticated, 0 qualified models). Nothing is switched on.
- **`worker-boost-bulk-ingest` is built and wired, live 17 Nov 2026 17:01 AEDT (deploy on merge run 44027120386)** (Pilot #1205, migration `20261117163500`, guard spec s580; Platform Admin 16:15). Read back live: migration in the history (history md5 `93725fc9` equals the file; 2,065 applied; applied after `20261117170000` of Pilot #1206, which merged minutes earlier: a lower version applied later, as on 16 Nov; Thursday's squash takes both), job 431 active with the command above (no number), catalogue row area Boost, nonce allowlisted, all 11 `boost.*` settings, 5 register rows, row-level security on `pipeline.boost_ingest_files`, no execute for anon or authenticated, 0 qualified models, 0 files, 0 staged rows, 0 objects in `staging-boost`; edge function `worker-boost-bulk-ingest` version 1 ACTIVE, `verify_jwt` false, source equal to the file. Gate read live: now = outside the window; Thu 01:31 = blackout; at the read it also reported a real `admission-rule-runner-c` tick holding its lock (the lock check works on live locks). G3: 75 of 75 consumer functions equal their baseline md5, 48 of 48 relations present, no drift flag.
  - **What it does.** Job `worker-boost-bulk-ingest` (`*/5 * * * *`, catalogued in area Boost, nonce-allowlisted) calls edge function `worker-boost-bulk-ingest` (`worker-boost-bulk-ingest-v1.0.0`) only when the gate opens. The function reads `staging-boost/inbound/*.ndjson` (or `.jsonl`), claims each file once in `pipeline.boost_ingest_files`, loads its `kind: result` lines into `pipeline.boost_inbound_staging` and settles each batch with `security.boost_promote_v1` (admin `sql/boost-ingestion/002`, unchanged). A failed file stays `failed` until a person clears its row.
  - **When it runs** (`security.boost_ingest_gate_v1`, checked in this order): `boost.ingest_on` = 1; Pipeline Maintenance Mode off; Melbourne time 01:05–04:50; not inside the squash blackout (Thu 19 Nov 2026 01:30–03:30 AEDT); `housekeeping-daily` not running and started more than 20 minutes ago (it starts 03:47 AEDT and takes about 20 s, so the lane holds 03:47–04:07); and, checked by the function before each file, no PR 1 (`rollup-scheduler`), PR 2 (`admission-rule-runner` a, b, c) or PR 3 (`coverage-lane-dispatch` a, b, c) tick holds its lock. A held lock makes the function wait 5 s and look again (up to six times), then stop for that run. The PR 1 cutover review (Tue 17 Nov 23:20 AEDT) and PR 3 (06:45) fall outside the window.
  - **Settings** (Settings › Pipeline settings › Boost, toolset `pipeline`):

    | Key | Value | Range | Used by |
    |---|---|---|---|
    | `boost.ingest_on` | 1 | 0–1 | gate (the off switch) |
    | `boost.ingest_window_start_minute` | 65 (01:05) | 0–1439 | gate |
    | `boost.ingest_window_end_minute` | 290 (04:50) | 1–1440 | gate |
    | `boost.ingest_blackout_start_epoch` | 1795012200 (Thu 19 Nov 01:30 AEDT) | Unix seconds | gate |
    | `boost.ingest_blackout_end_epoch` | 1795019400 (Thu 19 Nov 03:30 AEDT) | Unix seconds | gate |
    | `boost.ingest_after_housekeeping_minutes` | 20 | 0–240 | gate |
    | `boost.ingest_files_per_run` | 4 | 1–50 | edge function |
    | `boost.ingest_rows_per_call` | 500 | 50–2000 | edge function |
    | `boost.quiet_window_start_hour` / `boost.quiet_window_end_hour` | 1 / 5 | hours | `boost_promote_v1` |
    | `boost.promote_rows_per_run` | 1000 | 1–5000 | `boost_promote_v1` |

  - **To stop it:** set `boost.ingest_on` to 0 (Settings › Pipeline settings › Boost, with a reason); the next run skips. Pausing the job on Automations also works.
  - **Nothing reaches the catalogue yet, for two reasons.** (1) No model is qualified (`pipeline.boost_model_qualifications` has 0 rows; the migration's post-check refuses any). (2) Nothing writes result files: the Boost Cloudflare Worker (`cf-boost-extractor`) and its exporter are built and tested locally but not deployed (they need the Cloudflare account and the AI-provider keys). Until both happen, each overnight run lists 0 files and exits. The "REQ and Roadmap chunks" in the 16:15 instruction are not a Boost input: the lane only reads Boost result files.
  - **Qualifying a model (Platform Admin, SQL editor).** Only `study_load` is ever admitted (only where the course has none and no manual lock); a row for `provider_accreditations`, `course_description` or `course_fees` only moves readings from shadow to proposed for that lane's own rule; `aer_entry` stays shadow. `provider` and `model` must match the Worker's result lines exactly.

    ```sql
    begin;
    insert into pipeline.boost_model_qualifications (lane, provider, model, qualified_by, qualified_at, reason)
    values
      ('study_load', '<provider, e.g. groq>', '<model, e.g. llama-3.3-70b-versatile>', null, now(),
       '<gate evidence: benchmark run, sample size, accuracy, date, who approved>')
    on conflict (lane, provider, model) do nothing
    returning lane, provider, model, qualified_at;
    select lane, provider, model, qualified_at, reason from pipeline.boost_model_qualifications order by 1, 2, 3;
    commit;
    ```

    Lanes allowed by the table: `study_load`, `provider_accreditations`, `course_description`, `course_fees`; `reason` must not be blank. Withdrawing a qualification is a delete, so it goes as a paste file.
  - **Dry run before merge** (production, rolled back): post-checks passed; gate now = outside the window; Thu 01:31 = blackout; Wed 03:00, Thu 01:10 and Thu 04:00 = open (4 files, 500 rows a call); 04:55 = outside; promotion dry run 0 rows; 5 register rows.
- **Paused for bulk ingestion, 13:34 AEDT** (Pilot #1195, migration `20261117051700`; 72-hour evidence from `security.job_outcomes_v1` and `cron.job_run_details`):

  | Job | Evidence |
  |---|---|
  | `scholarship-discover-refill` | hourly; 86 s a run, 102 busy minutes, 8 of 71 runs failed; it feeds the lane below |
  | `scholarship-discover` | 1 of 399 runs moved anything |
  | `scholarship-read` | 0 of 767 |
  | `calendar-reread` | 0 of 70 |

  Kept on: every job shadowed by PR 1, PR 2 or PR 3 (`coverage-reextract` and `policy-add-tests` are idle too but are PR 3 lanes), `openrouter-balance` (credit floor), and the jobs still moving work. **To resume:** Automations › the job › Resume (each pause is an Automations event with the reason).


| Item | State |
|---|---|
| Pilot #1200, #1208, #1210, #1213, #1215, #1216: CRICOS 11 Nov edition applied (Layer 1 register sizes and plan finish) | **Done 17 Nov 2026 20:11 AEDT** (S2-Build; Platform Admin 14:30). The edition's **1,953 of 1,953** planned course codes are in the catalogue (1,919 active, 34 inactive as the register marks them): run `4ae92b4f` applied 1,000, run `802d8928` the other 953 and reconciled. Causes found and fixed, each a size written into code or a slow statement under the service's 8-second limit: register apply calls (setting `layer1.register_apply_chunk`, now **20**, #1200, #1210), reporting stats made non-fatal (#1208), CRICOS facts call (#1213), courses per background batch (settings `layer1.batch_courses_au` 100 and `layer1.batch_providers_nz` 20, migration `20261117201000`, #1215), and the plan finish scanning the registrations once per new code (migration `20261117211000`, #1216; 1.1 s against more than 130 s). Workers: `layer1-au-depth` v1.9.2, `layer1-nz-live` v1.4.0, `layer1-au-cricos-facts` v1.4.0, `layer1-operations-control` v1.10.0. **Waiting on the Platform Admin:** 701 courses left the register, more than the automatic limit of 504, so their retirement is held for approval (run plan `802d8928`, departures `held`); 5 retired courses that are back on the register were reactivated. Specs s573, s584 |
| Pilot #1218, #1220: Wave 2 PR A, Layer 1 AI induction mapper (Mapper Contract v1.2) | **Live 17 Nov 2026 22:00 AEDT** (S2-Build; Platform Admin 17:55, 19:08, 19:58; AI routing choice 20:30: through the worker). Migration `20261117221000` (history md5 `3a69a2cb`); edge function `layer1-ai-induction-mapper` 1.0.0 (`status`, `map`; Curator and above); worker `coverage-sweep` v1.0.8 mode `induction_map` (prompt `induction.ts`, `induction-map-v1`). AI service route **`layer1_induction_map`**: one model `qwen3-30b` (central model, decision 13 Nov 19:09), provisional qualification on that decision, caps 2 USD and 200 calls a day; answer length `reading.answer_tokens.induction_map` (4,000). Declarative parser spec: allowed targets per record type `security.layer1_parser_targets_v1`, strict check `security.layer1_parser_spec_validate_v1` (fixed keys, types, transforms; attribution; unique key; expected headers), shared engine `_shared/cf247-layer1-spec.ts`. End-to-end check 21:56: the worker answered for 7 sample columns on Qwen3 30B (cost 0.00027 USD, recorded in `ai_invocations`, outcome answered). The wizard enables AI Auto-Map when `status` answers. Known limit: units are not converted (a "Duration (years)" column was suggested for `duration_weeks`; the person reviewing corrects it). Next: PR B (drift flags from the Layer 1 readers, re-infer job), PR C (generic runner and dry run). Spec s585 |
| Pilot #1201, #1207, RM1B ABS population and postcode loader | **Live 17 Nov 2026 18:40 AEDT** (S2-Build; approvals A-1 to A-4). Migration `20261117180000` (history md5 `e2e5fbd0`), edge function `layer1-destination-geo-loader` v1.0.0, job `destination-abs-load` (1st of the month 05:30 Sydney, catalogued, Run now through `security.destination_job_run_now_v1`), workflow `destination-abs-shares-load`. First load: 2,947 Postal Area to SUA shares for 2,641 postcodes (ASGS Edition 3 Mesh Block allocation files, sha256 `96c3ce68…52340`); **102 SUA localities** and 102 population figures (ERP 30 June 2025), all draft, attribution and evidence on every row (ABS workbook stored, sha256 `625c7c3d…eca39`); 1,303 locality postcode rows (1,064 primary, 239 flagged). Of 805 AU campus postcodes: 611 map at 90% or more, 94 are flagged (312 campuses in Layer 4 › Campus locality), 100 are outside any SUA (no locality; question to the Platform Admin). Spec s574 |
| Pilot #1162, API v3 field dictionary sync (REQ-76) | **Merged 16 Nov 17:05 AEDT** (taken over by S2 - SS Build): migration `20261116110000`, 1,923 rows live; 2 fields wait for the paste file |
| Pilot #1178, AER routes | **Merged 16 Nov 17:49 AEDT.** AER v1 entry reading (`course_entry_requirements`, `entry_matrices`) is **off**: Qwen3 30B unqualified, no model qualified. AER v2 shadow: Mistral Small 3.2 alone, provisional, off. See `docs/platform/layer4-clearance-and-model-benchmark-2026-11-16.md` §6 |
| Pilot #1179, worker v1.0.6 AER long pages | **Merged 16 Nov 18:02 AEDT**; the first deploy run failed reading migration history (Management API error) and the re-run passed. Worker `coverage-sweep-worker-v1.0.6` live from 18:05. Switch `reading.aer_v2_long_page_sections_on` = 0 |
| Split Pilot `docs/paste/` (41 files) | **Approved, Platform Admin 16 Nov 2026 10:10 (option 1).** After the PR 2 cutover (Tue 17 Nov 22:30 AEDT) is verified: the SQL files that specs or database fixtures read or run move to Pilot `tests/fixtures/` (all 18 guard specs keep their assertions, no cross-repository CI); every file a person runs moves to this repository's `docs/paste/` only; a Pilot guard then refuses any new `PASTE-*.sql` in Pilot. Queued for Wed 18 Nov 2026 09:15 AEDT, separate from the PR 3 queue. Never create a new `PASTE-*.sql` in Pilot. |
| UI/UX and settings simplification audit and plan | **Committed 16 Nov 2026 10:25 AEDT:** [`docs/platform/ui-audit/ui-ux-settings-audit-2026-11-15.md`](platform/ui-audit/ui-ux-settings-audit-2026-11-15.md), verbatim as supplied by the Platform Admin (decisions §6, UnoPim specs §7, progress to v2.16.12 §8). Phase 4 (Dispatcher Panels) waits for the PR 1 to 3 cutovers. |
| `cron-governance-audit-2026-11-15.md`, `rollup-scheduler-pr1-scope.md` | **Not yet in this repository.** The session that wrote them is committing them to `docs/platform/` before it closes (Platform Admin 16 Nov 2026 10:21). Until then, Pilot migrations and PRs #1157 and #1159 cite them as "project doc claude/…". |

### Production bulk data ingestion readiness (17 Nov 2026 08:50 AEDT; Platform Admin 07:39)

**17 Nov 14:05 AEDT:** the Admin screens are live (v2.16.19). The 19 November hold is cancelled (Platform Admin 13:12); loaders and ingestion are S2-Build's lane, and each load job named `destination-…` appears on Platform health › Data delivery › Destination loads once catalogued. Design for the screens, the API v3 blueprint and the ordered post-squash build is in [`docs/Roadmap/2026-01/DESTINATION-DATA-UI-AND-INGESTION-SPEC.md`](Roadmap/2026-01/DESTINATION-DATA-UI-AND-INGESTION-SPEC.md) v1.0 (v1.2; decisions G-1 to G-5 approved 17 Nov 11:52). The Destination data page is in `docs/UI-MAP.md` from v2.16.19.

Schema for every remaining roadmap item is live (Pilot #1194, migration `20261117040000`; design `docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md` v1.6). No destination data is loaded. Target rows marked "estimate" are planning figures to confirm at the first capture.

| Dataset or adapter | Target rows | Lands in | Entry point | Ready? | Blocker or next step |
|---|---|---|---|---|---|
| CRICOS 11 Nov edition | 1,953 waiting rows (1,596 changed, 357 new; read 17 Nov 06:5x) | Catalogue, through the Layer 1 register plan `d35d2541` | Layer 1 › Sources: apply the planned edition | Yes | Layer 1 owner to apply. 701 departures wait for the Platform Admin's approval |
| ABS population and ASGS postcodes | About 100 Significant Urban Areas (estimate); one population figure each; postcode shares for the 805 distinct AU campus postcodes (3,990 AU campuses) | `destination.localities`, `locality_metrics` (category `population`), `locality_postcodes` | Service-role upsert on the tables' unique keys; flags from `security.destination_postcode_flags_v1`; approve with `admin_destination_set_status` | Schema yes; loader no | Sources approved (A-1 to A-4). Build one catalogued load job; no direct Postal Area to SUA file exists in ASGS Edition 3 correspondences (checked 17 Nov), so the Mesh Block allocation (A-4) is the method. About 368,000 Mesh Blocks across three ABS files is beyond an edge function's 2-second CPU limit: the loader is planned as a catalogued GitHub Actions job (S2-Build) |
| BOM climate and living costs | Not set: localities with a campus × agreed measures | `destination.locality_metrics` (categories `climate`, `living_cost`) | As above | Schema yes | Sources and reuse terms not yet approved; needs localities first (RM1B) |
| JSA careers | About 350 to 360 occupations at four-digit level (estimate) | `destination.career_outcomes` through a `career_outcomes` edition | `security.destination_import_v1(payload)`; terms with `destination_edition_set_terms_v1`; publish with `destination_edition_publish_v1` | Yes for a national edition | Reuse terms (REQ-68) and edition choice. Confirm the edition's occupation coding matches a listed scheme (ANZSCO, NOC, SOC). G-1 grain is live (Pilot #1196): one row per edition, country, scheme, occupation and area (national, state or locality); `security.destination_import_v1` takes `occupation_scheme` (required), `geography_level`, `state_code`, `locality_id`, `reference_period`, `dataset_edition`, `attribution_text` |
| Study rules | About 15 to 25 AU rules (estimate): direct and five admissions-centre routes, funds, fee, work rights, post-study work, processing times | `destination.study_rules` and `rule_applicability`, through a `study_rules` edition | Visa rows: `security.destination_import_v1(payload)`. Categorised rules: service-role insert into a draft edition, then row approval, then edition publish | Schema yes; importer covers visa rows only | Capture each official page first. Extend the importer to the new rule fields with the first capture |
| NZQA courses | 3,894 four-digit candidates to match; 2,559 provider-style codes to classify | `catalogue.course_registrations` (scheme `nzqa`), course-level evidence | Layer 1 NZ adapter: new NZQCF qualifications capture | Schema yes; capture no | Build the capture. NZQA commercial-use terms flagged for management |
| UK, Ireland and USA adapters | Not set | Catalogue; schemes `uk_qaa`, `uk_ofs`, `ie_qqi`, `us_opeid`, `us_ipeds`, `hecos`, `cip` registered in `ref.registration_schemes` | None yet | No | Adapters RM3A, RM5A, RM6A are not built |
| Layer 4 Boost queue | 4,906 pending review items (read 17 Nov 08:44; 61,907 items in all) | `pipeline.layer4_review_items` | Layer 4 Review; Boost plan in `docs/platform/CF-WORKER-BOOST-AND-PROD-LAUNCH.md` | Existing path | Not changed by this release |

Order that unblocks the most: CRICOS apply, then the ABS load job (it gives every later city dataset its localities), then study-rule capture.

### Parallel Wave 2: Layer 1 induction wizard and completeness report (Platform Admin 17 Nov 2026 17:59, decisions 18:10; Pilot #1211, v2.16.24, 18:54 AEDT)

| Item | State |
|---|---|
| Wizard | Layer 1 › Sources › + Add source opens six steps: Country & scheme, Source & licence (REQ-68 terms), Field mapping, Cadence & retention, Dry-run preview, Activation. Drafts are saved at each step in `pipeline.layer1_source_inductions`. Pipeline Operator and above draft; the Platform Admin activates with a reason, logged. The source is created **paused** through the existing `admin_layer1_add_source`. No draft exists yet. |
| AI Auto-Map | **Off: the mapper `layer1-ai-induction-mapper` is not deployed** (S2-Build's lane). The button probes it and switches on by itself. Contract for S2-Build: `docs/platform/LAYER1-AI-INDUCTION-MAPPER-CONTRACT.md`. |
| Dry run | Recorded only by the service role (`svc_layer1_induction_dry_run_record`). A new source has no reader, so step 5 says Waiting for a reader; a recorded pass switches nothing on, and a recorded fail blocks activation. |
| Retention | The wizard records per-source values (defaults 14 days staging, raw snapshots permanent, as today's policy). **Not enforced:** `pipeline.retention_class_policies`, prune jobs and stored data are unchanged. |
| Enrichment categories | `ref.enrichment_categories` (8: Course basics, Fees, Entry requirements, Intakes & deadlines, Campus & location, Provider profile, Recognition & registration, Scholarships) and `ref.enrichment_category_fields` (the 32 coverage fields; 0 unmapped). The Platform Admin moves a field with a reason. |
| Category list (decided 19:58: one list) | `ref.enrichment_categories` and `ref.enrichment_category_fields` are the single list; `public.svc_enrichment_categories()` publishes it to every lane; keys, fields and the crosswalk are in `docs/platform/ENRICHMENT-CATEGORIES.md`. **Not yet one list in practice:** the Boost matrix setting `country_category_boost` and its check function still hold eight other keys (S2 - BOOST's lane). Moving it needs new weights for five categories and a decision on study rules and career outcomes, which have no key in the eight. |
| Report | Platform health › Country & category completeness (Curator and above): field fill by country and category from `pipeline.field_coverage_daily`, each Layer 1 source's editions, last change and retention, Layer 4 items by how long they have waited (settings `health.layer4_age_warn_days` 7, `health.layer4_age_old_days` 30). First read 17 Nov: AU entry requirements 29.9%, intakes & deadlines 18.9%, scholarships 5.8%; NZ fees 22.9%; CA fees 19.2%. A category figure pools its fields, so course and provider fields are counted together. |
| Parser line items (v2.16.25, Pilot #1214, 19:09 addenda) | Layer 1 › Sources has a Parser column: Hardcoded parser, AI-built parser or No parser yet, from `pipeline.layer1_source_parsers` (`admin_layer1_parser_status`). Live now: 43 sources, all Hardcoded, no parser row yet (AU 9 including CRICOS, QILT, PRISMS and TEQSA; NZ 2; CA 26; 3 world rankings with no country). ABS is a destination load job, not a Layer 1 source, and there is no UK, IE or US source yet, so the Country filter does not list them. |
| Re-infer Parser Spec | Shown on a line only when a reader has flagged layout drift (`svc_layer1_parser_drift_record`). Pipeline Operator and above, with a reason; recorded on the parser row and in the control log; nothing is run. **No reader flags drift yet**, so the button does not appear today. |
| Target record type | Wizard step 1: Course register, Provider register, Tuition fees, Study rules, Destination metrics, Career outcomes, Scholarships. Step 3 previews the mapper's parser spec, target table and category routing when the mapper returns them; on activation the spec becomes the source's AI-built parser. Contract v1.1 for S2-Build. |
| Per-source retention (decided 19:58: one place) | The wizard keeps one optional Staging kept (days) and, on activation, sets it through S1-Build's `admin_source_retention_set` in `pipeline.source_retention_policies`, which `housekeeping-daily` reads. The completeness report reads the same table and the `retention.*` settings (90 days, hashes 7 years, pruning off). No source has its own period yet. |
| Role gates (decided 20:45, by role name) | Curator (rank 3) and above open Layer 1 and create, edit and cancel drafts; Pipeline Operator (rank 4) and above request Re-infer Parser Spec; only the Platform Admin (rank 6) activates. `security.admin_layer1_operations_read` now opens at rank 3 (md5 `3af9dff0`). Every other Layer 1 control keeps its rank; `layer1_statistics_candidates_read` stays rank 4, so a Curator does not see new-edition candidates. |
| Deployed UAT on `main` (22:50 AEDT) | **Red, for a new reason.** (1) Fixed: `layer1-operations-deployed.spec.mjs` expected no + Add source for the UAT operator and had failed since v2.16.24; Pilot #1222 (`fd9eb052`, test only) now checks that the operator opens the wizard and cannot activate. (2) Open: at 22:16 to 22:17 AEDT a password reset was sent for the UAT account from the Admin, its link was used and the password changed, so the workflow's stored `UAT_PASSWORD` no longer signs in (Supabase Auth answers Invalid login credentials). Every Deployed UAT run fails at sign-in until the secret and the account match again. (3) Watch: two earlier runs also saw `admin_read` (`dashboard`) time out under load (21:43 and 21:57 AEDT). |
| Evidence and Layer 4 items (20:06) | Country & category completeness has the table Evidence captured and Layer 4 review items, by source, from S1-Build's `admin_ops_telemetry()`: two counts side by side, no rate. Live example: IRCC Designated Learning Institutions, 7 evidence captures and 825 review items in the window. |
| Not checked | The wizard and the report signed in; `admin_completeness_report` called as a signed-in user (its queries were read live separately). |

### Release v2.16.20, Users & roles › Links & Email Templates (Platform Admin 17 Nov 2026 14:40; Pilot #1202, 15:25 AEDT)

| Item | State |
|---|---|
| Screen | Administration › Users & roles now has two tabs (it had none): Users & roles, and Links & Email Templates (Platform Admin). Link settings, Invite User and Reset Password editors with variable chips, live preview, Reset to Default, Send Test Email, Save & Sync with a reason. |
| Database | `admin_auth_template_settings_read()` and `admin_auth_template_settings_save(payload, reason)` (rank 6; the save writes `pipeline.admin_control_events`, area `access`). One row `admin_auth_email_templates` in `pipeline.environment_settings`, written on the first save; until then the branded defaults apply. It shows read only on the Go-live checklist. |
| Copy to Supabase Auth | **Off.** `admin-user-management` copies the site URL and the two emails to Supabase Auth only when the Edge Function secret `SB_MANAGEMENT_TOKEN` (a Supabase access token for project `fxcwkweaxjtknorudmwp`) is set. Until the Platform Admin sets it, a save is stored and logged and Auth keeps the emails pasted from `docs/paste/PASTE-20261117-supabase-invite-email-template.md`. |
| Where links return | Still the edge function's `ADMIN_LOGIN_URL` (default the Worker address) and the Redirect URLs list in Supabase Auth. The Admin Site URL setting does not change the redirect by itself. |
| Signed-in test (Platform Admin, 15:45) | An invitation arrived with the indigo template applied at 14:33 and the sender "Supabase Auth". Nothing has been saved on the tab yet (no row in `pipeline.environment_settings`). |
| Emails in Supabase Auth now | **The `#0b6e5f` StudySearch PIM Admin templates, applied 17 Nov 16:04 AEDT** by workflow `supabase-auth-config.yml` (run 44021389741, read back PASS): subjects "You're invited to StudySearch PIM Admin" and "Reset your StudySearch PIM Admin password"; template md5 `f34516d2` (invite) and `e7fe57cf` (reset), equal to steps 2 and 3 of the paste file, which now hold the tab's defaults as Auth reads them. Site URL and redirect list unchanged. |
| v2.16.21 (Pilot #1203, 16:00 AEDT) | Users & roles: **Resend invite** on the row of a person who has not accepted yet (`admin-user-management` action `resend_invite`, recorded as `user_invited` with `resent`). Reset password has been on the row since v2.16.16; it is greyed for your own account and a Platform Admin. Links & Email Templates: a warning while the token is missing, with **Copy HTML for Supabase Dashboard** and Copy subject. |
| `SB_MANAGEMENT_TOKEN` | **Decided 17 Nov 16:13: not set.** No account-wide token is kept in the edge function. Supabase Auth's own templates are updated by workflow `supabase-auth-config.yml` from the paste file; Copy HTML stays on the tab. |
| Empty name (v2.16.22, Pilot #1204) | `{{user_name}}` becomes a conditional that takes its comma or space with it: "Welcome" and "Hello,". Applied to Supabase Auth 16:31 AEDT (workflow run 44024617120, read back PASS; md5 `e96fd944` invite, `d43f6e72` reset). |
| Email delivery provider (v2.16.23, Pilot #1206) | Links & Email Templates › Email delivery provider: Supabase Built-in or Resend API, Sender Name (default StudySearch PIM Admin), From Email, and a write-only Resend API key. Provider, sender and from email are the row `admin_email_delivery` in `pipeline.environment_settings`; the key is in Supabase Vault (`admin_resend_api_key`), read only by `svc_admin_email_delivery()` (service role). With Resend in use, Create user › Send invitation, Resend invite, Reset password and Send Test Email are written from the templates saved on the tab and sent through the Resend API (`auth.admin.generateLink` makes the link). |
| Live state of delivery | **Supabase built-in** (read 16:53 AEDT): no provider saved, no key in Vault. Resend starts when the Platform Admin chooses Resend API, enters the from email and the key, and saves with a reason. |
| Still from Supabase Auth | *Forgot password?* on the sign-in screen, whichever provider is chosen. Its sender name changes only with custom SMTP: Go-live checklist row `auth_custom_smtp` (pending), scope in `docs/platform/SUPABASE-AUTH-CUSTOM-SMTP-RESEND-SCOPE.md`. |
| Not checked | Any email as received; a real send through Resend (no key exists outside the Platform Admin's hands); the deployed edge function version read back; a save, a test email and a resent invitation, signed in. |

### Release v2.16.16, Admin UI (overnight task, Platform Admin 16 Nov 2026 22:12; Pilot #1189, 17 Nov 00:53 AEDT)

- **Users & roles:**
  - **Reset password** for another person's account (edge function `admin-user-management`, action `reset_password`). Not for a Platform Admin, your own account, the system account, a disabled account or an open invitation.
  - **Send invitation** passes `redirectTo` = `https://coursefinder-pilot.techm.workers.dev/` and `data { role, role_code, guide_url, full_name }`.
  - Links open a set-password screen. The sign-in screen has Forgot password?.
- **Catalogue lists** (Providers, Courses, Locations, Scholarships, Course readiness): **Export CSV**, visible or all columns, with every filtered row.
- **Paths taken:** A for invitations (Supabase `inviteUserByEmail`); A for the export (shared `DataTable`).
- **Not done here:**
  - Resets are not written to the access history (`user_access_events` action check). Widening it is a migration for a later change.
  - The Supabase Redirect URLs allow-list and the templates: applied 17 Nov 2026 14:33 AEDT (section 5 › S1-Build).

### Order of work to the 20 Nov data admission delivery (Platform Admin 16 Nov 2026 10:59)

| When (AEDT) | Work |
|---|---|
| Tue 17 Nov 23:20 | PR 1 cutover review, after the fixed 24-hour shadow (fix live Mon 16 Nov 23:14) |
| Mon 16 Nov 23:15 | PR 3 scope, build and merge in shadow: **in shadow since Tue 17 Nov 06:21 AEDT** (Pilot #1188, 13 lanes) |
| Wed 18 Nov 06:45 | PR 3 cutover review (scheduled; 24 h shadow and PR 1 verified first) |
| ~~Tue 17 Nov 22:30~~ | PR 2 cutover: **done Mon 16 Nov 23:31 AEDT** (Platform Admin override 21:23) |
| Wed 18 Nov 09:15 | Pilot paste-file split (option 1) |
| Daily 08:05 | Telemetry tabs refresh (`Model_Tier_&_Token_Efficiency`, `Layer_Lifecycle_Funnel`) before the 08:15 report |
| ~~Tue 17 Nov 09:45~~ | API v3 data PR A and PR B: **done Mon 16 Nov 21:50 AEDT** (Pilot #1184; counts in section 5) |
| Wed 18 Nov 09:30 | **Phase 5 before Phase 4:** Review & Evidence DataGrid, first slice on Layer 4 › Inbox, with shared views `AER Audit Samples`, `Official URLs`, `Provider Blockers`, personal views and the quote-versus-value drawer. Phase 4 (Dispatcher Panels) follows Phase 5 |
| Tue 17 Nov 07:30 | **AER benchmark round 3: done, Path B** (Pilot #1191 and #1192; runs 24 to 26). Mistral failed the gate: 13/50 right, error 22 pts, source integrity 85.7%, 1 false positive. AER v1 and the v2 shadow stay off; nothing qualified; no re-reads. Benchmark report §6.1 |
| Tue 17 Nov 13:15 | **PR E:** grade scales (REQ-19, scale decided 16 Nov 16:52) and destination draft editions; plan section 6 |
| Wed 18 Nov 13:30 | **API v3 data PR C** (AACSB/EQUIS/AMBA accreditations from the official lists, on demand) then **PR D** (v3 reads the four fields) |

### Course descriptions (v2.16.13 and v2.16.14, 16 Nov 2026)

- **Rejection memory (v2.16.13, Pilot #1174):** only a person's decision counts as an earlier refusal; rule `cdesc-machine-v2`. 492 admitted in the first 30 minutes; the waiting count went below the 1,500 back-pressure limit at 12:24.
- **Prompt v3 (v2.16.14, Pilot #1175):** no introducing opener sentence ("The <course> at <provider> is a ..."). By the existing rule, waiting v2 descriptions declined for good are superseded and read again with v3 (400 of 782 by 13:14; 790 waiting).
- **Retry gate:** the second model only for `enrich.cdesc_retry_rules` (`quote_not_on_page`, `identity_margin_thin`). Before: Mistral retries rescued 18.6% (1,095 admitted a day). Watch `retry_rescue_rate_pct` and `first_pass_admit_rate_pct` on `Model_Tier_&_Token_Efficiency`; the list is changed with a reason in Settings › Settings › Course description and deadline.
- **Ledger:** every AI attempt is written as it completes (worker v1.0.5), which closes the HTTP 546 gap found in the check below; the spend the ledger missed is shown daily as `unlogged_546_gap_usd` (US$0.96 for 15 Nov UTC).
- **Readings (13:36):** resumed with v3 (13:23 run succeeded; 3 AI calls by 13:35), but throttled by the rolling 24-hour cap `enrich.course_text_items_per_day` (8,000, full with the 15 Nov 16:00–17:00 re-read wave). Bulk v3 re-reads, including the 782 superseded descriptions, start at the 16:23 or 17:23 run. 15 waiting in Layer 4; 892 admitted by `cdesc-machine-v2` since 11:53.
- **Next bottleneck:** about half of first descriptions are declined by the machine for page binding (`identity_margin_thin`, `binding_ambiguous`) and wait for a person, which holds the queue near the 1,500 limit. Phase 5 (Layer 4 grid, Wed 09:30) is aimed at them.

### AI token efficiency check (read only, 16 Nov 2026 12:40 AEDT)

Read-only queries only (`set transaction read only`, 20 s limit), on project `fxcwkweaxjtknorudmwp`, Supabase logs and Pilot `main` 6bfadf0 (worker `coverage-sweep-worker-v1.0.4`). Nothing was changed. The PR 1 cutover (22:30 AEDT) was not touched. Days are UTC days.

**1. Pre-AI gate and duplicate input: not in place for `enrich_ai`**
- The admission gate (`admission-gate.ts admit`) is called only in mode `scholarship_ai` (index.ts about line 2234). `admission.gate_on` is 0 there: `pipeline.pre_ai_admission_decisions` has 0 rows in 3 days.
- `enrich_ai` (description, intakes and the other course fields) sends every leased item. Neither the worker nor `public.svc_enrich_ai_next` checks any of these before calling OpenRouter:
  - (course, field, page content hash, prompt version);
  - a minimum readable text length;
  - the page's identity status.
- Measured over 24 h on `pipeline.field_enrich_items`:
  - Description: 13,121 paid reads cost $9.01. 2,741 of them re-read a course and page already read in the window (about $1.91). Only 3 of those pairs had the same prompt version: the rest are the one-off re-read when `cdesc-source-grounded-v2` was released (15 Nov 05:00 UTC), and 1,110 of them were held again.
  - Intakes: 67 items, none with an identity reason.
- So a gate on (entity, field, hash, prompt version) would save almost nothing day to day. Its value is stopping re-reads that will predictably be held again.
- The 55.7% `DUPLICATE_HASH` and 73% `IDENTITY_MISMATCH` figures could not be reproduced from these tables. The query behind them is needed before building the gate on them.

**2. Prompt caching and `cached_tokens`: not used and not recorded**
- The course description request (`course-text.ts cdescRequest`) puts the static system prompt (`CDESC_SYSTEM`, about 2.5 KB) and the JSON schema ahead of the dynamic page JSON. The order is right for caching.
- No `session_id` is sent and there is no `cache_control`.
- `cascade.ts note()` keeps only `prompt_tokens`, `completion_tokens` and `cost`. `pipeline.ai_invocations` has no `cached_tokens` column.
- The static prefix is about 600 to 800 tokens of an average of 3,408 input tokens (Qwen, course description). That caps the possible input saving at about 20%, and only on providers that cache implicitly.
- The Mistral re-ask is a different model, so it cannot use Qwen's cache.

**3. Ledger drift: cause found**
- 15 Nov: at 21:15 UTC the key showed $10.81 against $9.84 in `pipeline.ai_invocations`. At day end it was $10.99 against $10.03, a $0.96 gap.
- The gap sits in the hours with `coverage-sweep` HTTP 546 (worker limit) responses:

  | Hour (UTC) | 546 responses | Gap |
  |---|---|---|
  | 03 | 114 | $0.56 |
  | 04 to 06 | 88 | $0.25 |
  | 14 to 15 | 52 | $0.08 |

- Hours with only HTTP 500 responses (07 to 12 UTC) drift by less than $0.02 an hour.
- Cause: the attempt trace is written once, at the end of a worker call (index.ts about line 529, `svc_ai_model_answered_v1`). A call killed by 546 loses every attempt it had already paid for.
- Minor: 924 failed attempts on 15 Nov carry no cost (time-outs and thrown errors).
- **Action:** write attempts as they complete (or flush in batches during the call), and keep `usage.cost` on errors where OpenRouter returns it. Separately, reduce 546s in `enrich_ai` course description calls: fewer pages per call at peak, through the existing setting.

**4. `unsupported_sentence` holds on `cdesc-source-grounded-v2`: top three causes**
- 2,249 holds since 15 Nov 05:00 UTC, 2,243 of them on Qwen first answers. The threshold is `pdesc.support_min_share` 0.6, a provider-description setting reused here. The three groups overlap.
  1. **The opening identity sentence: 1,857 holds (83%).** Sentences like "The <title> at <provider> is a …". The check strips the known title and provider before scoring (`security.cdesc_known_strip_v1`), so the framing left over ("is a qualification offered by …", 817 holds) is scored against a quote that does not contain it.
  2. **Level, credit or duration facts not in the cited quote: 750 holds (33%).** For example AQF level, credit points or full-time years.
  3. **Audience framing ("designed for …", 356, 16%) and near-empty sentences after stripping (280, 12%).** For example "The is offered by the.", support 0.
- **Re-asks to Mistral:** 9,087 Qwen answers led to 5,786 re-asks (64% in this window). Only 1,552 items ended with the Mistral answer (1,533 filled or in review), about 27% of re-asks. About 4,200 re-asks bought nothing (about $1.70 at $0.00041 a call).
- **Action, to decide (prompt and check change, not made here):**
  - Tell the model not to open with an identity sentence.
  - Or let that sentence draw on `VERIFIED_COURSE_FACTS` (title, provider, study level), with the check treating those facts as known in the same way.
  - Only re-ask when the hold is not one of these predictable patterns.

### Layer 4 clearance and AER model benchmark round 2 (16 Nov 2026 14:06–19:45 AEDT)

Full report: `docs/platform/layer4-clearance-and-model-benchmark-2026-11-16.md`.

- **Layer 4 waiting:**
  - 5,172 at 14:20; 5,136 at 16:28 after the reconcile switch; **4,916 at 19:20** after the official URL resolution (read back). `official_course_url` 1,328.
  - 651 new items arrived from other work between 16:28 and 18:48.
  - Since 16 Nov, items are decided or superseded faster than they arrive.
- **Switched on (Platform Admin approval, 15:56):**
  - `layer4.reconcile_supersede_on` = 1 since 16:00 AEDT.
  - Job `layer4-readiness` (:22, :52) supersedes waiting platform-kind items whose course or provider is retired, repeats, and items already decided. It never approves or rejects.
  - 36 retired-course official URL items cleared at 16:27.
  - Defect fixed in Pilot #1180 (migration `20261116143000`, live 18:47 AEDT): `layer4.reconcile_batch` (200) now caps items settled; the new `layer4.reconcile_examine_max` (5,000) caps items checked; `pipeline.layer4_reconcile_cursor` continues where the last run stopped, so no settleable item starves.
- **Official URL batch resolved (Platform Admin 16:47, 18:01, 18:44):** of 856 items, **836 closed and 20 open** (report §7).
  - 751 closed by rule `l4-link-refusal-v1` through "Refuse this proposal". 28 audit-sample items verified and closed; 4 unproven stay open.
  - 73 live-link conflicts: 56 verified valid and closed with the live link kept (26 are a finder defect, where the "other campus" named is the provider itself); 1 refused (Lead College 107328J, on the unlink-review list, recommendation keep); 16 unproven stay open.
  - No link or course record was changed.
  - #1177 (`20261116110000`) was refused by deploy (the version was taken by #1162) and renumbered as #1180.
  - **Pending for the Platform Admin:** paste file `PASTE-20261116-l4-lift-false-link-refusals.sql` (59 false finder refusals of verified live pages).
  - **S2 - SS Build regenerates the test register** for #1176, #1177 and #1180 (spec `s560`).
- **For the Phase 5 grid (Wed 09:30):**
  - 1,304 other official URL items, grouped by provider;
  - the 488 AER audit sample, which always stays with a person;
  - fees 146, provider descriptions 88, no-page samples 55.
- **For the AER session:** 1,604 quote_not_on_page items need a corrected read (AER v2 prompt v3), not a person.
- **Benchmark round 2** (runs 17 to 20, frozen 50-case set 5, Pilot #1176 `20261116100000`):
  - **No model qualifies.** Right answers on the 40 readable cases:
    - Gemini 2.5 Flash 11 ($0.0317 per right, p50 5.5 s);
    - MiMo v2.6 Flash 11 ($0.0053);
    - Mistral Small 3.2 10 ($0.0032; best source integrity, 83%);
    - Qwen3 30B 2 (18 timeouts).
  - 10 of the 50 pages are over `reading.aer_v2_page_chars` (60,000) and fail for every model.
  - Recommended candidate pins: Mistral Small 3.2 first, Gemini 2.5 Flash second. Retire Qwen3 30B from the AER path.
  - Spend $0.459; on-demand `ca8dee01` closed. `ai_eval.offline_runs_on` and `ai_eval.aer_v3_runs_on` are back to 0. Nothing was admitted.

### API v3 data admission: field lanes and 48-hour plan (16 Nov 2026 16:40 AEDT)

- **Plan:** [`docs/platform/API-V3-DATA-ADMISSION-PLAN-2026-11-17.md`](platform/API-V3-DATA-ADMISSION-PLAN-2026-11-17.md) (REQ-19, -52, -53, -57, -65, -67, -75, -76).
- **Schema is live, data is not:** `study_load`, `empty_reason_code`, `campuses.is_primary`, `catalogue.provider_accreditations`, `ref.grade_scale_conversions`, `destination.*` and `ref.api_field_dictionary` exist (migration `20261115190000`); all hold 0 rows or values.
- **PR 3 (Pilot #1188, built 23:25, not merged):** each field is declared as a lane in `pipeline.field_execution_registry`, disabled, with zero new cron jobs.
- **PR A and PR B filled live (Pilot #1184, migration `20261116180000`; run 16 Nov 21:50 AEDT on the Platform Admin's instruction), 8,516 values:**
  - primary campus on **356** providers (basis `cricos_head_office`; 7 with several matches and 1,193 with no match stay null; telemetry counts 354, because 2 of them have no active course);
  - campus-null reason on **5,639** courses (not published 5,104, online only 395, pending extraction 104, not on the register 29, source unavailable 7);
  - study load on **2,521** courses from stated evidence (full time 1,413, part time 183, both 925).
  - `updated_at` was not touched by the fills; G3 drift [].
- **Expected from the deterministic steps:** primary campus on 381 providers (registered head office matches exactly one campus); a campus-null reason on 5,639 courses; study load on about 2,671 courses from stated "full-time"/"part-time" evidence.
- **Corrections to the brief:** `catalogue.provider_registrations` holds 3,103 regulator registrations (CRICOS, IRCC DLI, NZQA), not 36,075, and none is a business-school accreditation: AACSB, EQUIS and AMBA come from each body's official list. There are 4,341 active campuses (not 3,880).
- **Decisions (16 Nov 16:52):** D-4 confirmed; 824 single-campus providers not marked; REQ-19 owned here (position on the qualification's own scale); destination drafts unpublished; Pilot #1162 merged. Plan section 5.
- **Daily admittance telemetry (Pilot #1183, 20:40 AEDT):** every API v3 and request-register field is recorded daily in `pipeline.field_coverage_daily` through the existing `platform-health` writer (no new job). `security.api_v3_daily_admittance_v1()` gives admitted, yesterday, daily gain, eligible and share per field. The sheet tab `API_v3_Daily_Admittance` is filled by the 08:05 task. Contract and the 16 Nov baseline: plan section 7.

### Layer 4 quick wins and pre-authorised gates (Platform Admin 16 Nov 2026 20:14)

| Item | Path taken | Result (live) |
|---|---|---|
| Official-URL finder false positives (from #1177 / #1180) | Fix shipped: Pilot #1181, migration `20261116150000`, md5-guarded edit of `security.course_page_check_v1` | **Campus:** a campus named like the provider is no longer "another campus" (all 26 such refusals).<br>**Sibling:** an address whose remaining words name this course is no longer a sibling's (double degrees, Dean's Scholar).<br>Re-check of the 1,868 refusals on record: 26 campus and 268 sibling no longer refuse; **none is accepted** by the fix alone.<br>Durham "Dental Assisting" and Wollongong BSc–BA stay refused: a near-duplicate course record holds the page. |
| A. Course page needed (2,058 asked; 2,113 open at 20:40) | **Path B.** No batch setting clears the list; each entry needs a person's choice or a paid search. Rule `cpn-settle-v1` (Pilot #1182) settles only entries whose outcome is on record. | One pass: **242 settled** (236 confirmed no page, 6 page already held); open **2,113 → 1,871**. The rest (including 454 with a bound page waiting) goes to the Phase 5 grid. |
| B. Course link same-domain alias duplicates | **Path B (fewer than 100):** 5 strict matches (31 on a loose pattern) among 1,328 open course-link items | No custom rule; left for the Phase 5 grid. Separately, 229 open items propose the page already held: a Layer 4 rule candidate. |
| Tue 07:30 AEDT, AER round 3 | Gate written into the scheduled task | **Pass** (100% source integrity, at most 10 error points, 0 false positives): qualify Mistral Small 3.2 on the v2 shadow and re-read the held items through the admission rule (audit samples stay with a person).<br>**Fail:** stay off, no further spend, failure buckets logged. |
| Tue 13:15 AEDT, PR E | Written into the scheduled task | About 20 official scales as drafts and AU destination drafts (unpublished). An approval table comes to the Platform Admin before Wed 13:30. |

Layer 4 pending at 20:49 AEDT: **4,902**; at 23:36 AEDT: **4,904**.

**229 identical-URL course-link items (Platform Admin 21:03, rule if 150 or more): Path B.** All 196 unclaimed items are housekeeping H13 old-year addresses (187) or E16 two-page cases (9), genuine questions under the 4 Nov decision (migration `20261104570000`). No rule; nothing run.

| Kind | Pending |
|---|---|
| `course_entry_first_read` | 2,578 |
| `official_course_url` | 1,328 |
| `course_description_first_read` | 613 |
| `provider_current_tuition_validation` | 146 |
| `provider_description` | 88 |
| `entry_matrix_first_run` | 77 |
| `no_page_first_run` | 55 |
| other | 17 |

### Cloudflare Worker Boost and production launch rehearsal (16 Nov 2026 20:31–21:05 AEDT)

Design, decisions, results and setup checklist: `docs/platform/CF-WORKER-BOOST-AND-PROD-LAUNCH.md`.

- **Built, not deployed or applied.**
  - Read-only queue exporter (`scripts/boost-export-queue.sql` / `.ts`).
  - Free-tier Cloudflare Worker with a Google → Groq → Mistral → OpenRouter failover chain (`workers/cf-boost-extractor/`). Each result names its one model, and quotes and values are checked before anything is written.
  - DRAFT staging and promotion SQL (`sql/boost-ingestion/`, quiet window 01:00–05:00 AEDT).
  - The 4-point harness (`scripts/test-boost-e2e.sh`).
- **Paths taken:** fixture (the registry is not live before PR 3), standalone Worker, staging table (no Layer 4 intake function exists).
- **Nothing is admitted from an unqualified model.** `pipeline.boost_model_qualifications` starts empty. AER results are shadow only. Accreditations are only proposed until PR C's official lists match them.
- **Harness:** points 1 to 3 pass (point 3 on a local Postgres stand-in). Point 4 (replay of the 2,043 live migrations; the repository holds 696) waits for the parallel test project.
- **Next:** the Platform Admin's 5-step setup (document §8). The staging SQL reaches production only as a Pilot migration after its rolled-back dry run.
- **Setup steps 1 to 4 (21:09 request; document §11).**
  - **Test project:** `coursefinder-boost-test` (ref `ucdaaqrpgcldnatavmib`, ap-southeast-2) created 21:02 AEDT, empty. This is a third project in the organisation, beside production and coursefinder-demo.
  - **Rebuild:** `.github/workflows/boost-test-rebuild.yml` (here) replays the 2,043 live migrations read-only from production onto it, then runs G3, point 3 and the 50-item shadow check. It needs `SUPABASE_ACCESS_TOKEN` set on this repository (today it is on Pilot only), then `gh workflow run boost-test-rebuild.yml -R msinghbs-ai/coursefinder-admin -f test_project_ref=ucdaaqrpgcldnatavmib`.
  - **Point 3 and the shadow-only check on local Postgres 16:** 1,000 rows in 0.011 s. With nothing qualified, 50 verified rows gave 0 admitted and 0 courses changed. Rehearsal 1/2/2; window refusal enforced; nothing left behind.
  - **Bucket:** `docs/paste/PASTE-20261116-staging-boost-bucket.sql` (not run).
  - **Test project rebuild, run 43851316573 (22:32 AEDT; document §12):** 2,046 migrations exported read-only from production; replay applied 1,004 and failed 1,042.
    - The first failure (`20260813035800`) needs data that production loaded at run time, and the failures cascade from there. G3 and point 3 could not run there.
    - **Finding:** production cannot be rebuilt from its migration record. A launch needs a schema dump, the reference data, then the newer migrations.
    - Proposed: reset the test project and rebuild it from the newest schema dump branch.
  - **Schema-dump route (Platform Admin 22:44, admin #532):** `scripts/boost-rebuild.py` and the reworked workflow reset the test project, apply the production schema dump, copy the reference and configuration data read only, then apply the migrations newer than the dump, and run G3, point 3 and the 50-item shadow-only check.
    - Dump: Pilot `db-schema-dump/43861191617` (16 Nov 22:50–23:04 AEDT, 10.4 MB, production head `20261116200000`). The dump held share locks for 14 minutes and blocked nothing.
    - **Rebuild run 43863252704 started 23:04 AEDT**; cancelled 01:25 AEDT after 2 h 20 min in the schema step (one API call per statement after a failed batch, no progress output). Fix admin #536.
    - **Run 43885548875 (01:25 AEDT): schema step stopped at its 90-minute limit, 3,698 of 15,936 statements, 1,258 failed** (document §12.1). Cause: the dump's session settings (`check_function_bodies = false`, `search_path = ''`) reached only the first batch, so functions failed before their tables existed, followed by their ALTER and COMMENT statements. No G3, point 3 or shadow-only result yet.
    - **Run 43940610220 (17 Nov 06:33, approved): schema complete, 15,936 of 15,936 statements in 297 s (the #537 fix works); verdict FAIL on the later steps** (document §12.2). 8 reference tables were copied before their parents, the G3 baseline table was not copied (G3 0/0), and the 005 rehearsal needed `pim.entity_registry` rows. The 3 newer migrations were refused by their own live-state gates, as expected on a project without cron jobs.
    - **17 Nov, fresh dump and three more fixes (document §12.3):** dump `db-schema-dump/43989024895` (11:36–11:50 AEDT, production head `20261117040000`, 8 `destination` tables). Runs 43991418340, 44004171402, 44009650216 and 44014040952 all slowed from statement 6,243. The cause was the reset: `drop schema pipeline cascade` failed with out of shared memory (too many objects for one transaction's lock table) and the run carried on over the previous run's `pipeline` schema. Fixes: an explicit transaction per call (#545), commit markers (#548), batch errors recorded (#550), and the reset drops a large schema in chunks and stops if one is left (#551).
    - **Run 44019730363 (15:48 AEDT, main `fdd8789d`): PASS on every check** (document §12.3). Reset clean; schema 16,033 of 16,033 statements in 275 s (105 calls, 0 failed); 6,911 reference rows in 39 tables; 7 of 8 newer migrations (the job pause `20261117051700` refuses on a project with no cron jobs, as expected).

      | Check | Result |
      |---|---|
      | G3: 75 functions, 48 relations, no drift | **PASS** (75, 48, drift `[]`) |
      | Bulk load of 1,000 rows under 5 s | **PASS** (0.038 s) |
      | 50-item shadow-only check: none admitted, no course changed | **PASS** (50 shadow, 0 admitted, 0 courses changed) |
      | Rehearsal: 1 written, 0 updated_at touched | **PASS** |
      | Outside the 01:00–05:00 window: refused | **PASS** |

      On the way: run 44015982270 (#551) failed on 005 (production requires `manual_locks.mode`) and G3; run 44017816120 (#553) passed point 3, and G3 showed 7 v2 read functions changed because the dump was read in text mode, which drops Windows line endings from their bodies (fix #554). Known and outside the verdict: `ref.study_level_source_mappings` refers to `pipeline.sources`, which is not copied.
    - **The Boost test project is rebuilt from production's schema and passes point 3.** `worker-boost-bulk-ingest` is live (Pilot #1205; see S1-Build above). Still open: a Platform Admin qualification row for each lane and model, and deploying the Boost Worker and exporter so result files reach `staging-boost/inbound/`.

## 6. Known gaps (not resolved, do not work around silently)

- `docs/platform/UI-CATALOGUE.md` and the `docs/README.md` row for it are behind the v2.16 screens.
- `docs/platform/COMPONENT-REGISTER.md` is the 15 Oct 2026 copy; the daily snapshot is on a Pilot branch, not here.
- This page is written by hand from live reads. Sections 3 and 4 should be generated from the live database at each release; until then, the reader checks the time on each section.
