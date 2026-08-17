# CourseFinder Running Build v2.24

**Date:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.22.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.22.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Provider Authority: PASS at 1,130 Providers / 1,130 IRCC DLI identifiers.
- Active CA Course scope: `ca-intl-bachelor-plus-v1`.
- Active scope-qualified CA Courses: **1,986 / 25 Providers**.
  - Bachelor 1,055
  - Master 632
  - Doctorate 290
  - First-professional 9
  - null study level 0
- Physical CA Course rows: 9,960 total; 7,974 inactive historical rows retained for evidence/lifecycle history.
- No CA Course is currently promoted to final published Search Projection while the country gate remains blocked.

## Canada scope correction now implemented

The live build no longer treats broad post-secondary programme counts as the product target. Active CA Courses must satisfy all of:
1. canonical Provider resolves by current `ircc_dli` identity;
2. accepted source has a stable non-name programme identifier;
3. programme is current in the accepted source inventory;
4. source explicitly classifies the programme at Bachelor, Master, Doctorate or supported first-professional level;
5. international eligibility is proven by the jurisdiction-specific designation contract.

Titles/names are descriptive only and cannot create identity or infer study level.

Private scope-control infrastructure:
- `pipeline.ca_course_scope_keys`;
- `pipeline.source_record_staging` for source inventory;
- service-role-only `svc_layer1_stage_course_scope_keys(...)`;
- service-role-only `svc_layer1_apply_course_scope(...)`;
- service-role-only inventory replace/read RPCs.

These objects are not browser CRUD surfaces.

## BC current active degree set

Source: EducationPlannerBC.  
Identity: `bc_epbc_program_guid`.

Active accepted set: **1,428 Courses / 23 Providers**:
- 693 Bachelor;
- 513 Master;
- 213 Doctorate;
- 9 first-professional.

2,687 broad EPBC records outside the new scope are retained inactive/unpublished.

## Alberta ALIS production adapter

Source ID: `2455ffdf-66ae-4b82-943c-b7293d996668`  
System: `ca_ab_alis_programs`  
Course identity: `ab_alis_program_guid`  
Edge worker: `layer1-ca-ab-alis-degrees-v0.2.0`  
Scope: `ca-intl-bachelor-plus-v1`

The worker:
- requires vault-backed Pilot automation authorisation;
- resolves a verified ALIS school UUID to a canonical current IRCC DLI Provider;
- captures full live ALIS inventory into private staging;
- fetches detail records in bounded batches of maximum eight;
- accepts only `Credential Type = Degree` with exact ALIS `Program Type` of Bachelor's, Master's or Doctoral;
- stages accepted GUIDs into the private scope table;
- reconciles canonical Courses using stable programme GUID identity;
- captures private evidence/hash lineage;
- applies scope lifecycle/study-level reconciliation through restricted RPCs.

### University of Calgary — production sub-gate PASS

- inventory 279/279;
- accepted 179 = 83 Bachelor / 59 Master / 37 Doctorate;
- first APPLY 179 created / 0 conflicts;
- replay 0 created / 179 existing / 0 conflicts;
- integrity 179 identifiers = 179 Courses, no orphans.

### University of Alberta — production sub-gate PASS

Stable ALIS school UUID: `420f73a6-7623-4ec9-8013-a12700c54747`  
Current IRCC DLI: `O19257171832`

Inventory:
- 432/432 records;
- 432 distinct stable programme GUIDs;
- inventory hash `318438de427989379f77159983fbfd2d081ebb04eb1c31cd7ca02ef61d921efa`.

Degree-only dry-run:
- 432/432 processed;
- 379 accepted;
- 279 Bachelor / 60 Master / 40 Doctorate;
- 0 unexpected study levels;
- bounded batches completed with evidence capture.

First APPLY:
- 54/54 batches PASS;
- 379 created;
- 0 existing;
- 0 conflicts;
- 0 failed batches.

Full replay:
- 54/54 batches PASS;
- 0 created;
- 379 existing;
- 0 conflicts;
- 0 failed batches.

Integrity:
- 379 identifiers;
- 379 distinct identifiers;
- 379 distinct canonical Courses;
- 0 orphan identifiers;
- 0 wrong Provider links;
- 379 active;
- 0 null study levels.

A single dry-run request earlier returned `JWT issued at future`; retrying the same offset passed. No canonical write was made by that failed request and APPLY/replay completed without recurrence.

Current Alberta scoped set after UAlberta: **558 stable programme GUIDs across two Providers**.

## Historical-source posture

Preserved but inactive where not requalified:
- Quebec MES non-degree Courses: 1,363;
- Ontario broad public-college Courses;
- Manitoba broad catalogue Courses;
- Nova Scotia broad catalogue Courses;
- Saskatchewan broad catalogue Courses;
- Newfoundland and Labrador broad catalogue Courses;
- Northwest Territories broad catalogue Courses;
- Yukon broad catalogue Courses.

This is intentional lifecycle preservation, not deletion.

## Security posture

- Provider and Course identity RPCs remain service-role constrained.
- Private scope/inventory/evidence data remain non-browser surfaces.
- `layer1-ca-ab-alis-degrees` has `verify_jwt=false` only because it implements custom vault-backed automation-key authentication and backend allowlisting.
- TLS is not weakened.
- Diagnostic/probe Edge Functions are temporary and must be removed or locked before final CA security PASS.

## Search position

Search remains a final country-gate item. Current active scoped CA Courses are canonical but not yet promoted as published CA Search Projection. Final Search UAT must prove that inactive historical broad data cannot leak into student discovery.

## Current blocker and next execution

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains open, now defined against the declared international-student Bachelor+ scope.

Next execution order:
1. continue ALIS production UAT across the remaining verified Alberta public-DLI mappings;
2. resolve St. Mary's University if a stable current ALIS mapping is available;
3. acquire Ontario university Bachelor+ sources;
4. acquire Quebec degree sources;
5. close remaining provincial/territorial degree-provider gaps;
6. explicitly replay BC degree-only scope;
7. run full CA integrity/Search/security/performance/advisor UAT;
8. mark CA PASS only when all final criteria are satisfied.
