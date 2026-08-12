# Coursefinder Database Architecture v2.10.1

**Status:** Authoritative architecture baseline.  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.0.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 12 August 2026

v2.10.1 retains every accepted v2.10.0 principle and QILT/ComparED structured-outcomes addition, and integrates the Canada source-scoped Course identity extension proven during the CA Layer 1 gate.

---

## 1. Core principles retained

1. Canonical entities use stable identifiers; names/titles never act as identity.
2. Layer 1 owns regulatory identity/truth and authoritative base-catalogue identity where a regulator does not issue a programme identifier.
3. Layer 2 acquires and normalises non-regulatory enrichment without redefining established canonical identity.
4. Layer 3 AI produces evidence-linked structured suggestions where deterministic extraction is insufficient.
5. Layer 4/human workflow resolves ambiguity and conflicts.
6. Search/comparison projections are derived and rebuildable.
7. Internal schemas are not direct browser CRUD surfaces.

---

## 2. Canada Provider identity

Canada-wide Provider authority is IRCC Designated Learning Institutions.

Canonical Provider identity:

`CA + ircc_dli + DLI number`

IRCC creates the DLI number after provincial/territorial designation. Provider name, campus name, city and URL are descriptive attributes only.

---

## 3. Canada Course identity extension

Canada has no single federal programme register exposing a stable programme identifier across all DLIs.

The accepted Course identity contract is therefore:

`Provider + course identity scheme/source namespace + stable source-local programme identifier`

Accepted identifier classes:
- provincial/territorial programme codes issued by an authority;
- stable first-party institution programme/catalogue codes where the institution is the authoritative source of its course catalogue;
- another regulator/source-issued immutable programme identifier accepted through UAT.

Explicitly prohibited from Course identity:
- Course title;
- Provider name;
- URL slug;
- row number/position;
- content hash;
- any key derived from descriptive text.

Regional regulatory codes remain optional. For example, Ontario APS may act as both a stable Course identifier and regional programme registration, but provinces without an equivalent field do not require a fake/null-substitute code.

---

## 4. Canonical implementation

No parallel Canada-specific `providers` or `courses` tables are introduced.

Existing canonical tables remain authoritative:
- `catalogue.providers`
- `catalogue.provider_identifiers`
- `catalogue.provider_registrations`
- `catalogue.courses`
- `catalogue.course_registrations`
- `pim.entity_registry`

New/now-implemented table:
- `catalogue.course_identifiers`

`catalogue.course_identifiers` stores explicit source-scoped Course identity:
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

Uniqueness:

`provider_id + scheme + identifier`

A database trigger verifies that the identifier's Provider matches the Course's Provider.

Internal Course UUIDs remain surrogate relational/PIM keys. Deterministic UUIDv5 is not required because stable business identity is explicit in `stable_key` + identifier tables and changing the UUID strategy would unnecessarily couple identity to the current PIM entity registry.

---

## 5. Canada ELT staging

New private staging table:

`pipeline.source_record_staging`

Purpose:
- receive raw heterogeneous provincial/institutional source records;
- preserve source record ID and content hash;
- store unnormalised `jsonb` payload;
- support asynchronous transform/reconciliation;
- isolate schema variance from the canonical catalogue.

Staging is not evidence-of-record. Raw source evidence/version/hash lineage continues through `pipeline.evidence_artifacts` and private evidence storage.

A GIN index supports JSONB inspection. `anon` and `authenticated` have no direct access; `service_role` is explicit.

---

## 6. Scoped reconciliation contract

New RPC:

`public.svc_layer1_apply_scoped_course_records(...)`

The RPC separates:
- Provider source;
- Provider identity scheme;
- Course source;
- Course identity scheme;
- optional regional Course registration scheme/code.

This removes the former assumption that one registration scheme necessarily identifies both Provider and Course.

Security:
- `PUBLIC`: denied;
- `anon`: denied;
- `authenticated`: denied;
- `service_role`: execute allowed.

AU/NZ production reconciliation functions remain unchanged.

---

## 7. Canada source hierarchy

### Federal
IRCC DLI:
- Provider identity;
- international-study designation/status;
- campus/location metadata where supplied.

### Provincial/territorial
Preferred when a stable programme code exists.

First configured example:
- system: `ca_on_public_college_programs`;
- source: Ontario public college programmes;
- identity/registration scheme: `on_aps`;
- APS is the unique programme code used for approved Ontario public-college programmes;
- scope is explicitly partial to Canada.

### First-party institution catalogue
Where government programme coverage is absent, an institution's official API/feed/catalogue may establish Course identity only when it exposes a stable local programme code and passes source authority/stability/freshness UAT.

Layer 1 may use that stable base-catalogue identity without granting non-regulatory attributes regulatory authority. Fees, intakes, scholarships, marketing content and similar attributes remain governed by Layer 2/3 rules.

---

## 8. Structured outcomes/QILT retained from v2.10.0

The v2.10.0 QILT/ComparED architecture remains fully authoritative and unchanged:
- `ref.outcome_surveys`
- `ref.outcome_metrics`
- `ref.external_study_areas`
- `ref.external_study_area_mappings`
- `pipeline.source_provider_mappings`
- `catalogue.provider_outcomes`

QILT remains Layer 2A authoritative structured enrichment and cannot create/merge Layer 1 identity from names.

Migrations 044/045 remain part of the baseline.

---

## 9. Search/API/admin/security principles retained

All v2.10.0 Search, comparison, Admin information architecture, manual-entry governance and internal-schema security rules remain unchanged.

Search and comparison are projections over accepted canonical identity/data and must never become the source of truth.

---

## 10. New production migrations

Applied to `coursefinder_Pilot`:
- `20260812115258 ca_scoped_course_identity_and_staging`
- `20260812115331 ca_scoped_course_reconciliation_rpc`

Pilot repository migration commits:
- `0254920c24a245571b9fc16bfe0c297b35a195ae`
- `b794ab9cc3293bf78e776276c1c76b239d908c37`

---

## 11. CA gate impact

The former **CA Course identity-model blocker is resolved**.

CA is still not production PASS because the accepted federated Course source set is incomplete. Remaining gate work is source coverage/acquisition UAT:
1. Ontario APS live ingestion + DLI mapping;
2. remaining provincial/territorial source discovery and qualification;
3. first-party institutional catalogue sources for documented gaps;
4. bounded APPLY/resume;
5. idempotency/duplicate/orphan integrity;
6. Search Projection;
7. security/performance UAT.

The active blocker is therefore `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`, not database identity architecture.
