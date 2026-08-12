# Coursefinder Running Build v2.5

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.2.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.4.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE / blocked on federated Course-source coverage; GB/US/IE queued; DE deferred/blocked.
- Phase 3A: AU QILT/ComparED and CA Postsecondary Outcomes are parallel structured-outcome streams.
- CA Layer 2A foundation PASS; StatsCan parser implementation PASS; authenticated runtime parser UAT pending.
- Phase 7 hardening continues.

## CA Layer 2A source model

Configured sources remain:
1. Statistics Canada PSIS / PID `37100278` / table `37-10-0278-01` — national structured backbone.
2. Ontario Postsecondary Graduate Outcomes — provincial Provider outcomes.
3. BC Student Outcomes — provincial Provider outcomes/source-discovery family.

All Layer 2A CA sources have canonical identity writes disabled. Provider-specific observations require verified source Provider -> canonical Provider mappings.

## StatsCan worker v0.2.0

Worker: `statcan-ca-psis-etl`  
Version: `statcan-ca-psis-etl-v0.2.0`  
Supabase function version: `2`  
Deployment SHA-256: `544b7d99bf86914d3f66ff7c88197ca9c871694682fde64b76f9730b57413464`  
JWT verification: enabled.

Pilot commits:
- `3ed44da1772828b25f0527c2b26144ae0706999e` — bounded ZIP/CSV parser and mapping diagnostics.
- `cee10a81c8632645cdcf0d573c273f18718e3023` — expose authenticated `runLayer2AStatsCan` client route.

Current worker flow:
1. Platform Admin authentication;
2. resolve configured StatsCan Layer 2A source;
3. WDS cube metadata;
4. WDS full-table CSV ZIP;
5. SHA-256 and private evidence;
6. unzip data CSV;
7. parse bounded sample (`sampleRows`, max 5,000);
8. validate `REF_DATE`, `VALUE`, and institution/geography dimension;
9. emit source institution candidates and field/credential/student-status diagnostics;
10. no canonical writes.

`apply=true` remains hard blocked.

## Mapping contract

Statistics Canada institution rows are external Layer 2A source entities. Institution data in this series are reported at parent level with documented exceptions, so PSIS identity is not assumed to equal IRCC DLI identity.

Source mapping path:

`PSIS source institution member/coordinate -> pipeline.source_provider_mappings -> verified canonical CA Provider (IRCC DLI identity)`

Institution labels are candidate-matching metadata only and cannot create/merge Providers.

## Database/source state

Statistics Canada source metadata now records:
- worker `statcan-ca-psis-etl-v0.2.0`;
- parser gate `implemented_pending_authenticated_runtime_uat`;
- sample-row cap 5,000;
- `apply_enabled=false`;
- verified IRCC DLI mapping required.

Current protected state remains:
- CA Layer 2A Provider outcome rows: 0 before accepted APPLY;
- CA benchmark rows: 0 before accepted APPLY.

## UAT

Current UAT document:
- `docs/uat/coursefinder-layer2a-ca-postsecondary-outcomes-parser-uat-v1.1.md`

Passed:
- source authority/discovery;
- Layer 2A source/database foundation;
- benchmark separation;
- security/service-role boundaries;
- FK-index hardening;
- parser implementation/deployment;
- bounded parser contract;
- authenticated Pilot client route.

Pending:
1. first signed-in Platform Admin dry-run of worker v0.2.0;
2. inspect exact live CSV headers/diagnostics;
3. persist source Provider candidates;
4. verify source Provider -> IRCC DLI mappings;
5. validate CIP/study-level/audience transforms;
6. bounded `provider_outcomes` APPLY;
7. rerun idempotency/integrity;
8. later add StatsCan longitudinal outcome benchmarks.

The management connector cannot perform the signed-in worker call because it does not expose the interactive Platform Admin JWT. No authentication bypass has been introduced.

## Layer 1 unchanged

CA Layer 1 remains the active country gate and is still blocked on federated Course-source coverage. Layer 2A work does not satisfy or bypass the Layer 1 gate.

Immediate Layer 1 slice remains Ontario APS live ingestion + DLI mapping UAT.
