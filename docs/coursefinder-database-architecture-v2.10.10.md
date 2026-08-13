# CourseFinder Database Architecture v2.10.10

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.9.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 14 August 2026

v2.10.10 extends the Canadian dual-authority Course model with lifecycle-aware institutional reconciliation and a sixth accepted Ontario institutional source.

## Canada identity authorities

Provider identity remains:
`CA + ircc_dli + DLI_number`.

Course identity remains:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Titles are mutable. APS/MTCU/CIP and any non-unique admissions/programme codes are validation metadata only.

## Gate A — Federal Provider Authority — PASS

1,130 canonical CA Providers / 1,130 DLI identifiers remain accepted.

## Ontario Provider mapping — PASS

24/24 Ontario ministry college codes map to verified IRCC-DLI Providers.

## Lifecycle-aware Course contract

`svc_layer1_apply_scoped_course_records(...)` now supports source-normalised lifecycle values:
- active;
- suspended;
- inactive;
- unknown.

Existing adapters are backward-compatible and default to active when lifecycle is omitted.

Waitlisted represents intake availability, not Course retirement, so any Open/Waitlisted intake keeps a programme active. Suspended/Closed are used only when no active intake exists.

## Accepted institutional Course sources

- Algonquin: `algonquin_program_code`, 88 Courses, full-source PASS.
- Conestoga: `conestoga_program_code`, 315 Courses, full-source PASS.
- Fanshawe: `fanshawe_program_code`, 80 Courses, partial PGWP source PASS.
- Mohawk: `mohawk_program_code`, 108 current-open Courses, PASS.
- Durham: `durham_program_id`, 150 full-current API Courses, PASS.
- Niagara: `niagara_program_page_id`, 135 lifecycle-aware Courses, PASS.

Canonical CA Courses: **876**.
Full/current accepted source Courses: **796**.
Partial-source Courses: **80**.

## Niagara identity decision

Niagara's published programme code is not a valid base identity. Code `0122` is reused across three distinct Broadcasting streams.

The official programme page IDs are unique 135/135 and therefore form the base identity:
`UUIDv5(O19396019469 + niagara_program_page_id)`.

`niagara_published_program_code` is stored as non-identifying registration metadata and may repeat across Courses.

Niagara lifecycle accepted at:
- active 114;
- suspended 16;
- inactive 5;
- unknown 0.

## Pilot execution boundary

For new Pilot workers, browser-JWT handoff is no longer required. Niagara proves a one-time nonce pattern:
- nonce generated server-side;
- two-minute expiry;
- single consumption;
- service-role-only consume RPC;
- no reusable secret transmitted through the connector.

This remains Pilot-only and must be removed during production hardening.

## Security

Course reconciliation ACL remains anon=false / authenticated=false / service_role=true. The nonce consume RPC has the same execution boundary. The nonce table is RLS-enabled and browser-inaccessible.

Existing project-level authenticated UI SECURITY DEFINER warnings and leaked-password protection remain Phase 7 items.

## Gate state

- CA Gate A Provider Authority — PASS.
- Ontario validation parser — PASS.
- Ontario Provider mapping — PASS 24/24.
- Institutional Course sub-gates — **6 PASS**.
- Canonical CA Courses — **876**.
- **CA Gate B remains ACTIVE/BLOCKED on `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.**

Next priority remains scaling official first-party institutional Course sources across the remaining Ontario Providers, followed by deterministic APS/MTCU/CIP validation joins and broader Canadian coverage before final Search/security/performance gates.
