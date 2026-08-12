# Coursefinder Master Project Plan v1.2

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.1.md`  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Last consolidated:** 12 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.1.md`  
**Running build baseline:** `docs/coursefinder-running-build-v2.3.md`  
**Accepted Layer 1 gates:** AU PASS; NZ PASS  
**Current programme position:** CA Layer 1 active. CA identity architecture is resolved; complete federated Canadian Course-source coverage remains the production blocker. GB, US and IE remain queued; DE deferred/blocked. Admin/PIM redesign and AU QILT Layer 2A work continue in parallel.

---

## 1. Governance

Source-of-truth order:
1. approved architecture/database identity rules;
2. this master project plan;
3. current running-build documentation;
4. accepted UAT evidence;
5. Admin/operator implementation guides.

All details from v1.1 remain valid unless superseded below.

---

## 2. Programme status

| Phase | Name | Status | Current gate |
|---|---|---|---|
| 0 | Foundation & Architecture | **COMPLETE / ACCEPTED** | Architecture v2.10.1 authoritative |
| 1 | Layer 1 Regulatory / Authoritative Base Catalogue | **IN PROGRESS** | AU PASS; NZ PASS; CA ACTIVE/BLOCKED ON SOURCE COVERAGE; GB/US/IE queued; DE deferred |
| 2 | Admin / PIM UX | **IN PROGRESS / REDESIGN APPROVED** | v1.1 information architecture retained |
| 3 | Layer 2 Source Enrichment | **PLANNED / FOUNDATION EXTENDED** | QILT Layer 2A foundation applied; Layer 2B planned |
| 4 | Layer 3 AI Enrichment | **PLANNED** | No production gate accepted |
| 5 | Data Quality & Human Review | **IN PROGRESS** | Source mapping/reconciliation foundations present |
| 6 | Search / API / Consumer Experience | **PARTIALLY COMPLETE** | AU/NZ search accepted |
| 7 | Production Hardening & Operations | **IN PROGRESS** | Security, bounded execution, observability and release hardening |

---

# Phase 0 — Foundation & Architecture

Architecture v2.10.1 retains v2.10.0 QILT/ComparED design and introduces the accepted CA source-scoped Course identity model.

Core identity principles:
- names/titles never act as identity;
- Provider identity is source/regulator issued;
- Course identity is source/regulator issued and scoped to its Provider/source namespace;
- Layer 1 may establish authoritative base Course identity from a first-party institutional programme code where no regulator programme ID exists, without elevating non-regulatory enrichment to regulatory truth;
- Layer 2/3/4 boundaries remain unchanged for enrichment/conflict/review;
- search/comparison remain derived projections.

Linked docs:
- `docs/coursefinder-database-architecture-v2.10.1.md`
- `docs/coursefinder-database-architecture-v2.10.0.md`
- `docs/uat/coursefinder-layer1-ca-production-gate-uat-v1.1.md`

---

# Phase 1 — Layer 1 Regulatory / Authoritative Base Catalogue

**Status:** IN PROGRESS

Country state:
- AU — **PASS / ACCEPTED**
- NZ — **PASS / ACCEPTED**
- CA — **ACTIVE / BLOCKED ON FEDERATED COURSE-SOURCE COVERAGE**
- GB — QUEUED
- US — QUEUED
- IE — QUEUED
- DE — DEFERRED/BLOCKED

## Production identity contract

Provider:

`country + accepted Provider identity scheme + stable regulator/source Provider code`

Course:

`Provider + accepted Course identity scheme/source namespace + stable regulator/source Course code`

Names/titles remain display metadata only.

## CA accepted architecture

Provider authority:
- IRCC Designated Learning Institutions.
- identity: `CA + ircc_dli + DLI number`.

Course identity:
- provincial/territorial programme code where available; or
- stable first-party institution programme/catalogue code where no regulator programme identifier exists and source authority/stability is accepted.

New production-model objects:
- `catalogue.course_identifiers`;
- `pipeline.source_record_staging`;
- `svc_layer1_apply_scoped_course_records(...)`.

