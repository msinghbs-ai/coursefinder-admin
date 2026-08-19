# CourseFinder Admin / PIM Design Decisions v1.9

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.8.md`

v1.9 retains all accepted decision-grid, searchable-combobox, cross-link, evidence, column-resize and UI-version principles and strengthens Country presentation for cross-browser consistency.

## Country visual primitive

Where a Country is displayed in an Admin/PIM UI, use one shared Country visual component.

Default compact presentation:
- real SVG flag rendered independently of operating-system emoji support;
- country name where space allows;
- ISO alpha-2 code retained in metadata, search/filter matching and tooltip/context rather than duplicated beside the name by default.

Examples:
- `Australian flag + Australia`
- `New Zealand flag + New Zealand`
- `Canada flag + Canada`

Global/non-country scope uses the globe treatment and `Global`.

## Country filters

Country filters remain searchable/typeable comboboxes.

The selected Country and dropdown options should show the same real flag primitive plus country name. ISO alpha-2 code remains searchable and may be shown as secondary metadata.

## Cross-browser requirement

Do not depend on Unicode regional-indicator emoji for flag rendering. Windows desktop browsers may render regional letters instead of coloured flag glyphs. Use browser-independent SVG flag assets/components.

The same Country component must be reused across Providers, Courses, Scholarships, Outcomes/QILT, Student Flow/PRISMS, Completeness, Jobs and future screens wherever Country is applicable.

## UI version correlation

Material visual changes to a common component require an incremented visible UI version. The cross-browser Country correction is first exposed in **UI v1.7.2**.
