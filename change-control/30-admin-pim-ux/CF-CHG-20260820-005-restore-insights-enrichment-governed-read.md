# CF-CHG-20260820-005 — Restore Insights / Enrichment workspaces and governed read boundary

**Status:** OPEN / AUDITED — IMPLEMENTATION IN PROGRESS  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 11:05 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Admin UX regression / governed read contract / security ACL / evidence presentation

## Trigger

The full Admin semantic audit after `CF-CHG-20260820-001` found that current PIM Admin source no longer exposes the previously accepted first-class `Insights / Enrichment` workspaces for:

- Outcomes (QILT)
- Student Flow (PRISMS)

This conflicts with authoritative `docs/coursefinder-admin-pim-design-decisions-v1.7.md` and the prior technical UAT `docs/uat/coursefinder-m1-pim-ui-v1.7.0-insights-resizable-grid-uat.md`.

The same audit found that the four existing QILT/PRISMS public read RPCs are `SECURITY DEFINER` and still directly executable by `authenticated`, which conflicts with the later hardened browser-read model centred on `public.admin_read`.

## Accepted semantic contract being restored

### QILT

QILT is Provider outcomes enrichment. It may resolve/cross-link to canonical Provider because accepted QILT observations carry canonical `provider_id`.

Preserve source grain and expose, where available:

- Provider
- Country
- Survey
- Metric
- Value
- National Benchmark
- Response Count
- Collection Year
- Audience
- Evidence/source
- Status

### PRISMS

Current accepted PRISMS Student Flow is geography/study-area/sector/time scoped. It does **not** provide accepted Provider or Course dimensions.

Admin must therefore:

- not manufacture Provider or Course links;
- preserve source geography, study area, sector, remoteness and period;
- pair `enrolments` and `commencements` only using the governed projection;
- preserve `metadata.source_row` in pairing identity so repeated dimensional labels never collapse distinct authoritative rows;
- retain suppression state and evidence/source context.

## Existing accepted backend projections

The live Pilot already contains:

- `public.ui_qilt_outcomes_page(...)`
- `public.ui_qilt_filter_options(text)`
- `public.ui_prisms_student_flow_page(...)`
- `public.ui_prisms_filter_options()`

Prior accepted corpus/UAT recorded:

- QILT Provider outcome observations: 2,033
- QILT surveys: GOS, SES, GOS-L, ESS
- PRISMS raw observations: 2,270
- PRISMS paired source rows: 1,135
- AU-VIC + higher_education paired PRISMS rows: 112

Fresh UAT must re-measure these values; prior counts are evidence, not a substitute for current verification.

## Security defect

Live privilege inspection on 20 August 2026 found `authenticated EXECUTE = true` for all four public QILT/PRISMS `SECURITY DEFINER` read RPCs.

The accepted correction is:

1. keep the proven read projections and their source-grain semantics;
2. route QILT/PRISMS browser reads through a private role-checked Insights dispatcher behind `public.admin_read`;
3. revoke direct `authenticated` execution from the four public definer RPCs;
4. retain service-role access only where operationally required;
5. do not expose internal schemas directly to the browser.

## Frontend regression

Current PIM Admin v2.3.0 navigation contains Catalogue, Governance, Operations and PIM workspaces but no QILT or PRISMS workspace. It also lacks the previously governed common persistent resizable-column primitive.

Restoration requirements:

- `Insights / Enrichment` navigation group;
- `Outcomes (QILT)` workspace;
- `Student Flow (PRISMS)` workspace;
- server-side filtering, sorting and pagination;
- searchable/typeable filters where practical;
- dense decision grids;
- evidence/source visibility;
- QILT Provider cross-click only where canonical `provider_id` exists;
- no Provider/Course cross-link for PRISMS;
- condensed detail without destroying list/filter state;
- persistent column widths via a reusable common primitive;
- `Reset columns`;
- visible UI version increment.

## Affected surfaces

- `public.admin_read(text,jsonb)`
- new private `security` Insights read helper
- execute ACLs on four QILT/PRISMS public UI functions
- `src/main.jsx`
- `src/styles.css`
- package/UI version
- Admin Guide / UAT / Running Build / Master Plan / Change Control

No QILT or PRISMS canonical observation, Provider/Course identity, source evidence, Search admission or Zoho/Website consumer admission is changed by this restoration.

## UAT required

### Backend/security

1. assigned Admin role can retrieve QILT/PRISMS through `public.admin_read`;
2. direct `authenticated` EXECUTE on all four legacy public definer functions is false;
3. unauthenticated/no-role access fails closed;
4. QILT results retain canonical Provider IDs and evidence/source context;
5. PRISMS results contain no manufactured Provider/Course mapping;
6. PRISMS paired total preserves `source_row` grain;
7. filter/sort/pagination semantics match displayed dimensions.

### Frontend

1. visible new UI version;
2. Insights / Enrichment contains both required workspaces;
3. QILT Provider cross-click opens canonical Provider detail;
4. PRISMS has no Provider/Course cross-link;
5. evidence/source context is reachable;
6. suppression is visible rather than converted to zero/missing;
7. column resize persists per workspace and Reset columns restores defaults;
8. filters operate on the visibly labelled dimension;
9. deployed browser UAT after runtime release.

## Rollback

- restore preceding `public.admin_read` definition;
- remove the private Insights dispatcher if unused;
- restoring direct browser EXECUTE on the four public definer functions requires explicit security-governance approval and is not the preferred rollback;
- restore preceding frontend source/version if UI regression occurs;
- never delete QILT/PRISMS canonical observations to roll back an Admin change.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 11:05 AEST | AUDITED / OPEN | Current Admin source lacks accepted QILT/PRISMS workspaces and common resize primitive | `M1-PIM-GOV` |
| 20 Aug 2026 11:05 AEST | SECURITY REVIEW | Four QILT/PRISMS public SECURITY DEFINER read RPCs confirmed directly executable by `authenticated`; restoration must use governed read boundary | live Pilot privilege audit |

## Closure

**Final status:** OPEN / IMPLEMENTATION IN PROGRESS  
**Closed at:** N/A  
**Outcome:** Pending governed read/ACL restoration, frontend parity restoration and UAT.
