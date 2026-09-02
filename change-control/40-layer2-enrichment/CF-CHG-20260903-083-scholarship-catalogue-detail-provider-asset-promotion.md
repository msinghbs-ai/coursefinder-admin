# CF-CHG-20260903-083 — Scholarship Catalogue→Detail Acquisition & Provider Asset Promotion

**Status:** IMPLEMENTED / TARGETED PASS — CONTROLLED DATA POPULATION CONTINUES  
**Date:** 3 September 2026 (Australia/Sydney)  
**Primary owner:** Layer 2 Enrichment  
**Parents:** CF-CHG-20260902-081 / CF-CHG-20260902-082 / A31  
**Pilot head:** `8fbcb36f76c52af7cd535adb910c7f2116378c66`

## Objective
Complete the governed acquisition path needed for large Provider Scholarship catalogues and Provider logos without flattening catalogue pages into single Scholarship records or publishing unresolved applicability.

## Provider asset promotion
Implemented:
- private `provider-assets` Storage bucket;
- candidate promotion context and apply RPCs;
- `layer2-provider-asset-promote` worker;
- asset fetch/mime/size validation;
- SHA-256 content hashing;
- Provider-scoped immutable storage path;
- primary approved asset record in `catalogue.provider_assets`;
- no direct Provider identity mutation and no direct `providers.logo_url` mutation.

Promoted:
- CQUniversity official navigation SVG;
- Edith Cowan University official PNG.

Charles Sturt official SVG remains accepted-but-unpromoted because the source CDN returned HTTP 403 to the promotion worker. The control was not weakened.

## Scholarship catalogue architecture
A Provider Scholarship catalogue is an enumeration source, not one Scholarship.

Accepted route:
`scholarship_catalogue → normalised Evidence → catalogue enumeration → scholarship_detail candidates → detail acquisition → detail extraction → canonical unpublished root → Layer 4 scope resolution → later publication gate`.

`pipeline.scholarship_catalogue_runs` records Provider/source/Evidence/content hash and discovered/unique/duplicate counts so completeness can be measured over time.

Catalogue pages are explicitly rejected by the individual Scholarship extractor with `catalogue_enumeration_required`.

## Bounded catalogue UAT
Seven first-party AU entrypoints acquired and normalised:
- ACU;
- ANU;
- CDU;
- Charles Sturt;
- Curtin;
- Deakin;
- ECU.

Acquisition: 7/7 HTTP 200, 3 Direct HTTP + 4 Firecrawl.

Enumeration:
- ACU 0 → needs_review;
- ANU 0 → needs_review;
- CDU 5;
- Charles Sturt 14;
- Curtin 14;
- Deakin 6;
- ECU 13.

Total discovered by catalogue runs: **52**. Zero results are not treated as completeness PASS.

## Individual detail UAT
Six first-party detail profiles:
- CDU Vice-Chancellor's High Achievers Scholarship;
- Charles Sturt International Joint Cooperation Program Scholarship;
- International Student Success Merit Scholarship;
- International Student Success Scholarship;
- Regional Accommodation Bursary for International Students;
- Vice-Chancellor International Excellence Scholarship.

Detail acquisition: 6/6 HTTP 200.
- CDU: Direct HTTP;
- Charles Sturt five: Firecrawl fallback.

Stable identity uses the official first-party detail URL with identifier scheme `first_party_detail_url`, not content hash/title.

Extracted bounded facts include:
- 25% fee;
- 30% tuition;
- 15% tuition;
- AUD 1,000 bursary;
- 50% tuition;
- international audience;
- application/deadline text where deterministic;
- eligibility text;
- scope-resolution requirement.

## Canonical / Layer 4 boundary
All six records passed dry-run Provider resolution:
- CDU CRICOS `00300K`;
- Charles Sturt CRICOS `00005F`;
- 0 unmapped Providers.

Six canonical Scholarship roots were created:
- Provider-linked;
- first-party URL identified;
- `publication_status='unpublished'`;
- no fabricated cycles/windows/scopes.

`scope_resolution` is now a publication-sensitive JSON field in the existing Layer 4 field registry. Six pending Layer 4 review items hold the exact Evidence and extracted eligibility/applicability clues. No Course applicability is manufactured before review.

Live Scholarship count: **186** (180 prior baseline + 6 CF-083 roots).

## Quality corrections retained as audit
Catalogue-level misinterpretations that produced junk values such as tiny dollar amounts were rejected, not deleted. The extractor now prevents catalogue pages entering detail extraction.

## Security
Private pipeline/catalogue structures retain RLS with browser grants revoked. New automation uses narrow service-role RPCs rather than exposing private schemas.

Post-change advisors: changed surface **0 WARN / 0 ERROR**. New FK-index INFO findings were corrected by `20260903212500_cf_083_scholarship_catalogue_fk_indexes.sql`.

## Consumer boundary
No CF-083 Scholarship or Provider logo is admitted to Search, Website/Wix or Zoho by this change. Canonical Scholarship roots remain unpublished until scope/publication gates are satisfied.
