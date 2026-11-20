# Active cron job reconciliation (CF-247 s881)

**Date:** 20 Nov 2026 · **Chat:** S1-Build · **Directive:** Platform Admin 20 Nov 2026 17:14 and 17:15 AEDT · **Change:** Pilot #1434 (`20261120181000`)

## Goal

The F-OPS ceiling is at most 140 active pg_cron jobs. The 16:54 AEDT validation read 142. The aim is at most 136 with 0 unregistered, so that the next deterministic sweeps (`fid-det-sweep`, S1-Fees-Intakes) still leave room.

## How it was read

- Every figure was read live between 17:18 and 17:58 AEDT, inside rolled-back runs of the `db-migration-dry-run` workflow. Nothing was kept.
- For each active job, the read covered: its schedule; its runs and failures in 24 hours; whether a dispatcher runs it; its catalogue and component register rows; and the on/off setting named in its register purpose.
- The fast jobs were also run once, inside the same rolled-back run, to see what they do now.

## What the count is

- **140 to 143 active, depending on the minute.** `boost-extract`, `coverage-read` and `coverage-read-2` pause themselves when idle, and `flag-recheck` switches them back on when work arrives. This alone moves the count by up to 3, which is why 142, 140 and 143 were all read on the same afternoon.
- **0 unregistered.** Every active job has a catalogue row and a component register row.
- **Net additions since the 140 checkpoint:** `aer-det-sweep` (S1-AER, s834–s835), `struct-det-sweep` (S1-Structure-Outcomes, s860–s862) and `elr-det-sweep` (S1-ELR, s840–s842). `fid-det-sweep` (S1-Fees-Intakes, Pilot #1425) is still to come.

## The 13 consolidation candidates (18 Nov 2026 audit, Pilot #1331)

| # | Job | Status 20 Nov 2026 | Why |
|---|---|---|---|
| 1 | `coverage-discover` | Already folded | `coverage-lane-dispatch`, PR 4 cutover 19 Nov 08:18 (unschedule paste file 3 Dec) |
| 2 | `coverage-discover-2` | Already folded | As 1 |
| 3 | `coverage-ai-match` | Already folded | As 1 |
| 4 | `central-find` | Already folded | As 1 |
| 5 | `logo-find` | Already folded | As 1 |
| 6 | `ops-diagnose` | Already folded | As 1 |
| 7 | `scholarship-listing` | Already folded | As 1 |
| 8 | `settings-backup-daily` | Already folded | `rollup-scheduler`, PR 4 cutover |
| 9 | `coverage-read` | Must keep | Runs every 30 seconds; the dispatcher ticks once a minute, so folding would halve its cadence. Idle-paused when there is nothing to read. |
| 10 | `coverage-read-2` | Must keep | As 9 |
| 11 | `boost-extract` | Must keep (S2-BOOST's lane) | Live work; idle-paused when its queue is empty |
| 12 | `boost-fields` | Must keep (S2-BOOST's lane) | Live work (`boost.fields_on` 1, about 640 runs a day). A fold into `coverage-lane-dispatch` needs its own 24-hour shadow, so it is left for S2-BOOST. |
| 13 | `boost-benchmark` | **Retired now** | Benchmark run bench-5 is finished: its gate reads "nothing left to do", and there were 0 worker calls in 24 hours. The audit said to retire it when the round finished. |

## Switched off now (Pilot #1434): 7 jobs with no work left

Each job is switched off only if its evidence still holds when the migration applies. Otherwise it is left on and the migration says why.

| Job | Cadence | Evidence |
|---|---|---|
| `boost-benchmark` | every 2 min | bench-5 finished (see row 13 above) |
| `lean-sections-eval` | every 5 min | All 13,079 labelled cases were done or failed on 14 Nov; 0 worker calls in 24 hours |
| `lean-qualify` | every minute | `reading.lean_qualify_on` is 0; 0 worker calls |
| `aer-v2-shadow` | :08 and :38 | `aer.v2_shadow_on` is 0; 0 worker calls. The deterministic `aer-det-sweep` is the live reader. |
| `course-url-fill` | daily 02:23 UTC | `course_url.fill_enabled` is 0 (paused by its own retraction guard); the job only returns "skipped" |
| `reread-pilot` | daily 05:41 | The pilot stopped itself under its D13 stop rule; `reread.pilot_enabled` is false |
| `course-description-stale-retire` | hourly :13 | `enrich.course_description_stale_supersede_on` is 0; the job returns `"on": false`, examined 0 |

- **Result (rolled-back dry run, 17:58 AEDT):** active 143 → **136**, 0 unregistered. That is 136 with every idle-paused job on, and 137 once `fid-det-sweep` lands.
- **Kept on, as directed:**
  - the deterministic sweeps: `aer-det-sweep`, `struct-det-sweep` and `elr-det-sweep`;
  - `scholarship-coverage-classify`, `coverage-reconcile` and `ops-pulse-refresh`;
  - the admission rule runners and the coverage lane dispatchers;
  - `rollup-scheduler` and the enrichment plan jobs;
  - every queue poller that would take new work when it arrives.

  The migration's post-check refuses if any of these is off.
- **Reversible:**
  - Nothing is unscheduled or dropped, and catalogue rows and settings stay.
  - To bring a job back, switch it on with `cron.alter_job` and set its register row to active.
  - `docs/paste/PASTE-20261205-s881-idle-jobs-unschedule.sql` unschedules the seven from 5 Dec 2026. It refuses unless all seven are still off, retiring and idle.

## Other jobs looked at and kept

These jobs found nothing to do in the read, but they are queue pollers or periodic checks that act when their input appears, so they are not redundant:

- `transition-recheck`, `scholarship-scope-auto`, `layer1-auto-ingest`, `programme-create`, `layer1-parser-reinfer`;
- `central-attach`, `ca-dli-flag`, `campus-regional-class-refresh`, `nz-cop`, `studysearch-codes`;
- `scholarship-fee-alignment`, `scholarship-nationality`, `better-page-revert`, `coverage-bind`, `provider-website-check`.

`layer2-onboarding-snapshot` has a rollup target in shadow that is switched off. Folding it needs that shadow switched on and a 24-hour cycle first.
