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

## Production read-back and follow-on (27 Nov 2026 00:45 AEDT)
Signed in on production after Pilot #1700 deployed (built-in browser, desktop pane and 412 x 915): Scheduled jobs › Automations showed 312 of 312 components, 20 a page, counted 27 Nov 12:06 am (the count took 21.3 s), states Degraded 1, Held 13, Shadow 1, Idle 18, Active 194, Retired 85; the stalled rollup `coursefinder-data-quality-overview-refresh` showed its backend reason and findings. Data Delivery showed no workers table, six state tiles and 28 attention items paged 10. No sideways scroll. Two polish items were fixed in `s1288`: a future next-run time repeated the date (now "in 10 min"), and the state chip was cropped on a phone.

## s1288: sampled delivery read-back (SS-Programme-Control 27 Nov 2026 00:09)
`pim.operations.consumer_fields` (s1176b) is drawn inside Data Delivery's Verified consumer read-back section, per stream (academic entry, descriptions): canonical population and what it counts, sampled coverage (courses checked in the window of the population, with the backend's coverage figure), verified delivery and international applicability as "n of the sampled courses", failure reasons with the latest failing courses, and the last verification. Nothing is extrapolated: the sample and the population are separate figures. A check the backend does not record (descriptions have no international check) reads Not checked, never 0. Guards: `cf-247-s1288-pim-consumer-sample-ui`, `cf-247-s1288-pim-consumer-sample-phone`.

## s1202 review
S1-RM-Design's correction (a read-only call to a frozen read is allowed in a later migration) is right. Its grant branch missed `grant ... on public.<name>` with no object word and named only two of G3's families. `cf-247-s1202` now names `website_v2_`, `website_edge_`, `website_api_v2_`, `zoho_edge_`, `svc_website_settings_v1` and schema `api`, with a self-test (seven change forms fail, four read-only forms pass). G3's central guard stays `cf-247-s57`.
