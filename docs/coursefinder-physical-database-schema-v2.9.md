# Coursefinder Physical Database Schema v2.9

**Status:** Implementation-ready physical design for review.

**Target:** Supabase project `Coursefinder_Prod`.

**Architecture baseline:** Coursefinder Architecture v2.8.1.

---

# 1. Physical design principles

1. Canonical write models are normalised.
2. Search/API read models are deliberately denormalised and rebuildable.
3. Business schemas are not directly browser-exposed.
4. Stable UUID primary keys are paired with immutable interchange keys/codes.
5. Names are display data, never identity.
6. Temporal facts use validity/effective dates instead of destructive overwrite where history matters.
7. Provenance/evidence is first-class.
8. Controlled vocabularies use foreign keys where globally meaningful.
9. Configurable PIM attributes are used for long-tail fields, not to replace strong relational entities such as fees, intakes, registrations, rankings or scholarships.
10. UX supports family-driven forms, attribute groups, options, category trees, bulk actions and completeness without making those UI constructs the database's only organising principle.

---

# 2. PostgreSQL schemas

| Schema | Purpose |
|---|---|
| `ref` | Global controlled reference data |
| `catalogue` | Providers, campuses, course collections, courses and structured course facts |
| `pim` | Families, groups, attributes, options, aliases, categories, values, completeness |
| `scholarship` | Scholarships, scopes, criteria, awards and coverage |
| `integration` | Scraper, LLM, model, router and external-consumer definitions |
| `pipeline` | Sources, policies, schedules, jobs, evidence and lineage |
| `search` | Search profiles, documents, embeddings and index state |
| `publishing` | Channels, locales and publication state |
| `workflow` | Review, suggestions, import/export jobs and row-level errors |
| `security` | Application roles and permission assignments |
| `api` | Deliberately exposed views/RPC functions only |

The `public` schema should contain extensions and only unavoidable framework objects, not canonical catalogue tables.

---

# 3. Shared conventions

## Keys

- Primary canonical entities: `id uuid primary key default gen_random_uuid()`.
- Stable interchange key: `stable_key text not null unique`.
- Controlled references: short immutable `code text unique` plus UUID where relationships benefit from UUID keys.

## Status fields

Use controlled values rather than arbitrary free text. Where change frequency is low, PostgreSQL check constraints are preferred over database enums to keep migrations simpler.

Common lifecycle values:
- `draft`
- `active`
- `inactive`
- `archived`
- `superseded`

Common publication values:
- `unpublished`
- `internal`
- `published`
- `withdrawn`

## Audit fields

Canonical/configuration tables should normally include:
- `created_at timestamptz not null default now()`
- `updated_at timestamptz not null default now()`
- optional `created_by uuid`
- optional `updated_by uuid`

---

# 4. Reference schema

## `ref.regions`

- `id uuid PK`
- `code text UNIQUE NOT NULL` — UN M49 or internal stable code
- `name text NOT NULL`
- `region_type text NOT NULL` — world/region/subregion/intermediate_region
- `parent_id uuid FK ref.regions(id)`
- `display_order int default 0`
- `status text default 'active'`

Indexes: `parent_id`, `(region_type,status)`.

## `ref.countries`

- `id uuid PK`
- `iso_alpha2 char(2) UNIQUE NOT NULL`
- `iso_alpha3 char(3) UNIQUE NOT NULL`
- `iso_numeric char(3)`
- `name text NOT NULL`
- `official_name text`
- `region_id uuid FK ref.regions`
- `subregion_id uuid FK ref.regions`
- `default_currency_code char(3)`
- `default_locale text`
- `catalogue_status text NOT NULL default 'seed_only'`
- `student_search_enabled boolean default false`
- `provider_ingestion_enabled boolean default false`
- `course_ingestion_enabled boolean default false`
- `scholarship_ingestion_enabled boolean default false`
- `valid_from date`
- `valid_to date`
- timestamps

Indexes: `(catalogue_status)`, `(region_id)`, `(subregion_id)`.

## `ref.subdivisions`

- `id uuid PK`
- `country_id uuid FK ref.countries NOT NULL`
- `code text UNIQUE NOT NULL` — e.g. AU-VIC
- `name text NOT NULL`
- `subdivision_type text`
- `parent_id uuid FK ref.subdivisions`
- `status text default 'active'`
- timestamps

