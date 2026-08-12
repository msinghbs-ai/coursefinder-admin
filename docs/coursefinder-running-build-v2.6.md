# Coursefinder Running Build v2.6

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.3.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.5.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE / blocked on federated Course-source coverage; GB/US/IE queued; DE deferred/blocked.
- CA identity architecture is now dual-authority and enforced in database code.
- Phase 3A: AU QILT/ComparED and CA Postsecondary Outcomes remain parallel structured-outcomes streams.
- CA Layer 2A foundation PASS; StatsCan authenticated runtime reached the worker, exposed a WDS method defect, and worker v0.2.1 has been deployed with the documented contract.

## CA Layer 1 identity enforcement

Provider business identity:

`CA + ircc_dli + DLI_number`

Course business identity:

`UUIDv5(verified DLI + namespaced stable local programme key)`

Provincial/classification identifiers:
- APS = optional validation registration;
- MTCU = classification/validation metadata;
- CIP = field-of-study classification;
- none may establish the base Course identity.

Migration applied live:
- `ca_dual_authority_identity_contract`

Reproducible files:
- Pilot: `supabase/migrations/20260812130000_ca_dual_authority_identity_contract.sql`
- Admin: `supabase/production-migrations/050_ca_dual_authority_identity_contract.sql`

`svc_layer1_apply_scoped_course_records(...)` now:
- requires `ircc_dli` for CA Providers;
- rejects APS/MTCU/CIP as CA Course base schemes;
- generates deterministic UUIDv5 IDs for new CA Courses;
- updates titles against the existing identity;
- keeps regional registration separate;
- remains service-role-only.

Privilege UAT:
- anon execute: false;
- authenticated execute: false;
- service_role execute: true.

Ontario source governance now records `provincial_course_validation` and `APS validation_metadata_only`.

## StatsCan runtime incident and correction

Authenticated Pilot invocation on 12 August 2026 created job:
- `21cf6d0c-86b0-4cc2-a6bd-896968910d48`
- domain `outcomes`
- job type `layer2a_outcomes`
- status `failed`

Failure:

`HTTP 404: https://www150.statcan.gc.ca/t1/wds/rest/getCubeMetadata/37100278`

Root cause:
- v0.2.0 incorrectly treated `getCubeMetadata` as a PID-addressed GET endpoint.

Documented Statistics Canada WDS contract:
- metadata = POST `/getCubeMetadata` with `[{'productId':37100278}]`;
- full-table CSV = GET `/getFullTableDownloadCSV/37100278/en`.

Corrected worker:
- `statcan-ca-psis-etl-v0.2.1`
- Supabase function version `3`
- deployment SHA-256 `3d069c7e3f3f87f8cafd54b8c5405d0a4c645f55711db2113e2f5152d0f51d5c`
- `verify_jwt=true`
- Platform Admin authorisation retained
- `apply=true` still hard blocked.

Pilot worker commit:
- `6bd544c931f29790a2f134a300d59c3ae59a6c36`

Pilot error handling commit:
- `d58a1a0cbfe09e6776ef2d9e516b83a747e633e4`
- Edge Function HTTP response bodies are now surfaced to the Admin UI where available.

## Current data state

No unverified Layer 2A canonical data has been applied.

Before accepted APPLY:
- CA Layer 2A Provider outcomes remain 0;
- CA outcome benchmarks remain 0;
- source-to-Provider mappings remain subject to explicit DLI verification.

## Current gates

### CA Layer 1

- Identity architecture: PASS.
- IRCC live Provider acquisition: implemented.
- Federated Course-source coverage: BLOCKED/PENDING.
- Final country production gate: NOT YET PASS.

### CA Layer 2A StatsCan

- source/foundation/security: PASS;
- parser implementation: PASS;
- authenticated invocation path: PASS;
- first runtime: FAIL — documented WDS method defect;
- corrective deployment v0.2.1: PASS;
- authenticated rerun: PENDING;
- Provider mapping/CIP transforms/APPLY: PENDING.

## Immediate next execution

1. Re-run `Run StatsCan PSIS Dry Run` once under Platform Admin on worker v0.2.1.
2. Inspect exact CSV headers, evidence hash, institution candidates and parser result.
3. Re-run the same dry-run for evidence/idempotency comparison.
4. Continue Layer 1 independently with IRCC Provider population and stable local Course-source key validation.
