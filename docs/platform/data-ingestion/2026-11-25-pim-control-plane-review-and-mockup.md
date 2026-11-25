# Global Autonomous PIM: design review, sizing and control-plane mockup

**Status:** design contribution for consolidation. Nothing is built, switched on or changed. This is not an implementation plan; the plan stays in Feature Acceptance and the Master Plan.
**Date:** 25 Nov 2026, 17:15 AEDT. **Asked by:** Platform Admin (consolidated design review, feedback and UI mockup brief).
**Chat:** StudySearch requirements register (Claude).
**Read from:** admin `main` `e6594483`; the umbrella design (M3, "Global Autonomous PIM Platform", v0.1); the Intake Engine design in this folder (with sections 4.0 and 4.0.1); `docs/UI-MAP.md` (release 2.17.0); the component register; s768; the capacity audit (21 Nov); the live telemetry read-back (23 Nov); the daily executive status (25 Nov); Request Register Rules v1.3.
**Not read:** Pilot source, and the live database for this brief. Function bodies and current settings must be re-read at implementation.

**Mockup:** [`mockups/pim-control-plane-mockup.html`](mockups/pim-control-plane-mockup.html) (one self-contained file; open in a browser). Every value in it is tagged LIVE READ or SAMPLE, and every control EXISTING, EXTENDED or PROPOSED.

---

## 1. Independent feedback on the architecture

**Will it meet the objective?** Yes in shape, with five conditions. The umbrella design is right that the missing piece is the closed loop, and right to extend the existing planner. The conditions below are where it would otherwise fall short.

| # | Finding | Why it matters | What to change |
|---|---|---|---|
| 1 | **The planner does not yet cover the first two domains.** The umbrella records that `enrich_plan_start_step_v1` dispatches site, pages, scholarships, fields and adapter, with no academic entry step, and that scholarship plans mainly target providers with no awards. | AER and scholarships are the acceptance scope, so the loop can't close for them until the planner has those steps. | Add an AER step and widen the scholarship step. This is the first build item, ahead of any screen. |
| 2 | **The planner's own run time is the demonstrated bottleneck.** `enrich_plan_auto_v1` has hit the 120-second limit (IQ-00355) and produced no new plans in that hour; `field-gap-queue` has hit a statement time-out; `coverage-reconcile` time-outs cluster on the busiest minute. | More work through the same planner makes this worse. It is a query-shape problem, not a compute-size problem. | Bounded slices from a checkpoint (the gap queue already has one) and a run-time test in acceptance. No infrastructure upgrade. |
| 3 | **"Applicable" is not defined anywhere I could find.** Both targets (100% of applicable fields filled; 100% accounted for) divide by it. | Without it, the matrix can't be computed and no-source can't be told from not-attempted. | One applicability rule per field in the existing field register (`pipeline.field_register`, F-OPS.03), including evidenced no-source (`pipeline.course_field_absence` exists). |
| 4 | **There are at least five status registers today.** AER and Scholarship reader-status CSVs, `PROVIDER-ENRICHMENT-QUEUE.csv`, the data gap register, the daily status, plus the trackers in Drive. | They disagree by design (different denominators and status words), and each needs a chat or a job to refresh. | Generate all of them from planner state and canonical data once that exists. Retire the hand-kept ones. |
| 5 | **Supersession safety is missing from the common contract.** s871 replaced 1,818 readings and 1,563 courses were left with nothing. The umbrella says "do not remove valid canonical records because a new read failed", but those were proposals, not canonical. | The same loss can recur under an automated planner, at scale. | The typed outcome needs "replaced, successor verified" and a check two cycles later. Shown in the mockup under Refresh & maintenance. |

**Other risks to autonomous operation**

