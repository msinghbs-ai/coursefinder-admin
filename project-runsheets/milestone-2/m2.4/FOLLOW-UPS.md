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
