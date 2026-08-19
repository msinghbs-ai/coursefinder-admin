# CourseFinder Admin / PIM Design Decisions v1.7

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.6.md`

v1.7 retains all prior decision-grid, visible-row filter semantics, canonical identity, evidence and low-click validation rules and adds two platform-wide standards.

## 1. Insights / Enrichment workspaces

Accepted structured Layer-2 domains must be visible as first-class Admin workspaces when their source grain is materially different from canonical Provider/Course master rows.

Current AU implementation:
- **Outcomes (QILT)** under `Insights / Enrichment`.
- **Student Flow (PRISMS)** under `Insights / Enrichment`.

The workspaces must reuse the same Admin interaction language as Catalogue/Data Quality pages where applicable:
- searchable/typeable combobox filters;
- server-side filtering, sorting and pagination;
- dense decision grids;
- visible evidence/source context;
- cross-click Provider/Course links only where the source has an accepted canonical mapping;
- condensed right-side detail without losing list state;
- visible UI version.

Source-specific workspace labels do not create source-specific canonical entities. QILT remains Provider outcomes enrichment and PRISMS remains time-scoped student-flow observations.

### QILT presentation

QILT Provider outcomes may expose Provider, Country, Survey, Metric, Value, National Benchmark, Response Count, Collection Year, Audience, Evidence and Status.

Provider is cross-clickable because the accepted QILT observations resolve to canonical Provider IDs.

### PRISMS presentation

The current accepted PRISMS source grain is geography/study-area/sector based and does not publish Provider or Course dimensions in the accepted dataset. Admin must therefore preserve that grain and must not manufacture Provider/Course mappings.

For validation efficiency, the read projection may pair `enrolments` and `commencements` from the same authoritative source row into one UI row. Pairing must preserve the published `source_row` so repeated dimensional labels do not collapse distinct source records.

## 2. Resizable columns are a common grid primitive

Decision grids and comparable Admin tables must support direct drag-to-resize column widths where desktop table density makes this useful.

Rules:
- a visible resize target is available at each column boundary;
- minimum and maximum widths prevent unusable layouts;
- user-selected widths persist locally by workspace;
- `Reset columns` restores governed defaults;
- resizing must not trigger column sorting or row selection;
- the table remains fluid to the viewport until user sizing requires horizontal scrolling;
- column-resize behaviour is implemented once as a reusable component/hook, not separately per page.

This applies to Providers, Courses, Scholarships, Outcomes, Student Flow, Evidence, Review Queue and simple PIM/Data Quality tables where applicable.

## Automation / agent principle

The preferred operating model remains minimum routine workforce with maximum safe deterministic automation and agent assistance. Insights workspaces should become human exception/validation surfaces, not manual data-entry replacements. AI may summarise or prioritise evidence-backed change but must not infer canonical identity or invent suppressed/unpublished source values.
