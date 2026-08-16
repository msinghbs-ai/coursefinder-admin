# CourseFinder Master Project Plan v1.19

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.18.md`  
**Last consolidated:** 17 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.19.md`  
**Running build:** `docs/coursefinder-running-build-v2.21.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- Ontario Provider mapping: PASS 24/24.
- Institutional Course identity sub-gates passed: **19**.
- Canonical CA Courses: **2,326**.
- Full/current accepted source Courses: **2,054**.
- Partial-source Courses: **80**.
- Identity-full / lifecycle-currentness pending: **192**.

## Northern College PASS

Northern College is now accepted as the nineteenth Ontario institutional Course sub-gate.

- Verified Provider DLI: `O19315830082`.
- First-party authority: dedicated Northern College Post-Secondary Programs feed plus programme detail pages.
- Source coverage: 53 unique current postsecondary programme pages.
- Canonical Course identity: `northern_program_slug`.
- Programme title is mutable metadata and is not identity.
- 17 programme pages publish 35 institutional Programme Codes; these are retained as secondary source metadata because one programme page may legitimately expose multiple delivery/campus codes.
- Course lifecycle: 53 active based on current catalogue membership.
- Seven Fall 2026 intake suspensions are admissions/intake metadata, not Course lifecycle; several explicitly state Fall 2027 applications will reopen.
- Dry-run: 53 parsed / 0 writes / 0 conflicts.
- First APPLY: 53 created / 0 existing / 0 conflicts / 0 Provider writes.
- Replay: 0 created / 53 existing / 0 conflicts.
- Integrity: 53 identifiers / 53 distinct / 53 Courses; wrong Provider 0; stable-key mismatch 0; lifecycle mismatch 0.
- Evidence SHA-256: `16383baf5de7e466d4226d909239573c7b6f7fe1eb102b32e932d805b9d03a1d`.
- Worker: `layer1-ca-northern-programs-v0.2.1`.
- Pilot source commit: `1b085dfbc9eefab48767d4cb09234b50cc1bc61f`.

## Remaining blocker

`CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active. Continue unresolved Ontario institutional adapters and Seneca lifecycle-currentness, then Ontario APS/MTCU/CIP joins, national Course expansion, Search Projection, security and performance gates before Canada can PASS.
