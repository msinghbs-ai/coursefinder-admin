# CourseFinder UI/UX Unification & Live Guide Parity Plan (v1.2, Final Fix)

**Status:** approved standing execution plan. **Date:** 23 Nov 2026. **Repositories:** `msinghbs-ai/Coursefinder-Pilot` and `msinghbs-ai/coursefinder-admin`.
**Owners:** S1-API-Frontend-Delivery (UI port, Layer 4 fix, guide parity, legacy CSS retirement) and S1-Build (settings registry, saved courses, partner contacts, daily mirror).
**Source:** Drive document of the same name, mirrored here on the Platform Admin's instruction of 23 Nov 2026 19:59 AEDT. This file is the source of truth.

## 1. Why the UI, mockups and guides drifted

1. **Split production experience.** Pilot #1498 (s990) moved Counsellor (rank 2) onto `src/ui-v1/` (`tokens.css` and `ui-kit.css`; Courses, Universities & Providers, Scholarships, Guide). Admin and Operator (rank 3+) routes stay on the legacy build with 58 legacy CSS files (656 KB).
2. **Layer 4 Review diff layout.** On `#layer-4-review` the Proposed value column collapsed to one word per line next to a full-width Live value now. Fixed in s998 (Pilot #1505).
3. **Settings disconnect.** Pipeline settings (for example `firecrawl.daily_budget_total`, `scholarships.counsellor_page_rows`, `integrations.status_fresh_hours`) do not match the plain-English section headers or sub-tabs, so operators cannot find or change them.
4. **Hardcoded stale role guides.** The legacy Role Guide still carries "reviewed for v2.16.61" and navigation that contradicts the live Counsellor build and the Admin sidebar.

## 2. Four slices

### Slice 1: Layer 4 Review and audit triage (S1-API-Frontend-Delivery)
- Diff grid: Proposed value and Live value now side by side at equal width (`minmax(0, 1fr) minmax(0, 1fr)`, `overflow-wrap: anywhere`) at 1440x900 and 375x812. **Done (s998).**
- Port Layer 4 onto `src/ui-v1/` (with the 2026-11-21 Layer 4 UI spec):
  - all 19 built-in queues share one 3-button bar: Yes (Approve), No (Reject), Resubmit to Review with AI; queue-specific extras under More options;
  - five primary filters on one row (Module / Field, University, Destination country, Source country, Decision bucket); the rest behind Advanced filters (N);
  - rule codes, version tags, 8-character refs and millisecond timings behind a Technical detail toggle, closed by default;
  - port Human Edits & Periodic Audit and Evidence.

### Slice 2: Settings, Integrations and API usage (S1-API-Frontend-Delivery and S1-Build)
- S1-Build: confirm or seed `firecrawl.daily_budget_total` (5.00, Standing Authority Charter section 10) and expose every active pipeline setting with a title, plain-English description, value, unit and audit-reason prompt.
- S1-API-Frontend-Delivery: port Settings, Integrations, API usage and Backup & restore onto `src/ui-v1/`. Render the budget caps (Firecrawl daily cap US$5.00 a day, monthly course-page credit cap) with instant search over plain-English labels and setting keys.

### Slice 3: Pipeline and operations monitoring (S1-API-Frontend-Delivery)
- Port Dashboard, Coverage & completeness, Layer 1 Register, Layer 2/3 Build & enrich, Platform health and Scheduled jobs. Show live queue progress, coverage and the active cron count (at most 140) with no hardcoded version banner.

### Slice 4: Admin catalogue, empty-state pills, route-driven guides (S1-API-Frontend-Delivery and S1-Build)
- Port Courses, Providers, Provider contacts (partner contacts REQ-116 by S1-Build), Scholarships, Entry requirements, Rankings & statistics, Destination data and Reference data.
- Four field-level empty-state pills (source-limitation reasons) across Course detail, Provider detail, AER, ELR and Scholarships.
- Role Guides generated from the live role-route manifest (`docs/UI-MAP.md`): Counsellor Guide (rank 2, the four live screens) and Operator & Platform Admin Guide (rank 3+, every live Admin route, the Layer 4 3-button workflow, Settings and API usage controls, Filter & Badge Reference). All hardcoded `v2.16.61` text and static guide prose removed.
- CI parity guard: the build fails if any guide link, screen name or filter label names a route or control absent from `docs/UI-MAP.md`.
- Legacy CSS retirement: delete the 58 legacy CSS files once no route imports them (checked by import graph, not assumed).

### Slice 5: Shadow-check and lock-preserving fee and intake refresh (S1-Build backend; S1-API-Frontend-Delivery Layer 4 screen)
Platform Admin, 24 Nov 2026 05:51 AEDT. Next S1-Build backend slice after s1016.

- **Shadow audit of locked records.**
  - The periodic fee and intake sweeps also read records whose field holds a manual lock (7,585 locks), in shadow-audit mode.
  - A sweep never writes a locked value: nothing in `catalogue.*` changes for a locked field.
- **Layer 4 item.**
  - When the upstream value differs from the live locked value, the sweep emits one **Periodic Audit — Locked Field Update** diff item into Layer 4 (Human Edits & Periodic Audit). Example: a new tuition year (2026 to 2027) or a fee delta.
  - The item shows live value, proposed value, the source quote and evidence, and the lock (who set it, when).
  - One open item per course, field and proposed value (no duplicates on re-read).
- **Approve & Keep Lock (single and bulk RPC).**
  - The action sets the live value to the proposed value and records the operator's audit reason (required).
  - It keeps the manual lock as it is (same row, same owner) and closes the item.
  - Bulk applies the same reason to the selected items, up to a G2 setting.
  - Reject closes the item and leaves the live value and the lock as they are.
- **Guardrails.**
  - The count of manual locks never changes.
  - Only a person's Layer 4 decision changes a locked value; no machine path does.
  - G3 is untouched (live values are read through the existing frozen views).
  - No new cron job: the shadow check runs inside the existing fee and intake sweeps. Any batch size or bulk limit is a G2 setting.
- **Split.**
  - S1-Build: shadow audit, item kind, RPCs `approve_keep_lock` (single and bulk), specs, rehearsed live dry run.
  - S1-API-Frontend-Delivery: the Layer 4 queue card and bulk bar for the new kind (master plan hand-off).

### Slice 6: Pre-admission sanity gates and golden-record validator (S1-Build; academic entry gate by S1-RM-Design)
Platform Admin, 24 Nov 2026 05:54 AEDT. Next S1-Build backend slice, with slice 5. Benchmark: UAT feedback-4 (Portal, 23 Nov 2026). The 22 `UAT_FEEDBACK:P1` rows in `docs/monitoring/S1-BLOCKER-QUEUE.csv` cover:
- Victoria University (EBCL; held under two VU provider records, a duplicate identity);
- Adelaide University;
- The University of Newcastle;
- The University of Notre Dame Australia.

- **Gates before admission.** An anomaly goes to Layer 4 as a review item; nothing is admitted silently.
  - **Tuition fee year.** A fee is admitted only with a fee year the source states, 2026 or 2027, and never a year inferred from the reading date. A source year that differs from the held year becomes a review item.
  - **English sub-band completeness.** Wherever IELTS is held for a course, PTE and TOEFL each need an overall score and four band scores (or a recorded "not stated by the source"). A partial set becomes a review item. Owner: S1-ELR domain, solved by S1-Build per the blocker queue.
  - **Canonical campus matching.** A course is linked only to a campus of its own provider's canonical campus list, including Adelaide University's (the merged university). An unmatched or cross-provider campus becomes a review item.
  - **Course-linked scholarship GPA criteria.** A scholarship linked to a course needs its GPA or grade criterion stated with its scale. A criterion with no scale, or one that conflicts with the course's level, becomes a review item.
- **Golden-record validator.** `scripts/ci/validate-golden-courses.mjs` asserts live completeness of the feedback-4 benchmark courses through the additive v3 read path, then reports what is missing for each field: fee year, English bands, campus, scholarship criteria and academic entry. The course list is read from a fixture listing the benchmark course ids, not written into the script. It runs in CI against live data and in the 08:00 AEDT digest.
- **Guardrails.**
  - G3 75/48 frozen; reads through additive v3 RPCs only.
  - No admitted record is withdrawn in bulk. A gate holds new admissions; held values are checked by the validator and listed, not deleted.
  - Manual locks unchanged.

### Slice 7: In-app counsellor feedback (S1-Build backend; S1-API-Frontend-Delivery screen)
Platform Admin, 24 Nov 2026 05:54 AEDT.

- **Table.** `pipeline.counsellor_feedback`, with:
  - `course_id`, `provider_id` and `campus_id`;
  - `issue_categories text[]`, from a reference list, not free codes;
  - `notes`, `source_url` and `displayed_snapshot jsonb` (what the counsellor saw);
  - the submitter, the time, a triage status and a link to the Layer 4 item.
- **Row-level security.**
  - Rank 2 (Counsellor) inserts and reads only their own rows.
  - Rank 3 and above read and triage all rows.
- **Additive v3 RPCs.**
  - `counsellor_feedback_submit_v1` checks the ids exist and caps notes and snapshot size with G2 settings.
  - `counsellor_feedback_list_v1` lists own rows for rank 2 and all rows with filters for rank 3 and above.
  - Layer 4 triage: each submission opens a Counsellor feedback review item for its course, and the triage decision is recorded on both.
- **Screen.** The feedback button on Counsellor Course detail, and the triage view, are handed to S1-API-Frontend-Delivery.

### Slice 8: Firecrawl Monitor webhook ingestion (S1-Build backend; S1-API-Frontend-Delivery screen)
Platform Admin, 24 Nov 2026 06:03 AEDT. API facts read from Firecrawl's documentation on 24 Nov 2026 (monitoring, webhook events, webhook security).

- **Edge function `firecrawl-monitor-webhook`.**
  - It verifies `X-Firecrawl-Signature: sha256=<hex>`: an HMAC-SHA256 of the raw request body with the account's webhook secret, compared timing-safe. A failed check is answered 401.
  - The secret is set by the Platform Admin as an Edge Function secret; no session handles it.
  - It answers 2xx within Firecrawl's 10-second limit, then processes the event.
  - It is idempotent on `webhookId` (Firecrawl retries 3 times and signs no timestamp).
  - `monitor.page` events are kept when `status` is `changed` or `new`; `monitor.check.completed` is kept as the check summary.
- **Storage.** Additive table `pipeline.monitor_events`, holding:
  - delivery id, monitor, check, URL and status;
  - `diff.json` (keyed by JSON path, `{previous, current}`);
  - matched provider and course, the routing result and the received time.
- **Routing.** Page text is untrusted (`fenceUntrusted`) and no model reads it (judge off).
  - A diff on an unlocked course or provider field goes through deterministic validation and admission (the slice 6 gates).
  - A diff on a field with a manual lock (7,585) opens a slice 5 **Periodic Audit — Locked Field Update** item in Layer 4 › Human Edits & Periodic Audit, decided by Approve & Keep Lock. Nothing is written to a locked value.
- **Initial Tier 1 watchlist.** Weekly, JSON-schema `changeTracking` mode, `judgeEnabled: false`:
  - **Universities:** Victoria University, Adelaide University, The University of Newcastle, The University of Notre Dame Australia, Monash, Melbourne, Macquarie and QUT.
  - **Pages:** each university's international entry-matrix, English language requirement (ELR) and 2027 fee hub pages, taken from their registered official sources.
  - **Web-scale search monitor:** a weekly search for Monash and Adelaide University 2027 entry and fee schedules.
  - Monitors are registered as rows in a watchlist table, never in code. Registering them calls the Firecrawl account (paid spend); see the budget gate below.
- **Cost and limits.**
  - Scrape checks cost 1 credit per URL per check plus format add-ons; search costs 2 credits per 10 results; there are no judge credits.
  - No cron job is added: Firecrawl pushes the events.
  - Spend is checked against the platform cap (US$5.00 a day) and the Firecrawl daily budget setting before any monitor is registered.
- **Screen.** Active monitors, last check, status and credits used, shown on Admin › Integrations and Services & limits. Handed to S1-API-Frontend-Delivery on an additive v3 read that S1-Build posts.
- **Guardrails.**
  - G3 75/48 frozen.
  - Catalogued as a component (G1).
  - The webhook endpoint follows the API security guide (fixed error codes, no raw database messages).
  - Manual locks unchanged.

## 3. Acceptance

| Slice | Scope | Owner | Gate |
|---|---|---|---|
| 1 | Layer 4 diff fix, Layer 4, Human Edits & Periodic Audit, Evidence | S1-API-Frontend-Delivery | Diff columns 50/50 at 1440x900 and 375x812; 19 queues share the 3-button bar; all `data-l4-*` specs pass |
| 2 | Settings, Integrations, API usage, Backup & restore; `firecrawl.daily_budget_total` = 5.00 | S1-Build and S1-API-Frontend-Delivery | Every live setting editable with an audit reason; saved-courses RLS live |
| 3 | Dashboard, Coverage, Layer 1 Register, Layer 2/3, Platform health, Scheduled jobs | S1-API-Frontend-Delivery | No hardcoded version string; live cron, lock and coverage figures verified |
| 4 | Admin catalogue, four pills, route-driven guides, 58 CSS files deleted | both | Zero legacy CSS imports; guide-to-route parity check green; `v2.16.61` gone |
| 5 | Shadow-check and lock-preserving fee and intake refresh | S1-Build (backend), S1-API-Frontend-Delivery (Layer 4 screen) | Locked fields never written by a sweep (rehearsed); a fee or year delta on a locked field creates one Locked Field Update item; Approve & Keep Lock (single and bulk) updates the value, logs the reason and leaves the lock count at 7,585 |
| 6 | Pre-admission sanity gates and golden-record validator | S1-Build (S1-RM-Design for academic entry) | Each gate routes its anomaly to Layer 4 (rehearsed on the feedback-4 universities); `validate-golden-courses.mjs` green in CI or naming every missing field; G3 75/48 |
| 7 | In-app counsellor feedback | S1-Build (backend), S1-API-Frontend-Delivery (screen) | RLS: rank 2 own rows only, rank 3+ all; submit and list RPCs answer; each submission opens one Layer 4 item |
| 8 | Firecrawl Monitor webhook ingestion | S1-Build (backend), S1-API-Frontend-Delivery (screen) | Signed deliveries accepted and unsigned ones refused (401); a repeated `webhookId` stored once; a locked-field diff opens one Layer 4 item and writes nothing; weekly Tier 1 monitors registered within the spend cap; no new cron job |

## 4. Guardrails

Consumer API G3 (75 functions, 48 relations) frozen (`s57`), reads use additive v3 RPCs only; 7,585 manual locks immutable (no lock row is added, removed or changed; under slice 5 a locked value changes only by a person's Approve & Keep Lock in Layer 4); at most 140 active cron jobs; paid spend at most US$5.00 a day. Every PR keeps Playwright at 1440x900 and 375x812, `docs/UI-MAP.md` and `TEST-REGISTER.md` green.

## 5. Delivery rule for this plan

Each port is a Pilot PR preceded by its Admin PR (register, UI map, plan row). A legacy CSS file is deleted only in the PR after which the import graph shows no importer. Status is kept in `CONTINUOUS-DELIVERY-MASTER-PLAN.md` (Lane 1 status log).
