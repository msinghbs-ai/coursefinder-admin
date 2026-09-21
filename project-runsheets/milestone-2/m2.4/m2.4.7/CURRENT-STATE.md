# M2.4.7 CURRENT STATE

**Status:** ACTIVE — END-TO-END AUTOMATED ADMISSION GAP IS THE PRIMARY DELIVERY TARGET  
**Opened:** 2026-09-15 AEST  
**Accepted Pilot baseline:** `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 paused until M2.4.9 GO  
**Primary programme authority:** `docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md` / `CF-CHG-20260915-247`  
**Operations/monitoring authority:** `docs/coursefinder-actionable-operations-monitoring-standard-v1.0.md`

## Accepted predecessor

M2.4.6 / CF-246 is CLOSED / PASS / FROZEN. Existing accepted Layer 1/2 authority, Evidence, identity, security and consumer contracts remain in force.

## Admission-first baseline

Starting accepted consumer baseline remains Search 33,105 courses; official-course URLs 527; intakes 487; English 520; provider-current tuition 161; website-admitted scholarships 0. Website/Zoho are curated read consumers and are not canonical authority.

RMIT controlled scale proved the architectural gap: 25/25 processed, 0 deterministic Layer 2 resolution, 25 `layer3_required`, 0 blocked, USD 0. No larger Layer 2 waves are authorised merely to enlarge undrained Layer 3 backlog.

## Gate D implementation/runtime truth — 17 September 2026

Durable Layer 3 work-queue primitives and fail-closed server-side enqueue/reservation/transition services are already deployed. Immutable tuition `candidate_context` is preserved from deterministic Layer 2 extraction into Layer 3 lineage. Runtime reconciliation found 610 explicit fee fall-out rows with proposed tuition candidate context; 598 retain fee-candidate arrays.

The tuition route `openrouter-provider-tuition-validation-v1` remains enabled but **paused / benchmark FAIL**, with limits 10 RPM, 25 requests/day and USD 0 cost ceiling. Automatic enqueue therefore correctly creates no tuition work while qualification is failing.

Latest trusted lifecycle counts are **2,511 `layer3_required` / 2,423 `resolved_l2` / 815 cancelled / 10 blocked**. Layer 3 work-item queue remains **0** and downstream admission throughput remains 0 items/hour. Evidence latest trusted total is **30,925**. These counts must be refreshed from authoritative runtime before being reported as current; lifecycle `status` is the backlog authority, not legacy `outcome_code`.

Pilot PR #99 (`cf-247-candidate-bound-layer3`) contains the fail-closed candidate-bound tuition contract. Its shared validators preserve exact deterministic Layer-2 amount/currency/basis/year membership, permit null rejection, and prohibit invention, annualisation, currency conversion, year mutation and basis strengthening. `layer3-interpret` still requires the final `provider_current_tuition_validation` candidate-context execution integration before live cohort execution.

## Qualification execution state

- Request **6324** completed FAIL: provider **0/4**, controls **2/4**, 13 calls, 18,799 input + 610 output tokens, USD 0, max latency 6.609 s. Profile remained paused.
- Narrow diagnostic commit `ea5d56b6f5489ee6948e4c4d2c4708caee4ff9bc` added candidate-focused Evidence context but changed transport to `json_object`. Deployed benchmark runtime v5 and request **6325** proved that transport was a regression: provider **0/4**, controls **0/4**, 11 calls, 6,678 input + 35 output tokens, USD 0, max latency 0.901 s.
- Pilot corrective head **`58115985856bace75fecb10422dea5220ea4cee4`** restores strict JSON-schema transport while retaining candidate-focused Evidence and all fail-closed validators. Exact source is deployed as `layer3-cf245-tuition-benchmark` runtime **v6** (`cf247-tuition-benchmark-v1.3.1-candidate-bound`).
- Governed qualification request **6326** has been submitted through `svc_cf245_run_tuition_benchmark(4)`. At the continuity cut it remains present in `net.http_request_queue` with the correct Edge Function URL and 120-second timeout; no terminal HTTP response or benchmark result exists yet. Do **not** submit another qualification until 6326 is resolved.
- The four positive benchmark records were revalidated against canonical `catalogue.course_fees` + retained `pipeline.evidence_artifacts`: all are UQ international `indicative_annual` 2027 AUD facts (48,080 / 56,800 / 60,952) with retained Evidence and matching 2027 source URLs. Retained HTML exact-text verification remains the next diagnostic only if strict-schema request 6326 still fails semantic positives.

## Layer 3 qualification/routing correction — 18 September 2026

A continuity drift was identified between the programme architecture and Gate-D execution wording. The programme design already defines Layer 4 as terminal human resolution for ambiguous, conflicting, low-confidence or validator-failed interpretation. Therefore a model that safely refuses to infer an unsupported annual/indicative basis is behaving correctly; that item must move to Layer 4 rather than block the entire Layer 3 route.

Qualification must now demonstrate both safe positive resolution and safe abstention/exception routing. Universal positive resolution is not a prerequisite for a bounded cohort. The strict candidate-bound validator remains unchanged: no invention, annualisation, currency conversion, year mutation, audience mutation or unsupported basis strengthening.

## Mandatory scheduled-execution invariant

M247-FU-020/021/022 remain mandatory. Scheduled runs are execution-first, must carry forward the exact next operation, and may claim DATA ADMISSION only with authoritative before/after proof across L2 → L3 → deterministic admission/L4 → canonical field delta → Search/API projection/no-op plus Evidence/model/resource telemetry. Otherwise report **NO DATA ADMISSION PROVEN**.

## Exact next action

1. Treat request **6326** as historical qualification evidence: provider positives failed while safety controls passed; its UQ abstentions are not by themselves proof of an unsafe model because the retained Evidence does not explicitly establish the disputed annual/indicative basis.
2. Make the smallest forward-only qualification/routing correction so safe abstention/ambiguity is an accepted Layer 3 outcome only when the durable work item is handed to Layer 4 with Evidence, candidate context, reason, interpretation/audit record and model telemetry.
3. Require exact-head CI/UAT for that correction, then run a bounded 10–25 existing Evidence-backed tuition cohort. Admit only explicitly validated authorised candidates; route unresolved/ambiguous/rejected/low-confidence outcomes to Layer 4.
4. Capture M247-FU-021 before/after proof through L2 → L3 result → deterministic admission or L4 → canonical delta → Search/API delta/no-op.
5. Do not resume broader AU waves until bounded live drain is proven.

**NO DATA ADMISSION PROVEN** at this continuity point.

## Superseding runtime state — 18 September 2026 01:20 UTC

This section supersedes the older request-6326/paused-profile handoff above where inconsistent.

- Pilot PR #99 exact head: `910925ffe5c2ed7549a203cf7943a7497b151220`; exact-head Frontend Build `35294774026/#2465` PASS.
- Deployed Pilot runtime: service-owned `layer3-work-interpret` v5; `layer3-work-dispatch` v3; tuition benchmark v11. Forward migrations add durable Layer-4 exception disposition, current service-role claim compatibility, server-owned private Evidence context, quota preflight and actual-provider-call quota accounting.
- Qualification PASS: request 6331 / run `76ba93df-7a0b-4646-be85-a22c6a548b49`, provider 4/4, controls 4/4, semantic provider 4, semantic controls 3, 10 calls, 12,460 input + 1,196 output tokens, USD 0. Profile is unpaused.
- Bounded cohort size 10. Current durable result: **3 `layer4_required`; 7 `failed`/retryable at attempt_count=3; 0 validated/admitted**. Three new Layer-4 reviews were created with Evidence/candidate/interpretation handover.
- Current counts: L2 2,511 `layer3_required` / 2,423 `resolved_l2` / 815 cancelled / 10 blocked; L4 pending 51; Evidence 30,925; `catalogue.course_fees` 79,730; Search documents 33,105.
- Cohort telemetry: 4 actual live provider calls, 40,839 input + 2,256 output tokens, USD 0, max live latency 22,923 ms.
- Quota telemetry is now based on actual `external_call_count`, not interpretation-row count, and includes benchmark calls. Current day total: **55 actual calls = 4 live + 51 benchmark**, configured limit 25, headroom 0; 69,096 input + 5,190 output tokens; USD 0. Reset 2026-09-19 00:00 UTC / 05:30 IST.
- Dispatcher v3 preflight request 6336 returned `quota_blocked=true`, reserved 0, dispatched 0. No retry attempts should be consumed while headroom remains zero.
- **NO DATA ADMISSION PROVEN**: canonical tuition and Search document counts did not change and no cohort item validated.

