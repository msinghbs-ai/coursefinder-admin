# CourseFinder Layer 1 Canada — Ontario First-Party Course Identity UAT v1.4

**Date:** 14 August 2026  
**Scope:** CA Gate B — Ontario first-party Course identity expansion  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.14.md`

## Aggregate result

- Ontario Provider mapping: **PASS 24/24**.
- Institutional identity sub-gates passed: **11**.
- Canonical CA Courses: **1,606**.
- Full/current accepted source Courses: **1,334**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.
- Overall CA Gate B: **ACTIVE/BLOCKED — country Course-source coverage incomplete**.

## Fleming College — PASS

Source: official Fleming programme A–Z catalogue.

Accepted identity:
`UUIDv5(IRCC DLI O19303189722 + fleming_program_guid)`.

Validation:
- programme cards: 77;
- distinct first-party GUID/path values: 77;
- secondary programme-code tokens: 88 / 88 distinct;
- one joint programme has no displayed programme code;
- lifecycle: 76 active / 1 unknown.

Database APPLY:
- bounded 50: 50 created / 0 conflicts;
- full 77: 27 created / 50 existing / 0 conflicts.

Integrity:
- UUID mismatch: 0;
- wrong Provider links: 0;
- lifecycle mismatch: 0;
- stable-key derivation from first-party GUID: 77/77.

Runtime:
- worker `layer1-ca-fleming-programs-v0.1.2`;
- direct Deno fetch was unsuitable because Fleming response headers exceed Deno's message-head limit;
- accepted acquisition transport is service-role-only `pg_net` through SECURITY INVOKER RPCs;
- runtime job completed with 77 parsed, 0 created / 77 existing, 0 conflicts;
- lifecycle 76 active / 1 unknown;
- private evidence captured.

## Georgian College — PASS

Source: official Georgian College Academic Catalogue, 2026–27 edition.

Accepted identity:
`UUIDv5(IRCC DLI O19395677361 + georgian_program_code)`.

Validation:
- catalogue entries: 209;
- distinct programme codes: 209;
- duplicate programme codes: 0;
- distinct titles: 201;
- eight titles map to multiple distinct programme codes, proving title is non-identifying.

Database APPLY:
- bounded 50: 50 created / 0 conflicts;
- full 209: 159 created / 50 existing / 0 conflicts.

Integrity:
- UUID mismatch: 0;
- wrong Provider links: 0;
- lifecycle mismatch: 0.

Autonomous runtime replay:
- worker `layer1-ca-georgian-catalogue-v0.1.0`;
- HTTP 200;
- parsed: 209;
- created: 0;
- existing: 209;
- conflicts: 0;
- lifecycle: 209 active;
- evidence SHA-256: `fe221ddaa4138990e4e84eed4bc21bb1ef9e02f3248305a080c7959584d4d591`;
- private evidence artifact captured.

## Current accepted institutional composition

- Algonquin — 88;
- Conestoga — 315;
- Fanshawe — 80 partial;
- Mohawk — 108;
- Durham — 150;
- Niagara — 135;
- Sheridan — 167;
- Seneca — 192 identity-full / lifecycle-currentness pending;
- Cambrian — 85;
- Fleming — 77;
- Georgian — 209.

## Gate state

**Eleven Ontario institutional Course identity sources now PASS, but `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue remaining Ontario coverage and then broaden beyond Ontario before Canada production promotion.**