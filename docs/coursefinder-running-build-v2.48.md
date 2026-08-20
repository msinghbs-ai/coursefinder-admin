# CourseFinder Running Build v2.48

**Status:** CURRENT GOVERNED SOURCE BUILD — CLOUDFLARE RUNTIME OBSERVATION PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.47.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.44.md`  
**Catalogue UAT:** `docs/uat/coursefinder-m1-pim-gov-catalogue-v2.6.0-uat-2026-08-20.md`

## Build delta

v2.48 preserves the accepted Layer 1, Layer 2, Search, fee, Insights and Evidence state and replaces capped client-side Catalogue discovery with governed full-catalogue server paging/search.

### PIM Admin v2.6.0

Providers, Courses, Campuses and Scholarships now use role-checked server page operations behind `public.admin_read`.

Current governed totals:

- Providers: **3,085**;
- Courses across lifecycle states: **43,461**;
- active Courses: **35,487**;
- Campuses: **3,922**;
- Scholarships: **4**.

The previous UI loaded only 1,000 Providers, 2,000 Courses and 1,000 Campuses. Exact `121174E` was absent from that Course slice.

### Exact identity reference

Full-catalogue `courses_page` search for CRICOS `121174E` now returns exactly one canonical Course:

- UUID: `1b8be4ac-01c0-4b11-888f-083401acd784`;
- stable key: `course:cricos:00111d:121174e`;
- Provider: Swinburne University of Technology;
- CRICOS tuition: AUD 132,900;
- canonical presence readiness: 50.00%.

Signals for the reference Course:

- registration: true;
- structure: true;
- fee: true;
- intake: false;
- English: false;
- description: false.

The readiness score is Admin canonical presence, not Search completeness, approval or source truth.

### Catalogue backend/security

Pilot migration:

`m1_pim_gov_catalogue_paging_v1`

Repository mirror:

`supabase/production-migrations/060_m1_pim_gov_catalogue_paging.sql`

The migration:

- corrects Course decision readiness to the six canonical signals;
- exposes deterministic CRICOS registered-total-course tuition fields;
- creates `security.admin_catalogue_page(text,jsonb)`;
- routes Provider/Course/Campus/Scholarship pages through `admin_read`;
- adds private Campus paging/search;
- removes direct authenticated EXECUTE from the routed public page/list SECURITY DEFINER functions.

Paging beyond former caps passed under assigned Platform Admin role.

## Completeness workspace

v2.6.0 uses the same full `courses_page` contract for **Canonical presence readiness** instead of a 2,000-row sample.

Current full-catalogue `min_completeness=100` total is 0. This is displayed as a presence/readiness exception state and is explicitly not interpreted as publication approval or source truth.

## Preserved governance regressions

### Fee semantics

Exact `121174E` Course detail still returns:

- three CRICOS fee concepts;
- zero Provider-current rows;
- zero unclassified rows;
- one valid Non-Tuition Fee amount of AUD 0.

### Insights

- QILT: 2,033;
- PRISMS paired rows: 1,135.

### Evidence

- governed evidence artifacts: 1,567.

## Preserved AU Layer 1 / Course Facts / Search

- AU CRICOS Providers: 1,546
- active AU CRICOS Courses: 26,648
- Layer 1 adapter: `layer1-au-depth-v1.6.0`
- qualified AU Provider-current sources: RMIT + UQ
- bounded Provider-current Courses: 10
- Search Course Documents: 33,105
- fee/intake/English Search enrichment admitted: 0

No Admin paging or readiness change grants Search/Website/Zoho publication.

## Change Control

- `CF-CHG-20260820-001` — technical/source PASS / deployed browser pending
- `CF-CHG-20260820-002` — CLOSED / PASS
- `CF-CHG-20260820-003` — DEFERRED
- `CF-CHG-20260820-004` — CLOSED / PASS
- `CF-CHG-20260820-005` — technical/source PASS / deployed browser pending
- `CF-CHG-20260820-006` — technical/source PASS / deployed browser pending
- `CF-CHG-20260820-007` — full-catalogue paging/exact identity technical/source PASS / deployed browser pending

## Documentation decision

Updated:

- Running Build → v2.48
- Master Plan → v1.44
- Catalogue paging UAT
- Change Control record/register
- executable repository migration 060

Unchanged because canonical entity semantics did not change:

- Database Architecture remains v2.10.37
- PIM Admin Guide v1.0 remains semantically authoritative
- Zoho consumer contract unchanged
- Search contract unchanged

## Remaining runtime gate

The current tool environment cannot independently observe the unindexed Cloudflare Worker runtime. Deployed authenticated browser UAT remains required before open PIM governance records close.
