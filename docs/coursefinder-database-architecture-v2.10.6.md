# CourseFinder Database Architecture v2.10.6

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.5.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 13 August 2026

v2.10.6 promotes the Canadian Federal Provider Authority sub-gate after full IRCC reconciliation while retaining the federated Course-authority boundary.

## 1. Canada identity authorities

Provider identity:
`CA + ircc_dli + DLI_number`

Course identity:
`UUIDv5(verified DLI + namespaced stable local programme key)`

Provider and Course authority are independently gated. Names and titles are mutable metadata and never business identity. APS/MTCU/CIP remain validation/classification metadata rather than base Course identity.

## 2. CA Gate A — Federal Provider Authority — PASS

Authoritative source: IRCC Designated Learning Institutions.

Accepted worker: `layer1-ca-live-v1.1.1`.

Full-source production reconciliation:
- parsed IRCC Providers: 1,130;
- canonical CA Providers: 1,130;
- IRCC DLI identifiers: 1,130;
- Providers without DLI: 0;
- Providers with multiple DLI identifiers: 0;
- duplicate DLI identifiers: 0;
- duplicate Provider stable keys: 0;
- orphan DLI identifiers: 0;
- Course writes: 0.

Bounded APPLY and same-offset idempotency have passed for offsets 0, 500 and 1000. The Provider-only reconciliation path is therefore accepted as the canonical Canadian Provider authority path.

## 3. IRCC execution contract

Dry-run is validation only and cannot move the production cursor.

Contract:
- `offset` = current slice;
- `candidateNextOffset` = end of parsed slice;
- dry-run `nextOffset` = current offset;
- successful APPLY `nextOffset` = candidate next offset.

JWT verification and Platform Admin authorisation remain enabled. Canonical write reconciliation is service-role mediated and writes no Courses.

IRCC evidence remains private, execution-scoped and hashed.

## 4. CA Gate B — Federated Course Authority — BLOCKED

Country-level Layer 1 remains blocked on:
`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.

Every Course must resolve to an existing verified IRCC-DLI Provider before canonical Course creation.

Initial integration priority:
1. Ontario public-college programme source;
2. live acquisition/parser;
3. exact source Provider → IRCC DLI mapping;
4. bounded Course dry-run/APPLY/idempotency/integrity;
5. remaining provincial/institutional source coverage.

No Course title/name matching may be used as base Course identity.

## 5. Statistics Canada Layer 2A isolation

Accepted parser worker: `statcan-ca-psis-etl-v0.3.1`.

Authenticated runtime parser dry-run remains PASS.

Required Provider mapping path:
`StatsCan institution member -> pipeline.source_provider_mappings -> existing canonical IRCC-DLI Provider`.

StatsCan cannot create or merge Provider identity. Canonical outcome APPLY remains disabled until source-provider mapping, CIP/study-level/audience transforms and bounded outcome/benchmark UAT pass.

The completed IRCC Provider gate now supplies the full canonical Provider target set for this mapping work.

## 6. Security and evidence boundary

Internal identity writes remain server/service-role mediated. Browser roles cannot directly perform the CA identity reconciliation path. Evidence is private and hashed.

Broader pre-existing Pilot authenticated UI SECURITY DEFINER warnings and leaked-password protection remain Phase 7 hardening items and are not represented as closed by this revision.

## 7. Gate state

- CA identity architecture — PASS.
- **CA Gate A Federal Provider Authority — PASS.**
- CA Gate B Federated Course Authority — BLOCKED on source coverage.
- CA Layer 2A StatsCan authenticated runtime parser dry-run — PASS.
- CA country production gate — ACTIVE/BLOCKED.

Overall Canada PASS still requires federated Course authority, full integrity, Search Projection, security and performance UAT.
