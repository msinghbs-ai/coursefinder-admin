# SS-021 work continuity: blocking-point audit and baseline (3 Nov 2026)

Mandate: `2026-11-03-p0-work-continuity-mandate-2119.md` §1 (blocking points) and §9 (baseline metrics). Integration Controller: this session. Audit agent: SS-021 part 1.

Method: read-only SQL on `fxcwkweaxjtknorudmwp` between 21:21 and 22:00 AEDT. Live definitions from `pg_get_functiondef`; live data from the queues, `cron.job_run_details` (24 hours) and `pipeline.queue_watch_state`. Heavy reads were kept to the :x6–:x8 windows. The only production writes were the governed registrations below. No record was re-queued or changed.

Scope: 167 scheduled jobs (155 active), all 168 rows of `pipeline.automation_catalogue` (no uncatalogued job) and the 15 task kinds in `pipeline.admin_job_kinds`, across the eight lanes in mandate §1.

## 1. Summary

Two jobs are blocked for every provider right now, and both are whole-run failures:
- **course-relink** has failed 20 of its last 21 runs since 17:30. One provider's statement time-out rolls back the whole tick, and the same provider is picked first each time.
- **provider-identity-check** has failed 4 of 4 runs since it was released. Its own issue write breaks two check constraints, so no identity result lands for any provider.

Four more patterns stop unrelated work today, or will within hours:
- AER scheduled reading is 27 items below its 600 limit. That limit is one count for the whole platform, and about 40 of the items it counts are duplicates or technically blocked reads.
- 2,614 field items and 202 scholarship reads have failed for good after transient or budget faults, with no retry time.
- 11 Find course pages tasks have been held for up to 18.5 hours behind the paid search daily cap. They are reported as "waiting their turn", and they keep 19 enrichment plans open.
- Parked work has no re-check: 616 onboarding stops, 211 companion pages and 1,336 course-page reads have been given up.

Working as intended, and the reference patterns:
- `coverage_admission_apply_v1` holds each refused item and carries on (the IQ-00067 fix). coverage-admit has had no failures since 05:33 UTC.
- Publication refreshes are healthy: 286 processed in 24 hours, 1 pending.
- `admin_jobs_tick_v1` allows `jobs.per_lane_per_tick` = 1000, so there is no head-of-line block in the task runner. The longest wait in the single `enrich` lane over 7 days was 5 minutes.
- Paid lanes are paused only by their own budget guard (`worker_lane_call_v1`). All 47 worker modes are callable now.

## 2. Findings

