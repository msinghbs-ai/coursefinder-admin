# CF-CHG-20260820-015 — PIM operational UI and browser acceptance finalisation

**Status:** DB/RPC/SECURITY/PERFORMANCE + FRONTEND SOURCE PASS — DEPLOYED AUTHENTICATED BROWSER UAT BLOCKED BY STALE DEPLOYED FRONTEND  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 15:04 AEST  
**Origin:** `M1-PIM-FINALISATION — Admin/PIM Operational UI & Browser Acceptance Gate`  
**Owner:** CourseFinder Admin/PIM governance  
**UI version:** PIM Admin v2.10.0

## Trigger

PIM v2.9.0 had accepted semantic panels but still behaved as a collection of database-oriented screens in several operational paths. Finalisation was opened to complete deployed-browser acceptance without redesigning accepted canonical field semantics.

## Defects confirmed

- Evidence fetched up to 2,000 rows and filtered locally.
- Operations/PIM compatibility screens could request 1,000–2,000 rows.
- navigation/filter/page/detail state was in-memory and did not reliably survive Back/Forward.
- loading/error behaviour did not provide consistent skeleton/retry states.
- Provider detail incorrectly read `rows` from related helpers that return `items`, causing UQ to display zero related Courses despite 382 actual Courses.
- default 50-row Course page executed at about 5.27 seconds DB-side before browser/network time.
- Search/Publication cold aggregation scanned wide Search documents.
- several legacy `public.ui_*` `SECURITY DEFINER` compatibility RPCs remained browser executable.

## Applied finalisation contract

### Operational UI

PIM Admin v2.10.0 provides a governed information architecture:

- Overview;
- Catalogue — Providers, Courses, Campuses;
- PIM Configuration — Attributes;
- Enrichment & Insights — QILT, PRISMS;
- Data Quality — Completeness, Review Queue;
- Evidence;
- Pipelines & Jobs — Pipeline Control, Jobs, Sources;
- Scholarships;
- Search & Publication.

No dead Integrations or Platform Settings placeholders were added merely to satisfy a menu taxonomy.

The v2.10 shell adds URL/history state, server-paged reads, debounce/cancellation, retry/error/empty/permission states, loading skeletons, responsive navigation, sticky table/header context, persisted resizable columns and structured Provider/Campus detail.

### Course scale/performance

The normal Course path now filters/counts/sorts lightweight canonical rows, paginates, then computes fee/readiness/geography/scholarship/Search fields only for the bounded page.

Measured Pilot DB-side timings:

| Read | Measured |
|---|---:|
| old default Course page, 50 | ~5,272 ms |
| v2.10 default Course page, 50 | ~260 ms |
| exact CRICOS Course `121174E` | ~167 ms |
| AU/VIC Provider-sorted Course page | ~963 ms |
| Provider page, 50 | ~212 ms |
| Campus page, 50 | ~109 ms |
| Evidence page, 50 | ~134 ms |
| Pipeline Jobs page, 50 | ~517 ms |
| Pipeline Sources page, 50 | ~32 ms |
| QILT page, 50 | ~157 ms |
| PRISMS page, 50 | ~297 ms |
| PIM Configuration | ~28 ms |

This is roughly a 95% reduction for the default Course database read. Derived catalogue-wide fee/completeness filters/sorts preserve their accepted semantics but are not exposed as normal clickable sort interactions in v2.10 until independently optimised.

### Exact identity and bounded reads

Pilot UAT proved:

- exact Course CRICOS `121174E` => one Course;
- exact Provider CRICOS `00025B` => one Provider;
- exact Evidence UUID => one Evidence artifact;
- exact Pipeline Job UUID => one Job;
- UQ Provider detail => 382 related Courses, bounded to 25 in the detail payload;
- Search projection => 33,105 Course documents during the gate.

### Security

