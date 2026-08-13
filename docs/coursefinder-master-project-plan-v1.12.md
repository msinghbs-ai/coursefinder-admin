# CourseFinder Master Project Plan v1.12

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.11.md`  
**Last consolidated:** 14 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.10.md`  
**Running build:** `docs/coursefinder-running-build-v2.13.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario validation authority: PASS.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course sub-gates passed: **6**.
- Canonical CA Courses: **876**.
- StatsCan Layer 2A authenticated runtime parser dry-run: PASS.

## CA Gate B — Federated Course Authority

Accepted Course identity remains:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Accepted institutional sources:
- Algonquin — 88 full-source Courses;
- Conestoga — 315 full-source Courses;
- Fanshawe — 80 partial PGWP-aligned Courses;
- Mohawk — 108 current-open Courses;
- Durham — 150 full-current API Courses;
- Niagara — 135 lifecycle-aware Courses.

Full/current accepted source Courses: **796**.  
Partial-source Courses: **80**.

## New architecture proof

Niagara proves two additional requirements:

1. Human-facing programme/admissions codes must be uniqueness-tested before promotion to identity. Niagara code `0122` is reused by three distinct Broadcasting streams and was rejected as a base key.
2. Institutional lifecycle can be preserved independently from identity. Niagara's accepted source reconciles 114 active, 16 suspended and 5 inactive Courses without creating new identities when state changes.

Accepted Niagara base key is the unique first-party programme page ID.

## Pilot autonomy

New Pilot runtime UAT can use one-time server-side nonces rather than requiring browser JWT handoffs. Nonces are short-lived, single-use and service-role consumed. This is temporary Pilot infrastructure and is removed in production hardening.

## Remaining blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.

The remaining Canada Layer 1 problem is source coverage, not identity model design. Ontario must be expanded further and then broader Canadian provincial/institutional coverage accepted before final Search/security/performance UAT.

## Immediate CA execution

1. Continue first-party adapters across remaining mapped Ontario public colleges.
2. Prefer official APIs and machine-readable/server-rendered institutional catalogues.
3. Uniqueness-test every candidate local identifier before canonical APPLY.
4. Preserve lifecycle where authoritative source state exists.
5. Keep non-unique admissions/regulatory codes as secondary validation metadata.
6. Continue full APPLY, same-source idempotency, UUID/Provider/title/lifecycle integrity and private evidence UAT per source.
7. Establish deterministic Ontario APS/MTCU/CIP joins.
8. Broaden outside Ontario and complete Canada Search/security/performance gates.

## Programme sequence

1. CA Gate A Provider Authority — PASS.
2. CA Gate B Ontario institutional Course expansion — ACTIVE.
3. Broaden Canadian Course identity coverage outside Ontario.
4. Complete Canada reconciliation/Search/security/performance gates.
5. Promote CA only when the country production gate passes.
6. Activate GB, then US and IE. DE remains deferred.

## Decision

**Canada remains ACTIVE/BLOCKED solely because Course-source coverage is incomplete. Six independent Ontario institutional source patterns now pass and produce 876 canonical Courses. Continue scaling the proven dual-authority + lifecycle-aware model.**
