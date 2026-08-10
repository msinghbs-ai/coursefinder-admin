# Coursefinder Physical Schema v2.9 — Review Checklist

Use this checklist before creating `Coursefinder_Prod`.

## A. Core schema

- [ ] Separate schemas `ref`, `catalogue`, `pim`, `scholarship`, `integration`, `pipeline`, `search`, `publishing`, `workflow`, `security`, `api` are approved.
- [ ] Canonical data is not stored primarily in `public`.
- [ ] Stable interchange keys are used in addition to UUIDs.
- [ ] Course embeddings are moved out of canonical `courses`.
- [ ] Course identity is not based only on provider + title.
- [ ] Provider identity is not based only on country + name.

## B. PIM/admin UX support

- [ ] Course Family drives the structural edit model.
- [ ] Attribute Groups support tab/section layout.
- [ ] Family-specific attribute requirements are supported.
- [ ] Attribute Options support select/multiselect UX.
- [ ] Categories support hierarchy and assignment.
- [ ] Course Collections remain provider-defined and separate from global categories.
- [ ] Bulk-editable/filterable/searchable/vector flags are explicit attribute metadata.
- [ ] Completeness profiles are configurable by family/country/channel.

## C. Catalogue

- [ ] Providers, identifiers, aliases, registrations and campuses are approved.
- [ ] Institution Collection memberships are temporal relationships.
- [ ] Rankings are separate time-series records.
- [ ] Course Collections may be hierarchical and many-to-many with courses.
- [ ] Fees, intakes, English requirements and registrations remain strong relational tables.
- [ ] Course Associations are typed relationships.

## D. Scholarships

- [ ] Scholarships are first-class entities.
- [ ] Award tiers replace duplicated scalar scholarship-value structures.
- [ ] Scopes use typed targets such as provider/course/collection/category/study level.
- [ ] Criteria remain separate student-eligibility rules.
- [ ] Explicit course links remain available where needed.
- [ ] Coverage supports `available`, `verified_none`, `unknown`, `needs_review`.

## E. Integrations / pipeline

- [ ] Multiple scraper providers are independently configurable.
- [ ] Multiple direct LLM providers are independently configurable.
- [ ] LLM routers/aggregators are separate integration types.
- [ ] Model Profiles and Extraction Profiles are versioned.
- [ ] Acquisition policies support global/country/provider overrides and fallbacks.
- [ ] Routing policies support fallback/confidence/cost rules.
- [ ] Secrets are referenced, never stored in browser-readable rows.

## F. Search

- [ ] Hybrid search = structured filters + lexical + pgvector + controlled scoring.
- [ ] Search documents are rebuildable derived data.
- [ ] Hot filter fields are typed/indexable columns.
- [ ] Category, Course Collection and Institution Collection IDs are structured facets.
- [ ] Ranking values are structured features, not vector content.
- [ ] Search Profiles control vector inclusion.
- [ ] Embeddings are versioned by content/model/profile.
- [ ] Production uses an ANN index such as HNSW after benchmark validation.
- [ ] Current prototype embeddings will be regenerated, not copied.

## G. Security/API

- [ ] Only deliberate API views/RPCs are exposed.
- [ ] No anonymous pipeline/config writes exist.
- [ ] Service role is server-only.
- [ ] Server-side permissions are authoritative; menu hiding is UX only.
- [ ] Public website receives only published projection data.
- [ ] Evidence storage remains private.
- [ ] Legacy prototype Edge Functions are reviewed/rebuilt rather than copied blindly.

## H. Import/export

- [ ] CSV and XLSX are supported.
- [ ] Imports use staging, validation, preview and commit.
- [ ] Stable keys/codes are used instead of UUIDs.
- [ ] Course Collections have dedicated import/export sheets.
- [ ] Long-form CourseAttributes supports future configurable attributes.
- [ ] Row-level validation errors are retained.
- [ ] Search-relevant imports trigger projection/embedding rebuilds.
- [ ] Export profiles prevent unrestricted raw-table dumps.

## I. Seed data

- [ ] Global geography is seeded from day one.
- [ ] Study-level taxonomy approved.
- [ ] Initial Course Families approved.
- [ ] Field-of-Study top-level taxonomy approved.
- [ ] Provider Types approved.
- [ ] English tests approved.
- [ ] Institution Collection definitions approved.
- [ ] Ranking-source placeholders remain disabled until licence approval.
- [ ] Australia and New Zealand activation settings approved.

## J. Migration

- [ ] Clean build rather than database clone is approved.
- [ ] Provider identity reconciliation approach approved.
- [ ] Course identity reconciliation approach approved.
- [ ] Current free-text `field_of_study` will be mapped/reviewed, not directly seeded.
- [ ] Current `pipeline_config` is not migrated as-is.
- [ ] Demo/public RLS policies are not migrated.
- [ ] Current embeddings are not migrated.
- [ ] Derived completeness/search data is rebuilt.

## Approval outcome

Choose one:

- [ ] **Approved** — create `Coursefinder_Prod` and begin ordered migrations.
- [ ] **Approved with changes** — amend v2.9 before project creation.
- [ ] **Not approved** — revisit physical schema.

## Execution after approval

1. Create `Coursefinder_Prod` in Australia Southeast.
2. Establish Git-backed Supabase migration structure.
3. Apply schema/extension/security migrations.
4. Load global/reference seeds.
5. Create first `platform_admin` account/role assignment.
6. Configure private evidence/import/export storage.
7. Migrate and reconcile providers.
8. Migrate/reclassify courses and structured child facts.
9. Migrate scholarships.
10. Configure Layer 1–3 production integrations/policies.
11. Build completeness/publication/search projections.
12. Generate embeddings and HNSW index.
13. Connect production admin application.
14. Run UAT and cutover validation.