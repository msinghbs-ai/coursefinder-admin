# CF-CHG-20260823-026 — M1 Performance & Responsiveness Gate

**Status:** CLOSED / PASS  
**Category:** 80-uat-release-operations  
**Initiated:** 23 August 2026 15:51 AEST  
**Closed:** 23 August 2026 16:12 AEST  
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

No canonical identity, field meaning, source authority, grain/cardinality, lifecycle, publication, Search-admission or Zoho semantic change was made. The accepted application remediation is browser route/request ownership only. No database DDL or persistent privilege change was required.

## Before

PIM v2.12 and the accepted capability surfaces were operational, but no single full-scale performance acceptance record spanned all operational workspaces. `#jobs` and `#sources` were visibly owned by Pipeline Ops v1.0 while the underlying PIM shell could also issue legacy `jobs` / `sources` reads, creating redundant hidden network/database work for authorised Pipeline users.

## After

- measurable DB/API/browser thresholds are explicit and automated;
- Provider/Course/Campus/Scholarship/Evidence/Data Quality paths remain server-paged/cached as designed;
- `#jobs` and `#sources` suppress the underlying legacy read while Pipeline Ops uses paged `pipeline_*` contracts;
- Search full-refresh dry-run proves unchanged content does not advance generation or trigger APPLY;
- Dashboard navigation and browser refresh are measured;
- responsive acceptance proves no page-level horizontal overflow at 1280/1366/1440 desktop/laptop widths;
- final deployed desktop and mobile Chromium gates pass against accepted Pilot SHA `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`.

## Source authority / evidence

- `PROJECT_INSTRUCTIONS.md`;
- Change Control register current through `CF-CHG-20260823-025` at initiation;
- Master Project Plan v1.64 at initiation;
- Running Build v2.66 at initiation;
- Database Architecture v2.10.40;
- Admin/PIM Design Decisions v1.13;
- pre-change Pilot runtime `16ce78e25e78c2324e056a7b8cb6024d4a0428a8`;
- intermediate Pilot runtime `c671bda6c8935011d074e97b2bf079bc7f72c94d`;
- accepted Pilot runtime `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`;
- live Supabase project `coursefinder_Pilot`;
- `docs/uat/coursefinder-m1-performance-responsiveness-technical-acceptance-2026-08-23.md`.

## Implementation references

- Supabase migration(s): none — measured DB paths did not justify DDL;
- Pilot PR #29: production route ownership guard + deployed performance suite;
- Pilot PR #30: UAT interaction-sequencing correction + Dashboard refresh measurement;
- accepted Pilot merge: `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`;
- source remediation: `src/lib/supabase.js` route guard for legacy `jobs` / `sources` only;
- deployed UAT: `tests/uat/performance-deployed.spec.mjs` in `.github/workflows/deployed-uat.yml`;
- final deployed run: GitHub Actions `32622164346`;
- final artifacts: desktop `9488698427`, mobile `9488698429`;
- RPC/API objects measured: `public.admin_read`, delegated `security.*` read functions, `api.website_course_search_v2`, `search.refresh_course_documents_v3(false)`;
- UI version: PIM Admin v2.12 retained; no visible version claim was required for a network/request ownership fix.

## Acceptance thresholds

- normal DB list/filter/detail target: <= 750 ms;
- complex/exact-ID DB p95: <= 2,000 ms; hard gate <= 2,500 ms;
- deployed interactive/read/detail RPC wall time: <= 3,000 ms;
- normal paged browser payload: <= 250 KB;
- Course filter-options payload: <= 350 KB;
- no unexpected 5xx in final accepted run;
- no page-level horizontal overflow at 1280×800, 1366×768 or 1440×900; wide tables scroll inside their grid container.

Search full-refresh is a batch operation and is judged on deterministic change detection/no-op behaviour rather than the interactive latency budget.

## UAT — authenticated database/API

Representative independent live Pilot timings:

- Dashboard 55.38 ms;
- Providers first page 61.86 ms;
- Courses AU first page 156.33 ms;
- Courses AU offset 500 454.67 ms;
- exact CRICOS `121174E` initial sample 523.66 ms;
- AU+VIC+fee+state multi-filter initial sample 1,123.72 ms;
- Campuses AU first page 33.29 ms;
- Scholarships first page 3.37 ms;
- Data Quality AU+NZ cached overview 1.52 ms;
- Pipeline jobs first page 137.26 ms;
- Evidence first page 40.33 ms;
- Course detail 428.94 ms;
- Campus detail 309.28 ms;
- Scholarship detail 63.92 ms;
- Provider detail 21.03 ms;
- Provider filter options 17.46 ms;
- Course filter options AU 209.69 ms / 222.2 KB;
- Course filter options all-country 352.14 ms / 273.0 KB.

Five-run slow-path sample:

- exact CRICOS `121174E`: average 621.12 ms / p95 1,626.37 ms / max 1,961.38 ms — PASS;
- AU+VIC+fee+state multi-filter: average 419.52 ms / p95 680.85 ms / max 766.89 ms — PASS.

The first benchmark harness revision accidentally accumulated elapsed time between cases. Those figures were discarded and are not acceptance evidence.

## UAT — final deployed browser/API

GitHub Actions run `32622164346` passed on both Chromium projects.

