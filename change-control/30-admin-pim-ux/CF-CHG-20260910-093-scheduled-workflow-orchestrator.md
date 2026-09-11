# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** REOPENED — POST-MERGE CODEX CORRECTIVE GATE ACTIVE  
**Initiated:** 2026-09-10 AEST  
**Reopened:** 2026-09-11 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Deployed Pilot baseline:** `cfc4702ba57a58ea31936dcabbd96fdd765194e2` / visible v2.15.78  
**Functional merge:** PR #69 -> `85bc068d379ed3fc9231d167cf524e56419e80f9`  
**Release merge:** PR #70 -> `cfc4702ba57a58ea31936dcabbd96fdd765194e2`  
**Corrective Pilot PR:** #71 (`m245/cf093-postmerge-codex-20260911`)

## Objective and accepted narrow boundary

Provide a task-first Scheduled Tasks control plane without collapsing CourseFinder layer authority. The governed sequence remains:

`Job / Dataset -> Country -> Scope Type -> Target -> Processing Mode -> Preview -> Run now / Schedule`

The implemented executable slice is deliberately narrow and server-enforced:

- **Dataset:** Course Facts enrichment only.
- **Country:** AU only.
- **Scope:** Country, State/Territory or University/Provider from governed Layer 2 scope services.
- **Processing:** Acquisition + deterministic Layer 2 only.
- **Preview:** mandatory, actor-bound, exact-target/mode-bound and time-limited.
- **Layer 1:** regulatory/publisher identity authority unchanged.
- **Layer 2:** deterministic source/Evidence acquisition only under qualified profile, execution policy and runtime-usable acquisition route.
- **Layer 3:** separate Evidence/profile/model/revalidation governance; no generic scheduler execution.
- **Layer 4:** audited human/exception resolution; no generic scheduler execution.
- **Search/Publication:** separate downstream governed consequences, never implicit effects of this builder.
- **Recurring scopes:** country/state recurring construction disabled; university recurring construction requires a separately accepted enforceable contract.
- **Security:** browser path remains authenticated/rank-4 gated; private helper ACLs remain closed to anon/public.

The old browser `scheduler_workflow_run_now_v1` path remains revoked.

## Immutable Pilot runtime lineage

Applied identities are immutable; no applied migration may be retimestamped, rewritten or replaced.

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

## Prior accepted deployed evidence

Before the corrective gate reopened, v2.15.78 had passed:

- Release History Contract `34579029903` — PASS;
- Pilot Frontend Build `34579029934` — PASS;
- CourseFinder Deployed UAT `34579029850` — PASS.

A policy-qualified UQ scope previously previewed 382 courses and produced governed Layer 2 Evidence without generic Layer 3, Layer 4, Search or Publication effects. Those results remain historical evidence but do not supersede the reopened corrective gate.

## Reopening and first post-merge corrective pass

Codex submitted five additional P2 findings against PR #69 after merge. Runtime migration `20260911085724 cf_093_scheduler_postmerge_codex_finalizer` corrected them forward-only by preserving actual dispatch time on dedupe, binding dispatch to exact previewed profile membership, requiring enabled acquisition route/provider, requiring worker-compatible discovery configuration, and aligning state selector semantics with the `layer2_scope_courses` execution predicate.

## Exact-head Codex review on corrective PR #71

Codex reviewed PR #71 head `a24f36b3e701391ab509c8c86c3820e02e234c9a` and returned six new actionable findings: **two P1 and four P2**.

1. **P1 — dedupe/profile membership:** a recent dispatch could be reused after profile membership changed, leaving newly added profiles unstarted.
2. **P2 — runtime route eligibility:** enabled provider/route flags were insufficient when an authenticated provider had no decrypted credential, and Parsebot is explicitly rejected by the discovery worker.
3. **P2 — discovery target validation:** preview did not fully mirror worker target precedence and HTTPS validation.
4. **P2 — University options:** Layer 1 catalogue providers without executable Layer 2 scope could still appear as selectable targets.
5. **P2 — preview atomicity:** counts and profile IDs could be produced from different READ COMMITTED statements while scope membership changed.
6. **P1 — exact runnable scope binding:** dispatch compared profile membership but not the exact course/source-URL classification represented by Preview.

## Forward-only exact-scope correction

Pilot runtime migration `20260911095142 cf_093_scheduler_exact_scope_codex_finalizer` was applied without changing any prior migration identity. It:

