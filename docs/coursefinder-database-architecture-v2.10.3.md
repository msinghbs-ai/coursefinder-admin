# Coursefinder Database Architecture v2.10.3

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.2.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 12 August 2026

v2.10.3 retains the global PIM, QILT/Layer 2A, evidence, staging, security and Search Projection contracts from v2.10.2 and tightens Canada around a dual-authority identity model.

---

## 1. Global identity rules

- Names/titles are mutable metadata and never canonical identity.
- Internal UUID PKs remain technical entity keys.
- Business identity must come from an authoritative stable identifier or a deterministic synthesis from accepted stable source identifiers.
- Layer 2A cannot create or merge Layer 1 Provider/Course identity.
- Search/comparison remain derived read models.
- Internal schemas remain deny-by-default browser surfaces.

---

## 2. Canada dual-authority model

Canada has two independent authority boundaries.

### Federal Provider authority

Authoritative source: IRCC Designated Learning Institutions register.

Provider business identity:

`CA + ircc_dli + DLI_number`

Rules:
- only an IRCC-verified DLI may establish a canonical Canadian Provider;
- local acronyms, institution names, provincial codes and StatsCan institution labels cannot establish Provider identity;
- `catalogue.providers.id` remains the internal UUID PK, while the authoritative business identity is persisted through `stable_key`, `provider_identifiers` and `provider_registrations`;
- Provider name changes are UPDATEs against the same DLI identity.

### Local Course authority

Canada has no single Canada-wide regulator course identifier.

Course business identity is therefore deterministic:

`UUIDv5( verified_DLI + namespaced_stable_local_programme_key )`

Implementation namespace:

`coursefinder:ca:{dli}:{local_source_scheme}:{local_programme_key}`

Rules:
- the local programme key must be stable within its accepted institutional/source namespace;
- Course title is never included in identity;
- title changes UPDATE the existing Course row;
- for newly created Canadian Courses, the deterministic UUIDv5 becomes `pim.entity_registry.id` and `catalogue.courses.id`;
- `catalogue.course_identifiers` retains the source-local scheme/key with evidence and source lineage.

---

## 3. Provincial and classification identifiers

Provincial identifiers are validation/registration metadata, not base Course identity.

Examples:
- Ontario APS -> `catalogue.course_registrations.scheme='on_aps'`;
- MTCU classifications -> reference/validation metadata;
- CIP -> taxonomy/classification mapping.

The Canada reconciliation RPC rejects `on_aps`, `aps`, `mtcu`, `cip` and `cip_2021` when supplied as the base Course identity scheme.

Ontario public-college source metadata is changed from `provincial_course_identity` to `provincial_course_validation`.

Ontario's official dataset defines APS as a unique ministry programme sequence and CIP as the national field-of-study classification, but Coursefinder deliberately keeps both outside the system-wide base Course identity so the Canada pattern remains portable to provinces/institutions without equivalent registries.

---

## 4. Canada ingestion translation contract

Accepted canonical payload shape:

```json
{
  "provider_code": "O123456789012",
  "provider_name": "Example Institution",
  "local_program_id": "institution-source-stable-key",
  "course_title": "Bachelor of Example",
  "regional_reg_scheme": "on_aps",
  "regional_reg_code": "optional-aps-code"
}
```

Required invocation schemes:
- `p_provider_scheme = 'ircc_dli'`;
- `p_course_scheme = stable local source namespace`, e.g. `institution_catalogue`, `college_program_code`, or another approved source-specific namespace.

Rejected as base Course schemes:
- `on_aps` / `aps`;
- `mtcu`;
- `cip` / `cip_2021`.

---

## 5. Layer 2A Canada outcomes

Layer 2A remains parallel to the Layer 1 production gate.

National structured backbone:
- Statistics Canada PSIS, table `37-10-0278-01`, PID `37100278`.

Provider mapping path:

`StatsCan source institution -> pipeline.source_provider_mappings -> existing IRCC-DLI canonical Provider`

StatsCan labels/coordinates never create Providers.

Provider-specific observations continue to use `catalogue.provider_outcomes`. Geography/field/cohort statistics without a named Provider continue to use `catalogue.outcome_benchmarks`.

---

## 6. StatsCan WDS contract correction

Worker: `statcan-ca-psis-etl-v0.2.1`.

The first authenticated runtime reached the worker and created a Layer 2A job but failed because v0.2.0 called:

`GET /getCubeMetadata/{PID}`

Statistics Canada documents `getCubeMetadata` as:

`POST /getCubeMetadata`

with body:

```json
[{"productId":37100278}]
```

The full-table acquisition remains:

`GET /getFullTableDownloadCSV/37100278/en`

v0.2.1 implements the documented method contract. `verify_jwt=true`, Platform Admin authorisation and `apply=true` blocking are unchanged.

---

## 7. Database enforcement

Production migration:
- `050_ca_dual_authority_identity_contract.sql`

Pilot migration:
- `20260812130000_ca_dual_authority_identity_contract.sql`

The migration:
- enforces `ircc_dli` for Canadian Provider identity;
- rejects provincial/classification schemes as base Course identity;
- generates deterministic UUIDv5 Course IDs for new Canadian Courses;
- treats titles as mutable metadata;
- stores optional regional registration independently;
- updates Ontario source governance to validation-only;
- preserves service-role-only execution of `svc_layer1_apply_scoped_course_records(...)`.

---

## 8. Current gate

CA Layer 1 remains **ACTIVE / BLOCKED on federated Course-source coverage**.

The identity architecture blocker is closed. Remaining work is source acquisition and coverage:
1. establish IRCC DLI Provider canonical set;
2. approve stable local programme-key namespace per Course source;
3. ingest Ontario/local Course sources with APS/CIP as validation/classification metadata;
4. bounded dry-run/APPLY/idempotency/integrity;
5. expand coverage beyond Ontario;
6. Search Projection/security/performance UAT.

CA Layer 2A StatsCan parser requires one authenticated rerun on v0.2.1 before the parser runtime gate can pass.
