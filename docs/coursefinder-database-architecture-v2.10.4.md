# Coursefinder Database Architecture v2.10.4

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.3.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 12 August 2026

v2.10.4 retains v2.10.3's Canada dual-authority identity contract and separates the Canadian Provider authority gate from the federated Course authority gate.

## 1. Canada authority boundaries

### Provider authority

Federal source of truth: IRCC Designated Learning Institutions register.

Business identity:

`CA + ircc_dli + DLI_number`

A verified DLI can be reconciled into the canonical Provider catalogue without waiting for any Course source. `catalogue.providers.id` remains the internal entity UUID; the immutable business identity is represented by `stable_key`, `provider_identifiers` and `provider_registrations`.

Provider names are mutable attributes and may be updated against the same DLI identity.

### Course authority

There is no assumed Canada-wide Course authority.

Business identity for a newly accepted Canadian Course:

`UUIDv5(verified DLI + namespaced stable local programme key)`

Implementation namespace:

`coursefinder:ca:{dli}:{local_source_scheme}:{local_programme_key}`

Titles are mutable. APS/MTCU/CIP remain validation/classification metadata and cannot be used as the base Course identity scheme.

## 2. Independent Provider APPLY contract

Service-role-only RPC:

`public.svc_layer1_apply_ca_ircc_providers(p_source_id, p_evidence_id, p_records)`

Responsibilities:
- accept only IRCC-style DLI identifiers (`O` plus digits);
- reconcile Provider by existing `ircc_dli` identifier or deterministic stable key;
- create/update canonical Provider and its IRCC identifier/registration;
- write zero Courses;
- preserve source/evidence verification;
- report created/existing/conflict counts.

Browser execution is prohibited:
- anon: no execute;
- authenticated: no execute;
- service_role: execute.

Production migration:
- `051_ca_ircc_provider_only_apply.sql`

Pilot migration:
- `20260812133000_ca_ircc_provider_only_apply.sql`

## 3. CA live worker

Worker `layer1-ca-live` is advanced to `layer1-ca-live-v1.1.0`.

For both modes it:
1. authenticates Platform Admin;
2. fetches the live IRCC DLI register;
3. parses/deduplicates by DLI number;
4. captures private HTML evidence and SHA-256;
5. executes a deterministic bounded offset/batch.

Dry-run:
- no canonical writes.

APPLY:
- calls only `svc_layer1_apply_ca_ircc_providers(...)`;
- reconciles the selected Provider slice;
- performs zero Course writes;
- completes successfully while returning the independent Course coverage blocker.

The previous blanket CA APPLY block is removed because it incorrectly coupled two independent authority layers.

## 4. Country gate semantics

A successful Provider APPLY does **not** mean CA production PASS.

Independent states are:
- Provider authority acquisition/reconciliation — can PASS first;
- Course source/local-key authority — federated and separately gated;
- final CA country production gate — PASS only when required Provider + Course coverage, integrity, Search Projection, security and performance UAT all pass.

Current country blocker:

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`

## 5. Layer 2A consequence

Populating verified IRCC Providers first unlocks safe Layer 2A source mapping:

`StatsCan/Provincial source entity -> pipeline.source_provider_mappings -> existing IRCC-DLI Provider`

Layer 2A still cannot create Providers and does not satisfy the Layer 1 Course gate.

StatsCan worker remains `statcan-ca-psis-etl-v0.2.1`, with WDS metadata corrected to the documented POST method and canonical outcome APPLY disabled pending parser/mapping UAT.

## 6. Security/performance UAT

Latest post-DDL review:
- new CA reconciliation RPCs remain service-role-only;
- no new exposed CA write surface was identified;
- RLS-with-no-policy INFO notices reflect the established deny-by-default internal-schema pattern;
- existing authenticated UI SECURITY DEFINER warnings remain a broader Pilot hardening item;
- performance advisor reports unused-index INFO only; no new CA missing-FK-index issue was introduced.

## 7. Next gate

1. bounded IRCC Provider dry-run;
2. bounded IRCC Provider APPLY;
3. same-offset idempotency re-run;
4. continue until full IRCC Provider source is reconciled;
5. validate Provider/identifier/registration/evidence integrity;
6. use canonical Providers for StatsCan/Ontario/BC mapping;
7. separately approve and ingest federated Course sources;
8. final CA Search/security/performance production gate.
