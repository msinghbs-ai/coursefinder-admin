# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 EXACT-HEAD CODEX RECOVERY  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-13 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Active candidate: PR #72 / `m245/cf093-async-discovery-20260912` / exact head `1a2caf375b394e7723543642996e4dadfa52e3fe`.
- CF-093 Targeted Recovery `34693956788`: PASS.
- Pilot Frontend Build `34693956789`: PASS.
- CF-093 Fresh Reconstruction `34693956761`: PASS only for the limited UQ bootstrap fixture; complete CF-093 replay remains open.
- Cloudflare exact-head preview: PASS/deployed at `1a2caf37`.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Production Supabase: not provisioned.
- PR remains draft/open; merge prohibited until all gates below close.

## Gate A — exact-head Codex recovery

Earlier forward hardening remains retained, but fresh Codex review on `1a2caf...` reopened additional P1/P2 work.

- [x] Runtime/source bootstrap tracking row `20260912005000` now present in Pilot history.
- [x] Forward migrations `20260912100539` and `20260912101339` remain applied/checked in.
- [x] Exact-head targeted recovery `34693956788` PASS.
- [x] Exact-head Frontend Build `34693956789` PASS.
- [x] Exact-head Cloudflare preview deployed.
- [ ] Bind every accepted selected/terminal discovery outcome to exact Preview-token provenance through provider attempt/job.
- [ ] Revalidate exact binding identity immediately before Evidence/candidate writes after network acquisition.
- [ ] Reject bound handoff if its exact binding is absent/cancelled; no unbound fallback.
- [ ] Require every `discovery_started` profile to have a reusable handoff outcome before completion dedupe can suppress recovery.
- [ ] Correct terminal-only and mixed-profile completion accounting.
- [ ] Align qualified terminal-negative metadata/version checks with the deployed worker contract.
- [ ] Preserve exact canonical-title matches against both original and prefix-stripped titles.
- [ ] Preserve qualified zero-result provider-attempt telemetry without overwriting it as generic success.
- [ ] Preserve the first cancellation audit on idempotent replay.
- [ ] Obtain a fresh Codex review with no remaining actionable P1/P2 defects.

## Gate B — repository reconstruction / migration currentness

- [x] Immutable `20260912005948` remains unchanged/unretimestamped.
- [x] Bootstrap `20260912005000_cf_093_uq_discovery_strategy_reconstruction_bootstrap.sql` exists before `005948`.
- [x] Pilot migration history now records `005000`, `005948`, `100539`, `101339`.
- [x] Limited UQ bootstrap fixture replay `34693956761` PASS.
- [ ] Replace/extend the limited fixture so the complete ordered CF-093 chain is replayed against an appropriate reconstructed baseline.
- [ ] Prove no syntax/dependency/function-replacement failure across the full CF-093 migration sequence.
- [x] Keep direct ad-hoc modification of `supabase_migrations.schema_migrations` prohibited.

## Gate C — authenticated acceptance evidence

- [ ] Assert the browser bridge status from `dispatch.result.status`, not the outer object.
- [ ] Prove the Cloudflare preview is serving the exact `GITHUB_SHA`, not merely HTTP 200.
- [ ] Ensure acceptance triggers on every relevant implementation exact head, not only workflow-file changes.
- [ ] Re-run consequential authenticated acceptance only after Gates A–B are clean.

## Gate D — UQ corrective discovery

Historical deterministic batch retained as evidence: `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f` = 248 `resolved_l2` + 3 `layer3_required`.

Previous hardened snapshot recorded 382 scoped / 251 queueable / 54 reopened discovery / 77 retained terminal negatives.

- [ ] Do not dispatch while current exact-head correlation/authority defects remain open.
- [ ] After Gates A–C close, obtain a new authenticated Preview and run only the currently actionable corrective UQ discovery scope.
- [ ] Reconcile changed/newly selected actionable work through deterministic L2 only.
- [ ] Prove exact-token/fingerprint/dedupe and zero generic Layer3/Layer4/Search/Publication side effects.

## Gate E — RMIT corrective discovery

Historical deterministic batch retained as evidence: `c8a33237-d2b5-47c3-a02b-2676cb6b820f` = 213 `resolved_l2` + 50 `layer3_required`.

Previous hardened snapshot recorded 500 scoped / 263 queueable / 27 reopened discovery / 210 retained terminal negatives.

- [ ] Do not dispatch while current exact-head correlation/authority defects remain open.
- [ ] After Gates A–C close, obtain a new authenticated Preview and run only the currently actionable corrective RMIT discovery scope.
- [ ] Reconcile changed/newly selected actionable work through deterministic L2 only.
- [ ] Prove exact-token/fingerprint/dedupe and zero generic Layer3/Layer4/Search/Publication side effects.

## Gate F — bounded Layer 3

Paused while CF-093 remains open.

- [x] Qualified JWT-protected Course Layer 3 contract previously inspected.
- [ ] Recalculate eligible Layer 3 cohort only after corrective discovery/L2 acceptance closes.
- [ ] Resume bounded authenticated Layer 3 only if still required after CF-093 closes.
- [x] Generic scheduler Layer 3 remains disabled.

## Gate G — final PR acceptance

- [ ] All exact-head Codex P1/P2 findings closed.
- [ ] Full migration-chain reconstruction proof clean.
- [ ] Correct authenticated acceptance evidence clean.
- [ ] Corrective UQ/RMIT discovery + changed deterministic L2 clean.
- [ ] Exact-head CI/UAT/runtime clean.
- [ ] Governance continuity and PR summary reconciled.
- [ ] Merge only after all required gates are clean; no visible release bump before acceptance.

## Continuous M2.4.5 gates

- H7 production migration/telemetry inventory remains active; Production target states pending.
- H8 bugs/addenda/features remain Change-Controlled.
- H9 targeted validation precedes bounded integration.
- H10 meeting/status evidence remains maintained.
- QS ranking recovery remains independent.
- H14 external-consumer API-key lifecycle remains separately governed.

## Exact next action

Address the current exact-head Codex findings with the smallest forward-only corrections, extend reconstruction to the complete CF-093 chain, and correct exact-head authenticated acceptance evidence. Do not start another UQ/RMIT corrective run until those gates are green. Layer 3 remains paused.