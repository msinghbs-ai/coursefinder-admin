# CF-CHG-20260820-007 — Catalogue paging and exact identity search

**Status:** APPLIED / DB-RPC-SECURITY PASS + FRONTEND SOURCE PASS — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 11:37 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Admin catalogue retrieval / exact identity / decision-grid correctness / security ACL

## Trigger

PIM Admin v2.5 client-filtered capped catalogue slices:

- Providers: 1,000;
- Courses: 2,000;
- Campuses: 1,000;
- Scholarships: 1,000.

Fresh live counts were larger: 3,085 active Providers, 35,487 active Courses, 3,922 Campuses and 4 Scholarships. The default full Course catalogue contains 43,461 records across lifecycle states.

Most importantly, exact CRICOS Course Code `121174E` was **not present** in the old 2,000-row Course slice. A locally formatted Course grid therefore could not reliably perform the project’s mandatory exact-code validation.

## Identity decision

Admin discovery/search must operate over the full governed catalogue. Client filtering of a capped subset is not identity resolution.

Course reconciliation remains exact stable identity. For the reference AU case this is Provider + CRICOS Course Code, never title-only matching.

## Applied backend contract

Pilot migration:

`m1_pim_gov_catalogue_paging_v1`

Repository mirror:

`supabase/production-migrations/060_m1_pim_gov_catalogue_paging.sql`

The migration:

1. replaces the Course decision-page readiness calculation with the six canonical Admin presence signals from `CF-CHG-001`:
   - registration;
   - structure;
   - fee;
   - intake;
   - English;
   - description;
2. exposes deterministic active CRICOS `tuition + registered_total_course` amount/currency;
3. aligns Scholarship presence with accepted Course or Provider scope;
4. creates role-checked `security.admin_catalogue_page(text,jsonb)`;
5. routes `providers_page`, `courses_page`, `campuses_page`, `scholarships_page` through `public.admin_read`;
6. provides server-side Campus paging/search within the private dispatcher;
7. revokes direct `authenticated` EXECUTE from the routed Provider/Course/Scholarship page functions and legacy Provider/Campus/Scholarship list projections;
8. retains service-role access to the underlying projections.

No Provider/Course/Campus/Scholarship identity or canonical observation was rewritten.

## Full-catalogue UAT

Executed under the assigned Platform Admin identity with `role=authenticated`.

Governed default totals:

- Providers: **3,085**;
- Courses across lifecycle states: **43,461**;
- Campuses: **3,922**;
- Scholarships: **4**.

Rows were successfully returned beyond all former UI caps:

- Provider offset 1,500: PASS;
- Course offset 2,500: PASS;
- Campus offset 1,500: PASS.

## Exact `121174E` UAT

`admin_read('courses_page',{query:'121174E'})` returns exactly one Course:

- UUID: `1b8be4ac-01c0-4b11-888f-083401acd784`;
- stable key: `course:cricos:00111d:121174e`;
- Provider: Swinburne University of Technology;
- CRICOS Course Code: `121174E`;
- deterministic CRICOS tuition: AUD **132,900**.

Canonical presence signals:

- registration: true;
- structure: true;
- fee: true;
- intake: false;
- English: false;
- description: false;
- Admin readiness/completeness: **50.00%**.

The legacy Course decision page had shown completeness `0` because it borrowed downstream Search state. The corrected value is canonical-presence readiness and is not approval or publication status.

## Completeness scope

The default full catalogue contains 43,461 Course records across lifecycle states. At the time of UAT, `min_completeness=100` returned **0** Courses because no current record had all six governed presence signals simultaneously.

PIM Admin v2.6 therefore explicitly labels this **Canonical presence readiness** and states that it is not truth, approval or Search publication state.

## Security after-state

Direct authenticated EXECUTE is false for the routed public Provider/Course/Scholarship page functions and legacy Provider/Campus/Scholarship list projections. Governed `public.admin_read(text,jsonb)` remains executable.

## Frontend source — PIM Admin v2.6.0

Catalogue decision grids now use 50-row server pages with debounced full-catalogue search, sortable columns, persistent widths, paging and right-side detail.

Key semantics:

- Course search covers Course, Provider, CRICOS/course code and stable key;
- CRICOS/course code is a first-class visible column;
- grid fee remains `CRICOS tuition (total course)`;
- Course lifecycle may be filtered without changing identity;
- Country values use flag + code display;
- Completeness uses the same full `courses_page` contract rather than a 2,000-row sample;
- missing-signal display uses the six canonical backend signals;
- visible/package version is `2.6.0`.

## Cross-change regression

After the new `admin_read` wrapper:

- `CF-CHG-001`: exact `121174E` detail still has 3 CRICOS fee rows, 0 Provider-current, 0 unclassified, and one valid zero Non-Tuition row;
- `CF-CHG-005`: QILT remains 2,033 and PRISMS remains 1,135 paired rows;
- `CF-CHG-006`: governed Evidence remains 1,567 artifacts.

**Technical regression verdict:** PASS.

## UAT evidence

`docs/uat/coursefinder-m1-pim-gov-catalogue-v2.6.0-uat-2026-08-20.md`

## Deployed browser UAT required for closure

1. visible `PIM Admin v2.6.0`;
2. Provider total 3,085 and paging beyond 1,000;
3. Course total 43,461 before lifecycle filter and paging beyond 2,000;
4. Campus total 3,922 and paging beyond 1,000;
5. exact `121174E` search returns one Swinburne Course;
6. row displays Course code `121174E`, AUD 132,900 CRICOS tuition and 50% canonical-presence readiness;
7. detail retains all three CRICOS fee concepts including Non-Tuition AUD 0;
8. Completeness full-catalogue search finds `121174E` and shows missing intake/English/description;
9. QILT/PRISMS/Evidence remain intact;
10. persisted resize, Reset columns and right-side detail remain functional.

## Rollback

Revert the paged frontend source and governed catalogue dispatcher independently. Do not alter canonical identity/data to roll back Admin retrieval. Reopening direct authenticated EXECUTE on SECURITY DEFINER projections requires explicit security-governance approval.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 11:37 AEST | AUDITED / OPEN | Capped client-side catalogue search proven unable to reach exact `121174E` | role-context Pilot UAT |
| 20 Aug 2026 | APPLIED | Full catalogue paging/search + canonical readiness + ACL hardening applied | `m1_pim_gov_catalogue_paging_v1` |
| 20 Aug 2026 | TECHNICAL UAT PASS | Full totals, beyond-cap paging, exact identity, readiness and regressions passed | v2.6.0 UAT |
| 20 Aug 2026 | FRONTEND SOURCE PASS | PIM Admin v2.6.0 full-catalogue decision grids staged | feature branch |

## Closure

**Final status:** OPEN — DB/RPC/SECURITY PASS + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING  
**Closed at:** N/A  
**Outcome:** Exact identifier discovery now operates over the full governed catalogue in Pilot/source; runtime browser verification remains pending.
