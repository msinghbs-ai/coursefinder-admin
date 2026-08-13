# CourseFinder Master Project Plan v1.8

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.7.md`  
**Last consolidated:** 13 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.6.md`  
**Running build:** `docs/coursefinder-running-build-v2.9.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA dual-authority identity architecture: PASS.
- **CA Gate A — Federal Provider Authority: PASS.**
- IRCC full-source reconciliation: 1,130 canonical Providers / 1,130 DLI identifiers.
- Provider idempotency and identity integrity: PASS.
- CA Gate B — Federated Course Authority: BLOCKED by `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.
- CA StatsCan Layer 2A authenticated runtime parser dry-run: PASS.

## CA Gate A — Federal Provider Authority — PASS

Identity:
`CA + ircc_dli + DLI_number`.

Accepted production UAT:
- offset 0 APPLY: 500 created;
- offset 0 rerun: 0 created / 500 existing;
- offset 500 previously accepted: 500 canonical and idempotent;
- offset 1000 APPLY: 130 created;
- offset 1000 rerun: 0 created / 130 existing;
- final canonical Providers: 1,130;
- final DLI identifiers: 1,130;
- duplicate DLI identifiers: 0;
- duplicate Provider stable keys: 0;
- Providers without DLI: 0;
- Providers with multiple DLI identifiers: 0;
- orphan DLI identifiers: 0;
- CA Courses written by Provider gate: 0.

Worker `layer1-ca-live-v1.1.1` remains the accepted Provider acquisition path. Dry-run validation cannot advance the production cursor; only successful APPLY advances it.

Provider UAT authority: `docs/uat/coursefinder-layer1-ca-provider-authority-uat-v1.0.md`.

## CA Gate B — Federated Course Authority

Course identity:
`UUIDv5(verified DLI + namespaced stable local programme key)`.

Course titles are mutable metadata and never identity. APS/MTCU/CIP are validation/classification metadata only. Every Course must resolve to an existing verified IRCC-DLI Provider.

Execution priority:
1. Ontario public-college programme live acquisition/parser.
2. Source Provider → canonical IRCC DLI mapping.
3. Bounded dry-run.
4. Approved APPLY slice and same-slice idempotency.
5. Course identity/evidence/integrity UAT.
6. Broaden remaining provincial/institutional Course-source coverage.
7. Complete national reconciliation, Search Projection, security and performance UAT.

## CA Layer 2A — Postsecondary Outcomes

StatsCan PSIS table `37-10-0278-01`, PID `37100278`.

Accepted worker: `statcan-ca-psis-etl-v0.3.1`.

Authenticated runtime parser dry-run: PASS.

Next Layer 2A gate runs in parallel:
`StatsCan source institution -> pipeline.source_provider_mappings -> existing verified IRCC-DLI Provider`, followed by CIP/study-level/audience transforms and bounded outcome/benchmark UAT.

Layer 2A cannot create or merge Provider identity.

## Programme sequence

1. **CA Gate A Provider Authority — complete/PASS.**
2. Execute CA Gate B federated Course authority, beginning with Ontario.
3. Run StatsCan source-provider mapping UAT in parallel.
4. Complete CA country-wide Course coverage and final integrity/Search/security/performance gates.
5. Promote CA country Layer 1 only after all country gates pass.
6. Activate GB, then US and IE. DE remains deferred.

## Decision

**CA Federal Provider Authority is formally PASS at 1,130/1,130 with idempotency and identity integrity clean. Overall Canada Layer 1 remains ACTIVE/BLOCKED because federated Course-source coverage is not yet complete. Architecture v2.10.6 and Running Build v2.9 are authoritative.**
