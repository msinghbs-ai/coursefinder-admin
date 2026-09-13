# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 REVIEWED + DEPLOYED / UQ ACCEPTANCE DISPATCH PENDING  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-13 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Active candidate: PR #72 / `m245/cf093-async-discovery-20260912` / exact head `4e67e32289235a88297502e90c8181f25639f300`.
- Targeted Recovery `34743276597`: PASS.
- Fresh Reconstruction `34743276592`: PASS through applied `20260913063252` + `20260913063321`.
- Frontend Build `34743276603`: PASS including local browser smoke/evidence.
- Cloudflare exact-head preview: PASS/deployed at `4e67e322`.
- Codex reviewed commit `4e67e32289`: CLEAN / no new actionable findings.
- Pilot worker deployed-current: v1.3.10 / Edge30 / SHA `a1037f04b5ea2a0d5300a900148b725632123b57c349308e8437a7995951560e`, `verify_jwt=false`.
- Production Supabase: not provisioned.

## Gate A — exact-head recovery

- [x] Failed/nonterminal candidate outcomes remain in bounded continuation/recovery.
- [x] Candidate-detail exact-binding identity drift fails closed before candidate write.
- [x] Exact Preview-token provenance enforced for selected discovery outcomes.
- [x] Layer 1 identity changes invalidate terminal-negative freshness.
- [x] Mixed bound handoff preserves pre-existing queueable URLs already protected by queueable fingerprint.
- [x] Targeted Recovery `34743276597` PASS including new regressions.
- [x] Frontend Build/local browser smoke `34743276603` PASS.
- [x] Cloudflare exact-head preview deployed at `4e67e322`.
- [x] All known actionable inline review threads resolved.
- [x] Fresh exact-head Codex review clean for reviewed commit `4e67e32289`.

## Gate B — reconstruction / migration currentness

- [x] Applied migrations immutable.
- [x] Runtime/source reconciled to applied `20260913063252` and `20260913063321`.
- [x] Temporary source-only aliases `062000`/`064500` removed.
- [x] Full ordered Fresh Reconstruction `34743276592` PASS.
- [x] Accepted-main fixture models only verified dependencies and does not fabricate provider/route rows.

## Gate C — deployed worker currentness

- [x] Exact reviewed repo worker deployed to Pilot.
- [x] Edge v30 verified active with SHA `a1037f04b5ea2a0d5300a900148b725632123b57c349308e8437a7995951560e`.
- [x] Bounded continuation and detail identity-drift fail-closed fixes present.
- [x] `verify_jwt=false` retained with existing custom one-time nonce/auth boundary.

## Gate D — UQ corrective discovery

- [ ] Start a **new** authenticated UQ corrective acceptance on reviewed/deployed exact head.
- [ ] Connected GitHub toolset currently lacks new workflow-dispatch; use authorised GitHub UI/API dispatch or equivalent normal authenticated Admin/PIM scheduler path, not rerun/direct SQL.
- [ ] Reconcile deterministic L2 changes only and prove exact-token/fingerprint/dedupe/cancel + zero generic L3/L4/Search/Publication side effects.

## Gate E — RMIT corrective discovery

- [ ] Run only after UQ is clean.
- [ ] Reconcile deterministic L2 changes only and retain authority boundaries.

## Gate F — bounded Layer 3

- [x] Generic scheduler Layer 3 remains disabled.
- [ ] Recalculate eligible Layer 3 cohort only after deterministic L2 acceptance closes.

## Gate G — final PR acceptance

- [x] Exact-head CI/reconstruction/build/Cloudflare technical gates clean at `4e67e322...`.
- [x] Exact-head Codex clean.
- [x] Worker deployed-currentness clean.
- [ ] Corrective UQ/RMIT acceptance clean.
- [ ] Final security/authority/UAT/runtime clean.
- [ ] Merge/release and post-merge main/deployed verification.

## Exact next action

Dispatch a **new** `CF-093 UQ Corrective Acceptance` on reviewed/deployed head `4e67e322...`. Do not rerun an older attempt and do not use direct DB/RPC as a substitute. RMIT, Layer 3, merge and release remain paused until consequential acceptance closes.