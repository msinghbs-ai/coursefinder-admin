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
5. `20260911025332 cf_093_scheduler_workflow_codex_third_pass` — forward-only dispatch-time live-scope revalidation; no prior applied migration identity was retimestamped or rewritten.

### Current executable capability

- **Dataset:** Course Facts enrichment;
- **Country:** AU only;
- **Scope:** Country, State/Territory, University/Provider through existing server-authorised scope services;
- **Processing mode:** Acquisition + deterministic Layer 2 only;
- **Preview:** required server-side before consequential dispatch, actor-bound, exact-target/mode-bound and valid for 15 minutes;
- **Profile qualification:** every scoped enabled/non-paused Course Facts profile must retain a valid current profile version at preview and again at dispatch; otherwise execution fails closed;
- **Live runnable-scope revalidation:** dispatch recomputes the authoritative server preview after token validation. If profile pause/disable/membership changes leave no runnable work, dispatch fails closed and requires a new preview rather than consuming the token as a successful no-op;
- **Executable-work guard:** zero queueable/discovery work returns non-executable and no runnable preview token;
- **Country canonicalisation:** country scope rejects non-null target IDs so one AU-wide workload cannot be represented as multiple fake exact scopes;
- **Run:** v2 exact-target dispatch requires the preview token and governance reason;
- **Idempotency:** exact target dispatch is advisory-lock serialized; consumed-token replay and matching recent dispatch reuse are measured from actual `consumed_at` dispatch time, not preview creation time;
- **Truthful Job semantics:** the completed record is the preview operation itself. Underlying Layer 2 batch/discovery records remain authoritative for processing status; the builder does not manufacture a completed enrichment Job;
- **UI race safety:** preview and dispatch activity are now separate state machines. Scope/target edits clear only preview activity and are disabled while dispatch is in flight, so a completed older dispatch cannot erase or unlock a newer target;
- **UI rank parity:** builder context resolves the same governed role rank used by Scheduled Tasks. Rank <4 is read-only and cannot preview or dispatch; server bridges remain independently rank-gated.

The old browser `scheduler_workflow_run_now_v1` path is revoked. Browser execution uses `scheduler_workflow_run_now_v2` only.

### Codex review reconciliation

The first Codex review of PR #69 at `216c2854...` raised seven actionable findings; all were corrected using forward-only changes.

The exact-head re-review of `fe69259a540fcbce36d39c340d40d6fe9bd391dd` raised five additional edge cases; all were corrected at `b3203c9a4a4e44f79e79637d96b6e0f2ca408c59` using migration `20260911023721` and UI state corrections.

The next exact-head Codex review of `b3203c9a4a4e44f79e79637d96b6e0f2ca408c59` raised three P2 findings:

1. changing scope/target while a dispatch RPC was active could clear shared busy state and allow overlapping consequential actions;
2. dispatch validated current profile-version quality but did not prove runnable work still existed after a profile was paused/disabled after preview;
3. the independently injected target builder exposed enabled Preview UI to read-only rank-3 users although the server correctly denied it.

Third-pass corrections:

- Pilot UI separates `previewBusy` and `dispatchBusy`; consequential target/mode/reason edits are locked during dispatch, while preview invalidation clears preview state only;
- Pilot runtime migration `20260911025332` recomputes the authoritative Layer 2 preview at dispatch and refuses a stale token when live queueable/discovery work is zero;
- builder resolves governed `api.context()` rank, stays read-only below Pipeline Operator rank 4, and retains independent server-side rank enforcement;
- unsupported generic L3/L4 orchestration, Evidence reprocessing, recurring country/state construction and implicit Search/Publication remain disabled.

Current Pilot candidate after the third pass is `1210a018db3451b31faafc14e0d0c4dfc69c9e12`. Exact-head Release History `34556438054` and Frontend Build `34556438021` were started by this head and must pass before re-review/acceptance progression.

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

Do not merge PR #69 or bump visible release until the current exact-head CI, Codex re-review and targeted acceptance are green.

Required before merge:

1. exact-head Codex review has no actionable finding;
2. repository/runtime migration history remains aligned;
3. targeted source/browser acceptance remains green;
4. negative anonymous/low-rank/unsupported mode and invalid/expired/mismatched preview paths pass;
5. nominated AU Layer 2 preview -> dispatch proves Jobs/Evidence follow-through with no manufactured L3/Publication activity;
6. only after functional acceptance, publish the next visible release;
7. post-merge deployed UAT/security/currentness reconciliation.

## Rollback / recovery

- Do not delete or rewrite applied migration identities `20260911021144`, `20260911021847`, `20260911022312`, `20260911023721` or `20260911025332`.
- UI target-builder changes can be reverted independently while retaining accepted v2.15.77 Phase A.
- If a scope cannot be proven server-enforceable, disable/remove it rather than weakening worker/security contracts.

CF-093 remains **OPEN** until the governed target-builder phase reaches its accepted boundary. Broader automatic cross-layer orchestration may remain a separately gated follow-up if it cannot be proven safely within M2.4.5.
