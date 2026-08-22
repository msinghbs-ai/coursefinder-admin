# CourseFinder Running Build v2.63

**Status:** **ACCESS ADMIN / UAT HARNESS / DATA QUALITY HARDENING CLOSED / PASS**  
**Date:** 23 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.62.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.39.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.14.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.13.md`

## Accepted release position

Current accepted Admin runtime:

`PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0 + Data Quality v1.0 + Access Admin v1.0`

Accepted Pilot head:

`msinghbs-ai/Coursefinder-Pilot@e877e3e28cd281ff3751a70bc500eeb0d8f31963`

Visible marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · governed`

PIM Admin remains v2.12; no PIM v2.13 release is claimed.

## Access Admin v1.0 — accepted

Platform Admin rank 6 can administer governed user access through Users & Roles without exposing the Supabase service-role key to browser code.

Accepted deployed workflow includes:

`create controlled Curator → replace role → add/remove expiry → restore Curator → disable → re-enable`.

Final account state was reconciled server-side as enabled, Curator, no expiry. Audit history records role replacement, user create, disable and enable events without passwords/tokens.

Server lockout protections reject Platform Admin self-disable/self-removal and last-active-Platform-Admin removal/disablement.

`CF-CHG-20260822-020` — **CLOSED / PASS**.

## Data Quality aggregate hardening — accepted

Data Quality semantics remain unchanged, but aggregate execution is now:

- private timestamped AU+NZ/AU/NZ overview snapshots;
- server refresh every 15 minutes;
- operator-visible computation timestamp/freshness;
- live bounded/paged exception drill-down;
- bounded Dashboard recent-activity aggregation.

The authenticated 8-second database statement timeout was not increased.

Representative post-hardening reads:

- Data Quality overview ~16–22 ms warm;
- overview ~16 ms while scheduled recomputation is running;
- Dashboard ~75 ms warm / ~558 ms during refresh.

AU+NZ regulatory fee remains exactly:

- 26,326 present;
- 191 source-null;
- 6,457 not-applicable;
- 131 zero;
- 99.28% readiness.

`CF-CHG-20260823-021` — **CLOSED / PASS**.

## Responsive correction

The automated mobile gate identified a genuine responsive defect: below 820px the fixed Data Quality shell did not provide a bounded vertical scroll container for `.dq-main`, making lower domains unreachable.

The mobile workspace now has an explicit full-height scroll container with momentum scrolling. This change does not alter Data Quality semantics.

## UAT Harness v1.0 — accepted

Final deployed run:

`32600027592`

Target:

`coursefinder-pilot.techm.workers.dev`

Results:

- Chromium desktop: **3/3 PASS** in 25.5 s;
- Chromium mobile / Pixel 7: **3/3 PASS** in 23.3 s;
- all six final runtime records: **0 HTTP 5xx / 0 HTTP 4xx / 0 console/page errors**;
- SHA-bound desktop and mobile commit contexts: **success**.

Final artefacts:

- desktop `9482641524`, digest `sha256:8dddfadd2c970037030f2ecf6efb4f25d73c6c8dc2a2c134e68c63c78e666666`;
- mobile `9482641597`, digest `sha256:e601d52976be082e7db17c878fee5b207c0d9a80e16574eb2f4fe21d01fef2de`.

`CF-CHG-20260822-019` — **CLOSED / PASS**.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 Courses;
- NZ: 409 Providers / 6,457 Courses;
- AU+NZ: 1,955 Providers / 33,105 Courses;
- all-country Courses: 43,461;
- Search projection: 33,105 Course documents;
- Campuses: 3,922;
- Scholarships: 4;
- accepted AU Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- Search admission remains independent from publication;
- no canonical identity/factual value was changed by this release.

## Live architecture additions

- `security.user_access_events` and service-only Access Admin helper RPCs;
- JWT-protected `admin-user-management` Edge Function;
- private `security.data_quality_overview_snapshots`;
- 15-minute `coursefinder-data-quality-overview-refresh` database schedule;
- bounded Dashboard recent-activity execution.

See Database Architecture v2.10.39.

## Current gates

**M1-PIM-FINALISATION: CLOSED / PASS.**  
**M1-PIPELINE-OPS: CLOSED / PASS.**  
**M1-EVIDENCE-UX: CLOSED / PASS.**  
**M1-DATA-QUALITY-READINESS: CLOSED / PASS.**  
**M1-UAT-HARNESS: CLOSED / PASS.**  
**ACCESS ADMIN v1.0: CLOSED / PASS.**  
**CF-CHG-021 DQ CONCURRENT HARDENING: CLOSED / PASS.**
