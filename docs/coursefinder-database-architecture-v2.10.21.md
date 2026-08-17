# CourseFinder Database Architecture v2.10.21

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.20.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 18 August 2026

This version retains the accepted Canada Layer 1 identity model from v2.10.20 and adds the validated relational Scholarship contract required for API/Layer 2 ingestion.

## 1. Unchanged core principles

- Stable identifiers are authoritative; names/titles are never identity.
- Layer 1 owns regulatory identity/truth.
- Layer 2 enriches existing canonical entities using evidence-backed source identities.
- Layer 3 AI produces structured suggestions where deterministic extraction is insufficient.
- Layer 4 resolves ambiguity/conflict.
- Internal schemas remain deny-by-default browser surfaces.
- Search/consumer read models are derived from canonical relational data.

## 2. Canada Layer 1 identity — unchanged

Provider identity remains `CA + ircc_dli + DLI_number`.

Course identity remains `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Titles remain mutable and admissions/intake availability remains separate from Course lifecycle.

Current accepted Canada position from v2.10.20:
- 1,130 Providers / DLI identifiers;
- 2,389 canonical CA Courses;
- 2,117 full/current accepted-source Courses;
- 80 partial-source Courses;
- 192 identity-full / lifecycle-currentness pending;
- CA remains ACTIVE/BLOCKED on `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`.

## 3. Scholarship domain — canonical entity versus offering

A Scholarship is a **long-lived canonical entity**.

Annual years, semesters, intakes, application rounds, award changes or eligibility changes do not create new canonical Scholarship identities unless the source explicitly establishes a different award identity.

The relational chain is:

`Scholarship -> Source Identifiers -> Offering Cycle -> Application Windows / Scopes / Eligibility / Award Tiers / Coverage`

This prevents year-specific clones and preserves history.

## 4. Scholarship source identity

New table:
- `scholarship.identifiers`

Purpose:
- retain API/source-native scholarship IDs independently of display name;
- support multiple identifier schemes/sources;
- preserve evidence and temporal validity;
- support unverified/superseded identifiers without changing canonical UUID identity.

Reconciliation rule:
1. exact accepted source identifier;
2. known alias/mapping where governed;
3. otherwise create/review candidate;
4. scholarship title alone must never merge entities.

## 5. Scholarship offering cycles

New table:
- `scholarship.offering_cycles`

A cycle represents a time-bound offering context such as `2027`, `2027-S1`, or a source-native award cycle.

Cycle-level facts can vary without overwriting prior history.

Existing root fields such as `academic_year` and root application dates remain compatibility/display fields only. New ingestion should prefer the cycle/window model.

## 6. Application windows

New table:
- `scholarship.application_windows`

A cycle can have zero, one or many application rounds. Each window can independently preserve:
- opening/closing timestamp;
- application method;
- application URL;
- status;
- source/evidence;
- source-native metadata.

No application window is required where the Scholarship is automatic-consideration.

## 7. Eligibility model

Existing atomic facts remain in:
- `scholarship.criteria`

New grouping table:
- `scholarship.criterion_groups`

Groups support nested `all` / `any` logic so eligibility can represent expressions such as:

`international AND full_time AND (India OR Nepal OR Indonesia) AND WAM >= 80`

Atomic criteria retain human wording and machine-evaluable fields. Unresolved natural-language conditions remain non-machine-evaluable and must not auto-pass.

Both groups and criteria can be cycle-specific.

## 8. Scope/applicability model

Existing `scholarship.scopes` remains authoritative for applicability.

Supported targets:
- global;
- Provider;
- Course;
- Course Collection;
- Study Level;
- Field of Study;
- Country;
- Campus.

`include` / `exclude` semantics remain first-class so broad applicability can be narrowed without materialising every Course relationship.

Migration 052 adds a structural constraint: each scope row must target exactly the entity type declared by `scope_type`.

Scope is now optionally cycle-specific.

## 9. Award and coverage model

Existing:
- `scholarship.award_tiers`
- `scholarship.coverage`

Both can now attach to `offering_cycles`.

`award_tiers` also gains source/evidence lineage because award amount/percentage is a material fact and must not rely only on root Scholarship provenance.

This supports:
- fixed amount;
- percentage;
- maximum amount;
- multiple merit bands;
- tuition/living/other coverage components;
- different awards by year/intake.

## 10. Layer 2 Scholarship ingestion contract

Scholarship ingestion is a Layer 2 enrichment workload.

Required adapter flow:
1. capture source evidence;
2. resolve Provider where relevant;
3. resolve Scholarship by source identifier, never name alone;
4. reconcile canonical Scholarship metadata;
5. upsert offering cycle;
6. reconcile application windows;
7. reconcile scopes;
8. reconcile criterion groups and criteria;
9. reconcile award tiers and coverage;
10. archive/close superseded cycles without destroying history;
11. route ambiguous identity/applicability to Layer 4 review.

Dry-run/APPLY/idempotency/evidence rules should follow the same production discipline already established for Layer 1, but Layer 2 cannot redefine regulatory Provider/Course identity.

## 11. Consumer/search implications

Scholarship discovery is relational, not a flat Course column.

Course matching:
`Course -> Provider / Collection / Study Level / Field / Campus / Country -> Scholarship scope`.

Student eligibility is a separate evaluation:
`Student/profile facts -> criterion groups -> eligible / ineligible / possible`.

The consumer UI must not imply eligibility merely because a Scholarship is applicable to a Course.

Current availability should derive primarily from active offering cycles/application windows, not the legacy root `academic_year` field.

## 12. Security and database boundary

New tables are internal schema tables with RLS enabled.

Direct `anon`/`authenticated` access is revoked. Service-role ingestion remains explicit. Browser access, when implemented, must use curated RPC/API contracts rather than direct table CRUD.

## 13. Migration baseline

New production migration:
- `052_scholarship_relational_api_hardening.sql`

Adds:
- `scholarship.identifiers`;
- `scholarship.offering_cycles`;
- `scholarship.application_windows`;
- `scholarship.criterion_groups`;
- cycle links on scopes/criteria/award tiers/coverage;
- criterion group links on criteria;
- source/evidence on award tiers;
- strict scope-target shape constraint;
- FK/query indexes and RLS/service-role boundaries.

Validation document:
- `docs/m1-scholarship-api-validation-2026-08-17.md`

## 14. Next gates

1. Define first Scholarship Layer 2 source adapter contract against a real provider/API source.
2. Validate stable source scholarship identifier behaviour.
3. Dry-run a representative sample containing recurring years, multiple deadlines, include/exclude scopes and compound eligibility.
4. Prove replay/idempotency and historical cycle preservation.
5. Add curated Admin Scholarship detail/edit UI using the relational model.
6. Add search/API projection only after ingestion and applicability UAT pass.
