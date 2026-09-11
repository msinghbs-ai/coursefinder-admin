# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE / PARTIAL PASS — TARGET BUILDER CODEX ACCEPTANCE  
**Initiated:** 2026-09-10 AEST  
**Updated:** 2026-09-11 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot baseline:** `643eef810ab10ab9679ab6687ee549b0664c5691` / visible v2.15.77  
**Active Pilot PR:** #69 (`m245/cf093-target-builder-20260911`)

## Objective

Provide one task-first Scheduled Tasks control plane that can progressively build governed ingestion/enrichment work without collapsing CourseFinder layer authority. Human business labels remain primary; technical IDs remain audit/support detail.

Target operator model:

`Job / Dataset -> Country -> Scope Type -> Target -> Processing Mode -> Preview -> Run now / Schedule`

## Phase A — operator catalogue and existing-policy control — PASS

Functional PR #67 and release-currentness PR #68 are accepted.

Accepted results include business-readable Scheduled Tasks labels, server-side search, durable creator/owner attribution, personal column preferences, audited bounded schedule edit, exact bounded Layer 1–2 Run on demand, Layer 3 Evidence/profile/model/revalidation governance and explicit Jobs/Evidence follow-through.

Acceptance evidence for v2.15.77:

- PR #67 merge `912572203e4f53ac081617b0ea567c9298cab84d`; post-merge Release History `34550482710`, Frontend Build `34550482729`, Deployed UAT `34550482733` — PASS.
- PR #68 release merge `643eef810ab10ab9679ab6687ee549b0664c5691`; Release History `34553234972`, Frontend Build `34553235073`, Deployed UAT `34553235214` — PASS.

## Phase B — new governed target builder — ACTIVE

### Runtime inventory decision

The existing generic `refresh_policy_upsert_v2` is **not** accepted as a universal target constructor. It checks that a bounded identifier exists but does not prove that a selected country/state/provider scope is qualified or enforced by the downstream worker. Exposing it generically would risk a UI scope claim that runtime dispatch does not honour.

The existing Layer 2 Course Facts service boundary already provides server-authorised Country/State/University scope resolution, preview and execution. CF-093 therefore starts with that proven path rather than manufacturing a browser-side scope model.

### Applied Pilot migration identities

The following runtime identities are APPLIED and immutable in repository history:

1. `20260911021144 cf_093_scheduler_workflow_builder_slice` — initial AU Course Facts target-builder slice.
2. `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix` — authenticated EXECUTE restored on independently rank-gated private bridges; anon denied.
3. `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency` — server preview receipt, zero-work rejection, v1 run retirement and exact-target v2 dispatch.
4. `20260911023721 cf_093_scheduler_workflow_codex_second_pass` — dispatch-time dedupe, current-profile-version qualification and canonical country scope.
5. `20260911025332 cf_093_scheduler_workflow_codex_third_pass` — dispatch-time live-scope revalidation.
6. `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass` — cross-operator exact-scope dispatch dedupe plus atomic empty-start rejection.
7. `20260911052952 cf_093_scheduler_execution_policy_qualification` — first fail-closed execution-policy qualification introduced after nominated queueable acceptance exposed a missing policy.
8. `20260911065626 cf_093_scheduler_policy_and_scope_limit_qualification` — extends execution-policy qualification to discovery-backed profiles and fails closed if any scoped profile exceeds the existing 1,000-course downstream contract.

### Current executable capability

