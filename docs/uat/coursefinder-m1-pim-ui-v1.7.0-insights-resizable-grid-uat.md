# CourseFinder Admin / PIM UI v1.7.0 Insights & Resizable Grid UAT

**Date:** 19 August 2026  
**Status:** TECHNICAL PASS / LIVE BROWSER UAT PENDING

## Scope

UI v1.7.0 adds first-class `Insights / Enrichment` navigation for accepted AU Layer-2 datasets and adds persistent drag-to-resize columns as a common Admin grid primitive.

### Outcomes (QILT)

Backend contract: `public.ui_qilt_outcomes_page` + `public.ui_qilt_filter_options`.

Validated accepted corpus:
- 2,033 QILT Provider outcome observations.
- QILT surveys include GOS, SES, GOS-L and ESS.
- Provider mapping is canonical and cross-clickable.
- Filters include Survey, Metric, Provider, Year and Status.
- Evidence/source metadata is visible in row/detail context.

### Student Flow (PRISMS)

Backend contract: `public.ui_prisms_student_flow_page` + `public.ui_prisms_filter_options`.

Validated accepted corpus:
- 2,270 raw observations: 1,135 enrolments + 1,135 commencements.
- UI projection returns exactly **1,135 paired source rows** after pairing by preserved source-row grain.
- Initial projection produced 1,133 rows; investigation found two duplicated dimensional labels representing distinct authoritative source rows. The projection was corrected to include `metadata.source_row`, preventing accidental collapse.
- Current source does not publish accepted Provider/Course dimensions; UI correctly remains geography/study-area/sector scoped.
- AU-VIC + higher_education filter UAT returned 112 paired rows.

### Security

- `anon` execute on QILT page RPC: false.
- `authenticated` execute on QILT page RPC: true.
- `anon` execute on PRISMS page RPC: false.
- `authenticated` execute on PRISMS page RPC: true.

### Column resizing

UI v1.7.0 introduces a common persistent column-resize hook used by decision grids and simple Admin tables.

Expected browser UAT:
1. visible `UI v1.7.0`;
2. `Insights / Enrichment` navigation contains Outcomes (QILT) and Student Flow (PRISMS);
3. dragging a column boundary changes only that column width;
4. resize does not trigger sort or row selection;
5. refreshed page retains widths for that workspace;
6. `Reset columns` restores default widths;
7. filtering/sorting/pagination/detail behaviour remains unchanged.
