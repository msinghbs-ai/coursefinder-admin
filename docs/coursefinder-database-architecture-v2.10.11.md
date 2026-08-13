# CourseFinder Database Architecture v2.10.11

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.10.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 14 August 2026

v2.10.11 adds Sheridan College as the seventh accepted Ontario institutional Course source while preserving the Canadian dual-authority and lifecycle-aware model.

## Canada identity authorities

Provider identity: `CA + ircc_dli + DLI_number`.

Course identity: `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Titles are mutable. APS/MTCU/CIP and non-unique admissions/programme codes remain validation metadata only.

## Accepted Ontario institutional sources

- Algonquin: `algonquin_program_code`, 88 full-source Courses.
- Conestoga: `conestoga_program_code`, 315 full-source Courses.
- Fanshawe: `fanshawe_program_code`, 80 partial PGWP-aligned Courses.
- Mohawk: `mohawk_program_code`, 108 current-open Courses.
- Durham: `durham_program_id`, 150 full-current API Courses.
- Niagara: `niagara_program_page_id`, 135 lifecycle-aware Courses.
- Sheridan: `sheridan_program_item_id`, 167 lifecycle-aware Courses.

Canonical CA Courses: **1,043**.  
Full/current accepted source Courses: **963**.  
Partial-source Courses: **80**.

## Sheridan source contract

Sheridan's official Sitecore search API returns 167 programme records with 167 distinct internal item IDs. The official `Program active` facet returns 114 active records; the remaining 53 are inactive.

Accepted base identity:
`UUIDv5(O19385946782 + sheridan_program_item_id)`.

Validation:
- API rows: 167;
- distinct programme item IDs: 167;
- missing IDs/titles/URLs: 0;
- active: 114;
- inactive: 53;
- UUID mismatch: 0;
- wrong Provider links: 0;
- lifecycle mismatch: 0;
- title-derived keys: 0.

Worker: `layer1-ca-sheridan-programs-v0.1.0`.

Autonomous Edge replay returned HTTP 200, 0 created / 167 existing, zero conflicts and fresh private JSON evidence.

## Lifecycle-aware Course contract

`svc_layer1_apply_scoped_course_records(...)` continues to support source-normalised `active`, `suspended`, `inactive`, and `unknown` lifecycle values. Sources without lifecycle remain backward-compatible and default to `active`.

## Pilot execution boundary

New workers may use short-lived single-use server-side nonces during Pilot UAT. Browser roles remain unable to execute Course APPLY or nonce-consume RPCs. Pilot-only nonce/JWT bypass infrastructure must be removed during production hardening.

## Migration note

The live Sheridan Provider-scoped source seed exists in Pilot migration history as `20260813230518_ca_on_sheridan_sitecore_program_source`. The GitHub connector blocked serialising that external-URL seed SQL during this session; worker code and governance are source-controlled, and the source seed must be normalised during the next migration-consolidation pass before production promotion.

## Gate state

- CA Gate A Provider Authority — PASS.
- Ontario validation parser — PASS.
- Ontario Provider mapping — PASS 24/24.
- Institutional Course sub-gates — **7 PASS**.
- Canonical CA Courses — **1,043**.
- **CA Gate B remains ACTIVE/BLOCKED on `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.**
