# M2.4.7 NEXT CHAT

Start from repository/runtime truth under `PROJECT_INSTRUCTIONS.md`, `docs/README.md`, CF-CHG-20260915-247 and this directory. M2.4.7 remains Gate D. Larger L2 waves remain paused until the next governed gate decision.

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
