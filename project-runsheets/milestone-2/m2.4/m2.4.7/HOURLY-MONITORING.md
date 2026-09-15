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

## 2026-09-15 11:27 UTC — durable Layer 3 queue foundation

- Implemented private `pipeline.layer3_work_items`, idempotent enqueue, bounded `SKIP LOCKED` reservation, benchmark/paused-profile guard and explicit transition service on Pilot PR #97.
- Runtime: 2,402 layer3_required; 2,281 resolved_l2; 815 cancelled; 10 blocked. L3 executions 0; provider/model usage 0 / USD 0.

## 2026-09-15 12:27 UTC — queue security/recovery hardening

- PR #97 initial build/Cloudflare PASS; Gitar found ineffective SECURITY DEFINER caller check, stale reservation recovery gap and unlimited retries.
- Corrected caller JWT/session role evaluation, 15-minute lease recovery and five-attempt parking; extended targeted UAT.
- Runtime unchanged; no L2 volume added.

## 2026-09-15 13:27 UTC — queue foundation accepted/deployed

- Pilot PR #97 merged to main as `81cfa56b5f4689b0208b3cf50dc48dec12dcd34c`; queue migration applied to Pilot runtime.
- Runtime queue initially empty by design; historical Layer 2 backlog remained 2,402 pending governed Evidence/task-class derivation.
- No AI calls/admissions/consumer delta; next unit is handoff derivation + dispatcher.

## 2026-09-15 14:27 UTC — Evidence lineage reconciled; governed handoff derivation opened

- Reconciled Pilot main `81cfa56b5f4689b0208b3cf50dc48dec12dcd34c` and live runtime.
- Runtime remains **2,402 layer3_required**, 2,281 resolved_l2, 815 cancelled, 10 blocked; Layer 3 queue empty; interpretations in prior hour 0.
- Important lineage finding: direct `evidence_artifacts.entity_id/job_id` matching is not the correct Layer 2 Evidence join for these runs. `layer2_provider_attempts` carries the authoritative raw/html/screenshot Evidence IDs. **2,178 / 2,402** current Layer 3 fall-out items have retained raw Evidence through that lineage with storage path + content hash.
- Backlog composition is predominantly tuition ambiguity: 351 multiple-equal-rank fee cases, 105 low-confidence fee cases plus further fee/no-fee variants; 1,403 rows show a generic `layer3_required` blocker and must not have a task class guessed.
- Model headroom: general free profile PASS/unpaused 20 RPM / 50 day but not tuition-authorised; source-pattern PASS 10/30; international-contact PASS 8/50. Provider-current-tuition profile remains paused + benchmark FAIL at 10 RPM / 25 day. Scholarship profiles remain paused/FAIL.
- Opened Pilot PR #98 at `896403d26231a38f4bf5b35cf9046530b944e219`: explicit service-role handoff derivation for fee-specific blockers using retained provider-attempt Evidence and only an enabled/unpaused/benchmark-PASS tuition profile. It deliberately fails closed today, so unsafe tuition AI is not executed.
- No AI/provider calls, tokens or cost this cycle; no canonical/Search/API delta. No new Layer 2 wave launched.
- Next action: get PR #98 CI/review clean; in parallel improve/benchmark the tuition task route rather than bypassing it. Once a tuition profile passes, deploy derivation and a bounded dispatcher can begin draining explicit fee cases. Generic `layer3_required` rows require explicit unresolved-field provenance before dispatch.
- No hard external API/auth/quota blocker. Active gate is internal task qualification and CI/review, not resource exhaustion.

## 2026-09-15 15:28 UTC — handoff derivation review fixes

- PR #98 original head `896403d...` Frontend Build PASS, but Gitar correctly blocked merge on two defects: provider-attempt fan-out could enqueue multiple Evidence items for one Layer 2 run item, and broad fee-candidate matching could produce a NULL reason and abort the batch.
- Corrected derivation to select exactly one latest retained Evidence attempt per run item through a lateral lookup and narrowed matching to the three explicitly governed fee blocker classes. Unknown blocker variants now fail closed instead of being guessed or aborting a batch.
- Extended targeted UAT to lock single-attempt selection and explicit taxonomy. New exact PR head `2f2cb6b5c44b0df4919ca9f1c656d6a5dbf0169c`; exact-head workflow/re-review pending at observation time.
- Runtime remains **2,402 layer3_required**, 2,281 resolved_l2, 815 cancelled, 10 blocked. No additional L2 work launched; no L3 execution/admission/consumer delta authorised while #98 is under exact-head assurance.
- Resource posture unchanged: no new model/provider calls or cost intentionally consumed. Tuition route remains benchmark-failed/paused, so even after derivation deployment it will fail closed until a task-specific profile passes.
- Next action: require exact-head CI + clean Gitar review, then merge/deploy #98 and proceed to bounded dispatcher + tuition benchmark work. No hard external API/auth/quota blocker.

