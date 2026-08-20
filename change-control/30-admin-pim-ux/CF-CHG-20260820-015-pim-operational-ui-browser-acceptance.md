# CF-CHG-20260820-015 — PIM operational UI and browser acceptance finalisation

**Status:** **BLOCKED — TECHNICAL GATE PASS / DEPLOYED AUTHENTICATED BROWSER ACCEPTANCE NOT PROVEN**  
**Category:** `30-admin-pim-ux`  
**Initiated:** 20 August 2026 15:04 AEST  
**Origin:** `M1-PIM-FINALISATION — Admin/PIM Operational UI & Browser Acceptance Gate`  
**Owner:** CourseFinder Admin/PIM governance  
**UI candidate:** PIM Admin v2.10.0  
**Last updated:** 20 August 2026

## Governing boundary

This work continues from accepted PIM v2.9.0 semantics. It does **not** redefine Provider/Course identity, CRICOS fee semantics, intake/English semantics, taxonomy authority, Scholarship semantics, lifecycle/publication/readiness/Search separation or Evidence provenance meaning.

`public.admin_read(text,jsonb)` remains the normal browser read boundary. Internal schemas are not promoted as browser CRUD surfaces.

## Reconciliation performed before change

The gate was reconciled against:

- `PROJECT_INSTRUCTIONS.md` on `main`;
- current master plan / running build / architecture / Admin guide;
- Admin/PIM design decisions v1.10 and IA v1.1;
- all open `30-admin-pim-ux` records 001 and 005–014;
- current `coursefinder-admin/main` and the v2.10 integration branch;
- the separate `Coursefinder-Pilot` repository;
- live `coursefinder_Pilot` Supabase migrations, functions, grants and API telemetry.

Several filenames referenced by `PROJECT_INSTRUCTIONS.md` are stale or absent on `main`; no missing governance content was invented. The latest matching current documents were used where present.

## Defects confirmed

- Evidence v2.5 could request up to 2,000 rows and filter locally.
- Operations/PIM compatibility paths could request four-digit row sets.
- v2.9 navigation/filter/detail state was largely in-memory.
- stale-request cancellation / consistent skeleton-error-retry behaviour was incomplete.
- Provider detail read `rows` from helpers returning `items`, causing false empty related-data displays.
- the old default 50-row Course page measured about 5.27 s DB-side.
- normal derived Course filters could fall back to full rich-row evaluation; `Has fee = Yes` measured about 4.29 s DB-side during finalisation recheck.
- Search/Publication had a cold wide-table aggregation path.
- legacy `public.ui_*` `SECURITY DEFINER` browser execution remained incompatible with the promoted `admin_read` boundary until retired.
- real Chrome API telemetry proved the deployed bundle was still calling legacy `ui_*` RPCs immediately before the governed redeploy trigger.

## Applied finalisation contract

### PIM Admin v2.10 operational shell

The candidate information architecture is:

- Overview;
- Catalogue — Providers, Courses, Campuses;
- PIM Configuration — Attributes;
- Enrichment & Insights — QILT, PRISMS;
- Data Quality — Completeness, Review Queue;
- Evidence;
- Pipelines & Jobs — Pipeline Control, Jobs, Sources;
- Scholarships;
- Search & Publication.

Dead Integrations / Platform Settings placeholders were not added merely to satisfy a taxonomy.

The shell provides URL/history-backed state, browser Back/Forward support, scroll restoration, request cancellation, debounced search, loading skeletons, explicit empty/error/retry/permission states, responsive navigation, sticky table/context regions, persisted resizable columns and structured Provider/Campus detail. Accepted Course and Scholarship semantic panels remain in use.

### Course scale

The Course read path now filters/counts/sorts canonical rows before bounded page enrichment. Normal derived filters are also evaluated before page enrichment without changing their governed meanings.

Measured Pilot DB-side samples:

| Path | Measured |
|---|---:|
| old default Course page, 50 | ~5,272 ms |
| current default Course page, warm sample | ~259 ms |
| current default Course page, cold sample during recheck | ~2,536 ms |
| `Has fee = Yes` before final derived-filter repair | ~4,287 ms |
| `Has fee = Yes` after migration 075 | **~277 ms** |
| minimum Admin readiness 50% after migration 075 | **~442 ms** |
| exact CRICOS `121174E` earlier bounded sample | ~167 ms |
| Provider page, 50 | ~212 ms |
| Campus page, 50 | ~109 ms |
| Evidence page, 50 | ~134 ms |
| Pipeline Jobs page, 50 | ~517 ms |
| Pipeline Sources page, 50 | ~32 ms |
| QILT page, 50 | ~157 ms |
| PRISMS page, 50 | ~297 ms |
| PIM Configuration | ~28 ms |

The cold default Course sample is explicitly recorded rather than hidden. v2.10 renders loading progress instead of a blank screen; real network/browser latency remains part of deployed UAT.

Migration applied to Pilot:

`m1_pim_finalisation_course_derived_filters_fast_v1`

Repository mirror:

`supabase/production-migrations/075_m1_pim_finalisation_course_derived_filters_fast.sql`

Fee/readiness *ordering* remains intentionally unpromoted in the normal v2.10 grid; their accepted calculations are not redefined.

## Exact identity / semantic regression

