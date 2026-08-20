# CourseFinder AU CRICOS Course Facts Gap v1.2

**Status:** RESOLVED / HISTORICAL GAP CLOSED  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-au-cricos-course-facts-gap-v1.1.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.42.md`

## Resolution status

The original v1.0 gap remains closed as a programme blocker.

The accepted implementation preserves the key semantic separation established by that investigation:

- CRICOS registered fee/cost facts remain Layer 1 regulatory observations;
- Provider-current fees remain independent Layer 2 observations;
- Provider enrichment does not overwrite CRICOS evidence or identity.

## Accepted Layer 1 baseline

- Providers: 1,546
- active CRICOS Courses: 26,648
- production adapter: `layer1-au-depth-v1.6.0`
- missing Study Level: 0
- unexplained Layer 1 mapping defects: 0

CRICOS source absences remain classified rather than manufactured.

## Current Layer 2 controlled-expansion snapshot

Qualified Provider-owned source classes:

- RMIT University — `au_rmit_official_course_pages`
- The University of Queensland — `au_uq_official_program_pages`

Current bounded aggregate:

- exact CRICOS Courses: 6
- official Provider Course URLs: 6
- Provider-current fee observations: 6
- intake observations: 10
- governed English requirement observations: 20

The UQ source class has now expanded from its original two-Course qualification sample to four exact CRICOS Courses under `coursefacts-au-uq-v0.2.0` with dry-run/APPLY/replay PASS.

Provider-current fees remain `provider_current_tuition` with source-published year/basis and are not annualised or collapsed into CRICOS registered total-course fees.

## Identity/evidence rules remain active

Provider enrichment must continue to:

- resolve by exact Provider CRICOS + Course CRICOS code, or another separately governed stable mapping;
- prohibit title-only identity;
- retain private source evidence and SHA-256 capture;
- preserve source record/version lineage;
- fail closed on ambiguity;
- keep Provider URL facts outside canonical Course identity fields;
- keep unsupported English-test schemes uncoerced until governed.

## Search consequence

Current Search state remains:

- Course Documents: 33,105
- rows with fee/intake/English enrichment: 0

Layer 2 APPLY does not constitute Search admission. Search enrichment readiness remains a separate gate.

## Decision

The original AU CRICOS Course Facts gap remains **closed as a blocker**.

This v1.2 snapshot exists only to prevent the historical gap document from carrying stale active coverage counts. Current execution authority is:

- Architecture v2.10.37
- Running Build v2.42
- Master Project Plan v1.38
- Change Control `CF-CHG-20260820-002` for the latest UQ coverage expansion.
