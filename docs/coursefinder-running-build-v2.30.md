# CourseFinder Running Build v2.30

**Date:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.28.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.28.md`  
**AU completeness UAT:** `docs/uat/coursefinder-au-geography-fields-completeness-gate-uat-v1.0.md`

## Current build position

**AU geography + Field completeness gate: PASS WITH ONE BOUNDED SOURCE-NULL CAMPUS GAP.**

Evidence-backed CRICOS replay has closed the previously missing Provider/Campus State and Course Field gaps without changing canonical identities.

Live AU state:

| Measure | Current |
|---|---:|
| Providers | 1,546 |
| Providers with direct postal subdivision | **1,546** |
| Campuses | 3,922 |
| Campuses with direct subdivision | **3,921** |
| Courses | 26,648 |
| Courses with exact ASCED primary field | **26,648** |
| Current Course field observations | **26,648** |
| Course↔Campus relationships | **47,671** |
| Courses with Course↔Campus relationship | 26,614 |
| Courses with authoritative linked State | 26,613 |
| Courses with delivery mode | 26,614 |
| Course Links | **0** |
| Course Fees | **0** |

The single unmapped Campus is Muirden Senior Secondary College, CRICOS Provider `00366C`. The authoritative CRICOS Locations row publishes both City and State as null; postcode `5000` is not used to infer South Australia.

## Field / filter correction

CRICOS `Field of Education 1 Narrow Field` is now retained as exact four-digit ASCED source evidence.

The Admin read contract now uses:
- Course State/Region from any linked Campus subdivision;
- Delivery from Course↔Campus relationship;
- Field from exact ASCED primary field;
- explicit Has State and Has Course Link readiness flags;
- active/current semantics for Has Fee.

AU filter-option UAT returns:
- 8 State/Territory options;
- 79 populated ASCED narrow fields;
- 1 delivery mode (`on_campus`).

Proof query:
- VIC + Business and Management + on-campus = 1,659 Courses;
- Missing State = 35;
- Missing Course Link = 26,648;
- Missing Fee = 26,648.

## Runtime

New maintenance worker: `layer1-au-completeness-v0.1.0`.

The worker acquires direct authoritative CRICOS CSV resources, captures evidence once and pins APPLY batches to the same content hashes. Six bounded batches completed, followed by an idempotency replay.

The earlier full ZIP-depth revision hit Supabase Edge HTTP 546 resource limits and is not the accepted path for this completeness gate.

## Identity regression

After APPLY and replay:
- Providers 1,546;
- Courses 26,648;
- Campuses 3,922;
- Course↔Campus 47,671.

No canonical identity counts changed and no duplicate Course field observations were created.

## Pilot source-control

Pilot changes include:
- `supabase/functions/layer1-au-completeness/index.ts`;
- `src/lib/supabase.js` support for `hasState` and `hasLink` course decision filters.

Browser-rendered UAT for new UI controls has not been claimed in this gate; the live backend RPC/filter contract is proven.

## Next AU data action

Proceed as a separate Layer 2 first-party Course enrichment gate for:
1. official Course URLs;
2. international Fees;
3. Intakes;
4. English requirements.

Those sources must resolve to accepted canonical Courses using stable/evidenced source keys. Zero current rows are a structured completeness signal, not permission to infer values.