# security.rollup_tick_v1: capture, replay and the D10 change (s1290)

Owner: S1-Build. Decision: Platform Admin D10, 27 Nov 2026 ("Approve permanent fix"; record coursefinder-admin #1207 comment 7203709925). Pilot migration `20261130090000_cf247_s1290_rollup_tick_p95_estimate_fair_order.sql`.

## 1. Capture (before the change)

Read live on 27 Nov 2026 at 08:40 AEDT from `pg_get_functiondef('security.rollup_tick_v1()'::regprocedure)`:
- 2,795 characters;
- md5 `36a8d4f314788d4a292bac677b568858`;
- one procedure, no arguments.

No migration held this procedure before s1290. The text below is that read, without its final newline:

```sql
CREATE OR REPLACE PROCEDURE security.rollup_tick_v1()
 LANGUAGE plpgsql
AS $procedure$
declare v_t0 timestamptz := clock_timestamp(); v_tick timestamptz := date_trunc('minute', now()); v_budget int; v_finish int; v_keep int; v_back int;
        v_r record; v_el numeric; v_n int := 0;
begin
  if security.pipeline_num_v1('rollup.scheduler_on', 0) < 1 then return; end if;
  if not pg_try_advisory_lock(hashtext('cf247:rollup_tick')) then return; end if;  -- fixed: the one tick lock (a tick still running keeps the next one out)
  v_budget := security.pipeline_num_v1('rollup.tick_budget_seconds', 60)::int;
  v_finish := security.pipeline_num_v1('rollup.tick_finish_by_seconds', 100)::int;
  v_keep := security.pipeline_num_v1('rollup.keep_days', 14)::int;
  v_back := security.pipeline_num_v1('rollup.catch_up_minutes', 180)::int;
  for v_r in
    select t.target_code, t.mode, d.due_at, d.n,
           case when t.mode = 'shadow' then 0 else coalesce(e.max_ms, t.expected_ms, 0) end exp_ms
      from pipeline.rollup_targets t
      cross join lateral (
        select max(m) due_at, count(*) n
          from generate_series(greatest(coalesce(t.last_due_at + interval '1 minute', v_tick), v_tick - make_interval(mins => v_back)), v_tick, interval '1 minute') m
         where security.cron_matches_v1(t.schedule, m)) d
      left join lateral (
        select max(x.ms) max_ms from pipeline.rollup_runs x
         where x.target_code = t.target_code and x.status = 'succeeded' and x.started_at > now() - make_interval(days => v_keep)) e on true
     where t.enabled and d.due_at is not null
     order by t.priority, d.due_at, t.target_code
  loop
    v_el := extract(epoch from clock_timestamp() - v_t0);
    if v_n > 0 and (v_el > v_budget or v_el + v_r.exp_ms / 1000.0 > v_finish) then
      if v_r.mode = 'live' then
        insert into pipeline.rollup_runs(tick_at, target_code, mode, due_at, due_minutes, status)
        values (v_tick, v_r.target_code, 'live', v_r.due_at, v_r.n::int, 'deferred');
        commit;
      end if;
      continue;  -- stays due for the next tick
    end if;
    if v_r.mode = 'live' then  -- PR 1 fix (16 Nov 2026): the due minute is recorded before a live target runs, so a run cut off by the statement limit is not taken again before its next due minute
      update pipeline.rollup_targets set last_due_at = v_r.due_at, updated_at = now() where target_code = v_r.target_code;
      commit;
    end if;
    perform security.rollup_run_target_v1(v_r.target_code, v_tick, v_r.due_at, v_r.n::int);
    v_n := v_n + 1;
    commit;
  end loop;
  -- the run history is trimmed by housekeeping-daily (security.rollup_runs_trim_v1), not inside the tick
  perform pg_advisory_unlock(hashtext('cf247:rollup_tick'));  -- fixed: the one tick lock
end $procedure$
```

## 2. Replay of the run history held

Data: 61,944 successful runs of the 33 live targets in the 14-day window (`rollup.keep_days`). There were 17,090 deferrals in the same window.

- "New" is the s1290 estimate: the 95th percentile plus 25%, capped at the longest run. A target with fewer than 20 runs keeps the longest run.
- "Over" counts the held runs that took longer than the new estimate.

| Target | Priority | Runs | p50 s | p95 s | Longest s (old estimate) | New estimate s | Runs over |
|---|---|---|---|---|---|---|---|
| ops-cost-guard | 3 | 44 | 44.4 | 73.0 | 114.6 | 91.2 | 2 |
| course-coverage-build | 5 | 5,694 | 8.6 | 13.4 | 112.2 | 16.7 | 88 |
| coursefinder-data-quality-overview-refresh | 3 | 5 | 72.6 | 103.2 | 108.6 | 108.6 (short history) | 0 |
| data-delivery | 9 | 12,961 | 0.4 | 21.4 | 103.5 | 26.8 | 309 |
| course-field-readiness | 11 | 2,019 | 33.6 | 52.9 | 94.4 | 66.1 | 30 |
| evidence-filter-options-refresh | 4 | 112 | 39.3 | 64.6 | 88.6 | 80.7 | 1 |
| course-completeness-build | 4 | 225 | 27.7 | 54.9 | 85.9 | 68.7 | 4 |
| adapter-build-readiness | 4 | 225 | 26.9 | 53.6 | 80.3 | 67.0 | 1 |
| aer-outcome-register | 10 | 2,699 | 0.0 | 20.5 | 57.0 | 25.6 | 71 |
| layer2-onboarding-snapshot | 4 | 4 | 41.0 | 52.5 | 54.1 | 54.1 (short history) | 0 |
| stats-15m | 10 | 850 | 13.6 | 22.2 | 44.4 | 27.8 | 5 |
| admin-read-snapshots | 10 | 13,404 | 0.1 | 14.6 | 41.9 | 18.3 | 321 |

**Reading.**
- Under the old estimate, five targets were estimated at 85 to 115 s. Any target whose estimate is above the 100 s finish time can run only as the first target of a tick, and some never were first.
- Under the new estimate, every target with enough history is below the finish time.
- 0.5 to 2.4% of held runs exceed the new estimate. Such a run only makes that one tick longer, which a first target can already do. The 60 s budget then defers the rest of that tick to the next minute. The tick lock keeps ticks from overlapping.
- The selection query took 170 ms against 214 ms for the old query.

## 3. The change

1. **Estimate.**
   - With at least `rollup.estimate_min_runs` (20) successful runs, the estimate is the `rollup.estimate_percentile` (95) run time plus `rollup.estimate_margin_percent` (25), never above the longest run.
   - With fewer runs, it is the longest run, else `expected_ms`, as before.
2. **Order.**
   - Targets at or below `rollup.protected_priority_max` (5) run first, in priority order: the cost guard, the daily overview, the 4-priority builds and the coverage build.
   - Next come targets due for longer than `rollup.starved_after_minutes` (30) without running.
   - Then the rest, in priority order.
   - A starved target is still held by the budget and the finish rule when it is not first, so its wait is bounded by the next tick with no protected target due.
3. **Unchanged:** the 60 s budget, the 100 s finish rule, the advisory tick lock, the due-minute record before a live run, the commit after each target, catch-up, shadow targets and the target priorities. No job, cron row or scheduler is created.

**Rollback.** Set `rollup.estimate_min_runs` to 500 (the old estimate for every target) and `rollup.protected_priority_max` to 0 with `rollup.starved_after_minutes` at 180, on Settings › Pipeline settings, with a reason. Or forward-fix by migration.

## 4. Measured after release

See the status log of `docs/platform/CONTINUOUS-DELIVERY-MASTER-PLAN.md`: Data Delivery freshness, course-field-readiness, the cost guard, admin snapshots, course completeness and deferrals, measured over unattended cycles.
