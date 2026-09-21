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
- [ ] Gate D — **PARTIALLY PROVEN**: durable queue/handoff, candidate-bound validation, service-owned interpretation/dispatcher and route-safety qualification are implemented. The original 10-item cohort has drained to Layer 4; a separate tuition item is parked. Exact-head repository repairs and deployed admission proof remain outstanding.
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

## Gate D routing correction — 18 September 2026

The programme architecture is authoritative over the narrower historical benchmark interpretation. Layer 3 does **not** need to resolve every tuition candidate to prove the drain path. A safe null/abstention, ambiguity, conflict, low-confidence or validator rejection is a valid Layer 3 result when it is persisted with Evidence/attempt context and deterministically routed to Layer 4 Human Resolution. Qualification fails when the model invents/strengthens facts, breaks Evidence/identity/security boundaries, or the system fails to route the exception correctly.

## Gate D bounded proof — 18 September 2026

- Pilot PR #99 exact head `910925ffe5c2ed7549a203cf7943a7497b151220`; exact-head Frontend Build `35294774026/#2465` PASS.
- Route-safety qualification PASS: run `76ba93df-7a0b-4646-be85-a22c6a548b49` / request 6331, provider 4/4, controls 4/4, profile unpaused.
- First bounded cohort: 10 existing Evidence-backed tuition work items created; current result 3 `layer4_required` + 3 new Layer-4 reviews, 7 retryable `failed` items at attempt_count=3, 0 validated/admitted.
- L2 lifecycle unchanged at 2,511 `layer3_required` / 2,423 `resolved_l2` / 815 cancelled / 10 blocked. L4 pending rose 48→51. Evidence 30,925 unchanged; `catalogue.course_fees` 79,730 unchanged; Search documents 33,105 unchanged.
- Live cohort consumed 4 actual provider calls, 40,839 input + 2,256 output tokens, USD 0, max latency 22,923 ms.
- Corrected daily accounting includes live + governed benchmark provider calls: 55 actual calls against configured day limit 25, headroom 0. Dispatcher quota preflight request 6336 proved 0 reservations / 0 dispatches while headroom is zero. Reset: 2026-09-19 00:00 UTC / 05:30 IST.
- **NO DATA ADMISSION PROVEN**: no validated result, canonical delta or Search/API delta exists yet.

## Exact next gate action

Until quota reset, do not enqueue, reserve, dispatch or benchmark. After reset, refresh provider-call headroom and resume **only the same seven retryable cohort items**. Do not create a replacement cohort. Validated authorised results continue immediately to deterministic Gate-E admission/Search proof; unresolved results route to Layer 4 with complete handover. Capture the remaining M247-FU-021 proof and keep larger L2 waves paused.

## Superseding Gate-D repair state — 21 September 2026

- PR #99 exact head `9b05918bcc59a1d68da54e1bbc6b9c15c6d9b051` makes `provider_current_tuition` the sole positive target, requires explicit identity/international audience, separates competing candidates, and runs the contract in exact-head CI.
- Exact-head Pilot Frontend Build `35555240917/#2478` and Release History Contract `35555240881/#156` PASS; Gitar reports no issues. PR remains draft.
- Earlier Gitar dispatcher corrections now reserve one item at a time, require a full-call time budget and recover both `reserved` and `interpreting` failures. The next bounded slice is task/profile-scoped reservation plus the governed scheduler-key auth bridge and direct dispatcher contract coverage.
- Deployed runtime is not yet current with these branch repairs: benchmark v11, interpreter v5 and dispatcher v4 remain active. Do not dispatch or deploy piecemeal.
- Live state at 2026-09-21 02:15 UTC: L2 `layer3_required` 2,511; L3 work 10 `layer4_required` + 1 `parked`; L4 pending 59; Evidence 32,040; field admissions 1,216; fees 79,730; Search documents 33,105. **NO DATA ADMISSION PROVEN.**

## 21 September 2026 — dispatcher/reservation slice runtime closure

- PR #99 exact head `c8866b573480b337ed86494f9817c98c69629c79` remains draft and mergeable; Gitar reports 5/5 findings closed.
- Exact-head workflows PASS: Pilot Frontend Build `35555931223 / #2479`; Release History Contract `35555931237 / #157`.
- Applied forward migration `20260921040446_cf247_task_profile_scoped_reservation` to Pilot. Scoped reservation now binds exact task class + profile, revalidates profile eligibility in-transaction, and grants execution only to `service_role`/postgres. The legacy global reservation RPC is retired fail-closed.
- Deployed exact-head `layer3-work-dispatch` v5, hash `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`. It reserves one item at a time through the scoped RPC and preserves the full-call time budget and fail-closed transition fallback.
- Parked item `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` was not retried or mutated: `parked`, attempt 6, unreserved. Runtime remains 10 `layer4_required` + 1 `parked`; Evidence 32,040; course fees 79,730; UTC-day live/benchmark calls 0/0, tokens 0/0, cost USD 0.
- Slice 2 is runtime-closed. Next bounded slice is slice 3 only: benchmark binding to exact prompt/schema/validator/model version with invalidation on change. No parked-item retry, cohort, larger L2 wave, admission claim, or RLS change is authorised.

