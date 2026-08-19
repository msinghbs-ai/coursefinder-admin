# CourseFinder AU Geography + Field Completeness Gate UAT v1.0

**Date:** 19 August 2026  
**Scope:** AU CRICOS evidence-backed geography and Field of Education completion plus Admin filter semantics  
**Decision:** **PASS WITH ONE BOUNDED SOURCE-NULL CAMPUS GEOGRAPHY GAP**

## Purpose

Close verified AU canonical completeness gaps that were incorrectly presented as unavailable data, without inventing values:

- Provider postal State/Region;
- Campus State/Region;
- Course primary Field of Study;
- Course State/Region filter semantics;
- Delivery filter semantics;
- explicit missing-State / missing-Link work queues.

Fees and first-party Course URLs are intentionally outside this Layer 1 correction gate and remain Layer 2 source-enrichment work.

## Authority and evidence

Source: Australian Government CRICOS dataset published by the Department of Education.

Direct resources used:

| Resource | Resource ID | Last modified | SHA-256 | Evidence ID |
|---|---|---|---|---|
| CRICOS Institutions.csv | `7f6941f3-5327-4db7-b556-5f16d77f63c1` | 4 Aug 2026 08:04:10 | `abe86484f715b8c7d24d2e5a2c6bcf02f14ad57697e473768d1f2b415419058a` | `4112b14d-646f-40b2-9039-2c42977f2a91` |
| CRICOS Courses.csv | `48cacf69-2082-415e-9595-f17d0c3a4af0` | 4 Aug 2026 08:04:20 | `fc2f2ef81c0b3c63dd47e1b01c7e5cf22f708c892e70f71707dbb421baed6945` | `721e46ca-a27f-4df1-b515-71056c71eae7` |
| CRICOS Locations.csv | `45d29535-1360-4486-8242-3850e61b5524` | 4 Aug 2026 08:04:15 | `66e9e307c11aa8fca7fe7efd4cc39cb87bb057993aa134a039eba895822a5019` | `5d6ed80b-e7f4-483c-a268-fdc98af61534` |

The hashes reproduce the previously accepted AU CRICOS evidence baseline.

## Field contract

CRICOS `Field of Education 1 Narrow Field` is treated as a source-published ASCED narrow-field observation.

Rules:
- exact four-digit source code required;
- broad parent is the first two ASCED digits;
- canonical codes are namespaced `asced-NN` and `asced-NNNN`;
- no fuzzy title classification is permitted;
- source code/name, source ID and evidence ID are retained in `catalogue.course_field_observations`;
- `courses.primary_field_id` points at the accepted exact narrow field.

ABS ASCED defines 12 two-digit broad fields and four-digit narrow fields. The gate seeds all 12 broad parents and creates only narrow fields actually published in CRICOS.

## Dry-run

Job: `14d985aa-ecc0-41e2-8322-29e163020711`

First 2,500-course dry-run:
- selected records: 2,500;
- field mapped: 2,500;
- field unmapped: 0;
- conflicts: 0;
- Provider State tokens: ACT, NSW, QLD, SA, VIC, WA;
- Location State tokens: ACT, NSW, QLD, SA, VIC, WA.

The original ZIP-depth worker revision hit Supabase Edge resource limit HTTP 546. The gate switched to `layer1-au-completeness-v0.1.0`, which consumes the authoritative direct CSV resources and pins subsequent APPLY batches to the captured hashes/evidence.

## APPLY

Bounded APPLY jobs:

| Offset | Selected | Job | Field unmapped | State mapping conflicts |
|---:|---:|---|---:|---:|
| 0 | 5,000 | `53d6a1ca-73eb-40e4-bab6-c75455d60973` | 0 | 0 |
| 5,000 | 5,000 | `18a49b6a-3daf-499e-ac8d-ce644425f0c9` | 0 | 0 |
| 10,000 | 5,000 | `44be899f-d029-47d4-b05e-ad82b9528673` | 0 | 0 |
| 15,000 | 5,000 | `cf203432-1959-4ff3-80fe-31da521926e0` | 0 | 0 |
| 20,000 | 5,000 | `c59522d7-3d4a-4fb9-9f85-438b875207ba` | 0 | 0 |
| 25,000 | 1,648 | `36849e69-155e-4948-a14b-2b9336d28a66` | 0 | 0 |

