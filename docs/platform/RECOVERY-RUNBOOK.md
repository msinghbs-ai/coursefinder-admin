# StudySearch recovery runbook

**Status:** DRAFT for the Platform Admin to accept. Nothing in it has been switched on, promoted or changed.
**Prepared:** 2 Nov 2026, Workstream E (recovery and sustainable operations).
**Authority:** Platform Admin direction 2 Nov 2026 07:41, Agent E (`nz-enrichment-brief/2026-11-02-continuous-multi-agent-delivery-direction.md`); SS-015 decision 05:45, Gates D and E.
**Evidence it builds on:** `nz-enrichment-brief/2026-11-02-ss015-gate-d-e-recovery.md` (gaps G1 to G14). The new live readings used here are listed in Appendix F.
**Project:** `fxcwkweaxjtknorudmwp` (Supabase name `coursefinder_Pilot`, region ap-south-1, Postgres 17.6). **Never** act on `coursefinder-demo`.
**Companion:** `nz-enrichment-brief/2026-11-02-restore-rehearsal-plan.md` (the restore test to run once approved).

> **Read this first.** This runbook tells you what to do when something goes wrong. Each scenario is written for a capable person who is not a database expert. Where a step needs the integrator (the engineer who holds deploy rights), it says so. If you are unsure, **stop the damage first** (pause the job, switch off the feature), then decide. Stopping is always allowed. Restoring, deleting and re-pointing are not done without the Platform Admin's yes.

---

## Contents

1. The first 15 minutes (any incident)
2. Recovery targets (PROPOSED RPO and RTO)
3. What is protected today, and what is not
4. Who decides and who acts
5. Where secrets and settings live (names only)
6. Scenarios
   - A. A bad data change
   - B. A failed migration
   - C. Database loss or corruption
   - D. Stored evidence (Storage) loss
   - E. An edge function stops working after a deploy
   - F. A stuck or runaway job
   - G. The alert channel is down
7. After any recovery
8. Things to do now, before an incident

Appendices: A. UR-14 recovery release proposal; B. UR-15 settings and catalogue backup proposal; C. Budget enforcement proposal; D. Alerts: second recipient and external watchdog; E. Decisions needed; F. Evidence and live readings.

---

## 1. The first 15 minutes (any incident)

1. **Write down the time** you noticed it and what you saw (a screenshot is fine).
2. **Is the website or Zoho affected?** Open Platform health › Health checks. A "consumer API drift" flag or website errors make it urgent.
3. **Stop the damage, do not fix yet.**
   - A job doing harm: Scheduled jobs › Automations › the job › **Pause**, with a reason (scenario F).
   - Paid tools spending too fast: see scenario F, "Emergency brakes".
   - A deploy that broke something: do not deploy again until you know which change did it (scenarios B and E).
4. **Do not** run a restore, a paste file or a delete in the first 15 minutes. Those need the Platform Admin's decision (section 4).
5. **Tell the Platform Admin** (today the only on-call person; see Appendix D) and the integrator.
6. **Pick the scenario** in section 6 and follow it.

**Busy windows to avoid for any heavy check:** minutes :00–:05 and :35–:42 of each hour, and 06:50–07:15 Melbourne time (`PRODUCTION-VALIDATION-LOAD-POLICY.md`).

---

## 2. Recovery targets (PROPOSED: the Platform Admin sets these)

RPO = how much recent data you can afford to lose. RTO = how long until the service works again.
All values below are **PROPOSED**. None is in force until the Platform Admin accepts them, and the RTO figures are estimates until the restore rehearsal measures them.

| Area | PROPOSED RPO | PROPOSED RTO | Basis |
|---|---|---|---|
| Database (catalogue, settings, pipeline state) | **24 hours** | **One working day** (8 h) for a full loss; **4 hours** for an in-place restore | Pro plan daily backups, kept 7 days. Restore time for 4.3 GB not yet measured |
| A bad data change (scenario A) | 0 (undone in place) | **4 hours** | Paste rollbacks, hold-lift and Backup & restore |
| Failed migration (scenario B) | 0 (refused, nothing changes) | **1 hour** to a forward fix | Transactional apply, proven in Gate D3 |
| Edge function regression (scenario E) | 0 | **1 hour** | Redeploy from git |
| Stuck or runaway job (scenario F) | 0 | **30 minutes** to stop; re-arm when the cause is fixed | Pause and Resume controls |
| Alert channel (scenario G) | n/a | **One working day**; with the watchdog, told within 2 hours | Appendix D |
| Stored evidence, Storage (scenario D) | **None today: not backed up** | **Not recoverable** until a decision is made | Appendix B, option S |
| Secrets (keys) | n/a | Part of the database RTO | Re-entered by hand from the owners' records |

**What PITR (Point-in-Time Recovery) would change**

- RPO for the database falls from up to 24 hours to **about 2 minutes** (Supabase documents a worst case of two minutes).
- You can restore to **just before** a bad change, not only to last night. This makes scenario A much safer for changes with no rollback file.
- Daily backups stop when PITR is on (PITR replaces them).
- Cost: about **US$100 a month** for 7 days' retention (US$0.137 an hour); it needs at least Small compute. It does **not** cover Storage, secrets or edge functions.
- **First check:** whether PITR is already on is still unknown (Gate D4). The Platform Admin reads Dashboard › Database › Backups and records it (section 8).

---

## 3. What is protected today, and what is not

| Part of the platform | Size (2 Nov 2026) | Protected by | Gap |
|---|---|---|---|
| Database (all schemas, auth users, cron jobs, vault) | 4,334 MB; 150 scheduled jobs (142 active); migration head `20261102010000` (1,706 history rows) | Supabase daily backup, 7 days | Up to 24 h of loss; restore never exercised |
| Rebuild from git | 361 migration files + 10 Oct baseline | Git | **Cannot rebuild today's database**: replay stops at migration 47 of 359 (migrations check live data). Use a backup, never git, to restore data |
| Storage bucket `evidence` | 190,145 objects, 20.8 GB | **Nothing** | Not in any backup |
| Storage bucket `adapter-captures` | 4,553 objects, 7.7 GB | **Nothing** | Not in any backup |
| Storage bucket `provider-assets` | 2,023 objects, 0.1 GB (logos, uploads) | **Nothing** | Uploads by people cannot be re-created |
| Storage bucket `archive` | 119 objects, 0.1 GB | **Nothing** | Holds the only copy of rows purged by paste files |
| Edge functions (72 in `.github/edge-functions.json`) | — | Git + `deploy-edge-functions` workflow; daily `edge-drift-check` | Fine |
| Edge function secrets | — | **Nothing** (not in backups) | Values must be held by their owners |
| Vault secrets (inside the database) | 15 names | Database backup | Whether they decrypt after a restore to a **new** project is unproven (rehearsal check R7) |
| Provider Published switch and 501 settings | about 125 KB a day | `settings-backup-daily` (19:50 UTC), kept 60 days; Settings › Backup & restore | Stored **inside** the same database; no catalogue data (UR-15) |
| Front end (admin app) | — | Git + Cloudflare | Build variables must point at the right project |

