# CourseFinder Master Project Plan v1.20

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.19.md`  
**Last consolidated:** 17 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.20.md`  
**Running build:** `docs/coursefinder-running-build-v2.22.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course identity sub-gates passed: **20**.
- Canonical CA Courses: **2,389**.
- Full/current accepted source Courses: **2,117**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.

## St. Lawrence College PASS

St. Lawrence College is accepted as the twentieth Ontario institutional Course sub-gate.

- Verified Provider DLI: `O19332845222`.
- Discovery: College public programme-search index, bounded to 500 hits and read using the browser search configuration exposed by the first-party page at runtime; no search credentials are persisted in code or governance.
- Authority: every accepted identity is independently verified on a first-party St. Lawrence programme detail page.
- Source discovery: 137 programme-index hits, including 79 Full-Time campus/delivery rows.
- Canonical identity: 63 unique `stlawrence_program_code` values.
- Multi-campus Full-Time variants collapse to one Course per programme code; campus/delivery rows are metadata, not separate Courses.
- First-party detail validation: 63/63.
- Course lifecycle: 63 active current catalogue programmes.
- One programme currently states `No Intakes Available`; this is admissions availability and does not change Course lifecycle.
- Final dry-run: 63 parsed / 0 writes / 0 conflicts.
- First APPLY: 63 created / 0 existing / 0 conflicts / 0 Provider writes.
- Replay: 0 created / 63 existing / 0 conflicts.
- Integrity: 63 identifiers / 63 distinct / wrong Provider 0 / stable-key mismatch 0 / lifecycle mismatch 0.
- Evidence SHA-256: `32ea00dd0e8612dbd14102a7d32b20903013e4f3ef7e5750071d799f8bf84fa4`.
- Worker: `layer1-ca-stlawrence-programs-v0.1.2`, Supabase function version 3, deployment SHA `67209989a166ce21ac63bce5995d77931ee69cc5d1ab431965ae20a3adb3e0b1`.
- Pilot source commit: `ca249603a9e7052365e151b772584f1248b4c8fc`.

## Remaining blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue the remaining Ontario institutional adapters and Seneca lifecycle-currentness, then Ontario APS/MTCU/CIP joins, national Course expansion, Search Projection, security and performance gates before Canada can PASS.
