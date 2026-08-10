# Coursefinder Production Handover v2.9.1

**Status:** Active build handover record.

## Current environment

- Supabase organisation: `techM` (`rszbvkqopqfvjldvfnbh`)
- Organisation plan: Free
- Current clean project: `Coursefinder_Prod`
- Project ref: `qmhroocwdipgtduapslr`
- Current region: Australia Southeast (`ap-southeast-2`)
- Current purpose: pilot/UAT of the production-model database
- Cost reported at project creation: $0/month

## Future regional target

After successful pilot/UAT, rebuild/migrate to Mumbai (`ap-south-1`).

The Mumbai project must be created from the Git-tracked schema/migration set, not by cloning the demo or copying temporary pilot configuration.

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

## Already applied to `Coursefinder_Prod`

- `001_schemas_extensions`
- `002_reference_core`

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

## Mumbai cutover checklist

1. UAT sign-off recorded.
2. Create Mumbai project in same/approved Supabase organisation and plan.
3. Apply all production migrations from Git in order.
4. Load controlled reference data.
5. Migrate validated canonical data.
6. Copy/import required private evidence objects using a controlled manifest.
7. Rebuild search projection.
8. Regenerate embeddings in Mumbai.
9. Deploy production Edge Functions and secrets.
10. Run security advisors and performance advisors.
11. Run API/Website/Zoho UAT.
12. Reconcile counts, stable keys, provider lineage, course identities, scholarships and review history.
13. Switch Website/Zoho endpoints.
14. Keep Australia Southeast UAT project available for agreed rollback period.
15. Decommission only after final sign-off.

## Handover rule

Every schema/config/API change that is required to reproduce production must exist in Git before Mumbai cutover. Dashboard-only/manual changes must be recorded here or converted into migrations/configuration artefacts before sign-off.
