# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** REOPENED — SOURCE/RUNTIME RECONCILIATION PASS; CONSEQUENTIAL ACCEPTANCE BLOCKER ACTIVE  
**Initiated:** 2026-09-10 AEST  
**Reopened:** 2026-09-11 AEST  
**Reconciled:** 2026-09-12 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Visible Pilot release:** v2.15.78  
**Functional merge:** PR #69 -> `85bc068d379ed3fc9231d167cf524e56419e80f9`  
**Release merge:** PR #70 -> `cfc4702ba57a58ea31936dcabbd96fdd765194e2`  
**Corrective source/runtime reconciliation merge:** PR #71 -> `63c7107cfce2d8f607fc378af4881d0ba28ca879`

## Objective and accepted narrow boundary

Provide a task-first Scheduled Tasks control plane without collapsing CourseFinder layer authority. The governed sequence remains:

`Job / Dataset -> Country -> Scope Type -> Target -> Processing Mode -> Preview -> Run now / Schedule`

The executable slice is deliberately narrow and server-enforced:

- Dataset: AU Course Facts enrichment only.
- Scope: server-authorised Country / State-Territory / University-Provider selections, executable only when all qualification gates pass.
- Processing: Acquisition + deterministic Layer 2 only.
- Preview: mandatory, actor-bound, exact-target/mode-bound and time-limited.
- Browser execution: authenticated rank-4 only; private helpers remain protected.
- Layer 1 identity/authority unchanged.
- Layer 2 remains deterministic source/Evidence acquisition under qualified profile, policy and runtime-usable route.
- Layer 3 remains Evidence/profile/model/revalidation governed and is not a generic scheduler action.
- Layer 4 remains audited human/exception resolution and is not a generic scheduler action.
- Search/Publication remain separate downstream governed consequences.
- Country/state recurring construction remains disabled; university recurrence requires a separately accepted enforceable contract.
- Generic discovery-backed dispatch remains disabled/fail-closed until a Preview-bound asynchronous payload/continuation contract is implemented and accepted.

The old browser `scheduler_workflow_run_now_v1` path remains revoked.

## Immutable Pilot runtime lineage

Applied identities are immutable; none may be rewritten or retimestamped:

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

Repository source now carries the exact applied identities. Earlier pre-apply timestamp aliases were removed without changing runtime history.

## Corrective history and Codex gate

Post-merge Codex reviews exposed defects in dedupe exactness, route/credential qualification, discovery-target selection, preview atomicity, worker budget/cost parity, URL/host parsing, post-start scope validation, browser/private bridge ACLs, discovery query binding, asynchronous Preview binding, operator reason semantics and worker-order route fallback semantics.

Corrections were applied forward-only. The final runtime/source migration `20260911120131` ensures:

- discovery-backed scopes report a truthful unsupported-discovery reason;
- deterministic provider-route qualification follows worker order/blocking/fallback semantics;
- queueable URL allowlist references are parsed literally like `layer2-acquire-v2`.

Exact corrective head `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575` passed Pilot Frontend Build `34597632959`, Cloudflare preview, and exact-head Codex review; Codex comment `5634309865` reported **“Didn't find any major issues.”**

## Source/runtime reconciliation — PASS

Pilot runtime already contained all eight post-merge forward corrective migrations through `20260911120131`, while Pilot `main` lacked those exact migration source files and two maintained CF-CHG-20260910-093 UAT contracts. Under the recovery protocol, leaving that state unmerged would preserve repository/runtime drift and weaken clean replay/recovery truth.

PR #71 therefore merged exact clean head `00c98f0cea...` to Pilot `main` as **`63c7107cfce2d8f607fc378af4881d0ba28ca879`** solely for source/runtime reconciliation. PR #71 contained no browser UI source change and introduced no runtime authority beyond what was already applied.

Post-merge evidence:

- Pilot Frontend Build `34655200676` — **PASS**.
- CourseFinder Deployed UAT `34655200754` — **PASS**; targeted desktop governed validation passed, mobile gate intentionally skipped by targeted-tier routing.
- Cloudflare Workers build `50ce255a-8c17-4319-a649-ef2113178254` — **PASS**.
- Cloudflare Worker version `529075ea-affa-4a5e-951a-15e53689c8e2`.
- Commit status `coursefinder/deployed-uat/targeted/chromium-desktop` — **success**.
- Visible release remains v2.15.78 because no browser UI source changed in PR #71.
- Security Advisor remains the known **191 INFO / 0 WARN / 0 ERROR** baseline.

