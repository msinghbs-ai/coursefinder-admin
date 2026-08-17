# CourseFinder Database Architecture v2.10.22

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.21.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 18 August 2026

This version retains the accepted Scholarship relational contract from v2.10.21 and updates the Canada Layer 1 production architecture to the explicit international-student, Bachelor-or-above Course scope now implemented in Pilot.

## 1. Core principles

- Stable identifiers are authoritative; names/titles are never identity.
- Layer 1 owns regulatory identity and base catalogue truth.
- Layer 2 enriches canonical entities and cannot redefine Provider/Course identity.
- Layer 3 AI may structure ambiguous enrichment but must not invent regulatory identity.
- Layer 4 resolves ambiguity/conflict.
- Internal schemas remain deny-by-default browser surfaces.
- Search/consumer read models derive only from accepted canonical state.

## 2. Canada Provider identity

Provider identity remains:

`CA + ircc_dli + DLI_number`

Every active Canada Course in the production scope must belong to a Provider that resolves through a current IRCC DLI identifier.

Provider names, school names and source display labels are evidence/descriptive fields only.

## 3. Canada Course identity

Course identity remains source-scoped and non-name based:

`Provider + source identity scheme + stable source-local programme identifier`

Canonical deterministic identity is equivalent to:

`UUIDv5(verified IRCC DLI + namespaced stable source-local programme key)`

A mutable Course title can never create, merge or move identity.

Accepted source-local schemes currently include, among others:
- `bc_epbc_program_guid`;
- `ab_alis_program_guid`;
- governed jurisdiction/institution schemes proven by their own production sub-gate.

## 4. Canada active product scope

Scope tag:

`ca-intl-bachelor-plus-v1`

A Course may be active in this scope only when:
1. its Provider resolves to a current IRCC DLI;
2. its source is accepted for the relevant jurisdiction/institution;
3. the programme has a stable source-local identifier;
4. current source inventory membership is proven;
5. the accepted source explicitly classifies the Course at Bachelor, Master, Doctorate/PhD, or an explicitly supported first-professional level;
6. the jurisdiction-specific international designation rule is satisfied.

Explicitly excluded are lower-level/unclassified programmes such as diplomas, certificates, graduate certificates/diplomas, trades and non-credential records.

Study level must derive from source fields under the adapter contract. Course-title inference is prohibited.

## 5. International eligibility contract

IRCC DLI identity is mandatory but does not by itself authorise every programme pattern for every institution type.

Current Alberta rule:
- public post-secondary institutions: institution-level designation plus current ALIS catalogue degree membership is accepted for Layer 1;
- private institutions: programme-specific designation evidence is required before active inclusion.

Equivalent jurisdiction-specific rules must be documented for other provinces/territories where designation semantics differ.

## 6. Scope-control architecture

Private table:
- `pipeline.ca_course_scope_keys`

Purpose:
- persist the accepted stable Course keys for a named production scope;
- bind source, Provider, identity scheme and identifier;
- retain exact `study_level_code` and scope metadata;
- support deterministic lifecycle activation/retirement without deleting historical canonical identity.

Key shape:
`source_id + scope_tag + provider_id + course_scheme + identifier`

Private inventory table:
- `pipeline.source_record_staging`

Purpose:
- retain current source inventory independently of canonical writes;
- support bounded resume, completeness validation and evidence/hash comparison;
- avoid exposing raw acquisition payloads as browser APIs.

Restricted RPCs include:
- `svc_layer1_stage_course_scope_keys(...)`;
- `svc_layer1_apply_course_scope(...)`;
- `svc_layer1_replace_source_inventory(...)`;
- `svc_layer1_read_source_inventory(...)`.

These remain service-role contracts; direct anon/authenticated execution is not part of the product API.

## 7. Lifecycle semantics

Canonical history and active product scope are different concepts.

- A previously ingested Course can remain as a canonical row while being `inactive`/unpublished when it no longer satisfies the accepted production scope.
- Scope reconciliation must not delete stable identifiers merely because a record is out of the current student-discovery product scope.
- Historical source/evidence lineage is preserved.

Current CA physical state after the University of Alberta sub-gate:
- total CA Course rows: 9,960;
- active scope-qualified: 1,986;
- inactive historical: 7,974;
- active null study levels: 0.

Active level split:
- Bachelor 1,055;
- Master 632;
- Doctorate 290;
- first-professional 9.

## 8. BC implementation

EducationPlannerBC is accepted for the current public-institution degree catalogue subset with stable programme GUID identity.

Current active BC scope:
- 1,428 Courses / 23 Providers;
- 693 Bachelor;
- 513 Master;
- 213 Doctorate;
- 9 first-professional.

2,687 previously broad EPBC records are retained inactive/unpublished.

## 9. Alberta ALIS implementation

System:
`ca_ab_alis_programs`

Course identity:
`ab_alis_program_guid`

Production worker:
`layer1-ca-ab-alis-degrees-v0.2.0`

The adapter contract requires:
- verified stable ALIS school UUID -> canonical IRCC DLI Provider mapping;
- complete current programme GUID inventory;
- bounded detail acquisition;
- exact `Credential Type = Degree`;
- exact source `Program Type` mapping:
  - `Bachelor's` -> `bachelor`;
  - `Master's` -> `masters`;
  - `Doctoral` -> `doctorate`;
- private evidence capture;
- scoped key staging;
- canonical APPLY and scope reconciliation;
- full replay idempotency.

The adapter follows ALIS source classification. It does not reinterpret degree names such as JD/MD using title heuristics.

Current verified ALIS scope:
- University of Calgary 179;
- University of Alberta 379;
- total 558 stable Course GUIDs across two Providers.

## 10. Search/publication boundary

Canonical active scope is necessary but not sufficient for student-facing publication.

Until the CA production gate closes:
- CA Search Projection remains protected;
- inactive historical broad rows must never be projected;
- final publication/search enablement is a separate country UAT action after national source coverage, integrity, security and performance tests pass.

## 11. Security boundary

- Raw acquisition evidence remains private.
- Scope and staging tables remain internal.
- privileged ingestion functions must have explicit restricted execution grants.
- custom-auth Edge Functions with `verify_jwt=false` must validate the vault-backed automation key internally and be backend allowlisted.
- service-role keys are never exposed to browser code.
- TLS weakening is prohibited.
- diagnostic/probe functions must be removed or locked before final country PASS.

## 12. Scholarship architecture retained from v2.10.21

The Scholarship domain remains relational:

`Scholarship -> Source Identifiers -> Offering Cycle -> Application Windows / Scopes / Eligibility / Award Tiers / Coverage`

Migration `052_scholarship_relational_api_hardening.sql` remains the accepted core baseline for:
- `scholarship.identifiers`;
- `scholarship.offering_cycles`;
- `scholarship.application_windows`;
- `scholarship.criterion_groups`;
- cycle-aware scopes/criteria/award tiers/coverage;
- nested `all`/`any` eligibility;
- source/evidence lineage;
- internal RLS/service-role boundaries.

Scholarship is Layer 2 and cannot change Layer 1 Provider/Course identity.

## 13. Canada production gate

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` now explicitly measures sufficient national/federated source coverage for `ca-intl-bachelor-plus-v1`, not every Canadian post-secondary programme.

CA PASS requires all declared source groups to prove:
- source authority/freshness;
- stable programme IDs;
- deterministic current-DLI mapping;
- exact Bachelor+ scope classification;
- bounded/resumable acquisition;
- evidence/hash lineage;
- APPLY/replay idempotency;
- duplicate/orphan/geography integrity;
- Search Projection isolation;
- security and performance UAT.
