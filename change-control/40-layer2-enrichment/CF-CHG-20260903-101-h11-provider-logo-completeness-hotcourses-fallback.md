# CF-CHG-20260903-101 — H11 Provider Logo Completeness & Aggregator Fallback Hardening

**Status:** CLOSED / PASS  
**Initiated:** 2026-09-03 — final acceptance 2026-09-04 06:31 AEST  
**Category:** 40-layer2-enrichment  
**Parent:** CF-CHG-20260903-091 / CF-CHG-20260903-087  
**Related:** CF-081 / A31, CF-082, CF-083 / A32, CF-084  
**Runtime mutation:** YES — Pilot database + Edge Functions + Provider Asset Storage  
**Production:** source inventory advanced only; Production tenancy remains unprovisioned

## Trigger

Finish H11 Provider logo completeness now, using Hotcourses Abroad as a practical reconciliation/fallback source where first-party delivery is missing or blocked.

The user explicitly approved use of an exact university-logo copy obtained through an aggregator where the mark belongs to the university. CourseFinder therefore preserves the aggregator as source/provenance while the canonical asset owner remains the canonical Provider.

## Accepted H11 scope

The broad active-Provider denominator from the CF-091 foundation is replaced for H11 completeness by a governed university cohort:

- 49 canonical ranked AU/NZ university Providers;
- Australia: 41;
- New Zealand: 8;
- scope derived from Provider mappings present in accepted ranking observations/provider links;
- country remains a Provider reconciliation constraint;
- logo similarity never creates or merges Provider identity.

This is an H11 completeness cohort, not a redefinition of the entire Provider catalogue.

## Source authority and fallback rule

Order of preference:

1. first-party university brand/header/logo asset;
2. first-party rendered Evidence / inline SVG;
3. official university downloadable brand bundle;
4. exact university-owned mark obtained through a public aggregator/public mirror when first-party delivery is blocked or the public asset is not directly retrievable.

Hotcourses/IDP is retained as:
- institution reconciliation crosswalk;
- fallback transport/source host where operator-approved;
- provenance Evidence.

The university Provider remains canonical owner.

The following are explicitly non-logo and cannot be promoted:
- Hotcourses/IDP own header/footer logos;
- IDP branding;
- placeholder pixels;
- country flags;
- course/subject imagery;
- social/search/profile icons;
- generic banners.

## Implementation

### Provider-page logo extraction

`layer2-provider-page-fanout` was hardened to recognise:
- JSON-LD organisation logos;
- modern header/brand containers;
- `srcset` / lazy-load attributes;
- picture/source/object/embed structures;
- first-party structured logo markup;
- inline SVG logos retained in Evidence;
- Provider-name-correlated image attributes.

Hotcourses/IDP branding and placeholder/subject-image signals are negatively scored and the known false positives were explicitly rejected.

### Retained inline SVG promotion

The promotion path now supports sanitised first-party inline SVG retained in Provider-page Evidence.

Sanitisation removes executable/script/event-handler/foreign-object content before Storage. Existing confidence and promotion gates remain in force.

### Rendered first-party fallback

For the difficult cohort, the existing Layer 2 acquisition worker was extended so an explicitly forced provider trial may still register a shared fetch when `register_shared_fetch=true`.

All 13 unresolved first-party Provider pages were successfully rendered with retained Evidence/screenshots before final fallback decisions.

### Raw asset proxy fallback

Direct university CDN image fetches returned HTTP 403 for several exact accepted logos.

`layer2-provider-asset-promote` now uses a bounded raw-byte fallback only after direct 403/429/network failure:
- Scrape.do;
- ScraperAPI;
- ZenRows.

Page-render flags are deliberately omitted in asset-byte mode. Image MIME may be safely sniffed from PNG/JPEG/WebP/SVG signatures where the proxy labels the payload generically.

This recovered the exact accepted assets for Macquarie, La Trobe, Monash, Charles Sturt and James Cook University without lowering the confidence threshold.

### Official archive support

QUT publishes an official international-logo ZIP for agents. Promotion worker v4+ supports an explicitly authorised logo archive and deterministically selects the best logo member by filename score.

Accepted QUT archive member:
`QUT International Logo - International.png`.

### Hotcourses crosswalk

The 13 unresolved university exceptions received bounded `third_party_directory` Hotcourses source records and manual fallback profiles.

Hotcourses Direct HTTP acquisition succeeded for the institution pages; no silent paid fallback was required for that acquisition pass.

A cleanup migration rejects known Hotcourses/IDP false-positive candidates.

## Pilot source artefacts

