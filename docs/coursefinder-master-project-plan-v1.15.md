# CourseFinder Master Project Plan v1.15

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.14.md`  
**Last consolidated:** 14 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.15.md`  
**Running build:** `docs/coursefinder-running-build-v2.17.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course identity sub-gates passed: **12**.
- Canonical CA Courses: **1,680**.
- StatsCan Layer 2A runtime parser dry-run: PASS.

## CA Gate B coverage

Accepted Course identity remains `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Coverage accounting:
- full/current accepted source Courses: **1,408**;
- partial-source Courses: **80**;
- identity-full / lifecycle-currentness pending: **192**.

Accepted institutional sources: Algonquin, Conestoga, Fanshawe (partial), Mohawk, Durham, Niagara, Sheridan, Seneca, Cambrian, Fleming, Georgian and Loyalist.

Loyalist adds a supported first-party WordPress AJAX acquisition pattern. The catalogue exposes 74 unique numeric programme record IDs across four pages. Runtime lifecycle is conservatively resolved to 65 active and 9 unknown; no inactive/suspended state is inferred without explicit evidence.

## Remaining blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue remaining Ontario institutional coverage, lifecycle-currentness completion, Ontario APS/MTCU/CIP validation joins and national expansion beyond Ontario before Canada Search/security/performance promotion.

## Immediate execution

1. Continue remaining machine-readable Ontario institutional adapters.
2. Keep CDN/client-challenge institutions queued for source-specific acquisition rather than brittle bypasses.
3. Complete Seneca lifecycle-currentness.
4. Establish deterministic Ontario APS/MTCU/CIP joins.
5. Broaden Course authority outside Ontario.
6. Run Canada-wide reconciliation, Search Projection, security and performance gates.
7. Promote CA only when the country production gate passes.
8. Continue GB → US → IE; DE remains deferred.

## Decision

**Canada remains ACTIVE/BLOCKED solely because Course-source coverage is incomplete. Twelve Ontario institutional identity sub-gates now PASS and produce 1,680 canonical Courses.**