---

## 4. Who decides and who acts

| Decision | Who decides | Who acts |
|---|---|---|
| Pause a job, switch off a feature, stop spend | Anyone on the operations roster (Platform Admin, PIM Admin, Pipeline Operator) | The same person, with a reason |
| Run a rollback paste file, lift a hold, put back a backup | **Platform Admin** | Platform Admin (paste) or integrator |
| Restore the database (any kind) | **Platform Admin** | Integrator, with the Platform Admin watching |
| Re-point the website or Zoho to another project | **Platform Admin** (and tell the website developer and the Zoho developer) | Integrator |
| Create or delete a Supabase project | **Platform Admin** (explicit yes) | Integrator |
| Change a budget or alert setting | **Platform Admin** | Platform Admin, on the settings screen, with a reason |

Today the on-call roster is **one person** (the Platform Admin). There is no named deputy and no stated hours (Gate E1). Appendix D proposes a fix.

---

## 5. Where secrets and settings live (names only; never copy values into documents)

**Supabase edge function secrets** (Dashboard › Edge Functions › Secrets):
- Set by Supabase automatically for every project: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`, `SUPABASE_PUBLISHABLE_KEY`, `SUPABASE_SECRET_KEYS`.
- Set by us, and **must be re-entered after a restore to a new project**: `OPENROUTER_API_KEY` (used by 9 call sites; shared by every AI profile) and `APOLLO_API_KEY` (contact enrichment).

**Supabase Vault** (inside the database; restored with it). Names only:
- `coursefinder_pilot_automation_key` (described as "temporary … remove before production");
- `coursefinder_l2_provider_<provider id>` × 7. The Firecrawl key is `coursefinder_l2_provider_6d99eba5-83e1-4fd8-a46f-d2b8dd8ffd88`;
- `coursefinder_layer3_profile_<profile id>` × 7 (OpenRouter profile credentials);
- `studysearch_alert_webhook_url` is **not created yet** (the webhook is off).

**GitHub** (Pilot repo › Settings › Secrets and variables › Actions):
- Secrets: `SUPABASE_ACCESS_TOKEN` (account-level token; used by 10 workflow references), `SUPABASE_DB_PASSWORD` (schema dump), `COURSEFINDER_UAT_EMAIL`, `COURSEFINDER_UAT_PASSWORD`.
- Variables: `SUPABASE_PROJECT_REF` (every deploy workflow refuses any other project; **change this when re-pointing**), `DEPLOYED_WEEKLY_LIVE_ACTING`.

**Cloudflare** (the admin app build): `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY` (read in `src/lib/supabase.js`). Where they are set (Cloudflare build variables) must be confirmed by the integrator; `.env.example` lists them.

**Inside the database** (restored with it, but check after a restore):
- `pipeline.environment_settings`, key `runtime_edge_base_url`: the address every scheduled job uses to call edge functions (through `pipeline.svc_pilot_submit_nonce`, used by 30 jobs). **After a restore to a new project it still points at the old project.**
- `private.api_keys`: the website and Zoho keys (restored with the database).
- `pipeline.platform_toolset_settings`: every operational setting (G2).

**Outside everything:** the "Work queue alerts" scheduled task in the Platform Admin's Claude account (`trig_01Eo7QrJXR24e774gNzLUvTi`, hourly at :59 UTC). Its prompt names the project; update it when re-pointing.

**Hard-coded addresses held by others:** the website and Zoho call `https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/…` (`website-api-v2`, `website-course-api`, `wix-course-api`, `zoho-api-v2`, `zoho-course-api`). A restore into a **new** project changes this address, so those developers must change it. That is the main reason to prefer an in-place restore (scenario C).

---

## 6. Scenarios

Each scenario gives: **Trigger**, **Who decides**, **Steps**, **Check it worked**, **Expected time**, **Data-loss exposure**.

### A. A bad data change

**Trigger:** wrong values on the website or in the admin (for example official links pointing at fee pages, a provider published by mistake, fees withdrawn wrongly) after a paste file, an automatic job, a migration or a person's edit.

**Who decides:** the Platform Admin decides every rollback. Anyone may pause the job that is causing it.

**Steps**

1. **Stop it repeating.** If a scheduled job keeps writing the wrong values, pause it (scenario F step 1). Example from 31 Oct: `coverage-admit` re-activated 167 held links until its plan was fixed.
2. **Find what made the change.** Pick the first match:

| What made the change | How to undo it | Where |
|---|---|---|
| A paste file with a rollback partner | Run its `-rollback.sql` partner in the SQL editor. It carries the same guards and the same id list as the forward file | `nz-enrichment-brief/PASTE-20261101-e1-fee-withdrawal-rollback.sql`, `PASTE-20261101-e14-entry-rows-withdrawal-rollback.sql`; other pastes in `docs/platform/pastes/` |
| An SS-007 binding remediation hold | `select security.binding_remediation_lift_v1('<course id>', 'restore', '<reason>');` (puts the binding and official links back and asks for a search refresh) or `'release'` (lifts the hold only). Runs only as `postgres` in the SQL editor | Supabase SQL editor |
| A provider published or unpublished by mistake, or a setting changed | Settings › Backup & restore › **Compare** the last daily backup › **Put back chosen** (or **Restore this backup**), with a reason. A `before_restore` backup is taken first, so this can itself be undone | Admin app (Platform Admin only) |
| A migration's data step | Read the migration's `-- Rollback:` header line (for example `20261101030000` names the definition md5 and the CSV of the 167 links). Issue the rollback as a **new** migration or a paste; never edit the applied file | `supabase/migrations/` |
| A person's edit in the admin | Look up `pipeline.manual_edit_log` for the row (who, when, before and after), then edit it back in the admin with a reason | Admin app |
| None of the above | Go to step 3 | |

3. **No rollback exists.** Recover the old values from a backup **without touching production**:
   - restore last night's backup (or a PITR point, if on) **to a new project** (scenario C, path C2, steps C2.1 to C2.3 only: create, then isolate);
   - read the affected rows there and prepare a guarded paste file that writes them back into production (with the id list, an expected count and a md5 guard, like the existing pastes);
   - the Platform Admin runs the paste; then pause or delete the temporary project.
   - **Never** restore production in place for a bad data change. It throws away every good change since the backup.
4. **Refresh the website view** if catalogue values changed: the rollback files and the hold-lift already ask for a search refresh. If not, ask the integrator to add one row to `search.refresh_requests`.

**Check it worked**
- The rows now match the "before" values in the rollback file or backup (count check printed by the paste).
- Platform Health › Health checks shows no new critical.
- `select security.consumer_api_check_v1();` reports no drift (data changes never change the API shape).
- For website data: open 3 affected courses through the website API (or the admin's Course detail) and compare.

**Expected time:** 30 minutes with a rollback file; 2 to 4 hours through a temporary restored project.
**Data-loss exposure:** none when a rollback exists. Through a backup: values are as at the backup (up to 24 hours old; about 2 minutes with PITR), and only the chosen rows are put back.

---

### B. A failed migration

**Trigger:** the `Deploy on merge` or `Database apply migration` GitHub workflow fails, or an applied migration turns out to be wrong.

**Who decides:** the integrator fixes forward; the Platform Admin approves anything that drops or deletes.

**How the guard works (proven in Gate D3).** `scripts/ci/apply-migration.sh` sends `begin;` + the file + its history row + `commit;` as one transaction. Any error rolls the whole thing back: no objects and no history row are left. It refuses before running: a bad file name, a top-level `drop`/`delete`/`truncate`/`alter table … drop`, the `$mig$` marker, and an already-applied version whose recorded md5 differs (UR-13).

**Steps when the workflow fails**
1. Open the failed run (GitHub › Actions › the run). Read the `::error::` line.
2. **Confirm nothing changed:** `select version from supabase_migrations.schema_migrations order by version desc limit 3;` The failed version must not be listed.
3. Common causes and fixes:
   - "live … differs from the definition this change replaces": production changed since the migration was written. Re-read the live definition, update the guard md5 in a **new** file version, and retry.
   - A post-check `raise`: the data was not in the expected state. Investigate; do not weaken the check.
   - "Refused: … drops, deletes or truncates": move that statement into a paste file for the Platform Admin.
   - "an applied migration was changed": leave the applied file as it is; issue the change as a new migration.
4. Fix in a new branch and PR; the full local suite, build and syntax check run before merge (project rules).

**Steps when an applied migration is wrong (it succeeded but behaves badly)**
1. Pause the affected job(s) if they are writing bad data (scenario F).
2. Read the migration's `-- Rollback:` line. It names the previous definition md5s.
3. Get the previous definition from git (the earlier migration that created it) or from a `db-function-snapshot/<run id>` branch (workflow "Database function snapshot").
4. Issue a **new** migration that re-applies the previous definition, guarded by the **current** md5. Apply with `Database apply migration` (typed project ref must equal `SUPABASE_PROJECT_REF`).
5. If it touched the consumer API (G3), the s57 test and the `consumer-api-guard` job will flag it; the fix must restore the baseline, and `security.consumer_api_rebaseline_v1` is **not** used unless the Platform Admin approved an API change.

**Check it worked:** the workflow log shows "applied; history md5 … matches the file"; `security.controls_check_v1()` and `security.consumer_api_check_v1()` are clean; the affected screen works.
**Expected time:** under 1 hour for a refused migration; 1 to 3 hours for a forward fix.
**Data-loss exposure:** none for a refused migration. For a wrong applied one: whatever the bad code wrote before it was paused (undo with scenario A).

---

### C. Database loss or corruption

**Trigger:** the database will not start, data is badly corrupted across many tables, the project was deleted, or Supabase reports data loss.

**Who decides:** **Platform Admin only.** The integrator carries out the steps.

**First, choose the path**

| Situation | Path | Why |
|---|---|---|
| The project still exists and its address works, but the data is unusable | **C1 Restore in place** | Keeps the address, keys, edge functions, Storage and secrets. The website and Zoho need no change |
| The project is gone, locked or unusable; or you must keep the damaged copy for investigation | **C2 Restore to a new project, then re-point** | The only option when the project itself is lost |

Both lose everything written after the backup (up to 24 hours; about 2 minutes with PITR).

#### C1. Restore in place

1. **Freeze.** Scheduled jobs › Automations: pause the paid lanes first (course link search, coverage read and discover, enrichment, AI lanes). If the admin app is down, skip this.
2. **Save what you can** (only if the database still answers): the integrator runs the `Database schema dump` workflow and, if possible, a data dump of the `catalogue`, `scholarship`, `ranking` and `search` schemas to a local file. This gives a way back if the restore is the wrong choice.
3. **Restore.** Supabase Dashboard › project `coursefinder_Pilot` › Database › Backups › **Scheduled backups** (or **Point in time** if PITR is on) › choose the newest backup **before** the damage › Restore › confirm. The project is offline during the restore.
4. **Wait** for the dashboard notice that the restore finished.
5. **Check before switching anything on** (see "Check it worked" below).
6. **Re-arm** the jobs paused in step 1 (Scheduled jobs › Automations › Resume, with a reason).

#### C2. Restore to a new project, then re-point

1. **Create.** Supabase Dashboard › the source project (or, if it is deleted, the organisation's backups if still listed) › Database › Backups › **Restore to a New Project** › choose the backup › Restore. Name: `coursefinder-recovery-<date>`, organisation techM, same region. Supabase copies the database only (schema, data, roles, auth users); it does **not** copy Storage, edge functions, auth settings, API keys or extension settings.
2. **Isolate at once** (on the **new** project, SQL editor). Supabase's own guidance is to disable `pg_cron` and `pg_net` behaviour after a copy:
   ```sql
   update cron.job set active = false;               -- stops all 150 jobs
   update pipeline.environment_settings
      set setting_value = to_jsonb('https://<NEW_REF>.supabase.co/functions/v1'::text)
    where setting_key = 'runtime_edge_base_url';     -- stops calls to the old project's functions
   ```
   Check the old value's exact form first (`select setting_value from pipeline.environment_settings where setting_key='runtime_edge_base_url';`) and keep the same shape.
3. **Stop the old project working twice.** If the old project is still running, pause its paid jobs, so two platforms do not both spend Firecrawl and OpenRouter credit.
4. **Secrets.**
   - Edge function secrets: Dashboard › Edge Functions › Secrets › add `OPENROUTER_API_KEY` and `APOLLO_API_KEY` (values from their owners' records).
   - Vault: check the secrets decrypt, without showing them: `select name, decrypted_secret is not null as ok from vault.decrypted_secrets;` Any `false` must be re-entered (Firecrawl key, OpenRouter profile keys) through Models & services in the admin, or by the integrator.
   - Custom database roles with a login need new passwords (Supabase does not keep them in daily backups).
5. **Edge functions.** GitHub › Pilot repo › Settings › Variables: set `SUPABASE_PROJECT_REF` to the new ref. Then Actions › **Deploy edge functions** › Run workflow: list all 72 functions from `.github/edge-functions.json` and type the new ref. The workflow deploys each with its recorded `verify_jwt`.
6. **Storage.** Re-create the four **private** buckets: `evidence`, `adapter-captures`, `provider-assets`, `archive`. Copy the objects from the old project if it is still readable (Supabase's documented script, or the S3-compatible API); otherwise see scenario D.
7. **Auth settings.** Dashboard › Authentication: site URL, redirect URLs, e-mail (SMTP) and any providers, matching the old project (not copied).
8. **Admin app.** Update the Cloudflare build variables `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY` and redeploy. Update the GitHub secret `SUPABASE_DB_PASSWORD`.
9. **Consumers.** Tell the website developer and the Zoho developer the new base address (`https://<NEW_REF>.supabase.co/functions/v1/…`). Their keys still work (they are in `private.api_keys`, restored).
10. **Alerts.** Update the "Work queue alerts" scheduled task prompt to the new project ref.
11. **Switch on.** When the checks below pass: Scheduled jobs › Automations › resume by area, cheapest first (health, alerts, settings backup), then the paid lanes.