- **People in Layer 4 are a rate limit.** 661 academic entry items and 81 scholarship providers are waiting. A planner that proposes faster only lengthens that queue. The Layer 4 regrouping and the routing class (F-OPS.05, P0-4) should land with the loop, not after it.
- **Rendered pages.** The scheduled Firecrawl budget is 5 credits a day. Pages with collapsed sections will sit in "held: budget" indefinitely unless that budget is sized to the measured need.
- **Scheduled job ceiling.** 138 of 140 are active. The design must not add a job per domain or country; it doesn't, and that should be an acceptance test.
- **Cost is not the risk.** Measured AI cost is about US$0.0001 to US$0.0003 a call. See section 5.
- **Quality.** A reader's answer is not its own proof. The umbrella says so; the mockup shows quality measured against the stored page. Until the labelled set exists, "recall" columns in Models & services will be empty rather than estimated.

**Reconciling Intake Engine v0.1 with the existing planner**

| v0.1 proposal | Reconciled position |
|---|---|
| New `intake-planner` lane | Retired. Extend `enrich_plan_*` and the standing gap queue (`field_gap_scan_v1`, `field_gap_queue_tick_v1`). |
| Ledger, one row per provider and domain | Retired as a table. State is derived at source, course, award, field and edition level; provider and country rows are summaries only. Add stored state only for attempts and due times, if the planner can't hold them in `enrich_plan_runs`. |
| Action catalogue and escalation ladder | Kept, as the planner's typed next action and typed outcome. |
| Reader registry and builder | Kept, lower priority (umbrella M7). |
| Compare-and-learn loop | Kept, lower priority (umbrella M7). |
| "Operations › Intake" screen | Retired. The views sit on existing pages (section 4). |

## 2. Inventory: retain, extend, retire, missing

| Component | Decision | Note |
|---|---|---|
| Layer 1 Register, registers and editions | Retain | Country onboarding view extends it |
| `enrich_plan_*` planner, `pipeline.enrich_plan_runs` | Extend | AER step; wider scholarship step; typed outcome; request and country weights in `enrich_plan_priority_v1` |
| Standing gap queue (`field_gap_*`) | Extend | Accepts re-check triggers (accepted counsellor reports, changed snapshots, due refresh) |
| Three dispatchers and worker lanes | Retain | No new lane or cron |
| Readers, lean selector, `ai_route_qualifications`, `ai_invocations` | Retain | Models & services reads them |
| Strict verifiers, admission rules, Layer 4 | Retain | Layer 4 regrouped; routing class per item (P0-4) |
| s768 operations control (`queue_watch`, `job_effective_state_v1`, `admin_control_events`) | Extend | Designed, not built; the mockup's Automations view is its screen |
| `pipeline.on_demand_requests`, Run now, Fill fields | Retain | Scoped preview and reason added |
| Request register (Rules v1.3) and its sync | Retain | Scope tags feed the planner weight |
| Counsellor Report a data issue, My reports (s1025, s1044) | Extend | Accepted report triggers a scoped re-check; closes on verified result |
| Data gap register (s927), readiness read | Retain, then generate | Sharing rule unchanged: not shared |
| Reader-status CSVs, `PROVIDER-ENRICHMENT-QUEUE.csv`, wave lists | Retire | After planner state is the source |
| **Missing:** field applicability rule | Build | In the field register |
| **Missing:** typed outcome and next-due per field instance | Build | The core of the closed loop |
| **Missing:** refresh policy settings | Build | Settings, not new jobs |
| **Missing:** consumer read-back and freshness measures | Build | Shown apart from canonical coverage |
| **Missing:** country readiness read and audited activation | Build | For onboarding |
| **Missing:** supersession check | Build | See finding 5 |

**Dependencies between domains:** official course link → descriptions, academic entry, English, fees, intakes (all read the bound page); provider site → scholarship hub → awards → course scope; academic calendar → intake dates; country pack (qualifications, grading) → academic entry; campus → state filters; provider lifecycle → everything.

## 3. Stakeholder demand and feedback in the common architecture

No separate engine. Each item uses an existing mechanism.

