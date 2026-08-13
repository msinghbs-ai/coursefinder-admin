# CourseFinder Master Project Plan v1.13

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.12.md`  
**Last consolidated:** 14 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.11.md`  
**Running build:** `docs/coursefinder-running-build-v2.14.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario validation authority: PASS.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course sub-gates passed: **7**.
- Canonical CA Courses: **1,043**.
- StatsCan Layer 2A authenticated runtime parser dry-run: PASS.

## CA Gate B — Federated Course Authority

Accepted Course identity remains:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Accepted institutional sources now cover:
- Algonquin — 88 full-source Courses;
- Conestoga — 315 full-source Courses;
- Fanshawe — 80 partial PGWP-aligned Courses;
- Mohawk — 108 current-open Courses;
- Durham — 150 full-current API Courses;
- Niagara — 135 lifecycle-aware Courses;
- Sheridan — 167 lifecycle-aware Courses.

Full/current accepted source Courses: **963**.  
Partial-source Courses: **80**.

Sheridan proves a second institutional internal-record identity pattern: its first-party Sitecore API exposes 167 stable item IDs and an authoritative active-program facet. This allows Course identity and lifecycle to remain independent from title/admissions coding.

## Remaining blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.

The identity/lifecycle architecture is sufficiently proven. Remaining work is dominated by institutional and provincial Course-source coverage plus deterministic validation joins.

## Immediate CA execution

1. Continue first-party adapters across the remaining mapped Ontario public colleges.
2. Prefer official APIs and machine-readable/server-rendered institutional catalogues.
3. Uniqueness-test every candidate local identifier before APPLY.
4. Preserve authoritative lifecycle state where available.
5. Keep non-unique admissions/regulatory codes as validation metadata.
6. Run full APPLY, same-source runtime replay, UUID/Provider/title/lifecycle integrity and private evidence UAT per accepted source.
7. Establish deterministic Ontario APS/MTCU/CIP joins.
8. Broaden Course authority beyond Ontario before final Canada Search/security/performance gates.

## Programme sequence

1. CA Gate A Provider Authority — PASS.
2. CA Gate B Ontario institutional Course expansion — ACTIVE.
3. Broaden Canadian Course identity coverage outside Ontario.
4. Complete Canada reconciliation/Search/security/performance gates.
5. Promote CA only when the country production gate passes.
6. Activate GB, then US and IE. DE remains deferred.

## Decision

**Canada remains ACTIVE/BLOCKED solely because Course-source coverage is incomplete. Seven independent Ontario institutional sources now pass and produce 1,043 canonical Courses. Continue scaling the accepted dual-authority + lifecycle-aware model.**
