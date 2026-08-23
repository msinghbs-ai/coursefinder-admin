# CF-CHG-20260823-029 — M2.1 Layer 2 Enrichment Platform Foundation

**Status:** BLOCKED — DEPLOYED BROWSER UAT EVIDENCE UNAVAILABLE  
**Category:** 40-layer2-enrichment  
**Initiated:** 23 August 2026 20:21 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** M2.1 Layer 2 Platform workstream  
**Change class:** schema / enrichment / UI / security / governance / documentation / operations

## Trigger

Milestone 2.1 authorised implementation gate following the accepted and frozen Milestone 1 Pilot baseline. Scope was subsequently clarified to require a reusable multi-provider acquisition plane and provider-compatible extraction-input worker rather than source-profile configuration alone.

## Outcome required

Layer 2 has two independent but linked configuration planes:

1. **Source Profiles** define source authority, discovery/URL scope, deterministic parser/mapping semantics, stable identity strategy, freshness/Evidence policy and immutable version.
2. **Acquisition Providers** define how a governed source is fetched: Direct HTTP, scraper API, browser/rendering API, structured proxy or custom gateway, with server-side credentials, capabilities, request templates, limits and operational state.

The runtime sequence is:

`Source Profile → Provider Route → Acquisition Job → Provider Attempt → Raw Evidence → Provider-compatible Extraction Input → Observation/Extraction → Canonical Mapping → Review → Search Admission → Publication`.

Acquisition or extraction-input success never authorises canonical mutation, Search admission or Publication.

## Affected surfaces

- `pipeline.sources`, `pipeline.jobs`, `pipeline.evidence_artifacts`;
- `pipeline.layer2_source_profiles`, `pipeline.layer2_source_profile_versions`;
- `pipeline.layer2_acquisition_providers`, `pipeline.layer2_profile_provider_routes`, `pipeline.layer2_provider_attempts`;
- Supabase Vault provider credentials;
- private Storage bucket `evidence`;
- `public.admin_read(text,jsonb)`;
- Edge Functions `layer2-config-control`, `layer2-provider-control`, `layer2-acquire`, `layer2-extract`;
- Pilot Admin `Layer 2 Config` and `L2 Providers`;
- automated database/security/API/deployed-browser UAT;
- Layer 2 operational/design documentation.

## Semantic impact

No canonical identity or accepted field semantics change. Layer 1 authority remains unchanged. Provider choice is a technical acquisition concern and must not alter the semantic meaning or authority of a Source Profile.

If acquisition succeeds but downstream extraction cannot safely resolve the required fact, the provider attempt may be marked `extraction_failed`; original Evidence is retained and the next explicitly routed provider may be attempted. Exhausted provider/extraction paths route to Review or remain unresolved rather than manufacturing a value.

## Implemented Source Profile foundation

- reusable `pipeline.layer2_source_profiles`;
- immutable `pipeline.layer2_source_profile_versions` with validation/hash/CC/UAT references;
- exact profile-version reference on Jobs and Evidence;
- pre-execution validity/enabled/paused gate;
- Evidence version guard;
- authenticated governed Admin read surface;
- rank-5 immutable version creation and rank-6 state controls;
- malformed initial `base_domain` seeds corrected through governed v2 profile versions rather than direct semantic overwrite.

## Implemented acquisition-provider foundation

Provider credentials are write-only through authorised Admin controls and stored in Supabase Vault. Browser reads expose only `credential_configured`. Provider capability/request JSON rejects secret-like fields.

Current provider registry:

| Priority | Provider | Mechanism | Authentication | Extraction response adapter | Default state |
|---:|---|---|---|---|---|
| 10 | Direct HTTP | direct source GET | none | passthrough | enabled |
| 20 | Scrape.do | scraper API; rendered fetch | query `token` | passthrough; `scrape_do_json` available for provider JSON/screenshot mode | enabled, credential required |
| 30 | ScraperAPI | scraper API; rendered fetch | query `api_key` | passthrough | enabled, credential required |
| 40 | Firecrawl | browser/API scrape POST | bearer | `firecrawl_v2` | enabled, credential required |
| 50 | ZenRows | scraper API; `js_render` + `premium_proxy` | query `apikey` | passthrough | enabled, credential required |
| 90 | Custom gateway (`{url}` template) | configurable API gateway | configurable header (`X-API-Key` seed) | `generic` | disabled until configured |