| Requirement | Design |
|---|---|
| Configurable priority weighting | A weight (0 to 3) per open request, a setting changed by the Platform Admin with a reason. Read by the existing priority function. |
| Validated scope reaching the planner | A request's scope is field, country and optional provider, checked against the field register before it counts. Unscoped requests carry no weight. |
| Scoped revalidation after an accepted report | An accepted counsellor report marks that course and field as due in the standing gap queue. |
| Verified issue resolution | The report closes only when the next read is verified; the reporter sees Fixed with the value, or Not changed with the reason. |
| Four separate measures | API delivery (is the field served), canonical completeness, consumer coverage (read-back), freshness. Never combined. |
| Consistent reporting | Client status sheet, weekly email drafts and internal views all generated from canonical data, evidence, consumer verification and planner state. |
| Clarifications | An open question holds only its own request or the action that depends on it. |
| Human engagement | Logged under the existing register rules; a hand-off from the planner carries its reference into the row. |
| Boundaries | Rules v1.3 unchanged. Stakeholders see the client sheet's columns only. The gap register stays unshared. |

## 4. Navigation and component mapping

| Brief | Existing page and route | Change | Data it needs (existing unless marked new) |
|---|---|---|---|
| A. Global data delivery | Coverage & completeness, `#coverage` | New tab "Data delivery" | Coverage reads; **new:** per-state counts from planner state |
| B. Country onboarding | Layer 1 Register, `#layer-1-register` | New view | Source register, `ref` tables; **new:** readiness read, activate action |
| C. Catalogue and enrichment | Courses, `#courses`, course detail | New tab "Field status" | Course detail, Run now, Fill fields; **new:** next action and next due per field |
| D. Operations | Scheduled jobs › Automations, `#scheduled-jobs` | Extend (s768) | `queue_watch`, `job_effective_state_v1`, `admin_control_events`; **new:** planner rows, delivered counts |
| E. Refresh and maintenance | Coverage & completeness | New tab | **New:** refresh policy settings, last and next due |
| F. Models and AI | Models & services › AI, `#models-services?tab=ai` | Extend | `ai_invocations`, `ai_route_qualifications`, lean selector; **new:** quality and cost-per-admission reads, preview |
| G. Layer 4 | Layer 4 Review › Inbox, `#layer-4-review` | Regroup into four tabs | Inbox, bulk bar, decisions; **new:** routing class per item |
| H. Requests and feedback | Coverage & completeness | New tab | Request register, counsellor reports; **new:** scope and weight, re-check link |
| I. Role guides | Guides › Role guides | Extend | Generated from the UI map |

The umbrella names an existing "Data Delivery" view. I could not find its route in the generated UI map, so the mockup places the matrix on Coverage & completeness. S1-API-Frontend-Delivery should confirm the right home before build.

## 5. Compute and toolset sizing

**Measured today**

| Resource | Reading | Source |
|---|---|---|
| Catalogue | 36,052 active courses, 1,886 providers | Daily status, 25 Nov |
| Database | 7,370 MiB on 21 Nov, growing about 200 MiB a day; above the pilot alert level of 7,168 MiB | Capacity audit |
| File storage | Evidence 22,611 MiB; adapter captures 7,534 MiB | Capacity audit |
| Evidence records | 236,101 (about 96 KB a stored copy on average) | Telemetry read-back |
| Scheduled jobs | 138 active of a 140 ceiling | Daily status |
| Busy time | Minute :26 is the peak; `coverage-reconcile` 106 s at p50 there against 9 s alone | Capacity audit |
| AI cost | About US$0.00007 to US$0.00009 a call (small reads); about US$0.0002 a course description (4,412 re-reads for about US$1) | CURRENT-STATE |
| AI input size | Course entry: 3,411 tokens whole page, 1,704 selected; description: 3,408 average | CURRENT-STATE |
| Paid spend | US$0.00 logged for 24 and 25 Nov; cap US$5.00 a day | Daily status |
| Firecrawl | 5 credits a day scheduled; 2,000 a day on demand; 150 a week monitor; 66,863 credits left on 21 Nov | Telemetry, CURRENT-STATE |

**Not measured (needed before any capacity change):** Supabase plan, compute size, memory, connection limit and provisioned disk; Cloudflare Worker and Edge Function limits and time-outs; worker concurrency per lane; OpenRouter rate limits. None of these is in the records I read.

