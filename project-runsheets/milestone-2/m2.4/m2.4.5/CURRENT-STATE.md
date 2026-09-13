# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 TECHNICAL GATES CLEAN / EXTERNAL REVIEW + ACCEPTANCE BLOCKED  
**Reconciled:** 2026-09-13 AEST  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Visible accepted release:** v2.15.78  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Active candidate

- PR #72 / `m245/cf093-async-discovery-20260912` / exact head `4e67e32289235a88297502e90c8181f25639f300`.
- PR OPEN / DRAFT / UNMERGED; accepted main/release unchanged.
- Targeted Recovery `34743276597`: **PASS**.
- Fresh Reconstruction `34743276592`: **PASS**, full chain through applied `20260913063252` and `20260913063321`.
- Frontend Build `34743276603`: **PASS**, including local browser smoke/evidence.
- Cloudflare exact-head preview: **PASS/deployed at `4e67e322`**.
- All previously actionable inline review threads: **RESOLVED**.
- Fresh exact-head Codex review comment `5651716801`: verdict unavailable because Codex reports a repository-environment prerequisite.

## Repository/runtime currentness

Pilot migration history and repository source are reconciled to immutable applied migrations:

- `20260913063252_cf_093_bound_resolution_identity_freshness_reconcile`
- `20260913063321_cf_093_bound_handoff_queueable_provenance_reconcile`

Temporary source-only aliases `062000`/`064500` were removed. Applied migration identity was not rewritten/renamed/retimestamped.

Repository worker contains the current fail-closed continuation and identity corrections. Pilot Edge remains v29 / SHA `665c56ade30fa89b517255bb023c8ce1a15f88df3935845baeeba17cca21c051`, `verify_jwt=false`, under the existing nonce boundary and predates the final repo worker fixes. Deployment is intentionally held until the required fresh exact-head review is clean.

## Security / authority

- Layer 1 identity/regulatory authority unchanged.
- Layer 2 deterministic, Evidence-preserving, Preview-bound and fail-closed.
- Failed/nonterminal candidate outcomes remain recoverable; only governed resolved outcomes are consumed.
- Bound selected outcomes require exact Preview-token provenance.
- Terminal freshness is invalidated by Layer 1 identity change.
- Mixed handoff retains pre-existing queueable URLs already covered by the binding fingerprint.
- Generic scheduler Layer 3/4 remains disabled; Search/Publication remains separate.
- No consequential UQ/RMIT run was dispatched during recovery.

## Exact next gate

1. Create/enable the Codex repo environment and obtain a clean review for `4e67e322...`.
2. Deploy/verify the exact repo worker to Pilot with `verify_jwt=false` and existing nonce boundary.
3. Start a **new** authenticated UQ corrective acceptance on the reviewed/deployed exact head. Current GitHub connector exposes workflow reads/reruns but no workflow-dispatch action; do not replace this with direct DB/RPC execution.
4. RMIT only after UQ clean; Layer 3 only after deterministic L2 closes.
5. Merge/release only after all governed gates close, followed by main CI/deployment/deployed-UAT verification.

M2.4.4 remains CLOSED/PASS/FROZEN and M2.5 remains paused.