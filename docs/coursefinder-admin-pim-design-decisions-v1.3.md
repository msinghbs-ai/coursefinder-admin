# CourseFinder Admin / PIM Design Decisions v1.3

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.2.md`  
**Pilot UI reference:** UI v1.5.0

v1.3 retains all accepted v1.2 decisions and adds the following mandatory platform rules.

## 1. Neutral first-column rule

The first data column is not a primary-action button and must not inherit application `primary` button styling.

- first-column text may be semibold for scanability;
- row selection is indicated at row level only;
- cells must remain neutral unless their data state itself requires a status colour;
- reusable table-cell classes must be namespace-safe and must not collide with global button/component classes.

## 2. Fluid decision-grid sizing

High-volume Admin tables must use available viewport width rather than a fixed spreadsheet canvas.

- use fluid semantic column widths (`xs`, `sm`, `md`, `wide`) rather than hard-coded pixel widths per screen;
- identity/name columns get the largest share;
- short codes/status/date/count columns stay compact;
- long secondary text truncates with drill-in/detail available;
- horizontal scroll is a fallback for constrained viewports, not the default desktop layout;
- opening the right-side drawer may trigger responsive stacking rather than crushing the decision grid.

## 3. Common modern component primitives

The same reusable components are expected across Providers, Courses, Scholarships, Evidence, Review Queue and future Admin workspaces:

- `FilterCombobox` — type + browse dropdown + keyboard select + clear;
- `DecisionWorkspace` — common header/search/filter/grid/pager/drawer shell;
- `DecisionTable` — sortable fluid columns with row selection;
- `CrossLink` — opens related filtered outcome with minimal navigation;
- `Drawer` — condensed verification/related-record workspace;
- `Status` / Country / Currency primitives;
- visible UI version.

Do not implement visually similar but behaviourally different controls per page.

## 4. Course catalogue discovery contract

Course Admin is a discovery and validation workspace, not merely a title list.

The preferred drill-down sequence is:

`Country -> State/Province/Region -> Provider -> Study Level -> Field of Study -> Delivery -> Lifecycle -> Publication`

Global search remains available independently.

All reference filters are searchable comboboxes and must dynamically narrow where the backend has governed data.

### Geography

Course geography may be derived only from governed Provider/Campus subdivision relationships. The Admin UI must not silently infer State/Region from city/address text.

If a country's authoritative subdivision mapping is incomplete, display the coverage gap in the UI and leave the filter empty rather than manufacturing options.

## 5. Cross-click behaviour

Course rows should expose related entities with the same minimal-navigation contract:

- Provider -> Provider verification drawer;
- future Campus count/location -> filtered Campus outcome;
- Fees / Intakes / English / Scholarships / Evidence -> filtered related view where canonical relationships exist;
- external Course URL -> new tab without changing Admin list context.

## 6. Version correlation

Every material Admin interaction/layout release increments the visible UI version. UI v1.5.0 corresponds to:

- removal of first-column blue style collision;
- fluid semantic column sizing;
- common flex-based filter bar;
- Course geography/provider/level/field/delivery drill-down;
- explicit canonical geography coverage warning when subdivision mapping is absent.

Future browser UAT feedback should name or show the visible UI version whenever possible.

## 7. Automation objective

Facet choices should come from governed backend read contracts, not duplicated frontend lists, so new Providers, Countries, subdivisions, study levels, fields and delivery modes appear with minimal manual UI maintenance.

The standing operating goal remains minimum routine workforce with maximum safe deterministic automation and bounded agent assistance.
