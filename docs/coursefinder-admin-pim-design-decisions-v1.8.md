# CourseFinder Admin / PIM Design Decisions v1.8

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.7.md`

v1.8 retains all prior decision-grid, filter, cross-link, resize, evidence and automation principles and adds a uniform Country presentation rule.

## Country presentation standard

Whenever a UI surface displays a Country field, the preferred visual treatment is:

- compact grid: `flag + ISO alpha-2 + country name where width permits`;
- searchable Country combobox: `flag + country name`, with ISO alpha-2 retained as searchable metadata;
- detail/fact panels: `flag + ISO alpha-2 + country name`;
- global/non-country scope: globe indicator + `Global`;
- responsive narrow grids may hide the long country name but MUST retain flag + ISO alpha-2.

Examples:
- `🇦🇺 AU Australia`
- `🇳🇿 NZ New Zealand`
- `🇨🇦 CA Canada`
- `🌐 Global`

Country flags are presentation only. ISO codes and canonical reference-country identity remain authoritative.

## Applicability

Apply this common Country primitive wherever Country is materially displayed, including Providers, Courses, Scholarships, QILT Outcomes, PRISMS/other country-scoped enrichment, Completeness, Jobs/operations and future decision workspaces.

Do not create page-specific country rendering when the shared Country component can be used.

## Visual balance

Flags are intended to improve scan speed and add restrained colour without turning the Admin into a decorative UI. Country pills should remain compact, legible and subordinate to canonical decision content.
