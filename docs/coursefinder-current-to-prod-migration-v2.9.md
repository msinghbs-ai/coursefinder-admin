# Coursefinder Current-to-Production Migration v2.9

**Status:** Migration design for review.

**Source:** current `coursefinder-demo` Supabase project.

**Target:** future `Coursefinder_Prod` Supabase project.

---

# 1. Migration principle

Do not clone the current database. Build the v2.9 schema cleanly, then migrate validated canonical data and rebuild derived state.

Migration classes:

1. **Direct-map with validation** — structurally compatible canonical data.
2. **Transform/map** — data moves into revised normalized structures.
3. **Reclassify** — free-text/current values map into controlled reference data.
4. **Do not migrate** — demo/prototype/security debt or obsolete derived data.
5. **Rebuild** — completeness, search documents and embeddings regenerated from the target model.

---

# 2. Source snapshot relevant to migration

Current assessed source contains approximately:
- 522 providers
- 13,698 courses
- 14,476 course registrations
- 12,782 course fee rows
- 137 course intake rows
- 5 scholarships
- 7 scholarship criteria
- 2,450 course embeddings

The current database is valuable as a migration source but contains prototype/public/demo controls that must not be promoted into production.

---

# 3. Table mapping

| Current | Target | Action |
|---|---|---|
| `ref_countries` | `ref.countries` + pipeline/integration config | Transform; keep country identity, split regulator/adapter fields |
| `providers` | `catalogue.providers` + `pim.entity_registry` | Transform/validate |
| `provider_registrations` | `catalogue.provider_registrations` | Map with source/evidence cleanup |
| `courses` | `catalogue.courses` + `pim.entity_registry` | Transform/reclassify; do not copy embedding |
| `course_registrations` | `catalogue.course_registrations` | Map |
| `course_fees` | `catalogue.course_fees` | Map; normalise year/student type/currency |
| `course_intakes` | `catalogue.course_intakes` | Map |
| `english_requirements` | `catalogue.english_requirements` | Map/reconcile provider-vs-course defaults |
| `pim_attribute_families` | `pim.attribute_families` | Seed/reconcile; not blind copy |
| `pim_attribute_groups` | `pim.attribute_groups` | Seed/reconcile |
| `pim_attribute_family_groups` | `pim.family_groups` | Map |
| `pim_attribute_definitions` | `pim.attribute_definitions` | Map/review flags; add vector/bulk fields |
| `pim_attribute_options` | `pim.attribute_options` | Map |
| `pim_attribute_aliases` | `pim.attribute_aliases` | Map after provider identity reconciliation |
| `field_values` | `pim.attribute_values` | Transform/validate typed values and entity registry |
| `pim_categories` | `pim.categories` | Reconcile with approved global category taxonomy |
| `pim_entity_categories` | `pim.entity_categories` | Map after category reconciliation |
| `pim_entity_family_assignments` | entity registry family assignment | Reconcile; target expects primary structural family |
| `scholarships` | `scholarship.scholarships` + entity registry | Transform/remove transitional duplicated value columns |
| `scholarship_award_tiers` | `scholarship.award_tiers` | Map |
| `scholarship_scopes` | `scholarship.scopes` | Transform from generic text/json targets into typed relationships where possible |
| `scholarship_criteria` | `scholarship.criteria` | Map/normalise |
| `course_scholarships` | `scholarship.course_links` | Map |
| `scholarship_coverage` | `scholarship.coverage` | Map |
| `data_sources` | `pipeline.sources` | Reconcile/split integration config |
| `ingest_jobs` | operational archive only | Optional historical archive; do not seed active production queues |
| `ingest_change_log` | migration audit/archive | Optional archive |
| `evidence_artifacts` | `pipeline.evidence_artifacts` | Migrate only evidence with valid storage/content references; otherwise preserve metadata archive |
| `review_queue` / `review_actions` | workflow tables | Migrate only active/useful review items if still relevant at cutover |
| `catalogue_suggestions` | `workflow.catalogue_suggestions` | Migrate unresolved valid suggestions only |
| `pim_user_roles` | `security.user_roles` | Recreate deliberately; do not blindly copy |
| `pipeline_config` | integration/pipeline policies | Do not migrate as-is |
| `demo_snapshot` | none | Do not migrate |
| `courses.embedding` | `search.embeddings` | Do not copy; regenerate |
| completeness views | target completeness/search projections | Rebuild |

---

# 4. Identity reconciliation

## Providers

