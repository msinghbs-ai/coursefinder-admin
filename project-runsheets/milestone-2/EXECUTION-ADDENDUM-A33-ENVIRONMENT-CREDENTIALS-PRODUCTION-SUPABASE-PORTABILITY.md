# Execution Addendum A33 — Environment Credentials & Production Supabase Portability

**Status:** ACTIVE / IMPLEMENTED IN PILOT  
**Date:** 3 September 2026  
**Change:** CF-CHG-20260903-084

## Standing rule
Environment-specific credentials, project refs, origins, quotas and migration status must be centrally visible in Administration. Secrets remain write-only.

## Secrets
- never return secret values to browser reads;
- Layer 2 acquisition credentials use Provider Vault records;
- Layer 3 credentials use Layer 3 Vault records;
- generic integration credentials use the integration secret registry + Vault;
- Production credentials should be rotated/re-entered for Production unless an accepted restore method proves secret-key portability;
- never copy Pilot Supabase publishable/secret keys into Production.

## Production tenancy
Production is a separate Supabase trust boundary. The target project must be separately identified and accepted.

The migration manifest must remain open until each required component is verified.

## Storage / Evidence
Preserve:
- bucket names;
- object paths;
- Evidence content hashes;
- source URLs;
- Evidence IDs/database relationships.

Do not persist environment-specific signed Storage URLs as canonical links. Generate them at request time from the current project.

## Schedules
Recreate/verify cron jobs after target functions/secrets/settings are ready. Do not allow Production schedulers to call Pilot endpoints or consume Pilot credentials.

## Origins
Production Admin/consumer origins are environment settings. Hard-coded Pilot origins must be eliminated or replaced during Production deployment verification.

## Vendor quota
Vendor entitlement belongs to governed provider configuration. When a paid plan changes, update the recorded monthly entitlement/reserve through Administration; do not require code changes.

## Parse.bot
Credential/endpoint can be prepared in Admin but adapter remains disabled until bounded UAT qualifies the actual trial contract.

## Consumer gate
Website/Wix/Zoho endpoint/key changes remain separate consumer admission/cutover work.
