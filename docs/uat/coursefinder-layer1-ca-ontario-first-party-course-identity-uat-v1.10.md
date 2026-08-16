# CourseFinder Layer 1 Canada — Ontario First-Party Course Identity UAT v1.10

**Date:** 17 August 2026  
**Scope:** CA Gate B — Ontario first-party Course identity expansion  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.20.md`

## Result

Ontario Provider mapping remains **PASS 24/24**.

Institutional Course identity sub-gates now **20 PASS**, producing **2,389 canonical CA Courses**.

Coverage:
- full/current: 2,117;
- partial source: 80;
- identity-full / lifecycle-currentness pending: 192.

## St. Lawrence College PASS

- DLI `O19332845222`.
- Programme discovery index: 137 hits.
- Full-Time campus/delivery rows: 79.
- Unique programme codes: 63.
- Identity `stlawrence_program_code`.
- Multi-campus rows collapse to one Course per programme code.
- First-party detail-page code and Full-Time validation: 63/63.
- Lifecycle: 63 active current catalogue programmes.
- One current programme has `No Intakes Available`; this is admissions availability, not Course lifecycle.

### Runtime UAT

- v0.1.0 dry-run failed safely with no writes when lower-case route for code `1043` resolved to a generic page.
- Canonical route validation established that the case-sensitive first-party programme route exposes the correct Program Details/code.
- v0.1.2 final dry-run job `d3bb1a1c-1086-4a46-afc5-1aec4984d64d`: 63 parsed / 63 detail verified / 0 writes / 0 conflicts.
- First APPLY job `74cbb274-6870-4d46-a334-3755874a6c31`: 63 created / 0 existing / 0 conflicts / 0 Provider writes.
- Replay job `62cb09c1-e0a6-4d62-8eb3-3c4b72f1bca7`: 0 created / 63 existing / 0 conflicts.
- Evidence hash stable across final dry-run/APPLY/replay: `32ea00dd0e8612dbd14102a7d32b20903013e4f3ef7e5750071d799f8bf84fa4`.
- Integrity: 63 identifiers / 63 distinct identifiers / 63 Courses; wrong Provider 0; stable-key mismatch 0; lifecycle mismatch 0.
- Database aggregate after acceptance: 2,389 CA Courses.

### Worker/source control

- Worker `layer1-ca-stlawrence-programs-v0.1.2`.
- Supabase function version 3.
- Deployment SHA `67209989a166ce21ac63bce5995d77931ee69cc5d1ab431965ae20a3adb3e0b1`.
- Pilot commit `ca249603a9e7052365e151b772584f1248b4c8fc`.

## Gate state

Overall Canada Gate B remains **ACTIVE/BLOCKED** because Course-source coverage is incomplete. `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` remains active.
