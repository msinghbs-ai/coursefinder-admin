# M2.4.5 NEXT CHAT

## Current pickup — 13 September 2026

- Milestone: **M2.4.5 ACTIVE / PRE-PRODUCTION HARDENING — CF-093 TECHNICAL GATES CLEAN / EXTERNAL REVIEW + ACCEPTANCE BLOCKED**.
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
- All previously actionable inline review threads are resolved.
- Fresh exact-head Codex review was requested in PR comment `5651716801`, but no verdict has returned because the connector reports that a repository environment must be created.

## Runtime / repository truth

- Applied/runtime migration identities are `20260913063252_cf_093_bound_resolution_identity_freshness_reconcile` and `20260913063321_cf_093_bound_handoff_queueable_provenance_reconcile`.
- Repository and Fresh Reconstruction use those exact identities; temporary aliases `062000`/`064500` are removed.
- Repository worker v1.3.10 contains bounded continuation and fail-closed detail identity-drift corrections.
- Pilot Edge remains v29 / SHA `665c56ade30fa89b517255bb023c8ce1a15f88df3935845baeeba17cca21c051`, `verify_jwt=false`, under the existing custom one-time nonce boundary. It predates the latest repo worker fixes and must not be redeployed until fresh exact-head Codex is clean.

## Authority boundaries

Layer 1 authority, deterministic/Evidence-preserving Layer 2, separate governed Layer 3/4/Search/Publication, rank/ACL/private-helper boundaries and fail-closed Preview provenance remain unchanged. No direct SQL/RPC substitute is authorised for consequential acceptance.

## Exact next actions

1. Satisfy the Codex repo-environment prerequisite and obtain a clean exact-head verdict for `4e67e322...`.
2. Deploy the exact repository `layer2-scope-discover-scheduled` worker to Pilot with `verify_jwt=false`; verify deployed source/SHA and one-time nonce boundary.
3. Dispatch a **new** `CF-093 UQ Corrective Acceptance` workflow on the reviewed/deployed exact head. The connected GitHub toolset currently exposes reads/reruns but no new workflow-dispatch operation, so use authorised GitHub UI/API dispatch if still unavailable; do not rerun an older SHA or use direct database execution.
4. Reconcile new deterministic UQ L2 evidence and prove zero generic Layer3/Layer4/Search/Publication side effects.
5. Run RMIT only after UQ clean; Layer 3 only after deterministic L2 closes.
6. Merge/release only after every governed gate is clean, followed by main CI, Cloudflare/deployed currentness and deployed UAT verification.

## Pickup text

> Continue CF M2.4.5 / CF-CHG-20260910-093 from repository/runtime truth. Accepted Pilot main remains `63c7107cfce2d8f607fc378af4881d0ba28ca879`, release v2.15.78. PR #72 is draft/open at exact head `4e67e32289235a88297502e90c8181f25639f300`. Exact-head Targeted Recovery `34743276597`, Fresh Reconstruction `34743276592`, Frontend Build `34743276603`, and Cloudflare deployment are PASS. Runtime/source migrations are reconciled to applied `20260913063252` and `20260913063321`; all previous inline review findings are resolved. The only pre-deployment blocker is the required fresh Codex exact-head verdict, currently unavailable because Codex reports a repo-environment prerequisite. Pilot Edge v29 remains intentionally stale relative to the latest repo worker fixes and must be redeployed only after Codex clean, preserving `verify_jwt=false` and the custom nonce boundary. Then dispatch NEW UQ corrective acceptance; RMIT, Layer 3, merge and release remain paused until consequential acceptance closes.