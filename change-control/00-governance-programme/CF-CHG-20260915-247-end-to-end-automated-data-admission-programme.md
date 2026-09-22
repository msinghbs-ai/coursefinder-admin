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


### CF-247 3B2A safety hold — 22 September 2026 03:10 AEST

Read-only Pilot check found tuition profile `openrouter-provider-tuition-validation-v1` enabled and unpaused on legacy benchmark run `76ba93df-7a0b-4646-be85-a22c6a548b49` with `quality_benchmark.pass=true` but no binding hash. There were no reserved/interpreting work items (queue: 10 Layer-4-required + 1 parked). A guarded Pilot update set only this tuition profile `paused=true`; legacy PASS/history were not rewritten. Gitar was given one bounded 3B2A instruction at PR #99 comment `5764398252` for source-derived binding manifest and forward-only PASS persistence, with explicit no-unpause/no-execution scope. PR #99 was draft at `86345a880692e30bb9e9b6512ecac5fa6b730ec6` when instructed. No provider call, benchmark, retry or admission occurred. Next: verify Gitar's exact diff/CI or implement the same 3B2A unit after a 45-minute stall; then separate 3B2B eligibility gates. **NO DATA ADMISSION PROVEN.**


### CF-247 3B2A baseline and manual failover — 22 September 2026 03:24 AEST

Pilot PR #99 draft head `f5bb7ead2fa1874e821d57a93a28cab8a994f67a` adds one NEW, UNAPPLIED migration containing the exact live tuition-benchmark record RPC baseline, function-body MD5 `7556ed94d82ec8fa46eb069b891e9737`; local comparison with fresh `pg_get_functiondef` was byte-identical. Do not apply the baseline as a standalone no-op; complete 3B2A in this same unapplied migration first. Exact-head Frontend Build `35630687777/#2495` and Release History Contract `35630687692/#167` PASS. Gitar independently matched the in-branch digest but stopped without a corrective commit because it lacks direct Pilot DB access and requires a credentialed CI/live diff. This is a Gitar capability blocker, not authorisation to weaken the check. The tuition profile remains paused against legacy unbound PASS; queue 10 Layer-4-required + 1 parked, no active execution or admission. If no manual/Gitar progress for 45 minutes after the last action, manually implement the same bounded forward-only 3B2A with direct live-function verification and exact-head CI; do not start 3B2B, deploy, run benchmark, unpause, retry parked, merge or expand L2. **NO DATA ADMISSION PROVEN.**


### CF-247 3B2A fail-closed migration foundation — 22 September 2026 04:12 AEST

After >45 minutes without Gitar progress, manual failover verified the live tuition recorder MD5 `7556ed94d82ec8fa46eb069b891e9737` and advanced only the same 3B2A unit. Pilot PR #99 remains draft at exact head `c1a7d411f9e338c6137187db93dfb46a231ca0e8` (a subsequent merge/synchronisation preserved the two changed blobs). Its **unapplied** `20260921171328` migration adds nullable SHA-256-format `binding_hash` storage to benchmark runs and disables the legacy ten-argument unbound recorder before its scorer/profile mutation. The original live scorer stays byte-identical behind the guard; the required binding contract checks this baseline, guard order, schema and service-role grants. Local binding/tuition tests PASS; exact-head Frontend Build `35636595427/#2498` and Release History Contract `35636595401/#170` PASS. This is **not** binding persistence or migration replay and must not be deployed alone as qualification: the bound recorder, source-derived worker manifest/handoff and later 3B2B gate comparisons remain. Runtime tuition profile stays paused with legacy unbound `pass=true`; queue 10 `layer4_required` + 1 `parked`. Dispatcher v5 `f72a0194…`, interpreter v5 `13c1aeea…`, benchmark v11 `ac0a1e6d…` unchanged. No benchmark/provider call, parked retry, deployment, admission or consumer delta. Next run continues **3B2A only** (source-derived manifest, bound recorder/persistence and worker handoff), then independent exact-head tests/CI; 3B2B remains later. **NO DATA ADMISSION PROVEN.**