Indexes: `(country_id,name)`, `parent_id`.

## `ref.currencies`
- `code char(3) PK`
- `name text`
- `numeric_code char(3)`
- `minor_unit smallint`
- `status text`

## `ref.languages`
- `code text PK`
- `name text`
- `status text`

## `ref.study_levels`
- `id uuid PK`
- `code text UNIQUE`
- `name text`
- `parent_id uuid FK ref.study_levels`
- `sort_order int`
- `status text`

## `ref.fields_of_study`
- `id uuid PK`
- `code text UNIQUE NOT NULL`
- `name text NOT NULL`
- `parent_id uuid FK ref.fields_of_study`
- `path text`
- `depth smallint`
- `status text`
- timestamps

Indexes: `parent_id`, `lower(name)` trigram/GIN if enabled.

## `ref.provider_types`
- `id uuid PK`
- `code text UNIQUE`
- `name text`
- `description text`
- `status text`

## `ref.english_tests`
- `id uuid PK`
- `code text UNIQUE`
- `name text`
- `score_scale jsonb`
- `status text`

## `ref.institution_collections`
- `id uuid PK`
- `code text UNIQUE NOT NULL`
- `name text NOT NULL`
- `collection_type text NOT NULL`
- `scope_type text NOT NULL`
- `country_id uuid FK ref.countries`
- `region_id uuid FK ref.regions`
- `official_url text`
- `description text`
- `status text`
- timestamps

## `ref.ranking_sources`
- `id uuid PK`
- `code text UNIQUE`
- `name text`
- `ranking_type text`
- `publisher_name text`
- `source_url text`
- `licence_status text`
- `licence_notes text`
- `status text`
- timestamps

---

# 5. PIM schema

## `pim.attribute_families`

- `id uuid PK`
- `code text UNIQUE NOT NULL`
- `name text NOT NULL`
- `entity_type text NOT NULL`
- `description text`
- `is_default boolean default false`
- `status text`
- timestamps

## `pim.attribute_groups`

- `id uuid PK`
- `code text UNIQUE NOT NULL`
- `name text NOT NULL`
- `entity_type text NOT NULL`
- `description text`
- `display_order int default 0`
- `status text`
- timestamps

## `pim.family_groups`

- `family_id uuid FK pim.attribute_families`
- `group_id uuid FK pim.attribute_groups`
- `display_order int`
- `is_collapsed_default boolean default false`
- PK `(family_id,group_id)`

This directly supports family-driven product/course edit UX.

## `pim.attribute_definitions`

- `id uuid PK`
- `code text UNIQUE NOT NULL`
- `name text NOT NULL`
- `entity_type text NOT NULL`
- `group_id uuid FK pim.attribute_groups`
- `data_type text NOT NULL` — text/number/boolean/date/datetime/url/richtext/select/multiselect/reference/json
- `unit_code text`
- `validation_rules jsonb default '{}'`
- `is_required_default boolean default false`
- `is_unique boolean default false`
- `is_filterable boolean default false`
- `is_searchable boolean default false`
- `include_in_vector boolean default false`
- `vector_weight numeric(5,2) default 1`
- `is_localisable boolean default false`
- `is_channel_scoped boolean default false`
- `is_multivalue boolean default false`
- `is_bulk_editable boolean default true`
- `display_order int default 0`
- `status text`
- timestamps

Indexes: `(entity_type,status)`, `group_id`, `(is_filterable) where true`, `(include_in_vector) where true`.

## `pim.family_attributes`

Makes required/display behaviour family-specific rather than relying only on the attribute default.

- `family_id uuid FK pim.attribute_families`
- `attribute_id uuid FK pim.attribute_definitions`
- `is_required boolean`
- `is_visible boolean default true`
- `display_order int`
- `validation_override jsonb default '{}'`
- PK `(family_id,attribute_id)`

## `pim.attribute_options`

- `id uuid PK`
- `attribute_id uuid FK pim.attribute_definitions NOT NULL`
- `code text NOT NULL`
- `label text NOT NULL`
- `locale text`
- `metadata jsonb default '{}'`
- `display_order int default 0`
- `status text`
- UNIQUE `(attribute_id,code,coalesce(locale,''))`

