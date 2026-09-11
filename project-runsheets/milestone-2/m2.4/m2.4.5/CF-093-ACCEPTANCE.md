# CF-093 Acceptance Plan

**Status:** PHASE A PASS / PHASE B TARGET BUILDER ACTIVE  
**Updated:** 11 Sep 2026

## Accepted Phase A — Scheduled Tasks operator catalogue

Accepted Pilot main is `643eef810ab10ab9679ab6687ee549b0664c5691` after functional PR #67 and release-currentness PR #68. Visible Admin release remains **v2.15.77**.

Phase A acceptance remains unchanged: PR #67 post-merge Release History `34550482710`, Frontend Build `34550482729`, Deployed UAT `34550482733`; PR #68 post-merge Release History `34553234972`, Frontend Build `34553235073`, Deployed UAT `34553235214` — all PASS. Production remains unchanged and no Production Supabase project exists.

## Phase B — target builder/orchestration

Pilot branch: `m245/cf093-target-builder-20260911`  
Pilot PR: **#69**  
Base: accepted v2.15.77 main `643eef810ab10ab9679ab6687ee549b0664c5691`.

The generic `refresh_policy_upsert_v2` remains unsuitable as a universal scope constructor because it does not prove downstream enforcement of country/state/provider selections. The Phase B slice therefore uses the existing server-authorised Layer 2 Course Facts scope services only.

### Applied Pilot runtime lineage

1. `20260911021144 cf_093_scheduler_workflow_builder_slice` — initial AU Course Facts builder.
2. `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix` — authenticated private-bridge EXECUTE restored while anon remains denied.
3. `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency` — server preview token, v1 run retirement, exact-target locking/dedupe and truthful preview receipt semantics.
4. `20260911023721 cf_093_scheduler_workflow_codex_second_pass` — post-dispatch dedupe timing, valid-current-profile enforcement and canonical country-scope guard.

Applied migration identities are immutable; any further correction must be forward-only.

### Current executable boundary

- AU only.
- Course Facts enrichment only.
- Country / State-Territory / University-Provider server-authorised scopes.
- Processing mode: **Acquisition + deterministic Layer 2** only.
- Same-actor exact-target server preview required and valid up to 15 minutes.
- No runnable token when scoped current Layer 2 profile versions are absent/invalid or no executable work exists.
- Dispatch re-checks profile validity before execution.
- Country scope rejects a non-null scope ID.
- Exact-target duplicate protection uses actual `consumed_at` dispatch time.
- Scope/target/search changes invalidate browser preview state; stale option/preview responses cannot authorise another target.
- Generic L3/L4 orchestration, Evidence reprocess and recurring scope construction remain unavailable.
- Search/Publication remain downstream governed consequences only.

### Codex history

Initial review of `216c2854...` produced seven actionable findings, all corrected and resolved.

Re-review of `fe69259a540fcbce36d39c340d40d6fe9bd391dd` produced five further findings:

1. P1 dedupe window based on preview creation rather than dispatch time;
2. P2 stale preview invalidation could leave `busy` stuck;
3. P2 executable check did not require a valid current Layer 2 profile version;
4. P2 changing university search could leave a hidden selected Provider UUID runnable;
5. P1 arbitrary country scope IDs could distinguish the same AU-wide workload and bypass dedupe.

All five are corrected at current Pilot candidate **`b3203c9a4a4e44f79e79637d96b6e0f2ca408c59`** and their review threads are resolved. A fresh exact-head Codex review is requested and remains the active merge blocker until it reports no new actionable finding.

### Exact-head evidence at `b3203c9a...`

- Release History Contract `34555446950` — PASS.
- Pilot Frontend Build/local browser smoke `34555446880` — PASS.
- Cloudflare PR preview deployment for `b3203c9a...` — PASS.
- Runtime migration history contains `20260911023721`.
- Runtime negative proof: country scope plus arbitrary UUID returns `22023 country scope must not include a scope id`.
- Current enabled/non-paused Course Facts runtime cohort has no invalid current profile version at the checked state.
- Runtime v2 definition uses `consumed_at` for recent-dispatch dedupe.
- Security remains at the previously checked **191 INFO / 0 WARN / 0 ERROR** baseline with no known CF-093 warning/error regression.

## Nominated bounded functional acceptance target

Use **RMIT University Pathways, RMIT UP** (`30b81368-9003-4775-81af-60439fc3b109`) only after exact-head Codex is clean. It has three governed catalogue Courses at the recorded runtime state and is materially safer for the nominated preview -> dispatch acceptance than the 500-Course RMIT University scope.

Required proof:

1. fresh server preview token for the exact University target;
2. preview remains executable and profile-qualified;
3. one governed v2 dispatch with an explicit acceptance reason;
4. immediate retry/double-submit reuses the same recent dispatch rather than creating paid duplicate acquisition;
5. Jobs/Evidence follow-through reflects underlying Layer 2 truth rather than manufactured completion;
6. no generic Layer 3, Layer 4, Search or Publication side effect;
7. retain exact request/job/evidence identifiers as acceptance evidence.

## Exact next gate

1. Obtain clean Codex review of `b3203c9a4a4e44f79e79637d96b6e0f2ca408c59`.
2. Execute the nominated three-Course RMIT UP preview -> v2 dispatch -> idempotency/follow-through proof.
3. Re-run targeted security/authority checks if the nominated run exposes any new runtime path.
4. If clean, mark PR #69 ready and merge without changing visible release yet unless the release contract requires promotion in the same governed batch.
5. Publish the next visible release only after the functional Phase B gate passes; then run deployed UAT/currentness/security reconciliation.
6. Reconcile Change Control, REGISTER, RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT.

Do not merge or bump the visible release while exact-head Codex or nominated runtime acceptance remains open.
