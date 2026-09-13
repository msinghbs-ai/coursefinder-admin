# M2.4.5 NEXT CHAT

## Current pickup — 13 September 2026

- Milestone: **M2.4.5 ACTIVE / PRE-PRODUCTION HARDENING — CF-093 REVIEWED + DEPLOYED / UQ ACCEPTANCE DISPATCH PENDING**.
- M2.5 remains PAUSED at P0; no Production Supabase exists.
- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Active change: `CF-CHG-20260910-093`.
- PR #72: OPEN / DRAFT / UNMERGED, exact head `4e67e32289235a88297502e90c8181f25639f300`.
- Targeted Recovery `34743276597`: PASS.
- Fresh Reconstruction `34743276592`: PASS through authoritative applied migrations `20260913063252` and `20260913063321`.
- Frontend Build `34743276603`: PASS including local browser smoke/evidence.
- Cloudflare exact-head preview: PASS/deployed at `4e67e322`.
- Codex reviewed commit `4e67e32289`: CLEAN / no new actionable findings.
- All previously actionable inline review threads are resolved.
- Pilot discovery worker is deployed-current: `layer2-scope-discover-scheduled-v1.3.10`, Edge v30, SHA `a1037f04b5ea2a0d5300a900148b725632123b57c349308e8437a7995951560e`, `verify_jwt=false`, one-time nonce/custom auth boundary preserved.

## Runtime / repository truth

- Applied/runtime migration identities are `20260913063252_cf_093_bound_resolution_identity_freshness_reconcile` and `20260913063321_cf_093_bound_handoff_queueable_provenance_reconcile`.
- Repository and Fresh Reconstruction use those exact identities; temporary aliases `062000`/`064500` remain removed.
- Reviewed worker source now matches Pilot deployed v30 and contains bounded continuation + fail-closed candidate-detail identity-drift handling.

## Authority boundaries

Layer 1 authority, deterministic/Evidence-preserving Layer 2, separate governed Layer 3/4/Search/Publication, rank/ACL/private-helper boundaries and fail-closed Preview provenance remain unchanged. No direct SQL/RPC substitute is authorised for consequential acceptance.

## Exact next actions

1. Dispatch a **new** `CF-093 UQ Corrective Acceptance` `workflow_dispatch` against exact head `4e67e322...`. The current GitHub connector exposes workflow reads/reruns but no new dispatch operation; use authorised GitHub UI/API dispatch or equivalent normal authenticated Admin/PIM scheduler path. Do not rerun an older SHA or use direct database execution.
2. Reconcile new deterministic UQ L2 evidence and explicitly prove exact-token/fingerprint/dedupe/cancel behaviour plus zero generic Layer3/Layer4/Search/Publication side effects.
3. Run RMIT only after UQ clean.
4. Recalculate eligible Layer 3 cohort only after deterministic L2 acceptance closes.
5. Merge/release only after every governed gate is clean, followed by main CI, Cloudflare/deployed currentness and deployed UAT verification.

## Pickup text

> Continue CF M2.4.5 / CF-CHG-20260910-093 from repository/runtime truth. Accepted Pilot main remains `63c7107cfce2d8f607fc378af4881d0ba28ca879`, release v2.15.78. PR #72 is draft/open at exact head `4e67e32289235a88297502e90c8181f25639f300`. Exact-head Targeted Recovery `34743276597`, Fresh Reconstruction `34743276592`, Frontend Build `34743276603`, Cloudflare deployment and Codex review of commit `4e67e32289` are clean. Runtime/source migrations are reconciled to applied `20260913063252` and `20260913063321`. Pilot worker is deployed-current as Edge30 / SHA `a1037f04b5ea2a0d5300a900148b725632123b57c349308e8437a7995951560e`, preserving `verify_jwt=false` and the one-time nonce boundary. The sole next gate is a NEW `CF-093 UQ Corrective Acceptance` workflow_dispatch on this reviewed/deployed head; connected GitHub tooling cannot start a new dispatch, so use authorised GitHub UI/API or equivalent normal authenticated Admin/PIM path. RMIT, Layer 3, merge and release remain paused until consequential acceptance closes.