# M2.4.5 NEXT CHAT

## Current pickup — 13 September 2026

- Milestone: **M2.4.5 ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CORRECTIVE ACCEPTANCE**.
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
- Exact-head Codex review comment `5649541094`: CLEAN / no major issues, reviewed commit `a035714aa5`.
- All prior inline Codex P1/P2 threads are resolved against the current forward hardening.

## Runtime hardening

- Forward migration `20260912232827_cf_093_preview_provenance_terminal_dedupe_hardening` is applied and checked in.
- Worker `layer2-scope-discover-scheduled-v1.3.10` is deployed as Edge v29, SHA `665c56ade30fa89b517255bb023c8ce1a15f88df3935845baeeba17cca21c051`.
- Existing custom nonce/auth boundary is unchanged.
- Exact Preview provenance, post-network/pre-Evidence identity revalidation, fail-closed missing/cancelled binding handling, completion-aware async dedupe, terminal-only/mixed accounting, qualified terminal basis, original + stripped-title exact matching, zero-result telemetry preservation and cancellation audit preservation have forward fixes and clean exact-head Codex review.

## Discovery acceptance

Historical evidence only:

- UQ batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 resolved + 3 `layer3_required`.
- RMIT batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 resolved + 50 `layer3_required`.

Previous hardened snapshots showed UQ 54 and RMIT 27 requiring corrective rediscovery. **No corrective rediscovery has been dispatched after the current hardening.** The code/reconstruction/Codex gate is now clean, so consequential acceptance is the next gate.

The maintained `CF-093 UQ Corrective Acceptance` workflow uses the normal authenticated Admin/PIM scheduler path. The currently connected GitHub toolset does not expose workflow-dispatch, so do not replace this with direct database execution or an ungoverned RPC call merely to advance the gate.

## Layer 3

Qualified JWT-protected Layer 3 remains separately governed and paused behind CF-093. Generic scheduler Layer 3 remains prohibited. Historical `layer3_required` counts do not authorise execution.

## Exact next actions

1. Dispatch the maintained UQ corrective acceptance workflow against exact head `a035714...`, or run the equivalent normal authenticated Admin/PIM scheduler path, and capture new Preview/dispatch evidence.
2. Reconcile only newly selected/changed deterministic UQ Layer 2 work and explicitly prove zero generic Layer3/Layer4 auto-approval/Search/Publication side effects.
3. Run bounded RMIT corrective acceptance only after UQ is clean.
4. Recalculate any eligible Layer 3 cohort only after deterministic L2 acceptance closes.
5. If acceptance exposes a reproducible defect, implement the smallest safe forward-only correction; never rewrite an applied migration. Then rerun Targeted Recovery, full reconstruction, Frontend Build, Cloudflare currentness and fresh exact-head Codex review before resuming acceptance.
6. Merge/release only after every governed gate is clean.

## Pickup text

> Continue CF M2.4.5 / CF-CHG-20260910-093 from repository/runtime truth. Accepted Pilot main is `63c7107cfce2d8f607fc378af4881d0ba28ca879`, release v2.15.78. PR #72 remains draft/open at exact head `a035714aa5bd9b4d88ae47a59c877b3514a1f287`. Exact-head Targeted Recovery `34726688848`, full ordered CF-093 reconstruction `34726688865`, Frontend Build `34726688863`, Cloudflare preview at `a035714a`, and Codex review comment `5649541094` are clean. Forward migration `20260912232827` and worker v1.3.10 / Edge29 / SHA `665c56...` contain the current hardening. No UQ/RMIT corrective rediscovery has been dispatched after hardening. Next gate is authenticated UQ corrective acceptance through the maintained scheduler workflow/path, then deterministic UQ reconciliation, then RMIT. Layer 3, merge and release remain paused.