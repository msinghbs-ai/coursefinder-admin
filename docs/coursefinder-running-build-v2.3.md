# Coursefinder Running Build v2.3

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.1.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.2.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; **CA ACTIVE / BLOCKED ON FEDERATED COURSE-SOURCE COVERAGE**; GB/US/IE queued; DE deferred/blocked.
- CA Course identity architecture is now resolved and implemented.
- Phase 2 Admin/PIM redesign remains approved.
- AU QILT structured-outcomes foundation remains applied and independent of the CA gate.
- Phase 7 hardening continues.

## Accepted Layer 1 baselines

### AU
- Providers: 1,546
- Courses: 26,648
- Campuses: 3,922
- Course↔Campus links: 47,671
- Search Documents: 26,648

### NZ
- Providers: 409
- Courses: 6,457
- Search Documents: 6,457

Combined accepted catalogue after NZ:
- Providers: 1,955
- Courses: 33,105
- Search Documents: 33,105

## CA runtime

### Provider acquisition
- Worker: `layer1-ca-live` / `layer1-ca-live-v1.0.0`.
- Source: IRCC Designated Learning Institutions list.
- Provider identity: `CA + ircc_dli + DLI number`.
- CA Admin route no longer executes the preserved seed/snapshot adapter.
- `verify_jwt=true`; Platform Admin check retained.
- raw IRCC evidence stored privately with SHA-256 lineage.

### Course identity foundation
New architecture contract:

`Provider + course identity scheme/source namespace + stable source-local programme identifier`

New database objects:
- `catalogue.course_identifiers`
- `pipeline.source_record_staging`
- `public.svc_layer1_apply_scoped_course_records(...)`

Security verification:
- `catalogue.course_identifiers`: no `anon/authenticated` direct SELECT.
- `pipeline.source_record_staging`: no `anon/authenticated` direct SELECT.
- scoped reconciliation RPC: `anon=false`, `authenticated=false`, `service_role=true` for EXECUTE.

Applied migrations:
- `20260812115258 ca_scoped_course_identity_and_staging`
- `20260812115331 ca_scoped_course_reconciliation_rpc`

Pilot repository commits:
- `0254920c24a245571b9fc16bfe0c297b35a195ae`
- `b794ab9cc3293bf78e776276c1c76b239d908c37`

### First provincial Course source configured
Ontario public college programmes:
- system code: `ca_on_public_college_programs`
- Course identity/registration scheme: `on_aps`
- role: provincial Course identity/authority for Ontario public colleges.
- country coverage flag: incomplete.

CA still has **0 accepted canonical Providers/Courses** from this new path because full APPLY remains prohibited until source coverage and mapping UAT are complete.

## CA gate state

Resolved:
- non-name Provider identity;
- non-name Course identity architecture;
- separation of Provider and Course identity schemes;
- raw heterogeneous ELT staging;
- service-role-only reconciliation boundary;
- Ontario APS source qualification/configuration.

Remaining blocker:

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`

Required work:
1. implement live Ontario APS acquisition/parser;
2. map Ontario programme Providers to exact IRCC DLI identity without name-based canonical identity;
3. dry-run/APPLY/idempotency/integrity UAT for the Ontario slice;
4. discover and qualify remaining provincial/territorial programme sources;
5. use authoritative first-party institutional programme codes only for documented coverage gaps;
6. complete full CA bounded APPLY/resume;
7. run duplicate/orphan/integrity and Search Projection UAT;
8. close performance/security gate.

## Search Projection operational rule

Reconcile bounded slices first. Run one controlled Search Projection finalisation after a completed accepted country load, or serialize finalisation. Do not run concurrent full-catalogue finalisation from every slice.

## Parallel work retained

The v2.10 QILT/ComparED Layer 2A foundation remains active and unchanged. It does not alter the CA Layer 1 sequence or Course identity rules.

## Current next step

**Ontario APS live ingestion + DLI mapping UAT is the next CA implementation slice.**

Do not advance GB production APPLY until the CA gate is either PASS or programme governance explicitly changes sequencing.
