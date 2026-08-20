# CourseFinder Running Build v2.40

**Status:** CURRENT RUNNING BUILD  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.39.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.36.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.36.md`  
**Layer 2 UAT:** `Coursefinder-Pilot/docs/m1-l2-au-course-facts-rmit-uat-2026-08-20.md`

## Build delta

`M1-L2-AU-COURSE-FACTS` has started from the accepted `layer1-au-depth-v1.6.0` baseline.

RMIT University official Course pages are now the first accepted bounded Provider-owned Course Facts source.

## Preserved Layer 1 baseline

- AU Providers: 1,546
- active CRICOS Courses: 26,648
- missing Study Level: 0
- 34 Campus gaps: authoritative source absence
- unexplained Layer 1 mapping defects: 0

## Accepted first-source Layer 2 state

Source: `au_rmit_official_course_pages`  
Worker: `coursefacts-au-rmit-v0.2.0`  
Qualification: `qualified`

Applied observations:

- official Course links: 2
- provider-current international fees: 2
- intakes: 3
- English requirements: 8

Exact Courses:

- `111279A` — Associate Degree in Business
- `103390B` — Advanced Diploma of Electronics and Communications Engineering

## Fee separation

Provider-current fees are stored as `provider_current_tuition` and retain year and published basis.

They remain distinct from CRICOS registered total-course fee observations.

## UAT

Fresh-source dry-run: PASS.  
APPLY: PASS.  
Fresh replay: PASS at canonical row level.  
Ambiguity rejection: PASS.  
Canonical Course URL mutation: 0.  
CRICOS fee collision: 0.

Dynamic RMIT HTML changed source content hashes between fresh captures while parsed payload hashes remained stable. Evidence versioning therefore grew as designed without duplicate canonical facts.

## Search isolation

Search remains unchanged:

- Course Documents: 33,105
- `has_fee=true`: 0
- `has_intake=true`: 0
- `has_english=true`: 0

No Search enrichment admission occurred.

## Current serial position

1. `M1-L1-AU-CRICOS-COMPLETENESS` — PASS / COMPLETE
2. `M1-L2-AU-COURSE-FACTS` — IN PROGRESS / FIRST SOURCE ACCEPTED
3. controlled Provider/source expansion — NEXT
4. Search enrichment readiness — BLOCKED / SEPARATE GATE

The accepted Layer 1 identity substrate, PIM hardening decision and vector-search rejection remain unchanged.