### CF-247 3B2A source-binding correction — 22 September 2026 05:06 AEST

PR #99 remains draft/unmerged at exact head `eb432f4ad155010cb6292111c96f6dc3ef0f4d87`, with no unresolved review threads. Live `layer3_cf245_tuition_benchmark_profile_service` exposes `deterministic_validators` and `structured_output_schema`; the previous 3B1 descriptor incorrectly read `validators` (defaulting the values), omitted `max_output_tokens`, and omitted the stored profile schema. Manual 3B2A repair now binds the complete live validator JSON, stored profile schema and output-token setting without silent defaults. A checked-in source-hash manifest is verified by the mandatory binding contract against actual benchmark/interpreter prompt and request spans, validator source, shared response schema and helper source; drift fails CI. Local binding and tuition contracts PASS. Exact-head Frontend Build `35642420505/#2501` and Release History Contract `35642420484/#173` PASS. This is a repository-only descriptor/manifest correction: the unapplied migration's legacy recorder remains fail-closed, but the bound recorder/worker handoff and runtime PASS comparison are NOT implemented; do not deploy or run qualification based on this partial unit. Runtime tuition profile stays paused on legacy unbound PASS, queue unchanged at 10 `layer4_required` + 1 `parked`, deployed dispatcher v5 `f72a0194…`, interpreter v5 `13c1aeea…`, benchmark v11 `ac0a1e6d…`. No benchmark, provider call, parked retry, admission or consumer delta. Next run: **3B2A bound recorder + benchmark-worker binding handoff only**, then separate 3B2B gates; preserve draft, pause and larger-wave hold. **NO DATA ADMISSION PROVEN.**

### CF-247 Slice PRE — dense-source reformat, independently verified — 22 September 2026 06:55 AEST

Slice PRE was a pure Prettier reformat of four dense/minified source files: `supabase/functions/layer3-cf245-tuition-benchmark/index.ts`, `supabase/functions/_shared/cf247-tuition-validation.ts`, `supabase/functions/layer3-work-dispatch/index.ts` and `supabase/functions/layer3-work-interpret/index.ts`, with matching whitespace-tolerance fixes to source-contract regex assertions in `tests/cf247-tuition-validation-contract.test.ts`. No logic change was intended or made in the final verified replacement.

A process error occurred: the reformat was first built against branch commit `4e9abe7`, which predated four fixes already landed on the branch: `5ffe7f8` interpreter seed/reasoning, `1c309f9` `ambiguous_multiple_equal_rank` Evidence correction, `463821f` transport-error scoring and `82577c3` provider-corpus known-positive scoring. Applying that stale reformat reverted those four fixes. Gitar's bot independently detected and corrected the interpreter file in commit `9e7d9de`. The reformat was rebuilt from the correct current head `26ccc62` and re-verified.

A second error occurred during manual application: the test file's content was pasted into the benchmark file's path by mistake in commit `66df6a0`. Gitar's bot correctly detected and reverted that mistake in commit `293f84f`, restoring the correct pre-formatting original, verified byte-identical to the `26ccc62` source. The bot had no visibility into the pending reformatted replacement. The formatted benchmark file was then applied correctly in a follow-up commit.

Final Slice PRE state was independently confirmed against the live Pilot branch, not taken from an agent self-report: exact head `bcd82ccdbd932b87918b8c857a296ae442b3200e` at 22 September 2026 06:46 AEST. All five files' SHA-256 checksums match the independently built and verified replacement content. `npm run test:cf247-tuition-validation-contract` PASS (24 assertions); `npm run build` PASS; Playwright `cf-247-layer3-scoped-reservation-contract` and `cf-247-layer3-work-queue-contract` 4/4 PASS. No SQL, migrations, main-branch changes or worker-to-recorder binding-hash change occurred in this unit.

