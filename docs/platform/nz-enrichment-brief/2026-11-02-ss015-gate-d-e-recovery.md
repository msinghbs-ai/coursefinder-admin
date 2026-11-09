# SS-015 accelerated acceptance: verification stream E (Gate D recovery items, part of Gate E)

**Prepared:** 2 Nov 2026, about 05:45–06:10 Melbourne time (live database clock read at 1 Nov 18:47 UTC)
**Scope:** alerting, interrupted-operation recovery, migration refusal and rollback, restore rehearsal, monitoring and on-call ownership, recovery instructions, cost and budget enforcement.
**Method:** read-only SQL on project `fxcwkweaxjtknorudmwp` only; read-only reads of the scheduled task list; repository reads of Pilot `main` `1f7d41aa` (v2.15.400) and `admin-fresh`; existing non-`@deployed` specs run from a scratch copy on port 5199; a throwaway local PostgreSQL 16.15 (socket `/var/lib/postgresql/streamE`, port 55495, PID 7303, stopped by PID at the end). Nothing was written to production, no failure was injected, no protection was changed, no Supabase branch or project was created, and nothing was pushed.

## Summary of verdicts

| # | Item | Verdict |
|---|---|---|
| D1 | Alerts, deduplication and escalation | **Insufficient evidence** (alerts and deduplication pass; escalation is a reminder to the same person and has never fired; receipt is unconfirmed) |
| D2 | Recovery from an interrupted operation | **Pass**, with one stale-status finding |
| D3 | Migration failure refusal and rollback | **Pass** |
| D4 | Isolated restore rehearsal | **Fail** (no data restore has been run; a schema-only rebuild was proven on 10 Oct; this session's local rehearsal shows git alone cannot rebuild the current head) |
| E1 | Monitoring and on-call ownership are defined | **Insufficient evidence** (monitoring is defined; ownership is one person with no deputy, no hours and no out-of-band watchdog) |
| E2 | Recovery instructions are usable | **Fail** (no database, Storage or cron restore runbook; no RPO or RTO; the recovery baseline is inconsistent and stale) |
| E3 | Costs and budgets are enforced | **Insufficient evidence**: partly enforced. Firecrawl daily shares and two monthly caps refuse work. The AI daily ceiling and the OpenRouter credit floor only raise notices, because OpenRouter is in `observe` mode. |

---

## D1. Alerts, deduplication and escalation: Insufficient evidence

**What passes**

- **Pipeline is live.**
  - Jobs `platform-health` (`8-59/10`) and `platform-alerts` (`*/10`) are both active, with 144 runs each in the last 24 h and 0 failures.
  - The "Work queue alerts" scheduled task (`trig_01Eo7QrJXR24e774gNzLUvTi`, `59 * * * *` UTC) is enabled, with push and e-mail on. Its last run (1 Nov 18:59 UTC) succeeded. Its prompt calls `platform_alerts_take_v1` and `platform_alerts_confirm_v1`.
- **Settings are as documented** (`pipeline.platform_toolset_settings`):
  - `alerts.delivery_enabled` true; `test_mode` false;
  - `min_severity` 3; `confirm_minutes` 15; `cooldown_minutes` 60; `reminder_hours` 12;
  - `max_attempts` 5; `retry_minutes` 10; `collect_within_minutes` 120;
  - `webhook_enabled` false.
- **Outbox (`pipeline.platform_alerts`, all rows):**

| id | kind | check | created (UTC) | sent (UTC) | attempts |
|---|---|---|---|---|---|
| 1 | test | alerts:test | 31 Oct 10:57 | 31 Oct 11:00 | 1 |
| 2 | raised (critical) | alerts:delivery_test | 31 Oct 10:57 | 31 Oct 11:00 | 1 |
| 3 | recovered | alerts:delivery_test | 31 Oct 11:10 | 31 Oct 12:00 | 1 |
| 5 | raised (critical) | coverage_queues:read | 1 Nov 15:40 | 1 Nov 16:00 | 1 |
| 6 | recovered | coverage_queues:read | 1 Nov 16:20 | 1 Nov 16:59 | 1 |

  - Ids 5 and 6 are a **real production incident delivered end to end** (2 Nov 02:40 → sent 03:00 Melbourne, recovery sent 03:59). This is new evidence after the SS-014 test.
  - The `dedupe_key` is `<issue>:<kind>`. The 14 occurrences of issue `03a7f35e…` produced one raised alert. Deduplication is proven live.
  - Id 4 is absent: the rolled-back failure dry run in record §32.1.
- **Failure visibility.** `platform_health_check_v1` raises:
  - `alerts:delivery_failed` (warning) for failed deliveries in 24 h;
  - `alerts:not_collected` (critical) when alerts wait longer than 120 minutes.
- **Specs.** `cf-247-s194-operational-automation-contract` (10 tests: dedupe, escalation, reminder, recovery, retries, test mode, acknowledge) and `cf-247-s193-health-alerts-cost-truth-contract` (4) pass locally. See "Local spec run".

**What is not proven**

1. **Receipt.** The Platform Admin has not confirmed that the [TEST] messages, or the real 2 Nov 03:00 critical, arrived. "Sent" means the task wrote its output, not that the phone or mailbox received it. The admin SOP says this too (`docs/sops/admin-sop.md` line 101).
2. **Escalation is a reminder to the same recipient.**
   - In `platform_alerts_evaluate_v1` the kinds are `raised`, `escalated` (severity rise of the same issue), `reminder` (12 h, unacknowledged) and `recovered`.
   - There is no second person, channel or tier.
   - No `reminder` or `escalated` row has ever been produced live, so escalation is untested in production.
3. **The watchdog cannot report its own channel failing.** `alerts:not_collected` is delivered through the same scheduled task that is not collecting. If the task, the Claude scheduler or the account fails, the only signal is the Platform health page.
   - Nothing alerts when there are no pending alerts and the task is dead.
   - Nothing alerts when `pg_cron` itself stops.
4. **Recovery notice on reclassification, not on recovery.**
   - The 2 Nov 03:18 "Recovered" (id 6) was sent when issue `03a7f35e…` closed.
   - The same queue still had 13–18 items waiting with nothing processed. The condition was reopened under new issue ids at `info` severity ("job is paused because its recent runs found nothing"): `6525753e…`, `d6b32e29…`, `13864ccb…`, `c85fb596…`, and `4ce85456…` (warning, open now).
   - The alert told the recipient "No action needed" while the queue was still idle. This is SS-004 territory (idle pause versus stall), but it affects alert trust.
5. **Delay.** Expected worst case is about 75 minutes. The live incident took 20 minutes from raise to send, but the issue was first seen at 00:58, so the person was told about 2 h after the stall began (by the stall threshold design).

---

## D2. Recovery from an interrupted operation: Pass (one finding)

**Design evidence (live definitions)**

- 106 functions reference a lease column; 26 use the reclaim pattern `leased_until < now()`.
- A sample of the claimers that do not match the simple regex still reclaim expired leases:
  - `svc_coverage_discovery_next`: `coalesce(d.leased_until,'-infinity')<now() and d.attempts<3`;
  - `svc_programme_next`: lease of 10 minutes, `-- fixed:`;
  - `svc_scholarship_discover_next`;
  - `svc_register_replay_next_v3`: `lease_until <= now()`, and after 3 calls without saving it closes with a named error.
- So expired leases are taken again with bounded attempts. A crash mid-claim does not strand work.
- The alert outbox also has `lease_until`, so an interrupted delivery is retried up to 5 times.
- `layer1_run_queue` and `layer2_run_batches` carry `heartbeat_at`.

**Live evidence (read-only, 1 Nov 18:5x UTC)**

- Across all 24 `pipeline` tables with a lease column:
  - 0 rows in a working state have a lease more than 1 h expired;
  - `coverage_course_pages` has 215 expired lease stamps, all on finished rows (bound, mismatch, ambiguous);
  - `toolset_sample_items` has 2,234, all `done`;
  - `scholarship_page_candidates` has 5 (no state column).
- `pipeline.admin_jobs`: 0 queued or running.
- Layer 4 timeout recovery (migration `20261101040000_cf247_l4_timeout_recovery`, record §35) was applied successfully in the local replay.

**Specs (pass locally)**

- `cf-247-s148-entry-exhausted-lease-contract`: an expired lease on its last try is closed as failed with the reason named.
- `cf-247-s197-ss004-reliability-contract` (6): stall age; cancelled-by-idle-pause classified as paused.
- `cf-247-s172-enrich-reliability-contract`.

**Finding**

- `pipeline.layer2_run_batches` id `dc4fabeb-532a-4536-9cbd-50d042e09f8c` has been `running` since 29 Sep 2026.
  - Heartbeat 11 Oct 21:55 UTC; `processed_count` 61,211 = `target_count`; `completed_at` null.
  - The work finished but the batch was never closed, and no health check flags a batch whose heartbeat is 21 days old.
- **Harmless to data, but evidence that one lane has no stale-heartbeat closer.**

**Limit:** I did not interrupt a live job, as directed. The evidence is design plus live state plus specs, not an induced crash.

---

## D3. Migration failure refusal and rollback: Pass

**Deploy script** `scripts/ci/apply-migration.sh` (read in full):

- **Refuses before running:**
  - a bad file name;
  - a top-level `drop`, `delete`, `truncate` or `alter table … drop`;
  - the `$mig$` history quote marker;
  - an unreadable history.
- **Already-applied version (UR-13):**
  - skipped only when the recorded `md5(statements[1])` equals the file;
  - otherwise refused with "an applied migration was changed. Nothing was run."
- **Apply:**
  - sends one query to the Management API: `begin;` + file + `insert into supabase_migrations.schema_migrations …` + `commit;`;
  - any error aborts the whole transaction, so neither the objects nor the history row persist;
  - an HTTP status of 300 or more exits 1 and prints the error;
  - after the apply, the history md5 must equal the file.
- **In-file guards.** Migrations carry md5 guards (`raise exception 'live % differs from the definition this change replaces'`) and post-checks that raise. Both run inside that transaction.

**Specs (pass locally)**

- `cf-247-s203-ur07-13-retired-jobs-migration-check-contract`, test "UR-13: absent version applies once; identical version skips after comparing; changed version is refused before anything runs". It executes the real script with a mocked API.
- `cf-247-s69-phase3-ci-deploys` (8): deploy order, safeguards kept, daily drift check.

**Local rehearsal** (throwaway PostgreSQL, a local mirror of the script's refusals and wrapper: `streamE/apply-local.sh`)

| Test migration | Result | State after |
|---|---|---|
| `…0001_e_fail_midway`: creates `rt.half_done`, inserts 1 row, then raises | FAILED: "deliberate failure after partial work" | table absent, no history row |
| Same file sent as **one** simple-query message (as the Management API does) | `ERROR`, rc=1 | table absent (f), history rows 0 |
| `…0002_e_md5_guard`: the real guard pattern with a stale hash | FAILED: "live rt.f() differs from the definition this change replaces" | `rt.f()` unchanged (1) |
| `…0003_e_md5_guard_ok`: correct hash | APPLIED, history md5 43f23967 | `rt.f()` = 2 |
| `…0004_e_drop`: top-level `drop table` | REFUSED (drop) before running | unchanged |
| `…0003` re-run unchanged | SKIPPED, same md5 | unchanged |
| `…0003` edited after apply | REFUSED: recorded md5 43f23967… ≠ file a6a69fc5… | unchanged |

"Rollback" here is the transactional refusal. Applied migrations are never reversed; corrections are forward-only (governance §9). That is the intended model.

---

## D4. Isolated restore rehearsal: Fail

**What backups exist (verified, not assumed)**

- **Plan.**
  - Organisation `rszbvkqopqfvjldvfnbh` ("techM") is on **Pro** (`get_organization`).
  - Supabase documentation: Pro projects have **daily backups, last 7 days**; PITR is a paid add-on (7-day retention about US$100 a month, and it needs at least Small compute).
- **PITR status: not verifiable with the tools available.**
  - The MCP tools have no backups endpoint.
  - `archive_mode=on` with WAL-G `wal-push` and `archive_timeout=120` is how Supabase takes physical backups on every project, so it does not prove PITR.
  - `pg_stat_archiver`: 59,864 WAL files archived, last at 1 Nov 18:46 UTC, 3 failures (last 26 Sep).
  - **Action:** the Platform Admin checks Dashboard › Database › Backups (or `GET /v1/projects/fxcwkweaxjtknorudmwp/database/backups`) and records whether PITR is on and which daily backups are listed.
- **Not in database backups:**
  - **Storage objects: 196,831 objects, 27 GB** (Evidence). The Supabase documentation says backups hold only metadata.
  - Edge function secrets and custom role passwords.
- **Application settings backup.** Job `settings-backup-daily` (19:50 UTC) is active, and `pipeline.settings_backups` keeps one row a day. Backup 11 (31 Oct 19:50 UTC) holds:
  - 501 settings;
  - 3,102 providers (2,825 published, 277 unpublished);
  - about 125 KB in total.
  - It has **no catalogue data** (courses, fees, entry, intakes, scholarships). This confirms UR-15.
- **Database:** 4,334 MB; 150 `cron.job` rows (141 active); 1,705 migration history rows; head `20261101120000`.

**What has been exercised before**

- On 10 Oct 2026 the workflow "Database baseline rebuild test" (`db-baseline-rebuild-test.yml`) ran against the throwaway project `coursefinder-baseline-test` (`lcndgqdgtnsfuyysooje`, since deleted).
  - Runs `38028086660` and `38028894493` succeeded.
  - The record (`project-runsheets/milestone-2/m2.4/m2.4.7/CURRENT-STATE.md` around line 5218) shows functions 1,257, relations 458 and policies identical.
  - That was **schema only**. The record itself lists what was not included: row data, the cron schedules, Storage, secrets and Auth settings.
- **No data restore, PITR restore or backup restore has ever been run.** UR-14's "no restore has ever been exercised" is right for data. It is not right for schema: one schema rebuild was proven.

**What I rehearsed locally this session (PostgreSQL 16.15; production is 17.6)**

1. **Baseline rebuild from git.**
   - `md5sum -c MD5SUMS`: OK.
   - Applied `roles-apply.sql`, then `apply-preamble.sql` + `schema.sql` + `apply-postscript.sql`, onto local stand-ins for the Supabase schemas: auth, cron, vault, net and storage (`streamE/stubs.sql`). It took 21 s.
   - **398 of 400 tables and 1,253 of 1,257 functions were created.**
   - All 36 errors are explained by extensions missing locally: `vector` (2 tables `search.course_embeddings` and `search.query_embedding_cache`, plus the 4 vector-argument functions), `pg_cron`, `pg_net`, `supabase_vault`, and the `supabase_realtime` publication.
   - **Result:** the 10 Oct baseline is complete and self-consistent.
2. **Roll forward to head.**
   - Replayed all 359 post-baseline migrations in order through the mirrored wrapper. Result: **47 applied, 312 failed**.
   - The first real stop is `20261011007300_cf247_s3_scholarship_coverage`. Its post-check needs live data: at least 25 `scholarship_watch` rows, `scholarship_listing_pages`, and a `cron.job` row. Everything after it cascades: 55 md5-guard refusals, plus missing objects.
   - **Result:** git (baseline plus migrations) cannot rebuild the current production database onto an empty target. Many migrations assert live data and cron state by design. A restore must therefore come from a **Supabase backup or a fresh dump**, not from git. This is also the case for objects that exist only live (noted in the project instructions).
   - This is not a defect in the migrations: their guards correctly refused to run on the wrong state. That is further D3 evidence.
3. **Not rehearsed:** restoring catalogue data, the 27 GB of Storage, cron schedules or secrets. That needs either the production data or a backup, and pointing a restore at production is out of bounds.

**Proposal for a real isolated restore (needs Platform Admin approval; nothing created)**

Approach: Supabase "Restore to a new project" from a daily backup (or PITR if enabled). This creates a **separate** project. Production is never the target.

1. **Approve.** The Platform Admin approves cost and window, and names the target `coursefinder-restore-test` in org techM. Use a region of their choice; ap-south-1 matches production.
2. **Create.** Dashboard › Database › Backups › choose the latest daily backup › Restore to a new project (or the Management API equivalent). Compute: match production, which was Medium per the 3 Oct record (confirm). The target gets new keys.
3. **Isolate before anything runs** (first actions on the restored project):
   - pause all `cron.job` rows (`update cron.job set active=false`, on the test project only), so no scheduled job calls Firecrawl, OpenRouter, the website or Zoho;
   - remove or replace the vault secrets and the alert webhook secret;
   - do not deploy edge functions with real provider keys.
4. **Reconcile.** Compare the counts and hashes below with production at the backup time, all read-only on both projects:
   - `supabase_migrations` head and md5 of `statements` for the last 20 versions;
   - `pg_get_functiondef` md5 for consumer API functions (`security.consumer_api_rebaseline_v1` baseline values in `pipeline.consumer_api_baseline`);
   - row counts: `catalogue.providers`, courses, published counts;
   - `pipeline.settings_backups` latest;
   - `permission-fingerprint.sql`.
5. **Consumer API smoke.** Point a local build at the test project and run the non-mutating API contract specs (`cf-247-website-api-v2-contract`, `cf-247-institution-type-contract`, `s57`) against it.
6. **Storage.** Prove the Evidence recovery path separately:
   - Storage is not in the backup;
   - copy a sample (for example 100 objects) through the S3-compatible API to a test bucket, or decide formally that Evidence is re-creatable and document that.
7. **Time it.** Record the wall-clock restore time (RTO evidence) and the backup age (RPO evidence).
8. **Write up and pause.** Record results in the admin repo, then pause or delete the project (Platform Admin).

**Cost estimate** (Supabase list prices; confirm on the Billing page):

- A second project on Pro is compute-billed hourly. Medium is about US$0.0822 an hour (about US$60 a month); Small is about US$0.0206 an hour.
- A one-day rehearsal (24 h at Medium) costs about **US$2–3**, plus disk for about 4.3 GB (within Pro inclusions or cents).
- PITR is not needed for the rehearsal. If enabled for production, it is about US$100 a month (7 days) and needs at least Small compute.
- Approval: the Platform Admin for the new project and its deletion, per the hard limits and CLAUDE.md.

---

## E1. Monitoring and on-call ownership: Insufficient evidence

- **Monitoring is defined and running.**
  - `OPERATIONAL-LIMITS.md` v1.3 lists the health checks, alert rules and targets T1–T8.
  - `ops-scorecard` (daily 19:29 UTC) wrote the week of 26 Oct: 2 met, 4 missed, incomplete.
  - `consumer-api-guard` (daily, 0 failures) and `hygiene-check` (weekly) are active.
- **Ownership:**
  - `OPERATIONAL-LIMITS.md`: "Owner: Platform Admin".
  - `admin-sop.md` §7 (alert row): the Platform Admin acknowledges.
  - §9 Escalation: "raise it with the platform engineer" (no name and no contact).
  - `operator-sop.md` §9: the Pipeline Operator "tells the Platform Admin"; the Platform Admin acknowledges.
- **Gaps:**
  - one recipient (the Platform Admin's own account, through a Claude scheduled task);
  - no deputy;
  - no stated hours or response time;
  - no named platform engineer;
  - no out-of-band check that the alert task itself is running;
  - 5 issues currently open and unacknowledged (scorecard).
- **Search for an on-call or out-of-hours definition** across `admin-fresh/docs/platform` and `docs/01-governance`: none found.

## E2. Recovery instructions are usable: Fail

- `docs/01-governance/coursefinder-release-version-control-recovery-v1.0.md` gives gates R1–R5 for **browser release** recovery, to baseline v2.15.78.
  - `src/release-manifest.js` makes `RECOVERY_RELEASE` v2.15.79 (14 Sep, `pilotMain 32be4e96…`).
  - That is the UR-14 mismatch, confirmed. The candidate is v2.15.400, so the recovery point is 321 releases and 7 weeks behind.
  - Section 9 states database recovery is separate and forward-only.
- **No runbook exists for:** database restore (backup or PITR), the cron schedule re-creation, Storage/Evidence recovery, secret re-binding, or edge function redeploy after restore.
  - `coursefinder-production-environment-build-operations-guide-v1.1.md` lists all of these as **required acceptance evidence**, and none is satisfied: configured schedule and retention, PITR decision, RPO/RTO, isolated target, executed restore, reconciliation, Storage procedure, secret re-binding.
- **No RPO or RTO is defined anywhere** in the docs.
- **The settings-level restore is usable but narrow:** Settings › Backup & restore, Compare and Put back with a reason (admin SOP lines 84, 178–179), and spec `cf-247-s87-nz-review-and-backup-contract` passes. It is not disaster recovery (UR-15).

## E3. Costs and budgets are enforced: Insufficient evidence (partly enforced)

| Budget | Enforced in code? | Evidence | Live position |
|---|---|---|---|
| Firecrawl daily shares | **Yes, refuses** | `security.fc_budget_left_v1` returns 0 when `daily_budget_total` is reached or a share is used; callers refuse. `pipeline.firecrawl_budget_refusals` has rows today (15 reads, 1 other) and 82 on 1 Nov | `daily_budget_on` true; total **25,000** a day (the doc still says 15,000); shares: course_search 13,000, reads 5,000, scholarships 3,500, central 2,500, other 1,000. Billed today 56 |
| Firecrawl monthly (T3, 500,000, 2,000 reserve) | **Partly** | `security.layer2_provider_budget_status` (limit 500,000, `stop_at_remaining_units` 2,000) is checked by `svc_fc_run_next` (`stopped_plan_reserve`) and the Layer 2 policy. The daily-share path (`fc_budget_left_v1`) does not read the monthly limit; 25,000 × 30 = 750,000 can exceed 500,000 | Oct used 246,703 (scorecard) and 249,179 units in `coverage_vendor_usage`; Nov 1,570; remaining plan 320,448 |
| Course-page search monthly cap | **Yes, refuses** | `security.link_search_block_v1` returns `month_cap` when used + 2 > `monthly_credit_cap` | cap 200,000; Nov used 742; Oct 114,382 |
| AI daily ceiling `budgets.ai_daily_ceiling_usd` (US$14) | **No: monitor only** | Read only by `platform_health_check_v1` and `ops_scorecard_v1` (no refusal path) | Week to 1 Nov: worst day US$7.83; total US$21.84 |
| OpenRouter credit floor `credit_floor_usd` (US$5) and per-use daily guards | **No while mode is `observe`** | `security.ai_use_allowed_v1` returns true unless `platform_toolsets.enforcement='stop'`; live value is `observe`. Spec `s23`: "observe never stops" | Balance US$98.19 (18:45 UTC); today's spend by use is far below the guards (largest: enrich_fields US$2.33 of US$25) |
| Target T2 credit minimum `targets.ai_credit_min_usd` (US$10) | Monitor only | scorecard | met |

Specs passing locally:

- `cf-247-s26-firecrawl-budget-contract` (4);
- `cf-247-s23-ai-limits-journey-contract` (5);
- `cf-247-toolsets-limits-contract`;
- `cf-247-pipeline-settings-contract`.

Spend is within every target today. The **enforcement** asked for in Gate E holds for Firecrawl daily shares and course search. It does not hold for AI spend, by an earlier deliberate choice (observe mode). That choice needs a recorded Platform Admin decision, or a switch to `stop` with a qualification step.

---

## Local spec run

Command, from the scratch copy at `/tmp/claude-0/-home-claude/f86eaff9-39df-5a0c-9d38-8954c30d5e12/scratchpad/streamE/pilot` (web server on 127.0.0.1:5199):

`npx playwright test --project=chromium-desktop --grep-invert @deployed`

Specs:

- s194, s193, s197, s148, s203, s69, baseline, s26, s23, s172, s87;
- toolsets-limits, pipeline-settings, s206, platform-health.

**Result: 203 passed, 0 failed, 0 skipped (7.1 min).** Log: `…/scratchpad/streamE/specs-run.log`. Port 5199 was free afterwards.

Most of these are source contracts (they read migration and script text), plus mocked-browser tests. s203's UR-13 test runs the real deploy script against a mocked API. None of them exercises the live alert channel or a restore.

## Gaps, smallest fix, owner

| # | Gap | Smallest fix | Owner |
|---|---|---|---|
| G1 | Alert receipt never confirmed (test 31 Oct; real critical 2 Nov 03:00) | Platform Admin confirms on the phone and in e-mail that ids 1–3, 5 and 6 arrived; record it in the transformation record | Platform Admin |
| G2 | Escalation is a reminder to the same person; never fired live | Name a second recipient (or channel) for criticals unacknowledged after N hours; or record a decision that one person is accepted for the pilot. Test it once with `alerts.test_mode` | Platform Admin (decision); Claude (setting and test) |
| G3 | No out-of-band watchdog for the alert task or `pg_cron` | A tiny GitHub Actions schedule (hourly) that reads `max(sent_at)` and the `platform-alerts` last run through the Management API, and fails (GitHub e-mails) when the task has not collected for over 2 h or the job has not run for 30 min | Claude (build, on approval) |
| G4 | "Recovered" sent when an issue is reclassified to idle-paused while work still waits | Do not emit `recovered` when the same check reopens within one cycle at lower severity; carry the issue id across the severity change. Add a test to s194 | Claude (SS-004 follow-up) |
| G5 | `layer2_run_batches` `dc4fabeb…` stuck `running` since 29 Sep, heartbeat 11 Oct | Governed action to close it as completed (processed = target). Add a health check for a heartbeat older than `health.stuck_hours` | Claude (proposal); Platform Admin (approve) |
| G6 | No data restore ever exercised; PITR state unknown | Platform Admin reads Dashboard › Backups (PITR on or off, backups listed). Approve the D4 rehearsal (about US$2–3 for a day) | Platform Admin |
| G7 | No RPO or RTO; no database, Storage, cron or secrets restore runbook | Write `docs/platform/RECOVERY-RUNBOOK.md` from the D4 steps once rehearsed; set RPO (24 h on daily backups, or 2 min with PITR) and RTO from the measured time | Claude (draft); Platform Admin (accept) |
| G8 | Evidence Storage (27 GB, 196,831 objects) is not in any backup | Decide: re-creatable (document how) or replicate (S3-compatible copy to external storage, with cost) | Platform Admin (decision) |
| G9 | UR-14: recovery release v2.15.79 (manifest) vs v2.15.78 (governance doc); 7 weeks old | Make the two agree (one-line doc fix). Promote a recent accepted release only by explicit acceptance, never automatically | Platform Admin (decision); Claude (doc fix) |
| G10 | UR-15: settings backup excludes catalogue data | Label its scope on the Backup & restore card; rely on the database backup for catalogue data (G6) | Claude (label); Platform Admin (accept) |
| G11 | AI ceiling and credit floor are not enforced (`observe`) | Record the decision to stay on observe for the pilot, or set `openrouter.enforcement='stop'` after a qualification. Note: the toolset floor is US$5 and the T2 floor is US$10 (two floors) | Platform Admin |
| G12 | Firecrawl monthly limit not checked on the daily-share path; daily total 25,000 can exceed 500,000 a month | Have `fc_budget_left_v1` also return 0 when `layer2_provider_budget_status.allowed` is false (md5-guarded edit plus a spec) | Claude (build, on approval) |
| G13 | `OPERATIONAL-LIMITS.md` is stale: 15,000 daily total (live 25,000), 89 running jobs (live 141 active of 150) | Refresh the figures section from live values | Claude |
| G14 | On-call hours, deputy and the "platform engineer" are unnamed in the SOPs | Add a short "Who is called" table to admin SOP §9: name, channel, hours, deputy | Platform Admin |

## Artefacts (scratchpad, not committed)

- `/tmp/claude-0/-home-claude/f86eaff9-39df-5a0c-9d38-8954c30d5e12/scratchpad/streamE/stubs.sql` and `/tmp/claude-0/-home-claude/f86eaff9-39df-5a0c-9d38-8954c30d5e12/scratchpad/streamE/stubs2.sql`: local stand-ins for the Supabase schemas.
- `/tmp/claude-0/-home-claude/f86eaff9-39df-5a0c-9d38-8954c30d5e12/scratchpad/streamE/apply-local.sh`: local mirror of `apply-migration.sh`.
- `/tmp/claude-0/-home-claude/f86eaff9-39df-5a0c-9d38-8954c30d5e12/scratchpad/streamE/baseline-apply.log`: the baseline rebuild log (36 errors, all from missing extensions).
- `/tmp/claude-0/-home-claude/f86eaff9-39df-5a0c-9d38-8954c30d5e12/scratchpad/streamE/migrations-apply.log`: the 359-migration replay, file by file.
- `/tmp/claude-0/-home-claude/f86eaff9-39df-5a0c-9d38-8954c30d5e12/scratchpad/streamE/mig-test/`: the refusal test migrations.
- `/tmp/claude-0/-home-claude/f86eaff9-39df-5a0c-9d38-8954c30d5e12/scratchpad/streamE/specs-run.log`: the local spec run.
- Local PostgreSQL data at `/var/lib/postgresql/streamE` (server stopped; PID 7303).
