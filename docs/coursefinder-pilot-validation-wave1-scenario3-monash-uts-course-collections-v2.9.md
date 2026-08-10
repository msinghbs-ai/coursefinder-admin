# Coursefinder Pilot Validation Wave 1 — Scenario 3: Monash + UTS Course Collections v2.9

**Status:** Validation result. No database migration or production schema change applied.

## Objective

Validate the boundary between:

- Course Collection — provider-defined study area / vertical grouping;
- Course Academic Option — major, minor, specialisation, stream, concentration or pathway inside a course;
- Global Category — Coursefinder-controlled taxonomy used consistently across providers;
- Course Family — structural schema/type of the course.

## Providers tested

- Monash University
- University of Technology Sydney (UTS)

## Source behaviour observed

### Monash

Monash publishes an Information Technology study area that groups many independent award courses across levels and award types. The same provider-defined vertical includes undergraduate, graduate certificate, graduate diploma, masters and research options.

Examples include:

- Bachelor of Applied Data Science
- Bachelor of Computer Science
- Bachelor of Information Technology
- Graduate Certificate of Applied Data Science
- Graduate Certificate of Cybersecurity
- Graduate Diploma of Applied Data Science
- Master of Artificial Intelligence
- Master of Cybersecurity
- Master of Data Science
- Master of Information Technology
- Doctor of Philosophy

This is a provider-defined catalogue grouping, not a Course Family and not a Global Category.

### UTS

UTS publishes an Information Technology study area with nested study-option groupings such as:

- Information Technology
- Artificial Intelligence
- Computer Science
- Cybersecurity and Networking
- Games, Graphics and Multimedia
- Systems Design and Analysis

These groupings organise independent award courses while individual course pages separately contain majors/sub-majors/electives and other academic options.

For example, Bachelor of Artificial Intelligence is a standalone course while UTS also describes complementary sub-majors/electives inside the course. Bachelor of Information Technology is also a standalone course within the wider Information Technology study area.

## Demo database check

The existing demo database already stores the major independent Monash and UTS award courses as separate canonical `courses` rows.

Examples present in Layer 1 include:

### Monash

- Bachelor of Applied Data Science
- Bachelor of Artificial Intelligence
- Bachelor of Information Technology
- Master of Artificial Intelligence
- Master of Cybersecurity
- Master of Data Science
- Master of Information Technology

### UTS

- Bachelor of Artificial Intelligence
- Bachelor of Cybersecurity
- Bachelor of Information Technology
- Graduate Diploma in Artificial Intelligence
- Master of Artificial Intelligence
- Master of Cybersecurity
- Master of Data Science and Innovation
- Master of Information Technology

This confirms that Layer 1 is correctly identifying award-level entities and does not require provider study-area groupings to become canonical courses.

## Validation outcome

**PASS — Course Collection design is valid.**

No new Course Collection design gap was found.

The provider-defined study area should be represented as:

```text
Provider
  -> Course Collection
       -> Course Collection Membership
            -> Course
```

A collection may contain courses from multiple Course Families and study levels.

Examples:

```text
Monash University
  -> Information Technology
       -> Bachelor of Information Technology
       -> Master of Data Science
       -> Master of Artificial Intelligence
       -> Graduate Certificate of Cybersecurity
```

```text
UTS
  -> Information Technology
       -> Artificial Intelligence
            -> Bachelor of Artificial Intelligence
            -> Master of Artificial Intelligence
       -> Cybersecurity and Networking
            -> Bachelor of Cybersecurity
            -> Master of Cybersecurity
```

`parent_collection_id` therefore remains important because provider catalogue navigation can be hierarchical.

## Production modelling rule

Use the following hierarchy consistently:

```text
Course Family
= structural data model

Course Collection
= provider's own catalogue/study-area hierarchy

Course Academic Option
= major/minor/specialisation/stream/etc. inside a course

Global Category
= Coursefinder-controlled cross-provider taxonomy
```

Do not infer one from another.

Example:

```text
Course: Master of Data Science
Provider: Monash University
Course Family: Higher Education Course
Provider Course Collection: Information Technology
Global Category: Computing > Data Science
Academic Options: only those explicitly offered within that course
```

## Layer 2 requirements confirmed

Layer 2 should capture provider-native catalogue navigation when supported by evidence:

- collection name;
- collection hierarchy/breadcrumb;
- provider-local collection URL;
- course membership;
- display order where reliable;
- source/evidence;
- verification timestamp.

Layer 2 must not create a new global category merely because a provider uses a new study-area label.

## Layer 4 requirements confirmed

Layer 4 should review ambiguous classifications such as:

- whether a discovered page is a Course Collection or a Course Academic Option;
- whether a provider-local collection should map to one or more Global Categories;
- duplicate or overlapping provider collections;
- collection labels that change while membership remains similar.

Human review should preserve the provider's source wording while allowing Coursefinder's Global Category mapping to differ.

## Search behaviour

Course Collection contributes in two ways:

1. `collection_id` / collection path as deterministic structured metadata;
2. approved human-readable collection labels as optional semantic search context.

The provider collection must not replace the Global Category filter.

Example query:

`postgraduate AI or data courses at Monash`

Can resolve using:

- provider = Monash;
- study level = postgraduate;
- provider collection = Information Technology;
- Global Category = AI/Data Science where applicable;
- semantic ranking across course title/description/search projection.

## Classification

- Course Collection model: **PASS**
- Hierarchical Course Collections: **PASS / required**
- Many-to-many collection membership: **PASS / retain**
- Separation from Global Category: **PASS**
- Separation from Course Academic Option: **PASS**, subject to the Scenario 2 Academic Option design addition
- Layer 1 award-course boundary: **PASS**
- Layer 2 provider-navigation capture: **IMPLEMENTATION_GAP**
- Layer 4 collection-vs-option review workflow: **IMPLEMENTATION_GAP**

## Architecture impact

No change to the approved Course Collection concept is required.

Scenario 2's proposed Course Academic Option entity remains the only material physical-model addition identified so far.

## Next recommended scenario

Proceed to representative Layer 2 course-detail extraction covering:

- course URL discovery;
- fees;
- intakes;
- English requirements;
- description/content;
- evidence capture;
- dynamic/fallback acquisition.

Use Monash and UTS first because the current Layer 1 database already has strong award-course identity and fee baselines but little or no course-detail enrichment.
