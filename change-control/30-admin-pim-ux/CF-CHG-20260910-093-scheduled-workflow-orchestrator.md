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

### Current executable capability

- **Dataset:** Course Facts enrichment;
- **Country:** AU only;
- **Scope:** Country, State/Territory, University/Provider through existing server-authorised scope services;
- **Processing mode:** Acquisition + deterministic Layer 2 only;
- **Preview:** required server-side before consequential dispatch, actor-bound, exact-target/mode-bound and valid for 15 minutes;
- **Executable-work guard:** zero queueable/discovery work returns `executable=false` and cannot be dispatched;
- **Run:** v2 exact-target dispatch requires the preview token and governance reason;
- **Idempotency:** exact target dispatch is advisory-lock serialized; a consumed token replays its stored result and a matching recent dispatch is reused rather than starting paid acquisition again;
- **Truthful Job semantics:** the completed record is the preview operation itself. Underlying Layer 2 batch/discovery records remain authoritative for processing status; the builder does not manufacture a completed enrichment Job;
- **UI race safety:** scope/target changes invalidate preview state and request generations prevent stale option/preview responses from authorising another target.

The old browser `scheduler_workflow_run_now_v1` path is revoked. Browser execution uses `scheduler_workflow_run_now_v2` only.

### Codex review reconciliation

The first Codex review of PR #69 at `216c2854...` raised seven actionable findings. All are addressed on the current candidate using forward-only corrections:

1. **P1 private bridge ACL chain** — fixed by `20260911021847`; authenticated private bridge EXECUTE=true, anon=false.
2. **P1 server preview enforcement** — fixed by `20260911022312`; same-actor exact-target server preview token required.
3. **P1 stale target preview** — fixed in UI; target/scope changes clear and version the preview.
4. **P2 misleading completed dispatch Job** — v1 run path retired; underlying work no longer represented as completed.
5. **P2 unqualified/no-work target** — preview marks non-executable and server v2 refuses dispatch.
6. **P1 retry/idempotency** — exact target advisory lock plus consumed/recent dispatch reuse.
7. **P2 stale university search response** — option request generation allows only newest response to update state.

The seven original review threads have been replied to with evidence and resolved. Fresh exact-head Codex review was requested for Pilot head `fe69259a540fcbce36d39c340d40d6fe9bd391dd` after exact-head CI passed.

### Exact-head CI / security evidence

At `fe69259a540fcbce36d39c340d40d6fe9bd391dd`:

- Release History Contract `34554608690` — PASS.
- Pilot Frontend Build/local browser smoke `34554608629` — PASS.
- Runtime v1 public/private authenticated EXECUTE — false.
- Runtime v2 public/private authenticated EXECUTE — true.
- Runtime v2 public/private anon EXECUTE — false.
- Security Advisor — **191 INFO / 0 WARN / 0 ERROR**, unchanged known `rls_enabled_no_policy` baseline.

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

- Do not delete or rewrite applied migration identities `20260911021144`, `20260911021847` or `20260911022312`.
- UI target-builder changes can be reverted independently while retaining accepted v2.15.77 Phase A.
- If a scope cannot be proven server-enforceable, disable/remove it rather than weakening worker/security contracts.

CF-093 remains **OPEN** until the governed target-builder phase reaches its accepted boundary. Broader automatic cross-layer orchestration may remain a separately gated follow-up if it cannot be proven safely within M2.4.5.
