# Coursefinder Database Architecture v2.9.1

**Status:** Production build baseline after pilot-to-production validation.

**Target pilot/UAT project:** `Coursefinder_Prod` (`qmhroocwdipgtduapslr`) in Australia Southeast.

**Post-UAT target:** Recreate/migrate the validated production build to Mumbai (`ap-south-1`) after successful pilot/UAT.

**Baseline:** Coursefinder Architecture v2.8.1 + Physical Database Schema v2.9 + validation scenarios 2–12.

---

# 1. Purpose

This version consolidates the database model proven during the pilot-to-production validation wave. It is the implementation baseline for the clean production-model database and replaces v2.9 as the active physical design reference without deleting or rewriting earlier versions.

The design keeps canonical academic/catalogue truth separate from search projections, commercial CRM ranking and consumer-facing APIs.

---

# 2. Core design principles

1. Normalised canonical write model; denormalised rebuildable read/search model.
2. Stable IDs and explicit identifiers/aliases; names never act as identity.
3. Evidence, provenance, temporal validity and review history are first-class.
4. Strong relational tables for structural facts such as providers, courses, fees, intakes, registrations, scholarships and rankings.
5. PIM attributes handle configurable/long-tail fields, not relational facts that require integrity.
6. Course Family, Course Collection, Course Academic Option and Global Category are separate concepts.
7. Layer 1 is canonical/regulatory ingestion; Layer 2 acquires/enriches evidence; Layer 3 performs structured AI extraction where required; Layer 4 governs acceptance/rejection/conflict resolution.
8. Search is a derived service: structured filters + FTS + optional pgvector + rank fusion.
9. Coursefinder returns academic truth/relevance. Commercial preference/commission remains outside the catalogue model and may re-rank downstream in Zoho.
10. Internal schemas are not browser-exposed. API access is through curated `api` views/RPCs and Edge Functions.

---

# 3. PostgreSQL schemas

| Schema | Purpose |
|---|---|
| `ref` | Countries, regions, subdivisions, currencies, languages, study levels, fields, provider types, English tests, institution groups, ranking sources |
| `catalogue` | Providers, identities, campuses, provider associations, course collections, courses, academic options and structured course facts |
| `pim` | Families, groups, attributes, options, aliases, values, categories and completeness |
| `scholarship` | Scholarships, scopes, criteria, award tiers and coverage |
| `integration` | Scrapers, connectors, models, extraction profiles, routing profiles and consumer definitions |
| `pipeline` | Sources, acquisition policies, jobs, evidence, hashes, lineage and change detection |
| `search` | Search Profiles, aliases, documents, embeddings, jobs, query embedding cache and index state |
| `publishing` | Channels/locales/publication state |
| `workflow` | Layer 4 review, review actions, reopening lineage, suggestions, import/export jobs and validation errors |
| `security` | Roles, user-role assignments and service permissions |
| `api` | Curated read contracts/RPCs only |
| `extensions` | PostgreSQL extensions such as pgcrypto and pgvector |

`public` is not used for canonical business tables.

---

# 4. Reference model

Core tables:

- `ref.regions`
- `ref.countries`
- `ref.subdivisions`
- `ref.currencies`
- `ref.languages`
- `ref.study_levels`
- `ref.fields_of_study`
- `ref.provider_types`
- `ref.english_tests`
- `ref.institution_collections`
- `ref.ranking_sources`

Countries include separate flags for catalogue/search/provider/course/scholarship enablement so global reference data can exist before ingestion is activated.

---

# 5. PIM model

PIM follows the validated family/group/attribute/value model:

`Attribute Family -> Attribute Group -> Attribute Definition -> Attribute Value`

Key tables:

- `pim.attribute_families`
- `pim.attribute_groups`
- `pim.family_groups`
- `pim.attribute_definitions`
- `pim.family_attributes`
- `pim.attribute_options`
- `pim.attribute_aliases`
- `pim.entity_registry`
- `pim.attribute_values`
- `pim.categories`
- `pim.entity_categories`
- `pim.completeness_profiles`
- `pim.completeness_requirements`

Attribute definitions support filterability, searchability, vector inclusion, validation, localisation, channel scoping and bulk edit behaviour.

This supports the approved PIM-style UX: family-driven forms, grouped tabs, managed options, category trees, completeness indicators and bulk operations.

---

# 6. Catalogue model

## Providers

Primary entities:

- `catalogue.providers`
- `catalogue.provider_identifiers`
- `catalogue.provider_aliases`
- `catalogue.provider_registrations`
- `catalogue.campuses`
- `catalogue.provider_collection_memberships`
- `catalogue.provider_rankings`

### Provider Associations — validated addition

`catalogue.provider_associations` is first-class and stores temporal/evidenced provider lineage without merging identities.

Required relationship types include:

- `predecessor_of`
- `successor_of`
- `foundation_of`
- `merged_into`
- `renamed_to`
- `related_institution`

Key fields:

- `id`
- `from_provider_id`
- `to_provider_id`
- `relationship_type`
- `valid_from`
- `valid_to`
- `source_id`
- `evidence_id`
- `status`

Adelaide University, University of Adelaide and UniSA remain separate canonical providers linked by explicit lineage.

## Course Collections

Provider-defined study-area/portfolio hierarchy:

- `catalogue.course_collections`
- `catalogue.course_collection_memberships`

A course may belong to multiple collections and may have one primary provider collection.

Course Collections are not Course Families, Global Categories or academic options.

## Courses

Primary tables:

- `catalogue.courses`
- `catalogue.course_identifiers`
- `catalogue.course_aliases`
- `catalogue.course_registrations`
- `catalogue.course_campuses`
- `catalogue.course_fees`
- `catalogue.course_intakes`
- `catalogue.course_english_requirements`
- `catalogue.course_relationships`

Fees preserve audience/cohort/year/currency/basis (annual/total/etc). Intakes preserve provider labels such as Autumn/Spring/Semester 1 instead of fabricating dates where the source does not supply one.

### Course Academic Options — validated addition

`catalogue.course_academic_options` represents child academic structures inside a course:

- Major
- Minor
- Specialisation
- Stream
- Concentration
- Program
- Research Pathway

Key fields:

- `id`
- `course_id`
- `parent_option_id`
- `option_type`
- `code`
- `name`
- `description`
- `is_optional`
- `source_url`
- `source_id`
- `evidence_id`
- validity/status/order fields

This prevents majors/specialisations from being incorrectly modelled as standalone courses or provider Course Collections.

---

# 7. Scholarship model

Core tables:

- `scholarship.scholarships`
- `scholarship.award_tiers`
- `scholarship.scopes`
- `scholarship.criteria`
- `scholarship.coverage`
- `scholarship.course_relationships`

### Course Collection scholarship scope — validated addition

Scholarship scope supports:

- provider-wide
- all courses
- study level
- field of study
- specific course
- specific Course Collection
- explicit include/exclude

This avoids materialising thousands of individual course links where a scholarship applies to a provider-defined vertical.

### Machine-normalised eligibility

Layer 2/3 extraction and Layer 4 approval must convert human wording into machine-evaluable criteria where possible, for example:

- `WAM >= 80`
- citizenship codes
- residency status
- study level
- course/collection scope
- alumni provider IDs
- English thresholds

Unresolved natural-language criteria remain `possible`, never auto-pass.

---

# 8. Pipeline and evidence

Core tables:

- `pipeline.sources`
- `pipeline.acquisition_policies`
- `pipeline.jobs`
- `pipeline.job_items`
- `pipeline.evidence_artifacts`
- `pipeline.change_events`
- `pipeline.extraction_runs`

Evidence stores URL/source identity, retrieval timestamp, content hash, version, storage reference and optional `supersedes_evidence_id`.

Layer 2 re-runs are idempotent and use content hashes/change detection. Changed evidence can reopen Layer 4 review.

---

# 9. Layer 4 workflow

Core tables:

- `workflow.review_queue`
- `workflow.review_actions`
- `workflow.catalogue_suggestions`
- `workflow.import_jobs`
- `workflow.import_rows`
- `workflow.import_errors`
- `workflow.export_jobs`

### Review reopening lineage — validated addition

Review records support explicit lineage:

- `reopened_from_review_id`
- `supersedes_review_id`
- `reopen_reason`

Review actions are append-only and include actor, action, before/after values, source/evidence and timestamps.

Supported actions include approve, reject, edit/approve, reclassify, reopen and supersede.

---

# 10. Search architecture

Search is derived from canonical catalogue/PIM data.

Core tables:

- `search.profiles`
- `search.profile_fields`
- `search.intent_aliases`
- `search.documents`
- `search.embeddings`
- `search.index_jobs`
- `search.query_embedding_cache`

