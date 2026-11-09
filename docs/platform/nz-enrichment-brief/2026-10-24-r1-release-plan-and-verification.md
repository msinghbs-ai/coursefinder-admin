# CF-247 R1 — release plan and verification

**Date:** 24 October 2026  
**Authority:** Platform Admin mandate, 24 October 2026 09:55 AEDT; [AU builds and enrichment jobs — MANDATE RECORD](2026-10-24-au-builds-and-enrichment-jobs.md).  
**Technical plan:** [Platform throughput gap and schema plan](2026-10-23-platform-throughput-gap-schema.md), items 1–3 and the apply-time identity extension.  
**Status:** R1 landed as v2.15.339 / package 0.1.266. This file records the full plan and reconciles the concurrent implementation; it is not a claim that this plan was written before PR #681 appeared.

## 1. Release rule and scope

R1 ships as **one uninterrupted release** before B1–B6. It contains exactly:

1. **Q2:** empty-tick backoff with event-driven reset.
2. **Q4, narrowed:** the companion-read failure and one per-lane “why idle” line.
3. **Q3:** a durable per-mode outcome ledger.
4. **Apply-time identity enforcement:** the common fee write must enforce the bound page’s identity basis.

No throughput value is raised in R1. R3 (`health-hourly`) follows only after R1 lands. The consumer API remains frozen; manual bindings and admin writes remain exempt from identity quarantine.

## 2. Q2 plan — empty-tick backoff and wake-up

### Required behaviour

- Pause a drained worker lane only after its governed empty-call threshold.
- Cap the next trial at `tick.backoff_max_minutes` (default 15; allowed 1–60).
- Wake a paused lane when eligible work arrives; never leave it asleep while its own queue is eligible.
- Keep the control in governed settings, with no cron change and no second worker-side backoff.

### Implementation decision

The existing flag unit already supplied the empty-call counter and pause mechanism. R1 therefore keeps `flag.empty_calls_to_pause` as the “after N empty ticks” control rather than adding a duplicate `tick.backoff_after_empty` setting.

`security.flag_jobs_v1()` caps the trial wait with `tick.backoff_max_minutes`. `security.worker_mode_waiting_v1(mode)` mirrors each picker’s eligibility without leasing work. The existing 10-minute flag recheck consumes that predicate and resets the pause when work is waiting. This is the release’s event-driven reset path: queue state, not the old six-hour timer, drives the wake-up. Pre-existing six-hour trials are brought forward to the cap separately, with a logged control event.

Paused-prone modes covered: `read`, `link_search`, `provider_facts`, `ai_match`, `reidentify`, `discover`, `find_site`, `central_find`, `contact_page`, `logo_find`, `companion_read`, `source_find`, `programme_read`.

## 3. Q4 plan — companion read and why-idle

### Companion-read failure

The University of Sydney’s `.coredata.json` addresses can return the course page itself as HTML with HTTP 200. The worker previously rejected that body as not JSON. The fix accepts HTML at a `.json` address and reads it as the page. The affected 219 exhausted companion rows have their attempts restored by a count-guarded migration block; no manual binding is touched.

### Why-idle line

Add `pipeline.queue_watch.upstream_key` and `security.lane_why_idle_v1(key)`, exposed through the existing `public.admin_queue_watch()` and Work queues screen. One plain line explains the applicable state:

- paused by the idle guard, including the next trial and wake-on-work behaviour;
- nothing waiting, including the upstream lane that feeds it;
- work waiting with nothing finishing, indicating a gate;
- failing, out of tools, waiting for budget, or nothing left.

Central-AI rows for unpublished providers remain skipped by design. Onboarding and central-AI lease conditions are reported, not changed, under the narrowed scope.

## 4. Q3 plan — durable per-mode ledger

Create `pipeline.mode_outcome_ledger`, with RLS enabled, one row per worker call:

- `run_at`, `mode`, `status`, `ms`;
- `items`, `ok`, `failed`, `wait_ms`;
- `landed`, `worker`, and bounded `detail`.

`public.svc_worker_report_v1(...)` is service-role only. Worker `coverage-sweep-worker-v0.46.0` reports after building each answer; ledger failure must not fail the worker call. In v1, `wait_ms` may remain null because the pickers do not yet carry queued-at values. `security.lane_queue_wait_v1(hours)` supplies queue-wait p50/p90/max and rows waiting from existing queue timestamps.

Retention is governed by `retention.mode_outcome_ledger_days` (default 90). The catalogued daily `ledger-retention` job removes old ledger rows and old zero-yield snapshots. R3 consumes the ledger and queue-wait function; no new panel is introduced.

## 5. Apply-time identity plan

Enforce identity inside `security.coverage_apply_course_v1`, not only at fee enqueue:

- find the course’s bound, non-manual page and its `identity_basis`;
- call `security.coverage_identity_allowed(provider, basis, 'tuition')`;
- if disallowed, write the fee as `unverified`;
- create one pending Layer 4 row with source `identity_basis_reverify`;
- return `fee_quarantined_identity`;
- preserve the existing fee-floor quarantine behaviour;
- exempt `basis = 'manual'`, `identity_basis = 'manual'`, and admin writes.

Re-binding under the country’s rule re-admits through the same apply path.

## 6. Release artefacts and verification

| Item | Landed artefact |
|---|---|
| Pull request | Pilot PR #681, merged 24 October 2026 |
| Merge commit | `90e540a5555e5cc481feac013443f8b843d61b5f` |
| Release | v2.15.339 / package 0.1.266 |
| Migration | `20261024004000_cf247_r1_backoff_ledger_identity.sql` |
| Worker | `coverage-sweep-worker-v0.46.0` |
| Contract test | `tests/uat/cf-247-s93-r1-backoff-ledger-identity-contract.spec.mjs` |
| UI | Existing Work queues screen; `why_idle` line |
| Housekeeping | `-- Replaces:` and `-- Retires:` present; settings, table comments, component register and job catalogue included |

Verification evidence:

- PR checks: `build-and-smoke`, `release-history-contract`, and Cloudflare Workers build all passed.
- Independent source verification: release contract PASS; production build PASS; R1 contract test **10/10 PASS** across desktop and mobile projects.
- Read-only live reconciliation confirmed `pipeline.mode_outcome_ledger`, `public.svc_worker_report_v1`, `security.lane_why_idle_v1`, the 15-minute cap, 90-day retention and one `ledger-retention` cron job.
- The live apply function contains `fee_quarantined_identity`; the queue-watch function contains `why_idle`.
- The ledger had 299 rows at reconciliation, latest worker `coverage-sweep-worker-v0.46.0`; the Sydney exhausted-companion count was zero.
- The implementation record also observed coverage-read, coverage-read-2 and find-site wake when work was waiting.

## 7. Gates and next step

This reconciliation made no additional migration application, merge, deployment or activation. It used repository reads, local verification and read-only live queries only. No consumer API or throughput setting changed.

R1 has landed. R3 is the next standing-order item and remains a separate release. A later concurrent workstream delivered R3 as PR #682 / v2.15.340; that release is not claimed as part of R1 and does not alter this plan’s scope.
