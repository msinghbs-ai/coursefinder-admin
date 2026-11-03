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

## Cycle 3 check: 13:52 AEDT (scheduled check)

**Cycle 2 (12:41, 17 plans): no data moved.**
- Every plan had a single step, `scholarship_provider_scan`, and every task ended done with total 0 ("0 of 0 done … the rest wait their turn in the reader").
- The cycle reported 17 done plans while moving nothing. This is logged as **IQ-00066 (P1)**: plans propose steps with no eligible work and count them as done.

**Cycle 3 (13:41): 5 automatic plans, 8 steps running.**
- 4 page-find steps: 231, 121, 63 and 128 courses without a course page.
- Field-fill steps with 389, 462, 613 and 715 items.
- Reasons recorded: missing values grew (for example 2,081 → 2,543), plus new verified evidence.

**Data movement, last 2 hours (field items and course-link search):**
- Field items: 55 filled, 32 to Layer 4 review, 520 skipped, 1,326 queued, 240 leased.
- Course-link search: 195 found, 3 verified, 221 none, 26 queued.

**Intake job:** runs at 13:26, 13:35 and 13:45 all succeeded.

**Integration queue:**
- **IQ-00060 closed.** The coverage-discover jobs stay inactive after the flag rechecks.
- **IQ-00053 not closed.** No lock waits, but 6 time-outs in `svc_enrich_ai_record` at 13:48:31, inside the :47–:48 busy window, against 32 successful calls in the hour.

**Release A:** v2.15.424 is live and verified.

**Two-cycle criterion: not met.**
- Cycle 1 moved data. Cycle 2 did not. Cycle 3 is in progress.
- The criterion now needs two consecutive cycles that each move data: 13:41 and 14:41 at the earliest, assuming IQ-00066 does not repeat.
- The 24-hour unattended test starts only after that and after IQ-00064 closes.

## Release B first gap run: 14:31 AEDT check

**Gap queue at 14:23 (the first run after v2.15.425): done.**
- One complete pass over 35,690 courses in 78 seconds, with no time-out. It queued 1,018 items.
- `field_gap_queue_runs` has its first row.
- `course_page_proofs` has 4,038 rows, 297 of them proven.
- **IQ-00031 closed.**

**Description and deadline items, all sources: data is now moving.**

| Field | Filled | To Layer 4 | Skipped | Failed | Leased |
|---|---:|---:|---:|---:|---:|
| Deadline | 70 | – | 776 | 65 | 204 |
| Description | – | 253 | 826 | 160 | 213 |

Course descriptions go to Layer 4 under D5.

**Regression: IQ-00053 time-outs got worse.**
- `svc_enrich_ai_record` hit 54 statement time-outs in 45 minutes. The cause is the description duplicate check run for every item, with up to 30 items per statement. The root cause is diagnosed and the fix is in v2.15.426.
- **Interim setting:** `enrich.ai_items_per_call` 30 → 10 (event #28746). It goes back to 30 once v2.15.426 is verified live.

## v2.15.426 verification: 15:06 AEDT check

**IQ-00053 (description recording time-outs): fixed, not yet closed.**
- Since v2.15.426 went live at 14:37: 0 `svc_enrich_ai_record` time-outs and 117 successful enrich_ai calls.
- `enrich.ai_items_per_call` restored 10 → 30 (event #28752).
- The issue closes after a full clean hour.

**Cycle 3 (13:41): data moved.**
- Fields filled include campus 2, English 1, deadline 11 and delivery 2.
- Course-page searches are progressing (125, 87 and 23 done, waiting their turn).
- Before the fix, deadline reads failed 61 times on time-outs.
- One step was for a university on the search skip list. It was proposed before the v2.15.426 rule.

**Cycle 4 (14:41, under the new rule): data moved.**
- No step was proposed without work: no scholarship scans with nothing to do and no skip-list searches.
- Deadlines filled: 1, 34, 106 and 38, so 179 in total.
- Four course-page searches are running.

**Source-proof job, 14:44: first routed run.**

| Route | Courses |
|---|---:|
| Sent to the free re-link lane | 50 |
| Already being read | 108 |
| Waiting on Layer 4 | 362 |
| Locked by hand | 258 |
| No route (D1 paid search is off) | 1,222 |

- Run time: 9.5 seconds.
- The 1,222 with no route are the courses that would need paid course-page search. They are the D1 measure.

**IQ-00063 closed.** The onboarding row stopped at 14:36 with reason needs_source_discovery, and it has not been re-stepped since. The website correction is still waiting as a paste file.

**Two-cycle criterion: met, for data movement.**
- Cycles 3 and 4 each moved independent, verified data, with no manual dispatch.
- Self-sustainability is still not PASS. That needs IQ-00064 closed (the 4 failed searches recovered by scheduled re-plan from about 18:38), IQ-00053 and IQ-00066 closed, and then the 24-hour unattended acceptance test.
