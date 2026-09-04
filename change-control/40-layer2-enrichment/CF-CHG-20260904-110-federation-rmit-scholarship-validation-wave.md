# CF-CHG-20260904-110 — Federation & RMIT Scholarship Validation Wave

**Status:** IMPLEMENTED / TARGETED PASS  
**Date:** 4 September 2026 (Australia/Sydney)  
**Milestone:** M2.4.5  
**Parent:** CF-CHG-20260904-105 / CF-CHG-20260904-107

## Objective
Add Federation University Australia and RMIT University to the first-party Scholarship validation wave so milestone stakeholders can validate familiar Provider examples directly against official university sources.

## First-party references captured
### Federation University Australia
Catalogue: `https://www.federation.edu.au/study/scholarships/`
- Federation Merit Scholarship — 2026 — 20% tuition.
- Federation Pathways Scholarship — 2026 — 10% tuition.
- Federation Global Merit Scholarship — 2027 — 25% tuition.

### RMIT University
Catalogue: `https://www.rmit.edu.au/scholarships/international-scholarships`
- Academic Merit Scholarship for South East Asia — 20% tuition.
- Future Leaders Scholarship — 20% tuition, eligible offers from 2026.
- Supporting international scholarship terms retained as trace metadata: `https://www.rmit.edu.au/scholarships/international-scholarships/international-scholarships-terms-and-conditions`.

## Traceability
Each item is written to `pipeline.scholarship_acquisition_trace` with canonical Provider identity, first-party catalogue URL, first-party detail URL, observed title, verification state and meeting-validation metadata.

No landscape/discovery source is presented as the authoritative reference. University-owned pages are the verification and downstream reference authority.

## Publication boundary
These are first-party verified acquisition traces only. They are not automatically canonicalised, course-mapped or published. Existing detail acquisition, evidence, Layer 4 scope and publication gates remain mandatory.

## Runtime / source
Pilot migration: `20260904014155_cf_110_add_federation_rmit_scholarship_validation_wave.sql`.
