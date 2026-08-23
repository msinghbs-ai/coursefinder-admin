# CF-CHG-20260823-030 — Data Acquisition Navigation Replan

**Status:** IMPLEMENTED — BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 23 August 2026 21:50 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** Admin/PIM UX with M2.1 Layer 2 Platform  
**Change class:** Admin information architecture / navigation / operations UX

## Trigger

M2.1 added Pipeline Operations, Layer 2 Source Configuration and Acquisition Providers as operational workspaces, but the primary Admin navigation still reflected the older PIM-first information architecture. Pipeline and Layer 2 controls were exposed as floating launchers while Evidence was grouped under Data Quality, making the acquisition lifecycle appear disjointed.

The M2.1 architecture was then clarified further: CourseFinder has exactly four enrichment authority layers, Layer 4 is terminal, QILT/PRISMS are decision context that may be surfaced with Courses while preserving source grain, CourseFinder is not a university-admissions workflow, and country/provider completeness benchmarking is an explicit M2.1 operating capability rather than an offline engineering-only task.

## Decision

The main Admin navigation is organised around the actual data lifecycle rather than backing tables/repositories.

### Primary navigation

1. **Overview**
   - Dashboard
2. **Catalogue**
   - Providers
   - Courses
   - Campuses
   - Scholarships
3. **Data Acquisition**
   - Pipeline Control
   - Source Registry
   - Layer 2 Source Config
   - Acquisition Providers
   - Acquisition Trials
   - Jobs
   - Evidence
4. **Enrichment & Insights**
   - Outcomes (QILT)
   - Student Flow (PRISMS)
5. **Quality & Review**
   - Completeness
   - Review Queue
6. **Governance & Platform**
   - Attributes
   - Settings

## Rationale

- Pipeline Control is the operational top of the Layer 1–4 journey and therefore belongs in the primary menu.
- Source Registry, Layer 2 Source Config and Acquisition Providers are distinct configuration planes but belong together under Data Acquisition.
- **Acquisition Trials** belongs between provider configuration and Jobs because it is the governed country/Provider/Course learning and benchmark workspace used to determine which routed provider/extractor combination produces the best evidence-backed completion/correctness/cost outcome.
- Jobs and Evidence are execution/provenance consequences of acquisition and therefore sit directly beside acquisition configuration/trials.
- Evidence is not merely a data-quality concept; it is a cross-layer acquisition and decision record.
- QILT/PRISMS remain visible as enrichment/context workspaces and may also contribute labelled context to Course views/comparisons.
- Completeness distinguishes Course factual completeness from decision-context completeness.
- Review Queue represents Layer 4 terminal human resolution and is downstream of Layer 2/3 automation.
- PIM Attributes and privileged Settings are governance/platform controls, not routine acquisition operations.

## Layer boundary

The menu communicates exactly four enrichment authority layers:

`Layer 1 Authoritative/Regulatory → Layer 2 Deterministic Acquisition/Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

There is no Layer 5. Search Projection/Visibility and Publication are downstream product states, not additional layers.

CourseFinder does not provide university application/admissions/offer-letter/visa workflows. Avoid the term **Search Admission** in new UI; use Search Eligibility, Search Projection, Search Visibility, Publication Eligibility or Publication.

## Semantic impact

No canonical identity or accepted source-authority semantics change. Existing role/rank boundaries remain unchanged. QILT/PRISMS contextual Course presentation must preserve source grain rather than creating false Course-level facts.

Acquisition Trials do not widen data authority. Trial execution produces Provider Attempts, Evidence, candidate extraction and benchmark results only. A trial must not directly mutate canonical Course/Scholarship/Search/Publication state.

## Implementation

Pilot `src/data-acquisition-nav-entry.js`, mounted from `index.html`, integrates governed workspaces into the primary sidebar and suppresses redundant floating launchers:

- `.ops-launcher` → **Pipeline Control**;
- `.l2-launcher` → **Layer 2 Source Config**;
- `.l2p-launcher` → **Acquisition Providers**;
- `.l2t-launcher` → **Acquisition Trials**.

`Acquisition Trials` opens the governed Layer 2 trial workspace, which displays country/Provider learning cohorts, factual/context baseline, provider selector, bounded acquisition/discovery/extraction controls and measured provider outcomes.

Existing governed React/Edge controls remain the authority for workspace behaviour and permissions. The integration layer adds no data-access or mutation authority.

Pilot implementation evidence includes:

- `ef1dd433f40d3108279fc75081ef099a7b28c84a` — initial acquisition navigation integration;
- `7aff5e75586fb7cd10e60c4e247136a50393cdbd` — initial mount;
- `66e707eed9f89d9c4875ada558504d18df260096` — Acquisition Trials added to Data Acquisition navigation;
- `b2920306e86550a8d41ad2259505f7128d34f0a2` — Layer 2 Platform v1.2 shell marker/trial mount;
- `c718cf16d035c9986e14843fc6e9fdf4d19e4274` — deployed navigation UAT updated for Acquisition Trials.

Current maintained IA: `docs/coursefinder-admin-navigation-information-architecture-v1.2.md`.

## UAT requirement

Final acceptance requires deployed desktop and mobile browser verification that:

- the Data Acquisition group appears in the main sidebar for authorised users;
- Pipeline Control, Source Registry, Layer 2 Source Config, Acquisition Providers, Acquisition Trials, Jobs and Evidence all open the governed workspace;
- old floating Pipeline/L2/Provider/Trial launchers are hidden as primary navigation;
- Acquisition Trials displays authorised learning cohorts and does not expose provider credentials;
- Enrichment & Insights retains QILT/PRISMS;
- Quality & Review retains Completeness and Layer 4 Review Queue;
- Governance & Platform retains Attributes/Settings subject to rank;
- collapsed/mobile navigation remains usable;
- no role boundary is widened;
- terminology does not imply CourseFinder performs university admissions.

This UI UAT remains coupled to the currently open M2.1 acceptance state under `CF-CHG-20260823-029`.

## Rollback

Remove/revert the `data-acquisition-nav-entry.js` trial/navigation mount. The underlying governed workspaces remain intact and can be re-opened through their implementation controls during rollback.

## Closure

**Final status:** N/A — browser UAT pending.  
**Outcome:** Primary Admin navigation presents data acquisition as a coherent operational lifecycle including the governed provider-learning/benchmark stage; acceptance remains pending deployed browser evidence.