| # | Finding | Lane | Pattern | Live evidence (function and line) | Issue | Root cause | Proposed shared fix |
|---|---|---|---|---|---|---|---|
| F1 | course-relink fails every run. One provider's slug/URL-normalisation query hits the statement time-out, and the whole tick rolls back, including the settle steps for every other provider. | Course links and page acquisition | Whole-batch abort; head-of-line | cron: 23 of 144 runs failed in 24 h; 20 of 21 since 17:30 AEDT (17:00 hour 3/6, then 6/6 each hour). Error: `canceling statement due to statement timeout` in `course_relink_slugs_v1` / `course_relink_url_norm_v1`. `course_relink_tick_v1` orders providers `count(*) desc` with no deferral and no exception block. `course_relink`: 579 `trying` (oldest 18 Oct), last change 06:24 UTC (4 h with no movement). | IQ-00074 (reused) | `wc_batch_abort_one_item`, `wc_head_of_line_fixed_order` | Per-provider savepoint with a per-provider time budget. A provider that fails or times out gets a next-eligible time and goes to the back. The settle steps commit separately. |
| F2 | provider-identity-check fails every run. Its integration-issue write uses `root_cause_class = 'data'` and `workstream = 'G'`, and neither value is allowed by the table's check constraints. The whole check rolls back, so no identity finding or lifecycle step lands for any provider. | Provider discovery, identity and lifecycle | A failed report write aborts the run | cron: 4 of 4 runs failed (last 10:16 UTC). `provider_identity_check_v1` line 109 passes `'root_cause_class', 'data', 'workstream', 'G'`. The allowed lists are `integration_issues_root_cause_class_check` (unclassified, code_defect, data_drift, …) and `integration_issues_workstream_check` (A1–A10). Each failed run also uses up an issue number (IQ-00113 to IQ-00126 were never stored). | IQ-00077 (reused) | `wc_report_write_aborts_run` | Write issues and alerts in their own savepoint after the work commits. Make `integration_issue_upsert_v1` map unknown classes and workstreams to `unclassified`/`A10` and record the original, instead of raising. |
| F3 | Find course pages tasks stay `running` for up to 24 h while the paid search lane is at its daily cap. They report `waiting_turn` instead of the cap, and keep their enrichment plans open. One task is for a skip-listed provider and can never progress, yet it is held to its 24-hour end. | Course links and page acquisition → Layer 2/3 plans | A paid cap holds dependants; held with no progress | 11 running `course_page_find` tasks, oldest started 02:51 UTC, last event 02:53 UTC. queue-watch `course_page_search`: "capped: 1382 of 200 courses picked today, resumes 04 Nov 11:00". Task `9433d1c4` (provider `1b8f2f2f`, 231 courses) is held `skipped_provider`. 19 auto plans running (`plans.auto_open_max` 40). `svc_course_link_search_next` line 19 counts rows sent today, all providers together. | IQ-00130 (new; depends on IQ-00064) | `wc_dependent_held_by_paid_cap` | Park the step with the cap reset as its next-eligible time and a true hold code. Release the plan to run its free steps. End impossible steps (skip list) `not_needed` straight away. |
| F4 | The AER scheduled-reading back-pressure is one count for the whole platform. Pending entry items plus in-progress reads at or above 600 stop new course reads *and* due matrix refreshes for every provider. Duplicates and technically blocked reads count towards it. | AER and qualification matrices | Global back-pressure | `aer_schedule_tick_v1` lines 29–31 (count), 63 (new reads), 86 (matrix refresh). Live: `course_entry_first_read` 532 + `entry_matrix_first_run` 41 = 573 of 600 (last run 565; no back-pressure yet). The 41 matrix items cover 19 entities (22 duplicates). 18 items are `technical_blocked` (repair:completeness_gate). | IQ-00128 (new; depends on IQ-00038) | `wc_global_backpressure_all_providers` | Count only distinct `judgement_ready` items. Give each provider a share, and keep room for new providers. Never gate technical refreshes or other lanes. Send technically blocked items back to bounded technical recovery (mandate §5). |
| F5 | Transient and budget failures become permanent. Items reach the attempt cap and are marked `failed`, with no failure class, no next-eligible time and no way back. | Layer 2/3 enrichment; intakes and deadlines; scholarships | Exhausted retry, no recovery | `field_enrich_items` failed 2,614 (all at attempts 3). 2,538 say "no answer could be recorded after 3 tries": intakes 738 (139 providers), English 586, duration 268, delivery 233, international 218, campus 191, description 180, deadline 85. 2,513 of them were updated in 24 h, in sweeps at 2 Nov 18:44 and 3 Nov 03:31 UTC during the IQ-00053 time-outs. `scholarship_ai_queue`: 202 failed "no scraper credit after 3 tries". | IQ-00129 (new; depends on IQ-00053) | `wc_transient_exhausted_terminal` | Record a failure class on every item. Transient faults retry with bounded backoff and a next-eligible time. Budget faults park until the budget renews. Only a rule or evidence result is final (mandate §3). |
| F6 | Parked work is never re-checked. Onboarding stops with reasons that no rule revisits. Given-up companion pages, course-page reads and central pages have no next-eligible time. | Provider lifecycle; course pages | Parked with no recovery deadline | `provider_onboarding` stopped 1,592: too_few_pages 609 (since 12 Oct), no_courses 535, nothing_ready 330, no_website 108, approve_central 5, error 3, adapter_off 1, capture_failed 1. `provider_onboarding_tick_v1` lines 18–57 re-queue only ai_allowance, no_courses, no_website/needs_source_discovery and admitted nothing_ready/approve_central. Onboarding `27613c5b` has sat in scholarship_admit since 22 Oct ("1 page waiting for the AI"; the scholarship AI queue has nothing due). queue-watch: companion_read 211 exhausted (idle since 2 Nov); course_page_read 1,336 exhausted and failing 36 of 46 in the hour; central_ai 4; fee_reader 5. | IQ-00131 (new; depends on IQ-00071). Also IQ-00056 (companion) and IQ-00046 / IQ-00051 (course-page reads), reused | `wc_parked_no_recheck` | Every parked item gets a re-check time and the condition that brings it back (new pages, new evidence, website change). Otherwise it gets a named authority blocker. Use one sweep for all lanes, not one per lane. |
| F7 | The scholarship AI admission queue takes directory-site pages that the worker then refuses. The rows end `failed` and use up worker calls. | Scholarships | Queued without the worker's gate | `scholarship_ai_queue` failed 22,335 of 56,194. 22,133 have skip_reason "directory site" (77 providers; 7,962 in the last 7 days; last 2 Nov 15:13 UTC). | IQ-00132 (new) | `wc_enqueue_without_gate` | Apply the worker's eligibility rule at enqueue. Record a refusal as `not_needed`, not `failed`. |
| F8 | Eight scheduled batch writers have no per-item isolation. One row's error rolls back the whole run. This is latent, except for F1. | Fees; intakes; provider rules; adapters; Layer 4 auto-admit; scholarships publish | Whole-batch abort | No exception handler in the per-row loops of `intake_dates_apply_v1`, `fee_period_settle_v1`, `provider_rule_admit_v1`, `provider_basis_rule_admit_v1`, `adapter_overwrite_gated_v1`, `no_page_auto_admit_v1`, `scholarship_auto_publish_v1` and `course_relink_tick_v1`. Reference fix: `coverage_admission_apply_v1` lines 75–77 and 131–135. coverage-admit failed 17 of 144 runs on a manual-lock refusal before the fix, and none since 05:33 UTC. | IQ-00133 (new; depends on IQ-00074) | `wc_batch_abort_one_item` | One shared per-item wrapper (savepoint, hold row with reason, error limit per run), used by every batch writer. |
| F9 | Some lanes can be stopped as a whole. The fee reader calls its worker only when no lease is live anywhere. The course link search tick resends after 20 minutes with no attempt cap, and one bad response body or bind refusal rolls back the harvest, advance and send for all providers. Both are latent today. | Fees; course links | Single-flight lane; unbounded retry | `fee_reader_tick_v1` lines 54–55. The queue is empty (done 6,237, failed 5) and `fees.course_pages` = 0 under the IQ-00111 containment. `course_link_search_tick_v1`: the resend `update … attempts = attempts + 1` has no cap; the `r.content::jsonb` cast and `course_link_bind_v1` are not isolated; `send_via` = worker. | IQ-00134 (new) | `wc_single_flight_lane` | Per-item leases with expiry. The worker is called while any item is due and capacity is free. Retry caps and isolation as in F5 and F8. |
| F10 | Layer 4 readiness has classified fewer than half of the waiting items. Without that, genuine human decisions cannot be told apart from technically incomplete reads. Inflow far exceeds outflow. | Layer 4 admission | Review queue as a bottleneck (input to F4) | 4,432 pending, 1,999 classified: official_course_url 1,372 of 3,233; course_description_first_read 0 of 421; tuition validation 29 of 135. 228 official_course_url items are `resolvable: covered_by_active` while `layer4.reconcile_supersede_on` = 0. Last 24 h: 1,648 created, 88 left the queue (87 superseded, 1 rejected). | IQ-00128 (F4), IQ-00061 / IQ-00039 (reused) | `wc_global_backpressure_all_providers` | Classify every waiting item. Settle `resolvable` ones only through the authorised, audited transition, once the Platform Admin switches it on. Count and schedule by readiness. |

