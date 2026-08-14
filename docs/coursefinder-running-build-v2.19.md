# CourseFinder Running Build v2.19

**Date:** 14 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.17.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.17.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional identity sub-gates passed: **14**.
- Canonical CA Courses: **1,883**.
- Full/current accepted source Courses: **1,611**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.

## St. Clair runtime outcome

Current programme page publishes 132 Fall 2026 programme rows with 132 unique institutional programme codes.

Identity: `stclair_program_code` under DLI `O19395083703`.

Bounded APPLY: 50 created / 0 conflicts.  
Full APPLY: 82 created / 50 existing / 0 conflicts.  
Integrity: 132/132 identifiers, wrong Provider 0, stable-key mismatch 0.

Autonomous worker `layer1-ca-stclair-programs-v0.1.0`:
- HTTP 200;
- parsed 132;
- created 0 / existing 132;
- conflicts 0;
- Course lifecycle 132 active;
- Fall 2026 availability 62 open / 44 closed / 26 waitlisted;
- private evidence SHA-256 `59750e1d8f001f05ec3eb8d46789e9e8374d9c21ef8af67c556276e3706824ca`.

## Design rule reinforced

Admissions availability is not Course lifecycle. Closed or waitlisted intake status must not retire a current catalogue Course.

## Blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.