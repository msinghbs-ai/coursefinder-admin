# CourseFinder Admin Navigation / Information Architecture v1.3

**Status:** M2.1 IMPLEMENTED / DEPLOYED BROWSER UAT PENDING  
**Supersedes:** v1.2 for M2+ navigation  
**Related:** `CF-CHG-20260823-030`, `CF-CHG-20260823-029`

## Design objective

The Admin must support management and operational staff without exposing every backend concept as a main-menu item.

The default navigation should answer:

1. What data do we have?
2. What enrichment is running / scheduled?
3. What failed or needs interpretation/review?
4. What Evidence supports the result?

Configuration and diagnostics remain available through drill-down rather than occupying the primary sidebar.

## Primary navigation

```text
Overview
  Dashboard

Catalogue
  Providers
  Courses
  Campuses
  Scholarships

Data Enrichment
  Layer 2 Operations
  Evidence

Insights
  Outcomes (QILT)
  Student Flow (PRISMS)

Quality & Review
  Completeness
  Review Queue

Governance & Platform
  Attributes
  Settings / Access
```

## Why QILT and PRISMS are not under Layer 2

QILT and PRISMS are already governed Layer 1 contextual datasets. They can appear with Course decision context but are not targets for paid scraper acquisition.

They remain under **Insights**.

## Layer 2 Operations

The management landing page contains only:

- Enrichment sources and schedule;
- provider readiness/cost-routing summary;
- recent run outcomes;
- Evidence summary;
- exceptions passed to Layer 3.

Advanced capabilities are accessed from buttons/drawers:

- Source Registry / profile version detail;
- Source configuration;
- Acquisition Provider credentials/capabilities;
- bounded provider/completeness trials;
- Pipeline/Jobs diagnostics;
- Evidence detail.

These capabilities remain operationally available but are intentionally removed as separate primary-menu destinations.

## Management wireframe

```text
┌────────────────────────────────────────────────────────────────────┐
│ Layer 2 Operations                          Refresh              X │
│ Courses and Scholarships only                                      │
├────────────────────────────────────────────────────────────────────┤
│ Sources     Providers ready     Evidence     Needs review           │
│    3             4/4              123            7                  │
├────────────────────────────────────────────────────────────────────┤
│ ENRICHMENT PLAN                                      [Run trial]    │
│ AU  Courses · RMIT       Weekly · 10 · Direct→best value [Schedule]│
│ AU  Courses · UQ         Weekly · 10 · Direct→best value [Schedule]│
│ AU  Scholarships        Daily  · 10 · Direct→best value [Schedule]│
├────────────────────────────────┬───────────────────────────────────┤
│ PROVIDER HEALTH                │ EVIDENCE                          │
│ Direct HTTP       Ready        │ 123 artifacts                     │
│ Firecrawl         Ready        │ 7 need review                     │
│ Scrape.do         Ready        │ [Open Evidence]                   │
│ ZenRows           Ready        │                                   │
│ [Configure]                    │                                   │
├────────────────────────────────┴───────────────────────────────────┤
│ RECENT RUNS                                                        │
│ Status   Processed   L2 resolved   To L3   Cost   Started           │
│ PASS     10/10       9             1       ...    ...               │
│ [Jobs / diagnostics]                                              │
└────────────────────────────────────────────────────────────────────┘
```

## Progressive disclosure

### Level 1 — Management

Show state, schedule, outcome, cost and exception count.

### Level 2 — Operations

Show run, Course/Scholarship item, provider attempts and Evidence produced.

### Level 3 — Diagnostics

Show response headers, runtime region/deployment, content hash, storage path, provider trace IDs, retries and raw logs.

This prevents the management interface from becoming a raw observability console.

## Layer 3 / Layer 4 navigation consequence

Layer 2 Operations shows `L3 required` only as a run outcome/filter.

Layer 3 consumes the unresolved Evidence package. It does not appear as another scraper-control page.

Only Layer 3 fall-out requiring human resolution appears in **Quality & Review → Review Queue (Layer 4)**.

No direct Layer 2 → Layer 4 operator action is provided.
