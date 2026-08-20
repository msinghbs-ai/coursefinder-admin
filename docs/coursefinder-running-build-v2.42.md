# CourseFinder Running Build v2.42

**Status:** CURRENT RUNNING BUILD  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.41.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.38.md`  
**Layer 2 UAT:** `Coursefinder-Pilot/docs/m1-l2-au-course-facts-uq-expansion-uat-2026-08-20.md`  
**Change Control:** `change-control/40-layer2-enrichment/CF-CHG-20260820-002-uq-course-facts-coverage-expansion.md`

## Build delta

`M1-L2-AU-COURSE-FACTS` remains **IN PROGRESS / TWO SOURCE CLASSES QUALIFIED**.

The already-qualified UQ source class has now passed its first controlled coverage expansion. No new architecture semantic contract was introduced; Architecture v2.10.37 remains authoritative.

## Preserved Layer 1 baseline

- AU Providers: 1,546
- active CRICOS Courses: 26,648
- production adapter: `layer1-au-depth-v1.6.0`
- missing Study Level: 0
- 34 Campus gaps: authoritative CRICOS source absence
- unexplained Layer 1 mapping defects: 0

## Qualified Layer 2 sources

### RMIT

- source: `au_rmit_official_course_pages`
- Provider CRICOS: `00122A`
- worker: `coursefacts-au-rmit-v0.2.0`
- status: qualified
- bounded Courses: 2

### The University of Queensland

- source: `au_uq_official_program_pages`
- Provider CRICOS: `00025B`
- worker: `coursefacts-au-uq-v0.2.0`
- status: qualified
- bounded Courses: 4

UQ now includes:

- `102784C` — Bachelor of Computer Science (Honours)
- `082960F` — Bachelor of Nursing (Honours)
- `045401M` — Bachelor of Commerce/Bachelor of Information Technology
- `013827E` — Bachelor of Science/Bachelor of Arts

## Aggregate accepted Course Facts state

Across RMIT and UQ:

- qualified Provider source classes: 2
- bounded exact CRICOS Courses: 6
- official Course links: 6
- Provider-current international fees: 6
- intakes: 10
- governed English requirements: 20

No canonical Provider/Course identity changed.

## UQ coverage-expansion UAT

Worker: `coursefacts-au-uq-v0.2.0`  
Live Edge Function version: 2

- canonical identity preflight for `045401M` and `013827E`: PASS
- fresh dry-run request `1906`: PASS
- APPLY request `1907`: PASS
- replay request `1908`: PASS
- source proof: PASS for all four UQ records
- unchanged page hashes reused source-record IDs: PASS
- post-replay UQ cardinality: 4 links / 4 fees / 7 intakes / 12 English rows
- canonical Course URL mutation: 0
- title-only mapping introduced: no

Provider-current fee semantics remain `provider_current_tuition` with 2027 year and published `indicative_annual` basis for the new UQ rows.

## Search isolation

Search remains unchanged:

- Course Documents: 33,105
- rows with fee/intake/English enrichment: 0

No Search enrichment admission occurred.

## Production delta

- Edge worker upgraded: `coursefacts-au-uq-v0.1.0` -> `coursefacts-au-uq-v0.2.0`
- production migration: `20260820004354_m1_l2_au_coursefacts_uq_coverage_v2`
- Change Control: `CF-CHG-20260820-002` CLOSED / PASS

## Documentation decision

Updated because production coverage changed:

- Running Build -> v2.42
- Master Project Plan -> v1.38
- historical Course Facts gap snapshot -> v1.2
- Pilot UAT -> new UQ expansion record
- Change Control register -> indexed

Not versioned because semantics did not change:

- Database Architecture remains v2.10.37
- PIM Admin Guide unchanged
- Zoho contract unchanged
- Search contract unchanged

## Current serial position

1. `M1-L1-AU-CRICOS-COMPLETENESS` — PASS / COMPLETE
2. `M1-L2-AU-COURSE-FACTS` — IN PROGRESS / TWO SOURCE CLASSES QUALIFIED / SIX COURSES BOUNDED
3. further qualified-source coverage and additional Provider source qualification — ACTIVE NEXT
4. Search enrichment readiness — BLOCKED / SEPARATE GATE

The accepted Layer 1 substrate, PIM hardening decision and vector-search rejection remain unchanged.
