# Coursefinder Seed Data v2.9

**Status:** Production seed specification for review.

**Target:** `Coursefinder_Prod`.

**Architecture baseline:** v2.8.1. Physical schema companion: `coursefinder-physical-database-schema-v2.9.md`.

---

# 1. Seed principles

Seed data is divided into four classes:

1. **Global standards** — stable, broadly applicable data loaded from authoritative standards.
2. **Coursefinder controlled vocabularies** — application semantics owned by Coursefinder.
3. **Destination-specific regulatory reference** — country-specific registers, classifications and mappings.
4. **Operational bootstrap** — roles, permissions, channels, profiles and defaults needed to run the platform.

Provider and course catalogue data is **not application seed**. It is imported/ingested canonical data with source/evidence lineage.

---

# 2. Global standards seed

## Geography

Load globally from day one:

- ISO 3166-1 countries: alpha-2, alpha-3, numeric, canonical/official names.
- UN M49 region/subregion hierarchy.
- ISO 3166-2 subdivisions for active destinations initially; extend globally as destinations activate.

Initial destination states:

| Country | Catalogue | Provider ingestion | Course ingestion | Scholarship ingestion | Student search |
|---|---|---|---|---|---|
| Australia | active | true | true | true | true |
| New Zealand | active/onboarding | true | true | true | true when validated |
| United States | seed_only | false | false | false | false |
| Canada | seed_only | false | false | false | false |
| United Kingdom | seed_only | false | false | false | false |
| Ireland | seed_only | false | false | false | false |
| Germany | seed_only | false | false | false | false |
| Other countries | seed_only | false | false | false | false |

## Currencies

Seed ISO 4217 currencies globally. Important initial codes:
- AUD
- NZD
- USD
- CAD
- GBP
- EUR

## Languages

Seed at least ISO-style language codes needed for catalogue locale/publication handling. Initial platform locale remains English unless later requirements add translations.

---

# 3. Coursefinder controlled vocabularies

## Study levels

Suggested canonical hierarchy:

- `NON_AWARD`
- `ENGLISH_LANGUAGE`
- `FOUNDATION`
- `CERTIFICATE`
  - `CERT_I`
  - `CERT_II`
  - `CERT_III`
  - `CERT_IV`
- `DIPLOMA`
- `ADVANCED_DIPLOMA`
- `ASSOCIATE_DEGREE`
- `BACHELOR`
- `BACHELOR_HONOURS`
- `GRADUATE_CERTIFICATE`
- `GRADUATE_DIPLOMA`
- `MASTERS_COURSEWORK`
- `MASTERS_RESEARCH`
- `DOCTORAL`
- `MICROCREDENTIAL`
- `SHORT_COURSE`

Country adapters map local wording into these canonical levels while retaining source wording/evidence.

## Course Families

Initial structural families:
- `HIGHER_EDUCATION_COURSE`
- `VET_VOCATIONAL_COURSE`
- `ELICOS_ENGLISH_LANGUAGE`
- `FOUNDATION_PATHWAY`
- `RESEARCH_PROGRAM`
- `SHORT_COURSE_MICROCREDENTIAL`

Families control data shape/completeness; they do not represent university subject verticals.

## Provider Types

Initial controlled set:
- University
- University College
- Higher Education Institute
- Vocational Education / Training Provider
- TAFE / Polytechnic / Institute of Technology
- English Language Provider
- Pathway / Foundation College
- Private Education Provider
- Wānanga
- Government / Public Education Organisation
- Other Registered Education Provider

Country-specific classifications may be stored separately in regulatory records if they do not map cleanly to this global taxonomy.

## Delivery mode

- on_campus
- online
- hybrid
- distance
- workplace
- mixed

## Study load

- full_time
- part_time
- flexible

## English tests

Initial:
- IELTS Academic
- PTE Academic
- TOEFL iBT
- Cambridge English
- OET where relevant

Do not hard-code score scales into course rows; test definitions hold metadata and requirements hold values.

---

# 4. Global Field of Study taxonomy

Seed a hierarchical, Coursefinder-controlled taxonomy broad enough to support cross-provider search.

Recommended top-level nodes:

1. Agriculture & Environmental Studies
2. Architecture & Built Environment
3. Arts, Humanities & Languages
4. Business, Management & Commerce
5. Communication & Media
6. Computing & Information Technology
7. Creative Arts & Design
8. Education & Teaching
9. Engineering
10. Health & Medicine
11. Hospitality, Tourism & Events
12. Law & Legal Studies
13. Natural & Physical Sciences
14. Social & Behavioural Sciences
15. Mathematics & Statistics
16. Veterinary & Animal Sciences
17. Interdisciplinary Studies
18. General / Non-award / Pathway

