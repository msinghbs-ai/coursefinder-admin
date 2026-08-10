# Coursefinder Physical Schema v2.9 — Index

**Status:** Implementation-ready design pack for review. No production database has been created or changed by this document set.

**Architecture baseline:** Coursefinder Architecture v2.8.1.

## Authoritative v2.9 documents

1. `coursefinder-physical-database-schema-v2.9.md` — complete physical PostgreSQL/Supabase schema design.
2. `coursefinder-seed-data-v2.9.md` — global and destination-specific seed/reference data.
3. `coursefinder-import-export-v2.9.md` — CSV/XLSX interchange, staging, validation and export profiles.
4. `coursefinder-security-api-search-v2.9.md` — schema exposure, RLS/RBAC, API contracts, search projection and pgvector indexing.
5. `coursefinder-current-to-prod-migration-v2.9.md` — current `coursefinder-demo` to `Coursefinder_Prod` migration mapping and execution order.
6. `coursefinder-schema-v2.9-review-checklist.md` — approval checklist before creation of `Coursefinder_Prod`.

## Versioning rule

Each v2.9 document is complete for its own scope. It may refer to other v2.9 documents for companion detail, but it does not require a reader to reconstruct the design from earlier versions.

The v2.8.1 architecture remains the approved conceptual baseline. V2.9 translates it into physical database, API, search and migration structures.

## Implementation gate

Do not create or initialise `Coursefinder_Prod` until the v2.9 physical schema pack is approved. Once approved, create the project and apply ordered migrations from an empty database rather than cloning the prototype.