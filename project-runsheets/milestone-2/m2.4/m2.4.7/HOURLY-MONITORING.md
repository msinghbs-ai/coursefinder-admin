# M2.4.7 / CF-247 Hourly Monitoring

**Status:** ACTIVE  
**Purpose:** durable hourly operational record for autonomous CourseFinder delivery.  
**Authority:** `docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md`, `docs/coursefinder-actionable-operations-monitoring-standard-v1.0.md`, `CF-CHG-20260915-247`.

## Recording rule

Add one concise entry per hourly monitoring/execution cycle. Record only actionable deltas and exact blockers; do not turn this into a chat transcript.

Each entry should contain where available: timestamp; repo/runtime/CI head checked; implementation/data outcome; L2/L3/L4; admissions/Search/API delta; Evidence; provider/model usage; backlog/resource headroom; forecast/next action; hard external blocker.

## 2026-09-15 09:27 UTC — monitoring baseline

- CF-247 active; Pilot Supabase `fxcwkweaxjtknorudmwp`; accepted entering baseline `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`.
- RMIT proof: 25/25 processed, 0 deterministic L2 resolution, 25 `layer3_required`, 0 blocked, USD 0.
- Runtime backlog **2,402** `layer3_required`; consumer baseline Search 33,105; official URLs 527; intakes 487; English 520; provider-current tuition 161.
- Decision: no larger L2 backlog until automatic L2→L3→admission exists.

## 2026-09-15 11:27–23:25 UTC — prior cycles

- Durable service-owned Layer 3 queue, security/recovery controls and explicit Evidence-backed tuition handoff derivation were implemented, reviewed, merged and deployed through Pilot main `2346fab3...`.
- Direct runtime truth reconciled at **2,402 layer3_required / 2,281 resolved_l2 / 815 cancelled / 10 blocked**. L3 queue remains empty because tuition qualification fails closed.
- Explicit tuition ambiguity comprises **390 multiple-equal-rank + 208 low-confidence = 598** items. Generic **1,780** `layer3_required` rows remain non-dispatchable until unresolved-field provenance is explicit.
- Tuition benchmark execution was unblocked with forward migration `cf_247_allowlist_tuition_benchmark_nonce`, reconciled to Pilot `188093ca...`. Fresh benchmark: provider semantic **0/4**, safety controls **4/4**, 8 calls, 68,071 input + 1,466 output tokens, max latency 5.794 s, USD 0. Profile remains paused/FAIL.
- Root cause: prior positive benchmark cases were unresolved backlog Evidence whose expected basis itself required validation; the safety contract correctly refused to manufacture an annual fee. Do not weaken the prompt/model.

## 2026-09-16 01:27 UTC — valid benchmark-positive corpus located

- Runtime contains **168** admitted `provider_current_tuition` fee rows; **9** have retained governed Evidence plus explicit allowed annual basis and form the positive benchmark corpus.
- No model call consumed. Exact next action was corrected benchmark selection.

## 2026-09-16 02:32 UTC — corrected benchmark corpus deployed

- `layer3_cf245_tuition_benchmark_cases_service` now selects only already-admitted provider-current tuition with explicit annual/indicative-annual basis and retained Evidence. Forward migration reconciled to Pilot `1010f027...`.
- Runtime unchanged; profile remained paused pending qualification.

## 2026-09-16 03:04 UTC — verified corpus benchmark completed; worker semantic defect isolated

- Verified corpus benchmark finished **provider 0/4, controls 4/4**, 11 calls, 27,052 input + 1,241 output tokens, max latency 6.867 s, USD 0.
- Worker instruction was inconsistent with governed `indicative_annual` positive truth. Deployed worker source was also absent from repository. Runtime backlog remained **2,402 / 2,281 / 815 / 10**; queue empty.

## 2026-09-16 03:58 UTC — benchmark worker reconciled; narrow semantic correction committed

- Retrieved deployed `layer3-cf245-tuition-benchmark` v1 source from Pilot runtime and reconciled it into Pilot repository at `supabase/functions/layer3-cf245-tuition-benchmark/index.ts`, commit `fa612605f72bd19dd3288c8869b5bec80c6563b3`.
- Corrected only the positive semantic contract: explicit governed `annual`, `indicative annual`, or `per-year explicit` Evidence is eligible; `indicative_annual` must remain that weaker basis and may not be strengthened/annualised. Positive validator now requires the returned basis to equal independently admitted expected basis. Existing ambiguity/domestic/loan/deposit/currency controls remain unchanged.
- No new model call was intentionally consumed. Runtime/admission/Search/API deltas remained unclaimed.

