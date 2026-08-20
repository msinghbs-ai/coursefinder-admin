# M1-PIM-FINALISATION UAT — 20 August 2026

**Workstream:** Admin/PIM Operational UI & Browser Acceptance Gate  
**UI candidate:** PIM Admin v2.10.0  
**Pilot:** `coursefinder_Pilot`  
**Outcome:** **TECHNICAL UAT PASS — DEPLOYED AUTHENTICATED BROWSER GATE BLOCKED / NOT YET PROVEN**

## 1. Acceptance rule

Source, SQL, CI and synthetic-role success do not close Admin/PIM Change Controls. The gate closes only after the real deployed authenticated browser passes the operational acceptance checklist.

## 2. Governance reconciliation

Before implementation the workstream read `PROJECT_INSTRUCTIONS.md`, current main governance, open `30-admin-pim-ux` Change Controls, the v2.10 candidate, the separate Pilot repository and the live Supabase state.

The accepted semantic baseline remains PIM Admin v2.9.0. No accepted Provider/Course identity, CRICOS fee, intake/English, geography, taxonomy, Scholarship, lifecycle/publication/readiness/Search or Evidence semantics were redesigned.

Several filenames referenced by `PROJECT_INSTRUCTIONS.md` are stale/absent on main. The latest matching present governance documents were used; missing documents were not invented.

## 3. Live scale observed

| Domain | Current Pilot count |
|---|---:|
| active Providers | 3,085 |
| active Courses | 35,487 |
| all Course rows | 43,461 |
| Campuses | 3,922 |
| Search Course documents | 33,105 |
| Evidence artifacts | 1,567 |
| Pipeline Jobs | 1,325 |

The historical accepted AU CRICOS substrate remains 1,546 Providers / 26,648 active CRICOS Courses; the larger current catalogue includes additional countries/sources and must not be confused with the AU baseline.

## 4. Pre-finalisation defects proven

- Evidence could fetch up to 2,000 rows and filter locally.
- operational/PIM compatibility views could request four-digit row sets.
- v2.9 navigation/detail state was mainly in-memory.
- request cancellation and consistent skeleton/error/retry behaviour were incomplete.
- Provider detail expected `rows` where related helpers return `items`, creating false-empty detail.
- old default Course page was ~5.27 s DB-side for 50 rows.
- normal derived Course filters could fall back to catalogue-wide rich-row evaluation.
- the Search/Publication summary had a cold wide-table scan path.
- legacy browser-executable public `SECURITY DEFINER` helpers conflicted with the promoted `public.admin_read` boundary.

## 5. v2.10 operational UI source gate

Implemented at source level:

- governed information architecture for Catalogue, PIM Configuration, Enrichment/Insights, Data Quality, Evidence, Pipelines/Jobs, Scholarships and Search/Publication;
- no empty Integrations/Platform Settings placeholders merely for taxonomy completeness;
- URL-backed query/filter/page/sort/detail state;
- browser Back/Forward and scroll-state handling;
- `AbortController` cancellation and debounced search;
- loading skeletons;
- explicit empty/error/retry/permission states;
- responsive desktop/laptop navigation;
- sticky context/header behaviour;
- persisted resizable table columns;
- structured Provider/Campus detail;
- accepted Course and Scholarship semantic panels retained;
- no direct internal-table `.from(...)` reads in the promoted v2.10 shell.

The build-time guard also prevents known regressions in Campus routing, list-history preservation, Evidence payload adaptation and exposure of the unoptimised fee/readiness sort actions.

## 6. Real production build UAT

A GitHub Actions Node 22 production-build gate was added to the finalisation branch.

The first workflow configuration failed before application build because npm cache setup requires a lockfile and this repository has no lockfile. That workflow issue was corrected; it was not classified as an application failure.

Final production build:

| Assertion | Result |
|---|---|
| Node 22.23.2 | PASS |
| dependency install | PASS |
| npm audit result during install | 0 reported vulnerabilities |
| `npm run build` | PASS |
| Vite | 8.1.5 |
| transformed modules | 65 |
| production bundle emitted | PASS |

The latest CI run after migration 075 also passed.

## 7. Course performance UAT

PostgreSQL timings are DB-side samples only; browser/network time is separate.

| Path | Measured execution |
|---|---:|
| historical old default Course page, 50 | ~5,272 ms |
| current default Course page, immediate warm sample | ~259 ms |
| current default Course page, first cold sample during recheck | ~2,536 ms |
| `Has fee = Yes`, before migration 075 | ~4,287 ms |
| `Has fee = Yes`, after migration 075 | **~277 ms** |
| minimum Admin readiness 50%, after migration 075 | **~442 ms** |
| exact CRICOS `121174E`, earlier bounded sample | ~167 ms |
| Provider page, 50 | ~212 ms |
| Campus page, 50 | ~109 ms |
| Evidence page, 50 | ~134 ms |
| Pipeline Jobs, 50 | ~517 ms |
| Pipeline Sources, 50 | ~32 ms |
| QILT, 50 | ~157 ms |
| PRISMS, 50 | ~297 ms |
| PIM Configuration | ~28 ms |

