# CourseFinder Layer 1 Canada Provider Authority UAT v1.0

**Date:** 13 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.6.md`  
**Running build:** `docs/coursefinder-running-build-v2.9.md`  
**Gate:** CA Gate A — Federal Provider Authority

## Result

**PASS**

The authoritative IRCC Designated Learning Institutions source has been fully reconciled to the canonical Provider catalogue using stable identity:

`CA + ircc_dli + DLI_number`.

## Accepted runtime

Worker:
- `layer1-ca-live-v1.1.1`;
- Supabase function version 3;
- `verify_jwt=true`;
- Platform Admin required.

Fresh bounded execution:
- offset 0 APPLY: 500 created / 0 existing;
- offset 0 idempotency rerun: 0 created / 500 existing;
- offset 1000 APPLY: 130 created / 0 existing;
- offset 1000 idempotency rerun: 0 created / 130 existing;
- previously accepted offset 500 slice: 500 canonical Providers with same-offset idempotency PASS.

No fresh execution returned an error.

## Full-source reconciliation

| Check | Result |
|---|---:|
| Authoritative IRCC parsed Providers | 1,130 |
| Canonical CA Providers | 1,130 |
| IRCC DLI identifiers | 1,130 |
| Providers without DLI | 0 |
| Providers with multiple DLI identifiers | 0 |
| Duplicate DLI identifiers | 0 |
| Duplicate Provider stable keys | 0 |
| Orphan DLI identifiers | 0 |
| CA Courses written by Provider gate | 0 |

## Evidence and source health

All five fresh validation/APPLY/idempotency executions captured private evidence with non-null content hashes and storage paths.

At acceptance:
- source status: active;
- source health: success;
- worker version: `layer1-ca-live-v1.1.1`;
- parsed Providers: 1,130;
- last error: null;
- Provider APPLY allowed: true;
- Course gate blocked: true;
- source metadata Provider gate: `federal_provider_authority_pass`.

Evidence is execution-scoped. Multiple evidence artifacts do not constitute a canonical idempotency defect.

## Security boundary

The Provider-only reconciliation path remains server/service-role mediated and writes zero Courses. JWT verification and Platform Admin authorisation remain enabled. Broader pre-existing Pilot security warnings are not represented as closed by this UAT.

## Country gate boundary

This PASS promotes **CA Gate A — Federal Provider Authority only**.

Canada Layer 1 remains blocked on:
`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.

Course identity remains:
`UUIDv5(verified DLI + namespaced stable local programme key)`.

Course titles are not identity. Layer 2A sources cannot create Provider identities.

## Next gate

Proceed with **CA Gate B — Federated Course Authority**, beginning with Ontario public-college programme live acquisition/parser, verified source Provider → IRCC DLI mapping, bounded dry-run/APPLY/idempotency/integrity UAT, then remaining Canadian Course-source coverage.
