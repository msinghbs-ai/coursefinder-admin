# CourseFinder User Guide v2.1

**Effective:** 23 August 2026  
**Status:** CURRENT — M2.1 LAYER 2 PLATFORM  
**Supersedes:** `docs/coursefinder-user-guide-v2.0.md`  
**Applies to:** frozen M1 AU+NZ baseline plus Layer 2 Platform v1.1

## 1. Operating model

CourseFinder deliberately separates authority and workflow:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`.

Within Layer 2, two configuration planes are deliberately separate:

`Source Profile → Acquisition Provider Route → Acquisition Job → Provider Attempt → Evidence → Extraction/Observation → Mapping/Review`.

Layer 2 enriches canonical entities but does not redefine Layer 1 identity. Successful discovery/acquisition is not approval, Search admission or publication.

## 2. Navigation

Existing M1 navigation remains unchanged. Authorised operations/admin users have two governed Layer 2 launchers:

- **Layer 2 Config** → **Enrichment Source Configuration**: source authority, discovery/URL rules, parser/mapping strategy, freshness/evidence policy and immutable source-profile versions.
- **L2 Providers** → **Layer 2 Acquisition Providers**: acquisition vendor/service profiles, secure credential state, capabilities, request templates, per-source provider routes/fallback and bounded acquisition.

Pipeline Ops → Jobs/Sources and Evidence remain the related execution/provenance screens.

## 3. Roles and access

| Activity | Minimum role |
|---|---|
| View Layer 2 source/provider configuration and traceability | Pipeline Operator / Operations Support, rank 4 |
| Run a bounded governed acquisition | Pipeline Operator / Operations Support, rank 4 |
| Create a validated immutable source configuration version | PIM/Data Administrator, rank 5 |
| Configure per-source provider routing/fallback | PIM/Data Administrator, rank 5 |
| Interpret/manage downstream PIM mapping | PIM/Data Administrator, rank 5 |
| Add/edit acquisition providers or set/rotate provider API credentials | Platform Admin, rank 6 |
| Validate current source profile, pause, resume, enable or disable | Platform Admin, rank 6 |

Configuration changes and operational controls are re-authorised server-side. Browser users never receive service-role secrets or provider credential values.

## 4. Layer 2 source configuration

The **Layer 2 Config** list shows source/profile, country, acquisition method, affected Provider/entity scope, current version, validation, health, last successful run, freshness/inventory, associated Jobs/Evidence and blocker.

Open a profile to inspect source authority, current immutable version, non-secret acquisition configuration, freshness, history/hash/Change Control/UAT reference, version diff and Job/Evidence traceability.

### Create a new source configuration version

PIM Admin or Platform Admin can select **Create new version**. The server validates the whole source configuration before creating it. Historical versions are immutable. Secret-like keys, unsupported methods/targets, unsafe limits, missing discovery information and `evidence_required=false` are rejected.

## 5. Layer 2 acquisition providers

The **L2 Providers** screen separates the acquisition technology/vendor from the university/source profile. This allows multiple providers to be trialled against the same source without provider-specific schema.

The provider list shows:

- provider name/key and adapter type;
- endpoint/base URL;
- authentication mechanism and **credential configured / missing** state;
- declared capabilities such as HTML, JSON, JavaScript, anti-bot, proxy or screenshot;
- timeout/concurrency/rate settings;
- last runtime test state;
- number of source routes using the provider.

### Add or edit a provider

Platform Admin can add a provider or edit its non-secret settings. Supported generic adapter classes are Direct HTTP, scraper API, browser API, structured API proxy and custom deterministic adapter. Provider-specific request/query/body options live in the request template rather than new database tables.

Do not put API keys or tokens in capability/request-template JSON. The server rejects secret-like object keys.

### Set or rotate an API credential

For a provider requiring authentication, Platform Admin opens the provider and enters the new credential under **Set / rotate API credential**.

The credential is write-only from the browser and is stored in Supabase Vault. After saving, the UI shows only that a credential is configured; it cannot read the secret back.

### Route providers to a source

Select a source profile in **Provider routing & fallback**. Routes are ordered by priority. A typical web source can use:

1. Direct HTTP for the simplest/lowest-cost path;
2. a scraper/anti-bot provider when direct access is blocked;
3. a browser/rendering or screenshot-capable provider for sites requiring JavaScript/rendering or additional visual evidence.

Routes can require capabilities and define fallback reasons such as `blocked`, `timeout`, `403`, `429`, `5xx` and `extraction_failed`.

### Run bounded acquisition

Choose **Run bounded acquisition** for the selected source. The runtime:

1. uses only URLs allowed by that governed source profile;
2. tries eligible provider routes in priority order;
3. records the exact provider attempt and source-profile version;
4. captures the returned JSON/HTML/document/image in the private Evidence bucket;
5. records HTTP/MIME/hash/storage metadata;
6. never authorises canonical mutation.

The result panel shows the successful provider, Job and Evidence identifiers.

## 6. Extraction-blocked fallback

A successful acquisition may still be insufficient for deterministic or AI-assisted extraction. In that case the extraction layer must not overwrite or discard the acquired content.

The failed interpretation is recorded against the provider attempt as `extraction_failed`, with a blocker reason. The runtime can then request the next routed acquisition provider. Prior Evidence remains immutable and available for comparison/review.

A screenshot is evidence only when a configured provider actually supports and returns image/screenshot output. Merely setting a screenshot policy flag does not invent a screenshot capability.

## 7. Configuration and attempt states

- **Valid:** source configuration passes pre-execution validation.
- **Invalid:** source acquisition must not start.
- **Healthy / degraded / stale / paused / disabled:** source operational state as documented by the source profile.
- **Credential missing:** provider requires authentication but no Vault credential is configured; the provider is skipped by runtime.
- **Succeeded:** provider attempt obtained and persisted Evidence.
- **Blocked / failed:** transport/provider attempt did not complete successfully.
- **Extraction failed:** content was acquired but downstream extraction could not resolve the required fact; fallback/review is required.

For data facts, continue to distinguish `present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`. Inaccessible acquisition is not `source_null`.

## 8. Normal workflow

1. Locate and validate the source in **Layer 2 Config**.
2. Open **L2 Providers** and confirm at least one eligible provider route.
3. Confirm required provider credentials are configured; never paste credentials into source JSON.
4. Run or schedule the governed acquisition.
5. Inspect provider attempt status in Pipeline Ops/Layer 2 traceability.
6. Inspect captured artifacts in Evidence.
7. Extract observations and map only against existing canonical identity.
8. If extraction is stuck, record the blocker and use the next routed provider where policy permits.
9. Send unresolved ambiguity/conflict to Review Queue.
10. Treat Search admission and Publication as separate downstream gates.

## 9. Evidence/provenance

Every governed Layer 2 Job identifies the exact source-profile version used. Provider attempts additionally identify the acquisition provider and attempt number. Evidence records preserve provider/job/profile-version provenance and may link raw JSON, HTML, document or screenshot/image artifacts.

Historical Evidence remains tied to the original provider attempt/configuration even when source or provider settings later change.

## 10. Security and URL boundary

The generic acquisition runtime is not an arbitrary URL fetcher. Runtime target hosts must match the source profile’s governed discovery/base/URL-pattern host allowlist. Provider credentials are service-side only. New provider tables have no direct browser table grants.

## 11. Search/publication consequences

A valid source profile, configured provider, successful provider attempt or Evidence artifact does **not** automatically mutate canonical facts, admit them to Search or publish them. Follow the domain-specific mapping/review/Search gate and publication governance.

## 12. Do / Don't

**Do:** keep source semantics and provider technology separate; use Vault credential controls; route multiple providers where justified; retain each attempt’s Evidence; use fallback when extraction is genuinely blocked; respect source authority and stable identifiers.

**Don't:** put API keys in JSON; use the acquisition runtime for arbitrary URLs; add provider-specific schema; discard failed-attempt Evidence; assume a provider response is a canonical fact; invent CRICOS/NZQA identifiers; bypass Search/publication gates.

## 13. Troubleshooting

- **Credential missing:** Platform Admin must set/rotate the credential in L2 Providers; do not add it to source/provider JSON.
- **Provider unavailable/blocked/timeout/403/429/5xx:** inspect provider health and attempt Evidence, then allow configured fallback where policy permits.
- **Extraction failed:** preserve the acquired Evidence, record the blocker and request next provider/review rather than forcing a value.
- **Target URL rejected:** the requested host is outside the governed source-profile allowlist; correct the source profile through a new version rather than bypassing the check.
- **No Evidence:** do not proceed to canonical mapping.
- **Ambiguous mapping:** use Review Queue.

See `docs/coursefinder-data-flow-feature-atlas-v1.0.md` and `docs/coursefinder-operations-runbook-v1.1.md` for deeper operational detail.