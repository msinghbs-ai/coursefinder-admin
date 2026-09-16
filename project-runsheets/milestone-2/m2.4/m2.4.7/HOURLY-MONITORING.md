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
- Pilot frontend/deployed-UAT workflows started on exact commit. Direct Supabase deployment attempt from this execution environment was blocked by tool safety enforcement, so runtime remains on Edge v1 pending the normal repository/deployment path or a later permitted deployment. This is a tool-execution boundary for this cycle, not authority to bypass deployment controls.
- No new model call was intentionally consumed and no benchmark rerun was launched because corrected worker is not yet deployed. Runtime/admission/Search/API deltas remain unclaimed; last authoritative backlog remains **2,402 layer3_required / 2,281 resolved_l2 / 815 cancelled / 10 blocked**, L3 queue empty.
- Exact next action: require exact-head CI/UAT green, deploy the repository-owned worker v1.1 through an allowed path, rerun the verified 4+4 benchmark once, and only on full PASS unpause/enqueue a bounded cohort. No larger L2 wave before end-to-end proof.

## 2026-09-16 04:41 UTC — worker v1.1 deployed; benchmark rerun started

- Reconciled Pilot main `fa612605f72bd19dd3288c8869b5bec80c6563b3`. Frontend build completed successfully. Deployed-UAT run `35053817695` failed on an existing Layer 3 UI locator strictness defect: the source-pattern article locator now matches 51 nested articles; the checked-in Layer 3 contract test itself passed. This failure does not evidence a benchmark-worker semantic or security regression and is tracked as a targeted UAT-contract/UI-locator defect, not authority to weaken runtime controls.
- Deployed repository-owned `layer3-cf245-tuition-benchmark` **v2 / worker `cf247-tuition-benchmark-v1.1.0`** to Pilot Supabase with the same established nonce-based custom-auth design (`verify_jwt=false` retained because the function consumes a one-time server nonce). Runtime source now matches Pilot repository semantics.
- Triggered exactly one verified 4-positive + 4-control benchmark through governed `pipeline.svc_pilot_submit_nonce`; pg_net request **6257** accepted. Result was still in flight at observation cutoff, so profile remains paused and no second benchmark was launched.
- Runtime backlog remains **2,402 layer3_required / 2,281 resolved_l2 / 815 cancelled / 10 blocked**; no L3 queue/admission/Search/API delta claimed. Last completed profile benchmark remains FAIL until request 6257 records its result.
- Exact next action: observe request 6257/profile result. On full provider+control PASS, unpause the tuition profile and enqueue only a bounded Evidence-backed cohort; otherwise inspect only failed semantic cases. Separately repair the stale/nested deployed-UAT locator without blocking the end-to-end data path unless it reveals a real runtime defect.
