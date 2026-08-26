# CF-CHG-20260826-041 — Restore M2.2+ Standing Cross-Chat Instruction Contract

**Status:** APPLIED — GOVERNANCE BASELINE  
**Category:** 00-governance-programme  
**Initiated:** 26 August 2026 17:48 AEST (+10:00)  
**Origin chat/workstream:** Milestone 2 review / M2.4 continuation  
**Owner:** CourseFinder programme governance

## Trigger

The user identified that the M2.2-onward operating instruction set had become fragmented as M2.3/M2.4 work moved into increasingly narrow `NEXT-CHAT.md` and sub-milestone prompts. Review confirmed that `PROJECT_INSTRUCTIONS.md` still preserved the top-level governance rules, but the richer M2.2+ execution contract — autonomous UAT, security-first acceptance, repo-first continuation, blocker/follow-up continuity, production isolation, operational maturity and timekeeping/blackout rules — was not being explicitly inherited by every M2 continuation.

## Decision

Create `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md` as the durable M2.2+ continuation contract.

Every M2.x and M2.x.y runsheet / continuation prompt must inherit both:

1. `PROJECT_INSTRUCTIONS.md`; and
2. `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`.

Task-specific prompts may narrow scope, but they must not silently remove the standing governance, security, automated-UAT, authority, operations, documentation, follow-up or Production-boundary requirements.

## Restored requirements

The standing contract explicitly preserves:

- authoritative repo-first reconciliation before material work;
- inheritance of newer parallel work and deployed runtime truth;
- autonomous implementation/UAT and no routine manual technical UAT handoff;
- PASS/BLOCKED/DEFERRED evidence-backed closure states;
- follow-up recording rather than losing independent work when one issue blocks;
- Layer 1→2→3→4 authority model and downstream Search/Publication boundary;
- security-first acceptance including RPC/SECURITY DEFINER/RLS/grants/private-helper/Edge/secret-leak negative tests;
- automated DB/API/storage/browser/mobile/performance/replay/rollback/restore regression matrix;
- operational Admin UX principles: progress, queue, Evidence, health, next action, progressive diagnostics rather than experimental controls;
- scheduling/rechecks/housekeeping/stuck-job/retention/provider-budget/storage monitoring expectations;
- clean separate Production trust boundary;
- 16–30 September no-planned-delivery blackout;
- user-confirmed billing rather than inferred chat-duration hours;
- mandatory repo runsheet/current-state/follow-up/next-chat update before large-context handoff.

## Affected surfaces

- project-runsheets/milestone-2/*;
- future M2 continuation prompts;
- milestone governance and meeting record keeping;
- 70-security-platform and 80-uat-release-operations requirements by reference;
- Production planning by reference.

## Implementation evidence

- `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md` created.

## UAT / validation

Governance-only validation:

- compared current `PROJECT_INSTRUCTIONS.md` with M2.3 `NEXT-CHAT.md` and M2.4 `NEXT-CHAT.md`;
- confirmed the narrow continuation prompts did not explicitly carry the full M2.2+ operating contract;
- restored the missing requirements in one durable parent instruction file.

No deployed application/schema/security state is changed by this record.

## Rollback

Revert the standing-instruction document and this governance record. No runtime or canonical data rollback is required.

## Closure

**Status:** APPLIED — standing M2 continuation contract restored. Future M2 prompts must reference it explicitly.
