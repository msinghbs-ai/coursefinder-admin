# Coursefinder Master Project Plan v1.3

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.2.md`  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Last consolidated:** 12 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.2.md`  
**Running build baseline:** `docs/coursefinder-running-build-v2.4.md`  
**Accepted Layer 1 gates:** AU PASS; NZ PASS  
**Current programme position:** CA Layer 1 remains active and blocked only on federated Course-source coverage. CA Layer 2A Postsecondary Outcomes is now an approved parallel workstream using Statistics Canada as the national structured backbone plus provincial outcome sources. GB, US and IE remain queued; DE remains deferred/blocked.

---

## 1. Governance

Source-of-truth order remains:
1. approved architecture/database identity rules;
2. this master project plan;
3. current running build;
4. accepted UAT evidence;
5. Admin/operator implementation guides.

All v1.2 decisions remain valid unless superseded below.

---

## 2. Programme status

| Phase | Name | Status | Current gate |
|---|---|---|---|
| 0 | Foundation & Architecture | **COMPLETE / ACCEPTED** | Architecture v2.10.2 authoritative |
| 1 | Layer 1 Regulatory / Authoritative Base Catalogue | **IN PROGRESS** | AU PASS; NZ PASS; CA ACTIVE/BLOCKED ON SOURCE COVERAGE; GB/US/IE queued; DE deferred |
| 2 | Admin / PIM UX | **IN PROGRESS / REDESIGN APPROVED** | Pipeline/Settings separation retained |
| 3 | Layer 2 Source Enrichment | **IN PROGRESS / FOUNDATION EXTENDED** | AU QILT foundation + CA Postsecondary Outcomes foundation |
| 4 | Layer 3 AI Enrichment | **PLANNED** | No production gate accepted |
| 5 | Data Quality & Human Review | **IN PROGRESS** | Provider/study-area source mapping foundations present |
| 6 | Search / API / Consumer Experience | **PARTIALLY COMPLETE** | AU/NZ search accepted; outcomes/comparison projection pending |
| 7 | Production Hardening & Operations | **IN PROGRESS** | Security, evidence, bounded execution, observability |

---

# Phase 1 — Layer 1 Regulatory / Authoritative Base Catalogue

No sequencing change from v1.2.

Country state:
- AU — PASS
- NZ — PASS
- CA — ACTIVE / BLOCKED ON FEDERATED COURSE-SOURCE COVERAGE
- GB — QUEUED
- US — QUEUED
- IE — QUEUED
- DE — DEFERRED/BLOCKED

CA Layer 2A work does not count toward the Layer 1 gate and cannot create or merge canonical Provider/Course identity.

Immediate Layer 1 CA slice remains:
1. Ontario APS live acquisition/parser;
2. exact Provider-to-DLI mapping;
3. bounded dry-run/APPLY/idempotency/integrity;
4. expand federated Course-source coverage;
5. final Search Projection/security/performance gate.

---

# Phase 2 — Admin / PIM UX

Approved v1.1/v1.2 information architecture remains unchanged.

Data Operations > Pipeline must show Layer 2A country/source jobs separately from Layer 1 jobs.

Administration > Sources / ETL Workers must support:
- source family/layer;
- country/subdivision scope;
- provider mapping requirement;
- canonical identity write permission (normally false for Layer 2A);
- worker/parser version;
- evidence freshness/health;
- Validate Configuration without canonical writes.

Insights > Outcomes & Comparisons remains the eventual read/admin surface.

---

# Phase 3 — Layer 2 Source Enrichment

## Phase 3A — Authoritative Structured Enrichment

### AU — QILT / ComparED

Existing v1.2/QILT plan remains unchanged.

### CA — Postsecondary Outcomes

Approved source hierarchy:

1. **Statistics Canada PSIS** — national structured backbone.
   - Initial table: `37-10-0278-01`, PID `37100278`.
   - Role: institution-level graduate counts and published field/program/credential/student-status dimensions.
   - Provider mappings attach source institutions to existing canonical CA DLI Providers.

