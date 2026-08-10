# Coursefinder Current Database Assessment v2.8.1

**Status:** Current-state assessment and migration input. No schema or application changes are included in this document.

**Source system assessed:** Supabase project `coursefinder-demo` (`gfryvshbeptxwbzjomhe`)

**Target production project:** `Coursefinder_Prod`

**Architecture baseline:** v2.8.1

**Companion documents:**
- `docs/coursefinder-database-architecture-v2.8.1.md`
- `docs/coursefinder-architecture-v2.8.1-menu-integration-model.md`
- `docs/coursefinder-architecture-v2.8.1-global-reference-seed-search.md`
- `docs/coursefinder-database-architecture-v2.8.1-review-checklist.md`

---

## 1. Purpose

This document assesses the current `coursefinder-demo` database against the complete v2.8.1 target architecture. It identifies reusable components, migration candidates, structural limitations, security concerns, search limitations and schema debt that should not be copied into the production project.

The current project is treated as a **prototype, evidence source and migration source**, not as the physical baseline for production.

---

## 2. Executive assessment

The existing database has a valuable foundation:

- canonical Providers and Courses;
- provider/course registrations;
- fees and intakes;
- scholarship entities and matching rules;
- evidence artefacts;
- Layer 1–4 jobs/review concepts;
- configurable PIM families/groups/attributes/categories;
- generic field values;
- pgvector proof of concept;
- consumer completeness/scholarship views.

However, the current implementation combines canonical data, demo/public access, pipeline configuration, PIM metadata, search vectors, evidence, review workflow and consumer views inside the exposed `public` schema.

The recommended production approach is therefore:

```text
Current coursefinder-demo
        ↓
Assess / map / cleanse
        ↓
Create clean Coursefinder_Prod
        ↓
Load global reference seed
        ↓
Migrate validated canonical data
        ↓
Rebuild derived completeness/search/embeddings
```

Do not clone the project and simply rename it production.

---

## 3. Current estate snapshot

Live assessment on 10 August 2026 found approximately:

| Item | Current state |
|---|---:|
| Public base tables | 35 |
| Public views | 5 |
| Providers | 522 |
| Courses | 13,698 |
| Course registrations | 14,476 |
| Course fees | 12,782 |
| Course intakes | 137 |
| Scholarships | 5 |
| Scholarship criteria | 7 |
| Evidence artefacts | 19 |
| Review queue items | 27 |
| Courses with embeddings | 2,450 |
| Courses with meaningful description >20 chars | 2 |
| Distinct `level_code` values | 10 |
| Distinct free-text `field_of_study` values | 297 |
| Countries in `ref_countries` | 7 |

Provider distribution currently includes significant historical/demo populations in GB and DE, with AU as a stronger active catalogue destination.

---

## 4. Current core tables and observations

### `providers`

Strengths:

- UUID identity;
- country relationship;
- canonical name;
- lifecycle/publication state.

Limitations:

- uniqueness relies on `(country_code, canonical_name)`;
- external identifiers are not first-class generic crosswalks;
- campus/organisation identity is under-modelled;
- provider type, aliases, memberships and rankings are not fully separated;
- name still carries too much identity responsibility.

Target action:

- migrate validated providers into `catalogue.providers`;
- generate stable interchange keys;
- migrate registrations into explicit provider-identifier/regulatory tables;
- add aliases, campuses, institution memberships and rankings through separate relationships.

### `courses`

Strengths:

- UUID identity;
- provider relationship;
- core course fields;
- existing vector column/proof of concept.

Limitations:

- uniqueness relies on provider + canonical title;
- `field_of_study` is free text;
- no provider-defined Course Collection model;
- structural Family relationship is generic and indirect;
- embedding is stored directly on canonical course;
- no search-document/profile/version lifecycle.

Target action:

- migrate validated canonical course identity;
- create stable course keys/external identifiers;
- map free-text fields to global taxonomy;
- capture provider Course Collections;
- regenerate Search Projections/embeddings rather than copying vector state.

### `course_fees`

Strengths:

- temporal academic year;
- amount/currency/billing period;
- source/evidence fields.

Limitations:

- production needs clearer currency reference FK and validity/offer/campus/international context where applicable.

Target action: retain the one-to-many fee principle and migrate validated rows.

### `course_intakes`

Strengths:

- explicit intake date;
- status;
- source.

Limitations:

- current population is small relative to course count;
- future model should allow campus, application deadlines, terms and status history.

### `english_requirements`

Strengths:

- structured test/overall/min-band concepts.

Limitations:

- current data is effectively unpopulated;
- provider/course dual ownership can create ambiguity;
- global test/component reference tables are missing.

### `course_registrations` and `provider_registrations`

Strengths:

- official register/code concept;
- validity;
- source linkage.

Limitations:

