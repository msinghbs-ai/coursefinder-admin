# StudySearch – current state (read this first)

**Purpose:** one page a new coding session reads before anything else, so it starts from the live system and not from chat history. It says where each exact fact lives and what is in flight right now.
**Rule (Platform Admin, 16 Nov 2026 09:20):** every version bump, migration, or UI or scheduler change updates this page in the same release cycle, with the documents it points to. A fact here carries the time it was read; check the live system before relying on a figure older than a day.
**Last updated:** 16 Nov 2026 22:50 AEDT (PR 1 cutover held: shadow fails the no-tick-over-budget criterion; section 4), 16 Nov 2026 21:25 AEDT (Boost setup steps 1 to 4: test project `coursefinder-boost-test` created; rebuild workflow waits for one secret; bucket paste file; sections 4 and 5), 21:05 AEDT (Cloudflare Worker Boost built and tested locally, nothing deployed or applied; section 5), 20:50 AEDT (Pilot #1181 finder fix, #1182 Course page needed settle, #1183 API v3 daily admittance telemetry; Layer 4 quick wins and the paths taken; Tue A/B gates; sections 3 and 5), 19:45 AEDT (Pilot #1180 live; official URL resolution of 856 items, Layer 4 4,916, new paste file; sections 3 to 5), 18:10 AEDT (Pilot #1162 field dictionary, #1178 AER routes and #1179 worker v1.0.6 merged; decisions of 16:52 in section 5), 16:45 AEDT (API v3 data admission plan in section 5), 16:40 AEDT (Layer 4 clearance and AER benchmark round 2 in section 5), 13:36 AEDT (course description readings in section 5), 13:25 AEDT (release v2.16.14: sections 2 to 5), 12:45 AEDT (AI token efficiency check in section 5), 12:26 AEDT (sections 3 to 5), 09:25 AEDT (rest), by the Course Module session (S2-CF), from Pilot `main` 8f53f8fd (#1173) and a read-only query of project `fxcwkweaxjtknorudmwp`.

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
| Visible release | v2.16.14 (package 0.1.436); Pilot `main` ee7fb575 (16 Nov 20:40 AEDT); worker coverage-sweep v1.0.6 |
| Newest migration applied live | `20261116170000` (Pilot #1183, API v3 daily admittance; read 20:45 AEDT). Before it: `20261116160000` (#1182), `20261116150000` (#1181), `20261116143000` (#1180) |
| Migrations applied | 2,042 (18:49 AEDT) |
| Scheduled jobs (`cron.job`) | 191 active, 11 switched off |
| Components marked retiring | 46 settings, 30 functions, 14 screens, 8 jobs, 5 tables, 1 edge function |
| Tests | 688 specs, 3,246 tests (3,154 local, 92 deployed track; 20:50 AEDT) |
| UI | 20 pages, 48 tabs, 17 sub-tab bars, 178 folds, 39 drawers and dialogs |

## 4. Dispatchers, pending cutovers and pending paste files

Rule: Pilot `CLAUDE.md`, "Cron dispatchers" (register each legacy job byte for byte, 24-hour shadow cycle, then cutover; `cron.unschedule` by paste file after 14 days).

| Dispatcher | Jobs | State as read | Shadow since | Next step | Owner |
|---|---|---|---|---|---|
| Consolidation PR 1, `rollup-scheduler` | 26 report and cache targets (`pipeline.rollup_targets`) | **Shadow, cutover HELD (16 Nov 2026 22:35 AEDT)**: 24-hour report all_match (26 of 26, no difference above 1); lags over 60 s only in the 15 Nov 23:00 AEDT incident hour (otherwise max 51 s, p99 31 s); no tick failure; 26 legacy jobs unchanged. **Fails the scope's third acceptance criterion, no tick over budget:** 20 of 1,427 shadow ticks ran 60.5 to 105.5 s (median 0.63 s), all at minutes ending in 6, with every dispatch done in under 1 s, so the time is spent after the loop (history clean-up and commit), beside `search-refresh-requested` (6-59/10). Live, a tick is one 120 s statement: `layer2-onboarding-snapshot` (p95 108 s, max 117 s) would be cancelled and retried every minute, starving the other hourly targets | 15 Nov 2026 22:22 AEDT | **Fix, then a new 24-hour shadow (decision for the Platform Admin):** history clean-up to `housekeeping-daily` (as the scope says); a live target's due minute recorded before it runs, so a cancelled run is not retried in a loop; targets whose legacy p95 is over the tick budget stay on their own jobs (now `layer2-onboarding-snapshot`). Legacy jobs keep running until then; nothing changed | The session that prepared PR 1. Do not touch from another session. |
| Consolidation PR 2, `admission-rule-runner` (lanes `-b`, `-c`) | 20 admission rules (`pipeline.admission_rules`) | **Shadow**: 20 of 20 in shadow; 574 due-records since start; legacy jobs still running | 15 Nov 2026 23:29 AEDT | **Cutover Tue 17 Nov 2026 22:30 AEDT** | The session that prepared PR 2. Do not touch from another session. |
| Consolidation PR 3, `pipeline.field_execution_registry` and `coverage-lane-dispatch` | Not scoped yet (the `calendar-reread` worker lane is named for it) | **Not built** | — | **Pulled forward 24 hours (Platform Admin 16 Nov 2026 10:59, for the 20 Nov delivery):** scope, build and merge in shadow from **Mon 16 Nov 23:15 AEDT**, once the PR 1 cutover is verified live. PR 2 and its 22:30 Tue cutover are not touched. Cutover no sooner than 24 hours after its shadow starts, and only after the PR 2 cutover is verified | Course Module session (S2-CF) |

Pending paste files (run by the Platform Admin; details and md5 in `docs/paste/README.md`):

| File | Run on or after |
|---|---|
| `docs/paste/PASTE-20261115-cron-legacy-jobs-drop.sql` | Part A any time; Part B from 29 Nov 2026 |
| `docs/paste/PASTE-20261116-retired-settings-drop.sql` | 29 Nov 2026 |
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

### Order of work to the 20 Nov data admission delivery (Platform Admin 16 Nov 2026 10:59)

| When (AEDT) | Work |
|---|---|
| Mon 16 Nov 22:30 | PR 1 cutover (unchanged) |
| Mon 16 Nov 23:15 | PR 3 scope, build and merge in shadow |
| Tue 17 Nov 22:30 | PR 2 cutover (unchanged) |
| Wed 18 Nov 09:15 | Pilot paste-file split (option 1) |
| Daily 08:05 | Telemetry tabs refresh (`Model_Tier_&_Token_Efficiency`, `Layer_Lifecycle_Funnel`) before the 08:15 report |
| Tue 17 Nov 09:45 | **API v3 data PR A** (primary campus by registered head office, campus-null reasons) then **PR B** (study load from stated evidence); plan below |
| Wed 18 Nov 09:30 | **Phase 5 before Phase 4:** Review & Evidence DataGrid, first slice on Layer 4 › Inbox, with shared views `AER Audit Samples`, `Official URLs`, `Provider Blockers`, personal views and the quote-versus-value drawer. Phase 4 (Dispatcher Panels) follows Phase 5 |
| Tue 17 Nov 07:30 | **AER benchmark round 3** (long-page sections on; Mistral, MiMo, Gemini 2.5 Flash; same set and limits). Qualifying is a separate Platform Admin step |
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
- **Tonight (PR 3, 23:15):** each field is declared as a lane in `pipeline.field_execution_registry`, disabled, with zero new cron jobs.
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

Layer 4 pending at 20:49 AEDT: **4,902**.

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

## 6. Known gaps (not resolved, do not work around silently)

- `docs/platform/UI-CATALOGUE.md` and the `docs/README.md` row for it are behind the v2.16 screens.
- `docs/platform/COMPONENT-REGISTER.md` is the 15 Oct 2026 copy; the daily snapshot is on a Pilot branch, not here.
- This page is written by hand from live reads. Sections 3 and 4 should be generated from the live database at each release; until then, the reader checks the time on each section.
