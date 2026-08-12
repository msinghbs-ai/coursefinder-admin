# Coursefinder Database Architecture v2.9.2

**Status:** Active production baseline extension to v2.9.1.  
**Date:** 12 August 2026  
**Supersedes:** v2.9.1 only where explicitly stated below; all other v2.9.1 rules remain authoritative.

## 1. Purpose

Canada has a federal stable Provider identifier (IRCC DLI number) but no single Canada-wide regulator programme identifier. v2.9.2 adds a source-scoped Course identity contract without allowing names/titles to become identity.

## 2. Identity contract

### Provider

`country + provider_identity_scheme + provider_identifier`

For Canada:

`CA + ircc_dli + DLI number`

IRCC DLI number remains the canonical Provider identity anchor.

### Course

`Provider + course_identity_scheme/source namespace + stable source-local programme identifier`

Accepted identifier classes may include:
- provincial/territorial programme codes issued by an authority (for example Ontario APS);
- stable first-party institutional programme/catalogue codes where the institution is the authoritative course catalogue source;
- other regulator/source-issued immutable programme identifiers approved through the country gate.

Course title, Provider name, URL slug, row position, content hash or any derivative of descriptive text is prohibited from identity construction.

A regional regulatory code is an optional registration attached to the Course and does not need to exist in every province.

## 3. Existing canonical model retained

No parallel `providers` or `courses` tables are introduced.

The existing canonical entities remain:
- `catalogue.providers`
- `catalogue.provider_identifiers`
- `catalogue.provider_registrations`
- `catalogue.courses`
- `catalogue.course_registrations`
- `pim.entity_registry`

Internal UUID primary keys remain surrogate relational keys. Stable identity is carried by the explicit stable key/identifier model; deterministic UUIDv5 is therefore not required and would create unnecessary coupling to the existing PIM entity registry.

## 4. Course identifiers

`catalogue.course_identifiers` is now implemented as the explicit source-scoped Course identifier table already anticipated by the v2.9.1 logical architecture.

Key fields:
- `course_id`
- `provider_id`
- `scheme`
- `identifier`
- `country_id`
- `issuing_authority`
- `is_primary`
- `source_id`
- `evidence_id`
- `verified_at`

Identity uniqueness is enforced at:

`provider_id + scheme + identifier`

A trigger verifies that the identifier Provider matches the Course Provider.

## 5. ELT staging

Raw heterogeneous source records are staged in private schema table:

`pipeline.source_record_staging`

Fields include:
- country/source/provider references;
- source record ID;
- raw `jsonb` payload;
- SHA/content hash;
- processing status;
- ingestion/processing timestamps;
- error text.

A GIN index supports payload inspection where required. The table is not exposed to `anon` or `authenticated`; service-role access only is granted.

Evidence/provenance continues to use `pipeline.evidence_artifacts` and private evidence storage. Staging is a processing buffer, not the evidence system of record.

## 6. Scoped reconciliation

New service function:

`svc_layer1_apply_scoped_course_records(...)`

It accepts separate:
- Provider source and identity scheme;
- Course source and identity scheme;
- optional regional registration scheme/code per record.

This prevents the former one-scheme assumption from conflating `ircc_dli` Provider identity with `on_aps` or institution-local Course identity.

The RPC is denied to `PUBLIC`, `anon` and `authenticated` and executable by `service_role` only.

## 7. Canadian source hierarchy

### Federal Provider authority
IRCC DLI:
- Provider identity and international-study designation;
- DLI number is stable identity;
- does not represent complete national Course coverage.

### Provincial/territorial programme authority
Where available, provincial/territorial programme datasets are preferred and can supply regional registrations and/or Course identity.

Ontario public-college programme data is the first configured example:
- Course identity/registration scheme: `on_aps`;
- APS is a unique code assigned to an approved programme of instruction;
- coverage is Ontario public colleges only and is not national coverage.

### First-party institution catalogue sources
For gaps not covered by a government programme register, an institution's authoritative catalogue/API/feed may supply a stable local programme code. Such sources must pass source-authority, stability, freshness and bounded-acquisition UAT before APPLY.

## 8. Layer boundary clarification

For Canada, Layer 1 means authoritative base catalogue identity/truth, not exclusively a single federal regulator feed.

- federal/provincial regulatory facts retain regulatory authority;
- stable first-party programme catalogue identity may establish the Course entity where no regulator programme identifier exists;
- fees, intakes, marketing description, scholarships and other enrichment remain Layer 2/3 according to existing source-priority rules;
- first-party catalogue sourcing must not silently elevate non-regulatory attributes to regulatory truth.

## 9. Security and compatibility

- AU and NZ reconciliation functions are unchanged.
- Existing v2.9.1 service-role/evidence/security boundaries remain mandatory.
- No browser service-role exposure.
- Internal schemas remain non-general CRUD surfaces.
- Search remains rebuildable from accepted canonical data.

## 10. CA gate impact

The prior **Course identity-model blocker is resolved by architecture**.

CA is **not yet production PASS** because national/federated Course source coverage must still be implemented and validated. The remaining blocker is source coverage and source-by-source acquisition UAT, not the database identity model.
