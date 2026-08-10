# Coursefinder Pilot Validation v2.9 — Wave 1 Scenario 2

## Sydney specialisation-vs-course modelling

**Status:** Executed design-validation scenario

**Environment:** Existing `coursefinder-demo` project + current University of Sydney public course/handbook sources

**Purpose:** Validate whether the v2.9 data model can correctly distinguish award-level courses from provider-defined majors, minors, specialisations, streams and similar in-course academic options.

---

## 1. Scenario

University websites often expose pages for:

- degrees/courses;
- majors;
- minors;
- specialisations;
- streams;
- programs;
- pathways;
- research pathways.

These must not all become independent `course` rows.

The University of Sydney was selected because its current catalogue explicitly distinguishes award courses from optional specialisations and majors.

---

## 2. Source findings

### Master of Data Science

The University of Sydney handbook lists the following award-level course codes/titles:

- Master of Data Science
- Graduate Diploma in Data Science
- Graduate Certificate in Data Science
- Master of Data Science (Online)
- Graduate Diploma in Data Science (Online)

Within the Master of Data Science, the handbook separately defines optional specialisations:

- Data Engineering
- Machine Learning

The specialisations require prescribed specialisation-core units and related capstone/research work. They are not separate degrees or award courses.

### Undergraduate majors/minors

Sydney also defines majors and minors as academic components within a degree. A major is a sequence of units of study within the enrolled course rather than a separate award course.

---

## 3. Current demo database result

The current demo database contains award-level Sydney Data Science records including:

- Graduate Certificate in Data Science
- Graduate Diploma in Data Science
- Master of Data Science

It does not incorrectly contain `Data Engineering` or `Machine Learning` as independent Course rows in the tested Data Science set.

This validates the Layer 1 canonical course boundary for this example.

---

## 4. v2.9 design assessment

The v2.9 model already separates:

- Course Family — structural type;
- Course Collection — provider-defined grouping/vertical;
- Global Category — Coursefinder-controlled cross-provider taxonomy;
- Course Association — relationship between canonical courses.

However, none of those concepts accurately represents an **academic option inside a course**.

Using Course Collection would be incorrect because `Machine Learning` here is not primarily a provider catalogue vertical containing multiple award courses.

Using Global Category would lose the provider-native academic relationship and requirements.

Using a generic multivalue attribute would be too weak for options that may have their own:

- provider-native code;
- label;
- type;
- URL;
- description;
- credit-point requirement;
- mandatory/optional state;
- validity;
- evidence;
- ordering;
- search/filter behaviour.

### Classification

**DESIGN_GAP — material but contained.**

The production schema should explicitly model provider-native academic options/components under an award course.

---

## 5. Recommended production model

Add a first-class child entity such as:

### `catalogue.course_academic_options`

Suggested fields:

- `id uuid PK`
- `course_id uuid FK -> catalogue.courses`
- `stable_key text`
- `option_type text/ref` — `major`, `minor`, `specialisation`, `stream`, `program`, `research_pathway`, `concentration`, future controlled types
- `provider_code text nullable`
- `name text`
- `description text nullable`
- `source_url text nullable`
- `credit_points numeric nullable`
- `is_optional boolean`
- `is_primary boolean default false`
- `display_order integer`
- `valid_from date nullable`
- `valid_to date nullable`
- `status text`
- `source_id uuid nullable`
- `evidence_id uuid nullable`
- `last_verified_at timestamptz nullable`
- `created_at timestamptz`
- `updated_at timestamptz`

Recommended uniqueness should use provider/course-native identity rather than name alone, for example course + provider code where supplied, otherwise a stable generated key.

### Optional taxonomy mapping

Provider-native academic options should be mappable to Coursefinder global Fields of Study / Categories without overwriting their source names.

Example:

```text
Course: Master of Data Science
  Academic Option: Machine Learning
      option_type = specialisation
      Global Category mapping = Computing > Artificial Intelligence > Machine Learning

  Academic Option: Data Engineering
      option_type = specialisation
      Global Category mapping = Computing > Data Science > Data Engineering
```

This mapping can use the existing generic entity/category model if the entity registry includes `course_academic_option`.

---

## 6. Relationship boundaries

Use the following rules:

| Source concept | Production entity |
|---|---|
| Master of Data Science | Course |
| Graduate Diploma in Data Science | Course |
| Graduate Certificate in Data Science | Course |
| Information Technology / Computing study vertical | Course Collection |
| Data Engineering specialisation inside Master of Data Science | Course Academic Option |
| Machine Learning specialisation inside Master of Data Science | Course Academic Option |
| Data Science as global subject classification | Global Category / Field of Study |
| Graduate Certificate -> Master pathway/credit relation | Course Association |

---

## 7. Layer 2 behaviour

Layer 2 should capture the provider-native hierarchy and page context before classification.

For a discovered page/item, it should retain signals such as:

- parent course URL/title/code;
- breadcrumb;
- provider terminology (`major`, `specialisation`, etc.);
- award/course code if present;
- academic-option code if present;
- credit requirements;
- source URL/evidence.

Layer 2 must not assume every discoverable page is a canonical course.

---

## 8. Layer 3 behaviour

Layer 3 classification should output an entity classification such as:

- `course`
- `course_collection`
- `course_academic_option`
- `course_association_candidate`
- `category_mapping_candidate`
- `unknown`

Confidence should be based on provider terminology, parent-child context, award language, regulatory identity and page structure.

---

## 9. Layer 4 behaviour

Low-confidence cases should be presented to a curator with:

- discovered name;
- provider terminology;
- parent course candidate;
- page/breadcrumb evidence;
- proposed entity type;
- proposed global category mapping;
- duplicate candidates.

Layer 4 actions:

- approve as Course Academic Option;
- reclassify as Course;
- reclassify as Course Collection;
- map to existing option;
- reject/non-catalogue content;
- approve taxonomy/category mapping separately.

A human reclassification should be durable and auditable so a subsequent scrape does not recreate the same classification error.

---

## 10. Search behaviour

Academic options should be searchable but should not automatically become standalone course results.

Example student query:

`machine learning masters at Sydney`

Expected behaviour:

1. structured provider/study-level constraints identify Sydney + Masters;
2. lexical/vector search recognises `Machine Learning` from the course academic option;
3. result returned is **Master of Data Science**;
4. result explanation can say `Specialisation: Machine Learning`.

The search projection should therefore contain academic-option names/codes as controlled child content and structured metadata.

---

## 11. Import/export impact

Add workbook/CSV entities:

### `CourseAcademicOptions`

Recommended interchange columns:

- `course_key`
- `option_key`
- `option_type`
- `provider_code`
- `name`
- `description`
- `source_url`
- `credit_points`
- `is_optional`
- `display_order`
- `status`
- `valid_from`
- `valid_to`

### `CourseAcademicOptionCategories`

- `option_key`
- `category_code`
- `is_primary`

UUIDs remain internal and are not required for normal interchange.

---

## 12. Scenario outcome

### PASS

- Current Layer 1 award-course boundary for the tested Sydney Data Science records.
- Course Family remains separate from subject/specialisation.
- Course Collection remains appropriate for provider catalogue verticals.
- Global taxonomy remains separate from provider wording.

### DESIGN GAP

Add a first-class **Course Academic Option** model for majors, minors, specialisations, streams, programs, concentrations and research pathways that exist within a canonical course.

### Production gate impact

This gap should be incorporated into the v2.9 physical schema before `Coursefinder_Prod` is created.

It does not require redesign of the overall architecture; it is a contained extension of the catalogue/PIM/search/import-export model.
