# Isolated restore rehearsal plan (Gate D4)

**Status:** PLAN ONLY. Nothing has been created. The integrator runs it only after the Platform Admin's explicit yes (project creation, cost and window), recorded verbatim.
**Prepared:** 2 Nov 2026, Workstream E. **Authority:** Platform Admin direction 2 Nov 2026 07:41 (Agent E); SS-015 decision 05:45 (Gate D4 failed: no data restore has ever been exercised).
**Source project:** `fxcwkweaxjtknorudmwp` (`coursefinder_Pilot`, org techM `rszbvkqopqfvjldvfnbh`, ap-south-1, Postgres 17.6, Pro plan). **Never** `coursefinder-demo`.
**Goes with:** `docs/platform/RECOVERY-RUNBOOK.md` (scenario C, path C2). The rehearsal measures the RTO and RPO proposed there.

## 1. What the rehearsal proves

| # | Question | Evidence it produces |
|---|---|---|
| Q1 | Can a Supabase daily backup be restored into a separate project? | The project exists, healthy, from a named backup |
| Q2 | How long does it take? | Wall-clock times per step (RTO evidence) |
| Q3 | How old is the data? | Backup time vs restore start (RPO evidence) |
| Q4 | Is the copy complete and faithful? | Migration head, function md5s, row counts, consumer API check, course detail sample (section 5) |
| Q5 | Can the copy be made safe (no jobs, no outbound calls)? | Cron inactive, base address changed, zero outbound calls (section 4) |
| Q6 | Do vault secrets survive a restore to a **new** project? | Count of secrets that decrypt (names only) |
| Q7 | Can the edge functions, admin app and consumer API run against it? | Deploy of a small set, smoke tests |
| Q8 | What is still missing? | A list (Storage, auth settings, secrets) feeding the runbook |

## 2. Cost

- Supabase "Restore to a New Project" creates a project that **mirrors the source compute and disk** (the cost is shown before you confirm). At the 3 Oct record's Medium compute, about **US$0.0822 an hour**: a 24-hour rehearsal is about **US$2**, plus disk for about 4.3 GB (within Pro inclusions or cents). Small would be about US$0.50 a day.
- Budget to approve: **US$2–3** for one day; **at most US$5** if it overruns to two days. Pause or delete it the same day the evidence is saved.
- No PITR is needed. No paid tool (Firecrawl, OpenRouter, Apollo) is called; section 4 makes sure of that.
- Confirm the figure on the confirmation screen and on Dashboard › Organisation › Billing before starting.

## 3. Prerequisites (before the day)

| # | Item | Owner |
|---|---|---|
| P1 | Platform Admin approves: create `coursefinder-restore-test`, the cost, the window, and who deletes it | Platform Admin |
| P2 | Read Dashboard › Database › Backups on the source: PITR on or off; list of daily backups and their times. Pick the **newest** daily backup | Platform Admin or integrator |
| P3 | Window: a weekday, starting about 10:00 Melbourne time (away from the 06:50–07:15 peak). Production reads for comparison only at minutes :10–:30 or :45–:58 | Integrator |
| P4 | Local scratch folder for evidence, outside both repositories, under the session scratchpad | Integrator |
| P5 | The production reference figures (section 5, "P" queries) prepared, each bounded and under 10 seconds | Integrator |

## 4. Steps

Record the clock time at the start and end of every step.

**R1. Freeze reference (production, read-only, small).** Before restoring, note: the chosen backup's timestamp (T_backup); `select max(version), count(*) from supabase_migrations.schema_migrations;` Do not run heavy queries on production at any point.

**R2. Create the copy.** Dashboard › project `coursefinder_Pilot` › Database › Backups › **Restore to a New Project** › choose the backup from P2 › Restore. Name `coursefinder-restore-test`, org techM. Region follows the source (Supabase keeps data in the source region). Record the new ref (NEW_REF) and the time it reports healthy.

**R3. Isolate at once (on NEW_REF only, SQL editor of the new project).** Supabase states that pg_cron and pg_net should be disabled after a copy. Run first, before anything else:
```sql
-- R3a: stop every scheduled job on the copy (150 rows; nothing is deleted)
update cron.job set active = false;
-- R3b: point the job base address at the copy itself (no functions deployed there yet, so calls fail harmlessly)
select setting_value from pipeline.environment_settings where setting_key = 'runtime_edge_base_url';   -- record the shape
update pipeline.environment_settings
   set setting_value = to_jsonb('https://<NEW_REF>.supabase.co/functions/v1'::text)
 where setting_key = 'runtime_edge_base_url';
-- R3c: make sure alerts cannot leave the copy
update pipeline.platform_toolset_settings set value = 'false'::jsonb where toolset_key = 'pipeline' and key in ('alerts.delivery_enabled', 'alerts.webhook_enabled');
```
**Why this matters:** in the minutes between restore and R3, the copy's jobs may fire. Jobs call edge functions through `pipeline.svc_pilot_submit_nonce` at the restored base address, which is still **production**. Production refuses them (each function consumes the nonce from its **own** database, so a nonce created in the copy is rejected with 401), but the calls still arrive. R3 must be done within minutes of the copy being ready. Record the count of such calls (R4).

