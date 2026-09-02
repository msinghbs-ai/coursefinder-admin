# CF-CHG-20260902-079 — Course Comparison Provider Coverage Correction

- **Initiated:** 2026-09-02T21:07:00+10:00
- **Origin:** CourseFinder — “Bug: course comparison not all uni are available”
- **Category:** 30-admin-pim-ux
- **Change class:** Browser comparison selector defect correction
- **Status:** IMPLEMENTED / TARGETED UAT ACTIVE

## Problem

Course comparison used one global `courses_page` search and displayed only the first bounded result set. Although the governed Course search could match Provider names, a university with many matching Courses — or another provider sorting earlier — could consume the bounded results. This made valid universities appear unavailable in the Course comparison picker.

The issue was selector design, not missing canonical Provider/Course data.

## Correction

Course comparison now supports a Provider-first selection flow:

1. search **University / provider** through governed `providers_page`;
2. select any governed Provider;
3. Course search is then scoped with `provider_id`;
4. the picker automatically loads the first governed Courses for that Provider;
5. the operator can narrow by Course title/code;
6. **All providers** clears the scope and restores global Course search.

Global Course search remains available when no Provider is selected. The comparison maximum remains six Courses.

## Data / authority impact

No database or authority mutation was introduced.

Unchanged:
- Provider and Course identity;
- Course catalogue content;
- QILT / PRISMS grain;
- QS / THE ranking context;
- Search and Publication admission;
- Zoho / Website consumers;
- comparison maximum of six entities.

The correction uses existing governed browser RPC operations:
- `providers_page`;
- `courses_page` with existing `provider_id` filtering;
- `contextual_compare`.

## Runtime truth checked

Pilot database confirms the Course catalogue is already Provider-linked and the existing `security.admin_course_page_fast_base(jsonb)` supports exact `provider_id` scoping. No new SQL function is required.

## Implementation

Coursefinder-Pilot:
- `src/ComparisonWorkspace.jsx`
  - provider search state/results;
  - Provider-first Course selection;
  - provider-scoped Course page read;
  - anchored scoped Course results;
  - clear Provider scope.
- release **v2.15.40**:
  - `src/mature-main.jsx`;
  - `src/pim-version-entry.js`;
  - `index.html`.
- acceptance:
  - source/build contract updated;
  - deployed comparison test now selects Adelaide University first and verifies returned Course rows are scoped to that Provider;
  - CF-079 deployed candidate routing added.

Implementation commits:
- `51f15f2775d028e5e52ba11bb8015c9f167a8e57`
- `a2203904bde3f3ff474ba9e9723dba29c6a4ad16`
- `0cfa576621df5a7c76d7ba06a67e8f2b504aaede`
- `cebbdec1dfe1eb35b513e8b2cecf4f2f83b232df`
- `f3af3a13a8351ab9f58a6e6bc882d40e221461ab`
- `adf3ba21b4c490255b71fe80841acf5c49c6b36c`
- `1f3dc58c88b8e2c7ccf8e1d41303df35f74792a9`
- `6bb0a7a8bf73608a5a4f675babf1c1fb914210a6`

## UAT acceptance

Targeted deployed comparison UAT must prove:

1. current Admin release is v2.15.40;
2. Course comparison exposes **Search universities or providers**;
3. Adelaide University can be returned from the governed Provider search;
4. choosing it causes `courses_page` to execute with that exact `provider_id`;
5. returned Course rows belong to Adelaide University;
6. Course result cards become available without entering a Course search term;
7. existing Provider comparison and Course-detail-to-Compare journeys remain valid;
8. no server 5xx errors occur.

## Rollback

Revert the CF-079 UI/release/test commits above. No database rollback is required.
