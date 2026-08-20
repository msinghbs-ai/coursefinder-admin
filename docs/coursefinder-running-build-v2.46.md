# CourseFinder Running Build v2.46

**Status:** CURRENT GOVERNED SOURCE BUILD — CLOUDFLARE RUNTIME OBSERVATION PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.45.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.42.md`  
**Fee semantic UAT:** `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`  
**Insights restoration UAT:** `docs/uat/coursefinder-m1-pim-gov-insights-v2.4.0-uat-2026-08-20.md`

## Build delta

v2.46 preserves the accepted Layer 1, Layer 2, Search and fee-semantic state and restores the previously governed Admin `Insights / Enrichment` contract.

### PIM Admin source version

**PIM Admin v2.4.0**

Restored workspaces:

- Outcomes (QILT)
- Student Flow (PRISMS)

Restored common UX primitive:

- drag-to-resize columns;
- per-workspace local persistence;
- Reset columns;
- condensed right-side detail preserving list/filter state.

### Governed Insights read boundary

Pilot migration:

`m1_pim_gov_insights_admin_read_acl_v1`

Repository mirror:

`supabase/production-migrations/058_m1_pim_gov_insights_admin_read_acl.sql`

Browser access now uses `public.admin_read` → private role-checked `security.admin_insights_read`.

Direct authenticated EXECUTE has been removed from:

- `public.ui_qilt_outcomes_page(...)`
- `public.ui_qilt_filter_options(text)`
- `public.ui_prisms_student_flow_page(...)`
- `public.ui_prisms_filter_options()`

The underlying accepted projections remain unchanged and service-role accessible.

## Insights UAT

Fresh live state:

- QILT Provider outcomes: 2,033
- QILT surveys: 4
- QILT Provider filter options: 105
- PRISMS raw observations: 2,270
- PRISMS paired source rows: 1,135
- PRISMS AU-VIC + higher_education paired rows: 112
- PRISMS subdivision options: 8
- PRISMS sector options: 5

Role-context UAT under assigned Platform Admin passed.

Semantic controls proven:

- QILT retains canonical Provider ID and evidence/source context;
- PRISMS retains `source_row` and evidence but contains no Provider/Course IDs;
- no Provider/Course identity is manufactured for PRISMS;
- suppression remains a distinct state;
- direct browser execution of the four public definer functions is removed.

## Fee semantic regression

Exact CRICOS `121174E` was retested after the `admin_read` wrapper change:

- CRICOS fee rows: 3
- Provider-current fee rows: 0
- other fee rows: 0
- zero Non-Tuition Fee: preserved

PIM Admin v2.4.0 retains all v2.3.0 fee presentation rules from `CF-CHG-20260820-001`.

## Preserved AU Layer 1 baseline

- Providers: 1,546
- active CRICOS Courses: 26,648
- production adapter: `layer1-au-depth-v1.6.0`
- missing Study Level: 0
- 34 Campus gaps: authoritative source absence
- unexplained Layer 1 mapping defects: 0

## Preserved AU Course Facts state

- qualified production-fetchable sources: RMIT + UQ
- exact bounded CRICOS Courses: 10
- official Course links: 10
- Provider-current international fees: 10
- intakes: 18
- governed English requirements: 32
- QUT: DEFERRED / source-specific HTTP 403 blocker

## Search isolation

- Search Course Documents: 33,105
- fee/intake/English enrichment admitted: 0

No Admin restoration grants Search/Website/Zoho publication.

## Change Control

- `CF-CHG-20260820-001` — DB-RPC-GOVERNANCE + frontend source PASS / deployed browser UAT pending
- `CF-CHG-20260820-002` — CLOSED / PASS
- `CF-CHG-20260820-003` — DEFERRED
- `CF-CHG-20260820-004` — CLOSED / PASS
- `CF-CHG-20260820-005` — DB-RPC-SECURITY + frontend source PASS / deployed browser UAT pending

## Documentation decision

Updated:

- Running Build → v2.46
- Master Plan → v1.42
- Insights technical/source UAT
- Change Control record/register

Unchanged because semantics/canonical contract did not change:

- Database Architecture remains v2.10.37
- PIM Admin Guide semantic QILT/PRISMS sections remain valid
- Zoho consumer contract unchanged
- Search contract unchanged

## Remaining PIM-GOV runtime gate

The current environment still cannot independently observe the unindexed Cloudflare Worker runtime. Final deployed browser UAT must verify v2.4.0, both Insights workspaces, counts/filter semantics, QILT Provider cross-link, PRISMS no-identity rule, suppression, persisted resizing and the retained `121174E` fee presentation before `CF-CHG-001` or `005` close.