### Exact resume action

At/after quota reset, refresh actual call headroom. If positive, retry **only the same seven failed cohort items** using the quota-bounded dispatcher. Do not enqueue additional tuition work. Continue any validated item through deterministic admission/Search proof; route unresolved items to Layer 4. Preserve the complete M247-FU-021 bundle.

## Superseding current state — 21 September 2026 02:15 UTC

- PR #99 exact head is `9b05918bcc59a1d68da54e1bbc6b9c15c6d9b051`; Frontend Build `35555240917/#2478` and Release History Contract `35555240881/#156` PASS. The candidate-bound test is now an executed CI step. Gitar reports no issues; PR remains draft.
- Candidate validation is now bound only to `candidate_context.provider_current_tuition`; competing fees cannot substitute. Non-null results require `identity_match=true` and explicit international audience. Null remains safe abstention.
- Deployed Edge runtime remains benchmark v11 / interpreter v5 / dispatcher v4. Repository repairs are therefore not deployed proof.
- Live lifecycle is 2,511 L2 `layer3_required`; L3 work 10 `layer4_required` + 1 `parked`; L4 pending 59. The parked item `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` has candidate context, attempt_count 6 and no active reservation. Do not retry it before dispatcher, benchmark binding and admission gates are exact-head validated/deployed.
- Evidence is 32,040; field admissions 1,216; fees 79,730; Search documents 33,105. No canonical/Search delta is attributable to CF-247. **NO DATA ADMISSION PROVEN.**
- Manual execution is primary while active. The enabled hourly `CF-247 Gitar Closure` task is failover, detects in-flight work and takes over only when manual work is idle/stalled.

