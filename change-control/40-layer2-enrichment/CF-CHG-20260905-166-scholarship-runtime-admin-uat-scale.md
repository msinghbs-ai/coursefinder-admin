# CF-CHG-20260905-166 — Scholarship Runtime Admin, Scale & UAT

**Milestone:** M2.4.5  
**Status:** IMPLEMENTED / RUNTIME PASS  
**Scope:** Scholarship acquisition, Admin/PIM operations, Provider/Course cross-reference, UAT and efficiency hardening.

## Outcome

CourseFinder Scholarships now have one governed runtime path for **Country** and **University** scope. The operator workflow is:

`scope preview → first-party catalogue acquisition → international-only candidate gate → detail acquisition → Evidence normalisation → Scholarship extraction/source record → review/canonical reconciliation`.

The runtime remains fail-closed:

- international-only automatic acquisition;
- no automatic canonical mutation;
- no automatic publication;
- catalogue/filter pages remain Evidence/enumeration and are not individual Scholarships;
- ambiguous eligibility remains review-required;
- Course financial calculations remain blocked until exact Scholarship fee scope/basis/year and a concrete Course fee row align.

## Minimal Admin settings

Private `pipeline.scholarship_runtime_settings` stores only operator-maintained runtime defaults per country:

- Runtime enabled;
- Detail jobs per batch;
- Auto-dispatch qualified detail jobs;
- Catalogue refresh hours;
- Detail refresh hours.

Scraper credentials, quotas, concurrency and route priority remain authoritative under **Administration → Scraper Config** and are not duplicated in Scholarship settings.

The settings table has RLS enabled. Browser roles have no direct table access. PIM Admin+ writes settings through guarded `public.scholarship_runtime_settings_write(jsonb)`.

## Runtime control

New Edge Function: `scholarship-runtime-control` (`verify_jwt=true`).

Supported scope:

- Country;
- University.

Supported actions:

- Preview — read-only;
- Start — governed acquisition jobs only.

The Edge Function reads the authenticated CourseFinder role, reads private settings server-side and calls the existing catalogue/detail scope services. Publication remains explicitly blocked.

## Scholarship module UX

A dedicated Scholarship Operations workspace now provides:

- live canonical/candidate/source/mapping statistics;
- sortable Provider coverage statistics;
- Country/University Preview and Start controls;
- descriptive Scholarship catalogue search;
- sortable Scholarship, University, Award, Year, Closing Date, mapped Courses, Evidence and update fields;
- recent governed scope runs;
- embedded UAT results.

The existing Scholarship Selection workspace now includes **Selection & cross-reference** and **Operations, Catalogue & UAT**.

Administration → Scraper Config includes a collapsed **Scholarship runtime settings** section so the five essential defaults remain in the existing acquisition-control menu rather than creating a duplicate configuration surface.

## Provider and Course cross-reference

Provider detail now returns `scholarship_context` via guarded `security.admin_provider_scholarships(uuid)`, including Provider Scholarship inventory and mapped-Course counts.

Course detail continues to use guarded `security.admin_course_scholarships(uuid)`, including structured award fields and Course financial calculation status. A calculated saving/net fee is exposed only when the fail-closed fee calculation contract passes.

## Search and descriptive catalogue

`public.ui_scholarships_page` now searches Scholarship name, Provider, stable key, description, award text, Scholarship type and academic year.

Additional display fields include description excerpt, structured award, application dates, cycles/windows, Evidence count, mapped Course count and review Course count.

## UAT

Runtime UAT is exposed through `security.admin_scholarship_runtime_uat(text)` and the Admin Scholarship UAT tab.

Current AU runtime result: **11/11 PASS**.

Checks cover:

1. runtime settings RLS;
2. no direct browser table access;
3. international-only policy;
4. publication blocked;
5. scope service present;
6. detail batch service present;
7. Provider Scholarship cross-reference;
8. Course Scholarship cross-reference;
9. financial calculations fail closed;
10. Scholarship source Evidence retained;
11. acquisition jobs carry no mass-publication authorisation.

## Efficiency hardening

Worker `scholarship-scope-job-execute` advanced to v5:

- reuses normalised Evidence where available;
- detects and recovers concurrent normalisation collisions;
- converts `catalogue_enumeration_required` into a successful governed catalogue skip instead of a false failed job;
- preserves source and normalised Evidence lineage;
- performs no canonical/publication mutation.

Scheduler lease reduced from 30 minutes to 10 minutes, with a three-attempt ceiling. Stale jobs are recovered; exhausted jobs fail visibly instead of looping indefinitely.

Scope requests now roll up to `completed` or `completed_with_errors` when all child jobs finish.

## AU scale run evidence

A current AU Country run was executed after the runtime control was installed:

- 1,546 Providers in scope;
- 11 executable first-party catalogue profiles;
- 11 catalogue jobs dispatched;
- 25 qualified detail jobs queued in the first bounded batch;
- 20 detail jobs immediately dispatched by scheduler cap;
- initial five false failures were classified as 4 catalogue skips + 1 normalisation collision;
- after worker v5 retry, all five completed successfully without a country refetch;
- current recent Scholarship runtime cohort reached 115 succeeded jobs with no failed jobs in the active window.

Observed acquisition efficiency in the initial current run window:

- 30 Layer2 acquisition jobs succeeded;
- 17 reused shared fetch Evidence;
- 9 required Firecrawl;
- 4 used direct HTTP;
- Parse.bot/ZenRows were not needed for that cohort.

## Current data snapshot

At runtime verification:

- canonical Scholarships: **213**;
- published: **0** (intentional hold);
- Scholarship source records: **333**;
- captured source records: **74**;
- discovery candidates: **1,162**;
- detail-ready: **141**;
- needs review: **560**;
- catalogue/filter: **59**;
- Course mappings: **5,540**;
- Courses with mapped Scholarship: **2,606**;
- calculated net-fee rows: **0** — intentional until exact fee scope/basis/year reconciliation passes.

## Pilot replay artefacts

- `supabase/migrations/20260904215000_cf_166_scholarship_runtime_admin_settings_and_cross_reference.sql`
- `supabase/migrations/20260904215100_cf_167_scholarship_catalogue_search_sort_descriptive_columns.sql`
- `supabase/migrations/20260904215200_cf_168_scholarship_runtime_uat_and_operational_stats.sql`
- `supabase/migrations/20260904220500_cf_169_scholarship_runtime_idempotent_retry_support.sql`
- `supabase/migrations/20260904221000_cf_170_scholarship_runtime_job_lease_and_request_rollup.sql`
- `supabase/functions/scholarship-runtime-control/index.ts`
- `supabase/functions/scholarship-scope-job-execute/index.ts`
- `src/ScholarshipRuntimeWorkspace.jsx`
- `src/scholarship-runtime.css`
- `src/scholarship-selection-entry.jsx`
- `src/layer2-provider-entry.jsx`

## Remaining gates

- Continue first-party Provider catalogue qualification beyond the current 11 AU executable Provider routes; the route gap is still large.
- Do not mass-publish the 213 canonical Scholarships until review/publication policy is explicitly approved.
- Reconcile exact Scholarship fee applicability and current Provider fee year/basis before enabling calculated net-fee rows.
- Add deployed browser UAT for the new Scholarship workspace once the current Pilot front-end deployment is confirmed.
