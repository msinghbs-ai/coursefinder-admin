# CourseFinder Production Supabase Migration & Environment Controls v1.0

**Status:** CURRENT PRODUCTION-READINESS DESIGN  
**Date:** 3 September 2026  
**Authority:** CF-CHG-20260903-084 / A33

## 1. Goal
Move CourseFinder from Pilot to a clean Production Supabase project in a different tenancy/project without breaking canonical IDs, Evidence lineage, Storage references, background schedules or integration contracts.

## 2. Migration principle
The Production migration is a multi-plane migration, not only a database restore.

| Plane | Source of truth | Production treatment |
|---|---|---|
| Database schemas/data/indexes/RLS/functions | Repository migrations + Pilot database | clone/restore then verify migrations/counts/security |
| Auth user data | Supabase Auth schema | migrate with accepted database clone/restore; verify Auth config separately |
| Vault secrets | Vault + Admin credential registry | preferably rotate/re-enter; if copied by supported restore, verify decryptability |
| Storage bucket configuration | migrations/runtime inventory | recreate exactly |
| Storage object bytes | Supabase Storage | copy separately preserving bucket + object path |
| Evidence links | `source_url` + relative `storage_path` | preserve values; regenerate signed URLs in target |
| Edge Functions | Git repository | deploy accepted revision to Production |
| Edge Function secrets | Admin/Vault/deployment config | configure per Production environment |
| pg_cron | migrations/runtime manifest | recreate disabled/controlled, then enable after prerequisites |
| Extensions/project settings | Supabase project | verify/reconfigure explicitly |
| Frontend Supabase config | deployment environment | set Production URL + target publishable key |
| CORS/origins | environment/deployment config | replace Pilot origins with Production origins |
| Website/Zoho/API consumers | later consumer gate | reconfigure only when separately authorised |

## 3. Admin control surface
Platform Admin uses:
`Administration → Environment & Migration`.

It contains:
- Integration credentials & quota controls;
- Production target non-secret settings;
- Migration manifest with target status;
- live portability telemetry.

## 4. Credential policy
### Supabase project keys
Production uses its own project-generated publishable and secret keys.
Do not store the Production secret key in browser-readable settings.

### Layer 2 acquisition
Credentials stay in Vault and are write-only:
- Firecrawl;
- Parse.bot;
- Scrape.do;
- ScraperAPI;
- ZenRows;
- future registered providers.

### Layer 3
OpenRouter credentials use the existing Layer 3 Vault contract.

### Contact enrichment
Apollo now prefers the generic Vault integration key.

### Automation
Pilot automation credentials are not Production credentials. Create/rotate a dedicated Production automation key.

## 5. Firecrawl plan changes
Provider billing configuration contains the operational entitlement:
- monthly vendor units;
- safety reserve / stop-at threshold;
- plan metadata.

If the vendor plan is increased, update these values in Admin. Budget-aware wave clamping must read the persisted provider configuration.

## 6. Parse.bot onboarding
Admin provision exists before the trial arrives:
1. enter endpoint;
2. store API key write-only;
3. keep disabled;
4. run bounded adapter/response/cost UAT;
5. enable only approved routes;
6. retain Direct HTTP before paid provider fallback.

## 7. Evidence portability
Pilot audit at CF-084:
- 17,400 Evidence rows;
- 17,391 relative Storage paths;
- 0 absolute Storage paths;
- 0 Pilot Supabase URLs in Evidence source/metadata;
- 2 Provider asset rows, both relative.

This is the preferred portable model.

Migration must copy Storage objects to identical bucket/object paths. Evidence rows do not need URL rewriting when paths remain relative.

## 8. Production sequence
1. approve target Supabase organisation/tenancy, region and project cost;
2. create clean Production project;
3. record target project ref/URL/region/origins in Admin;
4. establish database using accepted clone/restore/migration approach;
5. verify schema migration history, RLS/grants, functions and canonical row counts;
6. configure/rotate Vault and integration credentials;
7. create/verify Storage buckets;
8. copy all Storage objects preserving exact paths;
9. verify sampled Evidence SHA-256 and Provider assets;
10. deploy all accepted Edge Functions;
11. configure Production-only custom secrets and origins;
12. configure Auth site/redirect URLs and target-generated publishable/secret keys;
13. recreate cron schedules but hold automatic work until prerequisites pass;
14. verify extensions/settings;
15. update Admin frontend environment to Production URL/publishable key;
16. execute security, role, Evidence, scheduler and restore UAT;
17. enable Production schedules;
18. only later update Website/Zoho consumer endpoints under their own gate.

## 9. Acceptance minimum
Production cannot be accepted if:
- any required manifest component is pending/blocked;
- any Production deployment references the Pilot project ref/origin/key;
- Evidence object counts/paths do not reconcile;
- sampled Evidence hashes fail;
- Edge Function inventory is incomplete;
- secrets are missing or exposed;
- Auth/RLS negative tests fail;
- cron calls Pilot endpoints;
- restore/recovery gate remains unproven.

## 10. Rollback
Production cutover rollback must not mutate/delete Pilot Evidence or canonical history. Disable Production schedules/consumers, restore routing to the accepted prior endpoint, retain failed Production evidence for audit and correct the target environment before retry.


## 11. Database-to-Edge runtime binding

Database Edge dispatch must not use project-ref literals.

Environment & Migration owns:
- `runtime_edge_base_url`;
- `runtime_automation_integration_key`.

Pilot uses its Pilot URL and `pilot_automation`. Production must be rebound to its target Functions base URL and `production_automation` before any scheduler is enabled.

## 12. Website and Zoho bearer tokens

Existing consumer auth is hash-only:
- `private.zoho_integration_credentials`;
- `private.website_integration_credentials`.

Raw Pilot tokens cannot be recovered from these tables. This is intentional.

Production procedure:
1. do not attempt to copy/recover the raw Pilot token;
2. create a new random Production bearer token for each consumer;
3. enter it through Administration → Environment & Migration while connected to Production;
4. securely provide that same new token to the authorised Zoho/Website integration owner;
5. perform bounded auth/rate-limit contract UAT;
6. cut the consumer endpoint over only under its separate gate.
