# CourseFinder Database Architecture v2.10.12

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.11.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 14 August 2026

v2.10.12 adds Seneca Polytechnic as the eighth accepted Ontario institutional identity source and formalises a new coverage class: identity-full with lifecycle-currentness pending.

## Canada identity authorities

Provider identity: `CA + ircc_dli + DLI_number`.

Course identity: `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Titles are mutable. APS/MTCU/CIP and non-unique admissions/programme codes remain validation metadata only.

## Accepted Ontario institutional sources

- Algonquin: 88 full-source Courses.
- Conestoga: 315 full-source Courses.
- Fanshawe: 80 partial PGWP-aligned Courses.
- Mohawk: 108 current-open Courses.
- Durham: 150 full-current API Courses.
- Niagara: 135 lifecycle-aware Courses.
- Sheridan: 167 lifecycle-aware Courses.
- Seneca: 192 identity-full Courses; lifecycle-currentness pending.

Canonical CA Courses: **1,235**.

Coverage accounting:
- full/current accepted source Courses: **963**;
- partial-source Courses: **80**;
- identity-full / lifecycle-currentness pending: **192**.

## Seneca identity decision

Official academic catalogue: Seneca Polytechnic catalogue A–Z.

Observed:
- programme rows: 192;
- distinct published programme codes: 192;
- distinct catalogue slugs: 192;
- missing programme codes: 0;
- duplicate programme codes: 0.

Accepted base identity:
`UUIDv5(O19395536013 + seneca_program_code)`.

The official catalogue currently identifies itself as the 2025–2026 edition. Because the current admissions cycle has already moved into 2026/27, catalogue membership is accepted for identity but is not sufficient to assert current lifecycle. All 192 Seneca Courses therefore reconcile to `unknown` lifecycle pending a current academic catalogue or deterministic institutional lifecycle source.

Worker: `layer1-ca-seneca-catalogue-v0.1.0`.

Autonomous Edge replay:
- HTTP 200;
- parsed 192;
- created 0 / existing 192;
- conflicts 0;
- lifecycle unknown 192;
- private HTML evidence captured.

## Gate state

- CA Gate A Provider Authority — PASS.
- Ontario Provider mapping — PASS 24/24.
- Institutional identity sub-gates — **8 PASS**.
- Canonical CA Courses — **1,235**.
- **CA Gate B remains ACTIVE/BLOCKED on `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.**

Do not inflate full/current coverage with identity-only or lifecycle-stale sources. Continue remaining Ontario sources, currentness resolution and deterministic APS/MTCU/CIP joins before broader Canada promotion.