Migration:

`m1_pim_finalisation_course_derived_filters_fast_v1`

Repository mirror:

`supabase/production-migrations/075_m1_pim_finalisation_course_derived_filters_fast.sql`

The repair changes execution strategy only. `has_fee`, `has_intake`, `has_english`, `has_scholarship`, geography/link presence and the six-signal Admin readiness calculation retain their accepted meanings and are evaluated before bounded page enrichment.

Fee/readiness catalogue-wide ordering remains deliberately unpromoted in the normal v2.10 UI.

The cold default Course sample is explicitly retained in this record. v2.10 supplies a loading skeleton rather than a blank screen, but the deployed network/browser initial-load gate still requires observation.

## 8. Search / Publication performance

The initial Search/Publication aggregate measured ~2.95 s on a cold wide-table scan. A narrow covering summary index was added. The underlying summary aggregate then used an index-only scan at ~33 ms in the measured UAT.

## 9. Exact identity and semantic regression

Authenticated Platform Admin post-repair regression:

| Test | Result |
|---|---|
| exact Course query `121174E` | exactly 1 Course — PASS |
| exact Provider query `00025B` | exactly 1 Provider — PASS |
| `121174E` CRICOS registered fee rows | 3 — PASS |
| `121174E` Provider-current fee rows | 0 — PASS |
| `121174E` semantic-review/other fee rows | 0 — PASS |
| Non-Tuition Fee AUD 0 preserved | PASS |

No title-only identity logic was added and CRICOS registered amounts were not substituted into Provider-current fees.

Earlier bounded finalisation checks also confirmed exact Evidence UUID and Pipeline Job UUID lookup and UQ Provider detail with 382 related Courses / bounded 25-row preview.

## 10. Security UAT

Current live Pilot:

- `public.admin_read(text,jsonb)` is `SECURITY INVOKER` and authenticated-executable;
- zero public `SECURITY DEFINER` functions are executable by `authenticated`;
- zero public `SECURITY DEFINER` functions are executable by `anon`;
- no browser internal-schema CRUD path was introduced.

Synthetic authenticated identity with no CourseFinder role:

| Operation | Expected | Result |
|---|---|---|
| Evidence | Curator+ | `42501 curator role required` — PASS |
| Pipeline Jobs | Pipeline Operator+ | `42501 pipeline_operator role required` — PASS |
| PIM Configuration | PIM Admin+ | `42501 pim_admin role required` — PASS |

The correct remediation for a stale browser is **not** to restore broad authenticated execution of legacy `public.ui_*` helpers.

## 11. Deployed runtime evidence

Real Windows Chrome Supabase API telemetry immediately before recovery showed direct legacy calls including:

- `/rpc/ui_context`;
- `/rpc/ui_dashboard`;
- `/rpc/ui_courses_decision_page`;
- `/rpc/ui_course_filter_options`;
- legacy QILT/PRISMS RPCs.

The newest observed legacy request was `ui_context` at **20 August 2026 07:00:57 UTC**, HTTP 403.

This proves the deployed bundle was stale before recovery.

### Governed recovery trigger

`coursefinder-admin/main` received a no-content fast-forward commit using the unchanged v2.9 tree:

`494a6ddcc18671abd492370410a94212c9c21deb`

Commit time: **20 August 2026 07:04:28 UTC**.

Purpose: trigger the established external Cloudflare Git-integrated rebuild without weakening the DB boundary or merging the newer v2.10 candidate solely to recover access.

The available API telemetry currently contains **no browser request after 07:04:28 UTC**, so it cannot prove whether that external rebuild completed or what bundle is now served.

The external browser tool cannot open the unindexed Workers URL and no Cloudflare control-plane connector is available. Therefore post-trigger deployed state remains unverified.

## 12. Remaining browser acceptance checklist

The following are still required in the real deployed authenticated UI:

1. normal browser reads use `/rpc/admin_read`, not legacy direct browser `ui_*` calls;
2. visible UI version/navigation matches the intended release;
3. no unexplained blank/slow screens;
4. Course list practical at 35k+ active / 43k+ total current scale;
5. exact Provider/Course/CRICOS identity search works through the UI;
6. filter/page/sort/scroll state survives detail navigation and Back/Forward;
7. rapid filter/search changes cannot be overwritten by stale requests;
8. responsive desktop/laptop layout is usable;
9. sticky context and resizable columns work in-browser;
10. every visible menu entry loads real data or a governed explicit empty state;
11. role-visible navigation matches server-side permissions.

## 13. Verdict

**TECHNICAL UAT: PASS.**  
**PRODUCTION BUILD: PASS.**  
**DEPLOYED AUTHENTICATED BROWSER UAT: BLOCKED / NOT PROVEN AFTER THE GOVERNED REDEPLOY TRIGGER.**

`CF-CHG-20260820-015` and applicable predecessor Admin/PIM controls remain OPEN/BLOCKED. They must not be represented as closed until the deployed browser checklist passes.