## Verified runtime update — 21 September 2026 14:05 AEST

- Pilot PR #99: `c8866b573480b337ed86494f9817c98c69629c79`, draft/open/mergeable; Gitar review 5/5 closed.
- Exact-head CI: Pilot Frontend Build `35555931223 / #2479` PASS; Release History Contract `35555931237 / #157` PASS.
- Pilot migration: `20260921040446_cf247_task_profile_scoped_reservation` applied forward-only.
- Runtime dispatcher: `layer3-work-dispatch` ACTIVE v5; hash `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`; exact-head source calls `layer3_reserve_scoped_work_service` and no longer calls the legacy global RPC.
- Runtime authority: scoped RPC is executable only by postgres/service_role and binds exact task class/profile; legacy RPC is retired fail-closed.
- Work queue: 10 `layer4_required` + 1 `parked`. Target `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` remains parked, attempt 6, corrective retry count 1, unreserved; no mutation this run.
- Counts: Evidence 32,040; `catalogue.course_fees` 79,730. UTC-day live calls 0, benchmark calls 0, tokens 0/0, cost USD 0, max live latency 0 ms.
- DATA ADMISSION remains unproven; no canonical or Search/API delta is claimed.
- Next: slice 3 benchmark binding only. The parked item and new cohorts remain untouched.

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
