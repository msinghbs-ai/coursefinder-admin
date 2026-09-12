# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 LARGE-UNIVERSITY L2 PASS; REVIEW/L3 GATES OPEN  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-12 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Active candidate: Pilot PR #72, branch `m245/cf093-async-discovery-20260912`, head `81a8ae3b24063970d5571b6d8bb177b9c6c7e07a`.
- Exact-head Pilot Frontend Build `34672122160`: PASS.
- Cloudflare exact-head preview: PASS/deployed.
- Codex exact-head review: pending/no result present.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Production Supabase: not provisioned.

## CF-093 large-university acceptance sequence

### Gate A — repository/runtime reconciliation

- [x] Reconcile Pilot main, PR #72, CI and Cloudflare preview.
- [x] Reconcile forward migration source with immutable Pilot runtime history; no applied migration rewritten/retimestamped.
- [x] Add targeted terminal-negative/dedupe regression coverage and restore missing forward migration source; exact-head CI PASS.
- [ ] Obtain fresh Codex review on final exact PR head.

### Gate B — UQ 382-course proof

- [x] Fresh governed Preview/binding.
- [x] Discovery completed with 245 selected current URLs + 131 governed terminal negatives; 0 transient/unattempted.
- [x] Deterministic L2 batch `eee74644-9b2e-45b8-b0f7-20c4e5c587d4`: 248 `resolved_l2` + 3 `layer3_required`.
- [x] Same-token replay proved idempotent.
- [x] Fresh-Preview dedupe defect identified, unintended duplicate cancelled with 0 processed items, forward completion-anchored correction applied and retested PASS.
- [x] No generic Layer 3 or Search/Publication side effect accepted.

### Gate C — RMIT 500-course proof

- [x] Fresh Preview token `c3e73796-d2d3-486e-b3a4-83afc54b806d`: 500 total / 261 queueable / 239 discovery; executable with zero qualification gaps.
- [x] Initial discovery chain remained fail-closed; terminal request `5965` identified 15 transient/unattempted records.
- [x] Bounded exact-binding retry request `5966` processed only those 15 with 0 failures.
- [x] Final discovery: 2 selected current URLs + 237 governed terminal negatives; 0 transient/unattempted.
- [x] Deterministic L2 batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: target 263; terminal 213 `resolved_l2` + 50 `layer3_required`; no failed/queued/acquiring items.
- [x] No generic Layer 3 jobs; no Search refresh signals; handoff explicitly denied canonical mutation and Search/Publication authority.
- [ ] Same-token replay through authenticated scheduler surface.
- [ ] Fresh-Preview recent-dispatch dedupe through authenticated scheduler surface.

### Gate D — bounded Layer 3 assessment

- [ ] Inspect eligible UQ/RMIT `layer3_required` Evidence and existing qualified Course Layer 3 profile/model/revalidation state.
- [ ] Run bounded Layer 3 acceptance only through that existing governed contract.
- [ ] Do not enable generic scheduler Layer 3.
- [ ] Preserve Layer 4 and Search/Publication separation.

### Gate E — final PR acceptance

- [ ] Fresh Codex review on final exact PR head.
- [ ] Reconfirm exact-head CI/UAT/runtime after any review-driven change.
- [ ] Update PR #72 final acceptance summary.
- [ ] Merge only after all required gates are clean; no visible release bump before acceptance.

### Gate F — next AU qualification wave

Normal qualification only: Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW. Do not manufacture missing policy/profile/configuration.

## Continuous M2.4.5 gates

- H7 production migration/telemetry inventory remains active; Production target states remain pending.
- H8 bugs/addenda/features remain Change-Controlled.
- H9 targeted validation precedes bounded integration; one broader nominated acceptance only when warranted.
- H10 meeting/status evidence remains maintained.
- QS ranking recovery remains independent.
- H14 external-consumer API-key lifecycle remains separately governed.

## Exact next action

Complete RMIT authenticated replay/dedupe proof if an authorised browser/session surface is available, then perform bounded Layer 3 acceptance using only the existing qualified Evidence/profile/model/revalidation contract. Obtain exact-head Codex review before merge. M2.5 remains paused.
