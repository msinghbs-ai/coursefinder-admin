# CourseFinder M2.1 Layer 2 Platform — Technical Acceptance

**Date:** 23 August 2026  
**Change Control:** `CF-CHG-20260823-029`  
**Gate:** M2.1 — Layer 2 Enrichment Platform & Source/Provider Configuration Foundation  
**Status:** **BLOCKED — deployed desktop/mobile browser evidence unavailable**

## 1. Acceptance statement

The M2.1 Layer 2 platform implementation is deployed at the database/API/Edge-control-plane level and mirrored in `msinghbs-ai/Coursefinder-Pilot`. Database/API/security UAT is PASS. The acceptance gate is not closed because the latest Pilot SHA has not published the required SHA-bound deployed Playwright desktop/mobile statuses/artifacts.

This is an evidence/harness blocker, not permission to infer browser acceptance. M2.1 remains open until the current deployed UI/runtime is independently exercised and evidenced by the governed UAT harness.

## 2. Intended Layer 2 model now implemented

Layer 2 separates four concerns:

1. **Source Profile** — authority, discovery/URL scope, deterministic parser/mapping semantics, freshness/Evidence policy and immutable version.
2. **Acquisition Provider** — reusable transport/vendor such as Direct HTTP, scraper API, browser/rendering API or structured proxy, including endpoint, auth mechanism, Vault credential reference, capabilities and limits.
3. **Source → Provider Route** — provider order, required capabilities, request overrides, Evidence policy and explicit fallback reasons.
4. **Provider Attempt / Evidence** — every Job may have multiple provider attempts, each linked to the exact source-profile version and its raw JSON/HTML/document/image Evidence.

Acquisition success never directly authorises canonical mutation, Search admission or Publication.

## 3. Deployed objects verified

### Source configuration

- `pipeline.layer2_source_profiles`: 5 current profiles.
- `pipeline.layer2_source_profile_versions`: 10 versions after governed base-domain correction; all five current versions are v2/valid.
- exact profile version stamped on Layer 2 Jobs and inherited/guarded on Evidence.

### Acquisition providers

- `pipeline.layer2_acquisition_providers`.
- `pipeline.layer2_profile_provider_routes`.
- `pipeline.layer2_provider_attempts`.
- Direct HTTP and Scrape.do initial provider profiles.
- 8 initial routes: 5 Direct HTTP + 3 Scrape.do.

### Credentials/security

- provider credentials stored in Supabase Vault via write-only Admin control;
- browser projection exposes `credential_configured` only;
- service-role-only runtime RPC obtains decrypted credential;
- recursive provider JSON secret-key rejection/sanitisation;
- provider/source tables have no direct browser table grants.

### Runtime

- `layer2-config-control` — JWT protected.
- `layer2-provider-control` — JWT protected.
- `layer2-acquire` v2 — JWT protected; source-host-bound acquisition, capability/credential/fallback enforcement, private Evidence capture.

## 4. Database/API/security UAT — PASS

### ACL boundary

Verified:

- `anon`/`authenticated` cannot directly SELECT the new acquisition-provider tables;
- `anon`/`authenticated` cannot execute provider mutation/runtime-credential functions;
- `service_role` can execute the privileged control/runtime functions;
- `public.admin_read(text,jsonb)` remains the authenticated SECURITY INVOKER browser read boundary.

### Secret boundary

Verified:

- secret-like provider JSON keys such as `api_key` are rejected;
- non-secret request metadata such as `credential_parameter` remains permitted;
- nested secret-like fields are stripped by browser read sanitisation;
- provider API credential value is not present in the browser projection.

### Routing/fallback

Verified live:

- Direct HTTP is first route for all five initial source profiles;
- Scrape.do is second route for RMIT, UQ and Study Australia web/search profiles;
- Scrape.do requires JavaScript capability and remains skipped until a Vault credential is configured;
- fallback policy includes transport/policy failures and `extraction_failed`.

### Extraction-blocked hand-off

Transaction UAT proved a versioned provider attempt can be marked:

- `status = extraction_failed`;
- `extraction_status = blocked`;
- blocker text retained;

without changing canonical data. Transaction was rolled back after verification.

### Source profile integrity hardening

