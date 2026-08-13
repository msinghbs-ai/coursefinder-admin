# CourseFinder Master Project Plan v1.9

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.8.md`  
**Last consolidated:** 13 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.7.md`  
**Running build:** `docs/coursefinder-running-build-v2.10.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A — Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- CA Gate B — Ontario live ministry acquisition/parser: PASS.
- Ontario ministry workbook cannot by itself provide accepted base Course identity because it contains no stable institutional/local programme key.
- CA Gate B canonical Course APPLY remains BLOCKED by `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.
- CA StatsCan Layer 2A runtime parser dry-run: PASS.

## CA Gate B — Ontario parser result

Live source: Ontario Data Catalogue public-college postsecondary field-of-study table.

Current runtime evidence:
- current XLSX discovered automatically;
- 4,522 programme rows;
- 24 Ontario public-college source codes;
- APS Code coverage 4,522 / 4,522;
- stable institutional/local programme-code coverage 0 / 4,522;
- private XLSX evidence and SHA-256 captured.

The workbook supplies APS, MTCU, CIP, credential and title metadata. Under the accepted architecture these are validation/classification/descriptive attributes, not base Course identity.

Accepted Course identity remains:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Therefore the Ontario ministry source is retained as a validation authority and must be joined to first-party institutional catalogue identity.

## Pilot autonomous UAT

A temporary Pilot automation secret boundary is now available for newly wired UAT workers so routine parser/runtime tests do not require repeated browser JWT handoff.

Controls:
- plaintext key in Supabase Vault only;
- SHA-256 validator record in an internal RLS-protected table;
- service-role-only validation RPC;
- normal Platform Admin session remains supported;
- selected workers may disable the Edge platform JWT pre-check only while enforcing in-handler authorisation;
- temporary Pilot key expires 30 September 2026;
- remove/disable this path before production hardening.

## Immediate CA Gate B execution

1. Verify the 24 Ontario source-college codes to existing canonical IRCC-DLI Providers.
2. Identify first-party Ontario college catalogue sources exposing stable programme codes/keys.
3. Build first-party programme acquisition adapters.
4. Join those stable programme identities to Ontario APS/MTCU/CIP validation metadata.
5. Run bounded Course dry-run.
6. Enable only an approved Course APPLY slice after identity UAT passes.
7. Prove same-slice idempotency, evidence and integrity.
8. Broaden Canadian provincial/institutional Course-source coverage.
9. Complete national reconciliation, Search Projection, security and performance UAT.

## Parallel work

StatsCan Layer 2A source-provider mapping continues against the completed IRCC Provider target set. Layer 2A remains unable to create or merge Provider identity.

## Programme sequence

1. CA Gate A Provider Authority — PASS.
2. CA Gate B — verified Ontario Provider mappings + first-party programme identities.
3. Broaden Canadian Course identity coverage beyond Ontario.
4. Complete Canada final integrity/Search/security/performance gates.
5. Promote CA only after all country gates pass.
6. Activate GB, then US and IE. DE remains deferred.

## Decision

**Ontario live acquisition/parser is PASS but confirms the ministry workbook is validation/classification data rather than sufficient base Course identity. CA Gate B remains BLOCKED until verified DLI mappings and stable first-party institutional programme keys are integrated. Pilot UAT can now be executed autonomously through the temporary Vault-backed automation secret without repeated browser JWT handoff.**
