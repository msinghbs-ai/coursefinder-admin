# CF-CHG-20260823-029 — M2.1 Layer 2 Enrichment Platform Foundation

**Status:** BLOCKED — DEPLOYED BROWSER UAT EVIDENCE UNAVAILABLE  
**Category:** 40-layer2-enrichment  
**Initiated:** 23 August 2026 20:21 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** M2.1 Layer 2 Platform workstream  
**Change class:** schema / enrichment / UI / security / governance / documentation / operations

## Trigger

Milestone 2.1 authorised implementation gate following the accepted and frozen Milestone 1 Pilot baseline.

## Problem / requested outcome

Layer 2 needs two independent but linked configuration planes:

1. **Source acquisition profiles** — what first-party/regulatory source is being acquired, its authority, URL/discovery rules, deterministic parser/mapping semantics, evidence/freshness policy and version; and
2. **Acquisition-provider profiles** — how the source is fetched, including Direct HTTP, scraper APIs, browser/rendering providers and future deterministic acquisition services, with server-side credentials, capabilities, request templates, limits and health.

The original M2.1 implementation delivered the source-profile plane but did not operationalise the intended multi-provider trial/fallback model. This Change Control therefore records the scope correction: the same university/source profile must be routable through multiple acquisition providers without provider-specific database schema, with evidence retained per attempt and an explicit fallback contract when downstream extraction/inference cannot resolve a required fact.

## Affected surfaces / related workstreams

- `pipeline.sources`, `pipeline.jobs`, `pipeline.evidence_artifacts`;
- `pipeline.layer2_source_profiles` and immutable profile versions;
- `pipeline.layer2_acquisition_providers`, `pipeline.layer2_profile_provider_routes`, `pipeline.layer2_provider_attempts`;
- Supabase Vault for provider credentials;
- private Storage bucket `evidence` for JSON/HTML/binary/image evidence;
- `public.admin_read(text,jsonb)` governed browser read contract;
- JWT-protected `layer2-config-control`, `layer2-provider-control` and `layer2-acquire` Edge Functions;
- Admin `Layer 2 Config` and `L2 Providers` surfaces;
- automated database/security/API/deployed-browser UAT;
- Platform User Guide, PIM Admin Guide, Data Flow & Feature Atlas, Operations Runbook and database architecture.

## Semantic impact

No canonical identity or field-meaning change is authorised. Layer 1 authority and canonical identity remain unchanged. Acquisition never directly mutates canonical data.

Accepted sequence:

`Source Profile → Provider Route → Acquisition Job → Provider Attempt → Evidence → Observation/Extraction → Canonical Mapping → Review where required → Search Admission → Publication`

If extraction is blocked after valid acquisition, the extraction layer records `extraction_failed` against the attempt and may request the next configured provider. The original evidence is retained; fallback does not overwrite it.

## Before

Layer 2 had source-specific acquisition implementations and, after the first M2.1 increment, reusable source-profile configuration/versioning. It did not have an operational acquisition-provider registry, write-only credential management, ordered per-source provider routing, provider-attempt traceability or extraction-triggered provider fallback.

## After

- reusable source profiles remain versioned independently from execution;
- reusable acquisition-provider profiles are data/configuration, not provider-specific tables;
- provider API keys are entered through authorised Admin controls and stored in Supabase Vault; browsers see only masked configuration state;
- per-source routing defines ordered providers, required capabilities and fallback conditions;
- the acquisition runtime is source-bound to prevent arbitrary URL/SSRF use;
- every provider attempt records the exact Job, source-profile version, provider, HTTP/MIME result, blocker and Evidence links;
- raw JSON, HTML, documents and provider-returned screenshots/images are stored in the existing private Evidence bucket;
- downstream extraction can mark an attempt `extraction_failed` and request the next routed provider;
- provider capability/request-template JSON rejects secret-like object keys; credentials must use the dedicated Vault path;
- canonical mutation remains explicitly unauthorised at acquisition time.

