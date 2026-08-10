# Coursefinder Current Database Assessment v2.8

**Status:** Architecture and migration assessment only. No schema or application changes are included in this document.

**Source system assessed:** Supabase project `coursefinder-demo` (`gfryvshbeptxwbzjomhe`)

**Target recommendation:** build a clean production Supabase project named `Coursefinder_Prod` after architecture sign-off, then migrate curated data into the new schema. Do **not** clone the existing database as the production baseline.

---

## 1. Executive assessment

The current database has a useful V2 foundation: canonical providers/courses, regulatory registrations, fees, intakes, scholarship entities, evidence, review workflow, PIM metadata, source tracking and a pgvector proof of concept. It is suitable as a **design/prototype source and migration source**, but it should not be promoted directly into production.

The main reason is structural rather than scale. The current project combines:

- canonical catalogue data;
- PIM metadata;
- demo/public read policies;
- pipeline configuration;
- operational jobs;
- evidence;
- search embeddings;
- review workflow;
- scholarship matching;
- consumer/demo views;

inside the exposed `public` schema.

The production design should keep the good entity decomposition but re-establish clear boundaries between **reference data, canonical catalogue, PIM metadata, enrichment/pipeline, search, publishing, integrations, workflow and API exposure**.

### Recommendation

Create `Coursefinder_Prod` as a **schema-first clean build** after approval of the v2.8 database architecture. Migrate only validated data and mapped identifiers from the current project. Regenerate derived search data and embeddings in the new project rather than copying the existing vector state blindly.

---

## 2. Current estate snapshot

Live assessment on 10 August 2026 found:

| Item | Current state |
|---|---:|
| Public base tables | 35 |
| Public views | 5 |
| Providers | 522 |
| Courses | 13,698 |
| Course registrations | ~14,476 |
| Course fees | ~12,782 |
| Course intakes | ~137 |
| Scholarships | 5 |
| Scholarship criteria | 7 |
| Evidence artefacts | ~19 |
| Review queue | ~27 |
| Courses with embeddings | 2,450 |
| Courses with meaningful description (>20 chars) | 2 |
| Distinct current `level_code` values | 10 |
| Distinct free-text `field_of_study` values | 297 |
| Countries in `ref_countries` | 7 |

Current provider counts are concentrated in GB and DE because of earlier demo/import work, while AU is the strongest active catalogue country. The current country table contains only seven rows and mixes geography with regulator/adapter configuration.

### Current geography table

`ref_countries` currently contains:

- `country_code`
- `name`
- `currency_code`
- `register_name`
- `register_url`
- `adapter_key`

This combines three responsibilities that should be separated in production:

1. stable geographic reference data;
2. regulatory source configuration;
3. ingestion adapter configuration.

---

## 3. Current table domains

### 3.1 Canonical catalogue

Current useful core tables:

- `providers`
- `provider_registrations`
- `courses`
- `course_registrations`
- `course_fees`
- `course_intakes`
- `english_requirements`

This is a strong starting decomposition, but identity and global-reference support are incomplete.

### 3.2 Scholarships

Current tables:

- `scholarships`
- `scholarship_award_tiers`
- `scholarship_scopes`
- `scholarship_criteria`
- `course_scholarships`
- `scholarship_coverage`

This is directionally correct. The production design should retain scholarships as first-class entities rather than converting them into generic course attributes.

### 3.3 PIM metadata

Current tables:

- `pim_attribute_families`
- `pim_attribute_groups`
- `pim_attribute_family_groups`
- `pim_attribute_definitions`
- `pim_attribute_options`
- `pim_attribute_aliases`
- `pim_categories`
- `pim_entity_categories`
- `pim_entity_family_assignments`
- `field_values`

The design captures sound PIM principles: entities have families, groups organise attributes, categories are separate from families, and source wording can map to canonical attributes through aliases.

The production model should refine this rather than discard it.

### 3.4 Pipeline, evidence and review

Current tables:

- `data_sources`
- `pipeline_config`
- `ingest_jobs`
- `ingest_change_log`
- `evidence_artifacts`
- `review_queue`
- `review_actions`
- `catalogue_suggestions`

The concepts are valid, but production needs stronger separation of integration definitions, routing policy, operational execution and secrets.

### 3.5 Current views

Current public views:

