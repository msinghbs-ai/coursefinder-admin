# CourseFinder Database Architecture v2.10.20

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.19.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 17 August 2026

## Canada Layer 1 identity

Provider identity remains `CA + ircc_dli + DLI_number`.

Course identity remains `UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

Titles are mutable and never identity. Admissions/intake availability remains separate from Course lifecycle unless a source explicitly expresses true programme lifecycle.

## Institutional Course authority

Twenty Ontario institutional identity sub-gates now PASS, producing **2,389 canonical CA Courses**.

Coverage accounting:
- full/current: **2,117**;
- partial-source: **80**;
- identity-full / lifecycle-currentness pending: **192**.

## St. Lawrence College accepted contract

- DLI: `O19332845222`.
- First-party catalogue page exposes a public browser programme-search configuration; it is used transiently for discovery only and is not persisted in source code or governance.
- Discovery set: 137 index hits; 79 Full-Time campus/delivery rows.
- Authority boundary: every accepted programme code is revalidated on a first-party St. Lawrence programme detail page.
- Identity scheme: `stlawrence_program_code`.
- 63 unique programme codes after collapsing campus/delivery variants.
- Multi-campus variants do not create separate Course identities because programme code and title remain the same across those variants.
- Titles are mutable metadata only.
- Current catalogue membership gives Course lifecycle `active` for 63 records.
- `No Intakes Available` is admissions availability, not Course lifecycle; one current programme presently carries this state.
- Stable-key form: `course:ca:ircc_dli:o19332845222:stlawrence_program_code:<code>`.
- UAT integrity: 63 identifiers / 63 distinct / wrong Provider 0 / stable-key mismatch 0 / lifecycle mismatch 0.
- Evidence SHA-256: `32ea00dd0e8612dbd14102a7d32b20903013e4f3ef7e5750071d799f8bf84fa4`.

## Gate state

CA remains ACTIVE/BLOCKED on `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER` pending remaining institutional coverage, Seneca lifecycle-currentness, Ontario validation joins, national expansion, Search Projection, security and performance gates.
