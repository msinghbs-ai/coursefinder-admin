# CourseFinder Running Build v2.36

**Status:** CURRENT RUNNING BUILD  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.35.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.34.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.33.md`

## Build delta

The immediate serial gate remains `M1-L1-AU-CRICOS-COMPLETENESS`.

`M1-L2-AU-COURSE-FACTS` has been pre-staged only to verify the future Provider-owned enrichment contract. This does not authorise Layer 2 APPLY and does not change the programme sequence in master plan v1.33.

## Verified live AU state

- Providers: 1,546
- active Courses: 26,648
- missing mapped Study Level: 2,281
- missing canonical campus relationship: 34
- Search Documents: 33,105
- Search `has_fee=true`: 0

## AU first-party Course Facts pre-stage

Bounded RMIT source verification covered two exact CRICOS-coded Courses and proved the future contract for:
- official Course URL;
- 2027 international fee with exact published basis;
- intake/application timing;
- IELTS / TOEFL iBT / PTE / C1 Advanced requirements;
- source/evidence retention;
- exact CRICOS Provider+Course mapping;
- idempotent source-keyed replay.

The apply contract was hardened so Layer 2:
- cannot use title-only identity;
- requires an admitted source qualification;
- does not mutate canonical `catalogue.courses.course_url`;
- stores Provider-current tuition as `provider_current_tuition` rather than CRICOS registered fee semantics;
- preserves source/evidence and validity metadata.

## Pre-stage UAT

Bounded dry-run: PASS.

Temporary APPLY/replay after one intake-key expression fix: PASS.

Validated replay cardinality:
- 2 source records;
- 2 official Course links;
- 2 Provider-current fee rows;
- 3 intake rows;
- 8 English requirement rows;
- 0 canonical Course URL mutations;
- 0 primary Layer 2 link promotions;
- 0 CRICOS registered-fee collisions.

Ambiguity test: PASS — invalid/mismatched CRICOS Course code rejected; no title fallback exists.

Because the prerequisite gate is still open, all temporary catalogue Layer 2 rows were removed after UAT. Source evidence remains available for reproducibility.

## Current Course Facts posture

RMIT source qualification:
- status: `deferred`;
- `apply_admitted=false`;
- `search_admitted=false`.

Current applied RMIT Layer 2 facts:
- links: 0;
- Provider-current fees: 0;
- intakes: 0;
- English requirements: 0.

## Search posture

Unchanged and blocked for Course Facts enrichment:
- Search Documents: 33,105;
- `has_fee=true`: 0.

## Current gate

**Immediate primary remains:** `M1-L1-AU-CRICOS-COMPLETENESS`.

Only after that gate passes may `M1-L2-AU-COURSE-FACTS` reactivate its first-party source qualification and rerun authoritative capture + dry-run/APPLY/replay/idempotency/ambiguity UAT for acceptance.