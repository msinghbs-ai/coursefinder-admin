# Coursefinder Production Handover v2.9.1

**Status:** Mumbai pilot database build complete enough for UI integration/UAT.

## Current authoritative environment

- Supabase organisation: `techM` (`rszbvkqopqfvjldvfnbh`)
- Organisation plan: Free
- Current project: `coursefinder_Pilot`
- Project ref: `fxcwkweaxjtknorudmwp`
- Region: Mumbai (`ap-south-1`)
- Purpose: pilot/UAT of the production-model database, API and admin UI
- Cost reported at project creation: $0/month
- Authority: this Mumbai project supersedes the earlier Australia Southeast production-model pilot for all new build/UAT work.

## Superseded Australia Southeast project

- Project: `Coursefinder_Prod`
- Project ref: `qmhroocwdipgtduapslr`
- Region: Australia Southeast (`ap-southeast-2`)
- State: paused after the deployment-region plan changed.
- Do not continue schema/data/API development there unless explicitly restored for comparison or rollback investigation.

The working `coursefinder-demo` project remains separate and unchanged. It is a migration/source-validation environment only.

## Source of truth

- Architecture baseline: `docs/coursefinder-database-architecture-v2.9.1.md`
- Production migrations: `supabase/production-migrations/`
- Historical physical design: `docs/coursefinder-physical-database-schema-v2.9.md`
- Pilot validation: scenario documents under `docs/coursefinder-pilot-validation-wave1-*`
- UI handoff: `docs/coursefinder-ui-handoff-v2.9.1.md`

## Applied migration set in Mumbai

1. `001_schemas_extensions`
2. `002_reference_core`
3. `003_security_rbac`
4. `004_pim_core`
5. `005_catalogue_core`
6. `006_academic_options_provider_associations`
7. `007_scholarships`
8. `008_integrations_pipeline_evidence`
9. `009_layer4_workflow`
10. `010_publishing`
11. `011_search_projection`
12. `012_pgvector_embeddings_cache`
13. `013_api_contracts`
14. `014_import_export`
15. `015_migration_utilities`
16. `016_baseline_seed`
17. `017_ui_seed_slice`
18. `018_search_projection_rebuild`
19. `019_fk_index_hardening`
20. `020_private_evidence_storage`
21. `021_ui_api_bridge`
22. `022_ui_compatibility_views`
23. `023_ui_bridge_security_hardening`

All production-relevant DDL is tracked under `supabase/production-migrations/`.

## Current data state

### Controlled/reference seed

- Countries: AU, CA, DE, GB, IE, NZ, US enabled for pilot catalogue/search; IN present as seed/reference.
- Core currencies, study levels, provider types and English tests seeded.
- Default Provider, Course and Scholarship PIM families seeded.
- Course edit groups seeded: General, Academic, Admissions, English, Fees, Intakes, Campuses, Scholarships, SEO/Content and Evidence.
- Initial Search Profiles and intent aliases seeded for Website and Zoho.

### UI catalogue seed

A deliberately small validated slice from `coursefinder-demo` was loaded to let UI work start without copying demo schema debt:

- 7 Australian providers
- 35 technology/data/AI/cyber-related courses
- migration provenance recorded in `workflow.migration_runs` and `workflow.migration_entity_map`

This is a UI/UAT seed, not the final full catalogue migration.

### Search projection

- `search.rebuild_course_documents()` is deployed server-side.
- Projection generation: `2`
- Projected courses: `35`
- FTS indexes are present.
- pgvector HNSW structure is present but embeddings are intentionally regenerated later from canonical Mumbai data rather than copied from demo.

## PIM and catalogue model now available

- Attribute Families, Groups and family/group ordering
- Attribute Definitions, managed Options and aliases
- hierarchical Categories
- Entity Registry and typed Attribute Values
- configurable Completeness Profiles/Requirements
- Providers, IDs, aliases, registrations, campuses and rankings
- Course Collections and memberships
- Courses, registrations, fees, intakes, campus delivery and English requirements
- Course Academic Options
- Provider Associations/lineage
- Scholarships, scopes including Course Collection, criteria, award tiers and coverage
- Evidence lineage including `supersedes_evidence_id`
- Layer 4 review queue/actions including reopening/supersession lineage
- import/export staging and reconciliation structures

## Search/API model available