Supports managed options/features in admin UX.

## `pim.attribute_aliases`

- `id uuid PK`
- `attribute_id uuid FK pim.attribute_definitions`
- `provider_id uuid nullable` — logical FK added after catalogue provider creation or enforced through bridge migration
- `alias text NOT NULL`
- `alias_kind text`
- `normalisation_hint jsonb`
- `status text`
- timestamps

## `pim.categories`

- `id uuid PK`
- `code text UNIQUE NOT NULL`
- `name text NOT NULL`
- `category_type text NOT NULL`
- `parent_id uuid FK pim.categories`
- `path text`
- `depth smallint`
- `description text`
- `display_order int`
- `status text`
- timestamps

Indexes: `parent_id`, `(category_type,status)`, trigram on name if enabled.

## `pim.entity_registry`

- `id uuid PK`
- `entity_type text NOT NULL`
- `stable_key text UNIQUE NOT NULL`
- `family_id uuid FK pim.attribute_families`
- `lifecycle_status text`
- timestamps

Purpose: preserves FK integrity for generic PIM values/categories/publication/evidence relationships.

## `pim.attribute_values`

- `id uuid PK`
- `entity_id uuid FK pim.entity_registry NOT NULL`
- `attribute_id uuid FK pim.attribute_definitions NOT NULL`
- typed value columns: `value_text`, `value_number`, `value_boolean`, `value_date`, `value_datetime`, `value_code`, `value_json`
- `locale text`
- `channel_code text`
- `position int default 0`
- `source_id uuid`
- `evidence_id uuid`
- `confidence numeric(5,4)`
- `review_status text`
- `is_preferred boolean default true`
- `valid_from date`
- `valid_to date`
- timestamps

Constraint: exactly one value representation should be populated for scalar values.

Indexes: `(entity_id,attribute_id)`, `(attribute_id,value_code)`, `(attribute_id,value_number)`, partial preferred-value index.

## `pim.entity_categories`

- `entity_id uuid FK pim.entity_registry`
- `category_id uuid FK pim.categories`
- `is_primary boolean default false`
- `display_order int default 0`
- PK `(entity_id,category_id)`

## `pim.completeness_profiles`

- `id uuid PK`
- `code text UNIQUE`
- `name text`
- `entity_type text`
- `family_id uuid FK pim.attribute_families`
- `country_id uuid FK ref.countries`
- `channel_code text`
- `minimum_publish_score numeric(5,2)`
- `status text`
- timestamps

## `pim.completeness_requirements`

- `profile_id uuid FK pim.completeness_profiles`
- `attribute_id uuid FK pim.attribute_definitions nullable`
- `requirement_code text` — can point to structural facts such as fee/intake/registration/scholarship coverage
- `weight numeric(6,3) default 1`
- `is_mandatory boolean default false`
- `rule jsonb default '{}'`
- PK synthetic UUID or composite unique `(profile_id,attribute_id,requirement_code)`

---

# 6. Catalogue schema

## `catalogue.providers`

Consumer/display fields:
- `canonical_name text NOT NULL`
- `display_name text`
- `short_name text`
- `website text`
- `description text`
- `primary_city text`
- `address_line1 text`
- `address_line2 text`
- `postcode text`
- `latitude numeric(9,6)`
- `longitude numeric(9,6)`
- `phone text`
- `email text`
- `logo_url text`
- `established_year smallint`

Logical fields:
- `id uuid PK/FK pim.entity_registry(id)`
- `stable_key text UNIQUE NOT NULL`
- `country_id uuid FK ref.countries NOT NULL`
- `subdivision_id uuid FK ref.subdivisions`
- `provider_type_id uuid FK ref.provider_types`
- `lifecycle_status text`
- `publication_status text`
- `canonical_source_id uuid`
- `last_verified_at timestamptz`
- timestamps

Indexes: `(country_id,publication_status)`, `(provider_type_id)`, trigram/search index on canonical/display name.

## `catalogue.provider_identifiers`

