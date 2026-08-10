# Coursefinder Database Architecture v2.8.1 — Review Checklist

Use this checklist to approve the architecture before physical schema v2.9 is prepared.

## A. Catalogue model

- [ ] Provider remains the canonical institution entity.
- [ ] Course remains the atomic searchable academic offering.
- [ ] Course Collection is approved as a first-class provider-defined grouping.
- [ ] Course Collections may be hierarchical.
- [ ] Courses may belong to multiple Course Collections.
- [ ] Course Family remains the structural schema/type and is not used for university subject verticals.
- [ ] Global Categories remain Coursefinder-controlled cross-provider taxonomy.
- [ ] Course Associations remain separate typed course-to-course relationships.

## B. Search / pgvector

- [ ] Provider Collection IDs are structured filters.
- [ ] Provider Collection labels may contribute to semantic search text when configured.
- [ ] Global Categories remain the primary cross-provider browse/filter taxonomy.
- [ ] Search Profiles determine which fields are embedded.
- [ ] Search projection changes can queue re-embedding.
- [ ] Hybrid search remains structured filters + lexical search + pgvector + ranking signals.

## C. Scholarships

- [ ] Scholarships remain first-class entities.
- [ ] Scholarship scope may reference a provider Course Collection.
- [ ] Course Collection scope does not replace student eligibility criteria.
- [ ] Scholarship text is not indiscriminately merged into course embeddings.

## D. Pipeline

- [ ] Layer 2 captures provider-native collection/breadcrumb structures where available.
- [ ] Layer 3 uses collection context for classification but does not overwrite provider-native structure.
- [ ] Low-confidence global category mapping routes to Layer 4.

## E. Import / export

- [ ] Add `CourseCollections` workbook/CSV entity.
- [ ] Add `CourseCollectionMemberships` workbook/CSV entity.
- [ ] Normal imports use stable keys rather than UUIDs.
- [ ] Imports use staging, validation, preview and controlled commit.

## F. Production menu

- [ ] Add `Course Collections` under Catalogue.
- [ ] Keep provider collections out of the PIM Model menu.

## G. Production project approach

- [ ] Keep existing `coursefinder-demo` as prototype/migration source.
- [ ] Build new `Coursefinder_Prod` schema-first after v2.9 approval.
- [ ] Do not clone current demo RLS/public exposure/configuration into production.
- [ ] Rebuild search projections and embeddings in production from validated canonical data.

## Approval outcome

Choose one:

- [ ] **Approved** — proceed to physical Database Schema v2.9.
- [ ] **Approved with changes** — record required amendments before v2.9.
- [ ] **Not approved** — revisit architecture.

## Planned next sequence after approval

1. Physical Database Schema v2.9.
2. Current-to-target migration mapping.
3. Seed data specification.
4. Import/export template specification.
5. Security/RLS/API contract design.
6. Search/vector physical design and indexing.
7. Create `Coursefinder_Prod`.
8. Apply ordered schema migrations.
9. Load seed/reference data.
10. Migrate validated canonical data.
11. Regenerate derived completeness/search/vector data.
12. Connect production admin application.