First configured provincial source:
- Ontario public college programmes;
- scheme: `on_aps`;
- APS is accepted as stable programme identity/registration for that source scope.

## CA blocker

**Blocker:** `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`

The identity model is no longer blocked. The country cannot pass until the accepted federated source set provides sufficient Canadian Course coverage and passes source-by-source acquisition/UAT.

Required CA sequence:
1. Ontario APS live parser/acquisition;
2. exact DLI mapping and Ontario bounded UAT;
3. remaining provincial/territorial source discovery;
4. first-party provider catalogue sources for documented gaps;
5. full bounded APPLY/resume;
6. rerun idempotency;
7. duplicate/orphan/integrity checks;
8. Search Projection finalisation;
9. security/performance gate;
10. CA PASS decision.

No CA canonical APPLY may use descriptive names, title-derived IDs or the legacy snapshot path.

---

# Phase 2 — Admin / PIM UX

The approved v1.1 information architecture remains unchanged:
- Overview/Dashboard;
- Catalogue;
- Data Quality;
- Data Operations;
- Insights;
- Administration.

Pipeline owns execution; Settings/Administration owns configuration. Country/source/worker validation must remain non-writing.

CA source configuration now needs to support multiple source roles/schemes within one country, including Provider authority, provincial Course authority and approved first-party Course catalogues.

---

# Phase 3 — Layer 2 Source Enrichment

The v1.1 split remains:
- Phase 3A Layer 2A authoritative structured enrichment (including QILT/ComparED outcomes);
- Phase 3B Layer 2B provider/source enrichment.

CA first-party programme sources used solely to establish stable base Course identity remain Layer 1 identity sources. Their fees, intakes, scholarships, descriptions and other enrichment fields remain Layer 2/3 governed.

QILT work remains independent of the CA Layer 1 gate.

---

# Phase 4 — Layer 3 AI Enrichment

No change from v1.1. AI output remains evidence-linked suggestion, not unreviewed canonical truth.

---

# Phase 5 — Data Quality & Human Review

In addition to v1.1 mapping/review scope, CA requires:
- source Provider -> exact DLI reconciliation;
- source-local programme identifier stability review where necessary;
- ambiguous cross-source Provider/Course mapping routed to review rather than name-based merge.

---

# Phase 6 — Search / API / Consumer Experience

Current accepted:
- AU Search Projection PASS;
- NZ Search Projection PASS.

CA Search Projection remains blocked until accepted canonical CA Course data exists. Projection is rebuilt only after bounded canonical reconciliation is complete.

---

# Phase 7 — Production Hardening & Operations

Continue v1.1 hardening plus:
- verify service-role-only CA scoped reconciliation;
- keep CA staging/internal identifier tables private;
- measure source/parser throughput by province/source;
- ensure country finalisation runs once or serially after reconciliation;
- keep evidence and staging lifecycle separate;
- add source coverage/health observability for the federated CA source set.

Applied CA migrations:
- `20260812115258 ca_scoped_course_identity_and_staging`
- `20260812115331 ca_scoped_course_reconciliation_rpc`

---

## 3. Immediate programme sequence

Primary Layer 1 sequence remains:
1. **CA production gate — ACTIVE.**
2. GB production gate.
3. US production gate.
4. IE production gate.
5. DE remediation/re-entry.

Immediate CA execution slice:
1. Ontario APS live ingestion.
2. DLI mapping.
3. bounded dry-run/APPLY/idempotency/integrity.
4. expand federated source coverage.

Parallel non-blocking work retained from v1.1:
- Admin/PIM implementation;
- QILT AU source/parser pilot;
- Dashboard/filter/manual-entry contracts;
- Pipeline/Settings separation;
- Source Mapping UI;
- Phase 7 security hardening.

---

## 4. Current programme decision

**Architecture v2.10.1 is authoritative. CA remains the active Layer 1 country. The CA identity-model blocker is closed; the remaining blocker is federated Course-source coverage. Ontario APS is the first configured provincial Course authority. GB/US/IE remain queued and DE remains deferred.**
