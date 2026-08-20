# CourseFinder Running Build v2.57

**Status:** PIM FINALISATION INTEGRATION CANDIDATE — **TECHNICAL/BUILD PASS; DEPLOYED AUTHENTICATED BROWSER GATE BLOCKED**  
**Date:** 20 August 2026  
**Base on main:** `docs/coursefinder-running-build-v2.54.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.8.md`  
**UAT:** `docs/uat/coursefinder-m1-pim-finalisation-uat-2026-08-20.md`

## Build delta

v2.57 consolidates the open PIM governance work into the **PIM Admin v2.10.0 candidate** and replaces another generic hardening pass with the operational UI/browser-acceptance gate.

Accepted canonical Provider/Course/Campus/Scholarship, CRICOS fee, geography, taxonomy, entry, Search and publication semantics are preserved.

## Operational UI candidate

`src/finalisation.jsx` provides:

- governed role-aware information architecture;
- bounded server-paged operational lists;
- URL-backed query/filter/page/sort/detail state;
- browser Back/Forward and stored scroll context;
- cancellable/debounced reads;
- skeleton, empty, error, retry and permission states;
- responsive desktop/laptop navigation;
- sticky/resizable data grids;
- structured Provider and Campus detail;
- retained accepted Course/Scholarship semantic modules;
- Search/Publication overview;
- visible UI version `2.10.0`.

No dead Integrations or Platform Settings placeholder is promoted merely to make the menu taxonomy look complete.

## Course-scale performance

The original default 50-row Course path measured about **5.27 s** DB-side. The bounded paged-enrichment path measures about **259 ms** on the immediate warm sample; a first cold recheck measured about **2.54 s** and remains explicitly documented for deployed initial-load observation.

A further defect was found in normal derived filters: `Has fee = Yes` still fell back to the catalogue-wide rich-row path and measured about **4.29 s**.

Pilot migration:

`m1_pim_finalisation_course_derived_filters_fast_v1`

Repository mirror:

`supabase/production-migrations/075_m1_pim_finalisation_course_derived_filters_fast.sql`

After migration 075:

- `Has fee = Yes` → **~277 ms**;
- minimum Admin readiness 50% → **~442 ms**.

The accepted fee/readiness calculations are unchanged; only execution order changed. Fee/readiness catalogue-wide *ordering* remains deliberately unpromoted in the normal v2.10 grid.

## Correctness regression

Post-repair authenticated checks:

- exact CRICOS Course `121174E` → exactly 1 Course;
- exact Provider CRICOS `00025B` → exactly 1 Provider;
- `121174E` CRICOS registered fee rows → 3;
- Provider-current fee rows → 0;
- Non-Tuition Fee AUD 0 preserved;
- no CRICOS registered value was substituted as a Provider-current fee.

Provider detail still uses the repaired related-data `items` contract; UQ has 382 related Courses with a bounded 25-row preview.

## Security boundary

Current Pilot after-state:

- browser read boundary: `public.admin_read`;
- `public.admin_read` is `SECURITY INVOKER` and authenticated-executable;
- zero public `SECURITY DEFINER` functions are executable by `authenticated` or `anon`;
- no internal-schema browser CRUD was introduced;
- unassigned authenticated identities are denied Evidence, Pipeline and PIM Configuration with SQLSTATE `42501` at their governed rank thresholds.

Supabase leaked-password protection remains a separate project/Auth security warning.

## Production build gate

The finalisation branch now has a real GitHub Actions production-build gate using Node 22.

After correcting an initial workflow-only lockfile/cache configuration error:

- dependency install — PASS;
- 0 vulnerabilities reported during install;
- Vite 8.1.5 production build — PASS;
- 65 modules transformed;
- bundle emitted successfully.

The latest build after migration 075 also passed.

## Deployed runtime gate

Real Chrome Supabase API telemetry immediately before recovery showed the deployed bundle still calling legacy direct browser `ui_*` RPCs and receiving 403s after their browser EXECUTE grants were retired.

Latest observed pre-trigger browser event:

- `ui_context` at **20 August 2026 07:00:57 UTC** — HTTP 403.

A governed no-content main commit using the unchanged v2.9 source tree was issued solely to trigger the existing external Cloudflare Git rebuild:

`494a6ddcc18671abd492370410a94212c9c21deb`

Commit time: **20 August 2026 07:04:28 UTC**.

The available API telemetry contains no browser request after that trigger, the external browser tool cannot open the unindexed Workers URL, and no Cloudflare control-plane connector is available. Therefore the post-trigger deployed bundle is **not proven**.

## Change Controls

The branch carries `CF-CHG-013`, `014` and `015`, and the central register explicitly reclassifies `001`, `005`–`015` to their common remaining state:

**technical/source gates passed as recorded; deployed authenticated browser/runtime gate BLOCKED / not yet proven.**

No applicable PIM Change Control is closed from SQL/source/CI evidence.

## Preserved programme baselines

- AU CRICOS accepted baseline: 1,546 Providers / 26,648 active Courses;
- current broader Pilot: 3,085 active Providers / 35,487 active Courses / 43,461 total Course rows;
- accepted Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- Search Course Documents: 33,105;
- CRICOS registered total-course fee remains distinct from Provider-current fee;
- QILT, PRISMS and Scholarship semantic contracts remain unchanged;
- no consumer publication scope is broadened by this build.

## Current gate

**TECHNICAL UAT: PASS. Production build: PASS. Deployed authenticated browser acceptance: BLOCKED / NOT PROVEN.**

Do not promote v2.57 as browser accepted or close the open PIM Change Controls until the deployed browser checklist in the finalisation UAT passes.
