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
**Current corrective head:** `f3622ff51654969fcd37961392b82449eb372218`

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

Migration-history reconciliation on 11 September 2026: Pilot runtime had already applied `20260911111431 cf_093_scheduler_query_binding_and_ipv4_finalizer`, while PR #71 source temporarily carried the same migration under stale filename `20260911111622`. Source was corrected to the immutable applied identity `20260911111431` and the stale alias removed. The runtime identity was not retimestamped or rewritten.

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

Codex then returned five P2 findings requiring post-start fingerprint validation, worker budget/cost parity, stricter URL parsing, rejection of no-op/partial starts and queueable source host allowlisting. The correction:

- adds private strict HTTPS/host validation and rejects invalid ports;
- validates queueable source URLs against current profile acquisition host allowlists;
- qualifies routes through governed runtime configuration with enabled/non-Parsebot, credential, budget and cost gates;
- requires every dispatch result to represent real exact work before Preview consumption;
- recomputes the authoritative scope snapshot after `start` and raises in-transaction on drift.

### Browser/query-binding pass — `20260911105517` / `20260911111431`

The browser bridge remained authenticated/rank-4 gated while private helpers retained closed ACLs. Scope fingerprinting was expanded to bind current profile version and discovery query-driving course identity fields. Initial numeric-host parsing was tightened to canonical decimal IPv4 forms. The applied migration identity is `20260911111431`; source now matches that identity exactly.

## Latest exact-head Codex findings on `f280cc712...`

Codex reviewed PR #71 exact head `f280cc712071428c9ee28e811ae628a54f4d476b` on 11 September 2026 and returned **six actionable findings: one P1 and five P2**:

1. **P1 — asynchronous discovery Preview binding:** the nonce payload carried profile/course IDs only while the worker resolved live profile configuration and course query fields later, so an asynchronous request/continuation could fetch inputs not represented by the consumed Preview.
2. **P2 — active batch before discovery:** a discovery-backed profile could be accepted as started while later deterministic auto-sync returned `already_running`/no-op.
3. **P2 — provider base URL:** non-direct acquisition routes could qualify despite missing/malformed provider `base_url`, then fail asynchronously.
4. **P2 — expanded discovery URL:** dummy `{query}` replacement did not prove the actual worker-expanded URL was valid when `{query}` appeared in unsafe URL components.
5. **P2 — fingerprint encoding:** delimiter-concatenated arbitrary text permitted theoretical serialization collisions.
6. **P2 — hexadecimal WHATWG IPv4:** hex/legacy numeric host spellings could bypass the canonical decimal guard or diverge from JavaScript `new URL()` handling.

## Forward-only fail-closed correction — `20260911114056`

The smallest safe correction was to reduce authority rather than retrofit an unproven asynchronous contract inside the review loop. Pilot runtime migration `20260911114056 cf_093_scheduler_discovery_failclosed_and_runtime_parser_finalizer` was applied forward-only and mirrored in PR #71. It:

- makes every generic Scheduled Tasks scope containing discovery-backed work (`source_url is null`) fail closed before a Preview token can be issued;
- relies on the run bridge's existing qualification recheck so generic discovery cannot be queued after an earlier Preview either;
- leaves queueable deterministic Layer 2 available under the exact Preview/run contract;
- validates non-direct provider `base_url` through the strict HTTPS helper in addition to existing enabled, non-Parsebot, credential, budget and cost rules;
- replaces delimiter-concatenated scope fingerprint serialization with an ordered structured JSON array hash binding profile/version/course/source/discovery/query-driving fields;
- rejects numeric/hex-like WHATWG IPv4 forms unless the host is exactly four canonical decimal octets;
- preserves all prior ACL/rank gates and does not add any Layer 3, Layer 4, Search or Publication consequence.

The separate capability to carry Preview-bound profile version, course inputs and expanded discovery targets through the nonce payload and every continuation remains **unimplemented** and is a prerequisite to re-enabling discovery-backed generic Scheduled Tasks. This is an explicit CF-093 follow-up; the orchestrator is not considered complete because of this missing capability.

All six latest review threads were answered with forward-fix/runtime evidence and resolved. Exact-head Codex re-review was requested in PR #71 comment `5633932810` against `f3622ff51654969fcd37961392b82449eb372218`.

## Current runtime and exact-head evidence

- Pilot exact candidate: `f3622ff51654969fcd37961392b82449eb372218`.
- Pilot Frontend Build `34595439211` — **PASS**; job `103250001746` — **PASS**. Build, UAT suite discovery and local browser smoke passed on that exact head.
- Runtime migration `20260911114056` is applied after immutable `20260911111431`.
- Strict parser proof: canonical `1.2.3.8` accepted; `01.02.03.08`, `0x7f000001`, `0x7f.0.0.1`, `0x100000000` and port `65536` rejected; port `65535` accepted.
- Nominated University of Queensland scope: **382 courses / 156 queueable / 226 discovery**, **0** execution-policy gaps, **0** oversize gaps and **0** route gaps; it now intentionally has **1 discovery gate gap** and is not executable from generic Scheduled Tasks until async Preview binding is implemented.
- Queueable-only Nova Higher Education and Stamford International College scopes are discovery-gap-free but currently each has an existing execution-policy gap. No policy was manufactured merely to make acceptance pass.
- Security Advisor remains the known **191 INFO / 0 WARN / 0 ERROR** baseline.

## Corrective acceptance gate

PR #71 is **draft/open and must not merge** until all of the following are true on one exact head:

1. required CI checks pass;
2. targeted CF-093 source/runtime acceptance passes;
3. all current Codex threads are reconciled against runtime evidence;
4. exact-head Codex re-review of `f3622ff51654969fcd37961392b82449eb372218` is clean or any additional actionable finding is corrected forward-only;
5. required queueable deterministic Layer 2 consequential/nominated acceptance is clean on an actually governed policy-qualified target;
6. post-merge deployed acceptance is green before CF-093 is returned to CLOSED/PASS.

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

CF-CHG-20260910-093 remains **REOPENED** until PR #71 completes exact-head Codex, CI, targeted acceptance and required deployed-UAT gates. The full orchestrator scope must not be closed while Preview-bound asynchronous discovery and the broader explicitly-disabled capabilities remain unimplemented.
