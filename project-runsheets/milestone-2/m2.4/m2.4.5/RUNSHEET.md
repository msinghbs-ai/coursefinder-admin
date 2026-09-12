# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CODEX RECOVERY; DISCOVERY ACCEPTANCE REOPENED  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-12 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Active candidate: Pilot PR #72, branch `m245/cf093-async-discovery-20260912`, head `c5226c2bcadd7ee7102935088130262ca2a3a2a2`.
- Exact-head Pilot Frontend Build `34687938846`: PASS.
- Cloudflare exact-head preview: PASS/deployed.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- `layer2-scope-discover-scheduled`: Edge v27 / worker v1.3.9 / SHA `15c958609f6f6787a4de2e449d15e3e3e9718480da4c8599743c0da92a3d4ef2`.
- Production Supabase: not provisioned.
- PR remains draft/open; merge prohibited while P1 reconstruction blocker remains.

## Gate A — Codex recovery and repository/runtime reconciliation

- [x] Reconcile immutable runtime migrations through `20260912100539` and `20260912101339` into PR source.
- [x] Bind Preview-bound discovery context, continuation and handoff to the exact Preview token.
- [x] Revalidate profile/course identity fingerprint before new discovery Evidence writes.
- [x] Make multi-profile cancellation set-based.
- [x] Include async handoff batch IDs in completion-anchored dedupe.
- [x] Reject dedupe reuse when any referenced batch is cancelled/missing/non-terminal.
- [x] Make terminal-only scopes non-executable at Preview.
- [x] Correct course-code regex boundary and stale worker-version UAT.
- [x] Make unqualified first-party 200/no-link search results transient; do not fabricate zero-result markers.
- [x] Invalidate legacy `current_page_not_found` freshness suppression through forward migration `20260912101339`.
- [x] Exact-head Frontend Build `34687938846` PASS and Cloudflare preview PASS.
- [ ] Resolve historical reconstruction P1 without rewriting/retimestamping applied `20260912005948` or mutating migration history ad hoc.
- [ ] Obtain fresh Codex review on corrected exact head after reconstruction remedy.

## Gate B — UQ 382-course acceptance

Historical deterministic evidence retained:
- corrected batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f` = 248 `resolved_l2` + 3 `layer3_required`;
- same-token replay and corrected completion-dedupe were previously proven;
- no generic Layer 3/Search/Publication side effects were observed.

**Discovery acceptance reopened after Codex zero-result finding.** Current hardened snapshot:
- 382 scoped;
- 251 queueable;
- 54 require rediscovery;
- 77 retained governed terminal negatives.

- [ ] Run bounded authenticated rediscovery for the 54 reopened Courses only.
- [ ] Reconcile any newly selected/changed actionable work through deterministic L2.
- [ ] Re-prove side-effect boundaries.

## Gate C — RMIT 500-course acceptance

Historical deterministic evidence retained:
- batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f` = 213 `resolved_l2` + 50 `layer3_required`;
- 263 succeeded L2 acquisition jobs; no Search refresh signals; canonical/Search authority false.

**Discovery acceptance reopened after Codex zero-result finding.** Current hardened snapshot:
- 500 scoped;
- 263 queueable;
- 27 require rediscovery;
- 210 retained governed terminal negatives.

- [ ] Run bounded authenticated rediscovery for the 27 reopened Courses only.
- [ ] Reconcile any newly selected/changed actionable work through deterministic L2.
- [ ] Re-prove side-effect boundaries.

## Gate D — bounded Layer 3 assessment

Paused while CF-093 Codex/reconstruction/discovery recovery remains open.

- [x] Existing qualified Course Layer 3 contract inspected.
- [x] 53 historical UQ/RMIT `layer3_required` Evidence items identified with retained text/html Evidence and zero existing interpretations at inspection time.
- [ ] Resume bounded authenticated live-provider acceptance only after Gate A–C are clean.
- [ ] Do not enable generic scheduler Layer 3.
- [ ] Preserve Layer 4 and Search/Publication separation.

## Gate E — final PR acceptance

- [ ] Reconstruction P1 resolved through governed repository strategy.
- [ ] Fresh Codex review on final exact PR head with no unresolved P1/P2 findings.
- [ ] Exact-head CI/UAT/runtime clean after final corrections.
- [ ] Update PR #72 final acceptance summary.
- [ ] Merge only after all required gates are clean; no visible release bump before acceptance.

## Continuous M2.4.5 gates

- H7 production migration/telemetry inventory remains active; Production target states remain pending.
- H8 bugs/addenda/features remain Change-Controlled.
- H9 targeted validation precedes bounded integration; one broader nominated acceptance only when warranted.
- H10 meeting/status evidence remains maintained.
- QS ranking recovery remains independent.
- H14 external-consumer API-key lifecycle remains separately governed.

## Exact next action

Resolve the repository reconstruction P1 without altering immutable applied history, then obtain fresh Codex review. After that, use the normal authenticated scheduler surface to rediscover only the reopened 54 UQ + 27 RMIT Courses and reconcile changed actionable work. Layer 3 remains paused until those gates are clean.