Desktop representative wall times:

- Dashboard navigation/refresh: 475 / 491 ms;
- Providers: 1,245 ms;
- Courses: 1,716 ms;
- exact CRICOS: 997 ms;
- Course detail: 1,023 ms;
- paging: 1,003 ms;
- browser Back: 1,059 ms;
- Campuses: 539 ms;
- Scholarships: 388 ms;
- Evidence: 529 ms;
- Data Quality: 387 ms;
- Pipeline Jobs: 1,485 ms;
- Pipeline Sources: 479 ms.

Mobile Chromium representative wall times:

- Dashboard navigation/refresh: 568 / 448 ms;
- Providers: 1,628 ms;
- Courses: 1,691 ms;
- exact CRICOS: 1,853 ms;
- Course detail: 1,250 ms;
- paging: 802 ms;
- browser Back: 945 ms;
- Campuses: 932 ms;
- Scholarships: 422 ms;
- Evidence: 470 ms;
- Data Quality: 373 ms;
- Pipeline Jobs: 869 ms;
- Pipeline Sources: 480 ms.

All are inside the 3,000 ms wall-time gate. Normal page payloads remain below 250 KB. Course filter options measured 257.7 KB and remain inside the explicit 350 KB support-payload budget.

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

## UAT — request audit/remediation

Final deployed evidence proves:

- Jobs issues `pipeline_jobs_page` and no legacy `jobs` request;
- Sources issues `pipeline_sources_page` and no legacy `sources` request;
- exact-ID lookup, detail opening, paging, Back navigation and Dashboard refresh remain interactive;
- no page-level overflow at 1440×900, 1366×768 or 1280×800; the wide 1610 px Course grid scrolls inside its bounded container;
- the accepted final run has no unexpected 5xx.

### First-run failure handling

Run `32621741394` failed and was not waived:

- Course paging UAT attempted to click behind an open detail drawer; PR #30 corrected test sequencing by closing the drawer first.
- Pipeline Ops correctly displayed `Not authorised` because the deployed UAT principal was Curator rank 3 and Pipeline requires rank 4.
- a transient Evidence detail 500 passed the configured retry, but the final accepted run had no unexpected 5xx.

For final Pipeline browser acceptance the dedicated UAT principal received a temporary, audited `pipeline_operator` role with automatic expiry. After final PASS, the role was explicitly removed and the principal was verified restored to its original Curator-only state.

## Security / advisor review

No database ACL/function/DDL change was made. `public.admin_read` remains SECURITY INVOKER; delegated private functions retain existing role checks. Supabase performance advisors show no performance-severity blocker on the measured surfaces. Existing informational unused-index/unindexed-FK observations are not evidenced as an interactive blocker in this gate.

The temporary Pipeline Operator UAT assignment was bounded, audit-recorded and fully reverted. There is no persistent access-state delta from this gate.

## Rollback / reversion

- revert PR #29 / the `src/lib/supabase.js` route ownership guard if the duplicate-read remediation must be withdrawn;
- PR #30 changes only automated UAT sequencing/coverage and can be independently reverted;
- no database rollback is required because there is no persistent database mutation;
- do not alter canonical identity/data, Search semantics or publication state as a rollback mechanism.

## Documentation impact

- PIM Admin Guide: no operator semantic change; no guide bump required;
- Database Architecture: no schema/API contract/ACL change; no architecture bump required;
- Running Build: advanced on closure to record accepted Pilot source authority and gate;
- Master Project Plan: advanced on closure to record explicit performance gate PASS;
- UAT: dedicated technical acceptance closed PASS;
- Zoho contract: no change.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 23 Aug 2026 15:51 AEST | PROPOSED | Performance gate initiated after governance/runtime reconciliation | M1-PERFORMANCE-RESPONSIVENESS |
| 23 Aug 2026 15:51 AEST | APPLIED / UAT IN PROGRESS | Live authenticated DB baseline captured | live Pilot Supabase |
| 23 Aug 2026 15:57 AEST | SOURCE UAT PASS | PR #29 build/UAT discovery passed | Actions `32621666805` |
| 23 Aug 2026 15:59 AEST | APPLIED | PR #29 merged | `c671bda6...` |
| 23 Aug 2026 16:03 AEST | DEPLOYED UAT FAIL | First deployed run exposed UAT sequencing defect and Curator-only Pipeline authorization mismatch; no waiver | Actions `32621741394` |
| 23 Aug 2026 16:08 AEST | SOURCE UAT PASS | PR #30 build/local browser smoke passed | Actions `32622096667` |
| 23 Aug 2026 16:08 AEST | APPLIED | PR #30 merged | `1bcb96d2...` |
| 23 Aug 2026 16:12 AEST | CLOSED / PASS | Final desktop+mobile deployed performance gate passed; temporary UAT Pipeline role removed and original access restored | Actions `32622164346` |

## Closure

**Final status:** CLOSED / PASS  
**Closed at:** 23 August 2026 16:12 AEST  
**Outcome:** Full-scale Admin/Search operational performance gate passed. Duplicate Pipeline hidden reads were removed, thresholds and regression coverage were established, no DB optimisation was justified by measured evidence, Search no-op rebuild semantics passed, responsive grid behaviour passed, and the accepted Pilot source authority is `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`.