- `id uuid PK`
- `provider_id uuid FK catalogue.providers`
- `scheme text NOT NULL`
- `identifier text NOT NULL`
- `country_id uuid FK ref.countries`
- `issuing_authority text`
- `is_primary boolean`
- `valid_from date`
- `valid_to date`
- `source_id uuid`
- `evidence_id uuid`
- `verified_at timestamptz`
- UNIQUE `(scheme,identifier)` where globally unique; otherwise enforce through scheme+country.

## `catalogue.provider_aliases`
- `id uuid PK`
- `provider_id uuid FK catalogue.providers`
- `alias text`
- `alias_type text`
- `locale text`
- `valid_from date`
- `valid_to date`
- `source_id uuid`

## `catalogue.campuses`

Display fields:
- `name text NOT NULL`
- `campus_code text`
- `city text`
- address/postcode/lat/long/phone/website

Logical:
- `id uuid PK`
- `stable_key text UNIQUE`
- `provider_id uuid FK catalogue.providers`
- `country_id uuid FK ref.countries`
- `subdivision_id uuid FK ref.subdivisions`
- `status text`
- `publication_status text`
- validity/timestamps

Indexes: `(provider_id,status)`, `(country_id,subdivision_id,city)`.

## `catalogue.provider_registrations`

- `id uuid PK`
- `provider_id uuid FK catalogue.providers`
- `source_id uuid`
- `registration_scheme text`
- `registration_code text`
- `provider_classification text`
- `status text`
- `valid_from date`
- `valid_to date`
- `checked_at timestamptz`
- `evidence_id uuid`
- UNIQUE `(registration_scheme,registration_code,provider_id)`

## `catalogue.provider_collection_memberships`

- `id uuid PK`
- `provider_id uuid FK catalogue.providers`
- `collection_id uuid FK ref.institution_collections`
- `membership_type text`
- `status text`
- `valid_from date`
- `valid_to date`
- `source_id uuid`
- `evidence_id uuid`
- `verified_at timestamptz`
- UNIQUE `(provider_id,collection_id,valid_from)`

## `catalogue.provider_rankings`

- `id uuid PK`
- `provider_id uuid FK catalogue.providers`
- `ranking_source_id uuid FK ref.ranking_sources`
- `ranking_year int`
- `subject_field_id uuid FK ref.fields_of_study`
- `rank_exact int`
- `rank_band_min int`
- `rank_band_max int`
- `percentile numeric(6,3)`
- `score numeric`
- `display_label text`
- `source_id uuid`
- `evidence_id uuid`
- `retrieved_at timestamptz`
- UNIQUE `(provider_id,ranking_source_id,ranking_year,coalesce(subject_field_id,'00000000-0000-0000-0000-000000000000'))`

## `catalogue.course_collections`

Provider-native academic/programme groupings.

- `id uuid PK`
- `stable_key text UNIQUE NOT NULL`
- `provider_id uuid FK catalogue.providers NOT NULL`
- `parent_id uuid FK catalogue.course_collections`
- `name text NOT NULL`
- `code text`
- `description text`
- `source_url text`
- `collection_type text default 'provider_programme_group'`
- `display_order int`
- `status text`
- `valid_from date`
- `valid_to date`
- `source_id uuid`
- `evidence_id uuid`
- timestamps

Indexes: `(provider_id,parent_id)`, `(provider_id,status)`.

## `catalogue.courses`

Core display fields:
- `canonical_title text NOT NULL`
- `display_title text`
- `provider_course_code text`
- `summary text`
- `description text`
- `duration_value numeric`
- `duration_unit text`
- `credits numeric`
- `credit_unit text`
- `delivery_mode_code text`
- `study_load_code text`
- `official_url text`
- `application_url text`

Logical fields:
- `id uuid PK/FK pim.entity_registry`
- `stable_key text UNIQUE NOT NULL`
- `provider_id uuid FK catalogue.providers NOT NULL`
- `primary_campus_id uuid FK catalogue.campuses`
- `study_level_id uuid FK ref.study_levels`
- `primary_field_id uuid FK ref.fields_of_study`
- `lifecycle_status text`
- `publication_status text`
- `canonical_source_id uuid`
- `last_verified_at timestamptz`
- timestamps

Do not store embeddings here.

Indexes:
- `(provider_id,publication_status)`
- `(study_level_id,primary_field_id)`
- `(lifecycle_status)`
- trigram/FTS as appropriate for canonical title.

