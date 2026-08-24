# CourseFinder M2.1 Provider Benchmark — 24 August 2026

**Change Control:** `CF-CHG-20260823-029`  
**Status:** PARTIAL PASS — acquisition/provider telemetry proven; formal retained-Evidence extraction trial still outstanding  
**Scope:** AU Layer 2 Course and Scholarship enrichment only

## Boundary

QILT and PRISMS are Layer 1 authoritative/contextual datasets and are not Layer 2 acquisition targets. Layer 2 acquisition is limited to Course enrichment and Scholarship enrichment. Scrape.do, Firecrawl and ZenRows are acquisition providers, not sources.

## UI correction

Layer 2 Platform visible version is now **v1.3**. The manual selector is presented as **Enrichment source**, with human context such as:

- `Australia · Courses · RMIT University`;
- `Australia · Courses · The University of Queensland`;
- `Australia · Scholarships · Study Australia`.

Deployed UAT was updated to assert that QILT/PRISMS do not appear in the Layer 2 enrichment-source selector and that Direct HTTP, Scrape.do, Firecrawl and ZenRows are available acquisition choices.

## Course acquisition benchmark

Benchmark ref: `M2.1-AU-5x2-PROVIDER-BENCH-2026-08-24`.

Targets: five current RMIT Course pages and five current UQ Course pages. Each target was attempted through Direct HTTP, Scrape.do, Firecrawl and ZenRows: **40 bounded acquisition attempts**.

Provider-selection telemetry is persisted in `pipeline.layer2_provider_benchmark_observations`. These rows retain request ID, target, provider, HTTP outcome, response size, vendor units where available, response SHA-256 and high-level identity/fee/English/intake markers. Browser roles have no direct access. The observations are explicitly marked `probe_hash_only`; they are provider-selection telemetry and are not a substitute for Native Evidence created by `layer2-acquire`.

### Initial parallel-batch result

| University | Provider | Success | Evidence shape | Vendor units observed | Finding |
|---|---|---:|---|---:|---|
| RMIT | Direct HTTP | 5/5 | HTML | external vendor fee 0 | complete baseline |
| RMIT | Firecrawl | 5/5 | HTML + Markdown + screenshot | 5 total base credits | complete, richer Evidence shape |
| RMIT | Scrape.do | 3/5 | rendered HTML on successes | 15 credits on successes | two HTTP 429 throttles |
| RMIT | ZenRows | 4/5 | rendered response | vendor units not exposed by current probe | one HTTP 429 throttle |
| UQ | Direct HTTP | 5/5 | HTML | external vendor fee 0 | complete baseline |
| UQ | Firecrawl | 5/5 | HTML + Markdown + screenshot | 5 total base credits | complete, richer Evidence shape |
| UQ | Scrape.do | 1/5 | rendered HTML on success | 5 credits on success | burst caused HTTP 429/one no-response result |
| UQ | ZenRows | 1/5 | rendered response on success | vendor units not exposed by current probe | burst caused HTTP 429 |

Every successful response contained the exact target CRICOS identity and fee, English-language and intake/start markers.

The 429 results are **not accepted as provider content failures**. The benchmark intentionally exposed an orchestration defect: the diagnostic batch fired requests concurrently without enforcing the provider registry's configured concurrency. Scrape.do is configured at concurrency 1; ZenRows at concurrency 2. Future benchmark and production orchestration must respect provider-specific concurrency/rate-limit settings.

### Sequential recheck

A throttled UQ Scrape.do target was rerun individually and returned HTTP 200 with usable HTML, consuming 5 credits. A throttled UQ ZenRows target was rerun individually and returned HTTP 200 with usable content.

Therefore the current interpretation is:

- Direct HTTP is the preferred first route for ordinary RMIT/UQ Course pages because it provided complete target markers with no external acquisition fee;
- Firecrawl is currently the strongest proved escalation route when richer Evidence (Markdown and screenshot) is useful;
- Scrape.do and ZenRows remain viable but must be tested/routed with rate- and concurrency-aware orchestration;
- no final paid-provider winner is accepted until deterministic extraction correctness/completeness and actual account-plan monetary economics are measured.

## Scholarship acquisition benchmark

Governed target: `https://search.studyaustralia.gov.au/scholarships` under `au-study-australia-scholarship-search`.

| Provider | HTTP | Response | Vendor units | Scholarship/eligibility/international/value markers |
|---|---:|---|---:|---|
| Direct HTTP | 200 | HTML | 0 external vendor fee | present |
| Firecrawl | 200 | JSON containing HTML + Markdown + screenshot | 1 base credit | present |
| Scrape.do | 200 | rendered HTML | 5 credits | present |
| ZenRows | 200 | rendered response | not exposed by current probe | present |

This proves bounded acquisition capability only. `layer2-scholarship-extract` must still be exercised against retained and normalised Layer 2 Evidence before Scholarship extraction is accepted.

## Evidence and cost semantics

Provider-native Evidence must be retained by the normal `layer2-acquire` path. Hash-only benchmark telemetry is deliberately not labelled Evidence.

Cost is tracked as two separate concepts:

1. provider-native units/credits consumed;
2. effective monetary cost calculated only when actual account-plan economics are configured.

Unknown monetary pricing remains unknown rather than being treated as zero.

## Current acceptance state

**PASS:**

- Layer 2 scope corrected to Course/Scholarship enrichment only;
- Scrape.do, Firecrawl and ZenRows credentials confirmed configured in Vault;
- 40-attempt Course acquisition benchmark completed and persisted;
- rate-limit/concurrency behaviour identified and sequentially rechecked;
- Study Australia Scholarship acquisition succeeds through all four tested methods;
- QILT/PRISMS remain downstream Layer 1 decision context, not Layer 2 scraper targets.

**OUTSTANDING:**

- provider-specific rate/concurrency enforcement in automated benchmark orchestration;
- Native Evidence-retained Course attempts through `layer2-acquire` for representative trial rows;
- normalisation through `layer2-extract`;
- deterministic Course fact extraction correctness/completeness comparison;
- retained-Evidence Scholarship extraction UAT;
- actual plan-cost configuration where monetary provider ranking is required;
- deployed SHA-bound desktop/mobile UAT for Layer 2 Platform v1.3.

M2.1 remains BLOCKED until those acceptance items are resolved or explicitly deferred.
