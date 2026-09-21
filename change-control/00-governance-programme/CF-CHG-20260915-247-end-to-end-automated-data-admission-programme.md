# CF-CHG-20260915-247 — End-to-End Automated Data Admission Programme

**Status:** OPEN — ACTIVE DELIVERY AUTHORITY  
**Opened:** 2026-09-15 AEST  
**Primary owner:** 00-governance-programme  
**Affected surfaces:** Layer 1, Layer 2, Layer 3, Layer 4, Search/API consumers, Admin/PIM operations, Scholarships, Rankings, Statistics, country onboarding, Edge/runtime orchestration and UAT.

## Objective

Close the gap between accepted source/Evidence components and the business outcome: qualified data must flow automatically from source acquisition through governed admission to consumer-ready Search/API state, with human intervention reserved for genuine exceptions.

Programme authority: `docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md`  
Actionable operations/monitoring authority: `docs/coursefinder-actionable-operations-monitoring-standard-v1.0.md`

## Runtime finding that triggered this Change Control

The deployed Layer 2 path performs governed acquisition, Evidence normalization, deterministic extraction and item telemetry. Unresolved targets become `layer3_required`; the controlled RMIT proof produced 25/25 Layer 3 fall-outs and no automatic Layer 3 interpretation. A wider runtime check found 2,402 Layer 2 run items in `layer3_required`, proving that increasing Layer 2 volume without a drain path creates operational debt rather than admitted data.

## Programme decision

Do not expand Layer 2 wave volume merely to enlarge the Layer 3 backlog. The immediate engineering priority is the automatic Layer 2 → Layer 3 → deterministic admission/Layer 4 → Search/API loop. Existing accepted parsers, adapters, Evidence contracts, provider controls, model profiles and consumer APIs remain reusable; this is not authority for a big-bang refactor.

The Admin UI/reporting model remains part of the feature outcome. Routine screens must prioritise role-specific actionable, cross-linked metrics; stale totals and decorative diagnostics must not displace execution work.

## Required implementation outcomes

1. Durable idempotent Layer 3 work queue generated automatically from eligible Layer 2 fall-out.
2. Server-owned Layer 3 dispatcher with model-profile qualification, concurrency, RPM/day, cost and retry ceilings.
3. Task-class coverage for the fields actually produced by Course enrichment, with benchmark-passed model routes before execution.
4. Deterministic post-Layer-3 admission policy; AI never receives unrestricted canonical-write authority.
5. Automatic governed Search/API projection after accepted changes.
6. Layer 4 receives only policy-defined exceptions/ambiguities/consequential decisions.
7. Live Admin end-to-end progress: Layer 2 → Layer 3 → Layer 4 → admitted/Search, with Evidence, cost, tokens, latency and stop reasons.
8. Shared source/adapter and field-policy contracts used for AU/NZ/CA and upcoming countries rather than duplicating orchestration per Provider/country.
9. Scholarships, Rankings and Statistics converge on the same operations/control-plane conventions while retaining correct source-specific data semantics.
10. Wix/Website and Zoho remain curated read consumers behind safe API contracts.
11. Every headline operational metric is drillable to the exact Jobs/Evidence/queue/admission/consumer records that produce it.
12. Active runs show target, processed, remaining, L2/L3/L4/admission counts, throughput, ETA, provider/model resource usage and quota headroom with automatic refresh/realtime behaviour.
13. Hourly/daily retained telemetry supports capacity forecasting, backlog burn-down, cost/quota planning and source freshness management.
14. Each Admin screen is reviewed by role and stripped to actionable default data; forensic detail remains available through drill-down.

## Security invariants

- Layer 1 identity authority remains protected.
- Browser does not invoke service-only dispatch/admission helpers directly.
- private Evidence/Vault secrets remain private.
- Layer 3 outputs are candidates; deterministic policy controls admission.
- identity/regulatory/consequential ambiguity routes to Layer 4.
- no source qualification or benchmark is bypassed for throughput.
- API consumers have no canonical-write authority.
- candidate-bound tuition validation may return only an immutable Layer-2 candidate or null; it may not invent, annualise, convert currency, mutate year or strengthen basis.

## Continuous execution / anti-loop rule

Routine safe execution must not wait for a user `proceed` message. M247-FU-020/021/022 are mandatory: scheduled runs execute the exact carried-forward critical-path action after minimum reconciliation; implementation/CI/review/qualification are not data admission; DATA ADMISSION requires authoritative before/after proof through L2, L3, deterministic admission/L4, canonical delta, Search/API and Evidence/model/resource telemetry. One non-advancing run without a hard external blocker forces a changed executable approach; two is `SCHEDULER EXECUTION FAILURE`.

The only normal reasons to wait are a hard external API/quota/tool execution limit, authentication/approval requirement, safety boundary or genuine authority/security blocker. Exact run IDs and next actions must be persisted before tool/context exhaustion.

## Gate D execution state — 17 September 2026

Durable Layer 3 queue/security/handoff primitives are deployed and tuition candidate lineage is preserved. 610 explicit tuition fall-out records have proposed candidate context; 598 retain fee-candidate arrays. The tuition-specific profile remains correctly paused until benchmark PASS.

Latest trusted lifecycle baseline is 2,511 `layer3_required` / 2,423 `resolved_l2` / 815 cancelled / 10 blocked; Layer 3 work queue is 0. Evidence latest trusted total is 30,925. No larger Layer 2 wave is authorised.

Pilot PR #99 candidate-bound branch corrective head is **`58115985856bace75fecb10422dea5220ea4cee4`**. The exact worker source is deployed as `layer3-cf245-tuition-benchmark` runtime **v6**, worker `cf247-tuition-benchmark-v1.3.1-candidate-bound`.

