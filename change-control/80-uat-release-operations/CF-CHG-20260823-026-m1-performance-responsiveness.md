# CF-CHG-20260823-026 — M1 Performance & Responsiveness Gate

**Status:** APPLIED / DEPLOYED UAT IN PROGRESS  
**Category:** 80-uat-release-operations  
**Initiated:** 23 August 2026 15:51 AEST  
**Origin chat/workstream:** M1-PERFORMANCE-RESPONSIVENESS  
**Owner:** CourseFinder M1 operational performance workstream  
**Change class:** operations / UAT / performance

## Trigger

Explicit M1 full-scale Admin/Search operational performance gate requested against the real deployed AU+NZ Pilot rather than relying on subjective frontend responsiveness.

## Problem / requested outcome

Measure real browser/API/database behaviour for Dashboard, Providers, Courses, Campuses, Scholarships, Evidence, Jobs/Pipelines, Completeness, Search, detail opening, exact-ID lookup, multi-filter queries, paging, navigation/back and refresh. Identify N+1 RPCs, full-table browser loads, oversized payloads, redundant requests, slow SECURITY DEFINER paths and unnecessary Search rebuilds. Establish practical thresholds and validate common laptop/desktop responsive layouts.

## Affected surfaces / related workstreams

- Pilot browser application and deployed UAT harness;
- `public.admin_read(text,jsonb)` and delegated private `security.*` read functions;
- catalogue/search/pipeline/evidence/data-quality read paths;
- Search `course-v3` read/rebuild behaviour only; no vector admission;
- M1-PIM-FINALISATION, M1-EVIDENCE-UX, M1-PIPELINE-OPS, M1-DATA-QUALITY-READINESS, M1-UAT-HARNESS and M1-SEARCH-ENRICHMENT.

## Semantic impact

No canonical identity, field meaning, source authority, grain/cardinality, lifecycle, publication, Search-admission or Zoho semantic change is made by this gate. The accepted remediation is browser route/request ownership only. No database DDL or privilege change was required.

## Before

PIM v2.12 and the accepted capability surfaces were operational, and deployed desktop/mobile UAT was passing, but there was no single full-scale performance acceptance record spanning all operational workspaces. In addition, `#jobs` and `#sources` were owned visibly by Pipeline Ops v1.0 while the underlying PIM shell also issued legacy `jobs` / `sources` reads, creating redundant hidden network/database work.

## After

- measurable DB/API/browser thresholds are explicit and automated;
- the accepted Provider/Course/Campus/Scholarship/Evidence/Data Quality paths remain server-paged/cached as designed;
- `#jobs` and `#sources` suppress only the underlying legacy request while Pipeline Ops owns the route and continues using paged `pipeline_*` contracts;
- Search full-refresh dry-run proves unchanged content does not advance generation or trigger an APPLY;
- responsive browser acceptance checks common 1280/1366/1440 desktop/laptop widths for page-level overflow.

## Source authority / evidence

- `PROJECT_INSTRUCTIONS.md`;
- Change Control register current through `CF-CHG-20260823-025` at initiation;
- Master Project Plan v1.64;
- Running Build v2.66;
- Database Architecture v2.10.40;
- Admin/PIM Design Decisions v1.13;
- pre-change Pilot runtime `msinghbs-ai/Coursefinder-Pilot@16ce78e25e78c2324e056a7b8cb6024d4a0428a8`;
- candidate/merged Pilot runtime `msinghbs-ai/Coursefinder-Pilot@c671bda6c8935011d074e97b2bf079bc7f72c94d`;
- live Supabase project `coursefinder_Pilot`;
- dedicated technical acceptance `docs/uat/coursefinder-m1-performance-responsiveness-technical-acceptance-2026-08-23.md`.

## Implementation references

- Supabase migration(s): none — measured DB paths did not justify DDL;
- Pilot PR: `msinghbs-ai/Coursefinder-Pilot#29`;
- Pilot merge: `c671bda6c8935011d074e97b2bf079bc7f72c94d`;
- source remediation: `src/lib/supabase.js` route ownership guard for legacy `jobs` / `sources` only;
- deployed UAT: `tests/uat/performance-deployed.spec.mjs` added to `.github/workflows/deployed-uat.yml`;
- RPC/API objects measured: `public.admin_read`, delegated `security.*` read functions, `api.website_course_search_v2`, `search.refresh_course_documents_v3(false)`;
- UI version: PIM Admin v2.12 retained; no visible version claim is required for a network/request ownership fix.

## Acceptance thresholds

- normal DB list/filter/detail target: <= 750 ms;
- complex/exact-ID DB p95: <= 2,000 ms; hard gate <= 2,500 ms;
- deployed interactive/read/detail RPC wall time: <= 3,000 ms;
- normal paged browser payload: <= 250 KB;
- Course filter-options payload: <= 350 KB;
- no unexpected 5xx;
- no page-level horizontal overflow at 1280×800, 1366×768 or 1440×900; wide tables scroll inside their grid container.