**Check it worked (C1 and C2)**
- `select max(version) from supabase_migrations.schema_migrations;` equals the head at the backup time (today `20261102010000`).
- `select security.consumer_api_check_v1();` reports no drift. **Do not** re-baseline: a clean check is the proof the consumer API came back unchanged. `security.consumer_api_rebaseline_v1` is only for an approved API change.
- Row counts of `catalogue.providers`, `catalogue.courses`, `catalogue.course_fees`, `catalogue.course_links`, `search.course_documents` match the last known figures (the latest `pipeline.settings_backups` row gives the provider counts).
- `select count(*) filter (where active), count(*) from cron.job;` is as expected once re-armed (today 142 of 150).
- The `edge-drift-check` workflow (run by hand) shows no drift.
- The deployed UAT (`deployed-uat` workflow, live-acting switch **off**) passes; the website contract specs `cf-247-website-api-v2-contract` and `cf-247-institution-type-contract` pass against the restored address.
- Platform health: no critical after two health runs (20 minutes).

**Expected time (estimates, to be measured by the rehearsal):** C1 about 2 to 4 hours (restore of 4.3 GB plus checks). C2 about one working day, plus however long the website and Zoho developers need to change the address.
**Data-loss exposure:** everything written after the backup: up to 24 hours (about 2 minutes with PITR). Storage objects are not affected by C1; with C2 they are lost unless copied from the old project.

