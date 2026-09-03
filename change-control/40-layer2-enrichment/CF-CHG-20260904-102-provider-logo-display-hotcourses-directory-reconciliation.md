# CF-CHG-20260904-102 — Provider Logo Display & Hotcourses Directory Reconciliation

**Status:** IMPLEMENTED / TARGETED VERIFICATION ACTIVE  
**Initiated:** 2026-09-04 06:50 AEST  
**Category:** 40-layer2-enrichment  
**Parent:** CF-CHG-20260903-087  
**Related:** CF-CHG-20260903-091, CF-CHG-20260903-101, CF-081/A31, CF-082, CF-083/A32, CF-084  
**Runtime mutation:** YES — Pilot database, Edge Functions, Admin UI  
**Admin release:** v2.15.57  
**Production:** source inventory only; Production tenancy remains unprovisioned

## Trigger

The user confirmed that approved university logos should not remain only in the Provider Assets administration workspace. The primary approved university logo should appear where it improves recognition and visual quality, specifically:
- Provider detail blade;
- Course detail blade;
- Provider comparison;
- Course comparison / selected Provider context;
- other compact identity surfaces where the additional signed-asset request is justified.

The user also directed CourseFinder to scrape/parse Hotcourses Abroad directly or through Layer 2 and update the process rather than treating the prior H11 reconciliation as a one-off.

## Display architecture

The Provider asset bucket remains private.

New governed access path:
1. browser supplies normal CourseFinder bearer session;
2. `provider-asset-access` validates the authenticated Admin/PIM role through `admin_read('context')`;
3. a service-only descriptor resolves the current approved primary Provider logo;
4. the Edge Function returns a short-lived signed `provider-assets` Storage URL;
5. the shared `ProviderLogo` component caches the signed URL until near expiry.

No Storage bucket was made public and no service-role credential is exposed.

## UI implementation

Release v2.15.57 adds the shared `src/ProviderLogo.jsx` identity component.

Surfaces:
- **Provider blade:** 54px university mark in the detail header with Provider identity.
- **Course blade:** Provider/university brand strip above Course facts.
- **Provider comparison:** logo in each selected comparison entity card.
- **Course comparison:** Provider logo for each selected Course entity and the selected Provider chip.
- PRISMS comparison cards reuse the same Provider identity where applicable.

Large catalogue tables are intentionally not filled with signed logos by default. This avoids turning a 50-row table render into 50 signed-asset calls and keeps the visual mark on decision/identity surfaces where it is useful.

## Hotcourses repeatable Layer 2 feed

Hotcourses is now a governed, repeatable Provider Asset reconciliation source rather than an H11-only manual crosswalk.

Registered country directory sources:
- Australia: `https://www.hotcoursesabroad.com/study/australia/international/schools-colleges-university/9/list.html`
- New Zealand: `https://www.hotcoursesabroad.com/study/newzealand/international/schools-colleges-university/134/list.html`

Profiles:
- `au-hotcourses-provider-directory`
- `nz-hotcourses-provider-directory`

Architecture:
- domain remains `provider_asset`;
- target entity remains `provider_asset`;
- authority class `third_party_discovery`;
- Direct HTTP priority 10;
- Firecrawl fallback priority 40;
- Evidence required;
- monthly reconciliation/manual on-demand cadence;
- Provider identity is never created or merged by the directory;
- parsed observations are stored in private `pipeline.provider_directory_observations`.

An initial attempt to model the directory profile as target `provider` was rejected by the existing Layer 2 route-scope guard. CF-102 preserves that guard and keeps the directory within Provider Asset enrichment rather than broadening Layer 2 authority.

## Parser

New Edge Function:
`layer2-hotcourses-directory-parse`.

It parses retained Hotcourses Evidence for:
- Hotcourses institution ID;
- observed institution name;
- institution detail URL;
- institution-card logo URL;
- country;
- pagination references when present.

Provider mapping is country constrained:
1. exact canonical/display match with harmless leading “The” normalisation;
2. exact governed Provider alias match within the same country;
3. otherwise remain unmatched.

No fuzzy global name match is authorised.

For a matched ranked AU/NZ university with no approved primary logo, an extracted institution-card logo can enter the existing Provider Asset workflow as:
- confidence 0.85;
- `needs_review`;
- never automatic promotion;
- never replacement of an already-approved primary.

## First live acquisition and parse

Both country-list pages were acquired through the normal Layer 2 bridge using **Direct HTTP**. Firecrawl was not required and estimated paid-vendor acquisition cost was zero.

AU:
- Layer 2 request: 4838;
- Evidence: `9871c365-5cd5-4be2-8d40-e0623e819f13`;
- latency: 1,036 ms;
- parsed institution cards: 12;
- extracted institution-card logo URLs: 12;
- matched Providers after governed alias correction: **12/12**.