## 2026-09-16 04:41 UTC — worker v1.1 deployed; benchmark rerun started

- Reconciled Pilot main `fa612605...`. Frontend build completed successfully. Deployed-UAT run `35053817695` failed on an existing Layer 3 UI locator strictness defect; checked-in Layer 3 contract test passed. This is tracked separately and is not authority to weaken runtime controls.
- Deployed repository-owned `layer3-cf245-tuition-benchmark` **v2 / worker `cf247-tuition-benchmark-v1.1.0`**. Triggered exactly one verified 4-positive + 4-control benchmark through governed server path, request **6257**.

## 2026-09-16 05:35 UTC — benchmark 6257 completed; validation-vs-extraction contract mismatch isolated

- Request 6257 completed: **provider 0/4, controls 4/4**, 9 calls, 36,056 input + 1,529 output tokens, max latency 6.554 s, USD 0. Profile remains paused/FAIL.
- Three verified UQ positives returned `candidate_value=null` at confidence 0.95; the fourth also returned null. Root cause: `provider_current_tuition_validation` is a validation task for Layer 2 fee candidates, but benchmark/runtime prompt supplied raw Evidence without the candidate-under-validation.
- Runtime operational state remained **2,402 layer3_required / 2,281 resolved_l2 / 815 cancelled / 10 blocked**; L3 queue empty; no admission/Search/API delta.

## 2026-09-16 07:42 UTC — Layer 2 candidate lineage preserved at Layer 3 handoff

- Reconciled the actual Layer 2 extraction contract: `layer2-course-fact-extract` persists `provider_current_tuition`, `fee_candidates`, ambiguity and identity state in `pipeline.course_fact_source_records.parsed_payload`; those records are keyed to the **normalized extraction Evidence**, not the raw/html attempt Evidence.
- Applied forward migrations `cf_247_layer3_candidate_validation_context` and `cf_247_layer3_candidate_lineage_fix`; reconciled to Pilot main commits `5c944936...` then `555875d8...`. `pipeline.layer3_work_items` now has immutable `candidate_context`; enqueue derives it from the exact normalized Evidence/source record and still requires service role + enabled/unpaused/benchmark-PASS tuition profile.
- Initial raw-Evidence join correctly produced zero candidate matches and was fixed forward-only rather than rewriting the applied migration. Direct runtime reconciliation after the fix finds **610** explicit fee fall-out records with candidate lineage: **610/610** have a proposed provider-current tuition candidate and **598/610** retain fee-candidate arrays. This proves the candidate needed by Layer 3 was already persisted; it was being dropped at handoff.
- No queue items were enqueued because the tuition profile remains benchmark-FAIL/paused. No model calls, tokens or cost were consumed this cycle; no canonical/L4/Search/API delta is claimed. Last authoritative overall backlog remains **2,402 / 2,281 / 815 / 10** pending a fresh direct count in the next execution cycle.
- Exact next action: update `layer3-interpret` and the tuition benchmark to consume `candidate_context`, require any accepted amount to be a member of the deterministic Layer 2 candidate set, prohibit basis strengthening/annualisation, retain null for genuine ambiguity, then rerun one bounded qualification. On full semantic+safety PASS, unpause and dispatch the first 10–25-item cohort through deterministic admission/L4 → Search/API.
- No hard external API/quota/auth blocker observed.

## 2026-09-16 08:46 UTC — candidate-bound validation contract implemented; critical path advanced