Current web/search routing for RMIT, UQ and Study Australia is:

`Direct HTTP → Scrape.do → ScraperAPI → Firecrawl → ZenRows`.

QILT document and PRISMS XLSX remain Direct HTTP because they are deterministic downloadable-file sources and do not require browser/scraper routing by default.

Current provider count: **6**. Current route count: **17**.

## Provider-compatible extraction worker

JWT-protected Edge Function `layer2-extract` v1 normalises provider-native Evidence into a common private `layer2_extraction_input` Evidence artifact.

Input: `attempt_id` for an already acquired provider attempt.

The worker:

1. verifies authenticated role rank >=4;
2. resolves the Provider Attempt, provider response adapter and source Evidence;
3. downloads the source Evidence from the private `evidence` bucket using the trusted service client;
4. normalises text/HTML/structured JSON/visual references according to the provider adapter;
5. stores a new hashed/versioned `layer2_extraction_input` Evidence artifact;
6. marks the attempt `normalised` when there is extractable content;
7. marks extraction blocked and returns `fallback_required=true` when no extractable text, structured or visual payload exists;
8. retains `canonical_mutation_authorised=false` throughout.

`layer2-extract` deliberately does **not** call an LLM. It is the Layer 2 provider-normalisation boundary. Layer 3 AI or deterministic domain extractors consume its common Evidence contract without needing provider-specific response parsing.

Supported response adapters:

- `passthrough` — Direct HTTP, Scrape.do, ScraperAPI and ZenRows normal HTML/JSON responses;
- `firecrawl_v2` — normalises Firecrawl `data.markdown`, HTML, structured JSON and screenshot reference fields;
- `scrape_do_json` — supported for Scrape.do JSON/screenshot-return mode;
- `generic` — configurable common text/screenshot paths for a custom gateway.

Screenshot policy does not manufacture screenshots. A provider must actually return image/screenshot content or a provider screenshot reference. A future provider-trial gate may additionally materialise returned screenshot URLs into separate private image artifacts if required.

## Supabase implementation references

Source/configuration migrations:

- `20260823102443_m2_1_layer2_platform_foundation`
- `20260823102619_m2_1_layer2_execution_traceability_hardening`
- `20260823103650_m2_1_layer2_config_version_governance_hardening`
- `20260823104038_m2_1_layer2_profile_fk_index_hardening`
- `20260823104311_m2_1_layer2_config_read_scale_hardening`

Provider/runtime migrations:

- `20260823105722_m2_1_layer2_acquisition_provider_registry`
- `20260823105735_m2_1_layer2_provider_admin_read_dispatch`
- `20260823105757_m2_1_layer2_provider_runtime_contract`
- `20260823110522_m2_1_layer2_provider_default_routing`
- `20260823111021_m2_1_layer2_provider_secret_config_hardening`
- `m2_1_layer2_provider_catalog_expansion` — ScraperAPI / Firecrawl / ZenRows / Custom gateway and expanded routing.

Edge Functions:

- `layer2-config-control` v2 — `verify_jwt=true`;
- `layer2-provider-control` v1 — `verify_jwt=true`;
- `layer2-acquire` v2 — `verify_jwt=true`, source-bound acquisition/fallback/private Evidence;
- `layer2-extract` v1 — `verify_jwt=true`, provider-compatible extraction-input normalisation.

Pilot mirrors include:

- `supabase/migrations/20260823113300_m2_1_layer2_provider_catalog_expansion.sql`;
- `supabase/functions/layer2-extract/index.ts`;
- updated `tests/uat/layer2-provider-deployed.spec.mjs` covering all six provider labels and the five-provider RMIT route.