## Source authority / evidence

- `PROJECT_INSTRUCTIONS.md` and current Change Control register;
- M1 frozen architecture and accepted AU+NZ canonical/Search substrate;
- deployed Supabase project `fxcwkweaxjtknorudmwp`;
- current `msinghbs-ai/Coursefinder-Pilot` and `msinghbs-ai/coursefinder-admin` main branches;
- M2.1 workstream clarification that multi-provider acquisition/fallback is a core Layer 2 platform requirement.

## Implementation references

### Supabase migrations

- `20260823102443_m2_1_layer2_platform_foundation`
- `20260823102619_m2_1_layer2_execution_traceability_hardening`
- `20260823103650_m2_1_layer2_config_version_governance_hardening`
- `20260823104038_m2_1_layer2_profile_fk_index_hardening`
- `20260823104311_m2_1_layer2_config_read_scale_hardening`
- `20260823105722_m2_1_layer2_acquisition_provider_registry`
- `20260823105735_m2_1_layer2_provider_admin_read_dispatch`
- `20260823105757_m2_1_layer2_provider_runtime_contract`
- `20260823110522_m2_1_layer2_provider_default_routing`
- `20260823111021_m2_1_layer2_provider_secret_config_hardening`

### Runtime/API

- `public.admin_read(text,jsonb)` — SECURITY INVOKER; authenticated browser read boundary.
- `public.layer2_provider_control(uuid,text,jsonb)` — service-role only; rank re-authorised server-side.
- `public.layer2_provider_runtime_config(uuid)` — service-role only; only trusted runtime may obtain decrypted Vault credential.
- `public.layer2_provider_attempt_start`, `public.layer2_provider_attempt_finish`, `public.layer2_mark_extraction_blocked` — service-role only.
- Edge `layer2-provider-control` v1 — `verify_jwt=true`.
- Edge `layer2-acquire` v2 — `verify_jwt=true`, source-bound URL allowlist, provider capability/fallback enforcement and private Evidence capture.

### Pilot UI/repository

- visible UI version: **Layer 2 Platform v1.1**;
- `src/layer2-platform-entry.jsx` — source profile/version control;
- `src/layer2-provider-entry.jsx` — provider registry, provider settings, Vault credential rotation, routing and bounded acquisition;
- `tests/uat/layer2-platform-deployed.spec.mjs`;
- `tests/uat/layer2-provider-deployed.spec.mjs`;
- deployed UAT workflow includes desktop and mobile provider orchestration coverage;
- live migrations and Edge Functions mirrored under `supabase/migrations` and `supabase/functions`.

## Initial provider/routing substrate

- **Direct HTTP** — no credential; raw/HTML/JSON acquisition.
- **Scrape.do** — scraper API profile with JavaScript/anti-bot/proxy capabilities; credential deliberately not populated by code and must be entered through Admin/Vault.
- Direct HTTP is routed first across all five initial source profiles.
- Scrape.do is routed as second acquisition path for the three web/search profiles where JavaScript/anti-bot fallback is applicable.
- Additional browser/scraper/API providers are added as configuration. A screenshot-capable provider must declare/configure the provider-specific request template that returns image evidence; no screenshot vendor credential is assumed by this Change Control.

## UAT

### PASS — database/API/security

