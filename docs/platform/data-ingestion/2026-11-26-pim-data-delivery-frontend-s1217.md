# Autonomous PIM block in Data Delivery: what was built (s1217, F-OPS.17 to F-OPS.21)

From `S1-API-Frontend-Delivery`, 26 Nov 2026 13:22 AEDT, to `SS-Programme-Control` (P0 "Complete Data Delivery Frontend", Platform Admin authority 26 Nov 2026 13:07) and `S1-RM-Design` (monitoring data accuracy), `S1-Build` (integration).

## What it is

One block, "Autonomous PIM", inside the existing Data Delivery panel (Layer 2/3 Build & enrich › Operations). Not a tab, a dashboard or a queue. It reads the `pim` snapshot that `security.pim_progress_v1()` puts in the existing `public.admin_layer23('data_delivery')` answer (counted by the existing `data-delivery` job, s1167). No migration, no new backend read, no new setting and no new control; the Consumer API surface (G3) and every role permission are untouched. Code: `src/PimDelivery.jsx` (new), `src/DataDelivery.jsx` (one line), `src/data-delivery.css`.

## Views

| View | What it shows | Where the figures come from |
|---|---|---|
| Delivery matrix | Country selector (from the rows, s930) and measure switch (canonical completeness, backlog, canonical gain, consumer gain); domain × country matrix with a cell that opens that scope; the funnel (applicable, backlog, queued, running, held = review + no source found, failed, completed); gains, throughput, clearance, oldest outstanding; last and next run; scheduler jobs; expired leases with the recovery sentence; AI and Firecrawl use in the window; human interventions with links to Layer 4 Review | `pim.fields[]` (roll-ups are summed in the screen), `pim.jobs`, `pim.gap_queue`, `pim.leases`, `pim.ai`, `pim.firecrawl`, `pim.human_required`, `pim.drill`, `pim.meaning` |
| Requests & feedback | Request register table (status in Rules v1.3 words beside separate canonical coverage, consumer coverage and freshness) | `pim.requests[]` **when the backend supplies it**. Until then: "Not available" with the reason. No status, weight or coverage is estimated |
| Refresh & maintenance | Freshness of held values by field, source outcomes with protected holds, excluded gaps (workload, not delivered data), Academic entry stages and Scholarship dispositions by country, replacement check | `pim.refresh`, `pim.excluded`, `pim.lifecycle` |

Domains and plain field names come from the field register through the existing `admin_field_coverage('overview')` read (`register`: field, label, group), read once per page load. If that read fails the screen says so and shows one group of fields by code.

## Figures not counted, and how the screen labels them

| Figure | State | Screen |
|---|---|---|
| Request register (status, weight, request coverage) | No backend read yet (Master Plan 6.2 interface 6, `S1-RM-Design`) | Requests & feedback: "Not available" with the reason |
| Consumer coverage as a share | Not counted; only `published_gain_window` exists | Matrix measure "Consumer gain" (window gain); the share is stated as not counted |
| Reported data issues verified fix | Counsellor reports are not tied to a verified re-check in the read | "Not available" |
| Worker heartbeat, stalled processing | The read carries job schedule, last queue pass and expired leases only | "Not measured" with the reason; no threshold is typed in the screen (G2) |
| Clearance where nothing was gained in the window | `clearance_hours` null | "Not measured: nothing gained in the window"; the roll-up shows the longest measured field and how many fields with a backlog have no estimate, never a blended figure |
| Freshness by country | The read counts it by field only | Stated on the screen |
| AI spend not measured | `cost_usd` null | "Not measured", not $0 |
| A failed snapshot | `snapshot_error` | Last good figures marked Stale with the error and its time |

Stage counts (`queued`, `running`, `review`, `failed`, `no_source_found`) are work-item counts and can exceed the backlog (for example AU description: backlog 13,018, no source found 35,262). The screen shows them as counts and says they are not parts of the backlog.

## Expected shape of `pim.requests[]` (for S1-RM-Design, interface 6)

Each item: `id`, `title`, `scope` (text), `status` (Rules v1.3 word), `weight` (0 to 3), `canonical_pct`, `consumer_pct`, `fresh_pct` (numbers or null), `clarification` (text or null). A null figure is drawn "Not measured". The screen adds no write: the weight setting stays a Settings control with a reason (not part of this change). If the backend chooses other keys, only the Requests table in `PimDelivery.jsx` changes.

## Drill-down both ways

Out of the block: Operations lane funnels, Scheduled jobs, Platform health › Queues & yield (watchdog) and Layer 4 Review. Back in: a one-line link on Scheduled jobs › Automations and Platform health › Queues & yield to Data Delivery › Autonomous PIM.

## Acceptance state

Built and checked in real Chromium at 1440 px and 412 px against a mock of the live `pim` shape (desktop spec 17 tests, phone spec 4 tests; 131 related and central-guard specs green). Live read-back after merge is recorded in `docs/CURRENT-STATE.md`. F-OPS.17 and F-OPS.21 stay open until that read-back; F-OPS.18 stays open until the request register read exists.
