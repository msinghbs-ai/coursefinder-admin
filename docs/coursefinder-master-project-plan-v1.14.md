# CourseFinder Master Project Plan v1.14

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.13.md`  
**Last consolidated:** 14 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.14.md`  
**Running build:** `docs/coursefinder-running-build-v2.16.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario validation authority: PASS.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course identity sub-gates passed: **11**.
- Canonical CA Courses: **1,606**.
- StatsCan Layer 2A authenticated runtime parser dry-run: PASS.

## CA Gate B — Federated Course Authority

Accepted Course identity remains:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Current accepted coverage accounting:
- full/current accepted source Courses: **1,334**;
- partial-source Courses: **80**;
- identity-full / lifecycle-currentness pending: **192**.

Accepted institutional sources now include Algonquin, Conestoga, Fanshawe (partial), Mohawk, Durham, Niagara, Sheridan, Seneca, Cambrian, Fleming and Georgian.

Fleming adds the first accepted transport-specific adapter: its first-party catalogue is valid and stable, but oversized response headers require a service-role-only PostgreSQL `pg_net` acquisition bridge before normal Edge parsing/reconciliation.

Georgian adds a current 2026–27 academic-catalogue source with 209 unique programme codes and proves again that titles are non-identifying because multiple distinct codes share the same title.

## Remaining blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.

The dual-authority identity architecture is proven across multiple independent institutional systems. Remaining CA Layer 1 work is now dominated by source coverage breadth, lifecycle-currentness completion, deterministic Ontario validation joins, and then national expansion beyond Ontario.

## Immediate CA execution

1. Continue remaining machine-readable Ontario institutional adapters.
2. Keep browser/CDN/challenge-blocked institutions queued for source-specific acquisition patterns rather than brittle bypasses.
3. Complete lifecycle-currentness for identity-full sources such as Seneca.
4. Establish deterministic Ontario APS/MTCU/CIP validation joins.
5. Broaden authoritative Course identity coverage beyond Ontario.
6. Run Canada-wide reconciliation, Search Projection, security and performance gates.
7. Promote CA only when country production criteria pass.
8. Continue sequence GB → US → IE; DE remains deferred.

## Decision

**Canada remains ACTIVE/BLOCKED solely because Course-source coverage is incomplete. Eleven Ontario institutional identity sub-gates now PASS and produce 1,606 canonical Courses. Continue scaling the accepted model; do not promote Canada yet.**