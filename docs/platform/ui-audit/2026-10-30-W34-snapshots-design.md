# CF-247 decision W34: cached snapshots and page-first reads for the four slow admin reads

Approval: Platform Admin, 30 Oct 2026 06:53. Lane M (code only). Branch `cf247-admin-read-snapshots`. Migration `20261030070000_cf247_admin_read_snapshots.sql` (provisional number; renumber as needed).

## Problem

The weekly deployed run on 30 Oct (01:00 to 01:15 AEDT, 14:00 to 14:15 UTC on 29 Oct) had four red tests. All four were database response time under load. At 14:00 UTC several jobs also hit their 120 s limit.

| Read | Weekly run | Budget or limit |
|---|---|---|
| `admin_read('providers_page')` | 3,552 / 3,043 ms | 3,000 ms |
| `admin_read('courses_page')` | 3,020 / 3,018 ms | 3,000 ms |
| `admin_read('pipeline_jobs_page')` | HTTP 500 (statement time-out) | 8 s signed-in limit |
| `admin_read('course_coverage')` | HTTP 500 twice (statement time-out) | 8 s signed-in limit |

## Causes (measured read-only as the Platform Admin, 30 Oct 2026)

The database was busy throughout, so the timings below are single runs.

- **providers_page** (`security.admin_providers_page_v2`): the course count, the adapter status (a function call) and the evidence count (a union over three tables) were worked out for every provider (3,085). This happened before the page was chosen, because `count(*) over()` needs every row. Measured at 1,722 ms idle.
- **courses_page** (`security.admin_course_page_fast_base`): the screen's default arguments include `lifecycle_status='active'`, so the read skips the unfiltered fast path. Every matching course (35,668) was then carried with all its columns, the description too, through a window count and a full sort that spilled to temporary files. Measured at 1.0 to 1.6 s idle.
- **pipeline_jobs_page** (`security.admin_pipeline_ops_read`): every job (19,657) was projected in full before sorting. That projection meant about 30 jsonb extractions per job, an evidence count per job (0.3 s) and a register-run lookup per job (0.7 s), with wide rows sorted through temporary files. Measured at 3.8 s idle and 8.1 s when busy.
- **course_coverage** (`security.admin_course_coverage_read`): every open re-totalled the hourly snapshot tables, about 524,000 attribute rows. Measured at 6.1 s idle. Separately, the hourly builders `truncate` their tables, so during a build (38 to 56 s) any live read of those tables waits on the lock.

## Changes

| Read | Change | Before → after (read-only, same session) | Same answer |
|---|---|---|---|
| course_coverage | Answers from the derived snapshot `pipeline.course_coverage_totals` (48k rows). The live re-total stays only as the fallback when no snapshot exists. | 2.6 to 6.1 s → about 0.5 s or less (estimated from `explain analyze`; the live dry run measures it). On a local copy the read was not blocked while a source table was exclusively locked. | Yes, for 6 filter sets on live data and 7 on local data, apart from the new `snapshot` key |
| providers_page | The page is chosen on light columns. Counts, adapter status and evidence are worked out for the 50 page rows only. Adapter status for every row only when the Adapter filter or sort needs it; course count only for the Courses sort. | 910 to 1,722 ms → 50 to 102 ms | Yes, byte-identical, 7 argument sets |
| courses_page | The filters run once into ids plus sort keys. The total is a count, and the page is the ordered ids. The 50 rows are then read in full. | 384 to 998 ms → 253 to 337 ms (interleaved) | Yes, byte-identical, 8 argument sets |
| pipeline_jobs_page | A register run's earlier batches are hidden by one set-based match of the about 100 runs, which is the v2.15.246 Fix 1 rule. Filters run once into ids plus sort keys. The evidence count and run totals are worked out for the page rows only. Adds a new partial index `pipeline.jobs (source_id, created_at) where job_type='regulatory_sync'`. | 2,107 to 8,076 ms → 213 ms (before the index; the index removes the run match's 128 ms) | Yes, byte-identical, 9 argument sets |

