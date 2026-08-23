# CourseFinder Admin Navigation & Information Architecture v1.0

**Status:** CURRENT — M2.1 navigation replan  
**Date:** 23 August 2026  
**Change Control:** `CF-CHG-20260823-030`

## Principle

The CourseFinder Admin menu should communicate the operational data journey. Workspaces must not be hidden merely because they were delivered by separate technical workstreams.

The operator should be able to read the main navigation approximately as:

`Acquire → Evidence → Enrich/Interpret → Review → Govern → Publish/Consume`

Catalogue remains a separate PIM decision workspace because it represents canonical entities rather than acquisition machinery.

## Primary sidebar

| Group | Menu item | Purpose | Minimum role/rank |
|---|---|---|---:|
| Overview | Dashboard | Operational command view | 1 |
| Catalogue | Providers | Canonical Provider catalogue | 1 |
| Catalogue | Courses | Canonical Course catalogue | 1 |
| Catalogue | Campuses | Canonical Campus catalogue | 1 |
| Catalogue | Scholarships | Canonical Scholarship catalogue | 1 |
| Data Acquisition | Pipeline Control | Layer 1 → Layer 4 execution/health journey | 4 |
| Data Acquisition | Source Registry | Governed source inventory | 4 |
| Data Acquisition | Layer 2 Source Config | Versioned source/discovery/parser/evidence configuration | 4 read / 5 version / 6 state |
| Data Acquisition | Acquisition Providers | Direct HTTP/scraper/browser/API providers, Vault credentials and routing | 4 read/run / 5 route / 6 provider/credential |
| Data Acquisition | Jobs | Acquisition/enrichment execution history | 4 |
| Data Acquisition | Evidence | Raw/HTML/JSON/document/screenshot provenance | 3 |
| Enrichment & Insights | Outcomes (QILT) | Structured outcome enrichment | 1 |
| Enrichment & Insights | Student Flow (PRISMS) | Structured student-flow enrichment | 1 |
| Quality & Review | Completeness | Domain readiness and exceptions | 1 |
| Quality & Review | Review Queue | Human ambiguity/conflict resolution | 3 |
| Governance & Platform | Attributes | PIM configuration | 5 |
| Governance & Platform | Settings | Platform/regulatory privileged settings | 6 |

## Data Acquisition mental model

### Pipeline Control

The top-level operational view. Shows where the system is across Layer 1 regulatory ingestion, Layer 2 deterministic acquisition/enrichment, Layer 3 AI suggestions and Layer 4 human resolution.

### Source Registry

Defines the source itself: authority, country/domain, source type, freshness and operational source state.

### Layer 2 Source Config

Defines how a particular first-party or structured source is discovered and interpreted. It does not hold acquisition-vendor secrets.

### Acquisition Providers

Defines reusable technical fetch mechanisms such as Direct HTTP, Scrape.do, ScraperAPI, Firecrawl, ZenRows and future adapters. Credentials remain server-side in Vault.

### Jobs

Shows actual execution. A configuration is not evidence that a job has run.

### Evidence

Shows what was actually acquired by each Job/provider attempt: JSON, HTML, document or screenshot/image plus provenance/hash/version. Evidence belongs in Data Acquisition because it is produced by acquisition and consumed by extraction/review across all layers.

## Downstream relationship

`Data Acquisition → Evidence → deterministic extraction / Layer 3 inference → Quality & Review → canonical mapping → Search Admission → Publication`

Completeness and Review are intentionally downstream. Evidence must not be hidden under completeness because evidence exists even for facts that are complete, rejected, superseded or not yet mapped.

## UI rules

- Do not reintroduce floating primary launch buttons for Pipeline or Layer 2 once the sidebar integration is accepted.
- Preserve role-based menu visibility and server-side authorisation.
- A menu item may open a full operational console, but it must be discoverable from the main navigation.
- Keep Source Registry distinct from Layer 2 Source Config: one defines authority/source inventory; the other defines deterministic acquisition semantics.
- Keep Acquisition Providers distinct from Source Config: provider credentials and transport capability must remain reusable across many university sources.
- Jobs and Evidence should be cross-clickable to Provider Attempt, Source Profile and canonical affected entity where applicable.
- Future Layer 3 and publication workspaces should be placed according to the same lifecycle rather than implementation repository ownership.

## Future target

The current M2.1 integration reuses the existing governed consoles. A later Admin-shell consolidation may render Pipeline Control, Layer 2 Source Config and Acquisition Providers directly as native route pages rather than full-screen overlays. That is a presentation refactor only; it must preserve the same RPC/security/evidence contracts and should not block the M2 acquisition platform work.