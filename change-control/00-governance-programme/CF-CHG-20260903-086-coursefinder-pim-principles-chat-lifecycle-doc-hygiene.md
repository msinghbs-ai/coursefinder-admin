# CF-CHG-20260903-086 — CourseFinder PIM Principles, Chat Lifecycle & Documentation Hygiene

**Status:** APPLIED — GOVERNANCE BASELINE / ARCHIVE MIGRATION STAGED  
**Category:** 00-governance-programme  
**Initiated:** 2026-09-03 10:03 AEST  
**Origin chat/workstream:** 01-CourseFinder PIM Principles  
**Owner:** CourseFinder programme governance  
**Change class:** governance / documentation / delivery process

## Trigger

Version-alignment problems, chat sprawl, bug/addenda work bypassing primary repository principles, inconsistent UI trial behaviour, and a crowded `docs/` root containing many superseded document versions.

## Requested outcome

Establish one durable CourseFinder PIM/Admin operating principle covering:
- new-chat and milestone continuation discipline;
- simple achieved/failed/next handoff;
- dated bug/addenda/feature traceability;
- end-to-end feature wiring through Settings, telemetry, evidence and operation;
- Settings protection before feature/control removal;
- standard navigation and trial-feature handling;
- consistent UI/UX theme and screen-density principles;
- bounded agile UAT and regression control;
- explicit current-document routing;
- reference-safe historical documentation archiving.

## Before

The repository already had strong Project Instructions, Change Control and runsheet continuity, but the operating rules were distributed across multiple milestone addenda. New chats could still choose documents by filename/version inference, and the docs root contained multiple historical versions side-by-side.

## After

- `docs/README.md` becomes the explicit current-document router.
- `docs/01-governance/coursefinder-pim-operating-principles-v1.0.md` becomes the durable Admin/PIM delivery principle.
- `PROJECT_INSTRUCTIONS.md` requires both before material work.
- `project-runsheets/README.md` adopts a standard chat naming/start/close contract.
- M2 standing instructions inherit the PIM principles.
- historical document relocation is staged as a reference-safe migration, not a blind bulk move.

## Semantic impact

No Layer 1 identity, canonical data, Search/publication or consumer semantic change.

Operational impact is governance-significant: all material work now uses the current-document router and work-item/chat lifecycle rules.

## Implementation references

- `docs/README.md`
- `docs/01-governance/coursefinder-pim-operating-principles-v1.0.md`
- `PROJECT_INSTRUCTIONS.md`
- `project-runsheets/README.md`
- `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`
- `change-control/REGISTER.md`

## UAT / validation

Targeted governance validation:
- current core doc paths cross-checked against existing M2.5 state/register;
- new principle does not supersede Change Control, runsheets or runtime truth;
- document migration explicitly prevents breaking historical references;
- chat lifecycle retains existing autonomous/bounded UAT model.

Result: PASS for principle and current-document routing. Physical historical archive migration remains staged and must be performed in reference-safe batches.

## Rollback

Revert the CF-086 governance commits and restore prior read order. No runtime/database rollback is required.

## Next action

Execute historical docs archive migration in bounded families, starting with a low-risk superseded document family. For each batch, rewrite references and validate before deleting old paths.

## Status history

| Timestamp | Status | Event |
|---|---|---|
| 2026-09-03 10:03 AEST | PROPOSED | User requested consolidated PIM principles, chat lifecycle and docs hygiene |
| 2026-09-03 10:03 AEST | APPLIED | Principle/current-document router and inherited governance prepared |

