# Milestone 2 Execution Addendum A10 — Paged Filters, Dependent Scope Options & Tablet Focus

**Status:** AUTHORITATIVE EXECUTION ADDENDUM  
**Effective:** 27 August 2026  
**Applies to:** M2.4.2 and all later Admin/PIM browser work unless explicitly superseded.

This addendum extends PROJECT_INSTRUCTIONS.md, Milestone 2 Standing Instructions and A1–A8.

## Purpose

Large filter/dropdown option sets must not be eagerly loaded into the browser or force keyboard focus on touch/tablet devices. The Admin must remain responsive as countries, providers, universities, Courses and reference vocabularies grow.

## Platform-wide filter rule

For every operator-facing filter, dropdown, combobox or scope selector:

- 10 options is the maximum normal page size;
- if more than 10 values exist, options must be paged or searched incrementally;
- do not preload the complete option universe merely to open a screen;
- server-side option paging/search is required for large/dynamic domains;
- client-side rendering must also remain capped at 10 visible options per page;
- a selected value must remain labelled even when it is not in the current option page;
- dependent filters must be resolved from current parent scope rather than global option lists;
- changing a parent filter clears invalid child selections;
- option counts/has-more state should be returned where useful without returning the entire list.

Examples covered by this rule include Provider, University, State/Region, Campus, Study level, Field, Delivery, source, Job, Evidence type and other growing governed dimensions.

Small fixed enums of 10 or fewer values may remain local/static.

## Tablet / touch focus rule

Opening a filter or dropdown on a coarse-pointer/touch-first device must not automatically focus a search input and summon the on-screen keyboard.

- No unconditional `autoFocus` in shared filter popovers.
- Desktop/fine-pointer users may receive search focus when useful.
- Tablet/touch users explicitly tap the search field when they want to type.
- Opening and paging a dropdown must preserve the trigger/button focus and must not move the page cursor unexpectedly.
- Keyboard accessibility on desktop remains mandatory.

## Layer 2 dependent scope rule

Layer 2 scope selectors are dependent:

`Country → State → Universities in State`

and

`Country → University`.

When **State** scope is selected:
- the State selector identifies the governed subdivision;
- the preview must visibly list **all universities included in that State scope**;
- university display is paged 10 at a time;
- the list is informational for State scope and does not require individually selecting each university;
- scope counts/batches must reconcile to exactly those universities and their eligible Courses.

When University scope is selected, university options must use the same 10-item paging/search contract once more than 10 options exist.

## Course-screen priority

The Course catalogue is the priority platform-wide implementation because it contains the broadest filter surface.

Provider, State/Region, Study level, Field and Delivery option loading must move away from complete browser-side lists. Large filter option searches must execute server-side and return no more than 10 results per page.

Course result pagination remains separate from filter-option pagination.

## Backend contract

Large option endpoints must accept, as applicable:
- parent scope (country/state/provider);
- filter kind;
- search term;
- limit, hard-capped to 10;
- offset/cursor;
- selected value when needed to preserve the current label.

They should return:
- items;
- total;
- limit;
- offset/cursor;
- has_more.

No private table or credential exposure is authorised.

## UAT

Targeted browser/API UAT must prove:
- Layer 2 State scope lists every included university and pages after 10;
- selecting a State does not expose universities outside that State;
- Course Provider filter never returns/renders more than 10 options per page;
- searching a Course Provider filter can find an option outside the initial page;
- selected option label persists after paging/search;
- changing Country/State clears invalid dependent selections;
- tablet/coarse-pointer dropdown open does not focus the search input;
- desktop keyboard navigation/search remains functional;
- opening filters does not bulk-fetch complete Provider/University lists;
- no regression to catalogue result pagination, role/RBAC or private-schema boundaries.

## Rollout rule

A10 is platform-wide. M2.4.2 must implement it for Layer 2 scope and Course filters. Other large filter surfaces discovered during M2 must be migrated to the same shared paged-filter pattern before their next acceptance gate rather than creating new bespoke dropdowns.
