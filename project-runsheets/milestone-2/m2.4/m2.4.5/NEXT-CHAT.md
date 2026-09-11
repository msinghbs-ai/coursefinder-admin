# M2.4.5 NEXT CHAT

## Accepted active baseline — 11 September 2026

- Accepted Pilot `main`: **`643eef810ab10ab9679ab6687ee549b0664c5691`** after CF-093 functional PR #67 and v2.15.77 release-currentness PR #68.
- Visible Admin release: **v2.15.77**.
- CF-092 remains **CLOSED / PASS**. CF-093 Phase A is accepted; Phase B target builder remains ACTIVE.
- PR #67 post-merge Release History `34550482710`, Frontend Build `34550482729`, Deployed UAT `34550482733` — PASS.
- PR #68 post-merge Release History `34553234972`, Frontend Build `34553235073`, Deployed UAT `34553235214` — PASS.
- Pilot Security Advisor remains at the known **191 INFO / 0 WARN / 0 ERROR** baseline. Production unchanged; no Production Supabase project exists; M2.5 remains paused at P0.

## Active CF-093 Phase B

Pilot PR: **#69 — CF-093: add governed Scheduled Tasks target-builder slice**  
Pilot branch: `m245/cf093-target-builder-20260911`  
Current candidate: **`b3203c9a4a4e44f79e79637d96b6e0f2ca408c59`**  
Admin governance PR: **#34** on the matching branch.

Applied Pilot runtime lineage is immutable:

- `20260911021144 cf_093_scheduler_workflow_builder_slice`
- `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix`
- `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency`
- `20260911023721 cf_093_scheduler_workflow_codex_second_pass`

Current executable boundary remains deliberately narrow: AU Course Facts Layer 2 only; server-authorised Country/State/University targets; Acquisition + deterministic Layer 2 only; server preview receipt required; generic L3/L4 orchestration, Evidence reprocess and recurring scope construction remain disabled; Search/Publication remain separate.

## Codex / acceptance state

First Codex review raised seven findings; all corrected and resolved. Re-review of `fe69259a...` raised five additional edge cases: dispatch-time dedupe basis, busy-state invalidation, valid-current-profile enforcement, hidden selected Provider after search change, and arbitrary country scope IDs. All five are corrected and their threads are resolved.

At `b3203c9a...`:

- Release History Contract `34555446950` — PASS.
- Pilot Frontend Build/local browser smoke `34555446880` — PASS.
- Cloudflare PR preview deployment — PASS.
- Runtime country scope with arbitrary UUID fails closed with `22023 country scope must not include a scope id`.
- v2 recent-dispatch dedupe uses stored `consumed_at`.
- current enabled/non-paused Course Facts profiles had no invalid current profile version at the recorded runtime check.
- exact-head Codex re-review was requested in PR #69 comment `5628647173`; result remained pending at the last continuity write.

## Exact next gate

1. Read the exact Codex result for `b3203c9a4a4e44f79e79637d96b6e0f2ca408c59`.
2. If any actionable finding exists, apply the smallest forward-only correction; never retimestamp applied migrations.
3. When Codex is clean, use **RMIT University Pathways, RMIT UP** (`30b81368-9003-4775-81af-60439fc3b109`) for the nominated bounded acceptance. It had 3 governed Courses at the recorded runtime state.
4. Run fresh preview -> v2 dispatch -> immediate retry/dedupe proof -> Jobs/Evidence follow-through; verify no manufactured Layer 3/Layer 4/Search/Publication consequence.
5. If clean, mark PR #69 ready, merge, then perform the governed visible-release promotion/currentness and deployed UAT/security reconciliation.
6. Reconcile Change Control, REGISTER, RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT before closing the slice.

## Pickup text

> Continue CourseFinder M2.4.5 from repository/runtime truth. Accepted Pilot main is `643eef810ab10ab9679ab6687ee549b0664c5691`, visible v2.15.77. CF-093 Phase B is active in Pilot PR #69 at candidate `b3203c9a4a4e44f79e79637d96b6e0f2ca408c59`; runtime migrations are applied through `20260911023721 cf_093_scheduler_workflow_codex_second_pass`. Exact-head Release History `34555446950`, Frontend Build `34555446880`, and PR preview deployment are PASS. Fresh Codex re-review comment `5628647173` is the current blocker. After a clean result, execute the nominated three-Course RMIT UP preview -> dispatch -> idempotency/Jobs/Evidence acceptance. Keep generic L3/L4, Evidence reprocess, recurring scope construction and implicit Search/Publication disabled.
