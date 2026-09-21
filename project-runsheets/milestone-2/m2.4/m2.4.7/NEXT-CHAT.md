# M2.4.7 NEXT CHAT

Start from repository/runtime truth under `PROJECT_INSTRUCTIONS.md`, `docs/README.md`, CF-CHG-20260915-247 and this directory. M2.4.7 remains Gate D. Larger L2 waves remain paused until the next governed gate decision.

For short manual control prompts, use [`OPERATOR-PROMPTS.md`](./OPERATOR-PROMPTS.md). Manual work is primary while active; the hourly CF-247 task is failover and must not duplicate an in-flight Gitar, CI, deployment or UAT action.

## Current critical-path truth — 19 September 2026

Pilot PR #99 branch `cf-247-candidate-bound-layer3` exact head is **`06b2c7b2ad538500f6658f7d58883be9b7ede2e9`**. Exact-head Pilot Frontend Build **35494635619 PASS** (20 September 2026).

Qualification previously PASSED under the corrected route-safety contract: run `76ba93df-7a0b-4646-be85-a22c6a548b49`, request 6331, provider 4/4 and controls 4/4. Strict candidate validation remains fail-closed; safe abstention/ambiguity/rejection is valid only when durably routed to Layer 4.

The bounded 10-item Evidence-backed tuition cohort has fully drained through Layer 3: **10/10 `layer4_required`**, with **0 validated/admitted**. Layer 4 pending is **58**. `catalogue.course_fees` remains **79,730**, `search.course_documents` **33,105**, and Evidence **32,034**. **NO DATA ADMISSION PROVEN.**

### 19 Sep 2026 positive-path probe

Execution advanced to a separate bounded RMIT target rather than recycling the exhausted cohort. RMIT Associate Degree in Design (Furniture), CRICOS `061154K`, course `1a36c939-1560-4e5f-a6b7-25bf5fa38f51`, retained Evidence `8929bff1-2606-4323-a8ef-45f25f1cf49d`, has an international AUD 38,400 candidate requiring basis validation. Its latest Layer-2 item `5ee026d1-1309-4a14-9e37-79d66a2c5a0e` is `layer3_required`.

A bounded enqueue through `layer3_enqueue_from_layer2_service` created work item `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1`; dispatcher request **6621** reserved it. Runtime verification immediately exposed a contract defect: this direct single-item enqueue service does **not persist `candidate_context`**, while the service-owned interpreter requires persisted candidate context. The item was safely transitioned `reserved`→`failed` through `layer3_work_item_transition_service` with a one-hour retry delay; no unsafe interpretation/admission was allowed and no DATA ADMISSION is claimed.

The existing bulk `layer3_enqueue_eligible_layer2_service` is confirmed to construct and persist immutable `candidate_context` from the exact normalized Evidence/source record. Therefore the defect is specifically the direct single-item enqueue path, not the candidate-bound interpreter contract.

## Exact continuation sequence

1. Do **not** dispatch work item `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` again while its `candidate_context` is null.
2. Make the smallest forward-only correction so the bounded/single-item enqueue path derives and persists the same immutable candidate context as `layer3_enqueue_eligible_layer2_service`, or introduce an equally narrow service-owned bounded enqueue that reuses that governed derivation. Do not accept caller-supplied candidate context.
3. Repository-back/apply the correction, require exact-diff/exact-head CI/UAT, then retry only the RMIT bounded target. If validation succeeds, continue immediately through deterministic admission → canonical delta → Search/API projection/no-op proof. If it safely abstains/rejects, route to Layer 4 and select a different genuinely Evidence-supported positive target; do not manufacture a positive.
4. Capture M247-FU-021 before/after proof including the bounded work/item/entity IDs, Evidence lineage, L2/L3/L4 counts, canonical and Search/API deltas, provider calls/tokens/cost/latency and quota headroom.
5. Keep larger L2 waves paused. DATA ADMISSION remains unproven until authoritative canonical plus consumer proof exists.

M247-FU-020/021/022 and the anti-loop rule remain mandatory.

## Fresh reconciliation — 20 September 2026

PR #99 head is `06b2c7b2ad538500f6658f7d58883be9b7ede2e9`; exact-head Frontend Build `35494635619` PASS. Live `pipeline.layer3_work_items` grouped by status: 10 `layer4_required`, 1 `pending`. Prior section's `reserved`→`failed` status is historical. FOLLOW-UPS records dispatcher request 6632 `service_role required` and an auth/currentness corrective action; reconcile the PR's intervening commits and deployed dispatcher before applying another fix. Do not assume an old defect persists merely from handoff text. Next executable action: inspect exact-head dispatcher auth change and deployed version; if corrected, dispatch only the existing pending work item and capture its terminal disposition; if not, make the smallest forward-only service-owned auth fix, validate/deploy then retry that item. Do not enqueue a new cohort or invent candidate context. M247-FU-021 still requires the full proof bundle; **NO DATA ADMISSION PROVEN** from the observed queue count alone.

## Superseding handoff — 21 September 2026

PR #99 exact head is `9b05918bcc59a1d68da54e1bbc6b9c15c6d9b051`; Frontend Build `35555240917/#2478` and Release History Contract `35555240881/#156` PASS, including the new candidate-bound contract step. Gitar reports no issues and the PR remains draft.

Live runtime: 2,511 L2 `layer3_required`; L3 work 10 `layer4_required` + 1 `parked`; L4 pending 59; Evidence 32,040; field admissions 1,216; fees 79,730; Search documents 33,105. Deployed functions remain benchmark v11, interpreter v5, dispatcher v4. Repository head is not deployed proof. **NO DATA ADMISSION PROVEN.**