NZ:
- Layer 2 request: 4839;
- Evidence: `6f3821e6-5644-4638-8e0b-291c6ad7992f`;
- latency: 995 ms;
- parsed institution cards: 12;
- extracted institution-card logo URLs: 12;
- matched Providers: **10/12**;
- intentionally unmatched:
  - Ara Institute of Canterbury Limited;
  - Massey University College.

These unmatched entries are retained as directory observations and are not coerced into university Provider identity.

Total first-pass observations:
- 24 institution cards;
- 24 logo URLs;
- 22 country-safe Provider matches;
- 2 retained unmatched;
- 0 new Provider Asset review candidates because the accepted ranked AU/NZ university cohort already has 49/49 approved primary logos.

## Runtime / source artefacts

Migrations:
- `20260904065000_cf_102_provider_logo_display_access.sql`;
- `20260904070500_cf_102_hotcourses_directory_reconciliation.sql`;
- `20260904071500_cf_102_hotcourses_parser_allowlist.sql`;
- `20260904073000_cf_102_hotcourses_country_alias_matching.sql`.

Edge Functions:
- `provider-asset-access` v1;
- `layer2-hotcourses-directory-parse` v1.

Key Pilot commits:
- signed descriptor: `cff0115111819b641adab261e68605b676c2205c`;
- signed access Edge: `76d97ce068ecda77f7d2e5ac79312636f183ffe0`;
- browser API: `df70c23cb465ee5d9f456532c7e5780759bd47e9`;
- shared logo component: `cc256b86aa6444f3a91054ebe978e36e5744b816`;
- styles: `f0b3b828de09158dc1f48aeb5c5d65d122881d55`;
- Provider blade: `c3d411b82439cd601110147640791218b090cf1f`;
- Course blade: `e638b7ff4b920bde7a6bcc6611855233ecc6fe4c`;
- Compare: `df5c90756c32060dcfb1eadea730b86eab065f86`;
- directory migration guard correction: `fdc79ef41f9e0fdfea025d42f00a80199cf731c5`;
- directory parser: `7670afa074352c434545daccc93d4b6db3b8fab6`;
- parser allowlist: `ebc2c40b470a137f24982e2dedf74a1cf6a7d2a9`;
- country-safe alias matching: `7f30e0bc82986c8c49f3d3f66bb10995f26bce07`;
- v2.15.57 main: `345645bb30b8f2945d33a5ba04dd6766bb0fcb03`;
- release notes: `2352a86c4672bcc9383c3c931ecefb05bb26767f`;
- title currentness: `9276232011a3846bde373be0c2f3ee53476f3020`;
- permanent deployed UAT: `3f750310b1035a564a583b1f16ea0ed9fc571729`;
- final targeted routing precedence: `d947f693f6a2673add90de0d9ce7914e7610b23b`.

## Security / performance

Post-change Supabase advisors:
- Security: 175 INFO / **0 WARN / 0 ERROR**;
- Performance: 203 INFO / **0 WARN / 0 ERROR**.

Existing INFO findings remain programme-level observations. CF-102 adds no browser table grant for `provider_directory_observations`.

## UAT

Permanent targeted spec:
`tests/uat/cf-102-provider-logo-surfaces-deployed.spec.mjs`.

It proves:
- v2.15.57 source/currentness;
- Provider blade uses governed ProviderBrand;
- Course blade uses the same Provider primary asset;
- comparison cards use the same Provider logo;
- browser access uses `provider-asset-access`;
- deployed RMIT Provider and Course render actual signed `provider-assets` URLs;
- RMIT + UQ Provider comparison renders both logos.

Current workflows:
- Frontend Build `33805770000` — active at record time;
- Deployed targeted UAT `33805769747` — active at record time.

## Production portability

When M2.5 resumes, Production must include:
- CF-102 migrations above;
- private `provider_directory_observations` data/schema;
- Hotcourses AU/NZ sources, profiles and provider routes;
- `provider-asset-access`;
- `layer2-hotcourses-directory-parse`;
- current Admin v2.15.57 UI source;
- existing private `provider-assets` object paths/hashes;
- target-project signed URLs must be regenerated by the Production Edge Function and must never copy Pilot signed URLs.

No Production target state is advanced.

## Rollback

- remove ProviderLogo rendering from the affected UI surfaces;
- disable `provider-asset-access`;
- disable Hotcourses directory profiles/routes;
- stop new directory parse runs;
- retain Evidence and directory observations for audit;
- do not delete already-approved primary logos;
- no Provider identity rollback should be required because CF-102 does not create or merge Provider identity.

## Outcome

Provider logos are now part of the intended Admin/PIM visual identity system and Hotcourses directory acquisition/parsing is a repeatable governed Layer 2 Provider Asset process. Final closure depends only on the current targeted build/browser workflow conclusions.
