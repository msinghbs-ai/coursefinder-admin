# M1 Scholarship API Validation — 17 August 2026

**Status:** VALIDATED / CORE DATABASE ADJUSTMENT APPLIED  
**Reviewed:** 18 August 2026  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Migration:** `052_scholarship_relational_api_hardening.sql`

## Purpose

Validate the existing CourseFinder scholarship domain against the shape required for provider/API ingestion and future Layer 2 enrichment, without flattening recurring awards, eligibility or course/provider applicability into one record.

## Existing model assessment

The original model was directionally correct:
- `scholarship.scholarships` for the canonical scholarship;
- `scholarship.scopes` for Provider/Course/Collection/Study Level/Field/Country/Campus applicability;
- `scholarship.criteria` for eligibility;
- `scholarship.award_tiers` for award values;
- `scholarship.coverage` for what the award covers.

This already supported relational scope better than a flat PIM/Creator model.

### Proven gaps

1. **Source identity was under-modelled.**
   `stable_key` alone does not preserve source/API-native identifiers, aliases, supersession or evidence.

2. **Recurring scholarship offerings were too flat.**
   Root-level `academic_year` and application dates cannot safely represent annual cycles, semester/intake variants or multiple application rounds without cloning the Scholarship entity.

3. **Application windows require independent cardinality.**
   A Scholarship can have several rounds/windows in one cycle and each may have its own URL/method/status/evidence.

4. **Eligibility logic requires grouping.**
   A flat list of criteria cannot reliably represent rules such as `A AND (B OR C)` while preserving machine evaluability and human wording.

5. **Cycle-specific facts were not expressible.**
   Scope, award tiers, coverage and criteria may change from one offering year/intake to another.

6. **Scope rows needed structural validation.**
   A row marked `course` must target exactly a Course, a row marked `provider` exactly a Provider, etc. Invalid mixed-target rows must fail at the database boundary.

## Accepted relational contract

### Canonical Scholarship

`scholarship.scholarships` remains the long-lived identity.

Do **not** create separate canonical scholarships purely because the year, intake, deadline or award changes.

### Source identifiers

New `scholarship.identifiers` stores:
- source/API scheme;
- source-native identifier;
- source/evidence;
- primary/secondary state;
- validity/supersession state.

Names remain descriptive and are not identity.

### Offering cycles

New `scholarship.offering_cycles` represents a specific offering context such as:
- 2027;
- 2027 Semester 1;
- 2027 International Intake;
- an API-defined award cycle.

Cycle-specific scope, eligibility, award and coverage can attach through `cycle_id`.

### Application windows

New `scholarship.application_windows` supports zero, one or many application rounds per Scholarship/cycle with independent:
- opening/closing timestamp;
- application method;
- application URL;
- status;
- source/evidence.

Automatic-consideration scholarships can continue to use `application_required = false`; the absence of a window is not treated as missing data where no application is required.

### Eligibility groups

New `scholarship.criterion_groups` supports nested `all` / `any` logic.

Examples:
- all of: international student + full-time enrolment + minimum WAM;
- any of: India OR Nepal OR Indonesia citizenship;
- nested: academic threshold AND (specific course OR specific field).

`scholarship.criteria` retains the atomic criterion and gains optional `criterion_group_id` and `cycle_id`.

### Scope integrity

`scholarship.scopes` remains the reusable applicability model. A database constraint now requires the target column to match `scope_type` exactly:
- provider -> `provider_id`;
- course -> `course_id`;
- course_collection -> `course_collection_id`;
- study_level -> `study_level_id`;
- field_of_study -> `field_id`;
- country -> `country_id`;
- campus -> `campus_id`;
- global -> no target ID.

Include/exclude remains independent so broad inclusion plus specific exclusion can be modelled without expanding thousands of course rows.

## API ingestion rules

For Layer 2 scholarship adapters:
1. resolve/source the canonical Provider where applicable;
2. identify Scholarship using accepted source identifier mapping, never title alone;
3. upsert the canonical Scholarship;
4. upsert the current offering cycle;
5. reconcile windows, scopes, criteria groups/criteria, award tiers and coverage for that cycle;
6. retain source/evidence on every material child fact where available;
7. close/archive a prior cycle rather than overwriting historical facts;
8. route ambiguous source identity or applicability to review.

## Search/consumer implications

Search and consumer APIs should derive `current scholarship availability` from active cycles/windows rather than root `academic_year` alone.

Course-level scholarship discovery should resolve relational scope:
`Scholarship -> include/exclude scope -> Provider/Course/Collection/Study Level/Field/Campus/Country`.

Eligibility should be displayed separately from applicability. A Scholarship being applicable to a Course does not mean the student is eligible.

## Validation result

**PASS — with migration 052 applied.**

The core Scholarship entity remains valid. The relational hardening closes the identified API/cardinality gaps without changing existing canonical identity principles or Layer 1 regulatory behaviour.