Key migrations:
- `20260903130000_cf_101_h11_official_brand_overrides_batch1.sql`;
- `20260903131500_cf_101_h11_inline_svg_promotion_contract.sql`;
- `20260903134000_cf_101_h11_hotcourses_reconciliation_scope.sql`;
- `20260903135500_cf_101_h11_hotcourses_fallback_profiles.sql`;
- `20260903142500_cf_101_h11_hotcourses_false_positive_cleanup.sql`;
- `20260903144500_cf_101_h11_asset_fetch_fallback_routes.sql`;
- `20260903150000_cf_101_h11_final_eight_logo_fallbacks.sql`;
- `20260904062500_cf_101_h11_final_asset_url_corrections.sql`;
- `20260904063500_cf_101_h11_wikipedia_local_asset_corrections.sql`.

Key implementation commits:
- `d2481741b4f812dd9696165c1c8c84b9f83f59f3` — Hotcourses lazy-loaded logo handling;
- `05e2fb58ea3058a05894d0612f317bf6d569088d` — institution image-attribute inspection;
- `1e0237d413c76498fec0ab7888080939e6674251` — forced acquisition may retain shared Evidence;
- `6f6de718448f4c8c6cb89e29c6f3504a962f4a45` — governed blocked-asset proxy fallback;
- `c528b3adcb123aa69bff5c68fefffddccf89a44a` — raw logo byte handling;
- `d382976fd26e00e66b56f4715a17d97359d2093b` — official QUT logo archive support;
- `773c527ba24870fc259295bca99ed43f64b119fc` — archive pass-through correction;
- `f0020746d187b0b7640980b65f4c5fc20779bc3a` — final source URL corrections;
- `f54a8992d9aa531f17c057be75eac4e57647157a` — final Wikipedia-local asset corrections;
- `9f65736f0d7b83f613f55b4eb8bd707d446798a9` — permanent H11 deployed acceptance updated to current university scope;
- `94d10f5eecada99c9a603d5708559c5e92297e68` — CF-101 targeted deployed-UAT routing.

Latest deployed Edge state:
- `layer2-provider-page-fanout` — upgraded modern logo parser;
- `layer2-acquire-v2` — v13;
- `layer2-provider-asset-promote` — deployed Edge version 6 / worker v4.1.

## Runtime acceptance — PASS

Live Pilot verification at 2026-09-04 06:22 AEST:

- expected: **49**;
- approved primary logos: **49**;
- AU: **41 / 41**;
- NZ: **8 / 8**;
- remaining: **0**;
- approved assets missing Storage/hash/MIME: **0**;
- Providers with duplicate approved primary logos: **0**;
- accepted known Hotcourses/IDP false positives: **0**.

Every accepted primary is stored under the Provider asset Storage namespace with content hash and MIME.

## Security / performance

Post-change Supabase advisors:
- no CF-101-specific WARN/ERROR identified;
- Security Advisor continues to report existing INFO-only RLS-enabled/no-policy findings on private catalogue tables, including `catalogue.provider_assets`;
- Performance Advisor continues to report existing INFO-only unindexed-FK findings elsewhere.

CF-101 does not relax browser table access and does not expose service-role credentials.

## UAT

Database/runtime acceptance: **PASS**.

Permanent deployed browser spec:
`tests/uat/cf-091-h11-provider-assets-deployed.spec.mjs`
now asserts the current university scope and 41/41 AU view rather than the superseded broad-Provider scope warning.

Final targeted verification:
- Pilot Frontend Build `33802561372`: PASS;
- CourseFinder Deployed UAT `33802561541`: PASS;
- earlier run `33802121519` is retained as a test-routing regression: H11 itself passed, but the workflow selected stale CF-089 UAT due routing precedence; corrected by Pilot `7aa9f77e67d7855ea74c80150d3a1eadddd45fa3`.

H11 browser/source/runtime acceptance is therefore PASS.

## Rollback

If the H11 hardening must be reversed:
- disable Hotcourses fallback profiles/routes;
- revert the parser/promotion Edge Functions to their prior accepted deployments;
- stop new fallback promotions;
- retain already-written Evidence and Provider asset rows for audit rather than deleting historical provenance;
- explicitly demote/review any affected primary Provider asset rather than destructive removal;
- restore the prior Admin read contract only if the university-scope contract itself is being rolled back.

## Production portability

When M2.5 resumes, Production must include:
- all CF-101 migrations above;
- current `layer2-provider-page-fanout`;
- current `layer2-acquire-v2`;
- current `layer2-provider-asset-promote`;
- Provider asset Storage bucket/object paths and hashes;
- Layer 2 acquisition provider/Vault configuration used by controlled asset fallback;
- Hotcourses reconciliation sources/profiles if retained for Production operations.

No Production target state is advanced by this change.

## Outcome

H11 is CLOSED / PASS at 49/49 approved primary university logos with runtime and targeted deployed-browser acceptance complete.