---

### D. Stored evidence (Storage) loss

**Trigger:** Evidence screens show "object not found", downloads fail, a bucket is emptied or deleted, or Supabase reports a Storage incident.

**Who decides:** Platform Admin.

**Important:** Storage is **not in any backup** today (3 buckets of data, 28.6 GB, 196,840 objects). Restoring the database does **not** bring objects back; it only brings back the list of what used to exist.

**Steps**
1. **Stop anything that deletes or rewrites objects:** pause the `evidence-storage-dedupe` work and any purge job (Scheduled jobs › Automations).
2. **Measure the damage** (bounded, outside busy windows): the number of rows in `storage.objects` per bucket, compared with the figures in section 3; then try to download a sample of 20 objects per bucket from the admin's Evidence screens.
3. **Open a Supabase support ticket at once** (Dashboard › Support), naming the project, buckets and time. Ask whether the objects can be recovered on their side. This is the only recovery route while there is no copy.
4. **If an external copy exists** (only after Appendix B option S is approved): re-create the buckets as **private** with the same names and copy the objects back.
5. **If no copy exists,** decide per bucket:
   - `evidence` and `adapter-captures`: the pages can be read again, but they cost Firecrawl credit and show today's page, not the page as it was. Prioritise courses on the website; keep the Layer 4 decisions that relied on the lost evidence, and mark them "evidence lost on <date>".
   - `provider-assets`: logos can be found again (job `logo-find`); uploaded files must be asked for again.
   - `archive`: the purged rows it held are **lost**. Record which archive manifests are affected.

**Check it worked:** a sample of 20 objects per bucket downloads; Evidence links in Course detail open.
**Expected time:** stop and measure in 1 hour; recovery depends on Supabase support, or the external copy (hours), or re-reading (days to weeks).
**Data-loss exposure:** **total** for the lost objects today. With option S in Appendix B: up to the copy interval (proposed 24 hours).

---

### E. An edge function stops working after a deploy

**Trigger:** a function starts failing after `Deploy on merge` or `Deploy edge functions`; Platform health shows worker failures; the website or Zoho returns errors.

**Who decides:** the integrator, with the Platform Admin told. A consumer function (`website-api-v2`, `wix-course-api`, `website-course-api`, `zoho-api-v2`, `zoho-course-api`) is urgent.

**Steps**
1. Find the last good version: `git log --oneline -- supabase/functions/<name>` in the Pilot repo, and the deploy time in the workflow run.
2. **Normal route:** open a PR that reverts the function's change on `main`. On merge, `Deploy on merge` redeploys the changed function.
3. **Fast route (urgent):** the integrator creates a recovery branch from the last good commit and runs Actions › **Deploy edge functions** › "Use workflow from" that branch, functions = `<name>`, project ref typed. (`scripts/ci/deploy-function.sh` refuses any function not in `.github/edge-functions.json`.) Then merge the revert to `main` so git and live agree again.
4. Consumer functions: the redeployed source must match the checksum in `tests/uat/consumer-api-baseline.json`. If it does not, stop and ask the Platform Admin (G3).

