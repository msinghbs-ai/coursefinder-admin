# CourseFinder M1-PIM-GOV Catalogue Paging UAT — PIM Admin v2.6.0

**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-007`  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Status:** **DB/RPC/SECURITY + FRONTEND SOURCE UAT PASS — DEPLOYED BROWSER UAT PENDING**

## Purpose

Replace capped client-side Catalogue search with governed server-side paging/search across the full canonical catalogue, while preserving exact stable identity and the canonical-presence readiness semantics established by `CF-CHG-20260820-001`.

## Defect baseline

The previous frontend requested fixed list slices:

- Providers: 1,000;
- Courses: 2,000;
- Campuses: 1,000;
- Scholarships: 1,000.

Fresh role-context testing confirmed those exact loaded sizes. Exact CRICOS Course Code `121174E` was **not present** in the 2,000-row Course slice, so the Course workspace could not reliably perform the mandatory exact-identifier audit.

Fresh live catalogue counts at audit time:

- active Providers: 3,085;
- active Courses: 35,487;
- all lifecycle Course records exposed by the default page route: 43,461;
- Campuses: 3,922;
- Scholarships: 4.

## Applied backend contract

Pilot migration:

`m1_pim_gov_catalogue_paging_v1`

Repository mirror:

`supabase/production-migrations/060_m1_pim_gov_catalogue_paging.sql`

The migration:

1. corrects `ui_courses_decision_page(...)` so Admin completeness/readiness is derived from six canonical presence signals rather than `search.course_documents.completeness_score`;
2. exposes deterministic active CRICOS `tuition + registered_total_course` amount/currency on the Course page result;
3. aligns scholarship presence with accepted course or Provider scope;
4. creates role-checked `security.admin_catalogue_page(text,jsonb)`;
5. adds governed `admin_read` operations:
   - `providers_page`;
   - `courses_page`;
   - `campuses_page`;
   - `scholarships_page`;
6. provides a server-side Campus page/search projection inside the private dispatcher;
7. revokes direct `authenticated` EXECUTE from the routed public Provider/Course/Scholarship page functions and legacy Provider/Campus/Scholarship list projections;
8. retains service-role access to underlying projections.

No Provider/Course/Campus/Scholarship identity or canonical observation is rewritten.

## Full-catalogue page UAT

Executed under the assigned `platform_admin` identity with `role=authenticated`.

Unfiltered governed totals:

- Providers: **3,085**;
- Courses across lifecycle states: **43,461**;
- Campuses: **3,922**;
- Scholarships: **4**.

Paging beyond the old frontend caps returned rows successfully:

- Provider offset 1,500: PASS;
- Course offset 2,500: PASS;
- Campus offset 1,500: PASS.

**Verdict:** PASS — decision grids are no longer restricted to the former client snapshots.

## Exact CRICOS identity UAT

`admin_read('courses_page',{query:'121174E'})` returned exactly one Course:

- UUID: `1b8be4ac-01c0-4b11-888f-083401acd784`;
- stable key: `course:cricos:00111d:121174e`;
- Course code: `121174E`;
- Provider: Swinburne University of Technology;
- deterministic CRICOS tuition: AUD **132,900**.

Canonical presence signals:

- registration: true;
- structure: true;
- fee: true;
- intake: false;
- English: false;
- description: false;
- completeness/readiness score: **50.00%**.

The previous legacy Course decision projection had reported completeness `0` because it borrowed downstream Search state. The new score is the governed six-signal Admin presence formula from `CF-CHG-001`.

**Verdict:** PASS.

## Completeness/readiness UAT

The full default Course page contains **43,461** catalogue Course records across lifecycle states.

`min_completeness=100` currently returns **0** records. This is not treated as a source-truth failure or publication verdict; it means no current Course has all six governed Admin presence signals simultaneously.

PIM Admin v2.6.0 therefore labels this workspace **Canonical presence readiness** and explicitly states that the score is not truth, approval or Search publication status.

## Security UAT

After migration, direct authenticated EXECUTE is false for:

- `ui_providers_page(...)`;
- `ui_courses_decision_page(...)`;
- `ui_scholarships_page(...)`;
- `ui_providers_list(integer)`;
- `ui_campuses_list(integer)`;
- `ui_scholarships_list(integer)`.

Authenticated EXECUTE on governed `public.admin_read(text,jsonb)` remains true.

**Verdict:** PASS.

## Cross-change regression UAT

After replacing the `admin_read` wrapper:

### Fee semantics (`CF-CHG-001`)

Exact `121174E` Course detail:

- CRICOS registered fee rows: 3;
- Provider-current rows: 0;
- unclassified rows: 0;
- Non-Tuition Fee amount zero row: 1.

### Insights (`CF-CHG-005`)

- QILT total: 2,033;
- PRISMS paired total: 1,135.

### Evidence (`CF-CHG-006`)

- governed Evidence rows: 1,567.

**Verdict:** PASS.

## Frontend source implementation — PIM Admin v2.6.0

Catalogue list screens now use 50-row governed server pages with debounced full-catalogue search, sortable decision grids, paging controls, persisted column widths and right-side details.

Notable source behaviour:

- Course search explicitly accepts Course, Provider, CRICOS/course code or stable key;
- Course code is a first-class visible grid column;
- Course grid retains **CRICOS tuition (total course)**;
- Course lifecycle can be filtered without changing identity;
- Provider/Campus/Course country values use flag + code display;
- Completeness workspace uses the same full `courses_page` contract rather than a 2,000-row sample;
- Completeness missing-signal display uses the six canonical signals returned by the backend;
- visible/package version is `PIM Admin v2.6.0`.

No frontend title/name matching is used as an identity mapping mechanism; query is only discovery, and selected records retain canonical IDs.

## Deployed browser UAT required

When the GitHub-triggered Cloudflare runtime is observable:

1. visible `PIM Admin v2.6.0`;
2. Provider total shows 3,085 and paging can move beyond 1,000;
3. Course total shows 43,461 before lifecycle filtering and paging can move beyond 2,000;
4. Campus total shows 3,922 and paging can move beyond 1,000;
5. exact search `121174E` returns one Swinburne Course;
6. that row shows Course code `121174E`, AUD 132,900 CRICOS tuition and 50% canonical-presence readiness;
7. opening the row retains the three governed CRICOS fee observations including Non-Tuition AUD 0;
8. Completeness search can find `121174E` across the full catalogue and shows its missing intake/English/description signals;
9. QILT, PRISMS and Evidence workspaces remain intact;
10. persistent resize / Reset columns / right-side detail continue to work.

## Verdict

**Full-catalogue retrieval:** PASS  
**Exact stable identity:** PASS  
**Canonical readiness semantics:** PASS  
**CRICOS tuition compatibility field:** PASS  
**Security ACL:** PASS  
**Cross-workstream regression:** PASS  
**Frontend source semantics:** PASS  
**Cloudflare deployed/authenticated browser UAT:** PENDING

`CF-CHG-20260820-007` remains OPEN until deployed browser verification passes.
