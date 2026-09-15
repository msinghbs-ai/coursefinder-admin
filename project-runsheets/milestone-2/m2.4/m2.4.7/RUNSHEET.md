# M2.4.7 RUNSHEET — Controlled Operational Scale

**Status:** ACTIVE — END-TO-END ADMISSION FOUNDATION  
**Opened:** 2026-09-15 AEST  
**Predecessor:** M2.4.6 CLOSED / PASS / FROZEN  
**Accepted Pilot baseline:** `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`  
**Successor:** M2.4.8 Consumer & Data Operations Readiness  
**Programme authority:** `../M2.4.6-M2.4.9-OPERATIONS-PLAN.md`  
**Primary delivery roadmap:** `../../../../docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md` / `CF-CHG-20260915-247`

## Objective

Prove and complete the reusable end-to-end automation contract before increasing raw wave volume. A feature is complete only when qualified source data reaches governed admission/Search/API automatically or reaches Layer 4 as an explicit exception.

## Gates

- [x] Gate A — M2.4.6 accepted/frozen at Pilot `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`.
- [x] Gate B — RMIT selected as first genuinely qualified AU scale target.
- [x] Gate C1 — bounded RMIT 25-item scale wave executed: 25/25 processed, 0 blocked, USD 0.
- [x] Gate C2 — architecture gap proven: all 25 items ended `layer3_required`; deployed Layer 2 batch runner does not automatically enqueue/dispatch general Layer 3 Course interpretation.
- [ ] Gate D — implement durable automatic Layer 2 → Layer 3 queue and server-owned dispatcher with benchmark/profile/rate/cost/retry/stale controls.
- [ ] Gate E — implement deterministic post-L3 admission policy and incremental Search/API projection; AI has no unrestricted canonical-write authority.
- [ ] Gate F — add live Admin end-to-end progress: L2/L3/L4/admitted/remaining + Evidence/model/provider/cost/latency/blocker telemetry.
- [ ] Gate G — prove automatic admitted-data delta on AU, then the same shared engine on independently qualified NZ and CA pilots; run GB/US/IE/DE portability fixtures before each later-country live pilot.
- [ ] Gate H — converge Scholarship/Ranking/Statistics operations onto shared job/telemetry/control-plane conventions and complete the nominated security/replay/recovery/performance acceptance matrix.
- [ ] Gate I — close/freeze M2.4.7 only when the end-to-end automation foundation is reusable; later milestone labels must not reopen this architecture question.

## Starting consumer baseline

- Search courses: 33,105;
- official-course URLs: 527;
- intakes: 487;
- English requirements: 520;
- provider-current tuition: 161;
- website v3.1 `has_link=true`: 527;
- website-admitted scholarships: 0.

## RMIT scale-wave evidence

Request `f120fb4b-ec69-4f2c-8147-550a338c6f3d`, batch `13f33fcf-05b9-4379-b214-cf4760bbe1f3`:

- 25 targets / 25 processed;
- 0 deterministic Layer 2 resolutions;
- 25 Layer 3 fall-outs;
- 0 blocked;
- 25 vendor units;
- USD 0 provider cost.

This is sufficient evidence to stop launching larger Layer 2 waves until Layer 3 can drain automatically. More Layer 2 volume would only enlarge an undrained queue.

## Architecture direction

Keep accepted parsers, source profiles, Evidence, provider routing and model execution functions. Add shared orchestration around them:

1. automatic Layer 3 queue;
2. server dispatcher;
3. task-specific benchmarked model routes;
4. deterministic admission policy;
5. automatic Search/API projection;
6. live Admin trace.

Do not big-bang rewrite stable provider/country parsers. New country work changes adapters/source authority, not the queue/admission architecture.

## Guardrails

- CF-093 and CF-246 remain closed historical evidence.
- Do not manufacture data or copy AU qualification into another country.
- Do not unpause or repurpose a Layer 3 model for a task class that has not passed the relevant benchmark.
- Do not give AI direct Layer 1 identity or unrestricted canonical-write authority.
- Do not increase scheduler frequency/concurrency merely to increase counts.
- Acquisition/Evidence/AI candidate success is not itself consumer admission.
- Bugs/security/tooling proceed in parallel and block only when they affect authority, correctness, recoverability, safe execution or consumer integrity.

## Exact next gate

Implement Gate D: additive durable Layer 3 work queue + automatic dispatcher from existing Layer 2 `layer3_required` Evidence. Reuse deployed `layer3-interpret` for execution/validation and preserve all current security/Evidence boundaries. After that, add admission/projection and live UI before resuming broad AU waves.
