# CourseFinder Database Architecture v2.10.8

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.7.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 13 August 2026

v2.10.8 accepts the first production-proven institutional Course identity adapters under the Canadian dual-authority model while retaining the country-wide Course coverage blocker.

## 1. Canada identity authorities

Provider identity:
`CA + ircc_dli + DLI_number`.

Course identity:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Names/titles are mutable and never identity. APS/MTCU/CIP remain validation/classification metadata.

## 2. Gate A — Federal Provider Authority — PASS

IRCC Provider authority remains accepted at:
- 1,130 canonical CA Providers;
- 1,130 DLI identifiers;
- clean full-source identity integrity and idempotency.

Accepted worker: `layer1-ca-live-v1.1.1`.

## 3. Ontario validation authority and Provider mapping

Ontario ministry workbook remains a validation/classification authority, not base Course identity authority:
- 4,522 programme rows;
- APS present 4,522/4,522;
- stable institutional programme key present 0/4,522.

All 24 Ontario ministry college codes are now verified in `pipeline.source_provider_mappings` to 24 existing IRCC-DLI Providers.

The Ontario source cannot create or merge Provider identity.

## 4. Provider-scoped first-party source architecture

First-party institutional catalogues are represented as Provider-scoped `pipeline.sources` records. They are intentionally excluded from the country regulatory-source resolver and use service-only Provider-source resolution.

Service contracts:
- `svc_layer1_resolve_provider_by_identifier(...)`;
- `svc_layer1_resolve_provider_sources(...)`;
- `svc_layer1_apply_scoped_course_records(...)`.

The Course reconciliation RPC remains service-role-only at the database ACL. A redundant request-JWT claim check was removed because PostgREST service-role execution runs through the authenticator session; browser roles remain unable to execute the RPC.

## 5. Accepted institutional Course identity sources

### Algonquin College — full-source PASS
- DLI: `O19358971022`;
- identity scheme: `algonquin_program_code`;
- accepted Courses: 88;
- full-source idempotency: PASS;
- UUID/title/Provider integrity: PASS;
- Edge worker: `layer1-ca-algonquin-catalogue-v0.2.0`.

### Conestoga College — full-source PASS
- DLI: `O19376158572`;
- identity scheme: `conestoga_program_code`;
- 317 raw rows / 315 unique programme codes;
- duplicate source appearances: 2, conflicting duplicates: 0;
- accepted Courses: 315;
- full-source idempotency: PASS;
- UUID/title/Provider integrity: PASS;
- Edge worker: `layer1-ca-conestoga-catalogue-v0.1.0`.

### Fanshawe College — partial-source PASS
- DLI: `O19361039982`;
- identity scheme: `fanshawe_program_code`;
- source coverage: `partial_pgwp_aligned_only`;
- accepted Courses: 80;
- idempotency: PASS;
- UUID/title/Provider integrity: PASS;
- Edge worker: `layer1-ca-fanshawe-pgwp-v0.1.0`.

Fanshawe's source is not a complete Provider catalogue and must remain marked partial.

## 6. Current Canadian Course state

Canonical CA Courses: **483**.

Composition:
- 403 full-source Courses across Algonquin and Conestoga;
- 80 partial-source Courses from Fanshawe PGWP-aligned offerings.

This is a proven Course identity foundation, not sufficient country-wide coverage.

## 7. Pilot execution boundary

Temporary Pilot automation uses:
- secret stored in Supabase Vault;
- hash-backed validation;
- service-only `pipeline.pilot_edge_execution_queue`;
- allowlisted Edge workers;
- bounded 30-second internal HTTP timeout.

Selected workers have `verify_jwt=false` only because the worker body enforces Platform Admin or the temporary Pilot key. The Pilot path must be removed/disabled before production.

## 8. Security/performance status

New CA identity-write paths remain service mediated. Browser roles cannot execute the Course reconciliation RPC or the Pilot queue.

Supabase advisors continue to report pre-existing Pilot items including authenticated UI SECURITY DEFINER warnings, leaked-password protection disabled, deny-by-default RLS/no-policy INFO and unused-index INFO. They remain Phase 7 items.

## 9. Gate state

- CA Gate A Federal Provider Authority — PASS.
- Ontario validation parser — PASS.
- Ontario source Provider mapping — PASS 24/24.
- Algonquin full-source Course identity — PASS.
- Conestoga full-source Course identity — PASS.
- Fanshawe partial-source Course identity — PASS.
- CA canonical Courses — 483.
- **CA Gate B Federated Course Authority — ACTIVE/BLOCKED on `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.**

Next architecture priority is repeatable first-party Course adapters for the remaining mapped Ontario public colleges, followed by broader Canadian provincial/institutional coverage and final Search/security/performance gates.
