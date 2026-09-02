# CF-CHG-20260902-081 — Layer 2 consolidated acquisition, Scholarship seed & Provider assets

**Status:** APPLIED / TARGETED VERIFICATION IN PROGRESS  
**Initiated:** 2 September 2026 (Australia/Melbourne)  
**Primary owner:** Layer 2 Enrichment  
**Origin:** Scholarship initial seed, Provider logos and cross-module acquisition-cost consolidation  
**Pilot migration:** `20260902132027 cf_081_layer2_consolidated_acquisition_scholarship_assets`

## Objective
Make Scholarships and Provider logos first-class Layer 2 acquisition targets while reducing repeated vendor fetches across Course, Scholarship and Provider enrichment.

## Before
- Course Layer 2 already used governed Direct HTTP / scraper routing.
- Scholarship ETL retained a separate first-party fetch implementation.
- Provider logos had no governed asset/candidate model.
- `layer2_source_profiles.source_id` was one-to-one, preventing multiple deterministic extraction profiles over one Evidence source.
- Study Australia full ETL ran daily and scholarship maintenance ran daily.

## After
- one physical source may support multiple versioned Layer 2 extraction profiles;
- same-URL acquisitions can be content-hashed, retained as private Evidence and reused for a bounded TTL;
- sibling extraction tasks are recorded in `pipeline.layer2_fanout_tasks`;
- `catalogue.provider_assets` and `pipeline.provider_asset_candidates` govern logos/brand assets;
- AU/NZ first-party web-catalogue anchors receive Scholarship and Provider-logo profiles;
- Parse.bot is registered **disabled** until endpoint/key qualification;
- Direct HTTP remains first, Firecrawl remains the active rendered fallback, with terminal fallback retained;
- routine full refresh is volatility-based rather than blanket daily.

## Source authority
Canonical Scholarship facts prefer official Provider/government sources. Commercial aggregators (including Hotcourses/IDP) are reconciliation/UX signals only unless separate reuse authority is explicitly approved.

Provider logos must originate from first-party Provider web/brand assets where possible. A logo never establishes Provider identity.

## Cadence
| Domain | Full refresh | Lightweight/change check | Acceleration |
|---|---:|---:|---|
| Course facts | 30 days | 7 days | 72h around fee/intake changes |
| Scholarships | 7 days | 72h | 24h around application boundaries |
| Provider logos | 90 days | 30 days | changed source/hash |
| DFAT Australia Awards | 30 days | source health | on announced cycle change |

## Initial seed
The accepted Study Australia seed existed before this change. CF-081 extends the bounded bootstrap with three additional first-party dispatch windows: pages 6–10, 11–15 and 16–20, max 50 records each.

## Security boundaries
- QILT/PRISMS and statistical Layer 1 sources remain prohibited by the Layer 2 route trigger.
- new tables have RLS enabled and browser roles revoked;
- shared-fetch RPCs are service-role only;
- Parse.bot has no endpoint or credential and is disabled;
- no Search/Website/Zoho publication is authorised.

## Implementation
- Pilot migration `20260902132027`;
- `layer2-acquire-v2` upgraded to v10 for shared-fetch lookup/register;
- Pilot source commit: `e3d3109734306701fe6c63acbc2472e47dc06d95`.

## Rollback
Disable new Scholarship/logo profiles and Parse.bot, restore previous cadence, revert Layer 2 worker to v9, then remove new fan-out/assets structures only after proving no retained Evidence/asset references depend on them. Do not delete canonical Scholarship or Evidence history as rollback.
