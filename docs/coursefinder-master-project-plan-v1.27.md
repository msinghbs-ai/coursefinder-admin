# CourseFinder Master Project Plan v1.27

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.26.md`  
**Last consolidated:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.27.md`  
**Running build:** `docs/coursefinder-running-build-v2.29.md`

This version retains all previously accepted Layer 1 and Layer 2 gates and adds an explicit AU completeness correction for State/Region, Course Links and Fees.

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity | PASS / ACCEPTED | Provider/Course/Campus identity and Course-Campus relationships remain accepted |
| AU Layer 1 geography completeness | **ACTIVE CORRECTION** | Populate only direct CRICOS state/postal geography; no inferred states |
| AU Course Links | **FOUNDATION READY / DATA MISSING** | Populate from qualified Layer 2 first-party/authoritative sources |
| AU Course Fees | **FOUNDATION READY / DATA MISSING** | Populate from qualified Layer 2 first-party/authoritative sources |
| NZ Layer 1 NZQA | PASS / ACCEPTED | No change |
| AU QILT Layer 2A | PASS / ACCEPTED | No change |
| AU PRISMS Layer 2A | PASS / ACCEPTED | No change |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | No change |
| Admin/PIM | IN PROGRESS | Expose true completeness gaps and related-record workspaces |
| Search/API enrichment | PENDING | Do not expose inferred State/Fee/Link facts |

## AU completeness correction

Live revalidation confirms:
- 8 AU State/Territory reference dimensions exist;
- 0/1,546 AU Providers have canonical subdivision populated;
- 0/3,922 AU Campuses have canonical subdivision populated;
- 47,671 AU Course-Campus relationships are already present;
- 0/26,648 AU Courses have structured fee observations;
- 0/26,648 AU Courses have a legacy `course_url`;
- 0 relational Course Links currently exist.

Therefore AU Layer 1 PASS continues to mean **accepted regulatory identity/relationship substrate**, not that all catalogue enrichment fields are complete.

## Phase 0 — Foundation & Architecture

**Status: COMPLETE / GOVERNED, WITH v2.10.27 CORRECTION ACCEPTED**

Architecture now explicitly separates:
- canonical country/subdivision dimensions;
- Provider primary/postal geography;
- Provider operational geography through Campuses;
- Course-Campus relationships;
- Course external Links;
- Course Fee observations.

No geography, fee or URL may become canonical merely because it can be guessed from another field.

## Phase 1 — Layer 1 Regulatory / Canonical Data

**Status: AU + NZ IDENTITY ACCEPTED; AU GEOGRAPHY COMPLETENESS CORRECTION ACTIVE**

AU identity counts remain accepted:
- Providers: 1,546;
- Courses: 26,648;
- Campuses: 3,922;
- Course-Campus relationships: 47,671.

A defect was identified in AU Location State normalisation: CRICOS abbreviations such as `NSW` were not resolving to canonical `AU-NSW` subdivision codes.

Migration 053 corrects the service resolver using exact source normalisation only. It does not infer State from postcode, city or address.

Required completion gate:
1. upgrade AU worker Provider geography payload where the CRICOS Institution source directly publishes postal state/address/postcode;
2. bounded CRICOS geography replay;
3. zero identity regression;
4. explicit unresolved-state reporting;
5. Campus State/Region completeness result recorded in UAT.

## Phase 2 — Admin / PIM UX

**Status: IN PROGRESS**

Admin must treat missing structured enrichment as a first-class quality state.

Course workspace requirements now explicitly distinguish:
- Locations/Campuses;
- Links;
- Fees;
- Intakes;
- English;
- Scholarships;
- Evidence.

Filters/readiness signals must distinguish:
- Has Campus;
- Has State/Region;
- Has Course Link;
- Has Fee.

Provider workspace must display Provider primary/postal geography separately from operational Campus coverage by State/Region.

State/Region filtering must not imply completeness while canonical subdivision coverage is absent.

## Phase 3 — Layer 2 Structured / Provider Enrichment

**Status: ACTIVE**

Existing accepted QILT, PRISMS and Scholarship gates remain unchanged.

### 3E — AU Course detail enrichment

**NEW ACTIVE/QUEUED GATE.**

Scope:
- first-party Course pages/links;
- international Course pages where distinct;
- handbook/course guide links;
- application links;
- international tuition/fee observations;
- evidence/version/replay contract.

Physical foundation:
- `catalogue.course_links` created by migration 053;
- `catalogue.course_fees` replay/source identity hardened by migration 054.

Rules:
- Provider/Course identity must already be resolved through accepted canonical identifiers/mappings;
- URL/title matching alone never creates or merges a Course;
- fees are temporal observations by year/audience/type/basis;
- campus-specific fees are stored only when explicitly published;
- ambiguous mapping is routed to review;
- all accepted values retain source/evidence lineage.

## Phase 5 — Data Quality & Human Review

Add governed queues/views for:
- Campus missing State/Region;
- Provider missing direct primary/postal subdivision;
- unrecognised published subdivision token;
- Course missing accepted Link;
- Course missing current international Fee;
- stale fee/link verification;
- ambiguous provider-course page mapping.

Do not use postcode/city inference as an automatic correction mechanism.

## Phase 6 — Search / API / Consumer Experience

State/Region search/filtering should be based on Course -> Campus -> canonical subdivision, not Provider postal subdivision.

Before Fee sorting/filtering is enabled, define:
- audience selection, particularly international;
- fee year/currentness;
- annual versus total/per-unit basis;
- multi-campus selection;
- missing/stale semantics.

Before Course Links are consumer-facing, define active primary-link selection and fallback behaviour.

## Phase 7 — Production Hardening & Operations

New required UAT invariants:
- exact subdivision alias resolution only;
- unknown subdivision token remains null;
- no Provider/Course/Campus identity changes during geography replay;
- Course-Campus count/reconciliation remains stable;
- Fee/Link Layer 2 APPLY is deterministic and idempotent;
- direct `anon`/`authenticated` access remains denied for internal canonical tables;
- advisor regressions attributable to new migrations must be resolved before gate acceptance.

## Next programme action

Proceed in this order without reopening accepted identity decisions:
1. complete the bounded AU CRICOS geography correction and UAT;
2. implement Admin State/Region completeness display against real canonical mapping;
3. qualify the first AU Provider Course-detail source pattern for Course Links and international Fees;
4. implement bounded Layer 2 Course Links/Fees ingestion and replay UAT;
5. update completeness projections;
6. then define student-facing State/Fee/Link Search semantics.