Course uniqueness must not depend only on provider+title. Prefer stable_key sourced from authoritative registration/code where possible, with deduplication rules outside a simplistic unique constraint.

## `catalogue.course_collection_memberships`

- `collection_id uuid FK catalogue.course_collections`
- `course_id uuid FK catalogue.courses`
- `relationship_type text default 'member'`
- `is_primary boolean default false`
- `display_order int default 0`
- `source_id uuid`
- `evidence_id uuid`
- PK `(collection_id,course_id)`

## `catalogue.course_campuses`

- `course_id uuid FK catalogue.courses`
- `campus_id uuid FK catalogue.campuses`
- `delivery_notes text`
- `is_primary boolean`
- PK `(course_id,campus_id)`

## `catalogue.course_registrations`

- `id uuid PK`
- `course_id uuid FK catalogue.courses`
- `registration_scheme text`
- `registration_code text`
- `campus_id uuid FK catalogue.campuses`
- `status text`
- `valid_from date`
- `valid_to date`
- `source_id uuid`
- `evidence_id uuid`
- `checked_at timestamptz`
- UNIQUE `(registration_scheme,registration_code,course_id,coalesce(campus_id,'00000000-0000-0000-0000-000000000000'))`

## `catalogue.course_fees`

- `id uuid PK`
- `course_id uuid FK catalogue.courses`
- `academic_year int`
- `fee_type text`
- `student_type text` — international/domestic/etc.
- `amount_min numeric(14,2)`
- `amount_max numeric(14,2)`
- `currency_code char(3) FK ref.currencies`
- `billing_period text`
- `indicative boolean`
- `valid_from date`
- `valid_to date`
- `source_id uuid`
- `evidence_id uuid`
- `fetched_at timestamptz`

Indexes: `(course_id,academic_year desc)`, `(currency_code,amount_min)`.

## `catalogue.course_intakes`

- `id uuid PK`
- `course_id uuid FK catalogue.courses`
- `campus_id uuid FK catalogue.campuses`
- `intake_date date`
- `intake_label text`
- `application_deadline date`
- `status text`
- `source_id uuid`
- `evidence_id uuid`
- `fetched_at timestamptz`

Indexes: `(course_id,intake_date)`, `(status,intake_date)`.

## `catalogue.english_requirements`

- `id uuid PK`
- `course_id uuid FK catalogue.courses`
- `provider_id uuid FK catalogue.providers`
- `test_id uuid FK ref.english_tests`
- `overall_min numeric`
- `listening_min numeric`
- `reading_min numeric`
- `writing_min numeric`
- `speaking_min numeric`
- `notes text`
- `is_provider_default boolean`
- `source_id uuid`
- `evidence_id uuid`
- validity/timestamps

Rule: exactly one of course_id/provider_id may be present unless explicit inheritance model needs both.

## `catalogue.course_associations`

- `id uuid PK`
- `source_course_id uuid FK catalogue.courses`
- `target_course_id uuid FK catalogue.courses`
- `association_type text` — related/pathway/articulation/successor/predecessor/nested_award
- `directional boolean`
- `notes text`
- `source_id uuid`
- `evidence_id uuid`
- UNIQUE `(source_course_id,target_course_id,association_type)`

---

# 7. Scholarship schema

## `scholarship.scholarships`

- `id uuid PK/FK pim.entity_registry`
- `stable_key text UNIQUE`
- `provider_id uuid FK catalogue.providers nullable` — external/government scholarships may not belong to one provider
- `canonical_name text NOT NULL`
- `display_name text`
- `description text`
- `scholarship_type_code text`
- `academic_year int`
- `application_mode text`
- `application_url text`
- `deadline date`
- `deadline_text text`
- `renewable boolean`
- `renewal_conditions text`
- `international_only boolean`
- `status text`
- `publication_status text`
- `valid_from date`
- `valid_to date`
- `source_id uuid`
- `evidence_id uuid`
- `confidence numeric(5,4)`
- `last_verified_at timestamptz`
- `next_review_at timestamptz`
- timestamps

## `scholarship.award_tiers`

