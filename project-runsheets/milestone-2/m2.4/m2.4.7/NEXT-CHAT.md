# M2.4.7 NEXT CHAT

Start from repository/runtime truth under `PROJECT_INSTRUCTIONS.md`, `docs/README.md`, CF-CHG-20260915-247 and this directory. M2.4.7 remains Gate D; no larger L2 wave is authorised until bounded L3 drain is proven.

## Current critical-path truth

Pilot PR #99 branch `cf-247-candidate-bound-layer3` exact head is **`f6c5ab09253f6faa29e4149666c940c6363ccd4f`**. The previously applied `cf_247_service_owned_layer3_work_reservation` bridge remains authoritative: service-role-only reservation loads persisted immutable `candidate_context`, retained Evidence and benchmark-qualified profile and transitions the durable item `reserved → interpreting`.

Because replacing the existing curator/manual `layer3-interpret` implementation in-place through the available contents API would have required a high-risk full-file rewrite, the anti-loop alternative was executed: a bounded repository-owned **`supabase/functions/layer3-work-interpret/index.ts`** service worker was added at `f6c5ab09...` and deployed to Pilot runtime as Edge Function **`layer3-work-interpret` v1**. It accepts only `work_item_id + worker`, authenticates the service-role bearer itself, calls `layer3_reserve_work_interpretation_service`, consumes only persisted candidate context, adds `tuitionValidationPromptContext`, permits only `provider_current_tuition_validation`, downloads retained Evidence, enforces quote presence, calls the qualified profile under RPM/day/cost controls, applies `validateProviderCurrentTuitionCandidate`, requires explicit Evidence support for any ambiguous-basis resolution, persists through `layer3_complete_interpretation_service`, and transitions the durable work item to `validated`, `no_candidate`, `rejected`, or retryable `failed`. Existing curator/manual `layer3-interpret` is unchanged.

Runtime deployment is active with custom service-role authentication (`verify_jwt=false` only because the function body requires the exact server service-role bearer; no anonymous execution path exists). Exact-head Pilot Frontend Build run **35218231587 / #2451** was in progress at handoff; do not accept this head until it completes successfully and required UAT is checked.

Qualification remains fail-closed. Latest trusted candidate benchmark remains request 6326: provider 0/4, controls 4/4, 9 calls, 12,807 input + 1,247 output, USD 0, max 10.133s. Diagnostic 6327 showed the prior UQ positive snapshots do not explicitly support annual/indicative-annual basis adjacent to the fee, so correct benchmark corpus semantics rather than weaken the validator.

Latest trusted lifecycle baseline before this implementation remains 2,511 `layer3_required` / 2,423 `resolved_l2` / 815 cancelled / 10 blocked; L3 queue 0; Evidence 30,925. Refresh before reporting these as current. **NO DATA ADMISSION PROVEN**.

## Exact continuation sequence

1. Resolve exact-head CI **35218231587** and required UAT for `f6c5ab09...`; inspect the exact PR diff. Fix only bounded implementation/CI defects.
2. Add the durable server dispatcher that calls `layer3_reserve_work_service(worker,limit)` and invokes deployed `layer3-work-interpret` for each reserved item. Preserve benchmark/profile/RPM/day/cost/retry/stale controls and service-role boundaries. Repository-back and deploy it, then exact-head CI/UAT again.
3. Correct the tuition qualification corpus to Evidence that explicitly supports the governed candidate basis; rerun one semantic+safety qualification. Do not annualise, infer or weaken candidate/Evidence authority.
4. Only on full PASS unpause the tuition profile, enqueue/dispatch 10–25 existing Evidence-backed items and capture M247-FU-021 proof across L2 before/after, L3 create/reserve/result, deterministic admission/L4, canonical delta, Search/API projection/no-op, Evidence lineage, failures/retries, calls/tokens/cost/latency and resource/quota headroom.
5. Without that proof report **NO DATA ADMISSION PROVEN**. Normal AU/NZ admission scheduling resumes only after bounded end-to-end drain is demonstrated.

M247-FU-020/021/022 and the anti-loop rule remain mandatory.
