# CF-CHG-20260823-030 — Data Enrichment Navigation Replan

**Status:** IMPLEMENTED — BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 23 August 2026 21:50 AEST (+10:00)  
**Updated:** 24 August 2026 10:38 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** Admin/PIM UX with M2.1 Layer 2 Platform  
**Change class:** Admin information architecture / navigation / operations UX

## Trigger

The first M2.1 navigation pass correctly grouped Pipeline, Source, Provider, Trial, Job and Evidence capabilities, but it exposed too many backend concepts as separate management-menu destinations.

Management staff need to answer a smaller set of questions: what Course/Scholarship enrichment is scheduled, which provider/routing policy is active, what did the recent run resolve, what did it cost, what Evidence exists and what fell through to Layer 3/4.

QILT and PRISMS are already governed Layer 1 contextual datasets and must not appear as Layer 2 paid-acquisition targets.

## Decision

The primary menu is simplified to:

1. **Overview**
   - Dashboard
2. **Catalogue**
   - Providers
   - Courses
   - Campuses
   - Scholarships
3. **Data Enrichment**
   - Layer 2 Operations
   - Evidence
4. **Insights**
   - Outcomes (QILT)
   - Student Flow (PRISMS)
5. **Quality & Review**
   - Completeness
   - Review Queue
6. **Governance & Platform**
   - Attributes
   - Settings / Access

Pipeline Control, Source Registry, Layer 2 Source Config, Acquisition Providers, Acquisition Trials and Jobs remain governed operational capabilities but are moved behind **Layer 2 Operations** as drill-down actions rather than separate primary-menu entries.

## Layer 2 Operations workspace

The management landing page exposes only:

- enrichment source / country / Courses or Scholarships;
- automation schedule and batch size;
- cost-aware provider routing policy;
- provider readiness / last test;
- Evidence count / review count;
- recent run outcome: processed / L2 resolved / sent to L3 / blocked / cost.

Advanced source configuration, provider credentials/capabilities, trials, Jobs and diagnostic logs are available only when the operator drills in.

## Progressive disclosure

**Level 1 — Management:** status, schedule, outcome, cost, exceptions.  
**Level 2 — Operations:** run, entity, provider attempts, Evidence.  
**Level 3 — Diagnostics:** source-profile version, runtime region/deployment, storage path/hash, provider trace/rate/credit headers and raw logs.

This avoids turning the Admin into an observability console while preserving full diagnostic access.

## Layer boundary

The menu continues to reflect exactly four authority layers:

`Layer 1 Authoritative/Regulatory → Layer 2 Deterministic Acquisition/Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 2 never exposes a direct `Send to Layer 4` action. Its fall-out state is `L3 required`; only unresolved/conflicting Layer 3 fall-out appears in the Layer 4 Review Queue.

There is no Layer 5. Search/Publication remain downstream product states.

## Implementation

Pilot implementation now includes:

- `src/layer2-operations-entry.jsx` — concise Layer 2 management workspace;
- `src/layer2-operations.css`;
- `src/data-acquisition-nav-entry.js` v1.4 — simplified `Data Enrichment` navigation;
- `index.html` Layer 2 Platform visible version v1.4;
- existing `.ops-launcher`, `.l2-launcher`, `.l2p-launcher`, `.l2t-launcher` remain hidden from primary navigation and are invoked only as drill-down controls;
- `tests/uat/admin-navigation-deployed.spec.mjs` updated for the simplified IA.

Current maintained IA: `docs/coursefinder-admin-navigation-information-architecture-v1.3.md`.

## UAT requirement

Acceptance requires deployed desktop/mobile verification that:

- `Data Enrichment` contains only `Layer 2 Operations` and `Evidence`;
- Layer 2 Operations loads only Course/Scholarship enrichment sources;
- QILT/PRISMS remain under Insights and never appear as Layer 2 acquisition targets;
- schedule/routing controls remain role-gated;
- advanced provider/source/trial/job controls remain available by drill-down;
- Evidence opens the existing governed private Evidence workspace;
- no provider secrets or service-role material appear in browser content;
- collapsed/mobile navigation remains usable.

## Rollback

Revert the v1.4 `data-acquisition-nav-entry.js` and remove the `layer2-operations-entry.jsx` mount. Underlying Source/Provider/Trial/Pipeline/Jobs/Evidence controls remain intact.

## Closure

**Final status:** IMPLEMENTED — DEPLOYED BROWSER UAT PENDING.  
**Outcome:** The primary Admin menu is management-oriented and intentionally small, while operational detail remains available through progressive drill-down.
