# CF-CHG-20260910-093 Acceptance

**Status:** REOPENED — CORRECTIVE ACCEPTANCE ACTIVE  
**Updated:** 11 Sep 2026

## Historical accepted deployed baseline

The earlier narrow target-builder slice was released as:

- Pilot functional target-builder PR **#69** merge `85bc068d379ed3fc9231d167cf524e56419e80f9`;
- release-currentness PR **#70** merge / deployed Pilot main `cfc4702ba57a58ea31936dcabbd96fdd765194e2`;
- visible PIM Admin release **v2.15.78**;
- Release History Contract `34579029903` — **PASS**;
- Pilot Frontend Build `34579029934` — **PASS**;
- CourseFinder Deployed UAT `34579029850` — **PASS**.

That historical acceptance is retained for audit, but **CF-CHG-20260910-093 is no longer CLOSED/PASS** because post-merge Codex review exposed additional runtime-contract defects. Forward-only corrective work is in Pilot PR **#71**.

## Current accepted authority boundary

The executable intent remains deliberately narrow:

- AU Course Facts only;
- Acquisition + deterministic Layer 2 only;
- mandatory actor-bound server Preview and exact dispatch revalidation;
- valid profile version, execution policy, bounded scope and runtime-usable acquisition route;
- Layer 1 authority unchanged;
- Layer 2 Jobs/Evidence remain processing truth;
- Layer 3 remains Evidence/profile/model/revalidation governed;
- Layer 4 remains audited human/exception resolution;
- Search and Publication remain separate governed boundaries;
- browser execution remains authenticated/rank-4 gated and private helpers remain protected.

Generic L3/L4 orchestration, generic Evidence reprocess, NZ Layer 2 enrichment, arbitrary Layer 1 construction, recurring country/state construction, unsupported recurring university construction and implicit Search/Publication remain disabled.

Generic discovery-backed Scheduled Tasks are explicitly disabled/fail-closed until a separate Preview-bound asynchronous worker payload/continuation contract is implemented and accepted. Queueable deterministic Layer 2 is the only generic Scheduled Tasks acquisition path that may remain executable.

## Immutable corrective runtime lineage

Applied Pilot migrations are immutable. Relevant lineage now includes:

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

No applied migration was retimestamped. Repository source is reconciled to immutable runtime identities `20260911111431` and `20260911120131`; stale pre-apply filename aliases were removed without changing migration semantics.

## Latest Codex corrective acceptance

Codex review of PR #71 head `f3622ff51654969fcd37961392b82449eb372218` returned three P2 findings: intentionally unsupported discovery was reported as a configuration defect, route qualification ignored a blocking malformed predecessor/fallback rule, and queueable allowlist parsing expanded `{query}` differently from the acquisition worker.

Forward-only migration `20260911120131 cf_093_scheduler_operator_reason_and_route_chain_finalizer` resolves those findings by:

- exposing `unsupported_discovery_count` with an operator-truthful fail-closed reason;
- evaluating deterministic provider routes in worker order and respecting blocking/fallback semantics;
- parsing queueable allowlist references literally, matching `layer2-acquire-v2`.

All three review threads were answered and resolved. Codex then reviewed exact corrective head **`00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575`** and reported **“Didn't find any major issues”** in PR #71 comment **`5634309865`**. This closes the Codex-review portion of the corrective gate only; it does not waive consequential acceptance.

## Current targeted evidence

- Pilot exact candidate: **`00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575`**.
- Pilot Frontend Build **`34597632959` — PASS**.
- Branch/commit Cloudflare preview deployment for `00c98f0c` — **PASS**.
- Security Advisor remains **191 INFO / 0 WARN / 0 ERROR**, the pre-existing informational RLS baseline.
- University of Queensland remains **382 total / 156 queueable / 226 discovery** and is intentionally non-executable from generic Scheduled Tasks because async discovery is fail-closed.
- Runtime-wide University target inventory confirms the only fully queueable AU University scopes are Nova Higher Education and Stamford International College; each is **1 queueable / 0 discovery**, route gaps 0, URL gaps 0, oversize 0, but **execution-policy gap 1**.
- No policy, source profile, route or runtime configuration has been manufactured merely to force UAT green.

## Historical consequential evidence retained

The earlier UQ acceptance that produced governed Layer 2 Evidence remains retained as historical evidence only: primary preview/dispatch token `18a3784a-1e2d-4c73-9d91-0b3ea04f7b30`; second preview token `29df92d3-9071-4e6e-92db-0bc5b9daa111`; University scope `e55396d2-869a-46ef-9d17-841c7eab1313`; UQ profile `c7976665-14f3-40ac-834b-a8ee1c8afc32`; profile version `9b3689b8-0d2a-4cde-a50f-b4fee4c06945`; Layer 2 start request `5727`; representative Job `3445bc7a-0495-4c96-9321-43e581c81742`; HTML Evidence `8738fcf9-a4e6-47ac-9880-a57e4405b42b`; extraction-input Evidence `1d06a4ff-52aa-4a68-8e89-b661c7903e1f`.

This evidence cannot be used to claim the newly disabled generic discovery-backed async contract is implemented.

## Current closure gate

CF-CHG-20260910-093 remains **REOPENED**. Do not merge corrective PR #71 or return this file to CLOSED/PASS until:

1. exact-head Codex review is clean — **PASS at `00c98f0cea...`**;
2. required exact-head CI/source/runtime acceptance is green — **current targeted checks PASS**;
3. a genuinely governed policy-qualified **queueable deterministic Layer 2** target completes required consequential acceptance without fabricating configuration for UAT — **BLOCKED by current runtime truth**;
4. the accepted exact head is merged;
5. post-merge deployed currentness/UAT is green.

The current blocker is not a software-review or CI failure. The runtime contains no genuinely policy-qualified fully queueable University target: Nova and Stamford are fully queueable but each lacks the governed deterministic execution policy; UQ and all State scopes require unsupported asynchronous discovery. Do not weaken Preview/authority or create test-only policy/configuration to bypass this gate.

The broader orchestrator scope remains explicitly open. Preview-bound asynchronous discovery, generic L3/L4, Evidence reprocess and recurring country/state scope construction must not be inferred from this corrective slice.
