# CourseFinder Database Architecture v2.10.9

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.8.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 13 August 2026

v2.10.9 extends the Canadian dual-authority model across five Ontario institutional Course sources and proves both published programme-code and internal catalogue-record identity patterns.

## Canada identity authorities

Provider identity: `CA + ircc_dli + DLI_number`.

Course identity: `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Titles are mutable. APS/MTCU/CIP and non-unique admissions codes are validation/classification metadata only.

## Gate A — Federal Provider Authority — PASS

1,130 canonical CA Providers / 1,130 DLI identifiers remain accepted with clean identity and idempotency UAT.

## Ontario Provider mapping — PASS

All 24 ministry college codes map to 24 existing verified IRCC-DLI Providers. The Ontario ministry source cannot create Provider identity.

## Accepted institutional Course sources

- Algonquin: `algonquin_program_code`, 88 Courses, full-source PASS.
- Conestoga: `conestoga_program_code`, 315 Courses, full-source PASS.
- Fanshawe: `fanshawe_program_code`, 80 Courses, partial PGWP source PASS.
- Mohawk: `mohawk_program_code`, 108 current-open Courses, PASS; 46 closed source rows excluded.
- Durham: `durham_program_id`, 150 Courses, full current API PASS.

Canonical CA Courses: **741**.

## Durham identity decision

Durham's official JSON API publishes both an internal programme record `id` and an OCAS admissions code.

Observed:
- API rows: 150;
- unique programme record IDs: 150;
- duplicate record IDs: 0;
- four OCAS codes reused across distinct programme/pathway records.

Therefore `durham_program_id` is the base Course identity scheme. OCAS is explicitly prohibited from base identity and retained only as source metadata/diagnostic until a safe secondary-registration model is approved.

## Provider-scoped runtime

Institutional sources remain Provider-scoped `pipeline.sources` entries and use service-only Provider/source resolution plus `svc_layer1_apply_scoped_course_records(...)`.

Autonomous Pilot UAT uses the temporary Vault-backed allowlisted queue. Current nominated workers include Ontario ministry, Algonquin, Conestoga, Fanshawe, Mohawk and Durham. Pilot-only `verify_jwt=false` workers must enforce the temporary Pilot key in-handler and must be retired during production hardening.

## Current gate state

- CA Gate A Provider Authority — PASS.
- Ontario validation parser — PASS.
- Ontario Provider mapping — PASS 24/24.
- Institutional Course sub-gates — 5 PASS.
- Full/current accepted source Courses — 661.
- Partial-source Courses — 80.
- Total CA Courses — 741.
- **CA Gate B remains ACTIVE/BLOCKED on `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.**

Next architecture priority is to scale machine-readable institutional adapters across the remaining Ontario Providers, then prove deterministic APS/MTCU/CIP joins and broaden coverage beyond Ontario before final Search/security/performance gates.
