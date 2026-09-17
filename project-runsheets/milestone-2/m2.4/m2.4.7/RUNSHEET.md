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
- [x] Gate C2 — architecture gap proven: all 25 items ended `layer3_required`.
- [ ] Gate D — complete the reusable automatic L2→L3 drain: durable queue/handoff primitives are deployed; candidate-context tuition route is now in bounded qualification/runtime integration and must prove server-owned execution before the first cohort.
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

## Gate D current execution evidence — 17 September 2026

- Queue/security/handoff foundation is deployed; immutable tuition `candidate_context` is retained from Layer 2 into Layer 3 lineage.
- 610 explicit tuition fall-out rows have proposed candidate context; 598 retain ranked fee-candidate arrays.
- Latest trusted lifecycle baseline: 2,511 `layer3_required` / 2,423 `resolved_l2` / 815 cancelled / 10 blocked; Layer 3 work queue 0.
- Tuition route remains enabled but paused/benchmark-FAIL, correctly preventing automatic enqueue.
- Candidate-bound PR #99 corrective head: `58115985856bace75fecb10422dea5220ea4cee4`.
- Exact benchmark source deployed as Edge Function v6 / `cf247-tuition-benchmark-v1.3.1-candidate-bound`.
- Request 6324 failed 0/4 provider + 2/4 controls. Diagnostic request 6325 proved `json_object` transport was a regression at 0/4 + 0/4. v1.3.1 restores strict JSON-schema transport while retaining focused Evidence and fail-closed validators.
- Qualification request **6326** is submitted and, at continuity cut, remains queued in `net.http_request_queue`; do not duplicate it.
- `layer3-interpret` still requires final `provider_current_tuition_validation` candidate-context execution integration before bounded live admission.

## Architecture direction

Keep accepted parsers, source profiles, Evidence, provider routing and model execution functions. Add/reuse shared orchestration around them: automatic Layer 3 queue, server dispatcher, task-specific benchmarked routes, deterministic admission, Search/API projection and live Admin trace. Do not big-bang rewrite stable provider/country parsers.

## Guardrails

- CF-093 and CF-246 remain closed historical evidence.
- Do not manufacture data or copy AU qualification into another country.
- Do not unpause or repurpose a Layer 3 model for a task class that has not passed the relevant benchmark.
- Do not give AI direct Layer 1 identity or unrestricted canonical-write authority.
- Do not increase scheduler frequency/concurrency merely to increase counts.
- Acquisition/Evidence/AI candidate success is not itself consumer admission.
- Bugs/security/tooling proceed in parallel and block only when they affect authority, correctness, recoverability, safe execution or consumer integrity.
- M247-FU-020/021/022 are mandatory: execution-first state transition, admission-proof contract and exact next-action carry-forward.

## Exact next gate action

Resolve request **6326** first. On full provider+safety PASS, complete exact-head `layer3-interpret` candidate-context integration/CI/UAT and execute only a 10–25-item existing Evidence-backed tuition cohort through L3 → deterministic admission/L4 → Search/API proof. If 6326 fails, use its exact failure classes; if controls recover but positives remain null, verify retained HTML exact support before another bounded corrective change. Do not weaken qualification and do not launch larger L2 waves.

**NO DATA ADMISSION PROVEN** until the bounded cohort satisfies M247-FU-021.