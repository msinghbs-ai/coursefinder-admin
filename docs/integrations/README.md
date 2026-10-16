# CourseFinder Integration Handover Router

**Status:** CURRENT ROUTER  
**Effective:** 15 October 2026

Use this file to identify the current developer handover. Do not infer currentness from filename ordering alone.

## Wix / Website

**Requirements register:** `WEBSITE-DEVELOPER-REQUIREMENTS.md` (v1.5, 15 Oct 2026, developer pack issued, v1 marked for retirement): every website request, its status and the open work.

**Send to the developer (current, issue 3, 16 October 2026):** `developer-pack/` — `StudySearch-Website-API-v2-Developer-Guide` (.docx and .pdf; master .md), `StudySearch-Website-API-v2.openapi.json`, `StudySearch-Website-API-v2.postman_collection.json` (address `website-api-v2`). Rebuild with `developer-pack/build.sh`. The key goes separately by a secure channel. File names carry the API version (Platform Admin, 16 Oct 2026 12:05).

## Zoho

**Send to the Zoho developers (current, first issue, 16 October 2026):** `zoho-pack/` — `StudySearch-Zoho-API-v2-Developer-Guide` (.docx and .pdf; master .md), `StudySearch-Zoho-API-v2.openapi.json`, `StudySearch-Zoho-API-v2.postman_collection.json` (address `zoho-api-v2`). Rebuild with `zoho-pack/build.sh`. Keys go separately by a secure channel.

**Internal history (no longer sent):** `coursefinder-wix-api-handover-v2.md` (Version 2, contract website-search-v2, live on Pilot; StudySearch name; issued 14 October 2026, reissued the same day with institution type, then with New Zealand and Canadian coverage (O1), then with the sync action and display approval (v2.15.277))  
**Previous:** `coursefinder-wix-api-handover-v1.1.md`, `coursefinder-wix-api-handover-v1.0.md`  
**Version 2 rule (Platform Admin, 14 October 2026):** one document per contract. Additive changes reissue Version 2 with a new date and a change-log line (its section 21); a breaking change starts Version 3. The 3 and 8 October drafts were not filed.

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