- Website and Zoho Search Profiles
- Search Projection
- HNSW pgvector course embeddings store
- query embedding cache keyed by model + profile version + hash
- curated authenticated API functions
- authenticated UI RPC bridge
- temporary read-only compatibility views for the existing admin UI

The compatibility views are a transition aid only. New UI work should progressively use the explicit v2.9.1 RPC/API contracts rather than treating the compatibility views as the long-term backend contract.

## Security state

- Canonical `catalogue`, `pim`, `scholarship`, `pipeline`, `workflow`, `search`, `security`, `integration` and `publishing` schemas are not directly granted to browser roles.
- `service_role` remains server-side only.
- Private `evidence` Storage bucket created; no anonymous/authenticated object policies added.
- UI bridge requires an authenticated Supabase session.
- Migration `023_ui_bridge_security_hardening` replaced the temporary compatibility views with `security_invoker=true` views over explicit authenticated RPCs. The prior Security Advisor `security_definer_view` ERROR findings are resolved.
- Current Security Advisor findings are intentional INFO notices for server-only RLS tables with no client policies, plus WARN notices that the authenticated read RPCs are `SECURITY DEFINER`. Those RPCs are deliberately exposed read contracts, check `auth.uid()`, and provide no write path.
- No anonymous write policies from the demo were copied.

## Performance state

The first performance review found missing covering indexes on foreign keys. Migration `019_fk_index_hardening` added those indexes.

After migration 019, Supabase reports no remaining unindexed-foreign-key notices. Remaining performance notices are unused-index INFO messages, which are expected before representative UI/pipeline traffic exists and should not be used as a reason to remove indexes yet.

## Browser-contract validation

An authenticated-session simulation against the hardened UI bridge returned:

- Providers: `7`
- Courses: `35`
- PIM Attributes: `3`
- Search documents: `35`
- Search generation: `2`

Supabase TypeScript types were also generated successfully from the Mumbai pilot schema for frontend use.

## Explicitly prohibited from demo migration

- demo snapshots
- `search_pilot` temporary objects
- old query-cache rows
- old course embeddings
- anonymous write policies
- anonymous `pipeline_config` mutation
- service-role credentials in browser/frontend
- temporary pilot Edge Functions unless explicitly promoted/rebuilt

## Data migration principles

- migrate using stable business/interchange keys and retain provenance;
- regulatory identifiers remain authoritative source facts;
- historical provider identities remain separate and use Provider Associations;
- preserve aliases/evidence/history;
- rebuild Search Projection and embeddings from canonical Mumbai data;
- reconcile counts and stable keys before any full catalogue cutover.

## Remaining data/pipeline work after UI start

These are not unresolved physical DB-design tasks; they are catalogue/pipeline population and application work:

1. migrate the wider validated catalogue after UI/pipeline UAT;
2. run Layer 2 enrichment in Mumbai for URLs, descriptions, fees, intakes, English, collections and scholarships;
3. run Layer 4 review workflows;
4. normalise scholarship eligibility criteria;
5. regenerate course embeddings against the production Search Profile;
6. expand Search Projection after canonical enrichment;
7. populate private evidence objects using a controlled manifest;
8. UAT Website and Zoho contracts.

## UI start gate

The database is ready for UI development against the 7-provider / 35-course pilot slice.

Before a person can use the authenticated UI, that user must exist in Mumbai Supabase Auth. Role assignment can then be made in `security.user_roles`. An authenticated but unassigned user can use the read-only UI bridge for pilot development; write operations remain unpromoted until explicit role-checked write RPC/Edge contracts are completed.

## Git/UI integration state

PR #3, `Mumbai pilot DB handoff and UI bridge v2.9.1`, was merged into `main` as squash commit `6bf41535510c6b12d69c0192e25f46374b53c5a4`.

`src/supabase.js` now resolves admin context through `ui_context()` rather than the retired demo `pim-admin-v2-1` Edge Function. The existing React read screens can use the hardened compatibility layer while new components move to explicit v2.9.1 RPC contracts.

## Handover rule

Every schema/config/API change required to reproduce the environment must exist in Git. Dashboard-only/manual changes must be recorded here or converted into migrations/configuration artefacts before sign-off.

The Mumbai environment must remain reproducible from Git-tracked migrations, seed files, deployment manifests and handover documentation; it must never depend on undocumented state copied from the demo or the paused Australia project.
