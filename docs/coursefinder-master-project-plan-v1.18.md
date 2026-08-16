# CourseFinder Master Project Plan v1.18

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.17.md`  
**Last consolidated:** 16 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.18.md`  
**Running build:** `docs/coursefinder-running-build-v2.20.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course identity sub-gates passed: **18**.
- Canonical CA Courses: **2,273**.
- Full/current accepted source Courses: **2,001**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.

## Consolidated Ontario milestone since v1.17

Four additional institutional sources have passed full autonomous runtime and idempotency gates:

- Collège Boréal: 63 Courses, identity `boreal_program_slug`, lifecycle 58 active / 5 unknown.
- Sault College: 76 Courses, identity `sault_program_code`, lifecycle 53 active / 23 unknown.
- Confederation College: 59 full-time degree/diploma/certificate Courses, identity `confederation_program_id`, lifecycle 59 active.
- Centennial College: 192 current credential Courses from 195 unique catalogue codes; 2 College Preparation and 1 Recognition of Achievement rows intentionally excluded. Identity `centennial_program_code`; lifecycle 192 active.

All four sources passed autonomous replay with zero newly-created Courses on the replay and zero reconciliation conflicts.

## Northern College

Northern's dedicated first-party Post-Secondary Programs feed is reachable and resolves to 53 programme pages. A strict dry-run proved 35 valid programme-code identities but 36 pages use alternate code markup. No Northern Course APPLY has been performed. Northern remains a parser-normalisation blocker until every accepted code is extracted only from explicit institutional code surfaces.

## Remaining blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue unresolved Ontario institutional adapters and lifecycle-currentness, then Ontario APS/MTCU/CIP joins, national Course expansion, Search Projection, security and performance gates before Canada can PASS.