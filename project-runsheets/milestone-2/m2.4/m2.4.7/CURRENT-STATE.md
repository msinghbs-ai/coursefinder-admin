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
