# CourseFinder Running Build v2.21

**Date:** 17 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.19.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.19.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional identity sub-gates passed: **19**.
- Canonical CA Courses: **2,326**.
- Full/current accepted source Courses: **2,054**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.

## Northern College PASS

- Worker: `layer1-ca-northern-programs-v0.2.1`.
- Supabase Edge Function version 3, deployment SHA `1ec575eb462af4eba12ea207d8fa64440a1769f1b523b8648c283d47679b5802`.
- Pilot source commit: `1b085dfbc9eefab48767d4cb09234b50cc1bc61f`.
- DLI: `O19315830082`.
- First-party Post-Secondary Programs feed resolves to 53 unique programme pages.
- Identity: `northern_program_slug`.
- 17 pages expose 35 published institutional Programme Codes retained as secondary metadata.
- Lifecycle: 53 active current catalogue programmes.
- Seven Fall 2026 intake suspensions are stored as admissions metadata and do not alter Course lifecycle.
- Dry-run job `a6afbdb8-d05d-4113-95d9-c7885ccc3876`: 53 parsed / 0 writes.
- First APPLY job `43e5e475-66aa-4c40-9c43-683714f52c6f`: 53 created / 0 conflicts / 0 Provider writes.
- Replay job `2a782dbb-5eac-4cd2-8924-9a25a059ed5f`: 0 created / 53 existing / 0 conflicts.
- Integrity: 53/53 unique identifiers; wrong Provider 0; stable-key mismatch 0; lifecycle mismatch 0.
- Evidence SHA-256 `16383baf5de7e466d4226d909239573c7b6f7fe1eb102b32e932d805b9d03a1d`.

## Current blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue unresolved Ontario institutional sources and Seneca lifecycle-currentness before validation joins and wider Canadian coverage.
