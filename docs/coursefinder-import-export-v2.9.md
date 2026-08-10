# Coursefinder Import / Export v2.9

**Status:** Production interchange design for review.

**Target:** `Coursefinder_Prod`.

---

# 1. Objectives

Provide safe, repeatable CSV/XLSX import/export for future operations, migrations, partner exchange and bulk administration without exposing internal UUIDs or requiring direct table editing.

Principles:
- stable interchange keys/codes, not UUIDs, in user-facing files;
- versioned templates;
- staging before commit;
- validation with row-level errors;
- preview of insert/update/conflict actions;
- idempotent re-runs where possible;
- auditable import/export jobs;
- support both CSV and XLSX;
- preserve source/evidence references where supplied.

---

# 2. Import workflow

```mermaid
flowchart LR
    A[CSV/XLSX Upload] --> B[workflow.import_jobs]
    B --> C[Parse to workflow.import_rows]
    C --> D[Normalise keys and codes]
    D --> E[Validate references/types/rules]
    E --> F{Valid?}
    F -- No --> G[Row-level error report]
    F -- Yes --> H[Preview Insert/Update/No-op/Conflict]
    H --> I[Approved Commit]
    I --> J[Canonical tables]
    J --> K[Audit + derived rebuild queue]
```

No spreadsheet import should write directly into canonical tables from the browser.

---

# 3. Template/version model

Each template has:
- `template_code`
- `template_version`
- entity scope
- supported operation mode
- required columns
- optional columns
- reference-code dictionaries
- validation rules
- change log.

Example template codes:
- `providers_v1`
- `campuses_v1`
- `course_collections_v1`
- `courses_v1`
- `course_fees_v1`
- `course_intakes_v1`
- `course_categories_v1`
- `course_attributes_v1`
- `scholarships_v1`
- `scholarship_scopes_v1`
- `scholarship_criteria_v1`

---

# 4. Recommended XLSX workbook structure

## Provider workbook

Sheets:
- `Providers`
- `ProviderIdentifiers`
- `Campuses`
- `ProviderCollections`
- `ProviderRankings` where licensed/approved

## Course workbook

Sheets:
- `Courses`
- `CourseCollections`
- `CourseCollectionMemberships`
- `CourseCampuses`
- `CourseRegistrations`
- `CourseFees`
- `CourseIntakes`
- `CourseEnglish`
- `CourseCategories`
- `CourseAttributes`
- `CourseAssociations`

## Scholarship workbook

Sheets:
- `Scholarships`
- `ScholarshipAwardTiers`
- `ScholarshipScopes`
- `ScholarshipCriteria`
- `CourseScholarships`
- `ScholarshipCoverage`

---

# 5. Stable keys

Examples:

## Provider
`provider_key`

Prefer an immutable internal interchange key generated once and retained even when the provider display name changes.

## Course
`course_key`

Should remain stable across title changes. When an authoritative registration/code exists it can inform identity, but the interchange key itself should remain Coursefinder-controlled.

## Course Collection
`course_collection_key`

Scoped to provider but globally unique as a Coursefinder stable key.

## Categories/reference values
Use controlled codes such as:
- `AU`
- `AU-VIC`
- `BACHELOR`
- `COMPUTING.DATA_SCIENCE`
- `GO8_AU`
- `IELTS`

---

# 6. Example Courses sheet

Recommended visible columns:

1. `course_key`
2. `provider_key`
3. `course_name`
4. `display_title`
5. `provider_course_code`
6. `study_level_code`
7. `primary_field_code`
8. `summary`
9. `description`
10. `duration_value`
11. `duration_unit`
12. `credits`
13. `credit_unit`
14. `delivery_mode_code`
15. `study_load_code`
16. `primary_campus_key`
17. `official_url`
18. `application_url`
19. `family_code`
20. `publication_status`
21. `lifecycle_status`

Optional operational columns:
- `source_code`
- `last_verified_at`
- `row_action` for explicit insert/update modes

Internal UUIDs are excluded.

---

# 7. Example CourseCollections sheet

Columns:
- `course_collection_key`
- `provider_key`
- `parent_collection_key`
- `name`
- `code`
- `description`
- `source_url`
- `display_order`
- `status`
- `valid_from`
- `valid_to`
- `source_code`

## CourseCollectionMemberships

- `course_collection_key`
- `course_key`
- `relationship_type`
- `is_primary`
- `display_order`
- `source_code`

This preserves provider-native verticals independently of Coursefinder categories.

---

# 8. Example CourseFees sheet

- `course_key`
- `academic_year`
- `fee_type`
- `student_type`
- `amount_min`
- `amount_max`
- `currency_code`
- `billing_period`
- `indicative`
- `valid_from`
- `valid_to`
- `source_code`

Validation includes currency existence, numeric ranges, academic-year format and course-key existence.

---

# 9. Example CourseCategories sheet

- `course_key`
- `category_code`
- `is_primary`
- `display_order`

Global categories only. Provider-native course collections are imported separately.

---

# 10. Dynamic CourseAttributes sheet

Long-form layout is preferred for future-proofing:

- `entity_key`
- `attribute_code`
- `value`
- `value_type`
- `locale`
- `channel_code`
- `position`
- `source_code`
- `confidence`
- `valid_from`
- `valid_to`

For select/multiselect values, `value` should contain the option code, not display label.

Wide-format exports may be offered for human convenience, but long-form is the canonical import format for configurable attributes.

---

# 11. Validation classes

Every import row is evaluated for:

## Structural validation
- required column present
- expected datatype
- valid date/number/boolean format

## Reference validation
- provider/course/category/reference code exists
- option code belongs to the specified attribute
- parent relationships are valid

## Business validation
- provider/course relationships are coherent
- one primary category/collection where configured
- valid-from <= valid-to
- fee min <= max
- ranking values compatible with source/year
- family supports supplied attributes

## Duplicate/identity validation
- stable key collision
- external identifier collision
- duplicate relationship
- potential provider/course duplicate requiring review

## Security validation
- importing user has permission for the entity/action
- restricted fields are not writable through general templates

---

# 12. Import actions

Possible planned actions per row:
- `insert`
- `update`
- `no_change`
- `conflict`
- `reject`
- `review_required`

Bulk commit occurs only after validation/preview.

Records that change search-relevant canonical values should enqueue search projection rebuild; vector-included changes subsequently enqueue embedding regeneration.

---

# 13. Export design

Exports are generated from approved export profiles, not arbitrary raw-table dumps.

Examples:
- Catalogue snapshot
- Provider catalogue
- Course catalogue
- Scholarship catalogue
- Data-quality report
- Completeness report
- Search projection diagnostic
- Migration archive

Each profile controls:
- fields
- relationship expansion
- channel/publication filtering
- locale
- output format
- whether internal logical keys are included.

---

# 14. Export formats

## CSV
Best for:
- large flat entities
- automation
- re-import
- data exchange

## XLSX
Best for:
- multi-sheet relationship exports
- operational review
- bulk editing templates

For large datasets, export files should be generated asynchronously and stored in private object storage with short-lived signed download access.

---

# 15. Round-trip rule

A supported export intended for editing/re-import should be round-trip safe:

`Export → modify supported columns → import → validation → update`

Generated/derived fields such as embeddings, calculated completeness, ranking score boosts and internal UUIDs are read-only and should not be accepted back as writable canonical fields.

---

# 16. Audit

Import/export jobs retain:
- initiating user
- input/output file hash
- template/profile version
- row counts
- errors
- committed entity IDs
- timestamps
- status

This allows the platform to explain what changed because of a spreadsheet import and supports future rollback/reconciliation workflows.