All batches used the same captured evidence IDs and refused source content if the current hashes differed.

## Post-APPLY canonical state

| Measure | Result |
|---|---:|
| AU Providers | 1,546 |
| Provider postal subdivision populated | **1,546 / 1,546** |
| AU Campuses | 3,922 |
| Campus subdivision populated | **3,921 / 3,922** |
| AU Courses | 26,648 |
| Course primary ASCED field populated | **26,648 / 26,648** |
| Current Course field observations | **26,648** |
| Course↔Campus relationships | **47,671** |
| Courses with any Course↔Campus relationship | 26,614 |
| Courses with authoritative Campus State | 26,613 |
| Courses with Course↔Campus delivery mode | 26,614 |
| Active Course Links | 0 |
| Active Course Fees | 0 |

No Provider, Course, Campus or Course↔Campus identity counts changed.

## Explicit bounded Campus gap

Unresolved Campus:
- Provider CRICOS: `00366C`;
- Provider: Muirden Senior College;
- Campus: Muirden Senior Secondary College;
- postcode: `5000`.

The current CRICOS Locations datastore row itself publishes:
- City: `null`;
- State: `null`.

The Campus therefore remains `subdivision_id = null`. The system does **not** infer South Australia from postcode 5000.

## Filter semantics UAT

Course State/Region is now operational course geography:

`Course -> Course Campus -> Campus -> subdivision`

It is not derived from Provider postal State.

Delivery is now read from `catalogue.course_campuses.delivery_mode` where available.

Filter-option UAT for AU:
- subdivision options: **8**;
- field options: **79** source-populated narrow fields;
- delivery options: **1** (`on_campus`).

Decision-query proof:
- VIC + Business and Management (`asced-0803`) + on-campus: **1,659** courses;
- Missing State: **35** courses;
- Missing Course Link: **26,648** courses;
- Missing Fee: **26,648** courses.

The 35 Missing-State courses consist of courses with no authoritative mapped Course Campus geography; this remains a valid exception queue.

## State distribution

| State/Territory | Campuses | Courses with a linked campus there |
|---|---:|---:|
| ACT | 147 | 1,106 |
| NSW | 1,078 | 10,846 |
| NT | 27 | 296 |
| QLD | 683 | 5,200 |
| SA | 358 | 3,513 |
| TAS | 63 | 719 |
| VIC | 1,161 | 9,045 |
| WA | 404 | 2,799 |

A course can appear in more than one State/Territory.

## Replay / idempotency

Replay job: `9828cfba-9ee5-46d7-a2e7-fd43bd20c703`.

The final 1,648-course slice was replayed with the same evidence IDs and exact expected hashes.

Post-replay counts remained:
- Providers 1,546;
- Courses 26,648;
- Campuses 3,922;
- Course↔Campus 47,671;
- current Course field observations 26,648.

No duplicate canonical records or field observations were created.

## Runtime

`layer1-au-completeness` executions completed HTTP 200. Full 5,000-course APPLY slices completed in approximately 28–40 seconds; the 1,648-record final/replay slices completed in approximately 14–15 seconds.

## Gate decision

**PASS WITH ONE BOUNDED SOURCE-NULL CAMPUS GEOGRAPHY GAP.**

The accepted AU Layer 1 canonical substrate is now materially more complete for Admin filtering while preserving the no-inference rule.

Next source gate is Layer 2 first-party Course enrichment for evidence-backed Course URLs, Fees, Intakes and English requirements. Zero rows in those domains are not treated as CRICOS defects.