# CF-CHG-20260820-004 — UQ Course Facts Coverage Expansion v3

**Status:** CLOSED / PASS  
**Category:** 40-layer2-enrichment  
**Initiated:** 20 August 2026  
**Origin chat/workstream:** M1-L2-AU-COURSE-FACTS — AU First-Party Course Enrichment  
**Owner:** CourseFinder Layer 2 enrichment workstream  
**Change class:** ingestion / data / governance / documentation

## Trigger

Continue controlled coverage expansion under the already-qualified UQ source class while unrelated Provider acquisition candidates were being assessed independently.

## Problem / requested outcome

Increase qualified UQ Course coverage from four to eight exact CRICOS Courses without changing canonical identity, fact semantics, evidence requirements or Search admission.

## Affected surfaces / related workstreams

- `coursefacts-au-uq`
- `pipeline.course_fact_source_qualifications`
- Course links / Provider-current fees / intakes / English requirements
- Pilot UAT and migration lineage
- current Admin programme/build snapshots

## Semantic impact

**No canonical semantic change.**

This is a same-source-class coverage expansion under Architecture v2.10.37.

## Before

UQ bounded state:

- exact CRICOS Courses: 4
- links: 4
- Provider-current fees: 4
- intakes: 7
- English requirements: 12

RMIT + UQ aggregate:

- Courses: 6
- links: 6
- fees: 6
- intakes: 10
- English: 20

## After

UQ bounded state:

- exact CRICOS Courses: 8
- links: 8
- Provider-current fees: 8
- intakes: 15
- English requirements: 24

RMIT + UQ aggregate:

- exact CRICOS Courses: 10
- links: 10
- Provider-current fees: 10
- intakes: 18
- English requirements: 32

Search remains 33,105 documents with zero fee/intake/English enrichment admitted.

## Source authority / evidence

New exact CRICOS Courses:

- `019886A` — Bachelor of Business Management
- `001942A` — Bachelor of Arts
- `080734K` — Bachelor of Engineering (Honours)
- `092454G` — Master of Data Science

Each UQ official 2027 program page was fetched during UAT, source-proofed, SHA-256 captured and retained through the existing private evidence contract.

## Implementation references

- worker: `coursefacts-au-uq-v0.3.0`
- production migration: `20260820005253_m1_l2_au_coursefacts_uq_coverage_v3`
- Edge Function version: 3
- deployment SHA-256: `3ee7aade7fca8f075d49b8e1755a166bdf64ed55fe434bf12d2afca8eb156b94`
- Pilot worker commit: `ff276ede5501c93e0ae7a1318a6d79735c036a57`
- Pilot UAT: `docs/m1-l2-au-course-facts-uq-expansion-v3-uat-2026-08-20.md`
- UI version: N/A

## UAT

- dry-run `1912`: PASS
- APPLY `1913`: PASS
- replay `1914`: PASS
- exact CRICOS resolution: PASS for all eight UQ records
- canonical replay cardinality: unchanged
- Search enrichment admission: 0

## Rollback / reversion

Rollback only the four latest UQ exact CRICOS Course observations for the UQ source ID and restore the v0.2.0 worker record set. Preserve source/evidence history. No Layer 1 or Search rollback is required.

## Documentation impact

- Architecture: unchanged at v2.10.37
- Running build: advance current snapshot
- Master plan: advance current coverage counts
- historical resolved gap snapshot: refresh counts
- Pilot UAT: added
- Search/PIM/Zoho contracts: unchanged

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 | IN PROGRESS | UQ second coverage wave started | M1-L2-AU-COURSE-FACTS |
| 20 Aug 2026 | PASS | dry-run/APPLY/replay completed | requests 1912 / 1913 / 1914 |
| 20 Aug 2026 | CLOSED | eight-Course bounded UQ state accepted | this record |

## Closure

**Final status:** CLOSED / PASS  
**Closed at:** 20 August 2026  
**Outcome:** UQ qualified source coverage expanded to eight exact CRICOS Courses with canonical idempotency and Search isolation preserved.
