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
7. `20260911052952 cf_093_scheduler_execution_policy_qualification` — fail-closed qualification for fully queueable profiles that lack the execution policy required by `layer2_run_batch_create`; preview and dispatch both re-check the boundary.

### Current executable capability

- **Dataset:** Course Facts enrichment.
- **Country:** AU only.
- **Scope:** Country, State/Territory, University/Provider through existing server-authorised scope services.
- **Processing mode:** Acquisition + deterministic Layer 2 only.
- **Preview:** required server-side before consequential dispatch, actor-bound, exact-target/mode-bound and valid for 15 minutes.
- **Profile qualification:** scoped enabled/non-paused Course Facts profiles must retain valid current versions at preview and dispatch.
- **Execution-policy qualification:** a fully queueable profile must have a Layer 2 execution policy before a preview token is issued; discovery-backed profiles remain eligible because their start path does not call `layer2_run_batch_create`.
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
- Exact-head review of `aae269c3c69fe3203a78f7bf5416bcf9ca3c7227`: **no major issues**.

### Nominated acceptance findings — 11 Sep 2026

Required runtime acceptance then materially advanced the gate:

1. **RMIT University Pathways / RMIT UP** (`30b81368-9003-4775-81af-60439fc3b109`) previewed as 3 discovery-backed courses and dispatched successfully under preview receipt `e2be7de3-d9d7-4eff-b6b5-b8932e8b5f4a`, producing Layer 2 discovery request `5726`.
2. Immediate same-token retry returned `idempotent_replay=true`.
3. A second rank-4 operator obtained a fresh preview and dispatch; it returned `existing_recent_dispatch=true` and deduplicated against the first preview receipt, proving cross-operator exact-scope reuse.
4. Resulting Jobs after the nominated run were limited to `scheduler_workflow_preview` and underlying `layer2_discovery`; no generic Layer 3/Layer 4/Search/Publication Job was manufactured.
5. The RMIT discovery job completed with `selected=0 / processed=0`, so it did not by itself prove Evidence production.
6. A second one-course queueable target, **Nova Higher Education** (`340f8a84-c04e-4a7c-ad43-1b37755b0018`), previewed as executable but dispatch failed with `execution policy missing` inside `layer2_run_batch_create`.

This exposed a real qualification gap rather than a reason to weaken execution policy enforcement. The smallest-safe correction is migration `20260911052952 cf_093_scheduler_execution_policy_qualification`:

- helper `security.scheduler_workflow_execution_policy_gap_count_v1` identifies fully queueable profiles that have no `pipeline.layer2_execution_policies` row;
- helper EXECUTE is revoked from browser roles;
- preview returns `missing_execution_policy_count` and no token when the gap exists;
- dispatch re-checks the same qualification before start;
- discovery-backed profiles remain executable because their existing governed path does not require run-batch execution policy.

Post-correction runtime proof: Nova now returns `executable=false`, `preview_token=null`, `missing_execution_policy_count=1`; RMIT UP remains executable with `missing_execution_policy_count=0`.

Current Pilot candidate is `e1abc037c8c76b84639896177262470c7283df34`.

- Release History Contract `34566251054` — **PASS**.
- Pilot Frontend Build `34566251196` — **PASS**.
- Pilot Security Advisor after the new forward migration — **191 INFO / 0 WARN / 0 ERROR**, unchanged known `rls_enabled_no_policy` baseline.
- Exact-head Codex re-review requested in PR #69 comment `5629956836`; result pending at this governance write.

Runtime inventory also confirms there is currently **no AU Course Facts profile that is both fully queueable and backed by a `pipeline.layer2_execution_policies` row**. Final queueable Job/Evidence acceptance therefore cannot be completed without first governing/configuring an execution policy through the normal operational control plane. No policy is being manufactured purely to make UAT pass.

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
2. Layer 2 remains deterministic source/Evidence acquisition under qualified source profiles.
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
5. one queueable AU Layer 2 target with a valid execution policy proves preview -> dispatch -> Layer 2 Job/Evidence follow-through; the prior Nova target is now correctly blocked rather than allowed to fail inside `layer2_run_batch_create`;
6. no generic Layer 3/Layer 4/Search/Publication activity is manufactured;
7. only after functional acceptance, publish the next visible release;
8. post-merge deployed UAT/security/currentness reconciliation.

## Rollback / recovery

- Do not delete, rewrite or retimestamp applied identities `20260911021144`, `20260911021847`, `20260911022312`, `20260911023721`, `20260911025332`, `20260911031554` or `20260911052952`.
- UI target-builder changes can be reverted independently while retaining accepted v2.15.77 Phase A.
- If a scope cannot be proven server-enforceable, disable/remove it rather than weakening worker/security contracts.

CF-093 remains **OPEN** until the governed target-builder phase reaches its accepted boundary. Broader generic cross-layer orchestration remains separately gated and is not claimed by this slice.
