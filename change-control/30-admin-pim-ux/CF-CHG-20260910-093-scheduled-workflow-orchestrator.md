# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** REOPENED — CONSEQUENTIAL ACCEPTANCE BLOCKER ACTIVE  
**Initiated:** 2026-09-10 AEST  
**Reopened:** 2026-09-11 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Deployed Pilot baseline:** `cfc4702ba57a58ea31936dcabbd96fdd765194e2` / visible v2.15.78  
**Functional merge:** PR #69 -> `85bc068d379ed3fc9231d167cf524e56419e80f9`  
**Release merge:** PR #70 -> `cfc4702ba57a58ea31936dcabbd96fdd765194e2`  
**Corrective Pilot PR:** #71 (`m245/cf093-postmerge-codex-20260911`)  
**Current corrective head:** `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575`

## Objective and accepted narrow boundary

Provide a task-first Scheduled Tasks control plane without collapsing CourseFinder layer authority. The governed sequence remains:

`Job / Dataset -> Country -> Scope Type -> Target -> Processing Mode -> Preview -> Run now / Schedule`

The implemented executable slice is deliberately narrow and server-enforced:

- **Dataset:** Course Facts enrichment only.
- **Country:** AU only.
- **Scope:** Country, State/Territory or University/Provider from governed Layer 2 scope services; a selected scope is executable only if all server qualification gates pass.
- **Processing:** Acquisition + deterministic Layer 2 only.
- **Preview:** mandatory, actor-bound, exact-target/mode-bound and time-limited.
- **Layer 1:** regulatory/publisher identity authority unchanged.
- **Layer 2:** deterministic source/Evidence acquisition only under qualified profile, execution policy and runtime-usable acquisition route.
- **Layer 3:** separate Evidence/profile/model/revalidation governance; no generic scheduler execution.
- **Layer 4:** audited human/exception resolution; no generic scheduler execution.
- **Search/Publication:** separate downstream governed consequences, never implicit effects of this builder.
- **Recurring scopes:** country/state recurring construction disabled; university recurring construction requires a separately accepted enforceable contract.
- **Discovery-backed generic dispatch:** disabled/fail-closed until a Preview-bound asynchronous payload and continuation contract is implemented and accepted.
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
12. `20260911103931 cf_093_scheduler_runtime_semantics_finalizer`
13. `20260911105517 cf_093_scheduler_browser_bridge_and_scope_binding_finalizer`
14. `20260911111431 cf_093_scheduler_query_binding_and_ipv4_finalizer`
15. `20260911114056 cf_093_scheduler_discovery_failclosed_and_runtime_parser_finalizer`
16. `20260911120131 cf_093_scheduler_operator_reason_and_route_chain_finalizer`

Migration-history reconciliation on 11 September 2026:

- Pilot runtime had already applied `20260911111431 cf_093_scheduler_query_binding_and_ipv4_finalizer` while PR #71 source temporarily carried stale filename `20260911111622`; source was corrected to immutable runtime identity `20260911111431` and the stale alias removed.
- Pilot runtime subsequently recorded `20260911120131 cf_093_scheduler_operator_reason_and_route_chain_finalizer`. The branch now carries that exact applied identity; the pre-apply source alias `20260911115830` was removed without changing migration semantics.
- No applied migration was retimestamped or rewritten.

## Prior accepted deployed evidence

Before the corrective gate reopened, v2.15.78 had passed:

- Release History Contract `34579029903` — PASS;
- Pilot Frontend Build `34579029934` — PASS;
- CourseFinder Deployed UAT `34579029850` — PASS.

A policy-qualified UQ scope previously produced governed Layer 2 Evidence without generic Layer 3, Layer 4, Search or Publication effects. Those results remain historical evidence but do not supersede the reopened corrective gate.

## Post-merge corrective history

### First post-merge pass — `20260911085724`

Codex submitted five additional P2 findings against PR #69 after merge. Runtime migration `20260911085724 cf_093_scheduler_postmerge_codex_finalizer` corrected them forward-only by preserving actual dispatch time on dedupe, binding dispatch to exact previewed profile membership, requiring enabled acquisition route/provider, requiring worker-compatible discovery configuration, and aligning state selector semantics with the `layer2_scope_courses` execution predicate.

### Exact-scope and route correction — `20260911095142` / `20260911095420`

Codex then returned six actionable findings, including exact course/source scope binding, dedupe membership, route credential/runtime eligibility, discovery target precedence, University option eligibility and Preview atomicity. The forward corrections introduced an authoritative scope snapshot/fingerprint, exact pre-dispatch comparison, current fingerprint-bound dedupe, executable University options, worker-aligned discovery target qualification and decrypted Vault credential checks while excluding Parsebot.

### Runtime semantics pass — `20260911103931`

Codex then returned five P2 findings requiring post-start fingerprint validation, worker budget/cost parity, stricter URL parsing, rejection of no-op/partial starts and queueable source host allowlisting. The correction adds strict HTTPS/host validation, worker-aligned route qualification, exact dispatch-result checks, current-profile queueable URL allowlisting, and post-start scope-fingerprint revalidation inside the same transaction.

### Browser/query-binding pass — `20260911105517` / `20260911111431`

The browser bridge remains authenticated/rank-4 gated while private helpers retain closed ACLs. Scope fingerprinting binds current profile version and discovery query-driving course identity fields. Numeric-host parsing is fail-closed to canonical decimal IPv4 forms. Source matches applied identity `20260911111431` exactly.

