# CourseFinder Admin Navigation & Information Architecture v1.2

**Status:** CURRENT — M2.1 acquisition-trial navigation baseline  
**Date:** 24 August 2026  
**Supersedes:** v1.1  
**Change Control:** `CF-CHG-20260823-030`

## Principle

The primary Admin navigation communicates the CourseFinder data lifecycle rather than repository/table ownership.

The operating journey is:

`Source → Acquisition Configuration → Provider Trial/Execution → Evidence → Extraction/Interpretation → Review → Canonical/Completeness → Search Projection/Publication`

There are exactly four enrichment authority layers:

`Layer 1 Authoritative/Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`.

Layer 4 is terminal. Search/Publication are downstream product states, not Layer 5+, and CourseFinder is not a university-admissions workflow.

## Primary sidebar

| Group | Menu item | Purpose | Minimum role/rank |
|---|---|---|---:|
| Overview | Dashboard | Operational command view | 1 |
| Catalogue | Providers | Canonical Provider catalogue | 1 |
| Catalogue | Courses | Canonical Course catalogue and decision context | 1 |
| Catalogue | Campuses | Campus geography and Provider relationship | 1 |
| Catalogue | Scholarships | Scholarship catalogue/eligibility context | 1 |
| Data Acquisition | Pipeline Control | Layer 1 → Layer 4 execution/health journey | 4 |
| Data Acquisition | Source Registry | Governed authority/source inventory | 4 |
| Data Acquisition | Layer 2 Source Config | Versioned source/discovery/parser/Evidence configuration | 4 read / 5 version / 6 state |
| Data Acquisition | Acquisition Providers | Direct HTTP/scraper/browser/API providers, Vault credentials and routing | 4 read/run / 5 route / 6 provider/credential |
| Data Acquisition | Acquisition Trials | Country/Provider/Course learning cohorts, forced-provider benchmark execution and evidence-backed outcome/cost comparison | 4 |
| Data Acquisition | Jobs | Acquisition/extraction execution history | 4 |
| Data Acquisition | Evidence | Native and normalised provenance across Layers 1–4 | 3 |
| Enrichment & Insights | Outcomes (QILT) | Provider/study-area outcome context | 1 |
| Enrichment & Insights | Student Flow (PRISMS) | Provider/state/sector/cohort international-student context | 1 |
| Quality & Review | Completeness | Course factual and decision-context completeness/readiness | 1 |
| Quality & Review | Review Queue | Layer 4 terminal human resolution workload | 3 |
| Governance & Platform | Attributes | PIM configuration | 5 |
| Governance & Platform | Settings | Privileged platform/regulatory settings | 6 |

## Data Acquisition mental model

### Pipeline Control
Shows Layer 1 authoritative ingestion, Layer 2 deterministic acquisition/extraction, Layer 3 AI-assisted Evidence interpretation and Layer 4 human resolution. It must not imply Layer 5.

### Source Registry
Defines the source itself: authority, country/domain, source type, freshness and operational state.

### Layer 2 Source Config
Defines how an approved source is discovered/interpreted and which domains it may contribute to. It does not contain acquisition-vendor secrets.

### Acquisition Providers
Defines reusable technical fetch mechanisms such as Direct HTTP, Scrape.do, ScraperAPI, Firecrawl, ZenRows and future adapters. Credentials remain write-only from Admin and server-side in Vault.

### Acquisition Trials
Provides the bounded learning/benchmark workspace used to answer the operational question: **which provider and extraction path gives the most accurate evidence-backed Course/data completion at acceptable cost?**

The workspace is organised as:

`Country → university/Provider → representative Course cohort → selected acquisition provider → Provider Attempt → Native Evidence → normalised Evidence → deterministic extractor → Layer 3 only if required → Layer 4 only if automation is exhausted`.

Rules:

- ten Courses is a starting learning cohort, not a production limit;
- initial cohorts should contain known-coverage controls and genuine enrichment gaps;
- provider benchmark mode may force one explicitly selected provider only when that provider is already an enabled route for the governed Source Profile;
- forced-provider mode must not bypass URL/source boundaries or Vault controls;
- results must record the actual acquisition-provider identity, Provider Attempt and Evidence;
- compare resolution/correctness/Evidence quality/latency/cost and Layer 3/4 escalation, not HTTP success alone;
- missing current Course pages may indicate retired/superseded identity and must not be completed by attaching a merely similar current Course;
- trial candidates/results are not canonical writes.

### Jobs
Shows actual execution. Configuration or a trial definition does not imply successful acquisition or extraction.

### Evidence
Shows what was actually acquired/derived: provider-native JSON/HTML/Markdown/documents/screenshots plus normalised extraction representations, hashes, versions, Provider Attempts and lineage.

## Enrichment & Insights

QILT and PRISMS are decision context that may also be projected alongside Courses for counsellor/student comparison while preserving source grain.

- QILT Provider-level metrics remain Provider-level.
- QILT study-area/field outcomes remain study-area/field context.
- PRISMS Provider/state/sector/cohort trends retain their real reporting grain/time period.

## Quality & Review

### Completeness
Must distinguish:

- **Course factual completeness**; and
- **decision-context completeness**.

Country-specific completeness profiles drive what Course facts are expected for international students. Missing, stale, source-null, suppressed, ambiguous and not-applicable states must remain distinct.

### Review Queue
Represents Layer 4 and is terminal for enrichment authority. It receives unresolved, ambiguous, conflicting or consequential cases only after the Layer 2/3 path is exhausted or human resolution is explicitly required.

## UI rules

- Do not reintroduce floating primary launch buttons once sidebar integration is accepted.
- Preserve role-based menu visibility and server-side authorisation.
- Source Registry, Source Config, Acquisition Providers and Acquisition Trials are distinct concepts even though they are adjacent.
- Jobs and Evidence should cross-link to Source Profile, Provider Attempt, Trial and affected canonical entity where applicable.
- Course pages/comparisons should surface relevant QILT/PRISMS/Scholarship context with scope labels.
- Do not display Provider/state/cohort metrics as Course-grain facts.
- Avoid **Search Admission** wording. Use Search Eligibility, Search Projection or Search Visibility.
- There is no university admissions/application/offer-letter/visa workflow in this Admin IA.

## Future route target

When full native routing replaces overlay consoles, preferred route families are:

- `/data-acquisition/pipeline`
- `/data-acquisition/sources`
- `/data-acquisition/layer2-profiles`
- `/data-acquisition/providers`
- `/data-acquisition/trials`
- `/data-acquisition/jobs`
- `/data-acquisition/evidence`
- `/quality/completeness`
- `/quality/review`

That is a presentation refactor and must preserve existing RPC/Vault/Evidence/security contracts.