Active action: finish only the in-flight Gitar dispatcher slice requested in PR comment `5754745214`: task/profile-scoped reservation, `x-cf-pilot-key` validation through the governed RPC, one-at-a-time/full-budget/status recovery preservation, and explicit CI coverage. Then independently inspect exact diff/head/CI. Next slices are benchmark-version binding, deterministic admission/L2 reconciliation, and only then the description-first generic handler. Do not dispatch the parked item, deploy piecemeal, start intake/English, enqueue a cohort or merge PR #99.

## Next bounded execution — updated 21 September 2026 14:05 AEST

Start at Pilot PR #99 exact head `c8866b573480b337ed86494f9817c98c69629c79`. Exact-head workflows `35555931223/#2479` and `35555931237/#157` pass. Pilot has migration `20260921040446_cf247_task_profile_scoped_reservation` and ACTIVE `layer3-work-dispatch` v5 hash `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`.

Runtime remains 10 `layer4_required` + 1 `parked`; target `8eb0d4e1...` is parked at attempt 6 and must not be retried. Evidence is 32,040, course fees 79,730, and UTC-day provider/benchmark calls are 0/0.

Execute exactly slice 3: bind benchmark PASS to the shared candidate-bound validator/schema and exact profile prompt/schema/validator/model versions, invalidate PASS on any binding change, use one bounded Gitar repair, then independently verify exact-head CI and runtime currentness. Do not start deterministic admission, generic drain, a cohort, larger L2 waves, RLS remediation or merge/ready-for-review in the same run.

### Migration-ledger reconciliation — 21 September 2026 14:12 AEST

Gitar aligned the repository migration filename to the already-applied Pilot ledger without changing SQL bytes. PR #99 exact head is now `e7b6d5b3ab345511c99fa66e35e65b89fab4d581`; Pilot Frontend Build `35560006737/#2480` and Release History Contract `35560006759/#158` both PASS. Repository file `20260921040446_cf247_task_profile_scoped_reservation.sql` now matches runtime migration `20260921040446`. Dispatcher v5/hash, queue counts and zero-call telemetry are unchanged. Slice 2 remains closed; slice 3 benchmark binding is next.


### CF-247 Slice 3A1 — 21 September 2026 15:00 AEST

PR #99 remains draft and mergeable at exact head `d3e48fa6c33cbe03cec66f3af0d3e3df50686a66`. Gitar added only the shared strict tuition response-schema export, stable candidate-validator/schema contract identifiers, and deterministic assertions in the existing required contract test. Independent diff review confirmed two files changed and no validator behaviour, benchmark execution, migration, dispatcher, interpreter, admission, Layer 4 or Search authority changed. Exact-head Pilot Frontend Build `35562558006/#2481` and Release History Contract `35562557856/#159` PASS.

This is repository/contract foundation only; it is not a runtime deployment or DATA ADMISSION. Pilot remains: dispatcher ACTIVE v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`; interpreter ACTIVE v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`; tuition benchmark ACTIVE v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. Runtime is unchanged at 10 Layer-4-required + 1 parked; target `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` remains parked at attempt 6; Evidence 32,040; course fees 79,730. No provider call, retry, canonical or Search/API delta was caused by this slice.

Next executable unit is Slice 3A2 only: make the tuition benchmark consume the shared schema/validator and align positive/null fixtures to single-target candidate-bound semantics. Do not start binding persistence/predicate work, retry the parked item, run a benchmark, create a cohort or expand Layer 2 in that unit.

### CF-247 Slice 3A2a — 21 September 2026 17:08 AEST

PR #99 remains draft at exact head `59b7a0759d5e87a709c47586f17ed952fa12f7a0` ([commit](https://github.com/msinghbs-ai/Coursefinder-Pilot/commit/59b7a0759d5e87a709c47586f17ed952fa12f7a0)). After the prior Gitar stop, a narrower, independently verified unit replaced only the benchmark's duplicate response schema with the shared schema export and added a deterministic source assertion; two files changed. Gitar's local contract/build passed; exact-head Pilot Frontend Build `35571407034/#2482` and Release History Contract `35571407041/#160` both PASS. No deployment or benchmark execution. Pilot functions remain dispatcher v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`, interpreter v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`, benchmark v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. Fresh queue read: 10 `layer4_required`, 1 `parked`; bounded item remains parked at attempt 6. No provider call, retry or admission was triggered; fresh broader resource, canonical and Search/API counts were not measured. **NO DATA ADMISSION PROVEN.** Next run: complete 3A2 shared-validator adoption and candidate-bound control fixtures only, then independently verify exact-head CI. Binding persistence/predicate remains 3B; do not retry the parked item, benchmark or expand L2.

### Exact next action — 21 September 2026 20:04 AEST

Pilot PR #99 draft/mergeable, head `463821f178ff3d79f3888b0d65f6b6227c08469d`; Frontend Build `35581451411/#2484` and Release History Contract `35581451463/#162` PASS. Slice 3A2c fixture repair `1c309f9` is independently verified; follow-on transport-scoring correction `463821f` also passed exact-head CI. Deployed benchmark v11 (`ac0a1e6d…`), interpreter v5 (`13c1aeea…`), dispatcher v5 (`f72a0194…`) have not changed. Live L3 queue 10 `layer4_required` + 1 `parked`; no admission proven. Next run handles 3A2d only: known-positive provider corpus must be scored as positive truth, without letting a fragile Evidence-text keyword heuristic decide the expected class. Inspect exact diff, one bounded Gitar instruction if no action in flight, verify tests/CI. Then 3B binding on a later run. Preserve draft/no auto-merge, parked-item and larger-wave pauses.


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
