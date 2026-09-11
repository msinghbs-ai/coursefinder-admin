# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** REOPENED — POST-MERGE CODEX CORRECTIVE GATE ACTIVE  
**Initiated:** 2026-09-10 AEST  
**Reopened:** 2026-09-11 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Deployed Pilot baseline before corrective gate:** `cfc4702ba57a58ea31936dcabbd96fdd765194e2` / visible v2.15.78  
**Functional merge:** PR #69 -> `85bc068d379ed3fc9231d167cf524e56419e80f9`  
**Release merge:** PR #70 -> `cfc4702ba57a58ea31936dcabbd96fdd765194e2`  
**Corrective Pilot PR:** #71 (`m245/cf093-postmerge-codex-20260911`)

## Objective

Provide a task-first Scheduled Tasks control plane that progressively builds governed ingestion/enrichment work without collapsing CourseFinder layer authority. Human business labels remain primary; technical IDs remain audit/support detail.

Governed operator sequence:

`Job / Dataset -> Country -> Scope Type -> Target -> Processing Mode -> Preview -> Run now / Schedule`

Preview remains a required server control boundary before consequential execution.

## Accepted narrow authority boundary

The implemented slice remains deliberately narrow and server-enforced:

- **Dataset:** Course Facts enrichment.
- **Country:** AU only.
- **Scope:** Country, State/Territory or University/Provider through governed Layer 2 scope services.
- **Processing mode:** Acquisition + deterministic Layer 2 only.
- **Preview:** mandatory server-side preview, actor-bound, exact-target/mode-bound and time-limited.
- **Layer 1:** regulatory/publisher identity authority is unchanged.
- **Layer 2:** deterministic source/Evidence acquisition only under qualified profile, execution policy and acquisition route.
- **Layer 3:** remains separately Evidence/profile/model/revalidation governed; no generic scheduler execution.
- **Layer 4:** remains audited human/exception resolution; no generic scheduler execution.
- **Search/Publication:** remain separate downstream governed consequences and are not implicit effects of this builder.
- **Recurring scopes:** country/state recurring construction remains disabled; university scheduling still requires a separately accepted enforceable contract.

The old browser `scheduler_workflow_run_now_v1` path remains revoked. Browser execution uses the accepted v2 governed path with rank-4 server enforcement.

## Immutable Pilot runtime lineage

1. `20260911021144 cf_093_scheduler_workflow_builder_slice`
2. `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix`
3. `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency`
4. `20260911023721 cf_093_scheduler_workflow_codex_second_pass`
5. `20260911025332 cf_093_scheduler_workflow_codex_third_pass`
6. `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass`
7. `20260911052952 cf_093_scheduler_execution_policy_qualification`
8. `20260911065626 cf_093_scheduler_policy_and_scope_limit_qualification`
9. `20260911085724 cf_093_scheduler_postmerge_codex_finalizer`

Applied migration identities are immutable. No applied migration has been retimestamped, rewritten or replaced.

## Prior accepted evidence

The v2.15.78 release was deployed after PR #69 and PR #70. Prior post-release checks were:

- Release History Contract `34579029903` — PASS;
- Pilot Frontend Build `34579029934` — PASS;
- CourseFinder Deployed UAT `34579029850` — PASS.

A policy-qualified UQ scope previously previewed 382 courses and produced governed Layer 2 Evidence without generic Layer 3, Layer 4, Search or Publication effects.

## Reopening trigger — exact-head Codex result received after PR #69 merge

Codex submitted five additional P2 findings against PR #69 final reviewed head `f01ef66437864db5b0d2f5a319ab7a80bb6f0073` after the functional PR had already merged. Because those findings are material to dispatch correctness, the earlier CLOSED/PASS status is withdrawn pending corrective acceptance.

The findings were:

1. deduplicated retries wrote a fresh `consumed_at`, allowing repeated retries to extend the 10-minute dedupe window indefinitely;
2. a multi-profile scope could partially dispatch if one previewed profile disappeared between revalidation and `start`;
3. preview did not require at least one enabled acquisition route backed by an enabled acquisition provider;
4. discovery-backed work did not require a worker-compatible discovery URL/search target before token issuance;
5. state options used a broader provider-state predicate than execution, whose authoritative state scope is course-campus based.

## Forward-only corrective implementation

Pilot runtime migration `20260911085724 cf_093_scheduler_postmerge_codex_finalizer` was applied as a new migration. Repository source is being reconciled in Pilot PR #71; no prior migration was retimestamped.

The finalizer:

- records `deduplicated_at` on reused previews and preserves the original real dispatch `consumed_at` for dedupe-window calculation;
- stores the exact sorted preview profile-ID set and requires the live pre-dispatch profile set to remain identical;
- compares the profile IDs returned by `start` with the pre-start live set and raises inside the same transaction on any partial-set change, rolling back start-side effects;
- fails preview and dispatch closed when any scoped profile lacks an enabled acquisition route backed by an enabled provider;
- fails preview and dispatch closed when work requiring discovery lacks `discovery_url`, `discovery_strategy.catalogue_url`, or a qualified `first_party_search` `search_url_template`;
- builds state options from the same `public.layer2_scope_courses(...,'state',...)` predicate used by preview/start, eliminating selector/execution scope drift;
- retains AU-only, rank-4, acquisition-only and preview-before-dispatch gates.

Security Advisor after the forward migration remains at the known baseline: **191 INFO / 0 WARN / 0 ERROR**. No ACL/rank weakening was introduced.

## Corrective acceptance gate

Current Pilot corrective branch exact head after migration + targeted UAT source coverage: `a24f36b3e701391ab509c8c86c3820e02e234c9a`.

Pilot PR #71 is **draft/open and must not merge** until:

1. exact-head CI required checks pass;
2. exact-head Codex re-review is clean or all new actionable findings are forward-corrected;
3. targeted runtime/source acceptance confirms the five post-merge findings are closed;
4. any required deployed UAT after merge is green.

Codex exact-head review was requested on PR #71 in comment `5632068158`.

## Preserved authority and security rules

1. Layer 1 regulatory/publisher identity authority is unchanged.
2. Layer 2 remains deterministic source/Evidence acquisition under qualified source profiles, execution policy and enabled acquisition route.
3. Layer 3 can execute only through accepted Evidence/profile/model/revalidation controls.
4. Layer 4 remains audited human/exception resolution.
5. Browser execution remains authenticated and rank-gated; private helpers remain separately protected.
6. No service-role/provider secret/private Evidence is exposed to browser code.
7. Unsupported scope or processing mode fails closed.
8. Search/Publication remain separate downstream governed consequences.
9. Security/UAT rules are not weakened to make tests pass.

## Explicitly outside this boundary

- NZ Layer 2 Course enrichment;
- generic automatic L2 -> L3 -> L4 orchestration;
- generic Layer 3 Evidence reprocessing;
- arbitrary Layer 1 target construction;
- country/state recurring target construction;
- university recurring target construction without a separately accepted enforceable contract;
- implicit Search or Publication actions.

## Rollback / recovery

- Do not delete, rewrite or retimestamp any applied CF-CHG-20260910-093 migration identity.
- UI target-builder changes may be reverted independently; database corrections remain forward-only.
- If a scope cannot be proven server-enforceable, disable/remove it rather than weakening worker, identity, Evidence or authority controls.

CF-CHG-20260910-093 remains **REOPENED** until PR #71 completes its exact-head Codex/CI/targeted/deployed acceptance sequence.