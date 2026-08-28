# M2.4 Follow-ups / Carry-forward Register

**Purpose:** Prevent unresolved work from being lost when an individual issue blocks a sub-milestone.

## Rules

Every blocked, deferred or newly discovered item must record ID, origin, problem, impact, evidence, owner/workstream, next action, target sub-milestone and status. Do not silently drop an item because another issue becomes the immediate focus.

## Current follow-ups

| ID | Origin | Item | Target | Status |
|---|---|---|---|---|
| M24-FU-001 | Go 7 / M2.4 | Obsolete floating navigation/permanent-suite dependency removed and accepted under M2.4.0. | M2.4.0 | CLOSED / PASS |
| M24-FU-008 | Go 7 stop | Post-Go7 Pilot reconciliation accepted on the M2.4.0 checkpoint. | M2.4.0 | CLOSED / PASS |
| M24-FU-009 | Go 7 / CI | Targeted → integration → one acceptance matrix established and retained through M2.4.1. | M2.4 | CLOSED / PASS |
| M24-FU-010 | Go 7 / UI | Floating operational launchers quarantined from normal operator architecture. | M2.4.0 | CLOSED / QUARANTINED |
| M24-FU-011 | Go 7 / UAT | Shared navigation adapters and bounded/fail-fast deterministic waits established. | M2.4.0 | CLOSED / PASS |
| M24-FU-012 | Go 7 / evidence | Lightweight UX/content audit separated from permanent functional acceptance. | M2.4.0 | CLOSED / PASS |
| M24-FU-013 | M2.4.0 performance | First Course-page performance contention fixed without widening the 3,000 ms budget. | M2.4.0 | CLOSED / PASS |
| M24-FU-002 | M2.3 | NZ first-party Layer 2 Course enrichment remains deferred pending source qualification/onboarding. Do not represent as implemented during M2.4.2. | Future governed NZ L2 gate | DEFERRED |
| M24-FU-003 | M2.4.1 | Explicit AU/NZ regulatory source validation and record-count variance guardrails established and accepted. | M2.4.1 | CLOSED / PASS |
| M24-FU-004 | M2.4.1/2 | Layer 1 transient queue/scheduler cleanup and retained Evidence/source-version lifecycle established; cross-layer housekeeping remains for later M2.4.4 consolidation. | M2.4.1/4 | L1 CLOSED / CROSS-LAYER CARRY-FORWARD |
| M24-FU-005 | M2.4.2 | Capture full-run Layer 2 performance, provider economics, Evidence growth and Layer 3 fall-out before tuning schedules/concurrency. | M2.4.2 | PLANNED / PRIORITY |
| M24-FU-006 | M2.4.2 | Add/verify Layer 2 operational alerts for stuck jobs, stale sources, provider quota/spend thresholds and abnormal source behaviour. | M2.4.2/4 | PLANNED / PRIORITY |
| M24-FU-007 | M2.4 | Keep Guides, Runbooks, release notes and current-state files synchronized with accepted UI/runtime behaviour. | Every sub-milestone | STANDING |
| M24-FU-014 | M2.4.1 Stage C | An obsolete permanent Course Detail release pin to v2.15.6 invalidated the first acceptance attempt; test was corrected without runtime semantic change and the full Stage A→B→C chain was restarted successfully. Prevent patch-version literals where a feature contract is intended. | UAT hygiene | CLOSED / PASS |

## M2.4.1 evidence summary

- accepted final Pilot: `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`;
- Stage A `32971449084` — PASS;
- Stage B `32971584012` — desktop/mobile PASS;
- Stage C `32972106291` — desktop/mobile PASS;
- build `32972106272` — PASS;
- AU CRICOS live validation: 26,648 active / 90 expired / 26,738 total;
- NZ NZQA live validation: 411 current versus 409 baseline, approximately 0.489% PASS variance;
- final Security Advisor: no new material M2.4.1 Critical/High/Warning finding;
- final Performance Advisor: no unindexed Layer 1 foreign key.

## Next review

At M2.4.2 start, review M24-FU-002, M24-FU-005, M24-FU-006 and standing M24-FU-007. Preserve all accepted M2.4.1 Layer 1 authority/security/operations contracts while maturing Layer 2.

## M2.4.2 Stage B closure input — 29 August 2026

Stage B desktop/mobile PASS is now accepted input for M2.4.2 final acceptance: run `33214733610`, marker `e2eec9b8de0187a5373b506342316ea457b79a0b`. Remaining consequential gate is exactly one Stage C final acceptance. RMIT canonical promotion and the Layer 3 source-pattern benchmark remain explicitly blocked/carry-forward and must not be bypassed.


## M2.4.2 final-gate blocker — 29 August 2026

Stage C final acceptance run `33215640328` failed 1 of 46 desktop tests; mobile was skipped. Root cause is a stale pre-A12 test assumption, not a runtime reorder defect. The test is corrected at Pilot `60e9e25a86a48522dbae7a29d6c2955c9d295761`, but governance prohibits silently replacing/re-running the single final Stage C.

Carry forward as **BLOCKED / GOVERNANCE REOPENING REQUIRED**. Do not advance programme baselines until explicitly authorised.


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
