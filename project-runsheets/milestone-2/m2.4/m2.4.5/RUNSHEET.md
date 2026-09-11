# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 LARGE-UNIVERSITY ACCEPTANCE BLOCKED  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-12 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Active candidate: Pilot PR #72, branch `m245/cf093-async-discovery-20260912`, head `692ba7ef93e19d833963d96dab2558b340eaea17`.
- Exact-head Pilot Frontend Build `34657854675`: PASS.
- Cloudflare PR preview: PASS/deployed.
- Codex exact-head review: pending/no result present.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Production Supabase: not provisioned.

## CF-093 large-university acceptance sequence

### Gate A — repository/runtime reconciliation

- [x] Reconcile Pilot main, PR #72, CI and Cloudflare preview.
- [x] Reconcile Pilot runtime migration history.
- [ ] Reconcile PR #72 source migration identities with immutable runtime-applied identities; do not rewrite/retimestamp applied migrations.
- [ ] Obtain fresh Codex review on the final exact PR head.

### Gate B — UQ 382-course proof

- [x] Wait for recent-dispatch dedupe window to clear.
- [x] Fresh Preview: 382 total / 156 queueable / 226 discovery; executable; zero profile/policy/route/oversize/discovery-config gaps.
- [x] Fresh Run now dispatched under CF-093 governance; not deduplicated.
- [x] Historical unsuccessful discovery dispositions proved retryable while preserving history.
- [x] All 226 discovery Courses retried through seven bounded Layer 2 discovery Jobs.
- [ ] Deterministic Layer 2 handoff: **BLOCKED**.
- [ ] Same-token successful replay: not applicable until a successful handoff exists.
- [ ] Fresh-preview recent-dispatch dedupe after successful handoff: not applicable until a successful handoff exists.

Terminal UQ disposition: 115 current_page_not_found, 79 identity_mismatch, 27 ambiguous, 5 likely_match/selected. Final pg_net request `5759` returned HTTP 500 with the governed all-discovery-current fail-closed error.

### Gate C — UQ discovery qualification recovery

- [ ] Inspect retained UQ discovery Jobs/Evidence and official first-party examples.
- [ ] Qualify/correct the existing UQ discovery/search and identity-confirmation profile/algorithm without fabricating routes, profiles, policies or URLs.
- [ ] Preserve exact CRICOS/detail identity proof and fail-closed semantics.
- [ ] Re-run targeted retry/binding regression.
- [ ] Run a fresh UQ 382-course consequential acceptance after the failed binding is no longer active under the governed contract.

### Gate D — RMIT 500-course proof

- [ ] **GATED BY UQ PASS.** Do not run before Gate C passes.
- [ ] Preview 500 total / expected 261 queueable / 239 discovery subject to fresh runtime truth.
- [ ] Run now → discovery continuations → deterministic Layer 2 → Jobs/Evidence.
- [ ] Same-token replay and fresh-preview dedupe.

### Gate E — Layer 3 bounded assessment

- [ ] Inspect accepted Layer 2 Evidence after successful large-university proof.
- [ ] Use only existing Layer 3 profile/model/revalidation contracts for eligible Evidence.
- [ ] Do not enable generic scheduler Layer 3.
- [ ] Preserve Layer 4 and Search/Publication separation.

### Gate F — next AU qualification wave

Normal profile/policy/config qualification only, in this order:

1. Monash University
2. The University of Melbourne
3. Australian National University
4. University of Technology Sydney
5. The University of Western Australia
6. The University of Sydney
7. UNSW Sydney

No cohort membership is authority to manufacture missing execution policy, source profile or discovery config.

## Continuous M2.4.5 gates

- H7 production migration/telemetry inventory remains active; Production target states remain pending.
- H8 bugs/addenda/features remain Change-Controlled.
- H9 targeted validation precedes bounded integration; one broader nominated acceptance only when warranted.
- H10 meeting/status evidence remains maintained.
- QS-focused ranking recovery remains an independent active workstream; generic ARWU/Diversity ETL remains deferred roadmap work unless re-authorised.
- H14 external-consumer API-key lifecycle remains separately governed.

## Exact next action

Resolve the UQ discovery qualification blocker from retained Evidence, while also reconciling PR #72 migration source identities. Do not run RMIT, generic Layer 3, merge PR #72, deploy a new accepted release, or reopen M2.5 until the relevant gates are clean.