Also seen (not a new finding):
- search-refresh-requested timed out twice in 24 h (IQ-00032 / IQ-00044). The single writer lock holds every request, but the backlog is only 1.
- 22 adapter drafts have been stuck in `capturing` since 5 Oct (IQ-00036). They do not hold onboarding slots, because no onboarding is in a working stage.
- source_find has 1,136 pending at 3 an hour (ETA 379 h). That is a throughput limit, not a block.

## 3. Root causes registered (`pipeline.ops_root_causes`, prefix `wc_`)

| Code | Class | Findings |
|---|---|---|
| `wc_batch_abort_one_item` | rule | F1, F8 |
| `wc_head_of_line_fixed_order` | rule | F1 |
| `wc_report_write_aborts_run` | rule | F2 |
| `wc_global_backpressure_all_providers` | capacity | F4, F10 |
| `wc_transient_exhausted_terminal` | transient | F5 |
| `wc_parked_no_recheck` | dependency | F6 |
| `wc_dependent_held_by_paid_cap` | capacity | F3 |
| `wc_enqueue_without_gate` | rule | F7 |
| `wc_single_flight_lane` | capacity | F9 |

No remedies were registered; the contract agent (branch `cf247-continuity`) owns those.

## 4. Issues

- New, fingerprint prefix `wc:`: IQ-00128 (`wc:aer_backpressure_global`), IQ-00129 (`wc:transient_failures_terminal`), IQ-00130 (`wc:page_find_tasks_held_by_daily_cap`), IQ-00131 (`wc:onboarding_parked_no_recheck`), IQ-00132 (`wc:scholarship_ai_enqueue_refused`), IQ-00133 (`wc:batch_writers_no_item_isolation`), IQ-00134 (`wc:single_flight_lanes`).
- Reused, unchanged (recorded here, not rewritten): IQ-00074, IQ-00077, IQ-00064, IQ-00038, IQ-00053, IQ-00071, IQ-00056, IQ-00046, IQ-00051, IQ-00061, IQ-00039, IQ-00032.
- IQ-00127 was never stored. My first insert was refused by the workstream check, and the number was used up.

## 5. Baseline metrics (§9), 3 Nov 2026 about 21:30 AEDT

BASELINE_TABLE

## 6. Shared fixes ranked by the unrelated work they unblock

TOP_FIXES
