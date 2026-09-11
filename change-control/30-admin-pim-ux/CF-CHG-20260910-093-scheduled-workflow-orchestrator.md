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
6. `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass` — cross-operator exact-scope dispatch dedupe plus atomic empty-start rejection. The repository was aligned to the runtime-assigned immutable identity; no applied migration was retimestamped.

### Current executable capability

- **Dataset:** Course Facts enrichment.
- **Country:** AU only.
- **Scope:** Country, State/Territory, University/Provider through existing server-authorised scope services.
- **Processing mode:** Acquisition + deterministic Layer 2 only.
- **Preview:** required server-side before consequential dispatch, actor-bound, exact-target/mode-bound and valid for 15 minutes.
- **Profile qualification:** scoped enabled/non-paused Course Facts profiles must retain valid current versions at preview and dispatch.
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
- Review of `1210a018db3451b31faafc14e0d0c4dfc69c9e12`: two new findings:
  1. **P1 cross-operator duplicate paid acquisition** — the recent-dispatch predicate was still actor-scoped. Corrected in `20260911031554` by keeping preview-token ownership actor-bound but removing actor filtering from recent exact-scope successful-dispatch reuse.
  2. **P2 pause/disable race after live preview** — a profile could become non-runnable between recheck and `start`. Corrected in `20260911031554` by validating the returned start `profiles` array inside the same transaction and raising on an empty result, which rolls back start-side effects.

Targeted CF-093 source tests now assert only one actor-bound `requested_by` predicate remains (the preview-token ownership check), and assert the atomic empty-start rejection. Current Pilot candidate after the test update is `aae269c3c69fe3203a78f7bf5416bcf9ca3c7227`; exact-head CI is the active gate before requesting final re-review.

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

Do not merge PR #69 or bump the visible release until current exact-head CI, exact-head Codex re-review and targeted acceptance are green.

Required before merge:

1. exact-head Codex review has no actionable finding;
2. repository/runtime migration history remains aligned;
3. targeted source/browser acceptance remains green;
4. negative anonymous/low-rank/unsupported mode and invalid/expired/mismatched preview paths pass;
5. nominated AU Layer 2 preview -> dispatch proves Jobs/Evidence follow-through and retry/dedupe without manufactured Layer 3/Layer 4/Search/Publication activity;
6. only after functional acceptance, publish the next visible release;
7. post-merge deployed UAT/security/currentness reconciliation.

## Rollback / recovery

- Do not delete, rewrite or retimestamp applied identities `20260911021144`, `20260911021847`, `20260911022312`, `20260911023721`, `20260911025332` or `20260911031554`.
- UI target-builder changes can be reverted independently while retaining accepted v2.15.77 Phase A.
- If a scope cannot be proven server-enforceable, disable/remove it rather than weakening worker/security contracts.

CF-093 remains **OPEN** until the governed target-builder phase reaches its accepted boundary. Broader generic cross-layer orchestration remains separately gated and is not claimed by this slice.
