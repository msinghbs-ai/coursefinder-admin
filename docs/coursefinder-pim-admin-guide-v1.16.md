# CourseFinder PIM Admin Guide v1.16

**Effective:** 23 August 2026  
**Status:** CURRENT — M2.1 LAYER 2 PLATFORM  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.15.md`  
**Change Control:** `CF-CHG-20260823-029`  
**Applies to:** Layer 2 Platform v1.1

## 1. Authority boundary

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`.

Within Layer 2:

`Source Profile → Acquisition Provider Route → Job → Provider Attempt → Evidence → Extraction/Observation → Canonical Mapping/Review`.

Layer 2 acquisition does not redefine Layer 1 identity and never directly authorises canonical mutation.

## 2. Role/access requirements

| Surface/action | Minimum role |
|---|---|
| View Layer 2 source/provider configuration, routes and traceability | Pipeline Operator, rank 4 |
| Run bounded acquisition | Pipeline Operator, rank 4 |
| Create validated immutable source configuration version | PIM Admin, rank 5 |
| Configure source→provider routing/fallback | PIM Admin, rank 5 |
| PIM mapping/governance downstream | PIM Admin, rank 5 |
| Add/edit provider and set/rotate provider credential | Platform Admin, rank 6 |
| Validate/pause/resume/enable/disable source profile | Platform Admin, rank 6 |

Browser reads use `public.admin_read(text,jsonb)` and server rank checks. Source controls use JWT-protected `layer2-config-control`; provider controls use JWT-protected `layer2-provider-control`; acquisition uses JWT-protected `layer2-acquire`. Privileged database mutations/runtime credential reads are service-role-only.

## 3. Source-profile contract

Persistent source-profile objects:

- `pipeline.layer2_source_profiles` — stable source profile identity/state;
- `pipeline.layer2_source_profile_versions` — immutable configuration/hash/validation/governance;
- `pipeline.jobs.source_profile_version_id` — exact version used;
- `pipeline.evidence_artifacts.source_profile_version_id` — exact generating version.

Supported source/acquisition-method semantics include website, catalogue/detail, fees, intakes, English requirements, Scholarships, documents, structured API/JSON, CSV/XLSX, sitemap and search/discovery sources.

Source profile JSON is non-secret. `security.layer2_validate_profile_config` rejects secret-like keys and unsafe/incomplete execution settings; `security.layer2_sanitise_config` recursively sanitises browser projections.

## 4. Acquisition-provider contract

Persistent provider objects:

- `pipeline.layer2_acquisition_providers` — reusable acquisition service definition;
- `pipeline.layer2_profile_provider_routes` — ordered per-source provider route/capability/fallback policy;
- `pipeline.layer2_provider_attempts` — each provider attempt and its Evidence/extraction result;
- Supabase Vault — provider credential value storage;
- private Storage `evidence` bucket — acquired JSON/HTML/documents/images.

Provider adapter types are generic: `direct_http`, `scraper_api`, `browser_api`, `structured_api_proxy`, `custom`.

Provider configuration includes endpoint, auth mechanism, capability declaration, generic request template, rate/concurrency/timeout, state/priority, owner and operational health. It must not contain credential material.

`security.layer2_provider_has_secret_keys` recursively rejects secret-like object keys in provider/request-route JSON. `security.layer2_provider_sanitise_json` is the defence-in-depth browser projection sanitizer. Credentials are written only through `set_secret` and stored in Vault.

## 5. Source version workflow

PIM Admin+ uses **Layer 2 Config → Create new version**. `public.layer2_create_profile_version(...)` is service-role only and re-checks rank 5+. It validates, hashes, inserts immutable history, supersedes the prior accepted version and atomically moves `current_version_id` only when valid.

Do not edit historical source configuration in place.

## 6. Provider configuration workflow

### Add/edit provider

Platform Admin uses **L2 Providers**. Provider key/adapter identity is stable; endpoint, auth scheme/field, declared capabilities, generic request template and execution limits are governed non-secret settings.

### Credential

Platform Admin enters/rotates the credential under **Set / rotate API credential**. The browser submits the value once to `layer2-provider-control`. The database stores it in Vault. Browser reads expose only `credential_configured`; `vault_secret_id` and decrypted credential are not part of the Admin projection.

### Route provider to source

PIM Admin+ can route a reusable acquisition provider to a source profile with priority, required capabilities, request overrides, Evidence policy and fallback reasons. Routes do not change the source’s authority or mapping semantics.

Initial substrate:

- Direct HTTP priority 10 across all five initial profiles;
- Scrape.do priority 20 for RMIT/UQ/Study Australia web/search profiles;
- Scrape.do remains skipped until a Vault credential is configured.

## 7. Pre-execution and runtime gates

`security.layer2_assert_profile_executable(profile_id)` blocks missing/invalid/disabled/paused source profiles.

