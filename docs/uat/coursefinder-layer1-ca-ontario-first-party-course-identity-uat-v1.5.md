# CourseFinder Layer 1 Canada — Ontario First-Party Course Identity UAT v1.5

**Date:** 14 August 2026  
**Scope:** CA Gate B — Ontario first-party Course identity expansion  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.15.md`

## Result

Ontario Provider mapping remains **PASS 24/24**.

Institutional Course identity sub-gates now **12 PASS**, producing **1,680 canonical CA Courses**.

Accepted sources: Algonquin, Conestoga, Fanshawe partial, Mohawk, Durham, Niagara, Sheridan, Seneca, Cambrian, Fleming, Georgian and Loyalist.

## Loyalist identity / acquisition

Official programme-list UI exposes a supported WordPress AJAX flow. The page supplies a short-lived WordPress nonce and JavaScript calls `admin-ajax.php?action=filter_programs` with pagination.

Complete source result:
- records: 74;
- distinct numeric programme IDs: 74;
- distinct programme permalinks: 74;
- missing titles: 0.

Accepted Course identity:
`UUIDv5(IRCC DLI O19359011572 + loyalist_program_id)`.

## APPLY / integrity

Bounded APPLY:
- 50 created;
- 0 conflicts.

Full APPLY:
- 74 records;
- 24 created / 50 existing;
- 0 conflicts;
- Provider writes: 0.

Integrity:
- distinct IDs: 74/74;
- UUID mismatch: 0;
- wrong Provider: 0.

## Autonomous runtime / idempotency

Worker: `layer1-ca-loyalist-programs-v0.1.0`.

Runtime replay:
- HTTP 200;
- parsed: 74;
- created: 0;
- existing: 74;
- conflicts: 0;
- fresh private evidence captured.

Accepted lifecycle after runtime reconciliation:
- active: 65;
- unknown: 9;
- inactive: 0;
- suspended: 0.

The nine unknown records are exactly four `No Upcoming Intakes` and five generic `Other` records without an explicit positive intake. This runtime rule supersedes the earlier management-plane precheck that overclassified some `Other`/mixed cards as active.

## Gate state

**Loyalist institutional sub-gate: PASS.**  
Overall Canada Gate B remains **ACTIVE/BLOCKED** because national Course-source coverage is incomplete. `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.