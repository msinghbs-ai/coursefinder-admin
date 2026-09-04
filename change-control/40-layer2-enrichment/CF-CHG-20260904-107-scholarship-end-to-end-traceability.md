# CF-CHG-20260904-107 — Scholarship End-to-End Traceability

**Status:** IMPLEMENTED / RECONCILIATION ACTIVE  
**Date:** 4 September 2026 (Australia/Sydney)  
**Milestone:** M2.4.5  
**Parents:** CF-CHG-20260903-083 / CF-CHG-20260904-105

## Decision
Scholarship acquisition must preserve a complete trace chain from landscape discovery through first-party verification, canonicalisation, Layer 4 review and publication.

External aggregation/discovery sources are workflow aids only. They are not canonical authorities and must not be presented as the scholarship reference source to downstream consumers.

Accepted trace chain:
`landscape discovery -> first-party catalogue/detail URL -> Evidence -> discovery candidate -> source record -> canonical unpublished scholarship -> Layer 4 review -> publication decision -> governed consumer projection`.

## Runtime implementation
Pilot migration `20260904114000_cf_107_scholarship_end_to_end_traceability.sql` adds private `pipeline.scholarship_acquisition_trace`.

The trace preserves, where applicable:
- canonical Provider ID;
- observed scholarship title;
- internal landscape/discovery URL;
- first-party catalogue URL;
- first-party scholarship detail URL;
- discovery candidate ID;
- source-record ID;
- canonical Scholarship ID;
- discovery Evidence ID;
- first-party verification Evidence ID;
- Layer 4 review queue ID;
- publication-decision ID;
- current stage and verification status;
- observation/verification/update timestamps;
- Change Control/runtime metadata.

## First verification wave
Three high-gap provider candidates were verified against first-party university pages and inserted at `first_party_verified` stage:
- University of Melbourne — AG Whitlam International Undergraduate Scholarship;
- Australian National University — ANU International Achievement Award;
- Monash University — Monash International Merit Scholarship.

No canonical Scholarship, Layer 4 review or publication decision is manufactured before detail acquisition and governed processing.

## Authority / UI boundary
Only first-party university URLs are authoritative scholarship references for PIM/consumer presentation. Landscape URLs remain private pipeline provenance for audit and completeness analysis.

## Security
`pipeline.scholarship_acquisition_trace` has RLS enabled. Browser roles have no direct privileges; controlled service-role processing retains access.