## Refresh and invalidation bound (course_coverage)

- Job `course-coverage-snapshot` runs every 5 minutes (`2-59/5`) and calls `security.course_coverage_snapshot_refresh_v1()`. The command has no numbers in it, and the job has a catalogue row.
- The job compares the source build times (`max(computed_at)` of the attribute, completeness and field-source tables) with the times the snapshot was built from:
  - If they are unchanged, it only marks the snapshot checked.
  - If they have changed, it rebuilds, but not more often than the setting `snapshot.course_coverage_min_interval_minutes` (default 10; range 5 to 120 minutes).
- The snapshot is therefore never more than about the interval plus 5 minutes behind an hourly build, and is rebuilt at most about 6 times an hour.
- A rebuild takes about 1 to 3 s in the job, never in a read.
- The rebuild uses `delete` and `insert` in one transaction, not `truncate`. A reader always sees the whole previous snapshot or the whole new one.

## Stampede guard

- Reads never rebuild, so screens cannot cause a stampede.
- The job takes `pg_try_advisory_xact_lock`. A second run (an overlap or a manual run) returns `busy` at once, and the screens keep the last snapshot.
- `lock_timeout` is set to 2 s and marked `-- fixed:`. If an hourly builder holds its table, the run returns `source_build_running` and the next run tries again. It never queues behind the builder.

## Staleness display

- `course_coverage` now returns `snapshot: {source, generated_at, checked_at, source_computed_at, completeness_computed_at, field_sources_at, stale_after_minutes, stale}`.
- `stale` is true when the snapshot has not been checked for `snapshot.course_coverage_stale_minutes` (default 30; range 10 to 1,440 minutes), for example when the job has stopped.
- Completeness › Courses and Attributes show "Totals from the snapshot built …, last checked against the hourly build … Course lists opened from these totals are always live."
- When stale, the screens add an amber "Stale: not checked for more than 30 minutes, so these numbers may be behind."
- If no snapshot exists yet, the screens say "Totals counted just now".

## Permission and exactness preserved

- Every edited function keeps its role check first. No edit touches a `current_role_rank` line, and the replaced providers function keeps its check unchanged.
- The new refresh function is revoked from public, anon and authenticated.
- The new tables have row-level security enabled and are revoked from anon and authenticated.
- The drill-downs `course_coverage_courses` and `course_coverage_providers` are not edited; they stay live and exact.
- Nothing changes in the consumer API (Decision 266), admissions or the catalogue.
- `public.admin_read` is not edited (md5 `6b1bb9d569bd13390f76803f9a710053`).

## Tests

- No budget or time-out has changed. `RPC_BUDGET_MS` and `DETAIL_BUDGET_MS` are still 3,000, and the deployed specs still assert no HTTP 5xx.
- The new spec `cf-247-s178-admin-read-snapshots-contract` (6 tests: 4 source contracts and 2 mocked browser tests) guards the design.

## Rollback

1. Unschedule `course-coverage-snapshot`.
2. Restore the four functions from their pre-change definitions, at md5s:
   - `0485f037236c3859e3c9f757b8a440eb` (course_coverage)
   - `aa10ef7287e7937e476be26c6f157f91` (courses)
   - `898e94c53630aee8e22466b121915e8a` (jobs)
   - `9ebd485d949649a3959746692efbe511` (providers)
3. Faster partial rollback for course_coverage only: empty `pipeline.course_coverage_snapshot` by a paste file. The read then falls back to the live re-total straight away.
4. Drop the two tables and the index later by a paste file, per the housekeeping rules.

## Residual risk (not in scope)

- The live drill-down `course_coverage_courses` still reads `pipeline.course_attribute_coverage`, so it can wait up to about 56 s during the hourly `truncate` at :47 (the 8 s limit gives HTTP 500). The cure is in the builder: build into a staging table and swap, or use delete and insert instead of truncate. That is a separate change.
