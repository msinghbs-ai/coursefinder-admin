# CourseFinder Running Build v2.20

**Date:** 16 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.18.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.18.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional identity sub-gates passed: **18**.
- Canonical CA Courses: **2,273**.
- Full/current accepted source Courses: **2,001**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.

## Newly accepted runtime gates

| Institution | Courses | Identity | Lifecycle | Replay |
|---|---:|---|---|---|
| Collège Boréal | 63 | `boreal_program_slug` | 58 active / 5 unknown | 0 created / 63 existing / 0 conflicts |
| Sault College | 76 | `sault_program_code` | 53 active / 23 unknown | 0 / 76 / 0 |
| Confederation College | 59 | `confederation_program_id` | 59 active | 0 / 59 / 0 |
| Centennial College | 192 | `centennial_program_code` | 192 active | 0 / 192 / 0 |

Centennial source validation is 195/195 unique source programme codes; 3 non-standard preparation/recognition records are intentionally outside this Layer 1 credential scope.

## Source-control state

Pilot workers are committed for Boréal, Sault, Confederation and Centennial.

## Northern College

Dedicated Post-Secondary Programs feed: 53 first-party programme pages. Strict Edge dry-run: 35 valid code identities, 36 pages with alternate code markup, therefore no APPLY. A proposed broadened parser was blocked by the deployment connector and was not promoted. Northern remains parser-normalisation pending.

## Blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.