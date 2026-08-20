# CF-CHG-20260820-005 — Restore Insights / Enrichment workspaces and governed read boundary

**Status:** APPLIED / DB-RPC-SECURITY PASS + FRONTEND SOURCE PASS — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 11:05 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Admin UX regression / governed read contract / security ACL / evidence presentation

## Trigger and decision

The semantic audit after `CF-CHG-20260820-001` proved that the current Admin source had regressed the accepted first-class `Insights / Enrichment` workspaces for **Outcomes (QILT)** and **Student Flow (PRISMS)**, and also no longer used the governed common persisted column-resize primitive.

This contradicted `docs/coursefinder-admin-pim-design-decisions-v1.7.md` and prior UAT.

Live privilege inspection additionally found direct `authenticated EXECUTE` on the four public QILT/PRISMS `SECURITY DEFINER` read/filter RPCs. The restoration therefore had to preserve their proven projections but place browser access behind the hardened `public.admin_read` boundary rather than simply reconnect the frontend directly.

## Semantic contract preserved

### QILT

- Provider outcomes enrichment;
- canonical Provider cross-link allowed because accepted observations carry canonical `provider_id`;
- preserve survey, metric, value, benchmark, response count, collection year, audience, status and evidence/source context;
- QILT observations never redefine Provider identity.

### PRISMS

- aggregate geography/study-area/sector/remoteness/time source grain;
- no accepted Provider or Course dimensions in the current dataset;
- no manufactured Provider/Course link or identity;
- paired enrolments/commencements retain authoritative `source_row` in identity;
- suppression remains suppression, not zero or missing;
- evidence/source context remains visible.

## Fresh cardinality audit

Measured before the access/routing correction and unchanged after it:

| Check | Result |
|---|---:|
| QILT Provider outcome observations | 2,033 |
| PRISMS raw observations | 2,270 |
| PRISMS paired source rows | 1,135 |
| AU-VIC + higher_education paired PRISMS rows | 112 |

These exactly match the prior accepted technical UAT baseline.

## Applied DB/RPC/security correction

Pilot migration:

`m1_pim_gov_insights_admin_read_acl_v1`

Repository mirror:

`supabase/production-migrations/058_m1_pim_gov_insights_admin_read_acl.sql`

Applied behaviour:

1. private role-checked `security.admin_insights_read(text,jsonb)` dispatches accepted Insights reads;
2. `public.admin_read` now accepts `qilt_outcomes`, `qilt_filters`, `prisms_student_flow`, `prisms_filters`;
3. existing `course_detail` fee-summary overlay from `CF-CHG-20260820-001` remains intact;
4. direct authenticated EXECUTE on the four public QILT/PRISMS definer functions is revoked;
5. service-role access to the underlying projections remains available;
6. no canonical QILT/PRISMS data or pairing logic is changed.

## Role-context UAT

Executed under the existing assigned `platform_admin` identity using `role=authenticated`.

QILT governed read:

- total: 2,033;
- canonical Provider ID present;
- evidence ID present;
- source ID present;
- surveys: 4;
- Provider filter options: 105.

PRISMS governed read:

- paired total: 1,135;
- `source_row` present;
- Provider ID absent;
- Course ID absent;
- evidence URL present;
- AU-VIC + higher_education: 112;
- subdivision options: 8;
- sector options: 5.

ACL after-state:

- direct authenticated QILT page/filter execute: false;
- direct authenticated PRISMS page/filter execute: false;
- `public.admin_read` authenticated execute: true.

**DB/RPC/security verdict:** PASS.

## Cross-change regression

Exact CRICOS Course `121174E` was retested through the replaced `public.admin_read` wrapper:

- CRICOS registered fees: 3;
- Provider-current fees: 0;
- unclassified fees: 0;
- Non-Tuition Fee amount exactly zero: preserved.

`CF-CHG-20260820-001` semantics are therefore not regressed.

## Frontend source restoration — PIM Admin v2.4.0

Staged source behaviour:

- visible `PIM Admin v2.4.0`;
- `Insights / Enrichment` navigation;
- `Outcomes (QILT)` and `Student Flow (PRISMS)` workspaces;
- Insights use `adminRead` only, never direct UI RPC calls;
- server-side search/filter/sort/page semantics;
- typeable datalist-based structured filters;
- canonical Provider cross-click for QILT only;
- explicit no-Provider/Course semantic note for PRISMS;
- source/evidence detail retained;
- suppressed PRISMS values visibly labelled;
- reusable `ResizableTable` / `useGridWidths` primitive across decision grids;
- per-workspace local width persistence and `Reset columns`;
- condensed right-side detail drawer preserving list/filter state;
- package version aligned to `2.4.0`.

Changed frontend files:

- `src/main.jsx`
- `src/styles.css`
- `src/drawer-v2.4.css`
- `index.html`
- `package.json`

No canonical ingestion, Search, Zoho/Website publication or Layer 1 identity logic changed.

## UAT evidence

`docs/uat/coursefinder-m1-pim-gov-insights-v2.4.0-uat-2026-08-20.md`

Technical/source UAT passed. The current tool environment cannot independently observe the unindexed Cloudflare Worker runtime, so GitHub publication will not be treated as deployed browser proof.

## Deployed browser UAT required for closure

1. visible `PIM Admin v2.4.0`;
2. both Insights workspaces visible;
3. QILT initial total 2,033;
4. QILT filters/sort/page operate on displayed dimensions;
5. QILT Provider cross-click opens canonical Provider detail;
6. QILT source/evidence context reachable;
7. PRISMS paired total 1,135;
8. AU-VIC + higher_education returns 112;
9. PRISMS contains no Provider/Course cross-link;
10. suppression is visibly distinct from zero/missing;
11. column resize persists after refresh;
12. Reset columns restores defaults;
13. `121174E` fee presentation remains correct.

## Documentation decision

PIM Admin Guide semantic sections for QILT and PRISMS were already correct and are retained rather than duplicated. This change updates operational UAT, Change Control and programme/running-build state only.

## Rollback

Frontend source can be reverted independently. Backend rollback may restore the previous `public.admin_read` wrapper and remove the private dispatcher, but re-opening direct authenticated EXECUTE on public SECURITY DEFINER functions requires explicit security-governance approval. Canonical QILT/PRISMS observations must not be deleted to roll back an Admin change.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 11:05 AEST | AUDITED / OPEN | Current Admin source lacks accepted QILT/PRISMS workspaces and common resize primitive | `M1-PIM-GOV` |
| 20 Aug 2026 11:05 AEST | SECURITY REVIEW | Four public definer read/filter RPCs directly executable by authenticated | live Pilot privilege audit |
| 20 Aug 2026 | APPLIED | Private Insights dispatcher + admin_read routes + ACL hardening applied | `m1_pim_gov_insights_admin_read_acl_v1` |
| 20 Aug 2026 | UAT PASS — TECHNICAL | Current QILT/PRISMS cardinality, role-context routing, source grain, filters and CF-CHG-001 regression passed | Insights v2.4.0 UAT |
| 20 Aug 2026 | FRONTEND SOURCE PASS | v2.4.0 source restores Insights, semantic links, suppression handling, persistent resizing and right-side detail | feature branch |

## Closure

**Final status:** OPEN — DB/RPC/SECURITY PASS + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING  
**Closed at:** N/A  
**Outcome:** Accepted Insights semantics and security boundary restored in Pilot/source. Final closure requires deployed browser verification.
