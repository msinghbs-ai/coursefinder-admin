# CourseFinder M1-PIM — UI v1.4.0 Decision Workspace Parity UAT

**Date:** 19 August 2026  
**Status:** TECHNICAL GATE PASS / LIVE BROWSER UAT PENDING  
**UI version:** `1.4.0`  
**Design contract:** `docs/coursefinder-admin-pim-design-decisions-v1.2.md`  
**Architecture boundary:** canonical backend identity/source/evidence/lifecycle/publication design unchanged.

## Purpose

UI v1.4.0 is the first platform-wide Admin/PIM parity pass using Providers as the accepted reference interaction model.

The release standardises:
- searchable/typeable dropdown comboboxes rather than plain inputs/datalist-only controls;
- dense sortable decision grids;
- server-side pagination/filtering for high-volume entities;
- compact right-side verification drawers;
- cross-clickable related items without losing list/filter/page state;
- country flag + ISO code;
- ISO currency code where country/value context exists;
- canonical external website/source links;
- visible UI version for browser-UAT/change correlation.

## Surfaces moved to the common contract

### Providers
Retains the accepted reference UX:
- Country and State/Region comboboxes;
- Lifecycle and Publication comboboxes;
- sortable columns;
- country flag/code and default currency;
- Provider website link;
- clickable related Courses and Evidence;
- compact Provider drawer.

### Courses
Now uses:
- paged server-side Course contract;
- Country, Study Level, Lifecycle and Publication searchable comboboxes;
- sortable Course/Provider/Country/Level/Completeness/Verified columns;
- flag/code + default currency;
- Course URL action where present;
- cross-clickable Provider opening the Provider verification drawer;
- compact Course detail drawer for Fees and Intakes.

### Scholarships
Converted from cards to a condensed decision grid:
- Country, Lifecycle and Publication searchable comboboxes;
- Provider cross-link;
- Country flag/code + default currency where Provider-scoped;
- Award, Offering Cycle, Application Window and Evidence signals;
- clickable relational counts opening the relevant drawer tab;
- Source link where present;
- relational Scholarship detail remains source/evidence/cycle aware.

### Evidence
Converted from cards to a paged decision grid:
- Evidence Type searchable combobox;
- source/captured/MIME/hash/entity/lineage columns;
- source URL cross-link;
- compact evidence metadata drawer.

### Review Queue
Converted to the common decision-grid shell:
- Domain and Status searchable comboboxes;
- Priority ordering;
- Entity/reason/status/timestamp visibility;
- compact exception detail drawer.

The current live Review Queue is empty; empty-state behaviour is therefore the accepted result, not seeded fake review data.

## Backend contracts

New authenticated read contracts:
- `public.ui_courses_page(...)`;
- `public.ui_course_filter_options()`;
- `public.ui_scholarships_page(...)`;
- `public.ui_evidence_page(...)`;
- `public.ui_evidence_filter_options()`;
- `public.ui_reviews_page(...)`;
- `public.ui_review_filter_options()`.

All are authenticated UI read contracts; they do not grant Layer 1/2 write authority or change canonical identity.

Applied Supabase migrations:
- `20260818214238_m1_pim_uniform_decision_grid_pages`;
- `20260818214620_m1_pim_fix_scholarship_page_window_fk`.

## Autonomous UAT

Authenticated transaction UAT after defect correction returned:

| Surface | Page rows | Filtered/live total | Result |
|---|---:|---:|---|
| AU active/unpublished Courses | 25 | 26,648 | PASS |
| Unpublished Scholarships | 4 | 4 | PASS |
| Evidence | 25 | 1,171 | PASS |
| Review Queue | 0 | 0 | PASS — legitimate empty state |

### Defect corrected during gate

The first Scholarship page implementation incorrectly assumed `application_windows.offering_cycle_id`.

The accepted relational schema uses `application_windows.scholarship_id` and `cycle_id`. The gate was held, the page contract was corrected, and the complete UAT was rerun successfully.

No fake data or schema weakening was used to make the UI pass.

## Browser UAT focus

After GitHub -> Cloudflare automatic publication, verify:
1. visible `UI v1.4.0` in the application shell;
2. Country/State/Level/Status filters open as searchable dropdowns and are also directly typeable;
3. keyboard arrows + Enter + Escape work in comboboxes;
4. selecting a Country narrows dependent State/Region options where authoritative data exists;
5. sorting, filtering and pagination work together;
6. opening/closing drawers preserves list state;
7. Course Provider links open Provider verification without navigation loss;
8. Scholarship Cycle/Window/Evidence counts open the appropriate relational drawer tab;
9. Evidence source links open the authoritative source in a new tab;
10. empty Review Queue is rendered cleanly;
11. Provider reference UX does not regress.

## Gate position

**UI v1.4.0 technical parity gate: PASS.**

Final live-browser acceptance remains pending Cloudflare publication/browser UAT. Future material Admin UI changes must increment the visible UI version and record the corresponding design/UAT delta.