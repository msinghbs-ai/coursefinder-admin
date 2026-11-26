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

## s1218 accuracy pass (SS-Programme-Control 26 Nov 2026 14:25; Pilot #1661)

The live snapshot showed three things the first build did not separate, so the screen now does (no new control, no backend change):

| Point | Live evidence (26 Nov 2026 snapshot) | What the screen does |
|---|---|---|
| `gain_basis` | Academic entry is counted as "courses whose first active entry row was created in the window"; every other field as "enrich items filled in the window". The first build added them. | Each gain group names its basis. Fields on different bases are never added: the gains panel has one group per basis, and a matrix cell that spans two says "Mixed bases" (a legend lists the bases and their domains). The field table shows each row's basis. Clearance names the basis of the longest measured field and says fields are not combined. |
| Published provider vs verified consumer delivery | `published_gain_window` is "canonical gains for courses of a published provider" (the Published switch), not a delivery check. | Renamed "Published-provider gain". A separate "Verified consumer delivery" tile says Not measured per field and points to the stream cards (Website and Zoho read-back). |
| Measured zero vs unavailable | A missing value was summed as 0. | A counted none reads "measured: none"; a missing value is "Not measured"; a sum over rows with a gap says "at least" and how many rows were not counted. |
| Canonical backlog vs work-item holds | Held work items exceed the backlog (AU description: 35,357 held items against a backlog of 13,018; AU English 12,929 against 8,799). | Two groups: Canonical field coverage (applicable, completed, backlog) and Work items in the queue (queued, running, held, failed). Field-table columns read Items queued, running, held, failed. The note says work items are per queue item, can be larger than the backlog and are never subtracted from it. |

Request data (F-OPS.18), response performance and the 412 px live check wait for the S1-RM-Design backend release (request register read and the Data Delivery read under the 8 s limit); the Requests view already renders `pim.requests[]`.

## Acceptance state

Built and checked in real Chromium at 1440 px and 412 px against a mock of the live `pim` shape (desktop spec 17 tests, phone spec 4 tests; 131 related and central-guard specs green).