- `catalogue_stats`
- `course_completeness`
- `course_completeness_v2`
- `pim_review_queue_summary_v2_1`
- `scholarship_catalogue_v2`

These views are useful prototypes but currently mix presentation logic with hard-coded business logic.

---

## 4. Strengths to preserve

The new production design should preserve the following ideas.

### 4.1 UUID primary identities

UUIDs are appropriate internal record identities across distributed ingest and integration workflows.

### 4.2 Separate repeated facts from the course row

Fees, registrations and intakes are already separate tables. This is preferable to repeatedly adding `fee_2026`, `fee_2027`, `intake_1`, `intake_2` columns to `courses`.

### 4.3 Evidence/provenance

`evidence_artifacts` contains URL, content hash, fetched time, storage path, source and job lineage. This is a key production requirement and should be strengthened.

### 4.4 Human review model

The current review queue and review actions already separate uncertain machine output from canonical publication. This should remain the Layer 4 principle.

### 4.5 Scholarship decomposition

Award tiers, scopes and criteria are already separate from the scholarship master. This supports future deterministic matching.

### 4.6 Attribute aliases

Provider-specific terms mapped to global attributes are important to avoid creating one schema per university.

### 4.7 Source and job lineage

`source_id`, `source_layer`, confidence and evidence references are already present in many enrichment tables.

---

## 5. Production limitations and risks

## 5.1 Exposed-schema boundary is too broad

All current business tables are in `public`, which is the default exposed schema in Supabase deployments unless changed. Production should expose only deliberate API views/functions and keep canonical/internal tables in non-exposed schemas.

Supabase recommends enabling RLS on exposed tables and carefully controlling Data API access. Production should go further and reduce the number of internal tables exposed in the first place.

**Production direction:**

- internal schemas: `ref`, `catalogue`, `pim`, `scholarship`, `pipeline`, `integration`, `search`, `workflow`, `publishing`, `security`;
- exposed schema: `api` only;
- frontend reads through approved `api` views/RPCs;
- service operations use server-side Edge Functions or controlled database roles.

Reference: https://supabase.com/docs/guides/database/postgres/row-level-security

---

## 5.2 Demo RLS policies must not migrate

Current demo policies grant anonymous/public read access to several canonical/operational tables, including courses, fees, registrations, jobs and change logs.

More importantly, `pipeline_config` currently has anonymous SELECT, INSERT and UPDATE policies.

This is a production blocker.

**Production direction:**

- no browser access to pipeline secrets or operational integration configuration;
- no anonymous writes to configuration tables;
- configuration mutations require `platform_admin`/authorised roles and server-side validation;
- public website receives a curated search API, not direct table access.

---

## 5.3 Country data is not a global reference model

The current seven-country table is an ingestion configuration table disguised as geography.

It does not provide:

- ISO alpha-3;
- ISO numeric code;
- UN M49 region/subregion;
- subdivisions/states/provinces;
- activation state independent from reference state;
- temporal validity;
- alternate names.

**Production direction:** seed global geography from ISO 3166 and UN M49, then separately configure which countries are active for catalogue ingestion.

References:

- https://www.iso.org/iso-3166-country-codes.html
- https://unstats.un.org/unsd/methodology/m49/

---

## 5.4 Provider identity is too name-dependent

Current provider uniqueness is:

`(country_code, canonical_name)`

This is fragile because institution names can change, merge, rebrand or have multiple legal/trading names.

The current provider table also lacks a global identifier crosswalk.

**Production direction:** introduce:

- canonical `provider_id` UUID;
- stable Coursefinder `provider_key`;
- provider aliases/names with validity;
- external identifiers table (`CRICOS`, `TEQSA`, `NZQA`, `ROR`, future US/Canada/Europe identifiers);
- separate campuses;
- institution collections/memberships;
- rankings as time-series records.

---

## 5.5 Course identity is too title-dependent

Current course uniqueness is:

`(provider_id, canonical_title)`

This will fail when a provider offers the same named award at multiple campuses, in multiple delivery modes or under multiple official codes.

It also creates rename problems.

**Production direction:** separate:

- internal UUID;
- stable Coursefinder `course_key`;
- provider course code where available;
- registration identifiers;
- title history/aliases where needed;
- campus/delivery relationships;
- course lifecycle/publication state.

A title should be display data, not identity.

---

## 5.6 `field_of_study` is uncontrolled free text

There are currently 297 distinct `field_of_study` values across 13,698 courses.

