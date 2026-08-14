# CourseFinder Running Build v2.16

**Date:** 14 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.14.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.14.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional identity sub-gates passed: **11**.
- Canonical CA Courses: **1,606**.
- StatsCan Layer 2A authenticated runtime parser dry-run: PASS.

## Coverage accounting

- Full/current accepted source Courses: **1,334**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.

## New accepted sources

### Fleming College
- identity: `fleming_program_guid` under DLI `O19303189722`;
- 77 Courses;
- lifecycle 76 active / 1 unknown;
- full runtime replay: 0 created / 77 existing / 0 conflicts;
- worker `layer1-ca-fleming-programs-v0.1.2`;
- acquisition uses service-role-only `pg_net` transport because Fleming response headers exceed Deno direct-fetch limits.

### Georgian College
- current source: official 2026–27 Academic Catalogue;
- identity: `georgian_program_code` under DLI `O19395677361`;
- 209 unique programme codes;
- full runtime replay: 0 created / 209 existing / 0 conflicts;
- lifecycle 209 active;
- evidence SHA-256 `fe221ddaa4138990e4e84eed4bc21bb1ef9e02f3248305a080c7959584d4d591`;
- worker `layer1-ca-georgian-catalogue-v0.1.0`.

## Pilot source control

Deployed workers are committed to Pilot:
- Fleming: `efb9a565ffed4b4762ad399e7f60cddf64627b2b`;
- Georgian: `60697f9cf69e58f64b655fcf8f20fa16b27bf6bc`.

## Blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue the remaining Ontario institutional adapters and then broaden authoritative Course coverage beyond Ontario before the final Canada Search/security/performance gate.