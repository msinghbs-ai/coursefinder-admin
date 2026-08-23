# CourseFinder M1 Performance & Responsiveness Technical Acceptance — 23 August 2026

**Workstream:** `M1-PERFORMANCE-RESPONSIVENESS`  
**Change Control:** `CF-CHG-20260823-026`  
**Pilot source under test:** `msinghbs-ai/Coursefinder-Pilot@c671bda6c8935011d074e97b2bf079bc7f72c94d`  
**Scale:** AU 26,648 Courses + NZ 6,457 Courses = 33,105 accepted Search documents; full Admin catalogue 43,461 Courses  
**Status:** UAT IN PROGRESS — deployed browser gate pending

## 1. Acceptance thresholds

These are operational acceptance budgets, not synthetic benchmark targets. They apply to the current Pilot scale and are intended to catch structural regressions before UI masking.

| Surface | Acceptance budget |
|---|---:|
| Normal DB list/filter/detail path | target <= 750 ms |
| Complex/exact-ID DB path | p95 <= 2,000 ms; hard gate <= 2,500 ms |
| Deployed interactive `admin_read` RPC | <= 3,000 ms wall time |
| Deployed detail navigation RPC | <= 3,000 ms wall time |
| Normal paged browser payload | <= 250 KB |
| Course filter-options payload | <= 350 KB |
| Page-level horizontal overflow | none at 1280×800, 1366×768 and 1440×900; wide tables scroll inside their grid container |
| HTTP/runtime errors | no unexpected 5xx; governed UAT fails on 5xx |

The Search full-refresh function is an operational batch path and is not held to the interactive RPC budget. Its acceptance criterion is deterministic dry-run/apply gating and no unnecessary generation/content mutation when unchanged.

## 2. Database/API baseline

Authenticated calls were executed through the normal Platform Admin role context and `public.admin_read(text,jsonb)`. The test did not bypass server rank checks.

| Operation | DB elapsed | Payload |
|---|---:|---:|
| Dashboard | 55.38 ms | 2.7 KB |
| Providers first page | 61.86 ms | 35.5 KB |
| Courses AU first page | 156.33 ms | 84.2 KB |
| Courses AU offset 500 | 454.67 ms | 86.7 KB |
| Courses exact `121174E` initial sample | 523.66 ms | 1.8 KB |
| Courses AU + VIC + fee + state multi-filter initial sample | 1,123.72 ms | empty-result envelope |
| Campuses AU first page | 33.29 ms | 36.3 KB |
| Scholarships first page | 3.37 ms | 3.6 KB |
| Data Quality AU+NZ cached overview | 1.52 ms | 21.1 KB |
| Pipeline jobs first page | 137.26 ms | 67.2 KB |
| Evidence first page | 40.33 ms | 44.9 KB |
| Course detail `121174E` | 428.94 ms | 12.7 KB |
| Campus detail | 309.28 ms | 9.3 KB |
| Scholarship detail | 63.92 ms | 14.9 KB |
| Provider detail | 21.03 ms | 30.7 KB |
| Provider filter options | 17.46 ms | 1.6 KB |
| Course filter options AU | 209.69 ms | 222.2 KB |
| Course filter options all-country | 352.14 ms | 273.0 KB |

The first timing harness revision accidentally accumulated elapsed time between cases. Those figures were discarded. All numbers above are independently clocked per operation in one authenticated server session.

### Repeated slow-path sample

Five-run sample after the baseline:

- exact CRICOS `121174E`: average 621.12 ms, p95 1,626.37 ms, max 1,961.38 ms;
- AU + VIC + fee + state multi-filter: average 419.52 ms, p95 680.85 ms, max 766.89 ms.

Both remain inside the explicit complex/exact-ID hard gate. No index/RPC mutation is justified solely by the measured Pilot result.

## 3. Search performance / rebuild semantics

`search.refresh_course_documents_v3(false)` was run as the governed dry-run against the complete 33,105-document AU+NZ projection:

- elapsed: 14,894.87 ms;
- base new/changed/removed: 0 / 0 / 0;
- base unchanged: 33,105;
- enrichment changed: 0;
- enrichment unchanged: 33,105;
- generation before/after: 22 / 22;
- row count before/after: 33,105 / 33,105;
- projection content hash unchanged: PASS.

Therefore the expensive full comparison is not converted into a needless APPLY/rebuild when content is unchanged.

Current Website Search v2 calls are well below the interactive budget in the all-unpublished Pilot state (representative measured calls 182.32 ms and 2.33 ms). Publication semantics remain governed separately and were not broadened for this performance gate.

## 4. Browser request audit and remediation

Source reconciliation found a concrete duplicate-read defect on `#jobs` and `#sources`:

1. PIM Admin v2.12 remained mounted and issued legacy `admin_read('jobs',{limit:200,...})` / `admin_read('sources',...)` reads;
2. the Pipeline Ops v1.0 overlay simultaneously owned those same routes and issued the accepted paged `pipeline_*` reads.

This created redundant network/database work behind the visible Pipeline Ops workspace.

Remediation in Pilot PR #29 / merge `c671bda6...` suppresses only the legacy `jobs` or `sources` request when the matching Pipeline Ops-owned hash route is active. Pipeline `pipeline_jobs_page`, `pipeline_sources_page`, filters/detail and other Admin calls are unchanged.

**Semantic impact:** none. No identity, authority, field, grain, Search admission or publication semantics change.

## 5. Paged/full-table/payload findings

- modern Provider/Course/Campus/Scholarship lists are server-paged at 50 rows and bounded to 200 by the client contract;
- Pipeline Jobs/Sources use server-paged 50-row contracts after duplicate-route suppression;
- Evidence is server-paged;
- Data Quality aggregate is a cached snapshot and exception drill-down is live/paged;
- legacy high-limit dispatcher branches remain server-side compatibility surfaces but are not accepted as justification for browser full-table loading;
- Course filter options are currently the largest normal catalogue-support payload at approximately 222 KB for AU and 273 KB all-country. They are inside the 350 KB gate but should not be allowed to grow unbounded as Provider scale increases.

## 6. Responsive source acceptance

The PIM layout uses `minmax(0,1fr)` shell columns, `min-width:0` main/panels and `.m-table-wrap { overflow:auto; max-width:100% }`. Course tables deliberately retain a wide internal table with a sticky first column; the acceptance requirement is therefore internal grid scrolling, not destructive column compression.

Automated deployed tests cover 1440×900, 1366×768 and 1280×800 and assert that document-level horizontal overflow does not exceed the viewport.

## 7. Automated deployed browser gate

Pilot adds `tests/uat/performance-deployed.spec.mjs` to the promoted `.github/workflows/deployed-uat.yml` suite. It covers:

- Providers, Courses, Campuses, Scholarships, Evidence and Data Quality RPC/payload budgets;
- exact CRICOS lookup `121174E`;
- Course detail opening;
- list paging;
- browser Back navigation;
- Pipeline Ops Jobs/Sources route ownership and absence of legacy duplicate reads;
- responsive containment at the three accepted laptop/desktop viewports;
- unexpected 5xx failure evidence.

The existing Data Quality deployed suite remains in the same promoted workflow and continues to execute on desktop and mobile.

## 8. Security / advisors

No database DDL or privilege change was made by this gate. `public.admin_read` remains SECURITY INVOKER and private `security.*` functions retain the existing role-checked boundary. Supabase performance advisors show no performance-severity blocker for this workstream; existing informational unused-index/unindexed-FK observations are not evidence of an interactive regression in the measured paths.

## 9. Final gate

**Current verdict:** UAT IN PROGRESS.  
The record is to be closed only after the merged deployed browser workflow reports PASS or a reproducible blocker is recorded with evidence.
