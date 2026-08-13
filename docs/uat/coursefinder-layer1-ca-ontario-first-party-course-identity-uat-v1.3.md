# CourseFinder Layer 1 Canada — Ontario First-Party Course Identity UAT v1.3

**Date:** 14 August 2026  
**Scope:** CA Gate B — Ontario first-party Course identity expansion  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.11.md`

## Result

- Ontario Provider mapping: **PASS 24/24**.
- Algonquin: **PASS — 88**.
- Conestoga: **PASS — 315**.
- Fanshawe partial PGWP source: **PASS — 80**.
- Mohawk current-open source: **PASS — 108**.
- Durham full-current API: **PASS — 150**.
- Niagara lifecycle-aware source: **PASS — 135**.
- Sheridan lifecycle-aware source: **PASS — 167**.
- Overall CA Gate B: **ACTIVE/BLOCKED — country Course-source coverage incomplete**.

## Sheridan identity / lifecycle discovery

Official first-party source: Sheridan Sitecore `/sxa/search/results/` programme API.

Base query returns **167** programme records. Validation showed:
- distinct Sitecore programme item IDs: 167;
- duplicate IDs: 0;
- missing IDs: 0;
- missing titles: 0;
- missing URLs: 0.

Sheridan's official `Program active` facet returns **114** records. Therefore the accepted source lifecycle is:
- active: 114;
- inactive: 53;
- suspended: 0;
- unknown: 0.

Accepted identity scheme:
`UUIDv5(IRCC DLI O19385946782 + sheridan_program_item_id)`.

Titles remain mutable and non-identifying.

## APPLY / integrity

First full APPLY:
- records: 167;
- created: 167;
- conflicts: 0;
- Provider writes: 0.

Integrity:
- UUIDv5 mismatch: 0;
- distinct item IDs: 167/167;
- wrong Provider links: 0;
- lifecycle mismatch: 0;
- title-derived stable keys: 0.

## Autonomous runtime / idempotency PASS

Worker: `layer1-ca-sheridan-programs-v0.1.0`.

The worker independently fetches the 167-record base Sitecore API and the 114-record `Program active=true` result set, derives lifecycle from item-ID membership, captures combined JSON evidence, and reconciles under `sheridan_program_item_id`.

Autonomous one-time-nonce Edge replay:
- HTTP 200;
- API rows: 167;
- active API rows: 114;
- parsed records: 167;
- created: 0;
- existing: 167;
- conflicts: 0;
- lifecycle: 114 active / 53 inactive;
- private JSON evidence captured;
- SHA-256: `13828057e2369188e523f06379175f74b07b76056ad8825c4697719bb136b6b5`.

## Current CA Course state

Canonical CA Courses: **1,043**.

Composition:
- Algonquin 88;
- Conestoga 315;
- Fanshawe 80 partial;
- Mohawk 108;
- Durham 150;
- Niagara 135;
- Sheridan 167.

Full/current accepted source Courses: **963**.  
Partial-source Courses: **80**.

## Gate state

**Seven Ontario institutional Course source patterns now PASS, but `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue institutional coverage; do not promote Canada yet.**