Under Computing & IT, for example:

- Computer Science
- Information Technology
- Software Engineering
- Data Science & Analytics
- Artificial Intelligence & Machine Learning
- Cyber Security
- Information Systems
- Networks & Cloud Computing
- Games & Interactive Media

The taxonomy should be deep enough for useful student search but not mirror every provider's marketing wording. Provider wording is retained separately and mapped into one or more global categories.

---

# 5. Institution collections seed

Initial official groups only where they materially support discovery:

## Oceania
- `GO8_AU` — Group of Eight

## Americas
- `U15_CA` — U15 Canada
- `AAU_NA` — Association of American Universities

## Europe
- `RUSSELL_GROUP_UK`
- `LERU_EU`

Only collection definitions are seed data. Membership rows are destination/provider data and must be source/evidence-backed with validity dates.

---

# 6. Ranking source seed

Seed definitions only; do not populate commercial/licensed ranking results until redistribution and licence terms are confirmed.

Suggested disabled placeholders:
- QS
- Times Higher Education
- ARWU
- U.S. News
- Coursefinder Internal / Meta Ranking (future)

Each ranking source must include licence status such as:
- `unreviewed`
- `approved_for_internal_use`
- `approved_for_display`
- `restricted`
- `disabled`

---

# 7. Scholarship reference seed

Suggested scholarship types:
- Merit
- International Student
- Equity / Access
- Research
- Faculty / School
- Course-specific
- Government
- External / Industry
- Accommodation / Living Support
- Fee Waiver / Tuition Discount

Suggested scope types are not UI options alone; they map to physical relationship behaviour:
- provider
- all_courses
- course
- course_collection
- category
- study_level
- campus
- country

Suggested criteria types:
- citizenship / nationality
- residency status
- academic score
- GPA
- WAM
- ATAR
- English score
- field of study
- study level
- specific course
- enrolment status
- commencement intake
- financial/equity condition
- research topic
- other/manual review

---

# 8. Operational bootstrap seed

## Roles
- platform_admin
- pim_admin
- pipeline_operator
- curator
- counsellor
- viewer

## Publication channels
- internal_pim
- counsellor
- student_web
- api

## Core permissions
Seed action-based permissions for catalogue read/write/bulk, PIM model management, pipeline execution/configuration, review, search configuration, import/export and administration.

## Default completeness profiles
Initial placeholders to be refined before production publication:

- AU Higher Education / Internal PIM
- AU Higher Education / Counsellor
- AU Higher Education / Student Web
- NZ Higher Education / Internal PIM
- NZ Higher Education / Student Web

The actual requirement rows must be approved before public go-live.

## Default search profiles
- `COURSE_STUDENT_SEARCH_V1`
- `COURSE_COUNSELLOR_SEARCH_V1`
- `SCHOLARSHIP_SEARCH_V1`

These are seeded inactive or draft until embedding/model configuration is complete.

---

# 9. Destination-specific seed: Australia

Reference/configuration seed should include:

- country activation flags
- CRICOS source definition
- TEQSA source definition
- Australian subdivision list
- country-specific level mappings
- provider classification mappings
- regulatory registration scheme definitions
- Go8 collection definition already global/reference

Canonical providers and CRICOS courses are imported through Layer 1, not static seed SQL.

---

# 10. Destination-specific seed: New Zealand

Reference/configuration seed should include:

- NZ activation flags
- NZQA/official source definitions
- NZ subdivisions/regions required for search
- provider type mappings including universities, institutes/polytechnics, wānanga, PTEs where relevant
- country-specific qualification/study-level mappings

Providers/programmes are ingestion data, not static seed constants.

---

# 11. Future destination activation pattern

When a new country is activated:

1. Global country row already exists.
2. Enable catalogue/onboarding flags.
3. Load useful subdivisions.
4. Register authoritative regulatory source(s).
5. Configure country-specific identifier schemes.
6. Configure provider-type and study-level mappings.
7. Define Layer 1 adapter/source.
8. Define Layer 2 default acquisition policy.
9. Define Layer 3 extraction/routing policy.
10. Configure completeness profiles.
11. Configure search/publication rules.
12. Import/ingest providers, then courses.

No core schema redesign should be required.