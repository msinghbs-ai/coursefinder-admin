# CF-CHG-20260823-026 — M1 Performance & Responsiveness Gate

**Status:** APPLIED / UAT IN PROGRESS  
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
- Search `course-v3` read behaviour only; no vector admission;
- M1-PIM-FINALISATION, M1-EVIDENCE-UX, M1-PIPELINE-OPS, M1-DATA-QUALITY-READINESS, M1-UAT-HARNESS and M1-SEARCH-ENRICHMENT.

## Semantic impact

No canonical identity, field meaning, source authority, grain/cardinality, lifecycle, publication, Search-admission or Zoho semantic change is authorised by this gate. Performance work may change query/index/read-path implementation and UAT/release instrumentation only. Any semantic change discovered as necessary must be separately governed before acceptance.

## Before

PIM v2.12 and the accepted capability surfaces are operational, and deployed desktop/mobile UAT is passing, but there is no single full-scale performance acceptance record spanning all operational workspaces. Existing read paths include paged catalogue APIs plus some legacy high-limit branches that must be distinguished from active browser calls by runtime evidence.

## After

The accepted Pilot will have reproducible database/API/browser performance evidence, explicit thresholds, responsive laptop/desktop acceptance, and identified/remediated material bottlenecks where required. Latency must be solved server-side before any frontend-only masking.

## Source authority / evidence

- `PROJECT_INSTRUCTIONS.md`;
- Change Control register current through `CF-CHG-20260823-025`;
- Master Project Plan v1.64;
- Running Build v2.66;
- Database Architecture v2.10.40;
- Admin/PIM Design Decisions v1.13;
- accepted Pilot runtime `msinghbs-ai/Coursefinder-Pilot@16ce78e25e78c2324e056a7b8cb6024d4a0428a8`;
- live Supabase project `coursefinder_Pilot`;
- existing deployed UAT harness and runtime evidence contract.

## Implementation references

- Supabase migration(s): pending only if measured optimisation requires DDL;
- Git repository/commit(s): pending;
- Issue/PR: N/A at initiation;
- RPC/API objects: `public.admin_read`, delegated `security.*` read functions, `api.website_course_search_v2`;
- UI version: PIM Admin v2.12 retained unless browser-facing behaviour changes.

## UAT

Initial authenticated DB benchmark on 23 August 2026 against live Pilot, 50-row pages unless stated otherwise:

- Dashboard: 55.38 ms / 2.7 KB;
- Providers first page: 61.86 ms / 35.5 KB;
- Courses AU first page: 156.33 ms / 84.2 KB;
- Courses AU offset 500: 454.67 ms / 86.7 KB;
- Courses exact query `121174E`: 523.66 ms / 1.8 KB;
- Courses AU+VIC+fee+state multi-filter: 1123.72 ms / empty-result envelope;
- Campuses AU first page: 33.29 ms / 36.3 KB;
- Scholarships first page: 3.37 ms / 3.6 KB;
- Data Quality AU+NZ cached overview: 1.52 ms / 21.1 KB;
- Pipeline jobs first page: 137.26 ms / 67.2 KB;
- Evidence first page: 40.33 ms / 44.9 KB.

The earlier apparent cumulative timings were discarded after correcting the benchmark harness; the figures above are independently clocked inside one authenticated server session.

Further browser/API/detail/paging/search/responsive tests remain in progress.

## Rollback / reversion

Read-only benchmarking is non-mutating. Any later index/function optimisation will require a mirrored migration and explicit rollback path before closure. UAT-harness-only changes can be reverted by source commit.

## Documentation impact

- PIM Admin Guide: only if operator-visible behaviour changes;
- Architecture: only if an accepted DB/API read contract changes materially;
- Running build: update when the gate closes;
- Master plan: update when the gate closes;
- UAT/design docs: create dedicated performance technical acceptance;
- Zoho contract: no change expected.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 23 Aug 2026 15:51 AEST | PROPOSED | Performance gate initiated after governance/runtime reconciliation | M1-PERFORMANCE-RESPONSIVENESS |
| 23 Aug 2026 15:51 AEST | APPLIED / UAT IN PROGRESS | Live authenticated DB baseline captured; no runtime mutation yet | live Pilot Supabase |

## Closure

**Final status:** UAT IN PROGRESS  
**Closed at:** N/A  
**Outcome:** Pending full browser/API/database/responsive acceptance.