**R4. Prove isolation (copy).**
```sql
select count(*) filter (where active) as active_jobs from cron.job;                      -- expect 0
select count(*) as outbound_calls, min(created), max(created) from net._http_response;   -- calls made by the copy since it started
```
Wait 30 minutes and run the second query again: `max(created)` must not move. On production, check the edge function logs (Dashboard › Edge Functions › Logs, or the logs tool) for 401 "valid one-time Pilot nonce required" in the window between R2 and R3; record the count. No production setting, job or row is changed.

**R5. Secrets check (copy, names only).**
```sql
select count(*) as secrets, count(*) filter (where decrypted_secret is not null and length(decrypted_secret) > 0) as decrypt_ok
  from vault.decrypted_secrets;            -- never select the secret values
```
Expect 15 and 15. Fewer decrypting means a restore to a new project needs every vault secret re-entered (record it in the runbook). **Then remove the risk:** do not add `OPENROUTER_API_KEY` or `APOLLO_API_KEY` to the copy's edge function secrets, and do not enable any job.

**R6. Reconcile (section 5).** Run the comparison queries on the copy, and the matching "P" queries on production in a quiet window.

**R7. Consumer API on the copy.** `select security.consumer_api_check_v1();` must report no drift (the baseline table is restored with the data). **Do not** call `security.consumer_api_rebaseline_v1` on either project.

**R8. Edge functions (copy, small set).** The deploy workflows refuse any ref other than `SUPABASE_PROJECT_REF`, by design. Do **not** change that variable. The integrator deploys with the CLI from a local checkout of Pilot `main`, using `scripts/ci/deploy-function.sh` with `REF=<NEW_REF>` and a token: deploy only `website-api-v2` and `zoho-api-v2`. Then call each once with a known key (keys are in the restored `private.api_keys`; use the UAT/test key, never a real customer key) for one course detail and one search. Expect HTTP 200 and the same body as the matching production call made at R6 (subject to the drift rule in section 5).

**R9. Contract specs.** From a scratch copy of Pilot, run the non-mutating contract specs against the copy's address: `cf-247-website-api-v2-contract`, `cf-247-institution-type-contract`, `cf-247-s57-consumer-api-frozen`. No `@live-acting` spec.

**R10. Admin app smoke (optional, for UR-14).** Build the chosen recovery commit (Appendix A of the runbook) with `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY` of the copy, run it locally (port 5199), sign in with the UAT user (restored with auth), open Platform health and Course catalogue. Record pass or fail.

**R11. Storage probe (small).** The copy has bucket metadata in `storage.objects` but no files. Record `select bucket_id, count(*) from storage.objects group by 1;` on the copy (expect the section 3 figures as at T_backup) and confirm that downloading one object from the copy fails. This proves, in practice, that Storage needs its own protection (runbook Appendix B, option S). Optionally, with approval, copy 100 objects from production `evidence` into a test bucket on the copy through the S3-compatible API and time it (gives a rate for estimating a full copy).

**R12. Write up** in `nz-enrichment-brief/<date>-restore-rehearsal-result.md`: times per step, T_backup, RPO and RTO figures, every check with pass or fail, the R4 counts, the R5 result, and the gaps. Update section 2 of the runbook with measured times (Platform Admin accepts).

