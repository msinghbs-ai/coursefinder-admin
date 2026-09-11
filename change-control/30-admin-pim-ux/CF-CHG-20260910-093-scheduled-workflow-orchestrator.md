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

The existing Layer 2 Course Facts service boundary already provides server-authorised Country/State/University scope resolution, preview and execution. CF-093 therefore starts with that proven path rather than manufacturing a browser-side scope model.

### Applied Pilot migration identities

The following runtime identities are APPLIED and must remain immutable in repository history:

1. `20260911021144 cf_093_scheduler_workflow_builder_slice` — initial AU Course Facts target-builder slice.
2. `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix` — forward fix restoring authenticated EXECUTE on independently rank-gated private bridges while keeping anon denied.
3. `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency` — server-enforced preview receipt, zero-work rejection, v1 run retirement and idempotent exact-target v2 dispatch.
4. `20260911023721 cf_093_scheduler_workflow_codex_second_pass` — dispatch-time dedupe, current-profile-version qualification guard and canonical country-scope enforcement.

### Current executable capability

- **Dataset:** Course Facts enrichment;
- **Country:** AU only;
- **Scope:** Country, State/Territory, University/Provider through existing server-authorised scope services;
- **Processing mode:** Acquisition + deterministic Layer 2 only;
- **Preview:** required server-side before consequential dispatch, actor-bound, exact-target/mode-bound and valid for 15 minutes;
- **Profile qualification:** every scoped enabled/non-paused Course Facts profile must retain a valid current profile version at preview and again at dispatch; otherwise execution fails closed;
- **Executable-work guard:** zero queueable/discovery work returns non-executable and no runnable preview token;
- **Country canonicalisation:** country scope rejects non-null target IDs so one AU-wide workload cannot be represented as multiple fake exact scopes;
- **Run:** v2 exact-target dispatch requires the preview token and governance reason;
- **Idempotency:** exact target dispatch is advisory-lock serialized; consumed-token replay and matching recent dispatch reuse are measured from actual `consumed_at` dispatch time, not preview creation time;
- **Truthful Job semantics:** the completed record is the preview operation itself. Underlying Layer 2 batch/discovery records remain authoritative for processing status; the builder does not manufacture a completed enrichment Job;
- **UI race safety:** scope/target changes invalidate preview state and clear busy state; request generations prevent stale option/preview responses from authorising another target; editing university search clears any selected provider so a hidden UUID cannot remain runnable.

The old browser `scheduler_workflow_run_now_v1` path is revoked. Browser execution uses `scheduler_workflow_run_now_v2` only.

### Codex review reconciliation

The first Codex review of PR #69 at `216c2854...` raised seven actionable findings; all were corrected using forward-only changes.

The exact-head re-review of `fe69259a540fcbce36d39c340d40d6fe9bd391dd` found five further edge cases:

1. **P1 dispatch dedupe window** used preview creation time rather than actual dispatch time.
2. **P2 in-flight preview invalidation** could leave UI `busy=true` after the stale response was ignored.
3. **P2 runnable profile qualification** was not re-checking the valid current profile version used by runtime execution.
4. **P2 university search change** could leave a hidden selected Provider UUID runnable after the result list changed.
5. **P1 country scope canonicalisation** allowed arbitrary scope IDs to distinguish the same AU-wide workload and bypass dedupe.

All five are corrected at current Pilot candidate `b3203c9a4a4e44f79e79637d96b6e0f2ca408c59`; their review threads have remediation evidence and are resolved. A fresh exact-head Codex review is requested against that candidate.

### Exact-head CI / runtime / security evidence

At `b3203c9a4a4e44f79e79637d96b6e0f2ca408c59`:

- Release History Contract `34555446950` — PASS.
- Pilot Frontend Build/local browser smoke `34555446880` — PASS.
- Pilot runtime migration lineage includes `20260911023721 cf_093_scheduler_workflow_codex_second_pass`.
- Country scope with an arbitrary non-null scope ID fails closed with `22023 country scope must not include a scope id`.
- Current enabled/non-paused Course Facts profiles have no invalid current profile version at the checked runtime state; preview and dispatch now independently re-check this invariant.
- v2 recent-dispatch lookup uses stored `consumed_at`.
- Previously proven browser ACL remains: v1 execution unavailable; v2 authenticated public/private execution available; v2 anonymous execution denied.
- Last Security Advisor check remains the known **191 INFO / 0 WARN / 0 ERROR** baseline; no CF-093 warning/error regression has been introduced.

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
2. Layer 3 can execute only through accepted Evidence/profile/model/revalidation controls.
3. Layer 4 remains audited human/exception resolution.
4. Scholarship Provider ownership never manufactures Course eligibility.
5. Browser execution uses authenticated public wrappers only; private bridges independently rank-gate Pipeline Operator access.
6. No browser service-role/provider secret/private Evidence exposure is allowed.
7. Unsupported scope or processing mode must fail closed and remain visibly unavailable.
8. Search/Publication remain separate downstream governed consequences.
9. Applied migration identities are never retimestamped; corrections use forward migrations.

## Active acceptance gate

Do not merge PR #69 or bump visible release while exact-head Codex re-review remains pending.

Required before merge:

1. exact-head Codex review has no actionable finding;
2. repository/runtime migration history remains aligned;
3. targeted source/browser acceptance remains green;
4. negative anonymous/low-rank/unsupported mode and invalid/expired/mismatched preview paths pass;
5. nominated AU Layer 2 preview -> dispatch proves Jobs/Evidence follow-through with no manufactured L3/Publication activity;
6. only after functional acceptance, publish the next visible release;
7. post-merge deployed UAT/security/currentness reconciliation.

## Rollback / recovery

- Do not delete or rewrite applied migration identities `20260911021144`, `20260911021847`, `20260911022312` or `20260911023721`.
- UI target-builder changes can be reverted independently while retaining accepted v2.15.77 Phase A.
- If a scope cannot be proven server-enforceable, disable/remove it rather than weakening worker/security contracts.

CF-093 remains **OPEN** until the governed target-builder phase reaches its accepted boundary. Broader automatic cross-layer orchestration may remain a separately gated follow-up if it cannot be proven safely within M2.4.5.
