# M2.4 Sub-milestone Plan

**Status:** ACTIVE / GOVERNED SPLIT
**Updated:** 26 August 2026
**Parent milestone:** M2.4 — AI/Data Quality Optimisation, UX Consolidation, Full-Stack Regression & Pre-Blackout Checkpoint
**Active parent Change Control:** CF-CHG-20260826-040

## Purpose

Split M2.4 into smaller, outcome-oriented sub-milestones so the programme can simplify and mature Layer 1 and Layer 2 operations before further AI optimisation. Each sub-milestone must remain security-first, automated-UAT-first and fully documented.

## Sequence

1. **M2.4.1 — Layer 1 Regulatory Operations Maturity & Automation**
2. **M2.4.2 — Layer 2 Full Enrichment, Operations Maturity & Performance**
3. **M2.4.3 — Layer 3 AI Operations Maturity**
4. **M2.4.4 — Cross-layer Operations, Housekeeping, Scheduling & Pre-blackout Acceptance**

M2.4.3 and M2.4.4 are follow-up placeholders so issues discovered in M2.4.1/2 are not lost if an individual defect blocks progress.

## Programme rules

- Do not expose experimental/reset/probe controls in the normal operator journey.
- Preserve stable source identity, Evidence, versioning and immutable operational lineage.
- Every routine operator action must be role/rank protected server-side.
- Automated UAT is mandatory for database/API/security/storage/browser/mobile/rollback/replay where applicable.
- The UI must show status, progress, next action, Evidence and errors without requiring Supabase/schema knowledge.
- Jobs must be restartable/resumable where safe, idempotent where expected, and clean up transient state after completion.
- Scheduling, rechecks, retention and housekeeping must be governed configuration, not hidden manual procedures.
- Any blocked task must be recorded in FOLLOW-UPS.md with owner, impact, evidence and next action before moving on.
- Guides, release notes, runsheets and operational documentation are part of acceptance, not post-project cleanup.
- Broad Publication and Production cutover remain separately governed.
