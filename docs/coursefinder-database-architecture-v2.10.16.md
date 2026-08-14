# CourseFinder Database Architecture v2.10.16

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.15.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 14 August 2026

## Canada Layer 1 position

Provider identity remains `CA + ircc_dli + DLI_number`.

Course identity remains `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

## Institutional Course authority

Thirteen Ontario institutional identity sub-gates now PASS, producing **1,751 canonical CA Courses**.

Coverage accounting:
- full/current: **1,479**;
- partial-source: **80**;
- identity-full / lifecycle-currentness pending: **192**.

## Lambton identity decision

Official first-party source: `https://www.lambtoncollege.ca/programs`.

The current Full-Time Programs page embeds on each programme card:
- `data-code`;
- `data-title`;
- `data-startdate`;
- `data-delivery`;
- credential/category metadata.

Complete source validation:
- structured programme cards: 71;
- unique programme codes: 71;
- matching programme routes: 71;
- missing titles: 0;
- missing start-term values: 1.

Individual programme pages confirm the route/code contract; for example `/programs/in-person/actg` publishes `Business Accounting - ACTG`.

Accepted identity scheme: `lambton_program_code` under verified DLI `O19305293332`.

## Lifecycle / UAT

Lifecycle rule:
- non-empty current catalogue start-term metadata -> `active`;
- missing start-term -> `unknown`;
- no inactive/suspended state inferred without explicit evidence.

Accepted lifecycle: **70 active / 1 unknown**.

Bounded APPLY: 50 created / 0 conflicts.  
Full APPLY: 21 created / 50 existing / 0 conflicts.  
Integrity: 71/71 identifiers, wrong Provider 0, stable-key mismatch 0.  
Autonomous Edge replay: HTTP 200, 0 created / 71 existing / 0 conflicts, fresh private evidence.

Worker: `layer1-ca-lambton-programs-v0.1.0`.

## Gate state

CA remains ACTIVE/BLOCKED on `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.