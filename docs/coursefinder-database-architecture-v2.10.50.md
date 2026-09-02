# CourseFinder Database Architecture v2.10.50

**Status:** CURRENT ADDITIVE M2.5 ARCHITECTURE  
**Date:** 3 September 2026  
**Supersedes:** v2.10.49; unchanged accepted architecture remains authoritative.  
**Change Controls:** CF-CHG-20260903-083, CF-CHG-20260903-084

## Preserved v2.10.49
Scholarship catalogue/detail grain, stable first-party detail identity, Layer 4 Scholarship scope resolution and Provider asset promotion remain authoritative.

## Environment registry
Private Pipeline structures:
- `pipeline.environment_settings`;
- `pipeline.integration_secret_registry`;
- `pipeline.production_migration_manifest`.

They contain environment metadata/status only. Secret values remain in Vault and are never returned to browser reads.

## Credential boundaries
Layer 2 provider credentials remain keyed to `layer2_acquisition_providers.vault_secret_id`.

Layer 3 credentials retain the established per-profile Vault naming contract.

Generic integration secrets are addressed by `integration_secret_registry.secret_name` and resolved only through service-role-only functions.

## Production portability
Canonical Evidence/Provider-asset Storage references remain relative paths. The Production project must preserve bucket/object paths or explicitly migrate canonical references through a separately accepted change.

## Environment-specific values
Project refs, deployment origins, frontend Supabase URL and other target values are environment metadata, not canonical educational data.

Project-generated Supabase publishable/secret keys are outside canonical database content.

## Migration status
The migration manifest is an operational readiness ledger and does not itself execute Production migration.