- **Dataset:** Course Facts enrichment.
- **Country:** AU only.
- **Scope:** Country, State/Territory, University/Provider through existing server-authorised scope services.
- **Processing mode:** Acquisition + deterministic Layer 2 only.
- **Preview:** required server-side before consequential dispatch, actor-bound, exact-target/mode-bound and valid for 15 minutes.
- **Profile qualification:** scoped enabled/non-paused Course Facts profiles must retain valid current versions at preview and dispatch.
- **Execution-policy qualification:** every scoped Course Facts profile must have the deterministic Layer 2 execution policy before acquisition/dispatch, including discovery-backed profiles because successful discovery auto-syncs into `layer2_run_batch_create`.
- **Scope-size qualification:** preview and dispatch fail closed if any scoped profile contains more than 1,000 courses, matching the current downstream service/batch array limit instead of exposing a scope that is guaranteed to fail later.
- **Live runnable-scope revalidation:** dispatch rechecks authoritative Layer 2 work before start.
- **Atomic empty-start guard:** if runnable membership changes between the live preview and `start`, an empty `profiles` result raises within the same transaction so start-side effects roll back and the preview is not consumed as a successful no-op.
- **Executable-work guard:** zero queueable/discovery work is non-executable.
- **Country canonicalisation:** country scope rejects non-null target IDs.
- **Run:** v2 exact-target dispatch requires preview token and governance reason.
- **Idempotency:** the exact-target advisory lock serialises dispatch. Preview-token ownership remains actor-bound, but successful recent exact-scope dispatch reuse is operator-independent so two rank-4 operators cannot independently submit duplicate paid acquisition for the same target. The reuse window is measured from actual `consumed_at` time.
- **Truthful Job semantics:** the completed record is the preview operation; underlying Layer 2 batch/discovery records remain authoritative for processing status.
- **UI race safety:** preview and dispatch have separate state; target edits cannot unlock an active dispatch.
- **UI rank parity:** rank <4 remains read-only; server bridges independently rank-gate execution.

The old browser `scheduler_workflow_run_now_v1` path is revoked. Browser execution uses `scheduler_workflow_run_now_v2` only.

### Codex review reconciliation

- Review of `216c2854...`: seven actionable findings corrected forward-only.
- Review of `fe69259a...`: five edge cases corrected by `20260911023721` plus UI state changes.
- Review of `b3203c9a...`: three P2 findings corrected by dispatch/preview state separation, rank-4 UI parity and `20260911025332` live-scope revalidation.
- Review of `1210a018db3451b31faafc14e0d0c4dfc69c9e12`: two findings corrected by `20260911031554` — cross-operator exact-scope paid-acquisition dedupe and atomic empty-start rejection.
- Exact-head review of `aae269c3c69fe3203a78f7bf5416bcf9ca3c7227`: no major issues.
- Review of `e1abc037c8c76b84639896177262470c7283df34`: two further findings — **P1** policy qualification incorrectly exempted discovery-backed profiles that later auto-sync into deterministic Layer 2, and **P2** supported scopes could exceed the downstream 1,000-course per-profile service limit. Both are corrected forward-only by `20260911065626` and targeted source/runtime acceptance.

### Nominated acceptance findings — 11 Sep 2026

Earlier nominated acceptance proved cross-operator dedupe and truthful underlying Jobs behavior using RMIT University Pathways / RMIT UP, but the resulting discovery run selected/processed zero courses and therefore did not prove Evidence production. Nova Higher Education then exposed the missing execution-policy qualification gap.

The first correction `20260911052952` blocked fully queueable profiles without policy, but Codex correctly identified that this was still too permissive: a discovery-backed profile can spend acquisition and then auto-sync into the same deterministic Layer 2 batch path that requires an execution policy.

The current correction `20260911065626 cf_093_scheduler_policy_and_scope_limit_qualification` therefore:

- requires an execution policy for **every** scoped Course Facts profile before a preview token can be issued, regardless of current discovery state;
- re-checks the same policy boundary immediately before dispatch;
- adds private helper `security.scheduler_workflow_oversized_profile_count_v1` and blocks preview/dispatch when one profile exceeds 1,000 scoped courses;
- preserves private-helper ACLs, public SECURITY INVOKER wrappers and independent rank checks;
- does not alter Layer 1 authority, Layer 3 Evidence/profile/model governance, Layer 4 human resolution, Search/Publication separation or any unsupported generic processing mode.

