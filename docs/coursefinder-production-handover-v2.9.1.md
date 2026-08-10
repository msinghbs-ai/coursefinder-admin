# Coursefinder Production Handover v2.9.1

**Status:** Active build handover record.

## Current authoritative environment

- Supabase organisation: `techM` (`rszbvkqopqfvjldvfnbh`)
- Organisation plan: Free
- Current project: `coursefinder_Pilot`
- Project ref: `fxcwkweaxjtknorudmwp`
- Region: Mumbai (`ap-south-1`)
- Purpose: pilot/UAT of the production-model database and API stack
- Cost reported at project creation: $0/month
- Authority: this Mumbai project supersedes the earlier Australia Southeast production-model pilot for all new build/UAT work.

## Superseded Australia Southeast project

- Project: `Coursefinder_Prod`
- Project ref: `qmhroocwdipgtduapslr`
- Region: Australia Southeast (`ap-southeast-2`)
- State: paused on 2026-08-11 after the deployment-region plan changed.
- Do not continue schema/data/API development in this project unless it is explicitly restored for comparison or rollback investigation.

The working `coursefinder-demo` project remains separate and unchanged. It is a migration/source-validation environment only and is not the production-model target.

## Source of truth

- Architecture baseline: `docs/coursefinder-database-architecture-v2.9.1.md`
- Production migrations: `supabase/production-migrations/`
- Historical physical design: `docs/coursefinder-physical-database-schema-v2.9.md`
- Validation evidence: scenario documents under `docs/coursefinder-pilot-validation-wave1-*`

## Production migration sequence

1. 001 schemas/extensions
2. 002 reference core
3. 003 security/RBAC
4. 004 PIM core
5. 005 catalogue core
6. 006 academic options/provider associations
7. 007 scholarships
8. 008 integrations/pipeline/evidence
9. 009 Layer 4 workflow
10. 010 publishing
11. 011 search projection
12. 012 pgvector/embeddings/cache
13. 013 API contracts
14. 014 import/export
15. 015 demo-to-production migration utilities

## Already applied to Mumbai `coursefinder_Pilot`

- `001_schemas_extensions`
- `002_reference_core`
- `003_security_rbac`

These were replayed from the Git-tracked production migration files after the Mumbai project was created.

Security model after 003: the `security` schema is server-only. Client roles have no schema/table access; `service_role` has the required access. RLS remains enabled on security tables.

## Validated design changes included in v2.9.1

- Course Academic Options as first-class course children.
- Provider Associations/lineage.
- Review reopening/supersession lineage.
- Scholarship scoping by Course Collection.
- Search Projection separate from canonical catalogue.
- True query embeddings.
- Configurable intent normalisation.
- Query embedding cache keyed by model + Search Profile version + normalised-query hash.
- Website and Zoho API separation/batching principles.
- Machine-normalised scholarship criteria with conservative unknown handling.

## Explicitly prohibited from demo migration

- demo snapshots
- `search_pilot` temporary objects
- query cache rows
- old course embeddings
- anonymous write policies
- anonymous `pipeline_config` mutation
- service-role credentials in browser/frontend
- temporary pilot Edge Functions unless explicitly promoted/rebuilt

## Data migration principles

- migrate by stable business/interchange keys, not by assuming demo UUIDs are authoritative everywhere;
- retain regulatory identifiers and historical provider identity;
- preserve provider/course aliases and lineage;
- preserve evidence/source references;
- rebuild search documents and embeddings from canonical data;
- reconcile counts and identities before cutover.

## Mumbai pilot/UAT completion checklist

1. Apply all production migrations from Git in order.
2. Load controlled reference data.
3. Migrate validated canonical data from the demo/source environment.
4. Copy/import required private evidence objects using a controlled manifest.
5. Build Layer 2 and Layer 4 production workflows.
6. Build Search Projection and regenerate embeddings in Mumbai.
7. Deploy production-candidate Edge Functions and secrets.
8. Run security and performance advisors.
9. Run Website and Zoho API UAT, including semantic/hybrid search and scholarships.
10. Reconcile counts, stable keys, provider lineage, course identities, collections, academic options, scholarships and review history.
11. Record pilot/UAT sign-off.
12. Promote the Mumbai environment/configuration according to the final production release decision.

## Handover rule

Every schema/config/API change required to reproduce the environment must exist in Git. Dashboard-only/manual changes must be recorded here or converted into migrations/configuration artefacts before sign-off.

The Mumbai environment must remain reproducible from Git-tracked migrations, seed files, deployment manifests and handover documentation; it must never depend on undocumented state copied from the demo or the paused Australia project.
