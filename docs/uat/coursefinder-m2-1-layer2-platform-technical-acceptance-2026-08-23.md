# CourseFinder M2.1 Layer 2 Platform — Technical Acceptance

**Date:** 23 August 2026  
**Change Control:** `CF-CHG-20260823-029`  
**Gate:** M2.1 — Layer 2 Enrichment Platform & Source/Provider Configuration Foundation  
**Status:** **BLOCKED — deployed desktop/mobile browser evidence unavailable**

## 1. Acceptance statement

M2.1 is implemented at database/API/Edge-control-plane level and mirrored in `msinghbs-ai/Coursefinder-Pilot`. Database/API/security and baseline-regression checks are PASS. Final acceptance is not closed because the current Pilot SHA has not published the required SHA-bound deployed Playwright desktop/mobile status/artifacts.

The latest provider expansion adds the API mechanisms requested for Direct HTTP, Scrape.do, ScraperAPI, Firecrawl, ZenRows and a Custom gateway, plus a provider-compatible Layer 2 extraction-input worker. No external provider success is claimed until its actual API credential is configured through the Vault-backed Admin control and bounded live UAT succeeds.

## 2. Implemented Layer 2 model

1. **Source Profile** — authority, discovery/URL scope, parser/mapping semantics, freshness/Evidence policy and immutable version.
2. **Acquisition Provider** — reusable transport/API provider, endpoint, auth mechanism, Vault credential reference, capability and limits.
3. **Source → Provider Route** — provider order, required capabilities, request overrides, Evidence policy and fallback reasons.
4. **Provider Attempt / Raw Evidence** — every acquisition attempt is linked to exact Job/profile version/provider and its raw Evidence.
5. **Provider-compatible Extraction Input** — `layer2-extract` converts provider-native responses to one normalised Evidence shape for downstream deterministic/AI extraction.

Authority remains:

`Source Profile → Provider Route → Job → Provider Attempt → Raw Evidence → Normalised Extraction Input → Observation/Extraction → Mapping → Review → Search Admission → Publication`.

Acquisition/extraction input never directly authorises canonical writes.

## 3. Current source configuration state

- Source Profiles: **5**.
- Source Profile versions: **10** after governed correction of initial malformed base domains; all five current versions are v2/valid.
- Job and Evidence carry exact source-profile version.
- Source-bound URL validation prevents arbitrary proxy use.

Current source base domains:

- RMIT: `https://www.rmit.edu.au`;
- UQ: `https://study.uq.edu.au`;
- QILT: `https://qilt.edu.au`;
- PRISMS: `https://www.education.gov.au`;
- Study Australia Scholarships: `https://search.studyaustralia.gov.au`.

## 4. Provider catalogue — implemented

| Priority | Provider | API mechanism | Authentication | Response adapter | Credential state |
|---:|---|---|---|---|---|
| 10 | Direct HTTP | direct governed source GET | none | `passthrough` | N/A |
| 20 | Scrape.do | GET `https://api.scrape.do/`; target query `url`; render mode | query `token` | `passthrough`; `scrape_do_json` supported | not configured |
| 30 | ScraperAPI | GET `https://api.scraperapi.com/`; target `url`; `render=true` | query `api_key` | `passthrough` | not configured |
| 40 | Firecrawl | POST `https://api.firecrawl.dev/v2/scrape`; body `url` + formats markdown/html/screenshot | bearer | `firecrawl_v2` | not configured |
| 50 | ZenRows | GET `https://api.zenrows.com/v1/`; `url`, `js_render=true`, `premium_proxy=true` | query `apikey` | `passthrough` | not configured |
| 90 | Custom gateway (`{url}` template) | configurable API gateway | configurable header; seed `X-API-Key` | `generic` | disabled / not configured |

Provider registry count: **6**.

Current route count: **17**.

RMIT, UQ and Study Australia route order:

`Direct HTTP → Scrape.do → ScraperAPI → Firecrawl → ZenRows`.

PRISMS and QILT remain Direct HTTP-only by default because their approved source is a deterministic downloadable file.

## 5. Provider-compatible extraction worker — implemented

Edge Function `layer2-extract` v1 is **ACTIVE** and `verify_jwt=true`.

Input: `attempt_id`.

The worker:

- re-authenticates the caller and requires rank >=4;
- resolves the Provider Attempt/provider response adapter/raw Evidence;
- downloads source Evidence from the private `evidence` bucket;
- normalises text, HTML, structured JSON and visual references;
- creates a new hashed/versioned private Evidence artifact with `evidence_type='layer2_extraction_input'`;
- records `canonical_mutation_authorised=false`;
- updates attempt extraction status to `normalised` when content is usable;
- returns `fallback_required=true` and marks `extraction_failed/blocked` if no extractable text/structured/visual payload exists.

Adapter compatibility:

- `passthrough`: Direct HTTP, Scrape.do, ScraperAPI, ZenRows;
- `firecrawl_v2`: Firecrawl nested markdown/HTML/JSON/screenshot-reference response;
- `scrape_do_json`: Scrape.do JSON/screenshot-return response if configured;
- `generic`: custom gateway using configurable common text/screenshot paths.

This worker is intentionally **not an LLM**. It provides a provider-independent Layer 2 Evidence contract to deterministic extractors and Layer 3 AI so vendor response parsing is not duplicated across domain workers.

## 6. Credentials/security — PASS

Verified design/runtime boundary:

- provider API credentials are write-only in Admin and stored in Supabase Vault;
- browser projection exposes `credential_configured`, never decrypted secrets or Vault IDs;
- provider mutation/runtime-credential functions remain service-role only;
- new provider tables are RLS-enabled with no direct browser table grants;
- secret-like keys in provider request/capability JSON are rejected/sanitised;
- all four M2.1 Edge controls/runtimes are JWT protected;
- source host allowlist is enforced before acquisition;
- provider API keys were not fabricated or entered by this workstream.

## 7. Evidence / fallback — PASS at contract level

- Raw provider response is captured as private Evidence before successful acquisition is reported.
- Provider Attempt records source-profile version/provider/HTTP/MIME/blocker/metrics/Evidence links.
- Extraction-blocked path retains original Evidence and can request the next provider route using existing `extraction_failed` fallback semantics.
- Screenshot capability is declarative only when provider-supported; no screenshot artifact is fabricated.
- Firecrawl/provider JSON screenshot references can be retained in normalised Evidence. A later provider-trial hardening gate may materialise remote screenshot URLs/base64 payloads as distinct private image artifacts when required.

## 8. M1 regression — PASS

Latest live post-expansion state:

- acquisition providers: **6**;
- provider routes: **17**;
- Search documents: **33,105**;
- Search published: **0**;
- canonical Courses: **43,461**;
- canonical Courses unpublished: **43,461**.

No provider/extraction migration or Edge Function authorises canonical or Search writes.

## 9. Pilot repository evidence

Repository mirrors include:

- `supabase/migrations/20260823113300_m2_1_layer2_provider_catalog_expansion.sql`;
- `supabase/functions/layer2-extract/index.ts`;
- `tests/uat/layer2-provider-deployed.spec.mjs` updated for all six provider labels and the five-provider RMIT route.

Relevant commits:

- `37d36fe65f182bb36093be7323c34c6c1919085a` — provider catalogue migration mirror;
- `3c8af292014dd22fe05bed52049e0e1f3c35906c` — provider-compatible extraction worker mirror;
- `567a9bb2ce3cbbb5fff6ba3406b08f867cc957cf` — deployed provider catalogue browser UAT assertions.

Latest Pilot main observed for this acceptance check: `567a9bb2ce3cbbb5fff6ba3406b08f867cc957cf`.

## 10. Deployed browser UAT expected coverage

The governed Playwright suite requires desktop/mobile verification of:

1. `L2 Providers` launcher and registry;
2. Direct HTTP, Scrape.do, ScraperAPI, Firecrawl, ZenRows and Custom gateway visibility;
3. RMIT five-provider route ordering/visibility;
4. credential non-disclosure and write-only credential control;
5. bounded PRISMS Direct HTTP acquisition with private versioned Evidence;
6. existing Layer 2 source configuration/version/diff behavior;
7. no server/runtime errors and retained screenshots/artifacts.

## 11. Current blocker evidence

Latest combined-status check for Pilot SHA `567a9bb2ce3cbbb5fff6ba3406b08f867cc957cf` returned no SHA-bound statuses (`statuses: []`). The available connected GitHub surface does not expose a usable push-workflow dispatch/list path for reconstructing the governed desktop/mobile run independently.

Therefore this gate remains **BLOCKED**, not PASS.

## 12. Provider-trial dependency

For Scrape.do, ScraperAPI, Firecrawl and ZenRows live UAT:

1. open **L2 Providers**;
2. select the provider;
3. use **Set / rotate API credential**;
4. the value is written to Vault and never displayed again;
5. run bounded acquisitions against representative source profiles;
6. invoke `layer2-extract` for each successful Provider Attempt;
7. compare acquisition success, anti-bot/JS coverage, Evidence quality, extraction success, latency, reliability and operational cost;
8. deliberately test extraction failure → next-provider fallback.

Secrets must not be pasted into profile JSON, source code, documentation or chat logs.

## 13. Closure requirement

M2.1 may change to `CLOSED / PASS` only after:

- current deployed desktop UAT PASS;
- current deployed mobile UAT PASS;
- SHA/run/artifact evidence retained;
- bounded acquisition Evidence lineage confirmed;
- exact M1 regression re-confirmed;
- Change Control/Register/Running Build/Master Plan reconciled without overwriting newer parallel M2 work.
