# Execution Addendum A22 — Responsive Detail Blades & Cross-Viewport UI Acceptance

**Status:** ACTIVE — M2.4.4 ADDENDUM  
**Effective:** 31 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Purpose

Make Provider/Course detail blades usable as final Pilot workspaces across desktop, tablet and mobile, with one predictable scroll owner and no cramped insight/funding panels.

## A22.1 — Drawer sizing

- Provider detail: wide decision workspace on desktop; target approximately 52–62vw with a governed max width around 1,040px.
- Course detail: wider than Provider where needed for fee/QILT/PRISMS/Scholarship/Evidence sections; target approximately 58–66vw with a governed max width around 1,100px.
- Campus/Scholarship may remain narrower.
- Tablet drawers occupy approximately 94–96vw.
- Mobile drawers occupy 100vw.

## A22.2 — Scroll ownership

The drawer content region is the single vertical scroll owner beneath the sticky drawer header.

- Provider and Course details must always permit vertical scrolling when content exceeds viewport height.
- Nested detail sections must not create competing page-level scroll traps.
- Horizontal overflow is prohibited for normal detail content; wide internal data must wrap or use a deliberately bounded horizontal region.

## A22.3 — Responsive insight cards

Provider QILT/PRISMS/Scholarship/contact panels must adapt to available blade width.

- no clipped KPI cards;
- no forced horizontal page scroll for normal insight cards;
- tablet collapses multi-column insight cards progressively;
- mobile becomes single-column.

## A22.4 — Acceptance

Permanent UI UAT must cover:
1. Provider drawer desktop + tablet dimensions and vertical scroll;
2. Course drawer desktop + tablet + mobile vertical scroll;
3. no body/page horizontal overflow caused by drawer content;
4. drawer close/Evidence actions remain visible;
5. contextual cards reflow without clipping;
6. representative Provider and Course records render without runtime errors.