- `id uuid PK`
- `scholarship_id uuid FK scholarship.scholarships`
- `tier_name text`
- `value_type text`
- `amount_min numeric`
- `amount_max numeric`
- `percentage_min numeric`
- `percentage_max numeric`
- `currency_code char(3)`
- `period text`
- `conditions_text text`
- `display_order int`

## `scholarship.scopes`

Structured scope table instead of free-text-only scope.

- `id uuid PK`
- `scholarship_id uuid FK`
- `scope_type text` — provider/course/course_collection/category/study_level/country/campus/all_courses
- typed FK columns nullable: `provider_id`, `course_id`, `course_collection_id`, `category_id`, `study_level_id`, `country_id`
- `include_exclude text default 'include'`
- `source_text text`
- `source_id uuid`
- `evidence_id uuid`
- `confidence numeric(5,4)`

Constraint: exactly one typed target appropriate to scope_type.

## `scholarship.criteria`

- `id uuid PK`
- `scholarship_id uuid FK`
- `criteria_group text`
- `criteria_type text`
- `metric_code text`
- `operator text`
- typed values: `value_number`, `value_code`, `value_text`, `value_json`
- `unit text`
- `mandatory boolean default true`
- `source_text text`
- `source_id uuid`
- `evidence_id uuid`
- `confidence numeric(5,4)`
- `review_status text`
- timestamps

Indexes on `(scholarship_id)`, `(criteria_type,metric_code,operator,value_number,value_code)`.

## `scholarship.course_links`

- `course_id uuid FK catalogue.courses`
- `scholarship_id uuid FK scholarship.scholarships`
- `relationship_type text`
- `eligibility_status text`
- `source_id uuid`
- `evidence_id uuid`
- `confidence numeric(5,4)`
- `valid_from date`
- `valid_to date`
- `verified_at timestamptz`
- PK `(course_id,scholarship_id)`

## `scholarship.coverage`

- `id uuid PK`
- `provider_id uuid FK catalogue.providers`
- `course_id uuid FK catalogue.courses`
- `status text` — available/verified_none/unknown/needs_review
- `source_id uuid`
- `evidence_id uuid`
- `verified_at timestamptz`
- `next_review_at timestamptz`
- `notes text`

Unique provider-level and course-level coverage enforced using partial unique indexes.

---

# 8. Integration and pipeline schemas

## `integration.scraper_providers`
- id/code/name/adapter_type
- capability flags JSONB
- secret_reference text
- health_status
- cost_model JSONB
- enabled
- timestamps

## `integration.llm_providers`
- id/code/name/adapter_type
- endpoint_class
- secret_reference
- capabilities JSONB
- health_status
- enabled

## `integration.llm_routers`
- id/code/name/adapter_type
- secret_reference
- capabilities JSONB
- health_status
- enabled

## `integration.model_profiles`
- `id uuid PK`
- `code text UNIQUE`
- `purpose text`
- either provider_id or router_id
- `model_identifier text`
- `settings jsonb`
- `cost_limits jsonb`
- `fallback_profile_id uuid self FK`
- `status text`
- `version int`

## `integration.extraction_profiles`
- id/code/entity_type/family_id
- prompt/template/schema version references
- output schema JSONB
- confidence thresholds
- evidence requirements
- validator version
- status/version

## `pipeline.sources`

Canonical source registry:
- id/code/name/source_type/layer
- base_url
- country_id
- regulator/institution/provider scope
- adapter reference
- trust_priority
- active
- timestamps

## `pipeline.acquisition_policies`

- id/code/name
- scope_type global/country/provider/domain
- country_id/provider_id/domain_pattern
- primary_scraper_id
- fallback_scraper_ids jsonb or child table
- concurrency/rate/retry/timeout settings
- evidence_capture requirements
- revisit interval
- priority
- status/version

Prefer child table `pipeline.acquisition_policy_steps` for ordered scraper fallbacks if operational querying becomes important.

## `pipeline.routing_policies`
- id/code/name/purpose
- extraction_profile_id
- primary_model_profile_id
- fallback chain via child table
- retry rules
- confidence threshold
- cost ceiling
- status/version

## `pipeline.schedules`
- id/code/job_kind/policy_id/schedule expression/timezone/enabled
- scope jsonb
- next_run_at/last_run_at

