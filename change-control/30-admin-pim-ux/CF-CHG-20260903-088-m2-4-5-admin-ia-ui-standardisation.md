# CF-CHG-20260903-088 — M2.4.5 H1 Administration IA/UI standardisation

**Status:** IMPLEMENTED / TARGETED VERIFICATION ACTIVE  
**Initiated:** 2026-09-03 10:35 AEST (Australia/Sydney)  
**Implementation started:** 2026-09-03 10:39 AEST  
**Owner:** Admin/PIM UX  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260903-087 / M2.4.5  
**Related:** CF-078, CF-058, CF-084, CF-085, CF-086  
**Pilot release:** v2.15.45

## Objective

Standardise Administration information architecture before Production readiness without changing accepted primary routes, rank boundaries, data authority, Search/Publication contracts or Production provisioning state.

## H1 inventory

### Primary NAV

`src/mature-main.jsx` retains the accepted primary groups:
- Overview → Dashboard;
- Catalogue → Providers, Courses, Campuses, Scholarships, Provider Contacts;
- Statistics & Insights → Statistics & Rankings, Compare;
- Data Operations → Layer 1, Layer 2, Layer 3, Layer 4, Evidence, Jobs;
- Quality & Review → Completeness, Review Queue;
- Administration → Administration.

No new primary menu or floating settings launcher was added.

### Administration sections and minimum visible rank

| Section | Rank | Purpose |
|---|---:|---|
| Overview | 4 | canonical configuration map |
| Sources & Imports | 4 | governed publisher/import registration |
| Layer 1 sources | 6 | authoritative Layer 1 source controls |
| Layer 2 sources | 4 | enrichment source/profile configuration |
| Scraper Config | 4 | provider registry/routing view; higher-rank writes remain server enforced |
| Scheduling | 4 | scheduling workspace inside Administration |
| Onboarding | 4 | onboarding workspace inside Administration |
| PIM configuration | 5 | PIM attributes/families/options/completeness |
| Users & Roles | 6 | identity/role administration |
| Environment & Migration | 6 | environment, credentials and Production migration inventory |
| Platform | 6 | platform/readiness controls |

The section metadata is now defined once in `ADMIN_SECTIONS` and reused for labels, rank visibility, breadcrumbs, tabs and overview cards.

### HIDDEN_ROUTES / compatibility

Existing hidden/deep-link routes were inventoried.

- `#users-roles` now resolves to canonical Administration → Users & Roles.
- `#attributes` resolves to canonical Administration → PIM configuration.
- `#settings` resolves to canonical Administration → Platform.
- `Refresh & Scheduling` and `Onboarding` compatibility routes are retained because their historic minimum rank is 3 while central Administration begins at rank 4; silently redirecting them would change permissions.
- `Sources` remains a distinct hidden operational source registry because it is not equivalent to any one Administration configuration section.
- QILT and PRISMS hidden dataset routes remain unchanged.

### PAGE_META and workspace patterns

No accepted page title/deep-link contract was deleted. Administration continues to own nested section breadcrumbs. The large duplicated overview card definitions were replaced by compact metadata-driven cards using the existing Admin theme.

### Roles/rank visibility

Runtime reconciliation confirms:
- viewer 1;
- counsellor 2;
- curator 3;
- pipeline_operator 4;
- `pim_admin` displayed as **PIM Operator**, rank 5;
- platform_admin 6.

No role rank or server authority changed.

### Readers / writers / runtime consumers

H1 changed composition only.

- Users & Roles continues to use `accessApi` and its existing protected access-management Edge/server boundary.
- PIM configuration continues to use existing Attributes/PIM readers/writers.
- Environment & Migration continues CF-084 write-only credential and manifest services.
- Platform continues CF-058 secured Admin reads/mutations.
- Scheduling/Onboarding continue existing operational services.

The standalone `access-roles-root` and standalone access script were removed from `index.html`; the same Users & Roles implementation is now embedded in Administration. This removes a parallel full-screen Admin shell without changing the access service.

## H2 inventory started

The first H2 reconciliation was performed against Pilot runtime and current source.

Canonical Scraper Config readers/writers:
- reads: `adminRead('layer2_acquisition_providers')`, `adminRead('layer2_profiles')`, `adminRead('layer2_provider_routes')`;
- provider writes: `layer2-provider-control`;
- bounded provider execution: `layer2-acquire`;
- global wave/routing policy: `layer2-sync-control` → `public.layer2_execution_policy_service` / `public.layer2_wave_scope_service`;
- existing per-profile execution-policy writer: `public.layer2_ops_policy_update`.

Runtime provider state at 2026-09-03 10:43 AEST:
- Direct HTTP enabled priority 10;
- Scrape.do enabled priority 20;
- Parse.bot **disabled** priority 25;
- ScraperAPI enabled priority 30;
- Firecrawl enabled priority 40, 30/min, concurrency 5, timeout 90s, recorded monthly entitlement 5,000, reserve 250;
- ZenRows enabled priority 50;
- Custom gateway disabled priority 90.

H2 presentation was aligned so the embedded provider surface explicitly identifies **Administration · Scraper Config** and its single provider-control-plane ownership. No routing semantics were changed.

## Implementation

Pilot commits:
- `a5eff83fa4accf190728f796480c5e4a986010ca` — expose embedded Users & Roles;
- `f2b0b993f716581f8167733880010208ab678a35` — canonical embedded access styling;
- `527980d1e4fb5870c4870845a9b7956b6b3838f1` — metadata-driven Administration IA/deep-link compatibility;
- `2a082cf79e12f0bf5e86e89100799ddcf5ed9bb8` — compact Admin cards;
- `f3392fa7d933b543ea282e613f26043525206470` — retire standalone access shell/root;
- `1dbe29c15e454218c4346f916970d4ce03389f79` — v2.15.45 release;
- `60c8ad28afa28b166641d168d0c7bf08e0a74c56` — stable heading + H2 policy wording;
- `a033d3ef941eadb7fd992da15eb82c77956f9bec` — Scraper Config ownership wording;
- `87eba42de1e03c9761b927f2cb59a793cd10215f` — targeted H1 contract alignment.

Permanent targeted contract:
- `tests/uat/cf-088-admin-ia-targeted.spec.mjs`;
- source contract includes `npm run build`;
- deployed browser verifies the canonical Admin shell, compact overview, v2.15.45 and that a non-rank-6 UAT identity cannot expose Users & Roles through the legacy deep link.

## Production / data impact

None.

- no Production Supabase project created;
- no database schema or data migration;
- no Production target status advanced;
- no secret moved or exposed;
- no Search/Publication/Website/Zoho authority changed.

The Production migration manifest remains source-ready / target-pending.

## Rollback

Revert the listed Pilot commits in reverse order. Because this is UI/composition only, no data rollback is required. The legacy access component styles remain present for safe source rollback.

## Verification

Targeted workflows are running against the final H1 source lineage. Do not mark targeted PASS until both targeted build and deployed-browser evidence are successful.
