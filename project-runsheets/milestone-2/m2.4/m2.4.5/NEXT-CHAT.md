# M2.4.5 NEXT CHAT

## Accepted active baseline — 11 September 2026

- Accepted Pilot `main`: **`643eef810ab10ab9679ab6687ee549b0664c5691`** after CF-093 functional PR #67 and v2.15.77 release-currentness PR #68.
- Visible Admin release: **v2.15.77**.
- CF-092 remains **CLOSED / PASS**. CF-093 Phase A is accepted; Phase B target builder remains ACTIVE.
- PR #67 post-merge Release History `34550482710`, Frontend Build `34550482729`, Deployed UAT `34550482733` — PASS.
- PR #68 post-merge Release History `34553234972`, Frontend Build `34553235073`, Deployed UAT `34553235214` — PASS.
- Production unchanged; no Production Supabase project exists; M2.5 remains paused at P0.

## Active CF-093 Phase B

Pilot PR: **#69 — CF-093: add governed Scheduled Tasks target-builder slice**  
Pilot branch: `m245/cf093-target-builder-20260911`  
Current candidate: **`f01ef66437864db5b0d2f5a319ab7a80bb6f0073`**  
Admin governance PR: **#34** on the matching branch.

Applied Pilot runtime lineage is immutable:

- `20260911021144 cf_093_scheduler_workflow_builder_slice`
- `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix`
- `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency`
- `20260911023721 cf_093_scheduler_workflow_codex_second_pass`
- `20260911025332 cf_093_scheduler_workflow_codex_third_pass`
- `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass`
- `20260911052952 cf_093_scheduler_execution_policy_qualification`
- `20260911065626 cf_093_scheduler_policy_and_scope_limit_qualification`

Current executable boundary remains deliberately narrow: AU Course Facts Layer 2 only; server-authorised Country/State/University targets; Acquisition + deterministic Layer 2 only; server preview receipt required. Generic L3/L4 orchestration, Evidence reprocess and recurring country/state scope construction remain disabled; Search/Publication remain separate.

## Latest Codex / acceptance state

Codex exact-head review of `e1abc037c8c76b84639896177262470c7283df34` identified two further defects:

1. **P1 execution-policy coverage** — discovery-backed profiles were incorrectly exempted even though successful discovery auto-syncs into `layer2_run_batch_create`, so acquisition could spend resources before deterministic Layer 2 failed on a missing execution policy.
2. **P2 downstream service limit** — Country/State/University scopes could contain more than 1,000 courses for one profile even though the existing downstream start/batch contracts reject arrays above 1,000.

Smallest-safe forward correction is applied as immutable migration `20260911065626 cf_093_scheduler_policy_and_scope_limit_qualification` and represented at exact Pilot head `f01ef66437864db5b0d2f5a319ab7a80bb6f0073`:

- every scoped Course Facts profile, including discovery-backed profiles, must have a `pipeline.layer2_execution_policies` row before preview can issue a token;
- dispatch re-checks the same execution-policy qualification immediately before start;
- preview computes per-profile scoped course counts and fails closed if any profile exceeds 1,000 courses;
- dispatch re-checks the same 1,000-course bound;
- helper functions remain private to the security boundary; authenticated browser execution still routes through the existing public wrappers and independent rank checks;
- no prior applied migration was retimestamped or rewritten.

Runtime truth after the correction:

- RMIT University Pathways / RMIT UP now reports **1 execution-policy gap**, so it is no longer allowed to spend discovery acquisition before deterministic Layer 2 would fail.
- Nova Higher Education also reports **1 execution-policy gap**.
- Current AU runtime has **0 oversized profiles**; maximum current scoped Course Facts profile size is **665 courses**. The >1,000 guard is still required because Country/State/University are supported scope types and must fail closed before a downstream service-limit failure.
- Pilot Security Advisor remains **191 INFO / 0 WARN / 0 ERROR**, unchanged known `rls_enabled_no_policy` baseline.

Exact-head CI for `f01ef664...`:

- Release History Contract `34572186142` — **PASS**.
- Pilot Frontend Build `34572186144` — **PASS**.

Both new Codex threads were replied to with runtime evidence and resolved. Fresh exact-head Codex re-review was requested in PR #69 comment **`5630709016`**.

## Remaining acceptance blocker

Pilot currently has only two Course Facts execution-policy rows across the enabled profile inventory, and both nominated RMIT UP / Nova scopes lack one. Therefore a consequential target-builder run must remain blocked until the selected profile has a governed execution policy through the normal operational control plane. No execution policy is being manufactured purely to make UAT pass.

## Exact next gate

1. Obtain clean exact-head Codex review for `f01ef664...`.
2. Re-run/confirm targeted negative acceptance for unauthenticated/low-rank/unsupported mode/invalid or mismatched preview paths against the current runtime.
3. Identify a Course Facts scope whose profile already has a valid governed execution policy, or configure one through the normal operational control plane, then prove preview -> dispatch -> Layer 2 Job/Evidence follow-through.
4. Verify no generic Layer 3/Layer 4/Search/Publication side effect.
5. Do not merge PR #69 until the above acceptance is green.
6. Only after functional acceptance: mark PR #69 ready, merge, publish/reconcile the next visible release and run deployed UAT/security/currentness.

## Pickup text

> Continue CourseFinder M2.4.5 from repository/runtime truth. Accepted main is `643eef810ab10ab9679ab6687ee549b0664c5691`, visible v2.15.77. CF-093 Phase B is active in Pilot PR #69 at `f01ef66437864db5b0d2f5a319ab7a80bb6f0073`; Pilot runtime is applied through immutable forward migration `20260911065626 cf_093_scheduler_policy_and_scope_limit_qualification`. Exact-head Release History `34572186142` and Frontend Build `34572186144` PASS; Security Advisor remains 191 INFO / 0 WARN / 0 ERROR. Codex re-review is pending. Discovery-backed and queueable profiles now both require the deterministic Layer 2 execution policy before acquisition/dispatch, and scopes fail closed if one profile exceeds 1,000 courses. Keep generic L3/L4, Evidence reprocess, recurring country/state construction and implicit Search/Publication disabled.
