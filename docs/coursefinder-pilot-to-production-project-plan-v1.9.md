# Coursefinder Pilot to Production Project Plan v1.9

**Status:** Active master programme plan  
**Architecture baseline:** Coursefinder Database Architecture v2.9.1  
**Running build:** Coursefinder Running Build v2.1  
**Latest accepted UAT gate:** Layer 1 Full AU CRICOS Ingestion — PASS  
**Primary runtime:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)

---

## 1. Current Overall Position

Coursefinder is in **post-AU Layer 1 productionisation / multi-country expansion preparation**.

The full Australian regulatory ingestion gate is complete and accepted. The programme now moves from proving AU canonical ingestion into hardening the production control model, closing platform security debt, and validating additional country adapters before Layer 2 expansion.

Approximate programme completion by major workstream:

| Workstream | Status |
|---|---|
| Architecture / canonical identity | Accepted baseline |
| Production database foundation | Complete |
| Admin UI foundation | In progress / operational |
| Layer 1 regulatory framework | Complete for AU; framework operational for configured countries |
| AU CRICOS full ingestion | PASS |
| Search projection / FTS baseline | PASS for AU |
| Security hardening | Partially complete; residual advisor items remain |
| Multi-country Layer 1 | In progress |
| Layer 2 acquisition / enrichment | Not yet resumed |
| Layer 3 AI extraction | Planned |
| Layer 4 governance | Foundation present; broader production workflow validation remains |
| Production readiness / cutover | Not complete |

---

## 2. Completed Phases and Accepted Gates

### Phase 0 — Runtime Foundation
**Status:** COMPLETE

Accepted:
- production-model Supabase schemas and migrations;
- curated API / service boundaries;
- private evidence storage;
- search projection foundation;
- migration/reset utilities.

### Phase 0A — Security Foundation
**Status:** COMPLETE WITH RESIDUAL DEBT

Accepted:
- service-role-only Layer 1 reconciliation boundary;
- internal schema protection baseline;
- browser/service separation;
- JWT + Platform Admin controls for Layer 1 execution.

Residual platform hardening remains tracked in Section 6.

### Phase 1 — PIM / Admin UI
**Status:** IN PROGRESS

Operational foundations exist for PIM, evidence, review and regulatory execution. Detailed UI implementation remains documented in the Admin guide / running-build documentation and should not be duplicated here.

### Phase 1A — Regulatory Settings
**Status:** COMPLETE

Accepted:
- country-specific regulatory configuration;
- official source resolution;
- authenticated Layer 1 trigger path;
- bounded country execution controls.

### Phase 3A — Layer 1 Core / AU Controlled UAT
**Status:** COMPLETE

Accepted:
- source acquisition;
- evidence + SHA-256 lineage;
- parsing and controlled APPLY;
- deterministic reconciliation;
- reset controls;
- 100-record reconciliation/idempotency UAT.

### Phase 3B — Layer 1 Full AU CRICOS Ingestion
**Status:** PASS / GATE ACCEPTED

Accepted canonical AU baseline:
- Providers: **1,546**;
- Courses: **26,648**;
- Campuses: **3,922**;
- Course↔Campus relationships: **47,671**;
- Search Documents: **26,648**.

Accepted identity rules:
- Provider identity = `country + registration_scheme + regulator_provider_code`;
- Course identity = `provider + registration_scheme + regulator_course_code`;
- names/titles are descriptive only and never identity.

The full ingestion gate also validated evidence, integrity, idempotency and bounded performance. High-concurrency Course Location processing is explicitly not the production model.

---

## 3. Active Workstreams

### A. Layer 1 Production Control Model
- Maintain bounded, resumable country execution.
- Preserve `country`, `apply`, `offset`, `batchSize` execution contract.
- Resume from persisted `nextOffset`.
- Keep controlled concurrency and deterministic rerun behaviour.

### B. Multi-Country Layer 1
Current framework routes AU, GB, DE, CA, IE, NZ and US through the common Layer 1 entrypoint.

Priority is to validate each adapter against the same principles proven by AU:
- authoritative source configuration;
- stable regulatory identity;
- bounded acquisition;
- evidence/provenance;
- idempotency;
- canonical reconciliation;
- search projection impact.

### C. Admin UI / Operational UX
- continue production-style one-country workflow;
- preserve last-job state and resumability;
- surface source health / adapter logic / reconciliation metrics;
- keep detailed implementation in Admin UI technical documentation.