- introduces a private materialized scope snapshot over authoritative `public.layer2_scope_courses` containing sorted profile IDs, queueable/discovery counts, scoped-course count and an exact fingerprint of `profile_id + course_id + resolved source URL/discovery classification`;
- stores the snapshot fingerprint/profile set in Preview and re-snapshots before token issuance, rejecting construction-time scope drift;
- requires dispatch live fingerprint and profile set to exactly match the server-issued Preview;
- binds recent-dispatch dedupe to both the current fingerprint and current profile set;
- derives University options only from executable `layer2_scope_courses`, including state-filtered executable scope when a state is selected;
- mirrors discovery-worker target precedence and rejects non-HTTPS/invalid target forms before dispatch;
- retains exact started-profile equality and transactional rollback on partial dispatch;
- preserves AU-only, rank-4, acquisition-only and mandatory Preview gates.

Runtime reconciliation then confirmed `public.layer2_provider_runtime_config` supplies `secret` from `vault.decrypted_secrets`. Because a non-null `vault_secret_id` alone is not equivalent to a usable decrypted credential, migration `20260911095420 cf_093_scheduler_runtime_route_credential_finalizer` further tightens route qualification to require either `auth_scheme='none'` or a non-empty decrypted Vault secret, while continuing to exclude Parsebot from qualified discovery routes. This is also forward-only.

## Current runtime evidence

After the two latest corrections:

- AU authoritative scope snapshot: **21,093 courses**;
- queueable now: **445**;
- requiring discovery: **20,648**;
- exact scope fingerprint: **`16c0defeb19917ad2695a5f27bab9c55`**;
- runtime-usable acquisition route gaps: **0**;
- worker-valid discovery configuration gaps at AU-wide scope: **97**.

The 97 discovery gaps mean AU-wide consequential dispatch must currently fail closed. This is expected governed behaviour; a narrower eligible target may still pass qualification.

Security Advisor after the new migrations remains the known baseline: **191 INFO / 0 WARN / 0 ERROR**. No new warning/error and no rank/ACL weakening were introduced.

## Repository reconciliation

Corrective PR #71 now contains the immutable runtime migration identities and targeted UAT source coverage. Current exact head after the latest source/test reconciliation must be verified from PR truth before acceptance/merge.

The targeted contract asserts:

- exact course/source scope fingerprint binding across Preview -> dispatch;
- prior-dispatch dedupe requires the same current profile set and fingerprint;
- University options derive only from executable Layer 2 scope;
- Parsebot and missing decrypted credentials do not qualify a route;
- worker-selected discovery target must be HTTPS-valid;
- AU Course Facts / acquisition-only / rank-4 controls remain in force;
- generic L3/L4 and generic Evidence reprocessing remain disabled.

## Corrective acceptance gate

PR #71 is **draft/open and must not merge** until all of the following are true on one exact head:

1. required CI checks pass;
2. targeted CF-093 source/runtime acceptance passes;
3. the six latest Codex threads are reconciled against runtime evidence;
4. an exact-head Codex re-review is clean or any additional actionable findings are corrected forward-only;
5. post-merge deployed acceptance is green before CF-093 is returned to CLOSED/PASS.

## Preserved authority and security rules

1. Layer 1 regulatory/publisher identity authority is unchanged.
2. Layer 2 remains deterministic source/Evidence acquisition under qualified source profiles, execution policies and runtime-usable routes.
3. Layer 3 executes only through accepted Evidence/profile/model/revalidation controls.
4. Layer 4 remains audited human/exception resolution.
5. Browser execution remains authenticated and rank-gated; private helpers remain protected.
6. No service-role/provider secret/private Evidence is exposed to browser code.
7. Unsupported scope or processing mode fails closed.
8. Search/Publication remain separate downstream governed consequences.
9. Security/UAT rules are never weakened merely to satisfy acceptance.

## Explicitly outside this Change Control boundary

- NZ Layer 2 Course enrichment;
- generic automatic L2 -> L3 -> L4 orchestration;
- generic Layer 3 Evidence reprocessing;
- arbitrary Layer 1 target construction;
- country/state recurring target construction;
- university recurring target construction without a separately accepted enforceable contract;
- implicit Search or Publication actions.

## Rollback / recovery

- Never delete, rewrite or retimestamp applied CF-CHG-20260910-093 migration identities.
- UI target-builder changes may be reverted independently; database corrections remain forward-only.
- If a scope cannot be proven server-enforceable, disable/remove it rather than weakening worker, identity, Evidence or authority controls.

CF-CHG-20260910-093 remains **REOPENED** until PR #71 completes exact-head Codex, CI, targeted acceptance and required deployed-UAT gates.
