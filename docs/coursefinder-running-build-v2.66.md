# CourseFinder Running Build v2.66

**Status:** **M1-GUIDES-OPS-HANDOVER CLOSED / PASS**  
**Date:** 23 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.65.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.40.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.15.md`  
**User Guide:** `docs/coursefinder-user-guide-v2.0.md`  
**Operations Runbook:** `docs/coursefinder-operations-runbook-v1.0.md`

## Accepted release position

All accepted runtime, Search, publication, consumer, security and data-quality semantics from Running Build v2.65 remain unchanged.

Current accepted Admin runtime remains:

`PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0 + Data Quality v1.0 + Access Admin v1.0 + Publication Governance v1.0`

No frontend/runtime release is claimed by this documentation gate.

## M1-GUIDES-OPS-HANDOVER — accepted

`CF-CHG-20260823-025` is **CLOSED / PASS**.

Accepted documentation baseline:

- User Guide v2.0 — role-specific deployed navigation and normal operator use;
- PIM Admin Guide v1.15 — final complex-field semantic matrix and Admin interpretation rules;
- Operations Runbook v1.0 — source refresh, failed jobs, replay/idempotency, evidence inspection, source change, rollback, security escalation, Search admission and publication rollback;
- technical acceptance: `docs/uat/coursefinder-m1-guides-ops-handover-technical-acceptance-2026-08-23.md`.

Older User Guide instructions that describe Course Collections/Categories as current top-level navigation or semantic/vector Search as accepted production behaviour are superseded.

## Live state reconciled during handover

Pilot Supabase remains healthy and unchanged by this workstream.

Verified live state:

- all-country Providers: 3,085;
- all-country Courses: 43,461;
- accepted AU+NZ Search documents: 33,105;
- published Search documents: 0;
- Search projection version: `course-v3`;
- current Search generation: 22;
- combined accepted Search content hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- refresh function: `search.refresh_course_documents_v3`;
- enrichment gate: `domain_and_source_explicit`.

Generation is operational state and may advance during bounded deterministic refresh/UAT. Accepted content hashes and semantics are the stable baseline.

## Role boundary reconfirmed

Live roles remain:

1. Viewer;
2. Counsellor;
3. Curator;
4. Pipeline Operator;
5. PIM Admin;
6. Platform Admin.

Evidence/Review Queue requires rank 3; Jobs/Sources requires rank 4; PIM Configuration requires rank 5; Settings/Access Admin requires rank 6.

## Security position

The security adviser was rerun. The known `auth_leaked_password_protection` warning remains. It is still governed as a bounded Pilot exception under `CF-CHG-20260823-022` and remains a mandatory Production go-live gate.

No new schema, ACL, RPC, storage or runtime change was introduced by this documentation gate.

## Current gates

**M1-PIM-FINALISATION: CLOSED / PASS.**  
**M1-PIPELINE-OPS: CLOSED / PASS.**  
**M1-EVIDENCE-UX: CLOSED / PASS.**  
**M1-DATA-QUALITY-READINESS: CLOSED / PASS.**  
**M1-UAT-HARNESS: CLOSED / PASS.**  
**ACCESS ADMIN v1.0: CLOSED / PASS.**  
**M1-SEARCH-ENRICHMENT: CLOSED / PASS.**  
**M1-PUBLICATION-UAT: CLOSED / PASS.**  
**M1-GUIDES-OPS-HANDOVER: CLOSED / PASS.**  
**M1-SEARCH-VECTOR: REJECTED / NOT ADMITTED.**  
**LEAKED PASSWORD PROTECTION: DEFERRED FOR PILOT / MANDATORY PRODUCTION GATE.**