- Reconciled deployed `layer3-interpret` v10 against Pilot `555875d8...`: production worker still lacks `provider_current_tuition_validation` and does not consume `candidate_context`; this is the active implementation gate, not a runtime-capacity blocker.
- Created bounded implementation branch `cf-247-candidate-bound-layer3` from `555875d8...`. Added shared fail-closed validator at Pilot `e8f618f4...` and explicit safety contract tests at `3556a395...`.
- Validator permits only an exact deterministic Layer 2 candidate match across amount/currency/basis/year; null remains a safe rejection/no-candidate outcome. Tests explicitly reject basis strengthening (`indicative_annual`→`annual`), currency conversion, derived amounts, year mutation and missing candidate context.
- No runtime mutation, L2 wave, model call or benchmark was performed before worker integration. Runtime remains **2,402 layer3_required / 2,281 resolved_l2 / 815 cancelled / 10 blocked**, L3 queue 0; admission/Search/API delta 0. Latest observed DB size 973 MB and connections 11/60 (81.7% connection headroom); CPU/RAM/Edge concurrency/storage quota remain unavailable from current tooling.
- PLAN CONTROL: critical path advanced from diagnosis to executable safety-contract implementation. Current gate is integration of this validator + candidate prompt context into `layer3-interpret` and benchmark, then CI/UAT and one qualification run. Next-gate ETA cannot yet be supported by measured integration duration; metric needed is first exact-head CI/UAT duration after integration. M2.4.7 completion ETA remains unavailable until a successful bounded cohort establishes admission throughput.
- Exact next action: integrate the shared contract into `layer3-interpret` and benchmark without changing Evidence/identity/profile authority, run exact-head CI/UAT, then execute one candidate+Evidence qualification. No hard external blocker observed.

## 2026-09-16 08:50 UTC — bounded implementation PR opened; runtime rechecked

- Pilot main remains `555875d8...`; implementation branch head `3556a395...` contains the candidate-bound validator + safety tests. Opened draft PR **#99** so exact-head CI/Gitar review can operate on the bounded change while worker integration continues. Admin main is `e6cef66b...` with the governed Gitar self-resolution rule recorded.
- Direct runtime recheck: **2,402 layer3_required / 2,281 resolved_l2 / 815 cancelled / 10 blocked**; Layer 3 work-item queue remains **0**. Evidence is **30,172 total**, **75 created in the last 24h**. No canonical/L4/Search/API delta occurred this cycle.
- Tuition profile remains enabled but paused with benchmark PASS=false; limits remain **10 RPM / 25 requests/day / USD 0 ceiling**. No model calls/tokens/cost were consumed in this cycle. CPU/RAM/Edge concurrency/storage quota remain unavailable from current tooling; prior observed DB size/connections remain 973 MB and 11/60 until refreshed by the persistence audit.
- PLAN CONTROL: critical path advanced operationally by moving the bounded safety implementation into PR review/CI scope, but worker integration is still the current gate. No workflow run was yet attached to branch head at observation time. Status **ON-PLAN / implementation active**, not looping. Next-gate ETA remains unavailable until the integration commit produces measurable exact-head CI/UAT duration. M2.4.7 completion ETA remains unavailable until the first successful bounded admission cohort establishes end-to-end throughput.
- Exact next action: integrate candidate_context into `layer3-interpret` + tuition benchmark on PR #99, then exact-head CI/UAT/Gitar review and one bounded qualification. No hard external blocker observed.

## 2026-09-16 15:21 UTC — corrected Gitar-reviewed benchmark deployed

- PR #99 exact head is `753a67d2...`; exact-head Pilot Frontend Build run `35098223140` is PASS. Gitar's defence-in-depth finding is resolved and outdated; the corrected worker independently enforces candidate equality plus international audience, governed basis and fee-year range.
- Deployed the exact PR-head `layer3-cf245-tuition-benchmark` source to Pilot runtime as Edge Function **v4**, preserving the existing custom one-time nonce/service-role boundary (`verify_jwt=false` unchanged from the governed worker). This closes repository/runtime drift for the corrected benchmark implementation.
- Latest authoritative benchmark remains the prior FAIL: provider **0/4**, controls **4/4**, **9 calls**, **36,361 input + 969 output tokens**, **USD 0**, max latency **3.303 s**. No new model call was consumed by this deployment. Profile therefore remains fail-closed/paused pending one corrected qualification.
- Runtime schema reconciliation corrected the earlier monitoring mistake: Layer 2/3 operational tables are under `pipeline`, including `pipeline.layer2_run_items` and `pipeline.layer3_work_items`; querying `pim.layer2_run_items` was schema drift in the monitor, not a missing runtime table.
- No admission/L4/Search/API delta is claimed this cycle. Last trusted backlog remains **2,402 layer3_required / 2,281 resolved_l2 / 815 cancelled / 10 blocked**, queue 0, until a fresh bounded aggregate count is accepted by the query safety layer. CPU/RAM/Edge concurrency/storage quota remain unavailable rather than zero.
- PLAN CONTROL: critical path advanced from reviewed code to corrected deployed benchmark runtime. Status **AT-RISK / ADVANCING**, not looping. Current gate is exactly one corrected candidate-context qualification. Next-gate ETA: one qualification cycle, medium confidence. M2.4.7 completion ETA remains unavailable until a successful 10–25-item live cohort establishes measured L3→admission→Search/API throughput.
- Exact next action: execute one governed qualification against v4; only on semantic+safety PASS may the profile unpause and first bounded cohort dispatch. No hard external blocker observed.

