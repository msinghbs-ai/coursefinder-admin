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