## 2026-09-15 16:27 UTC — governed handoff derivation accepted/deployed

- PR #98 exact head `2f2cb6b...` passed Pilot Frontend Build; Cloudflare preview deployment succeeded; both Gitar defect threads are resolved. PR #98 merged to Pilot main as `2346fab3a018943f505656fad225b423115ce328`.
- Applied `cf_247_layer3_handoff_derivation` to Pilot Supabase. Service maps only explicit governed fee blockers, selects one latest retained Evidence attempt per L2 item, remains service-role only and requires enabled/unpaused/benchmark-PASS tuition profile.
- Runtime remains **2,402 layer3_required**, 2,281 resolved_l2, 815 cancelled, 10 blocked. Calling the deployed enqueue service correctly returned `queued=0 / no_benchmark_passed_executable_profile`; no unsafe work entered the L3 queue.
- Tuition profile remains paused/FAIL: NVIDIA Nemotron free route, 10 RPM / 25 day; prior benchmark provider cases 0/4, controls 3/4, 11 calls, 67,876 input + 1,246 output tokens, max latency 6.114 s, USD 0. This is now the immediate throughput gate for explicit fee backlog.
- No new L2 work, L3 interpretations, admissions or consumer/Search delta this cycle. No new provider/model cost incurred.
- Next action: build/execute a corrected tuition benchmark route/profile and only on PASS enable bounded dispatch; in parallel preserve explicit provenance work for the 1,403 generic `layer3_required` rows. No external API/auth/quota blocker currently observed.

## 2026-09-15 18:26 UTC — backlog decreased without Layer 3 execution; investigate before dispatch

- Reconciled Pilot main `2346fab3a018943f505656fad225b423115ce328` and live Pilot runtime. `pipeline.layer3_work_items` remains empty, so no automatic L3 queue drain has occurred yet.
- Current Layer 2 `layer3_required` count is **2,313**, down **89** from the 2,402 baseline. Current blocker composition: 1,751 generic `layer3_required`; 386 multiple-equal-rank fee; 160 low-confidence international fee; 9 no-fee; 4 domestic/CSP; 3 source-page identity mismatch.
- Current `resolved_l2` count is **1,998**. Because both `layer3_required` and `resolved_l2` counts changed while the L3 queue stayed empty, do not attribute the 89-item reduction to successful L3 admission. Runtime history/cleanup/reclassification must be reconciled before using this as an enrichment gain metric.
- Explicit ambiguous tuition work is now **546** items (386 + 160). Deterministic terminal/exception fee outcomes are 16 items (9 no-fee + 4 domestic/CSP + 3 identity mismatch) and should not consume AI quota.
- No evidence in the L3 queue of provider/model calls, tokens, cost, retries or Layer 4 creation from the new automatic path. Consumer/Search delta is therefore not claimed.
- Next action: reconcile why the L2 historical counts changed, then qualify/benchmark a tuition model and wire bounded dispatcher only for explicit Evidence-backed ambiguous tuition work. Preserve the 1,751 generic rows until explicit unresolved-field provenance exists; do not guess task class.
- No hard external API/auth/quota blocker observed. Active gate remains internal benchmark/dispatcher implementation plus runtime-history reconciliation.

## 2026-09-15 22:52 UTC — blocker and monitoring-integrity reconciliation

