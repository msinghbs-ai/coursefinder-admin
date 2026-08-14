# CourseFinder Database Architecture v2.10.17

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.16.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 14 August 2026

## Canada Layer 1 position

Provider identity remains `CA + ircc_dli + DLI_number`.

Course identity remains `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

## Institutional Course authority

Fourteen Ontario institutional identity sub-gates now PASS, producing **1,883 canonical CA Courses**.

Coverage accounting:
- full/current: **1,611**;
- partial-source: **80**;
- identity-full / lifecycle-currentness pending: **192**.

## St. Clair identity / availability decision

Official first-party source: `https://www.stclaircollege.ca/programs`.

The current page explicitly states programme statuses are for Fall 2026 and renders 132 programme rows. Each row publishes an institutional programme code and an availability state.

Validation:
- programme rows: 132;
- distinct programme codes: 132;
- distinct programme paths: 116;
- missing titles: 0;
- Fall 2026 availability: 62 open / 44 closed / 26 waitlisted.

Accepted base identity: `stclair_program_code` under verified DLI `O19395083703`.

Because open/closed/waitlisted are intake-admissions states, not Course lifecycle states, all 132 current catalogue programmes retain Course lifecycle `active`. Availability remains separate evidence/source metadata.

## UAT

Bounded APPLY: 50 created / 0 conflicts.  
Full APPLY: 82 created / 50 existing / 0 conflicts.  
Identity integrity: 132/132 identifiers, wrong Provider 0, stable-key mismatch 0.  
Autonomous Edge replay: HTTP 200, 0 created / 132 existing / 0 conflicts, availability 62/44/26, fresh private evidence.

Worker: `layer1-ca-stclair-programs-v0.1.0`.

## Gate state

CA remains ACTIVE/BLOCKED on `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.