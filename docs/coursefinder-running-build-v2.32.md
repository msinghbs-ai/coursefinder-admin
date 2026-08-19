# CourseFinder Running Build v2.32

**Status:** CURRENT RUNNING BUILD  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.31.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.30.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.30.md`

## Build delta

No canonical data was mutated in this governance correction.

The build review identified an accepted-source extraction gap in AU Layer 1: CRICOS Course records expose registered tuition/cost and other structured Course attributes, but the current `layer1-au-depth` adapter does not persist them.

## Verified live data state

- AU Courses: 26,648
- AU `catalogue.course_fees` rows: 0
- all `catalogue.course_fees` rows: 0
- AU Course Links: 0
- AU Course Intakes: 0
- AU English requirement rows: 0

Existing accepted Search remains unchanged:
- Search Documents: 33,105
- AU: 26,648
- NZ: 6,457
- vector embeddings: 0

## Adapter finding

Current `layer1-au-depth` persists:
- CRICOS Provider/Course identity;
- Course title;
- mapped Course level;
- duration weeks;
- ASCED narrow field;
- Locations/Campuses;
- Course Locations/Course Campus relationships.

It does not currently persist CRICOS registered Tuition Fee, Non Tuition Fee or Estimated Total Course Cost.

Detailed finding: `docs/coursefinder-au-cricos-course-facts-gap-v1.0.md`.

## Revised execution

Primary next gate: `M1-L1-AU-CRICOS-FACTS`.

After that: `M1-L2-AU-COURSE-FACTS` for first-party current Course URL, fee schedule, intakes and English requirements.

Parallel independent gates:
- `M1-PIM-HARDENING`;
- `M1-SEARCH-VECTOR`.

## Search posture

Fee/Link/Intake/English Search admission remains blocked. Persisting a CRICOS regulatory fee must not automatically make a Course consumer-ready for a current fee display.

A regulatory registered total-course amount and a first-party current/year-specific marketed fee are distinct observations and should coexist with provenance.

## Security posture

M1-SEARCH remains accepted. Pre-existing Admin/PIM browser-executable `SECURITY DEFINER` warnings and the Supabase Auth leaked-password-protection warning remain outstanding for the dedicated PIM/security hardening gate.

## Gate

**Governance/source-completeness correction accepted. No data migration performed in this update.**
