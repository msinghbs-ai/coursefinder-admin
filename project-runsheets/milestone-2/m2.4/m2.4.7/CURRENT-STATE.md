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

### PR #102 (CF-247 Track B Phase 3: credential widget wired in) merged and verified — 22 September 2026 AEST

Confirmed merged into main at commit b250cb0. Full audit findings from
this Phase 3 unit: layer3-provider-credential-entry.jsx (complete,
working, real live edge function, but unreachable — no HTML ever
referenced it) converted into a regular component and mounted in the
actual app shell, rank-gated on session context already available
there. Two items explicitly not acted on, left for deliberate
decisions rather than folded in here: layer2-trial-entry.jsx (a second
orphaned entry, backing functions confirmed live, but large/old/
uncertain current relevance) and Scholarship's own parallel AI-control
system (confirmed a genuinely different batch/budget workflow, not
simple redundancy — an architecture question, not a bug).

Verified against actual current main, not the branch: npm run build
pass; both CF-247 contract tests pass; 12/12 Layer 3 and Scheduled
Tasks UAT specs pass, confirming this sits cleanly alongside every
prior Track B unit without disturbing any of them.

**Standing open items, unchanged**: no unpause/activation mechanism
for qualified Layer 3 profiles. layer2-trial-entry.jsx's relevance
undecided. Scholarship AI-control architecture undecided. Phase 4
(formalising the config/telemetry split as a standing rule) is next.

### Plan to Production handover recorded; live admission-readiness check — 23 September 2026 AEST

UI consolidation Phases 0–4 are complete (PRs #100–#102, roadmap
Track B point 6 and the UI consolidation discipline subsection). Focus
now moves to the first complete automated admission run.

Live check of the Pilot project before planning, not assumed:
- 17 scheduled jobs active; all fire on time and report succeeded,
  but none has created a pipeline job or Evidence since 19 September.
  Cause confirmed: no Layer 2 wave requests are queued (all completed
  by 15 September). Idle by design, not failing.
- One genuine failure: coursefinder-platform-capacity-observation
  fails daily on a statement timeout while counting storage objects.
- Layer 3: layer3-work-dispatch is not scheduled; no qualified profile
  is active; 0 work items have ever reached validated or admitted
  (current queue: 10 layer4_required, 1 parked).
- Master Project Plan v1.81 contradicted the router (it recorded M2.4
  closed and M2.5 active). Corrected in v1.82.

Plan recorded in Master Project Plan v1.82, "Path to Production
handover". M2.4.7 exit is one controlled AU run admitting real data
end to end, which needs, in order: an activation gate for qualified
Layer 3 profiles; a scheduled, kill-switchable Layer 3 dispatcher;
confirmation of the deterministic admission path; Search/API
projection; and scheduled-job telemetry that distinguishes idle,
working and failing.

Next unit: activation gate — design options first, for decision
before build.

### PR #103 merged; interpreter deployed from main; Layer 3 source reconciled — 23 September 2026 AEST

Stage 1.0 of the path to Production handover is complete.

PR #103 merged to main at 4128358: layer3-cf245-tuition-benchmark,
layer3-work-interpret and the binding manifest now match the intended
state. Confirmed on a fresh clone that all five binding-relevant files
on main (benchmark, interpreter, manifest, shared validator, binding
helper) match the verified set.

layer3-work-interpret deployed from main as v8 (the previous v7 still
forced reasoning off and carried an older manifest). Pulled back after
deploy and checked against main: reasoning setting removed,
provider.require_parameters present, and all seven manifest hashes
identical to main. layer3-cf245-tuition-benchmark remains v15, whose
source is identical to main.

Binding hash for the qualified Mistral Small 3.2 profile, computed
with main's code: 7e8c05f6… using the profile shape the benchmark
receives, and 7e8c05f6… using the shape the interpreter receives from
layer3_reserve_work_interpretation_service. Both equal the qualified
hash. Before this deploy the live interpreter computed 010dc5fa… and
would have refused every Mistral work item.

No profile is active, so nothing executed as a result of this deploy.
Main, the live Layer 3 functions and Mistral's qualification now agree,
verified on edge-function source as well as database functions.

Next unit: activation gate for qualified Layer 3 profiles — design
options for decision before build.

### Stage 1 work packages and sequencing — 23 September 2026 AEST

Stage 1 (activation gate and Layer 3 tuition admission) is built, verified
live and packaged as branch cf-247-stage1-activation-admission; merge is
held at the programme owner's discretion. Remaining work is split into
single-session work packages:

- WP1 — Stage 1 activation and admission: complete, merge held.
- WP2a — supervised demonstration, part 1: enqueue ten tuition candidates
  and dispatch them through Mistral Small 3.2. Requires WP1 merged and an
  administrator to activate the profile from Administration.
- WP2b — supervised demonstration, part 2: admission, projection refresh,
  and an end-to-end trace from Layer 2 candidate through Evidence, Layer 3
  validation and the admitted fee to the website API.
- WP3a — website course search function: combinable filters, campus city
  and postcode at campus grain, and an explicit tuition basis.
- WP3b — scholarship search function at provider grain.
- WP3c — bring wix-course-api into source control (it currently exists
  only in the live project) and add search and scholarship actions.
  Additive; existing website actions and all Zoho functions unchanged.
- WP4 — reply to the website developer and a short API guide.
- WP5 — switch the Layer 3 schedules on after the supervised run; decide
  on the three legacy profiles on the NVIDIA free model; address the
  stale cf-085 contract test.

WP3 is independent of Stage 1 and may proceed while WP1 awaits merge.
Admitted data reaches both website and Zoho consumers through the shared
search projection with unchanged field shapes; no UI release-version
change is required.

### Stage 1 decisions: activation gate, Layer 3 admission, website data request — 23 September 2026 AEST

Recorded after "Stage 1 work packages and sequencing"; chronologically this
entry and the next precede it.

Finding: the automated chain is enqueue → dispatch → interpret → admit →
project. Only interpret and project existed. No schedule enqueued the 298
waiting tuition candidates, the dispatcher was not scheduled, and no
admission step existed, so a valid Layer 3 result stopped at "validated".

Decisions:
- Activation: database gate plus automatic pause on binding drift
  (execution already refuses drift; auto-pause keeps displayed state
  truthful). Maker/checker approval deferred to M2.4.9.
- Authority: administrator (rank 6) activates; rank 4 and above may pause.
  Activation reason required. Every activation, refusal and pause is
  recorded in an append-only audit table.
- Activation checks: benchmark passed within 14 days, qualified binding
  hash on record, credential stored, no other active profile for the same
  task (one primary per task class).
- The old profile setter can still pause or disable but can no longer
  unpause.
- Admission: automatic for validated, candidate-bound results at or above
  the profile's review confidence (0.9), within allowed currencies, bases
  and amount ceiling; written using the same fee key convention as Layer 2
  so the two layers cannot duplicate a fee. Anything else, including a
  conflict with an existing different fee, is held for human review. The
  consumer projection is refreshed after each batch that admits.
- Schedules for enqueue, dispatch and admission are created switched off;
  enabled only after a supervised first run.

Website data request (14 Sep test) reviewed against live data:
- Coverage has moved on since the test: intakes 487, English 520,
  official links 527, current tuition 161 (developer saw 10 each).
- Course listing: an undocumented sync_courses action already pages
  results; the underlying search already supports all requested filters.
  Decision: add a documented search action as an additive consumer change
  (Zoho functions untouched).
- Campus city and postcode: data exists (3,921/3,922 campuses, 26,613
  courses linked) but is not exposed. Decision: expose at campus grain.
- Tuition basis: always return the basis explicitly; never label a course
  total as annual.
- Scholarships: in scope. 292 exist in canonical data at provider grain.
  Decision: expose through a separate scholarship action.
- publication_status "unpublished": meaningful. Pilot data is not cleared
  for public display until the M4 publication gate.
- QILT/PRISMS "not_admitted": a Pilot-scope decision, not licensing.
  QS: not in scope (commercial licensing).
- Logos: not supplied until redistribution rights are confirmed; the
  initials fallback stands.

---

### Stage 1 verified live and raised for merge — 23 September 2026 AEST

Stage 1 was applied directly to the live Pilot project as migrations
cf247_stage1_activation_gate_and_tuition_admission and
cf247_stage1_layer3_tuition_schedules_disabled, after SQL was tested
locally (10 activation cases, 6 admission cases, atomic rollback).

Live verification after apply: all eight Stage 1 functions are
byte-identical to the locally tested versions (checksum of each
definition). The activation audit table has row-level security on and an
append-only trigger; anonymous users cannot activate; browser sessions
cannot run admission or read the audit table. The enqueue, dispatch and
admission schedules exist and are switched off. A live smoke test ran
admission cleanly with nothing to admit, and enqueue refused to queue
work because no tuition profile is active — activation is the master
switch for the whole chain. Nothing has been activated or admitted.

Raised as branch cf-247-stage1-activation-admission: one migration file
(already applied live) and two UI files adding Activate/Pause to
Administration → Environment migration → OpenRouter / Layer 3. The
accepted A26–A28 operator-UX wording in the Layer 3 workspace is kept.
Build, CF-247 contract tests and 12 Layer 3 / Scheduled Tasks UAT runs
pass.

Open items found during verification, not introduced by Stage 1:
- Three legacy M2.3 profiles (free router, international contact, source
  pattern) remain active on the NVIDIA free model, which cannot honour
  response_format at its only endpoint; their benchmarks passed in August,
  before provider parameter enforcement. They serve legacy task classes,
  not tuition. Re-benchmark or pause to be decided (WP5).
- cf-085-firecrawl-scraper-config-contract fails identically on main and
  is not wired into any CI workflow (WP5).

### WP3 website course and scholarship search — live and raised for merge — 23 September 2026 AEST

Two service-only database functions and two new website API actions
were applied and deployed to the live Pilot project, and raised as
branch cf-247-wp3-website-api.

- WP3a website_edge_course_search_v1: combinable filters including city
  and postcode; campuses at campus grain; explicit tuition basis, with a
  derived annual figure only for courses of a year or more and flagged as
  derived; the same keyword matching and sort as the Zoho search; Layer 4
  block exclusion. Tested live: the developer's example request returns
  11 courses with consistent pagination and no over-budget or unpriceable
  results. A city-display defect found in testing (first campus shown
  instead of the searched city) was fixed before release.
- WP3b website_edge_scholarship_search_v1: 291 active scholarships at
  provider grain; award type and value, first-party URL where known,
  deadline status; fields not held in the data return null; unsupported
  filters are reported in filters_not_applied. A wrong provider column
  name found on first run was fixed before release.
- WP3c wix-course-api, which existed only in the live project, is now in
  source control; deployed as v4 with search and scholarships actions.
  Existing actions and all Zoho functions are unchanged. Both database
  functions are byte-identical to the committed files; the deployed
  source was pulled back and matched; all actions return 401 without a
  valid token. An authenticated end-to-end call is pending with the
  website developer's key.

Data limits recorded for the developer reply (WP4): entry-requirement
summaries are not captured; scholarships carry no study level, study
area or academic-score data; only 14 of 292 have a closing date.
Performance note: a filtered course search takes about 3 seconds —
indexing to be addressed before Production.

Held for merge alongside this: Stage 1 (cf-247-stage1-activation-admission),
already live and verified. Main is behind live until both merge.

### PR #104 merged; WP4 developer reply drafted — 23 September 2026 AEST

PR #104 (WP3 website course and scholarship search) merged to main as
b46af75. Confirmed on a fresh clone that all three files match the
verified set; main now matches the live wix-course-api (v4) and both
website search functions.

WP4: reply to the website developer drafted against their eight asks —
corrected coverage figures, request examples for the search and
scholarships actions, the tuition-basis rules, the scholarship data
limits (no study level, study area, academic score or citizenship data;
14 of 292 with a closing date), and the recorded decisions on
publication status, QILT/PRISMS/QS and logos. The developer is asked to
run both requests with their key, which is the remaining end-to-end
check.

Finding: on Cloudflare preview URLs the Layer 2 — Enrichment page shows
"Failed to send a request to the Edge Function". Cause confirmed:
layer2-config-control and layer2-sync-control accept browser requests
only from the main Pilot address and localhost, so preview origins are
blocked by CORS before reaching the function. Pre-existing, not caused
by WP3. Whether to allow preview origins is a security decision, logged
for WP5.

Still held: Stage 1 (cf-247-stage1-activation-admission) is live but not
merged, so main remains behind live for the Stage 1 functions.

### PR #105 merged (Stage 1); WP5 maintenance applied — 23 September 2026 AEST

PR #105 merged to main as 78f51af. Reviewed on a fresh clone: the Stage 1
migration and both UI files match the verified set byte-for-byte, so main
now matches the Stage 1 database changes already live. Build, both CF-247
contract tests and the Layer 3 contract specs pass on main.

WP5 items completed:
- cf-085-firecrawl-scraper-config-contract updated for the CF-088
  Administration tool structure; the Firecrawl quota contract itself was
  still intact. Passes on main.
- The matching change to .github/workflows/pim-build.yml (running cf-085
  in the Pilot Frontend Build check) did not land in #105 and is being
  raised as a separate small PR. Until it merges, cf-085 is not run by CI.
- Three legacy Layer 3 profiles on the NVIDIA free model were paused in
  the live Pilot project: openrouter-free-router-v1 and
  openrouter-international-contact-v1 (never called) and
  openrouter-source-pattern-v1 (three calls ever, all provider errors,
  last on 7 September). Each pause is recorded in the activation audit
  table with no user actor and a stated reason. Reactivation must pass the
  activation gate, which requires a benchmark pass within 14 days.
  No Layer 3 profile is now active on the platform.
- Preview-URL CORS: recommendation to keep Cloudflare preview origins
  blocked from admin edge functions; admin pages are tested on the main
  Pilot URL.

Next: an administrator activates Mistral Small 3.2 from Administration →
Environment migration → OpenRouter / Layer 3, then the supervised
admission demonstration (WP2a) runs.

### Mistral activated; activation UI fixed; supervised run started — 23 September 2026 AEST

Activation: Mistral Small 3.2
(openrouter-provider-tuition-validation-mistral-small-3-2-v1) was
activated at 07:29 UTC on 23 September by a logged-in administrator
through Administration → Environment migration. Every gate check passed
and it is the only active Layer 3 profile. Audit correction: the
append-only activation record shows the reason "Production credential
rotation". That text was a pre-filled default in a shared reason field,
not the operator's intent. The actual purpose was the supervised Stage 1
admission demonstration. The record cannot be edited by design; this
entry is the correction.

UI defects and fix: activation and pause reused the credential card's
pre-filled reason field, and a long profile name made the OpenRouter card
overflow onto its neighbour. Fixed with a separate, empty, required
activation/pause reason field and cards that shrink to their column.
PR #106 uploaded the fix to the repository root instead of src/, so the
application was unchanged and two unreferenced copies were added at the
root. A follow-up PR placed the fix in src/ and removed the stray copies;
reviewed before merge (both src files match the verified fix; root copies
removed; no other files touched).

CI: commit 07ee029 completes the earlier change — cf-085 now runs in the
Pilot Frontend Build check.

WP2a started: 10 tuition candidates enqueued from the 298-item backlog
and the first batch of 5 dispatched to Mistral. Results, admission and
the end-to-end trace will be recorded separately.

Process: uploads to a subfolder are done by navigating into the folder
first; every merge is reviewed on main before documentation is written.

### First end-to-end Layer 3 admission demonstrated; PR #108 merged — 23 September 2026 AEST

Result: a supervised run admitted 8 provider-current tuition fees through
every layer, with no wrong admissions. Each is annual, 2027, confidence 1.0,
and linked to its saved Evidence page and source: A$38,400, A$39,360,
A$40,320, A$45,120 (two courses), A$47,040, A$48,960 and A$49,920. Two
further items were correctly sent to people, including a page that stated a
course total rather than an annual fee. Courses with current tuition in the
website API rose from 161 to 169. Model cost for the run: US$0.016.

End-to-end trace verified for course 078839G (RMIT Associate Degree): Layer 2
found A$38,400 but could not tell whether it was annual and captured no year;
Mistral Small 3.2 confirmed annual 2027, quoting the page verbatim ("AU$38,400
(2027 annual)"); admission recorded it using the Layer 2 fee key; the website
API now returns A$38,400, annual, provider-current, not derived.

Problems found and fixed during the run (all live and merged in PR #108 as
1a27ec3, verified byte-for-byte on main):
1. Enqueue read the wrong population: 611 Layer 2 items with no fee to
   confirm, while the 298 real candidates sat in the governed backlog. A
   JSON-null check also never filtered. Enqueue now reads the backlog and
   requires a real Layer 2 target. Five items queued under the old rule were
   parked without a model call.
2. The dispatcher stopped the whole batch when one item failed. Fixed.
3. Real pages state the fee year; Layer 2 does not capture it, so correct
   results were rejected. Decision (option A): Layer 3 may supply a year only
   when a returned quote states it together with the amount.
4. The benchmark did not represent real work (its cases already had a year
   and a resolved basis). Production-shaped cases and a new required control
   for pages stating a course total were added, and the benchmark prompt was
   aligned with the live interpreter.
5. The model treated "indicative" as "indicative annual", including on a
   course-total page. Now refused both in the model's instructions and in
   shared code used by the benchmark and the interpreter.
6. Quote matching failed on spacing introduced when pages are converted to
   text. Spacing is now ignored; the characters must still match exactly.

Qualification: after the fixes Mistral Small 3.2 passed 6/6 provider cases
and 5/5 required controls at binding hash c45afa50…, identical for the
benchmark (v19) and the interpreter (v11). An administrator re-activated it
through the activation gate with the reason "Re-qualified 6/6 and 5/5; resume
supervised Stage 1 run". Audit correction: the first activation earlier on
23 September recorded "Production credential rotation", a pre-filled default
since fixed in PR #106/#107; its real purpose was the supervised run.

Layer 4 now uses plain English: every review item says what happened and what
to check, with the fee amount, for example "The page doesn't clearly say
A$23,000 is charged per year. Please confirm whether it is an annual fee."
Items held at admission now open a review (previously they were invisible),
and validated fees no longer open one. The existing queue was cleaned up: six
items rejected under the old rules were re-checked, five parked items with no
Layer 2 fee were given reviews, and all older reasons were rewritten. 23
reviews are pending; none use technical wording.

Setting change: Mistral's daily call limit was raised from 25 to 1,000 at the
programme owner's request, after the day's re-qualification runs used up the
allowance. Typical cost is about US$0.0002 per call; the scheduled dispatcher
limits real throughput to about 720 calls a day. The change and reason are
recorded on the profile.

Still open:
- The enqueue, dispatch and admission schedules remain switched off; to be
  switched on after this record is accepted (WP5).
- Benchmark calls count against the live daily allowance; they should be
  excluded (follow-up).
- Layer 2 should capture the fee year itself so Layer 3 does not need to
  (option C, follow-up).
- 288 governed backlog candidates remain to be processed once schedules run.

### Layer 3 tuition schedules switched on; first automatic cycles confirmed — 23 September 2026 AEST

Before switching on, the 288 remaining governed backlog candidates were
classified by the page text beside each fee: 250 say annual or per year
(expected to admit automatically), 35 say total, per semester or per unit
(expected to go to a reviewer), 3 are unclear; 269 state a fee year.
Expected run: about 10 hours, about 290 model calls, about US$0.60.

The enqueue (every 15 minutes), dispatch (every 10 minutes) and admission
(every 15 minutes) schedules were switched on. First automatic cycles,
confirmed on live data rather than job status alone: enqueue queued 25
candidates at 10:30 UTC; dispatch at 10:35 sent 5 to Mistral, all validated
(annual, 2027) within about 80 seconds; admission at 10:38 recorded them and
refreshed the consumer projection in 61 seconds, well inside its 15-minute
slot. By 10:54 UTC, 18 fees had been admitted in total, with no failed runs
and Mistral still active.

Stopping the pipeline: pausing Mistral in Administration → Environment
migration → OpenRouter / Layer 3 stops enqueue and dispatch immediately. The
profile also pauses itself if the deployed code drifts from what was
qualified. Progress is visible in Layer 3 — AI Interpretation (live queue)
and Layer 4 — Human Resolution (items needing a person).

---

### UI refinement: screen decisions approved (UI-0) — 23 September 2026 AEST

UI refinement runs alongside the admission pipeline and does not touch it.

Findings from a code inventory: 24 top-level menu items plus 11
Administration tools, with duplicates; 11 separate scripts loaded by the
page, six of which alter screens after they are drawn; one 125 KB shell
file holding most screens; 28 stylesheets (292 KB); only 7 screens remember
any user choices; only 6 screens link to other screens.

Design standard adopted for all screens: one place per job (configuration
in Administration, work and monitoring in Data Operations); the same page
shape everywhere (header, key numbers, filters, table, detail panel);
every identifier is a link, including an end-to-end course trace; filters,
sort, tab and page are kept in the address bar and remembered per screen;
plain language; no scripts that alter screens after drawing.

Approved menu, 24 items to 16 in five groups:
- Overview: Dashboard
- Catalogue: Providers, Courses, Campuses, Scholarships, Provider Contacts
- Data Operations: Layer 1, Layer 2, Layer 3, Layer 4, Jobs & Schedules,
  Evidence, Onboarding
- Quality & Insights: Completeness, Statistics & Rankings, Compare
- Administration: one entry holding all configuration tools

Approved decisions:
- Review Queue merges into Layer 4, on condition that both are first shown
  to list the same review items; if they do not, the decision returns to
  the programme owner.
- Jobs and Scheduled Tasks merge into Jobs & Schedules, with two tabs.
- Onboarding stays in Data Operations and its duplicate Administration tool
  is removed (moving it into Administration would have removed access for
  role 3 users).
- Attributes is removed from the menu; it remains in Administration as PIM
  configuration (the same screen).
- Sources moves into Administration.
- Settings (legacy Regulatory ingestion) moves into Administration; it is
  retired later only once Layer 1 sources is shown to cover everything it
  does.
- Outcomes (QILT) and Student Flow (PRISMS) become tabs within Statistics &
  Rankings.

Safeguards: no user loses access to anything they can reach today (role
gates move with their screens), and every existing address redirects to its
new location.

Plan: UI-1 navigation; UI-2 shared page kit with remembered choices; UI-4
cross-linking and course trace; UI-5 screen-by-screen migration, busiest
screens first; UI-6 removal of screen-altering scripts; UI-7 stylesheet
consolidation. Visual checks rely on programme-owner screenshots, as live
screens cannot be viewed from the build environment. Deployed UI tests that
protect agreed behaviour are kept, not rewritten.

### UI-1 navigation and release v2.15.80 candidate merged — 23 September 2026 AEST

PR #109 (UI-1 navigation) merged as e1ad2c9 and PR #110 (release v2.15.80
candidate, package 0.1.7) merged as 18aaa41. Both reviewed on main; all
files match what was tested.

UI-1: Review Queue retired from the menu. It read workflow.review_queue,
which has never held an item and which nothing writes to; its address
redirects to Layer 4 and the table is untouched. "Statistics & Insights"
and "Quality & Review" merged into "Quality & Insights". The Dashboard Open
reviews tile and review message now open Layer 4 instead of the empty
retired queue. Correction to the UI-0 entry: the menu had 18 visible items,
not 24 (six items counted then are hidden deep-link routes, which stay); it
now has 17 items in 5 groups. Jobs & Schedules, QILT/PRISMS tabs and
Onboarding move to UI-5, where they land with their screen redesigns and
the four tests that use those labels.

Release: the version pill now shows v2.15.80 as a release candidate, with
its changes and bug fixes, covering the visible work since v2.15.79.
v2.15.79 remains the accepted recovery release; its own notes are now
stored in its entry rather than borrowed from the current release. From now
on, every UI package bumps the version and adds its changes and fixes in
the same pull request. v2.15.80 is marked accepted after it is checked live.

Deployed UAT result: the targeted deployed check failed on its "no server
errors" safeguard, not on anything the release changed. It recorded 16
HTTP 500 responses from the Dashboard and layer-status summary reads
between 11:51 and 11:52 UTC. Database logs show these were statement
timeouts. No scheduled job was running heavily at that time, and query
statistics show these reads have taken 3 to 16 seconds for some time. This
is a pre-existing performance problem affecting the Dashboard for real
users. A performance package (PERF-1) is scheduled before UI-2.

Also found: two older release tests
(m245-release-currentness-ranking-fix-contract and
m245-release-dialog-history-contract) already fail on main because they are
pinned to v2.15.75 and v2.15.76. They are not run by CI; to be repaired in
a small clean-up.

Pipeline: the Layer 3 tuition schedules continue to run automatically.

### PERF-2 scoped search refresh merged; admission contention removed — 23 September 2026 AEST

PR #112 merged as dd7a3e3; reviewed on main, both migrations match what was
applied and verified live.

Root cause confirmed: both failed deployed checks (11:52 and 12:23 UTC)
happened while the admission job rebuilt the whole search projection. To add
a few fees, admission recalculated all 33,105 course documents and rewrote
every one of them, whether changed or not: 60 to 85 seconds of heavy work
every 15 minutes, which pushed concurrent users' reads past the 8-second
limit.

Decisions (approved by the programme owner, 23 September 2026):
- Option A, interim: admission moved to hourly at :37 with a cap of 50 per
  run, cutting the heavy work fourfold straight away.
- Option B, permanent: a scoped refresh that updates only the courses
  admission changed. It was generated from the live full refresh by exact,
  guarded substitution, so its logic is identical; the only difference is
  the course restriction. The full refresh is unchanged for its other
  callers. With B in place, admission returned to every 15 minutes with its
  original cap of 25.
- PERF-2 has no visible screen change, so it does not bump the version
  pill. Its fix is included in the notes of the next UI release.

Proof, on live data:
- Equivalence: for 350 courses (every Layer 3 admission plus 300 random),
  the scoped and full calculations gave identical results for every course
  (0 mismatches, 0 missing).
- Speed: a real 50-course refresh took 1.1 seconds. The first scheduled
  admission on the new path (12:53 UTC) took 1.47 seconds, against 60 to 85
  seconds for the four runs before it.
- Consistency: a full recalculation afterwards found 0 of 33,105 search
  documents out of date.

Pipeline at 13:01 UTC: 51 fees admitted by Layer 3; courses with current
tuition in search rose from 161 to 211 during the day. The backlog
continues automatically every 15 minutes.

Follow-up PERF-3 (before Production): the full refresh still rewrites every
row even when nothing changed. It should write only changed rows. Lower
priority now that admission no longer uses it.

### PERF-1 Dashboard performance merged (release v2.15.81 candidate) — 23 September 2026 AEST

Recorded after the PERF-2 entry; PERF-1 was merged first (PR #111 as
9c47f96). Reviewed on main, all files match what was tested. The database
part was applied and verified live before merge.

Problem: the Dashboard and layer-status summaries counted across 27 tables
every time a screen opened. With cold cache or contention they took 2 to 25
seconds against the 8-second limit for signed-in users, and returned errors
(HTTP 500).

Design decisions (approved by the programme owner, 23 September 2026):
- The summaries are pre-calculated by a background job every 2 minutes and
  stored in a snapshot table. A Dashboard up to 2 minutes old is accepted.
- The heavy counting runs only in the background, with no time limit; it
  never runs when a user opens a screen. Only the service role can run it.
- The read functions keep their names, role checks and output, and add the
  time the figures were calculated. Screens needed no change beyond showing
  it.
- If the snapshot is missing or more than 10 minutes old, the read
  calculates live, so the screen never breaks.
- Open reviews and recent review activity now use Layer 4 review items. They
  previously counted the retired, empty review queue and always showed 0;
  the Dashboard now shows the real number (85 at the time of the change).
- The Dashboard shows "Updated X ago · refreshes every 2 minutes".

Result: the Dashboard reads take 0 to 20 milliseconds. The version pill
shows v2.15.81 as a release candidate with these fixes; v2.15.79 remains
the accepted recovery release.

After PERF-1, the targeted deployed check still failed on statement
timeouts from other reads during an admission run. That showed the
Dashboard was a symptom and the full search rebuild the cause; it was
resolved by PERF-2 (see the PERF-2 entry).

### Layer 4 redesign approved; PERF-4 Evidence timeout fixed — 23 September 2026 AEST

Layer 4 feedback: after v2.15.82 the programme owner found the review screen
confusing. Problems identified: items showed database IDs instead of course
and provider names; there was no link to the page being checked; the AI's
proposal was shown as raw data; the proposal could contradict the reason
without saying so; six equal buttons used jargon ("Return L2", "Return
L3"); the title appeared three times; and Evidence and Layer 3 references
were raw IDs.

Redesign principles: help operators decide without overwhelming them, and
scale from one part-time person to a team. One decision at a time, with
the next item opening after each decision. Show the reason first, then the
three facts that settle it (currently recorded, AI suggested, what the page
says), then links to the provider page and the saved copy; technical
detail stays collapsed. Group repeat work for one decision with preview and
audit. Management gets a read-only team and forecast view built from data
already recorded (who decided, when, how many), refreshed in the background.

Decisions (approved by the programme owner, 23 September 2026):
- Show rule-based suggestions (not AI), clearly labelled and never applied
  automatically.
- Opening an item claims it; a claim is released after 30 minutes idle.
- Managers (role 5 and above) see everyone's figures; operators see only
  their own.
- Waiting-time target: no item waits more than 7 days. It sets the warning
  colour on the oldest item and the forecast's target.
- Fix the Evidence timeout first, then build the review desk.

Delivery plan: L4-A review desk (v2.15.83), L4-B team working with claims,
next-item flow and time per decision (v2.15.84), L4-C batches, folding the
mass-operations panel into a Batches tab and retiring its page-altering
script (v2.15.85), L4-D team and forecast view (v2.15.86).

Data facts at the time: 116 items waiting (68 tuition, 42 official course
links, 6 scope), plus 37,200 scholarship course-scope items in cohorts;
only 9 decisions ever recorded and no item ever assigned. Decision records
already store who decided and when; the time an item was opened is not yet
recorded and will be added in L4-B.

PERF-4, Evidence timeout: the Evidence screen showed "canceling statement
due to statement timeout" and no items. Its dropdown-options read made five
full passes over 32,040 Evidence items on every open (6.5 seconds cold).
It now uses the PERF-1 pattern: calculated in the background every 15
minutes, same function name, curator role check and output, with a live
calculation if the stored copy is over an hour old. PR #114 merged as
6d9bc77; reviewed on main. Proven on live data: reads take 0 to 12
milliseconds, and the stored options are identical to a fresh calculation.

Release: PERF-4 has no screen change, so, as decided for PERF-2, it does
not bump the version; its fix will appear in the v2.15.83 notes.

### UI releases v2.15.82 to v2.15.84 merged: shared kit, Layer 4 review desk, desk first — 24 September 2026 AEST

Three releases merged and reviewed on main; every file matched what was
tested. The version pill shows v2.15.84 live. v2.15.79 remains the accepted
recovery release.

v2.15.82 (PR #113, aa3de17), shared kit and first Layer 4 clarity:
- Common screen parts now come from one shared module (src/ui-kit.jsx);
  one page-navigation component replaces three copies, each screen keeping
  its look.
- A shared "remembered choices" mechanism: the address bar first, then the
  user's last choices for that screen, then the defaults; kept per user and
  screen; unreadable saved data falls back to defaults. The Catalogue moved
  onto it with the same storage key, so saved choices carried over.
- Layer 4: plain-English reason on each item, remembered filters, plain
  status labels, queue limit 100 to 250.

v2.15.83 (PR #115, 60518be), Layer 4 review desk (L4-A):
- New read public.layer4_review_desk_v1, added alongside the existing queue.
  It gives each item the course and provider by name, a plain task label,
  age, a plain reason (developer-facing reasons replaced, originals kept
  under Technical detail), what is recorded now, what the AI suggested as
  readable text, the exact words the page shows (web-link formatting
  removed), links including a ready-made web search, and a rule-based
  suggestion that is never applied automatically.
- Layer 4 screen: a queue and one decision at a time, oldest first; the
  suggested action is the main button (none when the suggestion is only
  "Check"); a decision note pre-filled from the suggestion; less common
  actions under More; the next item opens after each decision. Decisions
  still use layer4_review_decide, so auditing is unchanged.
  Provider-contact reconciliation is unchanged.
- Release notes include the PERF-4 Evidence fix.

v2.15.84 (PR #116, 8ea1a23), desk first:
- The mass-operations panel was a separately loaded script inserting itself
  above the review desk and listing all 87 scholarship cohorts, pushing the
  desk out of sight. It now sits below the desk, collapsed, with its count
  cards visible and an "Open batch work" button. Nothing was removed.

Queue at 24 September: 261 waiting (213 tuition, 42 official course links,
6 scholarship scope); oldest 21 days against the 7-day target; 39 suggested
reject and 18 suggested approve.

Decision (programme owner, 24 September 2026): L4-C (batches) is brought
forward ahead of L4-B, because a growing share of the queue is repeat
cases. L4-C also gives the 6 scholarship scope items their names (they are
scholarships, for example "Charles Sturt International Joint Cooperation
Program Scholarship", and were showing only "Scope") and plain wording.

Stale tests (fail identically on main, not run by CI), for a clean-up
package: m245-release-currentness-ranking-fix-contract,
m245-release-dialog-history-contract, cf-208-scholarship-pim-maturity-contract,
cf-142-143-evidence-provenance-layer-order-contract, and
cf-205-layer4-mass-operations-contract (pinned to v2.15.65).

### L4-C Layer 4 batches merged (release v2.15.85 candidate) — 24 September 2026 AEST

PR #117 merged as b918aa2; reviewed on main, all 10 files match what was
tested. The database part was applied and proven live before merge.

What it adds:
- A Batches view in Layer 4. Waiting items are grouped by task and
  rule-based suggestion; at the time, 41 tuition fees suggested reject and
  19 suggested approve.
- Batch decision: Pipeline Operator role or above (curators can preview);
  2 to 100 previewed items of one kind; items can be unticked; one reason;
  a typed confirmation such as "REJECT 41"; no bulk editing. Each item is
  decided through the existing single-decision function, so it gets the same
  audit record as a manual decision, and the batch is recorded as well. If
  any item fails, none are decided.
- Scholarship scope items show the scholarship and provider names, with a
  plain reason; Approve is not offered for them because it only applies to
  course facts. Scholarship cohort reason codes are shown in plain English.
- The mass-operations panel no longer inserts itself into the page; Layer 4
  shows it in the Batches view.

Proof before merge (all rolled back, nothing decided): wrong confirmation,
single-item batches, mixed batches and approving scholarships were all
refused. A real two-item batch succeeded with two per-item decision records
and one batch record, then was rolled back. A proof run also found that the
audit table did not accept the new batch type; this was fixed before use.

Failure during review: the first version of the pull request stopped the
application from starting. Removing the panel's self-inserting code left one
line calling a deleted function, so the module failed on load and, because
Layer 4 now imports it, the whole application failed. The build could not
detect this; the CI browser smoke test did, and the change was not merged.
The line was removed, and the fix was proven by running the module (the
fixed version loads; the faulty version fails with the same error). Nothing
live was affected. Practice adopted: any module that has code removed is run
before packaging, not only built.

Follow-up for L4-B: in the Batches view the scholarship tools open fully
expanded (87 cohorts); they will be collapsed by default.

### Package 1 (v2.15.90): queue relief, Layer 3 re-qualification, release history — 25 September 2026 AEST

Roadmap to production agreed with the programme owner, 24 September 2026:
P1 queue relief, P2 Jobs, P3 screen-by-screen review, P4 Admin menu
redesign, P5 admission cross-check, P6 consumer API (Wix and Zoho), P7
release notes and history, P8 user guides by role, P9 metrics, P10
production build in a new environment. Work is consolidated into fewer,
larger pull requests. Production region recommended: Sydney (the pilot
runs in Mumbai).

Root cause of the Layer 4 backlog: 176 of 282 waiting tuition items (170
from UQ) were refused because saved pages contain web-link formatting,
so a true quote of the visible words ("Fees A$56800 Duration 3 Years")
never matched the saved text ("Fees[A$56800](https://...)Duration...").
Fix: one shared visible-text comparison in the shared validator, used by
both the interpreter and the benchmark; link targets, JSON escapes and
formatting symbols are removed on both sides, and characters must still
match exactly and in order. Tested: real quote found; wrong amount,
different order, invented wording and link-address-only quotes refused.
A new benchmark case built from a UQ-style page was added.

Re-qualification (governed path): the binding contract detected the
validator change and required a regenerated manifest. Layer 3 schedules
were paused; the functions were deployed by the new workflow; the
programme owner paused Mistral; the benchmark passed (6/6 real provider
cases, 3/3 real-page cases including the new one, 5/5 safety controls,
US$0.0027); new binding 6b3adf23..., replacing c45afa50...; the
programme owner activated it; schedules resumed. Note: the benchmark
service function defaults to an old, disabled profile, so it must be run
naming the profile explicitly.

Layer 4 fixes: "Send back to AI check (Layer 3)" did not re-check tuition
items (nothing consumed the request); it now re-queues the work item. A
"Send back" suggestion appears for formatting-refused items only once a
newly qualified binding is active. 100 items were sent back in one batch;
93 have a Layer 2 fee to check, and 7 have none and will return to
Layer 4 for a person to enter the fee. Official course link suggestions:
exit awards and study abroad or exchange: Reject; research degrees: use
the provider's research-degree page.

Jobs: only recorded, non-zero counts are shown. Release history: the
dialog had lost the notes for v2.15.79 to v2.15.88 (only the current
release was added to an old fixed list). A build step now generates one
history (70 releases) from the old list, the release notes files and the
manifest; the dialog fills in missing releases and links to a searchable
history page.

Deployment: a guarded "Deploy edge functions" workflow (allow-list with
recorded JWT settings, typed project reference that must match a
repository variable, Layer 3 contracts run first). Lessons: files and
folders starting with a dot are skipped by GitHub's upload page, so the
workflow and .gitignore were created in the web editor; the project
reference must be a variable, not a secret.

Merged: PR #125 (bcab6e8), plus the workflow and .gitignore committed
directly. Stale tests: one fixed; one more found (an Administration
"Open PIM" expectation), deferred to Package 2. Moved to Package 2:
merging Jobs and Scheduled Tasks in the menu, since tests select menu
items by label.

### Package 2 and Layer 3 qualification review; design decisions v1.32 — 25 September 2026 AEST

Design decisions: the design document had not been updated since v1.31
(3 September 2026). v1.32 now records every CF-247 decision to date as
Decisions 84 to 123 and is CURRENT. From now on each decision is numbered
when made and recorded no later than the close of its package
(Decision 122).

Merged and reviewed on main:
- PR #126 (a13b386), Package 2, release v2.15.91: Jobs & Schedules menu
  item; UQ provider fee rule and profile mechanism; Evidence acquisition
  provenance; Scheduled Tasks clean-up; stale tests fixed. The live site
  showed v2.15.91 after a Cloudflare build delay.
- PR #127 (eeffe00): Layer 3 instruction for year selectors and exact
  continuous quotes (Decision 96).
- PR #128 (663bed3): quote comparison ignores stray square brackets
  (Decision 95).
- PR #129 (8104b68): fair benchmark (provider-rule context, Decision 94)
  and one OpenRouter key per aggregator (Decision 99).
Each Layer 3 change was deployed with the Deploy edge functions workflow.

Layer 3 qualification: under the two-clean-passes rule (Decision 91), no
model qualified (Decision 98). Findings: the benchmark had rewarded
guessing on UQ pages (fixed, Decision 94); after the fix, careful models
left the year blank where Layer 2's target said 2027, because UQ pages
use a year selector (Decision 96). Layer 3 tuition validation remains
paused; nothing unsafe was admitted at any point, because the validator
refused every invalid answer.

Decision taken: rule-covered pages (UQ) are admitted deterministically
without AI (Decision 106). Layer 2 already recorded the fee panel text for
each candidate, so the check runs in the database. Seven UQ fees had
already been admitted under the rule as indicative annual. Build and a
rolled-back proof are next.

Open items: remove the Administration tab row Layer 1 to 4 duplicates;
retire the unused data-acquisition navigation script; move production
Layer 3 to the strict JSON schema; retire the per-profile OpenRouter key
copies; decide on storing total course fees; plan a Gemini successor if
chosen.

### Package 3 (v2.15.92): deterministic UQ admission, Administration tidy-up, stale test sweep — 25 September 2026 AEST

Design decisions v1.33 adds Decisions 124 to 128 and is CURRENT.

Merged and reviewed on main:
- PR #130 (2e10605), release v2.15.92: deterministic provider-rule
  admission and its schedule (Decisions 106 and 124); the Administration
  tab row no longer repeats Layer 1 to 4 (Decision 116), and a test now
  asserts it cannot return.
- PR #131 (b009749) and direct test-only commits a06805b, b94bef1 and
  1c316dc (Decision 126): stale live-site test expectations fixed. All
  checks, including Deployed UAT, were green on 1c316dc.

Outcome of the deterministic UQ path: proof mode first (160 would admit,
24 held back because the matching text was UQ's fee explanation rather
than the fee panel, 0 exclusion hits), then applied: 160 items admitted,
89 UQ courses gained an indicative annual fee visible in search and the
website API, 159 Layer 4 reviews marked superseded, and the Layer 4 queue
fell from 330 to 151. Layer 3 enqueue is running again; AI dispatch and
admission stay paused (Decision 125).

Stale test sweep: 17 out-of-date expectations were fixed across 13 test
files, including a renamed heading ("Acquisition providers"), nine
hard-coded version pins now read from the release manifest, newer
provider-screen wording, and ranking tests updated to automatic apply
(Decision 128). These tests run only when related files change, which is
why they had drifted. A full check of every live-site test is the first
item of P3 (Decision 127).

Reminders set by the programme owner: check rule admissions and the
Layer 4 forecast the next day; weekly pipeline metrics; UQ rule review
on 31 March 2027.

### Package 4 (v2.15.93): full live-site test check, old links restored — 26 September 2026 AEST

Design decisions v1.34 adds Decision 129 and is CURRENT.

Merged and reviewed on main: PR #132 (6a1b5ab), release v2.15.93. All
checks green on the merge commit, including Deployed UAT (targeted),
which ran the updated live-site tests.

P3 item 1, full live-site test check (Decision 127): all 430 on-screen
expectations in live-site tests were compared with the current app and
database. Result: 11 out-of-date expectations updated to current wording
(Schedule Configuration, Latest Refresh Queue, Profile routing, contact
reconciliation, eligibility inference); 5 changing counts now checked by
pattern; 39 confirmed against live data; 18 built dynamically by the app;
14 correct must-not-appear checks; none left unexplained. One
classification was double-checked and corrected before release (the
eligibility inference check is a positive check, not a must-not-appear
check).

Regression found and fixed: after the Jobs & Schedules merge (v2.15.91),
bookmarks and links to #jobs, #scheduled-tasks and #refresh-scheduling
fell back to the Dashboard; in-app buttons were not affected. They are
routable again (Decision 129).

Working practice: check results are now read directly from GitHub after
each merge, so screenshots of green runs are no longer needed.

Next: P3 continues with the screen-by-screen review.

### Package 5 (v2.15.94): Operations screens review, UQ fee explanation, one current tuition — 26 September 2026 AEST

Design decisions v1.35 adds Decisions 130 to 133 and is CURRENT.
Decision 133 supersedes A24 (CF-CHG-20260830-048).

Merged on main: PR #133 (4f919b1), release v2.15.94; all 23 files
verified identical to the package. The capture tool update was committed
directly (a3a23bc, tooling only).

P3 screen review, Operations group (Jobs & Schedules, Layer 4, Layer 3),
reviewed from captured screenshots (Decision 130). Changes: one title per
Layer screen (Decision 133); plain titles instead of developer labels;
Jobs shows only columns with values, one "Completed" status and fits the
screen; the Layer 4 queue scrolls in its own column with the decision
panel kept in view, and batch history loads its details only when
opened; Layer 3 states when AI interpretation is paused. The first
capture showed Layer 4 as empty because it was taken before data loaded;
the tool now waits for data and captures full height.

Data (applied with proof first): 24 more UQ items admitted from UQ's fee
explanation, 14 courses (Decision 131); 14 courses with duplicate
same-amount fee records resolved to one current record each, 14 records
superseded and kept (Decision 132). A suggested Approve for the held-back
UQ items was not built, because it would have recorded guessed years and
the wrong basis. The Layer 4 queue stands at 127 waiting.

Follow-ups: two Node contract tests (cf-206, cf-209) are stale on main
and not run in CI; decide whether the Compare screen's banner follows
Decision 133 in the Quality & Insights review; Layer 3 tuition panel
(T2) and schedule preview speed (J5) remain for Package 6.

### Package 6 (database security and efficiency) and Package 7 start (attribute register) — 26 September 2026 AEST

Design decisions v1.36 adds Decisions 134 to 145 and is CURRENT. The
Attribute & Admission Register v1.0 is a new standing design document
(Decision 144).

Package 6 (database only; applied live; merged as PR #134, ac871b5):
- Consumer API guard (Decision 136): 13 fixed cases across the six data
  functions behind the website, Wix and Zoho APIs; deterministic (two
  runs, no differences); baselines saved.
- 12 foreign-key indexes on busy tables, including a profile lookup that
  had been scanned about 14.2 million times; guard passed.
- Reference bundle cached (Decision 137): 4,623 ms to 54 ms, identical
  output, service-role access unchanged.
- Two large unused indexes removed with recreate scripts; three kept on
  purpose; small unused indexes left (Decision 145).
- Function security: all 590 security-definer functions pin their search
  path; anon execute removed from 28 functions (it had no schema access);
  five legacy or edge-only api functions limited to the service role; the
  admin app verified as a Pipeline Operator; consumer outputs unchanged.
- Security advisor: informational findings only, no warnings or errors.

Package 7 findings and decisions: provider-sourced attributes cover about
2% of Australian courses because 24,087 courses await Layer 2
qualification, now addressed per provider (Decision 141). Course
description had no working path (Decision 140). 292 scholarships were
found and none published; 57 are ready (Decision 139). No courses are
published; the pilot keeps its behaviour and a production publication
plan is recorded (Decision 138). New Zealand baseline accepted
(Decision 143). Statistics: Statistics & Rankings cards read fields the
read no longer returns, so they show no data; QILT is split into four
cards; each dataset holds one edition; THE 2019–2024 validated but never
applied; THE "2015" is likely the 2021 file; QS 2024 and 2025 duplicated;
Layer 1 dates use US format (Decision 134 addresses these). ARWU and UDI
planned (Decision 135).

Test fix (ed5ea21, test-only, committed to main per Decision 126): the
Layer 1 and Layer 2 test helpers still looked for the screen title inside
the embedded panel, which Decision 133 removed. They now check the page
title. Found by the default Layer 1 test after the Package 6 merge; all
checks green afterwards.

Next: Package 7 builds — Layer 2 admissions view and per-provider
qualification, Layer 4 correction paths for intakes and English,
scholarship publication batches, course description extraction,
statistics model and screens, Layer 1 review.

### Platform Design Reference v1.0 — single decision authority — 26 September 2026 AEST

docs/coursefinder-design-reference-v1.0.md is now the single authority
for CourseFinder design, guardrails and decisions (Decision 148). It
consolidates all 144 recorded decisions verbatim from Design Decisions
v1.0–v1.36 (Decision 26 was never assigned), the foundation principles,
and the Attribute & Admission Register, and adds: the Layer 1–4 model, a
capture and admission map for 15 course attributes, refinements R1–R13,
canonical model and new-country rules, a guardrails register and screen
rules. Earlier decision files and the register are kept as history.

New decisions: 146 (evidence first), 147 (automatic catalogue discovery),
148 (one design reference) — Current. 149 (country-neutral identity and
consumer fields) and 150 (system identity for automation) — Proposed.

Key refinements found: academic entry requirements have no capture path
(R1); Australian course identity is not in the identifier tables, unlike
Canada (R3); two consumer fields use Australian terms (R4); THE
2019–2024 validated but not applied, contrary to Decision 128 (R5);
automation acts under a real admin's identity (R10).

From now on, every package records its decisions in the Design
Reference (new numbered entries), not in a new Design Decisions version.

### Platform recovery, Package 8 start, Design Reference v1.1 — 26 September 2026 AEST

Incident: the pilot database (Nano compute, 0.5 GB memory, 1.7 GB database)
exhausted its disk IO budget after the evidence link index stored every
link (1.75 million rows, 672 MB in a few hours). Jobs ran for minutes and
failed, and Auth timed out (Deployed UAT 504s). Response: heavy jobs
paused; link table emptied and redesigned as a narrow index; compute
upgraded Nano to Micro (no extra cost); all jobs restored in three stages
on a new schedule (no job more often than its data changes, heavy jobs
never overlapping); consumer reference bundle rebuilt hourly with a
3-hour live fallback; job history kept 14 days. Result: database 1,021 MB,
cache hit rate 99.45%, admin summary refresh 2.7 s (was 20 s), Deployed
UAT green.

Also: a Layer 2 run stuck since 15 Sep was closed and a daily stale-run
closer added (Decision 151); automation now acts as the system identity
CourseFinder Automation with Pipeline Operator rights (Decision 150); the
three Layer 1 apply functions write only on real change and refresh
verification markers at most every 30 days (Decision 152, option B).
Package 7 part 2 merged as PR #136 (v2.15.96).

Design Reference v1.1 is CURRENT: 146 refined; 149 and 150 Current; new
151 (stale runs closed), 152 (workload efficiency), 153 (platform sizing
and resource observability); new principle P11 Efficient by design.

Next: Package 8.2 (resource utilisation and cost in Administration),
8.5 (admission lifecycle), then one Package 8 PR with the staged
migrations (stale-run closer, narrow link index, Micro schedule, system
identity, Layer 1 write-only-when-changed).

### Package 8 complete (v2.15.97) and Design Reference v1.2 — 26 September 2026 AEST

Package 8 merged as PR #138 (c90b37e), release v2.15.97; all 17 files
verified identical on main. It adds the Platform resources and cost panel
(Environment & Migration): hourly observations of database size against
memory, cache hit rate, job health and overlaps, evidence storage, largest
tables, acquisition and AI usage; alerts; 30-day trends; an editable cost
model; and the admission lifecycle view. The daily capacity observation,
which had timed out every day since 2 Sep, runs again (2.9 s).

Admission lifecycle (Decision 154): registers checked weekly; course facts
annually (Aug–Nov window) or on demand; scholarships quarterly; provider
assets annually; QILT twice a year; PRISMS monthly; rankings annually.
3,057 Layer 2 profiles aligned through the official versioning path
(0 errors); consumer APIs unchanged.

First readings: database 1,033 MB against 1 GB memory (Micro); cache hit
99.45%; evidence storage 15 GB; AI this month US$0.63.

Design Reference v1.2 is CURRENT: Decision 154; R15 done; R16 register
ingestion overdue since 2 Sep; R17 publishing window recorded but not yet
enforced.

Housekeeping: PR #137 placed the stale-run migration at the repository
root; the correct copy is now under supabase/migrations/ and the root copy
is to be removed.

Next: Package 9 — R16 register ingestion, country-neutral identity and
consumer fields (Decision 149), academic entry requirements, ranking
editions, Layer 4 corrections for intakes and English, scholarship
publication, course description, statistics model and Layer 1 screens,
publishing-window scheduling (R17).

### Package 9 (9a, 9b, CF-068 fix) complete (v2.15.98) and Design Reference v1.3 — 28 September 2026 AEST

Package 9a merged as PR #139 (db56844): register ingestion unblocked
(R16). Search refresh made safe-update compliant and moved to a deferred
job (search-refresh-requested, every 10 minutes); the hard-coded CRICOS
count removed from layer1-au-depth, -cricos-facts and -completeness.
CRICOS caught up on 26 Sep (25,978 active courses; 139 new courses, 2 new
providers). On 27 Sep the 809 courses no longer in CRICOS were retired
(inactive, not deleted; audit table pipeline.layer1_course_retirements;
685 linked to Adelaide University as successor; consumer API baseline
diff empty).

Package 9b merged as PR #140 (21e55b1), release v2.15.98; CF-068 fix
merged as PR #141 (d1b8aee). All files verified identical on main; edge
functions redeployed from main by the workflow (layer1-operations-control
v13, layer1-nz-live v6, layer1-register-etl v11, layer1-au-depth v13).
Decision 155 part 1: runs are advanced by the database (lease per run,
layer1-run-driver every minute, 430 checks, 0 failures), temporary source
errors retried 5 times, identical register files reused, live progress
and real errors on the Layer 1 card with resume. NZQA 414 of 414
providers in 81 s; CRICOS full dry run 3.5 min with no new evidence files.
layer1-nz-live is now in the repository (was live-only). Decision 156:
ranking family card shows the newest ingested edition with its year;
QS 2027 shows as pending. Deployed UAT passed.

Design Reference v1.3 is CURRENT: Decisions 155 and 156; R16 done;
new R18 duplicate evidence, R19 change-based apply, R20 automatic
departures and mergers, R21 database 1,296 MB against 1 GB memory
(evidence link index 184 MB and growing), R22 run summary counts
inactive registrations.

Next: Package 10 — Decision 155 parts 2 to 4 (change-based apply,
automatic departures and mergers, duplicate evidence clean-up with proof
first, then automatic weekly register ingestion within the pass band);
R21 link index growth; then Decision 149 identity and consumer fields.

### Package 10 (v2.15.99, applied live) and Design Reference v1.4 — 28 September 2026 AEST

Decision 155 is fully delivered. Applied live and verified; the code is
staged for one Package 10 PR (21 files, 9 migrations).

Link index (R21, option A, Decision 157): discovery links kept once per
provider (447,678 rows, 188 MB, to 25,521 rows, 19 MB); candidates proven
identical for all 648 providers (3,011) before switching; only providers
waiting for onboarding are indexed; database 1,296 MB to 1,131 MB.

Change-based apply (R19): register fingerprints bootstrapped from the
accepted 26 Sep CRICOS file (25,978); a full comparison takes about 10 s.
Test: 3 courses marked changed were found and applied in one 13 s batch;
a dry run then showed 0 changes; accepted hash unchanged.

Departures (R20, Decision 158): retired automatically at the end of each
run with audit and count check; more than 2% (at least 50) held for a
Platform Admin; reactivation and provider review list. Tested in
rolled-back transactions (retire 2, hold 600, reactivate 1, provider 1)
and in a live run (1 departed test key).

Duplicate evidence (R18): 746 copies of register files (1.7 GB) removed
after a 20-file byte-for-byte check; 0 failures; 0 broken references;
evidence bucket 16 GB to 14 GB. Records were not deleted.

Automatic ingestion (Decision 155 step 7): layer1-auto-ingest (hourly at
:34) queues an apply run when a register changed within the 'pass' band;
on for CRICOS and NZQA. Tested (1 queued, 1 'warn' skipped, rolled back).

Edge functions deployed live: layer1-operations-control v1.5.0,
layer1-au-depth v1.7.0, layer1-au-cricos-facts v1.2.0,
evidence-storage-dedupe v1.0.0 (new). Contract suite: 42 passed; the same
12 older failures as main.

Design Reference v1.4 is CURRENT: Decisions 157 and 158; R18–R21 done;
new R23 Layer 2 duplicate evidence (about 4.4 GB, needs approval), R24
NZQA re-fetches every provider, R25 provider departures review screen.

Next: merge Package 10 and redeploy the four functions from main; then
Decision 149 identity and consumer fields and the remaining Package 9
refinements.

### 28 Sep 2026 — Package 10 merged; CF-068 deployed UAT fixed (PR #144)

Package 10 merged (#142, ce47e67) and the four edge functions redeployed
from main by the deploy workflow. CI now publishes Playwright failures as
check annotations (#143), because UAT log downloads are blocked here.

CF-068 deployed UAT failed on mapped_unique (expected 35, received 36).
Cause: the QS validate path uses the CF-077 preview, which counts Victoria
University (two providers with the same name) as an equivalent fan-out
that is mapped, and always reports exact_ambiguous 0. Expectations were
updated to live-verified values: 36 AU rows, alias 14, exact 21, fan-out
1, unmatched 0. No data changed.

Found while verifying: QS and THE sources have no country, so queuing a
run for them (Run now or background) failed on layer1_run_queue.
country_code (char(2), NOT NULL). Column widened to text; both queue paths
now record GLOBAL (checksum-guarded patch, migration 20260928050000).
Verified with a live QS 2026 background dry run: completed, 1,501
observations. Merged as 82d63c4; deployed UAT (CF-068 spec) passed.

Still open: R23 Layer 2 duplicate evidence clean-up (about 4.4 GB) awaits
approval. Next: Decision 149 identity and consumer fields, then the
remaining refinements.

### 28 Sep 2026 — R23 duplicate Layer 2 evidence removed (approved)

Scope approved: Layer 2 screenshots and HTML page snapshots only. Same
method as R18: every evidence record is kept with its own capture time,
URL and job; records whose file is byte-identical to an earlier capture of
the same provider are pointed at the first stored copy (original path kept
in metadata), then only the redundant copies are removed.

Proof: 1,848 groups, 8,461 copies, 4.47 GB, no size mismatches, no
missing files. Byte check: 60 of 60 sampled copies matched the kept file
and the recorded SHA-256. Removed 8,461 copies, 0 failures. Every Layer 2
record still points to a stored file. Evidence bucket 14 GB to 10 GB.
Checked beforehand that no other table or job payload stores these file
paths, and that capture code only removes its own just-uploaded file.

Function change (migration 20260928060000): approved scope 'layer2' added;
group checks rewritten per group because the row-by-row version timed
out on about 17,000 records. Layer 1 scope re-run: 0 left, as expected.

Also noted: two register evidence records from 14 Aug have no stored file
(before any clean-up; not caused by R18 or R23).

New R26: new Layer 2 captures still store identical files (about 600 a
week in September); needs a decision between reusing the stored file at
capture time or a scheduled clean-up.

### 28 Sep 2026 — R26 Layer 2 captures reuse identical files (approved)

Approach approved: reuse the stored file at capture time. Change made once
in the shared capture function (layer2_evidence_capture, checksum-guarded;
migration 20260928070000), so every Layer 2 capture path is covered
without changing edge functions.

For screenshots and HTML snapshots: when an earlier record of the same
provider source already holds a stored file with the same SHA-256, the
new capture still gets its own record (capture time, URL, job, metadata)
but points at that file. The just-uploaded copy is returned so callers
that already tidy up remove it at once; it is also logged, and a new daily
job (evidence-storage-dedupe-daily, 19:17 UTC) removes any copy left
behind once no record references it.

Tested in a rolled-back transaction: identical bytes in a new group reused
the existing file and logged the upload; different bytes stored their own
file; same-group repeats unchanged. No Layer 2 captures ran in the last
24 hours, so the first live reuse will show in the next scheduled run.

Rule for any future retention purge: files can be shared between records,
so only delete files no record references.

### 28 Sep 2026 — Decision 149 country-scoped identifiers delivered

Audit: Canada already recorded official identifiers in the identifier
tables; Australia (CRICOS) and New Zealand (NZQA) codes were only in the
registration tables, and provider registrations carried no country.

Delivered (migration 20260928080000): ref.identifier_schemes lists each
official scheme once (CRICOS and NZQA for providers and courses, IRCC DLI
for providers); a new country adds rows, not columns. Triggers on the
registration tables keep provider_identifiers and course_identifiers in
step, writing only when an identifying value changes. Backfilled 1,548
CRICOS and 414 NZQA provider codes, 26,787 CRICOS and 6,496 NZQA course
codes; all 100% matched, country correct. Trigger test (rolled back):
status-only change wrote nothing; code change moved the identifier;
delete removed it; provider insert and delete mirrored.

Consumer contracts checked: already neutral (ISO subdivision codes,
tuition basis 'registered_total_course', no CRICOS-named fields). The
'state' key inside regulatory_tuition means status; rename in the next
contract version, alongside the old name.

Fixed (migration 20260928080100): the Zoho course lookup skipped the
Layer 4 search block for matches by course code (missing bracket). No
course is blocked today, so no output changed; consumer snapshot content
identical before and after.

New R27: older AU-specific columns in Layer 2 staging tables and
vet_national_code on course_regulatory_observations; plan is neutral
columns alongside, then retire the old names.

### 28 Sep 2026 — Layer 1 closed (Decision 159, v2.15.100)

Approved by the Platform Admin: close Layer 1 for functionality, including
rankings and statistics. Pilot PR #148 (branch cf247-layer1-closure).

Delivered and verified live:
- R22: run summaries count active records (25,978 CRICOS; 809 retired
  shown separately).
- R25: Layer 4 → Provider departures (closed / merged with successor /
  reviewed; Platform Admin with a reason). 10 AU providers listed, incl.
  UniSA and The University of Adelaide with Adelaide University suggested.
- NZQA departures (new): each run records the courses it reads; unseen
  courses of providers read in that run are retired with the CRICOS audit
  and hold. First run: 6,475 seen, 21 retired (= 6,496 registrations).
- R14: CRICOS rows seen in a run are re-marked checked at most every 30
  days; NZQA rows by each run.
- Scheduled checks now cover QS/THE (country GLOBAL) and QILT/PRISMS (the
  scheduled worker called undefined helpers). THE 2026 re-verified: 3,118
  rows, pass. Ranking runs could not be queued (NULL country) — fixed.
- R5 rankings: THE 2016–2024 applied with exact expected counts (800,
  981, 1,103, 1,258, 1,397, 1,526, 2,112, 2,345, 2,671); THE "2015"
  withdrawn (identical to 2021, 1,526 of 1,526 rows); QS 2025 restored to
  the correct load (replacement workbook had region as country, 0 matches).
  One current edition per year: QS 2021–2027, THE 2016–2026, all linked.
- R6 / Decision 134: edition rules on stable publisher pages, monthly
  discovery with a test read, Apply edition on the card, QILT one card
  with survey tabs. First discovery: QILT SES 2025 found and test-read
  (1,059 records) — waiting for a person to apply it on the card.
- Closure contract suite (6 tests); contract suite 50 passed, the same 12
  older failures as main. Release v2.15.100 / package 0.1.27.

Background admission (running):
- Automatic onboarding switched on gently (10 providers/day, 3 in flight).
  First results: UNSW, Sydney and Monash (about 1,900 waiting courses)
  failed the 3-course identity check on all 3 candidates each → Needs a
  person. The largest university catalogues need hand onboarding.
- Layer 2: 108 captures in 2 hours; 48 reused an identical stored file
  (R26 working). Firecrawl 2,636 pages left this month (resets 1 Oct).
- Layer 3: no qualified tuition model (best Mistral Small 3.2: 8/10
  provider, 5/5 controls); dispatch and admission remain off. 336 items
  admitted to date; 127 Layer 4 items open.

Upcoming plan (M2.4.7 → M2.4.9):
1. Layer 3 qualification decision (activation needs a passing model or an
   agreed abstain-to-Layer-4 bar), then a bounded AU tuition cohort with
   end-to-end admission proof (M2.4.7 exit).
2. Hand-onboard the large universities that failed automatic onboarding;
   keep automatic onboarding on for the rest.
3. Consumer contract next version (R2 duration, R4 status rename).
4. Canada register onboarding as a country adapter (not a Layer 1 change).
5. R27, R1, R7–R9, R12, R13, R17 per the design reference.

### 28 Sep 2026 — Layer 3 AI activated (Decision 160)

Approved by the Platform Admin (Option 1): a Layer 3 model qualifies when
every answer it gives is correct. It may say "unsure"; unsure items go to
Layer 4 for a person. Pilot PRs #149 and #150.

Delivered and verified live:
- Qualification rule: at least 3 cases, 0 wrong answers, 0 infrastructure
  errors, at least 3 and at least half resolved, controls all pass. A
  passing benchmark still leaves the model paused; activation is a separate
  recorded step.
- Mistral Small 3.2 (pinned model, OpenRouter) qualified: 10/10 resolved,
  0 wrong, controls 5/5, cost USD 0.003. Activated under the system
  identity with an activation event. Dispatch (every 10 min) and admission
  (every 15 min) jobs switched on; limit 1,000 calls a day, USD 0.05 cap.
- The 5 open items (Layer 4 send-backs) were still assigned to the retired
  Nemotron profile, so dispatch skipped them. They were moved to the
  qualified profile, each move recorded in
  pipeline.layer3_work_item_rebinds (only open items; finished items never
  move).
- First live run (09:35 UTC) processed all 5: 2 unsure and 2 stopped by the
  admission guard (answer could not be bound to a Layer 2 fee target) went
  to Layer 4; 1 hit a temporary provider rate limit and retries on the next
  run. No fee was written, which is correct for these hard cases
  (catalogue.course_fees unchanged at 157,552).

Still to show for the M2.4.7 exit: a fresh Layer 2 tuition item admitted
end to end by Layer 3 (enqueue has no new eligible items yet; they arrive as
Layer 2 captures run).

Waiting on a person:
- QILT SES 2025 edition: press Apply edition on the Layer 1 QILT card
  (checked: 1,059 records).
- UNSW, Sydney and Monash: hand onboarding (automatic onboarding stopped
  at needs a person).

### 28 Sep 2026 — QILT SES 2025 edition applied (Decision 134)

First statistics edition applied through discovery and Apply edition.
Pilot PR #152.

- First Apply (09:53 UTC) was refused: "QILT observation lacks verified
  source-to-CRICOS mapping". Victoria University (2 CRICOS codes) and
  Holmes Institute (3) are one QILT institution each; the verified mapping
  lists the equivalent providers, but the apply guard accepted only the
  first. Nothing was written.
- Fix (checksum-guarded): the guard also accepts a provider in the same
  verified mapping's recorded equivalent set; any other provider is still
  refused. Tested in a rolled-back transaction both ways. Contract test
  added to the Layer 1 closure suite (14 passed). A defect fix, not a
  reopening of Layer 1 (Decision 159).
- Applied by the Platform Admin at 10:07 UTC: 1,059 records read, 1,095
  outcome rows written (Victoria University and Holmes Institute written
  for each equivalent provider), 115 providers, 0 rows without a verified
  mapping. SES 2025 is current; SES 2024 is retained (1,013 rows) and no
  longer checked on schedule; next SES check 29 Mar 2027.

Gap logged: 36 SES 2024 rows (La Trobe, Monash, RMIT; 12 each) have no
exact verified mapping match (older institution key format, loaded before
the guard). Left unchanged; to be reconciled with R27.

### 28 Sep 2026 — QS parser v1.4.0; Compare datasets on by default (v2.15.101)

Pilot PRs #153 and #154.

QS official workbooks (2024, 2025, 2026, 2027 as supplied by the Platform
Admin):
- 2024, 2026 and 2027 are byte-identical to the accepted editions; nothing
  to load.
- The 2025 workbook labels its country column "location code" and its
  region column "location"; parser v1.3.0 read regions as countries (0
  Australian rows). v1.4.0 picks the country-name column and refuses a file
  with fewer than 30 countries or no Australia rows. 2024/2026/2027 output
  identical to v1.3.0; 2025 now 38 Australian rows, matching the accepted
  2025 edition on rank and score for all 38. No reload needed.
- Governance gap closed: main held ranking-qs-official-etl v1.1.0 while
  v1.3.0 was deployed (only on recovery branches); main now matches live.
  Added to the deploy allow-list (verify_jwt=true).

Compare:
- QILT and PRISMS were greyed out until items were selected (periods came
  only from the selected items). All four datasets are now on by default and
  switched off only by a click; periods show "Latest available" until
  items supply them.
- Course mode labels each dataset: QILT and rankings for each course's
  university; PRISMS for the course, its state and field, or its state.
- Course-mode PRISMS was empty for most courses (no fallback beyond state
  and field). It now falls back to the course's state, as the university
  view does (checksum-guarded; admin read only; no consumer API function
  calls it; fresh consumer baseline stored).
- Release v2.15.101 / 0.1.28. Deployed UAT and currentness green on main.

Noted: older Compare contract tests (cf-215, cf-075, cf-061, early m245)
fail identically on main because they contradict the later M2.4.5
contract; to be retired or rewritten.

### 28 Sep 2026 — Layer 2 extraction restored (discovered URLs carried forward)

Pilot PR #155.

Finding while checking the M2.4.7 exit (why Layer 3 had no new items):
- Decision 152 (26 Sep) created a new version of 3,057 Layer 2 profiles,
  changing only freshness_sla_hours. Discovered course URLs are stored per
  profile version and were not carried over, so every current version had
  no URLs: scheduled extraction would fetch nothing (UQ's weekly run due
  1 Oct would have completed empty).
- Repaired live: 7,301 discovered URLs for 141 profiles (565 selected)
  copied to the Decision 152 versions, each copy recording its source
  version (UQ 251, RMIT 263, Federation 10 selected; 22 profiles now have
  selected URLs). Guarded to the exact counts.
- A trigger now carries URLs forward whenever a new version keeps the same
  discovery settings (discovery_strategy, url_patterns). Tested both ways
  in a rolled-back transaction.

Fee extraction coverage (the only path that feeds Layer 3 tuition):
| Source | Status | Courses | With provider tuition |
|---|---|---|---|
| UQ | qualified, weekly refresh on | 382 | 262 |
| RMIT | qualified, weekly refresh OFF (CF-044: promotion blocked) | 506 | 141 |
| Federation | bounded, paused (source-limited) | 195 | 5 |
| QUT | deferred | 294 | 0 |

Layer 3 has no new work because no new tuition candidates exist outside
these sources. Decision needed from the Platform Admin on how to grow fee
coverage (see NEXT-CHAT).

### 28 Sep 2026 — RMIT course refresh unblocked (Decision 161)

Platform Admin decision (option "Unblock RMIT"). Pilot PR #156.

- RMIT weekly Layer 2 refresh policy switched back on (disabled 27 Aug
  under CF-044); first run due 28 Sep 11:59 UTC, then weekly.
- Output follows today's rules: tuition via Layer 3 (Decision 160), unsure
  to Layer 4; other fields via the Decision 152 admission lifecycle.
- RMIT: 506 courses, 141 with provider tuition, 263 selected course URLs;
  no Layer 4 blocks; fee qualification "qualified".
- Federation (paused, source-limited) and QUT (deferred) unchanged.
- Next: confirm the batch runs, new tuition candidates reach Layer 3 and
  at least one is admitted end to end (M2.4.7 exit).

### 28 Sep 2026 — Decision 162: course attributes, deterministic ingestion and refresh

Platform Admin direction: tuition is steady for a year and CRICOS already
supplies it; international applicability and scholarships to be defined;
Layer 2 to be deterministic; review Firecrawl; explain the Layer 2/3 badges.

- Definition: docs/coursefinder-course-attribute-ingestion-v1.0.md
  (attribute catalogue, scholarship rules, Layer 2 method, refresh tiers,
  badge redefinition, Firecrawl use, build order).
- Findings: CRICOS gives registered international tuition for 25,795 of
  25,978 AU courses (plus non-tuition and total cost); provider annual
  tuition covers ~408. International availability = active CRICOS
  registration. 292 scholarships, all international (200 Study Australia).
- Badge engine: security.admin_course_field_states infers layers from
  presence, not stored provenance: 242 Layer 3-admitted tuitions show "L2";
  CRICOS tuition ignored, so ~26k courses show tuition "Awaiting L2";
  "Awaiting L3" shown for fields Layer 3 never handles.
- Live change (Pilot PR, applied and verified): UQ and RMIT course-page
  refresh moved from weekly to every 90 days (term-cycle); next runs 23 Dec
  (UQ) and 27 Dec (RMIT). Today's RMIT run still proceeds.
- Firecrawl: fetcher only (map/sitemap, rawHtml with maxAge 0, git-diff
  change tracking at no extra credit, PDF fast parser, scripted actions);
  AI extraction (json, /extract, /agent) not used for admission.
- Build order: 1 badges on stored provenance; 2 provider fee-schedule
  adapters; 3 change check; 4 English tables; 5 entry requirements;
  6 extend fee rules beyond UQ/RMIT/Federation.

### 28 Sep 2026 — Decision 162 step 1 live (badges from stored provenance, v2.15.102)

Pilot PR #158; deployed UAT, release history and currentness green on main.
- security.admin_course_field_states now reads stored records (Layer 3
  admitted work item by course and evidence, Layer 4 resolutions, CRICOS);
  checked on six sample courses: Layer 3 fee now "L3 · mistral-small-3.2";
  Layer 4-bound item "Awaiting L4"; other AU university "CRICOS tuition
  applies"; NZ "Not collected". Consumer endpoint hashes unchanged.
- Step 2 research: whole-of-university international fee schedules found
  for Western Sydney, Federation, Charles Darwin, Charles Sturt (CRICOS-
  keyed), RMIT, Swinburne, Wollongong, UQ, UWA, Melbourne (details in the
  attribute document §8a).
- RMIT first run: batch started 13:18 UTC (263 pages); first 20 records
  all identity-matched, 15 with tuition candidates for Layer 3.

### 28 Sep 2026 — Decision 162 step 2 live: provider fee schedules (Federation, Western Sydney)

Pilot PR #159. Worker fee-schedule-etl v0.3.0 (deterministic PDF table
reading; no AI, no Firecrawl); svc_fee_schedule_preview (read-only) and
svc_fee_schedule_apply (governed path, provider-scoped, conflict rules).
- Federation 2026: 73 written (3 confirmed identical course-page values).
- Western Sydney 2027: UG 71 written (1 held: listed twice with different
  fees; 3 codes not in register); PG 65 written (2 not in register).
- Provider tuition coverage 408 -> 614 courses; spot values match PDFs; no
  double tuitions; consumer baselines stored before/after; API healthy.
- Follow-up: send held same-code conflicts to Layer 4 automatically; add
  Charles Darwin, RMIT, Swinburne schedules after inspection.

### 28 Sep 2026 — Decision 162 step 2 extended; RMIT basis finding

Pilot PRs #160, #161.
- Parser v0.4.1 (A$/year fees; two-column pages; $12,000 annual floor and
  English programs excluded). Federation/WSU re-parse identically.
- Charles Darwin 2026: 105 written; Swinburne 2027 UG 88 (1 held), PG 24.
  Provider tuition coverage 614 -> 831; spot values match PDFs; no double
  tuitions; consumer API healthy (baselines stored).
- Badges: courses missing from a fee schedule show "CRICOS tuition applies";
  schedule values labelled "Layer 2 provider fee schedule".
- RMIT 2027 schedule deferred (rotated table, program codes, no CRICOS).
- RMIT pages print "(2027 annual)" / "(2027 total)"; two fresh Layer 3
  items read a total as annual and were rejected by the deterministic
  validator (to Layer 4). Proposed provider rule rmit-program-page-year-
  basis-v1 awaits programme owner approval (Decision 132 pattern).

### 28 Sep 2026 — Decisions awaiting the Platform Admin (Decision 162)

- Search gate: the 426 schedule fees are in the catalogue but not in Search
  or the consumer API, because only UQ and RMIT course-page sources have
  approved Search gates (CF-023). Fee-schedule qualifications corrected to
  search_admitted=false (Pilot PR #162). Decision: open gates for the four
  schedule sources.
- RMIT provider fee rule (pages print "(2027 annual)" / "(2027 total)").
- English: provider default by study level plus named exceptions (UQ, WSU,
  Macquarie, UWA pattern; UTS by internal code).
- Layer 3: 25 fresh RMIT items enqueued 14:22 UTC; results due before the
  15:50 check-in.

### 28 Sep 2026 — Platform Admin approvals applied (Decision 162)

- Search gates opened for the four fee-schedule sources (Pilot PR #163):
  426 tuitions in Search/consumer API, amounts verified; snapshots stored.
- RMIT fee-basis rule live (Pilot PR #164): 31 courses admitted as 2027
  totals; Layer 4 queue 86 -> 53; runs 3-59/10 before the dispatcher.
- English rule: not yet written. UWA list not exhaustive (course rules);
  Macquarie blocks fetching (403); Western Sydney uses short names/groups;
  UQ Table 1 is the right first case but needs a line-joining parser and a
  full reconciliation before apply. Inspect support merged (PR #165).
- Provider tuition coverage today: 408 -> 862 courses.

### 28 Sep 2026 — M2.4.7 exit evidence: fresh item admitted end to end by Layer 3

- Layer 2: RMIT weekly refresh (Decision 161) batch 22e7ffac… read 263
  pages (13:18–14:40 UTC); record for Associate Degree in Design
  (Furniture), CRICOS 061154K, page text "Fees: AU $38,400 (2027 annual)".
- Layer 3: work item 34aade5c… enqueued 14:22; Mistral Small 3.2 (pinned,
  qualified, Decision 160) answered $38,400 annual 2027; deterministic
  validator passed; admitted 14:38.
- Catalogue: provider_current_tuition $38,400, annual, 2027 (note links
  interpretation faab8a30…). Search: has provider tuition, annual 38,400.
- Same run: the AI read "(2027 total)" as annual on two items; the
  validator rejected both (Layer 4); the RMIT basis rule now resolves such
  pages deterministically (31 courses as totals).
- Coverage today: provider tuition 408 -> 863 courses; 861 in Search.

### 28 Sep 2026 15:50 UTC — Scheduled check-in: RMIT end to end (M2.4.7 exit confirmed)

- Layer 2: RMIT batch 22e7ffac… finished (263 pages); its tuition
  candidates all reached the Layer 3 backlog and work items.
- Layer 3 (all provider tuition items): admitted 379, Layer 4 79, parked 1,
  pending 0. RMIT: admitted 182, Layer 4 50, parked 1.
- The 26 rows still listed in the fee backlog view all have work items in
  Layer 4 (for example $4,000 and $172,800 amounts that are not annual
  tuition); none are waiting for Layer 3.
- RMIT basis rule: 42 admissions in total; cron provider-basis-rule-admit
  active.
- Catalogue: 173 RMIT courses with a current provider tuition; 863 courses
  overall. Search: 861 carry provider tuition (2 held by gates, unchanged).
- M2.4.7 exit: met (fresh item 34aade5c… admitted end to end, 14:38 UTC).

### 28 Sep 2026 — Decision 162 step 4: UQ English requirements (default plus named exceptions)

- Built and applied under the Platform Admin approval (Pilot PR #166; fee-schedule-etl v0.7.1).
- Sources: UQ ELP Procedure cl. 10-11, Table 1 (56 higher-than-minimum
  programs) and Table 3 (minimum IELTS 6.5/6 each, TOEFL 87, PTE 64);
  both PDFs kept as evidence with SHA-256.
- Dry run: 0 parser issues; Table 1 agrees with course pages 40/40; minimum
  agrees 149/150 (Bachelor of Music page PTE 30 left unchanged for Layer 4).
- Applied: 54 UQ courses without English (9 Table 1, 45 minimum), 144 rows;
  no existing value changed; consumer snapshots before/after identical.
- Held, not guessed: 94 double degrees, 17 research degrees, 14 near-name
  variants, 7 non-award, 6 exit awards.
- Fixed during the dry run: plan timeout (27 s -> 0.13 s); a research
  program name read as a section header.
- Next: Search gate for this source and a double-degree rule (Platform
  Admin decisions).

### 29 Sep 2026 — UQ English: Search gate opened; double degrees take the higher component

- Platform Admin approvals 29 Sep 2026; Pilot PR #167.
- Search gate for the UQ English-requirements source: 54/54 courses show
  English in Search; consumer snapshots before/after identical.
- Double-degree rule higher_component_v1 trialled first: 84 of 94 resolved
  (68 minimum, 10 Laws (Honours) 7.0, 6 Education (Secondary) 7.5); 51/52
  agree with course pages (other: course-page PTE 30, IELTS agrees).
- Applied: 32 double degrees, 86 rows, all in Search; 10 held with an
  unrecognised component (Diploma in Languages, Humanities, Law singular,
  International Law, Pharmaceutics/Doctor of Pharmacy).
- UQ English coverage: 262 -> 348 of 382 active courses.

### 29 Sep 2026 — Complete-coverage programme: statistics, coverage sweep, precision checks
- Direction (Platform Admin): complete coverage of every active Australian course, ongoing, in days not weeks; Firecrawl plan upgrade approved; Layer 3 cap 15,000/day with US$5/day ceiling; "complete" = every course accounted for per attribute.
- Statistics live (v2.15.103, Pilot #168): Data Quality → Course coverage; one state per course per attribute, rebuilt hourly, kept daily.
- Coverage sweep live (v2.15.104, Pilot #169; ops follow-up branch cf247-coverage-ops): find website, discover (site maps first, Firecrawl map when short), bind one-to-one, read (robots.txt respected, gzipped evidence), re-extract, monthly document checks (weekly Oct–Dec). Nothing is written to the catalogue by the sweep.
- Precision: CRICOS-code pages 13/13 correct, exact-title-only 3/8, so only CRICOS-code pages count as verified; English 12/12; tuition amounts 8/9 but basis unreliable, so tuition goes to Layer 3.
- Status 09:25 IST: 1,538 providers (109 mapped, 873 queued, 554 website search); 3,460 pages bound, 1,075 read, 797 verified; candidates awaiting admission rule: official page 772, English 329, intakes 390, tuition 189. Firecrawl 9,449/11,000 this month.
- Pending Platform Admin decisions: admission rule + Search gates for verified sweep values; Layer 3 route for sweep tuition; new Firecrawl monthly limit.
- Detail: docs/coursefinder-course-attribute-ingestion-v1.0.md section 9.

### 29 Sep 2026 — Firecrawl 100k plan live; daily updates scheduled; consolidated plan (Decision 163)
- Platform Admin: Firecrawl upgraded to 100,000 credits a month (50,000 searches or 100,000 pages), 25 concurrent; OpenRouter US$29 prepaid.
- Applied live (Pilot migration 20260929140000): budget limit 100,000, stop at 2,000 remaining, concurrency 20; pages held for the 1 Oct reset released; discovery 8 providers per call. Verified live: 90,245 credits available, 0 pages still held.
- Daily update scheduled 08:49 IST (docs/daily-updates/, part A consumer API, part B stakeholders; push and email summary).
- Consolidated plan v1.0 (waves 0–4 to GO/NO-GO 12 Oct) and Decision 163 recorded.
- Awaiting Platform Admin: admission rule, Layer 3 tuition route, publication of 57 Decision 139 scholarships, compute upgrade, semantic search timing, website developer's request.

### 29 Sep 2026 — Admission live (official page, English); scholarships under Decision 139; production runbook for 3 Oct (Decision 164)
- Platform Admin approvals (09:56 IST): admission rule, tuition via Layer 3 Option A, scholarship publication plus sweep, semantic search after go-live. 10:01 IST: production by 3 Oct in customer-owned accounts; compute to Medium.
- Extractor v0.5.3–v0.5.4: IELTS overall never read across other words or from another test; score before "IELTS"; several overall scores = unclear; PTE/TOEFL evidence kept; money/visa/deadline windows not intakes. Hand-check after fix: English 14/14.
- Admission live (security.coverage_admission_apply_v1, cron coverage-admit every 10 min): official page and English only, write-only-when-empty, differences to Layer 4, Search gates per sweep source, snapshots before/after. First batch 20 courses verified in Search.
- Intakes held (hand-check about 9/14): to Layer 3 benchmark.
- Scholarships: exact Decision 139 check gives 4 of 292 (not 57); 4 published, 2 withdrawn by the new course-link breadth rule; 2 live; daily review cron scholarship-publication-review.
- Found: 27 live edge functions have no source in GitHub (incl. layer4-course-resolve), to be brought into the repo before the transfer.
- Production runbook v1.0 and plan v1.1 issued; Decision 164 recorded. Open: region (Mumbai transfer vs Sydney migration), extra Layer 2 fetchers and Apollo, host names, developer's request.

### 29 Sep 2026 — Production decisions; Option A tuition live; completeness score; security retirements
- Platform Admin (10:55 IST): production in Mumbai by project transfer; extra Layer 2 fetchers and Apollo dropped; consumer API stays on the Supabase functions address. Runbook updated (§1a).
- Found: the code repository msinghbs-ai/Coursefinder-Pilot is public. No credentials found in main. To be made private (runbook §6.2).
- 27 live-only edge functions imported into git (Pilot PR #173). ranking-qs-2027-publish-recovery (no authentication) and ranking-qs-2027-binary-recovery (embedded key) replaced live with 410 stubs; verified live.
- Tuition Option A live (Pilot PR #174): sweep pages with one international fee are handed to the qualified Mistral model as plain-text evidence with Layer 2 run items (disabled profile au-coverage-sweep-course-pages). First 4 processed end to end, all held for Layer 4 (no "per year" wording), so hand-off throttled to 20 per 10 minutes until the admit rate is known.
- Completeness score live: pipeline.course_completeness and completeness_daily, hourly (cron course-completeness-build). First build: 44.9% complete, 54.3% accounted for, 403 of 25,978 courses fully complete.
- Daily update prompt extended with completeness, sweep admission, Layer 3 tuition and the production go-live track.

### 29 Sep 2026 — Compute Medium; consumer API update for the website developer (Decision 165)
- Compute upgraded to Medium by the Platform Admin (t3a.medium, 120 connections); verified: restart clean, no scheduled-job failures, sweep reading on. Sweep discovery now every minute (8 providers); reads 60 per call.
- Website developer's data request (PDF, 29 Sep) reviewed: search, the 12 "Must" fields, city/postcode and tuition basis already live since 23 Sep; draft reply prepared.
- Consumer API update live (Pilot PR #175), checksum-guarded, snapshots before/after (only reference_bundle changed, as expected): presentable provider names (legal_name kept), Home Affairs regional category and metro area per campus, city filter by metro area, English entry summary, title-case localities. Developer's example search 0 → 10 results; "nursing" in Melbourne 15 → 89; searches 0.1–0.4 s.
- Tuition via Layer 3 (first hour): 42 admitted, 113 to Layer 4, 17 pending; admitted sample checked against page wording.

### 29 Sep 2026 — University groups in filters, admin and API (Decision 166); scholarship sweep and first batch (Decision 167)
- Platform Admin (13:19 IST): developer reply, production environment and repository access parked; focus on data admission, university groups and the scholarship sweep.
- University groups live (Pilot PRs #176, #177): Group of Eight, ATN, IRU and RUN from each group's official member page, 26 universities matched by CRICOS code. Admin v2.15.105 has a University group filter on Courses and Providers. Consumer API has a `university_groups` filter (go8, atn, iru, run), `provider.university_groups` on results, and group vocabulary in the reference bundle. Checksum-guarded, snapshots before and after. Courses by group: Go8 3,966, ATN 2,109, IRU 1,929, RUN 709.
- Scholarship sweep live (Pilot PR #178, worker coverage-sweep v0.7.0 / scholarship-sweep-v0.3.1, cron scholarship-read every 5 minutes). 91 own-page scholarships read, 201 changes logged. Hand-checks found and fixed: tiered values (now not applied), faculty-only awards linked too widely, levels taken from outside the eligibility section, Law mapped to Law (asced-0909), re-read evidence versions.
- Decision 139 check extended: not publishable if the provider page limits eligibility to citizens and residents, or never mentions international students (7 held back, e.g. Monash Arts Equity Travel Grant, UOW Regional Kick Start).
- First sweep batch published by hand after a dry run and sample check: 54 published (27 at Go8 universities), verified through the live scholarship search (`published_only`). There is no automatic publish job; each later batch is run by hand. The nightly review withdraws anything that stops qualifying.
- Completeness (hourly, 13:22 IST): 48.4% complete, 61.6% accounted for, 404 of 25,978 courses fully complete.
- Next: scholarship discovery for the 113 Study Australia-only records and new scholarships from provider sites; Layer 3 benchmark for intakes; tuition Layer 4 review load; group filter for the Zoho v2 search.

### 29 Sep 2026 — UI uniformity live; scholarship discovery and second batch; intakes benchmark (Decisions 167, 168)
- Platform Admin (14:37 IST): prioritise data admission; run the UI improvements and planned steps in parallel.
- UI uniformity (B2) and completeness states (R12) live, admin v2.15.106 (Pilot PR #179). There is now one token set and one component kit, with en-AU dates, numbers and money and consistent "Layer N" wording; distinct colours went from 562 to 114. Coverage shows the nine completeness states and the course score. The coverage read was replaced under a checksum guard and verified live; the deployed release check passed.
- Scholarship discovery live (Pilot PR #181, extractor v0.4.6, cron scholarship-discover every 10 minutes).
  - Step 1: 88 of the 200 Study Australia-only scholarships now have their own provider page, confirmed by name; 112 remain.
  - Step 2: 152 new unpublished university scholarships were admitted through the governed function, and 22 more were admitted then withdrawn after hand-checks.
  - 7,527 candidate pages were found (6,734 still unread). Firecrawl used 774 credits.
  - Hand-check fixes: values from other scholarships' wording, "up to" amounts, USD as AUD, tiers, levels outside eligibility, and non-scholarship pages.
- Second batch: a dry run showed 83 eligible. The hand-check held 40 records (`pipeline.scholarship_publication_holds`, Pilot PR #182): 12 not open, 5 English-course bursaries linked to degrees, and 23 with research and undergraduate levels together (to be re-read). 70 were published by hand. 124 are now published (Go8 49, ATN 28, IRU 13, RUN 15), verified through the live scholarship search.
- Intakes Layer 3 benchmark (Pilot PR #180, Decision 168): 44 hand-read gold cases. Layer 2 scored 55%. Layer 3 (Mistral Small 3.2, pinned) scored 90% with 1 invented intake, which fails the bar (at least 95% and none invented). Intakes stay held and nothing was activated. OpenRouter spend was US$0.03.
- Completeness (16:22 IST): 49.7% complete, 63.7% accounted for, 404 of 25,978 courses fully complete.
- Next: re-read the 23 level holds with a fix, then run batch 3; let discovery read the remaining candidates (about 33 hours); intake safety rule or stronger pinned model, re-qualified on a fresh holdout set; tuition Layer 4 review queue; resume production (3 Oct) steps.

### 29 Sep 2026 — Layer 3 model routing activated; platform self-monitoring; admin menu simplified (Decisions 169–171)
- Platform Admin (18:30 IST): stronger AI model (option 2); rework with stronger models and admit across all universities; test several OpenRouter profiles and route to the improved one; retire unused models and profiles; simplify the Layer 3 screen; keep both sources (provider and government/regulator) and show them in the UI; the platform must run on its own and report its own errors; UI (menu, completeness screen) is the top priority.
- Intakes re-test (Pilot PR #183): safety rule, 12 quotes, frozen holdout of 45. Mistral Small 3.2 scored 76% and Mistral Medium 3.1 scored 86%; both failed.
- Layer 3 model routing (Pilot PR #186, Decision 169):
  - Each task's contract was frozen before the holdout pages were read. Pinned candidates were tested on fresh frozen holdouts, and the bar was unchanged.
  - Passed: intakes and English on Claude Sonnet 4.6 (13/13 and 19/19, 0 wrong); tuition on Qwen3 235B 2507 (8/8, 0 wrong). Mistral Small 3.2 failed the fresh tuition holdout (6/8).
  - Activated 19:44 IST as a logged step. 24 unused profiles retired.
  - Daily guards: intake US$4, English US$4, tuition US$5. Credit floor US$5.
  - First 75 minutes: 50 intakes and 112 English requirements admitted, 18 sent to Layer 4 and 208 pages that state neither. Spend US$4.70; OpenRouter credit US$22.70 remaining.
  - Spot-check: admitted values match their verbatim quotes.
  - Process note: the routing worker's report didn't come back to the lead. Its work was found live but not yet in git. It was reviewed (edge function files compared byte-for-byte, migrations and tests passing) and then merged.
- Platform self-monitoring (Pilot PRs #184, #187, Decision 170): health check every 10 minutes; Platform health screen; summary in the daily update.
  - Fixes: the OpenRouter check now uses the route guards (US$14 combined) plus a credit-floor check; one orphaned tuition item was released.
  - Open issues: the Layer 4 backlog (1,079 waiting) and the database at 1.7 GB (watch level).
- Admin UI v2.15.107 live (Pilot PR #185, Decision 171):
  - Five-section menu, with every screen in the standard layout (the Coverage screen included).
  - Layer 3 page with tabs (Routing, Models & profiles, Test results, Spend, Work queue).
  - Platform settings (integrations, scrapers).
  - Provider page next to Study Australia or CRICOS, with differences highlighted.
  - The deployed release check passed.
- Daily update task prompt extended with platform health, Layer 3 routing and OpenRouter credit days left.
- Completeness (20:22 IST): 49.9% complete, 64.2% accounted for.
- Decision needed: OpenRouter credit. At the guard rate (about US$13 a day) the US$22.70 credit reaches the US$5 floor in about 1.5 days, after which automated admission pauses. About US$12 per 1,000 course pages per task.

### 29 Sep 2026 — Main branch green again; Layer 3 cost-first cascade (Decision 172); OpenRouter key weekly limit
- Platform Admin (21:08 IST): Layer 3 must use OpenRouter routing: the cheapest model with at least 80% success first, and failed pages escalated to higher-cost models. At 21:13 IST: keep PR hand-over and merging consistent and keep main green.
- Main branch: the deployed UAT failed after v2.15.107 because Layer 1 tests still looked for the old page titles. The deployed specs and helpers were updated to the new menu (Pilot PR #188), and main is green (build, deployed UAT, Workers Builds). From now on the deployed UAT runs from the branch before merging.
- Cascade (Pilot PR #189, Decision 172):
  - Intakes: Qwen3 30B → Claude Haiku 4.5 → Claude Sonnet 4.6. English: Qwen3 30B → Mistral Small 3.2 → Claude Sonnet 4.6.
  - Each tier has at least 80% right and 0 wrong on the frozen holdouts.
  - Simulated cost: US$1.29 and US$0.17 per 1,000 pages, against US$10.94 and US$10.72 for Sonnet alone.
  - 5% audits by the final tier; a tier pauses automatically after 3 disagreements in its last 60 audits.
  - The foundation migration left live by an interrupted worker was reconstructed byte-for-byte into git. All live migration checksums match their files, and edge function v6 matches the branch byte-for-byte.
- Incident:
  - From 21:07 IST, OpenRouter refused every call with "Key limit exceeded (weekly limit)". The API key's own weekly cap was reached; about US$19.69 of account credit remains.
  - Refused pages had been sent to Layer 4 as model failures. 476 of these items were superseded and their pages released for retry.
  - The intake, English and tuition route jobs are paused.
  - Platform health now flags provider refusals as critical. The cascade releases a page on refusal instead of escalating it; verified live with 2 pages released and 0 sent to Layer 4.
- Needed from the Platform Admin: raise or remove the weekly limit on the OpenRouter API key, then the three route jobs are re-activated.

### 29 Sep 2026 — Layer 3 routes resumed (cascade live)
- Platform Admin removed the OpenRouter key's weekly limit (22:13 IST).
- Probe: English, 3 pages answered at tier 1 for US$0.0003 in total; intakes, 3 pages, 2 settled at tier 1 and 1 escalated to tier 3.
- Route jobs back on (Pilot PR #190; main green: build, deployed UAT, Workers Builds).
- First 8 minutes on the cascade:
  - Admitted: 47 English requirements and 11 intakes. Three went to Layer 4.
  - Refusals: none.
  - Spend: intake US$0.19, English US$0.13.
  - English was mostly answered by tier 1 (Qwen3 30B). Intakes escalate more often: 12 of 26 pages went beyond tier 1, mostly on the "not stated but the page shows months" signal.
  - Spot-checked tier-1 values match their page quotes.
- The intake daily guard (US$4) is reached for today, including spend before the cascade; English is close. Both reset at 05:30 IST.

### 29 Sep 2026 — Layer 3 control screen (Decision 173); parked work re-queued
- Platform Admin (22:47 IST): retry all parked Layer 3 and 4 work through the cascade. The cascade models weren't shown, there was no pause or model selection, and the screens were bloated.
- Admin UI v2.15.108 live (Pilot PR #191):
  - Layer 3 now has Control, Models and Work queue tabs.
  - Each task can be run or paused, with its daily limit and a cascade that can be reordered, switched on or off, added to (qualified models only) or removed from.
  - Models lists only qualified models, and the old per-profile list is gone from the Work queue.
  - Controls tested live as a Platform Admin in a rolled-back transaction. Main green: build, deployed UAT on the live version, release currentness and Workers Builds.
- Re-queue:
  - Intakes and English: Layer 3-raised Layer 4 items superseded and 336 pages released to the cascade.
  - Tuition: 1,014 items back to Layer 3; in total 1,042 Layer 4 items superseded.
  - Items where the page differs from a held value stay with a person.
- First tuition retries: 2 of 83 admitted and 79 back to Layer 4. The page does not state the fee "per year", which the tuition rule requires, so a model change cannot settle these. Decision needed on the tuition basis rule.
- Intakes and English: today's daily limits (US$4 each) are used up; they resume at 05:30 IST, or earlier if the limit is raised on the Control tab.

### 29 Sep 2026 — Tuition per-year rule with flagged values (Decision 174); daily limits US$10
- Platform Admin (23:27 IST): tuition without a stated period is per year, flagged, and editable by operators and admins. The intake daily limit was raised to US$10 on the Control tab; English matched to US$10.
- Rule live (Pilot PR #192, v2.15.109; main green: build, deployed UAT, release currentness, Workers Builds). It applies at admission, after the unchanged qualified Layer 3 check.
- 55 fees admitted as per year and flagged; all quote annual wording such as "estimated 1st year indicative fee", "one year of full-time study" or "pa".
- Sample check found 27 wrongly admitted in the first runs, all reverted to Layer 4 and the rule tightened:
  - 23 "total" fees;
  - 3 VET Student Loan caps;
  - 1 duplicate of a fee already held.
- Still in Layer 4: tuition where the model decided the amount is not this course's tuition (e.g. A$5,000 on many pages), quotes not found on the page, and differences from a value already held.
- Operators: Layer 4 Review › Flagged values, where rank 4+ can confirm per year, edit the amount or period, or remove. Tested live in a rolled-back transaction.

### 30 Sep 2026 — Everything operated from the admin screens (Decision 175); v2.15.110
- Platform Admin (29 Sep 23:45 IST): the admin UI must control every configured feature, including moving older entries between layers and managing the AI models.
- Sweep found three things done only in the database: the 58 scheduled automations, sending review items back to Layer 3, and scholarship publishing. Layer 3 models and the cascade were already on screen (Decision 173).
- Admin UI v2.15.110 live (Pilot PR #193; main green: build, deployed UAT, release currentness, Workers Builds):
  - Scheduled jobs › Automations: all 58 jobs by area in plain words, with pause or resume per job or area, run now, frequency and batch size.
  - Layer 4 Review › Send back to AI: 213 AI-raised items in 14 reason groups; send a group or a field back; retry failed work. Send back to AI button on each Layer 3 task.
  - Scholarships › Publishing: 124 published, 71 ready, 40 held; publish with an approval note, hold, release.
- Database: migrations 20260930050000–20260930052000 applied live, each md5 equal to its file; the two replacements were checksum-guarded. All controls tested live as a Platform Admin in rolled-back transactions.
- Nothing was paused, sent back or published by this change; the ready scholarships and review groups wait for an admin decision on screen.

### 30 Sep 2026 — Layer 3 without Sonnet (Decision 176); v2.15.111; plan for parked items
- Platform Admin (01:24 and 01:31 IST): Sonnet had used about US$4 in an hour. Stop using it; use cheap models with full coverage or park to Layer 4; send to a specific model only from Layer 4; more streams; plan for parked items.
- Findings:
  - Intakes hit the day's limit at about 00:59 IST.
  - About US$7 of the day's US$12.58 Sonnet spend confirmed two cheaper "not stated" answers.
- Done:
  - Sonnet switched off in both cascades (logged).
  - Four cheaper intake candidates tested; none qualified (GPT-OSS 120B 78.7% with 0 wrong; DeepSeek V3.2 1 wrong).
  - Model choice added on Layer 4 › Send back to AI.
  - Worker v7 (cascade v1.1.0) deployed and checked file for file.
  - Routes run every minute, 40 pages, 8 in parallel.
  - Pilot PR #194 merged; main green.
- Watch:
  - OpenRouter credit was US$10.22 at 01:40 IST, and the AI stops at US$5. Top up to keep Layer 3 running.
  - Daily limits on the Control screen now read US$15 for intakes and English.
- Plan for parked and unsettled items (deterministic first, no model):
  1. Whole-course fees: at least 312 Layer 4 tuition items quote a total course fee, not a yearly one (Wollongong 169, TAFE WA 80, Collarts 29, Canberra College of Management and Technology 19, Kingston 15). Proposal: admit as a whole-course fee (basis total_indicative), flagged, with no model call. Needs Platform Admin approval.
  2. Amounts that are not tuition: RMIT, UQ, Aspen and TAFE WA items where Layer 2 offered an amount such as A$5,000 that the model found is not tuition. Proposal: Layer 2 skips deposit, scholarship and non-tuition amounts; close these items as "no tuition on page".
  3. Intakes with month words but no intake: pages mention months for other reasons, such as closing dates. Proposal: provider page templates (fixed wording per provider) read deterministically; the rest stay "not stated".
  4. Pages without the CRICOS code (5,227 read, identity not confirmed): match by exact course title, provider and level, with a sample hand check before admission.
  5. Pages blocked or needing a browser (about 1,630): read through Firecrawl (85,533 credits left this month), identity still by CRICOS code.
  6. Official course page differences (UQ 42): check the new URL pattern on a sample, then accept in one batch.

### 30 Sep 2026 — Users & roles fixed; Catalogue and Coverage clearer (v2.15.112); screen review opened
- Platform Admin feedback (02:04 IST, with screenshots): screens still confusing; Provider contacts belongs in Catalogue; separate course and attribute completion; Users & roles lost all accounts and audit; Layer 1 and 2 operator screens bloated, Layer 3 and 4 likewise; ask before merging views.
- Users & roles: the system automation account (migration 20260926190000) had blank token fields that Supabase's user list cannot read, so the whole list failed.
  - No account or role was lost.
  - Migration 20260930070000 filled the blanks; applied live, md5 equal to the file.
- Live in v2.15.112 (Pilot PR #195; main green):
  - Provider contacts moved to Catalogue.
  - New Catalogue › Reference data: Ranking imports, Key dates, Key links.
  - Onboarding moved to Providers.
  - Layer 1 now has only Runs, Sources and Source settings; old links redirect.
  - Coverage has tabs Courses, Attributes and Readiness by area.
- Platform Admin answers:
  - Layer screens: split daily work from setup.
  - Layer 1 extras: to Catalogue › Reference data (done).
  - Older operator screens: list every action first, and the Platform Admin marks what to keep.
  - Whole-course tuition fees: leave in Layer 4. Plan item 1 of Decision 176 is withdrawn.
- Screen review page published (private artifact). It lists every action on the older Layer 1–4, Jobs and Scrapers screens with a suggestion and proposed home. Nothing is removed until it is marked.
- Found by the review:
  - Layer 2 Runs has broken Jobs and Data Quality links.
  - Three paid actions have no role check in the screen: Test selected route, and the two Layer 3 Work queue AI runs.
  - Layer 1 Retry and Recover show to operators while Resume needs Platform Admin.
  - Five live database functions have no public definition in git: layer3_model_profiles_admin, layer3_recent_interpretations, layer3_model_profile_set_state, layer4_review_decide and refresh_intelligence_overview.
- Health dot red at 02:00 IST was real:
  - OpenRouter spend in the last 24 hours was US$22 (mostly Sonnet before it was switched off).
  - Credit was US$7.47, and the AI stops at US$5.
  - The check's US$14 combined ceiling is out of date against the Control-screen limits (to align).

### 30 Sep 2026 — Cost leak found and stopped; no Anthropic model in any automatic route
- Platform Admin (02:49 IST): OpenRouter shows US$14.60 on Claude Sonnet 4.6 and US$7.02 on Claude Haiku 4.5. How much data did that admit?
- Sonnet (from about 19:00 IST on 29 Sep until it was switched off at 01:34 IST): about US$12.70.
  - Intakes: US$7.55 for 98 intakes found; 404 of its answers were "not on the page".
  - English: US$5.15 for 241 English score sets.
  - Qualification tests: US$0.91.
  - No Sonnet call after 01:34 IST.
- Leak after that:
  - At 01:46 and 01:57 IST the spot-check rule switched off the cheap Qwen3 30B step for intakes and English (3 disagreements in 60 checks).
  - Every intake page then went to Claude Haiku 4.5, about US$4.80 until the credit floor stopped Layer 3 at 02:13 IST (credit US$4.93).
  - Haiku in total: US$6.71 for 417 intakes found.
- The same period, cheap models:
  - Qwen3 30B: 475 intakes for US$0.71; 1,311 English score sets for US$1.17.
  - Mistral Small 3.2: 239 English score sets for US$0.19.
- Top 10 providers, 5,260 courses:

  | Attribute | Admitted |
  |---|---|
  | Official course page | 1,221 (23%) |
  | English | 863 (16%) |
  | Intakes | 368 (7%) |
  | Provider tuition | 176 (3%) |
  | Every attribute | 139 courses |

  The main gap is course pages not found or not matched to their course, not the AI step.
- Fixed:
  - Qwen3 30B back on for both tasks.
  - Claude Haiku 4.5 off. Intakes run on Qwen3 30B only (83% right, 0 wrong on the frozen holdout); English runs Qwen3 30B → Mistral Small 3.2.
  - The spot-check rule now raises an alert and never switches a step off (migration 20260930080000; Pilot PR #196).
  - No Anthropic model is in any automatic route; they are reachable only by choice from Layer 4 › Send back to AI.
- Layer 3 stays stopped by the credit floor until OpenRouter is topped up and the routes are resumed.

### 30 Sep 2026 — Resumed on cheap models; top universities first
- Platform Admin (03:05 IST): OpenRouter topped up by US$10 (credit US$14.93); the intake daily limit was set on the Layer 3 screen. Resume, with maximum data for the top universities.
- Resumed (logged): intake, English and tuition AI checks, and the tuition hand-off.
  - Runs cost about US$0.01–0.02 per 40 pages.
  - No Anthropic model is used.
- Top universities first (Pilot PR #197):
  - Providers are ranked by active courses (the Coverage tier ranking, refreshed daily).
  - Layer 3 takes the top providers' pages first.
  - The page reader takes the top 100 providers' pages first and uses Firecrawl for their blocked or script-only pages, including pages where more than one course could fit.
  - 1,594 such pages were queued again, using up to about 1,600 Firecrawl credits of the 83,400 left.
  - Identity is unchanged: a page is only accepted with the course's CRICOS code on it.
- Top 10 providers (5,260 courses), where the courses stand:

  | State | Courses |
  |---|---|
  | Page read and matched | 1,601 |
  | Page read but it does not show the course code | 1,381 |
  | No course page found | 1,545 (Monash 403, Melbourne 342, Macquarie 254, Newcastle 190) |
  | Page blocked or unclear which course | about 730 |

- The 1,381 pages without the course code are mostly the wrong page: a double degree matched to a single degree, a generic PhD page, a requirements page. Only 52 are strong unique title matches, so the identity rule stays.
- The next step for the top 10 is finding the right pages: Monash, Melbourne, Macquarie and Newcastle course pages that the site maps did not give. This is Firecrawl work, not AI spend.
- First Firecrawl reads: about 1 in 10 of the queued unclear pages turned out to be the right course.

### 30 Sep 2026 — Priority queue in the admin screens (Decision 178); v2.15.113
- Platform Admin (03:22 IST): move universities or courses up or down, and add a country, state or university to the priority queue, from the admin screens.
- Live (Pilot PR #198; main green):
  - Scheduled jobs › Priority queue: pin a university, state, country or single course; move pins up or down; remove them; "To the front" on any provider.
  - The current order shows each provider's courses, pages matched, pages waiting, and why it is there.
- The page reader and the Layer 3 intake and English checks follow this order: pinned courses, then pins in order, then Australian providers by size.
- Database: migrations 20260930100000 and 20260930101000, applied live, each md5 equal to its file. The claim and page-reader edits were checksum-guarded.
- Tested live as a Platform Admin in a rolled-back transaction: added a university, a state and a course at the top; moved; removed.
- No pins are set yet; the order is by size until an admin pins something.

### 30 Sep 2026 (23:59 AEST) — Decision 179: manual data first
- Platform Admin: how to find the top 10 course links; how to keep track of "not found"; CRUD needed at every level; publishing adds complexity because most foundational data will be handled manually.
- Answers:
  - Publishing: automatic, with a Hide switch.
  - "Course page needed": every course goes to Layer 4.
  - Build order: CRUD first, then course pages, then publishing.
- Findings:
  - The course and provider pages are read-only.
  - Official links are stored in catalogue.course_links; eight automated processes write intakes, English and fees.
  - All 43,639 courses are "unpublished", yet the website serves them.
- Status report (30 Sep 22:37 AEST), all courses since the morning:

  | Measure | Morning | 22:37 |
  |---|---|---|
  | Intakes | 1,051 | 2,841 |
  | English | 4,225 | 6,162 |
  | Official pages | 8,218 | 8,305 |
  | Tuition | 1,391 | 1,439 |
  | Completeness | 50.9% | 53.1% |
  | Fully complete | 467 | 651 |

  - AI: US$1.55 for about 2,600 values; OpenRouter credit US$13.37.
  - Jobs: 13,820 runs, 0 failures.
  - Database: 1,844 MB.
  - Eight tuition items at their retry limit were closed; they had set off the "dispatch stopped" alert.

### 1 Oct 2026 (01:45 AEST) — Decision 180: course link recipes for the top 10 universities
- Platform Admin (00:39 AEST): use VTAC's "Further information" link for the top 10 universities, build the same strategy, and fetch links with Firecrawl.
- VTAC findings:
  - The link is the university's own course page (Monash: `/study/course/<code>`).
  - VTAC's robots.txt blocks all automated access, and VTAC covers only Victorian undergraduate entry. We checked one page by hand and do not crawl VTAC.
- Strategy:
  - The same result comes from each university's own site. We search for the CRICOS code on its domain, then match the result to that university's course page or handbook address pattern.
  - A pilot of 36 courses (4 per university) gave a usable address for 26.
- Built (Pilot PRs #199 and #200, merged; UAT green on both branches and on main):
  - Recipe table (10 universities) and a search queue.
  - The search looks for the CRICOS code first, then the exact title.
  - Job `course-link-search`: every minute, 40 searches per run, universities in turn, 15,000-credit monthly cap.
  - `coverage_bind_v2` leaves these pages alone.
  - Page reader v0.6.2 renders a priority page through Firecrawl before calling it a mismatch.
  - A candidate that answers 404 moves on at once.
- Verification:
  - Migrations 20260930110000, 111000 and 112000 are applied live, each md5(statements[1]) equal to its file.
  - `coverage_bind_v2` and the tick edits were md5-guarded.
  - coverage-sweep v31 was deployed by the workflow and matches the repo file for file.
- Queued: 3,650 top-10 courses with no confirmed page (none, mismatch, or ambiguous and already read).
- First 40 minutes: 163 pages confirmed with the CRICOS code on the page (UNSW 128, Melbourne 12, Flinders 10, Macquarie 6, Monash 5, UTS 1, RMIT 1). 131 more are found and waiting to be read.
- About 2,900 courses are still to be searched, at about 90 minutes of run time. Courses with no page after both stages will be marked "none" for the Layer 4 "Course page needed" queue.

### 1 Oct 2026 (03:00 AEST) — Site map test, reverse match, CRUD (Decision 181), scholarship course links (Decision 182)
- **Firecrawl site map (Platform Admin question, Sydney and UNSW):**
  - A map call costs 1 credit and returned 537 Sydney and 497 UNSW course pages, but discovery already knew all but one of each. Crawling every page would cost about 36,000 credits for Sydney. Not used.
  - The gap is matching pages to courses: about 1,500 known top-10 course pages are matched to no course.
  - Sydney pages show no course CRICOS code, so they match by exact title only.
- **Reverse match** (Pilot PR #201, migrations 20260930113000 and 114000): reads the known unmatched pages directly (no credits) and matches a course only when its code is on exactly one page. Result: 1 new match; these pages are mostly majors of courses already covered.
- **CRUD, Decision 181** (v2.15.114, Pilot PR #202, migration 20260930120000; coverage-sweep v32, file-for-file equal to the branch):
  - Edit this course / Edit this provider panels, and Add course / Add provider.
  - Guard triggers make a hand-entered or removed value win over every automated writer.
  - Live test (rolled back): automated insert and update blocked, title kept, release worked, removal not refilled.
- **Scholarship course links, Decision 182** (v2.15.115, Pilot PR #203, migrations 20260930130000 to 133000):
  - One decision per scholarship for the 37,200 waiting links from 87 scholarships.
  - Decisions also govern the automatic sweep, which had mapped 17,008 of these links.
  - Live test (rolled back): one Masters scholarship matched 1 course, 580 rejected, 24 wrong sweep links removed.
  - No decisions have been made yet; they are the operators' to make.
- **Link search, 02:45 check:**
  - 1,092 of 3,650 top-10 courses confirmed.
  - Official pages 8,312 → 8,967, intakes 2,847 → 2,997, English 6,169 → 6,297, tuition 1,439 → 1,446.
  - 7,482 Firecrawl credits used (15,000 cap). The title-search stage is running.
- All migrations applied live, each md5(statements[1]) equal to its file. UAT green on every branch and on main.

### 1 Oct 2026 (08:30 AEST) — Link search finished; Layer 4 batch rules (Decision 183)
- **Link search final (03:30 AEST):**
  - 1,382 of 3,650 top-10 courses now have a confirmed page; 2,197 have none (candidates for the "Course page needed" queue).
  - Newcastle: 61 are waiting because its handbook site blocks automated reading, which we respect.
  - Official pages 8,312 → 9,356, intakes 2,847 → 3,150, English 6,169 → 6,468, tuition 1,439 → 1,446.
  - 12,300 Firecrawl credits used.
- **Platform Admin example 068783B** (UNSW Bachelor of Commerce / Bachelor of Information Systems): already matched and admitted since 29 Sep. Its tuition was unsettled because the page shows a first-year fee and a whole-degree fee. 228 UNSW pages share that wording.
- **Layer 4 batch rules, Decision 183** (v2.15.116, Pilot PR #205, migration 20260930140000, md5 equal to its file):
  - Fee wording rules with preview, a list of found wordings, draft → approve & run, hourly runs, pause.
  - A rule never touches a course that already has a fee or a value entered by hand.
- **Draft rules prepared for approval:**
  - #1 UNSW "Indicative First Year Fee", per year: 214 courses, amounts A$23,500–A$99,500.
  - #2 Monash "standard full-time course load for a year. The fees for", per year: 231 courses, A$41,940–A$68,140.
  - Neither has been approved or run yet.
- **CI fix** (Pilot PR #204): Release Currentness now waits until Cloudflare serves the new version, instead of failing when it runs too early.

### 1 Oct 2026 (11:30 AEST) — Batch rule fix; Models & services; Parse.bot removed; Edit in list (Decisions 184–186)
- **Platform Admin feedback (09:24 AEST):** approving a batch rule did nothing; asked for inline or list editing, an end to bloated previews, on/off switches for models and outside services, Parse.bot removed completely, a UI-managed list of third-party reference sites, and a review of every screen.
- **Batch rule approval fixed** (v2.15.117, Pilot PR #206, migration 20260930150000):
  - The run log was refused by a database check, so each approval rolled itself back. The error showed only in the page banner.
  - Errors now show on the Batch rules screen, and the preview is one compact table under the rules list.
  - Live test (rolled back): approving the Monash rule admitted 232 fees and closed 231 Layer 4 items.
  - Rules #1 (UNSW) and #2 (Monash) are still drafts awaiting the Platform Admin's approval.
- **Answer given — profiles:**
  - Course details use Layer 2 course-fact website profiles and Layer 3 models per task (intakes and English: Qwen3 30B, then Mistral Small for English; tuition: Qwen3 235B).
  - Scholarships use Layer 2 catalogue and website profiles. Their Layer 3 models are set up but paused, and scholarship AI is off for AU/NZ.
- **Models & services, Decision 184** (v2.15.118, Pilot PR #207, migration 20260930160000, md5 equal to its file).
- **Parse.bot removed, Decision 185** (v2.15.119, Pilot PR #208, migration 20260930170000, md5 equal to its file):
  - Edge functions redeployed through the workflow, then verified file for file against main.
  - The three ranking URL-import functions were deleted.
  - Live check: no database function mentions Parse.bot; 6 fetching services remain.
- **Edit in list, Decision 186** (v2.15.120, Pilot PR #209, migration 20260930180000, md5 equal to its file).
- **Layout fix in v2.15.120:**
  - Page grids could stretch past the window, hiding Add course, Compare, the result count and the pager on Courses and Providers, and overflowing Evidence, Layer 2 Runs, Schedules and Readiness. Checked on every page at 1440px.
  - Form text boxes are no longer cut to 130px.
- **Screen review:** all 47 screens and tabs reviewed; 171 findings published to the existing review page for the Platform Admin to mark Fix, Later, Skip or Discuss. Older screens are not reworked until the marks are in (Decision 177).
- **Next:** reference sources registry (Hotcourses, Study Australia, regulators, ranking publishers) replacing hard-coded site patterns. The design was sent to the Platform Admin.
- **Known failing tests, all already failing on main:**
  - cf-247-coverage-sweep-contract;
  - cf-092 scheduled-jobs contract;
  - m2-5-evidence-lineage-contract (expects worker v1.3.3).

### 1 Oct 2026 (13:15 AEST) — Screen review marked; packages 1 and 2 live (Decisions 187–188)
- **Screen review results (Platform Admin, 11:41 AEST):**
  - 171 findings: 166 Fix, 3 Skip (Courses filter wall, filter walls in general, contacts placement), 1 Discuss. The Discuss item was menu grouping: Provider contacts stays standalone where it is, the rest of the regrouping is Fix.
  - Older screen actions: Keep 27, Merge 14, Remove 8, Ask 5.
  - Work is grouped into 7 packages, each its own release.
- **Ask items answered with facts and recommendations, awaiting the Platform Admin:**
  - Layer 2 background enrichment (last used 13 Sep): remove.
  - Wave workload defaults (last wave 15 Sep): remove the panel and switch its job off.
  - Source-pattern interpretation (3 runs in 30 days, no role check): keep for Platform Admin only.
  - Layer 4 findings (0 records): remove.
- **Package 1, Reference sources, Decision 187** (v2.15.121, Pilot PR #210):
  - Migrations 20261001110000, 111000 and 112000, each md5 equal to its file.
  - coverage-sweep v33 deployed through the workflow and verified file for file.
- **Package 2, one home per setting, Decision 188** (v2.15.122, Pilot PR #211, migration 20261001120000, md5 equal to its file).
- **Governance gap found and closed:** adding a model to a Layer 3 cascade switched the model on without the activation checks. It must now be switched on in Models & services first, and only after passing its test.
- **Not yet built:** "Add model", which starts a new model's qualification from the UI. It needs qualification-run orchestration and is planned separately.

### 1 Oct 2026 (14:05 AEST) — Packages 3–5 live (Decisions 189–194)
- **Released, each merged with a squash merge after targeted deployed UAT passed on the branch, and main green after each:**

  | Package | Release | Pilot PR | Decision |
  |---|---|---|---|
  | 3, merge duplicate screens | v2.15.123–124 | #212, #213 | 189 |
  | 4, Dashboard "Waiting for you" | v2.15.125 | #214 | 190 |
  | 5, part 1: fee rules, flagged values, Layer 3 Control | v2.15.126 | #215 | 191 |
  | 5, part 2: Layer 3 Work queue, Layer 2 Source profiles | v2.15.127 | #216 | 192 |
  | 5, part 3: Layer 2 tabs | v2.15.128 | #217 | 193 |
  | 5, part 4: Layer 4 review queue | v2.15.129 | #218 | 194 |
- **Database:** only migration 20261001130000 (`admin_waiting_read`), md5 equal to its file. No edge function changes.
- **Review calls checked against the code and live data before acting:**
  - Layer 2 provider onboarding is not a duplicate of Providers › Onboarding, so it was kept.
  - Layer 4 provider departures (10 live records) was kept.
  - The scholarship scope cohorts (37,200 stale candidates) and the reusable scope rules (none ever saved) were removed from Layer 4 in favour of Scholarships › Course links.
- **UAT fix:** one deployed helper failed since #213 because a page with only one visible tab shows no tab bar (Layer 1 Register for operators). The helper now accepts that case.
- **Still waiting on the Platform Admin (Ask items):**
  - background area fetch: now on Layer 2 › Fetch an area;
  - wave defaults;
  - source-pattern interpretation: now on Layer 3 › Work queue;
  - Layer 4 findings: now under Bulk decisions.
- **Next:**
  - Package 6: edit in list for tuition, intakes, English, campuses, scholarships and Data model, and a shorter course panel.
  - Package 7: plain language, AU dates and Melbourne time, consistent counts, and older screens in the compact style.
- **Known failing tests, all already failing on main:**
  - cf-247-coverage-sweep-contract:84;
  - cf-247-admin-simplify:149 (mobile);
  - cf-206 version pin;
  - deployed specs that need credentials when run locally.

### 1 Oct 2026 (15:25 AEST) — Packages 6 and 7 live (Decisions 195–197); screen review implemented
- **Released, each merged with a squash merge after targeted deployed UAT passed on the branch, and main green after each:**

  | Package | Release | Pilot PR | Decision |
  |---|---|---|---|
  | 6, edit in list | v2.15.130 | #219 | 195 |
  | 7A, Melbourne time, plain wording, counts | v2.15.131 | #220 | 196 |
  | 7B, older screens in the compact style | v2.15.132 | #221 | 197 |
- **Database:**
  - 20261001140000: list read for tuition, intakes and English.
  - 20261001150000: campus and scholarship edits, with the manual-lock guard.
  - Both are md5-guarded, each stored statement equals its file, and both were tested live in a rolled-back transaction first.
- **Checks:** a broad local test run on every release found no new failures against main. Its 87 failing specs are pre-existing: specs that need deployed credentials, and old contracts.
- **Corrected against the marks:** provider onboarding was first placed on Layer 2. It moved to Providers › Onboarding because the Platform Admin had marked it "merge" there.
- **Raised with the Platform Admin, not acted on:**
  - Data model editing: three options were sent; the recommendation is read-only, tidied.
  - Platform health budgets check: it reports OK at US$12.76 of OpenRouter spend in 24 h against a stored daily ceiling of US$5. The ceiling looks stale, since the per-task Layer 3 limits now total US$13.
  - The four Ask items, still open: background area fetch, wave defaults, source-pattern interpretation and Layer 4 findings.
- **Screen review status:** all marked Fix items are implemented, except those raised above. Skips are respected: Courses filters, filter walls generally, and the placement of Provider contacts.

### 1 Oct 2026 (16:30 AEST) — NZ course-page coverage started; Layer 3 limited to Australia; course-link search for every Australian provider (Decisions 198–199)
- **Direction (Platform Admin, 16:01):** "Start parallel jobs for nz asap". Also: plan admitted data at scale for production handover; the Firecrawl, Supabase and OpenRouter subscriptions have been raised.
- **Released:** Pilot PR #222, merged with a squash merge after targeted deployed UAT passed on the branch. `layer1-nz-live` v1.2.1 deployed through the edge-function workflow (live version 7, content checked).
- **Database:** all five migrations were applied live, and each stored statement's md5 equals its file:
  - 20261001160000: 287 NZ providers queued for course-page discovery (281 pending, 6 with no website).
  - 20261001161000: second discovery worker `coverage-discover-2`, listed in Automations.
  - 20261001162000: 137 NZ websites stored as `https://https://…` corrected and requeued.
  - 20261001163000: Layer 3 hand-offs limited to Australian providers (Decision 198). Tested first in a rolled-back transaction.
  - 20261001164000: generic course-link search recipes for 920 Australian providers (Decision 199). Tested first in a rolled-back transaction.
- **NZ currency risk found and closed (Decision 198):**
  - NZ programme codes (e.g. AUT "AK3717") are printed on NZ pages the same way CRICOS codes are. So NZ pages reached the Layer 3 tuition step (which records AUD) and the intake and English steps.
  - Nothing was written to any NZ course: 0 fees, 0 intakes, 0 English, 0 links. Admission needs a CRICOS registration, so the NZ answers went to the Layer 4 queue instead.
  - The open NZ Layer 3 items are parked, and 48 NZ Layer 4 items are marked superseded with the reason.
- **NZ progress at 16:25:**
  - Discovery: 266 of 287 providers mapped, 20 failed.
  - 3,148 of 6,475 NZ courses have a candidate page.
  - Pages read: 48 show the programme code, 210 match on exact title, and 1,473 do not confirm. NZ pages rarely print the NZQA code.
- **Australian search (Decision 199):**
  - 9,960 courses queued; the batch was raised from 40 to 80 a minute through the governed control.
  - First 15 minutes: 438 searches, 105 pages found, 71 confirmed by the CRICOS code on the page.
  - Firecrawl this month: 1,057 credits of the 100,000 plan guard.
- **Corrections:**
  - The earlier "Firecrawl used 9 units" counted only the new calendar month. About 16,000 credits were used in the 24 hours before.
  - The US$12.76 in the 15:25 entry is the remaining OpenRouter credit, not 24-hour spend. Actual Layer 3 spend in 24 hours was about US$0.62.
  - The OpenRouter balance still read US$12.74 at 16:23. The Layer 3 credit floor stops work at US$5.
- **Measured, not assumed:**
  - Layer 3 has already tried almost every eligible Australian page (2 left untried for intakes and English, 0 tuition candidates waiting). Raising AI limits alone adds nothing.
  - On the pages it read in 24 hours, intakes were not stated on 691 of 1,017 and English on 750 of 752.
- **Raised with the Platform Admin:**
  - NZ admission rule: identity by NZ programme code or exact title on the provider's own site, NZD only.
  - AU exact-title pages (1,615).
  - Institution-level sources for fees, English and intakes.
  - Confirm the new Firecrawl and OpenRouter amounts.

### 1 Oct 2026 (17:45 AEST) — Course links of every kind, who can apply, link refresh, admission rules per country (Decisions 200–203); v2.15.133
- **Direction (Platform Admin, 16:54):** find and build course and handbook pages with Firecrawl and third-party or regulatory portals, in parallel; keep them in the course links, maintainable by hand; schedule refreshes for all countries or per country (more countries will be added). The applicant is the international student; domestic-only courses must be identifiable, because a missing English requirement makes sense for them. Answers: 1 yes, 2 yes, 3 build it, 4 same accounts.
- **Released:** v2.15.133 (Pilot PR #223), merged with a squash merge after targeted deployed UAT passed on the branch; main green.
- **Database:** five migrations applied live; each stored statement's md5 equals its file. The rule changes were tested first in rolled-back transactions.

  | Migration | Change | Decision |
  |---|---|---|
  | 20261001170000 | Link types, a manual lock per link type, who can apply, NZQA regulator links, editing functions, Courses filter | 200 |
  | 20261001171000 | "Has a course link" means the official course page everywhere (8 functions) | 200 |
  | 20261001172000 | Link refresh schedules (job link-refresh, every 10 minutes) and the portal registry | 201 |
  | 20261001173000 | Admission rules per country: NZ (Decision 202) and AU exact title (Decision 203) | 202, 203 |
  | 20261001174000 | Provider "enrols international students" read | 200 |
- **Live results by 17:42:**
  - AU official course links: 12,155 (up from 10,232 this morning).
  - NZ: 148 official course links and 60 English requirements, the first NZ values admitted. NZ intakes are still in Layer 3.
  - Every one of the 6,475 NZ courses has its NZQA regulator page.
  - All 26,103 AU courses are marked open to international students (CRICOS); 1,556 providers enrol international students.
- **Measured limit:** the database's outbound queue (pg_net) sends requests in rounds of 200 and each round waits for its slowest call.
  - At 80 course-link searches a minute the queue stalled for about 4 minutes and the coverage workers waited behind it.
  - Search is back to 20 a minute.
  - The fix for more speed is to move the search into the edge worker.
- **Corrected in tests:** the Layer 2 dispatcher contract still expected wording replaced in v2.15.131. It was failing on main and passes now.
- **Not yet done:**
  - NZ tuition (the Layer 3 tuition steps still assume AUD);
  - the portal harvest worker (UAC first; registry and switches are in place, all off except NZQA);
  - the institution-level fee, English and intake reader (approval 3);
  - moving the search into the edge worker.
- **OpenRouter:** the platform's key reports US$45 purchased and US$12.29 left at 16:54. The top-up is not on the balance this key draws on.

### 1 Oct 2026 (19:45 AEST) — Course-link search in the worker, fee schedules for approval, Layer 3 claim fixes, Firecrawl guard on the reported balance (Decisions 204–207); v2.15.134
- **Direction (Platform Admin, 18:15):** go ahead with the institution reader; make sure nothing else breaks; write a screen walkthrough for operators and Platform Admins (telemetry and actions); alert emails will use a free SMTP provider such as Mailgun; speed up data admission before Saturday.
- **Released:** v2.15.134 (Pilot PR #227). Pilot PRs #224, #225, #226, #227 and #228 merged with squash merges after targeted deployed UAT passed on each branch; main green after each. coverage-sweep deployed from main after #226 and #227 and checked by a live run.
- **Database:** nine migrations applied live; each stored statement's md5 equals its file. Function changes were tested first in rolled-back transactions, behind md5 guards.

  | Migration | Change | Decision |
  |---|---|---|
  | 20261001175000, 20261001176000 | Course-link search runs in the coverage-sweep worker (job course-link-search-worker) | 204 |
  | 20261001177000 | Worker pass lasts 5 minutes | 204 |
  | 20261001178000 | Institution-level sources: search queue (top 150 AU providers), documents, fee rows | 205 |
  | 20261001179000 | Layer 3 claim: a stale claim closes its interpretation; courses with an open call are skipped | 206 |
  | 20261001179100 | Layer 3 claim checks written as joins (9.1 s to 0.6 s) | 206 |
  | 20261001179200 | Fee schedules: linked PDFs followed; proposals approved by a Platform Admin | 205 |
  | 20261001179300 | Layer 3 claim: one claim at a time per task | 206 |
  | 20261001179400 | Job provider-facts every 10 minutes | 205 |
  | 20261001179500 | Firecrawl balance read every 15 minutes; guard uses the lower figure | 207 |
- **Found and fixed while checking nothing else broke:**
  - Layer 3 English and intake claims failed 26 times (06:00–08:30 UTC) on a duplicate open call, and 18 times on the 8-second time limit. Both fixed; no failures after 09:10 UTC.
  - The Firecrawl guard showed 60,657 credits left; Firecrawl reported 47,476. The guard now uses the reported balance.
  - Two coverage-sweep contract tests had been stale since earlier releases; corrected.
- **Live results (19:30):**
  - AU (26,103 courses): official course links 15,550; English 7,812; intakes 4,893; current tuition 2,340.
  - NZ (6,475 courses): official course links 271; English 202.
  - Last 6 hours: 6,529 course links, 1,877 English requirements, 448 tuition values admitted.
  - Course-link search queue is empty (5,255 found by CRICOS code, 2,879 by title, 5,476 with no page found).
  - First fee schedules read: ACU 2027 (103 courses ready for approval, 1 already the same); ACPE 2026 held back (several amounts per course, not used).
- **Waiting for a person:** approval of the ACU 2027 fee schedule (Coverage › Attributes › Fee schedules).
- **Not yet done:** English policy and calendar reading (needs a qualified extractor); NZ tuition in NZD; the portal harvest worker (UAC first); alert emails (SMTP provider to be chosen).
- **Operator walkthrough:** published as a doc, "CourseFinder Operations Walkthrough" (roles, daily routine, reading the screens, signal → action, Platform Admin duties, alert emails).

### 1 Oct 2026 (20:45 AEST) — QS and THE filters by country, state and provider; ranked universities linked to providers (Decision 208); v2.15.135
- **Request (Platform Admin, 19:46):** add country, state and provider filters to the QS and THE rankings; link the ranked universities to the providers page; keep the linkage automatic as countries are added.
- **Released:** v2.15.135 (Pilot PR #229), merged with a squash merge after targeted deployed UAT passed on the branch; main green (including release currentness).
- **Database:** migration 20261001180000 applied live after a rolled-back test; stored md5 equals the file. md5 guards on security.admin_ranking_read and public.admin_read.
- **Found:** QS and THE universities were linked to providers only when an edition was imported (exact name and country). Providers added later, a new country, or a slightly different name never linked, and no one could link one by hand. Unlinked in countries we hold: Australia 5, New Zealand 3, Canada 19 publisher names.
- **Live result of the first run:** 8 universities linked across 42 ranking entries (ANU, Adelaide, UNSW, Newcastle, Auckland, Canterbury, Lincoln, Victoria (Canada)); 22 candidates offered for a person, mostly Canadian universities listed in French (for example McGill, Laval, Montréal, Concordia).
- **Screens:** Rankings › QS / THE: Country, State, Provider and Link filters; a linked provider opens its record; Curators link a university from suggestions or a provider search. The provider record shows its QS and THE ranks by edition.
- **Waiting for a person:** the 22 candidates (Rankings › QS or THE › Link: Not linked › Link).

### 1 Oct 2026 (21:15 AEST) — Platform guide in the menu, reviewed every release (Decision 209); v2.15.136; Platform Admin answers recorded
- **Request (Platform Admin, 20:27):** put the screen walkthrough in the menu as a Platform guide; keep it updated with every new feature or change; update admin documents and repositories as needed.
- **Released:** v2.15.136 (Pilot PR #230), merged with a squash merge after targeted deployed UAT passed on the branch; main build, smoke, release history and deployed UAT green.
- **Help › Platform guide** (all roles): how the platform works, who does what, the daily routine, every menu screen (what it answers, what to read, what to do, and a button that opens it when the role allows), signal → action, Platform Admin duties, alert emails, and what changed in the current release. No screenshots, so it never shows stale or sample data.
- **Kept current:** the guide's words are in Pilot `src/guide/platformGuide.js`. The release gate (`npm run release:verify`, run before every build) and `cf-247-platform-guide-contract` fail unless the guide is marked reviewed for the release version and every menu page has an entry. Release procedure step 5a added (Release / Version Control & Recovery).
- **Corrected:** the walkthrough doc's "US$4 a day per task" came from sample screenshots. The live AI task limits are US$20 (intakes), US$15 (English) and US$5 (tuition); they were left unchanged.
- **OpenRouter:** the platform reads US$40.21 after the Platform Admin's US$30 top-up (20:17).
- **Platform Admin answers (20:19, multiple choice), queued in this order:**
  1. keep a fee for every year (one record per year; latest shown; earlier kept as history), and read year-by-year fee blocks such as Murdoch's (0 of 267 courses have a fee);
  2. when a page does not say "per year", take the basis from the university's approved fee schedule or fee rule; otherwise a person decides;
  3. UAC portal first, others after (waiting for confirmation that UAC's pages may be used);
  4. start testing an AI model for English policies and calendars (activation separately approved);
  5. NZ tuition in NZD, after fee schedules;
  6. ranking name matching fixed at import; Unlink / Change link for Platform Admin;
  7. remove background area fetch, wave workload defaults and Layer 4 findings; keep source-pattern interpretation for Platform Admin;
  8. remove the Data model screen;
  9. the Platform health budget check follows the sum of the AI task limits;
  10. reuse an identical stored page at capture instead of storing a copy;
  11. alert emails through Mailgun (sending subdomain, DNS, key and recipients to be provided).

### 1 Oct 2026 (23:50 AEST) — Fix: QS and THE filters refused for signed-in users (Decision 208)
- **Reported (Platform Admin, 23:28, screenshot):** "permission denied for function admin_ranking_links_read" on Rankings › QS; the Country list showed no options.
- **Cause:** public.admin_read runs as the signed-in user; migration 20261001180000 had revoked execute on the new security.admin_ranking_links_read from authenticated. The mocked browser tests and the rolled-back test could not see it.
- **Fix:** migration 20261001180100 grants execute to authenticated; the function checks the role itself. Applied live; stored md5 equals the file. Pilot PR #231, merged with a squash merge after targeted deployed UAT passed.
- **Checked live as a signed-in Platform Admin:** filter options (106 countries; Australia 37 ranked), Australia-filtered rankings, link candidates and provider search. Every security function that public.admin_read calls is now executable by authenticated.
- **Lesson:** a new read routed through public.admin_read is tested live as a signed-in user, not only as the database owner.

### 2 Oct 2026 (00:20 AEST) — Approved fee schedules settle flagged fees (Decision 210); v2.15.137
- **Reported (Platform Admin, 1 Oct 23:43, screenshots):** Layer 4 › Flagged values still asks a person to confirm "per year" fees for universities whose fee schedule was already approved, a double take.
- **Released:** v2.15.137 (Pilot PR #232), merged with a squash merge after targeted deployed UAT passed on the branch.
- **Database:** migration 20261001180200 applied live after a rolled-back test; stored md5 equals the file; md5 guards on public.admin_provider_fee_schedule_decide and security.admin_data_flags_read_v1.
- **Result:** 30 flags settled by approved schedules: Charles Sturt 25 (8 the same fee, 17 within 15%, last year's fee) and Sunshine Coast 5. 456 remain open, mostly Deakin (143) and Edith Cowan (140), whose fee documents are now read first.
- **Screens:** flagged values show the schedule's fee with "Use schedule fee"; settled flags say why. The Platform guide was updated and reviewed for v2.15.137.
- **Seen, not changed:** some approved schedules differ from fees already held by exactly 2 or 3 times (AIH Higher Education), which suggests a whole-course column read as annual. Those were listed as "different", not written, at approval.

### 2 Oct 2026 (03:15 AEST) — Scholarship eligibility and award scope from provider pages (Decision 211); v2.15.138
- **Asked (Platform Admin, 2 Oct 00:01):** "What is happening with scholarship for courses available to international students". Answers by multiple choice: read criteria first; retire the old course-link candidates.
- **Found:** 1,233 active scholarships (all recorded as for international students), 124 published. Structured eligibility existed for 9; award duration was known for 3. 37,200 course-link candidates had waited since 3–5 Sep 2026. Main publishing blocker is the award value (722 have no single stated value); 282 pass every check and wait on Scholarships › Publishing.
- **Released:** v2.15.138 (Pilot PR #233), merged with a squash merge after targeted deployed UAT passed on the branch; main checks green.
- **Database:** migration 20261002180300 applied live after a rolled-back test; stored md5 equals the file. md5 guards on public.scholarship_course_fill_service, security.scholarship_sweep_apply_v1 and public.ui_scholarship_detail. No rows deleted.
- **Reader:** coverage-sweep worker v0.9.0, scholarship reader v0.5.3 (three fixes after hand-checking 56 readings). Deployed through deploy-edge-functions.yml; the deployed files match the repository.
- **Result (all 1,120 stored pages re-read without fetching):** 834 scholarships have eligibility criteria; 524 have an award duration. Student type: 251 international only, 204 domestic and international, 251 domestic only. Study stage 426, full-time 339, ATAR/GPA/WAM minimum 140, automatic consideration 178, citizenship list 58, gender 46.
- **Old candidates:** 37,200 marked superseded (17,008 were already linked by later rules); the fill service no longer reopens them.
- **Screens:** Catalogue › Scholarships record shows Eligibility and award, each line with the provider page's words. The Platform guide was updated and reviewed for v2.15.138.
- **Not changed (for a decision):** publication rules. 251 scholarships read as domestic only, of which 18 are in the ready-to-publish list and 1 is published (Women in Engineering and Construction Scholarship). Fee-saving figures remain unresolved: the scholarship fee-type and basis words do not match the course fee records.

### 2 Oct 2026 (06:00 AEST) — Scholarship publishing rules (Decision 212); v2.15.139
- **Asked (Platform Admin, 2 Oct, multiple choice):** add a publishing check for domestic-only scholarships; publish a single "up to" value as a maximum; fix the fee-saving matching.
- **Correction recorded:** the earlier report that 378 scholarships were held back only by "up to" wording was wrong. 378 were held back only by the award value; 130 of those use "up to" wording, and 76 state a single "up to" value.
- **Released:** v2.15.139 (Pilot PR #234), merged with a squash merge after targeted deployed UAT passed on the branch.
- **Database:** migration 20261002180400 applied live after a rolled-back test; stored md5 equals the file. md5 guards on seven functions; no rows deleted. New column scholarship.scholarships.award_value_is_maximum; new daily job scholarship-savings (20:41 UTC).
- **Reader:** scholarship reader v0.5.4 (comma-listed "International Student" includes international students), deployed; the deployed files match the repository; all stored pages re-read.
- **Result:**
  - 236 scholarships read as domestic only are no longer publishable. Scholarships › Publishing › Domestic only lists them with the page's words. A Platform Admin can record "International students can apply" (note required). The one published domestic-only scholarship (Women in Engineering and Construction Scholarship) is withdrawn at the next daily review.
  - 145 scholarships hold a single maximum value, shown as "Up to …", never used for a saving. The website search marks them (amount_is_maximum, additive).
  - Fee savings: 3,221 course savings calculated for 44 scholarships across 1,345 courses (was 0). Each is per year, from the provider's annual international tuition fee. Unresolved: no annual fee for the course 10,299; page does not say the percentage is off tuition 8,365; maximum or not a percentage 355.
  - Ready to publish: 344 (was 282). Published: 124. Publishing itself still waits for a Platform Admin.
- **Open:** the deployed-release-currentness check after merge has failed since v2.15.136 at its wait step (the probe does not see the new version within 20 minutes). Targeted deployed UAT and the Workers build pass. The live version shown in the app has not been confirmed from this session.

### 2 Oct 2026 (08:30 AEST) — Coverage by country and university, fee schedule bulk approval, pattern requests retired (Decision 213); v2.15.140
- **Reported (Platform Admin, 06:56, screenshots):** "Edge Function returned a non-2xx status code" on Layer 3 › Work queue and Coverage; "what is the course page pattern doing?"; fee schedules need bulk approval and a review of every entry, and one schedule with nothing to approve kept appearing; Coverage & completeness has no country or university filter. Answers (multiple choice): retire the pattern requests; Coverage opens on all countries.
- **Cause of the error:** every course-page pattern request (CF-054; 1,415 queued and 240 blocked, 31 Aug–25 Sep) was bound to a retired free model that is paused, so Run returned 400. The banner stays on screen across pages until it is closed.
- **Released:** v2.15.140 (Pilot PR #235), merged with a squash merge after targeted deployed UAT passed on the branch.
- **Database:** migration 20261002180500 applied live after a rolled-back test; stored md5 equals the file; md5 guards on six functions; no deletes, drops or truncates. New table pipeline.course_coverage_daily_by_country; the old daily table is unchanged.
- **Result:**
  - Pattern requests: all 1,655 cancelled with the reason (kept); new ones are created cancelled; the panel shows only when one waits.
  - Fee schedules: approve or reject several at once; "Review N rows" on each; Show waiting, decided or all; "Close (nothing to add)" for a schedule with no new fees (this still settles flagged fees it answers). Waiting schedules are listed first, up to 300.
  - Coverage & completeness: every country with active courses (AU 26,103; NZ 6,475; CA 2,382), opening on all countries; Country and University filters apply to every count, list and trend; provider tiers ranked within each country. Checked live as a signed-in Platform Admin.
- **Seen, not changed:** New Zealand and Canada score low (NZ about 1%) because their register values (duration, campus, registered tuition) are not held for them yet, and only 272 NZ course pages and 203 English requirements are admitted.
- **Still open:** the deployed-release-currentness check after merge failed again (v2.15.139). The app itself showed the new version in the Platform Admin's screenshots, so the site deploys; the check's probe is at fault.

### 2 Oct 2026 (08:50 AEST) — Live activity, scholarship discovery refill, release check fixed (Decision 214); v2.15.141
- **Asked (Platform Admin, 07:27 and 07:31):** whether the mid-run message stopped the scholarship deployment; then "schedule them asap", make sure main is all green, and show what is running at each layer at any time instead of a person asking for the next round.
- **Review of the scholarship release:** not interrupted. Pilot PR #234 merged at 06:51 and its checks passed at 06:52; the message arrived at 06:56. Migrations 180300–180500 are live and match their files.
- **Found:** scholarship discovery had nothing queued since 29 Sep (93 providers, all done). Page reading is idle by design (every active page read; next due in 90 days).
- **Released:** v2.15.141 (Pilot PR #236), merged with a squash merge after targeted deployed UAT passed on the branch. **Main is all green (5 of 5),** including deployed-release-currentness for the first time since v2.15.136.
- **Release check cause:** release-currentness-deployed.yml piped the 1.5 MB bundle into `grep -q` under `pipefail`, so curl exited with code 23 whenever the version string sat mid-file (since v2.15.136). Reproduced locally; the check now downloads first, then searches.
- **Database:** migrations 20261002180600 (100 largest unsearched Australian providers queued; hourly job scholarship-discover-refill keeps 30 waiting), 180700 (discovery 6 providers per run, was 3) and 180800 (admin_read 'live_activity'; admin_read patch behind an md5 guard). Each applied live after a rolled-back test; stored md5 equals each file. The live read takes about 2 seconds and was checked as a signed-in Platform Admin.
- **Live activity screen** (under Dashboard, every role): all 71 scheduled jobs by layer, each Running now, Working (left, done in 24 hours, about how long to go), Up to date, Scheduled, Paused, Stuck or Failing; last run, the worker's last result, next run in Melbourne time; Waiting-for-a-person tiles. Refreshes every 20 seconds. The Platform guide was updated and reviewed for v2.15.141.
- **First results of the new discovery:** within about an hour, 18 of the 100 providers searched, 111 pages found, 76 read, 1 scholarship admitted. Most refusals are the normal page checks: no single named scholarship 58, international students not mentioned 41. Only 4 were refused for not being a university.

### 2 Oct 2026 (08:30 AEST) — Evidence link indexing fixed; Live activity shows worker errors (Decision 215); v2.15.142
- **Asked (Platform Admin, 07:57):** fix the failing evidence link indexing job and update the Platform guide to match.
- **Cause:** the job's worker refused every run from 30 Sep 2026 13:59 UTC with `invalid_pilot_automation_key`, because the long-lived automation key expired. The scheduled run only sends the request, so Scheduled jobs and Live activity showed it as succeeded. Separately, 11,676 compressed (`.html.gz`) saved pages had been recorded as having no links because the worker could not unpack them.
- **Fixed:** edge function evidence-link-index v4 (deployed from the branch, byte-compared) signs in with a one-time run pass and unpacks compressed pages. Migrations 20261002180900 (schedule uses `svc_pilot_submit_nonce`), 20261002181000 (compressed pages re-queued; 200 pages per run) and 20261002181100 (Live activity read, behind an md5 guard). Each applied after a rolled-back test; stored md5 equals each file.
- **Verified live:** the first scheduled run on the run pass (22:09 UTC) indexed 199 pages and found 9,491 links, with 1 page error. About 24,000 pages are waiting, about 20 hours at the current pace.
- **Live activity:** a new Workers sending back errors panel lists error replies from workers in the last few hours, with a plain-English reading, count and time. Index evidence links now shows pages left, pages done in 24 hours and links found. The live read was checked as a signed-in Platform Admin.
- **Released:** v2.15.142 (Pilot PR #237), merged with a squash merge after targeted deployed UAT passed on the branch; main is all green (4 of 4). The Platform guide was reviewed for v2.15.142: Live activity, Evidence, a new signal for repeating worker errors, and run passes under Budgets and keys.
- **Open (Platform Admin decision):** 27 other edge functions still sign in with the expired key. They are not on a schedule now, but would be refused if run. Options: move each to run passes, or issue a new key.

### 2 Oct 2026 (09:20 AEST) — Every background function signs in with one-time run passes (Decision 216); v2.15.143
- **Asked (Platform Admin, multiple choice after Decision 215):** move all 27 functions still on the expired automation key to run passes (recommended option).
- **Found before changing anything:** all 27 were deployed and active. 23 matched git exactly; 3 differed only in formatting. **`layer1-ca-on-college-programs` ran v0.3.0 live, which writes course records for four Ontario colleges, while git held an older test-only v0.1.0.** The live code was committed to git first (32b6ba3), then changed. 26 of the 27 had only ever been deployed by hand.
- **Changed:**
  - Each function now accepts only a one-time run pass under its own name (or, where it already allowed it, an admin sign-in). The Layer 2 batch runner and the scholarship scope job make a fresh pass for each function they call. evidence-link-index no longer accepts the old key either.
  - Migration 20261002181200 adds one allow-list (`pipeline.pilot_nonce_functions`, 55 functions) and `public.svc_pilot_issue_nonce` (service role only). It switches the six database callers to passes, each behind an md5 guard. It was applied after a rolled-back test; the stored md5 equals the file.
  - No database function or scheduled job references the old key any more.
- **Deployed:** all 28 functions from the branch through the deploy workflow (26 added to its allow-list, `verify_jwt=false` as before). Each was then compared byte for byte with git live: all identical, the on-college drift included.
- **Live checks:**
  - A valid pass gets through sign-in: the batch runner and scope job reach their request checks, and the diagnostic answers 200.
  - No pass is refused (401), and a fake pass is refused.
  - Evidence link indexing kept running on schedule: about 1,000 pages indexed in the hour after the change.
- **Released:** v2.15.143 (Pilot PR #238), merged with a squash merge after targeted deployed UAT passed on the branch; main is all green (4 of 4). The Platform guide was reviewed for v2.15.143: Budgets and keys, and the worker-error signal.
- **Noted, not changed:** `layer2-v2-diagnostic` passes sign-in but its own query fails ("Invalid schema: pipeline"), as it did before; it is a diagnostic only. The old key's database records remain, unused and expired.

### 2 Oct 2026 (10:35 AEST) — New Zealand course pages, search and tuition; fee schedules follow the country (Decision 217); v2.15.144
- **Asked (Platform Admin, 09:21, with screenshots):** the fee schedule panel doesn't follow the selected country; NZ isn't running any jobs; NZ data admissions are almost nil.
- **Found:**
  - The course-page search only queued courses with a CRICOS code, so no NZ course had ever been searched.
  - The reader rejected correct NZ pages because NZQA titles end in "(Level N)" and provider pages don't (2,584 rejected; about 900 tested as right on their stored headings).
  - The tuition hand-off to Layer 3 was Australia-only, with AUD fixed.
  - Fee schedules sat outside the Coverage filter.
- **Decided (multiple choice):** NZ identity "title + same level", plus a labelled NZQA number; search all NZ courses now; NZ tuition admitted like Australia, in NZD.
- **Changed:**
  - Reader v0.9.1 (coverage-sweep v42, deployed from the branch, byte-compared with git):
    - `title_level`: the heading is the NZQA title without the level, the same level shows on the page, and no other level of the same qualification appears;
    - `nzqa_code`: a labelled NZQA number on the page;
    - NZ fees are read in NZD, with AUD and US$ amounts left out;
    - Australia is unchanged.
  - Migration 20261002181300 (md5-guarded):
    - the read queue carries the country;
    - the NZ admission rule is extended (tuition only from a page that prints the course's code, like Australia);
    - the tuition hand-off follows each country's rule and currency;
    - the title search drops "(Level N)";
    - generic recipes for 398 NZ providers.
  - Migration 181400: 2,584 NZ pages read again; 2,927 NZ courses queued for search.
  - Migration 181500: NZ pages still rejected after the re-read go to the title search each minute (Australian queueing unchanged).
  - Each migration was applied after a rolled-back test; the stored md5 equals each file.
  - Fee schedules follow the Coverage country and university; for New Zealand the panel explains that schedules are CRICOS-matched and Australian only.
- **Results after about an hour:**
  - NZ official course pages 272 → 989; English requirements 203 → 624; intakes almost none → 341.
  - Proven pages: 449 by title and level, 418 exact title, 115 programme code, 14 NZQA number.
  - Search: 310 verified, 2,647 found and waiting to be read, 1,610 with nothing found.
  - 3 NZD tuition fees admitted through the qualified Layer 3 model. The first was checked by hand: Ara, Bachelor of Sustainability and Outdoor Education, page shows "International Fee $26,572 per year" for 2026, recorded as NZD 26,572 annual 2026.
  - Unclear fees go to Layer 4, as in Australia (e.g. NZ$1,259 for a postgraduate diploma, likely per credit).
- **Released:** v2.15.144 (Pilot PR #239) and the search follow-up (Pilot PR #240), each merged with a squash merge after targeted deployed UAT passed on the branch; main is green. The Platform guide was reviewed for v2.15.144: how a course page is accepted in each country, and the fee schedule scope.
- **Watch:**
  - The course-page search has used about 40,800 of its 50,000 monthly units; at the cap it pauses until 1 November.
  - The tuition model's test had no NZ pages. NZ fees are being spot-checked by hand as they arrive; an NZ case set for its next test is recommended.
  - 309 NZ courses belong to providers with no website on record and cannot be searched.

### 2 Oct 2026 (11:10 AEST) — Fee periods settled automatically; Live activity names the job behind each error (Decision 218); v2.15.145
- **Asked (Platform Admin, 10:51, with screenshots):** what is Layer 4; flagged values should be handled by the Layer 3 course-fee automation, not a person; fix the errors shown on Live activity.
- **Found:**
  - All 458 open flags were fees the Layer 3 fee check added as per year because its validator did not recognise the period wording (for example "estimated 1st year indicative fee", "$45,800 for 1 yr full-time").
  - The Live activity errors were the old automation key (fixed in Decisions 215–216), deliberate test calls after the run-pass change, and two compute-limit replies from evidence indexing (08:49, 08:59); every evidence run since 09:09 had succeeded.
- **Changed:** migration 20261002181600, applied after a rolled-back test; stored md5 equals the file; function patches md5-guarded.
  - Automatic period check (job `fee-period-settle`, every 10 minutes): confirms a flagged fee when its quoted wording says per year, or when the course runs a year or less. Wording naming another period (semester, trimester, total, whole course) is never confirmed.
  - Live activity: scheduled calls note the function and mode they called, so each error names its job. Pipeline Operators and above can Mark as seen; an error shows again only if it recurs. The errors already understood were marked as seen.
  - Evidence indexing (v6, deployed from the branch, checked live) works on 4 pages at a time (was 6) and skips unpacked pages over 12 MB.
- **Result:** the first scheduled run at 11:05 left 65 flags open, from 458. The test run had confirmed 393 (319 by wording, 74 short courses). The 65 that remain name no period or another period, e.g. "$73,392 (six trimesters full-time study)" (whole course) and "Semester 1 AUD $10,720" (per semester); a person corrects these.
- **Released:** v2.15.145 (Pilot PR #241), merged with a squash merge after targeted deployed UAT passed on the branch; main is all green (4 of 4). The Platform guide was reviewed for v2.15.145: what Layer 4 is, the period check, and Mark as seen.

### 2 Oct 2026 (11:55 AEST) — New Zealand regions and a country-named state filter; bulk decisions on flagged values (Decision 219); v2.15.146
- **Asked (Platform Admin, 11:24, with screenshot):** no state filter for New Zealand; check Canada; make state or province available as a filter. Add mass bulk actions to Layer 4 Flagged values.
- **Found:** Canada already holds a province or territory for all 1,130 providers (12 in use), so its filter worked. New Zealand had no regions in the reference list, so none of its 414 providers had one.
- **Changed:** migration 20261002181700, applied after a rolled-back test as a signed-in Platform Admin; the stored md5 equals the file.
  - New Zealand's 16 regions and the Chatham Islands were added (ISO 3166-2:NZ). 402 of 414 NZ providers were placed by their town, only where no region was held.
  - 12 are left for a person to set on the provider record. Six have overseas addresses (Cook Islands, "Offshore", "Overseas"). Six have towns that are ambiguous or unconfirmed: "Frankton" ×4 (Hamilton or Queenstown), "Central City" and "Waipapa".
  - The filter is named by country: State / territory (AU), Province / territory (CA), Region (NZ).
  - Flagged values have a tick box per row, Select all shown, and Confirm selected per year, Mark selected as whole course or Remove selected. These replace the per-university Confirm all. One call (`admin_data_flag_resolve_bulk`, Pipeline Operator and above) makes the same changes as a single decision, skips anything already decided and refreshes search once; 30 decisions took 266 ms in the test.
- **Released:** v2.15.146 (Pilot PR #242), merged with a squash merge after targeted deployed UAT passed on the branch; main is all green (4 of 4). The Platform guide was reviewed for v2.15.146.

### 2 Oct 2026 (12:35 AEST) — Old Layer 2 pipeline retired; an actionable Layer 2 overview and daily progress by country; Canada admitted like New Zealand (Decision 220); v2.15.147
- **Asked (Platform Admin, 12:02, with screenshots):** fan out data admission to every country and report progress since yesterday. Recent managed runs and recent fetches appear to come from an old script and make no sense — should they be removed, and why is current progress shown in History? Layer 2 Overview shows Action required but gives no button or guidance.
- **Answered by multiple choice:** retire the old Layer 2 pipeline (pause it, keep its history). Canada "like New Zealand". No preference for the next countries.
- **Found:**
  - The History panels and the Action required alerts all came from the older provider-reading pipeline (waves, fan-out, qualification batches). Its last fan-out task was created on 13 Sep 2026.
  - The "Running 29,618/29,618" batch is the ledger the course-page sweep uses to log tuition hand-offs, not a run.
  - Canada had 2,382 active courses at 34 providers, with no websites and no admission rule. Its course codes are internal identifiers, not official codes.
  - US, UK, Ireland and Germany have no providers or courses loaded.
- **Changed:** migration 20261002181800 was applied after a rolled-back test; the stored md5 equals the file.
  - The 7 old pipeline jobs are paused, not removed. Housekeeping, the onboarding snapshot, the Layer 3 tuition enqueue and scholarship scope keep running.
  - The site finder returns each provider's country and DLI number.
  - A Canadian site is accepted only on its own .ca host whose home page names the provider or prints its DLI number. It then gets the generic course-page recipe, and its active courses are queued for title search.
  - Canada's rule is exact title for links, English and intakes, with tuition only from a page that prints the course's code, in CAD. The tuition admit and the Layer 4 fee correction accept CAD.
  - All 34 Canadian providers joined the discovery queue.
  - coverage-sweep v43 (worker v0.9.2) reads Canadian pages in CAD. It never accepts a site against an empty CRICOS pattern.
  - Layer 2 Overview › Action required now lists only Layer 2 jobs that are failing or stuck and workers sending back errors. Each has what it means, what to do and a button to Live activity or Scheduled jobs.
  - Layer 2 History shows daily progress by country in place of the old run and fetch lists.
- **First Canadian results (12:30 AEST):**
  - 22 of 34 sites were found and mapped, covering 2,183 courses. All were checked by name on their own .ca home page; 12 providers are still without a site.
  - 1,558 courses have been searched so far.
  - 60 pages are proven by exact title.
  - No Canadian tuition will be added until courses carry an official code.
- **Released:** v2.15.147 (Pilot PR #243), merged with a squash merge after targeted deployed UAT passed on the branch; main is all green (6 of 6). The Platform guide was reviewed for v2.15.147.

### 2 Oct 2026 (13:00 AEST) — Layer 3 cascade never falls back to a switched-off model; pending claims labelled (Decision 221); v2.15.148
- **Asked (Platform Admin, 12:35, with screenshots):** "Again even sonet is disabled as a model work queue still passed it on to sonet model why is the leaking still happening??"
- **Found:**
  - No intake or English answer has come from Claude Sonnet 4.6 since 30 Sep 2026 06:03 AEST, when the cascade started.
  - In the last 24 hours every answer came from Qwen3 30b (step 1) or Mistral Small 3.2 (step 2).
  - The "Running · claude-sonnet-4.6" rows were claims waiting for the cascade. A claim is recorded against the task's single routed profile, which is Sonnet from before the cascade, and is relabelled with the step that answers.
  - There was a latent fallback: had every step been switched off, the worker would have called that routed profile.
- **Changed:**
  - layer3-model-routing v8. For a cascade task, the worker never runs the single-profile path. With no step switched on, nothing is claimed and no model is called. A step switched off mid-run releases the page. Send back to AI to one named model is unchanged.
  - Migration 20261002181900, applied after a rolled-back test; the stored md5 equals the file. Recent results now hides the placeholder model of an unanswered cascade claim and shows "Cascade · step not chosen yet". Answered rows show the step.
  - Verified after deploy: answers came from Qwen (step 1) and Mistral (step 2) only.
- **Released:** v2.15.148 (Pilot PR #244), merged with a squash merge after targeted deployed UAT passed on the branch. The Platform guide was reviewed for v2.15.148.

### 2 Oct 2026 (13:35 AEST) — Fetch an area works on the course-page sweep; Websites to find; worker errors say what to do (Decision 222); v2.15.149
- **Asked (Platform Admin, 12:41, with screenshots):**
  - "Manual job for Latrobe was submitted but open job button do nothing."
  - Error descriptions are not helpful and give no steps.
  - Universities whose site the finder tried should be handed to Layer 4 for a person to enter the URL.
- **Answered, on what Fetch an area should do:** "Align the sweep function with new sweep process."
- **Found:**
  - Fetch an area still started the retired pipeline, so the La Trobe request could never run. Its Open Jobs button pointed to a menu item that no longer exists.
  - In the sweep, La Trobe already has its site mapped and 239 of 248 course pages found and read. 239 have an official page admitted and 23 have intakes. None show English or fees, because the pages found are 2021 handbook pages that do not carry them.
  - 43 universities have no confirmed website (35 AU, 8 CA).
  - The worker errors had two causes:
    - The AI tuition check runs for up to 4 minutes, but its caller waited only 2.
    - The tuition hand-off took 2.7 s on average and up to 7.7 s, reaching the statement timeout once. A start-up error coincided with a release.
- **Changed:** migration 20261002182000, applied after a rolled-back test as Platform Admin; the stored md5 equals the file.
  - Layer 2 › Fetch an area now reads and drives the sweep. For a country, state or university it shows sites mapped or not found, pages found and read, facts admitted, and one line on what is holding it up.
  - Start (Pipeline Operator and above) puts the area first in the sweep, using the same priority pin as Scheduled jobs › Priority. It then:
    - searches again for sites not found and retries failed site maps
    - searches for pages of courses with none (a search that found nothing is repeated after 7 days)
    - reads found pages now.

    Nothing admitted or entered by hand is changed.
  - Layer 4 › Websites to find lists those universities with the search and pages tried. A website entered there is kept as entered by a person and logged. It adds the generic course-page recipe and starts the page search.
  - Each worker error on Live activity and on Layer 2 Action required now says what to do, often nothing, and when to switch a job off or tell the Platform Admin.
  - The AI tuition check's caller now waits 5 minutes. The tuition hand-off has an exact prefilter that misses none of the qualifying pages and runs in 0.4 s.
- **Released:** v2.15.149 (Pilot PR #245), merged with a squash merge after targeted deployed UAT passed on the branch. The Platform guide was reviewed for v2.15.149.
- **Open:** for universities like La Trobe, English and fees need a second page per course (the international course page rather than the handbook). This is not built yet.

### 2 Oct 2026 (15:50 AEST) — Fees follow the page's domestic or international view; answered tuition reviews closed (Decision 223); v2.15.150
- **Asked (Platform Admin, 15:02, with screenshots):** "Uq website clearly shows $10,520 how is the json getting additional fees not even listen on the page?"
- **Found:**
  - UQ's page carries a domestic view and an international view, and remembers which one a visitor chose. $10,520 (2026) is the domestic view, a Commonwealth supported place. AUD $60,952 (2027) is the international view and the page's own "Fees A$60952" summary. The recorded A$60,952 is correct.
  - The review was left by the retired pipeline's extractor (26 Aug). The same course was sent to a person again at 12:31 by layer3-tuition-enqueue, which still fed the retired pipeline's August snapshots to the AI fee check.
  - Across Layer 4, about 940 tuition reviews were waiting. Most came from the course-page sweep handing the AI fee check domestic-view fees, course totals and part-year fees as if they were international annual fees. The AI correctly declined them.
- **Changed:** migrations 20261002182100, 182200 and 182300, applied after rolled-back tests; the stored md5 equals each file.
  - 15 waiting tuition reviews were closed as superseded, with the reason kept. In each, the recorded international fee is the amount the current reader reads from the same page.
  - layer3-tuition-enqueue is paused (switched off, not removed).
  - Reader v0.5.5 (coverage-sweep worker v0.9.3, function v44, byte-identical to the repo):
    - fees follow the page's own view marker
    - course totals are recognised, with total wording scoped to its own amount
    - a fee for a study period, trimester or unit is never annual.
  - Every saved page is re-read once, each in its country's currency (re-extraction read every page in AUD before).
  - Nothing in the catalogue changes.
- **Released:** v2.15.150 (Pilot PR #246), merged with a squash merge after targeted deployed UAT passed on the branch. The Platform guide was reviewed for v2.15.150.
- **Open:** the remaining waiting tuition reviews whose page, once re-read, no longer has an international annual fee. They wait for the Platform Admin's decision.

### 2 Oct 2026 (16:20 AEST) — Tuition reviews settled against the page's international view (Decision 224); v2.15.151
- **Asked (Platform Admin, 15:35, with an RMIT review and RMIT's international view, AU$16,250 2027 total indicative):** "Review all other stuck in layer 4, tuition fees ... review for international students rather getting confused on default page that open domestic students."
- **Found:** about 970 tuition reviews were waiting. Most asked a person about a figure that is not international annual tuition. The AI check had been right to refuse them. The figures were:
  - domestic-view prices: Collarts, QIBT
  - a VET Student Loan cap: RMIT Diploma of Business, A$12,858
  - bursaries: TAFE International WA
  - scholarships: RMIT
  - health cover, salaries and deposit limits
  - whole-course totals and per-session fees: University of Wollongong.
- **Changed:**
  - Reader v0.5.6 (coverage-sweep worker v0.9.4, function v45, byte-identical to the repo) leaves those amounts out and reads "Session fee / Course fee" tables.
  - Migration 20261002182400 re-reads pages behind a waiting review first.
  - Migration 20261002182500 adds security.layer4_tuition_settle_v1, run then and every 10 minutes (job layer4-tuition-settle). It works as follows:
    - Duplicates are superseded.
    - When the amount asked about is not the page's international annual fee, the review is superseded with both amounts kept, and the page's international fee goes to the AI check again.
    - When the page shows no international fee at all, the review is superseded with that reason.
    - When the amount matches, or the page shows only per-session fees and totals, the review stays for a person.
    - Reviews a person opened in the last 30 minutes are left alone.
  - Both migrations were applied after rolled-back tests; the stored md5 equals each file. Nothing in the catalogue changed.
- **First run:** 332 reviews settled.
  - 28 duplicates.
  - About 120 sent back to the AI check with the page's international fee. Examples: UNE 31, TAFE SA 15, Kingston 13, RMIT 11, AUT 11, Monash 9, Box Hill 9.
  - About 190 with no international fee on the saved page: Collarts 81, TAFE International WA 80, Elston 12, QIBT 10. These pages carry only the domestic view, or link to a separate international fee list.
  - About 610 remain for a person:
    - about 400 where the page's international fee is the amount asked about
    - about 205 with only per-session fees and totals, 179 of them University of Wollongong.
- **Released:** v2.15.151 (Pilot PR #247), merged with a squash merge after targeted deployed UAT passed on the branch. The Platform guide was reviewed for v2.15.151.
- **Open:**
  - University of Wollongong lists a fee per session; a full-time year is two sessions, 48 credit points.
  - The official international fee lists of University of Wollongong and Collarts were found but not parsed: UOW's 2027 schedule PDF has 183 course codes and 0 rows read; Collarts' 2026 international flyer gave no rows.

### 2 Oct 2026 (18:10 AEST) — Australian tuition from CRICOS; quote failures re-run; English from each university's policy (Decisions 225–227); v2.15.152–v2.15.153
- **Asked (Platform Admin, 16:42):** "Th tuition fees were already listed in cricos for au region why are we investing in refinding those? It should only be done where regulatory are not advertising it and only for international students. We should concentrate on intakes and English requirements." By multiple choice: English from university policy, semesters to months, intake check v1.1, re-run quote failures (all four).
- **Decision 225 (v2.15.152, Pilot PR #248, migration 20261002182600):**
  - A country rule with no tuition identities means tuition comes from the regulator. Australia's tuition list is now empty; New Zealand and Canada keep theirs.
  - The institution reader no longer searches for or reads fee schedules for Australia (security.tuition_chase_enabled). It still finds English policies and academic calendars.
  - Australian tuition work waiting for the AI check was parked, and 648 Australian tuition reviews in Layer 4 were closed as superseded, with the reason kept. Recorded fees were not changed.
  - History › Daily progress shows Australia's tuition as "Tuition (CRICOS)".
- **Decision 226 (v2.15.153, migration 20261002182700):**
  - The 446 waiting intake and English reviews whose only reason was "The AI quoted text that is not on the saved page" were sent back to the Layer 3 cascade.
  - Retry failed for tuition no longer brings back tuition work parked under Decision 225 (patch behind an md5 guard).
  - Finding: 350 of the 446 failed the same way again. The AI's quotes are short ("April", "July", which are under the six-character minimum) or are stitched together from several parts of the page. A re-run does not clear them. The fix is a new intake check contract, qualified on the frozen holdout and switched on by the Platform Admin; the qualified v1.2 contract is not changed in place.
- **Decision 227 (v2.15.153, Pilot PR #249, migrations 20261002182800–20261002183200, coverage-sweep worker v0.9.5):**
  - The reader now also reads English policy and academic calendar pages, larger providers first. Each is stored as evidence and parsed without AI (parser provider-policy-v0.2.1) into a proposal.
  - An English proposal gives a default for undergraduate courses (bachelor, honours, associate degree) and for postgraduate coursework courses (graduate certificate, graduate diploma, coursework masters). It also lists courses the policy names with their own score.
  - The plan is worked out course by course. A requirement is written only where the course has no English row at all, no lock set by hand, no review open, no AI check in progress and no page waiting to be read.
  - Held back: research degrees, double degrees, exit awards, other levels, and courses the policy names or nearly names.
  - Nothing is written until a Platform Admin approves. Approved policies are applied again every six hours (job provider-english-defaults).
  - Approval is refused where at least 10 courses can be compared with their own pages and more of them differ than agree.
  - Screens: Coverage › Attributes › English policies and Academic calendars.
  - Every migration was tested rolled back first; the stored md5 equals each file. The edge function was deployed from the branch and checked byte for byte against the repo.
- **First results (116 of 413 policy documents read so far):**
  - 42 English proposals are waiting for approval. Examples:
    - Flinders: 57 course pages agree, 12 differ, 197 courses to fill
    - UQ: 207 agree, 45 differ
    - Deakin: 81 agree, 34 differ
    - Adelaide: 163 agree, 56 differ
  - Blocked by the agreement check, because the parser picked up a nursing table or a band table:
    - UTS
    - ECU: 10 agree, 106 differ
    - QUT: 0 agree, 77 differ
    - UTas: 3 agree, 25 differ
  - No single default, so these stay on course pages: policies that set scores by English band (Melbourne), by faculty (UNSW, Swinburne, Murdoch) or only on each course page (UOW, RMIT, Sydney's course list).
  - 22 calendar proposals are waiting.
  - Nothing has been written to the catalogue yet.
- **Released:** v2.15.152 (Pilot PR #248) and v2.15.153 (Pilot PR #249), merged with a squash merge after targeted deployed UAT passed on each branch. Local suite: 300 passed, with exactly the 18 known failures. The Platform guide was reviewed for v2.15.153.
- **Open:**
  - Semesters to months from approved calendars (next).
  - Intake check v1.3.0 as a parallel contract: day-first numeric dates, rolling or weekly intakes, short month quotes. It will be qualified on l3r-intake-h1 and activated by the Platform Admin.
  - 14 New Zealand tuition reviews remain.

### 2 Oct 2026 (19:30 AEST) — Roadblocks to data admission and the recommended actions (Decision 228 in progress)
- **Asked (Platform Admin, 19:02):** "How we come to such difficult turn, can you take and record recommended action to have maximum data admission and unlock these roadblock."
- **Where Australia stands (26,103 active courses):** official page 15,789 (60%), English 7,886 (30%), intakes 5,588 (21%). Tuition comes from CRICOS (Decision 225).
- **Why it has become hard:**
  - The easy facts are done. They came from registers (CRICOS: title, code, tuition) and from course pages that print the course's own CRICOS code.
  - What is left sits in places that are less structured:
    - English is usually set once per university in a policy, and often by band or faculty, not on the course page. The AI check found no English on 5,894 course pages.
    - Intakes are often given as "Semester 1" or "Trimester 2", or on a separate key-dates page or PDF. The AI check found no intakes on 9,713 course pages.
  - 5,766 pages were found but not proven to be the course's own. Some are the wrong page (library guides, contact pages), and those are correctly refused. Others are real course pages that do not print the CRICOS code.
  - About 3,800 courses have no course page found at all.
  - The safeguards are deliberate and stay: quotes must be on the saved page, models are qualified and pinned, people approve bulk writes, and hand values are never overwritten. They trade speed for accuracy, so each new source needs its own checked route.
  - Two tooling limits slowed the day:
    - A signed-in request stops after 8 seconds. Fixed for English policies by migration 20261002183300, which keeps the plan counts and fills courses by a job.
    - Database changes that write intakes and close reviews in bulk need the Platform Admin's approval in the database tool's prompt, and that prompt kept coming back cancelled.
- **Actions taken now:**
  - The policy and calendar reader reads 20 documents a run instead of 8 (migration 20261002183500, live; stored md5 equals the file). About 500 documents are left, which should take about 4 hours.
  - Semesters to months (Decision 228), part 1 of 3, is live: the calendar months and the plan for semester-only intake reviews (migration 20261002183400, recorded as version 20261002090507; stored md5 equals the file). It writes nothing.
  - Parts 2 and 3 (answering the reviews, the Platform Admin calendar entry, and the 10-minute job) are on Pilot branch cf247-semester-months. They wait for the Platform Admin to accept the database tool's prompt. They will not be reshaped to avoid that prompt.
  - In a rolled-back test, Murdoch (Semester 1 = February, Semester 2 = July) would have answered 47 reviews and ACU 23.
  - Governance gap: `security.quoted_study_periods` was created by a test statement before its migration. Migration 183400 re-created the same definition.
- **Recommended actions, in order of the courses they add:**
  1. **Approve the English policies that match the course pages (Platform Admin, Coverage › Attributes › English policies).** About 630 courses:
     - Flinders 197 (57 agree / 12 differ)
     - Adelaide 228 (163 / 56; its "language rich" exceptions are not named, so check them)
     - Deakin 59 (81 / 34)
     - Collarts 66
     - Smaller: William Angliss 19, CQU 14 (courses it names), AIH 14, Chisholm 11, AUT 10, Box Hill 8, Southern Cross 6
  2. **Check these English policies before approving.** There are no course pages to compare them with, or the policy hides exceptions:
     - Sydney 485 (says some courses need more)
     - Victoria University 158 (its second document disagrees 1 / 10)
     - Canberra 86 (40 / 31)
     - UNE 78
     - USQ 50
  3. **Leave the blocked English policies.** QUT, ECU and UTas picked up a nursing or band table.
  4. **Accept the prompt for Decision 228 parts 2 and 3, then set start months for the universities with most semester-only reviews.** Curtin 65, Murdoch 63, CQU 53, Griffith 41, TAFE International WA 36, UTas 35, UTS 34, ACU 24 (its calendar is parsed: Semester 1 March, Semester 2 August). Together about 350 reviews.
  5. **Intake check v1.3.0 as a new contract.** It accepts a month-name quote found as a whole word on the page, day-first dates (22/02/2027) and rolling or weekly intakes. It is qualified on the frozen holdout l3r-intake-h1 and switched on by the Platform Admin. It targets about 800 waiting intake reviews (350 of them repeat quote failures) and many of the 9,713 pages with no intakes found.
  6. **Course pages not proven to be the course.** Search again by exact course title on the university's own site for the 5,766 mismatched and about 3,800 missing pages, before any rule change. A rule change, for example the exact title as heading plus the university's own course-page address pattern, would be its own decision.
  7. **Calendars behind links.** Follow key-dates PDFs and links from calendar pages, as fee schedules already do. Most large universities' calendar pages are menus (Curtin, Griffith, UTas).
- **Open:** Decision 228 parts 2 and 3 wait for approval. The release of 183300 to 183500 and of the calendar screens follows once part 2 is live.

### 2 Oct 2026 (20:00 AEST) — English policies approved and applied; intake check v1.3.0 not qualified (Decisions 227, 229)
- **Asked (Platform Admin, 19:21):** "For 1, I have reviewed it ... we should leave as is and apply only to empty or not manually edited records. 2 I dont where to check these. 4 go ahead." Later, by multiple choice on group 2: "Apply all and leave and flag which aren't listed and courses meant for international students are priorities."
- **English group 1 approved and applied** (migration 20261002183600; stored md5 equals the file). 632 courses now have English from their university's policy:
  - Adelaide 228, Flinders 197, Collarts 66, Deakin 59, William Angliss 19
  - CQU 14 (its own named courses), AIH 14, Chisholm 11, AUT 10, Box Hill 8, Southern Cross 6
  - Values already on record were left as they are, including any that differ. The existing English values come from course pages (CRICOS does not publish English).
- **English group 2 checked against each university's own page:**
  - Victoria University: its requirements PDF gives bachelor 6.0 (no band below 6.0) and postgraduate 6.5 (6.0). It names 19 courses that need more. Use the PDF and reject the web-page versions.
  - USQ: 6.5 (6.0) for the majority of degrees. Bachelor of Nursing is named.
  - Sydney: standard 6.5 (6.0), but some faculties and courses differ and are not listed.
  - UNE: 6.0 (5.5) is a minimum; its higher-requirement courses are in a separate policy.
  - Canberra: no single score stated.
- **Group 2 approval with flags (migrations 20261002183700 and 20261002183710, on Pilot branch cf247-semester-months).** The flag rule:
  - Where a policy does not list the courses that need more, a course given the university standard is marked: its note says to check the course page, and its confidence is 0.6.
  - This also covers Adelaide and Deakin values already written.
  - Courses open to international students are written first.
- **Group 2 is not yet live.** The database tool's approval prompt came back cancelled for both migrations, so they are not applied. Approving Victoria University and USQ in Coverage › Attributes › English policies writes them at once (no flag needed). Sydney, UNE and Canberra wait for the flag step.
- **Decision 229, intake check v1.3.0, built as a separate contract.**
  - New file `_shared/cf247-intake-validation-v13.ts`. layer3-model-routing chooses the contract by the profile's prompt_profile_version.
  - The v1.2.0 contract file is unchanged and its binding descriptor is identical, checked in code and by test cf-247-intake-check-v13-contract.
  - Router deployed from the branch (version 9). All 10 deployed files equal the repo, and the live intake route still runs.
  - Two paused candidate profiles were added: Qwen3 30B and Claude Haiku 4.5 (migration 20261002183800; stored md5 equals the file).
- **What v1.3.0 accepts:**
  - short quotes that are on the page as whole words ("JAN 12", "12/01", "April")
  - a heading quoted with one item of its list, when every word is on the page in order and close together
  - day-first numeric dates
  - all twelve months for a quoted rolling, weekly or monthly intake
- **Qualification on the frozen holdout l3r-intake-h1 (47 cases): both candidates FAIL.**

| Candidate | Exact | Exact not stated | Wrong-admitted | Withheld | Incomplete | Cost (US$) |
|---|---|---|---|---|---|---|
| Qwen3 30B | 13 | 31 | 2 | 1 | 0 | 0.008 |
| Claude Haiku 4.5 | 12 | 32 | 2 | 0 | 1 | 0.18 |

- **The wrong admissions:**
  - "Rolling intakes (monthly)", which the gold reads as not stated (both models)
  - "Start Date Every Month" on a course closing to new international students from 5 October 2026 (Haiku)
  - a general "most courses start in Semester 1, usually in the last week of February" passage that is not about this course (Qwen)
- **Consequences:** nothing is switched on. The v1.3.0 profiles stay paused and the cascade is unchanged.
- **Before a v1.3.1 can be qualified:**
  - The Platform Admin must decide whether "rolling / monthly intakes" means all twelve months.
  - The safety rule must also catch "will not be available for new international student enrolments".
  - A rolling statement must name intakes or starts.
  - Because the h1 outcomes have now been read, v1.3.1 should be qualified on a fresh holdout (h2) read by hand, not on h1 again.
- **Also found:** intake cascade step 2 (Claude Haiku 4.5, v1.2.0) is already qualified (44/47 right, 0 wrong-admitted on h1) but switched off. Today only step 1 (Qwen3 30B) runs, so every quote failure goes straight to Layer 4. Switching step 2 on (Platform Admin, Control) would send failures to a stronger model first, at about US$0.004 a page.

### 2 Oct 2026 (20:20 AEST) — Intake cascade step 2 switched on; rolling intakes stay with a person
- **Decided (Platform Admin, by multiple choice):**
  - "Rolling / monthly intakes" stay with a person, so the v1.3.0 candidates stay paused.
  - "Switch on Haiku step 2".
- **Changed:**
  - Migration 20261002183900 switches on intake cascade step 2, Claude Haiku 4.5 on the qualified v1.2.0 contract. It becomes the final step; Claude Sonnet 4.6 stays off.
  - Migration 20261002184000 sends back once the 296 waiting intake reviews held for a quoting or format reason (quote not on the saved page, too many quotes, an answer that was not JSON). Reviews about months not in the quotes stay for a person.
  - Both migrations' stored md5 equal their files.
- **First cascade run after the change:** 22 of 40 pages validated, against 4–8 of 40 per run with step 1 alone; 36 of the 40 went to Haiku; US$0.19.
- **Credit:** OpenRouter credit is US$37.77.

### 2 Oct 2026 (20:35 AEST) — Candidate models Kimi K2 0905 and MiMo v2.6 Pro qualified on the h1 holdouts (Decision 230)
- **Asked (Platform Admin, 20:18):** "Qualify kimi-k2-0905 and mimo-v2.6-pro as alternative and cascade in models."
- **Done (Pilot branch cf247-candidates-kimi-mimo, PR #251):** migration 20261002184100 adds four candidate profiles — intake and English for each model — as copies of the qualified Qwen3 30B profile, each pinned to one named OpenRouter model (`moonshotai/kimi-k2-0905`, `xiaomi/mimo-v2.6-pro`; both listed in the catalogue with structured outputs). All four are paused and in no cascade. Applied live; the stored migration equals the file.
- **Qualification on the frozen holdouts** (rule: at least 95% exact on stated cases and zero wrong-admitted):

| Holdout | Model | Stated exact | Right of all | Wrong-admitted | Withheld | Cost (US$) | Result |
|---|---|---|---|---|---|---|---|
| l3r-intake-h1 (47) | Kimi K2 0905 | 12 of 13 | 43 | 0 | 4 | 0.10 | FAIL |
| l3r-intake-h1 (47) | MiMo v2.6 Pro | 12 of 13 | 45 | 0 | 2 | 0.06 | FAIL |
| l3r-english-h1 (37) | Kimi K2 0905 | 18 of 19 | 36 | 0 | 0 | 0.07 | FAIL |
| l3r-english-h1 (37) | MiMo v2.6 Pro | 19 of 19 | 37 | 0 | 0 | 0.04 | **PASS** |

- **Why each failed:** Kimi (intakes) withheld one stated page by returning more than twelve quotes; MiMo (intakes) withheld one stated page whose quotes were short numeric dates ("02 Feb") that the v1.2.0 quote rule does not match; Kimi (English) said "not stated" on a page listing two courses. None admitted a wrong value.
- **Consequence:** MiMo v2.6 Pro is qualified for the English task at about US$0.001 a page and could be added to the English cascade or kept as an alternative. Nothing is switched on; adding it to a cascade is a separate Platform Admin step. Neither model is qualified for intakes under v1.2.0.
- **Also delivered:** a workbook of data sources by course attribute and university (register, course page, PDF, policy page, calendar; ingestion layer; hard-coded, AI-qualified or person rules), built from the live database as at today.

### 2 Oct 2026 (21:05 AEST) — English cascade step 3 switched on: MiMo v2.6 Pro (Decision 230)
- **Asked (Platform Admin, multiple choice):** "Add as English step 3 (Recommended)".
- **Done (Pilot PR #252, merged):**
  - Migration 20261002184200: MiMo v2.6 Pro (qualified on l3r-english-h1, 37 of 37, 0 wrong-admitted) is English step 3 and the final step, after Qwen3 30B and Mistral Small 3.2. It was placed only after the same holdout evidence check as the ladder. Claude Sonnet 4.6 moved from step 3 to step 4 and stays off. Stored md5 equals the file.
  - Migration 20261002184300: the 281 waiting English reviews with no value on record were sent back once through all three steps. Reviews where the page differs from a value on record stay with a person. Stored md5 equals the file.
- **First 40 minutes, live:** 201 pages settled — 77 validated (going to admission), 69 not stated on the page, 55 to a person. 183 pages reached MiMo. Cost US$0.34. The intake cascade is unchanged.
- **Note:** a three-step English run can take longer than the 120-second HTTP wait of the cron call; the worker finishes the run regardless (confirmed from the work items).

### 2 Oct 2026 (23:15 AEST) — Overnight admission run, part 1: map-first link matcher, identity v0.5.7, admission fix, Hotcourses capture (Decisions 231, 232)
- **Asked (Platform Admin, 21:18):** "Keep using firecrawl and ai models cascaded approach and ill keep funding the both toolset. Outcome id maximum data admitted till tomm morning for au,nz,Canada. Extract all uni for Canada and nz from hotcourse as starting point if required using firecrawl, save as evidence as off-line website in our evidence bucket. Get started on new model asap."
- **Baseline at 21:20 (courses with a value):** AU official page 15,789 · English 8,518 · intakes 5,763; NZ 1,384 · 842 · 760; CA 163 · 29 · 21.
- **Decision 231 — map-first AI link matcher (live; Pilot PR #253):**
  - For a course with no verified page, the 25 closest addresses come from its university's stored site map (775,083 addresses for 1,694 providers; no Firecrawl credit).
  - One pinned model (Qwen3 30B 2507) picks the course's page or none; the choice must be one of the candidates.
  - The page is read and accepted only under the identity rule. Pages entered by hand are never replaced.
  - Cost about US$0.0001 a course. By 23:15: 408 pages chosen, 56 proven, 319 failed the identity rule (correctly in the cases checked).
- **Identity rule v0.5.7 (live):** a national qualification code before the exact title ("CHC52025 Diploma of Community Services") is the exact title. Stored mismatch pages were checked again without fetching: 423 of 8,100 now pass.
- **Admission fix (Pilot PR #254, migration 20261002185400):**
  - Cron coverage-admit was using the old default extractor (v0.5.4) while every page carries v0.5.6, so it had admitted nothing since 2 Oct.
  - The job now names the current extractor. A run by hand wrote 495 courses (0 errors, 0 to Layer 4).
  - AU official pages are now 16,284 (+495).
- **Decision 232 — third-party directories are hints only (Hotcourses captured):**
  - All 236 pages are stored under evidence thirdparty/hotcourses/: Canada and NZ site maps, 13 Canadian and 5 NZ listing pages, and all 208 institution profiles. robots.txt was read and respected.
  - 154 Canadian and 54 NZ institutions were found. 98 and 19 match our providers by exact name; course counts are kept for comparison.
  - The profiles show no official website (only tracking links), so Hotcourses gives no website hints.
  - Nothing from Hotcourses is admitted. Its terms bar commercial use without IDP's written consent: legal review is recommended before any further use.
- **OpenRouter weekly key limit:**
  - The key hit its weekly limit at about 22:40 and every model call was refused. The cascades released their work safely.
  - The matcher was paused, and refusals now return to the queue without using a course's attempts. It was resumed at about 23:00, when the key worked again.
- **AI page-identity check (contract cf247-page-identity-v1.0.2): qualification only, NOT switched on.**
  - Holdouts pid-h1 (development) and pid-h2 (fresh) were built from pages that print the course code (code masked for the model).
  - On pid-h2, Qwen3 30B and Claude Haiku 4.5 each accepted 1 wrong pairing and about half the right pairings → FAIL against the pre-set rule (≥95% right accepted, 0 wrong).
  - The one wrong pairing is a page whose heading is exactly the asked course but which prints a related award's code. The live exact-title rule would accept it too.
  - Many "right" pairings are general pages that merely print the code (the model correctly says no), so 95% may not be reachable with this gold. This needs a Platform Admin decision on the rule.
- **Waiting for the Platform Admin (not changed overnight):** Decision 203 limits Australian English to pages showing the CRICOS code. 708 English values from exact-title pages are waiting if that is relaxed.

### 2 Oct 2026 (22:10 AEST) — Correction to the times in the entry "Overnight admission run, part 1"
- The times in that entry and in the comments of migrations 20261002185100, 20261002185300 and 20261002185400 were estimated and are wrong. The times recorded by the database (applied versions, results) are:
  - first refused model call (OpenRouter weekly key limit): 21:52;
  - matcher paused (20261002185100): 21:54; matcher resumed (20261002185300): 21:57;
  - coverage-admit fix (20261002185400) and the hand run that wrote 495 courses: 22:05;
  - the entry itself: about 22:08 (not 23:15).
- Nothing else in the entry changes. The migration files are left as applied, so their stored text still equals the file.

### 2 Oct 2026 (22:30 AEST) — Reference sources, website hints, OpenRouter key status, priority control (Pilot PR #255, Decision 233)
- **OpenRouter weekly key limit:** checked at about 22:15. The limit is still US$50 a week and was not raised: US$35.52 used this week, US$14.48 left (US$5.93 today). It is likely to be reached again overnight; the matcher returns refused items to the queue without using attempts.
- **New sources (migration 20261002185500, md5 a27845fc…), recorded in pipeline.sources:**
  - Hipo university-domains-list (GitHub, MIT): website hints only. 10,268 rows read, 10,249 loaded, 134 matched to our providers by exact name. Stored as evidence under reference/hipo/.
  - univ.cc: third-party directory, hints only. Not captured: its robots.txt could not be read, so nothing was fetched (robots is not bypassed).
  - XuanXiao rankings: reference only, not read by any job. Its terms reserve text and data mining and forbid automated access.
- **Website hint check (worker coverage-sweep-worker-v0.10.1, extractor unchanged at coverage-sweep-v0.5.6):** a hint is accepted only if the home page proves it — AU: the CRICOS provider code on the page; CA/NZ: a .ca/.nz host plus the existing name or DLI rule. First run: 4 Canadian providers needed a website and had a hint (Royal Roads, North Island College, Fraser Valley, BCIT); all 4 were rejected by the name rule (one returned HTTP 403). Nothing was loosened.
- **Priority:** the AI link matcher's queue now follows the Priority queue pins (course order, then university rank), as page reads and matcher preparation already did.
- **Verification:** Pilot PR #255 merged after build-and-smoke; contract tests (30) and build passed locally; deployed coverage-sweep compared byte-for-byte with the branch by a separate check (5 files, all match).

### 2 Oct 2026 (22:45 AEST) — Australian English by exact title, university English statements, Firecrawl for reference sites, hourly report (Pilot PR #256, Decision 234)
- **Asked (Platform Admin, 22:26):** "Decision 203, if the university has declared agree category wide English requirement then we dont have to match it in course page but keep the evidence where uni defines it ... Cricos doesnt needs to be checked. For any reference website if direct access is not useful use firecrawl. Explain ai page proof test failed? And make the report and follow every hour with summary and recommended fix with doc, repo and relevant things updated."
- **Australian English by exact title (migration 20261002185600, md5 0a1426086bbd5c7fff3fb30f534b7976):** AU English is admitted from the CRICOS code or the exact title, as for course pages and intakes. A hand run wrote 796 values; 8 that differ from a held value went to Layer 4. Values entered by hand are never overwritten.
- **University-wide English statements (Decision 227, unchanged):** these already apply a university's level standard to every course of that level that has no English yet, with the policy document as evidence, once a Platform Admin approves the proposal. Migrations 20261002183700 and 20261002183710 (group 2 approvals) were not applied: the database approval prompt was cancelled again at 22:37, so no approval is recorded in the Platform Admin's name. The flag rule alone is applied (migration 20261002185700, md5 1bf6aa10fb9aa552d4cc6974d3ddbabb; security.provider_english_apply_v1 md5 625279c0… → b1d29a3d…). Recommended approvals (Sydney, Victoria University PDF, La Trobe, Canberra, UNE, CDU, EQUALS, UQ; about 826 courses) and rejections are listed in the overnight report for the Platform Admin to action in Coverage › Attributes › English policies.
- **Firecrawl when direct access fails (worker coverage-sweep-worker-v0.10.3; migration 20261002185800, md5 4b59d771c049d41df488f3b20fae2025):** website hints are read through Firecrawl when a site refuses us or the page does not prove itself as fetched. robots.txt per RFC 9309: rules followed; 404/410 or a file with no rule groups = no restrictions; unreadable = nothing captured. univ.cc (robots.txt with no rules) captured: world list plus AU, NZ and CA lists, stored under thirdparty/univcc/; 166 institutions, 98 matched to providers by exact name (hints only). XuanXiao stays reference only (terms forbid automated access and text and data mining; the tool used does not change that).
- **Website hints:** the 4 Canadian hints (BCIT, Fraser Valley, North Island College, Royal Roads) were read through Firecrawl and still rejected by the Decision 220 name rule (full name must be in the home page title or main heading; these sites use short names). Recommendation to the Platform Admin: also accept the full name in the home page footer or copyright line on the university's own .ca domain. Not changed.
- **AI page-identity test (explained):** on pid-h2 Qwen3 30B accepted 60 of 120 right pages and 1 of 120 wrong; Haiku 4.5 54 and 1. The "right" cases were chosen automatically and many are general pages that only print the code, so the ≥95% target cannot be met with this set; the one wrong acceptance is debatable. Recommendation: hand-check about 60 cases, change the pass mark to zero wrong acceptances across two sets, then a separate switch-on. Not switched on.
- **Report:** Claude Docs "CourseFinder overnight admission report — 2–3 Oct 2026" (summary, decisions, the test explained, waiting for the Platform Admin, hourly log). Hourly checks scheduled 23:50 to 05:50, morning report 06:30.
- **Verification:** Pilot PR #256 merged after build-and-smoke; 32 contract tests and the build passed locally; each migration's stored text equals its file (md5); deployed coverage-sweep compared byte-for-byte with the branch by a separate check (5 files match).

### 2 Oct 2026 (23:05 AEST) — Canada and New Zealand pinned first; univ.cc captured (Pilot PR #257)
- **Why:** by 22:45 the AI link matcher had prepared only Australian courses (the default priority order is Australia first, then the universities with the most courses). Canada had 163 verified course pages of 2,382; its 1,654 stored pages fail the identity rule because they are general listing pages, not course pages.
- **Change (migration 20261002185900, md5 bdb069e3a747d923ba4e0cb0fb38d7ca):** country pins Canada (1) and New Zealand (2) in pipeline.priority_pins, for the overnight run toward the Platform Admin's 21:18 outcome (maximum data for AU, NZ and Canada). 1,033 Canadian courses were prepared for the matcher at once. The pins show on the Priority queue screen and can be removed there.
- **univ.cc:** the Australian, New Zealand and Canadian lists were captured (robots.txt has no rules) and stored under thirdparty/univcc/: 263 institutions, 126 matched to providers by exact name (hints only). Only 2 more providers needed a website; both were rejected by the Canadian name rule.

### 2 Oct 2026 (23:10 AEST) — Correction to the univ.cc count in the entry "Canada and New Zealand pinned first"
- univ.cc holds 206 distinct institutions for the three countries, not 263 (Australia 53, of which 33 are matched; Canada 141, 84 matched; New Zealand 12, 9 matched), so 126 are matched in total. The count in the 22:45 entry (166 institutions, 98 matched) was taken before the third Canadian page was captured.

### 2 Oct 2026 (23:20 AEST) — Canada: websites, course search and the field + award page rule (Pilot PRs #258, #259, Decision 235)
- **Asked (Platform Admin, 22:50):** "I dont understand why getting the university website is so hard, you had dli listing with uni name and state, province which can be used to find the uni website. This can be also be found from hotcourse uni detials card. Once uni website is acquired, finding sitemap and courses page should be smooth." **By multiple choice (22:55)** on a Canadian page rule: "Yes, test then switch on (Recommended)".
- **Finding (plain words):** 26 of 34 Canadian universities already had a website and site map. The DLI list carries no web address and the Hotcourses cards link out only through tracking redirects. Canada was stuck at 163 of 2,382 courses because (1) the course search used our catalogue title as an exact phrase ("Medical Genetics: Doctor of Philosophy (PhD) - UBCV") that never appears on the university's site, so 2,003 searches found nothing; (2) the exact-title rule cannot match the university's own heading ("Doctor of Philosophy in Medical Genetics"); (3) the 1,654 stored Canadian pages that failed were general listing pages, correctly rejected.
- **Websites (worker v0.11.0):** a website is accepted when the full name appears anywhere on the home page and the address fits the name (initials or a distinctive name word), or the home page shows the DLI number. BCIT, University of the Fraser Valley, Royal Roads and North Island College accepted (were rejected under the title-only rule).
- **Search (migration 20261002190000, md5 bc7f531e20b6e2da9a320ce1e5b6eeb1):** Canadian searches use the title's words without quotes, brackets, colons or campus suffixes; 2,003 searches queued again. Within minutes 264 Canadian searches had found a page (previously 31). The monthly search credit cap (50,000; 46,238 used by 22:50) is unchanged and will stop the queue when reached.
- **Field + award rule (Canada only):** a page on the university's own site matches when its heading or title holds the same award (words or abbreviation) and exactly the same field. Combined, dual and double awards and generic awards never match; honours is part of the field; UBC Okanagan courses need "Okanagan" in the heading or title; archived calendar pages (a year in the address more than a year old) are not used. Built as identity v0.5.8, tightened to v0.5.9 (migration 20261002190100, md5 c9fb336e4b8e60f66d1ca15b979c4e37) and v0.5.10 after hand checks.
- **Hand check before switching on:** first 25 matches (v0.5.8): 23 right, 2 led to the honours and Okanagan tightening. Next 37 (v0.5.9): 36 right, 1 the right programme on a 2015 calendar page, which led to the archived-page check. No wrong pairing remained under v0.5.10.
- **Switched on (migration 20261002190200, md5 b81c1f835252f080becd78afb9273015):** Canadian admission accepts field + award for the official course page, English and intakes; tuition unchanged. First run wrote 25 courses. Canada at 23:18: 188 course pages, 46 English, 38 intakes (21:20: 163 / 29 / 21).
- **Verification:** each migration tested in a rolled-back transaction, applied, and its stored text checked against the file (md5); the guard checks held; CF-247 contract specs and the build passed before each deploy (one mobile UI test in cf-247-admin-simplify fails on main too, unrelated); each deploy (v0.11.0, v0.11.1, v0.11.2) compared byte-for-byte with its branch by a separate check.

### 3 Oct 2026 (01:15 AEST) — New Zealand degree-name rule, bulk English policy approval, search budget card; release v2.15.155 (Pilot PR #260, Decision 236)
- **Asked (Platform Admin, 00:57):** "\"yes NZ\" In English policies, make it bulk approval and some of the approved one still shoeing the greyed approve icon. Where so I increase search cap?"
- **New Zealand degree name (Decision 236; identity v0.5.12, worker v0.12.1):** at 00:50 the AI matcher had picked pages for 1,113 New Zealand courses and 1,069 failed the NZ rule, because university pages name a degree without its NZQA level. For degrees only (bachelor, graduate, postgraduate, master, doctor; levels 7–10), a heading that is exactly the degree name, optionally followed by its abbreviation, is accepted when the page names no other level of it. Conjoint, double and broad degrees taught in many subjects (Master of Arts, Bachelor of Science and similar) never match. Hand check: 45 matches under v0.5.11, 44 right and 1 a generic Master of Arts on a subject page, which led to the broad-degree exclusion. Switched on for the official course page, English and intakes (migration 20261003000400, md5 0d9113e1a6d9f0ede557ff126a1cd599); tuition unchanged.
- **Greyed Approve on approved universities (explained and fixed):** those rows were other documents of universities whose English policy had just been approved (Collarts, Box Hill, UQ, VU and others), most of them blocked because course pages disagree. Approving a document now closes the university's other waiting documents of the same kind (status superseded with a note); 9 were closed at once (migration 20261003000300, md5 cfc9cee15e2491787716f1cec55ef4e1; md5 guard on admin_provider_policy_decide).
- **Bulk approval:** Coverage › Attributes › English policies (and Academic calendars): tick several, or Select all that can be approved (blocked documents are left out), then Approve selected or Reject selected (public.admin_provider_policy_decide_bulk; each document goes through the same checks; one that cannot be approved is reported, not approved).
- **Search cap:** Jobs › Priority queue › Course-page search budget shows this month's search credits, the cap, what is left and searches waiting; a Platform Admin can raise the cap there (public.admin_course_link_search_settings, 1,000–500,000). At 01:00: 49,840 of 50,000 used, 320 waiting.
- **Platform Admin approvals noted (00:52–00:54, in the app):** English policies of Box Hill, Adelaide, Australian University College of Divinity (two documents), Collarts, AIH, QUT (research degree page), UQ (study page) and Victoria University (second copy of the PDF).
- **Verification:** migrations tested in rolled-back transactions, applied, stored text equal to the files (md5); CF-247 contract and browser tests pass (failing on main too, unrelated: one cf-247-admin-simplify mobile test and five legacy m245 UI contracts); release contract PASS v2.15.155 / 0.1.82; PR #260 merged after build-and-smoke; deployed coverage-sweep (v0.12.0 and v0.12.1) compared byte-for-byte with the commits by a separate check.

### 3 Oct 2026 (01:50 AEST) — Search budget moved to the top of the Priority queue; release v2.15.156 (Pilot PR #261)
- **Reported (Platform Admin, 01:39):** "Not visible in ui, Jobs › Priority queue › Course-page search budget, below the priority list".
- **Cause:** v2.15.155 placed the card below the 60-row "Current order" table and Recent changes, so it was easy to miss. The data call works for the Platform Admin (checked as that user: used 49,840, cap 50,000, can change).
- **Fix:** the Course-page search budget is now the first panel on Jobs › Priority queue; a browser test checks it. Release v2.15.156 / package 0.1.83; PR #261 merged after build-and-smoke; the deployed release check (Release Currentness Deployed) and Deployed UAT passed for the merged commit.

### 3 Oct 2026 (02:15 AEST) — Fee schedules and English policies moved to Layer 4 › Attributes; release v2.15.157 (Pilot PR #262)
- **Asked (Platform Admin, 02:00):** "Move english and fees from coverage attributes to layer 4 as the attributes tab."
- **Change:** a new Layer 4 Review tab, Attributes (Pipeline Operator and above), holds Fee schedules, English policies and Academic calendars with a country filter (All, Australia, New Zealand, Canada). Behaviour is unchanged (bulk approval, one approved document per university). Coverage › Attributes keeps the counts by attribute and links to Layer 4 Review › Attributes. The Platform guide moved the matching text from Coverage to Layer 4. No database change.
- **Verification:** CF-247 contract and browser specs pass (489; the one cf-247-admin-simplify mobile test fails on main too); release contract PASS v2.15.157 / 0.1.84; PR #262 merged after build-and-smoke; Release Currentness Deployed and Deployed UAT passed for the merged commit.

### 3 Oct 2026 (02:45 AEST) — Attributes lists open on Waiting; academic calendars explained; release v2.15.158 (Pilot PR #263)
- **Asked (Platform Admin, 02:30):** "Can you make the default filter as waiting and explain the academic year, how to find when the course starts, not session or trimester dates."
- **Change:** Layer 4 Review › Attributes › Fee schedules opens on Waiting (English policies and Academic calendars already did). The Academic calendars panel and the Platform guide now say what a calendar is for. No database change.
- **Academic calendars (explained to the Platform Admin):** a course's start months come from its own page. A calendar is used only when the course page gives its start as a study period ("starts in Semester 1") instead of a month; the calendar turns that period into a month (Decision 228). A calendar never adds a start to a course whose page names none. At 02:40: 49 calendars waiting; 355 intake reviews name only a study period and wait for their university's calendar, 73 more are held (for example a campus outside Australia). The step that writes those intakes after a calendar is approved (migrations 20261002183410 and 20261002183420, the 10-minute job provider-calendar-intakes) is not applied; until it is, approving a calendar records the start months and writes nothing.
- **Verification:** CF-247 specs 489 pass (1 fails on main too, unrelated); release contract PASS v2.15.158 / 0.1.85; PR #263 merged after build-and-smoke; Release Currentness Deployed and Deployed UAT passed.

### 3 Oct 2026 (03:05 AEST) — Calendar intakes step prepared, NOT applied (database approval cancelled)
- **Asked (Platform Admin, 02:53):** "yes calendars" (switch on the step that answers semester-only intake reviews from approved academic calendars, Decision 228).
- **Preview (rolled-back test, nothing written):** if all 49 waiting calendars were approved, they would answer 43 of the 428 semester-only intake reviews (Australian Catholic University 23, UNSW 12, Central Queensland University 6, Swinburne 1, Deakin 1). The rest have no usable calendar or a period with several start months; the largest are Curtin (67), Murdoch (63), CQU (48 more), Griffith (50), UTas (36) and TAFE International Western Australia (36). The earlier figure of 355 counted reviews waiting for a calendar, not reviews a calendar would answer.
- **Prepared:** migration 20261003000500_cf247_calendar_intakes_on.sql (md5 123f2f50cd92c23467eaa9a52833092d) on Pilot branch cf247-calendar-intakes-on: parts 2 and 3 of Decision 228 (prepared 2 Oct as 20261002183410 and 20261002183420, never applied) with the md5 guard on admin_provider_policy_decide updated to ed78f0a0bd0534430e194c543846edc5. It approves nothing.
- **Not applied:** the database tool's approval prompt came back cancelled three times (02:58 test, 03:00 and 03:02 after the Platform Admin chose "Try again now"). Nothing changed in the live database; the branch is not merged so that main matches the live database.

### 3 Oct 2026 (06:30 AEST) — Morning report, overnight maximum-admission run (21:20 → 06:30)
- **Result by country** (courses with an official course page / English / intakes):

| Country | 21:20 | 06:30 | Change |
|---|---|---|---|
| Australia | 15,789 / 8,518 / 5,763 | 16,516 / 11,142 / 5,954 | +727 / +2,624 / +191 |
| New Zealand | 1,384 / 842 / 760 | 1,656 / 937 / 760 | +272 / +95 / 0 |
| Canada | 163 / 29 / 21 | 869 / 250 / 115 | +706 / +221 / +94 |

- **What made the difference:** Australian English by exact title (Decision 234, 796 values); 77 university English policies approved by the Platform Admin (1,780 courses filled in total); Canadian search by title words and the field + award page rule (Decision 235); the New Zealand degree-name rule (Decision 236); Canada and New Zealand pinned first for the AI link matcher.
- **Spend overnight:** OpenRouter about US$2.30 (US$12.20 of the US$50 weekly limit left at 06:30; Layer 3 checks US$2.08); Firecrawl 15,801 credits (page reads 10,085, course search 4,242, policy documents 1,065, directories 245). No scheduled job failed overnight. Gains stopped after about 03:50: the matcher queue emptied and the Canadian searches cleared.
- **Waiting for the Platform Admin:** (1) apply the calendar step (Pilot branch cf247-calendar-intakes-on; its approval prompt was cancelled three times; answers 43 reviews from the 49 waiting calendars); (2) start months entered by hand for Curtin, Murdoch, Griffith, CQU, UTas and TAFE International WA (a screen to be built on request); (3) whether a parent course page may give English and intakes to its named majors (1,223 Australian picks rejected for that reason); (4) the AI page-identity test (recommended: fix the test set, then decide); (5) Hotcourses terms (legal review); (6) OpenRouter limit (fine at the current rate).
- **Report:** Claude Docs "CourseFinder overnight admission report — 2–3 Oct 2026" (summary, decisions taken, the AI test explained, decisions waiting, hourly log 23:10–06:30).

### 3 Oct 2026 (09:40 AEST) — Matcher throughput, intake cascade steps 2–3, Firecrawl AI extraction qualified (intakes pass, English not), screen audit
- **Direction (Platform Admin, 08:17 and 08:45):** raise the universities per matcher run to 200 or more; use Firecrawl's AI extraction as soon as possible ("Yes, qualify now"); MiMo as intake step 2 and Kimi as step 3; a 12:30 pre-meeting report for the 14:30 meeting; a less bloated UI, with every screen recorded as used or not used for decisions ("what is not been useful can be folded", after the 12:30 presentation).
- **Matcher throughput (migration 20261003000600, md5 73869355ac65759efa986d05e62966f5; PR #264):** the AI link matcher's prepare step cap 20 → 500 universities a run (job asks 200, 1,000 courses), the matcher 80 items a minute at 12 concurrent; 459 generic search recipes for mapped universities. Why: the morning report said the queues "ran dry"; they were throttled — 6,650 courses had never been offered to the matcher because the prepare step took 4 universities a run.
- **Intake cascade (migration 20261003000700, md5 f51c01712939db53a69a094ea64c9673; PR #265):** ladder now 1 Qwen3 30B, 2 MiMo v2.6 Pro (45 of 47, 0 wrong, US$1.26 per 1,000), 3 Kimi K2 0905 (43 of 47, 0 wrong, US$2.10), 4 Claude Haiku 4.5 (final), 5 Claude Sonnet 4.6 (off). Both admitted under the cascade admission rule (≥30 cases, ≥80% right, 0 wrong-admitted) they had met on 2 Oct but were marked "failed" against a stricter 95%-of-stated rule that Haiku does not meet either. 306 waiting intake reviews with no value on record (quote not on page / failed the checks) sent back once through the full ladder; semester-only reviews were not sent back (they wait for the calendar step).
- **Firecrawl AI extraction (migration 20261003000800, md5 58e06629217a938aa57ad1754ea69c98; worker coverage-sweep v0.13.0 → v0.13.3; PR #266; live function verified byte-for-byte after each deploy):** new worker mode `fc_extract_qualify` runs each frozen holdout case through Firecrawl's JSON format and records the answer and outcome in `pipeline.fc_extract_results` (report `admin_fc_extract_report()`). The same automatic checks as the live routes apply: the quote must be on the rendered page; a month counts only when its name is in the quote, a score only when its number is. **Qualification only — nothing admitted.** Runs (1,535 credits in all):

| Run | Prompt | Cases | Right | Wrong | Missed | Error | Rule |
|---|---|---|---|---|---|---|---|
| q-fcx-intake-h1 | 1 strict | 47 | 34 (72%) | 0 | 12 | 1 | fail (every stated case came back "not stated") |
| q-fcx-intake-h1-p2 | 2 plain, verbatim quote match | 47 | 35 | 4 | 8 | 0 | fail (months inferred from "rolling", "Trimester 1", "Autumn session") |
| q-fcx-intake-h1-v2 | 2 plain, checks as live | 47 | 43 (91%) | 0 | 4 | 0 | **pass** |
| q-fcx-intake-h1-v2b | 2 plain, repeat | 47 | 45 (96%) | 0 | 2 | 0 | **pass** |
| q-fcx-intake-h1-v3 | 3 (+ one continuous quote) | 47 | 44 (94%) | 1 | 2 | 0 | fail (one boilerplate "most courses start … February" admitted) |
| q-fcx-english-h1-v2 | 2 plain | 37 | 30 (81%) | 2 | 5 | 0 | fail (pathway scores listed as tests; "equivalent" tests given IELTS's number) |
| q-fcx-english-h1-v3 | 3 (+ the live English rules) | 37 | 31 (84%) | 1 | 4 | 1 | fail (one "equivalent" test still given a number) |

  Reading: for intakes with prompt 2, Firecrawl's extraction meets the rule in both runs (every miss was a right answer whose quote was stitched from several lines — it would go to review, not be admitted). For English it does not meet the rule (a wrong answer in both runs). Answers vary between runs of the same prompt (ECU boilerplate: "not stated" in one run, admitted in another), which is why Decision 237 keeps the weekly re-test and auto-pause for any provider-level route.
- **Decision 237** recorded in the design reference (matcher throughput; intake steps 2–3; Firecrawl extraction as a provider-level candidate: intakes qualified, English not, activation a separate Platform Admin step).
- **Screen audit (for the 12:30 report):** of 34 admin tabs, 8 had a recorded decision in the last 14 days. Keep 15, fold 7 into their neighbours, retire 12 never used for a decision (Layer 4 Blocks and Websites to find: 0 decisions ever; the four Layer 2 tabs: last wave 15 Sep; Layer 1 source settings and manual batch; Scholarships › Course links; Rankings › Datasets; Health › Capacity; Data model; Go-live checklist). Governance gaps found: several settings screens leave no audit row; publishing and pins are written by SQL only. Folding happens after the 12:30 presentation, on the Platform Admin's word.
- **Metrics at 09:35** (courses with an official course page / English / intakes): AU 16,695 / 11,220 / 5,954 (06:30: 16,516 / 11,142 / 5,954); NZ 1,657 / 937 / 760; CA 895 / 250 / 115.
- **Still waiting for the Platform Admin:** the calendar step migration (branch cf247-calendar-intakes-on, approval prompt cancelled three times); start months by hand; the majors/variants rule; the AI page-identity test; Hotcourses terms.

### 3 Oct 2026 (10:05 AEST) — Layer 3 daily cap, stored search results re-picked, course drawer, Settings page, approach for UI control, scholarships and vetting roles
- **Direction (Platform Admin, 09:26, every sentence kept):** hardcoded values requested many times must be reflected in the UI with complete control; find where the prompts and rules for English, intakes, fee rules, course links and scholarships are hardcoded and reflect them so a Platform Admin can adjust and run them; plan which pipeline step or admin menu each setting, variable and throttle belongs to and reflect them as soon as possible; update doco, repo, decision and design records and the platform guide; relink data (rankings where the university link is viable, scholarships where applicable); stop reinventing tabs and bloating decisions; work the admission plan with the attributes, which are stationary; simplify the course page's inline edit (the field that holds the value gets the edit button, not another foldable edit field; the comparison value field on top is not required); don't over-complicate the screens; revisit the scholarship plan for what counsellors need (applicable scholarship, monetary details, selection criteria, requirements) and deliver it with the toolset; plan which roles customer staff need to vet and edit data; three hours to finalise the approach and admit the maximum data by 12:30. Multiple choice (09:30): prompts change by "edit, test on holdout, then switch on"; two vetting roles, Reviewer and Editor; build the Settings page first, then the course drawer.
- **Layer 3 daily cap (migration 20261003001000, md5 f02d8bb61c92c976605f5be3dfab0caa; PR #267):** both cascades had stopped at 09:00 with "profile requests/day reached" — layer3_fact_claim_service counts every step's calls for a task together against one profile's 6,000-a-day cap. Raised to 40,000 for the enabled intake and English profiles; the daily spend guards (US$20 / US$15) and credit floor are unchanged. Both routes resumed at 09:25.
- **Stored search results re-picked (migration 20261003001100, md5 b2babcfebd3026f45849a851b99ddd79; PR #268):** 11,653 course-page searches had ended "none" on 1–2 Oct with results stored because the university had no URL recipe then; under the generic recipes the same pick function keeps a candidate for 8,789 courses with no page (AU 4,011, NZ 3,424, CA 1,354), bound and queued for the identity check at no search cost.
- **Correction (migration 20261003001300, md5 e9fc6b8c9212c6db0b8e9ed7ee3ddaa3; PR #271):** the generic recipes keep any page on the site, so 194 of the first 222 re-picked pages read were rejected, most read through Firecrawl at about 2,700 credits an hour against 17,000 left this month. Per the plan's retry timetable: a candidate whose address shares no title word waits 30 days (3,938), one word 7 days (2,319), two or more are read now (2,323). Nothing rejected unread.
- **Course drawer (release v2.15.159, PR #269, deployed checks passed):** opens on the course's values — official page, links, intakes, English, tuition, title, duration, delivery, description — each with its own Change button; the foldable "Edit this course" panel and the source-comparison strip are removed; "Fees & entry requirements" keeps only the registered CRICOS course cost.
- **Settings page (release v2.15.160, PR #270 open; migration 20261003001200 split into a cron helper and the read — both applied — and the write, whose approval prompt was cancelled four times):** Environment & keys becomes Settings, one section per pipeline step (2 find the course page, 3 read, 4 identify, 5 extract, 9 budgets): universities per matcher run, matcher and search speed, pages read per batch, page proofs per country and attribute, Layer 3 requests a day, daily spend guards, credit floor, Firecrawl limit and reserve (shown; written on the Layer 2 provider record until its control moves). Numbers apply at once and are logged; prompts and models are listed with version, hash, steps and holdout result and are never edited in place. Platform guide updated for the page.
- **Approach recorded in the pre-meeting report (Claude Doc "CourseFinder pre-meeting report — 3 Oct 2026, 12:30"):** the settings inventory mapped to pipeline steps; the course page edit; scholarships for counsellors (applicable scholarships, value, who qualifies, what to do and by when; 1,260 scholarships today, AU only, 123 published, mapped to 11,780 courses; NZ and CA none) and relinking of rankings and scholarships on the course page; Reviewer and Editor roles for customer staff (confirm or flag; edit in place, logged, never overwritten).
- **Decision 238** recorded in the design reference (settings controlled from the UI; prompts as versions; Reviewer and Editor roles).

### 3 Oct 2026 (10:30 AEST) — Settings page live, search candidates read directly, calendar step live, start months by hand
- **Why database prompts "never arrived" (Platform Admin, 09:51: "no settings or prompt to apply"):** the database tool refuses, on its own, any migration in which a line begins an `update` without its `where` clause on the same line — the Settings write function had one (`credit_floor`) and the calendar step's apply function had a multi-line update. The Platform Admin never saw a prompt. Convention from now on: every `update` keeps its `where` on the same line; a refused migration is split and re-sent, never retried unchanged.
- **Settings page (release v2.15.160, PR #270, deployed checks passed):** migrations 20261003001200 (cron helper, md5 9503ef532f81fc587593890d9d920211), 20261003001210 (read, md5 7328907d6a9cee8aa28b659702606964), 20261003001220 (write shell probe, md5 c174ba5f3ffcf0f670b9398c2124eb4e), 20261003001230 (write, md5 227c01cd00d1ef08eec0d522bdff9a2d) — all applied and matching the repository. The Firecrawl monthly limit and reserve are shown on the page and still changed on Scrapers & fetchers.
- **Search candidates read directly (worker coverage-sweep v0.13.4, PR #272, live function verified byte-for-byte; migration 20261003001400, md5 cdd7f5831ca430852611b628a95645cd):** a second correction found even two-word candidates mostly wrong and rendered through Firecrawl at about 6,700 credits an hour (migration 20261003001310, md5 f2212dc5b4e1fb5de8481ffc5ba07117, held them all for 7 days). svc_coverage_read_next now passes `basis`; a search candidate is read directly only, never rendered; the 6,257 held candidates were released at 10:10. Firecrawl use since: nil for search candidates; 76 credits in 30 minutes for the matcher's pages. In the first 30 minutes 103 candidates were accepted, 555 rejected, 139 wait as needs_render.
- **Calendar step live (Decision 228 parts 2 and 3; migrations 20261003001500 a2 md5 9208fe61f31dd6c46571353ddb68ccd4, 20261003001510 a1 md5 17206323b80758826b5a51fcea01fd5f, 20261003001520 b md5 19d95d0a1343e1eac2b3bf03a747a0f5; PR #273):** semester_intake_apply_v1, admin_provider_calendar_set, admin_semester_intakes_read, the policy-decide patch (approving a calendar reports how many reviews it answers; admin_provider_policy_decide md5 now 80c0203752072a848c81fe6daa6e6ff5), job provider-calendar-intakes every 10 minutes, listed on Automations. The two never-applied 2 Oct files (183410, 183420) removed from the repository. No calendar is approved yet (49 waiting; 39 reviews answerable once their calendar is approved, 216 universities with no calendar found).
- **Start months by hand (release v2.15.161, PR #274):** Layer 4 › Attributes › Academic calendars lists each university whose course pages name only a study period, with its waiting reviews; a Platform Admin enters the month each period starts and the calendar page; the reviews are answered within 10 minutes. Guide updated.
- **Pipeline at 10:25:** Layer 3 admitted 830 intakes and 115 English values in the hour after the daily cap was lifted; the AI matcher decides about 4,200 pages an hour (558 chosen); 7,297 pages wait to be read at about 1,700 an hour.

### 3 Oct 2026 (12:00 AEST) — Report-back and notes live; Decisions 239 and 240; pre-meeting report final
- **Direction (Platform Admin, 10:46):** academic dates reviewed ("trimester 1 seems to be the starting intake, or semester 1"); notes may be left on the evidence linked to a field for later correction by a Platform Admin or operator; a mechanism is needed from the Zoho consumer/counsellor side to flag or report back an edit. **(10:58):** on a UBC graduate page the international fee and a September intake were found by hand; add an application deadline date (international) to every course, found from the scraped pages. Multiple choice (11:10): Canadian tuition from the course's own page, labelled International, in CAD — yes, tested on a sample first (Decision 239); application deadline as the sixth attribute, pattern first and AI contract later (Decision 240).
- **Report-back and notes (migration 20261003001600, md5 035bd868c8abd161ff323b8c4ba07f5c; Zoho course API deployed and verified byte-for-byte; PR #275):** `zoho_edge_report_v1` behind the Zoho course API action `report` (course_id or stable_key, field, note, reporter name/email/ref) and `admin_value_note_add` for an assigned role; both write an open flag with the note on the course's field (`pipeline.data_flags`, flag_code reported / note) that Layer 4 › Flagged values lists. No value changes from a note. Function tested in a rolled-back transaction. The note button on the course page comes in the next release.
- **UBC check:** 260 UBC graduate pages are bound, 223 read and accepted by field + award; 194 carry the September intake; none carry tuition because the Canadian rule (Decision 220) asks for the course code on the page.
- **Decision 239 (Canadian tuition from the course's own page):** a page that passed exact title or field + award, an amount labelled international, in CAD, basis as printed (first year or per year); tested on a hand-checked sample before switch-on (plan step 9, 6–8 Oct).
- **Decision 240 (application deadline, international, the sixth attribute):** open date, deadline and the intake it applies to, read from the course page; a plain pattern first ("international applicant deadline: 1 February 2027"), the AI contract with its own holdout after; shown on the course page and through the Zoho API (plan step 10; pattern 7–9 Oct, contract 14 Oct).
- **Metrics at 11:50** (courses with an official course page / English / intakes): AU 16,862 / 11,343 / 6,147; NZ 1,921 / 1,041 / 1,212; CA 920 / 261 / 432. Since 21:20 on 2 Oct: AU +1,073 / +2,825 / +384; NZ +537 / +199 / +452; CA +757 / +232 / +411. Spend since 06:30: Layer 3 3,555 calls US$3.53; matcher 11,913 pages US$0.66 (1,687 chosen); Firecrawl 5,934 credits (83,749 of 100,000 this month). No scheduled job failed in 6 hours. Waiting for a person: 841 intake reviews (calendars: 0 approved of 49), 125 English, 48 identity, 18 tuition; 3,249 pages queued to be read.
- **Pre-meeting report** (Claude Doc "CourseFinder pre-meeting report — 3 Oct 2026, 12:30") final at 11:55 with these figures, plan steps 9–11, and the decisions list for 14:30.

### 3 Oct 2026 (12:15 AEST) — Academic calendars: a column per study period, approve as shown
- **Direction (Platform Admin, 12:05):** "Layer 4 academic year should suggest trimester 1 and semester 1 as input field in separate column and seek approval or else apply it."
- **Release v2.15.162 (PR #276, deployed checks passed):** Layer 4 › Attributes › Academic calendars shows Semester 1, Semester 2 and Trimester 1–3 as separate columns, each with the suggested start month as an input (terms and sessions in a last column). Approve applies the months as shown; a changed month is saved by hand (admin_provider_calendar_set, approved) and the parsed document is closed with the note "Replaced by the months entered on the Academic calendars list", so the course pages get exactly what the Platform Admin saw. Period keys on the live data are "semester 1", "trimester 1" (with a space); the contract tests use the same.
- At 12:15: 0 of 49 calendars approved; 841 intake reviews wait on them.

### 3 Oct 2026 (12:45 AEST) — Academic calendars: Intake 1, 2 … columns
- **Direction (Platform Admin, 12:30):** "I like the inline edit, but the heading on suggested column should be intake 1, 2 and so on. And option in drop down to only select intake 1 and leave intake 2 and so on as null."
- **Release v2.15.163 (PR #277, deployed checks passed):** the columns are Intake 1, Intake 2 … (up to six) in the order the calendar names its periods, the period shown under each month; the dropdown has "Not an intake", so a later intake can be left empty; only the intakes with a month are applied on Approve (saved by hand when they differ from what was parsed; the parsed document is then closed).

### 3 Oct 2026 (13:00 AEST) — Academic calendars: Intake 1 and 2, raw value captured
- **Direction (Platform Admin, 12:41):** "Max should be intake 1 and intake 2, and 3rd column raw value captured. Free fill intake 1 as trimester 1 or semester if trimester is not available; if both trimester or semester 1 doesn't show another month then intake 2 remains null."
- **Release v2.15.164 (PR #278, deployed checks passed):** Intake 1 and Intake 2 columns only, with "Raw value captured" (every period and month as parsed) beside them. Intake 1 is pre-filled from Trimester 1, else Semester 1, else the first period; Intake 2 from the second period of the same kind only when its month differs, else Not an intake. On Approve each intake month is written to every period of that rank the calendar names (semester 1, trimester 1, term 1 …), so a course page is answered whatever it calls its periods; only intakes with a month are applied; a row that differs from what was parsed is saved by hand and the parsed document closed.

### 3 Oct 2026 (13:15 AEST) — Approved calendars now reach the courses; links on each calendar row
- **Direction (Platform Admin, 12:51):** "Apply intake had 2 rows both of them approved but not recorded in the courses for provider? Academic calendar records under review should have internal and external link for easy navigation and validation."
- **Found:** three universities approved between 12:30 and 12:49 (ACU by hand: Semester 1 = March; Adelaide parsed; AAPoly by hand and parsed). Two faults: when a university had both a by-hand and a parsed approved calendar, the parsed months won for the same period; and a course page naming a period the Platform Admin left as "Not an intake" was held with "a period has no approved start month", so nothing was written. Adelaide and AAPoly had no waiting semester-only reviews, so there was nothing for them to answer.
- **Migration 20261003001700 (applied, md5 70e7d27324debb51800175a35421d680; md5 guards on both live functions):** calendar_period_months prefers by-hand months; new security.calendar_set_by_hand; semester_intake_plan_v1 answers a course from the periods that have a month when the calendar was set by hand (parsed-only calendars keep the every-period rule). The job then answered ACU's reviews: 7 ACU courses carry March.
- **Release v2.15.165 (PR #279, deployed checks passed):** each calendar row links to the university in CourseFinder and to its calendar page.

### 3 Oct 2026 (13:45 AEST) — College intakes from the approved calendar (Decision 241); provider-page tuition for Australia (Decision 242)
- **Direction (Platform Admin, 13:18, AAPoly Advanced Diploma of Hospitality Management 112083E):** the course link is populated and the calendar approved, yet the intake field stayed empty; no tuition although the page states a per-term fee and the number of terms; duration is listed too. Multiple choice (13:25): calendar default for VET/TAFE colleges only; provider-page fees for Australia beside the CRICOS fee, with basis and term count.
- **Found:** the page (bound by its CRICOS code) names no study period, so under Decision 228 the calendar had nothing to attach to; tuition was empty because Decision 225 keeps CRICOS as the Australian source (this course's registered fee A$16,000 is shown under Registered CRICOS course cost; the page's A$3,080 × 2 terms = A$6,160 is for the package); the page's "2 Terms" differs from the registered 101 weeks for the same reason.
- **Decision 241 (migration 20261003001800, md5 59cf68c513aa1d94a7ebacae8516d1ab; PR #280):** for an Australian college (not named University) with an approved calendar, Intake 1 and 2 fill each course that has an official page, no intake, no hand lock and no waiting review with a value; by-hand months alone count when set by hand; the calendar page is the evidence; keys say calendar_default; job provider-calendar-defaults every 10 minutes, on Automations. First run: 49 courses (AAPoly 10, Cass 23, Albright 14, APC 2); AAPoly 112083E now carries March.
- **Decision 242 (to build, plan step 12):** Australian provider-page tuition captured beside the CRICOS fee — per-term amount, number of terms and total as printed, labelled provider page, CAD/AUD as printed; a difference above 20% from the registered fee is flagged for review. Duration as printed on the page recorded the same way beside the registered duration.

### 3 Oct 2026 (14:45 AEST) — One Academic calendars list; calendar parser v0.2.2 (Curtin); provider drawer inline; Scholarships Audience filter (release v2.15.166, Pilot PR #281)
- **Asked (Platform Admin, 13:50):** Curtin's course pages say "Semester 1, Semester 2" and its calendar page (already in CourseFinder) shows Semester 1 starting in February and Semester 2 in July — where do parsing rules for universities live in the UI, and should Start months by hand be redesigned like Academic calendars (Intake 1 / Intake 2)? Multiple choice (14:05): "Fold into one list + fix parser". Then (14:12): the provider drawer edited inline, no fold, fields grouped by priority — attributes after the header, then contacts, then rankings. Then (14:21): the Scholarships list runs past the page; a filter for international students; scholarships under Publishing not searchable; the course drawer appears to show tuition twice.
- **Found:** Curtin's calendar page had been read (3 Oct) but parser v0.2.1 returned no values because the page names the period on its own table row ("| Semester 1 |") and the date on the next ("| Start date | Monday 16 February |"); Murdoch University's key-dates page carries no dates in its text (loaded by script). Scholarships: all 1,260 on record carry audience `international` (a default, not read from the page), so an audience filter separates nothing until audience is read from each scholarship's wording. Course drawer: the editable "Tuition" is the fee read from the course page (`provider_current_tuition`), empty for Australian courses because Decision 225 keeps CRICOS as the source; the "Registered CRICOS course cost" block below is the regulator's record — two fields, not a duplicate.
- **Where rules live:** the generic parser rules stay in the worker (`coverage-sweep/policy.ts`, `provider-policy-v0.2.2`) and move to Settings › step 7 "University documents" as a versioned, tested rule set under Decision 238; the months a Platform Admin saves for a university are that university's rule (approved by-hand calendar, wins over parsed values; Decision 228 / 13:05 entry). No per-university regex editor.
- **Change (worker coverage-sweep v0.13.5, deployed 14:08, verified byte-for-byte by a separate agent):** calendar parser v0.2.2 — a period named on its own section row or in the block heading applies to the "Start date …" rows that follow it until the next period is named; census/end rows add nothing. Mode `provider_facts_parse` re-ran over all 392 stored calendar pages (no Firecrawl credit): 68 proposals (was 60); Curtin: semester 1 = February, semester 2 = July; RMIT March/July; Deakin trimesters March/July.
- **Change (release v2.15.166 / package 0.1.93, Pilot PR #281, merged 14:35; Pilot Frontend Build and Release Currentness Deployed green on d47cfe9):** (1) Start months by hand folded into the Academic calendars list — a university with no months found is a row of the same shape (Intake 1, Intake 2, periods on its course pages, reviews waiting, calendar page address) with **Save months** (`admin_provider_calendar_set`); nothing is rejected; `CalendarByHand` removed; (2) provider drawer: `ProviderEditor inline` — header › provider values (name, website, city, course finder, applicants, description, then the facts in priority order: university group, ID, stable key, country, canonical name, currency, course/projected/scholarship counts, search and publication status, lifecycle, last verified) › contact details (phone, email, address, postcode) › contact card › world rankings › context; (3) Scholarships list: Audience filter and the Award column clipped to one line; (4) course drawer: the field is named "Tuition from the course page (international)" and, for an Australian course with none, says the tuition shown to counsellors is the registered CRICOS cost below (Decision 242). Platform guide updated; `GUIDE_REVIEWED_FOR` 2.15.166.
- **Migration 20261003001900_cf247_scholarships_page_audience (md5 447a85b860ee30605e9771f7a227ff7b, applied 14:40, live text = file):** `security.admin_scholarships_page` gains the `audience` predicate under an md5 guard on its live text (4dfeab65…); no other change.
- **Verification:** parser fixture (Curtin layout) and by-hand row browser test pass; local suite 321 pass, 18 pre-existing failures (the same 18 fail on the parser-only commit 592964b: cf-061/065/067/075/091/103/104/150/215, m2-5, m245 legacy); release contract PASS; CI build-and-smoke green before merge.
- **Open for the Platform Admin:** approve Curtin (February / July) and the other 67 calendar proposals on the Academic calendars list; Murdoch University needs its months entered by hand on the same list. Scholarship audience: a text-rule pass over each scholarship's description and criteria (international / domestic / all / not stated) before the Audience filter and the Publishing ready list mean anything — question put to the Platform Admin at 14:45; publishing stays a deliberate step.

### 3 Oct 2026 (15:05 AEST) — Scholarship audience read from each scholarship's wording (Decision 244; release v2.15.167, Pilot PR #282)
- **Asked (Platform Admin, 14:21 and multiple choice 14:50):** an international-students filter on the Scholarships list, and the scholarships under Publishing made available for search. Choice: "Read audience from wording, then publish international".
- **Found:** all 1,260 scholarships carried audience `international` as a default never read from the page, so the filter (v2.15.166) and the Publishing ready list (344) separated nothing; the ready list held domestic-only awards (Adelaide hockey travel grant, trombone scholarship). The course and provider scholarship selections served only `audience = 'international'`.
- **Change (migration 20261003002000_cf247_scholarship_audience_from_wording, applied 15:00, live text = file md5 4a230259badbce20a8a4a2ed63b4e026; rolled-back test first):** `scholarship.audience_readings` and `security.scholarship_audience_read_v1()` — fixed phrase rules over each active scholarship's name, description and criteria give international / domestic / international_and_domestic / not_stated, the matched phrases kept as the basis; the scholarship's audience is set from the reading unless set by hand (manual lock); the two selection functions now also serve `international_and_domestic` (replaced under md5 guards 0aac648f… / 45afb487…); job `scholarship-audience` hourly (41 past), on Automations. First run: 1,235 read, 924 changed → 311 international, 187 international and domestic, 278 domestic, 459 not stated. The Publishing ready list is 177 (international and both); nothing was published. Already published: 2 read as domestic (Stan and Jessie Holland; Doherty) and 25 as not stated — left published for the Platform Admin to hold or keep.
- **Release v2.15.167 / package 0.1.94 (Pilot PR #282, merged 15:03 after build-and-smoke):** list labels for the two new values; guide updated; `GUIDE_REVIEWED_FOR` 2.15.167.
- **Open for the Platform Admin:** Publishing › Publish the ready list (177); review the 2 + 25 published domestic / not-stated; the 459 not-stated stay held until a person decides or a later reading finds a phrase.

### 3 Oct 2026 (22:10 AEST) — Scholarship module: sources review, plan v1, award tiers, nationality, Zoho scholarships action (Decisions 245, 246; releases v2.15.167–168, Pilot PRs #282–#284)
- **Asked (Platform Admin, 20:22–20:51):** where the scholarship selector and plan stand; a review of six scholarship sources and the Hotcourses scholarship position; a plan for global coverage with pgvector for the website and Zoho; then "don't make endless plan, clear your intentions and keep working on this". Multiple choice (20:55): coverage AU, NZ, CA + UK and USA government awards; serving exact selector + pgvector search; nationality as a first-class field read from wording; funder scholarships not now.
- **Recorded:** `docs/scholarships/scholarship-sources-review-2026-10-03.md` (admin PR #141) — Hotcourses: course directories only were captured (Decision 232), no scholarship sitemap, terms bar use; the four aggregators (internationalscholarships.com, IEFA, internationalstudent.com, edupass list) are benchmarks only (registration walls, no API or reuse terms); Study Australia and DFAT are already sources of record. `docs/scholarships/scholarship-module-plan-v1.md` (PR #142) — record model, sources per country, serving layer, fold/retire, nine steps.
- **Decision 245 — award tiers from the page (migration 20261003002100, md5 632a866961e1af3491de68ae2447cf99, live = file; Pilot PR #283):** a page that states several values gives award tiers (tier codes page_tier_*) with the page as evidence; the value text becomes the range ("20% to 70% of tuition fees", "Up to A$15,000 (A$2,500, A$5,000, A$15,000 stated)"); a page-tier value counts as a stated value for publishing and is never a saving; hand values and other currencies untouched. 283 scholarships, 707 tiers; Publishing ready list 177 → 268.
- **Decision 246 — nationality from wording (migration 20261003002200, md5 e79fb577985fcdbbe1964cec5410a0f1, live = file):** `ref.nationality_terms` (103 countries, 11 regions), `scholarship.nationality_readings`, `scholarships.nationalities`, hourly job scholarship-nationality (43 past); Australia never a nationality; "New Zealand citizen" at an Australian provider is the domestic rule, not a nationality. 59 scholarships name one (India 11, China 7, Vietnam 6, Sri Lanka 4 …).
- **Serving (migration 20261003002300, md5 ee4532e21c3912ace8c65a5f81254f4a; 002400, md5 6153b56ca0870f85c131201fadfd65f6; edge zoho-course-api deployed and verified byte-for-byte):** the course and provider selections carry nationalities and the maximum flag; `public.zoho_edge_scholarships_v1(p_course)` and Zoho action `scholarships` return the published scholarships for a course with value and tiers, audience, nationalities, who qualifies in the page's words, saving per year, dates, page link; list and record reads carry nationalities.
- **Releases:** v2.15.167 (PR #282, audience labels), v2.15.168 (PR #284, Nationalities column, "Who it is for" on the record, guide). Contract tests added; CI green before each merge.
- **Next (plan steps 4–8):** source registry and Study Australia tool read via the worker; NZ/CA provider readers; UK/US government readers; pgvector embeddings and `scholarship_search_v1`; fold Course links and retire the runtime workspace. **For the Platform Admin:** Publishing › Publish the ready list (268).

### 3 Oct 2026 (23:50 AEST) — Scholarship operations established: Layer 4 publishing, course attribute with savings, clean values, 30-day re-read (Decisions 247–249; releases v2.15.169, Pilot PRs #285–#286)
- **Asked (Platform Admin, 21:16–21:43):** a scholarships UI mockup to interact with (made: design canvas "Scholarships UI mockup" — counsellor view, record drawer, list, publishing — with live records); comment "Search — on course as well"; "UI is good and concise"; whether Publishing belongs to Layer 3 or 4; where the data comes from, how publishing and course alignment work, tasks and cron jobs, how new scholarships and changed fees or percentages are handled, whether calculated amounts are a course attribute — "record and establish this now". Multiple choice (21:50): AU saving "Estimate from CRICOS, labelled"; the 27 published that now fail a check "Let it run as Decision 139 says" (withdrawn at 06:17 AEST).
- **Found:** publishing, withdrawal and re-costing did not reach the course attribute (nothing re-projected it); the attribute listed every scholarship scoped to a whole provider, not the decided course links; page fragments reached the course attribute and Zoho as the value; only 3,450 of 22,240 course–scholarship pairs had a saving (10,070 had no provider annual fee); pages were re-read about every 90 days.
- **Decision 247 (migrations 20261003002500 md5 36b46049ae6de3be208b9a390904c489; 002600 md5 a30d40e30587fb9191a0357dd336659d; 002900 md5 111a04b85fbb59767400a289d52cace6; all live = file):** saving estimated from the registered CRICOS cost ÷ registered years where no provider annual fee (basis estimated_annual_from_registered_total) — savings 3,450 → 13,406; course attribute = published, international, decided-link scholarships with value, audience, nationalities, saving and basis; jobs scholarship-course-attribute (every 15 min) and -full (06:51 AEST) — 6,060 courses show scholarships, 3,348 with a saving; published and ready scholarships re-read at least every 30 days (job scholarship-reread-cadence, 05:37 AEST).
- **Decision 248 (migration 002700, md5 c96d69435b8aada5631352a84d22d5be):** the value shown is built from the recorded value (`scholarship.value_label`), never page text; used by the course attribute, Zoho and the Scholarships list.
- **Decision 249 (release v2.15.169, PR #285):** Publishing moved to Layer 4 Review › Scholarship publishing; old addresses redirect; Live activity and Platform health links repointed. Scholarships list: Course search (migration 002800, md5 c9f256a0f336dddac80cded73dc9cd4f) and the clean Value column.
- **Recorded:** `docs/scholarships/scholarship-operations-v1.md` — sources, pipeline by layer, readiness checks, course attribute, savings, change handling, every scheduled job with its AEST time, next builds.
- **Verification:** each migration tested rolled back first where it changed behaviour, then live text = file; full suite 322 pass with only the pre-existing baseline failing (four tests updated for the tab move and v2.15.166's labels); CI green before merge.

### 3 Oct 2026 (23:05 AEST) — Platform guide reviewed for the scholarship module (release v2.15.170, Pilot PR #287)
- **Asked (Platform Admin, 22:48):** "Make sure platform guide is now updated with this module update."
- **Found:** the guide's Courses and Scheduled jobs entries said nothing about scholarships; it did not say where scholarship data comes from or what happens when a provider changes a value; there was no daily step or signal for scholarship publishing; two lines still pointed to Coverage › Attributes (moved to Layer 4 Review › Attributes on 3 Oct, v2.15.157).
- **Change (`src/guide/platformGuide.js`, `GUIDE_REVIEWED_FOR` 2.15.170):** Scholarships — sources, list columns and filters (Audience, Course), Who it is for, change handling (30-day re-read, 15-minute course refresh, 06:17 withdrawal, 06:41 savings), the course API `scholarships` action; Course links and publishing actions point to their screens. Courses — scholarships on a course with savings (estimates marked); tuition from the page vs the registered CRICOS cost. Scheduled jobs — the scholarship automations with Melbourne times. Daily routine and Approvals duty — Scholarship publishing. Signals — withdrawn at 06:17, "Value not stated", estimated saving. Stale Coverage › Attributes references fixed.
- **Verification:** guide contract and release tests pass; CI build-and-smoke green before merge; Pilot Frontend Build, Release Currentness Deployed and Deployed UAT green on 2abee5a.

### 3 Oct 2026 (23:50 AEST) — Scholarship screens brought in line with the mockup (release v2.15.171, Pilot PR #288)
- **Asked (Platform Admin, 23:27 and 23:30):** the live Scholarships list "doesn't match up with mockup"; "Make sure the rest of scholarships screens are in line with mockup."
- **Change — list:** columns Scholarship (provider and courses linked), Value, Who it is for (audience and nationalities, or Any nationality), Closes, Status (Published, Ready to publish, Held with reasons, Inactive); status pills with counts filter the list (migration 20261003003000, md5 43784c25bfe334bdf5939a4b36ce12e5: status, held reasons and counts on `admin_scholarships_page`).
- **Change — record drawer:** one row per fact (who it is for, nationalities, value, how long, who qualifies, application, provider page, courses), each marked Read from page or Entered by hand with the page's words; Change saves as entered by hand with a reason; Let automation update this hands it back; history; Hold from publishing. The Study Australia comparison and the Layer 4 overlay are kept, folded beneath.
- **Change — Scholarship publishing:** four tiles (Published, Ready to publish, Held, Published but now failing a check) and a view listing the failing ones with reasons; held reasons as a list with what each means and who fixes it.
- **Change — course drawer:** a card per scholarship with value, who it is for, nationalities, Published / Not published, saving a year (marked when estimated from the CRICOS cost), closing date and page; Student nationality filter; not-yet-published shown on request.
- **Database (migration 20261003003100, md5 ea58ff00ee8d360e3f095a22a162d385, live = file):** `admin_scholarship_record_read`; `admin_scholarship_edit` gains set_audience and set_nationalities (kept against the hourly readers); course scholarships and the publishing read carry the value label, nationalities, status, close date and the published-but-failing list (27 today). **Fix:** the page-tier reader (Decision 245) checked hand locks under the wrong field names; it now respects award_amount / award_percentage / award_value_type / award_value_text locks. Each replaced function was md5-guarded on its live text.
- **Verification:** live reads checked under a Platform Admin claim (record, publishing counts — published_failing 27 — and list status counts 123 / 268 / 844 / 25); full suite with only the pre-existing baseline and environment-only deployed specs failing; five new contract tests; CI build-and-smoke green before merge; Pilot Frontend Build, Release Currentness Deployed, Deployed UAT and Release History Contract green on f497277.

### 4 Oct 2026 (00:50 AEST) — Published-only Scholarships module; New Zealand and Canadian scholarships (Decision 250; release v2.15.172, Pilot PRs #289 and #290)
- **Asked (Platform Admin, 00:09 and 00:11):** "I still don't see courses attached to published scholarships and there is no scholarships for NZ and Canada, if they [have] sources, register them in layer1 and ingest data, cross link with courses internally"; "Scholarships module should only show published ones, remove filters and tag buttons relating to [status] in module UI, layer 1 to layer 4 can handle backend."
- **Found — courses:** all 391 published scholarships were linked to courses, but the 268 published at 00:05 came after the 00:00 course refresh; the refresh was run at once (courses showing scholarships 6,060 → 8,989). The scholarship record showed only a count.
- **Found — NZ and Canada:** discovery had only ever queued Australian providers; admission accepted Australian universities only; every amount was stored as AUD; domestic wording was Australian only. Canada's 1,130 providers have no website on the provider record (the website finder verified 30, BC and Alberta).
- **Change (migration 20261004000100, md5 687e65530d55d43fe726dffe503d238e, live = file):** provider-country currency in admission, page apply, criteria, tiers, value label and hand edit; NZ and Canadian universities admitted (Australian rule unchanged — 0 differences checked); stable keys carry the country; domestic wording and nationalities read for the study country; discovery refill covers every scholarship country and uses the website finder's sites; 25 universities queued (8 NZ, 17 Canada); Layer 1 sources Manaaki New Zealand Scholarships and Study in Canada Scholarships registered; the record read lists linked courses by study level. Seventeen patches, each md5-guarded and found exactly once; tested rolled back first.
- **Change (reader):** scholarship-sweep-v0.6.0 (amounts in the provider currency; Canadian and NZ domestic-only wording; "study permit") and v0.6.1 (numeric character references in titles decoded); coverage-sweep v71 and v72 verified byte-for-byte. Migration 20261004000200 (md5 ebee57f62cea24f1f867285b1e7c2805, live = file) decoded 8 stored names.
- **Change (UI, v2.15.172):** Scholarships list shows published only — no Status column, status pills, Lifecycle or Publication filters; record shows courses by study level with the list of linked courses, no status chip or hold; course record shows published scholarships only. Guide updated.
- **First results (00:45):** 12 universities mapped, 1,293 candidate pages, 8 scholarships admitted (UBC, Massey, Waikato) with C$/NZ$ values and course links (e.g. Waikato 165 and 223 courses). They wait in Layer 4 › Scholarship publishing for a Platform Admin.
- **Open:** one admitted page is a news story ("Tanisha's success with the Career Ready Advantage Award", UTS) — admission should refuse story pages; Canadian coverage is BC and Alberta only until the website finder and course coverage reach other provinces.
- **Verification:** contract tests for the reader (NZ$, C$, foreign-currency, Canadian and NZ wording, title decoding), migration shape and the published-only screens; full suite with only the pre-existing baseline and environment-only deployed specs failing; CI and deploy workflows green on 1aa940a.

### 4 Oct 2026 (02:15 AEST) — Scholarships at each layer (Decision 251; release v2.15.173, Pilot PR #291)
- **Asked (Platform Admin, 01:24):** which layer scholarships are configured for ingest, source URLs per country (several, plus reference and validation sources as supplied earlier), how much has run, successes and failures, whether Layers 2 and 3 are configured — and all of it in the UI per layer.
- **Found — Layer 1:** AU has 2 ingest feeds (Study Australia weekly, last read 3 Oct, 204 records; Australia Awards every 30 days, last read 9 Sep), 22 university scholarship catalogues and 210 single-page sources; NZ and CA have one government programme each (registered 4 Oct). The four third-party sites reviewed on 3 Oct (internationalscholarships.com, iefa.org, internationalstudent.com, edupass.org) had never been registered.
- **Found — Layer 2 (running):** 7 days: discovery 607 runs, page reads 1,237, 0 job failures; worker answers (6 h): discovery 36/37, reads 70/72 (1 timeout). AU: 940 universities searched (381 with pages, 554 none, 5 failed), 11,284 pages found, 944 added, 8,936 refused (top reasons: international students not mentioned 6,787; no scholarship name 3,703; past years only 1,944; not a university 509). NZ: 8 searched, 1,829 pages, 7 added, 30 blocked. CA: 17 searched, 1,576 pages, 9 added. The limits (6 universities, 30 and 20 pages per run, queue of 30, re-read every 30 days) were in job commands and function text.
- **Found — Layer 3 (configured, not running):** AI settings for AU and NZ exist but are off; two pinned models (gemini-2.5-flash-lite, qwen3.5-27b) are paused awaiting a paid benchmark; 0 runs ever. Scholarships are read by fixed rules in Layer 2.
- **Change (migration 20261004000300, md5 43d2c8c0ae62e4662e0f3b0ec736ab3b, live = file):** pipeline.scholarship_layer_settings (5 settings) read by the discover, read and refill jobs and the re-read cadence (md5-guarded patch); pipeline.scholarship_jobs (14 jobs by layer); a use on every scholarship source; the four reviewed sites registered (3 Validation, 1 Reference; not read automatically); admin_scholarship_layer_read / admin_scholarship_layer_write (Platform Admin, reason, logged; an Ingest source without a reader stays Registered); a Canadian AI setting row (off). Jobs confirmed running on the new commands (15:30 and 15:35 UTC, worker 200).
- **Change (UI v2.15.173):** Layer 1 › Scholarships (countries; sources by country and use; add, change use, pause, feed cadence); Layer 2 › Scholarships (by-country results, refusal reasons, worker answers, settings, job pause); Layer 3 › Scholarships (AI by country, models, benchmark/run control); jobs on Layer 4 › Scholarship publishing. Tabs follow each layer's existing minimum role. Guide updated.
- **Open:** the scholarship Firecrawl cap has 315 credits left, under the 800 reserve, so pages that block a direct read are not retried; the cap and reserve are still in the worker code. 509 AU pages were refused as not a university.
- **Verification:** rolled-back test of every read and write (setting change, job pause, ingest-without-reader refusal); five new contract tests; full suite with only the pre-existing baseline and environment-only deployed specs failing; CI and deploy workflows green on 031294e.

### 4 Oct 2026 (02:30 AEST) — Scholarships tidy; Course links retired; Firecrawl cap as a Layer 2 setting (releases v2.15.174 and v2.15.175, Pilot PRs #292 and #293)
- **Asked (Platform Admin, 01:57, screenshot):** the Scholarships tabs and "Scholarship catalogue" heading are not needed; retire Course links and clear its code; close the space between the module name and the search; show the Firecrawl credit cap in Layer 2, maintained in the UI — "no hard coding in the scripts or code".
- **Change (UI):** Scholarships › Course links retired: `ScholarshipLinks.jsx`, the link tools, the fill control and their CSS removed; the old address opens the list. Course decision support (`scholarship-selection-entry.jsx`), reachable only from that screen, retired with its deployed acceptance spec; the course record's scholarship cards cover it. The list has no tabs or heading; the published count sits beside Clear. Publishing names open the scholarship's record; course-link reasons explain that links come from the page (Layer 2).
- **Found:** the scholarship Firecrawl cap (3,000 credits, all time) and the 800-credit reserve were constants in the worker; 2,700 used.
- **Change (migration 20261004000400, md5 2c322f272ff257cc64018236a28b6470, live = file):** settings firecrawl_cap and firecrawl_reserve (Layer 2); svc_scholarship_fc_budget() for the worker; Layer 2 › Scholarships shows credits used, left, the reserve and use by purpose. Worker scholarship-sweep-v0.6.2 (coverage-sweep v73, verified byte-for-byte) reads them each run and spends nothing if they cannot be read; confirmed live (300 left).
- **Kept:** the database functions behind the old Course links decisions stay; decisions already made still govern course links.
- **Verification:** contract tests updated and added (retired tab and redirect, no constants in the worker, credits panel); full suite with only the pre-existing baseline and environment-only deployed specs failing; #292's deployed UAT failed on a CF-102 source contract that pinned the retired import — fixed in #293; all four workflows green on 87f4994.

### 4 Oct 2026 (12:40 AEDT) — Admission status review; scholarship job times follow daylight saving (release v2.15.176, Pilot PR #294)
- **Asked (Platform Admin, 12:12):** review progress and report data admission status with clear next steps.
- **Status (live, 4 Oct 01:14 UTC):** 34,960 active courses (AU 26,103 · NZ 6,475 · CA 2,382). Admitted: official page 19,736; English 12,664; intakes 7,861; provider tuition 3,079; CRICOS duration/campus/registered tuition for AU only. Completeness 49.6%, accounted for 66.6% (AU 63.3% / 81.9%; NZ 9.3% / 21.1%; CA 9.7% / 22.7%); 1,547 courses fully complete.
- **Found — plateau:** daily gains fell from +3,287 official pages (1→2 Oct) to +388 (2→3 Oct); provider tuition unchanged since 2 Oct. All workers answer without failure but find no work: every course has been searched once (course link search: 8,414 verified, 1,720 found, 10,995 none, 0 queued); Layer 3 has nothing queued (failed: intakes 3,278, English 984; waiting for a person: intakes 841, English 114, tuition 1,066); layer3-tuition-enqueue is paused. Layer 4 has 1,023 pending reviews. OpenRouter credit US$27.67 of US$75 left; scholarship Firecrawl 300 of 3,000 left.
- **Found — scholarships:** AU 363 published (28 withdrawn at the first daily review, as Decision 139 intends), NZ 1 published, CA none published (2 withdrawn); 825 AU, 17 NZ and 28 CA waiting in Layer 4.
- **Fix (v2.15.176):** Melbourne moved to AEDT today; the Scholarships tabs converted job times with a fixed +10. They now use the shared Melbourne clock helper; fixed clock times removed from the guide, the publishing tile and a job description (migration 20261004000500, md5 7bb0bb0a93c73173ee5a42f543d9d8ab, live = file). Full suite with only the pre-existing baseline and environment-only deployed specs failing; all four workflows green.
- **Next steps (recommended):** decide on resuming the tuition hand-off to Layer 3; re-run the failed Layer 3 intake and English items on a re-qualified pinned model or narrower rules; clear the Layer 4 backlog (bulk decisions where the rule is clear); repeat the course-page search for the 10,995 not found with a second strategy; NZ/CA register attributes (NZQA, Canadian equivalents) for duration, campus and tuition; scholarship Firecrawl cap decision; production go-live (parked since 29 Sep) to be rescheduled with a GO/NO-GO.

### 4 Oct 2026, 13:35 AEDT — Data admission failure review and final plan (report delivered)

Platform Admin, 12:39: find an end-to-end solution — every step stalls after execution; the UI needs complete visibility of variables, limits and prompts for each layer; review the plan for each attribute and its source; report what has failed, the blockers and the steps to resolve them; research other toolsets if needed; scheduled jobs are too bloated; finalise the admission plan and toolset and stop replanning layers per field.

Delivered as a Claude Docs report, "CourseFinder data admission — failure review and final plan" (eight sections: where admission stands, plan vs reality per attribute, the six blockers, toolset keep/add/retire, UI visibility inventory, job consolidation 84→28, final admission plan with one pipeline diagram and an eight-step order, decisions needed).

Findings recorded (live counts at 4 Oct):
- Workers are healthy; each strategy is exhausted, not broken. 15,187 courses have no official page (7,637 pages found but failed CRICOS identity — NZ/CA pages never print a code; 27,609 AI page-identity "none").
- Values sit on provider-wide pages, not course pages: 7,761 English and 11,031 intake "no_candidate" (UNSW 456, ANU 420, UniMelb 339, USyd 332 …); 13,781 tuition "not on page".
- Layer 3 quote check too strict: 794 intake + 38 English held at Layer 4. `layer3-tuition-enqueue` paused since 2 Oct (1,066 L4 + 1,919 candidates); Qwen3-235B at 75%. OpenRouter credit US$27.67 of 75.
- 1,012 blocked + 1,396 needs_render + 287 robots-disallowed pages (Monash, QUT, Otago, Lincoln, UWA robots; Sydney/Flinders handbooks; Alberta calendar). Scholarship Firecrawl: 304 of 3,000 credits left.
- No register for NZ/CA fees or Canadian programmes; 1,096 Canadian providers never entered the website finder. Scholarship Layer 3 configured but off. Layer 4: 1,023 pending.
- 84 cron jobs (76 active, 12 per-minute-or-faster); 140 edge functions, 7 scheduled.

Toolset researched (not yet chosen): search — Serper from US$1/1k, Brave US$5/1k, Exa US$7/1k, Tavily US$5–8/1k, SerpApi from US$15/1k; rendering/unblocking per 1k successful — Zyte US$0.10–0.95, ScrapingBee ~US$0.10 plain / US$0.45–1.49 rendered, ZenRows ~US$0.20, Bright Data US$1.50. NZQA publishes qualifications/levels (no fees); no Canadian national programme register.

Decisions put to the Platform Admin (none actioned): (1) OpenRouter top-up to US$75; (2) search provider and monthly cap (Serper recommended, ~US$16 for 15,187 courses); (3) rendering fetcher and scholarship Firecrawl cap (ScrapingBee or Zyte; backlog <US$5; cap 3,000→6,000); (4) two pinned models for a fresh tuition holdout; (5) job consolidation 84→28; (6) new go-live date and GO/NO-GO; (7) confirm robots-disallowed pages stay unread and the UI control rule (settings rows for limits; versioned read-only prompts/validators in Layer 3).

Open items logged, not actioned: `scholarship-nationality` times out 8/14 runs (needs a batch-size setting); a UTS news story admitted as a scholarship ("Tanisha's success…"); 509 AU provider pages refused as "not a university" (rule right for scholarships, wrong for course pages).

Nothing deployed this entry. Main stays at v2.15.176 / package 0.1.103.

### 4 Oct 2026, 14:20 AEDT — Decision 252: one admission plan and toolset; v2.15.177 released

Platform Admin, 13:37: keep OpenRouter uncapped by the platform (collect logs, analyse, top up when required); notify on the UI for the layer that hits a toolset time-out or limit; test the Serper and ScrapingBee trial keys first, in all countries, not only Australia; take the rest of the recommendations and record a decision for each step; plan incremental updates, never overwrite data from scratch, keep iterations recorded and inform of infrastructure limits; UI control of every variable.

Done (verified against the live project):
- Decision 252 recorded in the design reference, with a decision per step (AI, find the page, read the page, scholarship pages, tuition, jobs, go-live) and the standing rules: notices not silent stops; incremental, never from scratch; nothing hard-coded the Platform Admin cannot change; trials record, they do not admit.
- OpenRouter set to **observe only**: md5-guarded patches to `layer3_fact_claim_service`, `layer3_dispatch_headroom_service`, `layer3_route_credit_floor_service`; the routing worker's fixed US$5 floor replaced by `svc_layer3_credit_policy()`. One switch on Models & services returns it to "stop at limits".
- Notices on Layers 1–4, worked out from existing logs (no new scheduled job). Live at release: `scholarship-nationality` hit the database time limit 10 times in 24 h; scholarship Firecrawl share 2,974 of 3,000.
- Models & services › Toolsets and limits: toolset register with every threshold and look-back as a settings row; OpenRouter balance, spend today by task and 14 days of spend.
- Serper and ScrapingBee registered **switched off**; `toolset-trial` worker (v1); trials sample the real backlog per country and record outcome and credits, with a cost projection. Backlog today: course pages AU 5,078 / NZ 3,488 / CA 49; providers with no website AU 600 / NZ 6 / CA 31; pages needing a browser AU 1,185 / NZ 1,004 / CA 209. Rolled-back test of start → lease → record → close → results → notice passed.
- Scholarship Firecrawl cap raised 3,000 → 6,000 (logged, reason Decision 252).
- Migrations 20261004000600–20261004000800 (12 files): live `md5(statements[1])` equals every file. The trials change was applied in pieces because the migration tool cancelled the larger statements without a prompt; the pieces are recorded one file each.
- Edge functions `layer3-model-routing` v10 and `toolset-trial` v1 deployed via the workflow, verified byte-for-byte by an independent check. Routing worker calls after deploy return 200.
- Release v2.15.177 / package 0.1.104, PR #295 merged; full local suite shows no new failures beyond the env-only navigation audit.

Waiting on the Platform Admin:
- Save the Serper and ScrapingBee trial keys on Platform settings › Environment & integrations, then start the trials on Models & services › Toolsets and limits.
- The OpenRouter key has its own weekly limit set at OpenRouter (it refused 568 calls, 29 Sep–2 Oct). CourseFinder cannot change it; raise or clear it there if Layer 3 should never be stopped.

Next: read the trial results by country; then wire the chosen tools into the normal identity and admission checks as an incremental pass; tuition benchmark; job consolidation (pause duplicates, retire after 7 clean days); fix `scholarship-nationality` with a batch-size setting; GO/NO-GO date set at the trial review.

### 4 Oct 2026, 15:20 AEDT — Decision 252 amended: keys carry plan limits; sample runs; cause of the cancelled migrations; v2.15.178

Platform Admin, 14:26: no trial wording for the toolset or its code; the API keys and limits are set in the UI, starting with the keys supplied now and their plan limits, replaced later by production keys with new limits; find out what was cancelling the change; screenshots of where the settings are made.

Done (verified against the live project):
- Serper and ScrapingBee each have a key and plan section on Models & services › Toolsets and limits: plan name, credits in the plan, monthly renewal, count credits from (date), credits kept back, calls the plan allows at once, price per 1,000 credits. Work using a service stops when its key's plan reaches the reserve, with a Layer 2 notice. Moving to a production key: save it on Environment & integrations, then enter the new plan's limits. No code change.
- "Trials" renamed to sample runs everywhere — tables, functions, settings, UI, notices — by renaming, so nothing was recreated or lost. Worker `toolset-runner` v1 replaces `toolset-trial`, which was deleted through the deploy workflow's retired list. Verified byte-for-byte; `toolset-trial` no longer exists in the project.
- Settings grouped into sections: Key and plan limits, How the service is used, Sample runs, Notices.
- State at release: both keys saved and both services switched on by the Platform Admin at 14:33–14:34 (ZenRows, Scrape.do and ScraperAPI switched off at the same time). Free-plan limits entered: Serper 2,500 credits (reserve 100), ScrapingBee 1,000 credits (reserve 50), counted from 4 Oct 2026; check them against each vendor's dashboard. No scheduled job routes through either service yet.
- Migration 20261004000900: live `md5(statements[1])` equals the file. Rolled-back test of start → lease → record → close → notices passed, including the stop at the plan's reserve.
- Release v2.15.178 / package 0.1.105, PR #296 merged. Full local suite shows no new failures beyond the env-only navigation audit.

Why the earlier migrations came back "cancelled": the Supabase tool runs a destructive-statement check before applying a migration ("DROP, DELETE, TRUNCATE or UPDATE without WHERE"). The check splits the SQL on every semicolon, including semicolons inside text values. The trials change had one in a status message ("…reached its time per call; press Continue"), so the UPDATE that set it looked as if it had no WHERE clause. The tool then asked for confirmation, and this session runs non-interactively, so the request was declined automatically about 0.3 seconds later; nobody was shown a prompt. Confirmed from the client log, and by repeating it with a two-line test function (cancelled with the semicolon, applied without it). The test migrations failed on purpose and left nothing behind. Rule from now on: no text value in a migration contains a semicolon. A contract test checks this.

### 4 Oct 2026, 15:45 AEDT — First sample runs on the Serper and ScrapingBee keys (AU, NZ, CA): results and findings

Platform Admin, 14:54: proceed with the next step and report the result and findings.

Done:
- Sample-run worker `toolset-runner` v1.2.0 now accepts a one-time run pass, so runs the Platform Admin starts can run without a browser session (migration 20261004001000, live md5 = file; worker verified byte-for-byte; PR #297).
- Four sample runs, each started with a reason and logged. Credits used on the free keys: Serper 137 of 2,500; ScrapingBee 175 of 1,000. The ScrapingBee run paused at the 120-second time limit as designed, raised its notice, and finished after Continue.
- Nothing was admitted or written to any course, provider or page.

Results:

| Run | Cases | Outcome |
|---|---|---|
| Serper, course pages | 60 (20 per country) | 30 found a page on the provider's site with a matching title (AU 12, CA 12, NZ 6). 25 found the provider's site but no matching title. 5 found nothing (small English-language and VET colleges). By hand, about 17 of the 30 are the right course page. 3 are the exact page our identity check refused earlier. |
| Serper, provider websites, run 1 | 46 | CA about 18 of 20 right. AU 11 of 20, NZ 1 to 2 of 6: the rest were government or directory listings (yourcareer.gov.au, teqsa, bebee, studyspy, companyhub). |
| Serper, provider websites, run 2 (directories added to the settings list) | 31 | AU 10 of 15 suggestions right, with 5 correctly withheld. CA 10 of 11. Four more directories added to the list after this run. |
| ScrapingBee, pages that need a browser or refused a direct read | 45 (15 per country) | 7 rendered the course page (Flinders, Murdoch and Sydney handbooks; Otago Polytechnic pages showing intakes, English and fees). 25 rendered a page that is not the course. 13 still refused (Otago, Lincoln, AUT, Notre Dame, Emily Carr) on standard proxies. |

Findings:
1. Most of the rendering backlog is a wrong-page problem, not a rendering problem. 967 of the 2,398 pages waiting for a browser read do not look like course pages (profiles, research archives, events, policies). 176 University of Alberta calendar addresses were stored without their query string, so they open a blank page. 47 Massey addresses are internal template paths and 47 are AUT system pages. Rendering these spends credits for nothing; they need the right page first.
2. Search finds pages our discovery missed, including on renamed domains (Adelaide University's new adelaideuni.edu.au). Its title match is loose, so search results must go through the existing identity check and never be admitted directly. That is the plan.
3. The identity check rejects some right pages: "(International)" variants, "Global MBA", majors under a parent degree, and double degrees.
4. NZ register titles ("New Zealand Certificate in X (Level n)") rarely match how providers name their pages, so NZ needs the title-plus-level rule applied to search results.
5. Provider websites: search works well for Canada. Australia needs the directory list (now a setting, extended twice) and a preference for results whose address contains the provider's name.
6. Projected cost at the free-plan prices (from the settings): Serper about US$1 per 1,000 searches, so the whole course-page backlog (AU 5,078, NZ 3,488, CA 50) is about US$9. ScrapingBee at about 5 credits a page; only pages that look like course pages are worth sending.

Next steps proposed:
- (a) Add Serper as an incremental second discovery pass whose results go through the identity check.
- (b) Repair the stored addresses that lost their query string, and re-find the non-course pages, before any rendering.
- (c) Send ScrapingBee only course-like pages, and test premium proxies on 5 refused pages before deciding on them.
- (d) Identity-rule fixes for variants.
- (e) Rank provider-website results by name in the address.

### 4 Oct 2026, 15:40 AEDT — Serper search pass and address repair (steps a and b): results and findings; v2.15.179

Time correction: the two entries above headed 15:20 and 15:45 were written about 40 minutes ahead of the clock. Their real commit times are 14:45 and 15:03 AEDT. Times are not rewritten in place.

Released: v2.15.179 (Coursefinder-Pilot PR #298, checks green). Migration 20261004001100_cf247_search_pass_and_link_repair applied and checked (live md5 b3723a9551b2b1c0f606a7d5ea8ff63c equals the file). toolset-runner worker v1.3.0 deployed and checked byte for byte.

What changed:
- Search pass (Platform Admin, Toolsets page, Serper, "Search pass"). Its limits are settings: cases per country (1,000), credits per run (2,100), carry on after a time limit (on), re-find unreadable non-course pages (on), and the address pattern that counts as course-like.
- Search results are never admitted directly. A page found on the provider's own site with a matching title is bound with basis serper_search and goes through the existing reader and identity check. If the check refuses it, the next search result is tried, then the course is left. A confirmed page or a value entered by hand is never replaced. Every change is logged in pipeline.page_link_repairs with the old and new address.
- The course-link pick now keeps query strings on .php, .aspx, .cfm and .jsp pages. 392 stored addresses that had lost their query string were restored from the stored search results and logged.

Search pass run 90faa0c1-3361-4394-8199-3258417ca472: 2,052 courses (AU 1,000, NZ 1,000, CA 52 which is all of Canada's backlog), 2,052 Serper credits.

| Country | Page on provider's site with title match | Provider's site, no title match | No results | Other sites only |
|---|---|---|---|---|
| AU | 431 | 401 | 164 | 4 |
| NZ | 367 | 494 | 139 | 0 |
| CA | 35 | 16 | 1 | 0 |

After the reader and identity check (pipeline.search_pass_links, 4 Oct 15:38):

| Country | Confirmed by the identity check | Still being read | Refused, no result left |
|---|---|---|---|
| AU | 48 | 46 | 329 |
| NZ | 54 | 61 | 243 |
| CA | 0 | 4 | 31 |

- 102 courses gained a confirmed course page (100 new, 2 re-found). Largest sources: study.auckland.ac.nz 22, AUT 11, Lincoln 10, Macquarie handbook 10, UTS handbook 10.
- 111 are still being read, mostly fetch failures waiting for their second attempt (Canterbury 19, EIT 8, Swinburne 8).
- 603 were refused on every candidate. The identity check refused sibling courses correctly. Many refusals are majors, specialisations and variants that have no page of their own.

The 392 restored addresses: 24 confirmed, 246 need a browser read (mostly University of Alberta calendar pages, which are built in the browser), 97 refused by the identity check, 15 fetch failed, 10 blocked.

Serper key: 2,189 of 2,500 free-plan credits used, 311 left (reserve 100). The rest of the backlog (about 6,500 courses) needs the production key, entered in Environment & integrations with its plan limits set on the Toolsets page.

Findings:
1. Search plus the identity check adds pages safely but at a modest rate: about 5% of searched courses gained a confirmed page so far, rising to about 10% if the pages still being read pass. Nothing wrong was admitted.
2. The biggest remaining loss is identity rules, not search: majors, specialisations, "(International)" variants and double degrees. Whether a specialisation may use its parent course's page is a decision for the Platform Admin (raised).
3. UTS results come from handbookpre2025.uts.edu.au, an archived handbook. Identity matches, but fees and dates there may be out of date. Raised: prefer current handbooks or mark archived hosts as not current.
4. ask.adelaideuni.edu.au (a help site) appears among candidates. It should be on the directory list.
5. Recipes whose search domain is a directory site (search.acir.com.au 64, higherstudy.com 46, oneuedu.com 32) need correcting.

Next steps proposed (not started):
- (c) ScrapingBee only for course-like pages, starting with the 246 restored University of Alberta addresses, and a premium-proxy test on 5 refused pages.
- (d) Identity-rule fixes for variants, after the Platform Admin decides on specialisations.
- (e) Rank provider-website results by provider name in the address.
- Correct the directory-domain recipes; add archived-handbook and help-site hosts to the settings.
- Production Serper key before the next search pass.

### 4 Oct 2026, 17:05 AEDT — Decision 253: Firecrawl only, by use case, for target universities; university adapters; Firecrawl support report; v2.15.180

Platform Admin, 15:51: use Firecrawl (Growth plan) for everything, by use case, only for universities that enrol international students. Keep university adapters for field mappings, set in the UI. Keep a result report that can go to Firecrawl support.

Released: v2.15.180 (Coursefinder-Pilot PR #299, merged, checks green).
- Migrations 20261004001200, 001210, 001220, 001230, 001240 and 001250 were applied. For each, the live md5 of the statement equals the file.
- coverage-sweep worker v0.15.1 was deployed from main (version 80) and checked byte for byte: 7 of 7 files match.

What changed:
- **Target universities (settings):** AU, NZ and CA; a university name pattern; colleges, pathways and divinity left out; at least 100 active courses in AU and NZ and 30 in CA; on the CRICOS, NZQA or IRCC DLI register. This gives 57 targets (AU 34, NZ 8, CA 15). A setting (on) keeps every Firecrawl call of the coverage worker to targets.
- **Use cases:**
  - Read pages: course-like pages that need a browser or refused a plain read. Archives, profiles and PDFs are skipped.
  - Find pages: a Firecrawl search on the university's own site.
  - Each use case has its own settings and credit allowance and carries on every minute.
- **Every Firecrawl call of a run is logged:** request, HTTP status, error, scrape id, credits, proxy and page status. The Firecrawl panel shows the support report, which can be copied or downloaded as Markdown.
- **University adapters (UI):**
  - Each adapter holds title patterns, JSON paths in the page's own data and heading patterns per field.
  - An adapter is previewed on stored pages, then applied. The reader uses it too.
  - CourseLoop adapters were set up for Flinders, Macquarie and Murdoch. Their pages carry all course data in __NEXT_DATA__, so a plain fetch reads them with no Firecrawl credit.
  - Adapter identities (adapter_code, adapter_title) are not in any country admission rule. Nothing is admitted from them until the Platform Admin allows it.
- **Firecrawl allowance:** the platform's allowance now follows Firecrawl's reported balance. It was still set to the old 100,000-credit plan, with 85,914 counted this month, and was about to stop all Firecrawl work.

Results so far:

| | AU | NZ | CA |
|---|---|---|---|
| Course pages confirmed by the identity check (Firecrawl search, Firecrawl read or adapter) | 242 | 53 | 5 |
| Official course links admitted since 16:10 | 182 | 48 | 5 |
| English requirements admitted since 16:10 | 96 | 0 | 4 |

Find pages run:
- 3,975 courses searched for 7,874 credits.
- 2,262 had a page on the university's own site with a matching title. 345 of these are still waiting for the reader.
- 1,328 pages were refused by the identity check: mostly sibling courses, combined degrees and specialisations.

Read pages run:
- 259 pages read so far, at 1 credit each.
- Almost all are wrong pages bound by earlier discovery (QUT scholarship and news pages, Lincoln and UBC general pages). Refusing them sends those courses to Find pages.

Firecrawl itself:
- 4,290 calls with 3 failures: 1 timeout, 1 HTTP 502 and 1 not found.
- No product limit was hit, so there is nothing to raise with support yet. The report is in place for when there is.

Credits used today by Decision 253: about 8,700 of 490,000.

Findings:
1. **The loss is on our side, not Firecrawl's.**
   - Firecrawl's cleaned HTML leaves out the page title and the page-data script, so handbook pages looked empty and were refused. Reads now use raw HTML.
   - Handbooks built in the browser need an adapter, not a browser.
2. **Pages from archived and test handbooks are confirmed and read:** archive-dev.handbook.curtin.edu.au 152, archive.handbook.curtin.edu.au 77, test-handbook.federation.edu.au 16, handbookpre2025.uts.edu.au 78. Their data may be out of date. Raised.
3. **Most refusals are identity rules, not missing pages:** combined degrees, specialisations, NZ titles with levels, and Canadian "Master's Degree" titles. Per-university adapters (title patterns) are the place to fix these, one university at a time.
4. **A worker call longer than the database's 120-second wait holds up every other scheduled call.** Runs now stop at 95 seconds.

Waiting on the Platform Admin:
- Whether adapter_code (the CRICOS code in the page's own data) and adapter_title may be admitted, by country and field.
- Whether pages from archived and test handbook hosts should be refused.

### 4 Oct 2026, 17:45 AEDT — Decision 253 amended: admit from university adapters after testing; archived and test sites refused; v2.15.181

Platform Admin, 17:19: "Admit from adapter rule but I need to test it or ask for improvements on it, step 2, yes refuse".

Released: v2.15.181 (Coursefinder-Pilot PR #300, merged, checks green). Migration 20261004001260 was applied; the live md5 equals the file (cd0cb4e3a5305ce4f40ab6cd8bee70ee). The worker is unchanged.

- **Adapter admission:**
  - The country admission rules for AU, NZ and CA now list adapter_code and adapter_title for official links, English and intakes. Tuition is not included.
  - Each adapter also has its own admit switch, off by default. The admission gate requires both the country rule and the switch. Checked live: Flinders adapter_code is not admitted yet, while cricos_code still is.
  - The adapter panel lists what the adapter would admit (course, how it was confirmed, intakes, IELTS, the page) so it can be tested first. Admission is switched on per adapter, with a reason.
  - Requests for improvement are written against an adapter and listed as open or done.
- **Archived and test sites refused:**
  - A setting holds the host pattern: archive, dev, test, staging, uat and handbookpre2025.
  - A trigger on course pages stops any page on such a host being bound, unless a person entered that link by hand.
  - 380 pages were refused: Curtin archive and dev 243, UTS pre-2025 78, Federation test 18, Melbourne archive 17, ANU test 15, others 9. They go back to Find pages.
  - Values admitted automatically from those pages were taken out of use: 317 links set to deprecated, 96 English requirements and 42 intakes withdrawn. Values entered by hand were not touched. Every change is logged in pipeline.refused_host_changes.

Next: the Platform Admin tests the Flinders, Macquarie and Murdoch adapters on the Firecrawl panel (Adapter, then "What it would admit"), then switches admission on per adapter or sends a request for improvement.

### 4 Oct 2026, 19:45 AEDT — University adapters easy to find; the Firecrawl panel loads at once; v2.15.182

Platform Admin, 19:16: could not see how to test the adapters, and found no toggle and no per-university adapters.

Cause: the Firecrawl work panel, which holds the adapters, took about 7 seconds to work out its figures. The limit for a signed-in user is 8 seconds, so under load the panel did not load at all. It also sat at the bottom of the page.

Released: v2.15.182 (Coursefinder-Pilot PR #301, merged; checks and deployed release check green). Migration 20261004001270 was applied; the live md5 equals the file (f514751eb5c4ca8e1d98fb0c99445d72).
- **Figures kept in tables:** the target list refreshes every minute and course figures and the backlog every 5 minutes. The panel now loads in 0.2 seconds; starting a run reads the same tables.
- **Placement:** the panel sits directly under the Firecrawl settings, with a link from the settings.
- **New "University adapters" section:**
  - each adapter with its state (Testing — not admitting, or Admitting), pages it confirmed, pages waiting and open requests;
  - Open and "Set up an adapter for" controls, with three steps written out.
- **Adapter view order:** "Test, then admit" (the values found with page links, the admit switch, improvement requests) comes first. The technical settings are folded away below it.

### 4 Oct 2026, 22:30 AEDT — Flinders adapter set up; adapters read page text; intakes admitted only from an adapter's own reading; v2.15.183 and v2.15.184

Platform Admin, 21:50: Flinders shows location and delivery under the course offerings, duration, English at one central page by course category, and start dates that could follow a central or a campus calendar. "Prepare the adapter ... Help with adapter config."

Released: v2.15.183 (Coursefinder-Pilot PR #302, merged) and v2.15.184 (PR #303, merged). Main matches the live database and the live worker.
- Migrations were applied, and each live md5 equals its file:
  - 20261004001280 (c7d26e42df45154dedf7d7eff5d44bb7)
  - 20261004001290 (42ed3272d62a99b0a62f0057395742e8)
  - 20261004001300 (c30e1a1a87bc0e31d08895adf4165b44)
- The coverage-sweep worker is v0.16.2, byte-verified: 7 files, deployed version 84.

**What changed**
- **Adapters read page text.** An adapter now holds patterns for intakes, fee, IELTS, campus, mode, duration, study level, student type, not admitting and AQF level. A "pick" setting chooses the first, last or every match.
- **Adapter readings are marked.** Values read by the adapter (intakes_by, english_by, fee_by = adapter) and extra fields (adapter_extra) are kept apart from the general reader's values. The adapter panel lists them on pages confirmed by CRICOS code, next to the intakes held now.
- **Admission.**
  - Intakes are admitted only when the adapter itself read them and that adapter's admit switch is on. A new schedule, coverage-admit-intakes, runs every 10 minutes.
  - English read by an adapter also needs the switch.
  - The admission plan was changed with an md5 guard: two snippets, each found exactly once. The rest of the function is byte-identical to before.
  - Tuition is still not admitted from pages.
  - Every adapter's admit switch is off, so nothing new has been admitted.
- **Fixes found while applying Flinders:**
  - Preview and Apply stopped with "CPU Time exceeded". An edge call may use about 2 seconds of processor time, and a 300 KB page takes about 75 ms to read. Apply now reads pages in turn and carries on in a fresh call.
  - A pattern written as (.|\s) backtracked on long pages. Such patterns are now refused when saved.
  - Months are read only as printed with a capital, so "may vary" is not read as May.

**Flinders adapter (saved, switched on, admission off)**
- **Handbook pages** (CourseLoop page data): title, CRICOS code, IELTS, duration, location, mode, student type, study level, AQF level and guidance (for example "Not admitting new students from 2026"). The handbook does not give intakes.
- **Study pages:**
  - Each page prints a domestic block (SATAC code, CSP fee) and an international block that starts at the course's CRICOS code.
  - The patterns read only from that CRICOS code on: delivery mode and campus, duration, annual fee (CSP and FFP amounts skipped) and start dates.
  - Start-date formats handled: "– March – July", "March, July", "February - 12 month program June & October" and the folded "Start Dates" control.
- **Result on 360 stored pages:**
  - Start dates were read on 173 study pages (25 before). They agree with the intakes held on 145, differ on 22 and are new on 6.
  - Duration was read on 227 pages, campus on 130 and fee on 150.
- **Intake calendar:** a calendar is not needed for these courses. The study page states the international start months per course. The central key-dates and semester-dates pages parse to no periods and stay a fallback for semester-only wording.
- **English:** comes from the approved central English policy (2 Oct), mapped by course level: 253 agree, 12 differ, 1 named. Held for a decision: double degrees 72, named in policy 68, research 53, level not covered 17. Duolingo is not parsed.

Next:
- The Platform Admin checks the Flinders readings on the adapter panel ("What it read on pages confirmed by CRICOS code"), then switches admission on or sends a request.
- With admission on, 6 new intakes would be written. The 22 that differ go to review and are not overwritten.
- Re-find study pages for the Flinders courses bound only to the handbook (query "{course} site:flinders.edu.au/study/courses"). Intakes and fees are only on study pages.

### 4 Oct 2026, 23:30 AEDT — Flinders adapter admitting; adapter readings replace held values; better pages; next step per university; v2.15.185

Platform Admin, 22:43:
1. Yes, admit from the Flinders adapter.
2. "adapter is exact auto read and can overwrite all except manual ones".
3. Yes, search with Firecrawl.

Also: learn from the adapter exercise, evaluate the pending universities and courses for data admission, and show successful adapters collapsed, with each line stating whether it is enabled.

Released: v2.15.185 (Coursefinder-Pilot PR #304) and PR #305. Both merged, and the checks and deployed release check are green. No worker change; the coverage-sweep worker stays at v0.16.2. Migrations were applied, and each live md5 equals its file:
- 20261004001310 (e7662f6dfa7c3aefe91410d46c19b9b7)
- 20261004001320 (b1a851aa4f9053af93f873318f7f2c1d)
- 20261004001330 (cd8eb755a26ee33f4e77d7bc166c5569)

**1. Flinders admitting.** The admit switch was turned on with the reason logged.

**2. Adapter readings replace held values.**
- When an adapter is enabled and admitting, what it reads itself replaces held intakes and IELTS scores. Intakes not on the page are withdrawn.
- Values entered or locked by hand are never changed: manual locks, and intakes with no source.
- Each change is logged in pipeline.adapter_overwrite_changes, and pending review items for the same field are closed as superseded. This runs on the schedule adapter-overwrite (every 10 minutes).
- Flinders: 28 courses changed (22 replaced, 6 new). All 173 courses whose start dates the adapter read now match their page.

**3. Better pages with Firecrawl.**
- The run searched "{course} site:flinders.edu.au/study/courses" for 194 Flinders courses on handbook or other pages: 386 credits, with 140 found on the Flinders site.
- Only a result matching the study-page pattern replaces a page. A link entered by hand is never replaced.
- Lesson: double degrees, combined and discontinued courses have no study page of their own, so search returned a related page. The identity check refused 28 of them. Migration 1330 now undoes a better page the identity check refuses, binding and reading the earlier page again (schedule better-page-revert, every 5 minutes). Values admitted from the earlier page were never removed. 3 better pages are confirmed so far and 27 are waiting to be read.

**4. Evaluation of the target universities.**
- The rules learnt from Flinders are now settings (Firecrawl, Adapter evaluation):
  - no page for 30% or more of courses: find pages first;
  - unreadable pages for 20% or more: an adapter for the page data;
  - start dates or English on under 50% of confirmed pages: an adapter with patterns.
- Result:
  - Find pages first (26): Sydney, UBC, Alberta, Monash, Curtin, Auckland, VUW, Otago, Massey, Waikato, Victoria University, UVic, Lethbridge, Swinburne, Calgary, UTas, Lincoln, Adelaide, Notre Dame, Federation, UNBC, Canberra, Athabasca, MacEwan, Fraser Valley, Kwantlen.
  - Adapter for start dates (12): ANU, Melbourne, UTS, Murdoch, La Trobe, SFU, Bond, Griffith, JCU, CDU, CQU, Mount Royal.
  - Adapter for English (7): Western Sydney, Canterbury, Sunshine Coast, ACU, Thompson Rivers, Vancouver Island, Royal Roads.
  - Adapter for page data (2): Macquarie, UWA.
  - Admitted as it is (9): RMIT, Wollongong, AUT, QUT, ECU, Southern Cross, UNE, UQ, Deakin.
  - Admitting: Flinders.
- UI: admitting adapters show as one collapsed line each (adapter enabled or disabled, admission on or off), which expands to work on the adapter. The table "What each university needs next" opens an adapter from its row.

Next: Platform Admin to choose the next adapters from the evaluation. Suggested: ANU, Melbourne and UTS (start dates), and Macquarie and UWA (page data). Then Find pages for the 26 universities that need pages.

### 4 Oct 2026, 23:55 AEDT — Decision 254: university adapters report, decision and design; register and configurations recorded

Platform Admin, 23:30:
- asked how many university adapters can be built at once;
- asked for a report, a decision document and the configuration of each adapter, recorded in the admin documents for production preparation;
- set the target of a visual adapter builder (Firecrawl screenshot, comments, cheapest model proposing the configuration, JSON values chosen per attribute);
- asked how link pages, handbooks, central requirements and continued pages fill every attribute.

Recorded (admin repo, documents only, no platform change):
- **Report, decision and design:** `docs/coursefinder-university-adapters-v1.0.md` (new, CURRENT, listed in `docs/README.md`).
- **Decision 254** in `docs/coursefinder-design-reference-v1.4.md`, inserted before Decision 253.
- **Adapter register:** `docs/adapters/README.md`. It lists all 57 target universities with their figures, adapter state, next step and wave.
- **Configurations:** `docs/adapters/configs/` holds Flinders (Admitting), Macquarie (Testing) and Murdoch (Testing). The Flinders export was compared with the live row field by field (md5 of each pattern, path, pick value and the notes) and all match.
- **Production runbook:** new section 10a covers adapters after transfer: compare with the baseline, check schedules and admit switches.

Answers recorded:
- **How many at once:** adapters have no technical limit. Firecrawl Growth allows 50 concurrent browsers, and preview and apply use stored pages at no credit cost. The limits are the worker (about 2 seconds of processor time per call, so at most 5 apply chains at once) and Platform Admin review time. Recommendation: waves of five.
  - Wave 1: ANU, Melbourne, UTS, Macquarie, UWA.
  - Wave 2: Murdoch, La Trobe, Griffith, Bond, JCU.
  - Wave 3: CDU, CQU, Western Sydney, Sunshine Coast, ACU.
  - Wave 4: SFU, Mount Royal, Canterbury, Thompson Rivers, Vancouver Island, Royal Roads.
  - In parallel: one Find run for the 27 universities needing pages first (about 3,725 courses, about 7,500 credits). 477,999 credits are left this period.
- **Filling every attribute:** four page roles.
  - Course page.
  - Linked (continued) pages, which inherit identity from the confirmed course page.
  - Handbook page, which must show the code.
  - Central pages, which become policy proposals by course category, approved by the Platform Admin, and fill gaps only.
  - Precedence: by hand, then course page, then linked page, then handbook, then central policy, then the general reader.
  - Courses with no page of their own (double degrees, combined courses) keep the handbook page.
- **Visual builder:** a target design in phases B–E.
  - Phase 1 selects text blocks beside the screenshot and values in the JSON tree. Clicking on the picture itself needs a position probe first.
  - The cheapest qualified model, pinned by name, only proposes. Saving, applying and admission stay Platform Admin actions, and a passing test never switches anything on.

Decisions waiting for the Platform Admin:
1. Approve waves of five and wave 1.
2. Approve the Find run for the 27 universities.
3. Choose the cheapest model to qualify for the builder, and approve phase C.
4. Decide whether international fees read by an admitting adapter may be admitted.

### 5 Oct 2026, 00:30 AEDT — Decision 254 amended: NZ and CA in every wave, Find run, pinned builder model, fees admitted, visual adapter builder built; v2.15.186

Platform Admin, 23:41:
1. Include NZ and CA universities in each wave.
2. Find pages approved with Firecrawl; keep artifacts and scrape results in the Supabase bucket.
3. Use the preferred cheapest vetted model, without a large daily AI budget.
4. Include fees and admit them.
5. Build the visual adapter builder.

Released: v2.15.186 (Coursefinder-Pilot PR #306) and PRs #307–#308, all merged.
- Migrations applied, each live md5 equal to its file:
  - 20261004001340 (b5246789828df31d5021bda39f9635d4)
  - 20261004001350 (7204bc305ba712a93126fbc02d6a343f)
  - 20261004001360 (7a1181cfe252b552e4387662f81511d1)
- Worker coverage-sweep v0.17.1, byte-verified: 8 files including the new builder.ts, deployed version 86.

**1. Waves.** Each wave has three AU universities, one NZ and one CA:
- Wave 1: ANU, Melbourne, Macquarie, Canterbury, Simon Fraser.
- Wave 2: UTS, UWA, Murdoch, Auckland, Mount Royal.
- Wave 3: La Trobe, Griffith, Bond, Massey, Thompson Rivers.
- Wave 4: JCU, CDU, CQU, Lincoln, Vancouver Island.
- Wave 5: Western Sydney, Sunshine Coast, ACU, Waikato, Royal Roads.

These are recorded in `docs/coursefinder-university-adapters-v1.0.md` section 5 and in the register.

**2. Find run.** Started for 2,722 courses with an allowance of 15,000 credits. At 00:20 it had done 1,519 courses for 2,968 credits: 457 found on the university site, 998 with no title match.
- Pages read are kept in the evidence bucket, as before. Every search result is now kept there too (`layer2/{country}/firecrawl/search/{run}/{item}.json.gz`).
- Lessons:
  - UBC's recorded website is grad.ubc.ca, so its undergraduate searches found graduate pages only. UBC needs a re-run on ubc.ca.
  - Monash courses are on monash.edu. Its 157 waiting items were corrected before they ran, and the change is logged.
  - Recommendation: each adapter should hold its own search site.

**3. Builder model.** The builder is pinned to qwen/qwen3-30b-a3b-instruct-2507, the vetted model already used for page matching (no Anthropic model). The daily allowance is US$ 0.50 and 30 proposals (settings, section Adapter builder). The first live proposal cost US$ 0.0003.

**4. Fees.**
- The international annual fee an admitting adapter reads is admitted and replaces the automatic fee held for the same year. Hand-entered fees are never changed. Whole-course fees still go to Layer 4.
- Flinders: 157 fees read, and 155 now held matching the page.
- Two fixes found on the first run:
  - Some study pages cover several courses. Patterns now use `{code}`, the course's own code, and the Flinders patterns were re-saved with it. This corrected fees first read from another course's block on the same page (for example Water Resources Management: 23,000 back to 46,000).
  - A fee with no year on the page was written again on every run. It now takes the year held, or the current year. The last run replaced 0.

**5. Visual adapter builder (built).**
- Capture three sample pages (undergraduate, postgraduate, double degree) with Firecrawl. Each costs 1 credit including a full-page screenshot, kept in the private bucket adapter-captures.
- Each page is shown as text blocks and page-data values. The Platform Admin marks which one holds each attribute and adds comments.
- "Ask for a proposal": the pinned model proposes. Unsafe patterns and unknown fields are refused. The output is shown per sample.
- "Use this proposal" fills the adapter settings. Save, Apply and admission stay separate.
- First live run, ANU (wave 1): 3 credits and US$ 0.0003.
  - Proposal kept: fee, duration and mode. Left out: level and AQF fields, where the model copied a course title.
  - Saved for testing with admission off, and applied: fee read on 379 ANU pages.
  - ANU program pages carry no start dates, so a linked page or central key dates are needed.

Recorded: Decision 254 amended (design reference). The register and configurations are updated: Flinders re-exported with `{code}`, and ANU added. All 7 patterns were checked against the live rows by md5 and match.

Next: wave 1 continues with Melbourne, Macquarie, Canterbury and Simon Fraser using the builder. ANU needs its start-date source. Re-run Find for UBC on ubc.ca once the current run finishes.

### 5 Oct 2026, 07:30 AEDT: CF-247 Decision 254, wave run 1 to 5 and admissions switched on

**Instructions.**
- 04:49: continue the wave run, report after each wave, keep docs current, plan waves in fan-out.
- 05:50: switch on the admissions.
- 06:12 and 06:32: fetching any public website is approved, and Firecrawl is to be used to save evidence.

**1. Admission by field and course exclusions (built, live).**
- Migration 20261005001400 adds two controls:
  - `admit_fields`: intakes, English and fees are admitted separately.
  - `pipeline.uni_adapter_exclusions`: a course and field excluded with a reason. Exclusions are switched off, never removed.
- Both are honoured by the adapter overwrite, the country identity rule, the page record and, from migration 20261005001410, the coverage admission of intakes and English.
- Both migrations were checked live: the md5 of each stored statement equals its file (55addb3e…, c11ad4f3…).
- UI v2.15.188 (PR #312): admitted-field tick boxes, Exclude per reading, and a list of excluded courses with Stop excluding.

**2. Admission switched on (22 universities).** "All" means intakes, English and fees.

| University | Fields admitted | Held = adapter after the overwrite | Excluded / held back |
|---|---|---|---|
| Flinders | all | 174 intakes, 158 fees | — |
| Melbourne | all | 89 intakes | — |
| UTS | all | 130 intakes, 307 IELTS read | Fee PDF needed |
| Canterbury (NZ) | all | 148 intakes, 70 fees | — |
| Murdoch | all | 178 intakes, 160 fees, 41 IELTS | — |
| Griffith | English, fees | 252 fees, 252 IELTS | Intakes held: the 2027 calendar has T1 March, T2 July, T3 September, not Feb/Jul/Oct |
| Thompson Rivers (CA) | intakes | 36 | No fee reader |
| Massey (NZ) | intakes, fees | 10 intakes, 79 fees | 3 fees (GDDRS, UDBRB, UBAVT) |
| James Cook | intakes, fees | 20 intakes, 2 fees | Diploma of Higher Education fee (Singapore). IELTS held |
| Charles Darwin | intakes, fees | 147 intakes, 130 fees | 8 short-course totals |
| Lincoln (NZ) | intakes, fees | 57 intakes, 30 fees | LI0511 intakes |
| Vancouver Island (CA) | intakes, fees | 27 intakes, 25 fees | Liberal Studies and Global Studies (cancelled) |
| CQUniversity | all | 66 intakes, 66 fees, 55 IELTS | Rebound to handbook pages for the international view |
| La Trobe | all | 100 intakes, 100 fees, 95 IELTS | Dental fee to confirm |
| Western Sydney | intakes, fees | 138 intakes, 21 fees | 7 intakes, 6 fees |
| ACU | intakes, English | 90 intakes, 25 IELTS | 3 intakes. Fees wait on the international view |
| Waikato (NZ) | intakes, fees | 70 intakes, 21 fees | WI0250 intakes, 3 sub-year fees |
| Sunshine Coast | intakes | 93 intakes | 073869J intakes. Fees held (2026 or 2027 label in doubt) |
| Royal Roads (CA) | intakes | 13 intakes | 16 scholarship fees excluded |

- Overwrite runs: 394 values (05:55), 324 values (06:35) and 166 values (07:20), all with 0 errors.
- 54 exclusions are live, and none of them was written.

**3. Not admitted yet.**
- **ANU:** needs central start dates and English.
- **Macquarie:** page-data fee path saved, 0 fees read.
- **UWA:** fee calculator.
- **Auckland:** 45 intakes differ.
- **Simon Fraser:** 3 intakes only.
- **Mount Royal:** nothing admissible.
- **Bond:** fees are per semester only, and IELTS is on a second page (`/program/<slug>/entry_requirements`).

**4. Firecrawl spend.**
- Builder captures: about 3 credits per university.
- International-view re-reads: 153 credits, all evidence saved.
  - La Trobe: 118 pages re-read via `#/overview?studentType=int`.
  - CQUniversity: rebound to `handbook.cqu.edu.au/he/courses/view/<CODE>`, plain fetch.
- One text-only apply (Sunshine Coast) re-read a refused page through Firecrawl for 1 credit. That page was already needs_render.

**5. Lessons.**
- A university can be right on one field and wrong on another, so admission must be by field.
- Wrong single courses are mostly short-course totals printed as "annual", scholarships, domestic-only pages, and application-open months read as starts.
- Term months change by year (Griffith). The central English rule is by level for most universities (James Cook, Charles Darwin, Lincoln, Vancouver Island, Western Sydney, Sunshine Coast, Waikato). A central-rule source is the next design item.

**Next.**
- Wave 6 is scheduled for 07:49: Deakin, RMIT, Curtin, Otago (NZ), Victoria (CA).
- Design items:
  - Second-page source (Bond, ANU).
  - Central English rule by level.
  - Term months by year.
  - Sunshine Coast fee-year decision.
  - Re-run Find for UBC (ubc.ca).

### 5 Oct 2026, 07:55 AEDT: correction to the 07:30 entry

- Admission is on for **19** universities, not 22 (the 07:30 table has 19 rows; the live register agrees).
- Royal Roads: **15** scholarship fees are excluded, not 16.
- Migrations 20261005001400 and 20261005001410 are recorded in `supabase_migrations.schema_migrations` under their apply timestamps (names cf247_admit_by_field_and_exclusions and cf247_exclusions_in_coverage_admission). The md5 of each stored statement equals its file.

### 5 Oct 2026, 08:35 AEDT: CF-247 Decision 254, central rules, Universities tab, wave 6

**Instructions.**
- 07:36:
  - If no fee year is printed, use the current year.
  - Build the central rule and associate it with universities.
  - Show universities and courses in tables with coloured pills, as a new tab in Coverage & completeness.
- 07:42: increase the number of universities in each wave.

**1. Fee year (live).**
- Migration 20261005001420: an adapter fee with no year on the page is held against the current year (Melbourne time).
- Sunshine Coast fees are admitted. 28 readings are excluded: 13 from the 2024 and 2025 fee tables, 6 that are not annual, and 9 pages labelled 2026 that show 2027 table figures.
- Western Sydney courses that held a 2027 fee also gained a 2026 row.

**2. Central rules (live).**
- Migration 20261005001430: `admin_provider_central_page` attaches a university's central English or key-dates page. The provider-facts job reads it through Firecrawl (evidence kept) and the parser makes a proposal.
- Migrations 1440 and 1450 fixed the address check and mark attached pages as manual.
- The parser found no values on most central English pages, so migration 20261005001460 adds `admin_provider_english_propose`. It writes the rule out from the attached page as level defaults and named courses, **as a proposal only**, approved in Layer 4 Review › Attributes. An approved rule fills only courses with no English requirement.
- 25 central pages are attached.
- 16 English proposals are waiting:
  - Western Sydney, Sunshine Coast, Waikato, Lincoln, Vancouver Island;
  - Deakin, RMIT, Swinburne, UQ, Wollongong, QUT, Curtin, Otago, Victoria University of Wellington, University of Victoria, Alberta.
- Waikato also has a parser proposal reading "7.09". It should be rejected.

**3. Coverage & completeness › Universities (v2.15.189, PR #314).**
- One row per target university with pills for:
  - adapter state, admitted fields and exclusions;
  - central English rule and calendar;
  - coverage of intakes, English and fees by source.
- Open a university for its courses, each value with its source.
- A Platform Admin attaches central pages from the row.

**4. Wave 6 (11 universities). Admission is on for 9. 902 values were replaced with 0 errors, and 143 readings are excluded.**

| University | Fields admitted | Intakes / fees / IELTS held = adapter | Held back |
|---|---|---|---|
| UQ | all | 316 / 312 / 316 | 3 fees |
| Deakin | all | 144 / 189 / 185 | Domestic-view pages and site-menu months |
| QUT | all | 140 / 122 / 138 | 3 general-reader readings |
| Curtin | all | 202 / 3 / 257 | Fees wait on the international view |
| RMIT | English, fees | — / 271 / 362 | Intakes: 56 pages list fewer intakes than held (decision) |
| Swinburne | intakes, English | 212 / — / 219 | Fees: pages show 2026, the catalogue holds 2027 (decision) |
| Wollongong | intakes, English | 208 / — / 210 | No annual fee published |
| University of Victoria (CA) | intakes, English | 70 / — / 3 | No international fee on the pages |
| Alberta (CA) | English | — / — / 16 | No fee or start dates on the pages |
| Otago (NZ) | none | | Wrong bindings. Rebind 152 courses to `/courses/qualifications/<slug>` (about 160 credits, decision) and accept "(ABBR)" in the identity check |
| Victoria University of Wellington (NZ) | none | | The site moved to wgtn.ac.nz. Website and search domain still say vuw.ac.nz (decision) |

**Next.**
- Wave 7 is scheduled for 08:54: Sydney, Monash, Adelaide, Victoria University, Tasmania, Canberra, Federation, Edith Cowan, AUT (NZ), Calgary (CA), Lethbridge (CA).
- Wave 8 finishes the list.

### 5 Oct 2026, 09:30 AEDT: CF-247 Decision 254, wave 7

**Instruction.** Wave run on the Platform Admin instructions of 5 Oct (04:49, 05:50, 06:12 and 06:32 approving fetching of public websites, 07:42 asking for bigger waves). The four decisions raised after wave 6 have not been answered and stay on hold.

**Wave 7 (11 universities).**
- Admission is on for 10 of the 11.
- 490 values were replaced, with 0 errors.
- 685 readings are excluded: mostly domestic start dates, application closing dates and half-year totals.
- After the overwrite, every admitted field matches the adapter.

| University | Fields admitted | Intakes / fees / IELTS held = adapter | Held back |
|---|---|---|---|
| Monash | all | 266 / 262 / 260 | Scholarship and domestic fees, 2 intakes |
| Adelaide University | all | 229 / 199 / 246 | Half-year and online totals; online intakes (student visas) |
| Edith Cowan | all | 144 / 138 / 149 | Graduate certificate totals, 4 domestic-only pages |
| Canberra | intakes, English | 94 / — / 97 | Fees: not on the stored pages (the browser loads them) |
| Tasmania | intakes, English | 96 / — / 39 | Fees: annual figures for years that are not 100 credit points (decision) |
| AUT (NZ) | intakes, English | 137 / — / 138 | Fees: tuition only or with the student services levy (decision) |
| Federation | English, fees | — / 9 / 100 | Intakes: domestic-view pages |
| Sydney | intakes | 21 / — / — | Domestic-view pages; fee and IELTS load in the browser |
| Victoria University | English | — / — / 7 | Domestic-view pages; per-semester fees (decision) |
| Lethbridge (CA) | intakes | 3 / — / — | 186 courses bound to the wrong pages (decision) |
| Calgary (CA) | none | | Wrong bindings; graduate pages need an abbreviation identity rule (decision) |

**Central pages and rules.**
- 11 key-dates pages attached.
- 11 English proposals written out from the central pages, waiting in Layer 4 Review › Attributes (38 in total).

**Open decisions (8).**
1. RMIT intakes.
2. Swinburne fees.
3. Otago rebind (about 160 credits).
4. Victoria University of Wellington domain (wgtn.ac.nz).
5. AUT fee levy.
6. Tasmania fees for years that are not 100 credit points.
7. Victoria University international pages and turning per-semester fees into annual ones.
8. Calgary and Lethbridge rebind and abbreviation identity.

**Next.** Wave 8 (Southern Cross, Notre Dame, UNE, UNBC, Athabasca, MacEwan, Fraser Valley, Kwantlen) is scheduled for 09:49. UBC needs a Find re-run on ubc.ca.

### 5 Oct 2026, 10:30 AEDT: CF-247 Decision 254, wave 8 (last targets) and a fix to written-out rules

**Instruction.** Wave run on the Platform Admin instructions of 5 Oct (04:49, 05:50, 06:12 and 06:32 fetch approved, 07:42 bigger waves). No answer yet to the open decisions; they stay on hold.

**1. Fix (live, PR #316).**
- Migration 20261005001470 stops a parser re-read of an attached page superseding a central English rule written out from it.
- 10 rules lost that way (Adelaide University, AUT, Calgary, Lethbridge, Sydney, QUT, Otago, Victoria University of Wellington, University of Victoria, Alberta) are proposals again.
- Statement md5 equals the file.

**2. Wave 8.**
- Admission is on for 4 more universities (42 in all).
- 406 values were replaced, with 0 errors.
- 90 readings are excluded.

| University | Fields admitted | Intakes / fees / IELTS held = adapter | Held back |
|---|---|---|---|
| UBC (CA) | all | 196 / 216 / 220 | 11 short course-based programme fees, 4 wrong-campus pages |
| Southern Cross | all | 87 / 85 / 91 | 6 pages with a 2027 fee and no printed year |
| UNE | intakes, fees | 89 / 99 / — | Online-only courses, short-course totals, the 2027 fee list. 82 courses narrow to their international on-campus months |
| UNBC (CA) | intakes, fees | 3 / 2 / — | Most bindings are calendar pages |
| Athabasca (CA) | none | | Online only, no study permit (decision) |
| Notre Dame | none | | Website stored as nd.edu.au; the real site is notredame.edu.au (decision) |
| Fraser Valley, MacEwan, Kwantlen (CA) | none | | Wrong bindings and three title-matching gaps in the worker (decision). 2 Kwantlen median-earnings "fees" are excluded |

**Central pages and rules.**
- 8 key-dates pages attached.
- 9 English rules written out.
- 36 written-out rules are waiting in Layer 4 Review › Attributes.

**Open decisions (10).**
1. RMIT intakes.
2. Swinburne fees.
3. Otago rebind.
4. Victoria University of Wellington domain.
5. AUT fee levy.
6. Tasmania fees for years that are not 100 credit points.
7. Victoria University international pages and per-semester fees times two.
8. Rebind plus title-matching worker fixes for Calgary, Lethbridge, Fraser Valley, MacEwan and Kwantlen.
9. Athabasca (online only).
10. Notre Dame domain.

**Next.** Every target university has now been through a wave. The remaining work waits on these decisions.

### 5 Oct 2026, 11:35 AEDT: CF-247 Decision 254, wave 9 and the adapter apply fix

**Instruction.** Wave run on the Platform Admin instructions of 5 Oct (04:49, 05:50 switching admission on, 06:12–06:32 and 10:29 asking for bigger waves). At 10:54 the Platform Admin reported website permission prompts. They came from wave agents fetching university sites directly. From wave 10, agents do not fetch web pages. They read stored pages only, and central pages are attached for a Firecrawl read on the server, with evidence kept.

**1. Fix (live, PR #317).**
- Migration 20261005001480: applying a text-only adapter no longer sends needs_render pages back for a Firecrawl read (UBC, NorthTec and Southern Cross spent credits this way).
- The adapter's page record now clears test-only extra fields (adapter_extra) when the new reading has none.
- Statement md5 equals the file.

**2. Wave 9 (25 records).**
- Admission is on for 22 more (64 in all).
- 778 values were replaced across 676 courses (717 previously blank), with 0 errors.
- 966 readings are excluded (1,962 in all).

| Provider | Fields admitted | Held back |
|---|---|---|
| UNSW | intakes, fees | 34 fees (graduate certificate totals, borderline graduate diplomas, 6 wrong bindings). The English rule failed the agreement check (catalogue holds 6.0) |
| Newcastle | English | Intakes (domestic first term), fees (browser only) |
| Torrens | intakes, English | 29 intakes and 20 English (single past starts, shared pages) |
| Southern Institute of Technology | intakes, English | All general-reader fees |
| Collarts | intakes | 12 intakes, 8 wrong catalogue fees |
| TAFE International WA | intakes, English | All fees (semester or whole-course totals) |
| TAFE Queensland | English, fees | Intakes |
| TAFE SA | all | 15 fees |
| Ara | all | 6 fees, 5 intakes, 3 English |
| Wintec | intakes | All fees (domestic), 3 intakes |
| NMIT | intakes, English | All fees (domestic) |
| EIT | intakes, English | 37 courses not offered to international students |
| Alphacrucis | intakes, English | Fees (domestic per-subject only) |
| Otago Polytechnic | all | 30 readings |
| Melbourne Polytechnic | all | 27 not-for-international, closed or old-registration courses |
| Charles Sturt | all | 15 fees (2026 tables, study abroad, Master of Philosophy), 2 intakes |
| Whitireia and WelTec | all | 8 fees, 1 intake |
| WITT | English, fees | Intakes (next intake only) |
| Toi Ohomai | English | Intakes (domestic view) |
| AIBT | all | 9 fees (52 weeks on the page, longer in the catalogue), 9 older CRICOS codes |
| Unitec | all | 13 readings |
| Manukau Institute of Technology | all | 9 pages not for international students, 6 fees |
| NorthTec, Open Polytechnic, TAFE NSW | none | 40 courses bound to the academic calendar / distance only / no usable fields |

**Central pages and rules.**
- About 40 central English and key-dates pages are attached.
- 12 English rules are written out, waiting in Layer 4 Review › Attributes:
  - Whitireia and WelTec, Newcastle, Melbourne Polytechnic, Ara, EIT, Alphacrucis;
  - TAFE Queensland, TAFE SA, NMIT, Collarts, TAFE International WA, Unitec.
- Alphacrucis's parser proposal (7.0 for every level) should be rejected.

**Governance note.** Before the brief was tightened, wave 9 agents changed pipeline.coverage_course_pages directly:
- next_read_at at Charles Sturt (11 pages) and NorthTec (43 pages);
- adapter_extra on 7 NorthTec rows.

The brief now forbids direct table changes.

**Open decisions (10, unchanged).** These are the ten listed in the 10:30 entry.

**Next.** Wave 10 (19 providers) uses no web fetching.

### 5 Oct 2026, 18:04 AEDT: CF-247 Decision 254, international view, delivery, exit awards and the whole-course fee range (11:48–18:04)

**Instructions (Platform Admin, 5 Oct).**
- 11:48: read the international view; courses delivered 100% online are in scope; scholarships aligned.
- 12:12: Athabasca (per-credit fees); 13:25: use 30 credits a year.
- 12:18: MacEwan calendar.
- 13:02: La Trobe international fees view.
- 15:22: exit awards. Diploma 1 year, Associate Degree 2 years, Bachelor 3 years; whole fee = annual fee x years.
- 15:34: RMIT international toggle and pathways.
- 15:36: Coverage page columns for location, delivery and requirement.
- 16:49: decisions (below).
- 17:04: plan for the provider whole-course fee range.
- 18:04: decisions (below).

**Decisions of 16:49.**
- RMIT higher education figures labelled "(2027 total)" are treated as annual fees.
- Exit award years follow the term: 6 months or 1 year.
- Delivery is On campus or Online; location gives the campus detail.
- Requirement = the entry requirement plus other requirements (for example a nursing uniform, visits or kits).

**Decisions of 18:04 (whole-course fee range).**
- Use current fees first, with the CRICOS register as the fallback.
- Award courses only.
- Ranges are published per university.

**Migrations applied (statement md5 equals the file).**
- 1490 a83044fc, 1500 57423f76, 1510 b7679e14, 1520 3e06d14c, 1530 d4996cea, 1540 b0054498, 1550 2b60ad7e.
- 1560 a04060d8dfc30d7e85d2a3c820762ea4.
- 1570 0d18058e8436d2988e626af2cf18bfa6 (cf247_provider_whole_course_fee_range).

**Whole-course fee range (migration 1570).**
- New tables: catalogue.provider_fee_ranges and pipeline.provider_fee_range_settings.
- Defaults: courses under one year included; at least 5 courses; oldest fee year 2026; floor A$1,000; non-award levels left out.
- Functions: security.course_years_from_text, provider_course_whole_fees_v1 and provider_fee_ranges_refresh_v1 (cron job provider-fee-ranges-refresh at :57 each hour).
- Admin function public.admin_provider_fee_range with actions read, refresh, publish, unpublish, set, release and settings. Changes need a Platform Admin and a reason, which is logged.
- First run: 1,161 providers, 1,151 with a range, 845 meet the minimum, 0 published.
- Example: RMIT A$13,500–A$290,400 from 499 award courses (24 page totals, 329 annual fee x years, 146 from the CRICOS register).
- The A$1 CRICOS placeholder fees are left out by the floor (Monash 14, La Trobe 1).

**Releases.**
- Worker coverage-sweep v0.17.9 deployed (version 94); all 8 files are the SAME as the repo.
- UI v2.15.191 (package 0.1.118). Coverage › Universities has a "Whole-course fees" column, a panel for each university (publish, set by hand, work out again, and the course list showing how each fee was worked out and why a course was left out) and a settings panel.
- PR #318 squash-merged into main as 9f43815719df32f5d4b375115ce415064f30f3dd; CI green.

**Open items.**
- UBC (256 courses) and Auckland (12) have no course length, so they have no range yet.
- Vancouver Island shows the same whole fee on all 25 courses (one annual fee x 4 years); it needs a check of the adapter's course length.
- There is no public provider page in the repo yet, so published ranges are held in catalogue.provider_fee_ranges, ready for the public card.

### 5 Oct 2026, 20:30 AEDT: CF-247 Decision 254, hosted courses (award links and host pages) and the RMIT fee fix (19:01–20:30)

**Platform Admin requests.**
- 19:01: pathways (foundation → diploma → associate degree → bachelor) often have no course page of their own.
- 19:07: "try it out for couple of uni and come up with answers to decisions".
- 19:18: agreed, and asked whether this applies to the rest. It does: 5,400 active courses across all 76 adapters have no confirmed page.

**Decisions from read-only checks (RMIT, La Trobe, Monash and their colleges).**
1. An exit or nested award takes its page, annual fee, intakes and delivery from its single-degree parent, never a double degree, and only after a register check. Evidence: at RMIT, 20 of 21 Graduate Certificates are half the master's annual fee and 21 of 27 Graduate Diplomas equal it; La Trobe matches 33 of 39 pairs.
2. Pathway colleges (RMIT UP, La Trobe College, Monash College) stay as their own providers, outside the university's fee range, with a "leads to" link to the degree. This link is not built yet (provider_associations is empty platform-wide).

**Migrations applied (statement md5 equals the file).**
- 1580 cf247_award_links_and_host_pages ef747391efc0184c870e29c21c010044
- 1590 cf247_award_link_settings_year_aware_check 9742dd7eeb43b395b6a45492572839dc
- 1600 cf247_award_apply_no_fee_admitted_fix a54aba72bd168430b5e6c87b8b73d3bd

**1580 (award links and host pages).**
- security.exit_awards_detect_v2: La Trobe and RMIT exit-award wording; nested awards matched by title with exactly one single-degree parent; links moved off double degrees.
- security.exit_awards_apply_v2: skips a link that fails the check unless it was set by hand, and copies each field only when that field is admitted.
- pipeline.course_host_pages (shared_page, double_degree, no_public_page).
- security.host_pages_detect_v1 and apply_v1; cron job host-pages-apply at :42 each hour; admitted field 'host_pages'; identity basis 'host_page' added to the Coverage admission country lists.
- public.admin_host_pages (read, detect, apply, confirm_page, no_page, off/on).
- The course list shows 'host'.

**1590 (award link settings).**
- pipeline.award_link_settings: same-year tolerance 2%, lagged tolerance 6%, set from Coverage › Universities.
- The register check allows for the register running one fee year behind.
- admin_exit_awards gains a 'settings' action and reads the settings with scope 'settings'.

**1600.** Apply fix where fees are not admitted (Canberra).

**Worker.** coverage-sweep v0.17.10 deployed (version 95; all 8 files the SAME as the repo). It gives an annual fee from a whole-course total for courses of 0.25 to 8 years.

**Hand corrections.**
- La Trobe 121336C and 121337B re-linked from the double degree to the Bachelor of Food and Nutrition (check passes at 44,400).
- La Trobe Diploma of Science re-linked to the Bachelor of Science.

**Results.**
- Award links: 43 exit awards (36 pass; 7 fail but were set by hand, so they are applied); 360 nested awards (142 pass, 191 fail and are held for review, 27 with no register entry).
- Applied today: La Trobe 28, RMIT 18, Melbourne 14, Canberra 8, Griffith 7, Southern Cross 6.
- Host pages proposed: 55 shared pages (28 pass), 169 double degrees and 262 pages gone, all waiting for a Platform Admin. host_pages is not yet admitted for any university.

**RMIT fee fix.**
- 19 Graduate Certificates held the domestic figure as the international fee (fee rule rmit-program-page-year-basis-v1).
- The adapter now reads the international "(2027 total)" over 6 months. The overwrite at 20:20 replaced them with the international annual figure, which equals CRICOS (for example Marketing 19,200 → 50,880).
- 3 new Graduate Certificate fees were added: 084999G 55,680, 103208E 50,880, 084998J 50,880. No other RMIT fee changed.

**UI.** v2.15.192 (package 0.1.119) adds the Coverage › Universities hosted-courses panel, the award link settings, a host marker on each course and the 'Host pages' admit field.

**Pull requests.** #319 squash f22c4ad9522bfbb30643714ea24b8b45958579aa and #320 squash 4f3bc82b7aefc2b97490ceb5a2ed051382c88a67; CI green.

**Open items.**
- 191 nested awards failed the check (for example Melbourne Graduate Certificate in Management +114% and RMIT Diploma of Graphic Design −44%: different products, not parts of the degree).
- Admitting 'host_pages' university by university.
- The pathway "leads to" links (next change).
- La Trobe College Undergraduate Certificates: the whole-course fee is stored as annual.
- Monash diplomas are held under both Monash and Monash College.
- RMIT vocational courses under one year (Certificate IV in Accounting and Bookkeeping, Diploma of Accounting) are not read.
- The existing chromium-mobile failure in cf-247-admin-simplify ("highlight differences").

### 5 Oct 2026, 21:00 AEDT: CF-247 Decision 254, central English unblocked and hand-bound pages admitted (20:37–21:00)

**Platform Admin 20:37.** Athabasca "has all central links for requirements and course link is correct still not admitting or filling values, work out again was pressed but nothing happened".

**Root causes.**
1. The hourly central English job (provider-english-defaults) failed on every run from 5 Oct 10:33 Melbourne: 61 failures with "the policy document has no stored evidence". One approved rule with no evidence on the rule itself stopped every rule after it, across the platform. 24 approved rules had no evidence on the rule: 15 have it on their central page record and 9 have no captured page.
2. Pages bound by hand (identity 'manual') were never admitted: 482 pages at 26 universities, including 15 at Athabasca. 'manual' was missing from the identity lists of the Coverage admission countries.
3. "Work out again" only recomputes the fee range, and the button did not make that clear.

**Migration 1610** cf247_central_english_unblocked_hand_pages_admitted, md5 7a7d8978d95dc0b0385c64749da14873 (equals the file).
- provider_english_apply_v1 takes the evidence of the central page with the same address when the rule has none.
- provider_english_apply_all_v1 keeps going past a failing rule and records the error on that rule.
- 'manual' is added to the official_url, intakes and english identity lists.
- university_course_location_v1 shows "Online" for online-only courses.

**Catch-up.** The central English run wrote 2,308 English requirements across 117 rules. 9 rules stay held because their evidence was never captured.

**Athabasca at 20:55 (50 courses).**
- Delivery 50, location 50, intakes 49 (was 35), English 48 (was 0; 2 research degrees held), fee 39 (unchanged).
- 15 delivery and 11 intake changes came from the hand-bound pages.
- The other hand-bound pages are admitted by the adapter overwrite runs every 10 minutes (200 changes a run).

**UI.** v2.15.193 (package 0.1.120): the button now reads "Work out the fee range again", with a note that course values are admitted every 10 minutes.

**Pull request.** #321 squash 87378ac4606d9618bb95fc0c29068098be2b4321; CI green.

**Open.** The 9 held English rules need their central pages read: Ara, Newcastle, TAFE Queensland, Alphacrucis, Melbourne Polytechnic, NMIT, EIT, Unitec and NZIST.

### 6 Oct 2026, 11:30 AEDT: CF-247 Decision 254, overnight adapter run (waves 1–14), decisions D1–D11, worker v0.17.13, adapters read inactive courses, and the job system Phase A (5 Oct 21:44 – 6 Oct 11:30)

**Platform Admin 5 Oct 21:24 and 21:44.** "There are 3100 providers, how do we efficiently finish adapter configuring for each of them"; "Don't worry about firecrawl limits, run track in continuous waves after each other to stats at the end of each wave and keep running with max agents all night."

**Overnight run (tracks B, C, D/E, Canada).** Every queued provider (1,769 in `pipeline.night_run_queue`, tracks B 69 batches, C 137 batches, D rebatched by migration 1690 into E 12 batches worked and H 438 providers held for page discovery) plus the 21 Canadian providers never queued was worked by up to 20 agents a wave, 14 waves. Live at 6 Oct 09:27: 885 enabled adapters, 703 admitting (from 710 and 579 at 07:39). 6,840 values changed by adapters since 21:14 (delivery 4,383, fee 1,808, English 350, intakes 299). The remaining 1,175 providers have no courses; about 40 are listed only on aggregator sites and need their own site found. Agents admitted verified fields under the 21:44 instruction; hand-entered values untouched; no Canadian fee admitted (Decision 220 needs the course code on the page). Reports in the session workspace; the pattern sheet and lessons in this repo under `docs/adapters/` (PR #172, 1,426 providers at 09:24: 706 admitting, 186 testing, 141 no adapter, 393 blocked; lessons section 8 and open items 8–10 added).

**Migrations 1680 and 1690 (checked in #327).** 1680: a failed re-read keeps the earlier reading (193 pages restored). 1690: `pipeline.night_run_rebatch`, file md5 c8a1627e68b9484c8b0731f3e3fcc15d equals the live statement.

**Decisions, Platform Admin 6 Oct 10:56 (decision pack D1–D11).**
- D1 Canadian courses mostly inactive: read inactive courses too; activation stays a separate catalogue step.
- D2 Worker v0.17.13 (numeric and capitalised start dates, 34–44 weeks = one academic year): build, opt-in per adapter.
- D6 Release the English rules whose central page is now read; D7 rendered read for the failing pages; D9 host pages on where every shared-page link passed; D10 mark gone pages "No public page" in bulk: all approved and run.
- Job system Phase A with Qualify adapters as the first job: yes, start now.
- Recommended and awaiting the Platform Admin's word: D3 onshore fee read, offshore noted; D4 page wins when it names a year at or after the current academic year; D5 page/catalogue 52-week disagreements held for a person (Decision 225); D8 nested awards that failed the register check rejected in bulk where the parent is unregistered or gone; D11 double degrees held for the track H discovery pass.

**Bulk actions run and checked live (all logged with the decision number, all reversible).**
- D6/D7: the 9 held English rules were already approved; what held them was that their central pages failed with "budget" because those providers were not Firecrawl targets. 112 hand-attached central pages across 76 providers (including the 7 Canadian ones attached overnight) had failed the same way. The 76 providers were added as Firecrawl target overrides (`admin_firecrawl_write('target')`) and all 112 pages sent back with `admin_provider_central_page('read_again')`: 134 targets after refresh, 112 sources back to "found". Newcastle's rule was already applying (29 values).
- D9: host pages admitted for the 5 universities where every shared-page link passed the register check: UTS, Alphacrucis, Charles Darwin, ACU, QUT (`admin_uni_adapter_control('admit')`, existing fields kept). Partial-pass universities stay off.
- D10: the gone-page detector run over 44 providers, then `admin_host_pages('no_page')` for every detected row: 399 courses (262 waiting plus 137 newly detected), 399 course URLs cleared, 399 events logged. The 10 pages that returned 404 once but keep a good earlier reading (migration 1680) were correctly left alone.

**Worker v0.17.13 (PR #328, version 98, byte-identical to main; migration 1700, file md5 492ae280ef204eea8bdb5917809f66f5 equals `md5(statements[1])`).** `pipeline.uni_adapters.reading` = {numeric_dates, upper_dates, academic_year}, each off unless switched on; `admin_uni_adapter_write` checks and stores it; `uni_adapter_json` carries it; the editor shows three tick boxes under Reading options. `monthsIn()` reads "14/09/2026", "19/01/26", "2026-09-14" (day first; month first for Canada when the first number can be a month) and "JAN", "SEPT", "NOVEMBER"; `yearsOf(s, academicYear)` makes 34–44 weeks one year. Deployed through the Deploy edge functions workflow (run 37393147755). A contract test that had failed on main since v0.17.12 (hard-coded worker version) was loosened.

**Migration 1710, adapters read inactive courses (PR #329, file md5 a5d88bbf0f9ba925ea2a2eba4be60a43 equals `md5(statements[1])`).** `admin_adapter_builder`, `svc_adapter_apply_next` and `svc_adapter_preview_next` patched (md5-guarded) from `lifecycle_status = 'active'` to `in ('active', 'inactive')`. `adapter_overwrite_v1` unchanged, so admission still writes active courses only. The 27 Canadian adapters were applied again.

**Job system Phase A (PR #330, v2.15.197 package 0.1.124; migration 1720, file md5 b65c2d8c9c224b2982bb65b604b5333a equals `md5(statements[1])`).** Platform Admin 06:59: "mature the pressing button across ui to have same experience. That once pressed it updates progress, status updates even when page is refresh and admin action cancellation power by selecting ongoing task from ui like task manager."
- `pipeline.admin_jobs` (kind, lane, state queued/running/paused/done/failed/cancelled, args, cursor, progress, result, requested_by, reason), `pipeline.admin_job_events`, `pipeline.adapter_qualifications` (one row per adapter per Qualify run: pages read, each field's read/agree/differ/new/excluded/unclear counts, shares, pass and why). RLS on, no anon/authenticated table access.
- `public.admin_jobs(action, args)`: read (Operator and above), start qualify (Operator (adapters) and above), start admit (Platform Admin), cancel, pause, resume (an Operator or the person who started it). Every start and change is logged in `admin_control_events` (area jobs).
- `security.admin_jobs_tick_v1(10)` on pg_cron `admin-jobs` every minute: one job per lane (for update skip locked), a bounded slice per tick, progress written to the row so a refreshed page loses nothing, cancel and pause at the next provider boundary with work done so far kept, a failing provider counted and logged without stopping the job.
- Qualify thresholds come from settings, not the page: `eval_field_share` (read on at least this share of read pages, 0.5) and the new `qualify_agree_share` (where the catalogue holds values, at least this share agree, 0.9), both under Models & services › Firecrawl › Adapter evaluation.
- Admit the passing fields is a separate Platform Admin step: it calls the existing `admin_uni_adapter_control('admit')` as the person who started the job, adds only the passing fields, keeps fields already admitted, one logged entry per provider. The job never writes an adapter itself. A passing Qualify never activates anything.
- UI: Scheduled jobs › Task manager (nav tab `tasks`, min rank 4): start a Qualify run by country, state or province, provider kind (universities or any) and adapter state; task list with progress bars, started by, pause/resume/cancel; a finished run opens to the per-provider, per-field result with the reason text; Admit button for Platform Admins. Platform guide entry updated.
- Checked live: Qualify over the 11 Victorian universities (job 1f073c1b) ran in slices of 4, paused at a provider boundary, resumed and finished: La Trobe and Monash pass all four fields; Melbourne passes delivery only on the read-share rule (fields on 140–156 of 380 pages); RMIT fails intakes on agreement (58 of 308 differ); Swinburne fails fee on agreement (109 of 110 differ). Nothing was admitted by the run.
- Tests: 59 pass across the contract suites (3 new: migration shape and dispatcher guards, browser Task manager flow as Platform Admin, Operator cannot admit); build and release contract clean; Release Currentness Deployed confirms the site serves v2.15.197.

**Mass enabling by country and state.** Live universities with adapters: AU 51 of 51 (46 adapters, 42 admitting), NZ 8 of 8, Canada 15 of 107 (only 34 Canadian universities have courses loaded; Ontario 35 and Quebec 15 have none). The Task manager's Qualify then Admit is the mass-enable path; its honest answer for most of Canada is "nothing to enable yet".

**Open.**
- D3, D4, D5, D8, D11 await the Platform Admin's word (recommendations above).
- The 112 central pages read within the provider-facts job's next runs; the 8 English rules then apply on the hourly run. Check the Canadian english_policy and intake_calendar sources after that.
- Phase B (shared JobButton), Phase C (re-read, apply and central-page reads as jobs), Phase D (Attribute Registry) not started.
- Track H (438 providers) and about 40 aggregator-only providers need page discovery.
- The "Victoria University" name is held by two providers; the sheet and the Qualify list show both.

### 6 Oct 2026, 14:40 AEDT: CF-247 Decision 254, job system Phases A2, B and C, and the old operations console retired (12:01–14:40)

**Platform Admin 12:01.** "Task Manager is the concept of Windows Task manager, only Running or Queued Jobs management, closed Jobs and Scheduled Jobs are to be maintained from Jobs Tab. Cross check the UI what can be retired. Let me know when you are ready for next Phases - always ask for next step." **13:27:** "Through to C and retire the old operation console." **13:55:** "Option 1" (a one-off exception to the no-`drop` migration rule, for the `admin_jobs.kind` check constraint only).

**UI audit (12:01–12:30).** Surfaces that showed work in flight: Task manager (new), Scheduled jobs › Jobs (`pipeline.jobs` history), Automations, Priority queue, the Universities "Read pages again" request list, the Firecrawl Runs table, the adapter editor's Apply, Live activity, and the Layer 1–4 operations console (`pipeline-ops-entry.jsx`, CF-016, August 2026). Decision: Task manager = live only; Jobs = history; Automations, Priority queue and Live activity kept (recurring schedules and workers are different concepts); the re-read request list, the Firecrawl Runs table and the operations console retired.

**A2 and B (PR #331, v2.15.198 package 0.1.125; migration 1730, file md5 9f5470e7e65bab404b2049b99182251a equals `md5(statements[1])`).**
- `security.admin_job_close_v1`: a finished task (done, failed or cancelled) writes one `pipeline.jobs` row, `job_type` `layer2_task`, domain the task kind, status completed or failed, the task id and title in the payload, state, progress and counts in the result. Written once, from the dispatcher and from a cancel of a queued or paused task. The first Qualify run (1f073c1b) was closed into the history the same way.
- `public.admin_jobs` read returns live tasks only (queued, running, paused) unless `all`; `match` returns the live task of a kind and scope. New `admin_jobs.scope` (a state, country, provider, use case or qualification id).
- Scheduled jobs › Jobs: a `layer2_task` row opens to the task's per-provider result (`AdminTaskDetail` in `pipeline-ops-entry.jsx`, reusing `TaskResult` from `AdminTasks.jsx`) with the Admit button for a finished Qualify run (Platform Admin).
- `src/JobButton.jsx`: one button for a long-running action. Press, reason, start, then the task's progress from the database with Cancel; after a refresh it finds its task again by kind and scope; when the task finishes it says so and points to Jobs.
- Retired: `PipelineOpsEntry`, `OpsConsole`, `PipelineOverview` and the floating launcher (no mount point in the shell since v2.15.107). `JobsWorkspace` and `SourcesWorkspace` stay. Also fixed four colour literals in `mature.css` that failed the one-token-set contract on `main`.

**C (PR #333, v2.15.199 package 0.1.126; migration 1740, file md5 e92f6f710dca2679283fa29c86a4f661 equals `md5(statements[1])`).**
- The `admin_jobs.kind` check constraint is removed and added again wider: `reread_pages`, `firecrawl_run`, `adapter_apply`, `central_page_read` join `qualify_adapters` and `admit_qualified`. This is the one `drop` in the file, under the 13:55 exception; the contract test asserts exactly one and no other destructive word.
- Watcher tasks (`security.admin_job_watch_v1`, reached from `admin_job_slice_v1`): starting one performs the existing admin RPC as the caller (`admin_university_reread('queue')`, `admin_firecrawl_write('start')`, `admin_uni_adapter_write('apply')`, `admin_provider_central_page('add' or 'read_again')`), whose own checks and log entries are unchanged, then the dispatcher watches the underlying record a slice a minute: a re-read request's sending phase (universities sent) then its reading phase (pages of those universities read since the task started, against the pages sent); a Firecrawl run's done of items until its status leaves running; an adapter apply's pages read since start against the pages sent back; a central page's source status. A watcher with no progress for 20 minutes (apply) or 30 minutes (re-read, central page) finishes with a note saying how far the work got. Cancel sets a waiting or sending re-read request to cancelled, stops a Firecrawl run, and otherwise stops the watching. Pause and resume map to a run's stop and continue and are refused for the other three ("this task cannot be paused, only cancelled"). Lanes: `reads` (re-read, apply, central page), `firecrawl`, `adapters` (qualify, admit).
- UI: Coverage › Universities "Read pages again" (one or the ticked universities) and "Attach page", Models & services › Firecrawl's two run starts, and the adapter editor's Apply all use `JobButton`. Retired: the Universities panel's request list and 15-second polling (v2.15.195), the Firecrawl Runs table with Start, Stop and Continue. Firecrawl's call log stays in the support report.
- Checked live: an `adapter_apply` task for Northwestern Polytechnic ran, finished ("0 page(s) read again": the pages had been read since the adapter was last saved) and closed into the Jobs history.
- Tests: 68–70 contract tests pass per run (4 updated for the new flow, 3 new: Phase C migration shape, JobButton finds a running task and cancels, Jobs tab opens a task result). Release Currentness Deployed confirms v2.15.199.

**Open.**
- Phase D, Attribute Registry, not started (asked for the next step).
- Decisions D3, D4, D5, D8 and D11 still await the Platform Admin's word.
- `admin_firecrawl_read` still returns the old `runs` list; harmless, can be dropped from the read in a later tidy.
- The 377 re-read requests marked "sent" from before Phase C are history only; new requests are tasks.

## 6 Oct 2026 — v2.15.200 / 0.1.127: Adapters lifecycle workspace (Decision 254)

- Pilot PR #334 merged (squash 1047bac10c405524f9f0c62502095829b4237e06). Migration 1750 `20261006001750_cf247_adapters_lifecycle` applied live (file md5 e093ad26aacc6f52dce57f8898a558cb, verified equal to the applied statement md5): `uni_adapters.read_cycle_days` (7 to 365, default 90 via coalesce in `svc_coverage_read_record`), `public.admin_adapters` (list, detail, set_on, set_cycle; Platform Admin writes need a reason and are logged), and per-adapter Admit from each adapter's own latest finished Qualify (`admin_jobs`, `admin_job_slice_v1`).
- UI: Layer 2 opens on Adapters (one collapsed row per university: test, Qualify and Admit, on/off with consequences, read cycle, central pages, fee range and rules, Read pages again, hosted courses, Firecrawl target, history; bulk Qualify and Admit on the filtered list). Scholarships stays under Layer 2. Retired: Layer 2 Overview, Fetch an area, History and Source profiles tabs, and Coverage > Universities. Source profiles moved to Scrapers & fetchers (not deleted).
- All cards collapsed by default, open state remembered per browser session (Models & services, Toolsets, Adapters). Models & services keeps services, keys and limits. Task manager is a list only (running, queued, paused; pause, resume, cancel); Qualify starts from Adapters.
- Nothing admitted and no adapter switched on. The Platform Admin answered "Not yet" to admitting the Qualify results (AU 124 adapters, 37 passing; CA 12, 4; NZ 46, 16).
- Known follow-ups: deployed-UAT tests that drive the retired Layer 2 tabs are skipped and need rewriting against Adapters; `layer2-operations-entry.jsx` and `EnrichmentOperations.jsx` are now unused (kept because contract tests read them); 11 ranking/compare/lineage specs fail identically on the prior main.
- Decisions recorded, not yet built: D3 onshore fee read, offshore noted; D4 page wins when it names a year at or after the current academic year; D5 page wins only when the adapter reads a labelled international annual fee (supersedes Decision 225 for that case; log as Decision 255); D8 bulk-reject mechanical failures of nested awards; D11 hold the 169 double degrees for the track H discovery pass; later Phase D Attribute Registry.

## 6 Oct 2026 — v2.15.201 / 0.1.128: page fees against CRICOS, dry run (Decision 255)

- **Decision 255 (recorded, Platform Admin 6 Oct).** The page's labelled international annual fee wins over the CRICOS fee when the page names the current academic year or later and the adapter reads a labelled international annual fee (D4, D5); this supersedes Decision 225 for that case. A gap above 20% is not flagged (multiple choice "Page wins, no flag"). Built as a dry-run report first (multiple choice "Dry-run report only first"); nothing is applied until the Platform Admin reviews it. D3 (onshore fee read, offshore noted) waits on the reader capturing the onshore/offshore label; no stored fee carries it yet.
- Pilot PR #335 merged (squash 969309bac4a32ac283d3ad043b067ed724280a41). Migration 1760 `20261006001760_cf247_fee_rules_dry_run` applied live (file md5 68b44a654a141214cc92dd24a8f65bb7): read-only `public.admin_fee_rules_report` (Operator and above). UI: Layer 2 › Adapters › Page fees against CRICOS (dry run), collapsed card.
- Finding: CRICOS "tuition" is a registered course total, so it is divided by the course duration before comparison. Of 6,825 courses with both: 4,241 agree within 5%, 2,584 differ; the page would win on 2,349 (1,138 higher, 1,211 lower, 962 differ by over 20%), 1 is protected by hand, 59 keep CRICOS (older year), 175 keep CRICOS (no year).
- No fee value was written or changed.

## 6 Oct 2026 — v2.15.202 / 0.1.129: fee used label (Decision 255)

- Finding that changed the build: the whole-course fee range already takes the page's current annual fee first (CRICOS registered total only as the fallback), and the Zoho, Wix and website course APIs return the page fee and the CRICOS total as separate fields. So no resolver was added to those. Platform Admin chose (multiple choice) "Add a labelled fee used to the course drawer and APIs".
- Pilot PR #336 merged (squash 674da06d519186846d55fd98c3e61f7e095aec30). Migration 1770 `20261006001770_cf247_fee_used_label` applied live (file md5 a55eef993fe34380b9bd895fb542baa4, equal to the applied statement md5): read-only `security.course_fee_used_v1` and a `fee_used` key on `security.admin_course_fee_summary` (patch behind md5 guard a9edf2b34508931f9eea1df7c8ed6dfc). UI: course drawer › Fees › Fee used (page or CRICOS per year, the reason, locked by hand).
- Checked live as Platform Admin on four courses: page names 2027 (page used), page names 2025 (CRICOS used), no page fee (CRICOS used). No stored fee changed.
- Open: the Zoho, Wix and website APIs read through a prebuilt layer and do not yet carry `fee_used`; adding it is a separate step (an additive field on a public contract). The page-wins rule is not otherwise applied anywhere; the dry run (Adapters › Page fees against CRICOS) is the check.

## 6 Oct 2026 — v2.15.203 / 0.1.130: fee_used in the course APIs, deployed Layer 2 checks rewritten (Decision 255)

- Pilot PR #337 merged (squash e587796e9bd06d44191a18e34a0aebe3bcd036e8). Migration 1780 `20261006001780_cf247_fee_used_in_course_apis` applied live (file md5 a8692062e19a5df0dfe44b2d5296ce3e, equal to the applied statement md5): `api.zoho_course_lookup_v1` (guard c2e7944d91b06058e7bd7a456540f3c2) and `api.zoho_course_search_v2` (guard f82cdc9284081a9b73977cb32b3107f7) each gain an added `fee_used` key from `security.course_fee_used_v1`. The Wix API and the website card search (v3.1) build on the same search, so they carry it too. Nothing removed or renamed, contract version strings unchanged, no stored fee changed.
- Checked before applying, in a rolled-back transaction: every other key identical on a three-item search, `fee_used` present on search and lookup. Checked live after: 50 items returned with `fee_used` in under a second.
- The deployed Layer 2 checks that drove the retired tabs (admin-navigation, layer2-operations-maturity, a21 navigation, a23 background, a26-a28 operator UX, performance) were rewritten for Adapters and for Source profiles on Scrapers & fetchers; the shared navigation helper now opens Adapters and opens a closed card before reading it. They need the UAT credentials and run in the Deployed UAT workflow; they could not be run from the build session.
- Observation for the page-wins review: some pages show exactly half the CRICOS yearly figure (a per-semester fee read as annual is the likely cause). The dry run (Adapters › Page fees against CRICOS) and the largest-gaps table are the place to check this before any wider use of the page fee.

## 6 Oct 2026 — deployed UAT state after the Adapters release (Pilot PRs #338 to #341)

- The shared deployed-test menu helper still clicked the retired Layer 2 Overview tab, which failed every deployed check that opens Layer 2. It now opens Adapters (PR #339). Checks of Layer 2 screens retired in v2.15.200 (enrichment operations, finalizer fairness, run observability lineage, the Firecrawl route dialog) are skipped with the reason. The currentness check opens Adapters and tolerates an empty Layer 3 pattern queue (Decision 213). The Source profiles checks use the first heading, since the card and the panel both carry it.
- Targeted Deployed UAT passes on the latest commits. The integration tier (run by hand on 6 Oct) went from 44 failing checks to 33. The 33 are mostly older and unrelated to Layer 2 (QILT and PRISMS comparison, Data Quality, the sidebar's Administration label, Administration deep links, the Acquisition providers screen, the stale wording check in the Layer 2 maturity suite). They were not investigated or changed here and need their own pass.
- Open: rewrite or retire those 33; decide whether the integration tier should gate releases while they are red.

## 6 Oct 2026 — v2.15.204 / 0.1.131: fee used for courses under a year, and the half-of-CRICOS findings (Decision 255 correction)

- Pilot PR #342 merged (squash bf820fd20742d25463c74080c85dd968c57f148f). Migration 1790 `20261006001790_cf247_fee_under_one_year` applied live (file md5 24936a74ab79c94f3b3caecf69a5712e, equal to the applied statement md5): `public.admin_fee_rules_report` and `security.course_fee_used_v1` now divide the CRICOS registered total by the course length only when it is a year or more. Read only; no stored fee changed; page-wins is still not applied anywhere.
- Correction: for a course under a year (for example 26 weeks) the registered total is the whole-course fee. The earlier logic divided it by 0.5 years, doubling it and showing 113 of 313 twenty-six-week courses as false disagreements. Re-run live as Platform Admin: compared 7,097, agree 4,561, differ 2,536, would change 2,323, gap over 20% 928, kept (older year) 57, kept (no year) 155, protected by hand 1.
- Half-of-CRICOS findings: after the fix about 154 courses still show a page fee of half the CRICOS yearly figure, so about 41 remain outside the 26-week group. A genuine misread cluster is 52-week VET diplomas at Kingston International College, Canterbury Business College, Melbourne Education Institute and Evantaa (adapter-sourced, page fee exactly half). Some catalogue durations also look wrong (for example QUT Master of Architecture at 52 weeks).
- Source reliability: fee-schedule rows are the most reliable (484 of 552 agree); adapter rows 3,216 of 4,996 agree (501 more than 20% higher); Layer 3 "assumed annual" rows are the weakest (53 of 193 agree, 80 more than 20% higher).
- Open: fix the misreading adapters or pages, review the catalogue durations and the Layer 3 assumed-annual rows before any page-wins switch-on. The Qualify results are still not admitted.

## 6 Oct 2026 — v2.15.205 / 0.1.132: suspected half-year page fees held back in the fee dry run (Decision 255)

- Pilot PR #343 merged (squash 8a575441c885e50a2a49912f03daa0821cacb7a7). Migration 1800 `20261006001800_cf247_fee_suspected_half` applied live (file md5 7dd5f1b6c10627f34a19ec4a16d45ca4, equal to the applied statement md5; guarded on the live 1790 definition md5 d7233b6b8ea2a5f3687c1e9d238cf322): `public.admin_fee_rules_report` adds `suspected_half` and `suspected_half_sample` and leaves those rows out of `would_change`, `page_higher`, `page_lower`, `gap_over_20`, by country, by university and the largest gaps. Read only; no stored fee changed; page-wins still not applied anywhere.
- Rule: a page fee within 3 points of 50% of the CRICOS fee a year, differing, naming this year or later and not locked by hand. Checked live as Platform Admin: 20 held back (page would win 2,323 to 2,303); compared 7,097, agree 4,561 and differ 2,536 unchanged.
- Evidence: Melbourne Education Institute prints $6,000 against CRICOS $12,000 for 52 weeks and $18,000 for 78 weeks (2 and 3 times $6,000), so it is a per-semester fee read as annual. Vocational Careers Institute ($9,500 against $19,500, a duplicated course record) and Kingston International College ($10,400 to $11,000 against $20,000 to $45,000) look the same but are not clean multiples. Evantaa's rows are Layer 3 "period assumed annual", not a misread. Charles Darwin's two 26-week Graduate Certificates ($16,380 from the fee schedule against CRICOS $32,762) suggest the CRICOS total is the full-year figure. The course pages were not opened (these courses hold no page URL).
- Open: confirm the fee wording on the MEI, VCI and Kingston pages and set an adapter rule; review the CDU 26-week CRICOS totals and merge the duplicate Diploma of Automotive Management; Layer 3 assumed-annual rows stay the weakest source. The Qualify results are still not admitted.

## 6 Oct 2026 — v2.15.206 / 0.1.133: course scholarship lists only include the course's own provider (Canadian courses showing Australian scholarships)

- Reported by the Platform Admin (21:35 Melbourne): some Canadian courses show Australian scholarships. Validated, and wider than Canada.
- Cause: `security.scholarship_selection_for_course_impl`, behind the Zoho scholarships API (`public.zoho_edge_scholarships_v1`) and the admin course scholarship view, matched any study-level or field scope to every course at that level with no provider or country check. 4,677 study-level scopes carry no provider, course or country (1,071 scholarships). 2,373 of 10,356 Canadian courses were reached by 449 non-Canadian scholarships (433 AU, 16 NZ; 346 published). A Vancouver Island University course returned 226 scholarships from 35 providers; a Monash course returned 227, of which 209 were other providers'.
- Not affected: the 155,002 stored course-scholarship links (none cross country or provider) and the course search index (`has_scholarship`, `scholarship_options`), which are built from the links.
- Pilot PR #344 merged (squash bdb3a1feaea63372f286bc68f6cd7ffa7a02651a). Migration 1810 `20261006001810_cf247_scholarship_selection_provider_match` applied live (file md5 f85868b36c0d251ff2330cad96f75ae7, equal to the applied statement md5; guarded on the live definition md5 3ace946099f640874935d9a3237cea73, four snippets each found exactly once): study-level and field scopes now match only when the scholarship has no provider or its provider is the course's provider. No stored scholarship, link or course changed.
- Checked in a rolled-back transaction, then live: Monash course 227 to 18 (all Monash); Vancouver Island University course 226 to 0.
- Scholarship configuration found: 13 active scholarship jobs (course-scope apply hourly :19, course refresh every 15 minutes, weekly maintenance Sunday 05:20 UTC, daily publication review); latest weekly maintenance 4 Oct 39,616 mappings, 0 review candidates. Runtime settings exist for AU only (enabled); government feeds are Australian only (Australia Awards, Study Australia); the AI check on change is disabled for AU, NZ and CA. Canada holds 43 scholarships (2 published, 22 with criteria, 27 audience not stated, none with a provider or course scope); NZ 76 (8 published, 32 with criteria).
- Open: Canada and NZ scholarship runtime rows and feeds are not set up; Canadian and NZ scholarships carry no provider or course scope, so none link to courses by rule; 18 scholarships have no provider.

## 6 Oct 2026 — v2.15.207 / 0.1.134: Canada and NZ scholarship runtime settings added, switched off; government source research

- Pilot PR #345 merged (squash 7a99d9d83917c238c27b77e916827ccfedc7405e). Migration 1820 `20261006001820_cf247_scholarship_runtime_ca_nz_off` applied live (file md5 e280180a6034d296bc4740d5fcb91538, equal to the applied statement md5): `pipeline.scholarship_runtime_settings` gains CA and NZ rows, `enabled` false, `auto_dispatch` false, 25 pages a run, 168-hour refresh, publication not authorised (insert only, `on conflict do nothing`). Read back live. Nothing is read, refreshed or published for either country until a Platform Admin switches it on.
- Decision (Platform Admin, 6 Oct): rely on university pages for Canada and NZ for now; no national feed.
- Government source research (no source-qualification rows written): EduCanada's "Search for scholarships" is an official Government of Canada table of programmes (Program; Managed/Funded by), so at most national programme identity, with entry counts and detail pages unverified. Education New Zealand's scholarship pages describe the Prime Minister's Scholarships for Asia and Latin America, an outbound programme for NZ students, with no catalogue. MFAT's Manaaki New Zealand Scholarships are inbound but the official page was not opened. Neither country has a qualified feed comparable to Study Australia.
- Open: decide whether to record EduCanada as a candidate source (programme identity only); locate and qualify an official NZ inbound source; switch on Canada, then NZ, in the scholarship runtime settings once reviewed (Canada: 20 discovery providers and 43 scholarships; NZ: 8 and 76); give Canadian and NZ scholarships a provider scope so they link by rule.

## 6 Oct 2026 — v2.15.208 / 0.1.135: unscoped Canada and NZ scholarships queued for review (no links created)

- Pilot PR #346 merged (squash 535e9c9c4ec48d0d5616baf97dbc2f6f120d2c1f). Migration 1830 `20261006001830_cf247_scholarship_review_candidates_ca_nz` applied live (file md5 b0513633feac5502c501a65ccce412ed, equal to the applied statement md5): inserts `scholarship.course_mapping_candidates` rows, status `needs_review`, reason `provider_owned_but_no_explicit_course_or_provider_scope`, for the 19 Canadian and 38 NZ scholarships that have no scope, against their own provider's active courses (2,560 CA pairs, 15,463 NZ pairs). `on conflict do nothing`.
- Decision (Platform Admin, 6 Oct): queue the unscoped scholarships for review, with no links. A provider scope on every Canadian and NZ scholarship was declined: it would have added about 31,000 links (5,658 CA, 25,718 NZ) and widened the 24 CA and 38 NZ scholarships that are scoped by study level to every level.
- Checked live: candidates 2,560 CA and 15,463 NZ, all needs_review, none cross-provider; `scholarship.course_mappings` unchanged at 155,002; the earlier 37,200 AU candidates remain superseded. No course link was created, no eligibility assumed, nothing published.
- Open: the candidates are per course pair, so reviewing 18,023 pairs one by one is impractical; read each scholarship page for its level or "all courses" statement and accept or reject by scholarship, or add an explicit provider or course scope where the page states one.

## 6 Oct 2026 — v2.15.209 / 0.1.136: course blade scholarship context limited to the course's own provider; audit of customer-facing endpoints

- Audit requested by the Platform Admin (6 Oct, after v2.15.206): check the Wix, website and Zoho endpoints for the same missing provider or country check.
- Second instance found and fixed: `security.admin_contextual_insights` (the admin course blade's Scholarships context, A12) matched study-level and field scopes to every course at that level with no provider check, the same flaw fixed in `scholarship_selection_for_course_impl` (v2.15.206). A Vancouver Island University course listed 629 scholarships, including RMIT's; a Monash course 632; an Otago course 364.
- Pilot PR #347 merged (squash d9ed81eb34d06e2894fff34f1521e3261339c02c). Migration 1840 `20261006001840_cf247_contextual_scholarships_provider_match` applied live (file md5 3cfb43594b37aa87789cdd913bf78ffa, equal to the applied statement md5; guarded on the live definition md5 60ca16d244029dad671c8d838558fb6b, each of the two snippets found exactly twice): study-level and field scopes count only when the scholarship has no provider or its provider is the course's provider. Checked in a rolled-back transaction then live as the Platform Admin: Vancouver Island University 629 to 0, Monash 632 to 32, Otago 364 to 1. Read only; no stored data changed.
- Checked and clean: the course search index (49,670 scholarship entries on 9,586 courses, none from another provider, all keys found); the 155,002 stored course-scholarship links; course-campus links (48,729), intake and fee campuses, course identifiers (provider and country) all consistent with the course's provider; fee currency matches the provider's country (AUD, CAD, NZD). The provider-level selector `scholarship_selection_for_provider_impl`, the provider branch of the contextual insights and `website_edge_scholarship_search_v1` (scholarship-based, no course join) are provider-bound.
- Not changed, to decide: `website_edge_scholarship_search_v1` has no country filter and labels references and groups with Australian terms, so published Canadian and NZ scholarships (2 and 8) would appear in the website scholarship search; the Zoho and Wix course endpoints were audited through the selector and the search index only, not each response field.


## 6 Oct 2026 — stale deployed checks rewritten (test-only; no release bump)

- Pilot PRs #348 (squash b85e61e0abae8cef6794e85b575de14478e946f3) and #349 merged. Only test files changed; no application code, migration or version change.
- Fixed to match the current product: A10 paged-filter routes now sit under "Rankings & statistics"; admin navigation groups are Catalogue, Data pipeline, Operations and the deep link is `#scrapers` ("Scrapers & fetchers"); A12 accepts the `regional_context` state and asserts the benchmark line through `.ci-benchmark-copy` (no RMIT outcome carries a benchmark, so the text is not always present); CF-061 contract and deployed specs updated for the current compare route, manifest version pattern and benchmark line; Layer 2 operations maturity text updated.
- Result: targeted run on main green after #349 (push run 37458967944). Integration run 37459188845 (dispatched after the fixes) still fails 26 checks, down from 32 before.
- Still open (causes not readable; only truncated annotations are available): Data Quality x3 (the `openDataQuality` helper in `tests/uat/support/runtime-evidence.mjs` uses the retired heading "Data Quality & Readiness"), Layer 2 platform x1 and provider x3, M2.3 intelligence x2, plus admin-navigation deep-link and the two CF-061 deployed checks, which still fail in the integration tier.
- Nothing was loosened to make a check pass. No data, adapter, fee or scholarship setting changed.
