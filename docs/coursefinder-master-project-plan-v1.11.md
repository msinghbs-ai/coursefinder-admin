# CourseFinder Master Project Plan v1.11

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.10.md`  
**Last consolidated:** 13 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.9.md`  
**Running build:** `docs/coursefinder-running-build-v2.12.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario validation authority: PASS.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course sub-gates passed: 5.
- Canonical CA Courses: **741**.
- StatsCan Layer 2A authenticated runtime parser dry-run: PASS.

## CA Gate B — Federated Course Authority

Accepted identity remains:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Accepted institutional sources now cover:
- Algonquin College — 88 full-source Courses;
- Conestoga College — 315 full-source Courses;
- Fanshawe College — 80 partial PGWP-aligned Courses;
- Mohawk College — 108 current-open Courses;
- Durham College — 150 full-current API Courses.

Full/current accepted source Courses: **661**.  
Partial-source Courses: **80**.

Durham proves the institutional internal-ID pattern: its first-party API exposes 150 unique programme record IDs while four OCAS codes are duplicated across distinct programme/pathway records. OCAS is therefore prohibited from base identity.

## Remaining blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.

The identity architecture is sufficiently proven. Remaining work is dominated by source coverage and deterministic validation joins, not further identity redesign.

## Immediate CA execution

1. Scale first-party adapters across the remaining mapped Ontario public colleges.
2. Prefer machine-readable official APIs and server-rendered programme-code listings.
3. Use browser/API-specific acquisition patterns for CDN-protected sites; do not introduce brittle scraping merely to increase counts.
4. Keep full/current and partial coverage explicitly separated.
5. Run APPLY, same-source idempotency, UUID/Provider/title integrity and private evidence UAT for every accepted source.
6. Join accepted Course identities to Ontario APS/MTCU/CIP validation metadata only where deterministic joins are proven.
7. Establish the Ontario coverage threshold, then broaden Course authority across other Canadian provinces/territories and approved first-party institutional catalogues.
8. Complete Canada Search Projection, security and performance UAT after country-wide Course coverage is accepted.

## Programme sequence

1. CA Gate A Provider Authority — PASS.
2. CA Gate B Ontario institutional Course expansion — ACTIVE.
3. Broaden Canadian Course identity coverage outside Ontario.
4. Complete Canada reconciliation/Search/security/performance gates.
5. Promote CA only when the country production gate passes.
6. Activate GB, then US and IE. DE remains deferred.

## Decision

**Canada remains ACTIVE/BLOCKED solely because Course-source coverage is incomplete. Five independent Ontario institutional source patterns now pass, producing 741 canonical Courses under the accepted dual-authority identity model. Continue scaling the proven pattern rather than revisiting identity design.**