This is unsuitable for reliable global filtering and scholarship scoping because equivalent fields can be expressed differently.

**Production direction:**

- controlled hierarchical field-of-study taxonomy;
- many-to-many course-category relationship;
- optional source-specific labels retained as evidence/aliases;
- one primary field plus optional secondary fields;
- taxonomy codes used for filtering; human labels used for UI.

---

## 5.7 Family assignment is not constrained to one primary family

`pim_entity_family_assignments` allows an entity to be assigned to multiple families.

The desired production principle is one **primary structural family** per entity. Categories handle additional classification.

**Production direction:** enforce one active primary family per entity, either directly on the entity registry or through a unique entity-family assignment.

---

## 5.8 Generic PIM relationships can orphan records

Tables such as `field_values`, `pim_entity_categories` and `pim_entity_family_assignments` use `(entity_type, entity_id)` polymorphic references. PostgreSQL cannot enforce a normal foreign key from one `entity_id` column to several possible entity tables.

That creates orphan-risk.

**Production direction:** introduce a lightweight `pim.entity_registry` supertype table. Providers, courses and scholarships register their entity UUID there. Generic PIM relationships then foreign-key to `entity_registry.id`.

This retains flexibility while restoring referential integrity.

---

## 5.9 Attribute family/group relationship needs clearer applicability

Current attributes belong to groups, and families contain groups. This can unintentionally make every attribute in a group applicable to every family that includes that group.

Production should support family-specific attribute requirements.

**Production direction:** introduce `family_attributes` with:

- family_id;
- attribute_id;
- requiredness override;
- display order;
- completeness weight;
- publication requirement;
- optional search-profile defaults.

Groups remain UI organisation; family-attribute mapping determines actual applicability.

---

## 5.10 Completeness is hard-coded

Current `course_completeness` computes six fixed checks:

- registration;
- structure;
- fee;
- intake;
- English;
- description.

`course_completeness_v2` adds scholarship status as a seventh fixed check.

This is not sufficient for multiple course families, countries or publication channels.

**Production direction:** completeness becomes configuration:

`Entity Family + Country/Regime + Channel -> Completeness Profile -> Required Fields -> Score`

A Higher Education course intended for the public/student channel can have different requirements from an ELICOS record or an internal-only catalogue record.

---

## 5.11 Current search vector design is proof-of-concept only

`courses.embedding` stores the embedding directly on the course row.

Current state:

- 13,698 courses;
- 2,450 have an embedding;
- no HNSW or IVFFlat index exists on `courses.embedding`;
- current `match_courses` performs only vector distance ordering;
- no structured filters are applied inside the vector search;
- no search-profile version is stored;
- no embedding model/version is stored;
- no content hash links an embedding to the exact source projection;
- no stale/rebuild state is present.

This is a significant future-scaling limitation.

Supabase documents pgvector vector similarity and notes that approximate indexes plus filters require careful iterative search behaviour to return the desired filtered result count.

Reference: https://supabase.com/docs/guides/database/extensions/pgvector

**Production direction:** embeddings are derived search artefacts in a dedicated `search` schema, versioned by:

- entity_id;
- search_profile_version;
- embedding model profile;
- content hash;
- dimensions;
- generated_at;
- stale state.

Public search uses hybrid retrieval:

1. structured eligibility/filter criteria;
2. text/category matching;
3. pgvector semantic retrieval;
4. deterministic ranking/boost signals;
5. scholarship matching after candidate retrieval.

---

## 5.12 No vector ANN index currently exists

The current index inventory contains no HNSW or IVFFlat index on the course embedding.

At 2,450 embedded records this may still perform acceptably, but it should not be the production design for tens or hundreds of thousands of programmes.

**Production direction:** create the vector index only after the target embedding model/dimension and search profile are fixed. Do not create an index around the current proof-of-concept vector shape and then make that choice permanent.

---

## 5.13 Search and canonical data are too tightly coupled

Search should be disposable/rebuildable. Canonical catalogue data should not depend on a specific embedding model.

**Production direction:** canonical tables -> governed search projection -> search document -> embedding.

A search model change should require re-indexing, not a migration of canonical course records.

---

## 5.14 Scholarships contain transitional schema debt

The current `scholarships` table has 40 columns and contains both earlier single-value fields (`value_amount`, `value_percent`) and newer min/max/period/text fields plus award-tier support.

