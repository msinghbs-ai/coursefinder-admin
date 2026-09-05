# CourseFinder Integration Handover Router

**Status:** CURRENT ROUTER  
**Effective:** 5 September 2026

Use this file to identify the current developer handover. Do not infer currentness from filename ordering alone.

## Wix / Website

**Current:** `coursefinder-wix-api-handover-v1.1.md`  
**Previous:** `coursefinder-wix-api-handover-v1.0.md`

### Versioning rule

Every new Wix handover version must be a complete, independently usable developer handover.

- Put `Changes since previous version` at the top.
- Repeat the full current endpoint, auth, architecture, cache, data contract, testing, support and cutover instructions.
- Do not publish patch-only addenda that require a developer to combine multiple documents.
- Use a minor version for additive/backward-compatible changes.
- Use a major version for breaking API-contract or integration-architecture changes.
- Retain previous handovers as immutable historical evidence.
- Never store raw API keys in handover files or Git history.

## Credential ownership

External-consumer API credentials are owned by the CourseFinder Admin/API Key Lifecycle control plane. Wix, Zoho and other consumers receive dedicated environment-specific credentials. They must never receive Supabase `service_role` or vendor/scraper secrets.
