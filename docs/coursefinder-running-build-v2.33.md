# CourseFinder Running Build v2.33

**Status:** CURRENT RUNNING BUILD  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.32.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.31.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.31.md`

## Build delta

`M1-L1-AU-CRICOS-FACTS` is complete and accepted.

The current CRICOS Courses source has been fully inventoried and all 24 fields are now explicitly classified as canonical core, relational observation, source-only evidence/validation or explicitly excluded.

Useful omitted regulatory facts have been added without changing CRICOS Course identity.

## Verified live data state

Accepted AU canonical substrate remains:
- Providers: 1,546;
- Courses: 26,648.

New AU regulatory facts:
- current `catalogue.course_regulatory_observations`: 26,648;
- Courses with VET National Code observation: 10,214;
- Courses with Dual Qualification observation: 26,648;
- Courses with Foundation Studies observation: 26,648;
- Courses with Work Component observation: 26,648;
- valid Work Hours/Week observations: 6,172;
- valid Work Weeks observations: 7,053;
- valid Work Total Hours observations: 7,049;
- Courses with Course Language observation: 26,648.

CRICOS registered total-course fees:
- Tuition: 26,457 rows;
- Non Tuition: 26,457 rows;
- Estimated Total Course Cost: 26,648 rows;
- total active CRICOS fee observations: 79,562;
- current/year-specific Provider fee rows: 0.

Existing Search remains unchanged:
- Search Documents: 33,105;
- AU: 26,648;
- NZ: 6,457;
- `has_fee=true`: 0;
- vector embeddings: 0.

## Fee semantics

CRICOS fee rows are stored as regulatory total-course observations only:
- audience `international`;
- currency `AUD`;
- basis `registered_total_course`;
- `fee_year=NULL`;
- no annualisation.

Tuition, Non Tuition and Estimated Total Course Cost remain separate fee types.

## Regulatory observation decisions

Retained:
- VET National Code as relational observation, not identity;
- Dual Qualification;
- Foundation Studies;
- Work Component plus valid typed work quantities;
- Course Language using exact CRICOS vocabulary;
- secondary narrow Field of Education as a non-primary relationship where distinct.

Five negative work-quantity source values remain evidence-only anomalies and were not manufactured into typed positive facts.

## Source/evidence

Accepted source snapshot:
- CRICOS Courses resource last modified: `2026-08-04T08:04:20.717556Z`;
- SHA-256: `fc2f2ef81c0b3c63dd47e1b01c7e5cf22f708c892e70f71707dbb421baed6945`;
- evidence id: `11e23b34-f86e-42ee-8093-a5ab70bfdfd2`.

Detailed UAT: `docs/coursefinder-au-cricos-course-facts-uat-v1.0.md`.

## UAT status

Full dry-run: PASS.  
Full APPLY: PASS.  
Full same-snapshot replay: PASS.  
Identity completeness: 26,648 / 26,648.  
Fact duplicate groups: 0.  
Fee duplicate source-key groups: 0.  
Annualised CRICOS fee rows: 0.  
Wrong fact/fee evidence rows: 0.

Operational Edge worker:
- `layer1-au-cricos-facts-v1.0.4`;
- maximum 500 records per invocation;
- accepted 500-record post-APPLY dry-run smoke: HTTP 200, 500/500 matched, 500 facts unchanged, 1,488 fees unchanged, zero creates/updates/misses.

## Search posture

`search.enrichment_gates` for `courses/course_fee` remains **blocked** with approval reference `Await M1-L2-AU-COURSE-FACTS UAT`.

The new CRICOS regulatory fee observations therefore remain catalogue/governance facts only and do not enter Search or consumer fee readiness.

## Security posture

The new regulatory observation table is private/RLS-enabled. The reconciliation RPC is service-role only and the bounded worker uses the existing one-time nonce/platform-admin execution boundary.

Pre-existing Admin/PIM `SECURITY DEFINER`, leaked-password-protection and other unrelated production-hardening advisories remain outstanding in their existing gates.

## Revised execution

Primary next gate: `M1-L2-AU-COURSE-FACTS`.

Scope:
- authoritative Provider-owned Course URL;
- current/year-specific international fee schedules with exact year/basis dimensions;
- intakes;
- English requirements;
- CRICOS-code/stable-identity resolution only;
- evidence, validity, replay and ambiguity handling.

Parallel independent gates:
- `M1-PIM-HARDENING`;
- `M1-SEARCH-VECTOR`.

Search fee/link/intake/English admission remains a later separate readiness gate.

## Gate

**M1-L1-AU-CRICOS-FACTS = PASS / ACCEPTED.**