**Live read-back, 26 Nov 2026 about 14:10 AEDT (Pilot #1659 merged, deploy succeeded).** Signed in as Platform Admin on the live site at desktop width (about 1,900 px), Layer 2/3 Build & enrich › Operations › Data Delivery shows the Autonomous PIM block with all three views, the country selector (All, Australia, Canada, New Zealand), the measure switch, funnel, gains, throughput, measured clearance and the domain × country matrix; no horizontal overflow. The figures match the stored snapshot exactly (counted 1:58 pm Melbourne): applicable 480,923, completed 307,401 (63.9%), backlog 173,522, queued 5, running 0, held 198,841 (1,217 in review, 197,624 no source found), failed 7,719. Fields with no gain in the window say "Not measured", never 0.

- **Not read back live:** the 412 px phone layout. The Chrome window could not be narrowed from the session, so phone width is covered only by the mock-backed spec.
- **Pre-existing, not from this change: the Data Delivery read is near the 8 s limit for signed-in users.** `security.data_delivery_v1()` took 10 to 23 s when timed as the service role (limit for `authenticated` is 8 s). The slowest part is `security.data_delivery_cdesc_stages_v1()` at about 8.4 s, then `data_delivery_intake_v1()` 1.7 s, `data_delivery_aer_v1()` 1.3 s and `data_delivery_pdesc_v1()` 1.0 s, all counted live on every open; the PIM snapshot, queue and hold counts are fast (under 0.1 s). On the live screen, two of three retries failed with "The database took too long to answer", and the third succeeded. Timings were taken while seven cron ticks ran at the same minute boundary, so they are load-dependent. Proposed fix for the owning lane (S2-Build / S1-RM-Design): count those four helpers inside the existing background `data-delivery` job into `pipeline.data_delivery_job_runs`, as already done for `pim`, and read the snapshot. No frontend change is needed.

F-OPS.17 is met live at desktop width. F-OPS.21 stays open until the phone read-back and the Data Delivery read is reliably under the limit; F-OPS.18 stays open until the request register read exists.

**Final authenticated UAT, 26 Nov 2026 15:30 AEDT (after s1174, Pilot #1660).** Signed-in browser call to `admin_layer23('data_delivery')`: 404 to 739 ms over 10 calls (limit 8 s), 200, 85 KB. Database read 0.05 s warm. Snapshot every 10 min; the screen shows its age, and a failed count as Stale beside the last good figures. Role gate in the database: rank 2 refused (42501), ranks 4 to 6 read 42 rows; browser specs for ranks 2, 3, 4 and 6 (Pilot #1663). Still open: the 412 px live read-back (framing is denied by the site's headers, and the browser session cannot resize or zoom, so a phone or a resizable browser is needed) and request data (`pim.requests`).

## s1221 operations integration (SS-Programme-Control 26 Nov 2026 15:46; Pilot #1668; backend s1175, Pilot #1662)

The deployed `pim.operations` read was checked against the live snapshot, `security.data_delivery_v1()` and the s1175 migration (`20261129113000_cf247_s1175_pim_operations_no_sync_fallback.sql`) before building. The screen draws it as delivered; it adds no control beyond a country filter on the new freshness table, no setting and no write.

| `pim.operations` key | Shape (live) | What the screen does |
|---|---|---|
| `workers[]`, `stalled_workers`, `jobs_summary_at`, `meaning` | `{job, running, stalled, schedule, failed_24h, last_start, last_success}`; `stalled_workers` counts workers with a null or old last success against `plans.auto_stall_hours` | Processing shows Stalled workers (a measured 0 reads "0"). A Workers table lists each worker's state (Stalled, Running, Idle on time), last success (a null reads "Never" and counts as stalled), last start, failures in 24 h (a counted none reads "measured: none") and schedule. |
| `expired_leases` | number | Shown beside the existing leases tile only when `pim.leases` is absent. |
| `consumer[]` | `{stream, measured_at, error, rows[{cc, expected, w_*, z_*}]}`; streams live: disc, eng, fee, int, pdesc, sch; Zoho keys are null for `sch` | Verified consumer read-back: one row per stream and country, website and Zoho matched out of expected with pending, missing and not served kept apart; a null Zoho reads "Not measured"; a stream with an error shows the error and the age of the last read; each row says how old the read is and flags it Stale past `stale_after_minutes`. Streams are different kinds of record and are never added; there is no total. |
| `freshness_by_country[]` | `{country, field, held, refresh_due}` | Refresh & maintenance: a by-country and field table (held, due, fresh share, "None held" where nothing is held) with a country filter. The oldest verified date is still counted by field across all countries only. |
| `requests` | `{status: 'not_projected', reason}` | Requests & feedback still says Not available and now gives the backend's reason (no registered database source holds the request register). No status, weight or coverage is shown. |
| verified feedback | no key in the read | Not available, with the reason that no authoritative source is resolved. |
| `snapshots` (top level) | aer, pdesc, intake, cdesc_stages: `{as_at, error, took_ms, failed_at}` | One line under the PIM stamp lists each helper count's age and flags a failed or stale one (its last good result is kept). |

Unavailable still (S1-RM-Design to resolve): the request register (`pim.requests[]`), verified feedback, the oldest verified date by country, and a per-worker heartbeat beyond the job summary.

Built and checked in real Chromium: new desktop spec (13 tests) and 412 px phone spec (4 tests, Pixel 7 emulation) against a mock shaped like the live read, plus s1217, s1218 and the central guards. No migration, no setting, no consumer API change, US$0.

## Live 412 px phone check (open; needs the Platform Admin)

26 Nov 2026 17:10 AEDT, S1-API-Frontend-Delivery (S1-Build hand-off). The one connected Chrome here reports a successful window resize to 412 px but the page still measures 1,894 px, and the site denies framing by design (CSP `frame-ancestors 'none'`, `X-Frame-Options: DENY`; not changed). So no browser available to the session can show the live site at phone width. F-OPS.17 and F-OPS.21 stay open only on this check.

**Signed-in phone check (Platform Admin, a real phone or a browser at 412 px; about 3 minutes).** Open `https://coursefinder-pilot.techm.workers.dev/#layer-2-discovery?tab=operations` signed in as Platform Admin, find Data Delivery › Autonomous PIM, and confirm:

1. The page does not scroll sideways at any point.
2. Delivery matrix: each row is a stacked, labelled block (Domain, All countries, Australia, New Zealand, Canada); the country and measure selectors and the three tabs are easy to tap.
3. Processing: Stalled workers shows a number, and the Workers table is labelled rows (Worker, State, Last success, Last start, Failed in 24 h, Schedule).
4. Verified consumer read-back: each stream and country is a labelled block with Expected, Website, Zoho and Read; "pending · missing · not served" is readable.
5. Refresh & maintenance: the country selector works and the by-country table is labelled rows.
6. Requests & feedback says Not available with its reason; no status, weight or coverage is shown.

Reply with pass, or what failed and a screenshot. Request data stays Not available until a request register source exists (`operations.requests` is `not_projected`).

