# Operations: queue and lane control, and on-demand runs — design (s768)

**Version:** 1.0, 19 Nov 2026
**Status:** design specification. Not built: no migration, no Pilot change and no UI change comes with this document.
**Authority:** Platform Admin, 19 Nov 2026 12:59 AEDT (chat S1-Build, s768).
**Grounding:** production read only, 19 Nov 2026 13:00–13:20 AEDT; Pilot main `0246da6e` (release v2.16.50 live).
**Guardrails:** G3 stays at 75 functions and 48 tables. No consumer API object is added or changed. The design adds no table: it reuses existing tables and adds actions to the existing `admin_*` entry points, with new logic in schema `security`. G1 and G2 apply unchanged (every job catalogued; every size, threshold and cap a setting).

Each part below is marked **Exists** (live today), **Extend** (an existing object gains an action, a column or a row), or **New** (to build).

## 1. What the platform runs today (consolidated model, PR 1 to PR 4)

The full baseline is in [`AGENT-OPERATING-MODEL.md`, Production architecture baseline](AGENT-OPERATING-MODEL.md#production-architecture-baseline-for-handover-19-nov-2026). In short:

- **Three dispatchers** take their work from lists, every minute:
  - `rollup-scheduler`: `pipeline.rollup_targets`, 29 targets including `ops-cost-guard` (s767);
  - `admission-rule-runner`, `-b`, `-c`: `pipeline.admission_rules`;
  - `coverage-lane-dispatch`, `-b`, `-c`: `pipeline.field_execution_registry`, 21 worker lanes.
- **Own jobs, not dispatchers:** Layer 1 (`layer1-run-driver`, `layer1-auto-ingest` and the other `layer1-*` jobs), Layer 4 (`layer4-drain` and the other `layer4-*` jobs), Boost (`boost-extract`, `boost-fields`, `boost-benchmark`), and `coverage-read` and `coverage-read-2`. The brief named `layer1-register` and `layer4-drain` as dispatchers; they are jobs on their own schedules, and this design treats them as such.
- **Retired jobs.** 78 legacy jobs are switched off and `retiring`. They are hidden on Scheduled jobs › Automations until "Show retired legacy jobs" is ticked, and they show "Checks before removal" instead of controls.
- **A folded job reads its dispatcher's state, not its cron row.** `security.job_effective_state_v1` (s767) gives each folded job its runner, whether it is on (target enabled and dispatcher active), and its runs and failures. Telemetry exporter revision 4 uses it, so a folded job no longer shows PAUSED because its old `cron.job` row is off.
  - A lane can still be genuinely held. flag-recheck holds a coverage lane idle after 30 runs with no work and tries it again every 15 minutes.
  - The UI must show that state as **Idle (held)**, with its next trial time. It is not the same as Paused by a person.

## 2. Operations › Scheduled jobs › Queue & lane control

**Placement.** The brief asked for a page called "Operations › Queue & Lane Control". This design places it as a tab on the existing Scheduled jobs page instead, because F-OPS.03 ("NO duplicate screen") and the SS-020 menu consolidation (Decision 269) rule out a new page:
- the tab is **Queue & lane control** (`?tab=control`);
- the Queues & yield tab on Platform health keeps its watchdog and links to it.

**Who sees it:**
- the three monitoring tiers: Curator (rank 3) and above, read only, as Queues & yield today;
- the containment controls: Platform Admin (rank 6) only;
- Viewer (rank 1) and Counsellor (rank 2): the tab is hidden.

Today, Automations controls open at PIM Admin (rank 5; `security.admin_automation_control_v1` checks rank below 5). The containment controls below raise that to rank 6, as the brief asks. The existing per-job Pause, Resume, Run now, Frequency and Batch size controls on Automations stay at rank 5.

### 2.1 Three tiers of live monitoring

| Tier | Rows | Columns | Source | State |
|---|---|---|---|---|
| 1. Work queues | One row per registered queue (section 2.2) | Queued; in flight (`leased_until` in the future); expired leases (`leased_until` in the past, not finished); stuck; admitted in 24 h; AI and Firecrawl spend today against the cap | `pipeline.queue_watch` (17 queues today, with `pending_sql`, `progress_sql`, `done_sql`, `failed_sql`, `exhausted_sql`, `cap_sql`), `pipeline.queue_watch_state`, the toolset spend views | **Exists** for 17 queues; **Extend** with the columns in section 2.2 |
| 2. Dispatcher lanes | One row per lane of `coverage-lane-dispatch`, target of `rollup-scheduler` and rule of `admission-rule-runner` | Status, last run, duration, error rate over 30 minutes, items in the last batch | `pipeline.field_execution_registry`, `pipeline.rollup_targets`, `pipeline.admission_rules` and their run tables; `security.job_effective_state_v1` | **New** read function over existing tables |
| 3. Scheduled jobs (`pg_cron`) | One row per `cron.job` | Schedule, active, last run, runs and failures in 24 hours; retired jobs read only | `public.admin_automations_read()` | **Exists** (Automations) |

- **Lane status values:**
  - **Active**: the lane is enabled, its dispatcher is on, and it ran in its due minute;
  - **Idle (held)**: flag-recheck holds it after empty runs, with the next trial time;
  - **Paused**: a person paused it, with who, why and until when;
  - **Degraded**: failures in the last 30 minutes at or above `lane.degraded_fail_percent`, or `open_until` is in the future (the lane's breaker is open);
  - **Shadow**: registered, not yet live.
- **Tier 1 uses the brief's queue names as labels over existing rows.** Mapping:

| Brief's queue | Existing `queue_watch` row, or what is missing |
|---|---|
| Discovery search | "Find course pages (search)", "Discover course pages (site maps)" |
| Page reader | "Read course pages", "Companion pages", "Course list pages" |
| Course AI | "AI course page matching", "Enrichment plans", "Fee reader (AI)" |
| Provider AI | **Missing:** add a row over `pipeline.provider_description_reads` |
| AER machine admit | **Missing:** add a row over `pipeline.aer_machine_admissions` and its Layer 4 input |
| Layer 4 drain | **Missing:** add a row over `pipeline.layer4_review_items` (pending, claimed, decided) |
| Autonomous planner "0/40 slots" | **Not found.** No planner-slot object or setting exists in the database (read 19 Nov 2026). Before it is shown, the Platform Admin or the planner's owner defines what a slot is (enrichment plan capacity, `enrich-plan-run` concurrency or another limit). Until then the tile reads "not defined". |

### 2.2 Queue controls (Platform Admin)

| Control | What it does | How | State |
|---|---|---|---|
| Pause queue (drain) | No new claims; items already leased finish | Holds every job or lane listed in the queue's `jobnames`, through `security.job_switch_v1` (a live lane is held in the registry; a retiring job is never switched on). A claim function runs only from those jobs, so no `SKIP LOCKED` claim starts while they are held. | **Extend:** new action `pause_queue` on `public.admin_queue_watch` |
| Resume queue | Switches back on exactly the jobs and lanes that Pause queue held | The audit row stores the previous state of each. Never a job a person or a governed restore had already switched off (`security.job_held_off_v1`). | **Extend:** `resume_queue` |
| Release expired leases | Clears `leased_until` on rows past it by more than `queue.release_grace_minutes`, so the next claim takes them | A new nullable column `release_sql` on `pipeline.queue_watch`, one per queue, which touches only the lease columns. It never touches an admitted row, a `pipeline.manual_locks` record (7,585 today) or a value under no-overwrite. Most claim functions already treat an expired lease as free, so this is mainly for the display and for queues that do not. | **Extend:** column and action `release_leases` |
| Reclaim stalled planner slots | Frees slots idle or budget-held for longer than `planner.slot_stall_minutes` | Waits on the slot definition (section 2.1) | **Blocked:** definition first |

### 2.3 Lane controls (Platform Admin)

| Control | What it does | How | State |
|---|---|---|---|
| Pause lane | Holds one lane; the dispatcher and every other lane keep running | `field_execution_registry.enabled = false` (or `rollup_targets.enabled`, `admission_rules.enabled`), and the lane's job name is added to the existing `jobs.held_off` setting. `security.job_held_off_v1` reads that setting, so flag-recheck and the idle guard never switch a person-held lane on. The reason and the optional auto-resume time (at most `lane.pause_max_hours`) sit in the audit row. A small check in an existing rollup target resumes the lane when that time passes. | **New** action on `admin_automation_control` (`pause_lane`) |
| Resume lane | Clears the person hold | Removes the job name from `jobs.held_off` and sets the lane back on; it runs from its next due minute | **New** (`resume_lane`) |
| Run 1 bounded batch | One run of the lane now, at its usual batch setting | Calls the lane's registered `call_sql` once through the dispatcher's own run function (`coverage_lane_run_v1`, `rollup_run_target_v1`), so the md5 check, the budget and the run record apply | **New** (`run_lane_once`) |
| Stop / disable lane | Takes the lane out until a person turns it on again | As Pause lane with no auto-resume; the person types the lane code to confirm | **New** (`disable_lane`) |

### 2.4 Job and incident controls (Platform Admin)

| Control | State |
|---|---|
| Pause / resume schedule (one `cron.job`) | **Exists** on Automations (rank 5); kept |
| Restart stuck lock (a dispatcher's advisory lock held past its tick) | **New.** It ends only the stuck backend that holds the named lock (for example `cf247:rollup_tick`), after showing its query and start time. It never ends any other session. |
| Emergency stop | **Exists** as Pipeline maintenance › "Pause & Drain for Migration" (`public.admin_pipeline_maintenance`, pause, resume, status), which pauses every job and resumes only those it paused. This design renames the button for incidents and adds the audit fields below. |
| "Pause affected lane" on Platform health critical alert cards | **New.** The card names the lane, and the button opens Pause lane with the reason filled in. |

**Audit for every control.** One row in `pipeline.admin_control_events`:
- columns `area`, `action`, `target` and `actor` (the user ID);
- `detail` holds `reason` (required, at least 10 characters), `previous_state`, `auto_resume_at` and `request_id`;
- `created_at` is set by the table.

Typed confirmation is required for Stop / disable lane, Restart stuck lock and Emergency stop.

## 3. On-demand runs: one framework, no duplicate workers

### 3.1 Model

- **One run, one record.** The run ID is the `uuid` of `pipeline.on_demand_requests` (**Exists**: `security.on_demand_open_v1`, `on_demand_scope_v1`, `on_demand_report_v1`, `on_demand_close_v1`). It holds:
  - who and why: `requested_by`, `reason`;
  - where it came from: `requested_via`, set to `admin_ui:<entry point>`;
  - its scope: `provider_ids`, `purpose_groups`;
  - the caps, in `estimate`: `max_items`, `max_ai_usd`, `max_firecrawl_credits`;
  - the outcome: `before`, `actual` and `state`.
- **Manual runs use the existing queues and dispatchers.**
  - A manual run puts its scoped items into the same queue table the scheduled work uses, with the queue's existing priority where it has one. Where it has none, it runs the job's or lane's registered call once with the run's scope as arguments (`admin_job_run_now_v1` and run-now cohorts, **Exists**).
  - No second worker, prompt or admission path is added.
  - The brief's `priority = 100` and `trigger_type = 'MANUAL'` are recorded on the run (`requested_via`) and in each queue's own priority where it has one. Most queue tables have no per-item priority column. Adding one to each table is out of scope; it is listed as a follow-up for the queues that need it.
- **Caps and protection.**
  - On demand is not held by toolset limits; only the account's own limits stop it (Pilot `CLAUDE.md`).
  - The run's own caps hold, and it stops at the first one reached.
  - Defaults: fill empty fields only; never overwrite an admitted value (no-overwrite); never write a field or record in `pipeline.manual_locks`.
  - Refreshing a filled field is a separate mode, with a reason, and still goes through Layer 4 where the field's rule requires review.

### 3.2 Entry points

| Where | Action | Scope | Server action | State |
|---|---|---|---|---|
| Provider detail drawer | Refresh provider description; Re-verify provider pages | 1 provider, or a cohort of up to `on_demand.provider_cohort_max` (default 50); stored page first | `admin_provider_description_fill_v1`, `admin_provider_description_run_v1`, `admin_university_reread` | **Exists** (description); **Extend** (page re-verify) |
| Course detail drawer and cohort toolbar | Refresh course fields: description, study load, intakes, AER, links | 1 course, or a cohort of up to `on_demand.course_cohort_max` (default 100) | `admin_course_read_now`, `admin_aer_read_now`, `admin_intake_run_now_v1`; course description through the queue of `course-description-machine` | **Exists** per field; **Extend** with one combined action |
| Layer 1 Register | Run Layer 1 source now (artifact to Storage, evidence record, checksum deduplication) | 1 registered source | `admin_layer1_policy_run_v1`, `scheduler_policy_run_now_v1` | **Exists** |
| Layer 4 Inbox | Run Layer 4 machine-admit pass | One bounded pass of up to `on_demand.layer4_pass_max` items (default 250) | One run of `layer4-drain`'s call with the bound | **New** |
| Coverage & completeness | Recompute coverage snapshot; status buckets (Queued, Blocked, Not read, No page) open the filtered queue view | Whole platform; single-flight lock | `rollup_run_target_v1` on targets `course-coverage-build` and `course-coverage-snapshot` | **New** button; **Exists** target. Measured 19 Nov 2026: build median 11 s, longest 112 s; snapshot median 2 s. The brief's "under 8 s" is a target, not today's figure. |

### 3.3 Pre-flight card

Shown before anything starts; the run starts only from the card. It shows:
- the item count after the no-overwrite and manual-lock exclusions;
- how many items have a stored page, so they need no paid read;
- the estimated AI US$ and Firecrawl credits, against the remaining daily cap and the account's floor;
- the mode: "Fill empty only" by default, or "Refresh filled", which needs a reason.

### 3.4 Operations › Scheduled jobs › On-demand runs

This is a tab on Scheduled jobs, for the same reason as section 2. It replaces nothing on Task manager.

- **Run list:** one row per open or recent run (`on_demand_requests`): who, why, entry point, scope, caps and state.
- **Four stages per run,** each with counts:
  1. **Queued**;
  2. **Fetching / reading**: stored page used, or paid read;
  3. **Extracting / validating**;
  4. **Admitted / completed**: admitted, sent to Layer 4, held or skipped with the reason.
  - Each run also shows actual spend and duration.
- **Cancel remaining:** removes the run's unclaimed items from their queues and closes the run. Leased items finish.
- **Retry held items:** a new run for the held items only, linked to the first.
- **Where the counts come from:** each queue's own state, filtered by the run's scope and time window, so no new tracking table is needed. Where a queue cannot tell a manual item from a scheduled one, the stage shows the scope's counts and says so.

## 4. Settings this design adds (G2)

Each is a row in `pipeline.platform_toolset_settings`, with a label, range, unit and `used_by`:

| Setting | Default |
|---|---|
| `lane.degraded_fail_percent` | 20 |
| `lane.pause_max_hours` | 24 |
| `queue.release_grace_minutes` | 15 |
| `planner.slot_stall_minutes` | 120 (after the slot is defined) |
| `on_demand.provider_cohort_max` | 50 |
| `on_demand.course_cohort_max` | 100 |
| `on_demand.layer4_pass_max` | 250 |

## 5. Acceptance

The acceptance items are F-OPS.10 to F-OPS.12 in [`STUDYSEARCH-FEATURE-ACCEPTANCE.md`](STUDYSEARCH-FEATURE-ACCEPTANCE.md). Each build slice:
- gets its own Pilot spec, numbered when it is built;
- runs a rolled-back live dry run;
- passes a signed-in UI check at rank 6 (the controls are shown and work) and at ranks 1 and 2 (the tab is hidden).

## 6. Open points for the Platform Admin

1. **Planner slots.** What is a "slot" in "Autonomous Planner 0/40 slots"? Nothing in the database defines it today.
2. **Rank for lane and queue controls.** Platform Admin only (rank 6), as asked, while existing Automations controls stay at PIM Admin (rank 5)? Or move Automations to rank 6 as well?
3. **Per-item priority.** Should per-item priority columns be added to the queue tables that need them, so a manual item is visibly ahead of scheduled ones? This is a schema change on internal tables (not G3).
