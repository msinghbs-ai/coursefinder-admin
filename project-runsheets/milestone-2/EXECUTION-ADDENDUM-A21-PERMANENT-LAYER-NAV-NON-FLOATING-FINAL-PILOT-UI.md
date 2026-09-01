# Execution Addendum A21 — Permanent Layer Navigation, Non-floating Workspaces & Final Pilot UI Placement

**Status:** CLOSED / PASS — ACCEPTED M2.4.4 STANDING BEHAVIOUR
**Effective:** 31 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Purpose

Make the Pilot demonstrate the intended final Admin information architecture. Layer workspaces must not appear as floating launchers/dialogs detached from the canonical shell.

## A21.1 — Permanent layer placement

Under the canonical `Operations` navigation, expose four permanent sibling routes:

- Layer 1 — Authority
- Layer 2 — Enrichment
- Layer 3 — AI Interpretation
- Layer 4 — Human Resolution

All four routes are rendered inside the canonical CourseFinder shell. They are not floating buttons, global launchers or modal-only workspaces.

Layer 3 and Layer 4 are separate routes/workspaces. A tabbed Layer 3/4 combined dialog is not the canonical user journey.

## A21.2 — No floating primary journeys

The following are prohibited as the main route to a governed feature:
- fixed-position layer launchers;
- floating buttons that create independent navigation;
- full-screen dialogs mounted outside the canonical app shell;
- separate feature roots that duplicate the primary navigation model;
- hidden launcher-only workflows required by UAT.

Temporary compatibility hooks may remain only while migration is in progress and must not render a visible duplicate/floating control.

## A21.3 — Final Pilot presentation

The Pilot must show the intended placement and operator experience, not experimental UI.

Each Layer workspace should begin with:
1. concise status/health;
2. meaningful counts/KPIs;
3. the next actionable operator control;
4. current blocker/fall-out state;
5. recent outcome/progress;
6. Evidence/provenance links where relevant.

Advanced configuration, raw IDs, probes and diagnostics use progressive disclosure or Administration.

## A21.4 — Information-density principle

Normal screens must not feel bloated or overwhelming.

- Prefer 3–5 primary KPIs per workspace.
- Prefer one main action group per operational state.
- Put raw IDs, detailed lineage, API/provider settings and low-frequency controls under expandable detail or Administration.
- Avoid repeating the same status in multiple cards.
- Use compact tables for recent/history data rather than large cards for every record.
- Use clear labels and action verbs: Run, Retry, Resume, Review, Approve, Revert, Schedule, Open Evidence.
- Empty states must state what is missing and the next available action.

## A21.5 — Canonical implementation rule

`src/mature-main.jsx::NAV` remains the primary navigation authority under Decision 33.

Layer feature modules may export embedded workspace components, but they cannot mount independent visible navigation. The canonical app imports and renders those components on the four permanent routes.

## A21.6 — Acceptance

A21 requires:
1. Layer 1/2/3/4 are present in canonical Operations navigation;
2. no visible floating Layer 1/2/3/4 launcher remains;
3. Layer 3 and Layer 4 are separately addressable routes;
4. normal Layer screens show concise status + actions before advanced detail;
5. desktop/tablet/mobile route navigation passes;
6. existing role/rank boundaries remain server-side enforced;
7. permanent UAT navigates through canonical routes only.


## A21.7 — No post-render navigation mutation

The canonical React navigation may not be rewritten after render by MutationObserver/DOM-injection scripts.

Specifically prohibited:
- renaming canonical `NAV` groups from browser-side DOM code;
- hiding canonical menu items and injecting replacement buttons;
- routing a canonical Layer menu item to an unrelated Settings/legacy surface;
- injecting legacy groups such as `Data Operations`, `Governance & Platform`, `Decision Tools` or `Help & Guides` outside the canonical registry;
- using MutationObserver to continually reconcile a competing menu model.

Historical compatibility code may remain in source only if it is not loaded by the Pilot shell. Permanent UAT must assert that no legacy navigation marker or injected menu item is rendered.


## A21.8 — Stable filter restoration

Catalogue filter state restoration must never simulate user interaction.

Standing rule:
- saved query/filter/sort/advanced state is restored directly into canonical React state;
- restoration must not programmatically click filter buttons or options;
- no filter popover may open automatically during page load, reload, route restoration or screen-state recovery;
- only the filter explicitly opened by the operator may render a popover;
- async option loading may show a spinner inside that filter control, but must not move focus or open another filter;
- bounded option paging remains 10 visible options per page for large filter sets.

Legacy screen-state adapters that restore by DOM clicking must not be loaded by the Pilot shell.


## A21.9 — Embedded workspace CSS isolation

Canonical embedded Layer workspaces must not inherit legacy full-screen/floating shell CSS.

Standing rule:
- embedded Layer workspaces use normal document flow (`position: relative/static`);
- no embedded workspace may use `position: fixed; inset: 0` or a z-index that obscures the canonical sidebar/header;
- standalone/modal CSS must be scoped to explicit non-embedded classes/selectors;
- canonical route UAT must assert the sidebar remains visible when each Layer route is open;
- feature-specific DOM label mutators must not be loaded globally.

The Layer 2 regression where `.l2o-shell` remained `position: fixed; inset: 0; z-index: 2200` after canonical embedding is explicitly prohibited.

## Closure disposition — 1 September 2026
- Accepted under closed `CF-CHG-20260830-048` / M2.4.4.
- Replacement final acceptance `33468512515` PASS on desktop and mobile.
- This addendum remains standing behavioural/governance guidance where applicable, but does not keep M2.4.4 open.
