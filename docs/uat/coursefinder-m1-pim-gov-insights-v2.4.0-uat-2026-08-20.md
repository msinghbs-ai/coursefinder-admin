# CourseFinder M1-PIM-GOV Insights Restoration UAT — PIM Admin v2.4.0

**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-005`  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Status:** **DB/RPC/SECURITY + FRONTEND SOURCE UAT PASS — DEPLOYED BROWSER UAT PENDING**

## Purpose

Restore the previously accepted `Insights / Enrichment` Admin contract for QILT Provider Outcomes and PRISMS Student Flow after the current Admin source no longer exposed those workspaces, while preserving later PIM security hardening.

No canonical QILT/PRISMS observation, Provider/Course identity, Search projection or consumer admission is changed.

## Authoritative UX contract

- `docs/coursefinder-admin-pim-design-decisions-v1.7.md`
- prior UAT: `docs/uat/coursefinder-m1-pim-ui-v1.7.0-insights-resizable-grid-uat.md`

Required semantics:

- QILT is Provider outcomes enrichment and may cross-link canonical Provider IDs;
- PRISMS is geography/study-area/sector/time scoped and must not manufacture Provider/Course identity;
- PRISMS enrolment/commencement pairing preserves authoritative `source_row` grain;
- evidence/source context remains visible;
- decision grids use server-side filter/sort/page behaviour where appropriate;
- column resizing is a reusable persisted primitive with Reset columns.

## Fresh live corpus baseline

Measured before the access/routing migration:

| Check | Current live result | Prior accepted result | Verdict |
|---|---:|---:|---|
| QILT Provider outcome observations | 2,033 | 2,033 | PASS |
| PRISMS raw observations | 2,270 | 2,270 | PASS |
| PRISMS distinct source rows | 1,135 | 1,135 | PASS |
| PRISMS AU-VIC + higher_education paired rows | 112 | 112 | PASS |

The restoration therefore begins from the same accepted source cardinality; no data repair is required.

## Applied migration

Pilot migration:

`m1_pim_gov_insights_admin_read_acl_v1`

Repository mirror:

`supabase/production-migrations/058_m1_pim_gov_insights_admin_read_acl.sql`

The migration:

1. creates private role-checked `security.admin_insights_read(text,jsonb)`;
2. routes `qilt_outcomes`, `qilt_filters`, `prisms_student_flow`, `prisms_filters` through `public.admin_read`;
3. preserves the `CF-CHG-20260820-001` Course fee-summary overlay in the same governed wrapper;
4. revokes direct `authenticated` EXECUTE from the four public QILT/PRISMS `SECURITY DEFINER` projection/filter functions;
5. keeps service-role access for the underlying projections;
6. does not alter QILT/PRISMS canonical observations or the proven PRISMS pairing projection.

## ACL UAT

After migration:

| Function | direct authenticated EXECUTE |
|---|---|
| `ui_qilt_outcomes_page(...)` | false |
| `ui_qilt_filter_options(text)` | false |
| `ui_prisms_student_flow_page(...)` | false |
| `ui_prisms_filter_options()` | false |
| `admin_read(text,jsonb)` | true |

**Verdict:** PASS.

## Governed role-context UAT

Tests were executed under the existing assigned `platform_admin` identity with `role=authenticated`, not merely as database owner.

### QILT

`admin_read('qilt_outcomes', {limit:5})` returned:

- total: 2,033;
- returned: 5;
- canonical `provider_id`: present;
- `evidence_id`: present;
- `source_id`: present.

Filter contract returned:

- QILT surveys: 4;
- Provider options: 105.

**Verdict:** PASS.

### PRISMS

`admin_read('prisms_student_flow', {limit:5})` returned:

- total paired rows: 1,135;
- `source_row`: present;
- Provider ID: absent;
- Course ID: absent;
- evidence URL: present.

Filtered `AU-VIC + higher_education` total through governed `admin_read`: **112**.

Filter contract returned:

- subdivision options: 8;
- sector options: 5.

**Verdict:** PASS.

## Cross-change regression — CRICOS fee semantics

The replacement `public.admin_read` wrapper was explicitly tested against exact Course `121174E` after the Insights migration.

Result:

- `fee_summary.cricos_registered`: 3 rows;
- `fee_summary.provider_current`: 0;
- `fee_summary.other`: 0;
- `non_tuition` rows with amount exactly 0: 1.

**Verdict:** PASS — `CF-CHG-20260820-001` fee semantics remain intact.

## Frontend source restoration — PIM Admin v2.4.0

Staged frontend contract:

- visible UI version: `PIM Admin v2.4.0`;
- `Insights / Enrichment` navigation group;
- `Outcomes (QILT)` workspace;
- `Student Flow (PRISMS)` workspace;
- all Insights reads use the existing `adminRead` client boundary, never direct QILT/PRISMS RPC calls;
- QILT Provider name is a canonical Provider cross-link via `provider_detail`;
- PRISMS explicitly presents itself as source-grain only and contains no Provider/Course link;
- server-side query/filter/sort/page arguments use the accepted projection contracts;
- typeable datalist-based filters are provided for structured dimensions;
- row detail preserves source/evidence context without losing list state;
- suppressed PRISMS values are visibly labelled, not converted to zero;
- common `ResizableTable`/`useGridWidths` primitive is used for decision grids;
- widths persist in local storage per workspace;
- `Reset columns` restores governed defaults;
- package version aligned to `2.4.0`.

Source files changed:

- `src/main.jsx`
- `src/styles.css`
- `package.json`

## Source isolation check

Feature branch was created directly from the current governed `main` baseline and remained ahead-only during implementation. The change set is limited to:

- Change Control record/register;
- one mirrored read/ACL migration;
- three frontend files;
- UAT/governance documents.

No canonical ingestion, Layer 1, Search or Zoho implementation file is changed.

## Deployed browser UAT still required

Because this environment cannot independently observe the unindexed Cloudflare Worker runtime, final runtime acceptance must verify after GitHub-triggered deployment:

1. visible `PIM Admin v2.4.0`;
2. navigation includes `Insights / Enrichment` with both workspaces;
3. QILT initial total is 2,033;
4. QILT filters, sorting and paging act on the visibly labelled dimensions;
5. clicking a QILT Provider opens the canonical Provider detail;
6. QILT evidence/source context is reachable;
7. PRISMS initial paired total is 1,135;
8. AU-VIC + higher_education returns 112;
9. PRISMS contains no Provider/Course cross-link;
10. suppressed PRISMS values remain visibly suppressed;
11. resize one column, refresh, confirm width persists;
12. `Reset columns` restores defaults;
13. exact Course `121174E` still displays the v2.3 governed fee semantics.

## Verdict

**Canonical data:** unchanged / PASS  
**QILT governed read:** PASS  
**PRISMS governed read:** PASS  
**PRISMS source-row grain:** PASS  
**Security ACL:** PASS  
**CF-CHG-001 fee regression:** PASS  
**Frontend source semantics:** PASS  
**Cloudflare deployed/browser UAT:** PENDING  

`CF-CHG-20260820-005` remains OPEN until deployed browser UAT passes.