## Search Profiles

A Search Profile versions:

- included fields/weights
- structured filters
- FTS configuration
- semantic/vector configuration
- intent aliases/normalisation rules
- channel behaviour (Website vs Zoho)

## Search Documents

Search documents include canonical stable IDs plus denormalised filter/search fields. They are rebuildable and are never the source of truth.

## Embeddings

Embedding rows carry:

- entity/search document ID
- model
- dimensions
- profile version
- content hash
- embedding status
- created/updated timestamps
- vector

Canonical `catalogue.courses` does not store the production vector.

## Query embedding cache — validated addition

The query embedding cache key is a SHA-256 hash over:

`embedding model | Search Profile version | normalised query`

It stores no raw query text.

Fields include cache key, model, profile version, vector, created/last-used timestamps, hit count and expiry.

Server/service-role access only.

## Retrieval path

Normal browse/search:

`structured filters -> FTS -> ranking`

Semantic/natural-language/recommendation:

`intent normalisation -> hard filters -> query embedding/cache -> FTS candidates + HNSW vector candidates -> reciprocal/rank fusion -> final academic ranking`

pgvector is not invoked on every website keystroke.

HNSW is the pilot default. Production keeps benchmark evidence so ANN index strategy can be revisited if catalogue scale/query patterns materially change.

---

# 11. API boundaries

Recommended endpoints/contracts:

- `/search/courses`
- `/search/semantic`
- `/courses/{id}`
- `/courses/{id}/related`
- `/courses/compare`
- `/scholarships/search`
- `/recommendations/courses`

Website uses anonymous/public-safe read contracts with throttling/caching.

Zoho uses authenticated/batched recommendation contracts with stable Coursefinder IDs.

Coursefinder returns academic relevance and eligibility signals. Zoho applies any commercial preference/re-ranking separately.

---

# 12. Security

- No service-role credential in browser code.
- Internal schemas are not exposed as general browser CRUD surfaces.
- Curated Data API grants only where explicitly required.
- All exposed tables/views/RPCs use RLS/role validation appropriate to the contract.
- Edge Functions validate JWT or use explicit server-side authentication where a public endpoint is required.
- Evidence storage remains private.
- `pipeline_config`-style anonymous write access from the demo is explicitly prohibited.
- Secrets belong in platform secret/config facilities, not browser-readable tables.

---

# 13. Production migration order

1. `001_schemas_extensions`
2. `002_reference_core`
3. `003_security_rbac`
4. `004_pim_core`
5. `005_catalogue_core`
6. `006_academic_options_provider_associations`
7. `007_scholarships`
8. `008_integrations_pipeline`
9. `009_workflow_layer4`
10. `010_publishing`
11. `011_search_projection`
12. `012_pgvector_embeddings_cache`
13. `013_api_contracts`
14. `014_import_export`
15. `015_demo_to_prod_migration_utilities`

Only validated canonical data is migrated from the demo. Demo snapshots, insecure policies, old vectors and temporary pilot schemas/functions are not copied.

---

# 14. Regional deployment and handover

## Pilot/UAT

Project: `Coursefinder_Prod`

Project ref: `qmhroocwdipgtduapslr`

Region: Australia Southeast (`ap-southeast-2`)

Plan: Free

Purpose: clean production-model build, migration validation, UAT, API/search validation.

## Post-UAT Mumbai production

After pilot/UAT sign-off:

1. Create a new Supabase project in Mumbai (`ap-south-1`) under the approved organisation/plan.
2. Apply the exact Git-tracked production migrations in order.
3. Apply reference/controlled seed data.
4. Migrate validated canonical catalogue/scholarship/evidence data using stable keys.
5. Regenerate search documents and embeddings in Mumbai; do not migrate temporary pilot search cache.
6. Deploy production Edge Functions/API configuration and secrets.
7. Run schema checks, row-count reconciliations, identity checks, Layer 4 audit tests, search relevance tests and API UAT.
8. Update Website/Zoho endpoints only after acceptance.
9. Keep Australia Southeast pilot/UAT project until Mumbai cutover and rollback window are signed off.

The region move is therefore reproducible infrastructure/data migration, not an opaque manual transfer.

---

# 15. Version status

v2.9.1 is the active production database baseline.

Earlier v2.8.1/v2.9 documents and validation scenarios remain retained for history/evidence and should not be overwritten.
