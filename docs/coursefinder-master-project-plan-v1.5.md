# Coursefinder Master Project Plan v1.5

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.4.md`  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Last consolidated:** 12 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.3.md`  
**Running build baseline:** `docs/coursefinder-running-build-v2.6.md`  
**Accepted Layer 1 gates:** AU PASS; NZ PASS

## Current programme position

- CA Layer 1 remains active and blocked on federated Course-source coverage, not on identity architecture.
- GB, US and IE remain queued.
- DE remains deferred/blocked.
- Phase 3A continues in parallel for AU QILT/ComparED and CA Postsecondary Outcomes.

## Phase 1 — Canada dual-authority production pattern

Provider authority:
- IRCC is the only accepted Canadian Provider identity authority.
- Provider business identity = `CA + ircc_dli + DLI_number`.
- Local names/acronyms/provincial systems/StatsCan labels cannot create Provider identity.

Course authority:
- no single Canada-wide Course registry is assumed;
- Course business identity = `UUIDv5(verified DLI + namespaced stable local programme key)`;
- titles are mutable metadata only;
- provincial/classification identifiers such as APS, MTCU and CIP are validation/classification metadata and cannot be the base Course key.

Database enforcement is live through `svc_layer1_apply_scoped_course_records(...)` and migration 050.

### Immediate CA Layer 1 sequence

1. Establish the canonical IRCC DLI Provider set through the live IRCC worker.
2. For each accepted Course source, approve a stable local programme-key namespace.
3. Ontario public-college data: use stable source/local programme key for Course identity; store APS in `course_registrations`; map CIP as classification.
4. Perform bounded dry-run/APPLY/idempotency/integrity.
5. Expand Course-source coverage across additional provinces/institutions.
6. Run Search Projection/security/performance UAT.
7. Mark CA PASS only when country coverage and integrity gates pass.

## Phase 3A — CA Postsecondary Outcomes

Statistics Canada PSIS remains the national structured backbone.

The first authenticated worker invocation successfully reached the protected `statcan-ca-psis-etl` route but failed on an implementation defect in the WDS metadata call. The defect was not an authority/source blocker.

Root cause:
- v0.2.0 used `GET getCubeMetadata/{PID}`.

Correction:
- v0.2.1 uses Statistics Canada's documented `POST getCubeMetadata` with a productId body;
- full-table CSV remains the documented GET call;
- JWT, Platform Admin authorisation and APPLY blocking are unchanged.

Current Layer 2A gate:
1. PASS — source/foundation/security.
2. PASS — parser implementation.
3. PASS — authenticated route reached worker/job creation.
4. FAIL/CORRECTED — WDS metadata method defect in v0.2.0.
5. PENDING — authenticated v0.2.1 parser rerun.
6. PENDING — source Provider -> IRCC DLI mapping verification.
7. PENDING — CIP/study-level/audience transforms.
8. BLOCKED UNTIL ABOVE PASS — canonical outcome APPLY/idempotency/integrity.

## Security and governance

- Layer 2A cannot create Provider/Course identity.
- Canada Layer 1 reconciliation RPC remains service-role-only.
- anon/authenticated execution is denied.
- Raw source evidence remains private and hash-addressed.
- No authentication bypass is approved for testing.

## Immediate programme sequence

Primary Layer 1 sequence remains:
1. CA
2. GB
3. US
4. IE
5. DE remediation/re-entry

Parallel execution:
- CA StatsCan v0.2.1 runtime rerun and mapping work;
- AU QILT workstream;
- Admin/PIM implementation;
- production security hardening.

## Current programme decision

**Architecture v2.10.3 and Running Build v2.6 are authoritative. The Canada identity architecture is accepted as dual-authority: IRCC DLI for Provider identity; deterministic UUIDv5 from DLI + stable local programme key for Course identity; APS/MTCU/CIP are non-primary validation/classification metadata; titles are mutable. CA Layer 1 remains ACTIVE until federated Course-source coverage and full production UAT pass.**
