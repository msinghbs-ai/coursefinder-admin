# Coursefinder Master Project Plan v1.4

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.3.md`  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Last consolidated:** 12 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.2.md`  
**Running build baseline:** `docs/coursefinder-running-build-v2.5.md`  
**Accepted Layer 1 gates:** AU PASS; NZ PASS

## Current programme position

- CA Layer 1 remains active and blocked only on federated Course-source coverage.
- GB, US and IE remain queued.
- DE remains deferred/blocked.
- Phase 3A has two approved parallel structured-outcomes streams:
  - AU QILT/ComparED;
  - CA Postsecondary Outcomes.
- Canada Layer 2A foundation is accepted and the Statistics Canada PSIS parser is implemented; authenticated runtime parser UAT is the next gate.

## Phase 1 — Layer 1 Regulatory / Authoritative Base Catalogue

No sequencing or identity change from v1.3.

Country state:
- AU — PASS
- NZ — PASS
- CA — ACTIVE / BLOCKED ON FEDERATED COURSE-SOURCE COVERAGE
- GB — QUEUED
- US — QUEUED
- IE — QUEUED
- DE — DEFERRED/BLOCKED

Immediate CA Layer 1 slice remains:
1. Ontario APS live acquisition/parser;
2. exact Provider-to-DLI mapping;
3. bounded dry-run/APPLY/idempotency/integrity;
4. expand federated Course-source coverage;
5. final Search Projection/security/performance gate.

Layer 2A may not create or merge Layer 1 Provider/Course identity and does not satisfy the Layer 1 production gate.

## Phase 3A — Authoritative Structured Outcomes

### AU
QILT/ComparED architecture and gate remain unchanged.

### CA — Postsecondary Outcomes

Approved source family:
- Statistics Canada PSIS as national structured backbone;
- Statistics Canada longitudinal graduate outcomes as benchmark source family;
- Ontario graduate outcomes/KPIs;
- BC Student Outcomes.

Current accepted objects/controls:
- `catalogue.provider_outcomes` for Provider-specific published outcomes;
- `catalogue.outcome_benchmarks` for non-Provider geography/cohort outcomes;
- `pipeline.source_provider_mappings` for source institution reconciliation;
- `ref.external_study_areas` and mappings for source taxonomy crosswalk;
- service-role-only Layer 2A job/evidence/source-health functions;
- Layer 2A sources configured with `canonical_identity_write=false`.

Statistics Canada worker:
- `statcan-ca-psis-etl-v0.2.0`;
- JWT protected and Platform-Admin authorised;
- acquires WDS metadata/full-table ZIP;
- stores SHA-256 private evidence;
- performs bounded CSV sample parsing (max 5,000 rows);
- emits institution/mapping and field/credential/student-status diagnostics;
- `apply=true` remains disabled.

Provider mapping rule:

`PSIS source institution -> verified pipeline.source_provider_mappings -> existing canonical IRCC DLI Provider`

Institution labels may assist candidate matching but cannot create/merge Provider identity.

Current CA Layer 2A gate:
1. **PASS** — source discovery/foundation/security/performance hardening.
2. **PASS — implementation** — StatsCan parser v0.2.0 deployed.
3. **PENDING** — authenticated runtime parser dry-run.
4. **PENDING** — Provider-to-DLI mapping verification.
5. **PENDING** — CIP/study-level/audience crosswalk.
6. **BLOCKED UNTIL ABOVE PASS** — Provider outcome APPLY/idempotency/integrity.
7. Later — longitudinal benchmark ingestion and comparison projection.

UAT:
- `docs/uat/coursefinder-layer2a-ca-postsecondary-outcomes-parser-uat-v1.1.md`

## Admin / Operations

Pilot client now exposes an authenticated `runLayer2AStatsCan(...)` route for the protected worker. No public/test authentication bypass is approved.

Data Operations > Pipeline must surface Layer 2A jobs separately from Layer 1 jobs as already defined by the Admin information architecture.

## Immediate programme sequence

Primary Layer 1 sequence remains:
1. CA
2. GB
3. US
4. IE
5. DE remediation/re-entry

Parallel work:
- CA Layer 2A authenticated StatsCan parser UAT;
- AU QILT workstream;
- Admin/PIM implementation;
- Phase 7 security hardening.

## Current programme decision

**Architecture v2.10.2 remains authoritative. Running Build v2.5 is current. CA Layer 1 remains active and blocked on Course-source coverage. CA Layer 2A StatsCan parser implementation is accepted, but canonical outcome APPLY remains prohibited until an authenticated parser run, exact Provider mappings and source taxonomy transforms pass UAT.**
