# M2.4.5 NEXT CHAT

## Current pickup — 13 September 2026

- Milestone: **M2.4.5 ACTIVE / PRE-PRODUCTION HARDENING — CF-093 EXACT-HEAD CODEX REVIEW PENDING**.
- M2.5 remains PAUSED at P0; no Production Supabase exists.
- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Active change: `CF-CHG-20260910-093`.
- PR #72: OPEN / DRAFT / mergeable but governance-blocked, exact head `a035714aa5bd9b4d88ae47a59c877b3514a1f287`.
- CF-093 Targeted Recovery `34726688848`: PASS.
- CF-093 Fresh Reconstruction `34726688865`: PASS — complete ordered PR-added CF-093 migration-chain replay on a fresh reconstructed accepted-main dependency baseline.
- Pilot Frontend Build `34726688863`: PASS.
- Cloudflare exact-head preview: PASS/deployed at `a035714a`.
- Fresh exact-head Codex review requested in PR comment `5649524865`; no exact-head technical review submission observed at reconciliation. Silence is not approval.

## Runtime hardening

- Forward migration `20260912232827_cf_093_preview_provenance_terminal_dedupe_hardening` is applied and checked in.
- Worker `layer2-scope-discover-scheduled-v1.3.10` is deployed as Edge v29, SHA `665c56ade30fa89b517255bb023c8ce1a15f88df3935845baeeba17cca21c051`.
- Existing custom nonce/auth boundary is unchanged.
- Exact Preview provenance, post-network/pre-Evidence identity revalidation, fail-closed missing/cancelled binding handling, completion-aware async dedupe, terminal-only/mixed accounting, qualified terminal basis, original + stripped-title exact matching, zero-result telemetry preservation and cancellation audit preservation have forward fixes at the current head.
- Temporary one-shot migration/deployment/source-alignment workflows were removed after use.

## Discovery acceptance

Historical evidence only:

- UQ batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 resolved + 3 `layer3_required`.
- RMIT batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 resolved + 50 `layer3_required`.

Previous hardened snapshots showed UQ 54 and RMIT 27 requiring corrective rediscovery. **No corrective rediscovery has been dispatched after the current hardening.** Do not run it until the exact-head Codex gate is reconciled.

## Layer 3

Qualified JWT-protected Layer 3 remains separately governed and paused behind CF-093. Generic scheduler Layer 3 remains prohibited. Historical `layer3_required` counts do not authorise execution.

## Exact next actions

1. Keep checking Codex for an exact-head review on `a035714...`; if it returns a reproducible P1/P2, inspect repository/runtime truth and implement the smallest safe forward correction. Never rewrite an applied migration.
2. After any change, rerun Targeted Recovery, full CF-093 reconstruction, Frontend Build and confirm exact Cloudflare currentness; request Codex again on the new exact head.
3. Once Codex/CI/runtime are clean, obtain new authenticated UQ and RMIT Previews and run only the currently actionable corrective discovery scopes.
4. Reconcile only newly selected/changed deterministic Layer 2 work and explicitly prove zero generic Layer3/Layer4 auto-approval/Search/Publication side effects.
5. Recalculate any eligible Layer 3 cohort only after deterministic L2 acceptance closes.
6. Merge/release only after every exact-head gate is clean.

## Pickup text

> Continue CF M2.4.5 / CF-CHG-20260910-093 from repository/runtime truth. Accepted Pilot main is `63c7107cfce2d8f607fc378af4881d0ba28ca879`, release v2.15.78. PR #72 remains draft/open at exact head `a035714aa5bd9b4d88ae47a59c877b3514a1f287`. Exact-head Targeted Recovery `34726688848`, full ordered CF-093 reconstruction `34726688865`, Frontend Build `34726688863`, and Cloudflare preview at `a035714a` PASS. Forward migration `20260912232827` and worker v1.3.10 / Edge29 / SHA `665c56...` contain the current Codex hardening fixes. Fresh exact-head Codex request is comment `5649524865` and remains pending; silence is not approval. Do not run UQ/RMIT corrective discovery, Layer 3, merge or release until that review is reconciled.