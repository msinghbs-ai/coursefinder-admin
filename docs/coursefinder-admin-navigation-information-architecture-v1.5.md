# CourseFinder Admin Navigation & Information Architecture v1.5

**Status:** CURRENT — M2.5 STATISTICS / COMPARISON OPERATING MODEL  
**Date:** 2 September 2026  
**Supersedes:** v1.4  
**Related Change Controls:** `CF-CHG-20260826-040`, `CF-CHG-20260901-061`, `CF-CHG-20260902-063`, `CF-CHG-20260902-064`

## Principle

The sidebar describes operator journeys, not source-table history.

Authority remains:

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`.

Statistics/rankings are contextual decision data. They do not become a new authority layer.

## Primary navigation order

| Order | Group | Menu item | Purpose |
|---:|---|---|---|
| 1 | Overview | Dashboard | cross-platform health, blockers, freshness and next actions |
| 2 | Catalogue | Providers / Courses / Campuses / Scholarships | canonical decision workspaces |
| 3 | Statistics & Insights | Statistics & Rankings | unified coverage, years, observations, mappings, Evidence and source verification for QILT/PRISMS/QS/THE |
| 3 | Statistics & Insights | Compare | select Providers/Courses, datasets and aligned year/period for comparison |
| 4 | Data Operations | Layer 1 — Authority | authoritative/regulatory and publisher-authoritative ingestion |
| 4 | Data Operations | Layer 2 — Enrichment | deterministic first-party acquisition/extraction |
| 4 | Data Operations | Layer 3 — AI Interpretation | governed Evidence interpretation |
| 4 | Data Operations | Layer 4 — Human Resolution | terminal human resolution |
| 4 | Data Operations | Evidence | cross-layer provenance |
| 4 | Data Operations | Jobs | run history and operational state |
| 5 | Quality & Review | Completeness / reconciliation | coverage/readiness and unresolved decision work |
| 6 | Administration | Administration | Sources & Imports, acquisition, scheduling, onboarding, PIM, users/roles, platform |
| 7 | Help | Guides & Runbooks | maintained operator guidance |

## Statistics & Rankings rule

QILT and PRISMS remain first-class datasets but are no longer required to appear as separate top-level concepts. Their detailed dataset views are reached from Statistics & Rankings.

The workspace also owns QS/THE verification once ingested and provides:
- dataset/year coverage;
- mapped/unmapped state;
- suppression/unavailable state;
- Evidence/source links;
- manual publisher-file import entry for authorised historical artifacts.

## Compare rule

Compare is primary navigation, not a hidden route.

The comparison journey is:
1. choose Provider or Course mode;
2. select up to six entities;
3. choose datasets;
4. choose latest common or explicit period/edition;
5. render aligned comparison.

QS and THE are independent ranking systems. QILT/PRISMS retain true source grain. Course views may inherit Provider-level context only with explicit labelling.

## Administration sub-navigation

Administration consolidates configuration into:
- Overview;
- Sources & Imports;
- Acquisition;
- Scheduling;
- Onboarding;
- PIM configuration;
- Users & Roles;
- Platform.

Manual ranking publisher upload belongs under Sources & Imports and is also deep-linked from Statistics & Rankings.

## Detail blade rule

Provider/Course blades contain concise contextual summaries and links, not full statistical workspaces.

Each applicable blade should expose:
- View statistics;
- Add to Compare;
- latest available contextual indicators;
- explicit Provider-context labels where inherited.

## Mobile / responsive

The same logical groups are preserved in the mobile drawer. Compare tray and statistics filters must not create document-level horizontal overflow.

## Security / semantic boundary

Navigation changes do not alter role ranks, source precedence, Search/Publication authority or consumer admission.

Manual file import is privileged, private-Evidence-backed and server-registered.

## UAT gate

Desktop/tablet/mobile acceptance covers:
- exact group labels/order;
- Statistics & Rankings route;
- Compare primary route;
- dataset drill-downs;
- Administration sub-navigation;
- upload privilege-negative path;
- Provider/Course deep-links;
- no duplicate legacy top-level QILT/PRISMS ambiguity;
- role restrictions and existing regression.
