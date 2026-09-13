# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 EXACT-HEAD RECOVERY CLEAN / CONSEQUENT ACCEPTANCE PENDING  
**Reconciled:** 2026-09-13 AEST  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Visible accepted release:** v2.15.78  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Active candidate

- PR #72 / branch `m245/cf093-async-discovery-20260912`.
- Exact head `af5f97981cbb44ef157876552500c1404d15c9fd`.
- PR OPEN / DRAFT and governance-blocked; accepted main/release unchanged.
- CF-093 Targeted Recovery `34741811302`: **PASS**.
- CF-093 Fresh Reconstruction `34741811307`: **PASS**; ordered CF-093 migration replay now includes final immutable migrations through `20260913020646` against reconciled accepted-main dependency contracts.
- Pilot Frontend Build `34741811348`: **PASS**.
- Cloudflare exact-head preview: **PASS/deployed at `af5f9798`**.
- Fresh exact-head Codex review requested in PR comment `5651547613`; result pending at this reconciliation point.

## Latest recovery

Two exact-head P1 findings after the previous candidate reopened the recovery gate.

1. **Discovery continuation:** `layer2-scope-discover-scheduled` previously consumed every attempted course. This could remove `failed` or nonterminal `candidate` outcomes from continuation before deterministic resolution. Repository exact head now consumes only governed resolved statuses (`exact_match`, `likely_match`, `ambiguous`, `identity_mismatch`, `current_page_not_found`) and leaves unresolved outcomes in bounded continuation/recovery.
2. **Fresh reconstruction:** the replay was extended to include immutable migrations `20260913015530`, `20260913020222`, and `20260913020646`. This exposed stale/missing accepted-main fixture contracts, not migration defects. The fixture now models the accepted six-column `layer2_scope_courses`, acquisition provider/provider-route tables, `layer2_provider_runtime_config(uuid)`, and v1/v2 scheduler Run Now signatures needed for reconstruction/ACL replay. No runtime provider/route data was seeded or manufactured.

Applied migrations remain immutable; none were rewritten, removed, renamed or retimestamped.

## Runtime currentness

Pilot runtime migration history remains reconciled through already-applied `20260913020646_cf_093_scheduler_run_bridge_acl_reconcile`.

The deployed discovery worker remains `layer2-scope-discover-scheduled-v1.3.10`, Edge version 29, under the existing custom nonce/auth boundary (`verify_jwt=false`). The repository contains the new bounded-continuation correction, but that worker change is not treated as deployed currentness until exact-head review is clean and the exact repo source is deployed/verified.

## Security / authority

- Layer 1 identity/regulatory authority unchanged.
- Layer 2 remains deterministic, Evidence-preserving and fail-closed.
- Exact Preview token/fingerprint/binding provenance remains required.
- Generic scheduler Layer 3/4 remains disabled.
- `layer3_required` remains an L2 disposition only.
- Search/Publication remains separately governed.
- No source URL, route, profile, zero-result marker, identity, Evidence or migration-history row may be manufactured for acceptance.
- No UQ/RMIT consequential acceptance was dispatched during this recovery cycle.

## Discovery acceptance

Historical UQ/RMIT deterministic outcomes remain forensic evidence only:

- UQ batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- RMIT batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

New acceptance counts must come from new authenticated Previews after exact-head review and worker deployed-currentness close.

## Layer 3

Qualified JWT-protected Layer 3 remains separately governed and paused behind CF-093. Generic scheduler Layer 3 remains prohibited. Recalculate any eligible Layer 3 cohort only after corrective deterministic Layer 2 acceptance closes.

## Exact next gate

1. Obtain a clean Codex review for exact head `af5f9798...`.
2. Deploy the exact-head worker correction to Pilot while preserving `verify_jwt=false`, then verify deployed source/currentness.
3. Start a **new** `CF-093 UQ Corrective Acceptance` workflow_dispatch on the current branch/head; do not use Re-run on an older attempt.
4. Capture authenticated Preview → Run Now → continuation → deterministic L2 → Jobs/Evidence → same-token replay/dedupe evidence and prove zero generic Layer 3/Layer 4/Search/Publication side effects.
5. Run bounded RMIT corrective acceptance only after UQ is clean.
6. Merge/release only after all governed gates close, followed by main CI/deployment/deployed-UAT verification.

M2.4.4 remains CLOSED/PASS/FROZEN and M2.5 remains paused.