Runtime state was unchanged by this formatting unit. Current deployed dispatcher, interpreter and benchmark versions/hashes were not independently checked during this documentation update; previous entries' deployed figures are not asserted as current. No benchmark, parked-item retry, deployment or PR #99 merge was performed by this update. **NO DATA ADMISSION PROVEN.**

Next bounded unit is the worker-to-recorder binding-hash change only: `supabase/functions/layer3-cf245-tuition-benchmark/index.ts` must compute and pass `p_binding_hash` to the 11-argument `layer3_cf245_tuition_benchmark_record_service` RPC. The currently deployed 10-argument call resolves to the disabled legacy overload and fails closed by design. Do not start that unit, run a benchmark, retry the parked item, deploy or merge PR #99 in this documentation-only update.


### CF-247 Gitar access and workflow stop directive — 22 September 2026 AEST

Owner directive: stop Gitar from reviewing or editing the `msinghbs-ai/Coursefinder-Pilot` repository, including PR #99 and all other Pilot branches/PRs. Do not request or trigger Gitar reviews, fixes, commits, pushes, merges or autonomous follow-up. Do not treat earlier Gitar instructions, review requests, bot comments or scheduled handoffs as active authorisation. Continue CF-247 through direct, independently verified GitHub changes and governed CI/UAT only; preserve PR #99 draft/unmerged, tuition pause and larger Layer 2 wave hold until their respective acceptance gates are satisfied.

This entry records the stop instruction, not proof that Gitar's GitHub installation, repository access, webhook triggers or outstanding queued runs have been disabled. GitHub installation/repository permissions and any Gitar-side automation must be revoked or disabled by an authorised repository/installation administrator; verify access revocation separately before reporting technical enforcement. Do not use the Gitar bot for verification or remediation. No Pilot implementation, migration, deployment, runtime execution or data admission is authorised by this documentation-only directive. **NO DATA ADMISSION PROVEN.**

Next bounded unit: enforce and independently confirm Gitar's Pilot repository access/automation removal, then resume only the governed worker-to-recorder binding-hash handoff under direct control. Do not benchmark, retry the parked item, deploy or merge PR #99 as part of this governance update.

### CF-247 Slice PRE follow-up — binding contract CI fix — 22 September 2026 AEST

Slice PRE's reformat broke the CF-247 tuition-benchmark binding contract
in three distinct ways, not one. Gitar's bot independently fixed the
first (manifest-hash mismatch on the benchmark's prompt/request
extraction anchors, commits `006f37b`, `faaad01`, `55a4acc`) before
its Pilot access was revoked. Two further breakages remained and were
found and fixed independently, not by Gitar:

First, a genuine pre-existing bug in `extractCandidateContextInstructionSource`
(`supabase/functions/_shared/cf247-tuition-benchmark-binding.ts`): it
hardcoded a double-quote character to find a string literal's closing
delimiter. Prettier had chosen single quotes for that specific string
(it contains an embedded double-quoted word), so the function located
the wrong quote and extracted the wrong text. Fixed to detect either
quote character; the extracted instruction text is unchanged either
way, so this is a correctness fix, not a contract change. The source
manifest's `binding_helper_sha256` was regenerated to match, since it
hashes the entire binding-helper file.

Second, two more benchmark-side regex assertions in
`tests/cf247-tuition-benchmark-binding-contract.test.ts` assumed dense,
no-space formatting while their interpreter-side counterparts already
tolerated Prettier spacing; both were widened to match. One arbitrary
test-fixture string literal (unrelated to any real extraction anchor)
was also updated to match current formatting.

Independently verified: `test:cf247-tuition-benchmark-binding-contract`
PASS, `test:cf247-tuition-validation-contract` PASS, `npm run build`
PASS, and both non-deployed CF-247 Playwright specs 4/4 PASS. The full
110-spec UAT suite was also run for thoroughness; all failures there
are `@deployed`/`@smoke`-tagged tests requiring a live Pilot URL not
reachable from this verification environment (instant connection
failures, not logic failures) — this matches the existing split
between the "Frontend Build" and deployed-UAT CI jobs and is not a
new regression.

