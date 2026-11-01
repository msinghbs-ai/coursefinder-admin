# 2 Nov 2026 07:00 / 07:03 admission time-outs: evidence (Workstream A)

**Scope:** read-only, small, bounded reads on `fxcwkweaxjtknorudmwp` (each under 8 s, `statement_timeout` set per query), taken 2 Nov 07:42–07:50 AEDT, outside the :00–:05 and :35–:42 windows. Sources: `cron.job_run_details`, `cron.job`, `pipeline.job_input_marks`, live function definitions, and `postgres_logs` through the Supabase log query tool (19:40–20:12 UTC). All times AEDT (UTC+11).

**Classification (unchanged):** suspected validation-induced interference, pending root-cause verification. T1 ("0 failed runs") is **not met** for the window from 1 Nov 09:25. This record does not relabel either failure as a pass.

## 1. The two failures

| Job | Start | Duration | Where it was cancelled (log context) |
|---|---|---|---|
| `coverage-admit` (pid 1160446, txn 12415487) | 07:00:00 | 120.1 s, cancelled 07:02:00.483 | `pipeline_num_v1` statement 1, inside `coverage_admission_apply_v1` line 51 (FOR over SELECT rows), called by `coverage_admission_gated_v1` |
| `adapter-overwrite` (pid 1160731, txn 12416752) | 07:03:00 | 120.1 s, cancelled 07:05:00.841 | `coverage_identity_allowed` during startup, inside the fee branch of `adapter_overwrite_v1` line 58, called by `adapter_overwrite_gated_v1` |

Both were cancelled by the 120 s statement time-out (SQLSTATE 57014). The function named in each context is where the loop happened to be at 120 s; both are cheap per call. Each run is a long per-row loop.

## 2. Lock and contention evidence (postgres_logs)

- **No lock wait was logged for either failed run.** Lock-wait logging is on (deadlock time-out 1 s): the log holds one wait in the window, so a wait of 1 s or more by either run would have been logged.
- The one lock wait in the window: 06:52:02, `course_coverage_snapshot_refresh_v1` (pid 1159982) waited for AccessShareLock on `pipeline.course_completeness`, held by pid 1159981 (`course-completeness-build`, 06:52, 24.0 s). It is unrelated to the admission jobs and finished before 07:00.
- **Other statement time-outs in the window** (not admission jobs):
  - 06:50:49: integrator MCP query (E13 gate counted over all pending `course_entry_first_read` items), started 06:48:48;
  - 06:58:46 and 06:58:47: two PostgREST `admin_read` calls (ranking links screen, `ranking_country_id`), authenticator role;
  - 07:00:30: PostgREST `svc_scholarship_discover_next` (worker claim), started after 07:00:19.
- So the database was slow for several unrelated callers from about 06:58 to 07:05. The admission failures were long runs under load, **not lock waits**.

## 3. The integrator's verification queries (MCP, `oauth:9574bd8b…`)

| Started | Ended | Duration | Query |
|---|---|---|---|
| 06:46:48 | 06:48:45 | 115.4 s | E13 gate (`course_entry_gate_v1`) per pending entry item, grouped by field |
| 06:48:48 | 06:50:49 | cancelled at the time-out | E13 gate counts over all pending `course_entry_first_read` items |
| 06:50:53 | 06:51:21 | 26.6 s | E13 gate counts (smaller form) |

No other MCP statement over the log's duration threshold is logged from 06:51:21 to 07:10. Statements shorter than the threshold are not logged, so light lookups cannot be excluded.

**Fact that changes the earlier account:** the heavy E13 queries **ended at 06:51:21, 8 min 39 s before `coverage-admit` started**. They did not run at the same time as either failed run. They may have left the database behind (cache eviction, a backlog of slowed jobs), but that is inferred, not shown. The cause stays **unverified**.

## 4. Run durations, 06:50–07:10 (jobs over 3 s, and all failures)

Baselines are the medians from the Gate C record (1 Nov 19:30 to 2 Nov 06:30).

