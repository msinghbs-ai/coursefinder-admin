# CourseFinder Master Project Plan v1.10

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.9.md`  
**Last consolidated:** 13 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.8.md`  
**Running build:** `docs/coursefinder-running-build-v2.11.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario validation authority: PASS on the 4,522-row ministry workbook.
- Ontario Provider mapping: PASS 24/24 to canonical IRCC-DLI Providers.
- Ontario first-party Course identity currently proves 483 canonical Courses across three Providers.
- StatsCan Layer 2A authenticated runtime parser dry-run: PASS and remains unable to create Provider identity.

## CA Gate B — Federated Course Authority

Accepted Course identity remains:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Titles are mutable and never identity. APS/MTCU/CIP remain regional validation/classification metadata only.

Accepted institutional sub-gates:
- Algonquin College: full-source PASS, 88 Courses;
- Conestoga College: full-source PASS, 315 Courses;
- Fanshawe College: partial-source PASS, 80 PGWP-aligned Courses only.

Current canonical CA Course count: **483**.

Full-source institutional coverage: 403 Courses across two Providers.  
Partial-source institutional coverage: 80 Courses across one Provider.

The country blocker remains `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` because institutional/provincial coverage is not yet sufficient for Canada production acceptance.

## Pilot autonomous UAT

Temporary Pilot ingestion/UAT can execute through the Vault-backed, service-only allowlisted Edge queue without repeated browser JWT handoff.

Controls retained:
- secret stored in Supabase Vault;
- hash-backed validator;
- browser roles cannot use the queue;
- nominated workers enforce Platform Admin or Pilot-secret authentication in-function;
- 30-second bounded internal HTTP timeout;
- remove/disable this Pilot path during production hardening.

## Immediate CA execution

1. Continue remaining Ontario public-college first-party adapters, prioritising official listings with stable programme codes.
2. Distinguish full-source versus partial-source coverage in source metadata and governance.
3. Avoid title/APS-derived identities and avoid brittle scraping where CDN/browser protection blocks automation.
4. For each accepted institutional source run bounded/full APPLY, idempotency, UUID/Provider/title integrity and evidence UAT.
5. Deterministically attach Ontario APS/MTCU/CIP validation metadata where joins can be proven.
6. After Ontario coverage is sufficient, broaden Course identity coverage across remaining Canadian provinces/territories and approved first-party catalogues.
7. Complete Canada Search Projection, security and performance UAT only after country-wide Course coverage reaches the accepted threshold.

## Programme sequence

1. CA Gate A Provider Authority — PASS.
2. CA Gate B Ontario first-party Course expansion — ACTIVE.
3. Broaden Canadian Course identity coverage outside Ontario.
4. Complete Canada integrity/Search/security/performance gates.
5. Promote CA only when the full country gate passes.
6. Activate GB, then US and IE. DE remains deferred.

## Decision

**The Canadian dual-authority architecture is production-proven at Provider identity and across multiple independent institutional Course sources. CA remains ACTIVE/BLOCKED solely because Course-source coverage is incomplete; the programme now scales the proven adapter pattern rather than revisiting the identity model.**
