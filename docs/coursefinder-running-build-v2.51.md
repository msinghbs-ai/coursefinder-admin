# CourseFinder Running Build v2.51

**Status:** CURRENT GOVERNED SOURCE BUILD — CLOUDFLARE RUNTIME OBSERVATION PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.50.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.47.md`  
**Taxonomy UAT:** `docs/uat/coursefinder-m1-pim-gov-taxonomy-semantics-uat-2026-08-20.md`

## Build delta

v2.51 preserves v2.50 and adds `CF-CHG-20260820-010`: governed Course taxonomy source-lineage visibility.

## Taxonomy read contract

Pilot migration: `m1_pim_gov_taxonomy_semantics_v1`  
Repository mirror: `supabase/production-migrations/063_m1_pim_gov_taxonomy_semantics.sql`

Course detail now gains `taxonomy_summary` through `public.admin_read`, containing:

- Study Level source scheme/registration/source vocabulary;
- mapping status and canonical Study Level;
- validity/snapshot/observation/verification context;
- Field source code/name and canonical Field identity;
- source/evidence for both mapping classes.

No canonical Course, Study Level or Field rows were changed.

## Reference case — CRICOS 121174E

Study Level mapping:

- source: `Bachelor Degree`;
- canonical: `bachelor` / `Bachelor`;
- mapping status: `mapped`.

Field mapping:

- source: `0201` / `Computer Science`;
- canonical: `asced-0201` / `Computer Science`;
- primary: true.

CRICOS regulatory evidence is retained for both.

## Frontend state

Current frontend source remains PIM Admin v2.6.0. Planned v2.7 semantic Course-detail presentation should combine open `CF-CHG-008`, `009` and `010` presentation requirements.

## Governance outputs

- PIM Admin Guide v1.3;
- `CF-CHG-20260820-010`;
- taxonomy semantic UAT;
- migration 063.

## Preserved controls

- exact/stable identity before names;
- original source vocabulary remains recoverable after normalisation;
- Provider geography != Course delivery geography;
- Intake/English remain repeating observations;
- fee semantic separation retained;
- Search/Website/Zoho admission remains independent.

Database Architecture remains v2.10.37 because the canonical taxonomy model did not change.

## Next PIM-GOV work

1. implement/source-test the planned v2.7 Course-detail semantic presentation;
2. audit Scholarship compound eligibility/scope and lifecycle/publication semantics;
3. continue Zoho curated-contract review;
4. complete deployed browser UAT when Cloudflare runtime observation is available.