| Job (schedule, UTC) | Runs in window (start: seconds) | Usual |
|---|---|---|
| coverage-admit (*/10) | 06:50: 61.2 · **07:00: 120.1 failed** · 07:10: 46.6 | 1.3 s |
| coverage-admit-intakes (8-59/10) | 06:58: 96.2 (ended 06:59:36) · 07:08: 1.1 | 1.0 s |
| adapter-overwrite (3-59/10) | 06:53: 30.4 · **07:03: 120.1 failed** | 0.8 s |
| provider-english-defaults (3-59/10) | 06:53: 21.4 · 07:03: 85.2 | 20.6 s |
| coverage-ai-match-prepare (*/2) | 06:50: 45.6 · 06:52: 21.2 · 06:54: 20.9 · 06:56: 22.1 · 06:58: 53.8 · 07:00: 59.7 · 07:02: 75.2 · 07:04: 83.2 · 07:06: 17.0 · 07:08: 22.0 | 21.6 s |
| evidence-filter-options-refresh (4 */2, every 2 h) | 07:04: 79.7 | – |
| website-sync-check (every minute) | 06:55–06:57: 10–11 · 06:58: 26.0 · 07:00–07:05: 24–31 · 07:06: 11.3 | 12.1 s |
| fee-reader (every minute) | 06:50: 25.2 · 06:52–06:56: 11–15 · 06:58: 28.8 · 07:00–07:04: 30–35 · 07:06: 11.5 | 0.7 s |
| nz-cop (*/10) | 06:50: 25.6 · 07:00: 28.7 · 07:10: 20.6 | – |
| stats-15m (1-59/15) | 07:01: 30.0 | – |
| link-refresh (*/10) | 06:50: 22.4 · 07:00: 24.7 | – |
| platform-health (8-59/10) | 06:58: 27.3 · 07:08: 15.8 | 17.5 s |
| queue-watch (4-59/15) | 07:04: 21.3 | 9.3 s |
| admin-read-snapshots (every minute) | 06:58: 26.9 · 07:03: 10.6 · 07:08: 16.6 | – |
| others over 3 s | consumer-reference-bundle-refresh 06:50 12.9; aer-outcome-register 06:50 34.0; course-completeness-build 06:52 24.0; gap-causes 06:55 25.6; course-field-source-build 06:55 13.1; provider-field-daily 06:55 6.4; provider-fee-ranges-refresh 06:57 10.7; course-coverage-snapshot 06:57 7.9; toolset-use-daily 06:58 4.1; website-reference-cache 07:02 21.0; entry-matrix-read 07:04 13.9 | – |

**Shape:** a first rise at 06:50 (several :50 jobs together, during the integrator queries), a return to normal 06:52–06:57, then a second, larger rise from 06:58 to 07:05, and normal again from 07:06. The second rise has no logged MCP query in it.

## 5. The "07:00 daily jobs" are not daily

| Job | Live schedule (UTC) | Runs in AEDT | Shares a slot with |
|---|---|---|---|
| nz-cop | `*/10` | every 10 min at :x0 | coverage-admit (:x0), link-refresh |
| provider-english-defaults | `3-59/10` | every 10 min at :x3 | **adapter-overwrite (:x3)**, provider-basis-rule-admit |
| stats-15m | `1-59/15` | :01, :16, :31, :46 | admin-summary-snapshots-refresh |
| evidence-filter-options-refresh | `4 */2` | every 2 h at :04 (07:04, 09:04 …) | the tail of adapter-overwrite |

The only daily jobs near 07:00 are `provider-field-daily` (06:55, 6.4 s) and `toolset-use-daily` (06:58, 4.1 s), both light. So the same jobs meet the admission slots every 10 minutes all day. 07:00 was unusual in the load, not in the schedule.

## 6. Were records or queue states left inconsistent?

**No.** Evidence:
- Each failed run was one statement in one pg_cron transaction (txn 12415487 and 12416752). A cancel rolls the whole transaction back: admission writes, Layer 4 rows, any pg_net requests queued in it, and the `job_input_marks` update.
- Both wrappers (`coverage_admission_gated_v1` md5 `4e4e7f9a…`, `adapter_overwrite_gated_v1` md5 `ef72b386…`) write `pipeline.job_input_marks` only at the end, in the same transaction. Because it rolled back, `last_input_at` stayed at its earlier value, so the next run did not skip as "no new input". It did the work:
  - `coverage-admit` 07:10 ran 46.6 s (full);
  - `adapter-overwrite` 07:13 ran 28.2 s (full).
- `job_input_marks` now (07:4x): coverage-admit last run 07:40, last full 07:30, last result `errors 0`, `last_error null`; adapter-overwrite last run 07:43, last full 07:23, `errors 0`; coverage-admit-intakes last run 07:38, `errors 0`.
- No non-transactional side effects exist in either path (no dblink or autonomous writes). Sequence numbers consumed by the rolled-back inserts are the only trace, and they are harmless.

## 7. Recovery: runs from 07:06

| Job | Runs (start: seconds, status) |
|---|---|
| coverage-admit | 07:10: 46.6 ok · 07:20: 1.2 ok · 07:30: 65.9 ok · 07:40: 0.9 ok |
| adapter-overwrite | 07:13: 28.2 ok · 07:23: 40.9 ok · 07:33: 0.8 ok · 07:43: 0.7 ok |
| coverage-admit-intakes | 07:08: 1.1 · 07:18: 0.9 · 07:28: 43.1 · 07:38: 0.8 (all ok) |