- browser entrypoint remains `public.admin_read`;
- no normal browser table grants exist on internal Catalogue/Pipeline/Workflow/PIM/Scholarship/Search/Publishing/Security schemas;
- all legacy `public.ui_*` `SECURITY DEFINER` browser execution was revoked from `PUBLIC`, `anon` and `authenticated`;
- unassigned authenticated identities were denied Evidence, Pipeline and PIM Configuration with SQLSTATE `42501`;
- the security-advisor rerun no longer reports authenticated `SECURITY DEFINER` compatibility RPC exposure;
- existing deny-by-default RLS/no-policy INFO notices remain informational;
- Supabase leaked-password protection remains a separate project-level warning and is not claimed as fixed by this gate.

## Source acceptance

The production transform/source guard passed with zero JSX/transformation errors and asserts:

- explicit Campuses → Campus routing;
- list URL/scroll preserved before detail history push;
- latest governed Evidence filters/page contract;
- known slow fee/readiness sorts disabled from the normal Course grid;
- no 1,000/2,000/5,000 row frontend bulk-read constants;
- no direct Supabase `.from(...)` table reads in the v2.10 shell.

## Deployed runtime drift — 20 August 2026 16:36 AEST

A browser-reported permission regression was reconciled against current governance, repository source, Pilot migration state and Supabase API logs before any further ACL change.

Evidence:

- governed `main` remains PIM Admin v2.9.0 at `229201ff2819cbf3144cc6c0589bf7e4f0901018` and its browser client calls only `public.admin_read`;
- this v2.10 candidate likewise promotes only `public.admin_read` and intentionally retires direct authenticated `public.ui_*` `SECURITY DEFINER` execution;
- Pilot migration `m1_pim_finalisation_retire_legacy_ui_rpc_exec_v1` at 20 August 2026 05:43 UTC revoked direct authenticated legacy RPC execution after earlier temporary compatibility grants;
- Supabase API logs at 20 August 2026 06:36 UTC show the real Chrome client directly POSTing `/rest/v1/rpc/ui_context` and `/rest/v1/rpc/ui_dashboard`, both returning HTTP 403;
- earlier real-browser logs show direct calls to `ui_courses_decision_page`, `ui_qilt_outcomes_page`, `ui_prisms_student_flow_page` and other legacy RPCs;
- therefore the deployed Cloudflare bundle is stale relative to both governed main and the v2.10 candidate;
- browser permission errors are a frontend deployment/version mismatch, not evidence that the new database ACL should be weakened.

Current Pilot `public.admin_read` was re-tested under the assigned Platform Admin identity for Context, Dashboard, Providers, Courses, Campuses, Scholarships, QILT, PRISMS and Attributes; every governed path returned successfully.

### Recovery decision

Do **not** restore direct authenticated legacy `public.ui_*` execution. The authorised lowest-risk recovery is to redeploy the unchanged governed `main` v2.9 source tree through the existing Cloudflare Git integration. This keeps draft PR #5 and its newer v2.10 work intact and avoids merging its still-unreconciled predecessor Evidence/Pipeline migration mirrors solely to recover browser access.

A no-content `main` commit referencing `CF-CHG-20260820-015` may be used solely to trigger the Git-integrated rebuild. It must not be represented as deployed browser PASS until runtime evidence shows requests moving to `/rpc/admin_read` and the browser checklist passes.

## Deployed browser acceptance still required

This record MUST remain open until the deployed authenticated browser proves:

1. no unexplained blank/slow screens;
2. Course list practical at 26k+ scale;
3. filters/page/sort/scroll survive detail navigation and Back/Forward;
4. exact IDs searchable from the deployed UI;
5. responsive laptop/desktop layouts;
6. column resize/sticky context behaviour;
7. permission-hidden navigation matches server denial behaviour;
8. every visible menu entry loads useful real data or an explicit governed empty state;
9. no stale request wins after rapid filter/search/navigation changes;
10. Supabase API logs show normal browser reads using `public.admin_read`, with no direct authenticated legacy `public.ui_*` calls.

## Closure

**Final status:** BLOCKED — STALE DEPLOYED FRONTEND; GOVERNED REDEPLOY AUTHORISED, DEPLOYED AUTHENTICATED BROWSER UAT NOT YET PASSED.  
Do not close CF-CHG-001/005–015 solely from source, SQL or synthetic role evidence.
