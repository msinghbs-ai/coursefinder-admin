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
Current candidate: **`1210a018db3451b31faafc14e0d0c4dfc69c9e12`**  
Admin governance PR: **#34** on the matching branch.

Applied Pilot runtime lineage is immutable:

- `20260911021144 cf_093_scheduler_workflow_builder_slice`
- `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix`
- `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency`
- `20260911023721 cf_093_scheduler_workflow_codex_second_pass`
- `20260911025332 cf_093_scheduler_workflow_codex_third_pass`

Current executable boundary remains deliberately narrow: AU Course Facts Layer 2 only; server-authorised Country/State/University targets; Acquisition + deterministic Layer 2 only; server preview receipt required. Generic L3/L4 orchestration, Evidence reprocess and recurring country/state scope construction remain disabled; Search/Publication remain separate.

## Latest Codex / acceptance state

Exact-head Codex review of `b3203c9a...` returned three P2 findings:

1. shared busy state could allow scope/target changes to overlap an in-flight dispatch;
2. dispatch could consume a stale preview as a successful no-op if its only profile became paused/disabled after preview;
3. the injected builder exposed enabled Preview controls to rank-3 read-only users.

Smallest-safe corrections are now in candidate `1210a018...`:

- UI uses separate preview/dispatch activity; dispatch locks target, mode and governance inputs while active;
- builder resolves governed role context and remains read-only below Pipeline Operator rank 4 while the server retains its independent rank gate;
- forward runtime migration `20260911025332` recomputes live authoritative Layer 2 preview/work at dispatch and fails closed if runnable work disappeared;
- targeted CF-093 contract tests cover the new race/rank/live-scope guards.

Current exact-head CI started:

- Release History Contract `34556438054` — running at the continuity write;
- Pilot Frontend Build `34556438021` — running at the continuity write.

## Exact next gate

1. Confirm both `34556438054` and `34556438021` PASS on `1210a018...`.
2. Reconcile Pilot runtime/repository identity `20260911025332`; rerun security/negative checks as needed.
3. Reply/resolve the three latest Codex threads with evidence and request exact-head Codex re-review of `1210a018...`.
4. Do not merge until the exact-head review is clean.
5. Then execute the nominated bounded **RMIT University Pathways, RMIT UP** (`30b81368-9003-4775-81af-60439fc3b109`) acceptance: preview -> v2 dispatch -> immediate retry/dedupe -> Jobs/Evidence follow-through; verify no manufactured Layer 3/Layer 4/Search/Publication consequence.
6. Only after functional acceptance: mark PR #69 ready, merge, publish/reconcile the next visible release and run deployed UAT/security/currentness.

## Pickup text

> Continue CourseFinder M2.4.5 from repository/runtime truth. Accepted main is `643eef810ab10ab9679ab6687ee549b0664c5691`, visible v2.15.77. CF-093 Phase B is active in Pilot PR #69 at `1210a018db3451b31faafc14e0d0c4dfc69c9e12`; Pilot runtime is applied through immutable forward migration `20260911025332 cf_093_scheduler_workflow_codex_third_pass`. Three latest Codex P2 findings were corrected by separating preview/dispatch UI state, rank-4 gating the builder, and re-proving live runnable L2 work at dispatch. Check exact-head CI, request/obtain clean Codex re-review, then run the nominated RMIT UP bounded acceptance. Keep generic L3/L4, Evidence reprocess, recurring country/state construction and implicit Search/Publication disabled.
