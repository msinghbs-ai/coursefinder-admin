# Job and lane monitoring UI (s1283)

SS-Programme-Control, 26 Nov 2026 22:51 AEDT: "Complete job and lane monitoring UI". Backend: s1176 (Pilot #1693). UI: Pilot #1700. Frontend only; no migration, no setting, no new page or tab, consumer API untouched (G3).

## Where it is
| Screen | What it shows | Source |
|---|---|---|
| Data Delivery › Autonomous PIM › Delivery matrix | Snapshot time and any stale error; state counts; counts by component type; the items needing attention with the backend reason and findings (search, state and type filters, 10 a page); the Processing stalled count; one link to Scheduled jobs | `pim.operations` (`states`, `by_component`, `attention`, `jobs_snapshot`) in `public.admin_layer23('data_delivery')` |
| Scheduled jobs › Automations (first block) | Every cron, lane, rollup target and admission rule: state and reason, heartbeat, next run, 24 h outcomes; search; type, state, finding and 24 h outcome filters; 20 a page; Details drill-down | `public.admin_pim_jobs_v1` (Curator and above; the snapshot the background refresh keeps) |

## Rules kept
- The frontend only orders, filters and names the component type. State, effective state, `moved_to`, reason, findings and outcome classes are the backend's words (no competing label is derived).
- Outcome classes per run: productive, empty, held, failed, deferred, unmeasured. An outcome not recorded is Unmeasured, never 0; a partial window says when retained history starts.
- A failed background count keeps the last good figures and shows Stale with the reason; a snapshot not yet counted says so.
- Searching, filtering and paging work on the loaded snapshot; they never make another read. Nothing on the screen starts, stops or changes a job.
- Phone (412 px): the table becomes labelled cards, controls are 44 px, one page at a time. The 138-row worker table is removed.

## Known backend point
`toolset.ai[].not_ok` equals `attempts` on every service (for example 6,913 of 6,913; the 24 h answers are 6,274 answered and 191 failed), because the count treats `answered` as not OK. The UI omits failed AI attempts until the backend count is corrected, and says so on screen.

## Guards
`cf-247-s1283-pim-jobs-monitoring-ui` (desktop), `cf-247-s1283-pim-jobs-monitoring-phone` (`@responsive`). Retired: two s1221 tests that guarded the worker table (see the retirement log).
