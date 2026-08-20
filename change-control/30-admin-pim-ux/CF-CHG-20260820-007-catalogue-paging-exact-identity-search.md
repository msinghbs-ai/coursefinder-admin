# CF-CHG-20260820-007 — Catalogue paging and exact identity search

**Status:** OPEN / AUDITED — IMPLEMENTATION IN PROGRESS  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 11:37 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Admin catalogue retrieval / exact identity / decision-grid correctness / security ACL

## Trigger

The semantic audit proved that the current Catalogue screens client-filter capped snapshots rather than searching the full canonical catalogue.

Current v2.5 source requests:

- Providers: `limit=1000`;
- Courses: `limit=2000`;
- Campuses: `limit=1000`;
- Scholarships: `limit=1000`.

Fresh live canonical counts are substantially larger:

- active Providers: 3,085 across the current multi-country catalogue;
- active Courses: 35,487;
- Campuses: 3,922;
- Scholarships: 4.

Role-context UAT on the existing governed list routes returned exactly 1,000 Providers, 2,000 Courses and 1,000 Campuses. Exact CRICOS Course Code `121174E` was **not present in the 2,000-row Course slice**.

Therefore the current Course screen cannot reliably perform the project’s mandatory exact-identifier reconciliation even though the canonical Course exists.

## Identity rule

Admin search must operate over the full governed catalogue. Client-side filtering of a capped slice is not identity resolution.

For AU Course audit, exact CRICOS Course Code under the correct Provider remains the governed identity path. Title-only matching remains forbidden.

## Existing page projections

The live Pilot already contains server-side page/search projections for Providers, Courses and Scholarships. The Course decision projection can resolve exact `121174E` across the complete catalogue.

However the existing Course decision page still derives `completeness_score` from `search.course_documents`, which is incompatible with `CF-CHG-20260820-001` because Admin canonical-presence readiness must remain independent of Search publication state.

The accepted implementation must therefore combine:

1. full server-side paging/search;
2. the canonical six-signal Admin presence formula from `CF-CHG-001`;
3. deterministic CRICOS tuition display semantics;
4. hardened `public.admin_read` browser routing;
5. no direct browser EXECUTE on underlying SECURITY DEFINER page functions used by the restored catalogue route.

## Required frontend behaviour

- Providers, Courses and Campuses use server-side paging/search across the full catalogue;
- Scholarships may use the same paged pattern despite the current small corpus;
- exact Course search `121174E` returns the single canonical Swinburne Course;
- Course grid retains `CRICOS tuition (total course)` semantics;
- Admin readiness/completeness remains canonical-presence based, never Search-score based;
- pagination does not lose current search/filter state;
- persistent column widths and right-side detail remain intact;
- visible UI version increments;
- no title-only identity path is introduced.

## Security requirement

Any public SECURITY DEFINER page/list RPC connected to the new browser route must not remain directly executable by `authenticated`. Browser access should remain behind the governed role-checked `public.admin_read` contract.

## UAT required

1. full totals are returned by page routes rather than capped list sizes;
2. exact `121174E` search returns one canonical Course;
3. returned Course UUID/stable key/Provider/CRICOS code match the accepted reference;
4. canonical fee presence remains true and CRICOS tuition remains deterministic;
5. completeness/readiness uses the six canonical signals, not Search score;
6. Provider/Campus search works outside the old first-1,000 slice;
7. direct authenticated page/list definer execution is removed where routed through the new browser contract;
8. `CF-CHG-001`, `005` and `006` regression tests remain PASS;
9. deployed authenticated browser UAT after release.

## Rollback

Revert the paged frontend route and governed dispatcher independently. Do not delete catalogue records or alter identity to roll back an Admin retrieval change. Reopening direct authenticated EXECUTE on SECURITY DEFINER projections requires explicit security-governance approval.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 11:37 AEST | AUDITED / OPEN | Capped client-side catalogue search proven unable to reach exact `121174E` | `M1-PIM-GOV` / role-context Pilot UAT |

## Closure

**Final status:** OPEN / IMPLEMENTATION IN PROGRESS  
**Closed at:** N/A  
**Outcome:** Pending governed server-side catalogue paging/search restoration and UAT.
