# CourseFinder Master Project Plan v1.44

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.43.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.48.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 active Course substrate |
| AU Layer 1 residual completeness remediation | PASS / COMPLETE | `layer1-au-depth-v1.6.0`; zero missing Study Levels; zero unexplained mapping defects |
| AU first-party Course facts | IN PROGRESS / 2 QUALIFIED SOURCES / 10 COURSES BOUNDED | RMIT + UQ accepted; controlled expansion continues |
| QUT Course Facts candidate | DEFERRED / SOURCE-SPECIFIC | Production Edge acquisition returns HTTP 403; APPLY disabled |
| AU QILT Layer 2A | PASS / ACCEPTED | 2,033 Provider outcome observations retained |
| AU PRISMS Layer 2A | PASS / ACCEPTED | 2,270 raw observations / 1,135 paired source rows retained |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents |
| Vector/semantic Search | REJECTED / NOT ADMITTED | Existing rejection remains in force |
| Search enrichment readiness | BLOCKED / SEPARATE GATE | Layer 2 facts are not automatically consumer-admitted |
| Admin/PIM hardening | PASS / COMPLETE | Existing acceptance remains in force |
| M1-PIM-GOV fee semantics | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-001` |
| M1-PIM-GOV Insights restoration | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-005` |
| M1-PIM-GOV Evidence provenance | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-006` |
| **M1-PIM-GOV Catalogue paging/exact identity** | **DB/RPC/SECURITY + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING** | `CF-CHG-20260820-007`; capped client search retired from catalogue decision grids |

## PIM Admin v2.6.0

v2.6.0 retains the accepted fee, QILT/PRISMS and Evidence semantics and makes Catalogue discovery operate over the full governed catalogue.

### Full-catalogue retrieval contract

Current governed page totals:

- Providers: 3,085;
- Courses across lifecycle states: 43,461;
- active Courses: 35,487;
- Campuses: 3,922;
- Scholarships: 4.

The preceding frontend snapshots were capped at 1,000 Providers, 2,000 Courses and 1,000 Campuses. This was incompatible with exact identity audit because an entity outside the loaded slice was invisible to local search.

Catalogue pages now use 50-row server paging with full-query search behind `public.admin_read`.

### Exact CRICOS reference

Full-catalogue search `121174E` returns one canonical Course:

- `course:cricos:00111d:121174e`;
- Swinburne University of Technology;
- AUD 132,900 CRICOS registered-total-course tuition;
- 50.00% canonical-presence readiness.

The Course was absent from the old 2,000-row UI slice, which proves why title/local-slice discovery cannot serve as identity reconciliation.

### Admin readiness definition

Course readiness remains six explicit canonical presence signals:

1. registration;
2. structure;
3. fee;
4. intake;
5. English;
6. description.

It is not source truth, approval, freshness or Search publication.

The exact `121174E` signals are true/true/true/false/false/false = 50%.

The default full catalogue currently has zero Courses at 100% across all six signals. This is an exception/readiness result, not permission to manufacture values.

### Security boundary

Pilot migration:

`m1_pim_gov_catalogue_paging_v1`

Repository mirror:

`supabase/production-migrations/060_m1_pim_gov_catalogue_paging.sql`

The browser uses:

`public.admin_read` → role-checked `security.admin_catalogue_page` → accepted page projection/private Campus page.

Direct authenticated EXECUTE is removed from routed public Provider/Course/Scholarship page functions and legacy Provider/Campus/Scholarship list projections.

## Preserved PIM semantic contracts

### Fees

CRICOS registered fees remain distinct from Provider-current fees. Exact `121174E` retains the three source concepts including Non-Tuition AUD 0 and source-not-supplied year.

### QILT

QILT remains Provider outcomes enrichment with accepted canonical Provider cross-link only.

### PRISMS

PRISMS remains aggregate geography/study-area/sector/remoteness/time observations with no manufactured Provider/Course identity.

### Evidence

Evidence remains provenance, not truth or approval. All 1,567 current artifacts remain reachable through the Curator+ governed route.

## Consumer boundary

Search remains:

- Course Documents: 33,105;
- fee/intake/English enrichment admitted: 0.

Full Admin visibility does not grant Search, Website or Zoho publication.

## Current Change Control

- `CF-CHG-20260820-001` — fee semantics/Admin Guide — technical + source PASS, deployed browser pending
- `CF-CHG-20260820-002` — UQ first expansion — CLOSED / PASS
- `CF-CHG-20260820-003` — QUT acquisition — DEFERRED
- `CF-CHG-20260820-004` — UQ v3 expansion — CLOSED / PASS
- `CF-CHG-20260820-005` — Insights restoration — technical + source PASS, deployed browser pending
- `CF-CHG-20260820-006` — Evidence provenance — technical + source PASS, deployed browser pending
- `CF-CHG-20260820-007` — catalogue paging/exact identity — technical + source PASS, deployed browser pending

## Next PIM-GOV work

1. continue semantic audit of Scholarship, Provider/Campus detail, lifecycle/publication, Review Queue and source/operations presentation;
2. preserve stable identity and explicit source grain across every workspace;
3. create separate Change Control only for materially distinct defects;
4. complete deployed browser UAT for open PIM governance records when runtime observation becomes available;
5. keep Search/Website/Zoho admission independently governed.

Database Architecture remains v2.10.37 because no canonical relational model changed.
