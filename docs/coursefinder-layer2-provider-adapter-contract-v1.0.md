# CourseFinder Layer 2 Provider Adapter Contract v1.0

**Effective:** 23 August 2026  
**Status:** CURRENT — M2.1 IMPLEMENTED / FINAL BROWSER UAT BLOCKED  
**Change Control:** `CF-CHG-20260823-029`

## Purpose

This contract defines how Layer 2 acquisition providers plug into CourseFinder without provider-specific canonical schema or provider-specific downstream extractors.

## Authority boundary

`Source Profile → Provider Route → Acquisition Job → Provider Attempt → Raw Evidence → Normalised Extraction Input → Observation/Extraction → Canonical Mapping → Review → Search Admission → Publication`

Provider selection changes the technical acquisition mechanism only. It does not change source authority, canonical identity, field meaning, Search admission or publication authority.

## Provider catalogue

| Provider | API mechanism | Auth | Acquisition behaviour | Response adapter | Extraction input |
|---|---|---|---|---|---|
| Direct HTTP | direct HTTP GET to governed source URL | none | source response captured as-is | `passthrough` | HTML/text/JSON/binary Evidence normalised directly |
| Scrape.do | scraper API GET; target `url`; rendered mode | query `token` | anti-bot/JS/proxy acquisition; screenshot-capable mode supported | `passthrough`; optional `scrape_do_json` | rendered HTML/JSON or screenshot-bearing JSON normalised |
| ScraperAPI | scraper API GET; target `url`; `render=true` | query `api_key` | anti-bot/proxy/JS acquisition; screenshot request supported | `passthrough` | returned HTML/JSON/image Evidence normalised |
| Firecrawl | `POST /v2/scrape`; body contains source `url` and requested formats | bearer | browser-based scrape returning markdown/HTML/JSON/screenshot references | `firecrawl_v2` | `data.markdown`, HTML, structured JSON and visual reference normalised |
| ZenRows | scraper API GET; target `url`; `js_render=true`; `premium_proxy=true` | query `apikey` | rendered/anti-bot premium-proxy acquisition | `passthrough` | returned HTML/JSON Evidence normalised |
| Custom gateway | configured API base URL/template | configurable; seeded header `X-API-Key` | operator-defined governed gateway; disabled until configured | `generic` | common configured JSON text/HTML/screenshot paths normalised |

Credentials are never stored in this contract, Source Profile JSON or browser-readable provider configuration. They are write-only through Admin and stored in Supabase Vault.

## Routing

Web/search Source Profiles may have multiple ordered provider routes. Current seeded order is:

`Direct HTTP → Scrape.do → ScraperAPI → Firecrawl → ZenRows`.

Fallback occurs only for configured reasons such as `blocked`, timeout, HTTP 403/429/5xx or `extraction_failed`.

File-oriented PRISMS/QILT sources remain on Direct HTTP unless evidence shows an API/browser provider is technically necessary.

## Acquisition worker contract

`layer2-acquire` is the common acquisition worker. Provider-specific behaviour is data-driven from provider `adapter_type`, `base_url`, auth mechanism and `request_template`.

Required controls:

- authenticated JWT and role check;
- target URL must match Source Profile governed domains/URLs;
- provider must be enabled and credential-ready when auth is required;
- required route capabilities must be satisfied;
- timeout/payload limits apply;
- every attempt is persisted before/after execution;
- response bytes are hashed and stored in private Evidence;
- the exact Source Profile version remains on Job/Evidence;
- acquisition result declares `canonical_mutation_authorised=false`.

## Extraction worker compatibility

`layer2-extract` is the common provider-compatible normalisation worker. It does not contain canonical domain semantics and does not call an LLM.

Input:

- `attempt_id`.

Output is a private `layer2_extraction_input` Evidence object with a stable common shape:

```json
{
  "layer": 2,
  "attempt_id": "...",
  "job_id": "...",
  "provider_key": "...",
  "response_adapter": "...",
  "source_evidence_id": "...",
  "source_url": "...",
  "text": "... or null",
  "html": "... or null",
  "structured": {},
  "screenshot": "... or null",
  "screenshot_evidence_id": "... or null",
  "canonical_mutation_authorised": false
}
```

Downstream deterministic domain extractors and Layer 3 AI consume this common input rather than parsing Scrape.do/ScraperAPI/Firecrawl/ZenRows responses independently.

## Adapter rules

### `passthrough`

For HTML, content is exposed as text + HTML. For JSON, common fields such as markdown/html/content/body/text are surfaced while the full structured response is retained.

### `firecrawl_v2`

Uses Firecrawl's nested `data` response. Surfaces markdown/content/text, HTML/rawHtml, structured `data.json` where present and screenshot/screenshot URL references.

### `scrape_do_json`

Supports Scrape.do JSON-return mode, including common content/HTML fields and screenshot image paths. It may be selected later through provider configuration without another schema change.

### `generic`

Custom gateways may provide configured `extraction_text_paths` and `screenshot_paths`. This remains configuration-driven and must not contain credentials.

## Screenshot handling

`screenshot=true` capability means a provider can be configured to return a visual result. It does not mean every acquisition will produce a screenshot.

- image response bytes are first-class private Evidence;
- provider JSON screenshot references are preserved in normalised extraction input;
- a later provider-trial hardening step may materialise returned remote screenshot URLs/base64 values into a separate private `layer2_screenshot` artifact where required;
- screenshot absence is not silently substituted with a fabricated artifact.

## Extraction failure and fallback

If normalisation finds no usable text, HTML, structured content or visual payload, `layer2-extract` marks extraction blocked and returns `fallback_required=true`.

If later deterministic/AI semantic extraction cannot safely establish the requested fact, it must mark the Provider Attempt `extraction_failed` and use the existing next-provider fallback contract rather than retrying arbitrary URLs or inventing values.

All previous Evidence remains retained.

## Adding another provider

A new provider should normally require only:

1. provider key/name;
2. adapter type and API base URL;
3. auth scheme/field, with actual secret set separately in Vault;
4. capabilities;
5. request template;
6. response adapter (`passthrough`, existing provider adapter or `generic` paths);
7. source routes/priority/fallback policy;
8. bounded acquisition + extraction-input UAT.

A new database table or Provider-specific canonical column is not acceptable merely because a vendor API differs.

## Current acceptance boundary

Database/API/security implementation is present. External API provider credentials are currently not configured, therefore live Scrape.do/ScraperAPI/Firecrawl/ZenRows success is not claimed. Final M2.1 acceptance also remains blocked on the governed deployed desktop/mobile browser UAT evidence.