- five source profiles remain valid/versioned and executable only when current configuration is valid;
- initial malformed `base_domain` values were corrected through immutable governed v2 profile versions under this Change Control;
- eight initial provider routes exist: five Direct HTTP + three Scrape.do;
- new provider tables have RLS enabled and no direct `anon`/`authenticated` table privileges;
- provider mutation/runtime functions are not executable by `anon` or `authenticated`; service role only;
- provider public reads expose `credential_configured` rather than `vault_secret_id`/decrypted secret;
- recursive secret-key detection rejects `api_key`/token/password/etc object keys while allowing non-secret metadata such as `credential_parameter`;
- recursive read sanitisation removes nested secret-like keys;
- transaction UAT proved a versioned provider attempt can be marked `extraction_failed` / `blocked` with blocker evidence and rolled back;
- the existing Evidence bucket is private and supports JSON, HTML, PNG/JPEG, XLSX, ZIP and PDF required by the acquisition runtime;
- pre-existing five `pipeline` tables flagged by the Supabase RLS advisor currently have no direct `anon` or `authenticated` SELECT/INSERT privileges. Their RLS state is not changed by this M2.1 work because enabling RLS without reconciling existing privileged dependencies could regress M1;
- exact M1 regression remains 33,105 Search documents (26,648 AU + 6,457 NZ), 0 Search published, 43,461 canonical Courses all unpublished.

### BLOCKED — deployed browser/runtime evidence

The governed Playwright suite now contains provider registry/routing, credential non-disclosure, desktop/mobile responsiveness and a bounded PRISMS Direct HTTP acquisition that must create private versioned Evidence without canonical mutation.

Latest Pilot main observed for this gate:

`msinghbs-ai/Coursefinder-Pilot@ab9dfbef618ff259057321cbe88f7473e678c818`

Repeated combined-status checks returned no SHA-bound deployed-UAT statuses. The available GitHub connector does not expose dispatch/listing for push-triggered runs and the execution container cannot currently resolve GitHub or the deployed Worker hostname, so independent deployed browser evidence cannot be reconstructed outside the governed Actions harness.

Formal technical acceptance evidence: `docs/uat/coursefinder-m2-1-layer2-platform-technical-acceptance-2026-08-23.md`.

A real Scrape.do or screenshot-capable vendor call is not claimed until its credential/provider is configured through the Admin UI. This is an operational provider-trial dependency, not permission to weaken the platform credential/evidence model.

## Rollback / reversion

1. Disable/pause provider routes and the `layer2-acquire` Edge Function before removing provider objects.
2. Revert `L2 Providers` UI/runtime commits if required.
3. Remove provider-attempt rows/evidence only where explicitly identified as M2.1 UAT/provider evidence and no downstream observation depends on them.
4. Drop provider routing/provider tables/functions only after dependency verification.
5. Do not rewrite M1 canonical/Search data during rollback.

## Documentation impact

- PIM Admin Guide: updated.
- Architecture: updated.
- Running build: intentionally pending until final M2.1 acceptance.
- Master plan: intentionally pending until final M2.1 acceptance.
- UAT evidence: created with BLOCKED gate state.
- User Guide: updated.
- Data Flow & Feature Atlas: updated.
- Operations Runbook: updated.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 23 Aug 2026 20:21 AEST | PROPOSED | M2.1 Layer 2 platform workstream initiated against frozen M1 baseline | M2.1 — L2-PLATFORM |
| 23 Aug 2026 ~21:00 AEST | SCOPE CORRECTION | Source profiles alone were insufficient; acquisition-provider registry, Vault credentials, per-source routing/fallback and provider-attempt Evidence were confirmed as core M2.1 requirements | M2.1 clarification |
| 23 Aug 2026 ~21:10 AEST | IMPLEMENTED | Provider registry/routing/runtime/security hardening and Admin v1.1 deployed; database/API/security UAT PASS | Supabase + Coursefinder-Pilot main |
| 23 Aug 2026 ~21:20 AEST | BLOCKED | Current deployed desktop/mobile SHA-bound UAT evidence is not available from the governed harness; no final acceptance inferred | M2.1 technical acceptance doc |

## Closure

**Final status:** **BLOCKED — deployed desktop/mobile browser/runtime evidence unavailable**  
**Closed at:** N/A  
**Outcome:** Core M2.1 source-profile and acquisition-provider platform is implemented and database/API/security-tested. Final acceptance remains open solely until current deployed browser/runtime evidence is available and passing; third-party provider trials then proceed as configuration-driven post-foundation work.