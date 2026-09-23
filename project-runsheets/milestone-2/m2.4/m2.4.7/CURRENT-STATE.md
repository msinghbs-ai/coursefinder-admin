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