This indicates iterative prototype growth.

**Production direction:** simplify the scholarship master to identity, descriptive, lifecycle and application data. Keep repeating/variable award structures in `scholarship_award_tiers`; scopes and criteria remain separate.

---

## 5.15 Scholarship scope fields are still partially untyped

`scholarship_scopes` currently uses `scope_type` plus text/JSON values.

This is flexible but weak for deterministic filtering and referential integrity.

**Production direction:** retain a generic scope rule record, but add typed nullable FKs for common dimensions such as:

- provider_id;
- course_id;
- category_id;
- study_level_code;
- country_code;
- institution_collection_id.

Use JSON only for uncommon/extensible rule payloads.

---

## 5.16 Student profile ownership belongs outside the PIM

Current `student_profiles` is useful for matcher development, but the agreed commercial architecture places customer/student master data and customer-specific university preference in Zoho CRM/Creator.

**Production direction:** do not make the Coursefinder PIM the student CRM.

Use one of:

- stateless search/matcher request payloads;
- short-lived pseudonymous search sessions;
- controlled UAT/test profiles;
- external CRM reference IDs when necessary.

Do not duplicate sensitive customer records without a clear functional requirement.

---

## 5.17 Evidence raw content should not grow unbounded inside Postgres

`evidence_artifacts` currently supports both object storage references and `content_text` in the table.

As evidence volume grows, raw HTML/PDF/screenshots should remain in private Storage. Postgres should store metadata, hashes, extracted/normalised text required for downstream processing and short previews, not every raw binary or indefinitely large document body.

---

## 5.18 Integration configuration is insufficiently modelled

`pipeline_config(key,value jsonb)` is too generic to support production-grade multiple scrapers, multiple LLM providers, aggregators, fallbacks, health, costs and provider overrides.

`data_sources.config` has similar flexibility but cannot become the entire integration model.

**Production direction:** explicit configuration registries for:

- scraper providers/profiles;
- LLM providers;
- LLM routers/aggregators;
- model profiles;
- Layer 2 acquisition policies;
- Layer 3 extraction/routing policies;
- provider/country overrides;
- secret references only, never plaintext secrets.

---

## 5.19 Public views need production security treatment

PostgreSQL/Supabase views require deliberate security configuration. Production API views should use `security_invoker` where appropriate and should be exposed only through the designated API schema/roles.

Do not assume a view automatically inherits safe RLS behaviour.

---

## 5.20 Import/export is not a first-class subsystem

There is currently no formal import template/version, staging/validation workflow, row-level error reporting or export profile framework.

That will become important when providers, reference data and operational teams need bulk changes.

Production must support CSV and Excel as governed interchange formats rather than ad hoc direct table edits.

Supabase supports CSV import for smaller datasets and Postgres `COPY`/other bulk mechanisms for larger imports.

References:

- https://supabase.com/docs/guides/database/import-data
- https://www.postgresql.org/docs/current/sql-copy.html

---

## 6. Current relational strengths and gaps

### Strong current foreign-key relationships

The current database correctly links many repeated facts:

- courses -> providers;
- course fees/intakes/registrations -> courses;
- provider registrations -> providers;
- scholarship links -> courses/scholarships;
- scholarship criteria/scopes/tiers -> scholarships;
- evidence -> sources/jobs;
- review actions -> review queue;
- PIM definitions -> groups;
- PIM family groups -> families/groups.

### Important missing/weak relationships

Production needs explicit relationships for:

- provider -> external identifiers;
- provider -> aliases;
- provider -> campuses;
- provider -> institution collections;
- provider -> ranking results;
- country -> region/subregion;
- country -> subdivisions;
- course -> controlled field/category;
- course -> campus(es);
- course -> one structural family;
- generic PIM value/category -> guaranteed entity registry FK;
- embedding -> search profile/model/content version;
- integration policy -> scraper/model profile;
- job -> exact policy/profile versions used;
- publication -> channel/locale/completeness state.

---

## 7. Index assessment

### Existing useful indexes

Current design has appropriate basic indexes for:

- provider/course foreign keys;
- unique registrations;
- course intake uniqueness;
- recent jobs;
- review queue state;
- scholarship criteria lookup;
- scholarship scope lookup;
- evidence by entity;
- PIM aliases and group references.

### Missing production indexes/search structures

The new design will need:

