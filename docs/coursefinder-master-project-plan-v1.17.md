# CourseFinder Master Project Plan v1.17

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.16.md`  
**Last consolidated:** 14 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.17.md`  
**Running build:** `docs/coursefinder-running-build-v2.19.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course identity sub-gates passed: **14**.
- Canonical CA Courses: **1,883**.
- Full/current accepted source Courses: **1,611**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.

## St. Clair milestone

St. Clair College current programme catalogue exposes 132 Fall 2026 programme rows with 132 unique institutional programme codes. The page separately publishes intake availability: 62 open / 44 closed / 26 waitlisted.

Accepted identity: `stclair_program_code` under verified DLI `O19395083703`.

Course lifecycle remains active for all 132 current catalogue entries. Fall 2026 open/closed/waitlisted values are admissions availability and must not be conflated with Course lifecycle.

Autonomous runtime replay passed with 0 created / 132 existing / 0 conflicts and fresh private evidence.

## Remaining blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue remaining Ontario institutional adapters, lifecycle-currentness, Ontario APS/MTCU/CIP joins, and national Course expansion before final Canada Search/security/performance gates.