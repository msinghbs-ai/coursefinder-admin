# CourseFinder Layer 1 Canada — Ontario First-Party Course Identity UAT v1.7

**Date:** 14 August 2026  
**Scope:** CA Gate B — Ontario first-party Course identity expansion  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.17.md`

## Result

Ontario Provider mapping remains **PASS 24/24**.

Institutional Course identity sub-gates now **14 PASS**, producing **1,883 canonical CA Courses**.

## St. Clair source and identity

Official first-party current programme catalogue reports 132 Fall 2026 programme rows.

Validation:
- programme rows: 132;
- distinct programme codes: 132;
- missing titles: 0;
- availability: 62 open / 44 closed / 26 waitlisted.

Accepted identity:
`UUIDv5(IRCC DLI O19395083703 + stclair_program_code)`.

## Lifecycle / availability separation

The source explicitly states the open/closed/waitlisted statuses are Fall 2026 programme availability. They are not used as Course lifecycle.

All 132 current catalogue programmes retain lifecycle `active`; Fall 2026 availability is preserved separately in evidence/source metadata.

## APPLY / integrity

Bounded APPLY:
- 50 created;
- 0 conflicts.

Full APPLY:
- 132 records;
- 82 created / 50 existing;
- 0 conflicts;
- Provider writes: 0.

Integrity:
- identifiers: 132/132;
- wrong Provider: 0;
- stable-key mismatch: 0.

## Autonomous runtime / idempotency PASS

Worker: `layer1-ca-stclair-programs-v0.1.0`.

Runtime replay:
- HTTP 200;
- parsed 132;
- created 0;
- existing 132;
- conflicts 0;
- Course lifecycle 132 active;
- availability 62 open / 44 closed / 26 waitlisted;
- private evidence SHA-256 `59750e1d8f001f05ec3eb8d46789e9e8374d9c21ef8af67c556276e3706824ca`.

## Gate state

**St. Clair institutional sub-gate: PASS.**  
Overall Canada Gate B remains **ACTIVE/BLOCKED** because national Course-source coverage is incomplete. `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.