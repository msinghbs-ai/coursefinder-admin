# CourseFinder Admin/PIM Design Decisions v1.31

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 3 September 2026  
**Supersedes:** v1.30  
**Change Controls:** CF-CHG-20260903-083, CF-CHG-20260903-084

## Decisions 38–75
Decisions 38–75 from v1.30 remain authoritative and unchanged.

## Decision 76 — Environment controls are first-class Administration
Platform Admins use Administration → Environment & Migration for environment-specific settings, integration credentials, vendor entitlements and Production migration status.

## Decision 77 — Secret values are write-only
The UI may show configured/missing/rotation status but never retrieves an API key after save.

## Decision 78 — Provider quota changes are configuration
Firecrawl or other vendor-plan changes update provider billing/quota configuration in Admin; they do not require application source changes.

## Decision 79 — Parse.bot can be prepared but not implicitly enabled
Endpoint/key configuration is not adapter qualification. Parse.bot remains disabled until bounded UAT.

## Decision 80 — Production migration is multi-plane
Admin must show separate readiness for Database/Auth data, Vault, Storage bytes, Edge Functions, secrets, cron, extensions, CORS/origins, frontend keys and consumer endpoints.

## Decision 81 — Evidence paths are environment-portable
Canonical Evidence uses bucket-relative object paths and source URLs. Signed Storage URLs are generated for the current environment and are not canonical persisted links.

## Decision 82 — Production-generated Supabase keys are not copied
Production frontend/server deployments consume target-generated publishable/secret keys. Pilot keys are never treated as migration artefacts.

## Decision 83 — Consumer cutover remains separate
Environment readiness may record Website/Zoho endpoints/status but cannot authorise their Production cutover.
