# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** CLOSED / PASS — ACCEPTED BOUNDED TARGET-BUILDER SCOPE  
**Initiated:** 2026-09-10 AEST  
**Closed:** 2026-09-11 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot baseline:** `cfc4702ba57a58ea31936dcabbd96fdd765194e2` / visible v2.15.78  
**Functional merge:** PR #69 -> `85bc068d379ed3fc9231d167cf524e56419e80f9`  
**Release merge:** PR #70 -> `cfc4702ba57a58ea31936dcabbd96fdd765194e2`

## Objective

Provide a task-first Scheduled Tasks control plane that progressively builds governed ingestion/enrichment work without collapsing CourseFinder layer authority. Human business labels remain primary; technical IDs remain audit/support detail.

Governed operator sequence:

`Job / Dataset -> Country -> Scope Type -> Target -> Processing Mode -> Preview -> Run now / Schedule`

Preview is a required control boundary before consequential execution where the accepted workflow contract requires it.

## Accepted Phase A — operator controls

The accepted operator workspace includes:

- business-readable task/target labels with UUIDs relegated to technical detail;
- server-side task search;
- durable creator/owner attribution with historical identity retained independently of live account presence;
- personal column/view preferences separate from scheduler execution policy;
- bounded schedule editing and exact bounded Layer 1–2 Run on demand;
- explicit Job and Evidence follow-through;
- Layer 3 remaining Evidence/profile/model/revalidation governed and Layer 4 remaining audited human resolution.

## Accepted Phase B — new governed target builder

The executable slice is intentionally narrow and server-enforced:

- **Dataset:** Course Facts enrichment.
- **Country:** AU only.
- **Scope:** Country, State/Territory or University/Provider through existing server-authorised Layer 2 scope services.
- **Processing mode:** Acquisition + deterministic Layer 2 only.
- **Preview:** mandatory server-side preview, actor-bound, exact-target/mode-bound and time-limited.
- **Profile qualification:** scoped enabled/non-paused profiles require a valid current version at preview and dispatch.
- **Execution-policy qualification:** every scoped Course Facts profile requires the deterministic Layer 2 execution policy before acquisition or dispatch, including discovery-backed profiles.
- **Scope-size qualification:** one scoped profile may not exceed the existing 1,000-course downstream contract.
- **Dispatch revalidation:** live runnable scope is rechecked immediately before start.
- **Atomic empty-start:** a target that becomes empty/unqualified between preview and start fails the same transaction rather than consuming the preview as a successful no-op.
- **Idempotency:** exact-target advisory locking plus recent-dispatch reuse prevents duplicate paid acquisition across operators; reuse timing is based on actual dispatch consumption.
- **Truthful Job semantics:** the preview/dispatch control record does not manufacture downstream completion; underlying Layer 2 batch/discovery Jobs and Evidence remain authoritative.

The old browser `scheduler_workflow_run_now_v1` path remains revoked. Browser execution uses the accepted v2 governed path.

## Immutable Pilot runtime lineage

1. `20260911021144 cf_093_scheduler_workflow_builder_slice`
2. `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix`
3. `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency`
4. `20260911023721 cf_093_scheduler_workflow_codex_second_pass`
5. `20260911025332 cf_093_scheduler_workflow_codex_third_pass`
6. `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass`
7. `20260911052952 cf_093_scheduler_execution_policy_qualification`
8. `20260911065626 cf_093_scheduler_policy_and_scope_limit_qualification`

Applied migration identities are immutable; no accepted migration was retimestamped or rewritten.

## Review and acceptance evidence

Codex review drove forward-only corrections for stale preview state, invalid scope identity, profile-version qualification, dispatch-time dedupe, cross-operator duplicate prevention, empty-start atomicity, execution-policy qualification and downstream scope-size enforcement. The exact v2.15.78 release head `aa4fb9be7c0567b557092f52c218475fae9ba5a3` received a final Codex review with no major issues before release merge.

The final consequential acceptance used a policy-qualified AU Course Facts UQ scope rather than known-ineligible RMIT UP/Nova profiles. Preview covered **382 courses**. Dispatch was accepted; same-token retry and a second fresh-preview dispatch reused the original recent dispatch rather than duplicating acquisition. The underlying Layer 2 batch progressed and produced governed Evidence. No generic Layer 3 interpretation, Layer 4 resolution, Search admission or Publication side effect was observed from the target-builder run.

Post-release merge acceptance for Pilot main `cfc4702ba57a58ea31936dcabbd96fdd765194e2`:

- Release History Contract `34579029903` — **PASS**;
- Pilot Frontend Build `34579029934` — **PASS**;
- CourseFinder Deployed UAT `34579029850` — **PASS**.

## UAT recovery reconciliation

The first post-functional-merge deployed UAT failure was not accepted as a product pass. Exact failed workflow run: CourseFinder Deployed UAT `34575980681`, attempt 1. Its first CF-097 execution timed out on the stale historical `v2.15.74` visible-release assertion; Playwright retry #1 in the same workflow then observed the transient `admin_read('dashboard')` HTTP 500. The release-currentness correction changed only the stale currentness assertion to derive the expected value from the maintained release-currentness source. It did not relax HTTP 5xx detection, identity/rank checks, data authority, or UAT security boundaries. The subsequent post-release-merge CourseFinder Deployed UAT `34579029850` passed.

## Preserved authority and security rules

1. Layer 1 regulatory/publisher identity authority is unchanged.
2. Layer 2 remains deterministic source/Evidence acquisition under qualified source profiles and execution policy.
3. Layer 3 can execute only through accepted Evidence/profile/model/revalidation controls.
4. Layer 4 remains audited human/exception resolution.
5. Scholarship Provider ownership never manufactures Course eligibility.
6. Browser execution uses authenticated/rank-gated public contracts; private helpers remain separately protected.
7. No service-role/provider secret/private Evidence is exposed to browser code.
8. Unsupported scope or processing mode fails closed and remains unavailable.
9. Search/Publication remain separate downstream governed consequences.
10. Security/UAT rules are not weakened to make tests pass.

## Explicitly outside this CLOSED/PASS boundary

- NZ Layer 2 Course enrichment;
- generic automatic L2 -> L3 -> L4 orchestration;
- generic Layer 3 Evidence reprocessing;
- arbitrary Layer 1 target construction;
- country/state recurring target construction;
- university recurring target construction without a separately accepted enforceable contract;
- implicit Search or Publication actions.

These items require a future governed change or explicit reopening backed by executable server contracts. They are not implied by closure of CF-CHG-20260910-093.

## Rollback / recovery

- Do not delete, rewrite or retimestamp any applied CF-CHG-20260910-093 migration identity.
- UI target-builder changes may be reverted independently if required, while retaining immutable runtime migration history and using forward corrections for database changes.
- If a scope cannot be proven server-enforceable, disable/remove it rather than weakening worker, identity, evidence or authority controls.

CF-CHG-20260910-093 is **CLOSED / PASS** at the boundary above.