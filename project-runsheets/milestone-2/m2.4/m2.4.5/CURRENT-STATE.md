# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CORRECTIVE ACCEPTANCE RETRY PENDING  
**Reconciled:** 2026-09-13 AEST  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Visible accepted release:** v2.15.78  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Active candidate

- PR #72 / branch `m245/cf093-async-discovery-20260912`.
- Exact head `4cb8da49d7f1c79c6caaad893c1c7361394c4d65`.
- PR OPEN / DRAFT / mergeable but governance-blocked by consequential acceptance.
- CF-093 Targeted Recovery `34729795052`: **PASS**.
- CF-093 Fresh Reconstruction `34729795080`: **PASS**; complete ordered PR-added CF-093 migration chain replayed on a fresh reconstructed accepted-main dependency baseline.
- Pilot Frontend Build `34729795073`: **PASS**.
- Cloudflare exact-head preview: **PASS/deployed at `4cb8da49`**.
- Previous exact-head Codex reviews on `a035714aa5` were clean twice (`5649541094`, `5649656150`).
- Fresh Codex review requested for `4cb8da49...` in PR comment `5649862311`; pending at reconciliation.

## Acceptance workflow recovery

The first manually dispatched `CF-093 UQ Corrective Acceptance` attempt failed in the Playwright dispatch step after approximately 30 seconds. Credential preflight, checkout, dependency install, one-shot test creation and evidence upload all completed. Pilot runtime inspection shows **no new UQ async binding/activation was created by that failed attempt**, so no corrective discovery was dispatched and no consequential runtime mutation from the attempted acceptance run is being treated as accepted evidence.

The maintained one-shot test had no explicit test-level timeout, so Playwright's default 30-second test timeout could terminate the complete governed sequence (login + shell readiness + Scheduled Tasks navigation + provider search + Preview + Run Now) before its individual bounded waits could complete. The smallest acceptance-only correction was committed at `4cb8da49...`: `test.setTimeout(120_000)` in `.github/workflows/cf093-uq-corrective-acceptance.yml`.

No runtime SQL, worker logic, migration identity, authority boundary, ACL/rank rule, Layer 3/4/Search/Publication contract or accepted release changed.

## Runtime hardening

Pilot contains forward migration `20260912232827_cf_093_preview_provenance_terminal_dedupe_hardening`. Applied predecessor migrations remain immutable.

The deployed discovery worker remains `layer2-scope-discover-scheduled-v1.3.10`, Edge version 29, SHA `665c56ade30fa89b517255bb023c8ce1a15f88df3935845baeeba17cca21c051`. Existing custom nonce/auth remains unchanged. Exact Preview provenance, post-network/pre-Evidence identity revalidation, fail-closed binding, completion-aware dedupe, terminal-only/mixed accounting, title matching, qualified terminal basis and zero-result telemetry hardening remain unchanged.

## Security / authority

- Layer 1 identity/regulatory authority unchanged.
- Layer 2 remains deterministic, Evidence-preserving and fail-closed.
- Generic scheduler Layer 3/4 remains disabled.
- `layer3_required` remains an L2 disposition only.
- Search/Publication remains separately governed.
- No source URL, route, profile, zero-result marker, identity or Evidence may be manufactured for acceptance.
- The failed UQ acceptance attempt produced no new UQ binding/dispatch in Pilot runtime.

## Discovery acceptance

Historical UQ/RMIT deterministic outcomes remain evidence only:

- UQ batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- RMIT batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

Previous hardened snapshots recorded UQ 54 and RMIT 27 requiring corrective rediscovery. No corrective rediscovery has been dispatched after the current hardening.

## Layer 3

Qualified JWT-protected Layer 3 remains separately governed and paused behind CF-093. Generic scheduler Layer 3 remains prohibited. Recalculate any eligible Layer 3 cohort only after corrective deterministic Layer 2 acceptance closes.

## Exact next gate

1. Reconcile fresh Codex review for exact head `4cb8da49...`.
2. Re-dispatch `CF-093 UQ Corrective Acceptance` as a **new workflow_dispatch on the current branch head**; do not use Re-run on the failed older-head attempt because that would execute its original SHA.
3. Capture fresh authenticated Preview/Run Now evidence, then follow UQ discovery to terminal.
4. Reconcile only newly selected/changed deterministic UQ L2 work and prove exact-token/fingerprint/dedupe plus zero generic Layer 3/Layer 4 auto-approval/Search/Publication side effects.
5. Repeat bounded corrective acceptance for RMIT only after UQ is clean.
6. Merge/release only after all governed gates close.

M2.4.4 remains CLOSED/PASS/FROZEN and M2.5 remains paused.