`public.layer2_prepare_job` creates a versioned Job with `canonical_mutation_authorised=false`.

`layer2-acquire` then enforces:

1. authenticated rank 4+ actor;
2. current valid source profile;
3. target HTTP(S) URL host bound to that source profile’s governed discovery/base/URL-pattern hosts;
4. ordered enabled provider routes;
5. provider enabled state, required capabilities and credential readiness;
6. configured fallback reasons;
7. payload/timeout limits;
8. private Evidence capture before acquisition is returned successful.

The endpoint must never become an arbitrary URL/SSRF proxy.

## 8. Provider attempts and Evidence

Each `pipeline.layer2_provider_attempts` row records:

- Job and source-profile version;
- acquisition provider and attempt number;
- request URL;
- HTTP/MIME result;
- raw/HTML/screenshot Evidence links;
- extraction status/blocker;
- metrics/timestamps.

`pipeline.layer2_evidence_version_guard` still guarantees Job/Evidence source-profile-version consistency.

Acquired JSON, HTML, XLSX/ZIP/PDF or image output is persisted to the private Evidence bucket and represented in `pipeline.evidence_artifacts` with provider/attempt metadata and `canonical_mutation_authorised=false`.

## 9. Extraction-blocked fallback

Acquisition success and extraction success are distinct.

If deterministic/AI extraction cannot resolve a required fact from acquired Evidence:

1. retain the original Evidence;
2. call the governed extraction-blocked contract;
3. mark the attempt `extraction_failed`, `extraction_status=blocked`, with blocker reason;
4. request the next provider route after the previous route priority;
5. compare/use new Evidence or route unresolved ambiguity to Review.

Do not manufacture a value simply because all providers fail to establish it.

A screenshot is only an Evidence artifact if a configured provider with screenshot/image capability actually returns image content. The platform does not fabricate screenshots from an Evidence-policy flag.

## 10. Admin behaviour

### Layer 2 Config

Source/profile list/detail/history/diff, source authority, validity, freshness, inventory, Job/Evidence traceability and Platform Admin source-state controls.

### L2 Providers

Provider registry, endpoint/auth/capabilities, credential configured state, write-only Vault rotation, source route/fallback display, provider editing and **Run bounded acquisition** result showing provider, Job and Evidence IDs.

## 11. State semantics

- `valid`: source configuration passes safety/completeness validation.
- `paused` / `disabled`: source dispatch blocked intentionally.
- `credential missing`: authenticated provider cannot run and is skipped.
- `succeeded`: provider response acquired and Evidence persisted.
- `failed` / `blocked`: provider transport/policy path failed.
- `extraction_failed`: content was acquired but downstream extraction could not resolve the fact.
- `source_null`: authoritative acquired source proves omission; inaccessible/blocked is not source-null.
- `ambiguous`: mapping cannot safely choose canonical target; Review required.

## 12. Search/publication consequences

Source validity, provider health, acquisition success and Evidence presence have no automatic Search/publication effect. Mapping preserves Layer 1 identity and field meaning; Search Admission and Publication remain separately governed.

## 13. Do / Don't

**Do:** keep source semantics and provider technology separate; version source changes; use generic provider adapters; put credentials only in Vault; retain provider-attempt Evidence; configure explicit fallback; bind targets to source allowlists; route ambiguity to review.

**Don't:** store credentials in source/provider JSON; expose service/Vault secrets to browsers; create provider-specific canonical schema; use arbitrary target URLs; overwrite historical versions/Evidence; treat provider acquisition as canonical approval; invent regulatory IDs or missing values.

## 14. Troubleshooting

1. Check source enabled/paused/current-valid state.
2. Check provider route order and enabled state.
3. Check provider required capabilities.
4. If authentication is required, confirm `credential_configured=true`; set/rotate through Vault UI only.
5. Inspect provider attempt HTTP/MIME/blocker.
6. Confirm Job/Evidence profile-version match.
7. If extraction failed, preserve Evidence and request next provider/review.
8. If target URL is rejected, fix source configuration through a new governed version; do not bypass host binding.
9. Inspect Search admission separately.

## 15. Related documents

- `docs/coursefinder-user-guide-v2.1.md`
- `docs/coursefinder-data-flow-feature-atlas-v1.0.md`
- `docs/coursefinder-operations-runbook-v1.1.md`
- `docs/coursefinder-database-architecture-v2.10.41.md`
- `change-control/40-layer2-enrichment/CF-CHG-20260823-029-m2-1-layer2-platform-foundation.md`

## Revision history

### v1.16
- Added reusable/versioned Layer 2 source configuration and Admin surface.
- Added acquisition-provider registry, Vault credential boundary and provider routing/fallback.
- Added provider-attempt Evidence and explicit extraction-blocked fallback contract.
- Added source-bound generic acquisition runtime and provider configuration secret hardening.
- Retains all M1 semantic rules from v1.15 unless explicitly extended above.