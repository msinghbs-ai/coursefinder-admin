# CourseFinder Admin Navigation & Information Architecture v1.4

**Status:** CURRENT — M2.4 STREAMLINED OPERATING MODEL  
**Date:** 26 August 2026  
**Supersedes:** v1.3  
**Related Change Controls:** `CF-CHG-20260823-030`, `CF-CHG-20260825-036`, `CF-CHG-20260825-037`, `CF-CHG-20260825-038`, `CF-CHG-20260826-040`

## Principle

The Admin sidebar must describe the operating model, not implementation history. Layers 1–4 are first-class governed workflows and must be reachable from one Data Operations group. Qualification tools, provider internals and UAT-only controls must not make the primary product look experimental.

Authority remains:

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`.

Layer 4 is terminal. Search Projection, Search Visibility and Publication remain downstream product states.

## Accepted primary navigation order

| Order | Group | Menu item | Purpose |
|---:|---|---|---|
| 1 | Overview | Dashboard | cross-platform health, blockers, cost, freshness and next actions |
| 2 | Catalogue | Providers / Courses / Campuses / Scholarships | canonical decision workspaces |
| 3 | Data Operations | Layer 1 — Regulatory | authoritative source ingestion, source health, bounded reconciliation and Evidence |
| 3 | Data Operations | Layer 2 — Enrichment | deterministic first-party acquisition/extraction, provider routing and completeness |
| 3 | Data Operations | Layer 3 — AI Interpretation | governed Evidence interpretation using benchmarked server-side model profiles |
| 3 | Data Operations | Layer 4 — Human Resolution | terminal human resolution with retained reason and lineage |
| 3 | Data Operations | Evidence & Provenance | cross-layer source snapshots and consequence tracing |
| 3 | Data Operations | Jobs & Runs | pipeline execution history and operational state |
| 3 | Data Operations | Onboarding | reusable Country / Provider / Course lifecycle |
| 4 | Insights | Outcomes (QILT) / Student Flow (PRISMS) | contextual outcome/student-flow intelligence at true source grain |
| 5 | Quality & Review | Completeness | factual and decision-context completeness/readiness |
| 6 | Decision Tools | Scholarship Selection | source fact + transparent derived relevance + unresolved eligibility decision support |
| 7 | Governance & Platform | Sources | governed source inventory/configuration |
| 7 | Governance & Platform | Attributes | PIM taxonomy/attribute governance |
| 7 | Governance & Platform | Users & Roles | Platform Admin identity/role administration |
| 8 | Help & Guides | Guides & Runbooks | visible role-oriented operator guidance and workflow launch points |

Items remain role-filtered by the existing security model. The sidebar must not expose a control merely because the component exists.

## Layer 1 presentation rule

Layer 1 is a Data Operations capability, not a generic Settings feature. The normal Layer 1 journey presents regulatory source selection, health, bounded validation/apply, deterministic offsets/resume, reconciliation, Evidence and source registry.

Qualification and destructive Pilot/UAT tools are outside the normal Layer 1 journey. In particular:

- StatsCan PSIS Layer 2A parser qualification must not appear inside normal Layer 1 operations;
- Reset Pilot database must not appear inside normal Layer 1 operations;
- underlying privileged ACLs are unchanged by navigation presentation;
- direct legacy Settings routing is not the supported operator journey.

## Layer 2 presentation rule

Layer 2 is an accepted deterministic capability. Primary navigation says `Layer 2 — Enrichment`; Provider registry, source profile, provider attempt and trial/benchmark screens are progressive drill-downs rather than separate top-level navigation.

## Layer 3 presentation rule

Layer 3 opens directly to AI Interpretation. Model/provider credentials remain server-side and role restricted. Provider/model changes require governed revalidation/benchmark before resume. The benchmark-approved initial profile remains pinned until a later accepted provider/model change.

## Layer 4 presentation rule

Layer 4 opens directly to terminal human resolution. The older generic Review Queue entry is removed from the primary menu to avoid two apparent human-resolution authorities. Existing canonical resolution contracts remain unchanged.

## Evidence and Jobs

Evidence and Jobs are cross-layer operations and therefore sit inside Data Operations. Layer-specific screens deep-link into the same governed surfaces rather than duplicating them.

## Decision Tools

Scholarship Selection is not a catalogue editor and not a Layer 2/3 authority. It remains decision support and therefore sits under Decision Tools. Source facts, derived scope score and missing/unresolved eligibility must remain visibly distinct.

## Governance & Platform

Sources, Attributes and Users & Roles remain governance functions. Their existing rank boundaries remain authoritative. Generic Settings is removed from the primary sidebar because its Layer 1 content has a dedicated operating entry and its qualification/destructive controls are not routine navigation.

## Help & Guides

Guidance is an in-product requirement, not repository-only documentation. The visible Guides & Runbooks workspace provides:

- operating-authority summary;
- Layer 1/2/3/4 quick guides;
- Evidence and Onboarding quick guides;
- Platform Admin, Pipeline Operator, Curator/Reviewer and read-only role guidance;
- direct entry into governed workflows;
- references to the maintained User Guide, Data Operations Admin Guide, Operations Runbook and release notes.

The in-product guide supplements rather than replaces repository governance.

## Mobile / responsive

The same logical menu must be available through the mobile navigation drawer. Floating launchers are suppressed where equivalent primary navigation exists, preventing overlap with version/release controls and page actions.

## Security / semantic boundary

This IA changes presentation only. It does not change canonical identity, source precedence, RPC grants, role/rank thresholds, Layer authority, Search/Publication semantics or data contracts.

## UAT gate

A navigation release is accepted only when desktop and mobile deployed UAT proves:

- group labels/order;
- layer launch behaviour;
- Guides visibility;
- legacy Settings/duplicate Review Queue/floating launcher suppression;
- QILT/PRISMS contextual placement;
- role restrictions remain intact;
- existing Course Detail/Data Quality/Layer 2/Layer 3/Layer 4/performance/release regression remains green.
