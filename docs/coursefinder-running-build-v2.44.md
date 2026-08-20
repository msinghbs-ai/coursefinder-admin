# CourseFinder Running Build v2.44

**Status:** CURRENT RUNNING BUILD  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.43.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.40.md`  
**PIM-GOV UAT:** `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`  
**UQ v3 UAT:** `Coursefinder-Pilot/docs/m1-l2-au-course-facts-uq-expansion-v3-uat-2026-08-20.md`  
**QUT UAT:** `Coursefinder-Pilot/docs/m1-l2-au-course-facts-qut-deferred-uat-2026-08-20.md`

## Build delta

Two independent programme lanes are preserved in this build.

### `M1-L2-AU-COURSE-FACTS`

Remains **IN PROGRESS** with the accepted v2.43 position unchanged:

1. RMIT + UQ remain the two qualified production-fetchable Provider source classes;
2. ten exact CRICOS Courses have bounded accepted Provider-current Course Facts;
3. QUT remains **DEFERRED** because its official public Course pages return HTTP 403 to the production Supabase Edge runtime;
4. Search enrichment remains blocked behind its separate admission gate.

### `M1-PIM-GOV`

Now **IN PROGRESS — DB/RPC/GOVERNANCE UAT PASS / FRONTEND RELEASE PENDING**.

The first governed semantic walkthrough used exact CRICOS Course Code `121174E` and proved:

- the canonical three CRICOS registered fee concepts are stored correctly, including `non_tuition = AUD 0` and `fee_year = NULL`;
- CRICOS registered total-course fees remain separate from Provider-current fees;
- the Course grid compatibility fee is now deterministically CRICOS tuition with `basis=registered_total_course` rather than an arbitrary recent fee observation;
- Admin fee/intake/English presence signals now derive from canonical/relational observations rather than downstream Search projection flags;
- Course-detail fee summary now carries fee-level validity, campus, source, evidence, snapshot and verification metadata;
- unclassified active fee semantics are isolated for review rather than mislabeled;
- direct authenticated execution of the corrected internal completeness function was removed;
- the living PIM Admin Guide and curated Zoho consumer contract were established.

The frontend/browser semantic release remains required before `CF-CHG-20260820-001` closes.

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

Current governed Search remains:

- Search Course Documents: 33,105
- Search rows with fee/intake/English enrichment admitted: 0

The PIM semantic/read-contract correction does not broaden Search or consumer publication.

## PIM governance migration delta

Pilot-applied migrations:

- `m1_pim_gov_fee_semantics_read_contract_v1`
- `m1_pim_gov_fee_semantics_acl_fix_v1`

Repository mirrors:

- `supabase/production-migrations/056_m1_pim_gov_fee_semantics_read_contract.sql`
- `supabase/production-migrations/057_m1_pim_gov_fee_semantics_acl_fix.sql`

No canonical Provider/Course identity or canonical fee observation was rewritten.

## Existing Course Facts production migration delta

Preserved from v2.43:

- `20260820004729_m1_l2_au_coursefacts_qut_source_v1`
- `20260820004902_m1_l2_au_coursefacts_qut_defer_v1`
- `20260820005253_m1_l2_au_coursefacts_uq_coverage_v3`

## Change Control

- `CF-CHG-20260820-001` — PIM field semantics / Admin Guide — APPLIED / DB-RPC-GOVERNANCE UAT PASS / FRONTEND PENDING
- `CF-CHG-20260820-002` — UQ first Course Facts expansion — CLOSED / PASS
- `CF-CHG-20260820-003` — QUT Course Facts acquisition — DEFERRED
- `CF-CHG-20260820-004` — UQ Course Facts coverage expansion v3 — CLOSED / PASS

## Documentation decision

Updated because governed running behaviour/semantic interpretation changed:

- Running Build -> v2.44
- Master Project Plan -> v1.40
- `docs/coursefinder-pim-admin-guide-v1.0.md`
- `docs/coursefinder-zoho-consumer-contract-v1.0.md`
- `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`
- Change Control record/register

Not updated because the canonical relational contract did not change:

- Database Architecture remains v2.10.37
- Search contract unchanged
- Layer 1 identity contract unchanged

## Current serial/parallel position

1. `M1-L1-AU-CRICOS-COMPLETENESS` — PASS / COMPLETE
2. `M1-L2-AU-COURSE-FACTS` — IN PROGRESS / 2 QUALIFIED SOURCES / 10 COURSES BOUNDED
3. `M1-PIM-GOV` — IN PROGRESS / DB-RPC-GOVERNANCE PASS / FRONTEND RELEASE PENDING
4. further AU Course Facts coverage through production-fetchable qualified sources — ACTIVE
5. Search enrichment readiness — BLOCKED / SEPARATE GATE
