# CourseFinder Operations Runbook v1.1

**Effective:** 23 August 2026  
**Status:** CURRENT — M2.1 LAYER 2 PLATFORM  
**Supersedes:** `docs/coursefinder-operations-runbook-v1.0.md`  
**Audience:** Integration/Operations Support, Pipeline Operator, PIM Admin, Platform Admin  
**Applies to:** Layer 2 Platform v1.1

## 1. Operating principles

1. Read `PROJECT_INSTRUCTIONS.md`, `change-control/REGISTER.md` and the owning Change Control before material action.
2. Preserve `Layer 1 → Layer 2 → Layer 3 → Layer 4 → Search Admission → Publication` authority boundaries.
3. Keep **source configuration** separate from **acquisition-provider configuration** and from execution.
4. Successful acquisition is not canonical mutation authority.
5. Never repair failed acquisition/extraction by inventing canonical values.
6. Every governed provider attempt must remain traceable to Job, source-profile version and Evidence.
7. Provider credentials belong only in approved server-side secret storage/Vault.

## 2. Layer 2 pre-flight

Before a Layer 2 run:

### Source profile

- confirm environment/project and owning Change Control;
- use **Layer 2 Config** to verify source identity/authority/affected entity scope;
- confirm `enabled=true`, `paused=false`, current version exists and validation is `valid`;
- inspect discovery/base URL, URL rules, robots policy, MIME/payload, parser/mapping/stable-ID, Evidence requirement, freshness/SLA/schedule;
- inspect latest success/failure/inventory/blocker and source version diff;
- confirm no credential material is stored in source JSON.

### Acquisition providers

- use **L2 Providers** to confirm at least one enabled route;
- confirm route priority, required capabilities and fallback reasons;
- confirm authenticated providers show `credential configured`; if missing, Platform Admin must set/rotate through Vault UI;
- verify provider endpoint/request template contains no credential values;
- for screenshot evidence, confirm the selected provider actually declares screenshot/image capability and request configuration that returns image output;
- confirm private Evidence storage is available.

The generic source gate blocks invalid/paused/disabled profiles. The runtime additionally rejects target hosts outside the source-profile allowlist.

## 3. Normal Layer 2 refresh

1. Inspect source profile/current version in **Layer 2 Config**.
2. Inspect provider routes in **L2 Providers**.
3. If provider credentials are required, confirm Vault credential state; never place tokens into JSON.
4. Dispatch through **Run bounded acquisition** or the governed worker path.
5. Runtime creates a versioned Job and provider attempt.
6. Provider response is persisted to the private Evidence bucket and `pipeline.evidence_artifacts` before the acquisition is treated successful.
7. Monitor Pipeline Ops → Jobs and provider-attempt traceability.
8. Extract observations while preserving source grain/null/zero semantics.
9. Map only against stable canonical identity; route ambiguity/conflict to Review.
10. Search admission and Publication remain separate gates.
11. Record Job/attempt/Evidence/UAT references in Change Control.

## 4. Source profile change

A material source change creates a new immutable version.

1. Open profile and inspect current version/hash/diff.
2. Select **Create new version**.
3. Edit only governed non-secret configuration.
4. Enter owning Change Control/UAT reference.
5. **Validate & create version**.
6. Correct validation failures in the candidate; never bypass validator through SQL/environment/source edits.
7. Bound-test the new source/parser behaviour.
8. Verify new Jobs use the new version and historical Jobs/Evidence retain old references.

Acquisition method and target entity type remain stable profile identity in M2.1; create a different profile if either semantic meaning changes.

## 5. Acquisition provider change

### Add/edit provider

Platform Admin may add/edit reusable providers from **L2 Providers**. Governed fields include endpoint, adapter type, auth mechanism/field, capabilities, generic request template, execution limits, enabled state, owner and priority.

Do not add vendor-specific canonical/source tables merely to support a new scraper/browser/API provider.

### Set/rotate credential

1. Open the provider.
2. Use **Set / rotate API credential**.
3. Enter the credential into the password field.
4. Save.
5. Confirm the provider shows **Credential set**.
6. Do not expect/read the credential back; the browser only sees configured/missing state.

The Edge Function re-authorises Platform Admin rank 6 and writes the credential to Supabase Vault through a service-role-only RPC.

### Provider route change

PIM Admin+ may add/update source→provider routing. Review:

- priority/order;
- required capability;
- request overrides;
- Evidence policy;
- fallback reasons (`blocked`, `timeout`, `403`, `429`, `5xx`, `extraction_failed`).

Route changes do not alter source authority or canonical mapping semantics.

## 6. Transport/provider failure

For timeout/blocked/403/429/5xx/provider failure:

1. inspect provider attempt provider/HTTP/MIME/blocker/timestamp;
2. retain any acquired Evidence;
3. inspect provider health/credential/rate/concurrency/endpoint;
4. allow fallback only where that route’s configured fallback policy permits;
5. if no eligible provider remains, leave Job failed and record the blocker;
6. never convert inaccessible content into `source_null`.

The runtime enforces required capabilities and does not blindly cycle providers outside route policy.

## 7. Extraction-blocked fallback

Acquisition success does not guarantee extraction success.