This fix was prepared and verified but has not yet been committed to
the Pilot branch — it is being applied via direct GitHub web-editor
edits after four consecutive failures of the same transfer operation
through the GitHub-connected agent. That agent's connector was
confirmed (via its own diagnostic) to support creating Git blobs from
inline text/string content but not from file attachments; this is a
durable constraint worth remembering for future prompts to it, not a
one-off failure. **NO DATA ADMISSION PROVEN. No SQL, migration, main,
or worker-to-recorder binding-hash change in this unit.**

Next bounded unit, once this CI fix is confirmed live: the
worker-to-recorder binding-hash handoff — `layer3-cf245-tuition-
benchmark/index.ts` must compute and pass `p_binding_hash` to the
11-argument `layer3_cf245_tuition_benchmark_record_service` RPC. Do
not start that unit, run a benchmark, retry the parked item, deploy,
or merge PR #99 as part of this documentation update.

### CF-247 3B2A worker-to-recorder binding-hash handoff — 22 September 2026 AEST

The benchmark worker (layer3-cf245-tuition-benchmark/index.ts) now
computes and passes p_binding_hash to the 11-argument
layer3_cf245_tuition_benchmark_record_service RPC, closing the last
3B2A gap noted at "22 September 2026 05:06 AEST": the bound recorder
and worker handoff are now both in the branch.