Before import into target:
1. Generate/confirm stable provider keys.
2. Validate country.
3. Reconcile canonical names and aliases.
4. Match official registration identifiers.
5. Add ROR/other external identifiers where validated.
6. Detect duplicates caused by name variants.
7. Only then create target provider UUIDs.

Maintain a migration crosswalk:

`source_provider_id -> target_provider_id -> provider_key`

## Courses

Before target insert:
1. Map provider.
2. Generate immutable `course_key`.
3. Map study level to `ref.study_levels`.
4. Map free-text `field_of_study` to global taxonomy.
5. Validate title/registration/code identity.
6. Detect duplicate/renamed course candidates.
7. Assign structural Course Family.
8. Preserve source wording via attributes/evidence where required.

Maintain:

`source_course_id -> target_course_id -> course_key`

---

# 5. Field-of-study migration

Current source contains hundreds of distinct free-text field values. These must not become hundreds of global taxonomy nodes automatically.

Process:
1. Export distinct current values + course counts.
2. Normalise spelling/case.
3. Map confidently to approved `ref.fields_of_study` codes.
4. Preserve original source wording.
5. Route ambiguous mappings to review.
6. Allow multiple categories where a course is genuinely interdisciplinary.

Target `primary_field_id` gets the primary mapping; additional classifications use categories/attributes.

---

# 6. Course Collection onboarding

The source prototype does not contain a mature provider-native Course Collection model.

Therefore:
- do not infer Course Collections solely from current free-text field of study;
- populate them later from provider site structure, import files or Layer 2 evidence;
- if current source URLs/breadcrumbs contain reliable provider grouping, migration tooling may propose collections for review but should not auto-canonicalise without validation.

---

# 7. Scholarship migration

The current scholarship model is useful but transitional.

Migration process:
1. Create canonical scholarship entity.
2. Move range/percentage/value details into award tiers.
3. Convert broad applicability into typed scopes.
4. Preserve explicit course links.
5. Convert structured criteria into target criteria.
6. Preserve evidence/confidence/review state.
7. Recalculate coverage and matcher results in target.

Do not preserve duplicated legacy scalar value columns when the target award-tier model is authoritative.

---

# 8. Evidence migration

Evidence should be migrated only where useful and verifiable.

For each artifact:
- validate source URL
- validate object storage reference if present
- preserve content hash
- preserve fetched timestamp
- preserve supersession lineage where resolvable
- remap entity/value relationships to target UUIDs

If old evidence bytes are not accessible, retain metadata only in a migration archive rather than pretending the evidence is complete.

---

# 9. Security/config migration

Do not copy:
- anonymous demo policies
- anonymous pipeline configuration access
- broad demo/public table exposure
- legacy Layer 1–3 exposure assumptions
- service-role/browser patterns

Recreate roles/permissions/RLS from v2.9 design.

Production users are re-assigned intentionally after Auth setup.

---

# 10. Search migration

Do not migrate current vectors.

Target sequence:
1. migrate canonical providers/courses/scholarships
2. calculate completeness
3. generate `search.documents`
4. generate lexical indexes
5. configure active model profile
6. generate embeddings
7. build HNSW index
8. benchmark hybrid retrieval
9. enable website/search channel only after validation

---

# 11. Recommended migration phases

## Phase 0 — Prepare
- approve v2.9
- create `Coursefinder_Prod`
- apply empty schema migrations
- load global seeds
- configure security/admin user

## Phase 1 — Reference and Provider
- country/reference validation
- providers
- aliases/identifiers
- registrations
- campuses
- institution collections/memberships where validated

## Phase 2 — Courses
- courses
- registrations
- fees
- intakes
- English requirements
- categories/attributes
- associations

## Phase 3 — Scholarships
- scholarships
- award tiers
- scopes
- criteria
- links
- coverage

## Phase 4 — Pipeline/Evidence
- sources
- integration policies
- validated evidence
- operational configuration

## Phase 5 — Derived data
- completeness
- publications
- search documents
- embeddings
- indexes

## Phase 6 — Application cutover
- connect production admin
- UAT platform_admin flows
- UAT import/export
- UAT search
- UAT scholarship matching
- UAT Zoho contract
- enable production channels

---

# 12. Migration acceptance checks

At minimum:
- provider count reconciliation with explained exclusions/merges
- course count reconciliation with explained duplicates/archives
- no orphan FKs
- no invalid country/study-level/category codes
- registration counts reconciled
- fee/intake data-quality report
- scholarship rule tests
- evidence-link sampling
- RLS/API security test
- search projection completeness
- embedding/index health
- import/export round-trip test
- admin role/menu/action test

The source project should remain available as a migration reference until production reconciliation is signed off.