# PIM progress: backend interface and UI handover (s1162, F-OPS.21)

From `S1-RM-Design` to `S1-API-Frontend-Delivery`. Platform Admin 25 Nov 2026 19:52 and 21:37: Data Delivery is the primary monitoring screen; queue and lane detail stays under Operations and Scheduled jobs; no new dashboard, queue or framework. A backend read alone does not satisfy F-OPS.21.

## Interface (live when Pilot s1162 merges)

`public.admin_layer23('data_delivery')` (rank 3 and above, unchanged) returns the existing object plus one new top-level key, `pim`, from `security.pim_progress_v1()`. Nothing else in the payload moves. `src/DataDelivery.jsx` already reads it (`rpc('admin_layer23', {p_action:'data_delivery', p_args:{}})`).

| Key | Meaning |
|---|---|
| `pim.as_at`, `pim.window_hours` | Time of the read; the window is the existing `data_delivery.net_short_hours` setting |
| `pim.fields[]` | One row per country and registered course field: `country`, `field`, `applicable`, `not_applicable`, `held`, `backlog` (applicable minus held), `queued`, `running`, `review`, `failed`, `no_source_found`, `expired_leases`, `canonical_gain_window`, `published_gain_window`, `throughput_per_hour`, `clearance_hours` (null when nothing was gained in the window: show "Not measured", never 0 or a guess), `oldest_outstanding` |
| `pim.source_findings[]` | `country`, `class`, `open`: open evidence classes from `pipeline.course_field_absence` |
| `pim.jobs[]` | `job`, `active`, `schedule`, `next_run` for `enrich-plan-run`, `enrich-plan-auto`, `field-gap-queue` |
| `pim.gap_queue` | `cycle`, `last_run_at`, `cycle_started_at`, `cycle_scanned`, `cycle_found` (the last successful pass) |
| `pim.ai`, `pim.firecrawl` | Window use: attempts, failed, cost_usd; calls, credits |
| `pim.human_required` | `layer4_waiting[]` (field, waiting, oldest) and `enrich_review` |
| `pim.leases` | `expired` count and the recovery sentence to show beside it |
| `pim.drill` | Names of the destination screens |
| `pim.meaning` | The three definitions to show as help text |

Roll-ups (overall, per country, per domain) are sums over `pim.fields[]`; the screen adds them, the backend does not repeat them. Fields with no held-value test are absent from the held count until step 1 completes them; the screen shows what the read returns.

## What the screen does (inside the existing Data Delivery panel, as one block "Autonomous PIM")

1. A country selector (from the rows' `country`, never a typed list: s930) and a domain grouping from `field_register.grp` (read through `public.admin_lookups_v1` or the row's own `field`).
2. Overall and per country row: backlog, queued, running, held (review plus no_source_found), failed, completed (held), and the funnel in that order.
3. Gains: canonical and published, with throughput per hour and the clearance estimate (or "Not measured").
4. Oldest outstanding work; last successful and next scheduled run (`gap_queue.last_run_at`, `jobs[].next_run`); AI and Firecrawl use; expired leases with the recovery sentence; human interventions with a link to Layer 4 Review (open, not edited, by this lane).
5. Drill-down: each row links to Scheduled jobs › Queue & lane control (`#scheduled-jobs`) and Operations; the destination screens link back to Data Delivery. Reuse the existing watchdog and s768 controls; add no control.
6. 1440 x 900 and 412 px checks; screen help and `docs/UI-MAP.md` regenerated with the change.

## Boundaries

`S1-RM-Design` does not edit `src/` for this; the backend is additive and G3-safe. Layer 4 Review is not changed by this handover.