This reconciliation PASS is not feature closure and does not waive consequential acceptance.

## Current runtime consequential-target truth

No legitimate final acceptance target currently exists:

- RMIT University: **500 total / 261 queueable / 239 discovery**; has a governed execution policy but remains discovery-backed and therefore intentionally fail-closed in generic Scheduled Tasks.
- University of Queensland: **382 / 156 / 226**; has a governed execution policy but remains discovery-backed and intentionally fail-closed.
- Nova Higher Education: **1 queueable / 0 discovery**, route/oversize gaps 0, but **execution-policy gap 1**; profile is qualification-only under earlier source-qualification governance.
- Stamford International College: **1 queueable / 0 discovery**, route/oversize gaps 0, but **execution-policy gap 1**; profile is qualification-only under earlier source-qualification governance.
- Every inspected AU State/Territory scope remains discovery-backed and contains execution-policy gaps.

No execution policy, source profile, route or runtime configuration may be manufactured merely to force acceptance green.

## Historical consequential evidence retained

Earlier UQ execution evidence remains audit evidence only: preview/dispatch token `18a3784a-1e2d-4c73-9d91-0b3ea04f7b30`; second preview `29df92d3-9071-4e6e-92db-0bc5b9daa111`; UQ scope `e55396d2-869a-46ef-9d17-841c7eab1313`; profile `c7976665-14f3-40ac-834b-a8ee1c8afc32`; profile version `9b3689b8-0d2a-4cde-a50f-b4fee4c06945`; Layer 2 request `5727`; representative Job `3445bc7a-0495-4c96-9321-43e581c81742`; HTML Evidence `8738fcf9-a4e6-47ac-9880-a57e4405b42b`; extraction-input Evidence `1d06a4ff-52aa-4a68-8e89-b661c7903e1f`.

This does not prove the now-disabled generic async discovery contract.

## Current acceptance/closure gate

The following are PASS:

1. exact-head Codex review;
2. exact-head targeted CI/source/runtime validation;
3. repository/runtime reconciliation merge;
4. post-merge Frontend Build;
5. post-merge deployed UAT;
6. post-merge Cloudflare deployment/currentness.

The only remaining closure gate is:

7. **Preview → dispatch → dedupe/Jobs/Evidence consequential acceptance on a genuinely governed policy-qualified fully queueable deterministic Layer 2 target — BLOCKED BY CURRENT RUNTIME TRUTH.**

CF-CHG-20260910-093 remains **REOPENED** until item 7 is legitimately satisfied or a separately governed substantive design decision replaces that requirement. This blocker does not authorise fabricated configuration, weaker Preview binding, weaker authority, weaker role/ACL controls or reduced Evidence semantics.

## Explicitly outside this Change Control boundary / still open

- NZ Layer 2 Course enrichment;
- generic automatic L2 → L3 → L4 orchestration;
- generic Layer 3 Evidence reprocessing;
- arbitrary Layer 1 target construction;
- country/state recurring target construction;
- university recurring target construction without a separately accepted enforceable contract;
- generic discovery-backed Scheduled Tasks until Preview-bound asynchronous payload/continuation verification is implemented;
- implicit Search or Publication actions.

## Rollback / recovery

- Never delete, rewrite or retimestamp applied CF-CHG-20260910-093 migration identities.
- Database corrections remain forward-only.
- If a scope cannot be proven server-enforceable, keep it disabled rather than weakening worker, identity, Evidence or authority controls.
- Applied PR #71 migration source files are immutable repository recovery history and must remain present. A semantic rollback must be implemented by a new forward-only migration and matching source/governance update; do not revert/remove the applied migration source files or rewrite runtime history.

**Current outcome:** source/runtime reconciliation is **PASS** at Pilot `63c7107c...`; the Change Control itself remains **REOPENED** solely for consequential acceptance on a legitimate deterministic Layer 2 target.
