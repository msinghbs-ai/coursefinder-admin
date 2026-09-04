# CF-CHG-20260905-152 — Provider Logo Retention & Cache Regression Hardening

**Status:** IMPLEMENTED / TARGETED PASS PENDING FINAL CI  
**Milestone:** M2.4.5  
**Parent feature:** CF-CHG-20260904-102 — CLOSED / PASS  
**Admin release:** v2.15.62

## Trigger

Later Scholarship selector and ingestion work overlapped the same Admin shell after CF-102 had already closed. The user restored the Provider-logo feature from another chat and requested that CF-102 remain a permanent UI/UX capability, with fast loading and caching protected from future cross-chat source overwrites.

## Review finding

CF-102 architecture itself was still valid and restored in source:

- `ProviderLogo.jsx` remains the shared logo component;
- Provider detail uses `ProviderBrand`;
- Course detail uses the same Provider primary asset;
- Compare imports the same ProviderLogo component;
- the Provider list uses a bounded bulk `stable_keys` access call rather than one signed request per row;
- single-Provider requests use an in-memory cache plus in-flight Promise de-duplication;
- Provider-list results use sessionStorage cache;
- the Storage bucket remains private and signed URLs are issued only after Admin/PIM role validation.

The defect was the regression contract: the permanent CF-102 source test was pinned to the old release string `v2.15.57`. That made a correctly retained logo feature appear stale after later releases and increased the risk that a merge/recovery could remove logo wiring merely to satisfy an obsolete assertion.

## Change

### 1. Release-independent CF-102 feature contract

`tests/uat/cf-102-provider-logo-surfaces-deployed.spec.mjs` now asserts feature invariants instead of the historical UI version:

- mature shell imports ProviderLogo/ProviderBrand;
- Provider detail retains ProviderBrand;
- Course detail retains ProviderBrand;
- Comparison retains ProviderLogo;
- in-memory cache remains present;
- in-flight request de-duplication remains present;
- Provider-list sessionStorage cache remains present;
- Provider-list bulk access remains present;
- requestAnimationFrame hydration coalescing remains present;
- list images remain lazy/async/low-priority;
- the international Scholarship selector is also present, proving both features coexist rather than overwrite one another.

The deployed test still verifies real signed `provider-assets` images on Provider, Course and comparison surfaces. A new Provider-list test also constrains the list to a bounded number of `provider-asset-access` calls and verifies sessionStorage cache creation.

### 2. Signed-logo lifetime and bulk signing performance

`provider-asset-access` was advanced to Edge Function **version 4**.

- bucket remains private;
- JWT verification remains enabled;
- normal CourseFinder role validation remains required;
- signed URL lifetime changed from 600 seconds to **1800 seconds**;
- ProviderLogo already subtracts a safety margin before treating a signed URL as reusable;
- Provider-list session cache therefore avoids repeat signing for longer Admin sessions without creating permanent/public URLs;
- the existing bulk request remains capped at 100 stable keys;
- signed URLs for a bulk response are now generated concurrently with `Promise.all` rather than serially, reducing server-side list hydration latency without increasing browser request count.

### 3. Current release

Visible Admin release advanced to **v2.15.62** with release notes explicitly stating that CF-102 remains mandatory alongside Scholarship Selection.

## Runtime/source verification

Current Pilot data contains **51 Providers with approved primary logo assets**. This change does not expand the governed H11/CF-102 university target to every AU/NZ Provider record; it protects the existing approved asset set and display architecture.

## Security boundary

No public Storage access was introduced. No service-role key is exposed. No browser table grant is added. Signed URLs remain temporary and are regenerated per environment.

## Conflict-resolution rule going forward

CF-102 is a **retained platform capability**, not a release-specific experiment. Future Admin shell, Scholarship, Statistics, Course, Provider or comparison changes must preserve the ProviderLogo feature contract. If source overlap occurs, reconcile both capabilities; do not resolve the conflict by deleting Provider logo imports, access paths, cache controls or targeted UAT.

## Source artefacts

- hardened CF-102 UAT contract: `tests/uat/cf-102-provider-logo-surfaces-deployed.spec.mjs`
- signed-access Edge source: `supabase/functions/provider-asset-access/index.ts`
- visible currentness: `src/release-currentness-entry.js`
- shell title: `index.html`

## Production portability

Production must deploy the same private bucket/access model and generate Production-specific signed URLs. Pilot signed URLs or session caches must never be copied to Production.