**R13. Clean-up (with the Platform Admin's say-so).** Default: **pause** the project the same day (Dashboard › Project settings › General › Pause), so its evidence stays available; delete it once the write-up is accepted. Deleting removes its data permanently. Record who approved and when. Deleting the copy never affects the source or its backups.

## 5. What is compared

The copy is the database **as at T_backup**; production keeps changing. So each comparison is either exact or "explained by changes since T_backup".

| # | Check | Copy query | Production query | Pass when |
|---|---|---|---|---|
| C1 | Migration head | `select max(version), count(*) from supabase_migrations.schema_migrations` | same | Equal, or production is ahead only by migrations applied after T_backup (list them by `version`) |
| C2 | Last 20 migrations' content | `select version, md5(statements[1]) from supabase_migrations.schema_migrations order by version desc limit 20` | same | Every shared version has the same md5 |
| C3 | Consumer API function md5s | `select name, md5 from pipeline.consumer_api_baseline where kind='function' order by name` and `security.consumer_api_check_v1()` | same | 75 equal md5s; check clean on both |
| C4 | Key function md5s | `select p.oid::regprocedure::text, md5(pg_get_functiondef(p.oid)) from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname in ('security','api') order by 1` | same | Equal, apart from functions changed by migrations after T_backup |
| C5 | Object counts | count of tables, functions and policies per schema (catalogue queries) | same | Equal, apart from post-T_backup migrations |
| C6 | Row counts (exact on the copy; on production bounded by `created_at <= T_backup`) | `count(*)` of `catalogue.providers`, `catalogue.courses`, `catalogue.course_fees`, `catalogue.course_links`, `catalogue.course_intakes`, `catalogue.course_english_requirements`, `scholarship.course_mappings`, `search.course_documents`, `private.api_keys` | `count(*) … where created_at <= T_backup` for tables with `created_at`; split into several small queries outside busy windows | Copy count equals production's "created by T_backup" count, less rows deleted after T_backup (explained) |
| C7 | Published providers | latest `pipeline.settings_backups` row on the copy (counts) | same row by id | Identical |
| C8 | Scheduled jobs | `select count(*), count(*) filter (where active) from cron.job` (before R3: record from the restore result if possible) | same | 150 jobs; the active count before R3 equals production at T_backup (142) |
| C9 | Course detail sample | for 20 courses: `md5(public.website_v2_course('<id>')::text)` | same | Equal for every course whose `search.course_documents.updated_at` is before T_backup on production. The 20 ids are chosen on the copy as the 20 with the oldest `updated_at` among published courses, then checked on production by id list (at most 20) |
| C10 | Permission fingerprint | `supabase/live-capture/baseline/permission-fingerprint.sql` | same | Equal |
| C11 | Vault | R5 | — | 15 of 15 decrypt (or recorded otherwise) |

Every production query is a lookup or bounded by an id list of at most 100, under 10 seconds, outside :00–:05 and :35–:42 and outside 06:50–07:15, after the back-off check of the load policy (rule 5). The integrator runs them one at a time.

## 6. Success criteria

The rehearsal **passes** when all of these hold:

1. The copy is created from a named daily backup and reports healthy (Q1).
2. R4: 0 active jobs, and no outbound call after R3 over 30 minutes (Q5).
3. C1–C3 and C10 pass; C4–C9 pass or every difference is explained by a change after T_backup (Q4).
4. `security.consumer_api_check_v1()` is clean on the copy (R7).
5. R8: both consumer functions answer from the copy; R9 contract specs pass (Q7).
6. Times are recorded for R2 to R9 and T_backup is known (Q2, Q3).
7. The write-up lists everything still missing (Q8), and the runbook's section 2 is updated with measured numbers.

R5 and R10 are **recorded**, not pass/fail: they tell the runbook what to expect.

It **fails** (and is written up as such) if the copy cannot be created, cannot be isolated, or any unexplained difference remains.

## 7. How production is guaranteed untouched

- Nothing is written to `fxcwkweaxjtknorudmwp`. Every write in this plan (R3, R8) runs **only** on NEW_REF; the integrator reads the ref in the SQL editor's project name before each statement.
- "Restore to a New Project" reads a backup; it does not restore over the source (that is a different button, "Restore" under Scheduled backups, which is **not** used).
- The deploy workflows and `apply-migration.sh` cannot target the copy (they require the ref to equal `SUPABASE_PROJECT_REF`), and `SUPABASE_PROJECT_REF` is not changed.
- The copy's jobs are stopped (R3a), their address is moved off production (R3b), and its alerts are off (R3c). Even before R3, production refuses the copy's job calls (nonce check against production's own database).
- No paid-tool key is added to the copy's edge functions; no job is enabled; no `@live-acting` test runs.
- Production comparison reads follow the load policy (section 5), run one at a time by the integrator.
- `coursefinder-demo` is never touched.

## 8. Time estimate

| Step | Estimate |
|---|---|
| R2 restore (4.3 GB) | 30 to 90 minutes (Supabase says it depends on size) |
| R3–R5 isolate and secrets | 15 minutes, plus a 30-minute wait |
| R6–R9 compare, deploy, specs | 2 to 3 hours |
| R10–R11 optional | 1 hour |
| R12 write-up | 1 hour |
| **Total** | **about half a working day**, then pause |

## 9. Decisions needed

1. Yes or no to the rehearsal, the project name `coursefinder-restore-test`, the cost (US$2–3, at most US$5) and the window.
2. Whether R10 (admin app smoke for UR-14) and the R11 100-object Storage copy are included.
3. Pause or delete afterwards, and who does it.