**Projection** (assumptions stated; 1x is today's catalogue)

| | 1x | 2x | 5x |
|---|---|---|---|
| Courses / providers | 36,000 / 1,900 | 72,000 / 3,800 | 180,000 / 9,400 |
| Steady state: page checks a day (each bound page weekly, plus sources) | about 4,500 | 9,000 | 22,500 |
| AI calls a day (10% changed; up to 5 field reads; 25% need a model) | about 560 | 1,120 | 2,800 |
| AI cost a month at US$0.0003 a call | about US$5 | US$10 | US$25 |
| First population: readable field gaps | about 62,000 | 124,000 | 310,000 |
| First population AI cost (one call each) | about US$19 | US$37 | US$93 |
| Days at the US$5.00 daily cap | 4 | 8 | 19 |
| Rendered fetches, first population (assume 10% of pages, 1 credit each) | 2,400 credits | 4,800 | 12,000 |
| New stored evidence a month, steady state | about 1.3 GB | 2.6 GB | 6.5 GB |
| Database growth | 6 GB a month during back-fill (measured); lower in steady state | | |

**Genuine constraints, in order**

1. **Planner run time.** Already hitting its limit at 1x. Fix in the queries; no upgrade is shown to be needed.
2. **Scheduled job ceiling.** 2 free slots. Fine if all new work goes through the dispatchers.
3. **Scheduled Firecrawl budget.** 5 credits a day against a first-population need in the thousands. This is a setting, and a Platform Admin decision.
4. **People in Layer 4.** Not a compute limit, but the real cap on admission speed.
5. **Database alert level against an unread disk size.** The alert is already "critical" on expected growth. Read the provisioned disk before deciding anything (option A in the capacity audit).

**Monthly cost:** AI about US$5 to US$25 across 1x to 5x in steady state. Database disk growth adds about US$0.75 a month for each month of back-fill at the documented US$0.125 a GB. Supabase plan, file storage and Firecrawl plan charges were not read, so no total is given. I see no evidence for an infrastructure upgrade.

## 6. Implementation sizing and ownership

Hours are active agent-hours for the first slice, taken from the umbrella's allowance. S1-Build stays the sole Integration Controller.

| Component | Retain / Extend / Build | Existing chat owner | Dependencies | Effort | Acceptance |
|---|---|---|---|---|---|
| Applicability rule and typed outcome | Build | S1-Build | Field register | 2–3 h | Every active course and field has one state; no-source is separate from not-attempted |
| Planner: AER step, wider scholarship step, weights | Extend | S1-Build, with S2-AER and the scholarship owner | Above | 4–6 h | A new course gets AER and scholarship work with no prompt; planner run stays under its time limit |
| AER lifecycle adapter (all entry kinds) | Extend | S2-AER | Planner step | 3–5 h | 1,563 s871 courses regain a reading or a typed outcome |
| Scholarship lifecycle adapter | Extend | Existing scholarship owner | Planner step | 3–5 h | Award read to published, with consumer read-back |
| Supersession check; refresh policy settings | Build | S1-RM-Design | Typed outcome | 2–4 h | No replacement without a verified successor after two cycles |
| Request scope and weight; report re-check; delivery status rule | Extend | StudySearch requirements register (rules, scope) and S1-Build (planner side) | Planner weights | 1–2 h | A scoped request raises rank; an accepted report re-queues its field; no request shows Delivered under threshold |
| Screens A, C, D, E, H | Extend | S1-API-Frontend-Delivery | Reads above | 4–6 h | Matches the mockup; every figure live or labelled; phone width works |
| Screens F (models) and G (Layer 4) | Extend | S1-API-Frontend-Delivery, with S1-Build for reads | Routing class; quality reads | 3–5 h | Qualify and activate are separate, audited actions; technical items leave Layer 4 |
| Screen B (country onboarding) | Build | S1-RM-Design and S1-API-Frontend-Delivery | Readiness read | 2–4 h | A fixture country reaches "active" with enrichment starting by itself |
| Role guides | Extend | S1-API-Frontend-Delivery | UI map | 1 h | CI guide-to-route parity passes |

**Critical path:** applicability and typed outcome → planner steps → AER and scholarship adapters → two unattended result-bearing cycles. About 9 to 14 hours.
**In parallel, independent of the critical path:** Layer 4 regrouping; Models & services; role guides; request scope tagging; refresh policy settings. Screens A, C, D and E need the typed outcome first.

**Takeover requirements for a replacement chat:** the branch and head; the single component it owns; test and CI state; open request IDs; the acceptance evidence so far; the next executable action. All recorded in the existing Admin records and the M3 rolling handover. Start from `docs/CURRENT-STATE.md` and the Master Plan, not chat history.

## 7. Role and permission matrix

Page access is the existing rank from the UI map. Proposed actions reuse existing ranks; no new authority.

| Action | Viewer | Counsellor | Curator | Pipeline Operator | PIM Admin | Platform Admin |
|---|---|---|---|---|---|---|
| Read catalogue, coverage, guides | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Report a data issue; My reports | – | ✓ | ✓ | ✓ | ✓ | ✓ |
| Layer 1, Layer 2/3, Layer 4, Evidence, health | – | – | ✓ | ✓ | ✓ | ✓ |
| Decide Layer 4 groups | – | – | ✓ | ✓ | ✓ | ✓ |
| Scheduled jobs and Settings | – | – | – | ✓ | ✓ | ✓ |
| Run now, Fill fields (scoped) | – | – | – | ✓ | ✓ | ✓ |
| Qualify a model (proposed) | – | – | – | ✓ | ✓ | ✓ |
| Pause, drain, resume (proposed, s768) | – | – | – | – | – | ✓ |
| Priority weights (proposed) | – | – | – | – | – | ✓ |
| Activate or roll back a model (proposed) | – | – | – | – | – | ✓ |
| Activate a country (proposed) | – | – | – | – | – | ✓ |
| Users & roles; Go-live checklist | – | – | – | – | – | ✓ |

The ranks for "Decide Layer 4" and "Run now" are taken from page access, not from the RPCs. Verify them against the actual permission checks before build.

## 8. Consolidated acceptance criteria

These add to the umbrella's ten scenarios and map to existing Feature Acceptance items; they do not replace them.

1. Every applicable field instance has exactly one typed state; the six states in the matrix add up to the applicable total (F-OPS.03A).
2. A new provider and course are enrolled and worked with no chat prompt, for AER and scholarships (F-AER, F-SCH).
3. Canonical, published and consumer-verified, fresh, and accounted-for are four separate figures on every view.
4. A finished job with no canonical gain shows zero delivered (F-OPS.02).
5. A replacement without a verified successor is flagged within two cycles.
6. A protected hold stops only its own action; the same provider's other fields continue.
7. Technical failures never appear under Layer 4 "Needs a decision" (F-OPS.05).
8. Qualifying a model switches nothing on; activation and roll-back each need a reason and write an audit line.
9. An accepted counsellor report re-queues its field and closes only on a verified result.
10. No request shows Delivered while its scope is under the agreed threshold.
11. Active scheduled jobs stay at or under 140; planner runs stay inside their time limit at 1x and in a 2x fixture (F-OPS.01).
12. Every screen value is live or labelled as a timestamped snapshot; pages work at phone width; guide-to-route parity passes.

## 9. Decisions for the Platform Admin

1. **Applicability:** approve one rule per field in the field register as the basis for both 100% targets.
2. **Scheduled Firecrawl budget:** keep 5 credits a day (collapsed pages wait), or size it to the measured first-population need.
3. **Thresholds for "Delivered"** per field, used by the request status rule.
4. **Request weights:** confirm they may change planner order automatically once you set them.
5. **Home of the matrix:** Coverage & completeness (as mocked up) or the existing Data Delivery view.
6. **Pause and resume rank:** s768 left this open (rank 6 proposed, against 5 for Automations today).
7. **Disk:** read Project Settings › Compute and Disk so the alert level can be set against the real size.

---

## History

| Version | Date | Change |
|---|---|---|
| 0.1 | 25 Nov 2026 17:15 AEDT | First issue, with the mockup (chat "StudySearch requirements register") |