## `pipeline.jobs`
- id uuid PK
- parent_job_id/retry_of_job_id
- job_kind/layer/status
- source_id
- acquisition_policy_id/routing_policy_id/model_profile_id
- scope jsonb
- counters jsonb
- cost_usage jsonb
- idempotency_key UNIQUE
- started/completed timestamps
- error_code/error_message
- created_at

Indexes: status+created_at, source, policy, parent job.

## `pipeline.evidence_artifacts`
- id uuid PK
- source_id/job_id
- url/url_hash/content_hash
- artifact_type/mime_type
- private storage bucket/path
- content_text optional
- HTTP/fetch metadata
- fetched_at
- valid_from/valid_to
- supersedes_evidence_id self FK
- metadata jsonb

## `pipeline.entity_evidence`

- `entity_id uuid FK pim.entity_registry`
- `evidence_id uuid FK pipeline.evidence_artifacts`
- `relationship_type text`
- `attribute_id uuid FK pim.attribute_definitions nullable`
- `is_primary boolean`
- PK `(entity_id,evidence_id,coalesce(attribute_id,...),relationship_type)` — implement with surrogate id if needed for nullable uniqueness.

---

# 9. Search schema

## `search.profiles`

- id/code/name
- entity_type/family_id/channel_code
- lexical_fields config JSONB
- vector_fields config JSONB
- filter_fields config JSONB
- ranking_weights JSONB
- version int
- active boolean
- timestamps

## `search.documents`

One row per entity/search profile/version, primarily courses and scholarships.

- `id uuid PK`
- `entity_id uuid FK pim.entity_registry`
- `search_profile_id uuid FK search.profiles`
- `profile_version int`
- `content_hash text`
- `display_title text`
- `search_text text`
- `search_tsv tsvector`
- denormalised filter columns for hot dimensions: country_id, provider_id, study_level_id, primary_field_id, fee_min, fee_currency, duration_days/equivalent, IELTS/PTE thresholds, next intake, scholarship status, publication status, completeness score, freshness score
- arrays/JSONB for less-hot facets: category_ids, course_collection_ids, institution_collection_ids, ranking features
- `is_stale boolean`
- timestamps

Indexes:
- GIN `search_tsv`
- btree hot filters
- GIN on category/collection arrays where used.

## `search.embeddings`

- `id uuid PK`
- `search_document_id uuid FK search.documents`
- `model_profile_id uuid FK integration.model_profiles`
- `model_identifier text`
- `dimensions int`
- `embedding vector(N)` — N fixed per active index table/profile
- `content_hash text`
- `generated_at timestamptz`
- `status text`
- UNIQUE `(search_document_id,model_profile_id,content_hash)`

### Vector indexing

Create HNSW cosine index for the active production embedding model/profile. If multiple dimensions/models must coexist, use separate embedding tables or profile-specific physical tables rather than one unconstrained generic vector dimension.

Do not copy old prototype embeddings blindly; regenerate from v2.9 Search Profiles.

---

# 10. Publishing schema

## `publishing.channels`
- code PK/name/audience/status

Initial codes:
- `internal_pim`
- `counsellor`
- `student_web`
- `api`

## `publishing.locales`
- code PK/name/language/country/status

## `publishing.entity_publications`
- entity_id FK pim.entity_registry
- channel_code FK publishing.channels
- locale_code nullable
- publication_status
- completeness_profile_id
- published_at/withdrawn_at
- PK `(entity_id,channel_code,coalesce(locale_code,''))` implemented with surrogate ID + unique expression where required.

---

# 11. Workflow schema

## `workflow.review_queue`

- id/entity_id/review_type/reason/priority/status
- proposed_changes/current_values JSONB
- evidence_id
- source_layer
- assigned_to/assigned_at/due_at
- decision/resolution_payload
- reviewed_by/reviewed_at
- created_at/updated_at

## `workflow.review_actions`
- id/review_id/action/actor_id/payload/notes/created_at

## `workflow.catalogue_suggestions`
- id/channel/submitted_by_user_id/source_channel_ref
- entity_type/entity_id/suggestion_type
- proposed_values/source_url/notes
- status/review_id
- triaged_by/triaged_at
- timestamps

