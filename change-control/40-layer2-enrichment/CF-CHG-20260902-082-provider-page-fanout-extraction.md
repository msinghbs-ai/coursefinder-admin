# CF-CHG-20260902-082 — Provider Page Fan-out Extraction

**Status:** IMPLEMENTED / BOUNDED UAT ACTIVE  
**Date:** 2 September 2026  
**Parent:** CF-CHG-20260902-081 / A31  
**Layer:** Layer 2 Enrichment

## Objective
Consume one governed first-party Provider page acquisition and deterministically fan that Evidence into:
- Provider logo/brand candidates;
- Scholarship discovery links;
- existing Course profile reuse through the CF-081 shared-fetch plane.

No extra crawl is performed by the fan-out worker.

## Runtime
- Edge Function: `layer2-provider-page-fanout` v1;
- Pilot source: `4a827d7d964a4b1ab96559b1ad4a40b598cdb2c8`;
- service bridge migration: `20260902134010_cf_082_provider_page_fanout_service_bridge`;
- Provider-asset runtime context migration: `20260902134700_cf_082_provider_asset_runtime_context`.

## Extraction
Logo candidates are discovered from first-party HTML/Firecrawl HTML using deterministic markup signals such as:
- image src/data-src;
- alt/class/id containing logo/brand/wordmark/crest;
- first-party SVG/PNG preference;
- low confidence for generic social/OG/icon assets.

Scholarship candidates are discovered from same-page links containing scholarship/bursary/funding/financial-aid/award semantics with obvious news/event/research-award noise excluded.

## Authority
- logo candidates are staging/review data and do not define Provider identity;
- high-confidence candidates may enter accepted candidate state but do not become primary published assets automatically;
- Scholarship links are discovery candidates only and require normal Layer 2 acquisition/extraction before canonical Scholarship apply;
- no QILT/PRISMS/Layer 1 routing change;
- no Search/Website/Zoho publication change.

## UAT cohort
Initial acquisition cohort is limited to five AU university Providers:
- Australian Catholic University;
- Australian National University;
- Central Queensland University;
- Charles Darwin University;
- Curtin University.

The first attempt correctly exposed a stale `layer2_runtime_context` domain guard and returned HTTP 409 without vendor acquisition. CF-082 then extended the existing service-role runtime guard specifically to `provider_asset`; the cohort was requeued once after correction.


## Live bounded acquisition result
All five university Provider-page acquisitions passed HTTP 200:
- Direct HTTP: ANU, CDU, Curtin — 3/5;
- Firecrawl fallback: ACU, CQUniversity — 2/5;
- no Parse.bot calls;
- no failed acquisition.

Sibling Scholarship-profile reuse then passed 5/5:
- every request returned `provider_key=shared-fetch`;
- `shared_fetch_reused=true`;
- each retained the original Evidence ID;
- estimated request cost was 0 for all five;
- each shared-fetch row now has `reuse_count=1`.

This proves one Provider-page acquisition can serve another Layer 2 module without a second vendor acquisition.

## Fan-out quality finding
Initial deterministic extraction found useful Scholarship discovery entrypoints but the first logo scoring rule produced false positives for an ACU partnership logo and CQUniversity Regional Universities Network footer logo. Those rows were explicitly rejected and the extractor was tightened before broader rollout. No candidate was promoted into `catalogue.provider_assets` or `providers.logo_url`.

The fan-out Edge is now v3 / worker `layer2-provider-page-fanout-v1.2`.
