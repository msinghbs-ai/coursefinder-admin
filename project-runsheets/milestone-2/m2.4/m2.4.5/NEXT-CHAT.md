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
Current candidate: **`e1abc037c8c76b84639896177262470c7283df34`**  
Admin governance PR: **#34** on the matching branch.

Applied Pilot runtime lineage is immutable:

- `20260911021144 cf_093_scheduler_workflow_builder_slice`
- `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix`
- `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency`
- `20260911023721 cf_093_scheduler_workflow_codex_second_pass`
- `20260911025332 cf_093_scheduler_workflow_codex_third_pass`
- `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass`
- `20260911052952 cf_093_scheduler_execution_policy_qualification`

Current executable boundary remains deliberately narrow: AU Course Facts Layer 2 only; server-authorised Country/State/University targets; Acquisition + deterministic Layer 2 only; server preview receipt required. Generic L3/L4 orchestration, Evidence reprocess and recurring country/state scope construction remain disabled; Search/Publication remain separate.

## Latest Codex / acceptance state

Codex exact-head review of `aae269c3c69fe3203a78f7bf5416bcf9ca3c7227` returned **no major issues**.

Required nominated acceptance was then executed against Pilot runtime:

- RMIT University Pathways / RMIT UP (`30b81368-9003-4775-81af-60439fc3b109`) preview was executable for 3 courses, all discovery-backed.
- Consequential dispatch succeeded with request `5726`.
- Immediate same-token retry returned `idempotent_replay=true`.
- A fresh preview/dispatch under a different rank-4 operator returned `existing_recent_dispatch=true` and deduplicated against the first preview receipt, proving cross-operator exact-scope dedupe.
- Jobs recorded only `scheduler_workflow_preview` plus the underlying `layer2_discovery`; no manufactured generic Layer 3/Layer 4/Search/Publication job was created.
- The resulting Layer 2 discovery job completed with `selected=0 / processed=0`, so RMIT UP did not by itself prove Evidence production.

A second one-course queueable target, Nova Higher Education (`340f8a84-c04e-4a7c-ad43-1b37755b0018`), exposed a new fail-closed defect: preview reported executable, but dispatch failed in `layer2_run_batch_create` with **`execution policy missing`**.

Smallest-safe forward correction is now applied as immutable migration `20260911052952 cf_093_scheduler_execution_policy_qualification` and represented in repository history:

- fully queueable profiles (no discovery required) must have a `pipeline.layer2_execution_policies` row before preview can issue a token;
- preview returns `missing_execution_policy_count` and a truthful block reason when the policy is absent;
- dispatch re-checks the same policy qualification immediately before start;
- discovery-backed profiles remain eligible because that execution path does not call `layer2_run_batch_create` and therefore does not require a run-batch policy;
- helper function EXECUTE is revoked from browser roles; public browser wrappers and independent rank gates remain unchanged.

Runtime negative proof after the correction: Nova now returns `executable=false`, `preview_token=null`, `missing_execution_policy_count=1`; RMIT UP remains executable with `missing_execution_policy_count=0`.

Exact-head CI for `e1abc037...`:

- Release History Contract `34566251054` — in progress at this continuity write;
- Pilot Frontend Build `34566251196` — in progress at this continuity write.

Exact-head Codex re-review requested in PR #69 comment `5629956836`.

## Exact next gate

1. Confirm `34566251054` and `34566251196` PASS on `e1abc037...`.
2. Obtain clean exact-head Codex review for `e1abc037...`.
3. Run targeted negative acceptance for unauthenticated/low-rank/unsupported mode/invalid or mismatched preview paths against the current runtime.
4. Select a **queueable target that also has a valid execution policy** and prove preview -> dispatch -> underlying Layer 2 Job/Evidence follow-through; the earlier Nova target is now correctly blocked because its required policy is missing.
5. Verify no generic Layer 3/Layer 4/Search/Publication side effect.
6. Do not merge PR #69 until the above acceptance is green.
7. Only after functional acceptance: mark PR #69 ready, merge, publish/reconcile the next visible release and run deployed UAT/security/currentness.

## Pickup text

> Continue CourseFinder M2.4.5 from repository/runtime truth. Accepted main is `643eef810ab10ab9679ab6687ee549b0664c5691`, visible v2.15.77. CF-093 Phase B is active in Pilot PR #69 at `e1abc037c8c76b84639896177262470c7283df34`; Pilot runtime is applied through immutable forward migration `20260911052952 cf_093_scheduler_execution_policy_qualification`. Codex was clean on the prior exact head, but nominated acceptance exposed a queueable-profile execution-policy gap. That is now fail-closed at preview and dispatch. Check exact-head CI/Codex, then prove a queueable target with a valid execution policy through Layer 2 Job/Evidence follow-through before merge. Keep generic L3/L4, Evidence reprocess, recurring country/state construction and implicit Search/Publication disabled.