Qualification evidence:

- request 6324: FAIL provider 0/4, controls 2/4, 13 calls, 18,799 input + 610 output, USD 0, max latency 6.609 s;
- request 6325 on diagnostic v1.3: FAIL provider 0/4, controls 0/4, 11 calls, 6,678 input + 35 output, USD 0, max latency 0.901 s; this isolated `json_object` transport as a regression;
- v1.3.1 restores strict JSON-schema transport while retaining focused Evidence and all fail-closed validators;
- request **6326** is submitted through the governed server path and at continuity cut remains queued in `net.http_request_queue` with the correct tuition benchmark URL and 120-second timeout. Do not submit a duplicate while unresolved.

The four positive corpus records were rechecked against canonical `catalogue.course_fees` and retained `pipeline.evidence_artifacts`; all are UQ 2027 international `indicative_annual` AUD tuition facts with retained Evidence. If 6326 still fails semantic positives after controls recover, inspect retained Evidence exact text before any further prompt/model change.

`layer3-interpret` still requires final `provider_current_tuition_validation` candidate-context execution integration before the first bounded live cohort.

## Gate-D qualification interpretation correction — 18 September 2026

A narrower execution interpretation incorrectly made universal positive tuition resolution a prerequisite for operating the Layer 3 route. That is not the programme design. Layer 3 must resolve only facts explicitly supported by retained Evidence and the immutable Layer-2 candidate set. Safe abstention/no-candidate, ambiguity, conflict, low confidence or validator rejection is a valid outcome when the durable work item is deterministically transferred to Layer 4 with Evidence lineage, candidate context, interpretation/audit record, reason/failure class and model/provider telemetry.

Accordingly, qualification must prove two behaviours: supported facts resolve without mutation; unsupported/ambiguous facts fail closed and route correctly to Layer 4. A safe refusal to infer an unsupported annual/indicative basis is not grounds to block all Layer 3 execution. Existing security, service-role, identity, Evidence, migration, admission and Search/publication boundaries remain unchanged.

## Delivery order

1. Complete Gate D qualification + candidate-context Layer 3 execution/drain.
2. Post-L3 deterministic admission policy + Search projection.
3. Live actionable operations UI with cross-linked metrics and resource forecasts.
4. AU end-to-end admission proof and scale.
5. NZ + CA pilots on the same engine.
6. GB/US/IE/DE portability and source-qualified live pilots.
7. Scholarship/Ranking/Statistics operational convergence.
8. Full nominated acceptance matrix plus hourly/daily operational reporting acceptance.

## Stop / rollback principle

Fix bugs and security defects as they arise, but do not let unrelated refactoring or paperwork displace the end-to-end admission outcome. New orchestration/admission components remain additive until accepted; queue/dispatcher/admission/live-monitor components can be disabled independently without deleting Evidence or canonical history.

## Current next action

Correct the qualification/routing contract forward-only so safe abstention and other policy-defined unresolved outcomes are accepted only when they produce the correct durable Layer-4 disposition and handover. Require exact-head CI/UAT, then execute a 10–25-item existing Evidence-backed cohort. Admit only validated authorised candidates; send unresolved/ambiguous/rejected/low-confidence outcomes to Layer 4. Capture M247-FU-021 through canonical and Search/API consequences. Do not weaken validation and do not launch larger Course waves until bounded drain is proven.

**NO DATA ADMISSION PROVEN** until the bounded cohort satisfies M247-FU-021.

## Exact-head repair campaign — 21 September 2026

PR #99 exact head `9b05918bcc59a1d68da54e1bbc6b9c15c6d9b051` now enforces the sole-target candidate contract and executes it in CI. Frontend Build `35555240917/#2478` and Release History Contract `35555240881/#156` PASS; Gitar reports no issues and the PR remains draft.

This is repository assurance only. Deployed runtime remains benchmark v11, interpreter v5 and dispatcher v4. Live state is 2,511 L2 `layer3_required`, 10 L3 `layer4_required`, 1 L3 `parked`, 59 L4 pending, Evidence 32,040, field admissions 1,216, fees 79,730 and Search documents 33,105. No CF-247 admission delta is proven.

Ordered blockers before any drain are: task/profile/auth-safe dispatcher reservation; benchmark PASS binding to exact prompt/schema/validator/model version; deterministic idempotent admission/L2 reconciliation/canonical/Search projection; then a description-first generic handler and tiny exact-head deployed cohort. Intake and English remain out of scope until explicit policies and validators exist. The 1,780 finding is a row cohort with overlapping unresolved fields, not authority for a bulk enqueue.

## Delivery evidence — 21 September 2026 14:05 AEST

CF-247 dispatcher/reservation slice is now closed across repository, CI and Pilot runtime. PR #99 exact head is `c8866b573480b337ed86494f9817c98c69629c79`; workflows `35555931223/#2479` and `35555931237/#157` pass. Pilot migration `20260921040446_cf247_task_profile_scoped_reservation` is applied and `layer3-work-dispatch` is ACTIVE v5 at hash `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`.

The deployed path now reserves only the requested task/profile, revalidates profile eligibility in the reservation transaction, uses one-at-a-time reservation with full-call remaining-time protection, and fails closed across reserved/interpreting error states. RPC execution remains restricted to postgres/service_role; the legacy global reservation RPC is retired. The parked item was not retried. Runtime remains 10 Layer-4-required + 1 parked, with no provider call, token, cost, canonical or Search/API admission delta.

The next governed unit is benchmark-version binding (slice 3). Larger L2 waves, new cohorts and the parked tuition item remain paused.

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
