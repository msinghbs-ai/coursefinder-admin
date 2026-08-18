# CourseFinder Admin / PIM Design Decisions v1.2

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 18 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.1.md`  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.26.md`  
**Programme baseline:** `docs/coursefinder-master-project-plan-v1.26.md`

v1.2 retains all v1.1 decisions and makes UI primitive reuse and visible UI versioning mandatory.

## 1. One platform interaction model

Admin/PIM must not implement page-specific interaction patterns where a common primitive can be reused.

Providers, Courses, Campuses, Scholarships, Evidence, Review Queue, Pipeline/Jobs and future catalogue/enrichment workspaces should converge on the same operating model where applicable:

`search / quick view -> searchable combobox filters -> sortable dense columns -> cross-click related entity -> condensed right-side result/detail -> decision/action`

The objective is minimum navigation and minimum repetitive human effort while retaining evidence and governance context.

## 2. Mandatory searchable combobox primitive

Reference/bounded filters must use the common searchable combobox component rather than HTML `datalist`, plain text input or dropdown-only `select` unless there is a documented exception.

The component must support:
- click chevron to browse all available values;
- type to reduce the dropdown by code or display name;
- keyboard Up/Down navigation;
- Enter to select;
- Escape to close;
- explicit clear action;
- selected-state visibility;
- no server query merely because partial invalid text was typed;
- dependent option lists, such as Country -> State/Region;
- governed dynamic option sources where practical.

Country display: `flag + ISO alpha-2 + name`.

State/Region display: `human name + canonical subdivision code`.

The same primitive should be used for Lifecycle, Publication, Source, Study Level, Currency, Evidence Type, Review Status and similar bounded filters.

## 3. Uniform decision-grid primitive

High-volume workspaces should share:
- server-side pagination where volume requires it;
- dense rows;
- sortable column headers;
- structured filters aligned directly above the grid;
- consistent status pills;
- selected-row state;
- same-row cross-links for related objects/counts;
- condensed right-side detail/related-result panel;
- close/collapse without losing page, sort, search or filters.

Column order should prioritise human decision-making rather than physical schema order.

## 4. Cross-clickable relationships

Counts and related objects that help validation should be interactive rather than informational only.

Examples:
- Provider -> Courses, Campuses, Scholarships, Evidence, Outcomes;
- Course -> Provider, Campuses, Fees, Intakes, English, Evidence, Scholarships;
- Scholarship -> Provider, Offering Cycles, Windows, Eligibility, Awards/Coverage, Evidence;
- Evidence -> Source, Job, canonical entity;
- Review item -> affected canonical/source/evidence records.

Cross-click should prefer a filtered related-result workspace using the same combobox/search/order/pagination logic rather than navigating the user away from their current decision context.

## 5. Visible UI version — mandatory

Every user-visible Admin/PIM release that materially changes interaction, layout, fields, filters or decision behaviour must increment the UI version.

The active UI version must be visibly rendered in the application shell and/or page workspace so screenshots and browser UAT can be correlated to source control.

Version format:

`UI vMAJOR.MINOR.PATCH`

Guidance:
- MAJOR — substantial interaction model/navigation redesign;
- MINOR — new decision-grid/workspace/filter/cross-link capability;
- PATCH — defect/style correction with no material feature change.

A UAT report must state the UI version tested and, where available, the Pilot Git commit.

Initial governed implementation after this decision: **UI v1.3.0**.

## 6. AI / automation consistency

Uniform UI primitives should also support uniform agent/automation outputs. Agent-derived recommendations, source-change summaries, stale warnings and review priorities should surface through the same status/change-chip/detail conventions rather than bespoke page-specific widgets.

The operating principle remains:

**minimum routine workforce + maximum safe deterministic automation/agent assistance + human review by exception.**

## 7. Regression rule

A later country/source/chat implementation must not replace an accepted common primitive with a less capable page-specific implementation without an explicit superseding design decision.

When a feature is called out in one CourseFinder chat and is broadly applicable, treat it as a candidate common platform primitive and update this design contract rather than implementing it as an isolated screen behaviour.
