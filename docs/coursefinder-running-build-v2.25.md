# CourseFinder Running Build v2.25

**Date:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.23.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.23.md`  
**Source matrix:** `docs/coursefinder-country-authoritative-source-matrix-v1.0.md`

## Current programme position

Country ETL generation is now **PAUSED unless a country first passes the Layer 1 source-qualification gate**.

Accepted Layer 1 countries:
- Australia — PASS;
- New Zealand — PASS.

Canada:
- PAUSED/BLOCKED;
- existing canonical/history retained;
- no further institution-by-institution Course ETL under Milestone 1;
- excluded from the accepted Search Projection.

GB/US/IE/DE remain source-qualification/HOLD rather than implementation workstreams.

## Live Mumbai state at programme reset

Project: `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)

| Measure | Live count |
|---|---:|
| Providers | 3,085 |
| Courses — physical rows | 43,358 |
| Campuses | 3,922 |
| Course-Campus relationships | 47,671 |
| Evidence artifacts | 1,017 |
| Pipeline job/history rows | 948 |
| Search Documents | 33,105 |

Country populations:

| Country | Providers | Physical Courses | Accepted Search posture |
|---|---:|---:|---|
| AU | 1,546 | 26,648 | ACTIVE |
| NZ | 409 | 6,457 | ACTIVE |
| CA | 1,130 | 10,253 | BLOCKED / NOT PROJECTED |

Canada physical lifecycle state:
- active scoped rows: **2,279**;
- inactive/historical rows: **7,974**.

Accepted Search reconciliation:

`26,648 AU + 6,457 NZ = 33,105 Search Documents`

This confirms the Search Projection remains an acceptance boundary rather than a mirror of every physical canonical row.

## Layer 1 accepted state

### Australia

Production regulatory substrate:
- CRICOS Institutions;
- Courses;
- Locations;
- Course Locations;
- canonical Provider/Course/Campus identity and relationships;
- evidence/hash lineage;
- full-load and idempotency UAT previously accepted.

AU remains the reference country for Layer 1 and the first structured-enrichment country.

### New Zealand

Accepted NZQA production population:
- 409 Providers;
- 6,457 Courses/Qualifications;
- 6,457 Search Documents.

The NZ production gate remains PASS.

### Canada

Preserved work includes:
- 1,130 IRCC DLI Provider identities;
- provincial/institutional source-scoped Course identities;
- BC and Alberta degree-source work;
- historical/inactive rows and evidence;
- scope/inventory infrastructure.

Further expansion is stopped because the national Course source remains federated and has required disproportionate institution/province-specific adapter/UAT work.

No CA data is deleted by the pause.

## Source-qualified execution model

Before any future country implementation:
1. source authority is researched;
2. stable Provider/Course identifiers are proven;
3. target-population completeness/currentness is proven;
4. deterministic machine acquisition and use rights are proven;
5. only then is an ETL/Edge adapter approved for build.

This avoids repeating the Canada pattern of implementation preceding source sufficiency.

## Layer 2 structured enrichment — current priority

Priority order:
1. Australia QILT outcomes;
2. Australia PRISMS international-student measures;
3. Australia Scholarship enrichment;
4. New Zealand Education Counts;
5. New Zealand Scholarships;
6. structured UK/US outcome datasets may be evaluated independently as Layer 2 sources without opening a Layer 1 country gate.

## Scholarship domain

Migration 052 relational Scholarship hardening remains accepted.

Canonical chain:

`Scholarship -> Source Identifiers -> Offering Cycle -> Application Windows / Scopes / Eligibility / Award Tiers / Coverage`

No Scholarship records should be fabricated. First production source ingestion is now a Milestone 1 priority workstream.

## Admin/PIM state

Foundation remains available for:
- Dashboard;
- Providers;
- Courses/detail;
- Campuses;
- Course Collections;
- Categories;
- Regulatory Sources;
- Jobs;
- Review Queue;
- Scholarship/PIM configuration foundations.

Next Admin emphasis should make canonical identity/source/evidence/lifecycle/search status visible and implement the relational Scholarship workspace.

## Search state

Search currently represents the accepted AU+NZ canonical substrate only.

Do not project Canada merely because active canonical rows exist. Publication is a gate separate from canonical storage.

Structured outcome/Scholarship enrichment should update Search only after mapping and source UAT succeeds.

## Runtime/security position

Established production principles remain:
- service-role writes only from server-side runtime;
- browser uses authenticated curated RPC/API contracts;
- private evidence Storage;
- RLS/deny-by-default internal schemas;
- bounded/idempotent ingestion;
- UAT/probe functions retired after validation.

## Next build

The next build is **not another country Layer 1 ETL**.

Start separate workstreams for:
- M1 canonical architecture/meeting;
- AU QILT;
- AU PRISMS;
- Scholarship enrichment;
- Admin/PIM;
- Search/API.

Future countries remain under `SRC-QUAL` until their authoritative source passes the v2.10.23 gate.
