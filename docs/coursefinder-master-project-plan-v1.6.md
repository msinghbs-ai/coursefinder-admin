# Coursefinder Master Project Plan v1.6

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.5.md`  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Last consolidated:** 12 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.4.md`  
**Running build baseline:** `docs/coursefinder-running-build-v2.7.md`  
**Accepted Layer 1 gates:** AU PASS; NZ PASS

## Current programme position

- CA remains the active Layer 1 country.
- CA identity architecture is PASS under the dual-authority pattern.
- IRCC Provider authority can now be acquired/applied independently from the Course gate.
- CA final country PASS remains blocked on federated Course-source coverage plus bounded integrity/Search/security/performance UAT.
- GB, US and IE remain queued; DE remains deferred/blocked.
- CA Postsecondary Outcomes remains a parallel Phase 3A stream.

## Phase 1 — Canada execution model

### Gate A — Federal Provider authority

Source: IRCC DLI register.

Identity:
`CA + ircc_dli + DLI_number`

Execution:
1. live authoritative fetch;
2. DLI parse/deduplication;
3. private evidence/hash;
4. bounded dry-run;
5. bounded Provider-only APPLY;
6. same-offset idempotency;
7. full-source reconciliation/integrity.

Worker:
- `layer1-ca-live-v1.1.0`

RPC:
- `svc_layer1_apply_ca_ircc_providers(...)`

This gate writes no Courses and therefore may PASS before Gate B.

### Gate B — Federated Course authority

Identity:
`UUIDv5(verified DLI + namespaced stable local programme key)`

Rules:
- Course title is mutable only;
- local programme key must be stable within an approved source namespace;
- APS/MTCU/CIP are validation/classification metadata only;
- every Course must resolve to a canonical IRCC-DLI Provider.

Initial source slice:
- Ontario public-college programme source;
- APS stored as regional validation registration;
- CIP mapped as field-of-study classification.

Additional provincial/institutional Course sources are required to satisfy the Canadian coverage gate.

### Gate C — Canada country production gate

PASS requires:
- Provider authority PASS;
- required federated Course coverage PASS;
- duplicate/orphan/identity/evidence integrity PASS;
- Search Projection PASS;
- security/performance PASS.

Current blocker:
`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.

## Phase 3A — CA Postsecondary Outcomes

StatsCan PSIS remains the national structured backbone.

The first authenticated invocation proved the Pilot UI/JWT/Platform-Admin/job route. Its v0.2.0 failure was an incorrect WDS metadata HTTP method, now corrected in `statcan-ca-psis-etl-v0.2.1`.

Layer 2A sequencing:
1. authenticated v0.2.1 parser dry-run;
2. repeat for evidence/parser consistency;
3. source institution -> existing IRCC Provider mapping;
4. CIP/study-level/audience transforms;
5. bounded Provider outcome/benchmark APPLY;
6. idempotency/integrity;
7. Admin/API comparison projection.

Layer 2A cannot create Providers or Courses.

## Security and operations

The two CA write RPCs are service-role-only. Browser roles cannot directly execute them.

The post-DDL Supabase advisor review found no newly exposed CA write surface and no new missing-FK-index issue. Existing Pilot-wide authenticated UI `SECURITY DEFINER` warnings and leaked-password protection remain Phase 7 hardening work; deny-by-default RLS tables intentionally generate no-policy INFO notices.

## Immediate programme sequence

1. **CA Provider Gate** — bounded IRCC APPLY + idempotency/full-source reconciliation.
2. **CA Course Gate** — Ontario stable local-key integration + DLI mapping, then broaden federated coverage.
3. In parallel, rerun StatsCan v0.2.1 and establish source-to-DLI outcomes mappings.
4. Complete CA final Search/security/performance UAT.
5. Only then promote CA to PASS and activate GB.

## Current programme decision

**Architecture v2.10.4 and Running Build v2.7 are authoritative. Canada no longer treats missing national Course coverage as a blocker to authoritative IRCC Provider ingestion. Provider and Course authority are independently gated, while the overall CA production gate remains ACTIVE until both authority layers and final production UAT pass.**
