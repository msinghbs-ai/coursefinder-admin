# CourseFinder Running Build v2.14

**Date:** 14 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.11.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.13.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario validation parser: PASS.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course sub-gates passed: **7**.
- Canonical CA Courses: **1,043**.
- CA Layer 2A StatsCan runtime parser dry-run: PASS.

## Institutional Course coverage

- Algonquin: 88 full-source.
- Conestoga: 315 full-source.
- Fanshawe: 80 partial PGWP-aligned.
- Mohawk: 108 current-open.
- Durham: 150 full-current API.
- Niagara: 135 lifecycle-aware.
- Sheridan: 167 lifecycle-aware.

Full/current accepted source Courses: **963**.  
Partial-source Courses: **80**.

## Sheridan outcome

Worker: `layer1-ca-sheridan-programs-v0.1.0`.

Sheridan official Sitecore programme search returns 167 records. The official `Program active` facet returns 114 active records, leaving 53 inactive records.

Identity scheme: `sheridan_program_item_id` under verified DLI `O19385946782`.

Management APPLY:
- 167 created;
- 0 conflicts;
- lifecycle 114 active / 53 inactive.

Integrity:
- UUID mismatch 0;
- duplicate IDs 0;
- wrong Provider 0;
- lifecycle mismatch 0;
- title-derived keys 0.

Autonomous Edge replay:
- HTTP 200;
- 167 parsed;
- 0 created / 167 existing;
- 0 conflicts;
- same lifecycle split;
- fresh private JSON evidence.

## Blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue remaining Ontario institutional coverage, deterministic Ontario validation joins, then broader Canadian coverage before Search/security/performance promotion.