When deterministic/AI extraction cannot resolve the required fact:

1. preserve the successful acquisition Evidence;
2. record why extraction is unresolved;
3. call the governed fallback contract for the provider attempt;
4. the attempt becomes `extraction_failed`, `extraction_status=blocked` with blocker text;
5. runtime starts with the next provider route after the failed attempt’s priority;
6. capture the next provider’s Evidence independently;
7. compare/retry extraction or route unresolved ambiguity to Review.

Do not overwrite original Evidence or force a value because several providers disagree/fail.

## 8. Screenshot/image evidence

The Evidence policy expresses when screenshot evidence is useful; provider capability determines whether it can actually be produced.

A screenshot-capable provider must be configured as a browser/scraper/API adapter with:

- `screenshot=true` or equivalent declared capability;
- an endpoint/request template that returns PNG/JPEG/image content;
- Vault credential if required;
- source route requiring the screenshot capability where appropriate.

`layer2-acquire` persists image responses as `layer2_screenshot` Evidence. Never label HTML as screenshot Evidence.

## 9. Source-null, inaccessible and stale

- **source_null:** successfully acquired authoritative content omitted the field at applicable grain.
- **inaccessible:** acquisition failed due network/auth/policy/anti-bot/format; not source-null.
- **stale:** last successful acquisition exceeds SLA; keep prior provenance and reacquire under policy.
- **zero:** sourced zero remains zero.
- **not_yet_enriched:** no governed Layer 2 observation yet.

## 10. Evidence/version mismatch

The `pipeline.layer2_evidence_version_guard` trigger inherits a versioned Job’s source-profile version and rejects mismatches.

If mismatch occurs:

1. stop the run;
2. inspect Job `source_profile_version_id` and provider attempt;
3. confirm Evidence belongs to that Job/source/version;
4. correct adapter/association;
5. rerun bounded acquisition;
6. do not remove/disable the guard.

## 11. Security verification

For Layer 2 provider-platform changes verify:

- `public.admin_read` remains SECURITY INVOKER; anon denied;
- direct Layer 2 source/provider/route/attempt tables have no browser grants;
- source/provider mutation/runtime-credential functions are service-role only;
- `layer2-config-control`, `layer2-provider-control`, `layer2-acquire` use `verify_jwt=true`;
- rank 4 is minimum for acquisition/view; rank 5 for source version/provider routing; rank 6 for provider add/edit/credentials and source-state control;
- provider/source browser projections expose no secret value or Vault secret ID;
- secret-like JSON object keys are rejected and recursively sanitised;
- acquisition target host is bound to the source profile;
- private Evidence bucket remains non-public;
- acquired metadata says `canonical_mutation_authorised=false`.

Supabase currently advises that five pre-existing `pipeline` tables do not have RLS enabled. Current privilege verification shows `anon` and `authenticated` have no direct SELECT/INSERT privileges on those tables. Do **not** blindly enable RLS without reconciling existing privileged dependencies; treat it as a separate defence-in-depth/security-hardening item rather than silently changing frozen M1 behaviour.

## 12. Performance / scale

Source profile reads remain set-based. Provider registry/route reads are small control-plane queries. Keep provider attempt/Evidence lookup indexed and avoid per-row browser RPCs.

Existing live source-profile list benchmark after hardening was approximately 72 ms on the Pilot dataset. Re-benchmark provider-attempt views as job volumes scale.

## 13. Replay / UAT

For M2.1 or a provider change:

- validate source profile/version;
- verify provider route/capabilities/credential state;
- run a bounded acquisition;
- prove Job and attempt are versioned;
- prove private Evidence was created with source URL/hash/MIME/provider metadata;
- prove browser cannot read Vault credential/runtime config;
- where testing extraction failure, mark attempt `extraction_failed` and prove next-route selection;
- verify canonical/Search/publication counts/state did not change unless separately authorised;
- run deployed desktop/mobile Playwright and retain screenshots/runtime evidence;
- update Change Control and Guides.

## 14. Initial M2.1 provider substrate

- **Direct HTTP:** first route for five initial profiles; no credential.
- **Scrape.do:** second route for RMIT/UQ/Study Australia web/search profiles; JavaScript/anti-bot/proxy capabilities; requires a Vault credential before runtime eligibility.
- Additional scraper/browser/API providers are configuration, not schema.

## 15. Related documents

- **Layer 2 Config** — source configuration/version/diff/health.
- **L2 Providers** — acquisition provider/credential/routing/bounded acquisition.
- Pipeline Ops → Jobs/Sources — execution/source operational state.
- Evidence — provider attempt/source/job/artifact provenance.
- Review Queue — unresolved extraction/mapping conflict.
- `docs/coursefinder-data-flow-feature-atlas-v1.0.md`
- `docs/coursefinder-pim-admin-guide-v1.16.md`
- `docs/coursefinder-user-guide-v2.1.md`
- `docs/coursefinder-database-architecture-v2.10.41.md`
- `change-control/40-layer2-enrichment/CF-CHG-20260823-029-m2-1-layer2-platform-foundation.md`

All M1 operational procedures remain applicable unless explicitly extended by these Layer 2 controls.