**Check it worked:** run the `Edge drift check` workflow by hand (no drift); the function's own screen or a contract spec passes; Platform health worker failures stop within two runs.
**Expected time:** under 1 hour.
**Data-loss exposure:** none, apart from work the broken function did wrong (undo with scenario A).

---

### F. A stuck or runaway job

**Trigger:** a queue stops moving ("stalled" critical), a job fails every run, a job runs far longer than usual, or spend climbs quickly.

**Who decides:** anyone on the roster may pause; the Platform Admin decides spend changes.

**Steps**
1. **Pause:** Scheduled jobs › Automations (or Scheduled jobs › Task manager › Background jobs) › the job › **Pause**, with a reason. This calls `public.admin_automation_control(job, 'pause', …)` and is logged in `admin_control_events`. A whole area can be paused (`pause_area`).
2. **Emergency brakes for spend** (Settings, with a reason; all are existing settings):
   - Firecrawl, automatic work: Models & services › Toolsets & limits › Firecrawl `daily_budget_total` = 0 (every worker spend is refused through `svc_fc_spend`).
   - Firecrawl, on-demand runs: `ondemand_credits_per_day` = 0.
   - AI: switch OpenRouter enforcement to **Stop at limits** and lower the `guard_<use>` of the lane at fault (Appendix C). In Observe mode nothing is refused.
3. **Find the cause:** the job's last error (Automations › the job), Platform health › Work queues, and `cron.job_run_details` for the last few runs (bounded by time).
4. **Leases clear themselves.** Expired leases are taken again with a limited number of tries (Gate D2), so you do not need to "unlock" items by hand.
5. **Closed but still "running" records:** for example `pipeline.layer2_run_batches` `dc4fabeb-532a-4536-9cbd-50d042e09f8c` (running since 29 Sep; processed equals target). Closing it needs a governed action approved by the Platform Admin (Gate D G5); do not edit it by hand.
6. **Re-arm** when the cause is fixed: Automations › **Resume** (or **Resume area**), with a reason. Resuming also releases an open idle-pause flag for that job as a person's release (`security.job_idle_flag_person_release_v1`, D14). For course search stopped per university: `public.admin_firecrawl_search_resume`. Put any brake from step 2 back to its earlier value (the Settings history shows it).

**Check it worked:** the next run succeeds (Automations shows it); the queue moves; Platform health clears within two runs; spend for the day stops rising.
**Expected time:** stop in 5 to 30 minutes; re-arm when the cause is fixed.
**Data-loss exposure:** none from pausing. Work simply waits.

---

### G. The alert channel is down

**Trigger:** no alert arrives for an issue you can see on Platform health; Platform health shows `alerts:not_collected` (critical) or `alerts:delivery_failed`; the watchdog (Appendix D, once built) e-mails a failure.

**How alerts flow today:** job `platform-health` (every 10 minutes) → job `platform-alerts` (every 10 minutes) writes `pipeline.platform_alerts` → the "Work queue alerts" scheduled task (hourly at :59 UTC) collects them (`security.platform_alerts_take_v1`), sends push and e-mail, and confirms (`security.platform_alerts_confirm_v1`). Expect up to about 75 minutes from issue to message.

**Who decides:** Platform Admin.

**Steps**
1. Platform health › Health checks: is anything critical open? Treat it as found; you are now the alert channel.
2. **Is the database side running?** Scheduled jobs › Automations: `platform-health` and `platform-alerts` ran in the last 10 minutes. If not, see scenario F; if no jobs at all are running, `pg_cron` may be down: check status.supabase.com, then (Platform Admin) Dashboard › Project settings › General › **Restart project** in a quiet window.
3. **Is the scheduled task running?** In Claude, open scheduled tasks › "Work queue alerts": enabled, last run time, last result. Run it once by hand.
4. **Test end to end:** Settings › Pipeline settings › Alerts › send a test alert (or `alerts.test_mode` on, then off). Confirm it arrives on the phone **and** in e-mail.
5. **Fallback while it is broken:** the Platform Admin checks Platform health at least every 2 hours in working hours; or switch delivery to the webhook (needs the vault secret `studysearch_alert_webhook_url` and `alerts.webhook_enabled` = true; note the webhook **replaces** the scheduled-task delivery, it does not add to it).

**Check it worked:** the test alert arrives; `pipeline.platform_alerts` shows it `sent`; `alerts:not_collected` clears.
**Expected time:** 1 hour if the task only needs a re-run; up to one working day if the account or scheduler is at fault.
**Data-loss exposure:** none; alerts wait in the outbox (`alerts.collect_within_minutes` 120 before `not_collected` raises). The risk is a late response to a real incident.

---

## 7. After any recovery

1. Record in the change-control record: what happened, when it was noticed, what was done, the times, and the data lost (if any).
2. Re-run the checks in the scenario, then the next `ops-scorecard` and `consumer-api-guard` runs.
3. Put back every brake and pause that was used, or record why it stays.
4. If an RTO was missed, update section 2 with the measured time.
5. A job failure that coincided with verification load is recorded as "suspected validation-induced interference, pending root-cause verification", never as a pass (load policy).

## 8. Things to do now, before an incident

| # | Action | Owner |
|---|---|---|
| 1 | Read Dashboard › Database › Backups: record whether PITR is on and which daily backups are listed (and their time of day) | Platform Admin |
| 2 | Decide the RPO and RTO in section 2 | Platform Admin |
| 3 | Check that the values of `OPENROUTER_API_KEY`, `APOLLO_API_KEY`, the Firecrawl key, the GitHub `SUPABASE_ACCESS_TOKEN` and the database password are held in a password manager by their owner (not in any document) | Platform Admin |
| 4 | Approve the restore rehearsal (companion plan) | Platform Admin |
| 5 | Decide Storage protection (Appendix B, option S) | Platform Admin |
| 6 | Name a deputy and hours; approve the watchdog (Appendix D) | Platform Admin |
| 7 | Confirm alert receipt for ids 1–3, 5 and 6 (Gate D G1) | Platform Admin |

---

## Appendix A. UR-14: which recovery release to keep (proposal only)

**Finding (confirmed in both repositories)**