## 2026-09-16 23:17 UTC / 2026-09-17 04:47 IST — runtime metric reconciliation restored

- Pilot PR #99 remains exact head `753a67d2...`; exact-head Frontend Build run `35098223140` remains PASS. No new implementation commit was observed.
- Direct Pilot SQL access is available again. Authoritative lifecycle `status` counts remain exactly **2,402 layer3_required / 2,281 resolved_l2 / 815 cancelled / 10 blocked**; `pipeline.layer3_work_items` remains empty.
- Monitoring integrity issue isolated: aggregating `outcome_code` gives **2,313 layer3_required / 1,998 resolved_l2 / 821 deferred / 366 NULL / 10 blocked**, but this is telemetry classification, not lifecycle backlog. The 366 NULL outcome rows are legacy rows dated 2026-08-25 to 2026-08-27. Do not substitute `outcome_code` aggregates for lifecycle `status` counts in CF-247 backlog reporting.
- Evidence source reconciled to `pipeline.evidence_artifacts`: **30,172 total, 0 created in the last 24h**. Earlier `pim.evidence` lookup was a schema error, not zero Evidence.
- No L3 work item, admission/L4/Search/API delta, or model call was produced in this monitoring cycle. Latest trusted qualification remains provider **0/4**, controls **4/4**, 9 calls, 36,361 input + 969 output tokens, USD 0, max latency 3.303 s.
- PLAN CONTROL: **STALLED but runtime-access blocker cleared**. The critical path did not advance in this cycle; however, the prior SQL execution boundary is no longer a hard blocker. Current gate remains the forward-only CF-247 executable profile/benchmark/dispatcher reconciliation followed by exact-head CI/review and one corrected qualification. No larger L2 wave is authorised.
- Next-gate ETA: one bounded corrective implementation + review/qualification cycle, low-to-medium confidence. M2.4.7 completion ETA remains unavailable until the first successful 10–25-item cohort establishes measured end-to-end throughput.

## 2026-09-17 08:45–08:50 UTC — execution-first qualification correction; request 6326 queued

- Fresh authoritative runtime resolved request **6324** as FAIL: provider **0/4**, controls **2/4**, 13 calls, **18,799 input + 610 output tokens**, USD 0, max latency **6.609 s**. Profile remained paused.
- Pilot PR #99 was advanced with diagnostic commit `ea5d56b6f5489ee6948e4c4d2c4708caee4ff9bc`, adding candidate-focused Evidence context. Runtime benchmark v5/request **6325** proved the accompanying `json_object` transport change was a regression: provider **0/4**, controls **0/4**, 11 calls, **6,678 input + 35 output tokens**, USD 0, max latency **0.901 s**.
- The four positive benchmark rows were rechecked against canonical `catalogue.course_fees` + retained `pipeline.evidence_artifacts`: all are UQ 2027 international `indicative_annual` AUD tuition facts with retained Evidence and matching 2027 source URLs.
- Pilot corrective head **`58115985856bace75fecb10422dea5220ea4cee4`** restores strict JSON-schema transport while retaining focused Evidence context and all fail-closed candidate equality/audience/basis/year/no-strengthening controls. Exact source deployed as `layer3-cf245-tuition-benchmark` runtime **v6**, worker `cf247-tuition-benchmark-v1.3.1-candidate-bound`.
- Governed qualification request **6326** was submitted through `svc_cf245_run_tuition_benchmark(4)`. At the end of this execution cycle it remains in `net.http_request_queue` targeting the correct Edge Function URL with a 120-second timeout; `net._http_response` has no terminal record yet and the profile still reflects request 6325 FAIL. Do not submit a duplicate qualification while 6326 is unresolved.
- Latest trusted runtime baseline remains **2,511 layer3_required / 2,423 resolved_l2 / 815 cancelled / 10 blocked**, Layer 3 queue **0**, Evidence **30,925**. No deterministic admission/L4 or Search/API delta is proven.
- Proof classification: **IMPLEMENTATION ADVANCEMENT + QUALIFICATION DISPATCH; NO DATA ADMISSION PROVEN**.
- Exact next action: resolve request **6326** first. On full semantic+safety PASS, complete `layer3-interpret` candidate-context integration/exact-head CI/UAT and immediately run a 10–25-item existing Evidence-backed cohort. On FAIL, use exact failure classes; if controls recover but positives remain null, inspect retained Evidence exact text before any further bounded prompt/model correction. No larger L2 wave is authorised.
- NEXT-GATE ETA and M2.4.7 completion ETA remain unavailable until 6326 terminates and the first bounded cohort establishes non-zero end-to-end throughput.

