# CourseFinder Master Project Plan v1.16

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.15.md`  
**Last consolidated:** 14 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.16.md`  
**Running build:** `docs/coursefinder-running-build-v2.18.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course identity sub-gates passed: **13**.
- Canonical CA Courses: **1,751**.
- Full/current accepted source Courses: **1,479**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.

## Lambton milestone

Lambton College current Full-Time Programs catalogue is server-readable and embeds programme metadata directly on each card. The complete source exposes 71 structured programme cards with 71 unique institutional programme codes and matching programme routes.

Accepted identity: `lambton_program_code` under verified DLI `O19305293332`.

Lifecycle: 70 active / 1 unknown. Business Fundamentals (`BSFF`) is retained as unknown because the current source carries no start-term value; no inactive state is inferred.

Autonomous runtime replay passed with 0 created / 71 existing / 0 conflicts and fresh private evidence.

## Remaining blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue remaining Ontario institutional adapters, lifecycle-currentness, Ontario APS/MTCU/CIP joins, then broaden authoritative Course coverage outside Ontario before final Canada Search/security/performance gates.

## Programme sequence

1. Continue CA Gate B institutional coverage.
2. Complete deterministic Ontario validation joins.
3. Broaden Canadian Course identity coverage outside Ontario.
4. Complete Canada reconciliation/Search/security/performance gates.
5. Promote CA only when country production gate passes.
6. Continue GB → US → IE. DE remains deferred.