- `src/release-manifest.js` (Pilot `main` `c9338a91`, candidate v2.15.401): `ACCEPTED_RELEASES[0]` = **v2.15.79**, package 0.1.6, `pilotMain` `32be4e96a8df342deba3011f9740dc1230a672b2` (14 Sep 2026 16:55, "CF-093: align CF-097 ranking record-count wording"). `RECOVERY_RELEASE` is that entry. CHANGELOG repeats "v2.15.79 remains the accepted recovery release".
- `docs/01-governance/coursefinder-release-version-control-recovery-v1.0.md` §5 and §6 name **v2.15.78**, package 0.1.5, commit `7cf5cc72296ca82e6e026606a61f449ede4ead45` (14 Sep 06:45), as "the exact recovery point preceding candidate v2.15.79".
- `project-runsheets/milestone-2/m2.4/m2.4.5/CURRENT-STATE.md` records M2.4.5 closed 15 Sep with **"Visible accepted release: v2.15.79 / package 0.1.6"** and accepted Pilot main `e62c01ca…`.
- **So the two disagree only because the governance document was written while v2.15.79 was still a candidate, and was never updated after v2.15.79 was accepted.** The manifest is right; the document is stale. Both commits exist in the Pilot repository.
- One small further mismatch: M2.4.5 records the accepted main as `e62c01ca…`, the manifest pins `32be4e96…`. Both are 14–15 Sep; the integrator should confirm `32be4e96` is the release commit for v2.15.79 (`git log 32be4e96..e62c01ca`) before the document fix.

**Why it matters more than the version number.** v2.15.79 is 322 releases and 7 weeks behind. The database is forward-only (governance §9, Gate D3), so the v2.15.79 admin app would run against a database that has since gained and retired many functions. It is very unlikely to work. In practice the "recovery release" today is not a usable recovery point.

**Proposal (nothing is promoted by this document)**

1. **Reconcile now (doc-only, no approval needed beyond normal review):** update §5 and §6 of the governance document to v2.15.79 / 0.1.6 / `32be4e96…` / 14 Sep 2026, and add a note pointing to `ACCEPTED_RELEASES[0]` in the manifest as the single source, so the two cannot drift again.
2. **Platform Admin decision: which recent release becomes the recovery baseline.** Options:
   - **R-a (recommended):** promote the release that passes SS-015 acceptance (today the candidate line is v2.15.400 / v2.15.401; Gate A shows v2.15.400 deployed and its release contract passing). Promotion is a deliberate PR that adds it at the top of `ACCEPTED_RELEASES` with its `pilotMain`, sets `RELEASE_STATE='accepted'`, and is recorded with the Platform Admin's words. `scripts/verify-release-contract.mjs` then requires the accepted release to be the recovery release.
   - R-b: keep v2.15.79 and record that it is a nominal baseline only, accepting that an admin-app rollback means "redeploy the previous commit", not "go back to v2.15.79".
   - **Not proposed:** promoting automatically on every release. A passing check never switches anything on by itself.
3. **Define the admin-app rollback** in the governance document as: redeploy the previous accepted commit of the front end through Cloudflare; never roll back migrations (forward-only); if the old app needs a function that has changed, apply a forward compatibility migration.
4. **Prove it** in the restore rehearsal (step R10 of the plan): build the chosen recovery commit against the restored project and run the login and navigation smoke.

## Appendix B. UR-15: settings and catalogue backup (proposal only)

**Finding.** `settings-backup-daily` (19:50 UTC; `retention.settings_backup_days` 60; 12 backups held, latest 1 Nov 19:50 UTC) keeps the provider Published switch (3,102 providers) and 501 setting values, about 125 KB. It holds **no catalogue data**, and it lives inside the same database, so it does not survive a database loss on its own. The catalogue-type schemas are about 730 MB with indexes (catalogue 422 MB, scholarship 176 MB, ranking 133 MB, ref 2 MB); search 236 MB is rebuilt from them.

**Proposal, smallest first**

| Option | What | Uses | Cost and load | Protects against |
|---|---|---|---|---|
| **U1 (do now)** | Label the scope on Settings › Backup & restore: "Covers provider publishing and settings only. Catalogue data is protected by the daily database backup (7 days). Evidence files are not backed up." Link this runbook | Existing card | None | Misunderstanding (UR-15 acceptance) |
| **U2** | Keep a copy of the daily settings backup **outside** the database: the same GitHub workflow pattern as `Database schema dump` (read-only, typed-ref check) downloads the latest backup's SQL script (`public.admin_settings_backup` action `script`) weekly and keeps it as a workflow artefact (90 days) | `db-schema-dump.yml` pattern, `SUPABASE_ACCESS_TOKEN` | 125 KB; one small read | Loss of the project and its backups |
| **U3** | Monthly logical dump of the `catalogue`, `scholarship`, `ranking` and `ref` schemas (data), compressed, as a workflow artefact or in external storage (option S) | Same workflow pattern with `SUPABASE_DB_PASSWORD` | Estimated 100–200 MB compressed; a sequential read of about 730 MB, so it runs in a quiet hour (for example 02:2x Melbourne), never in the busy windows, after the load-policy back-off check | A loss older than the 7-day backup window, or of the whole Supabase account |
| **S (Storage)** | Daily copy of the four buckets to external S3-compatible storage (for example Cloudflare R2; Cloudflare already hosts the front end, so no new vendor), incremental by object name and `updated_at` | Supabase Storage S3-compatible API; a GitHub workflow | About 29 GB stored: roughly US$0.45 a month at R2 list price (confirm); first copy about 29 GB egress (within the Pro egress allowance; confirm); daily increments small | Gap G8: today Evidence has **no** copy |

Not proposed: widening `settings_backup_take_v1` to hold catalogue data. It would put hundreds of megabytes a day into a table in the same database, which adds load and no protection.

**Decision needed:** U1 (accept), then U2, U3 and S (each yes or no).

## Appendix C. Budget enforcement (proposal only)

### C1. OpenRouter: what switching "observe" to "stop" does

**Live now (read 2 Nov 2026 07:47 AEDT):** `pipeline.platform_toolsets.enforcement` for `openrouter` = **`observe`**. In observe mode `security.ai_use_allowed_v1` (live md5 `201f9305…`) always answers yes; nothing is refused.

In **stop** mode it refuses an AI call when either:
- the latest OpenRouter balance (read every 15 minutes by job `openrouter-balance`) is below `openrouter.credit_floor_usd`, or
- that lane's spend today (UTC day, `security.ai_spend_today_v1`, live md5 `f18af72f…`) has reached its guard.

