# CourseFinder Zoho Developer Handover v1.0

**Date:** 1 September 2026  
**Environment:** Pilot only  
**Change Control:** CF-CHG-20260827-045

## Endpoint

- Supabase project ref: `fxcwkweaxjtknorudmwp`
- Region: `ap-south-1` (Mumbai)
- HTTP endpoint: `https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/zoho-course-api`
- Edge Function: `zoho-course-api` v11 ACTIVE
- Method: POST
- Content-Type: `application/json`

## Authentication

Use the dedicated CourseFinder Pilot integration token.

Preferred header:

```text
Authorization: Bearer <COURSEFINDER_PILOT_INTEGRATION_TOKEN>
```

Alternative:

```text
x-cf-token: <COURSEFINDER_PILOT_INTEGRATION_TOKEN>
```

Do **not** use or request the Supabase service_role key. The connector does not require a Supabase anon key.

The raw integration token is intentionally not stored in this repository. Transfer it out-of-band.

## Proven JSON tests

### Exact Course lookup
```json
{"action":"lookup","identifier":"082960F"}
```

Verified: Bachelor of Nursing (Honours), The University of Queensland.

### Course search
```json
{"action":"search","query":"nursing","country_codes":["AU"],"limit":10,"offset":0}
```

Earlier validated AU Nursing baseline: 330 results.

### Provider options
```json
{"action":"provider_options","query":"RMIT","country_code":"AU","limit":10,"offset":0}
```

### Country options
```json
{"action":"filter_options","kind":"country","limit":10,"offset":0}
```

### AU subdivisions
```json
{"action":"filter_options","kind":"subdivision","country_code":"AU","limit":10,"offset":0}
```

### Reference/cache bundle
```json
{"action":"reference_bundle"}
```

Current backend bundle includes countries, subdivisions, providers, platform_stats and `course_filters`.

## Search v2 optional fields

The public action remains `search`. Edge Function v11 supports:

- `country_codes[]`
- `subdivision_codes[]`
- `provider_ids[]`
- `study_level_codes[]`
- `primary_field_codes[]`
- `delivery_modes[]`
- `has_scholarship`
- `has_intake`
- `has_english`
- `has_provider_current_tuition`
- `has_regulatory_tuition`
- `has_link`
- `intake_years[]`
- `intake_labels[]`
- `english_test_codes[]`
- provider-current and regulatory tuition ranges
- `publication_statuses[]`
- `limit` / `offset`

## Cache-first design

Validated reference bundle:

- 3 countries/status records
- 21 subdivisions
- 3,085 providers
- 22 study levels
- 79 study areas
- 4 intake labels
- 4 English tests
- platform/filter coverage metadata

Use a daily `reference_bundle` refresh into Zoho cache. Reserve live API calls for explicit Course Search and Course Lookup.

## Current semantic boundaries

- Regulatory tuition and Provider-current annual tuition are separate facts.
- QILT is contextual at Provider / study-area grain and is not currently admitted as a Course fact.
- PRISMS is contextual at Provider / State / sector grain and is not currently admitted as a Course fact.
- Empty scholarship arrays do not prove no scholarship exists.
- Canada is Beta/Limited.
- Zoho is a downstream consumer and has no canonical-write/publication authority.

## Errors

- 200: success; search no-results returns empty `items`
- 400: malformed/unsupported input
- 401: missing/invalid integration token
- 404: exact lookup not found
- 429: rate limit; honour Retry-After
- 503/5xx: bounded CourseFinder service failure

## Parallel developer acceptance

Before wiring UI, prove:
1. lookup `082960F`
2. search Nursing/AU
3. provider_options RMIT/AU
4. country filter
5. AU subdivision filter
6. reference_bundle
7. Search v2 filter payload
8. invalid-token 401
9. no secret/service-role exposure to browser/widget

No Zoho Production cutover is authorised by this handover.
