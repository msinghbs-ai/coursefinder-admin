# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE / PARTIAL PASS — TARGET BUILDER PHASE  
**Initiated:** 2026-09-10 AEST  
**Updated:** 2026-09-11 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot baseline:** `643eef810ab10ab9679ab6687ee549b0664c5691` / visible v2.15.77  
**Active Pilot PR:** #69 (`m245/cf093-target-builder-20260911`)

## Objective

Provide one task-first Scheduled Tasks control plane that can progressively build governed ingestion/enrichment work without collapsing CourseFinder layer authority. Human business labels remain primary; technical IDs remain audit/support detail.

The target operator model is:

`Job / Dataset -> Country -> Scope Type -> Target -> Processing Mode -> Preview -> Run now / Schedule`

## Phase A — operator catalogue and existing-policy control — PASS

Functional PR #67 and release-currentness PR #68 are accepted.

Accepted results:

- business-readable Scheduled Tasks labels and technical-ID disclosure;
- server-side search before pagination;
- durable creator/owner attribution including former-user semantics;
- personal column visibility/order preferences;
- audited edit of exact bounded recurring schedules;
- exact bounded existing-policy Run on demand for Layer 1–2 without changing cadence/next-run;
- Layer 3 remains Evidence/profile/model/revalidation governed;
- Jobs/Evidence follow-through remains explicit.

Acceptance evidence for v2.15.77:

- PR #67 merge `912572203e4f53ac081617b0ea567c9298cab84d`;
- post-merge Release History `34550482710` PASS;
- post-merge Frontend Build `34550482729` PASS;
- post-merge Deployed UAT `34550482733` PASS;
- PR #68 release merge `643eef810ab10ab9679ab6687ee549b0664c5691`;
- Release History `34553234972` PASS;
- Frontend Build `34553235073` PASS;
- Deployed UAT `34553235214` PASS.

## Phase B — new governed target builder — ACTIVE

### Runtime inventory decision

The existing generic `refresh_policy_upsert_v2` is **not** accepted as a universal target constructor. It checks that a bounded identifier exists but does not prove that a selected country/state/provider scope is qualified or enforced by the downstream worker. Exposing it generically would risk a UI scope claim that runtime dispatch does not honour.

The existing Layer 2 Course Facts service boundary already provides server-authorised Country/State/University scope resolution, preview and execution. CF-093 therefore starts with that proven path instead of inventing a new browser-side scope model.

### First executable slice

Pilot runtime migration `20260911021144 cf_093_scheduler_workflow_builder_slice` is APPLIED and must remain immutable in migration history.

It adds narrow public SECURITY INVOKER wrappers with independently rank-gated private bridges for:

- `scheduler_workflow_scope_options_v1`;
- `scheduler_workflow_preview_v1`;
- `scheduler_workflow_run_now_v1`.

Current executable capability:

- **Dataset:** Course Facts enrichment;
- **Country:** AU only;
- **Scope:** Country, State/Territory, University/Provider through existing server-authorised scope services;
- **Processing mode:** Acquisition + deterministic Layer 2 only;
- **Preview:** required before UI dispatch and shows course/provider/discovery/active-run impact;
- **Audit/follow-through:** governance reason required and a governed Jobs dispatch record is produced.

Explicitly unavailable in this slice:

- NZ Layer 2 Course enrichment;
- generic automatic L2 -> L3 -> L4 orchestration;
- generic Layer 3 Evidence reprocess;
- arbitrary Layer 1 target construction;
- country/state recurring schedule creation;
- university recurring schedule creation until a verified one-profile resolver/constructor is accepted;
- implicit Search/Publication actions.

## Preserved authority / security rules

1. Layer 1 identity and publisher/regulatory authority are never redefined by L2/L3 shortcuts.
2. Layer 3 can execute only through accepted Evidence/profile/model/revalidation controls.
3. Layer 4 remains audited human/exception resolution.
4. Scholarship Provider ownership never manufactures Course eligibility.
5. Browser execution uses authenticated public wrappers only; private bridges independently rank-gate Pipeline Operator access.
6. No browser service-role/provider secret/private Evidence exposure is allowed.
7. Unsupported scope or processing mode must fail closed and remain visibly unavailable.
8. Search/Publication remain separate downstream governed consequences.
9. Applied migration identities are never retimestamped to satisfy repository ordering; corrections use forward migrations.

## Security state

Security Advisor after the Phase B migration remains **191 INFO / 0 WARN / 0 ERROR**, the same known `rls_enabled_no_policy` baseline. No new CF-093 warning/error was introduced.

## Active acceptance gate

Pilot PR #69 initially opened at head `216c2854f2e9d53df723e5c038aa0a064999cfc4`.

Required before merge:

1. repository/runtime migration identity alignment;
2. source contract and browser/build acceptance;
3. negative anonymous/low-rank/unsupported workflow/mode acceptance;
4. preview-before-dispatch proof;
5. nominated AU Layer 2 run showing Jobs/Evidence follow-through and no manufactured L3/Publication activity;
6. Codex exact-head review with actionable findings resolved;
7. visible release bump only after the functional candidate is accepted;
8. post-merge deployed UAT/security/currentness reconciliation.

## Rollback / recovery

- Do not delete or rewrite `20260911021144`; any runtime correction is a new forward migration.
- UI target-builder changes can be reverted independently while retaining the accepted v2.15.77 Phase A baseline.
- If a scope cannot be proven server-enforceable, disable/remove it rather than weakening worker/security contracts.

CF-093 remains **OPEN** until the governed target-builder phase reaches its accepted boundary. Broader automatic cross-layer orchestration may remain a separately gated follow-up if it cannot be proven safely within M2.4.5.
