# CourseFinder Running Build v2.9

**Date:** 13 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.6.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.8.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred/blocked.
- CA dual-authority identity architecture: PASS.
- **CA Gate A Federal Provider Authority: PASS.**
- CA Gate B Federated Course Authority: BLOCKED on Course-source coverage.
- CA Layer 2A StatsCan authenticated runtime parser dry-run: PASS.

## CA Provider Authority — production UAT PASS

Accepted worker: `layer1-ca-live-v1.1.1`.

Final canonical state:
- CA Providers: 1,130;
- IRCC DLI identifiers: 1,130;
- Providers without DLI: 0;
- Providers with multiple DLI identifiers: 0;
- duplicate DLI identifiers: 0;
- duplicate Provider stable keys: 0;
- orphan DLI identifiers: 0;
- CA Courses: 0.

Fresh final execution:
- offset 0 APPLY: 500 created / 0 existing;
- offset 0 repeat: 0 created / 500 existing;
- offset 1000 APPLY: 130 created / 0 existing;
- offset 1000 repeat: 0 created / 130 existing.

The previously accepted offset 500 slice contributes the other 500 Providers and already passed same-offset idempotency.

All five fresh validation/APPLY/idempotency executions captured private evidence with content hashes and storage paths. Source health is successful with no current error.

Source metadata now records:
- `provider_gate=federal_provider_authority_pass`;
- `provider_gate_status=pass`;
- `provider_gate_provider_count=1130`;
- `provider_gate_dli_identifier_count=1130`;
- `provider_gate_idempotency_pass=true`;
- `provider_gate_identity_integrity_pass=true`;
- `course_gate_blocked=true`.

Provider UAT: `docs/uat/coursefinder-layer1-ca-provider-authority-uat-v1.0.md`.

## Provider cursor contract

Worker `layer1-ca-live-v1.1.1` remains deployed as Supabase function version 3 with `verify_jwt=true`.

Dry-run validation returns the current production offset and exposes the candidate next offset separately. Only successful APPLY advances the production cursor. This cursor defect is closed.

## StatsCan Layer 2A

Worker `statcan-ca-psis-etl-v0.3.1` remains accepted for authenticated parser/runtime dry-run UAT.

Runtime PASS:
- metadata contract PASS;
- required PSIS dimensions PASS;
- 248 institution candidates;
- private evidence captured;
- five bounded WDS institution series probes;
- 5/5 returned real vectors/data points with success response code 0;
- canonical identity writes disabled;
- outcome APPLY disabled.

Next Layer 2A gate is source-institution mapping to existing verified IRCC-DLI Providers, followed by CIP/study-level/audience transforms and bounded outcomes UAT.

## Immediate execution

1. Implement Ontario public-college Course live acquisition/parser.
2. Build exact source Provider → IRCC DLI mapping.
3. Run bounded Ontario dry-run/APPLY/idempotency/integrity UAT.
4. Broaden remaining Canadian Course-source coverage.
5. In parallel, begin StatsCan source-provider mapping UAT against the now-complete canonical DLI Provider set.
6. Complete Canada Search Projection, security and performance UAT only after Course coverage is sufficient.

## Decision

**CA Gate A Federal Provider Authority is PASS at 1,130/1,130 with clean idempotency and identity integrity. Overall CA remains ACTIVE/BLOCKED on `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.**