0 failures since 07:05. Heavy runs stay heavy: coverage-admit 65.9 s at 07:30, and 61.2 s at 06:50 before the incident. On a normal day a heavy run leaves 25 to 60 s of headroom under the 120 s limit, so moderate extra load is enough to push it over.

## 8. Proposed bounded targeted retest

**Aim:** show that the admission jobs complete through the daily peak and the 2-hourly :04 collision without the heavy-query pattern. No production write and no new scheduler.

1. **Precondition.** No integrator or agent query heavier than a lookup during the retest windows (load policy rules 2 to 4). The integrator records that none ran, from `postgres_logs` MCP entries.
2. **Windows:**
   - (a) **3 Nov 06:45–07:15 AEDT**, the same daily peak as the incident;
   - (b) the next two 2-hourly :04 collisions after (a) (09:00–09:10 and 11:00–11:10), when `evidence-filter-options-refresh` meets the :x3 slot;
   - (c) the rolling 24 h from 2 Nov 07:06 to 3 Nov 07:06, as the clean T1 window the Gate C follow-up offered.
3. **Jobs:**
   - coverage-admit, adapter-overwrite and coverage-admit-intakes (pass/fail);
   - provider-english-defaults, coverage-ai-match-prepare and evidence-filter-options-refresh (context).
4. **Pass:**
   - 0 failed runs of the three admission jobs in (a), (b) and (c);
   - every admission run under 100 s (20 s under the limit);
   - `job_input_marks` `last_error` null for all three after (a).
5. **Query** (integrator, after 07:20 on 3 Nov, about 1 s; three job ids, bounded window, no per-row function):
   ```sql
   set local statement_timeout = '8s';
   select j.jobname, count(*) runs, count(*) filter (where d.status <> 'succeeded') failed,
          round(max(extract(epoch from d.end_time - d.start_time))::numeric, 1) max_s,
          round((percentile_cont(0.95) within group (order by extract(epoch from d.end_time - d.start_time)))::numeric, 1) p95_s
     from cron.job_run_details d join cron.job j on j.jobid = d.jobid
    where j.jobname in ('coverage-admit', 'adapter-overwrite', 'coverage-admit-intakes')
      and d.start_time >= '2026-11-02 20:06:00+00'::timestamptz - interval '24 hours' and d.start_time < '2026-11-02 20:15:00+00'
    group by 1 order by 1;
   ```
6. **If (a) fails without any heavy query running,** the integrator query is ruled out as the sole cause. Daily-peak contention is then confirmed, and the stagger (below) and a smaller admission batch become the remediation, not a disclosure.

## 9. Stagger proposal (settings or job command only; not in the migration)

**Why not in the migration:**
- These are `cron.alter_job` schedule changes to live jobs. Their order relative to `adapter-overwrite` and the English admission has not been verified (`provider-english-defaults` may be in the :x3 slot on purpose, next to `provider-basis-rule-admit`).
- The Gate C follow-up calls it a change for the Platform Admin or an approved operations change.
- So it is proposed here, ready to apply as one reviewed change: `cron.alter_job` plus the matching `pipeline.automation_catalogue` schedule text.

| Job | Now (UTC) | Proposed | Why |
|---|---|---|---|
| provider-english-defaults | `3-59/10` | `5-59/10` | Leaves the :x3 adapter-overwrite slot. Odd minute, so it avoids coverage-ai-match-prepare (even minutes). Shares :x5 only with policy-auto-approve (1.4 s p50). It ends before intakes at :x8 (85 s at worst) |
| nz-cop | `*/10` | `7-59/10` | Leaves the :x0 coverage-admit slot. Odd minute. Shares :x7 with nothing heavy (search-refresh-requested is at :x6, 0.07 s p50) |
| evidence-filter-options-refresh | `4 */2` | `27 */2` | Leaves the adapter-overwrite tail. Odd minute, away from :x0, :x3 and :x8. At :27 it overlaps nz-cop (about 25 s) once every 2 h, which is acceptable |
| stats-15m | `1-59/15` | unchanged | Minutes 1, 16, 31 and 46 overlap only the tail of a heavy coverage-admit (:x0, up to 90 s) at :01 and :31. Move to `9-59/15` (:09, :24, :39, :54) only if the retest shows contention at :01 |
| link-refresh (not named in the brief) | `*/10` | optional `1-59/10` | Also shares :x0 with coverage-admit (22 to 25 s) |

**Rollback:** the same `cron.alter_job` calls with the old schedules.

**Lever outside the schedule (G2 settings, Platform Admin):**
- `batch.coverage_admit` (500) and `batch.adapter_overwrite` (200) set how long a heavy run takes.
- Heavy runs of 60 to 96 s leave little headroom. Lowering each batch (for example 500 → 300) shortens heavy runs with no code change; the remaining work carries over to the next run.
- Not proposed until the retest shows whether the stagger is enough.
