# CourseFinder Layer 1 Canada — Ontario First-Party Course Identity UAT v1.9

**Date:** 17 August 2026  
**Scope:** CA Gate B — Ontario first-party Course identity expansion  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.19.md`

## Result

Ontario Provider mapping remains **PASS 24/24**.

Institutional Course identity sub-gates now **19 PASS**, producing **2,326 canonical CA Courses**.

Coverage:
- full/current: 2,054;
- partial source: 80;
- identity-full / lifecycle-currentness pending: 192.

## Northern College PASS

- DLI `O19315830082`.
- First-party dedicated Post-Secondary Programs feed: 53 unique current programme pages.
- Universal identity: `northern_program_slug`.
- Rationale: only 17 pages publish Programme Codes and some publish multiple codes for one programme; using Programme Code as base identity would over-split the programme entity.
- 35 published Programme Codes are retained as secondary source metadata.
- Titles are mutable metadata and are not identity.
- Course lifecycle: 53 active from current catalogue membership.
- Seven pages explicitly suspend the Fall 2026 intake. These are admissions/intake states, not Course lifecycle; several explicitly state Fall 2027 applications will reopen.

### Runtime UAT

- Final dry-run job `a6afbdb8-d05d-4113-95d9-c7885ccc3876`: 53 parsed / 0 writes / 0 conflicts.
- First APPLY job `43e5e475-66aa-4c40-9c43-683714f52c6f`: 53 created / 0 existing / 0 conflicts / 0 Provider writes.
- Replay job `2a782dbb-5eac-4cd2-8924-9a25a059ed5f`: 0 created / 53 existing / 0 conflicts.
- Evidence hash stable across dry-run/APPLY/replay: `16383baf5de7e466d4226d909239573c7b6f7fe1eb102b32e932d805b9d03a1d`.
- Integrity: 53 identifiers / 53 distinct identifiers / 53 Courses; wrong Provider 0; stable-key mismatch 0; lifecycle mismatch 0.
- Database aggregate after acceptance: 2,326 CA Courses.

### Worker/source control

- Worker `layer1-ca-northern-programs-v0.2.1`.
- Supabase function version 3.
- Deployment SHA `1ec575eb462af4eba12ea207d8fa64440a1769f1b523b8648c283d47679b5802`.
- Pilot commit `1b085dfbc9eefab48767d4cb09234b50cc1bc61f`.

## Gate state

Overall Canada Gate B remains **ACTIVE/BLOCKED** because Course-source coverage is incomplete. `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.
