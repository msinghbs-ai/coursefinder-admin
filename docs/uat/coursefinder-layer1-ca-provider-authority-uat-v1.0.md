# Coursefinder Layer 1 Canada Provider Authority UAT v1.0

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.4.md`  
**Running build:** `docs/coursefinder-running-build-v2.7.md`

## Scope

Validate the separated Canadian federal Provider authority gate before any federated Course-source APPLY.

Provider source:
- IRCC Designated Learning Institutions register.

Provider business identity:
- `CA + ircc_dli + DLI_number`.

Worker:
- `layer1-ca-live-v1.1.0`;
- Supabase function version `2`;
- `verify_jwt=true`;
- Platform Admin required.

Write RPC:
- `svc_layer1_apply_ca_ircc_providers(...)`.

## Implementation UAT

| Test | Result |
|---|---|
| Live IRCC acquisition worker deployed | PASS |
| Stable DLI parsing/deduplication implemented | PASS |
| Private evidence + SHA-256 implemented | PASS |
| Deterministic offset/batch contract | PASS |
| Provider-only reconciliation RPC deployed | PASS |
| RPC rejects malformed/non-DLI identifiers | PASS — contract |
| Course writes from Provider RPC | PASS — structurally zero |
| anon RPC execute | PASS — denied |
| authenticated RPC execute | PASS — denied |
| service_role RPC execute | PASS — allowed |
| CA Provider canonical rows before APPLY | 0 |
| CA Course canonical rows before APPLY | 0 |
| Post-DDL security advisor | PASS for new CA boundary; existing Pilot-wide warnings retained |
| Post-DDL performance advisor | PASS for new CA boundary; unused-index INFO only |

## Gate semantics

The Provider gate is independent from the Course gate.

A successful Provider batch returns the still-open blocker:

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`

This blocker prevents final Canada country PASS but does not prevent authoritative IRCC Provider reconciliation.

## Runtime tests still required

1. signed-in Platform Admin dry-run on `layer1-ca-live-v1.1.0`;
2. bounded Provider APPLY;
3. same-offset APPLY rerun;
4. verify zero duplicate Provider/DLI identities;
5. verify Provider identifier/registration/evidence integrity;
6. continue bounded batches to complete the IRCC source;
7. verify final Provider source count and no Course writes.

## Current result

**IMPLEMENTATION PASS / RUNTIME APPLY PENDING.**

The previous blanket Canada APPLY blocker has been removed. The next CA Layer 1 action is a bounded IRCC Provider APPLY; Course ingestion remains separately prohibited until its own source/local-key UAT passes.
