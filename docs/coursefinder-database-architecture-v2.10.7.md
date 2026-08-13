# CourseFinder Database Architecture v2.10.7

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.6.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 13 August 2026

v2.10.7 retains the completed Canadian Federal Provider Authority and records the Ontario Gate B parser finding that provincial APS/MTCU/CIP data cannot replace a stable first-party programme identity key.

## 1. Canada identity authorities

Provider identity:
`CA + ircc_dli + DLI_number`

Course identity:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`

Names/titles are mutable metadata and never business identity. APS, MTCU and CIP are validation/classification metadata only.

## 2. CA Gate A — Federal Provider Authority — PASS

IRCC authority remains accepted at 1,130 canonical Providers / 1,130 DLI identifiers with clean duplicate/orphan/idempotency UAT and zero Course writes.

Accepted worker: `layer1-ca-live-v1.1.1`.

## 3. CA Gate B — Ontario ministry parser boundary

Worker: `layer1-ca-on-college-programs-v0.1.0`.

Live Ontario Data Catalogue XLSX acquisition/parser UAT: PASS.

Observed current workbook:
- rows: 4,522;
- Ontario college source codes: 24;
- APS Code coverage: 100%;
- stable institutional/local programme code coverage: 0%;
- principal dimensions: College, MTCU Code/Title, APS Code/Title, Credential Type, CIP Code/Title, STEM/BHASE.

Architectural classification:
- APS = regional registration / programme validation metadata;
- MTCU = ministry/funding classification metadata;
- CIP = field-of-study classification metadata;
- APS/MTCU titles = mutable descriptive metadata.

The Ontario ministry workbook is therefore a validation/classification authority but is insufficient by itself to create base canonical Course identity.

## 4. Required Ontario Course identity path

Required reconciliation sequence:

`Ontario source college code`
`-> verified pipeline.source_provider_mappings`
`-> existing canonical IRCC-DLI Provider`
`-> first-party institutional stable programme code/key`
`-> canonical Course identity`
`-> Ontario APS/MTCU/CIP validation metadata`

Canonical Course APPLY must remain disabled until both the Provider mapping and first-party programme-key path pass bounded UAT.

## 5. Pilot automation authentication boundary

For Pilot-only autonomous runtime UAT, selected ingestion workers may set Edge platform `verify_jwt=false` only when the function itself enforces one of:
1. signed-in Platform Admin validation; or
2. temporary server-side Pilot automation secret validation.

Implementation:
- plaintext secret stored only in Supabase Vault;
- SHA-256 hash stored in `pipeline.pilot_automation_keys`;
- service-role-only `svc_pilot_automation_authorize(text)` validates the secret;
- direct browser roles cannot read the key table or execute the validator;
- Pilot key expires 30 September 2026;
- the Pilot path must be disabled/removed during production hardening.

This pattern does not make the worker public merely because the platform JWT pre-check is disabled; unauthorised requests are rejected in the handler.

## 6. Evidence

Ontario XLSX evidence is stored privately and hashed. XLSX MIME support has been added to the private evidence bucket.

Accepted Ontario parser evidence hash:
`13754b3cfbf0ff6300855d9b0dcae2d1910063278db359297345009b0e95d295`.

## 7. Gate state

- CA identity architecture — PASS.
- CA Gate A Federal Provider Authority — PASS.
- Ontario live acquisition/parser — PASS.
- Ontario source Provider mapping — PENDING VERIFICATION.
- Ontario first-party stable programme identity coverage — BLOCKED/PENDING.
- CA Gate B Federated Course Authority — BLOCKED.
- CA Layer 2A StatsCan runtime parser dry-run — PASS.
- CA country production gate — ACTIVE/BLOCKED.

Current country blocker remains `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`, now refined to require verified DLI mappings plus stable first-party programme-key coverage.
