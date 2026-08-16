# CourseFinder Running Build v2.22

**Date:** 17 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.20.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.20.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional identity sub-gates passed: **20**.
- Canonical CA Courses: **2,389**.
- Full/current accepted source Courses: **2,117**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.

## St. Lawrence College PASS

- Worker `layer1-ca-stlawrence-programs-v0.1.2`.
- Supabase Edge Function version 3; deployment SHA `67209989a166ce21ac63bce5995d77931ee69cc5d1ab431965ae20a3adb3e0b1`.
- Pilot commit `ca249603a9e7052365e151b772584f1248b4c8fc`.
- DLI `O19332845222`.
- Discovery: 137 programme-search hits; 79 Full-Time campus/delivery rows; 63 unique programme codes.
- Identity `stlawrence_program_code`.
- First-party detail validation 63/63.
- Lifecycle: 63 active current catalogue programmes.
- One `No Intakes Available` record is preserved as admissions metadata and does not change Course lifecycle.
- Final dry-run job `d3bb1a1c-1086-4a46-afc5-1aec4984d64d`: 63 parsed / 0 writes.
- First APPLY job `74cbb274-6870-4d46-a334-3755874a6c31`: 63 created / 0 conflicts / 0 Provider writes.
- Replay job `62cb09c1-e0a6-4d62-8eb3-3c4b72f1bca7`: 0 created / 63 existing / 0 conflicts.
- Integrity: wrong Provider 0; stable-key mismatch 0; lifecycle mismatch 0.
- Evidence SHA-256 `32ea00dd0e8612dbd14102a7d32b20903013e4f3ef7e5750071d799f8bf84fa4`.

## Current blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue remaining Ontario institutional sources and Seneca lifecycle-currentness before validation joins and wider Canadian coverage.
