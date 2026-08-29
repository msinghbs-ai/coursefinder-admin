# M2.4 Current State

**Status:** ACTIVE — M2.4.0 CLOSED/PASS; M2.4.1 CLOSED/PASS; M2.4.2 CLOSED/PASS; M2.4.3 ACTIVE  
**Updated:** 29 August 2026  
**Standing governance:** CF-CHG-20260826-042 / A1–A15  
**Active change:** CF-CHG-20260829-046

## Accepted baseline

- M1 CLOSED/PASS/FROZEN.
- M2.1 CLOSED/PASS.
- M2.2 CLOSED/PASS.
- M2.3 CLOSED/PASS with NZ first-party Layer 2 expansion deferred.
- M2.4.0 CLOSED/PASS.
- M2.4.1 CLOSED/PASS.
- **M2.4.2 CLOSED/PASS.**
- Current accepted Pilot runtime: `093010fada8391c93626b59e59c678064f4961c3`.
- Visible browser release: PIM Admin `v2.15.10`.

Final M2.4.2 evidence:

- Stage B `33214733610` — desktop/mobile PASS;
- corrective Stage C `33219089690` — 45/45 desktop and 45/45 mobile PASS;
- accepted Pilot `093010fada8391c93626b59e59c678064f4961c3`;
- Security Advisor 0 WARN / 0 ERROR;
- Performance Advisor 0 WARN / 0 ERROR.

Historical M2.4.1 evidence:

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
3. **M2.4.2 — CLOSED / PASS** — Layer 2 Full Enrichment, Operations Maturity & Performance.
4. **M2.4.3 — ACTIVE** — Layer 3 AI Operations Maturity plus governed A15 institute international contact intelligence.
5. M2.4.4 — PLANNED — Cross-layer Operations, Housekeeping, Scheduling & Pre-blackout Acceptance.

## Current next gate — M2.4.3

M2.4.3 should mature Layer 3 AI operations using the accepted M2.4.2 Evidence and telemetry substrate without granting direct canonical write authority.

Current inputs:
- A14 model/call/token/latency/cost telemetry is standing;
- accepted production Layer 3 interpretations remain 0 at M2.4.2 closure;
- the dedicated source-pattern benchmark remains blocked under its unchanged quality threshold;
- RMIT canonical promotion remains a separate Layer 2 carry-forward blocker and must not be bypassed through Layer 3;
- Search/Publication authority remains downstream and unchanged.

## Historical M2.4.2 governing intent — CLOSED

M2.4.2 matured Layer 2 across the accepted source/provider architecture without weakening Layer 1 authority or reopening M2.4.0/M2.4.1 foundations.

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


## Explicit governance reopening — corrective Stage C

**Authorisation:** User explicitly authorised one corrective M2.4.2 Stage C acceptance run using the corrected UAT contract on 29 August 2026.

Scope of reopening:
- permits exactly **one** corrective Stage C acceptance candidate/run;
- uses corrected Pilot source beginning at `60e9e25a86a48522dbae7a29d6c2955c9d295761`;
- does not erase or replace historical Stage C failure `33215640328`;
- does not broaden Layer 1 identity, canonical, Search, Publication, Evidence, secret or provider authority;
- preserves the RMIT 212-record canonical-promotion BLOCK and Layer 3 source-pattern benchmark BLOCK;
- preserves A14 telemetry;
- if the corrective acceptance run fails, M2.4.2 remains BLOCKED and no further Stage C attempt is authorised without another explicit governance decision;
- if desktop and mobile both PASS, CF-CHG-044/M2.4.2 may close and the Running Build/Master Project Plan may advance.


## Corrective Stage C PASS / M2.4.2 CLOSED — 29 August 2026

The explicitly authorised corrective Stage C is PASS.

- corrected UAT source: `60e9e25a86a48522dbae7a29d6c2955c9d295761`;
- corrective Stage C candidate / accepted Pilot: `093010fada8391c93626b59e59c678064f4961c3`;
- deployed acceptance run: `33219089690`;
- chromium-desktop: **45/45 PASS**;
- chromium-mobile: **45/45 PASS**.

Historical Stage C failure `33215640328` remains retained as immutable evidence. It was not rewritten or removed; the explicit governance reopening authorised exactly one corrective run after the stale pre-A12 reorder assertion was corrected.

Final post-acceptance runtime:
- Security Advisor: 131 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 167 INFO / 0 WARN / 0 ERROR;
- UQ weekly Course refresh ENABLED;
- RMIT weekly Course refresh DISABLED;
- Federation weekly Course refresh DISABLED; source profile PAUSED/source-limited;
- RMIT frozen cohort remains 212/212 identity matched, 0 unsafe, 0 applied, fingerprint `627bb7daa62fe3bbfc3047ce2b57a88e`;
- RMIT canonical promotion remains separately BLOCKED pending an already-authorised exact frozen-set executor;
- Layer 3 source-pattern benchmark remains separately BLOCKED under its unchanged quality threshold;
- A14 telemetry remains standing and carries into M2.4.3.

M2.4.2 is **CLOSED / PASS** for its accepted Pilot scope.

Accepted programme documents:
- Running Build: `docs/coursefinder-running-build-v2.76.md`;
- Master Project Plan: `docs/coursefinder-master-project-plan-v1.76.md`.

Next gate: **M2.4.3 — Layer 3 AI Operations Maturity**.


## M2.4.3 A15 active checkpoint — 29 August 2026

CF-CHG-20260829-046 / A15 is ACTIVE.

Implemented/deployed:
- private Provider contact discovery profiles, observations, watch events and enrichment-attempt telemetry;
- governed Provider-detail projection with first-party source precedence;
- Provider blade International contacts panel;
- PIM Admin v2.15.10 release notes;
- first-party contact discovery worker using governed Provider origins/subdomains, sitemap/deep-link discovery and structured regional-manager-table extraction;
- optional Apollo domain/title search adapter with personal-email/phone reveal disabled;
- one-time nonce allowlist and service-role-only private-schema bridges;
- contact-change semantics separating initial discovery from later meaningful title/territory/contact changes.

Initial governed cohort: 52 AU + 8 NZ = 60 Provider contact profiles.

Accepted live proof:
- The University of Queensland: 8 current first-party International Regional Manager territory assignments retained from its governed university page, each with institutional email, source URL, Evidence and 0.98 extraction confidence.
- final clean proof worker: provider-contact-discover-scheduled v1.1.2 / Edge v5 before fallback hardening.
- A15 targeted deployed browser UAT: PASS, run `33221965310`, commit `1c6fa1992a8068b408df1ef9bcb7cb59a535bf2c`.

Rollout hardening in progress:
- transport-only URL normalization corrects duplicate-scheme discovery-profile values without modifying Layer 1 Provider website authority;
- Direct HTTP → governed Firecrawl fallback added for blocked first-party contact pages with per-attempt usage/latency/cost telemetry;
- full 60-profile AU/NZ rollout and final integration/advisor reconciliation remain active.

A15 does not alter Layer 1 Provider/Course identity, Search, Publication or canonical authority.