| Setting (toolset `openrouter`) | Live value | Who checks it in stop mode |
|---|---|---|
| `credit_floor_usd` | US$5 | every guarded lane |
| `guard_enrich_fields` | US$25 a day | `enrich_ai_fire_v1`, `course_entry_batch_v1`, `course_entry_programme_v1` |
| `guard_scholarship_ai` | US$20 a day | `scholarship_ai_fire_v1`, `scholarship_recheck_fire_v1` |
| `guard_fee_ai` | US$5 a day | `fee_reader_tick_v1` |
| `guard_central_ai` | US$5 a day | `central_ai_fire_v1` |
| `guard_entry_matrix` | US$2 a day | `entry_matrix_fire_v1`, `svc_entry_matrix_next`, `admin_aer`, `aer_reread_v1` |
| `guard_course_match` | US$5 a day | **no caller**: not enforced even in stop mode |
| `guard_adapter_builder` | US$5 a day | **no caller**: not enforced even in stop mode |
| `pipeline.budgets.ai_daily_ceiling_usd` | US$14 a day | **no refusal path**; health check and scorecard only |
| `pipeline.targets.ai_credit_min_usd` | US$10 | scorecard target T2 only |

Points to note:
- The guards add up to US$67 a day for the enforced lanes, so stop mode does **not** enforce the US$14 ceiling.
- There are two floors (US$5 enforced, US$10 target).
- Last week the worst day was US$7.83 and the balance was US$98.19, so switching to stop would not have refused anything.
- `SYSTEM-REFERENCE.md` line 108 says stop refuses only scholarship and central AI; it now covers five lanes (update the document).

**Proposed settings changes for the Platform Admin to approve** (Models & services › Toolsets & limits / AI & OpenRouter, each with a reason):

| # | Change | From → to | Effect |
|---|---|---|---|
| B1 | `openrouter` enforcement | observe → **stop** | Floor and guards start refusing. Do it after a qualification step: run spec `s23` (journey contract) and watch one day with Platform health open |
| B2 | `openrouter.credit_floor_usd` | 5 → **10** | One floor, equal to target T2 |
| B3 (option) | Make the guards add up to the ceiling: `guard_enrich_fields` 25 → 7, `guard_scholarship_ai` 20 → 3, `guard_fee_ai` 5 → 1, `guard_central_ai` 5 → 1, `guard_entry_matrix` 2 → 2 | sum 14 | Enforces about US$14 a day with settings only. Lower lanes may stop earlier in a busy day; raise a guard with a reason when needed. Not 0: a guard of 0 means "no guard" |
| B4 (code, later) | Add the `course_match` and `adapter_builder` callers, and a total-ceiling check reading `budgets.ai_daily_ceiling_usd` inside `ai_use_allowed_v1` (md5-guarded edit, spec in s23) | — | Closes the unguarded lanes; B3 then becomes optional |

Alternative to B1–B4: record a Platform Admin decision that AI spend stays on observe for the pilot (Gate E3 needs one or the other).

### C2. Firecrawl: the monthly limit on every path

**Live now:** the plan is 500,000 credits a month (`pipeline.layer2_acquisition_providers` row `firecrawl`, `billing_config.monthly_vendor_units_limit` 500,000, `stop_at_vendor_units_remaining` 2,000; vendor period noted as 2 Oct–2 Nov). Daily: `firecrawl.daily_budget_on` true, `daily_budget_total` **25,000**, shares course_search 13,000, reads 5,000, scholarships 3,500, central 2,500, other 1,000; `ondemand_credits_per_day` **2,000** (outside the daily total).

**Which paths check what (live function bodies):**

| Path | Daily share (`fc_budget_left_v1`) | Monthly limit (`layer2_provider_budget_status`) |
|---|---|---|
| Worker spends (`svc_fc_spend`: read, discover, link search, find site, scholarships, central) | yes | **no** |
| On-demand plan runs (`svc_fc_spend` on-demand branch, `admin_enrich_plan`) | own allowance | **no** |
| Course link search (`svc_course_link_search_next`, `link_search_block_v1`) | yes | **no** (has its own 200,000 month cap) |
| Enrichment plan tick (`enrich_plan_tick_v1`) | yes | **no** |
| Layer 2 runner (`svc_fc_run_next`, `layer2_execution_policy_service`, `firecrawl_upgrade_run_v1`) | no | yes |

So the paths that spend most check only the day. 25,000 × 31 + 2,000 × 31 = **837,000** a month is possible against 500,000. (Real use is lower: October about 247,000–249,000.)

**Proposed changes for the Platform Admin to approve**

| # | Change | Effect |
|---|---|---|
| F1 (settings only, now) | `firecrawl.daily_budget_total` 25,000 → **14,000** and `ondemand_credits_per_day` stays 2,000 | (14,000 + 2,000) × 31 = 496,000, under the 500,000 plan with the 2,000 reserve. October's average was about 8,000 a day, so normal work is not held back. The five shares (sum 25,000) then compete inside 14,000; scale them if a lane needs a guaranteed amount (for example course_search 7,000, reads 3,000, scholarships 2,000, central 1,300, other 700) |
| F2 (code, small) | One check, `layer2_provider_budget_status(<firecrawl provider by key>).allowed`, added to `fc_budget_left_v1` (returns 0) and to the on-demand branch of `svc_fc_spend`; md5-guarded edit (live `187ad8c1…`), test in `s26`; provider looked up by `provider_key`, no id in code | The monthly limit is enforced on every path; the vendor's own balance (read every 15 minutes) stays the authority, which also covers the vendor period starting on the 2nd rather than the 1st |
| F3 (doc) | `OPERATIONAL-LIMITS.md` says 15,000 a day; live is 25,000 (Gate E G13) | Refresh after F1 |

## Appendix D. Alerts: a second recipient and an external watchdog (proposal only)

