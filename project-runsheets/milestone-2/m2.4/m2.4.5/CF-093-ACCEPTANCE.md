# CF-CHG-20260910-093 Acceptance

**Status:** REOPENED — SOURCE/RUNTIME RECONCILIATION PASS; CONSEQUENTIAL ACCEPTANCE BLOCKED  
**Updated:** 12 Sep 2026

## Accepted deployed/repository state

- Functional target-builder PR #69 merged as `85bc068d379ed3fc9231d167cf524e56419e80f9`.
- Release-currentness PR #70 merged as `cfc4702ba57a58ea31936dcabbd96fdd765194e2`; visible PIM Admin release remains **v2.15.78**.
- Corrective PR #71 exact clean head `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575` merged to Pilot `main` as **`63c7107cfce2d8f607fc378af4881d0ba28ca879`** solely to reconcile repository source with already-applied Pilot runtime migrations and maintained UAT contracts.
- PR #71 introduced no browser UI source change and no new runtime authority; no visible release bump was required for that reconciliation merge.
- Post-merge Pilot Frontend Build **`34655200676` — PASS**.
- Post-merge CourseFinder Deployed UAT **`34655200754` — PASS**; targeted desktop governed validation passed and the mobile gate was intentionally skipped by targeted-tier routing.
- Cloudflare Workers build **`50ce255a-8c17-4319-a649-ef2113178254` — PASS**, Worker version **`529075ea-affa-4a5e-951a-15e53689c8e2`**.
- Security Advisor remains the known **191 INFO / 0 WARN / 0 ERROR** baseline.

## Accepted authority boundary

The executable contract remains deliberately narrow:

- AU Course Facts only;
- Acquisition + deterministic Layer 2 only;
- mandatory actor-bound server Preview and exact dispatch revalidation;
- valid profile version, deterministic execution policy, bounded scope and runtime-usable route/credential/budget/cost/URL qualification;
- authenticated rank-4 browser execution; private helpers remain protected;
- Layer 1 identity authority unchanged;
- Layer 2 Jobs/Evidence remain processing truth;
- Layer 3 remains Evidence/profile/model/revalidation governed;
- Layer 4 remains audited human/exception resolution;
- Search and Publication remain separately governed downstream boundaries.

Generic asynchronous discovery-backed Scheduled Tasks remain **disabled/fail-closed** until a separately accepted Preview-bound async worker payload/continuation contract exists. Generic L3/L4 orchestration, Evidence reprocess, NZ Layer 2 Course enrichment, arbitrary Layer 1 construction, recurring country/state construction, unsupported recurring university construction and implicit Search/Publication remain disabled.

## Immutable corrective runtime lineage

Applied Pilot migrations are immutable and now represented in Pilot `main` source:

1. `20260911021144 cf_093_scheduler_workflow_builder_slice`
2. `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix`
3. `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency`
4. `20260911023721 cf_093_scheduler_workflow_codex_second_pass`
5. `20260911025332 cf_093_scheduler_workflow_codex_third_pass`
6. `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass`
7. `20260911052952 cf_093_scheduler_execution_policy_qualification`
8. `20260911065626 cf_093_scheduler_policy_and_scope_limit_qualification`
9. `20260911085724 cf_093_scheduler_postmerge_codex_finalizer`
10. `20260911095142 cf_093_scheduler_exact_scope_codex_finalizer`
11. `20260911095420 cf_093_scheduler_runtime_route_credential_finalizer`
12. `20260911103931 cf_093_scheduler_runtime_semantics_finalizer`
13. `20260911105517 cf_093_scheduler_browser_bridge_and_scope_binding_finalizer`
14. `20260911111431 cf_093_scheduler_query_binding_and_ipv4_finalizer`
15. `20260911114056 cf_093_scheduler_discovery_failclosed_and_runtime_parser_finalizer`
16. `20260911120131 cf_093_scheduler_operator_reason_and_route_chain_finalizer`

No applied migration was rewritten or retimestamped. Stale pre-apply filename aliases were removed before merge without changing runtime semantics.

## Codex / targeted evidence

- Exact corrective head before merge: `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575`.
- Pre-merge Pilot Frontend Build `34597632959` — **PASS**.
- Exact-head Cloudflare preview — **PASS**.
- Exact-head Codex comment `5634309865` — **“Didn't find any major issues.”**
- Post-merge build/UAT/Cloudflare evidence above confirms the source/runtime reconciliation is accepted.

## Runtime consequential-target truth

Current runtime does **not** provide a legitimate target for the final consequential acceptance gate:

- RMIT University: **500 total / 261 queueable / 239 discovery**; has a governed execution policy but remains discovery-backed and therefore intentionally non-executable through generic Scheduled Tasks.
- University of Queensland: **382 / 156 / 226**; has a governed execution policy but remains discovery-backed and intentionally non-executable.
- Nova Higher Education: **1 queueable / 0 discovery**, route/oversize gaps 0, but **execution-policy gap 1**; profile is qualification-only under earlier source-qualification governance.
- Stamford International College: **1 queueable / 0 discovery**, route/oversize gaps 0, but **execution-policy gap 1**; profile is qualification-only under earlier source-qualification governance.
- Every inspected AU State/Territory scope remains discovery-backed and contains execution-policy gaps.

No execution policy, source profile, route or runtime configuration may be manufactured merely to force this acceptance gate green.

## Historical consequential evidence retained

Earlier UQ execution evidence remains retained for audit only: primary preview/dispatch token `18a3784a-1e2d-4c73-9d91-0b3ea04f7b30`; second preview `29df92d3-9071-4e6e-92db-0bc5b9daa111`; scope `e55396d2-869a-46ef-9d17-841c7eab1313`; profile `c7976665-14f3-40ac-834b-a8ee1c8afc32`; profile version `9b3689b8-0d2a-4cde-a50f-b4fee4c06945`; Layer 2 request `5727`; representative Job `3445bc7a-0495-4c96-9321-43e581c81742`; HTML Evidence `8738fcf9-a4e6-47ac-9880-a57e4405b42b`; extraction-input Evidence `1d06a4ff-52aa-4a68-8e89-b661c7903e1f`.

This historical evidence does not prove the now-disabled generic async discovery contract.

## Current closure gate

CF-CHG-20260910-093 remains **REOPENED**:

1. exact-head Codex review — **PASS**;
2. exact-head targeted CI/source/runtime validation — **PASS**;
3. repository/runtime reconciliation merge — **PASS**, Pilot main `63c7107c...`;
4. post-merge Frontend Build — **PASS**, `34655200676`;
5. post-merge deployed UAT — **PASS**, `34655200754`;
6. post-merge Cloudflare Worker build — **PASS**, `50ce255a-8c17-4319-a649-ef2113178254`;
7. consequential Preview → dispatch → dedupe/Jobs/Evidence acceptance on a genuinely governed policy-qualified fully queueable deterministic Layer 2 target — **BLOCKED BY CURRENT RUNTIME TRUTH**.

Only item 7 remains open. The feature must not be returned to CLOSED/PASS until that gate is legitimately satisfied or a separately governed substantive design decision replaces it. This blocker does not authorise fabricated configuration or weaker authority/security/UAT controls.