### Migration-ledger reconciliation — 21 September 2026 14:12 AEST

Gitar aligned the repository migration filename to the already-applied Pilot ledger without changing SQL bytes. PR #99 exact head is now `e7b6d5b3ab345511c99fa66e35e65b89fab4d581`; Pilot Frontend Build `35560006737/#2480` and Release History Contract `35560006759/#158` both PASS. Repository file `20260921040446_cf247_task_profile_scoped_reservation.sql` now matches runtime migration `20260921040446`. Dispatcher v5/hash, queue counts and zero-call telemetry are unchanged. Slice 2 remains closed; slice 3 benchmark binding is next.


### CF-247 Slice 3A1 — 21 September 2026 15:00 AEST

PR #99 remains draft and mergeable at exact head `d3e48fa6c33cbe03cec66f3af0d3e3df50686a66`. Gitar added only the shared strict tuition response-schema export, stable candidate-validator/schema contract identifiers, and deterministic assertions in the existing required contract test. Independent diff review confirmed two files changed and no validator behaviour, benchmark execution, migration, dispatcher, interpreter, admission, Layer 4 or Search authority changed. Exact-head Pilot Frontend Build `35562558006/#2481` and Release History Contract `35562557856/#159` PASS.

This is repository/contract foundation only; it is not a runtime deployment or DATA ADMISSION. Pilot remains: dispatcher ACTIVE v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`; interpreter ACTIVE v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`; tuition benchmark ACTIVE v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. Runtime is unchanged at 10 Layer-4-required + 1 parked; target `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` remains parked at attempt 6; Evidence 32,040; course fees 79,730. No provider call, retry, canonical or Search/API delta was caused by this slice.

Next executable unit is Slice 3A2 only: make the tuition benchmark consume the shared schema/validator and align positive/null fixtures to single-target candidate-bound semantics. Do not start binding persistence/predicate work, retry the parked item, run a benchmark, create a cohort or expand Layer 2 in that unit.

### CF-247 Slice 3A2a — 21 September 2026 17:08 AEST

PR #99 remains draft at exact head `59b7a0759d5e87a709c47586f17ed952fa12f7a0` ([commit](https://github.com/msinghbs-ai/Coursefinder-Pilot/commit/59b7a0759d5e87a709c47586f17ed952fa12f7a0)). After the prior Gitar stop, a narrower, independently verified unit replaced only the benchmark's duplicate response schema with the shared schema export and added a deterministic source assertion; two files changed. Gitar's local contract/build passed; exact-head Pilot Frontend Build `35571407034/#2482` and Release History Contract `35571407041/#160` both PASS. No deployment or benchmark execution. Pilot functions remain dispatcher v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`, interpreter v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`, benchmark v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. Fresh queue read: 10 `layer4_required`, 1 `parked`; bounded item remains parked at attempt 6. No provider call, retry or admission was triggered; fresh broader resource, canonical and Search/API counts were not measured. **NO DATA ADMISSION PROVEN.** Next run: complete 3A2 shared-validator adoption and candidate-bound control fixtures only, then independently verify exact-head CI. Binding persistence/predicate remains 3B; do not retry the parked item, benchmark or expand L2.

### CF-247 Slice 3A2c verification — 21 September 2026, 20:04 AEST

Pilot PR #99 is open/draft/mergeable at exact head `463821f178ff3d79f3888b0d65f6b6227c08469d` (auto-merge remains off). Gitar fixture commit `1c309f92befe31545d0567f6c66e4ccb706b79f7` changed only the `ambiguous_multiple_equal_rank` Evidence text plus a focused contract regression. The target AUD 56,800 annual/2026 now has explicit per-semester/conflicting basis; the AUD 59,000 fee remains competing, non-selectable context. Independent diff review confirmed no other runtime statement in that commit. A subsequent Gitar review correction at exact head `463821f` makes transport errors inconclusive/invalid instead of scoring them as passing; it does not prove semantic benchmark PASS. Exact-head Pilot Frontend Build `35581451411/#2484` PASS (including CF-247 contract and local browser smoke); Release History Contract `35581451463/#162` PASS. No benchmark or cohort was run.

