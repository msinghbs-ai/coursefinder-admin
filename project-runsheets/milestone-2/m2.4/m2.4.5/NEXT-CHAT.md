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
Current candidate: **`aae269c3c69fe3203a78f7bf5416bcf9ca3c7227`**  
Admin governance PR: **#34** on the matching branch.

Applied Pilot runtime lineage is immutable:

- `20260911021144 cf_093_scheduler_workflow_builder_slice`
- `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix`
- `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency`
- `20260911023721 cf_093_scheduler_workflow_codex_second_pass`
- `20260911025332 cf_093_scheduler_workflow_codex_third_pass`
- `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass`

Current executable boundary remains deliberately narrow: AU Course Facts Layer 2 only; server-authorised Country/State/University targets; Acquisition + deterministic Layer 2 only; server preview receipt required. Generic L3/L4 orchestration, Evidence reprocess and recurring country/state scope construction remain disabled; Search/Publication remain separate.

## Latest Codex / acceptance state

Exact-head Codex review of `1210a018db...` returned two additional findings:

1. **P1:** recent exact-scope dedupe was still filtered by operator, so two rank-4 operators could submit duplicate paid acquisition for the same discovery-bearing target;
2. **P2:** profile pause/disable could still race between the live preview statement and the later start statement, allowing a successful-looking empty `scope_started` result.

Smallest-safe forward correction:

- Pilot runtime migration `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass` is applied and represented by the same immutable repository identity;
- preview-token ownership remains actor-bound, but recent successful exact-scope dispatch reuse is now operator-independent under the existing exact-scope advisory lock;
- after `layer2_operator_scope_service(...,'start',...)`, the wrapper requires a non-empty `profiles` array inside the same transaction. An empty start raises, rolling back start-side effects instead of consuming the preview token as successful work;
- targeted CF-093 tests prove only the preview-token lookup remains actor-scoped and assert the atomic empty-start rejection;
- no Layer 1 authority, Layer 2 deterministic Evidence acquisition, Layer 3 Evidence/profile/model governance, Layer 4 human resolution, Search/Publication separation, rank/ACL boundary or unsupported-mode restriction was weakened.

Exact-head CI for `aae269c3...`:

- Release History Contract `34557840920` — running at this continuity write;
- Pilot Frontend Build `34557840961` — queued at this continuity write.

## Exact next gate

1. Confirm `34557840920` and `34557840961` PASS on exact head `aae269c3...`.
2. Reply/resolve the two latest Codex threads with the fourth-pass evidence and request exact-head Codex re-review.
3. Do not merge until that exact-head review is clean.
4. Then execute the nominated bounded **RMIT University Pathways, RMIT UP** (`30b81368-9003-4775-81af-60439fc3b109`) acceptance: preview -> v2 dispatch -> immediate retry/dedupe -> Jobs/Evidence follow-through; verify no manufactured Layer 3/Layer 4/Search/Publication consequence.
5. Only after functional acceptance: mark PR #69 ready, merge, publish/reconcile the next visible release and run deployed UAT/security/currentness.

## Pickup text

> Continue CourseFinder M2.4.5 from repository/runtime truth. Accepted main is `643eef810ab10ab9679ab6687ee549b0664c5691`, visible v2.15.77. CF-093 Phase B is active in Pilot PR #69 at `aae269c3c69fe3203a78f7bf5416bcf9ca3c7227`; Pilot runtime is applied through immutable forward migration `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass`. The latest Codex P1/P2 findings were corrected by operator-independent exact-scope dispatch dedupe and same-transaction rejection of an empty start result. Check exact-head CI, obtain clean Codex re-review, then run nominated RMIT UP bounded acceptance. Keep generic L3/L4, Evidence reprocess, recurring country/state construction and implicit Search/Publication disabled.
