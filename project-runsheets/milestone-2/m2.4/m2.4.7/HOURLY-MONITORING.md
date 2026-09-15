# M2.4.7 / CF-247 Hourly Monitoring

**Status:** ACTIVE  
**Purpose:** durable hourly operational record for autonomous CourseFinder delivery.  
**Authority:** `docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md`, `docs/coursefinder-actionable-operations-monitoring-standard-v1.0.md`, `CF-CHG-20260915-247`.

## Recording rule

Add one concise entry per hourly monitoring/execution cycle. Record only actionable deltas and exact blockers; do not turn this into a chat transcript.

Each entry should contain where available:

- timestamp;
- repo/runtime/CI head checked;
- implementation/data outcome achieved during the hour;
- L2 processed/resolved/blocked;
- L3 queued/active/completed/rejected;
- L4 exceptions;
- admissions/Search/API coverage delta;
- Evidence created/reused;
- provider/model units, calls, tokens, cost and latency;
- backlog/resource/quota headroom;
- forecast/next action;
- hard external blocker, if any.

## 2026-09-15 09:27 UTC — monitoring baseline

- CF-247 end-to-end automation programme active.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Accepted Pilot code baseline entering CF-247: `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`.
- Latest controlled RMIT proof: 25/25 processed, 0 deterministic L2 resolution, 25 `layer3_required`, 0 blocked, USD 0 provider cost.
- Runtime Layer 3 fall-out backlog check: **2,402** Layer 2 run items currently in `layer3_required` state.
- No active queued/running Layer 2 item work at the observation point.
- Consumer baseline retained: Search 33,105; official URLs 527; intakes 487; English 520; provider-current tuition 161; website v3.1 `has_link=true` 527.
- Primary blocker is architectural/operational, not source volume: Layer 2 does not automatically dispatch the general Layer 3 queue.
- Decision: do not generate larger L2 backlog. Implement automatic L2→L3 queue/dispatcher, task-qualified model routes, post-L3 deterministic admission/Search projection and live actionable UI first.
- Resource monitoring requirement activated: provider quotas, model RPM/day/tokens/cost, DB/Edge latency, Evidence growth, queue age/depth and estimated backlog-clear time must be retained/reported.
- Hourly autonomous monitoring/execution automation enabled. Routine safe work no longer waits for a `proceed` command.

## 2026-09-15 11:27 UTC — durable Layer 3 queue foundation

- Reconciled accepted Pilot `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`, existing Layer 3 reservation/completion services, `layer3-interpret`, CF-245 tuition profile and live Pilot runtime.
- Runtime L2 item states: **2,402 layer3_required**, 2,281 resolved_l2, 815 cancelled, 10 blocked. No new L2 volume launched.
- Confirmed current general free profile is benchmark PASS/unpaused but authorised only for course_description/official_course_url/delivery_mode/duration; tuition profile remains paused/benchmark FAIL; scholarship model profiles remain paused/benchmark FAIL. No unsafe profile was enabled.
- Implemented first CF-247 Pilot unit on `cf-247-automatic-layer3-admission`: private `pipeline.layer3_work_items`, idempotent enqueue, bounded `FOR UPDATE SKIP LOCKED` reservation, benchmark/paused-profile guard and explicit transition service.
- Added targeted service-role/security/idempotency UAT contract. No canonical, Search or consumer mutation is included in this foundation.
- Pilot PR #97 opened at head `8a1f1e8efec2479510b8284dfb5e6881ae9ecba0`; mergeable. Pilot Frontend Build queued at observation time.
- L3 executions/admissions this cycle: 0 by design; queue foundation is not deployed yet. Existing backlog therefore remains 2,402.
- Provider/model calls/tokens/cost this cycle: 0 / 0 / USD 0. No external quota consumed.
- Immediate next action: obtain green CI/review on PR #97, then wire a server-owned dispatcher to existing `layer3-interpret` and map only benchmark-approved task classes; add post-L3 deterministic admission only after the dispatcher contract passes.
- No hard external API/authentication blocker. Current constraint is implementation/CI progression, not quota.
