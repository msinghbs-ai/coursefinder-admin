# CF-247 decision W35: cached snapshots for slow admin reads, and the gap-cause run time

Approved by the Platform Admin on 30 Oct 2026 at 06:53 (both items). Lane M2. Branch `cf247-notices-publishability-snapshots`.

## 1. What each read was doing, and why it was slow

Measured read-only on 29–30 Oct 2026 (UTC 20:00), running as the Platform Admin.

| Read | What it recomputed on every open | Measured |
|---|---|---|
| `admin_platform_notices_read` | `security.platform_notices_v1` (reads 7 days of `cron.job_run_details`, about 118k rows; that table only has an index on `runid`) and `toolset_sample_notices_v1` | 3.2 s for the read; 3.2–4.3 s for the notices function; 0.64 s for the samples. 78 time-outs in 48 h. |
| `admin_progress_read('overview')` | `platform_notices_v1` | 2.7 s |
| `admin_progress_read('running')` | `admin_live_activity_v1`, which runs `scholarship_publishability_v1` for `needs_person` | 4.4 s (4.25 s of it in live activity) |
| `admin_waiting_read` | `scholarship_publishability_v1` (2,123 rows) | 1.5 s; the function took 0.7–2.8 s, and once 14 s under load. 19 time-outs in 48 h. |
| `admin_field_coverage('overview')` | providers by country, with `coverage_country()` called per provider; `max(computed_at)` over 524,732 rows; courses by country; `ai_spend_today_v1` | 1.3–1.5 s. The parts: 0.25–1.9 s, 0.47 s, 0.1–0.4 s, 0.12–0.47 s. 11 time-outs in 48 h. |
| `admin_gap_causes` (GapCauses panel) | Not slow. It showed `at`, which is the start of the hour; the job actually runs at :55 and takes about 26 s. | — |

## 2. The change

**Storage.** A new table, `pipeline.admin_read_snapshots`, holds one row per key:

- `platform_notices`: the notices plus the sample notices.
- `scholarship_publishability`: every row.
- `field_coverage`: courses and providers by country (all countries, no provider filter), `computed_at`, and today's `enrich_fields` AI spend.

