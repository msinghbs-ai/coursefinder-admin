# CourseFinder Running Build v2.17

**Date:** 14 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.15.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.15.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional identity sub-gates passed: **12**.
- Canonical CA Courses: **1,680**.
- Full/current accepted source Courses: **1,408**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.

## Loyalist runtime outcome

Official programme-list page exposes a supported WordPress AJAX flow. Four AJAX pages return exactly 74 programmes with unique numeric record IDs and unique permalinks.

Identity: `loyalist_program_id` under DLI `O19359011572`.

Bounded APPLY: 50 created / 0 conflicts.  
Full APPLY: 24 created / 50 existing / 0 conflicts.  
Autonomous worker `layer1-ca-loyalist-programs-v0.1.0`: HTTP 200, 0 created / 74 existing / 0 conflicts, fresh private evidence.

Runtime lifecycle correction is authoritative: **65 active / 9 unknown**. The nine unknowns are four `No Upcoming Intakes` and five generic `Other` records. No inactive/suspended state is inferred.

## Fleming transport closure

Fleming `layer1-ca-fleming-programs-v0.1.2` now passes through the service-role-only `pg_net` acquisition bridge: 77 parsed, 0 created / 77 existing, 0 conflicts, 76 active / 1 unknown.

## Blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue institutional coverage, lifecycle-currentness and Ontario validation joins before national expansion and final Canada gates.