- register values are text rather than governed integration/regulatory source IDs;
- country reference currently contains regulator fields that should be separate.

---

## 5. Current PIM metadata assessment

Existing useful tables:

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

These demonstrate the correct general PIM principle: separate structure, definitions, classifications and values.

### Limitations to fix in production

1. Polymorphic `entity_type + entity_id` relationships do not always have real FK protection.
2. Family-group structure exists, but a complete Family-to-Attribute rule model needs clearer required/optional/profile semantics.
3. Current categories are generic and do not distinguish all reference/taxonomy purposes.
4. Course Collections are absent.
5. Global Field of Study taxonomy is not established.
6. `field_values` supports many typed value columns but requires stronger uniqueness/preferred-value and entity-registry rules.
7. Completeness currently remains hard-coded in views rather than driven by a profile/rule model.
8. Search/vector inclusion needs explicit, versioned search-profile configuration.

Target direction:

- retain the principle;
- rebuild physically under dedicated `pim` and `ref` schemas;
- use an entity registry or equivalent FK-safe mechanism for generic PIM relationships;
- add explicit Course Collection and global taxonomy relationships.

---

## 6. Current scholarship assessment

Useful structures already exist:

- `scholarships`
- `scholarship_award_tiers`
- `scholarship_scopes`
- `scholarship_criteria`
- `course_scholarships`
- `scholarship_coverage`

This is a strong conceptual foundation and should be preserved in production.

### Current limitations

- `scholarships` contains transitional/duplicated value fields from iterative development;
- scope values are partly generic text/JSON rather than always FK-backed controlled references;
- Course Collection scope does not exist yet;
- criteria taxonomy needs controlled metric/operator/reference definitions;
- scholarship search projection/versioning is not established;
- current data volume is too small to validate all global patterns.

Target action:

- normalise the scholarship core;
- retain award tiers/scopes/criteria/coverage concepts;
- add FK-backed scopes to provider, Course Collection, category, level, campus and course where possible;
- preserve source text/evidence alongside machine-evaluable rules.

---

## 7. Current pipeline/integration assessment

Useful structures:

- `data_sources`
- `ingest_jobs`
- `ingest_change_log`
- `evidence_artifacts`
- `review_queue`
- `review_actions`
- `catalogue_suggestions`
- `pipeline_config`

### Strengths

- jobs are explicit;
- source/evidence concepts exist;
- review and suggestion workflow exists;
- evidence supports storage path, hashes, validity and supersession.

### Production limitations

1. `pipeline_config` is a generic JSON key/value table rather than a relational multi-scraper/multi-LLM configuration model.
2. Integrations and execution policies are not sufficiently separated.
3. Jobs do not fully record scraper/model/routing profile versions and cost/usage lineage.
4. provider/country policy inheritance is not explicitly modelled.
5. Layer 2 Course Collection discovery is not represented.
6. Layer 3 extraction/routing profiles are not first-class.

### Security blocker

Current RLS includes anonymous read/write access to `pipeline_config`.

This must not exist in production.

Production target:

```text
integration.* = capability definitions
pipeline.* = policies, jobs, schedules and evidence
workflow.* = review/suggestions
```

Secrets remain server-side and are referenced only by logical secret identifiers.

---

## 8. Current search / pgvector assessment

Current state:

- `vector` extension exists in `public`;
- `courses.embedding` exists;
- approximately 2,450 of 13,698 courses have embeddings;
- `match_courses(query_embedding, match_count)` orders directly by vector distance;
- no HNSW/IVFFlat index was found on the course embedding;
- no Search Profile/version/model/content-hash lifecycle is attached to each embedding;
- current semantic content is weak because only approximately two courses contain meaningful descriptions longer than 20 characters.

### Implications

The current vector state should be treated as a technical proof of concept, not migrated as production search state.

Production must introduce:

- `search.search_profiles`;
- `search.search_documents`;
- versioned embedding records;
- model/profile references;
- source content hashes;
- ANN indexing appropriate to the approved vector model;
- structured/filter indexes;
- full-text/trigram support where required;
- hybrid ranking RPC/API;
- stale/rebuild lifecycle.

### Search migration decision

Do **not** copy current embeddings into production as canonical data.

Rebuild them from approved v2.8.1 canonical/search projections after migration.

---

## 9. Current completeness assessment

`course_completeness` and `course_completeness_v2` are useful consumer views, but completeness is currently hard-coded around a small fixed set of checks such as:

- registration;
- structure;
- fee;
- intake;
- English;
- description;
- scholarship coverage.

Production needs:

```text
Family + Country/Regime + Channel -> Completeness Profile -> Rules
```

This allows Higher Education, VET, ELICOS, Research and other families to have different definitions of complete data.

`verified_none` scholarship coverage should continue to count as known/complete rather than missing.

---

## 10. Current reference-data assessment

`ref_countries` currently mixes:

