# Coursefinder Running Build v1.9

## Current Phase
Phase 3 — Layer 1 Regulatory Worker: AU CRICOS UAT / runtime hardening.

## Completed
- Mumbai Pilot database and authenticated Admin UI.
- Phase 0A RLS/privilege hardening.
- Phase 1A Regulatory Settings.
- Layer 1 Worker runtime with AU CRICOS discovery, evidence, hashing and reconciliation.
- 26,738 CRICOS course records parsed from the current official dataset.
- Controlled 100-record dry-run passed.
- Controlled 100-record APPLY passed: 2 providers created, 95 courses created, 5 existing courses linked, 0 conflicts.
- Idempotency validation: catalogue remains at 100 CRICOS course registrations, 95 regulator-created courses and 2 regulator-created providers after the repeated deterministic batch; no duplicate regulator-created courses.

## Current Runtime Issue
A later idempotency rerun returned HTTP 503 to the browser after database reconciliation and left its Pipeline Job row in Running. Catalogue counts were verified stable and the orphaned job was closed operationally. The synchronous browser request model is being replaced by queued Worker execution plus UI polling.

A separate UI defect can invoke `ui_course_detail` without a course ID and produce a PostgREST schema-cache error. Client-side parameter guarding is being added.

## Database
Migrations applied through 035.
- 033 evidence bucket CSV MIME support.
- 034 UUID-safe CRICOS reconciliation.
- 035 Platform Admin Layer 1 job status/latest-job read contracts.

## Immediate Gate
Deploy Layer 1 asynchronous job execution and persistent Settings result polling. Revalidate the 100-record deterministic batch before adding CRICOS Locations/Course Locations and full AU ingestion.
