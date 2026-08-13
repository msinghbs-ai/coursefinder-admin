# CourseFinder Running Build v2.13

**Date:** 14 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.10.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.12.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario validation parser: PASS.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course sub-gates passed: **6**.
- Canonical CA Courses: **876**.
- CA Layer 2A StatsCan runtime parser dry-run: PASS.

## Institutional Course coverage

- Algonquin: 88 full-source.
- Conestoga: 315 full-source.
- Fanshawe: 80 partial PGWP-aligned.
- Mohawk: 108 current-open.
- Durham: 150 full-current API.
- Niagara: 135 lifecycle-aware.

Full/current accepted source Courses: **796**.  
Partial-source Courses: **80**.

## Niagara runtime outcome

Worker: `layer1-ca-niagara-catalogue-v0.2.1`.

Identity discovery rejected `niagara_program_code` after code `0122` was found on three distinct Broadcasting streams. The temporary unpublished UAT rows for that rejected scheme were removed.

Accepted identity is `niagara_program_page_id`; first-party page IDs are unique 135/135. Published Niagara programme codes are secondary registration metadata only.

Lifecycle-aware full source:
- active 114;
- suspended 16;
- inactive 5;
- unknown 0.

Corrected APPLY: 135 created / 0 conflicts.  
Idempotency: 0 created / 135 existing.  
UUID/Provider/title integrity: PASS.  
Autonomous Edge replay: HTTP 200, 0 created / 135 existing, fresh private evidence.

## Pilot execution improvement

New worker UAT can use short-lived one-time database nonces rather than browser JWT handoff or a reusable outbound Pilot secret. Niagara proves this path end-to-end.

## Blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Identity and lifecycle architecture are proven; remaining work is primarily institutional/provincial Course-source coverage and deterministic validation joins.

## Immediate execution

1. Continue official machine-readable Ontario college adapters.
2. Keep base identity separate from non-unique admissions/programme codes.
3. Preserve lifecycle where the first-party source exposes suspended/closed state.
4. Keep full/current versus partial coverage explicit.
5. Prove APS/MTCU/CIP joins only after deterministic matches exist.
6. Broaden outside Ontario before final Search Projection/security/performance gates.
