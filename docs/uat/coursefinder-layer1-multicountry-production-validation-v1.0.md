# Coursefinder — Phase 1 Multi-Country Layer 1 Production Validation v1.0

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.9.1.md`  
**Master governance:** `docs/coursefinder-master-project-plan-v1.0.md`  
**Running build:** `docs/coursefinder-running-build-v2.1.md`  
**Accepted reference gate:** `docs/uat/coursefinder-layer1-au-full-ingestion-uat-v1.0.md` — PASS

## Execution Order

The controlled Phase 1 production-validation order is:

1. NZ
2. CA
3. GB
4. US
5. IE
6. DE — deferred until NZ, CA, GB, US and IE are accepted.

Countries are advanced sequentially. A country must reach an accepted Layer 1 Production Gate before the next country begins.

## Gate Standard

Each country must prove the AU-equivalent production properties before acceptance:

- authoritative regulatory/source datasets identified and validated;
- snapshot-backed acquisition replaced by live authoritative acquisition where required;
- source health and freshness verified;
- raw evidence retained in the private evidence boundary with SHA-256 lineage/provenance;
- Provider and Course identity derived only from stable regulator/source identifiers;
- names and titles remain descriptive and never act as identity;
- acquisition bounded and resumable through the production `country`, `apply`, `offset`, `batchSize`, `nextOffset`, `hasMore` contract;
- bounded dry-run succeeds;
- bounded APPLY succeeds;
- same-source rerun proves idempotency;
- duplicate, orphan and integrity checks return zero unacceptable defects;
- Search Projection is rebuilt and validated;
- JWT / Platform Admin / service-role privilege boundaries are validated, including negative browser-role checks where applicable;
- runtime and performance are validated under bounded execution;
- full UAT evidence is committed under `docs/uat/`;
- master programme status and running-build documentation are updated after the gate.

No country is accepted merely because its configured source URL is reachable or because its legacy seed/snapshot can reconcile.

## Current Gate Board

| Order | Country | Current Runtime Position | Gate Status | Next Required Action |
|---:|---|---|---|---|
| 0 | AU | Live authoritative CRICOS, full accepted baseline | **PASS / ACCEPTED** | Reference standard |
| 1 | NZ | `seed_snapshot_bounded` plus live health check; authoritative NZQA + Education Counts sources configured | **IN PROGRESS / NOT ACCEPTED** | Replace seed acquisition with live NZ authority and validate stable provider/course identifiers |
| 2 | CA | Snapshot-backed plus live health check | **PENDING** | Start only after NZ PASS |
| 3 | GB | Live UKVI provider register plus snapshot-backed course path | **PENDING** | Start only after CA PASS; remove any name-derived provider identity before APPLY |
| 4 | US | Snapshot-backed plus live health check | **PENDING** | Start only after GB PASS |
| 5 | IE | Snapshot-backed plus live health check | **PENDING** | Start only after US PASS |
| 6 | DE | Live DAAD path exists but provider identity/source authority are unresolved; DB guard prevents unsafe DAAD provider registration writes | **DEFERRED / BLOCKED** | Reassess only after IE PASS, remediate and re-run complete gate |

## NZ Entry Assessment — 12 August 2026

### Current runtime

Production `layer1-register-etl` (`layer1-edge-v1.4.1`) routes NZ through `runSeed()`. The adapter reads the preserved Layer 1 seed snapshot, performs only a reachability check against the configured live source, stores the seed JSON as evidence, and can reconcile that seed. This does **not** satisfy the production gate.

The configured NZ sources are:

1. `nz_nzqa` — New Zealand Qualifications Authority (NZQA) Education Organisations — primary authoritative regulatory source.
2. `nz_education_counts` — Ministry of Education / Education Counts tertiary-provider directory — authoritative secondary identity source.

### Stable identity assessment

NZQA explicitly publishes an **Education Organisation number** as the unique number assigned to each provider (also referred to as the Ministry of Education number/provider code). This is suitable for canonical Provider identity.

NZQA provider-specific qualification results expose a stable qualification **Number** together with qualification title, status, type, NZQF level and credits. Under architecture v2.9.1, the accepted NZ mapping is therefore:

- Provider identity: `NZ + nzqa + Education Organisation number`;
- Course identity: `Provider + nzqa + NZQA qualification Number`;
- Provider name and qualification title: descriptive only.

The existing seed identifiers such as `NZQA-UOA-001` and generated course identifiers are not accepted as production regulatory identity and must not be used for the NZ production APPLY gate.

### Acquisition direction

The NZ live adapter must use NZQA/Ministry authoritative records, retain live source evidence and avoid constructing identifiers from names. Education Counts may be used to define/validate the tertiary-provider population and NZQA to validate provider status and obtain provider-linked qualification records. Any deliberate narrowing of Layer 1 coverage must be documented as a source-authority/scope decision before acceptance.

### Architecture / DB impact

No architecture change is required for this identity mapping. It conforms to v2.9.1's existing regulator-identifier model and `041_layer1_identifier_identity_hardening.sql` semantics.

No NZ canonical writes are accepted from the legacy seed path.

## DE Deferral

DE remains protected by the existing safety guard and is explicitly out of execution sequence until NZ, CA, GB, US and IE have each passed. Existing DE investigation evidence remains valid for blocker context, but DE must be reassessed against the then-current runtime before remediation and APPLY.

## Gate Closure Rule

After each country gate, add a country-specific UAT document and update this board with:

- PASS/BLOCKED result;
- source/evidence hashes and freshness;
- canonical/reconciliation counts;
- idempotency and integrity results;
- Search Projection results;
- security/performance results;
- risks and dependencies;
- DB/architecture impact;
- recommendation for the next country.
