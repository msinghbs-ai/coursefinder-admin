# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 TECHNICAL GATES CLEAN / EXTERNAL REVIEW + ACCEPTANCE BLOCKED  
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
- All previously actionable inline review threads: resolved.
- Fresh Codex exact-head verdict: BLOCKED by reported repo-environment prerequisite.
- Pilot Edge worker remains v1.3.10 / Edge29 / SHA `665c56ade30fa89b517255bb023c8ce1a15f88df3935845baeeba17cca21c051`, `verify_jwt=false`; latest repo worker fixes are not deployed pending Codex clean.
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
- [ ] Fresh exact-head Codex verdict clean — blocked by Codex repo-environment prerequisite.

## Gate B — reconstruction / migration currentness

- [x] Applied migrations immutable.
- [x] Runtime/source reconciled to applied `20260913063252` and `20260913063321`.
- [x] Temporary source-only aliases `062000`/`064500` removed.
- [x] Full ordered Fresh Reconstruction `34743276592` PASS.
- [x] Accepted-main fixture models only verified dependencies and does not fabricate provider/route rows.

## Gate C — deployed worker currentness

- [x] Existing custom nonce/auth boundary verified; Edge29 has `verify_jwt=false`.
- [ ] After Codex clean, deploy exact repo worker to Pilot.
- [ ] Verify deployed version/SHA/source contains bounded continuation + identity-drift fail-closed fixes and preserves `verify_jwt=false`.

## Gate D — UQ corrective discovery

- [ ] Start a **new** authenticated UQ corrective acceptance on reviewed/deployed exact head.
- [ ] Connected GitHub toolset currently lacks new workflow-dispatch; use authorised GitHub UI/API dispatch rather than rerun/direct SQL.
- [ ] Reconcile deterministic L2 changes only and prove exact-token/fingerprint/dedupe + zero generic L3/L4/Search/Publication side effects.

## Gate E — RMIT corrective discovery

- [ ] Run only after UQ is clean.
- [ ] Reconcile deterministic L2 changes only and retain authority boundaries.

## Gate F — bounded Layer 3

- [x] Generic scheduler Layer 3 remains disabled.
- [ ] Recalculate eligible Layer 3 cohort only after deterministic L2 acceptance closes.

## Gate G — final PR acceptance

- [x] Exact-head CI/reconstruction/build/Cloudflare technical gates clean at `4e67e322...`.
- [ ] Fresh exact-head Codex clean.
- [ ] Worker deployed-currentness clean.
- [ ] Corrective UQ/RMIT acceptance clean.
- [ ] Final security/authority/UAT/runtime clean.
- [ ] Merge/release and post-merge main/deployed verification.

## Exact next action

Satisfy the Codex repository-environment prerequisite and obtain a clean exact-head review for `4e67e322...`. Then deploy/verify the exact repo worker and start a **new** UQ corrective acceptance workflow dispatch. Do not bypass either gate. RMIT, Layer 3, merge and release remain paused.