Each row has a payload, a `stamp` (the building transaction's `now()`), `generated_at`, `took_ms`, `item_count`, `last_error` and `last_error_at`. The table has row-level security on and is revoked from anon and authenticated. The consumer API never reads it.

**Reads.** Each read now answers from its snapshot and adds fields only:

- `admin_platform_notices_read` adds `snapshot`.
- `admin_progress_read('overview')` adds `notices_snapshot`.
- `admin_live_activity_v1` adds `publishability_snapshot`.
- `admin_waiting_read` adds `snapshot` on the `scholarships_ready` row.
- `admin_field_coverage('overview')` adds `snapshot`.
- `admin_gap_causes` adds `run` (`started_at`, `finished_at`, `age_seconds`, `stale`, `stale_after_minutes`).

**Gap causes.** The `gap-causes` job command becomes `select security.gap_causes_run_v1()`. This builds the same snapshot and also records the run's start and finish in `pipeline.gap_cause_runs`. The migration seeds the last successful run from the cron history once.

## 3. How refresh works, and its limits

- Job `admin-read-snapshots` runs every minute and is catalogued. A snapshot is rebuilt when its age is at least its setting:
  - notices: 5 minutes
  - publishability: 10 minutes
  - field coverage: 10 minutes
- The settings are `snapshots.*_every_minutes`. The only fixed value is a 20-second fire guard, marked `-- fixed:`.
- **Invalidation.** These events make the next minute's run rebuild early, so a fix shows within about a minute:
  - a search resumed or held, or a website entered by hand (notices);
  - a new scholarship publication batch (publishability).
- **Worst-case staleness** is the refresh interval plus about 1 minute. A snapshot older than `snapshots.stale_after_minutes` (30) is marked stale.
- **Load.** Rebuilding costs about 3–4 s every 5 minutes for notices, about 1–3 s every 10 minutes for publishability, and about 2 s every 10 minutes for field coverage. Before, this work ran on every screen open.
- **Side effect.** The every-minute job adds about 1,440 rows a day to `cron.job_run_details` (about 8% on top of today's roughly 17k a day). `fee-reader` already runs every minute. If you prefer a slower cadence, change the schedule to `*/2`; invalidation would then take up to about 2 minutes.

## 4. Stopping concurrent rebuilds (stampede guard)

- Each key's build takes `pg_try_advisory_xact_lock`. If another run is still building that key, the second run skips it and records it as `busy`.
- Screens never trigger a build. They read live only when no snapshot row exists yet, which happens before the first build. The migration does the first build itself.
- If a build fails, the last good snapshot stays. Its `last_error` is recorded, and the snapshot turns stale on screen.

## 5. How staleness is shown

A shared `SnapshotStamp` shows "<label> <time> (<age>)". Past the setting it adds the marker "Stale: older than N min". The age comes from the server's `age_seconds`, so every screen shows the same figure.

| Screen | Label |
|---|---|
| Layer notices strip | Notices checked |
| Toolsets and limits | Notices checked |
| Progress › Overview › Needs attention | Notices checked |
| Dashboard › Also › Scholarships ready to publish | Counted |
| Coverage › Attributes, Every field by country | Provider figures counted |
| Coverage › Attributes, Fill the gaps (AI spend) | Counted |
| Why values are missing | Last run finished |

Why values are missing shows the last run's finish time and age. It is marked stale after `gaps.causes_stale_after_minutes` (75, the same threshold the hourly report uses).

## 6. What stays exact

- **Permission checks:** unchanged in every read. The new functions are revoked from public, anon and authenticated, and are called only inside the definer reads.
- **Joined live at read time:** notice acknowledgements, scholarship `publication_status` and `lifecycle_status`. Publishing a scholarship therefore drops it from "ready" immediately.
- **Notice drill-downs:**
  - A university resumed since the snapshot leaves the `search_held` or `search_stopped` list at once, and the count is adjusted.
  - A provider given a website since the snapshot leaves `no_official_site`.
  - A notice left with no items disappears.
- **The "now" rule:** a notice that its builder stamped "now" is still answered as "now". So the acknowledgement rule (`acknowledged_at >= last_at`) behaves exactly as before.
- **One university's figures:** `admin_field_coverage` with a provider filter is computed live.
- **Shapes:** every returned shape is unchanged; fields are only added.

## 7. Consumer API (G3)

The consumer API is not touched:

- Every edited function is an admin read: `public.admin_*` or `security.admin_live_activity_v1`.
- `security.scholarship_publishability_v1` is not changed. Auto-publish and publish batches still read it live.
- No admission or publishing behaviour changes.
- `public.admin_read` (owned by lane M) is not edited. Its `live_activity` answer gains one field through `admin_live_activity_v1`.

## 8. Rollback

Paste file for the Platform Admin; nothing is dropped by a migration.

1. `select cron.unschedule('admin-read-snapshots');`
2. `select cron.alter_job((select jobid from cron.job where jobname='gap-causes'), command := 'select security.gap_causes_snapshot_v1()');`
3. Restore the six reads by running the reverse `pg_temp.edit_n` edits (new text back to old text). Guard them with these post-W35 md5s:
   - `admin_platform_notices_read`: 3e336b9f01793b45dcc4dd9d8c57a877
   - `admin_waiting_read`: c847e6713e2a339a483f895d0d782a95
   - `admin_gap_causes`: 48a5b2e4315824bb5a91d089b1ba9ec5
   - `admin_progress_read`, `admin_live_activity_v1`, `admin_field_coverage`: read them from the live dry run's "MD5 AFTER" line.
4. Leave the two tables and the new functions in place. Mark them `retiring` in `pipeline.component_register`, and drop them by paste after `hygiene.retire_after_days`.