## `workflow.import_jobs`
- id/template_code/template_version
- file_name/storage_path/file_hash
- entity_scope
- mode insert/update/upsert/validate_only
- status
- counts JSONB
- initiated_by
- started/completed timestamps

## `workflow.import_rows`
- id/import_job_id/row_number
- source_key
- raw_data jsonb
- normalized_data jsonb
- validation_status
- validation_errors jsonb
- action_planned
- target_entity_id
- committed_at

Indexes: `(import_job_id,row_number)`, validation status.

## `workflow.export_jobs`
- id/export_profile_id/filters/status/storage_path/file_format/counts/initiated_by/timestamps

## `workflow.export_profiles`
- id/code/name/entity_scope
- field_mapping jsonb
- include_relationships jsonb
- default_format
- status/version

---

# 12. Security schema

## `security.roles`

Seed:
- platform_admin
- pim_admin
- pipeline_operator
- curator
- counsellor
- viewer

Fields: code/name/description/rank/status.

## `security.permissions`

Action-based codes, e.g.:
- catalogue.provider.read/write
- catalogue.course.read/write/bulk
- pim.model.read/write
- pipeline.execute.layer1/2/3
- pipeline.config.read/write
- review.resolve
- search.config.write
- import.execute
- export.execute
- admin.users.manage

## `security.role_permissions`
- role_id/permission_id PK

## `security.user_roles`
- user_id auth.users reference
- role_id
- active
- valid_from/to
- assigned_by
- PK may allow multiple roles per user if desired; otherwise unique active role per user.

Server-side API/functions must enforce permissions; hidden menus are not authorization.

---

# 13. API schema contracts

Expose views/RPCs, not canonical tables.

Recommended initial API objects:

- `api.provider_catalogue_v1`
- `api.course_catalogue_v1`
- `api.course_detail_v1(course_key)` RPC or security-invoker view strategy
- `api.scholarship_catalogue_v1`
- `api.search_courses_v1(...)`
- `api.match_scholarships_v1(profile,course_key)`
- `api.reference_values_v1(type,country)`
- admin-specific RPCs for controlled writes/bulk operations.

Views exposed through the Data API must use `security_invoker = true` where supported, with grants/RLS matching the intended channel.

---

# 14. UX support mapping

The database directly supports the desired PIM-style admin experience:

| UX feature | Physical support |
|---|---|
| Family-driven course form | `attribute_families`, `family_groups`, `family_attributes` |
| Tabs/attribute groups | `attribute_groups`, display order |
| Select/multiselect options | `attribute_options` |
| Category tree | `pim.categories.parent_id/path/depth` |
| Provider course verticals | `course_collections` + memberships |
| Bulk edit | attribute metadata `is_bulk_editable` + controlled admin RPCs |
| Filterable product/course list | strong relational fields + `is_filterable` attributes + search projection |
| Completeness badges | completeness profiles/requirements + derived state |
| Publication/channel states | `publishing.entity_publications` |
| Evidence per field | `attribute_values.evidence_id` + entity evidence |
| Role-dependent actions | security roles/permissions |
| Import/export | workflow import/export subsystem |

---

# 15. Approximate physical table count

Target initial production baseline is approximately 55–65 base tables across all schemas, depending on whether some policy-step/fallback structures are normalised into child tables. This is appropriate because each table represents a distinct lifecycle/relationship; the public/search API remains simpler through projections.

The goal is not minimum table count. The goal is stable identity, integrity, explainability, efficient search and manageable administration.

---

# 16. Implementation order

1. Extensions and schemas.
2. `ref` tables and global seeds.
3. `security` roles/permissions.
4. PIM model tables.
5. Catalogue provider/campus/course tables.
6. Scholarship tables.
7. Integration/pipeline configuration.
8. Evidence/jobs/workflow.
9. Publishing.
10. Search profiles/documents/embeddings.
11. API views/RPCs.
12. RLS/grants.
13. Import/export templates.
14. Migration of validated data.
15. Rebuild completeness/search/embeddings.

---

# 17. Approval gate

This schema should be reviewed together with the v2.9 Seed Data, Import/Export, Security/API/Search, Migration Mapping and Review Checklist documents before creating `Coursefinder_Prod`.