- provider external identifier uniqueness;
- canonical key indexes;
- category hierarchy/closure indexes;
- course filter indexes on publication, country/provider, study level and category mappings;
- fee/intake current-effective indexes;
- ranking source/year/provider indexes;
- institution collection membership indexes;
- search document full-text/trigram indexes where used;
- HNSW or IVFFlat vector index after model selection;
- embedding stale/profile/model indexes;
- import/export job status indexes;
- integration policy/provider override indexes.

---

## 8. Data quality assessment

The current data volumes show that **identity/regulatory data is much more complete than enriched catalogue data**.

Evidence:

- 13,698 courses exist;
- ~14,476 course registrations exist;
- ~12,782 fee rows exist;
- only ~137 course intake rows exist;
- only 2 courses currently have descriptions longer than 20 characters;
- only 2,450 courses have embeddings;
- English requirement table is currently effectively empty in the assessed statistics;
- scholarship data remains pilot-scale.

This means production migration should not equate “row exists” with “catalogue is publication-ready”.

The target production database therefore needs explicit:

- completeness profiles;
- publication gates;
- freshness state;
- source confidence;
- verified-none semantics;
- unknown versus not-applicable distinction.

---

## 9. Migration classification

### 9.1 Keep concept, redesign physical table

- providers
- provider registrations
- courses
- course registrations
- course fees
- course intakes
- English requirements
- evidence
- jobs/change log
- review queue/actions
- PIM families/groups/attributes/options/aliases/categories
- scholarships/tiers/scopes/criteria/coverage

### 9.2 Do not migrate as-is

- `pipeline_config`
- `ref_countries`
- `courses.embedding`
- hard-coded completeness views
- demo-specific RLS policies
- `demo_snapshot`
- old demo/public views as production contracts
- student master/profile assumptions

### 9.3 Rebuild derived data

- embeddings;
- completeness results;
- search projections;
- API read models;
- catalogue statistics;
- scholarship matching caches if introduced.

### 9.4 Curated data migration

Provider and course records should migrate only after:

- deduplication;
- stable external/canonical keys are generated;
- country codes map to global reference seed;
- provider identifiers are cross-walked;
- field-of-study values map to controlled categories where possible;
- registration codes are normalised;
- source lineage is retained.

---

## 10. Recommended production project strategy

Create a new project after sign-off:

**Project name:** `Coursefinder_Prod`

Recommended principles:

- same intended Australian data-residency region as the current deployment unless a later residency review changes it;
- clean migration history from migration 001 onward;
- no copied demo policies;
- no copied demo secrets/config;
- no direct browser service-role use;
- `api` as the deliberate exposed data schema;
- internal schemas not exposed through Data API;
- private evidence Storage bucket(s);
- production Auth/RBAC created cleanly;
- environment-specific integration secret references;
- search embeddings generated after canonical migration and search-profile sign-off.

The existing `coursefinder-demo` project remains available as:

- migration source;
- demo/test data source;
- reference for historical experiments;
- non-production sandbox.

---

## 11. Migration approach

```mermaid
flowchart LR
    A[coursefinder-demo] --> B[Assessment + Mapping]
    B --> C[Reference Seed]
    C --> D[Provider Migration]
    D --> E[Course + Registration Migration]
    E --> F[Fees / Intakes / English]
    F --> G[PIM Families / Attributes / Categories]
    G --> H[Scholarships]
    H --> I[Evidence + Review History as required]
    I --> J[Completeness Recalculation]
    J --> K[Search Projection]
    K --> L[Embedding Rebuild]
    L --> M[API Validation]
    M --> N[Coursefinder_Prod Cutover]
```

Migration should be **schema-first and data-second**. No table should be copied merely because it exists in the current database.

---

## 12. Exit criteria before production project creation

Approve the following before creating `Coursefinder_Prod`:

1. target schema/domain boundaries;
2. provider/course/scholarship entity identities;
3. global reference seed design;
4. family/category/attribute rules;
5. Layer 2 integration configuration;
6. Layer 3 model/routing configuration;
7. completeness profiles;
8. search profiles and vector architecture;
9. API/consumer contract boundaries;
10. import/export templates;
11. Zoho commercial-layer boundary;
12. RBAC/RLS model;
13. migration mapping from current tables.

The companion document `coursefinder-database-architecture-v2.8.md` defines the recommended target design.