# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 LARGE-UNIVERSITY L2 PASS; AUTHENTICATED L3/CODEX GATES OPEN  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-12 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Active candidate: Pilot PR #72, branch `m245/cf093-async-discovery-20260912`, head `a7283139a9e6088933be68fa69f75d2e9eb71fbe`.
- Exact-head Pilot Frontend Build `34681032426`: PASS.
- Cloudflare exact-head preview: PASS/deployed.
- Codex exact-head review: blocked by code-review usage quota; no technical review outcome present.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Production Supabase: not provisioned.

## CF-093 large-university acceptance sequence

### Gate A — repository/runtime reconciliation

- [x] Reconcile Pilot main, PR #72, CI and Cloudflare preview.
- [x] Reconcile forward migration source with immutable Pilot runtime history; no applied migration rewritten/retimestamped.
- [x] Correct freshness UAT migration identity to applied `20260912031356`; exact-head CI PASS.
- [ ] Obtain exact-head Codex review when review quota permits.

### Gate B — UQ 382-course proof

- [x] Preview-bound discovery completed with 245 selected current URLs + 131 governed terminal negatives; 0 transient/unattempted.
- [x] Corrected executable scope 251 + 131 fresh terminal negatives; no unnecessary rediscovery.
- [x] Corrected rerun batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- [x] Same-token replay PASS.
- [x] Completion-anchored fresh-Preview dedupe PASS after governed cancellation of a zero-processed pre-correction duplicate.
- [x] No generic Layer 3 or Search/Publication side effect.

### Gate C — RMIT 500-course proof

- [x] Fresh Preview `c3e73796-d2d3-486e-b3a4-83afc54b806d`: 500 total / 261 queueable / 239 discovery; executable with zero qualification gaps.
- [x] Initial discovery chain failed closed at request `5965` with 15 transient/unattempted records.
- [x] Bounded exact-binding retry `5966` processed only those 15 with 0 failures and no threshold/profile relaxation.
- [x] Final discovery: 2 selected current URLs + 237 governed terminal negatives; 0 transient/unattempted.
- [x] Deterministic batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`; 0 failed/queued/acquiring.
- [x] No generic Layer 3 jobs; zero Search refresh signals; canonical/Search authority explicitly false.
- [x] RMIT replay/dedupe timing limitation classified: live 30-minute window elapsed; do not launch a duplicate 500-course run solely to recreate it. UQ provides live proof for the same corrected contract; repeat naturally on a future governed run.

### Gate D — bounded Layer 3 assessment

- [x] Reconcile owning `CF-CHG-20260825-038`: CLOSED/PASS Layer 3 execution boundary and pinned real-provider benchmark.
- [x] Runtime profile `openrouter-free-router-v1` confirmed enabled/unpaused and Pilot environment `pilot_qualified`; benchmark `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407` PASS.
- [x] Identify eligible UQ/RMIT set: 53 `layer3_required` items, 53 current Evidence artifacts, 0 existing interpretations.
- [x] Confirm `layer3-interpret` v9 is ACTIVE and `verify_jwt=true`; it validates the user token before reservation.
- [ ] Perform a deliberately bounded live-provider acceptance using an authorised authenticated user/session surface. Do not invoke through service-role SQL or bypass user JWT merely to obtain a PASS.
- [ ] Record Layer 3 calls/tokens/cost/latency/validator disposition and Evidence lineage in `SYSTEM-METRICS.md`.
- [ ] Reconcile stale runtime `pending-live-provider-uat` metadata through a governed forward change; do not directly mutate privileged state.
- [ ] Keep generic scheduler Layer 3 disabled; preserve Layer 4 and Search/Publication separation.

### Gate E — final PR acceptance

- [x] Update PR #72 acceptance description to UQ/RMIT/current migration truth.
- [ ] Exact-head Codex review when quota permits.
- [ ] Reconfirm exact-head CI/UAT/runtime after any review-driven or Layer 3 metadata change.
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

Use an authorised authenticated Layer 3 user/session surface for a deliberately bounded live-provider acceptance against the 53 eligible UQ/RMIT Evidence items. Do not bypass JWT/user identity. Record metrics and reconcile stale Layer 3 UAT metadata through forward governance. Obtain exact-head Codex review when quota permits; PR #72 remains draft/unmerged and M2.5 remains paused.
