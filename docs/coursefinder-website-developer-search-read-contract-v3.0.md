# CourseFinder Website / Wix Developer Search Contract v3.0

**Date:** 2 September 2026  
**Status:** PILOT SERVER-SIDE INTEGRATION ACTIVE / WIX E2E PENDING  
**Change Control:** CF-CHG-20260902-066  
**Supersedes for active website integration:** `docs/coursefinder-website-developer-search-read-contract-v1.0.md`  
**Boundary:** Pilot only; no Production cutover or broad Publication authority.

## Runtime

- Project: `fxcwkweaxjtknorudmwp` / ap-south-1.
- Edge Function: `website-course-api` v1 ACTIVE.
- Endpoint: `https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/website-course-api`.
- Contract marker: `website-integration-v3-pilot`.
- Preferred auth: `x-cf-token: <COURSEFINDER_WEBSITE_WIX_PILOT_TOKEN>`.
- Website credential is independent of Zoho.
- Search/lookup remain server-side Pilot reads and do not grant public publication authority.

## Wix boundary

Wix browser code calls a Wix backend web method. The Wix backend retrieves the integration token from Wix Secrets Manager and calls the CourseFinder Edge Function. The raw token must never be returned to browser code, logged in page console output, committed to GitHub, or embedded in this contract.

## Actions

- `search`: deterministic Course search plus structured hard filters.
- `lookup`: exact stable Course ID or regulatory/public Course code.
- `provider_options`: Provider autocomplete.
- `filter_options`: country/subdivision options.
- `reference_bundle`: countries, subdivisions, providers, course facets and platform statistics for backend caching.

## Search v3 inputs

`query`, `country_codes[]`, `subdivision_codes[]`, `provider_ids[]`,
`study_level_codes[]`, `primary_field_codes[]`, `delivery_modes[]`,
`has_scholarship`, `has_intake`, `has_english`,
`has_provider_current_tuition`, `has_regulatory_tuition`, `has_link`,
`intake_years[]`, `intake_labels[]`, `english_test_codes[]`,
`min/max_provider_annual_tuition`, `min/max_regulatory_total_tuition`,
`publication_statuses[]`, `limit`, `offset`.

Website target page size is 12. Edge cap remains 50.

## Fast-query rules

1. Route exact Course IDs/codes to `lookup`; do not mix exact identity lookup with relevance search.
2. Use a 250-350 ms typeahead debounce and do not send Course search for 0-1 characters.
3. Send country/state/provider/level/study-area/fee/intake/English as structured filters, not words appended to `query`.
4. Do not call Course lookup once per search card. Search DTO fields render cards; lookup is detail-on-demand.
5. Use Provider `provider_options` for autocomplete instead of loading all Providers into browser state.
6. Keep offset pagination in v3. Cursor pagination may be considered only if scale/UAT proves a need.

## Cache model

- reference bundle / stable facets: Wix backend 6-24 hours;
- Provider autocomplete: 5-15 minutes per normalised country/query;
- optional popular anonymous Search payload: 30-120 seconds;
- optional Course detail: 1-5 minutes;
- never cache the raw token;
- browser keeps UI state only.

## Current Pilot availability snapshot

At 2 September 2026 the reference bundle reports:
- 33,105 AU/NZ Search Course documents;
- 26,457 with regulatory tuition;
- 10 with Provider-current tuition;
- 10 with Intake;
- 10 with English;
- 10 with official Course URL;
- 0 with an admitted Scholarship relationship;
- AU/NZ live regulatory coverage; Canada reference coverage is Beta/Limited.

The website must read availability dynamically from `reference_bundle`; do not hard-code these counts.

## Field semantics

- `course_id`: stable identity.
- `course_code`: public/regulatory code where available.
- `provider.provider_id`: stable Provider identity.
- `regulatory_tuition`: registered total-course meaning.
- `provider_current_tuition`: separate current/annual Provider meaning.
- `intakes[]`, `english_requirements[]`, `scholarships[]`: repeating admitted data.
- QILT remains contextual at Provider/study-area grain.
- PRISMS remains contextual at Provider/geography/sector/cohort grain.
- empty Scholarship arrays do not prove no Scholarship exists.
- Pilot `publication_status` is diagnostic and must not be reinterpreted as website publication authority.
- Layer 4 Search blocks remain enforced server-side.

## Rate/security

- `search`, `lookup`, `provider_options`, `filter_options`: 60 requests/minute each for the Website Pilot identity.
- `reference_bundle`: 12/minute.
- 429 returns `Retry-After`.
- No service role / database / Vault / Evidence credential is held by Wix.
- Production should add a CourseFinder-owned API gateway/proxy with WAF/bot/rate controls before public release.

## Vector / hybrid

pgvector availability does not constitute an accepted search mode. The v3 Wix integration remains deterministic exact + PostgreSQL FTS + hard filters. Future vector/hybrid must first establish governed embeddings/model/profile and benchmark relevance/performance. Structured filters, identity, Layer 4 blocks and publication remain authoritative.

## Validation

Runtime checks performed in Pilot:
- dedicated Website credential valid-hash auth: PASS;
- invalid-hash auth: PASS;
- Website rate window: PASS;
- website preview lookup `082960F`: Bachelor of Nursing (Honours) returned;
- Edge Function v1: ACTIVE.

External Wix/backend HTTP E2E remains the first developer acceptance action. The environment used to prepare this change could not resolve the public Supabase hostname, therefore no curl-based external-network PASS is claimed.

## Rollback

Disable/rotate the Website credential and undeploy/replace `website-course-api`. Schema tables/functions are private support infrastructure and can remain without granting any consumer visibility. Canonical data and Search projection rows are not mutated by this integration.
