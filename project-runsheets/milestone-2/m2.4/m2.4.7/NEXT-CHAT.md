# M2.4.7 NEXT CHAT

Start from repository/runtime truth. Follow `PROJECT_INSTRUCTIONS.md`, `docs/README.md`, `docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md`, `CF-CHG-20260915-247`, then this directory.

## Accepted predecessor

- M2.4.6 / CF-246: CLOSED / PASS / FROZEN;
- accepted Pilot predecessor: `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`;
- Pilot Supabase: `fxcwkweaxjtknorudmwp`;
- Production remains unprovisioned; M2.5 remains paused until M2.4.9 GO.

## Programme objective

The outcome is not parser count, scheduler activity, CI success or `layer3_required`. The outcome is:

`Source → L1 authority → L2 acquisition/Evidence/deterministic extraction → automatic L3 interpretation → deterministic admission or L4 exception → Search/API projection → live Admin telemetry`.

Do not big-bang refactor accepted components and do not launch larger L2 waves merely to enlarge an undrained backlog.

## Current critical-path truth

M2.4.7 remains on Gate D. Durable Layer 3 queue primitives and immutable tuition `candidate_context` handoff are deployed. Latest trusted lifecycle baseline remains 2,511 `layer3_required` / 2,423 `resolved_l2` / 815 cancelled / 10 blocked; L3 work queue 0; Evidence 30,925. Refresh before calling these current.

Pilot PR #99 branch `cf-247-candidate-bound-layer3` is now at exact head **`2546ccbaee02b2fa2528353bf6a465cf889dde28`**. The shared tuition validator was corrected to match the real runtime candidate shape (`currency_code`, nullable `fee_year`, `audience`) and to permit only the explicitly governed basis resolution `annual_or_indicative_requires_validation → annual|indicative_annual`; amount/currency/year/audience remain immutable and all other basis expansion remains rejected. Contract tests were expanded accordingly.

A new forward-only repository/runtime bridge is applied: migration `cf_247_service_owned_layer3_work_reservation` / repository file `20260917170500_cf_247_service_owned_layer3_work_reservation.sql`. `public.layer3_reserve_work_interpretation_service(work_item_id,worker)` is service-role-only, requires an already-reserved durable work item, validates reservation ownership, retained Evidence and benchmark-passed executable profile, loads persisted `candidate_context` server-side, creates the Layer-3 interpretation audit row with `requested_by=null`, and atomically moves the work item from `reserved` to `interpreting`. Browser-supplied candidate context is not trusted.

Exact-head Pilot Frontend Build **35214792902 / #2450 = PASS** for `2546ccba...`.

Qualification history remains fail-closed:

- request 6324: FAIL provider 0/4, controls 2/4, 13 calls, 18,799 input + 610 output, USD 0, 6.609 s max;
- request 6325: transport regression, FAIL provider 0/4, controls 0/4;
- request 6326 after strict-schema restoration: FAIL provider 0/4, controls 4/4, 9 calls, 12,807 input + 1,247 output, USD 0, 10.133 s max;
- zero-call Evidence diagnostic 6327 confirmed all four UQ snapshots contain the amount, 2027 context and international-course context, but the rendered fee block is `Fees A$...` without an explicit annual/indicative-annual label adjacent to the amount. Do not weaken the validator to force these positives.

The remaining Gate-D implementation is now narrow and explicit: update `layer3-interpret` so a service-owned invocation takes `work_item_id` + reservation worker, calls `layer3_reserve_work_interpretation_service`, consumes only the returned persisted `candidate_context`, adds `tuitionValidationPromptContext`, validates the model result with `validateProviderCurrentTuitionCandidate`, and transitions the durable work item according to the persisted interpretation result. Preserve the existing curator/manual path unchanged. Then add the durable server dispatcher that reserves work and invokes this service-owned interpreter path.

## Mandatory scheduled-execution invariant

M247-FU-020/021/022 remain mandatory:

1. after minimum reconciliation, execute the carried-forward critical-path action;
2. do not rediscover a known blocker;
3. implementation/qualification progress is separate from data admission;
4. DATA ADMISSION requires authoritative before/after proof across L2, L3, deterministic admission/L4, canonical delta, Search/API and Evidence/model/resource telemetry;
5. otherwise state **NO DATA ADMISSION PROVEN**;
6. one non-advancing run without hard blocker forces a different executable approach; two is `SCHEDULER EXECUTION FAILURE`.

## Exact continuation sequence

1. **First operation:** implement the service-owned `layer3-interpret` work-item path on top of exact-head PASS `2546ccba...`, importing the shared CF-247 tuition validator/prompt context. The service path must obtain candidate context only from `layer3_reserve_work_interpretation_service`; no request-body candidate context is authoritative.
2. Add/complete the server-owned dispatcher: reserve via `layer3_reserve_work_service`, invoke the service-owned interpreter for each reserved work item, and persist work-item transitions/failures/retries. Respect profile benchmark, RPM/day, cost, retry and stale-reservation controls.
3. Run exact-head CI/UAT and one corrected candidate+Evidence qualification. The current UQ benchmark corpus may be unsuitable for asserting basis semantics when the retained snapshot does not explicitly state annual/indicative basis near the fee. Correct corpus semantics rather than relaxing the validation policy.
4. Only on full semantic+safety PASS unpause the tuition route and enqueue/dispatch 10–25 existing Evidence-backed tuition items. Capture M247-FU-021 proof: L2 before/after; L3 create/reserve/result; admitted/L4; canonical field delta; Search/API projection/no-op; Evidence lineage; failures/retries; calls/tokens/cost/latency; resource/quota headroom.
5. Only after bounded end-to-end proof establishes non-zero throughput may normal AU admission scheduling resume and backlog-clearance ETA be calculated.

**Proof classification at this handoff:** IMPLEMENTATION ADVANCEMENT; **NO DATA ADMISSION PROVEN**.
