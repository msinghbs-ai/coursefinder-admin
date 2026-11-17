# StudySearch – current state (read this first)

**Purpose:** one page a new coding session reads before anything else, so it starts from the live system and not from chat history. It says where each exact fact lives and what is in flight right now.
**Rule (Platform Admin, 16 Nov 2026 09:20):** every version bump, migration, or UI or scheduler change updates this page in the same release cycle, with the documents it points to. A fact here carries the time it was read; check the live system before relying on a figure older than a day.
**Last updated:** 17 Nov 2026 14:05 AEDT (release v2.16.19, Pilot #1197: Destination data page, Layer 4 kind Campus locality, `campuses[].locality` on API v3 providers; migration `20261117131500`). Before it: 17 Nov 2026 14:40 AEDT (S2-Build step 1, Pilot #1196: destination G-1 career grain and the destination field dictionary, migrations `20261117060000` and `20261117061000`; ABS loader runtime note in section 5), 17 Nov 2026 09:20 AEDT (AER benchmark round 3: Path B, Mistral failed the gate; Pilot #1191 and #1192; all AER entry reading stays off; benchmark report §6.1), 17 Nov 2026 08:50 AEDT (release v2.16.18, Pilot #1193 and #1194: destination data schema pack and API v3 `destination` action; migration `20261117040000`; bulk ingestion readiness checklist in section 5). Before it: 17 Nov 2026 07:15 AEDT (release v2.16.17, Pilot #1190: RM1A-3 register end dates; migration `20261117010000`; 2,051 applied), 17 Nov 2026 07:20 AEDT (Boost rebuild run 43940610220: schema complete, later steps FAIL with causes fixed; section 5), 17 Nov 2026 06:30 AEDT (PR 3 `coverage-lane-dispatch` in shadow since 06:21, Pilot #1188, 13 lanes; `coverage-ai-match` left out; section 4), 17 Nov 2026 03:30 AEDT (Boost rebuild: schema step stopped at its limit with one cause found and fixed; re-run waits; section 5), 17 Nov 2026 01:05 AEDT (release v2.16.16 live, Pilot #1189: invite and reset links to the admin sign-in, catalogue CSV export; no migration; Supabase dashboard paste doc pending; sections 3 to 5), 16 Nov 2026 23:45 AEDT (PR 2 cut over live 23:31 AEDT by S2 - SS Build under the Platform Admin's override of 21:23, Pilot #1185; PR 3 built in shadow as Pilot #1188, not merged: its live rehearsal waits for an approval; API v3 PR A/B fills live 21:50; sections 3 to 5), 16 Nov 2026 23:20 AEDT (PR 1 fix live 23:14 AEDT, Pilot #1187; fresh 24-hour shadow from 23:15 AEDT; cutover review Tue 17 Nov 23:20 AEDT; Boost test rebuild from the schema dump running, run 43863252704; sections 4 and 5), 16 Nov 2026 22:50 AEDT (PR 1 no longer blocks PR 3 or PR 2; PR 1 fix and new shadow, cutover Tue 22:30; section 4), 16 Nov 2026 22:50 AEDT (PR 1 cutover held: shadow fails the no-tick-over-budget criterion; section 4), 16 Nov 2026 21:25 AEDT (Boost setup steps 1 to 4: test project `coursefinder-boost-test` created; rebuild workflow waits for one secret; bucket paste file; sections 4 and 5), 21:05 AEDT (Cloudflare Worker Boost built and tested locally, nothing deployed or applied; section 5), 20:50 AEDT (Pilot #1181 finder fix, #1182 Course page needed settle, #1183 API v3 daily admittance telemetry; Layer 4 quick wins and the paths taken; Tue A/B gates; sections 3 and 5), 19:45 AEDT (Pilot #1180 live; official URL resolution of 856 items, Layer 4 4,916, new paste file; sections 3 to 5), 18:10 AEDT (Pilot #1162 field dictionary, #1178 AER routes and #1179 worker v1.0.6 merged; decisions of 16:52 in section 5), 16:45 AEDT (API v3 data admission plan in section 5), 16:40 AEDT (Layer 4 clearance and AER benchmark round 2 in section 5), 13:36 AEDT (course description readings in section 5), 13:25 AEDT (release v2.16.14: sections 2 to 5), 12:45 AEDT (AI token efficiency check in section 5), 12:26 AEDT (sections 3 to 5), 09:25 AEDT (rest), by the Course Module session (S2-CF), from Pilot `main` 8f53f8fd (#1173) and a read-only query of project `fxcwkweaxjtknorudmwp`.

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
| Visible release | **v2.16.19** (package 0.1.441; Pilot #1197, main `f8327605`, deploy-on-merge green 17 Nov 14:00 AEDT; Admin UI fitout RM0F: Destination data page with five tabs, Layer 4 Inbox kind Campus locality, adapted Course, Provider and Data delivery screens, `campuses[].locality` on API v3 providers; record in `docs/Roadmap/2026-01/DESTINATION-DATA-UI-AND-INGESTION-SPEC.md` v1.2 section 6). Before it **v2.16.18** (package 0.1.440; Pilot #1193 `76ff6b36` and #1194 `63deb84e`, deploy-on-merge green 17 Nov 08:43 AEDT; destination data schema pack and API v3 `destination` action; record in `docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md` v1.6). Before it **v2.16.17** (package 0.1.439; Pilot #1190, main `5430d822`, deploy-on-merge green 17 Nov 07:08 AEDT; RM1A-3: CRICOS registrations on the latest edition no longer end-dated; record in `docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md` v1.4). Before it **v2.16.16** (package 0.1.438; Pilot #1189, main `e301578e`, deployed 17 Nov 00:53 AEDT: deploy-on-merge, deployed UAT and release currentness green; edge function `admin-user-management` redeployed). Before it v2.16.15 (#1186). Worker coverage-sweep v1.0.6 |
| Newest migration applied live | `20261117131500` (Pilot #1197, destination Admin UI; applied 17 Nov 14:00 AEDT; history md5 equals the file; 2,058 applied). Before it: `20261117061000` (Pilot #1196, destination field dictionary: 2,071 current v3 fields, 148 of them `destination`) and `20261117060000` (Pilot #1196, G-1 career grain: key `career_outcomes_area_key`; importer body md5 `abf58405…`, read body md5 `40b256e6…`), applied 17 Nov 14:3x AEDT and read back. Before them: `20261117051700` (Pilot #1195, S1-Build: four low-yield jobs paused for bulk ingestion). Before it: `20261117040000` (Pilot #1194, destination schema pack; applied 17 Nov 08:43 AEDT; history md5 equals the file; 2,053 applied). `20261117030000` (Pilot #1193) was refused by the deploy step before anything ran and is not in the history; its file was reissued as `20261117040000`. Before it: `20261117020000` (Pilot #1191, AER v3 benchmark round 3). Before it: `20261117010000` (Pilot #1190, RM1A-3; applied 17 Nov 07:08 AEDT; 2,051 applied). Before it: `20261116220000` (Pilot #1188, PR 3 shadow; applied 17 Nov 06:21 AEDT). Before it: `20261116210000` (Pilot #1187, PR 1 fix; read 23:33 AEDT). `20261116190000` (Pilot #1185, PR 2 cutover) was applied after it at 23:31 AEDT (a lower version applied later; the deploy applies any version not yet in the history). `20261116180000` (#1184, API v3 PR A/B fill rules) 21:33 AEDT. Earlier: `20261116170000` (Pilot #1183, API v3 daily admittance; read 20:45 AEDT). Before it: `20261116160000` (#1182), `20261116150000` (#1181), `20261116143000` (#1180) |
| Migrations applied | 2,042 (18:49 AEDT) |
| Scheduled jobs (`cron.job`) | 191 active, 11 switched off |
| Components marked retiring | 46 settings, 30 functions, 14 screens, 8 jobs, 5 tables, 1 edge function |
| Tests | 701 specs, 3,301 tests (3,209 local, 92 deployed track; 17 Nov 14:05 AEDT, Pilot main `f8327605`) |
| UI | 21 pages, 53 tabs, 22 sub-tab bars, 178 folds, 39 drawers and dialogs (v2.16.19: Destination data added) |

## 4. Dispatchers, pending cutovers and pending paste files

Rule: Pilot `CLAUDE.md`, "Cron dispatchers" (register each legacy job byte for byte, 24-hour shadow cycle, then cutover; `cron.unschedule` by paste file after 14 days).

| Dispatcher | Jobs | State as read | Shadow since | Next step | Owner |
|---|---|---|---|---|---|
| Consolidation PR 1, `rollup-scheduler` | 25 report and cache targets (`pipeline.rollup_targets`; `layer2-onboarding-snapshot` stays on its own job) | **Shadow, fix live (16 Nov 2026 23:14 AEDT, Pilot #1187, migration `20261116210000`, main `396abc5f`)**. Read back live: tick md5 `36a8d4f314788d4a292bac677b568858`, shadow report md5 `465b6b4fa6cf9365f94036fb2adf77cf`; `housekeeping-daily` runs `select security.housekeeping_daily_v1(); select security.rollup_runs_trim_v1();`; `layer2-onboarding-snapshot` target disabled; 25 enabled targets, none live; 26 legacy jobs unchanged and active; no consumer API drift flag raised. The held 22:35 review (20 of 1,427 ticks over 60 s, all after the dispatch loop) is what the fix answers | **Fresh 24-hour shadow from 16 Nov 2026 23:15 AEDT** (first tick under the fix) | **Cutover review Tue 17 Nov 2026 23:20 AEDT** (scheduled), once the full 24-hour cycle ends at 23:15. Acceptance: all_match over 25 targets; no tick over 60 s since the fix; lag within one tick; no tick failure. The 22:44 target of 22:30 falls 45 minutes inside the cycle: the cutover waits for the full cycle unless the Platform Admin accepts the shorter window | The session that prepared PR 1. Do not touch from another session. |
| Consolidation PR 2, `admission-rule-runner` (lanes `-b`, `-c`) | 20 admission rules (`pipeline.admission_rules`) | **Live since 16 Nov 2026 23:31 AEDT** (Pilot #1185, migration `20261116190000`, main `3fa05b38`), cut over by S2 - SS Build under the Platform Admin's override of 16 Nov 21:23. Gate read 23:30 AEDT: shadow window 24.0 h, all 20 match, 0 minutes over capacity, 20 legacy jobs active with the registered md5 and schedule. Read back 23:33–23:36: 20 live, 20 legacy jobs off (`active = false`), 20 retiring (retire after 30 Nov 2026), 3 runner lanes on, 21 control events; first live runs 6 succeeded, 0 failed; G3 drift [] (75/48) | 15 Nov 2026 23:29 AEDT | **Done.** The other session's Tue 17 Nov 22:30 slot finds it cut over (the Platform Admin cancels it). `cron.unschedule` paste file `PASTE-20261116-admission-rule-legacy-unschedule.sql` on or after 1 Dec 2026 | S2 - SS Build (cutover); the session that prepared PR 2 |
| Consolidation PR 3, `pipeline.field_execution_registry` and `coverage-lane-dispatch` (lanes `-b`, `-c`) | 13 coverage worker lanes (course-link-search-worker, coverage-find-site, coverage-reextract, coverage-reidentify, provider-contact-page, provider-facts, companion-read, course-list-read, credential-read, policy-add-tests, programme-discover, programme-read, source-find), plus 7 API v3 field lanes declared disabled and never dispatched | **Shadow since 17 Nov 2026 06:21 AEDT** (Pilot #1188, migration `20261116220000`, main `d2afabfc`, spec `s567`). Two rolled-back rehearsals at 06:16–06:18, both passed with G3 equal: the full migration and the exact functions. Read back 06:23: all 13 lanes match their live job; 7 field lanes disabled; 3 dispatchers on and catalogued; 8 settings; shadow records arriving; G3 drift [] (75/48). **Left out:** `coverage-ai-match`, switched off on live 17 Nov 06:00 AEDT with no recorded reason (the Platform Admin chose 06:15 to take 13 and add it in a later change once it runs again); `calendar-reread` (S2-Intakes); `coverage-read` and `coverage-read-2` (30-second schedules) | — | Cutover review Wed 18 Nov 06:45 AEDT (scheduled): needs 24 h shadow, all 13 match, PR 1 cut over and verified | S2 - SS Build |

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
| `docs/paste/PASTE-20261117-supabase-invite-email-template.md` (Supabase dashboard, not SQL: Redirect URLs allow-list, Site URL, Invite user and Reset password templates for v2.16.16) | **Now**, before the next invitation or password reset is sent |
| `docs/paste/PASTE-20261116-staging-boost-bucket.sql` (private Boost bucket, idempotent) | Any time (Boost setup step 2) |
| `docs/paste/PASTE-20261116-api-field-dictionary-number-arrays.sql` | Any time (Pilot `20261116110000` is live); then a small migration loads the 2 held fields |
| `docs/paste/PASTE-20261116-l4-lift-false-link-refusals.sql` | Any time: lifts 59 false course-link refusals of live pages verified valid (Layer 4 report §7.3); stops unless exactly 59 rows match |

## 5. Open work in the repositories

| Item | State |
|---|---|
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

### Release v2.16.16, Admin UI (overnight task, Platform Admin 16 Nov 2026 22:12; Pilot #1189, 17 Nov 00:53 AEDT)

- **Users & roles:**
  - **Reset password** for another person's account (edge function `admin-user-management`, action `reset_password`). Not for a Platform Admin, your own account, the system account, a disabled account or an open invitation.
  - **Send invitation** passes `redirectTo` = `https://coursefinder-pilot.techm.workers.dev/` and `data { role, role_code, guide_url, full_name }`.
  - Links open a set-password screen. The sign-in screen has Forgot password?.
- **Catalogue lists** (Providers, Courses, Locations, Scholarships, Course readiness): **Export CSV**, visible or all columns, with every filtered row.
- **Paths taken:** A for invitations (Supabase `inviteUserByEmail`); A for the export (shared `DataTable`).
- **Not done here:**
  - Resets are not written to the access history (`user_access_events` action check). Widening it is a migration for a later change.
  - The Supabase Redirect URLs allow-list and the templates are dashboard settings: see the paste doc in section 4.

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
    - **Fixes ready (§12.2):** parents-first copy with retry passes, baseline table added, 005 registry rows (all tested locally). Next run: a fresh schema dump, then the rebuild. Waits for the Platform Admin.

## 6. Known gaps (not resolved, do not work around silently)

- `docs/platform/UI-CATALOGUE.md` and the `docs/README.md` row for it are behind the v2.16 screens.
- `docs/platform/COMPONENT-REGISTER.md` is the 15 Oct 2026 copy; the daily snapshot is on a Pilot branch, not here.
- This page is written by hand from live reads. Sections 3 and 4 should be generated from the live database at each release; until then, the reader checks the time on each section.