Pilot read-only queue: 10 `layer4_required` + 1 `parked`; the parked item was not retried. Deployed dispatcher v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`, interpreter v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`, benchmark v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c` remain ACTIVE and not updated from this PR. Fresh Evidence, admission, canonical/Search/API and provider-resource totals were not measured, so no delta is claimed. **NO DATA ADMISSION PROVEN.**

Next bounded unit (3A2d): fix the known-positive provider corpus scoring so authoritative positive truth is assessed with `validatePositive`, not an HTML keyword heuristic that can classify it as a null control. Verify its exact diff/tests/CI independently. Only after benchmark alignment is closed may Slice 3B bind PASS to exact prompt/schema/validator/model versions and invalidate on change. Keep the parked tuition item and larger L2 waves paused.


### CF-247 Slice 3A2d — 21 September 2026 22:00 AEST

PR #99 remains draft/open/mergeable at exact head `82577c36b6326b35f063eabe8c3c13c992c0888b` (one commit ahead of `463821f`; auto-merge not enabled). Independently inspected the two-file Gitar diff: the provider corpus now has fixed `resolve_candidate` expected truth and uses `validatePositive(r.parsed,candidateContext,evidence)` regardless of the keyword diagnostic; transport failures are invalid/inconclusive rather than semantic Layer 4. Four synthetic null controls, shared validator and quote/confidence/Evidence checks remain. Deterministic contract regressions were added. Exact-head Frontend Build `35592290555/#2491` PASS and Release History Contract `35592290539/#163` PASS; Gitar reports scoped contract/build/browser checks green. No new deployment. Pilot still has 10 `layer4_required` + 1 `parked` (fresh read); parked item was not retried. Dispatcher ACTIVE v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`, interpreter ACTIVE v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`, benchmark ACTIVE v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. No benchmark, provider call, admission or consumer delta was caused by this repository-only repair; fresh Evidence/course-fee/provider-resource/canonical/Search/API totals were not measured. **NO DATA ADMISSION PROVEN.** Next bounded unit is Slice 3B only: persist/compare an exact benchmark qualification binding covering shared validator implementation, response schema, profile prompt/system, model identifier and relevant settings; invalidate PASS on any mismatch. Require exact-head tests/CI and read-only runtime proof before any benchmark execution or parked-item/cohort retry. Larger L2 waves remain paused.


### CF-247 Slice 3B1 — 22 September 2026 02:00 AEST

Pilot PR #99 remains draft/unmerged at exact head `86345a880692e30bb9e9b6512ecac5fa6b730ec6` (auto-merge off). Independently reviewed Gitar's bounded binding-helper/test changes: the descriptor now derives real benchmark/interpreter prompt-building and provider-request source, the shared validator implementation/instruction and response schema, plus profile model/prompt/validator settings. The binding contract test is required in Frontend Build. Exact-head Frontend Build `35617285293/#2494` and Release History Contract `35617285480/#166` PASS; independent local binding and tuition contract tests PASS. This is descriptor/CI foundation only: no benchmark PASS is persisted or compared at runtime, no function was redeployed, and the existing PASS remains unbound. Pilot queue is 10 `layer4_required` + 1 `parked`; dispatcher v5 `f72a0194…`, interpreter v5 `13c1aeea…`, benchmark v11 `ac0a1e6d…` remain deployed. No provider call, parked retry, admission or consumer delta was caused by 3B1. **NO DATA ADMISSION PROVEN.** Next bounded unit is 3B2 only: forward-only PASS binding persistence and fail-closed comparison at every tuition execution/reservation gate, with profile-change invalidation and exact-head tests/CI; do not run benchmark or cohort until deployed proof. Larger L2 waves remain paused.


### CF-247 3B2A safety hold — 22 September 2026 03:10 AEST

Read-only Pilot check found tuition profile `openrouter-provider-tuition-validation-v1` enabled and unpaused on legacy benchmark run `76ba93df-7a0b-4646-be85-a22c6a548b49` with `quality_benchmark.pass=true` but no binding hash. There were no reserved/interpreting work items (queue: 10 Layer-4-required + 1 parked). A guarded Pilot update set only this tuition profile `paused=true`; legacy PASS/history were not rewritten. Gitar was given one bounded 3B2A instruction at PR #99 comment `5764398252` for source-derived binding manifest and forward-only PASS persistence, with explicit no-unpause/no-execution scope. PR #99 was draft at `86345a880692e30bb9e9b6512ecac5fa6b730ec6` when instructed. No provider call, benchmark, retry or admission occurred. Next: verify Gitar's exact diff/CI or implement the same 3B2A unit after a 45-minute stall; then separate 3B2B eligibility gates. **NO DATA ADMISSION PROVEN.**