Runtime proof after the fifth pass:

- RMIT UP now has `rmit_up_policy_gaps=1`; it is correctly blocked before paid discovery can be spent against a profile that cannot complete deterministic Layer 2.
- Nova has `nova_policy_gaps=1` and remains blocked.
- AU has `au_oversized_profiles=0`; maximum current Course Facts profile scope is 665 courses. The >1,000 fail-closed rule is nevertheless required because Country/State/University are supported scope types and the downstream contract rejects larger arrays.
- Pilot Security Advisor remains **191 INFO / 0 WARN / 0 ERROR**, unchanged known `rls_enabled_no_policy` baseline.

Current Pilot candidate is `f01ef66437864db5b0d2f5a319ab7a80bb6f0073`.

- Release History Contract `34572186142` — **PASS**.
- Pilot Frontend Build `34572186144` — **PASS**.
- Fresh exact-head Codex re-review requested in PR #69 comment `5630709016` after both findings were replied to and resolved.

Runtime inventory confirms the large majority of enabled Course Facts profiles currently lack `pipeline.layer2_execution_policies`; no policy is being manufactured solely to make UAT pass. Final consequential Job/Evidence acceptance must use a profile already governed with a valid policy or configure one through the normal operational control plane.

### Explicitly unavailable

- NZ Layer 2 Course enrichment;
- generic automatic L2 -> L3 -> L4 orchestration;
- generic Layer 3 Evidence reprocess;
- arbitrary Layer 1 target construction;
- country/state recurring schedule creation;
- university recurring schedule creation until a verified one-profile resolver/constructor is accepted;
- implicit Search/Publication actions.

## Preserved authority / security rules

1. Layer 1 identity and publisher/regulatory authority are never redefined by L2/L3 shortcuts.
2. Layer 2 remains deterministic source/Evidence acquisition under qualified source profiles and governed execution policy.
3. Layer 3 can execute only through accepted Evidence/profile/model/revalidation controls.
4. Layer 4 remains audited human/exception resolution.
5. Scholarship Provider ownership never manufactures Course eligibility.
6. Browser execution uses authenticated public wrappers only; private bridges independently rank-gate Pipeline Operator access.
7. No browser service-role/provider secret/private Evidence exposure is allowed.
8. Unsupported scope or processing mode must fail closed and remain visibly unavailable.
9. Search/Publication remain separate downstream governed consequences.
10. Applied migration identities are never retimestamped; corrections use forward migrations.

## Active acceptance gate

Do not merge PR #69 or bump the visible release until current exact-head Codex re-review and targeted acceptance are green.

Required before merge:

1. exact-head Codex review has no actionable finding;
2. repository/runtime migration history remains aligned;
3. targeted source/browser acceptance remains green;
4. negative anonymous/low-rank/unsupported mode and invalid/expired/mismatched preview paths pass;
5. one AU Layer 2 target with valid profile version and execution policy proves preview -> dispatch -> Layer 2 Job/Evidence follow-through under the current fail-closed scope limit;
6. no generic Layer 3/Layer 4/Search/Publication activity is manufactured;
7. only after functional acceptance, publish the next visible release;
8. post-merge deployed UAT/security/currentness reconciliation.

## Rollback / recovery

- Do not delete, rewrite or retimestamp applied identities `20260911021144`, `20260911021847`, `20260911022312`, `20260911023721`, `20260911025332`, `20260911031554`, `20260911052952` or `20260911065626`.
- UI target-builder changes can be reverted independently while retaining accepted v2.15.77 Phase A.
- If a scope cannot be proven server-enforceable, disable/remove it rather than weakening worker/security contracts.

CF-093 remains **OPEN** until the governed target-builder phase reaches its accepted boundary. Broader generic cross-layer orchestration remains separately gated and is not claimed by this slice.
