# CourseFinder Database Architecture v2.10.41

**Effective:** 23 August 2026  
**Status:** CURRENT — M2.1 LAYER 2 PLATFORM  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.40.md`  
**Change Control:** `CF-CHG-20260823-029`  
**Canonical identity semantics:** unchanged

## 1. Scope

All accepted v2.10.40/M1 architecture remains in force. This revision adds a reusable, versioned Layer 2 source-configuration plane **and** a separate acquisition-provider orchestration plane. It does not redefine Provider/Course/Campus/Scholarship identity, automatically mutate canonical data, admit data to Search or publish data.

## 2. Authority sequence

`Source Profile → Provider Route → Acquisition Job → Provider Attempt → Evidence → Observation/Extraction → Canonical Mapping → Review where required → Search Admission → Publication`

Layer 2 source/provider configuration and acquisition are upstream operational authority only. Layer 1 remains regulatory identity authority where applicable.

## 3. Persistent source-profile model

### `pipeline.layer2_source_profiles`
Stable source acquisition identity tied to `pipeline.sources`: reusable profile key, domain, acquisition method, target entity, authority, enabled/paused state, owner, SLA/schedule, current-version reference and inventory metadata.

### `pipeline.layer2_source_profile_versions`
Immutable configuration versions with configuration JSON, deterministic hash, validation state/result, Change Control/UAT references, creator and timestamp.

The source contract represents website/catalogue/detail/document/API/JSON/CSV/XLSX/sitemap/search/discovery and approved deterministic methods without Provider-specific schema.

## 4. Persistent acquisition-provider model

### `pipeline.layer2_acquisition_providers`
Reusable transport/vendor definition independent of university/source semantics. Stores:

- stable provider key/name;
- generic adapter type (`direct_http`, `scraper_api`, `browser_api`, `structured_api_proxy`, `custom`);
- base endpoint;
- auth mechanism and auth field name;
- Supabase Vault secret reference;
- capabilities and generic request template;
- rate/concurrency/timeout controls;
- enabled/priority/owner/Change Control;
- last runtime health/test metadata.

The browser projection exposes only `credential_configured`, never the Vault secret ID or decrypted credential.

### `pipeline.layer2_profile_provider_routes`
Many-to-many control plane linking source profiles to acquisition providers. Stores priority, enabled state, required capabilities, request overrides, Evidence policy, fallback reasons and Change Control. Unique constraints prevent duplicate provider routes and duplicate priorities for the same source profile.

### `pipeline.layer2_provider_attempts`
Per-Job acquisition-attempt ledger. Stores source-profile version, acquisition provider, attempt number, request URL, HTTP/MIME, raw/HTML/screenshot Evidence links, extraction status/blocker, metrics and timing.

This separates "the source" from "the transport used to obtain it" and allows the same university/source to be trialled through multiple providers without schema changes.

## 5. Credential model

Provider credential values are stored in Supabase Vault. `pipeline.layer2_acquisition_providers.vault_secret_id` stores only the reference.

`public.layer2_provider_control(..., 'set_secret', ...)` is service-role only and re-checks the supplied actor as Platform Admin rank 6. It creates/rotates the Vault secret. Browser users cannot read the credential back.

`public.layer2_provider_runtime_config(uuid)` is service-role only and is the only runtime contract that returns the decrypted provider credential to trusted server execution.

`security.layer2_provider_has_secret_keys` rejects secret-like object keys in provider capabilities/request templates and route overrides. `security.layer2_provider_sanitise_json` recursively strips secret-like object keys from browser projections.

## 6. Execution/Evidence traceability

`pipeline.jobs.source_profile_version_id` records the exact source-profile version used. `pipeline.evidence_artifacts.source_profile_version_id` records the generating version. `pipeline.layer2_evidence_version_guard` inherits/rejects mismatched Job/Evidence profile versions.

`public.layer2_prepare_job(...)` is service-role only and stamps the exact source-profile version plus `canonical_mutation_authorised=false`.

Provider execution adds:

- `public.layer2_provider_attempt_start(...)`;
- `public.layer2_provider_attempt_finish(...)`;
- `public.layer2_mark_extraction_blocked(...)`.

These are service-role-only and preserve attempt/Evidence lineage.

## 7. Generic acquisition runtime

JWT-protected Edge Function `layer2-acquire` is the generic acquisition orchestrator.

Before outbound acquisition it requires:

1. authenticated Pipeline Operator rank 4+;
2. current valid, enabled and unpaused source profile;
3. target HTTP(S) host matching a host derived from the governed source profile discovery/base/URL patterns;
4. ordered enabled provider route;
5. provider enabled state;
6. required capabilities satisfied;
7. required Vault credential configured;
8. configured timeout/payload/fallback policy.

The source-host binding prevents the runtime becoming an arbitrary SSRF/fetch proxy.

For Direct HTTP it fetches the governed target directly. Generic API/browser/scraper adapters build a provider request from `base_url + request_template + route overrides`, adding the Vault credential server-side according to query/header/bearer auth semantics.

## 8. Evidence model

The existing private Storage bucket `evidence` supports JSON, HTML, PNG/JPEG, XLSX, ZIP, PDF and other admitted formats. `layer2-acquire` hashes and stores successful provider response bytes before declaring acquisition success.

Evidence types include:

- `layer2_raw_json`;
- `layer2_html_snapshot`;
- `layer2_screenshot` for provider-returned image output;
- `layer2_raw_response` for other admitted binary/document content.

`pipeline.evidence_artifacts.metadata` records Layer 2/provider/attempt/HTTP/adapter context and `canonical_mutation_authorised=false`.

A screenshot policy does not create a screenshot by itself. A provider must explicitly support/configure screenshot/image output.

## 9. Fallback semantics

Transport/provider failure can fall through to the next provider only when the current route allows the classified reason (`blocked`, `timeout`, `403`, `429`, `5xx`, etc.).

Acquisition success and extraction success are separate. When downstream deterministic/AI extraction cannot resolve a required fact, the previous provider attempt is marked:

- `status='extraction_failed'`;
- `extraction_status='blocked'`;
- blocker text retained.

The runtime can then continue from the next route priority. Original Evidence remains immutable.

## 10. Browser security boundary

Source/provider reads remain under `Supabase Auth → public.admin_read(text,jsonb) → server rank check`; `public.admin_read` remains SECURITY INVOKER and anonymous execution is denied.

Direct Layer 2 source/version/provider/route/attempt tables are RLS-enabled with no direct `anon`/`authenticated` table grants.

Mutation/runtime credential functions are service-role only. `layer2-config-control`, `layer2-provider-control` and `layer2-acquire` use `verify_jwt=true` and re-authorise user context before privileged execution.

## 11. Role boundary

- rank 4 Pipeline Operator: read configuration/traceability and run bounded acquisition;
- rank 5 PIM Admin: create source versions and configure source→provider routes;
- rank 6 Platform Admin: source state controls, add/edit providers and set/rotate provider credentials.

## 12. Indexing

Existing source-profile indexes cover method/state/current-version and Job/Evidence profile-version traceability. Provider indexes cover route profile/priority, Job/attempt and provider/attempt history.

Avoid page-level N+1 browser RPCs as provider/attempt volume increases.

## 13. Initial platform breadth

Source profiles remain RMIT Course detail, UQ Course catalogue, QILT document, PRISMS XLSX and Study Australia Scholarship search/discovery.

Initial acquisition providers:

- Direct HTTP — first route for all five source profiles, no credential;
- Scrape.do — second route for the three web/search profiles, declared JavaScript/anti-bot/proxy capability, requiring a Vault credential before runtime eligibility.

Additional scraper/browser/API providers are configuration rather than schema changes.

## 14. M1 regression state

Post-change checks must retain:

- Search: 33,105 `course-v3` documents = 26,648 AU + 6,457 NZ;
- Search published: 0;
- canonical Courses: 43,461, all `publication_status=unpublished`.

No M2.1 provider migration/runtime authorises canonical Course fact or Search-document writes.

## 15. Existing RLS advisor note

Supabase currently reports five pre-existing `pipeline` tables without RLS enabled. Direct privilege verification shows `anon` and `authenticated` do not currently have SELECT/INSERT privileges on those tables. M2.1 does not blindly enable RLS because existing privileged dependencies must first be reconciled; this remains a defence-in-depth hardening item and is not a reason to weaken the new Layer 2 private-table pattern.

## 16. Related documents

- `docs/coursefinder-data-flow-feature-atlas-v1.0.md`
- `docs/coursefinder-pim-admin-guide-v1.16.md`
- `docs/coursefinder-user-guide-v2.1.md`
- `docs/coursefinder-operations-runbook-v1.1.md`
- `change-control/40-layer2-enrichment/CF-CHG-20260823-029-m2-1-layer2-platform-foundation.md`
