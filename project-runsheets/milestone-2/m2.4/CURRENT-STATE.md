# M2.4 Current State

**Status:** ACTIVE — M2.4.0 CLOSED/PASS; M2.4.1 CLOSED/PASS; M2.4.2 NEXT FEATURE GATE  
**Updated:** 27 August 2026 04:18 AEST (+10:00)  
**Standing governance:** CF-CHG-20260826-042 / A1–A7  
**Recently closed:** CF-CHG-20260826-043

## Accepted baseline

- M1 CLOSED/PASS/FROZEN.
- M2.1 CLOSED/PASS.
- M2.2 CLOSED/PASS.
- M2.3 CLOSED/PASS with NZ first-party Layer 2 expansion deferred.
- M2.4.0 CLOSED/PASS.
- **M2.4.1 CLOSED/PASS.**
- Current accepted Pilot runtime: `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`.
- Visible browser release: PIM Admin `v2.15.7`.

Final M2.4.1 evidence:

- frontend build `32972106272` — PASS;
- Stage C deployed UAT `32972106291` — desktop/mobile PASS;
- deployed acceptance job `98188037242` — PASS;
- Stage A `32971449084` — PASS;
- Stage B `32971584012` — desktop/mobile PASS.

## M2.4.1 accepted outcome

Layer 1 Regulatory is now production-shaped for AU CRICOS and NZ NZQA:

- governed source authority/configuration and retained versions;
- dynamic authority/source-shape validation;
- expected-count and variance guardrails;
- one-active-source queueing, idempotency, retry/resume and cumulative reconciliation;
- progress/heartbeat/stuck visibility and bounded recovery;
- source hash/no-change path;
- non-destructive scheduled authoritative-source rechecks through one-time nonce;
- paused-source exclusion and stale schedule recovery;
- safe transient housekeeping preserving governed Evidence/source versions/canonical history;
- simplified normal operator UI with Source Health, Current/Next Job, Progress, Reconciliation, Evidence/Provenance, Schedule/Recheck and Blockers/Actions;
- accepted role/rank/RLS/service-helper/private-Evidence boundaries.

Live proof retained:

- AU CRICOS: 26,648 active / 90 expired / 26,738 total Course rows;
- NZ NZQA: 411 current providers versus 409 accepted baseline, approximately 0.489% PASS variance.

Final Security Advisor has no new material M2.4.1 Critical/High/Warning finding. Final Performance Advisor has no unindexed Layer 1 foreign key.

## M2.4 sequence

1. **M2.4.0 — CLOSED / PASS** — Integration Cleanup, Test-Liability Removal & Acceptance Rebase.
2. **M2.4.1 — CLOSED / PASS** — Layer 1 Regulatory Operations Maturity & Automation.
3. **M2.4.2 — NEXT / READY** — Layer 2 Full Enrichment, Operations Maturity & Performance.
4. M2.4.3 — PLANNED — Layer 3 AI Operations Maturity.
5. M2.4.4 — PLANNED — Cross-layer Operations, Housekeeping, Scheduling & Pre-blackout Acceptance.

## M2.4.2 governing intent

M2.4.2 should mature Layer 2 across the accepted source/provider architecture without weakening Layer 1 authority or reopening M2.4.0/M2.4.1 foundations.

Priorities:

- full enrichment across accepted AU scope;
- clear source/profile/provider routing and operator controls;
- queue/progress/reconciliation/retry/recovery maturity;
- full-run throughput and latency measurements;
- provider spend/economics and quota visibility;
- Evidence growth/storage impact;
- Layer 3 fall-out measurement before schedule/concurrency tuning;
- UI/UX simplification based on actual full-run evidence;
- operational alerts for provider/source/job failure states where Layer 2-specific;
- current Guides/Runbooks/release notes and staged automated UAT.

## Carry-forward constraints

- NZ first-party Layer 2 Course enrichment remains deferred pending separate source qualification/onboarding.
- AU/NZ Layer 1 authority, identity, validation and variance controls are frozen accepted dependencies.
- Data Quality/Layer 1/Layer 2 `admin_read` dispatches must remain reconciled.
- Guides/Runbooks/release notes remain a closure blocker if stale.
- broad Publication, Production establishment and Zoho cutover remain separate later gates.

## Immediate next gate

Open/reconcile the M2.4.2 prompt/runsheet, current Pilot and deployed Supabase Layer 2 providers/profiles/jobs/Evidence/runtime before feature changes. Use targeted Stage A during implementation, bounded integration before promotion, and exactly one final deployed desktop/mobile acceptance matrix.

## M2.4.2 closure checkpoint — 29 August 2026

M2.4.2 final Stage B integration is PASS on desktop and mobile, deployed run `33214733610`, Pilot marker `e2eec9b8de0187a5373b506342316ea457b79a0b`, frozen source `69cb9b465de0a00247db381bcbffcc98a6b1f30a`.

RMIT canonical promotion remains formally blocked without an authorised exact frozen-set executor; no bypass is permitted. UQ refresh remains enabled, RMIT disabled, Federation disabled/paused/source-limited. Exactly one Stage C final acceptance gate remains before M2.4.2 closure.


## M2.4.2 final-gate disposition — 29 August 2026

M2.4.2 Stage B remains accepted PASS on desktop/mobile (`33214733610`).

The single final Stage C candidate `91b115ddf64b020563c7ae6bbd1ea395db866d3f` failed acceptance run `33215640328` with 45/46 desktop tests passing; mobile was skipped after desktop failure. The sole failure was a stale pre-A12 Course-card reorder assertion, corrected afterward at Pilot `60e9e25a86a48522dbae7a29d6c2955c9d295761`.

Under the one-final-candidate rule, M2.4.2 is **BLOCKED**. No replacement Stage C is authorised without a new explicit governance/change-control decision. Running Build/Master Plan remain unadvanced.
