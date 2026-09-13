# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 EXACT-HEAD RECOVERY CLEAN / CONSEQUENT ACCEPTANCE PENDING  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-13 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Active candidate: PR #72 / `m245/cf093-async-discovery-20260912` / exact head `af5f97981cbb44ef157876552500c1404d15c9fd`.
- CF-093 Targeted Recovery `34741811302`: PASS.
- CF-093 Fresh Reconstruction `34741811307`: PASS.
- Pilot Frontend Build `34741811348`: PASS.
- Cloudflare exact-head preview: PASS/deployed at `af5f9798`.
- Fresh exact-head Codex review requested in comment `5651547613`; pending at reconciliation.
- Pilot runtime migrations remain current through immutable `20260913020646_cf_093_scheduler_run_bridge_acl_reconcile`.
- Deployed discovery worker remains v1.3.10 / Edge v29 under the existing custom nonce/auth boundary; repository continuation fix awaits reviewed deployment currentness.
- Production Supabase: not provisioned.

## Gate A — exact-head recovery

- [x] Exact Preview-token provenance bound through provider attempt/job lineage.
- [x] Post-network/pre-Evidence bound-identity revalidation implemented.
- [x] Missing/cancelled exact Preview binding fails closed; no unbound fallback.
- [x] Async completion dedupe requires reusable handoff/terminal completion for every `discovery_started` profile.
- [x] Terminal-only and mixed actionable/terminal accounting implemented.
- [x] Qualified terminal-basis metadata aligned to worker v1.3.10 contract.
- [x] Exact title matching preserves original and prefix-stripped titles.
- [x] Qualified zero-result provider-attempt telemetry is not overwritten as generic success.
- [x] First cancellation timestamp/reason preserved on idempotent replay.
- [x] Unresolved `failed` / nonterminal `candidate` discovery outcomes remain in bounded continuation/recovery.
- [x] Exact-head Targeted Recovery `34741811302` PASS.
- [x] Exact-head Frontend Build `34741811348` PASS.
- [x] Exact-head Cloudflare preview deployed at `af5f9798`.
- [ ] Fresh exact-head Codex review clean for `af5f9798...`.

## Gate B — reconstruction / migration currentness

- [x] Applied migrations remain immutable; no predecessor rewrite/retimestamp.
- [x] Full reconstruction replay includes all PR-added/final CF-093 migrations through `20260913020646`.
- [x] Reconstructed accepted-main dependency fixture matches the six-column Layer 2 scope contract.
- [x] Reconstructed fixture models accepted Layer 2 acquisition provider/provider-route/runtime-config contracts without seeding fabricated runtime rows.
- [x] Reconstructed fixture models accepted v1/v2 Run Now function signatures required to exercise ACL reconciliation.
- [x] Exact-head full-chain reconstruction `34741811307` PASS.
- [x] Direct ad-hoc modification of `supabase_migrations.schema_migrations` remains prohibited.

## Gate C — deployed worker currentness

- [x] Existing deployed worker remains v1.3.10 / Edge v29 and custom nonce/auth boundary remains unchanged.
- [ ] After exact-head Codex clean, deploy the exact repo worker containing bounded-continuation correction.
- [ ] Verify deployed source/version and preserve `verify_jwt=false`; do not broaden auth/ACL boundaries.

## Gate D — UQ corrective discovery

Historical batch retained as evidence: `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f` = 248 `resolved_l2` + 3 `layer3_required`.

- [ ] Start a **new** authenticated UQ corrective acceptance on the reviewed/deployed current head.
- [ ] Reconcile newly selected/changed work through deterministic L2 only.
- [ ] Prove exact-token/fingerprint/dedupe and zero generic Layer3/Layer4/Search/Publication side effects.

## Gate E — RMIT corrective discovery

Historical batch retained as evidence: `c8a33237-d2b5-47c3-a02b-2676cb6b820f` = 213 `resolved_l2` + 50 `layer3_required`.

- [ ] After UQ is clean, run only the currently actionable RMIT corrective scope.
- [ ] Reconcile newly selected/changed work through deterministic L2 only.
- [ ] Prove exact-token/fingerprint/dedupe and zero generic Layer3/Layer4/Search/Publication side effects.

## Gate F — bounded Layer 3

- [x] Qualified JWT-protected Course Layer 3 contract remains separate.
- [x] Generic scheduler Layer 3 remains disabled.
- [ ] Recalculate eligible Layer 3 cohort only after corrective discovery/L2 acceptance closes.
- [ ] Resume bounded authenticated Layer 3 only if still required and qualified.

## Gate G — final PR acceptance

- [x] Exact-head Targeted Recovery / Fresh Reconstruction / Frontend Build / Cloudflare currentness clean at `af5f9798...`.
- [ ] Exact-head Codex clean.
- [ ] Worker deployed-currentness clean.
- [ ] Corrective UQ/RMIT discovery + changed deterministic L2 clean.
- [ ] Final security/authority/UAT/runtime clean.
- [ ] Governance continuity reconciled after consequential acceptance.
- [ ] Merge/release only after all required gates are clean; then verify main CI, Cloudflare/deployed currentness and deployed UAT.

## Exact next action

Reconcile the fresh Codex review for exact head `af5f9798...`. If clean, deploy and verify the exact-head discovery worker correction, then start a **new** `CF-093 UQ Corrective Acceptance` workflow_dispatch on the current branch/head. RMIT follows only after UQ is clean; Layer 3, merge and release remain paused.