## 2026-09-18 00:48 UTC / 06:18 IST — Gate-D qualification/routing contract corrected

- Authoritative programme design rechecked: Layer 3 interprets Evidence; ambiguous, conflicting, low-confidence or validator-failed outcomes belong in Layer 4 Human Resolution. Universal positive AI resolution is not a programme prerequisite.
- Identified continuity drift: recent Gate-D handoff narrowed qualification into full provider-positive PASS and caused repeated Evidence-corpus searches even though UQ safe abstention was consistent with the fail-closed design.
- Updated CF-247 RUNSHEET, CURRENT-STATE, FOLLOW-UPS, NEXT-CHAT and Change Control so qualification must prove both supported resolution and safe abstention/rejection→Layer-4 routing. Strict no-invention/no-annualisation/no-currency-conversion/year/audience/no-strengthening controls remain unchanged.
- Updated both active schedulers: CF-247 Admission Watch now executes the corrected bounded L3→admission/L4 path; CF Persistence Audit independently verifies safe abstention routing and M247-FU-021 proof instead of demanding universal resolution.
- Pilot PR #99 authoritative head remains `56afd9466c7375dc0a5f2c83d6cd58dbbac02715`; exact-head Frontend Build `35224454671/#2452` PASS.
- Proof classification: GOVERNANCE/EXECUTION-CONTRACT ADVANCEMENT; **NO DATA ADMISSION PROVEN** yet.
- Exact next action: inspect the existing service-owned interpreter/transition path for missing abstention→Layer-4 disposition, make the smallest forward-only code/runtime correction if required, exact-head CI/UAT, then execute the first 10–25 Evidence-backed cohort. Larger L2 waves remain paused.

## 2026-09-21 02:15–02:50 UTC — manual-first Gitar closure campaign

- Pilot PR #99 advanced from `06b2c7b...` to exact head `9b05918bcc59a1d68da54e1bbc6b9c15c6d9b051`. Candidate validation now has one positive target, explicit identity/audience gates, separated competitor prompt context and an executed exact-head CI contract.
- Frontend Build `35555240917/#2478` PASS and Release History Contract `35555240881/#156` PASS; Gitar reports no issues. PR remains draft/no auto-merge.
- Dispatcher repair commits now prevent batch lease stranding, require full-call remaining time and fail from either `reserved` or `interpreting`. Task/profile-scoped reservation + scheduler-key auth/CI coverage is the single in-flight slice.
- Direct runtime: L2 2,511 `layer3_required`; L3 work 10 `layer4_required` + 1 `parked`; L4 pending 59; Evidence 32,040; admissions 1,216; fees 79,730; Search 33,105. Deployed Edge versions remain benchmark v11, interpreter v5, dispatcher v4.
- No provider/model call, deployment, queue mutation, canonical admission or Search/API delta occurred. **NO DATA ADMISSION PROVEN.**
- Enabled hourly `CF-247 Gitar Closure` as manual-idle failover; older overlapping CF tasks remain paused. Next gate: finish dispatcher slice, then benchmark-version binding and deterministic admission before bounded runtime proof.

## 21 September 2026 14:05 AEST — bounded execution update

- Critical-path movement: completed dispatcher/reservation runtime closure.
- Pilot PR #99 exact head: `c8866b573480b337ed86494f9817c98c69629c79`; draft/open/mergeable; Gitar review 5/5 closed.
- CI: Pilot Frontend Build `35555931223/#2479` PASS; Release History Contract `35555931237/#157` PASS.
- Deployed: migration `20260921040446_cf247_task_profile_scoped_reservation`; `layer3-work-dispatch` ACTIVE v5, hash `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`.
- Contract proof: exact task/profile scoped reservation; profile eligibility rechecked under lock; legacy global reservation retired; ACL only postgres/service_role; one-at-a-time dispatch with 240 s total budget, 110 s call timeout and interpreting-status fallback.
- Live queue: 10 `layer4_required`, 1 `parked`; target unchanged at parked/attempt 6/unreserved. Retry burn 0.
- Data/resource telemetry: Evidence 32,040; course fees 79,730; live calls 0; benchmark calls 0; input/output tokens 0/0; cost USD 0; max live latency 0 ms. Storage/CPU/memory remain unavailable.
- Admission/canonical/Search/API delta: none proven.
- Next action: benchmark binding slice only. No parked-item retry or new cohort.