### Discovery fail-closed pass — `20260911114056`

Codex review found a P1 asynchronous Preview-binding defect plus five P2 runtime-parity defects. The smallest safe correction reduced authority rather than weakening Preview semantics: generic discovery-backed Scheduled Tasks now fail closed before a Preview token is issued; deterministic queueable Layer 2 remains eligible. The same migration validates non-direct provider base URLs, uses structured JSON scope hashing, and rejects legacy/hex numeric IPv4 representations.

The separate capability to carry Preview-bound profile version, course inputs and expanded discovery targets through the async worker payload and every continuation remains **unimplemented** and is a prerequisite to re-enabling discovery-backed generic Scheduled Tasks.

### Operator-truth / route-chain finalizer — `20260911120131`

Codex exact-head review of `f3622ff516...` returned three additional P2 findings. Runtime/source migration `20260911120131 cf_093_scheduler_operator_reason_and_route_chain_finalizer` corrects them forward-only:

1. discovery-backed scopes expose a distinct `unsupported_discovery_count` and truthful operator block reason rather than reporting a false configuration fault;
2. deterministic provider-route qualification evaluates worker route order and blocking/fallback semantics instead of accepting any later existentially usable route;
3. queueable URL allowlist references are parsed literally, matching `layer2-acquire-v2`, with no scheduler-only `{query}` substitution.

All three review threads were answered with remediation evidence and resolved. Source was reconciled to the immutable applied runtime identity `20260911120131`; the stale pre-apply alias `20260911115830` is absent.

## Current runtime and exact-head evidence

- Pilot exact candidate: `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575`.
- Pilot Frontend Build `34597632959` — **PASS**; build-and-smoke check `103257017648` — **PASS**.
- Cloudflare Workers exact-head preview build `a5398593-1916-4224-8ac9-8d9f3165a1ab` / check `103257139984` — **PASS** for `00c98f0c`.
- Runtime migration `20260911120131 cf_093_scheduler_operator_reason_and_route_chain_finalizer` is applied after immutable `20260911114056` and `20260911111431`.
- Exact-head Codex review of `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575` reported **“Didn't find any major issues”** in PR #71 comment `5634309865`.
- University of Queensland remains **382 courses / 156 queueable / 226 discovery** and is intentionally non-executable in generic Scheduled Tasks because discovery-backed execution is fail-closed.
- Runtime-wide AU University inspection confirms the only fully queueable University scopes are Nova Higher Education and Stamford International College. Each is **1 queueable / 0 discovery**, route gaps 0, URL gaps 0, oversize 0, but **execution-policy gap 1**.
- Current AU State scopes remain discovery-backed and contain policy gaps; there is no genuinely policy-qualified fully queueable consequential target available under current runtime truth.
- No execution policy, source profile, route or runtime configuration is being manufactured merely to force acceptance.
- Security Advisor remains the known **191 INFO / 0 WARN / 0 ERROR** baseline.

## Corrective acceptance gate

PR #71 is **draft/open and must not merge** until all of the following are true on one exact head:

1. required CI checks pass — **PASS at `00c98f0cea...`**;
2. targeted CF-CHG-20260910-093 source/runtime acceptance passes — **current targeted checks PASS**;
3. all current Codex threads are reconciled against runtime evidence — **PASS**;
4. exact-head Codex re-review is clean — **PASS at `00c98f0cea...` / comment `5634309865`**;
5. required queueable deterministic Layer 2 consequential/nominated acceptance is clean on an actually governed policy-qualified target — **BLOCKED by current runtime truth**;
6. post-merge deployed acceptance is green before CF-CHG-20260910-093 is returned to CLOSED/PASS.

The remaining blocker is substantive runtime eligibility, not review or CI. Governance must not be altered merely to waive this gate, and runtime policy/configuration must not be fabricated for testing. If a genuinely governed operational reason later qualifies a fully queueable target, rerun Preview -> consequential dispatch -> Jobs/Evidence/no-side-effect acceptance on that target before merge.

Discovery-backed generic acceptance is not a merge prerequisite while that capability is explicitly disabled; it cannot be claimed implemented until the separate Preview-bound asynchronous contract exists.

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
10. Generic discovery-backed dispatch remains disabled until its asynchronous Preview-binding contract is explicitly accepted.

## Explicitly outside this Change Control boundary / still open

- NZ Layer 2 Course enrichment;
- generic automatic L2 -> L3 -> L4 orchestration;
- generic Layer 3 Evidence reprocessing;
- arbitrary Layer 1 target construction;
- country/state recurring target construction;
- university recurring target construction without a separately accepted enforceable contract;
- generic discovery-backed Scheduled Tasks until Preview-bound asynchronous payload/continuation verification is implemented;
- implicit Search or Publication actions.

## Rollback / recovery

- Never delete, rewrite or retimestamp applied CF-CHG-20260910-093 migration identities.
- UI target-builder changes may be reverted independently; database corrections remain forward-only.
- If a scope cannot be proven server-enforceable, disable/remove it rather than weakening worker, identity, Evidence or authority controls.

CF-CHG-20260910-093 remains **REOPENED** at the consequential-acceptance blocker. Exact-head Codex/CI/targeted corrective checks are clean, but PR #71 must remain unmerged until a genuinely governed policy-qualified fully queueable deterministic Layer 2 target can satisfy consequential acceptance. The full orchestrator scope must not be closed while Preview-bound asynchronous discovery and the broader explicitly-disabled capabilities remain unimplemented.
