# CourseFinder Running Build v2.43

**Status:** CURRENT RUNNING BUILD  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.42.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.39.md`  
**UQ v3 UAT:** `Coursefinder-Pilot/docs/m1-l2-au-course-facts-uq-expansion-v3-uat-2026-08-20.md`  
**QUT UAT:** `Coursefinder-Pilot/docs/m1-l2-au-course-facts-qut-deferred-uat-2026-08-20.md`

## Build delta

`M1-L2-AU-COURSE-FACTS` remains **IN PROGRESS**.

This build contains two independent outcomes:

1. the qualified UQ source class expanded from four to eight exact CRICOS Courses and passed fresh dry-run/APPLY/replay UAT;
2. QUT was assessed as a third source candidate but remains **DEFERRED** because its official public Course pages return HTTP 403 to the production Supabase Edge runtime.

QUT did not block continued expansion through accepted sources and contributed zero canonical Layer 2 facts.

## Preserved Layer 1 baseline

- Providers: 1,546
- active CRICOS Courses: 26,648
- production adapter: `layer1-au-depth-v1.6.0`
- missing Study Level: 0
- 34 Campus gaps: authoritative source absence
- unexplained Layer 1 mapping defects: 0

## Qualified Course Facts sources

### RMIT University

- Provider CRICOS: `00122A`
- source: `au_rmit_official_course_pages`
- worker: `coursefacts-au-rmit-v0.2.0`
- qualification: qualified
- bounded exact Courses: 2

### The University of Queensland

- Provider CRICOS: `00025B`
- source: `au_uq_official_program_pages`
- worker: `coursefacts-au-uq-v0.3.0`
- qualification: qualified
- bounded exact Courses: 8
- Edge Function version: 3
- deployment SHA-256: `3ee7aade7fca8f075d49b8e1755a166bdf64ed55fe434bf12d2afca8eb156b94`

Current UQ exact CRICOS set:

- `102784C`
- `082960F`
- `045401M`
- `013827E`
- `019886A`
- `001942A`
- `080734K`
- `092454G`

## Deferred candidate — QUT

- Provider CRICOS: `00213J`
- source: `au_qut_official_course_pages`
- worker: `coursefacts-au-qut-v0.1.1`
- qualification: deferred
- APPLY admitted: false
- Search admitted: false
- runtime dry-run `1909`: HTTP 403
- browser-equivalent retry `1910`: HTTP 403
- accepted QUT Layer 2 facts: 0

No challenge bypass or anti-bot circumvention was attempted.

## UQ v3 UAT

- dry-run `1912`: PASS
- APPLY `1913`: PASS
- replay `1914`: PASS
- exact CRICOS resolution: PASS for all 8 records
- source proof: PASS for all 8 records
- replay source-record identity: stable
- canonical duplicate growth: 0
- canonical Course URL mutations: 0

Post-replay UQ state:

- links: 8
- Provider-current fees: 8
- intakes: 15
- governed English requirements: 24

## Aggregate accepted Course Facts state

Across qualified RMIT + UQ sources:

- qualified source classes: 2
- exact bounded CRICOS Courses: 10
- official Course links: 10
- Provider-current international fees: 10
- intakes: 18
- governed English requirements: 32

Provider-current fees remain separate from CRICOS registered total-course fees and retain their Provider-published year/basis.

## Search isolation

Verified after UQ APPLY/replay:

- Search Course Documents: 33,105
- Search rows with fee/intake/English enrichment admitted: 0

No Search enrichment admission occurred.

## Production migration delta

- `20260820004729_m1_l2_au_coursefacts_qut_source_v1`
- `20260820004902_m1_l2_au_coursefacts_qut_defer_v1`
- `20260820005253_m1_l2_au_coursefacts_uq_coverage_v3`

## Change Control

- `CF-CHG-20260820-003` — QUT Course Facts acquisition — DEFERRED
- `CF-CHG-20260820-004` — UQ Course Facts coverage expansion v3 — CLOSED / PASS

## Documentation decision

Updated because current production coverage/status changed:

- Running Build -> v2.43
- Master Project Plan -> v1.39
- resolved historical Course Facts gap snapshot -> v1.3
- Pilot UAT/worker/migration lineage
- Change Control register

Not updated because the canonical contract did not change:

- Database Architecture remains v2.10.37
- PIM Admin Guide unchanged
- Search contract unchanged
- Zoho contract unchanged

## Current serial position

1. `M1-L1-AU-CRICOS-COMPLETENESS` — PASS / COMPLETE
2. `M1-L2-AU-COURSE-FACTS` — IN PROGRESS / 2 QUALIFIED SOURCES / 10 COURSES BOUNDED
3. further coverage through production-fetchable qualified sources — ACTIVE
4. additional Provider source qualification — ACTIVE, source-specific blockers may defer independently
5. Search enrichment readiness — BLOCKED / SEPARATE GATE
