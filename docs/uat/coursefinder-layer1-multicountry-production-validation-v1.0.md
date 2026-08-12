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

Countries advance sequentially. A country must reach an accepted Layer 1 Production Gate before the next country begins.

## Gate Standard

Each country must prove the AU-equivalent production properties before acceptance:

- authoritative regulatory/source datasets identified and validated;
- snapshot-backed acquisition replaced by live authoritative acquisition where required;
- source health and freshness verified;
- raw evidence retained in the private evidence boundary with SHA-256 lineage/provenance;
- Provider and Course identity derived only from stable regulator/source identifiers;
- names and titles remain descriptive and never act as identity;
- acquisition bounded and resumable through the production execution contract;
- bounded dry-run succeeds;
- bounded APPLY succeeds;
- same-source rerun proves idempotency;
- duplicate, orphan and integrity checks return zero unacceptable defects;
- Search Projection is rebuilt and validated;
- JWT / Platform Admin / service-role privilege boundaries are validated;
- runtime and performance are validated under bounded execution;
- full UAT evidence is committed under `docs/uat/`;
- programme governance and running-build documentation are updated after the gate.

No country is accepted merely because a configured source URL is reachable or because a legacy seed/snapshot can reconcile.

## Current Gate Board

| Order | Country | Current Runtime Position | Gate Status | Next Required Action |
|---:|---|---|---|---|
| 0 | AU | Live authoritative CRICOS; accepted full baseline | **PASS / ACCEPTED** | Reference standard |
| 1 | NZ | Live NZQA tertiary-provider + qualification acquisition; stable NZQA identities; full canonical/search load complete | **PASS / ACCEPTED** | Retain as accepted baseline |
| 2 | CA | Snapshot-backed plus live health check | **IN PROGRESS / NEXT** | Replace snapshot path with authoritative Canadian acquisition and prove stable Provider/Course identities |
| 3 | GB | Live UKVI provider register plus snapshot-backed course path | **PENDING** | Start only after CA PASS; remove any name-derived Provider identity before APPLY |
| 4 | US | Snapshot-backed plus live health check | **PENDING** | Start only after GB PASS |
| 5 | IE | Snapshot-backed plus live health check | **PENDING** | Start only after US PASS |
| 6 | DE | Live DAAD path exists but Provider identity/source authority are unresolved; DB guard prevents unsafe DAAD Provider registration writes | **DEFERRED / BLOCKED** | Reassess only after IE PASS, remediate and rerun complete gate |

## NZ Production Gate — Accepted 12 August 2026

Detailed UAT:
- `docs/uat/coursefinder-layer1-nz-production-gate-uat-v1.0.md`

Accepted source model:
- NZQA Education Organisations / Qualifications register is the complete runtime acquisition source for the tertiary population.
- Education Counts remains an independent authority/freshness cross-check, not a hard runtime dependency because the database runtime encountered a Cloudflare challenge.

Accepted identity model:
- Provider: `NZ + nzqa + Education Organisation number`.
- Course: `Provider + nzqa + NZQA qualification Number`.
- Provider names and qualification titles are descriptive only.

Accepted live population:
- Universities: 8
- Polytechnics: 17
- Wānanga: 3
- Private Training Establishments: 377
- Government Training Establishments: 4
- Total Providers: **409**

Accepted canonical/search population:
- Providers: **409**
- Provider Registrations: **409**
- Courses: **6,457**
- Course Registrations: **6,457**
- Search Documents: **6,457**

Integrity:
- duplicate Provider identity keys: 0
- duplicate Course identity keys at `provider + scheme + qualification code`: 0
- Providers without registration: 0
- Courses without registration: 0
- orphan Course Registrations: 0

Security:
- production worker remains `verify_jwt=true` with Platform Admin authorisation;
- Layer 1 write/evidence/finalisation functions remain service-role only;
- temporary NZ UAT token function and token rows were removed;
- temporary UAT/inspection Edge Functions were retired as JWT-protected HTTP 410 harnesses.

Performance finding:
- concurrent bounded reconciliation is safe, but simultaneous `svc_layer1_finalize_catalogue()` calls can contend and hit PostgreSQL statement timeout;
- operational pattern should reconcile bounded country slices and perform one final Search Projection rebuild after the load, or otherwise serialize finalisation.

This finding is tracked as production hardening and does not invalidate the NZ data/identity gate.

## CA Entry Position

CA is now the active Phase 1 country.

Entry requirements:
- identify authoritative Canadian Provider and Course/programme source coverage;
- reject name-derived identity;
- replace the legacy snapshot-backed path before production APPLY;
- retain the v2.9.1 canonical model unless a documented country-specific architecture extension is genuinely required;
- complete the same dry-run/APPLY/idempotency/integrity/search/security gate used for AU and NZ.

## DE Deferral

DE remains protected by the existing database safety guard and is explicitly out of execution sequence until NZ, CA, GB, US and IE have each passed.

Existing DE investigation evidence remains valid for blocker context, but DE must be reassessed against the then-current runtime before remediation and APPLY.

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
