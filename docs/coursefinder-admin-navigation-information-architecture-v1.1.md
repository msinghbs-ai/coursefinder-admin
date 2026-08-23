# CourseFinder Admin Navigation & Information Architecture v1.1

**Status:** CURRENT — M2.1 navigation baseline  
**Date:** 23 August 2026  
**Supersedes:** v1.0  
**Change Control:** `CF-CHG-20260823-030`

## Principle

The primary Admin navigation communicates the CourseFinder data lifecycle rather than repository/table ownership.

The operating journey is:

`Source → Acquisition → Evidence → Extraction/Interpretation → Review → Canonical/Completeness → Search Projection/Publication`

There are exactly four enrichment authority layers. Search/Publication are downstream product states, not Layer 5+ and not university admissions.

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
| Data Acquisition | Acquisition Providers | Direct HTTP/scraper/browser/API providers, Vault credentials, routing and provider trials | 4 read/run / 5 route / 6 provider/credential |
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
Defines reusable technical fetch mechanisms such as Direct HTTP, Scrape.do, ScraperAPI, Firecrawl, ZenRows and future adapters. It also exposes provider routing/trial state, credential status, capabilities and bounded acquisition controls.

### Jobs
Shows actual execution. Configuration does not imply execution or successful extraction.

### Evidence
Shows what was actually acquired/derived: provider-native JSON/HTML/Markdown/documents/screenshots plus normalised extraction representations, hashes, versions, provider attempts and lineage.

## Enrichment & Insights

QILT and PRISMS are not isolated reporting screens only. They provide decision context that may also be projected alongside Courses for counsellor/student comparison while preserving source grain.

- QILT Provider-level metrics remain Provider-level.
- QILT study-area/field outcomes remain study-area/field context.
- PRISMS Provider/state/sector/cohort trends retain their real reporting grain/time period.

## Quality & Review

### Completeness
Must distinguish:

- Course factual completeness;
- decision-context completeness.

Country-specific completeness profiles drive what Course facts are expected for international students.

### Review Queue
Represents Layer 4 and is terminal for enrichment authority. It receives only unresolved, ambiguous or conflicting cases after Layer 2/3 automation is exhausted or a consequential decision requires human review.

## UI rules

- Do not reintroduce floating primary launch buttons once sidebar integration is accepted.
- Preserve role-based menu visibility and server-side authorisation.
- Source Registry, Source Config and Acquisition Providers remain separate concepts even though they are adjacent.
- Jobs and Evidence should cross-link to Source Profile, Provider Attempt and affected canonical entity where applicable.
- Course pages/comparisons should surface relevant QILT/PRISMS/Scholarship context with scope labels.
- Do not display Provider/state/cohort metrics as Course-grain facts.
- Avoid **Search Admission** wording in new UI. Use Search Eligibility, Projection or Visibility.
- There is no admissions/application workflow in this Admin IA.

## Future route target

When full native routing replaces overlay consoles, preferred route families are:

- `/data-acquisition/pipeline`
- `/data-acquisition/sources`
- `/data-acquisition/layer2-profiles`
- `/data-acquisition/providers`
- `/data-acquisition/jobs`
- `/data-acquisition/evidence`
- `/quality/completeness`
- `/quality/review`

That is a presentation refactor and must preserve existing RPC/Vault/Evidence/security contracts.