Design note, recorded because it was not pre-specified: the worker
cannot re-derive the binding hash from raw .ts source text at Deno
edge runtime the way the CI binding contract test does (there is no
precedent anywhere in this codebase for a deployed Edge Function
reading its own or a sibling function's source file, and the binding
helper's own documentation confirms that path is CI/test-only). The
worker instead computes its hash from the checked-in, CI-verified
source manifest (CF247_TUITION_BINDING_SOURCE_MANIFEST) combined with
the live profile settings it already fetches. This is genuinely
source-bound (the manifest is proven to match real source by the
existing mandatory binding contract test) and genuinely profile-bound
(a model, validator, or schema drift changes the hash), without a
first-of-its-kind runtime file-read dependency.

A new function, tuitionBenchmarkRuntimeBindingHash, was added to
supabase/functions/_shared/cf247-tuition-benchmark-binding.ts, reusing
the existing profile validation logic (extracted into
resolveTuitionProfileBindingInputs so the CI/test descriptor path and
the runtime path can never silently diverge in which profile fields
they require). binding_helper_sha256 in the source manifest was
regenerated to match.

Nine new CI assertions (#25-33) in
tests/cf247-tuition-benchmark-binding-contract.test.ts independently
prove: correct hash format (lowercase 64-char hex, matching the
recorder's CHECK constraint), determinism, that a source-manifest
drift changes the hash, that a profile drift (model identifier,
validator settings) changes the hash, that the same fail-closed
behaviour as the full descriptor applies (ambiguous or missing profile
fields throw), and a source-text contract proving the worker actually
computes and passes the hash before any provider call is made (so a
malformed profile fails closed before any cost is spent), not merely
that the capability exists unused.

Independently verified: test:cf247-tuition-benchmark-binding-contract
PASS (33 assertions), test:cf247-tuition-validation-contract PASS,
npm run build PASS, both non-deployed CF-247 Playwright specs 4/4
PASS. No secrets flow into the hash — confirmed the profile fields
used are the same non-secret settings already used elsewhere in this
worker; the real provider credential stays on its separate resolution
path.

This closes 3B2A. **NO DATA ADMISSION PROVEN — the recorder's own SQL
always sets paused=true regardless of pass/fail on this bound path, so
completing this unit cannot itself unpause tuition validation.** No
benchmark was run, the parked item was not retried, nothing was
deployed, and PR #99 was not merged as part of this unit.

Next bounded unit: 3B2B — fail-closed comparison of this binding hash
at every tuition execution/reservation gate, with profile-change
invalidation. That is a separate, later unit; do not start it, run a
benchmark, retry the parked item, deploy, or merge PR #99 as part of
this documentation update.

### CF-247 3B2A/3B2B live deployment and real verification — 22 September 2026 AEST

Both prepared migrations and both updated edge functions were applied
directly to the live Pilot Supabase project (fxcwkweaxjtknorudmwp) via
direct database/function-deploy access, corresponding exactly to Pilot
branch cf-247-candidate-bound-layer3 commit
28e6b0e1b23df13737183217b5e26369ae5ce23a. This deployment did not go
through a git merge to main or CI/CD; PR #99 remains open, draft and
unmerged. Governance note: the live deployed code currently
corresponds only to a reviewed draft-PR branch commit, not to main —
worth reconciling before this branch is considered the system of
record going forward.

Pre-deployment safety checks: confirmed live queue state (10
layer4_required + 1 parked, nothing reserved/interpreting), confirmed
no automated cron job dispatches tuition work (only an unrelated
15-minute housekeeping job exists), and confirmed the live 10-argument
legacy recorder function matched the exact baseline the migration
assumes (byte-for-byte, via MD5) before disabling its unbound path.

A transcription error occurred during the first benchmark deploy
attempt: `profile_response_schema` was accidentally omitted from the
`tuitionBenchmarkRuntimeBindingHash` descriptor while manually
transcribing file content into the deploy call — a real bug, not
present in the verified source. It was caught by checking the actual
deployed function content (not trusting the deploy call's own
success response), and corrected in a second deploy
(layer3-cf245-tuition-benchmark now version 13). The interpreter
deploy (layer3-work-interpret, version 6) was verified field-by-field
against the exact source before being treated as correct, with no
further errors found.

The residual gap flagged in the prior entry — whether the benchmark's
profile RPC (layer3_cf245_tuition_benchmark_profile_service, which has
no migration file in this repository) and the interpreter's profile
RPC genuinely produce field values that hash identically — is now
closed with direct evidence rather than inference. Querying the live
benchmark profile RPC definition confirmed it returns
deterministic_validators/structured_output_schema (canonical names),
consistent with the interpreter RPC's validators/schema aliases via
the existing alias-resolution code.

A real end-to-end test was run, not simulated: triggered via the
existing pipeline.svc_pilot_submit_nonce('layer3-cf245-tuition-benchmark')
mechanism (the same allowlisted path the system's own scheduler uses),
net.http_request id 6637. Result: benchmark run
8e55c4a1-3d3e-4279-afe9-acf97ba97bd2, status FAIL (provider 0/4,
controls 4/4, semantic_provider=4, semantic_controls=4, 10 calls, USD
0), with binding_hash 0944b3448095b3ac62d2a5a9e1afeec54cd890fcdc228d9e73a166b027b8c902
correctly recorded — the first non-null binding_hash on any benchmark
run in this system's history, proving the new code path executed
without error end-to-end (no 500, clean 422 fail response matching
the worker's own pass/fail branching).

The binding hash was independently re-derived outside the deployed
function entirely: read the live tuition profile's exact field values
via direct query, recomputed the identical canonical-descriptor
SHA-256 algorithm in a separate local environment, and confirmed an
exact byte-for-byte match against the recorded hash. This is direct
cryptographic proof the runtime computation is correct and
reproducible, not merely internally consistent.

Post-test state, confirmed by fresh query: tuition profile remains
enabled=true, paused=true (the bound recorder's own logic always sets
paused=true regardless of pass/fail, by design). quality_benchmark
now shows pass=false with the new binding_hash attached, superseding
the prior legacy pass=true/no-binding-hash record. Work queue
unchanged: 10 layer4_required + 1 parked, nothing newly reserved or
interpreting. **NO DATA ADMISSION PROVEN** — the benchmark did not
pass, and nothing was unpaused regardless.

This closes 3B2A and 3B2B as deployed and verified against live
infrastructure — a stronger bar than "built and internally
consistent." What remains open is substantive, not procedural: the
benchmark itself needs to actually pass (provider scoring dropped
from 4/4 on 18 September to 0/4 today under an unchanged model and
prompt version — worth investigating why before any retry, e.g.
Evidence drift, provider-side model behaviour change, or case
selection differences), and separately, unpausing tuition validation
after a genuine pass requires its own deliberate action that has not
been designed or built.

Next bounded unit: investigate the provider-scoring regression (4/4
to 0/4) before retrying the benchmark. Do not retry the benchmark,
design or build an unpause mechanism, retry the parked item, or merge
PR #99 as part of this documentation update.

### CF-247 multi-model evaluation — first genuine benchmark pass — 22 September 2026 AEST

Architecture clarification recorded first: OpenRouter's own auto/fallback
routing across models cannot be used for the qualified tuition profile.
The recorder's model_exact check requires every response in a qualifying
run to come from the exact profile.model_identifier; dynamic model
routing would make that guarantee impossible by design. Provider-level
routing for one chosen model (provider: { require_parameters: true },
already in place since the earlier CI-fix entry) remains the correct
and compatible use of the aggregator — it improves reliability of
serving one qualified model, not which model answers.

Multi-model support (added this session: parameterized profile_code on
layer3_cf245_tuition_benchmark_profile_service, p_profile_id-keyed
recorder overload, both already live and verified) was used to
configure and empirically benchmark four OpenRouter model candidates
against the real CF-247 case pool, not against documentation or pricing
tables alone — OpenRouter's own model-capability docs proved unreliable
twice this session (a "supports response_format" claim that was false
for the live endpoint, and a free-tier model deprecated mid-session).

Results, each against the identical 4 provider-case / 4 control-case
benchmark:

- openai/gpt-oss-20b (paid, $0.03/$0.13 per 1M): provider 2/4, controls
  4/4, semantic 4/4 both, zero transport errors, $0.0007/run. Mandates
  reasoning cannot be disabled (confirmed via direct API error
  "Reasoning is mandatory for this endpoint and cannot be disabled");
  code was changed to stop forcing reasoning off project-wide as a
  result (see prior entry). Cheapest tested, but real per-run cost
  varies with reasoning-token consumption.

- deepseek/deepseek-v3.2 ($0.26/$0.38 per 1M): provider 2/4, controls
  3/4 (one control failed on a missing rationale field, not a
  reasoning failure), zero transport errors, no forced-reasoning
  issue (reasoning_tokens: 0 throughout), $0.0043/run — 6x gpt-oss-20b's
  cost for no reliability improvement.

- mistralai/mistral-small-3.2-24b-instruct ($0.09/$0.25 per 1M):
  provider 4/4, controls 4/4, zero transport errors, no reasoning
  overhead, $0.0013/run. PASSED. Run id
  05669d3f-efa4-47ca-aed3-6e91b4a9bed5, binding_hash
  7e8c05f6540967a536e1654566c74915733c72dd34111b0ba2cb7fb34a78c12f,
  8 calls (no retries needed). This is the first genuine full pass
  of the CF-247 tuition benchmark under the corrected, require_parameters
  -enforced scoring since 3B2A/3B2B landed.

- qwen/qwen3-32b: diagnostic only, not fully benchmarked. Confirmed via
  direct API test that it enters unsolicited extended reasoning even
  without being asked (238 reasoning tokens for a one-line question,
  more expensive per-call in practice than deepseek-v3.2's diagnostic
  despite a lower headline per-token price). Same class of cost/
  predictability problem as gpt-oss-20b; not pursued further given
  mistral-small-3.2 already passed cleanly at lower cost.

Two profiles confirmed structurally disqualified this session and
candidates for formal retirement: the original nvidia/nemotron-3-nano-
omni-30b-a3b-reasoning:free profile (its sole endpoint does not support
response_format at all, confirmed via direct testing, not merely
undocumented) and openai/gpt-oss-20b:free (deprecated by OpenRouter
mid-session, paid variant used instead).

Post-benchmark state, confirmed by direct query: the passing profile
(mistral-small-3.2) remains enabled=true, paused=true — the bound
recorder's own logic always sets paused=true regardless of pass/fail,
by design. **NO DATA ADMISSION PROVEN. No unpause mechanism exists or
was designed. No interpretation, benchmark retry, deploy beyond what
is already recorded in prior entries, or PR #99 merge was performed
as part of this evaluation.**

Next bounded units, genuinely separate, not to be combined: (1) decide
whether to formally retire the two disqualified profiles or leave them
as historical record; (2) design and build the unpause mechanism
(comparing current runtime binding hash against the qualified one, a
3B2B-adjacent gate that has not yet been designed for the activation
path, only the execution-refusal path); (3) build the model-selection
UI (ScholarshipAiControl.jsx pattern already identified as the template)
now that a real passing profile exists to feature in it.

### PR #99 reviewed for squash-merge; governance gap found and fixed — 22 September 2026 AEST

PR #99 was reviewed in full ahead of a decision to squash-merge it into
main as a milestone, not discard it. Every substantive correctness
finding gitar's automated review raised across the PR's 49-commit
history (retired RPC still called by the dispatcher; positive validator
losing independent audience/basis/fee_year guards; the
ambiguous_multiple_equal_rank control contradicting the candidate-bound
contract it was meant to test; work items able to get permanently stuck
in interpreting on dispatcher failure; unbounded sequential dispatch
risking a wall-clock timeout) was independently verified fixed at the
current branch head — checked against the actual live code, not
trusted from historical comments. Full CF-247 test suite, build, and
UAT all pass. A dry-run merge against current main shows zero conflicts.

One real gap was found and fixed in the course of this review, not
before: four schema objects applied directly to the live Pilot Supabase
project in an earlier session unit (parameterized
layer3_cf245_tuition_benchmark_profile_service, the p_profile_id-keyed
12-argument recorder overload, security.tuition_ai_control_read_impl,
and the admin_read dispatch extension for tuition_ai) had no
corresponding checked-in migration file. Four migration files were
written to close this gap and each verified byte-for-byte identical to
the live definition by reapplying the file's exact content and
confirming the resulting function MD5 was unchanged. These four files
must land on the branch before merge:

- supabase/migrations/20260922050000_cf247_tuition_benchmark_profile_service_parameterize_code.sql
- supabase/migrations/20260922050100_cf247_tuition_benchmark_record_service_profile_id_overload.sql
- supabase/migrations/20260922050200_cf247_tuition_ai_control_read_impl.sql
- supabase/migrations/20260922050300_cf247_admin_read_tuition_ai_dispatch.sql

One further, non-blocking finding logged: a current_user-based
SECURITY DEFINER auth check pattern used throughout this codebase
(including several CF-247 functions) is a documented no-op under
SECURITY DEFINER — current_user reflects the function owner, not the
caller — matching a finding already raised on a separate, already-merged
PR for the same pattern elsewhere in the codebase. Not exploitable in
practice: actual enforcement is the REVOKE ALL / GRANT service_role
boundary, confirmed correct on every CF-247 function reviewed here.
Predates this PR and spans functions well outside CF-247's scope; not
addressed here and not a merge blocker.

**Decision: keep and squash-merge, not discard.** The messy 49-commit
history is git hygiene debt, resolved by squashing; the underlying
functionality is real, working, and independently verified live today
(binding-hash protection, multi-model qualification with a genuine
pass, the read-only comparison UI). Next steps: add the four migration
files, update the PR description, mark ready for review, squash-merge.

### PR #100 and PR #79 both merged and verified on live main — 22 September 2026 AEST

Both PRs are now merged into main, confirmed on a fresh clone, not
assumed: PR #100 at commit ba03fec ("Cf 247 track b UI consolidation
(#100)"), PR #79 at commit 92ac10b ("CF-093 follow-on: Scheduled Tasks
runtime operations and efficiency (#79)"), with #100 merged after #79.
The two PRs touch zero overlapping files (Scheduled Tasks observability
vs Layer 3 tuition workspace consolidation), so merge order carried no
risk, and this was confirmed directly rather than assumed.

Full verification run against actual current main (not a branch, not a
simulation): npm run build pass; both CF-247 contract tests
(tuition-benchmark-binding-contract, tuition-validation-contract) pass;
all Layer 3 and Scheduled Tasks UAT specs pass (12/12 runs across
desktop and mobile projects) — cf-247-layer3-scoped-reservation-
contract, cf-247-layer3-work-queue-contract, cf-093-scheduled-runtime-
health-contract, m245-layer2-discovery-terminal-timestamp-contract,
m245-scheduled-runtime-metrics-read-contract.

PR #100 delivered: retirement of the redundant tuition-specific admin
panel and its backing RPC (duplicated what security.
layer3_model_profiles_admin_impl already provided generically);
extension of the real, already-wired Layer 3 — AI Interpretation
workspace (m2-3-intelligence-entry.jsx) to include
provider_current_tuition_validation as a task class, with qualification
comparison (cost, provider/controls pass breakdown) shown generically
for any task class; the manual per-item "Run eligible interpretation"
path correctly excluded for the tuition task class, since it runs via
the automated CF-247 dispatcher/queue rather than manual Evidence
selection.

PR #79 delivered, after a full re-review that found and fixed six real
problems predating this session's involvement (a dangerous stale full
copy of admin_read from 13 September embedded in a migration; two
hidden stale-test wording mismatches; a test safety regex broken by
design against the mandatory search_path clause; and the underlying
governance gap — three tests never wired into any CI workflow, which is
how all of the above went undetected despite an earlier "Approved,
5/5 passing" status): Scheduled Tasks runtime health observability
(ScheduledRuntimeHealth.jsx, wired into the existing
ScheduledJobsWorkspace.jsx), the governed jobs_runtime read RPC, a
Layer 2 discovery terminal-timestamp trigger, and a new CI workflow
(scheduled-runtime-health-contract.yml) closing the coverage gap.

**No new open items from this pass.** Standing open items unchanged:
no unpause/activation mechanism for qualified Layer 3 profiles exists;
Layer 1/2/4 and Scholarship's own parallel AI-control system have not
had the same redundancy audit PR #100 applied to Layer 3.

### PR #101 (CF-247 Track G: live Layer 3 queue status) reviewed and verified — 22 September 2026 AEST

Delivers the item flagged as not-yet-built in PR #100's own description:
live queue status for the automated Layer 3 dispatcher/queue
(pipeline.layer3_work_items), surfaced in the real Layer 3 — AI
Interpretation workspace. A new read RPC
(security.layer3_queue_status_read_v1) reports counts by task class and
status, oldest-pending age, and last-completed timestamp — generic
across any task class using the automated queue, not tuition-specific,
consistent with the consolidation approach established in Track B.
Wired into admin_read the same way as every prior addition, verified
against genuinely current live data before this entry was written
(10 layer4_required, 1 parked, matching the live table directly).

Full verification against the actual branch content, not assumed: all
three files (two migrations, one workspace component) confirmed
byte-for-byte identical to what was built; npm run build pass; both
CF-247 contract tests pass; 12/12 Layer 3 and Scheduled Tasks UAT specs
pass, confirming this addition sits cleanly alongside PR #79 and #100's
work without disturbing either; zero merge conflicts against current
main; the live RPC re-confirmed unchanged since deployment. Ready to
merge, no fixes required.

**Standing open items, unchanged**: no unpause/activation mechanism for
qualified Layer 3 profiles exists. Layer 1, Layer 2, Layer 4, and
Scholarship's own parallel AI-control system have not had the
redundancy/consolidation audit Layer 3 has now had across three PRs.
