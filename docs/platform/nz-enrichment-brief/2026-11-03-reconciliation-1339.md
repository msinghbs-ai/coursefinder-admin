# Reconciliation of the 13:39 findings: 3 Nov 2026, 13:50 AEDT

Platform Admin request, 13:39: reconcile against the integration queue. Covers IQ-00064 terminal outcomes, descriptions stuck at 163 and 0, and empty gap-queue and page-proof tables. All checks were read-only SQL on `fxcwkweaxjtknorudmwp`. The only writes were integration-queue transitions.

## IQ-00064: the 21 completed automatic plans
- Plans today: 21 done, 1 running. Done plans with work left: 0. `security.plan_unfinished_done_v1()` returns 0.
- Steps:
  - enrich_fields: 5 done.
  - scholarship_provider_scan: 17 done.
  - course_page_find: 1 done, and 4 failed with a reason (62/173, 28/100, 40/92, 40/79). These are the steps the idle guard cut short. Release A reconciled them (event `iq64_plan_step_reconcile`, 18 steps).
  - One step was stopped with no task.
- Recovery goes through the scheduler (`plans.replan_on_retry`, 5 per hour), not by hand. The first of these is eligible at about 18:38.
- Status: **deployed** (v2.15.424, bc22f575). It closes only after those re-plans complete on real cycles.

## Gap queue: `field_gap_queue_runs` and `course_page_proofs` at 0
- Both tables arrived with v2.15.423 (about 12:30). Job `field-gap-queue` (`23 */6`) last ran at 11:23, before that deploy. Its next run is at 17:23.
- The writers are right: `field_gap_queue_run_v1` writes one run row each run, and `field_gap_scan_v1` records unproven pages in `course_page_proofs`.
- `source-proof-feed` ran at 13:44 and succeeded with no input. It reads only `course_page_proofs`, so nothing reaches it before 17:23.
- Instrumentation gap: the feed keeps no run record of its own. Added to Release B: a run log beside it, plus a gap cadence that does not starve the feed.

## Course descriptions at 163
- No `description` item has been created in the last 24 hours. Description and deadline items come only from the standing gap queue (`enrich_course_text_gaps_v1`), and that has not run since v2.15.422.
- A live read now shows 500 description and 500 deadline items due, and no standing task is open, so the 17:23 run will queue them.
- Under D5, every course description goes to Layer 4 review. The count of 163 rises only as reviewers approve.

## Provider descriptions at 0
- The pilot scope is 5 providers (`pdesc.provider_keys`). All 5 have been read: 4 proposed (pending in Layer 4) and 1 held (ACU, quote not on page). AI spend so far is US$0.0066 of the US$1 ceiling.
- No reader call has run since 11:06 because there is nothing left in scope. That is correct behaviour, not a stall.
- To move: Layer 4 decisions on the 4 proposals, and a Platform Admin decision on widening the pilot scope.

## Integration queue changes (deduplicated)
| Issue | Change | Reason |
|---|---|---|
| IQ-00064 | triaged → deployed | Release A live and verified |
| IQ-00062 | closed (duplicate of IQ-00055) | 09:56 time-out happened before v2.15.418; 11:06 call returned 200 |
| IQ-00031 | detected → deployed | Single-statement scan time-out replaced by the resumable scan; closes after the 17:23 run |
| IQ-00063 | detected → triaged | Separate root cause: onboarding row d5dfc2ea stores an email address as its website (`https://info@newgen.edu.au`) and has looped in course_pages since 12 Oct |