### Migration-ledger reconciliation — 21 September 2026 14:12 AEST

Gitar aligned the repository migration filename to the already-applied Pilot ledger without changing SQL bytes. PR #99 exact head is now `e7b6d5b3ab345511c99fa66e35e65b89fab4d581`; Pilot Frontend Build `35560006737/#2480` and Release History Contract `35560006759/#158` both PASS. Repository file `20260921040446_cf247_task_profile_scoped_reservation.sql` now matches runtime migration `20260921040446`. Dispatcher v5/hash, queue counts and zero-call telemetry are unchanged. Slice 2 remains closed; slice 3 benchmark binding is next.


### CF-247 Slice 3A1 — 21 September 2026 15:00 AEST

PR #99 remains draft and mergeable at exact head `d3e48fa6c33cbe03cec66f3af0d3e3df50686a66`. Gitar added only the shared strict tuition response-schema export, stable candidate-validator/schema contract identifiers, and deterministic assertions in the existing required contract test. Independent diff review confirmed two files changed and no validator behaviour, benchmark execution, migration, dispatcher, interpreter, admission, Layer 4 or Search authority changed. Exact-head Pilot Frontend Build `35562558006/#2481` and Release History Contract `35562557856/#159` PASS.

This is repository/contract foundation only; it is not a runtime deployment or DATA ADMISSION. Pilot remains: dispatcher ACTIVE v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`; interpreter ACTIVE v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`; tuition benchmark ACTIVE v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. Runtime is unchanged at 10 Layer-4-required + 1 parked; target `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` remains parked at attempt 6; Evidence 32,040; course fees 79,730. No provider call, retry, canonical or Search/API delta was caused by this slice.

Next executable unit is Slice 3A2 only: make the tuition benchmark consume the shared schema/validator and align positive/null fixtures to single-target candidate-bound semantics. Do not start binding persistence/predicate work, retry the parked item, run a benchmark, create a cohort or expand Layer 2 in that unit.

### CF-247 Slice 3A2a — 21 September 2026 17:08 AEST

PR #99 remains draft at exact head `59b7a0759d5e87a709c47586f17ed952fa12f7a0` ([commit](https://github.com/msinghbs-ai/Coursefinder-Pilot/commit/59b7a0759d5e87a709c47586f17ed952fa12f7a0)). After the prior Gitar stop, a narrower, independently verified unit replaced only the benchmark's duplicate response schema with the shared schema export and added a deterministic source assertion; two files changed. Gitar's local contract/build passed; exact-head Pilot Frontend Build `35571407034/#2482` and Release History Contract `35571407041/#160` both PASS. No deployment or benchmark execution. Pilot functions remain dispatcher v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`, interpreter v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`, benchmark v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. Fresh queue read: 10 `layer4_required`, 1 `parked`; bounded item remains parked at attempt 6. No provider call, retry or admission was triggered; fresh broader resource, canonical and Search/API counts were not measured. **NO DATA ADMISSION PROVEN.** Next run: complete 3A2 shared-validator adoption and candidate-bound control fixtures only, then independently verify exact-head CI. Binding persistence/predicate remains 3B; do not retry the parked item, benchmark or expand L2.

### 21 September 2026 20:04 AEST — verified repository movement

PR #99 draft/mergeable head `463821f178ff3d79f3888b0d65f6b6227c08469d`; fixture repair `1c309f9` and transport-inconclusive review correction `463821f` passed exact-head Frontend Build `35581451411/#2484` (CF-247 contract + smoke) and Release History Contract `35581451463/#162`. Pilot queue remains 10 Layer-4-required + 1 parked. Deployed functions unchanged: dispatcher v5 `f72a0194…`, interpreter v5 `13c1aeea…`, benchmark v11 `ac0a1e6d…`. No benchmark, provider call, retry or admission was initiated in this run. Fresh provider usage, Evidence, canonical and Search/API totals were not measured. Next: 3A2d known-positive provider scoring only, then 3B version binding; no bulk drain.


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
