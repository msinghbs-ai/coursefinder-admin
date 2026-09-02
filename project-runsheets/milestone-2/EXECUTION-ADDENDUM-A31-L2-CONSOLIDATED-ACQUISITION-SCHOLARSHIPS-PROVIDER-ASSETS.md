# Execution Addendum A31 — Consolidated Layer 2 Acquisition, Scholarships & Provider Assets

**Status:** ACTIVE / APPLIED IN PILOT  
**Change:** CF-CHG-20260902-081  
**Date:** 2 September 2026

## Rule
Layer 2 acquisition is a shared evidence plane, not a separate scraper implementation per module.

A successful first-party/provider-page fetch may feed multiple deterministic profiles (Course facts, Scholarship discovery, Provider asset/logo extraction) only where the source URL and authority are valid for each profile. Each downstream interpretation keeps its own profile version, target grain and Evidence lineage.

## Routing
Default low-cost path:
1. reusable same-URL Evidence inside bounded TTL;
2. Direct HTTP;
3. Parse.bot only after credential + adapter qualification (currently disabled);
4. Firecrawl rendered acquisition;
5. governed terminal fallback.

Vendor calls remain budget/rate/concurrency controlled. Shared Evidence must not bypass profile allowlists or canonical mutation gates.

## Scholarship
Scholarships remain Layer 2 enrichment with a first-class canonical Scholarship domain. National government catalogues bootstrap discovery; first-party Provider catalogues close completeness gaps and resolve Provider/course/study-level/field scope.

Hotcourses/IDP or other commercial aggregators are reconciliation signals unless licensed/approved as sources.

## Provider logos
Logos are `provider_asset` enrichment. Prefer official SVG/PNG/brand assets or deterministic organisation-logo markup. Store candidate + source Evidence first; approval selects the primary display logo. Logo matching never creates/merges Providers.

## Cross-module cost control
- hash/check before full extraction where possible;
- reuse one acquisition for sibling extraction tasks;
- no repeat Firecrawl request solely because another module needs the same unchanged page;
- content hashes, provider attempts, vendor units and estimated cost remain observable;
- evidence retention/reuse does not imply automatic publication.

## Cadence
Full crawls match volatility: Course monthly, Scholarship weekly, Provider logos quarterly. Lightweight hash/health checks run more often. Deadline/intake/fee windows can accelerate. Daily blanket recrawls are prohibited unless a source-specific accepted reason is recorded.

## Parse.bot onboarding
The registry slot is intentionally disabled and has no fabricated base URL/secret. When trial details arrive: configure server-side secret, validate adapter response contract, benchmark cost/latency/quality, run bounded UAT, then enable only approved profile routes.
