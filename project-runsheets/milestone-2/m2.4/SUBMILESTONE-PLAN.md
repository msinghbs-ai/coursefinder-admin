# M2.4 Sub-milestone Plan

**Status:** ACTIVE / CLEANUP GATE FIRST  
**Updated:** 26 August 2026  
**Parent milestone:** M2.4 — AI/Data Quality Optimisation, UX Consolidation, Full-Stack Regression & Pre-Blackout Checkpoint  
**Active parent Change Controls:** CF-CHG-20260826-040 and CF-CHG-20260826-042

## Purpose

Keep the existing outcome-oriented M2.4 plan, but insert a mandatory integration-cleanup gate before further feature development. Go 7 proved that navigation/test coupling and full-matrix-per-commit execution can disrupt momentum even when the underlying feature is sound.

All M2.4 work inherits `PROJECT_INSTRUCTIONS.md`, Milestone 2 Standing Instructions and A1–A6.

## Sequence

0. **M2.4.0 — Integration Cleanup, Test-Liability Removal & Acceptance Rebase** — mandatory first gate.
1. **M2.4.1 — Layer 1 Regulatory Operations Maturity & Automation**.
2. **M2.4.2 — Layer 2 Full Enrichment, Operations Maturity & Performance**.
3. **M2.4.3 — Layer 3 AI Operations Maturity**.
4. **M2.4.4 — Cross-layer Operations, Housekeeping, Scheduling & Pre-blackout Acceptance**.

M2.4.1 and M2.4.2 remain the user-directed core plan and are not replaced by M2.4.0. M2.4.0 exists only to clear inherited code/test/CI liability so those workstreams can proceed without repeated disruption.

## Dependency map

`M2.4.0 cleanup/accepted navigation+test baseline → M2.4.1 mature Layer 1 AU/NZ → M2.4.2 mature Layer 2 + broad AU enrichment/performance → M2.4.3 mature already-active Layer 3 → M2.4.4 cross-layer/housekeeping/pre-blackout acceptance`

Do not start M2.4.1 implementation while M2.4.0 is red. Do not start M2.4.2 broad enrichment before M2.4.1 acceptance. M2.4.3/4 may be prepared in documentation but must not overwrite active earlier-layer foundations.

## Automated development/testing model

Every sub-milestone uses A1:

1. **Targeted validation** while actively developing.
2. **Bounded integration regression** when a coherent slice is ready.
3. **One full deployed desktop/mobile acceptance matrix** only for a nominated acceptance candidate.

A failed final matrix must be reduced to a targeted failing dependency before another candidate is nominated. Do not repeatedly run the complete suite as the debugging loop.

Primary navigation/shared test adapters are standing architecture under A2/A3. Screenshot/page-content/performance auditing is a separate lightweight evidence suite under A5.

## Programme rules

- Do not expose experimental/reset/probe controls in the normal operator journey.
- Preserve stable source identity, Evidence, versioning and immutable operational lineage.
- Every routine operator action must be role/rank protected server-side.
- Automated UAT remains mandatory; its staging must follow A1 rather than full-matrix repetition.
- The UI must show status, progress, next action, Evidence and errors without requiring Supabase/schema knowledge.
- Jobs must be restartable/resumable where safe, idempotent where expected, and clean up transient state after completion.
- Scheduling, rechecks, retention and housekeeping must be governed configuration, not hidden manual procedures.
- Any blocked task must be recorded in FOLLOW-UPS.md with owner, impact, evidence and next action before moving on.
- Guides, release notes, runsheets and operational documentation are part of acceptance, not post-project cleanup.
- Broad Publication and Production cutover remain separately governed.


## Inserted M2.4.5 gate — 3 September 2026

M2.4.4 remains CLOSED / PASS / FROZEN. A new additive pre-production gate is inserted before M2.5:

`M2.4.4 frozen acceptance → M2.4.5 Admin/PIM hardening & operational readiness → M2.5 Production P0–P8`.

Authority: CF-CHG-20260903-087 and `project-runsheets/milestone-2/m2.4/m2.4.5/`.

M2.4.5 owns Admin IA/UI standardisation, Scraper Config/routing hardening, Scholarship PIM maturity, Scheduler/Jobs review, manual PIM records, publication control-plane safety, Production migration telemetry freshness, dated bug/addenda intake, faster targeted UAT and milestone-meeting evidence. It does not invalidate the M2.4.4 acceptance baseline.