### D. Search
- AU Search Projection baseline is accepted;
- retain rebuild-after-canonical-ingestion behaviour;
- validate search-document generation for additional countries before semantic expansion.

### E. Security / Production Readiness
- close residual security advisor findings;
- confirm browser-exposed `SECURITY DEFINER` functions are strictly required and hardened;
- enable leaked-password protection where applicable;
- validate final RLS/privilege posture before production cutover.

---

## 4. Architecture and Database Impact

**No architecture identity change is approved in this plan.**

The authoritative database baseline remains v2.9.1:
- stable IDs and explicit regulator identifiers are canonical;
- names never act as identity;
- canonical catalogue is separate from derived search;
- Layer 1 owns regulatory truth;
- Layer 2/3 may acquire/extract enrichment evidence;
- Layer 4 governs acceptance/rejection/conflict resolution;
- commercial ranking remains outside canonical Coursefinder academic truth.

Latest database hardening relevant to Layer 1:
- migration `041_layer1_identifier_identity_hardening.sql` corrected Provider/Course identity matching at full AU scale.

No new canonical entity type is introduced by the current production runner.

---

## 5. GitHub / Runtime Baseline

Admin repo latest running-build baseline records:
- `layer1-register-etl`: `layer1-edge-v1.4.1`;
- `layer1-au-depth`: `layer1-au-depth-v1.1.0`;
- `verify_jwt=true`;
- server-side Platform Admin authorisation required.

The production execution model is bounded country-at-a-time processing rather than monolithic full-country Edge execution.

The temporary AU full-gate UAT function is disabled and removed from operational use after gate acceptance.

---

## 6. Blockers, Risks and Technical Debt

| Item | Impact | Programme treatment |
|---|---|---|
| High concurrent Course Location batches can hit PostgreSQL statement timeouts | Throughput risk | Use deterministic bounded ranges; ~2,500 preferred under concurrency |
| Monolithic full-country Edge invocation exceeds execution ceiling | Runtime risk | Bounded/resumable execution is the accepted production contract |
| Broader `public.ui_*` `SECURITY DEFINER` advisor warnings | Security debt | Review/harden before production readiness gate |
| Leaked-password protection disabled | Security debt | Enable/validate before production readiness gate |
| Internal RLS/no-policy advisor notices | Governance/security review | Confirm intentional non-browser access and privilege model |
| Multi-country live source depth varies by adapter | Data quality / source risk | Country-by-country UAT before accepting Layer 1 gate |
| Master documentation versions can drift from running build | Governance risk | This v1.9 becomes the active master plan; future gate changes must update it |

---

## 7. Next Recommended Phase and Gate

### Next Phase — Layer 1 Multi-Country Production Validation

Proceed country-by-country using the accepted bounded execution framework rather than beginning Layer 2 immediately.

Recommended order:
1. **DE** — validate live paged DAAD acquisition end-to-end.
2. **GB** — validate UKVI provider register + configured course-source reconciliation.
3. **NZ / CA / IE / US** — validate existing snapshot/freshness adapters, then replace snapshot-backed acquisition with authoritative live acquisition where required.

### Gate Criteria
A country Layer 1 gate is accepted only when all are true:
- authoritative source and source health confirmed;
- stable regulatory identity confirmed;
- dry-run/apply reconciliation passes;
- rerun produces zero duplicate canonical entities;
- evidence/provenance captured;
- canonical integrity/orphan checks pass;
- search projection rebuild passes;
- runtime fits bounded execution contract;
- security privileges remain within approved service/admin boundaries;
- UAT evidence is written to `docs/uat/` and this master plan is updated.

Do **not** promote broad Layer 2 enrichment until at least the priority live country adapters have passed their Layer 1 gates or an explicit programme decision changes that sequencing.

---

## 8. Documentation Governance

For every material implementation change, update only the affected authoritative documents:

- **Master programme status / sequencing:** this project-plan version family.
- **Current deployed behaviour/runtime:** running-build version family.
- **Canonical architecture / identity / source-of-truth changes:** architecture/database architecture documents.
- **Accepted test evidence:** `docs/uat/`.
- **Operator workflow:** Admin guide.

Detailed implementation logs belong in the relevant technical repo/document and should be linked or referenced from the programme plan rather than duplicated here.

---

## 9. Current Gate Decision

**AU Layer 1 is ACCEPTED.**

**Programme is cleared to proceed to multi-country Layer 1 production validation and residual security hardening.**

Layer 2 remains the following major programme stage after the Layer 1 country-validation gate is sufficiently mature.