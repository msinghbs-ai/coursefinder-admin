# M2.4.6 RUNSHEET — Production Operations Model

**Status:** CLOSED / PASS / FROZEN  
**Opened:** 2026-09-15 AEST  
**Closed:** 2026-09-15 AEST  
**Predecessor:** M2.4.5 CLOSED / PASS / FROZEN  
**Successor:** M2.4.7 Controlled Operational Scale — ACTIVE  
**Accepted Pilot:** `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`  
**Programme authority:** `../M2.4.6-M2.4.9-OPERATIONS-PLAN.md`

## Objective

Prove the minimum practical day-to-day operating model required to safely keep admitting qualified data and handing it to governed consumers, without making optional operational improvements prerequisites.

## Permanent stop rule

A newly discovered issue blocks only when it directly prevents safe deterministic admission, required security/identity/Layer authority, Search/API correctness, or bounded recovery from an active failure. Otherwise defer it and continue.

## Gates

- [x] Gate A — predecessor baseline reconciled and frozen.
- [x] Gate B — dispatcher/wave contract reconciled: server-owned/rank-gated dispatch, qualified scope checks, wave clamping, per-profile serialization, scheduled continuation and explicit NZ Course block.
- [x] Gate C — minimum failure/recovery contract: active request idempotency and bounded `schedule_remaining=false` semantics fixed and proven under CF-246.
- [x] Gate D — existing quota/cost/concurrency controls sufficient for bounded operation; no speculative throughput tuning performed.
- [x] Gate E — CF-245 observability retained; admission and consumer deltas measurable.
- [x] Gate F — clean bounded AU runtime exercise: 5/5 processed, 5 bounded L3 handoffs, 0 blocked, USD 0, one batch, duplicate start reused active request, terminal continuation dispatched 0.
- [x] Gate G — changed-surface acceptance: authenticated direct execute denied, service-role boundary preserved, PR #96 CI `34948479991` PASS, runtime migration identities reconciled.
- [x] Gate H — M2.4.6 closed/frozen and handed to M2.4.7.

## Admission progress retained at closure

- Search courses: 33,105;
- official-course-URL coverage: **527** after 122 newly projected canonical changes;
- intake coverage: 487;
- English coverage: 520;
- provider-current tuition: 161;
- website v3.1 `has_link=true` total: **527**.

Observed Evidence replay currently has 0 additional deterministic intake/English candidates. The 457 provider-current-tuition candidates remain a bounded Layer 3 backlog and do not block website handover.

## Accepted CF-246 migrations

- `20260915083840_cf_246_layer2_wave_request_idempotency_v1`
- `20260915084229_cf_246_wave_schedule_remaining_guard_v1`

## Closure boundary

Shared-Evidence reuse tuning and generic retry taxonomy are not M2.4.6 blockers. They may be considered during controlled scale only when measurements show a real cost, throughput or recovery constraint.

M2.5 remains paused and Production remains unprovisioned until M2.4.9 explicit GO.
