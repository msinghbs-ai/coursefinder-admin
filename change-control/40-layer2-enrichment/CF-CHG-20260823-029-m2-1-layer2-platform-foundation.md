# CF-CHG-20260823-029 — M2.1 Layer 2 Enrichment Platform Foundation

**Status:** BLOCKED — RETAINED-EVIDENCE EXTRACTION + DEPLOYED BROWSER ACCEPTANCE OUTSTANDING  
**Category:** 40-layer2-enrichment  
**Initiated:** 23 August 2026 20:21 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** M2.1 Layer 2 Platform workstream  
**Change class:** schema / enrichment / UI / security / governance / documentation / operations

## Product and authority boundary

CourseFinder is an international-student Course and related-data aggregation, discovery and comparison platform. It is not an application/admissions/offer-letter/visa workflow.

Final enrichment authority model:

`Layer 1 Authoritative/Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 is terminal. There is no Layer 5. Completeness/readiness, Search Projection/Visibility and Publication are downstream states.

## Layer 2 scope correction

Layer 2 acquisition is now explicitly limited to **Course enrichment** and **Scholarship enrichment**.

QILT and PRISMS remain Layer 1 authoritative/contextual datasets and are available downstream with Courses at their real Provider/study-area/state/cohort grain. They are not Layer 2 scraper targets.

Live correction applied on 24 August 2026:

- `au-qilt-ess-structured-file` disabled/paused for Layer 2 execution;
- `au-prisms-xlsx` disabled/paused for Layer 2 execution;
- all Layer 2 provider routes for those profiles disabled;
- backend provider routing now rejects non-Course/non-Scholarship Layer 2 profile use;
- Admin Layer 2 profile reads expose only Course and Scholarship enrichment targets.

Scrape.do, Firecrawl, ZenRows and Direct HTTP are **Acquisition Providers**, not data sources.

## Required operating sequence

`Enrichment Source → Provider Route → Acquisition Job → Provider Attempt → Native Evidence → Normalised Extraction Evidence → Deterministic Candidate → Layer 3 if required → Layer 4 if still unresolved`

No acquisition/extraction worker directly authorises canonical mutation, Search visibility or Publication.

## Implemented platform

### Source Profiles

- `pipeline.layer2_source_profiles`;
- immutable `pipeline.layer2_source_profile_versions`;
- exact profile-version lineage on Jobs/Evidence;
- enabled/paused/validity execution gate;
- source-bound URL allowlist;
- Course discovery strategy separated from Course detail acquisition.

RMIT and UQ current Source Profile v3 configurations include first-party search/discovery strategies. UQ's search host is explicitly allowlisted for discovery; detail extraction remains bound to first-party study pages.

### Acquisition Providers

Provider credentials are write-only from Admin and stored in Supabase Vault. Browser reads expose only credential readiness and non-secret provider configuration.

Current tested acquisition providers:

| Provider | Credential | Current role |
|---|---|---|
| Direct HTTP | none | zero-external-fee first route where sufficient |
| Scrape.do | configured | rendered HTML fallback/benchmark candidate |
| Firecrawl | configured | rich HTML/Markdown/screenshot escalation candidate |
| ZenRows | configured | rendered/proxy fallback/benchmark candidate |
| ScraperAPI | not configured | retained catalogue option, not part of current live benchmark |
| Custom gateway | disabled | future governed adapter |

Provider billing configuration is non-secret metadata. Monetary cost remains unknown unless actual account-plan economics are configured. Vendor units/credits are recorded separately from money.

### Runtime / Evidence

JWT-protected runtime includes:

- `layer2-config-control`;
- `layer2-provider-control`;
- `layer2-acquire`;
- `layer2-extract`;
- `layer2-trial-control`;
- `layer2-course-discover`;
- `layer2-course-fact-extract`;
- `layer2-scholarship-extract`.

`layer2-acquire` supports governed forced-provider trial mode but only for providers already routed to the selected enrichment source. Acquisition URLs remain source-bound.

## Country completeness trials

Live AU learning cohorts:

- RMIT University trial `26086e95-a387-44a7-9a50-d566e29076bb` — 10 Courses, 2 controls + 8 gap-learning;
- The University of Queensland trial `3148ca84-f4f9-440f-9bb3-af2e54d383fa` — 10 Courses, 2 controls + 8 gap-learning.

The country completeness model distinguishes Course factual completeness from contextual completeness. QILT/PRISMS context never becomes fake Course-grain fact data.

## Provider benchmark telemetry

`pipeline.layer2_provider_benchmark_observations` was added on 24 August 2026 to retain provider-selection telemetry separately from formal Evidence.

The table stores benchmark reference, target/provider identity, request ID, HTTP result, response size, provider units where available, SHA-256 and high-level Course fact markers. It is RLS-enabled and browser roles have no direct access.

Telemetry is explicitly marked `probe_hash_only` unless produced through the formal retained-Evidence path. Probe telemetry must never be presented as Native Evidence.

Technical evidence: `docs/uat/coursefinder-m2-1-provider-benchmark-2026-08-24.md`.

### First 5×2 Course benchmark

Ten current first-party Course pages were tested: five RMIT and five UQ. Each was attempted through Direct HTTP, Scrape.do, Firecrawl and ZenRows: 40 bounded acquisition attempts.

Initial result:

| University | Direct HTTP | Firecrawl | Scrape.do | ZenRows |
|---|---:|---:|---:|---:|
| RMIT | 5/5 | 5/5 | 3/5 | 4/5 |
| UQ | 5/5 | 5/5 | 1/5 | 1/5 |

Every successful response contained the exact CRICOS target plus fee, English and intake/start markers.

Scrape.do and ZenRows failures were predominantly HTTP 429 during a deliberately parallel diagnostic batch. The batch did not respect configured provider concurrency, so these are not accepted as content failures. Sequential rechecks of representative failed UQ targets returned HTTP 200 for both Scrape.do and ZenRows.

Accepted interpretation at this stage:

- Direct HTTP remains the preferred first route for ordinary RMIT/UQ Course pages;
- Firecrawl is the strongest currently proved rich-Evidence escalation route because all tested targets returned HTML + Markdown + screenshot;
- Scrape.do and ZenRows remain viable but require rate/concurrency-aware orchestration;
- no final paid-provider winner is accepted before deterministic extraction quality and actual account-plan monetary economics are measured.

Observed provider units in this benchmark:

- Firecrawl: one base credit on each successful test response;
- Scrape.do: five credits on each successful rendered test response;
- ZenRows: units are not currently exposed by the probe contract;
- Direct HTTP: zero external vendor fee.

## Scholarship acquisition benchmark

The governed Study Australia Scholarship enrichment target was probed through Direct HTTP, Scrape.do, Firecrawl and ZenRows.

All four returned HTTP 200 and content containing Scholarship, eligibility, international-student and value/award markers. Firecrawl also returned Markdown + HTML + screenshot; Scrape.do consumed five credits.

This proves acquisition only. `layer2-scholarship-extract` still requires retained and normalised Layer 2 Evidence runtime UAT.

## Course extraction identity guard

`layer2-course-fact-extract` consumes normalised Layer 2 Evidence and selected canonical identity. It can attempt official URL, Provider-current international tuition, intake, English-test and description candidates.

Missing enrichment must not cause a similar current Course to be attached to an older/different regulatory identity. Identity mismatch/supersession remains unresolved and proceeds through Layer 3/Layer 4 rules rather than silent mutation.

## Layer 3 / Layer 4 contract

Layer 3 consumes Layer 2 Evidence/candidates and does not scrape independently or receive scraper credentials. If better Evidence is required, Layer 3 requests another governed Layer 2 acquisition capability.

Only genuinely unresolved/conflicting/consequential cases reach Layer 4 with the Evidence/attempt/candidate package. Layer 4 is terminal.

## Admin information architecture

Data Acquisition includes:

- Pipeline Control;
- Source Registry;
- Layer 2 Source Config;
- Acquisition Providers;
- Acquisition Trials;
- Jobs;
- Evidence.

Layer 2 Platform visible version is now **v1.3**. Manual selectors use **Enrichment source** rather than the internal term `Source profile`, with human context such as `Australia · Courses · RMIT University`.

QILT/PRISMS remain Enrichment & Insights because they are Layer 1 contextual datasets. Completeness and Layer 4 Review remain Quality & Review.

## Security / ACL UAT

PASS:

- Layer 2 trial/benchmark tables use RLS;
- anon/authenticated have no direct benchmark-table access;
- provider credentials remain Vault-only/write-only;
- acquisition targets remain source-bound;
- non-Course/non-Scholarship profiles cannot be routed through Layer 2 provider acquisition;
- extractors create candidates and do not authorise canonical/Search/Publication mutation;
- all new Layer 2 control/extraction Edge functions remain JWT protected.

## M1 regression boundary

M2.1 remains additive and must not change the frozen M1 publication baseline. Trial/probe/candidate state is outside canonical/Search authority.

## Current blockers / next execution

M2.1 remains **BLOCKED**, not PASS.

Outstanding acceptance evidence:

1. rate/concurrency-aware automated provider benchmark orchestration rather than uncontrolled parallel paid-provider calls;
2. representative Native Evidence-retained Course attempts through `layer2-acquire`;
3. `layer2-extract` normalisation runtime UAT on those retained attempts;
4. deterministic Course extraction correctness/completeness comparison across representative provider outputs;
5. retained-Evidence `layer2-scholarship-extract` UAT;
6. actual account-plan cost configuration if monetary provider ranking is required;
7. SHA-bound deployed desktop/mobile browser UAT for Layer 2 Platform v1.3.

Provider credentials are **not** a current blocker: Scrape.do, Firecrawl and ZenRows are configured and were exercised.

## Key implementation references

Live migrations/additions include:

- Layer 2 Source Profile/provider/Vault/routing foundation migrations;
- country completeness/provider trial foundation and service ACL;
- Course decision-context projection;
- provider trial metric and effective-cost contracts;
- Course discovery candidate contract;
- Layer 2 Course/Scholarship scope correction;
- `m2_1_provider_benchmark_observations`.

Pilot mirrors/runtime include:

- `supabase/functions/layer2-acquire/index.ts`;
- `supabase/functions/layer2-extract/index.ts`;
- `supabase/functions/layer2-trial-control/index.ts`;
- `supabase/functions/layer2-course-discover/index.ts`;
- `supabase/functions/layer2-course-fact-extract/index.ts`;
- `supabase/functions/layer2-scholarship-extract/index.ts`;
- `supabase/migrations/20260824101000_m2_1_layer2_course_scholarship_scope_correction.sql`;
- `supabase/migrations/20260824102300_m2_1_provider_benchmark_observations.sql`;
- `src/layer2-enrichment-scope-entry.js`;
- deployed-UAT updates enforcing the enrichment-only selector boundary.

## Decision history

| Time | State | Decision |
|---|---|---|
| 23 Aug 20:21 | PROPOSED | M2.1 initiated against frozen M1 baseline. |
| 23 Aug ~21:00 | SCOPE CORRECTION | Multi-provider acquisition/Vault/routing/Evidence made core. |
| 23 Aug ~22:15 | SCOPE REBASELINE | Country completeness, Scholarships, contextual QILT/PRISMS and terminal Layer 4 added. |
| 23 Aug ~22:35–22:55 | PARTIAL PASS | AU RMIT/UQ cohorts and Evidence-driven extraction workers deployed. |
| 24 Aug ~10:10 | SCOPE CORRECTION | QILT/PRISMS removed from Layer 2 acquisition; Course/Scholarship enrichment only. |
| 24 Aug ~10:18–10:25 | PARTIAL PASS | Layer 2 UI v1.3 and first 40-attempt Course + Scholarship provider benchmark completed. |

## Closure

**Final status:** **BLOCKED — retained-Evidence extraction and deployed browser acceptance outstanding**  
**Closed at:** N/A