- Reconciled Pilot `main` `2346fab3a018943f505656fad225b423115ce328`, successful latest-head frontend build, Pilot Supabase `fxcwkweaxjtknorudmwp` ACTIVE_HEALTHY and deployed CF-247 queue/handoff functions.
- Authoritative direct-table runtime counts are **2,402 `layer3_required`**, **2,281 `resolved_l2`**, **815 cancelled**, **10 blocked**. No Layer 2 rows have been updated after 2026-09-15 08:55:35 UTC, so the 18:26 UTC 2,313/1,998 observation cannot represent a real Layer 2 state transition and must not be used as admission/throughput evidence. Monitoring-query/source reconciliation is required.
- Current `layer3_required` blocker composition: **1,780 generic**, **390 multiple-equal-rank tuition**, **208 low-confidence international tuition**, **12 no-fee**, **9 domestic/CSP**, **3 source identity mismatch**. Explicit ambiguous tuition backlog is therefore **598** items; generic 1,780 remains non-dispatchable until unresolved-field provenance is explicit.
- `pipeline.layer3_work_items` remains empty; last-hour Layer 2 work 0, Layer 3 work 0, Evidence 0. Layer 3 interpretations contain 3 historical `provider_error` rows only. Last-24h new L3 tokens/cost are 0 / USD 0; no new latency sample.
- Deployed `layer3_enqueue_eligible_layer2_service(25)` returned `queued=0`, reason `no_benchmark_passed_executable_profile`. This confirms the immediate execution blocker is the tuition-specific Layer 3 model qualification gate, not queue code, database health, API quota or authentication.
- Tuition profile `openrouter-provider-tuition-validation-v1` is enabled but paused with benchmark FAIL: provider semantic cases 0/4; controls 3/4; 11 calls; 67,876 input + 1,246 output tokens; max latency 6.114 s; USD 0; limits 10 RPM / 25 requests/day. Other PASS profiles are not authorised for tuition and must not be reused.
- No consumer/Search/API admission delta claimed this cycle. No new L2 scale wave launched.
- Next action: correct and rerun the tuition task-specific benchmark against representative retained first-party Evidence; only on semantic + control PASS unpause that profile, enqueue a bounded 10–25-item tuition cohort, execute through the server dispatcher, and verify deterministic admission/Layer 4 routing plus Search/API projection before scaling. In parallel fix the monitoring query/source that produced the false 18:26 count delta.
- No hard external API quota/auth/tool blocker is currently evidenced. Waiting on user confirmation is not required; the active blocker is internal benchmark qualification plus missing dispatcher/admission execution wiring.

## 2026-09-15 23:25 UTC — benchmark execution unblocked; benchmark corpus defect isolated

- Reconciled Pilot `main` and runtime. Latest accepted CF-247 handoff head remained `2346fab3...`; latest-head deployed UAT and frontend build are PASS. Runtime counts remain **2,402 layer3_required / 2,281 resolved_l2 / 815 cancelled / 10 blocked**, with empty L3 work queue and no consumer admission delta.
- Found the deployed one-time `layer3-cf245-tuition-benchmark` worker was omitted from `pipeline.svc_pilot_submit_nonce` allowlist. Applied forward migration `cf_247_allowlist_tuition_benchmark_nonce` and reconciled it to Pilot repo commit `188093ca...`; no auth/security bypass was introduced—the existing one-time nonce control now explicitly permits the governed benchmark worker.
- Successfully executed a fresh tuition benchmark. Result improved from controls **3/4** to **4/4**; provider semantic cases remain **0/4**. Usage: **8 calls**, **68,071 input tokens**, **1,466 output tokens**, max latency **5.794 s**, **USD 0**, exact configured NVIDIA Nemotron free model returned. Profile remains correctly paused/FAIL.
- Root cause is now isolated to the benchmark corpus/expectation, not provider availability: all four supposed positive provider cases come from `cf245_layer3_fee_validation_backlog_v1` and have expected basis `annual_or_indicative_requires_validation`. The benchmark prompt correctly requires an explicit annual/per-year basis and therefore returns `candidate_value=null`; treating these unresolved backlog rows as positive benchmark truth is contradictory. One case also produced a quote-normalisation mismatch.
- This is meaningful progress: provider access, credential, model identity, zero-cost route and all four negative safety controls are proven. Do **not** weaken the model/prompt to force these ambiguous cases positive.
- Next action: correct the benchmark positive corpus to use retained first-party Evidence with already-known/verified explicit international annual tuition truth, keep the existing ambiguous backlog rows as negative/exception controls, rerun qualification, then only on PASS unpause/enqueue a bounded cohort. Dispatcher/admission/Search proof remains pending.
- No hard external quota/auth blocker. Current resource consumption for this run is 8 of the profile's 25-request/day configured ceiling, leaving nominal 17-call headroom; the profile remains paused so operational dispatch cannot consume it.