# CF-CHG-20260904-108 — Scholarship First-Party Catalogue Wave

**Status:** IMPLEMENTED / TARGETED PASS  
**Date:** 4 September 2026 (Australia/Sydney)  
**Milestone:** M2.4.5  
**Parents:** CF-CHG-20260903-083 / CF-CHG-20260904-107

## Objective
Expand scholarship acquisition from landscape discovery into first-party university catalogues while preserving end-to-end traceability.

## First-party catalogue roots
Captured as authoritative catalogue/navigation entrypoints:
- University of Melbourne — `https://scholarships.unimelb.edu.au/`
- Australian National University — `https://study.anu.edu.au/scholarships`
- Monash University — `https://www.monash.edu/study/fees-scholarships/scholarships/find-a-scholarship`

## Verified detail wave
Eight trace rows now have first-party detail links across the three providers:
- Melbourne: 4;
- ANU: 2;
- Monash: 2.

Five were added directly from first-party catalogues during this wave, including international undergraduate/pathway/excellence, vice-chancellor achievement and leadership awards.

## Boundary
These records remain at `first_party_verified` until controlled detail acquisition produces Evidence/source records and the normal canonical/Layer 4/publication workflow advances them. No canonical or consumer record is fabricated from discovery alone.

## Traceability
Each row preserves Provider identity, first-party catalogue/detail links, internal discovery provenance where applicable, stage, verification timestamps and Change Control metadata. Later Evidence, source-record, canonical Scholarship, review and publication IDs attach to the same trace chain.

## Security
The trace table is RLS-enabled; `anon` and `authenticated` have no direct SELECT privileges; `service_role` retains controlled access.
