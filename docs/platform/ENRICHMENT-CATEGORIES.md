# Enrichment categories — the one list

**Version:** 1.0, 17 Nov 2026 21:10 AEDT
**Decision:** Platform Admin, 17 Nov 2026 19:58 (chat S1-RM-Design): one single list of eight enrichment categories, read by every lane.
**For:** S2 - BOOST, S2-Build, S1-Build and any later lane that groups, routes or reports enrichment work by category.
**Source of truth:** tables `ref.enrichment_categories` and `ref.enrichment_category_fields` (Pilot migrations `20261117193000` and `20261117213000`). This document describes them; if the two disagree, the tables are right.

## The eight keys

Use these keys exactly. Do not keep a second list in a setting or in code.

| Order | Key | Label | What it holds |
|---|---|---|---|
| 1 | `course_basics` | Course basics | Level, length, delivery, field of study, description, official page |
| 2 | `fees` | Fees | Tuition on the register and as the provider publishes it |
| 3 | `entry_requirements` | Entry requirements | Academic and English entry, the provider entry matrix |
| 4 | `intakes_deadlines` | Intakes & deadlines | Start dates and application deadlines |
| 5 | `campus_location` | Campus & location | Where the course is taught and where the provider is |
| 6 | `provider_profile` | Provider profile | Description, logo, type, website, contact |
| 7 | `recognition_registration` | Recognition & registration | Registrations, accreditations, open to international students |
| 8 | `scholarships` | Scholarships | Scholarships the provider offers |

## Fields in each category (32 coverage fields)

| Key | Fields (`pipeline.field_coverage_daily.field`) |
|---|---|
| `course_basics` | `level`, `duration`, `delivery`, `field_of_study`, `description`, `official_url`, `v3_study_load`, `v3_empty_reason` |
| `fees` | `provider_tuition`, `registered_tuition` |
| `entry_requirements` | `academic_entry`, `english`, `p_entry_matrix`, `v3_grade_normalised` |
| `intakes_deadlines` | `intakes`, `deadline` |
| `campus_location` | `campus`, `campus_city`, `p_campuses`, `p_address`, `v3_campus_primary`, `v3_destination` |
| `provider_profile` | `p_description`, `p_logo`, `p_type`, `p_website`, `p_contact` |
| `recognition_registration` | `p_registrations`, `v3_accreditations`, `international`, `p_international` |
| `scholarships` | `p_scholarships` |

The Platform Admin can move a field to another category with a reason (Platform health › Country & category completeness). Read the list at run time; do not copy it.

## How to read it

| Reader | How |
|---|---|
| Edge functions and workers (service role) | `rpc('svc_enrichment_categories')` returns `{ "version": 1, "categories": [ { "key", "label", "description", "sort_order", "fields": [ { "field", "label" } ] } ] }` in order |
| SQL inside the database | `security.enrichment_categories_v1()` (same content), or the two tables directly (service role has `select`) |
| The Admin | `admin_layer1_induction_read` (wizard) and `admin_completeness_report` (report) already use it |

## What each lane needs to change

| Lane | Today | Change needed |
|---|---|---|
| S1-RM-Design (Admin wizard and report) | Uses the list | None |
| S2-Build (AI mapper, Layer 1 readers) | Not built yet | Return and accept only these keys in `category_key` (contract `LAYER1-AI-INDUCTION-MAPPER-CONTRACT.md`) |
| S2 - BOOST (Boost priority matrix) | Setting `country_category_boost` holds eight other keys, and `security.boost_country_category_check_v1()` fixes those eight in code (Pilot migration `20261117183000`) | Move the matrix to these keys: the `categories` list, `category_weight`, `cells`, `lane_category`, and the check function. Not done by S1-RM-Design: the matrix orders the nightly Boost work and its weights are S2 - BOOST's and the Platform Admin's to set |

## Crosswalk from the Boost keys (for S2 - BOOST's change)

`ref.enrichment_category_fields.boost_category` records, field by field, which Boost key each coverage field fell under. It is a crosswalk only and can be ignored once the matrix has moved.

| Boost key (old) | Becomes | Note |
|---|---|---|
| `tuition_fees` | `fees` | One to one |
| `admissions_entry` | `entry_requirements` | One to one |
| `geo_localities` | `campus_location` | One to one |
| `intakes_delivery` | `intakes_deadlines`, and part of `course_basics` | `intakes` and `deadline` move to `intakes_deadlines`; `delivery`, `duration` and `v3_study_load` sit in `course_basics` |
| `identity_registers` | `course_basics`, `provider_profile`, `recognition_registration` | One Boost key covers three categories; each needs its own weight |
| `scholarships_accred` | `scholarships`, and part of `recognition_registration` | `p_scholarships` to `scholarships`; `v3_accreditations` sits in `recognition_registration` |
| `study_rules` | No key in this list | Study rules are destination data, not a course or provider enrichment category |
| `careers_outcomes` | No key in this list | Career outcomes are destination data, not a course or provider enrichment category |

## Open points for the Platform Admin

- **Weights.** The Boost matrix has one weight per old key. Three old keys split across more than one new key, so new weights are needed for `course_basics`, `provider_profile`, `recognition_registration`, `intakes_deadlines` and `scholarships`.
- **Study rules and career outcomes.** They have no place in the eight. Either Boost orders them outside the category matrix, or the list grows (which would change the decision of one list of eight).
- **Lane work.** Boost lanes map to categories through `lane_category` (`study_load`, `course_fees`, `aer_entry`, `provider_accreditations`); those four entries need their new keys.
