# CourseFinder Layer 1 Canada — Ontario First-Party Course Identity UAT v1.6

**Date:** 14 August 2026  
**Scope:** CA Gate B — Ontario first-party Course identity expansion  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.16.md`

## Result

Ontario Provider mapping remains **PASS 24/24**.

Institutional Course identity sub-gates now **13 PASS**, producing **1,751 canonical CA Courses**.

## Lambton source and identity

Official first-party source: Lambton College current Full-Time Programs catalogue.

Observed complete source:
- programme cards: 71;
- distinct programme codes: 71;
- matching programme routes: 71;
- missing titles: 0;
- missing start-term metadata: 1.

Accepted identity:
`UUIDv5(IRCC DLI O19305293332 + lambton_program_code)`.

Titles/delivery/start terms remain mutable metadata.

## APPLY / integrity

Bounded APPLY:
- 50 records;
- 50 created;
- 0 conflicts.

Full APPLY:
- 71 records;
- 21 created / 50 existing;
- 0 conflicts;
- Provider writes: 0.

Integrity:
- identifiers: 71/71;
- wrong Provider: 0;
- stable-key mismatch: 0.

## Autonomous runtime / idempotency PASS

Worker: `layer1-ca-lambton-programs-v0.1.0`.

Runtime replay:
- HTTP 200;
- parsed: 71;
- created: 0;
- existing: 71;
- conflicts: 0;
- lifecycle: 70 active / 1 unknown;
- private evidence captured;
- SHA-256: `c82c07868ec775e8d0feeaf40159f749faa3b66e3bf13f3813bb4a39180327f4`.

Business Fundamentals (`BSFF`) is the sole unknown lifecycle record because the current catalogue contains no start-term value. No inactive/suspended state is inferred.

## Gate state

**Lambton institutional sub-gate: PASS.**  
Overall Canada Gate B remains **ACTIVE/BLOCKED** because national Course-source coverage is incomplete. `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.