Search full-refresh is a batch operation and is judged on deterministic change detection / no-op behaviour rather than the interactive latency budget.

## UAT — authenticated database/API

Initial live Pilot baseline, independently clocked per operation:

- Dashboard: 55.38 ms / 2.7 KB;
- Providers first page: 61.86 ms / 35.5 KB;
- Courses AU first page: 156.33 ms / 84.2 KB;
- Courses AU offset 500: 454.67 ms / 86.7 KB;
- Courses exact `121174E`: 523.66 ms / 1.8 KB initial sample;
- Courses AU+VIC+fee+state multi-filter: 1,123.72 ms initial sample;
- Campuses AU first page: 33.29 ms / 36.3 KB;
- Scholarships first page: 3.37 ms / 3.6 KB;
- Data Quality AU+NZ cached overview: 1.52 ms / 21.1 KB;
- Pipeline jobs first page: 137.26 ms / 67.2 KB;
- Evidence first page: 40.33 ms / 44.9 KB;
- Course detail `121174E`: 428.94 ms / 12.7 KB;
- Campus detail: 309.28 ms / 9.3 KB;
- Scholarship detail: 63.92 ms / 14.9 KB;
- Provider detail: 21.03 ms / 30.7 KB;
- Provider filter options: 17.46 ms / 1.6 KB;
- Course filter options AU: 209.69 ms / 222.2 KB;
- Course filter options all-country: 352.14 ms / 273.0 KB.

Five-run slow-path sample:

- exact CRICOS `121174E`: average 621.12 ms / p95 1,626.37 ms / max 1,961.38 ms — PASS;
- AU+VIC+fee+state multi-filter: average 419.52 ms / p95 680.85 ms / max 766.89 ms — PASS.

The first benchmark harness revision accidentally accumulated elapsed time between cases. Those figures were discarded and are not acceptance evidence.

## UAT — Search rebuild

Governed `search.refresh_course_documents_v3(false)` dry-run at 33,105 documents:

- elapsed 14,894.87 ms;
- base new/changed/removed 0/0/0;
- base unchanged 33,105;
- enrichment changed 0 / unchanged 33,105;
- generation 22 before and after;
- row count 33,105 before and after;
- projection hash unchanged.

**Verdict:** PASS — unchanged Search content does not cause an APPLY/generation mutation.

## UAT — browser request audit/remediation

Code reconciliation proved duplicate hidden operations on the Pipeline Ops-owned Jobs and Sources routes. PR #29 removes the redundant legacy network requests without changing the overlay's paged Pipeline Ops calls. The promoted deployed UAT now explicitly asserts:

- no legacy `jobs` network RPC when `#jobs` is active;
- no legacy `sources` network RPC when `#sources` is active;
- `pipeline_jobs_page` / `pipeline_sources_page` remain active and within the 3-second wall budget;
- exact CRICOS lookup, detail, paging and Back navigation remain interactive;
- core workspace payload budgets remain bounded;
- laptop/desktop page-level horizontal overflow is absent.

PR #29 frontend build and UAT suite discovery: **PASS**, workflow run `32621666805`.

Merged deployed browser gate for `c671bda6...`: **IN PROGRESS** at this record revision.

## Security / advisor review

No database ACL/function/DDL change was made. `public.admin_read` remains SECURITY INVOKER; delegated private functions retain existing role checks. Supabase performance advisors show no performance-severity blocker on the measured surfaces. Existing informational unused-index/unindexed-FK observations are not evidenced as an interactive blocker in this gate.

## Rollback / reversion

- revert Pilot merge `c671bda6...` / PR #29 to remove the route guard and performance suite;
- no database rollback is required because this gate made no database mutation;
- do not alter canonical identity/data, Search semantics or publication state as a rollback mechanism.

## Documentation impact

- PIM Admin Guide: no operator semantic change; no guide bump required;
- Database Architecture: no schema/API contract/ACL change; no architecture bump required;
- Running Build: update on final closure because accepted Pilot source authority changes;
- Master Project Plan: update on final closure to record the explicit performance gate outcome;
- UAT: dedicated performance technical acceptance added;
- Zoho contract: no change.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 23 Aug 2026 15:51 AEST | PROPOSED | Performance gate initiated after governance/runtime reconciliation | M1-PERFORMANCE-RESPONSIVENESS |
| 23 Aug 2026 15:51 AEST | APPLIED / UAT IN PROGRESS | Live authenticated DB baseline captured | live Pilot Supabase |
| 23 Aug 2026 15:57 AEST | SOURCE UAT PASS | PR #29 build/UAT discovery passed; route remediation and deployed performance suite accepted for merge | Actions `32621666805` |
| 23 Aug 2026 15:59 AEST | APPLIED | PR #29 merged to Pilot main | `c671bda6...` |

## Closure

**Final status:** DEPLOYED UAT IN PROGRESS  
**Closed at:** N/A  
**Outcome:** Database/API/Search gates pass; final desktop/mobile deployed browser performance run remains the closure condition.