Post-repair authenticated regression under the assigned Platform Admin identity:

- exact Course query `121174E` → 1 Course;
- exact Provider query `00025B` → 1 Provider;
- `121174E` CRICOS registered fee rows → 3;
- Provider-current fee rows for `121174E` → 0;
- semantic-review/other fee rows → 0;
- Non-Tuition Fee AUD 0 row remains present.

No CRICOS registered amount was substituted into the Provider-current fee section.

## Security regression

Live Pilot after-state:

- `public.admin_read` is `SECURITY INVOKER` and executable by `authenticated`;
- zero public `SECURITY DEFINER` functions are executable by `authenticated`;
- zero public `SECURITY DEFINER` functions are executable by `anon`;
- no browser internal-schema CRUD was introduced.

A synthetic authenticated identity with no CourseFinder assignment received SQLSTATE `42501` for:

- Evidence — `curator role required`;
- Pipeline Jobs — `pipeline_operator role required`;
- PIM Configuration — `pim_admin role required`.

Do not restore broad direct authenticated execution of legacy `public.ui_*` helpers to make an old browser bundle work.

## Production build gate

A real GitHub Actions production-build gate was added to the v2.10 integration branch.

Initial workflow configuration failed before application build because the repository has no lockfile and `setup-node` npm caching required one. The workflow was corrected to the repository's actual dependency model.

Final CI result:

- Node 22.23.2;
- `npm install --ignore-scripts` — PASS, 0 reported vulnerabilities;
- `npm run build` — PASS;
- Vite 8.1.5;
- 65 modules transformed;
- production bundle emitted successfully.

The latest branch build after migration 075 also passed.

## Deployed frontend evidence

Immediately before recovery, Supabase API logs from the real Windows Chrome client showed direct calls such as:

- `/rest/v1/rpc/ui_context`;
- `/rest/v1/rpc/ui_dashboard`;
- `/rest/v1/rpc/ui_courses_decision_page`;
- `/rest/v1/rpc/ui_course_filter_options`;
- legacy QILT/PRISMS helpers.

The newest observed legacy request in the available log batch was **20 August 2026 07:00:57 UTC**, returning HTTP 403 for `ui_context`.

This is valid proof that the deployed browser bundle was stale **before** the recovery trigger.

### Governed redeploy triggers

An initial no-content fast-forward commit was applied to `coursefinder-admin/main` using the unchanged v2.9 tree:

`494a6ddcc18671abd492370410a94212c9c21deb`

Commit time: **20 August 2026 07:04:28 UTC**.

A second governed redeploy trigger was issued after explicit operator approval, again preserving the exact same v2.9 application tree and changing no ACL or application code:

`eae32edab4ef9395b0584370ac62b6a0f5988ca3`

Commit time: **20 August 2026 08:07:02 UTC / 18:07 AEST**.

Purpose: trigger the established external Cloudflare Git-integrated rebuild without changing application semantics or merging the v2.10 candidate prematurely.

Post-trigger technical regression under the assigned Platform Admin identity remains PASS:

- `admin_read('context')` → `platform_admin`, role rank 6;
- exact Provider `00025B` → 1 Provider;
- Provider detail → 382 related Courses;
- exact Course `121174E` → 1 Course;
- Course detail → 3 CRICOS registered fee rows, 0 Provider-current rows, 0 semantic-review/other rows;
- `admin_read` remains executable by `authenticated` and denied to `anon`;
- zero public `SECURITY DEFINER` functions are executable by `authenticated` or `anon`.

The only remaining directly executable legacy `ui_*` functions for `authenticated` are the two `ui_providers_page` overloads, both `SECURITY INVOKER`; no legacy `ui_*` `SECURITY DEFINER` surface was reopened.

The current tool environment still has no Cloudflare control-plane connector and the available Supabase API log batch contains **no browser request newer than the 08:07:02 UTC redeploy trigger**. Therefore deployment success or failure after the approved trigger is **not yet proven**.

Absence of post-trigger telemetry is not treated as a deployment failure and is not treated as a PASS.

## Remaining deployed browser acceptance

This record remains open until an authenticated deployed browser proves all of the following:

1. the deployed bundle uses `/rpc/admin_read` rather than direct legacy browser `ui_*` calls;
2. visible version and navigation correspond to the intended release;
3. no unexplained blank/slow screens;
4. Course list is practical at current 35k+ active / 43k+ total Course scale;
5. exact IDs are searchable through browser controls;
6. filters/page/sort/scroll survive cross-click and browser Back/Forward;
7. rapid filter/search changes do not allow stale responses to win;
8. responsive laptop/desktop behaviour is acceptable;
9. resizable columns and sticky identity/context work in the actual browser;
10. every visible menu entry loads useful real data or an explicit governed empty state;
11. role-visible navigation aligns with server-side permission behaviour.

## Closure

**Final status:** **BLOCKED — TECHNICAL GATE PASS; DEPLOYED AUTHENTICATED BROWSER ACCEPTANCE NOT PROVEN AFTER GOVERNED REDEPLOY TRIGGER.**

Do not close `CF-CHG-20260820-001`, `005`–`014`, or this record solely from SQL, source, CI or synthetic role evidence. Their common remaining blocker is now explicitly this deployed-browser/runtime gate rather than a generic unqualified “browser UAT pending”.
