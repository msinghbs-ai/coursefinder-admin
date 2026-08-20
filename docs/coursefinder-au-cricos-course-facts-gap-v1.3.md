# CourseFinder AU CRICOS Course Facts Gap v1.3

**Status:** RESOLVED / HISTORICAL GAP CLOSED  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-au-cricos-course-facts-gap-v1.2.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.43.md`

## Resolution status

The original Course Facts gap remains closed as a blocker. CRICOS regulatory facts and Provider-current facts remain deliberately separate.

## Accepted Layer 1 baseline

- Providers: 1,546
- active CRICOS Courses: 26,648
- production adapter: `layer1-au-depth-v1.6.0`
- missing Study Level: 0
- unexplained Layer 1 mapping defects: 0

## Current Layer 2 production snapshot

Qualified Provider-owned source classes:

- RMIT University — `au_rmit_official_course_pages`
- The University of Queensland — `au_uq_official_program_pages`

Current accepted bounded aggregate:

- exact CRICOS Courses: 10
- official Provider Course URLs: 10
- Provider-current fee observations: 10
- intake observations: 18
- governed English requirement observations: 32

UQ currently contributes eight exact CRICOS Courses under `coursefacts-au-uq-v0.3.0`, with dry-run/APPLY/replay PASS.

QUT is represented only as a deferred source candidate. It contributes zero accepted facts because the production runtime received HTTP 403 from its official Course pages; APPLY is disabled.

## Identity/evidence rules remain active

Provider enrichment must continue to:

- resolve by exact Provider CRICOS + Course CRICOS code, or another separately governed stable mapping;
- prohibit title-only identity;
- retain private source evidence and SHA-256 capture;
- preserve source record/version lineage;
- fail closed on ambiguity or acquisition failure;
- keep Provider URLs outside canonical Course identity fields;
- retain Provider-current fee year/basis separately from CRICOS registered-total-course fees;
- keep unsupported English-test schemes uncoerced until governed.

## Search consequence

Current Search remains:

- Course Documents: 33,105
- fee/intake/English enrichment admitted: 0

Layer 2 APPLY does not constitute Search admission.

## Decision

The historical AU CRICOS Course Facts gap remains **closed as a blocker**. Current execution authority is:

- Architecture v2.10.37
- Running Build v2.43
- Master Project Plan v1.39
- Change Control `CF-CHG-20260820-003` for QUT deferral
- Change Control `CF-CHG-20260820-004` for UQ v3 expansion.