2. **Statistics Canada longitudinal graduate outcomes** — national/provincial cohort benchmarks.
   - Role: geography + credential/study-level + field + years-after-graduation outcomes.
   - Store in `catalogue.outcome_benchmarks` when no Provider dimension is published.

3. **Ontario University Graduate Survey / College Graduate Outcomes-KPIs** — richer Provider outcomes for Ontario where published granularity permits.

4. **BC Student Outcomes** — employment/further-study/satisfaction outcomes for BC where published granularity permits.

No Provider outcome may be inferred from a geography-only benchmark.

### CA Layer 2A implementation status

Applied production-model migrations:
- `046_ca_postsecondary_outcomes_foundation.sql`
- `047_ca_layer2a_service_contract.sql`
- `048_ca_layer2a_evidence_zip_mime.sql`

Implemented worker:
- `statcan-ca-psis-etl` v0.1.0
- JWT + Platform Admin protected
- source acquisition/evidence only
- `apply=true` hard blocked until parser/mapping UAT passes.

### CA Layer 2A gate sequence

1. StatsCan WDS acquisition/evidence UAT;
2. full-table CSV parser/schema UAT;
3. source institution -> canonical DLI Provider mapping;
4. CIP/study-area and credential/study-level mapping;
5. bounded dry-run;
6. bounded APPLY;
7. idempotency/duplicate/orphan/temporal integrity;
8. add longitudinal benchmark ingestion;
9. Ontario outcomes ingestion;
10. BC outcomes ingestion;
11. curated comparison projection/API;
12. production acceptance.

---

# Phase 5 — Data Quality & Human Review

Extend Source Mappings to support CA Layer 2A:
- StatsCan institution -> canonical DLI Provider;
- Ontario/BC source institution -> canonical DLI Provider;
- CIP/source study area -> CourseFinder field of study;
- credential/source level -> CourseFinder study level;
- candidate/verified/rejected states;
- evidence and reviewer history.

Name similarity may create candidates only; it cannot establish identity.

---

# Phase 6 — Search / API / Consumer Experience

Outcomes/Comparison architecture is now global rather than AU-only.

Read model must distinguish:
- Provider-specific outcome observations (`catalogue.provider_outcomes`);
- non-Provider benchmarks (`catalogue.outcome_benchmarks`).

The UI/API must never label a geography/field benchmark as a named institution's measured outcome.

Consumer CA outcomes remain disabled until CA Layer 2A UAT passes.

---

# Phase 7 — Production Hardening & Operations

Additional CA Layer 2A requirements:
- service-role-only Layer 2A source/job/evidence RPCs;
- private outcome/benchmark tables;
- immutable raw evidence with SHA-256;
- source release/version tracking;
- bounded parsing/apply and resumability;
- source-provider mapping observability;
- metrics for rejected/unmapped institutions/study areas;
- no canonical identity write from Layer 2A.

---

## Immediate programme sequence

### Primary Layer 1
1. CA production gate.
2. GB.
3. US.
4. IE.
5. DE remediation/re-entry.

### Parallel Phase 3A
1. CA StatsCan PSIS source acquisition and parser UAT.
2. AU QILT source/parser pilot.
3. CA Provider/study-area mapping workflow.
4. CA benchmark ingestion extension.
5. Ontario/BC outcomes adapters.

---

## Current programme decision

**Architecture v2.10.2 is authoritative. CA Layer 1 remains the active country and its production gate remains blocked only on federated Course-source coverage. Canada Layer 2A Postsecondary Outcomes is approved as a parallel structured-enrichment workstream, with Statistics Canada PSIS as the national backbone and Ontario/BC as richer provincial outcome sources. Layer 2A cannot alter Layer 1 identity or unblock the CA Layer 1 gate.**
