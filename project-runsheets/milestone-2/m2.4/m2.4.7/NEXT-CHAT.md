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
