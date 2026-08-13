# CourseFinder Running Build v2.12

**Date:** 13 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.9.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.11.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario validation parser: PASS.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course sub-gates passed: 5.
- Canonical CA Courses: **741**.
- CA Layer 2A StatsCan runtime parser dry-run: PASS.

## Current institutional Course coverage

- Algonquin: 88 full-source Courses.
- Conestoga: 315 full-source Courses.
- Fanshawe: 80 partial PGWP-aligned Courses.
- Mohawk: 108 current-open Courses; 46 closed source rows intentionally excluded.
- Durham: 150 full-current API Courses using unique first-party programme record IDs.

Full/current accepted source Courses: 661.  
Partial-source Courses: 80.

## New runtime outcomes

### Mohawk
Worker: `layer1-ca-mohawk-catalogue-v0.1.0`.

- 154 programme rows parsed from official server-rendered search;
- 108 current open programme identities;
- 46 closed rows excluded;
- APPLY/idempotency/integrity PASS;
- autonomous Edge replay: HTTP 200, 0 created / 108 existing, fresh evidence.

### Durham
Worker: `layer1-ca-durham-programs-v0.1.0`.

Official source: Durham first-party JSON API `/wp-json/dc/v2/programs`.

- API rows 150;
- unique programme record IDs 150/150;
- OCAS duplicates across distinct programme/pathway records: 4;
- base identity therefore uses `durham_program_id`, not OCAS;
- full APPLY/idempotency/integrity PASS;
- autonomous Edge replay: HTTP 200, 0 created / 150 existing, fresh evidence.

## Blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Identity is no longer the design blocker; coverage across remaining Ontario and broader Canadian institutions is the blocker.

## Immediate execution

1. Continue machine-readable Ontario public-college adapters.
2. Prefer first-party JSON/API or server-rendered programme-code listings.
3. Keep CDN/browser-protected institutions queued for browser/API-specific adapters rather than brittle scraping.
4. Preserve full-source versus partial-source classification.
5. Prove deterministic Ontario APS/MTCU/CIP joins after sufficient institutional identity coverage exists.
6. Broaden beyond Ontario before final Search Projection and hardening UAT.
