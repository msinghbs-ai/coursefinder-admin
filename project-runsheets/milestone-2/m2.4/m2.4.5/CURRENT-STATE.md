# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 EXACT-HEAD CODEX REVIEW PENDING  
**Reconciled:** 2026-09-13 AEST  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Visible accepted release:** v2.15.78  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Active candidate

- PR #72 / branch `m245/cf093-async-discovery-20260912`.
- Exact head `a035714aa5bd9b4d88ae47a59c877b3514a1f287`.
- PR OPEN / DRAFT / mergeable but governance-blocked.
- CF-093 Targeted Recovery `34726688848`: **PASS**.
- CF-093 Fresh Reconstruction `34726688865`: **PASS**; complete ordered PR-added CF-093 migration chain replayed on a fresh reconstructed accepted-main dependency baseline.
- Pilot Frontend Build `34726688863`: **PASS**.
- Cloudflare exact-head preview: **PASS/deployed at `a035714a`**.
- Fresh exact-head Codex review requested in PR comment `5649524865`; no exact-head technical review has yet been submitted. Silence is not approval.

## Runtime hardening

Pilot contains forward migration `20260912232827_cf_093_preview_provenance_terminal_dedupe_hardening`. Applied predecessor migrations remain immutable.

The deployed discovery worker is `layer2-scope-discover-scheduled-v1.3.10`, Edge version 29, SHA `665c56ade30fa89b517255bb023c8ce1a15f88df3935845baeeba17cca21c051`. It preserves the existing custom nonce/auth boundary and adds post-network/pre-Evidence bound-identity revalidation, exact Preview-token metadata/provenance, original + prefix-stripped exact title matching, qualified terminal-basis metadata and preservation of `discovery_zero_results` telemetry.

The forward migration closes the previously identified exact-token provenance, missing/cancelled binding fall-through, async completion dedupe, terminal-only/mixed-profile accounting and cancellation-audit replay defects. Exact-head targeted tests and full-chain reconstruction are green; fresh Codex review remains the independent review gate.

## Security / authority

- Layer 1 identity/regulatory authority unchanged.
- Layer 2 remains deterministic, Evidence-preserving and fail-closed.
- Generic scheduler Layer 3/4 remains disabled.
- `layer3_required` remains an L2 disposition only.
- Search/Publication remains separately governed.
- No source URL, route, profile, zero-result marker, identity or Evidence may be manufactured for acceptance.
- Supabase Security Advisor after hardening reported no new critical CF-093 regression; existing informational RLS-with-no-policy inventory remains separately governed.

## Discovery acceptance

Historical UQ/RMIT deterministic outcomes remain evidence only:

- UQ batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- RMIT batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

Previous hardened snapshots recorded UQ 54 and RMIT 27 requiring corrective rediscovery. No corrective rediscovery has been dispatched after the current hardening. Do not dispatch until the exact-head Codex review is reconciled and all exact-head gates remain green.

## Layer 3

Qualified JWT-protected Layer 3 remains separately governed and paused behind CF-093. Generic scheduler Layer 3 remains prohibited. Recalculate any eligible Layer 3 cohort only after corrective deterministic Layer 2 acceptance closes.

## Exact next gate

1. Reconcile fresh Codex review for exact head `a035714...`; forward-fix any reproducible P1/P2 only, using new forward migrations where deployed DB semantics change.
2. Re-run Targeted Recovery, complete CF-093 reconstruction, Frontend Build and exact Cloudflare deployment after any change.
3. Once exact-head review/runtime/CI is clean, obtain new authenticated UQ/RMIT Previews and run only the currently actionable corrective discovery scopes.
4. Reconcile only newly selected/changed deterministic Layer 2 work and prove zero generic Layer 3/Layer 4 auto-approval/Search/Publication side effects.
5. Merge/release only after all governed gates close.

M2.4.4 remains CLOSED/PASS/FROZEN and M2.5 remains paused.