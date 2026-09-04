# CF-CHG-20260905-152 — Provider Logo Retention & Cache Regression Hardening

**Status:** CLOSED / PASS  
**Milestone:** M2.4.5  
**Parent feature:** CF-CHG-20260904-102 — CLOSED / PASS  
**Admin release:** v2.15.62

## Trigger

Later Scholarship selector and ingestion work overlapped the same Admin shell after CF-102 had already closed. The user restored the Provider-logo feature from another chat and requested that CF-102 remain a permanent UI/UX capability, with fast loading and caching protected from future cross-chat source overwrites.

## Review finding

CF-102 architecture itself remains valid and restored in source:

- `ProviderLogo.jsx` remains the shared logo component;
- Provider detail uses `ProviderBrand`;
- Course detail uses the same Provider primary asset;
- Compare imports the same ProviderLogo component;
- the Provider list uses one bounded bulk `stable_keys` access call rather than one signed request per row;
- single-Provider requests use an in-memory cache plus in-flight Promise de-duplication;
- Provider-list results use sessionStorage cache;
- the Storage bucket remains private and signed URLs are issued only after Admin/PIM role validation.

The primary regression defect was the permanent CF-102 source test being pinned to the historical `v2.15.57` release string. That made a correctly retained logo feature appear stale after later releases and increased the risk that a merge/recovery could remove logo wiring merely to satisfy an obsolete assertion.

A second review issue was found during CF-152 UAT: the first bulk-signing optimisation used unbounded `Promise.all` across up to 100 descriptor rows. That did not match the intended bounded-concurrency design and was corrected before closure.

## Change

### 1. Release-independent CF-102 feature contract

`tests/uat/cf-102-provider-logo-surfaces-deployed.spec.mjs` now asserts feature invariants instead of a historical UI version:

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
- the international Scholarship selector is also present, proving both features coexist rather than overwrite one another;
- the Edge source must retain a 30-minute signed URL TTL and bounded signing concurrency of eight.

The deployed test still verifies real signed `provider-assets` images on Provider, Course and comparison surfaces.

### 2. Signed-logo lifetime and bulk signing performance

`provider-asset-access` is Edge Function **version 5**.

- bucket remains private;
- JWT verification remains enabled;
- normal CourseFinder role validation remains required;
- signed URL lifetime is **1800 seconds**;
- ProviderLogo subtracts a safety margin before treating a signed URL as reusable;
- Provider-list session cache therefore avoids repeat signing for longer Admin sessions without creating permanent/public URLs;
- the bulk request remains capped at 100 stable keys;
- bulk signing uses a concurrency pool capped at **8** instead of serial signing or unbounded Promise fan-out.

### 3. Deployed UAT finding and correction

Two earlier targeted deployed runs proved the critical CF-102 surfaces were healthy but exposed an over-eager new list-persistence assertion:

- Provider detail rendered a real signed primary logo;
- Course detail rendered the same governed Provider logo;
- Provider comparison rendered two real signed logos;
- source contract assertions passed.

The Provider-list persistence sub-test initially treated immediate fallback-slot rendering as proof that an asynchronous bulk request/cache write must already have completed. The test was revised to be response-aware:

- browser call count remains bounded;
- if a bulk request is made, its response must be 2xx;
- successful bulk results must persist into the session cache within a bounded settle window;
- absence of a new bulk request is not itself treated as cache failure.

This preserves a strict runtime gate without confusing render timing with cache correctness.

### 4. Current release

Visible Admin release remains **v2.15.62** with release notes explicitly stating that CF-102 remains mandatory alongside Scholarship Selection.

## Runtime/source verification

Current Pilot data contains **51 Providers with approved primary logo assets**. This change does not expand the governed H11/CF-102 university target to every AU/NZ Provider record; it protects the existing approved asset set and display architecture.

The bulk descriptor RPC was verified against 50 Provider stable keys and returned 50 descriptor rows, confirming that the DB-side bulk lookup contract itself is intact.

## Final validation

Final source commit under test: `c87e076d68953c2299a642ec72e37ae8cd410cc1`.

- Pilot Frontend Build `33917141425` — **PASS**;
- local browser smoke under the same run — **PASS**;
- deployed targeted UAT `33917141431` — **PASS**;
- deployed Provider, Course and Compare surfaces rendered governed signed logo URLs;
- Provider-list bounded/cache contract passed.

## Security boundary

No public Storage access was introduced. No service-role key is exposed. No browser table grant is added. Signed URLs remain temporary and are regenerated per environment.

## Conflict-resolution rule going forward

CF-102 is a **retained platform capability**, not a release-specific experiment. Future Admin shell, Scholarship, Statistics, Course, Provider or comparison changes must preserve the ProviderLogo feature contract. If source overlap occurs, reconcile both capabilities; do not resolve the conflict by deleting Provider logo imports, access paths, cache controls or targeted UAT.

## Source artefacts

- hardened CF-102 UAT contract: `tests/uat/cf-102-provider-logo-surfaces-deployed.spec.mjs`
- signed-access Edge source: `supabase/functions/provider-asset-access/index.ts`
- visible currentness: `src/release-currentness-entry.js`
- shell title: `index.html`

Key CF-152 Pilot commits:

- release-independent CF-102 contract: `08f0ddd27f29b7449c7c02ced4955f3522706299`;
- 30-minute signed URL TTL: `874ef91e535d158096f1c7d9ffdfb4daa29d0216`;
- first parallel-signing pass: `48038421b7c5c4a1508a6e8bc24ec2b208cbc00b`;
- bounded concurrency correction: `a5b48d0923ec61e1c89696e2badf7a8ef4a43aeb`;
- response-aware deployed cache UAT: `c87e076d68953c2299a642ec72e37ae8cd410cc1`.

## Production portability

Production must deploy the same private bucket/access model and generate Production-specific signed URLs. Pilot signed URLs or session caches must never be copied to Production.