Latest Pilot main observed after this expansion: `567a9bb2ce3cbbb5fff6ba3406b08f867cc957cf`.

## Security / UAT state

### PASS — database/API/security

- provider tables are RLS-enabled and not directly granted to `anon`/`authenticated`;
- privileged provider mutation/runtime functions are service-role only;
- provider secrets are absent from browser projection and kept in Vault;
- secret-like provider configuration keys are rejected/sanitised;
- source-bound URL validation prevents arbitrary acquisition proxy use;
- provider-attempt and profile-version provenance is retained;
- extraction-blocked fallback semantics are implemented;
- `layer2-extract` is JWT protected and writes only private Evidence/attempt operational state;
- all external vendor credentials remain intentionally unconfigured; no vendor live-success claim is made without a real key and bounded UAT.

### M1 regression — PASS

Post-change live state remains:

- Search documents: **33,105**;
- Search published: **0**;
- canonical Courses: **43,461**;
- canonical Courses unpublished: **43,461**.

### BLOCKED — deployed browser/runtime evidence

The governed Playwright suite contains provider registry/routing visibility, credential non-disclosure, bounded PRISMS acquisition and provider catalogue assertions for desktop/mobile. Current SHA-bound deployed browser statuses/artifacts are still unavailable through the connected GitHub surface; final browser acceptance is therefore not inferred.

A real Scrape.do, ScraperAPI, Firecrawl or ZenRows success path remains a provider-trial dependency until its API credential is entered through **L2 Providers → Set / rotate API credential** and bounded UAT is run. Do not paste provider secrets into source/profile JSON or documentation.

## Documentation / handoff

Current applicable docs:

- `docs/coursefinder-data-flow-feature-atlas-v1.0.md`;
- `docs/coursefinder-user-guide-v2.1.md`;
- `docs/coursefinder-pim-admin-guide-v1.16.md`;
- `docs/coursefinder-operations-runbook-v1.1.md`;
- `docs/coursefinder-database-architecture-v2.10.41.md`;
- `docs/coursefinder-layer2-provider-adapter-contract-v1.0.md`;
- `docs/uat/coursefinder-m2-1-layer2-platform-technical-acceptance-2026-08-23.md`.

Running Build and Master Project Plan remain intentionally unchanged until the M2.1 acceptance gate is actually closed.

## Rollback

1. Disable provider routes before provider removal.
2. Disable/remove provider credentials from Vault using the authorised control path.
3. Revert provider catalogue/runtime repository commits if required.
4. Remove provider attempts/Evidence only when explicitly identified and not referenced downstream.
5. Never rewrite the frozen M1 canonical/Search baseline during rollback.

## Decision / status history

| Timestamp | Status | Decision / event |
|---|---|---|
| 23 Aug 2026 20:21 AEST | PROPOSED | M2.1 Layer 2 platform initiated against frozen M1 baseline. |
| 23 Aug 2026 ~21:00 AEST | SCOPE CORRECTION | Multi-provider acquisition, Vault credentials, routing/fallback and provider-attempt Evidence confirmed as core M2.1. |
| 23 Aug 2026 ~21:10 AEST | IMPLEMENTED | Source/provider registry/runtime/Admin deployed; database/API/security UAT PASS. |
| 23 Aug 2026 ~21:20 AEST | BLOCKED | Deployed desktop/mobile SHA-bound browser evidence unavailable. |
| 23 Aug 2026 ~21:37 AEST | IMPLEMENTED / BLOCKED | Provider catalogue expanded to screenshot-requested providers and `layer2-extract` provider-normalisation worker deployed; M1 regression PASS; final browser/provider-key UAT still outstanding. |

## Closure

**Final status:** **BLOCKED — deployed desktop/mobile browser/runtime evidence unavailable**  
**Closed at:** N/A  
**Outcome:** M2.1 source-profile, multi-provider acquisition and provider-compatible extraction-input platform is implemented and database/API/security-tested. Final acceptance remains open until current deployed browser evidence passes. External provider live trials begin only after credentials are configured through the governed Vault-backed Admin control.