**Today:** one recipient (the Platform Admin's Claude account, push and e-mail); "escalated" means severity rose, "reminder" repeats to the same person after 12 hours; neither has fired live. Nothing outside the platform notices if the scheduled task, the Claude scheduler or `pg_cron` stops.

### D1. Second recipient: options

| Option | How | Change needed | Note |
|---|---|---|---|
| **2a. Shared channel by webhook (smallest real fix)** | Create a Teams or Slack incoming webhook for a channel the Platform Admin and a deputy both join (with phone push); store it as vault secret `studysearch_alert_webhook_url`; set `alerts.webhook_enabled` = true | Settings and one vault secret; **no code** (`platform_alerts_webhook_v1` exists, with retries and `alerts.webhook_batch` 20) | The webhook **replaces** the scheduled-task delivery (`platform_alerts_take_v1` returns nothing while it is on). Test with `alerts.test_mode` first |
| 2b. Tiered: reminders and unacknowledged criticals also to the webhook | Small code change: send `reminder` and `escalated` kinds to both channels | md5-guarded edit and a test in s194 | Keeps today's channel, adds a deputy only when the first person has not acknowledged |
| 2c. Record a decision that one person is accepted for the pilot | — | None | Must be written down for Gate E1 |

### D2. External watchdog: options

| Option | Independent of | Change | Note |
|---|---|---|---|
| **W1. Hourly GitHub Actions check (smallest)** | Claude scheduler, the alert task, `pg_cron` | One workflow in the Pilot repo, same pattern and secret (`SUPABASE_ACCESS_TOKEN`, typed-ref check against `SUPABASE_PROJECT_REF`) as `edge-drift-check`; runs at minute :23 (outside the busy windows); one read-only query of under a second | Fails, and GitHub e-mails, when: an alert has waited unsent longer than `alerts.collect_within_minutes` (120); **or** `platform-health` or `platform-alerts` has not run in the last 30 minutes (latest `cron.job_run_details` for those two jobs, bounded to the last hour). GitHub sends scheduled-run failure e-mail to the person who last edited the schedule line, so the deputy (or the Platform Admin) should make that edit. Catalogue it in the component register |
| W2. A second Claude scheduled task | the first task only | None | Same account and scheduler: does not cover their failure |
| W3. An outside "dead man's switch" service pinged by `platform-alerts` | everything | New service and an outbound call | A new subsystem; not proposed under the load policy |

**Recommendation:** W1 plus 2a once a deputy is named; or W1 plus 2c for the pilot.

**Sketch of the W1 query** (read-only; final form by the integrator):
```sql
select
  (select count(*) from pipeline.platform_alerts
    where status = 'pending' and created_at < now() - make_interval(mins => security.pipeline_num_v1('alerts.collect_within_minutes', 120)::int)) as overdue_alerts,
  (select max(d.start_time) from cron.job_run_details d join cron.job j on j.jobid = d.jobid
    where j.jobname = 'platform-health'  and d.start_time > now() - interval '1 hour') as health_last,
  (select max(d.start_time) from cron.job_run_details d join cron.job j on j.jobid = d.jobid
    where j.jobname = 'platform-alerts' and d.start_time > now() - interval '1 hour') as alerts_last;
```
(The 30-minute and hourly values of the workflow itself are fixed safety timers in the workflow, marked `fixed:`, or read from a new pipeline setting such as `alerts.watchdog_stale_minutes`, per G2.)

## Appendix E. Decisions needed from the Platform Admin

| # | Decision | Section |
|---|---|---|
| 1 | Set the RPO and RTO (proposed: 24 h and one working day for the database) | 2 |
| 2 | Record whether PITR is on; decide whether to buy it (about US$100 a month) | 2, 8 |
| 3 | Approve the restore rehearsal (about US$2–3) and later the deletion of its project | companion plan |
| 4 | Storage protection: option S (about US$0.45 a month stored) or accept the loss risk in writing | B |
| 5 | UR-14: accept the doc reconciliation to v2.15.79; choose R-a (promote the SS-015-accepted release) or R-b | A |
| 6 | UR-15: accept U1; yes or no to U2 and U3 | B |
| 7 | AI budget: B1 (stop) + B2 (floor 10) ± B3 (guards sum to 14), or record "observe for the pilot" | C1 |
| 8 | Firecrawl: F1 (`daily_budget_total` 14,000) now; F2 build | C2 |
| 9 | Alerts: name a deputy and hours; choose 2a, 2b or 2c; approve W1 | D |

## Appendix F. Evidence and live readings

All production reads on 2 Nov 2026 between 07:43 and 07:55 AEDT, read-only and bounded, outside the busy windows, after the load-policy back-off check (no failures or time-outs in the previous 20 minutes; `coverage-admit` 0.9 s and 65.9 s, `adapter-overwrite` 0.7–0.8 s). Values shown are names and figures only; no secret value was read.

- Settings: `pipeline.platform_toolset_settings` (alerts, budgets, targets, hygiene, retention, firecrawl, openrouter keys); `pipeline.platform_toolsets.enforcement` (openrouter `observe`).
- Function bodies and md5: `ai_use_allowed_v1` `201f9305…`, `ai_spend_today_v1` `f18af72f…`, `fc_budget_left_v1` `187ad8c1…`, `layer2_provider_budget_status` `30267f08…`, `link_search_block_v1` `95e26930…`; the callers of each (catalogue search of `pg_proc`).
- `pipeline.layer2_acquisition_providers` Firecrawl `billing_config` (key-like fields excluded).
- Vault: `vault.secrets` names and descriptions only. Buckets: `storage.buckets`; per-bucket object counts and sizes from `storage.objects` (8-second limit).
- Migration head `20261102010000` (1,706 rows); `cron.job` 142 of 150 active; settings backups 12, latest 1 Nov 19:50 UTC; `pipeline.platform_alerts` 5 rows, last sent 1 Nov 16:59 UTC.
- `pipeline.svc_pilot_submit_nonce` and `public.coursefinder_runtime_edge_base_url` (base address from `pipeline.environment_settings`); edge functions refuse a call without a nonce found in **their own** database (`svc_pilot_consume_nonce`), so a restored copy cannot make production run work, but its calls still reach production until isolated.
- Schema sizes by schema (catalogue 422 MB, scholarship 176 MB, ranking 133 MB, search 236 MB, pipeline 2,619 MB).
- Consumer API baseline: 75 functions and 48 relations, captured 31 Oct 03:22 UTC.
- Supabase documentation (search_docs, 2 Nov 2026): "Restore to a new project" (database-only copy; Storage, edge functions, auth settings and API keys need manual set-up; disable `pg_cron` and `pg_net` after the copy; needs physical backups, which Postgres 15.8.1.079 and later use by default) and "Database Backups" (Pro: 7 daily backups; Storage objects not included; custom role passwords not kept; PITR RPO two minutes, US$0.137 an hour for 7 days, needs Small compute, replaces daily backups).
- Repository: Pilot `main` `c9338a91` (v2.15.401); Admin `main` `2e0e6952`.
