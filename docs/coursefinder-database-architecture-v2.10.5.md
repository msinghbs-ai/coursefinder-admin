# CourseFinder Database Architecture v2.10.5

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.4.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 13 August 2026

v2.10.5 retains the Canada dual-authority identity model and hardens execution semantics for both IRCC Layer 1 and Statistics Canada Layer 2A.

## 1. Canada authority boundaries

Provider identity:
`CA + ircc_dli + DLI_number`

Course identity:
`UUIDv5(verified DLI + namespaced stable local programme key)`

Course titles are mutable metadata only. APS/MTCU/CIP remain validation/classification metadata and cannot become base Course identity.

Provider and Course authority are independently gated. Overall Canada PASS still requires both authority layers plus integrity, Search Projection, security and performance UAT.

## 2. Layer 1 IRCC cursor contract

Worker: `layer1-ca-live-v1.1.1`.

A dry-run is validation only and must not move the production cursor.

Contract:
- `offset` = slice being validated/applied;
- `candidateNextOffset` = end of the parsed slice;
- dry-run `nextOffset` = current `offset`;
- successful APPLY `nextOffset` = `candidateNextOffset`.

This prevents validation from silently skipping unapplied Provider slices.

The Provider-only RPC remains service-role-only and writes zero Courses.

Current full-source state is partial: 500 of 1,130 IRCC Providers are canonical because only offset 500 has been successfully applied. Offsets 0 and 1000 were dry-run only and remain pending APPLY/idempotency.

## 3. Statistics Canada Layer 2A runtime contract

Worker: `statcan-ca-psis-etl-v0.3.1`.

The previous full-cube ZIP synchronous design is retired for parser UAT because it exceeded Edge runtime limits. Parser UAT now uses a bounded WDS contract:
1. authenticated Platform Admin invocation;
2. POST cube metadata request for PID `37100278`;
3. private metadata evidence + SHA-256;
4. required dimension validation;
5. extraction of source-side institution members;
6. fixed-length WDS coordinate generation;
7. bounded POST series probes using `getDataFromCubePidCoordAndLatestNPeriods`;
8. runtime PASS only when metadata passes and at least one real vector/data point returns successfully.

The accepted v0.3.1 run returned 5/5 successful bounded institution series probes and 248 institution candidates.

## 4. Layer 2A identity isolation

PSIS is not an identity authority.

Required mapping:
`StatsCan institution member -> pipeline.source_provider_mappings -> existing canonical IRCC-DLI Provider`

PSIS labels may assist mapping review but may never create or merge a Provider. Layer 2A cannot create Layer 1 Course identity.

Canonical outcomes APPLY remains disabled until:
- source Provider mapping UAT passes;
- CIP/study-level/audience transforms pass;
- bounded outcome/benchmark APPLY is explicitly approved.

## 5. Evidence and security

Both workers retain JWT verification and Platform Admin authorisation. Internal reconciliation remains server/service-role mediated. Browser roles cannot directly execute CA identity write RPCs.

StatsCan metadata evidence is private and hashed. IRCC evidence remains private and hashed per execution.

Existing Pilot-wide authenticated UI SECURITY DEFINER warnings and leaked-password protection remain broader Phase 7 hardening items and are not represented as closed by this architecture revision.

## 6. Gate state

- CA identity architecture — PASS.
- CA Gate A Federal Provider authority — PARTIAL; full-source APPLY/idempotency pending offsets 0 and 1000.
- CA Gate B Federated Course authority — BLOCKED on source coverage.
- CA Layer 2A StatsCan authenticated runtime parser dry-run — PASS.
- CA country production gate — ACTIVE/BLOCKED.

Current country blocker:
`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.