# CourseFinder Master Project Plan v1.7

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.6.md`  
**Last consolidated:** 13 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.5.md`  
**Running build:** `docs/coursefinder-running-build-v2.8.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE; GB/US/IE queued; DE deferred.
- CA dual-authority identity architecture: PASS.
- CA Federal Provider authority: PARTIAL. Live IRCC source has 1,130 Providers; 500 are currently canonical.
- Offset 500 has passed APPLY and same-offset idempotency. Offsets 0 and 1000 were dry-run only and remain pending APPLY/idempotency.
- `layer1-ca-live-v1.1.1` fixes the cursor contract so dry-run validation cannot advance the production cursor.
- CA federated Course authority remains blocked by `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.
- CA StatsCan Layer 2A authenticated runtime parser dry-run: PASS.

## CA Gate A — Federal Provider authority

Identity: `CA + ircc_dli + DLI_number`.

Remaining gate work:
1. APPLY offset 0 / batch 500 and rerun same offset for idempotency.
2. APPLY offset 1000 / remaining 130 and rerun same offset for idempotency.
3. Verify 1,130 Providers / 1,130 DLI identifiers with zero duplicates or orphans.
4. Promote Gate A only when full-source reconciliation is clean.

Provider APPLY writes zero Courses.

## CA Gate B — Federated Course authority

Course identity: `UUIDv5(verified DLI + namespaced stable local programme key)`.

Course titles are mutable and never identity. APS/MTCU/CIP are validation/classification metadata only. Every Course must resolve to an existing verified IRCC-DLI Provider.

Initial high-value integration remains Ontario public-college programme data, followed by broader provincial/institutional coverage.

## CA Layer 2A — Postsecondary outcomes

StatsCan PSIS table `37-10-0278-01`, PID `37100278`.

Accepted worker: `statcan-ca-psis-etl-v0.3.1`.

Authenticated runtime parser dry-run PASS evidence:
- metadata and required dimensions PASS;
- 248 source institution candidates;
- private evidence captured;
- five bounded WDS series probes;
- 5/5 returned real vectors/data points with success response code 0;
- canonical identity writes disabled;
- outcomes APPLY disabled.

Next Layer 2A gate is source institution mapping to existing IRCC-DLI Providers, then CIP/study-level/audience transforms and bounded outcomes UAT.

## Programme sequence

1. Complete CA Provider Gate A.
2. Start StatsCan source-provider mapping UAT in parallel.
3. Implement Ontario Course source and broaden Canadian Course coverage.
4. Complete CA integrity, Search Projection, security and performance UAT.
5. Promote CA only after all country gates pass.
6. Activate GB, then US and IE. DE remains deferred.

## Decision

**Architecture v2.10.5 and Running Build v2.8 are authoritative. StatsCan runtime parser UAT is PASS. CA Provider Gate A remains PARTIAL until offsets 0 and 1000 are applied and idempotency-tested. Overall CA remains ACTIVE until federated Course coverage and final production UAT pass.**