The original initial source-profile seed carried a malformed `base_domain` value. It was corrected through the governed immutable version-creation path under this Change Control rather than direct current-row modification. Current valid v2 base domains are:

- RMIT: `https://www.rmit.edu.au`;
- UQ: `https://study.uq.edu.au`;
- QILT: `https://qilt.edu.au`;
- PRISMS: `https://www.education.gov.au`;
- Study Australia Scholarships: `https://search.studyaustralia.gov.au`.

### Evidence/storage

The existing private `evidence` Storage bucket is retained. It admits the required JSON, HTML, XLSX/ZIP/PDF and PNG/JPEG MIME classes. The generic runtime hashes and stores acquired bytes before reporting acquisition success.

A screenshot is accepted only when a configured provider actually returns image/screenshot output. An Evidence-policy flag alone does not manufacture screenshot capability.

## 5. M1 regression — PASS

Post-M2.1 live state remains:

- Search documents: **33,105**;
- AU Search: **26,648**;
- NZ Search: **6,457**;
- Search published: **0**;
- canonical Courses: **43,461**;
- canonical Courses unpublished: **43,461**.

No M2.1 provider migration/runtime authorises canonical or Search writes.

## 6. Pre-existing RLS advisor finding

Supabase reports RLS disabled on five pre-existing `pipeline` tables:

- `source_record_staging`;
- `ca_source_qualifications`;
- `ca_course_scope_keys`;
- `evidence_lineage_stats`;
- `evidence_entity_links`.

Direct privilege verification showed `anon` and `authenticated` currently have no SELECT or INSERT privileges on all five. M2.1 did not blindly enable RLS because existing privileged M1 dependencies must first be reconciled. This is retained as a defence-in-depth hardening item and must not be misrepresented as resolved.

## 7. Deployed browser UAT expected coverage

`Coursefinder-Pilot/.github/workflows/deployed-uat.yml` now runs on desktop and mobile and includes `tests/uat/layer2-provider-deployed.spec.mjs`.

Required assertions include:

1. **L2 Providers** launcher and provider registry are visible to authorised users.
2. Direct HTTP and Scrape.do provider/routing state is visible without any credential leakage.
3. RMIT route shows both acquisition paths.
4. PRISMS bounded Direct HTTP acquisition creates a versioned private Evidence artifact and displays Job/Evidence identifiers.
5. Platform Admin credential control is write-only and starts empty.
6. existing Layer 2 source configuration/version/diff UAT continues to pass.
7. desktop and mobile runtime evidence/screenshots are retained.

## 8. Current blocker evidence

Latest Pilot main observed for this gate:

`msinghbs-ai/Coursefinder-Pilot@ab9dfbef618ff259057321cbe88f7473e678c818`

Repeated GitHub combined-status checks returned no SHA-bound statuses (`statuses: []`) for the latest M2.1 commits. The available GitHub connector does not expose listing/dispatching push-triggered runs, and the execution container currently cannot resolve GitHub or the deployed Worker hostname, so independent browser/runtime evidence cannot be reconstructed outside the governed Actions harness.

Therefore the gate is **BLOCKED**, not PASS.

## 9. Third-party provider trials

A real Scrape.do acquisition is intentionally **not claimed** because no Scrape.do API credential has been configured in Vault. Likewise, no screenshot-capable third-party provider is assumed/configured by this workstream.

The platform now supports those trials through Admin configuration rather than code/schema changes. A subsequent provider-trial workstream should:

1. add/configure the selected provider in **L2 Providers**;
2. set its API credential through the write-only Vault control;
3. declare only capabilities the provider actually supports;
4. route it to selected university/source profiles;
5. run bounded comparisons against Direct HTTP/other providers;
6. retain raw/HTML/screenshot Evidence and provider-attempt metrics;
7. deliberately test extraction-blocked fallback;
8. accept/reject the provider based on measured access success, evidence quality, latency, reliability and cost.

## 10. Closure requirement

M2.1 may be changed from BLOCKED to CLOSED / PASS only after:

- current deployed desktop UAT PASS;
- current deployed mobile UAT PASS;
- SHA/run/artifact evidence retained;
- bounded acquisition Evidence lineage confirmed in live database;
- exact M1 regression re-confirmed;
- Change Control/Register/Running Build/Master Plan updated without overwriting newer parallel M2 state.