- country identity;
- currency;
- register name/URL;
- adapter key.

This is a major separation-of-concerns issue.

Production needs separate:

- global geography/reference;
- regulatory sources;
- integration adapters/policies.

Current country seed is only seven records, so the production global reference layer should be seeded independently rather than migrated wholesale.

---

## 11. Current security/API assessment

All business data is currently in `public`, including canonical tables and many demo-facing read policies.

Examples include anonymous/authenticated public reads on canonical tables used by the demo and public reads on scholarship structures.

This is not the recommended production exposure model.

Production target:

- internal schemas are not directly browser exposed;
- `api` schema provides deliberate views/RPC contracts;
- browser uses publishable key only;
- service-role/secret keys never appear in the client;
- RLS and grants enforce role/channel access;
- views use security-invoker patterns where required;
- privileged functions are minimised and explicitly secured.

---

## 12. Import/export assessment

Current schema was built primarily around direct ingestion/application operations; bulk interchange is not yet a full platform subsystem.

Production requires:

- template versions;
- staging tables;
- mapping profiles;
- validation results;
- preview/dry run;
- commit batches;
- export profiles;
- stable external/interchange keys;
- row-level audit/error reporting;
- CSV/XLSX support.

Do not expose raw internal UUIDs as the only user-facing import relationship mechanism.

---

## 13. Migration classification

### Reuse concept and migrate validated data

- Providers
- Courses
- Course registrations
- Provider registrations
- Fees
- Intakes
- Scholarships
- Award tiers
- Scholarship scopes/criteria/course links/coverage
- Evidence metadata and selected artefacts
- Review history where useful
- PIM definitions/aliases after validation

### Rebuild derived state

- completeness views/scores;
- search projection;
- embeddings;
- vector indexes;
- catalogue stats;
- API views.

### Replace/restructure

- `ref_countries` mixed responsibilities;
- `pipeline_config`;
- direct canonical public exposure;
- provider/course name-based uniqueness assumptions;
- free-text Field of Study as primary classification;
- polymorphic generic relationships without FK protection;
- transitional scholarship columns.

### Add as new production concepts

- global reference schemas;
- stable provider/course interchange keys;
- provider external identifiers;
- provider aliases;
- campuses;
- Institution Collections and memberships;
- Rankings;
- Course Collections and memberships;
- controlled Field of Study taxonomy;
- Completeness Profiles;
- Scraper Profiles and acquisition policies;
- LLM providers/routers/model profiles/extraction/routing policies;
- Search Profiles/documents/embedding lifecycle;
- Import/export subsystem;
- Publishing/channel model;
- deliberate API schema.

---

## 14. Migration risk summary

| Risk | Impact | Target treatment |
|---|---|---|
| Name-based provider/course uniqueness | Incorrect merge/split | Stable keys + external IDs + validation |
| Free-text field taxonomy | Poor filtering/search | Controlled global taxonomy + source labels |
| Mixed public schema | Security/maintenance | Dedicated internal schemas + API schema |
| Anonymous pipeline config | Critical security issue | Remove; server-side role-checked config |
| Existing vectors incomplete/unindexed | Poor search/scaling | Rebuild search projection and ANN indexes |
| Hard-coded completeness | Poor family/channel fit | Completeness Profiles |
| No Course Collections | Loses provider structure | Add first-class Course Collections |
| Transitional scholarship structure | Hard maintenance | Normalise scholarship core |
| Limited global seed | Expansion redesign risk | Global reference seed from day one |

---

## 15. Production recommendation

Create a clean `Coursefinder_Prod` project only after the v2.8.1 architecture set is approved and v2.9 physical schema is defined.

Recommended sequence:

1. create new production project;
2. enable required extensions in appropriate schemas;
3. create internal schemas and `api` boundary;
4. load global reference seed;
5. create canonical/provider/course/PIM/scholarship schema;
6. create integration/pipeline/workflow structures;
7. create import/export staging framework;
8. migrate validated canonical data;
9. map Course Collections/global categories;
10. rebuild completeness;
11. build Search Projection;
12. regenerate embeddings and vector indexes;
13. verify APIs/RLS/roles;
14. connect production admin/Zoho/website;
15. retain demo project separately for non-production experimentation.

---

## 16. v2.8.1 assessment conclusion

The existing project contains substantial reusable **data and concepts**, but production should be a controlled rebuild rather than a clone.

The migration objective is therefore not to preserve every current table. It is to preserve validated canonical knowledge, provenance and proven design concepts while eliminating prototype security exposure, mixed responsibilities and derived-state debt.

---

## Appendix A — Relationship to earlier assessments

Earlier assessment documents remain in the repository as historical snapshots. This v2.8.1 assessment is the current assessment baseline for the v2.8.1 architecture suite and the forthcoming v2.9 physical-schema design.
