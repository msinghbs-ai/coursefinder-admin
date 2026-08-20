# CourseFinder Running Build v2.57

**Status:** PIM FINALISATION INTEGRATION CANDIDATE — DEPLOYED AUTHENTICATED BROWSER UAT PENDING  
**Date:** 20 August 2026  
**Base on main:** `docs/coursefinder-running-build-v2.54.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.8.md`  
**UAT:** `docs/uat/coursefinder-m1-pim-finalisation-uat-2026-08-20.md`

## Build delta

v2.57 consolidates the open PIM governance work into **PIM Admin v2.10.0** and replaces another generic hardening pass with the operational UI/browser-acceptance gate.

Accepted canonical Course/Provider/Campus/Scholarship, fee, taxonomy, entry, Search and publication semantics are preserved.

## Operational UI

The new `src/finalisation.jsx` shell provides:

- governed role-aware information architecture;
- server-paged operational lists;
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

The branch entrypoint now loads the v2.10 shell. The v2.9 source remains available for rollback/history.

## Course-scale performance

Default 50-row Course DB execution reduced from about **5.27 seconds** to **260 ms** by moving enrichment after pagination. Exact CRICOS Course search measured about 167 ms.

Fee/readiness catalogue-wide sorts are not exposed as normal clickable v2.10 grid controls until their derived path is independently optimised.

## Correctness fixes

- Provider detail now consumes related helper `items` rather than nonexistent `rows`; UQ returns 382 related Courses with a bounded 25-row preview.
- PIM configuration maps to `pim.attribute_definitions` and `pim.completeness_requirements`, not obsolete table names.
- Search/Publication summary uses a narrow covering index to avoid a cold wide-document scan.

## Security boundary

- normal browser reads route through `public.admin_read`;
- no internal-schema browser CRUD was introduced;
- legacy `public.ui_*` SECURITY DEFINER browser EXECUTE has been revoked;
- role denials were proved for unassigned authenticated identities;
- menu role thresholds match server contracts;
- Supabase leaked-password protection remains an unrelated project-level open warning.

## Change Controls

The branch carries and updates:

- CF-CHG-20260820-013 — Operations role boundary;
- CF-CHG-20260820-014 — PIM Attribute/Completeness governance;
- CF-CHG-20260820-015 — PIM operational UI/browser acceptance.

The central register now indexes 001–015. PIM records requiring deployed browser acceptance remain OPEN.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- accepted Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- Search Course Documents observed during the gate: 33,105;
- Search remains a governed derived projection;
- CRICOS registered total-course fee remains distinct from Provider-current fee;
- QILT, PRISMS and Scholarship semantic contracts remain unchanged;
- no consumer publication scope is broadened by this build.

## Deployment boundary

Source transformation/JSX acceptance and live Pilot DB/RPC/security/performance UAT pass. The environment does not have a usable remote dependency bootstrap/CI path for a fresh branch Vite build, and no authenticated deployed browser session has been exercised from this workstream.

**Do not mark v2.57 as browser accepted or close the open PIM Change Controls until the Cloudflare deployment and authenticated browser walkthrough pass.**
