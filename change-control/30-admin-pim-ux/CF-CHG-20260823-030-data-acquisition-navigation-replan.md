# CF-CHG-20260823-030 — Data Acquisition Navigation Replan

**Status:** IMPLEMENTED — BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 23 August 2026 21:50 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** Admin/PIM UX with M2.1 Layer 2 Platform  
**Change class:** Admin information architecture / navigation / operations UX

## Trigger

M2.1 added Pipeline Operations, Layer 2 Source Configuration and Acquisition Providers as operational workspaces, but the primary Admin navigation still reflected the older PIM-first information architecture. Pipeline and Layer 2 controls were exposed as floating launchers while Evidence was grouped under Data Quality, making the acquisition lifecycle appear disjointed.

The M2.1 architecture was then clarified further: CourseFinder has exactly four enrichment authority layers, Layer 4 is terminal, QILT/PRISMS are decision context that may be surfaced with Courses while preserving source grain, and CourseFinder is not a university-admissions workflow.

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
- Jobs and Evidence are execution/provenance consequences of acquisition and therefore sit directly beside acquisition configuration.
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

## Implementation

Pilot adds `src/data-acquisition-nav-entry.js`, mounted from `index.html`, integrating existing governed workspaces into the primary sidebar and suppressing redundant floating launchers:

- `.ops-launcher` → **Pipeline Control**;
- `.l2-launcher` → **Layer 2 Source Config**;
- `.l2p-launcher` → **Acquisition Providers**.

Existing governed React controls remain the authority for workspace behaviour and permissions. The integration layer adds no new data-access or mutation authority.

Pilot implementation commits include:

- `ef1dd433f40d3108279fc75081ef099a7b28c84a` — acquisition navigation integration;
- `7aff5e75586fb7cd10e60c4e247136a50393cdbd` — mount acquisition navigation in Admin shell.

Current maintained IA: `docs/coursefinder-admin-navigation-information-architecture-v1.1.md`.

## UAT requirement

Final acceptance requires deployed desktop and mobile browser verification that:

- the Data Acquisition group appears in the main sidebar for authorised users;
- Pipeline Control, Source Registry, Layer 2 Source Config, Acquisition Providers, Jobs and Evidence all open the governed workspace;
- old floating Pipeline/L2 launchers are no longer visible;
- Enrichment & Insights retains QILT/PRISMS;
- Quality & Review retains Completeness and Layer 4 Review Queue;
- Governance & Platform retains Attributes/Settings subject to rank;
- collapsed/mobile navigation remains usable;
- no role boundary is widened;
- terminology does not imply CourseFinder performs university admissions.

This UI UAT remains coupled to the currently open M2.1 acceptance state under `CF-CHG-20260823-029`.

## Rollback

Remove the `data-acquisition-nav-entry.js` mount from `index.html` and delete the integration module. The underlying governed workspaces remain intact.

## Closure

**Final status:** N/A — browser UAT pending.  
**Outcome:** Primary Admin navigation presents data acquisition as a coherent operational lifecycle and aligns to the final Layer 1–4 CourseFinder model; acceptance remains pending deployed browser evidence.