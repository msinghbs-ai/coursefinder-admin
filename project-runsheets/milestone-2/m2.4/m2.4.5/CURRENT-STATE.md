# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 REVIEWED + DEPLOYED / UQ ACCEPTANCE DISPATCH PENDING  
**Reconciled:** 2026-09-13 AEST  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Visible accepted release:** v2.15.78  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Active candidate

- PR #72 / `m245/cf093-async-discovery-20260912` / exact head `4e67e32289235a88297502e90c8181f25639f300`.
- PR OPEN / DRAFT / UNMERGED; accepted main/release unchanged.
- Targeted Recovery `34743276597`: **PASS**.
- Fresh Reconstruction `34743276592`: **PASS**, through applied `20260913063252` and `20260913063321`.
- Frontend Build `34743276603`: **PASS**, including local browser smoke/evidence.
- Cloudflare exact-head preview: **PASS/deployed at `4e67e322`**.
- Codex current-head review submission for reviewed commit `4e67e32289`: **CLEAN / no new actionable findings**.
- All previously actionable inline review threads: **RESOLVED**.

## Repository/runtime currentness

Pilot migration history and repository source remain reconciled to immutable applied migrations:

- `20260913063252_cf_093_bound_resolution_identity_freshness_reconcile`
- `20260913063321_cf_093_bound_handoff_queueable_provenance_reconcile`

Temporary source-only aliases remain removed. Applied migration identity was not rewritten/renamed/retimestamped.

Pilot discovery worker is now deployed-current with the reviewed repository source:

- worker: `layer2-scope-discover-scheduled-v1.3.10`
- Edge version: **30**
- SHA: `a1037f04b5ea2a0d5300a900148b725632123b57c349308e8437a7995951560e`
- `verify_jwt=false`
- existing one-time nonce/custom auth boundary preserved.

## Security / authority

- Layer 1 identity/regulatory authority unchanged.
- Layer 2 deterministic, Evidence-preserving, Preview-bound and fail-closed.
- Failed/nonterminal candidate outcomes remain recoverable; only governed resolved outcomes are consumed.
- Bound selected outcomes require exact Preview-token provenance.
- Terminal freshness is invalidated by Layer 1 identity change.
- Mixed handoff retains pre-existing queueable URLs already covered by the binding fingerprint.
- Generic scheduler Layer 3/4 remains disabled; Search/Publication remains separate.
- No consequential UQ/RMIT run has yet been dispatched after Edge v30 deployment.

## Exact next gate

1. Start a **new** `CF-093 UQ Corrective Acceptance` `workflow_dispatch` on reviewed/deployed head `4e67e322...`. The current GitHub connector exposes workflow reads/reruns but no new dispatch action; use authorised GitHub UI/API dispatch or equivalent normal authenticated Admin/PIM scheduler path, not direct DB/RPC execution.
2. Reconcile deterministic UQ L2 changes and prove exact-token/fingerprint/dedupe/cancel plus zero generic L3/L4/Search/Publication side effects.
3. RMIT only after UQ clean; Layer 3 only after deterministic L2 closes.
4. Merge/release only after all governed gates close, followed by main CI/deployment/deployed-UAT verification.

M2.4.4 remains CLOSED/PASS/FROZEN and M2.5 remains paused.