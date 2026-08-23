# CF-CHG-20260823-030 — Data Acquisition Navigation Replan

**Status:** IMPLEMENTED — BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 23 August 2026 21:50 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** Admin/PIM UX with M2.1 Layer 2 Platform  
**Change class:** Admin information architecture / navigation / operations UX

## Trigger

M2.1 added Pipeline Operations, Layer 2 Source Configuration and Acquisition Providers as operational workspaces, but the primary Admin navigation still reflected the older PIM-first information architecture. Pipeline and Layer 2 controls were exposed as floating launchers while Evidence was grouped under Data Quality, making the acquisition lifecycle appear disjointed.

## Decision

The main Admin navigation is replanned around the actual operational lifecycle rather than the table/schema that happens to back each screen.

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
- Review Queue is downstream of evidence/extraction and remains grouped with completeness/decision workload.
- PIM Attributes and privileged Settings are governance/platform controls, not routine acquisition operations.

## Semantic impact

No canonical, source-authority, Search or publication semantics change. This is an Admin information-architecture correction only. Existing role/rank boundaries remain unchanged.

## Implementation

Pilot adds `src/data-acquisition-nav-entry.js`, mounted from `index.html`, which integrates the existing governed workspaces into the primary sidebar and suppresses the three redundant floating launchers:

- `.ops-launcher` → **Pipeline Control**;
- `.l2-launcher` → **Layer 2 Source Config**;
- `.l2p-launcher` → **Acquisition Providers**.

Existing governed React controls remain the authority for workspace behaviour and permissions. The integration layer does not add data access or mutation authority.

Pilot implementation commits include:

- `ef1dd433f40d3108279fc75081ef099a7b28c84a` — acquisition navigation integration;
- `7aff5e75586fb7cd10e60c4e247136a50393cdbd` — mount acquisition navigation in Admin shell.

## UAT requirement

Final acceptance requires deployed desktop and mobile browser verification that:

- the Data Acquisition group appears in the main sidebar for authorised users;
- Pipeline Control, Source Registry, Layer 2 Source Config, Acquisition Providers, Jobs and Evidence all open the existing governed workspace;
- old floating Pipeline/L2 launchers are no longer visible;
- Quality & Review retains Completeness and Review Queue;
- Governance & Platform retains Attributes/Settings subject to rank;
- collapsed/mobile navigation remains usable;
- no role boundary is widened.

This UI UAT is coupled to the currently BLOCKED deployed-browser evidence state under `CF-CHG-20260823-029`.

## Rollback

Remove the `data-acquisition-nav-entry.js` mount from `index.html` and delete the integration module. The underlying workspaces and original navigation remain intact.

## Closure

**Final status:** N/A — browser UAT pending.  
**Outcome:** Primary Admin navigation now presents data acquisition as a coherent operational lifecycle; acceptance remains pending deployed browser evidence.