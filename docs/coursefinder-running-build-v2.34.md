# CourseFinder Running Build v2.34

**Status:** CURRENT RUNNING BUILD  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.33.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.32.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.32.md`

## Build delta

The accepted CRICOS facts implementation is now consolidated into the primary AU Layer 1 operational adapter.

Primary worker:
- `layer1-au-depth-v1.5.1`;
- bounded streamed processing, maximum 500 Courses per invocation;
- internally invokes `layer1-au-cricos-facts-v1.1.0` for the regulatory facts phase using the same source/evidence/hash contract;
- no per-batch Search rebuild.

## Verified live state

- AU Providers: 1,546
- AU active Courses: 26,648
- current CRICOS regulatory observations: 26,648
- active CRICOS registered-total-course fee observations: 79,562
- Search Documents: 33,105
- Search `has_fee=true`: 0
- running AU depth jobs after UAT: 0

## Adapter UAT

500-record dry-run: PASS.

500-record APPLY/replay: PASS:
- 500 existing Courses;
- 500 existing Providers;
- 11 existing Campuses;
- 515 existing Course-location links;
- 500 facts unchanged;
- 1,488 fee observations unchanged;
- zero identity/fact/fee creates or updates;
- zero misses/conflicts.

End boundary offset 26,500: PASS:
- 148 selected;
- `hasMore=false`;
- 148 facts unchanged;
- 444 fee observations unchanged;
- zero creates/updates/misses/conflicts.

Detailed UAT: `docs/coursefinder-au-cricos-layer1-adapter-consolidation-uat-v1.0.md`.

## Completeness

The accepted facts materially improve Layer 1 regulatory/source completeness.

Analysis-only 13-dimension AU regulatory profile:
- estimated previous average: 45.49%;
- current average: 99.22%;
- 24,239 Courses at 100%;
- 26,448 Courses >=90%;
- 200 Courses <90%.

The existing publication/Search completeness score remains unchanged/null because AU has no Course publishing-state completeness rows/profile. This build does not conflate regulatory completeness with consumer readiness.

## Search posture

`courses/course_fee` remains blocked. CRICOS total-course fees do not enter consumer Search until the separate Search admission gate passes.

## Gate

**AU Layer 1 adapter consolidation = PASS / ACCEPTED.**

Layer 2 begins only with Provider-owned facts CRICOS does not supply at the required grain/freshness.
