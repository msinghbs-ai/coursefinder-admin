# CourseFinder Website Developer Search / Read Contract v1.0

**Date:** 25 August 2026  
**Status:** FRIDAY TECHNICAL DISCUSSION / PILOT PREVIEW  
**Authority:** CF-CHG-20260825-033  
**Important:** This contract is not broad Publication authority and is not yet a browser-public Production API.

## 1. Boundary

The website must consume a bounded Search/read service contract. It must not query raw `catalogue.*`, `search.*`, `pipeline.*`, Evidence, review or Vault tables.

Current Pilot preview functions are intentionally **service-role-only**:

- `api.website_course_lookup_preview_v1(text)` — exact Course code/stable-ID preview;
- `api.website_course_search_preview_v1(...)` — deterministic FTS/filter preview.

Anon/authenticated EXECUTE is revoked. A later consumer release gate must place the contract behind the final approved server/API boundary before website use.

## 2. Request inputs

### Exact lookup

`identifier`: stable public Course identifier or regulatory/public Course code.

### Search

Supported preview inputs:

- `query`;
- `country_codes[]`;
- `provider_keys[]`;
- `provider_name`;
- `subdivision_codes[]`;
- `level_codes[]`;
- `field_codes[]`;
- `delivery_modes[]`;
- `provider_annual_tuition_min`;
- `provider_annual_tuition_max`;
- `has_intake`;
- `has_english`;
- `has_scholarship`;
- `sort`: `relevance`, `title`, `provider_annual_tuition_asc`, `provider_annual_tuition_desc`, `earliest_intake`;
- `limit`: default 20, capped at 50;
- `offset`: non-negative pagination offset.

Website routing should treat exact code/ID lookup separately from text relevance. Deterministic filters must remain hard constraints and must not be overridden by future semantic ranking.

## 3. Result DTO

Consumer-safe Course result fields currently demonstrated:

- `course_id` — stable public Course identifier;
- `title`;
- `course_code`;
- `provider.provider_id`;
- `provider.name`;
- `country`;
- `study_level`;
- `field.code` / `field.name`;
- `locations[]`;
- `delivery_modes[]`;
- `regulatory_tuition`:
  - `state`;
  - `amount`;
  - `currency`;
  - `basis`;
- `provider_current_tuition`:
  - `has_value`;
  - `annual_amount`;
  - `annual_currency`;
  - `options[]`;
- `official_course_url`;
- `intakes[]`;
- `english_requirements[]`;
- `scholarships[]`;
- `visibility.publication_status`;
- `freshness.source_updated_at`;
- `freshness.generated_at`;
- `match.mode`;
- `match.keyword_score`.

Contract metadata includes:

- contract version;
- boundary (`server-side-showcase-only` during M2.2);
- Search mode;
- Search Projection version `course-v3`;
- projection generation/hash;
- pagination/sort;
- `publication_authority: not_granted`.

## 4. Fee semantics

Website presentation must preserve two distinct concepts:

1. **Regulatory tuition** — CRICOS/NZ regulatory source meaning at its real basis;
2. **Provider-current tuition** — current Provider-derived fee fact where accepted.

They must not be merged into one unlabeled “tuition” value. Fee year/basis must be shown when supplied.

## 5. Current enrichment coverage

Current AU+NZ Search Projection: 33,105 Courses.

- regulatory tuition: 26,457;
- Provider-current tuition: 10;
- Intake: 10;
- English: 10;
- official Course URL: 10;
- Scholarship: 0 in current Search Projection.

The website must treat unavailable fields as unavailable. It must not infer/fabricate missing Scholarship, fee, Intake or English data.

## 6. Example exact request/response

Conceptual server call:

```json
{
  "identifier": "082960F"
}
```

Representative real Pilot response shape:

```json
{
  "contract_version": "website-course-lookup-preview-v1",
  "boundary": "server-side-showcase-only",
  "meta": {
    "mode": "exact",
    "projection_version": "course-v3",
    "publication_authority": "not_granted"
  },
  "item": {
    "course_id": "course:cricos:00025b:082960f",
    "title": "Bachelor of Nursing (Honours)",
    "course_code": "082960F",
    "provider": {
      "provider_id": "provider:cricos:00025b",
      "name": "The University of Queensland"
    },
    "country": "AU",
    "study_level": "bachelor_honours",
    "locations": ["AU-QLD"],
    "regulatory_tuition": {
      "state": "present",
      "amount": 37920,
      "currency": "AUD",
      "basis": "registered_total_course"
    },
    "provider_current_tuition": {
      "has_value": true,
      "annual_amount": 48080,
      "annual_currency": "AUD"
    },
    "visibility": {
      "publication_status": "unpublished"
    }
  }
}
```

The example demonstrates the DTO only. The `unpublished` state is deliberate and does not authorise public display.

## 7. Example filtered request

```json
{
  "query": "nursing",
  "country_codes": ["AU"],
  "subdivision_codes": ["AU-QLD"],
  "provider_annual_tuition_max": 50000,
  "has_intake": true,
  "has_english": true,
  "limit": 5,
  "offset": 0
}
```

Pilot UAT returned the UQ Bachelor of Nursing (Honours) with the hard filters preserved and separate regulatory/provider-current fee semantics.

## 8. Error and input semantics

Final server/API implementation should use:

- `400` malformed/unsupported input;
- `401` missing authentication where authentication is required;
- `403` authenticated but not authorised;
- `404` exact public identifier not found where an exact resource route is used;
- `429` rate limit;
- `5xx` server failure without leaking SQL/secrets/internal paths.

Search no-results should normally be `200` with an empty `items` array rather than an application error.

## 9. Performance expectations

Current database evidence:

- direct indexed AU FTS for `data science`: about 18 ms execution in measured database UAT;
- initial combined exact+FTS preview design was rejected after a sequential-plan regression;
- exact lookup and FTS have now been separated, but the richer JSON preview wrapper remains under optimisation and is not yet a Production latency PASS.

The Production consumer gate must establish an agreed p50/p95 target and measure the actual final network/API path, not only database execution.

## 10. Vector / hybrid behaviour

pgvector is available in the database but is not an accepted Search mode yet. No governed embedding model/profile or embedding corpus currently exists.

If a later benchmark accepts vector/hybrid:

- structured filters remain deterministic hard constraints;
- vector never establishes Course identity;
- vectors are not returned to browser clients;
- result metadata identifies ranking mode/profile;
- embedding/model/profile version is reproducible;
- publication/visibility constraints remain authoritative.

Until then, website developers should design against exact + deterministic FTS/filter semantics.

## 11. Explicitly excluded fields

Never expose through this consumer DTO:

- Evidence IDs or Storage paths;
- raw Evidence payloads;
- review IDs/comments;
- Layer 2 Provider credentials or attempt internals;
- Vault content;
- service-role/secret details;
- internal Change Control-only metadata;
- raw canonical CRUD surfaces;
- embedding vector values.

## 12. Next contract decision

The next consumer gate must decide the final server/API transport, authentication/rate-limit model, pagination cursor strategy if required, browser-safe release surface, Production publication state and performance SLO. M2.2 deliberately stops before granting those authorities.
