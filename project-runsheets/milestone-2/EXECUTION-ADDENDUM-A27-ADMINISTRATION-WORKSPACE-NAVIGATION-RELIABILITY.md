# M2 Execution Addendum A27 — Administration Workspace Navigation Reliability

**Status:** CLOSED / PASS — ACCEPTED M2.4.4 STANDING BEHAVIOUR
**Effective:** 1 September 2026  
**Primary Change Control:** `CF-CHG-20260830-048`  
**Applies to:** canonical Administration route, Administration sub-navigation, embedded configuration panels, responsive Admin/PIM navigation and deployed UI acceptance.

## User-observed defect

The canonical `Administration` menu can open to an empty/blank workspace and its sub-context/sub-menu items do not reliably respond to clicks.

This is a production-readiness defect because A20/A21 intentionally centralised configuration under one Administration workspace. A non-functional Administration parent route makes source, onboarding, acquisition, scheduling, AI, platform and related configuration unreachable or misleading.

## Required behaviour

1. Clicking the canonical `Administration` primary-navigation item must always render a usable Administration landing workspace.
2. The landing workspace must never be an intentionally empty shell.
3. Administration must expose clear sub-context navigation for the governed configuration areas that actually exist in the repository/runtime.
4. Each visible sub-context item must:
   - respond to pointer/touch/keyboard activation;
   - update the active state;
   - render its associated panel/content;
   - preserve canonical route/hash behaviour;
   - not depend on legacy floating launchers, MutationObservers or post-render DOM mutation.
5. The parent Administration route should default to a meaningful first/overview section when no sub-route is selected.
6. Deep links/back-forward navigation must restore the correct sub-context where supported.
7. Rank-gated configuration must show a clear permission/availability state rather than a blank screen.
8. Loading or API failure must show bounded loading/error states rather than empty content.
9. Tablet/mobile layouts must keep Administration sub-navigation discoverable and usable without horizontal overflow.
10. The implementation must extend the canonical `src/mature-main.jsx` navigation/route model; no parallel top-level menu architecture may be introduced.

## UX expectations

Administration should remain concise and task-oriented:
- clear section title and short purpose statement;
- visible sub-context selector/navigation;
- meaningful configuration/status content;
- progressive disclosure for advanced/raw settings;
- no duplicate configuration entries in the main navigation.

## Acceptance

A27 is not accepted until deployed UAT proves:
- Administration parent click renders non-empty content;
- every visible Administration sub-context can be opened;
- active-state switching works;
- direct/deep route and browser back/forward do not produce a blank shell;
- insufficient-rank behaviour is explicit;
- no legacy floating/config launcher is required;
- desktop/tablet/mobile interaction passes;
- existing A20/A21 canonical navigation rules remain intact.

## Sequencing

A27 must be implemented together with the current M2.4.4 corrective head before the next bounded integration nomination. It is compatible with A26 and should share the same settled-head correction cycle.

## Non-goals

A27 does not authorise new configuration domains, Production cutover, broad Publication, Website/Zoho cutover, or bypass of role/rank enforcement.

## Closure disposition — 1 September 2026
- Accepted under closed `CF-CHG-20260830-048` / M2.4.4.
- Replacement final acceptance `33468512515` PASS on desktop and mobile.
- This addendum remains standing behavioural/governance guidance where applicable, but does not keep M2.4.4 open.
