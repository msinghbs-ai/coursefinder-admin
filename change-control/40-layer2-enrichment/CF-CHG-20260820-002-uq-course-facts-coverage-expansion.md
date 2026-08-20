# CF-CHG-20260820-002 — UQ Course Facts Coverage Expansion

**Status:** CLOSED / PASS  
**Category:** 40-layer2-enrichment  
**Initiated:** 20 August 2026 10:33 AEST  
**Origin chat/workstream:** M1-L2-AU-COURSE-FACTS — AU First-Party Course Enrichment  
**Owner:** CourseFinder Layer 2 enrichment workstream  
**Change class:** ingestion / data / governance / documentation

## Trigger

User direction to continue `M1-L2-AU-COURSE-FACTS` autonomously after the UQ source class qualified, while keeping all relevant governance documents current.

## Problem / requested outcome

The UQ Provider-owned program-page source class had passed qualification using two exact CRICOS Courses. The next required proof was controlled coverage growth inside that already-qualified source class, without changing identity, fee semantics, evidence rules or Search admission.

## Affected surfaces / related workstreams

- Supabase Edge Function `coursefacts-au-uq`
- `pipeline.course_fact_source_qualifications`
- `catalogue.course_links`
- `catalogue.course_fees`
- `catalogue.course_intakes`
- `catalogue.course_english_requirements`
- Pilot UAT and migration lineage
- Admin running build / master plan / historical gap governance
- Search isolation verification

## Semantic impact

**No canonical semantic change.**

This change increases bounded Course coverage under an already-qualified source class.

It does not change:

- Provider/Course identity authority;
- exact CRICOS mapping rules;
- Provider-current fee meaning;
- intake/English grain;
- canonical Course URL ownership;
- Search publication semantics.

## Before

Qualified UQ source coverage:

- 2 exact CRICOS Courses
- 2 official links
- 2 Provider-current fees
- 3 intakes
- 6 governed English requirements

Aggregate RMIT + UQ:

- 4 exact CRICOS Courses
- 4 links
- 4 Provider-current fees
- 6 intakes
- 14 English rows

## After

Qualified UQ source coverage:

- 4 exact CRICOS Courses
- 4 official links
- 4 Provider-current fees
- 7 intakes
- 12 governed English requirements

Aggregate RMIT + UQ:

- 6 exact CRICOS Courses
- 6 links
- 6 Provider-current fees
- 10 intakes
- 20 governed English requirements

Search remains 33,105 documents with zero fee/intake/English enrichment admission.

## Source authority / evidence

Authoritative Provider: The University of Queensland, Provider CRICOS `00025B`.

New official program sources:

- `045401M` — Bachelor of Commerce/Bachelor of Information Technology
- `013827E` — Bachelor of Science/Bachelor of Arts

Each runtime fetch is retained as private evidence with SHA-256 and exact CRICOS identity proof.

## Implementation references

- Supabase migration: `20260820004354_m1_l2_au_coursefacts_uq_coverage_v2`
- Pilot worker: `coursefacts-au-uq-v0.2.0`
- Live Edge Function version: 2
- Deployment SHA-256: `913bbe1d0aa35435e5561d67b75ef5025f7cfd07c0483e408df76ed928df12a3`
- Pilot worker commit: `518f4ad1e576d2101989c8ff5dd3b70b9de5516b`
- Pilot migration commit: `7af1685c900018c74008d7af8cc8ded7136fefe2`
- Pilot UAT: `docs/m1-l2-au-course-facts-uq-expansion-uat-2026-08-20.md`
- UI version: N/A

## UAT

- canonical identity preflight for `045401M` and `013827E`: PASS
- fresh source dry-run request `1906`: PASS
- production APPLY request `1907`: PASS
- replay request `1908`: PASS
- unchanged source hashes reused source-record IDs: PASS
- canonical post-replay counts stable: PASS
- canonical Course URL mutations: 0
- Search documents: 33,105
- Search rows with fee/intake/English enrichment: 0

The already-qualified source-class ambiguity rule remains exact-CRICOS fail-closed; no title fallback was introduced by this coverage change.

## Rollback / reversion

Rollback is bounded to the two newly introduced UQ CRICOS Course observations (`045401M`, `013827E`) for the UQ source ID. Remove only their UQ-source Layer 2 links, Provider-current fees, intakes and English requirements, restore the prior worker record set, and retain source/evidence history for audit. No Layer 1 or Search rollback is required.

## Documentation impact

- PIM Admin Guide: no semantic/UI change required
- Architecture: no new version required; v2.10.37 contract remains authoritative
- Running build: advance to v2.42
- Master plan: advance to v1.38 for current coverage counts
- UAT/design docs: add UQ coverage-expansion UAT
- Historical gap governance: advance resolved snapshot to v1.2
- Zoho contract: no change

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 10:33 AEST | IN PROGRESS | Controlled expansion authorised under qualified UQ source class | M1-L2-AU-COURSE-FACTS |
| 20 Aug 2026 | PASS | Dry-run / APPLY / replay completed; Search isolation retained | Pilot requests 1906 / 1907 / 1908 |
| 20 Aug 2026 | CLOSED | Coverage expansion accepted without architecture semantic change | This record |

## Closure

**Final status:** CLOSED / PASS  
**Closed at:** 20 August 2026  
**Outcome:** UQ qualified source coverage expanded from two to four exact CRICOS Courses with canonical idempotency and Search isolation preserved.
