# Coursefinder Architecture v2.8.1 — Review Checklist

**Purpose:** Approve the complete v2.8.1 production architecture baseline before physical Database Schema v2.9 is prepared.

**Review these companion documents together:**
- `docs/coursefinder-database-architecture-v2.8.1.md`
- `docs/coursefinder-architecture-v2.8.1-menu-integration-model.md`
- `docs/coursefinder-architecture-v2.8.1-global-reference-seed-search.md`
- `docs/coursefinder-current-db-assessment-v2.8.1.md`

---

## A. Core catalogue model

- [ ] Provider remains the canonical institution entity.
- [ ] Campus is a first-class provider location.
- [ ] Course remains the atomic searchable academic offering.
- [ ] Course Collection is approved as a first-class provider-defined grouping/vertical.
- [ ] Course Collections may be hierarchical.
- [ ] Courses may belong to multiple Course Collections.
- [ ] Course Family remains the structural schema/type and is not used for provider subject verticals.
- [ ] Global Categories/Fields of Study remain Coursefinder-controlled cross-provider taxonomy.
- [ ] Course Associations remain separate typed course-to-course relationships.
- [ ] Institution Collections such as Go8 remain provider memberships and are not Course Collections.
- [ ] Rankings remain separate temporal data and are not permanent provider attributes.

## B. PIM model

- [ ] Families define structural data shape and required/optional fields.
- [ ] Attribute Groups organise editable fields.
- [ ] Attribute Definitions separately control filterability, searchability and vector inclusion.
- [ ] Provider/source wording is preserved through aliases/evidence rather than uncontrolled new attributes.
- [ ] Completeness is driven by profiles/rules rather than one hard-coded formula.
- [ ] Generic PIM links use an FK-safe entity-registry/equivalent pattern.

## C. Global reference and seed data

- [ ] Global countries/regions are seeded from production foundation stage.
- [ ] Country existence is separate from country catalogue activation.
- [ ] Regulatory source configuration is separate from country reference rows.
- [ ] Study Levels are controlled reference data.
- [ ] Field of Study is a hierarchical global taxonomy.
- [ ] Provider Types are controlled reference data.
- [ ] Institution Collection definitions are globally managed.
- [ ] Ranking Source definitions include licensing/redistribution metadata.
- [ ] Official jurisdictional datasets remain the primary provider-identity source; global registries are crosswalk/enrichment sources.

## D. Search / pgvector

- [ ] Search uses a derived Search Projection rather than deep canonical joins per website request.
- [ ] Course Collection IDs are available as structured filters/navigation metadata.
- [ ] Course Collection labels may contribute to semantic search text when configured.
- [ ] Institution Collection memberships are structured filters/boosts.
- [ ] Rankings are structured filters/sorts/boosts rather than primary semantic vector data.
- [ ] Global Categories remain the primary cross-provider browse/filter taxonomy.
- [ ] Search Profiles determine which fields are embedded.
- [ ] Embeddings are versioned by Search Profile, model profile and source content hash.
- [ ] Relevant canonical/profile changes mark embeddings stale and queue regeneration.
- [ ] Hybrid search remains structured filters + lexical search + pgvector + controlled ranking signals.
- [ ] Production vector ANN indexing is designed/tested in v2.9 rather than copying the current unindexed proof-of-concept vector state.

## E. Scholarships

- [ ] Scholarships remain first-class entities.
- [ ] Award tiers remain separate from scholarship core identity.
- [ ] Scholarship scopes may reference Provider, Course Collection, global Category, Study Level, Campus or Course as appropriate.
- [ ] Course Collection scope does not replace student eligibility criteria.
- [ ] Structured criteria retain original source text/evidence.
- [ ] Scholarship coverage distinguishes `available`, `verified_none`, `unknown` and review states.
- [ ] Scholarship text is not indiscriminately merged into course embeddings.

## F. Layer 1–4 and integrations

- [ ] Integration capability definitions are separate from pipeline execution policies.
- [ ] Layer 2 supports multiple scraper profiles and fallbacks.
- [ ] Layer 2 policy inheritance supports global → country → provider → exception levels.
- [ ] Layer 2 captures provider-native Course Collection/breadcrumb structures where available.
- [ ] LLM Providers are separate from LLM Routers/Aggregators.
- [ ] Model Profiles are first-class versioned configuration.
- [ ] Layer 3 uses Extraction Profiles and Routing Policies.
- [ ] Layer 3 uses Course Collection context for classification but does not overwrite provider-native structure.
- [ ] Low-confidence global category/attribute mappings route to Layer 4.
- [ ] Secrets remain server-side and are not stored in browser-readable configuration.

## G. Zoho commercial boundary

- [ ] Canonical provider/course data remains in Coursefinder.
- [ ] Customer-specific commission/direct agreements/preferred providers remain in Zoho CRM.
- [ ] Zoho Creator performs counsellor/recommendation orchestration rather than duplicating the PIM catalogue.
- [ ] Recommendation policies support `open`, `preferred_first` and `restricted` modes.
- [ ] Customer commercial preference is applied after/alongside neutral Coursefinder relevance rather than being embedded as canonical provider facts.

## H. Import / export

- [ ] CSV/XLSX import/export is a first-class workflow.
- [ ] Imports use stable interchange keys rather than requiring UUIDs from business users.
- [ ] Imports use staging, mapping, validation, preview and controlled commit.
- [ ] Row-level validation/errors are retained.
- [ ] Export Profiles define fields, filters, channel/locale and relationship flattening.
- [ ] Include `CourseCollections` workbook/CSV entity.
- [ ] Include `CourseCollectionMemberships` workbook/CSV entity.
- [ ] Reference/seed data is independently exportable/importable through governed templates.

## I. Production menu and RBAC

- [ ] `platform_admin` is the complete super-menu baseline.
- [ ] Add `Course Collections` under Catalogue.
- [ ] Add `Reference Data` as a first-class menu area.
- [ ] Keep Integrations configuration separate from Enrichment execution.
- [ ] Keep Search & Matching separate from canonical Catalogue editing.
- [ ] Add Import / Export as an operational area.
- [ ] Lower roles receive reduced menus/actions.
- [ ] Server-side authorisation is authoritative; hidden menu items alone never enforce security.

## J. Production project approach

- [ ] Keep existing `coursefinder-demo` as prototype/migration source.
- [ ] Build a new `Coursefinder_Prod` schema-first after v2.9 approval.
- [ ] Do not clone current demo RLS/public exposure/configuration into production.
- [ ] Use dedicated internal schemas with a deliberate `api` exposure boundary.
- [ ] Load global reference seed before canonical migration.
- [ ] Migrate validated canonical data, not every historical/prototype object.
- [ ] Rebuild completeness/search projections/embeddings in production.

## Approval outcome

Choose one:

- [ ] **Approved** — proceed to physical Database Schema v2.9.
- [ ] **Approved with changes** — record required amendments before v2.9.
- [ ] **Not approved** — revisit v2.8.1 architecture.

## Planned next sequence after approval

1. Physical Database Schema v2.9.
2. Complete current-to-target table/field mapping.
3. Seed data specification and source/version manifest.
4. Import/export template specification.
5. Security/RLS/API contract design.
6. Search/vector physical design and performance indexing.
7. Create `Coursefinder_Prod`.
8. Apply ordered schema migrations.
9. Load seed/reference data.
10. Migrate validated canonical data.
11. Regenerate derived completeness/search/vector data.
12. Connect production admin, Zoho and website integrations.
