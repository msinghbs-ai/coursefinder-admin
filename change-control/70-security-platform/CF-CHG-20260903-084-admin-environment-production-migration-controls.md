# CF-CHG-20260903-084 — Admin Environment, Credentials & Production Supabase Migration Controls

**Status:** IMPLEMENTED / TARGETED PASS  
**Date:** 3 September 2026  
**Primary owner:** Platform / Production Readiness  
**Builds on:** CF-049, CF-081, CF-083 / A31 / A32

## Objective
Create one Platform Admin control surface for environment-specific integration settings and make the clean Production Supabase tenancy migration explicit and auditable.

## Admin surface
Pilot UI v2.15.43 adds:
`Administration → Environment & Migration`.

The workspace exposes only masked/configured state for secrets and allows write-only credential rotation.

Centralised controls:
- Parse.bot endpoint, enabled state, API credential, rate/concurrency/timeout;
- Firecrawl credential, current recorded rate, monthly vendor-unit entitlement and stop-at reserve;
- Scrape.do, ScraperAPI and ZenRows credentials/settings;
- OpenRouter Layer 3 credentials;
- Apollo contact-enrichment credential;
- separate Production automation credential;
- target Production Supabase organisation/project ref/project URL/region;
- Production Admin and Website origins;
- target-generated/deployment-managed Supabase/Auth settings as checklist state.

## Security
Secret values are never returned by Admin reads.

Layer 2 provider credentials continue to use the accepted `layer2_provider_control` Vault path.
Layer 3/OpenRouter continues to use the accepted Layer 3 credential Vault path.
Apollo now prefers `coursefinder_integration_apollo` in Vault, with the existing `APOLLO_API_KEY` Edge environment value retained only as transitional fallback.

Production Supabase publishable/secret keys are project-generated and are not copied into the Pilot registry.

## Production portability registry
New private structures:
- `pipeline.environment_settings`;
- `pipeline.integration_secret_registry`;
- `pipeline.production_migration_manifest`.

Browser roles have no direct table access. Platform Admin access is through `platform-environment-control` and service-role-only RPCs.

## Migration manifest
Required components explicitly tracked:
1. database schema/data/indexes/roles/Auth user data;
2. Vault/provider credentials;
3. Storage bucket configuration;
4. Storage objects;
5. Edge Functions;
6. Edge Function custom secrets;
7. Auth settings and target API keys;
8. cron schedules;
9. database extensions/project settings;
10. CORS/origins;
11. Evidence/source-link portability;
12. later Website/Zoho/API consumer reconfiguration.

## Evidence portability proof
Pilot snapshot:
- Evidence rows: 17,400;
- Evidence rows with relative Storage paths: 17,391;
- absolute Evidence Storage paths: 0;
- Pilot Supabase absolute URLs in Evidence source/metadata: 0;
- Provider asset rows: 2;
- absolute Provider asset paths: 0;
- Storage objects: 17,626;
- Storage buckets: 2;
- cron jobs: 14;
- Vault secrets: 7.

Therefore database Evidence references are portable if bucket names and exact object paths are preserved. Signed/download URLs must be regenerated against the target project.

## Parse.bot
Parse.bot remains registered but disabled. Admin may store the trial API key and endpoint when available. Enabling production routes still requires bounded adapter UAT; credential presence alone is not qualification.

## Firecrawl
Pilot currently records a 5,000-unit monthly entitlement. The user has increased the vendor limit externally. CF-084 deliberately does not invent the new value; Platform Admin now updates the entitlement/reserve through Admin and Layer 2 budget clamping then uses the persisted value.

## Production boundary
This change does not create the Production Supabase project and does not waive the existing organisation/region/cost approval gate. It prepares the source-of-truth inventory and target settings needed when the separate tenancy is created.

## Supabase portability rule
A database-only clone/restore is insufficient for full CourseFinder Production migration. Storage objects, Edge Functions, Auth settings/API keys and project settings require explicit target work. Vault handling must follow the chosen restore method and be verified before relying on copied encrypted values.

## Consumer boundary
No Website/Wix/Zoho cutover is authorised. Consumer endpoints/keys stay a later gate.


## Additional runtime portability hardening

Database-to-Edge dispatch was found to contain six executable hard-coded Pilot project URLs. CF-084 now centralises those dependencies through:
- `runtime_edge_base_url`;
- `runtime_automation_integration_key`;
- service helpers that resolve the selected Vault automation credential.

Before Production cron is enabled:
- set `runtime_edge_base_url` to the Production `/functions/v1` base;
- set `runtime_automation_integration_key=production_automation`;
- verify bounded database→Edge dispatch reaches Production.

Post-hardening scan: no executable database dispatch helper, source row or cron command remains hard-bound to the Pilot project URL. The only retained Pilot URL occurrence in a database function is the intentional portability audit expression.

## Consumer credentials

Pilot Website and Zoho consumer authentication stores only SHA-256 bearer-token hashes. The raw tokens are unrecoverable by design.

Administration → Environment & Migration now shows configured status and provides current-environment write-only rotation for:
- Zoho API bearer token;
- Website API bearer token.

Do not pre-stage Production consumer tokens in Pilot because rotation changes the current environment's active token. After the target Production project is created, rotate new Production tokens from the same Admin menu in Production. Consumer cutover remains separately governed.


## Targeted verification closure

Accepted Pilot source: `Coursefinder-Pilot@076a0e40047bfe7bbb146d868e44a569d6bb9c57`.

Verification:
- Pilot Frontend Build workflow `33695621150`: PASS;
- CourseFinder Deployed UAT workflow `33695621166`: PASS;
- current Admin shell/release version: v2.15.43;
- live `platform_environment_read_service`: PASS;
- current Website/Zoho hash-only credential status read: PASS;
- runtime Edge base URL/automation-selector read: PASS;
- post-change Security Advisor: 174 INFO / 0 WARN / 0 ERROR;
- post-change Performance Advisor: 209 INFO / 0 WARN / 0 ERROR;
- changed private environment tables report expected RLS-no-policy INFO only because browser roles have no direct table access.

CF-084 is therefore TARGETED PASS for the Pilot control surface and portability contracts. Production project creation/cutover remains a separate gate.

## M2.4.5 H2 portability update — 2026-09-03 11:46 AEST

CF-089 adds Pilot-only Layer 2 configuration/runtime artefacts that must be included in the existing Production migration inventory when M2.5 resumes:
- database migrations `cf_089_scraper_config_profile_options`, `cf_089_parsebot_provider_contract`, `cf_089_provider_probe_telemetry`;
- Edge Function `layer2-provider-control` advanced to v3;
- `layer2-acquire-v2` advanced to v11;
- `layer2-scope-discover-scheduled` advanced to v21;
- Parse.bot provider registry metadata now records generated-API integration semantics.

No Production target status was advanced. No Production project, secret, Storage object, cron or consumer endpoint was created by CF-089. Existing Production migration manifest rows therefore remain target-pending; the source inventory must deploy these migrations/functions when the separate Production tenancy is later authorised.
