# P0 autonomy: orchestration cycles observed (3 Nov 2026)

**Rule:** the Platform Admin, 3 Nov 11:23, said not to mark self-sustainability a PASS before:

- verified, independent data movement through at least two consecutive eligible orchestration cycles; then
- the unattended acceptance test, including a 24-hour soak.

**Claude-initiated enrichment actions in these cycles: 0.**

The integrator only:

- released v2.15.421 at about 11:40;
- set settings with recorded reasons: `plans.replan_per_hour` 5 at 10:59 (#28704), and at 11:42 `plans.replan_on_evidence`, `plans.replan_on_retry` and `plans.fair_order` (#28708–#28710).

## Cycle 1: `enrich-plan-auto` 11:41

- **Planner run:** succeeded (11:41:00–11:41:39). This run used the v2.15.419 logic, because v2.15.421 deployed during it.
- **Plans created:** 5, the hourly cap. Each records why it was created:

  | Provider | Missing values grew |
  |---|---|
  | 00e5f26c | 1,242 → 1,485 |
  | 229dc07d | 1,322 → 1,346 |
  | 87576ec2 | 893 → 932 |
  | e2dd4b2b | 1,065 → 1,125 |
  | ea5a3fa6 | 728 → 931 |

  87576ec2 is Ara Institute of Canterbury.
- **Steps started by the platform's own `enrich-plan-run` ticks** (within 20 minutes): 5 `course_page_find` tasks and 5 `enrich_fields` tasks, all running.
- **Standing gap queue task (11:23), final:** 279 items. 2 filled, 277 skipped. The skips are "no proven course page" (E16), now 99% of the batch: the 29 items that went to AI also ended skipped or unfilled. The fix is in the lanes branch: select only gaps with a proven page, and count the rest as "waiting for page proof".
- **Scholarship pilot:** 8 providers, 38 admitted (Layer 4 before publication), Firecrawl 17 of 700 a day, no stop condition.
- **Provider descriptions:** the 11:06 unattended run proposed Monash and CDU to Layer 4 and held ACU (IQ-00055 closed).

**Cycle 1 verdict:** the platform independently detected eligible work, created plans and started their steps. Real data movement from these plans is not yet measured; it is checked with cycle 2.

## Cycle 2: `enrich-plan-auto` 12:41 (first on v2.15.421 logic)

To be recorded: plans created and their triggers, the steps finished from cycle 1 with filled and admitted deltas, and the next batch transition.

### Cycle 1 outcomes (read 12:48)

**All 5 plans finished `done`**, and so did their 10 steps. Nothing was started or pushed by Claude.

**Data moved (cycle 1 plans):**

| Measure | Result |
|---|---|
| Field items filled | 18 |
| Sent to Layer 4 review | 6 |
| Skipped | 339 (mostly "no proven course page") |
| Course pages found by the plans' page-find steps | 117 of 561 searched |
| Firecrawl credits used | 372, within the existing course-search share |

**Defect found:**

- 4 of the 5 page-find steps ended `done` after only part of their scope.
- The note says the course-page search lane was "paused by the idle guard until 12:45".
- Logged as a P1 integration issue (fingerprint `enrich_plan:page_find_step_done_while_lane_idle_paused`).
- A step must wait or be held while its lane is idle-paused, not be marked done.

**Other lanes in the same window:**

- **Intakes:** 216 filled, up from 211 at 11:00, by the hourly `intake-dates-apply` on its own.
- **Scholarship pilot:** unchanged. 38 admitted (Layer 4), 17 Firecrawl credits, no stop condition.

## Cycle 2: `enrich-plan-auto` 12:41 (v2.15.421 logic, fair order on)

- **Run:** succeeded, 80 s.
- **Plans created:** 17, up to the per-run cap of 20. All are "most missing first", in fair order, so these are the universities due or never planned, ahead of early re-plans. All 17 were running at 12:48.
- **Data movement from cycle 2:** read at the next check (13:47), together with cycle 3.

## Verdict so far (12:48)

- **What two consecutive cycles show:** the platform independently detects work, creates plans and runs their steps. Cycle 1 produced real data (18 fields, 117 pages, Layer 4 routing) and handed over to cycle 2 without intervention.
- **Not yet a PASS:**
  - Cycle 2's own data movement is still to be verified.
  - The page-find step defect above needs correcting.
  - The 24-hour unattended soak has not started.
