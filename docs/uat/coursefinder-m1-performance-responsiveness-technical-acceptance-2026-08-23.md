# CourseFinder M1 Performance & Responsiveness Technical Acceptance — 23 August 2026

**Workstream:** `M1-PERFORMANCE-RESPONSIVENESS`  
**Change Control:** `CF-CHG-20260823-026`  
**Accepted Pilot source:** `msinghbs-ai/Coursefinder-Pilot@1bcb96d26f7c701ec6cf91d771016cb6405f51b2`  
**Scale:** AU 26,648 Courses + NZ 6,457 Courses = 33,105 accepted Search documents; full Admin catalogue 43,461 Courses  
**Status:** PASS

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
| HTTP/runtime errors | no unexpected 5xx in the final governed run |

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

## 3. Final deployed browser measurements

GitHub Actions run `32622164346` passed on both `chromium-desktop` and `chromium-mobile` against accepted SHA `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`.

### Desktop

| Operation | Wall time | Payload |
|---|---:|---:|
| Providers first page | 1,245 ms | 34.2 KB |
| Dashboard navigation | 475 ms | 2.5 KB |
| Dashboard browser refresh | 491 ms | 2.5 KB |
| Courses first page | 1,716 ms | 80.6 KB |
| Course filters | measured concurrently | 257.7 KB |
| Campuses first page | 539 ms | 35.4 KB |
| Scholarships first page | 388 ms | 3.4 KB |
| Evidence first page | 529 ms | 45.0 KB |
| Data Quality overview | 387 ms | 17.1 KB |
| Exact CRICOS `121174E` | 997 ms | 1.8 KB |
| Course detail | 1,023 ms | 12.3 KB |
| Next-page paging | 1,003 ms | 80.7 KB |
| Browser Back to Courses | 1,059 ms | 80.7 KB |
| Pipeline Jobs | 1,485 ms | 60.9 KB |
| Pipeline Sources | 479 ms | 44.9 KB |

### Mobile Chromium project

| Operation | Wall time | Payload |
|---|---:|---:|
| Providers first page | 1,628 ms | 34.2 KB |
| Dashboard navigation | 568 ms | 2.5 KB |
| Dashboard browser refresh | 448 ms | 2.5 KB |
| Courses first page | 1,691 ms | 80.6 KB |
| Course filters | measured concurrently | 257.7 KB |
| Campuses first page | 932 ms | 35.4 KB |
| Scholarships first page | 422 ms | 3.4 KB |
| Evidence first page | 470 ms | 45.0 KB |
| Data Quality overview | 373 ms | 17.1 KB |
| Exact CRICOS `121174E` | 1,853 ms | 1.8 KB |
| Course detail | 1,250 ms | 12.3 KB |
| Next-page paging | 802 ms | 80.7 KB |
| Browser Back to Courses | 945 ms | 80.7 KB |
| Pipeline Jobs | 869 ms | 60.9 KB |
| Pipeline Sources | 480 ms | 44.9 KB |

Every measured deployed interaction is inside the 3,000 ms wall-time gate and every paged payload is inside 250 KB. Course filter options remain inside their explicit 350 KB support-payload budget.

## 4. Search performance / rebuild semantics

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

## 5. Browser request audit and remediation

Source reconciliation found a concrete duplicate-read defect on `#jobs` and `#sources`:

1. PIM Admin v2.12 remained mounted and could issue legacy `admin_read('jobs',...)` / `admin_read('sources',...)` reads;
2. Pipeline Ops v1.0 simultaneously owned those same routes and issued the accepted paged `pipeline_*` reads.

Remediation in Pilot PR #29 suppresses only the legacy `jobs` or `sources` request when the matching Pipeline Ops-owned hash route is active. Pipeline `pipeline_jobs_page`, `pipeline_sources_page`, filters/detail and all other Admin calls remain unchanged.

The final deployed evidence proves:

- Jobs uses `pipeline_jobs_page`; no legacy `jobs` request is emitted;
- Sources uses `pipeline_sources_page`; no legacy `sources` request is emitted;
- both are inside the 3-second wall-time budget.

**Semantic impact:** none. No identity, authority, field, grain, Search admission or publication semantics change.

## 6. First deployed run and remediation evidence

The first merged run `32621741394` correctly failed rather than being waived:

- Course paging test attempted to click `Next` while the governed detail drawer was still open; the drawer intercepted the click. This was a UAT harness sequencing defect, not an application latency defect.
- Pipeline Ops timed out because the dedicated UAT principal was a Curator (rank 3) and the workspace correctly requires rank 4. The displayed `Not authorised` state confirmed the RBAC boundary.
- one existing Evidence detail request returned a transient 500 on its first attempt and passed its configured retry; the final accepted run contained no unexpected 5xx.

PR #30 corrected the interaction sequence and added explicit Dashboard browser refresh timing. For the final Pipeline browser test, the dedicated UAT principal received a temporary, audited `pipeline_operator` role with automatic expiry. Immediately after the successful run, that temporary role was explicitly removed and the principal was verified restored to its original Curator-only state.

No permanent access-policy or role-semantic change was made.

## 7. Paged/full-table/payload findings

- modern Provider/Course/Campus/Scholarship lists are server-paged at 50 rows and bounded to 200 by the client contract;
- Pipeline Jobs/Sources use server-paged 50-row contracts after duplicate-route suppression;
- Evidence is server-paged;
- Data Quality aggregate is a cached snapshot and exception drill-down is live/paged;
- legacy high-limit dispatcher branches remain server-side compatibility surfaces but are not active browser full-table paths in the accepted workspaces;
- Course filter options are currently the largest normal catalogue-support payload at approximately 258 KB in the deployed browser run and approximately 273 KB in the all-country DB baseline. They are inside the 350 KB gate but remain the clearest payload-growth watch item as Provider scale increases.

## 8. Responsive acceptance

The PIM layout uses `minmax(0,1fr)` shell columns, `min-width:0` main/panels and `.m-table-wrap { overflow:auto; max-width:100% }`. Course tables deliberately retain a wide internal table with a sticky first column; the acceptance requirement is internal grid scrolling, not destructive column compression.

Final desktop evidence:

| Viewport | Document width | Grid visible width | Grid scroll width | Verdict |
|---|---:|---:|---:|---|
| 1440×900 | 1440 | 1118 | 1610 | PASS — grid-contained horizontal scroll |
| 1366×768 | 1366 | 1044 | 1610 | PASS — grid-contained horizontal scroll |
| 1280×800 | 1280 | 958 | 1610 | PASS — grid-contained horizontal scroll |

There is no page-level horizontal overflow at the accepted laptop/desktop widths.

## 9. Security / advisors

No database DDL or application privilege contract was changed. `public.admin_read` remains SECURITY INVOKER and private `security.*` functions retain the existing role-checked boundary. Supabase performance advisors show no performance-severity blocker for this workstream; existing informational unused-index/unindexed-FK observations are not evidenced as an interactive regression in the measured paths.

The temporary UAT Pipeline Operator assignment was audit-recorded, time-limited and explicitly removed after acceptance. Final UAT principal state matches its pre-test Curator-only assignment.

## 10. Final gate

**Verdict: PASS.**

The deployed Admin/Search operational performance gate is accepted at current AU+NZ/full-Admin scale. No database index/RPC change is required from the measured evidence. The primary implementation correction is duplicate Pipeline route-read suppression, backed by automated deployed performance, payload, interaction, refresh and responsive acceptance.