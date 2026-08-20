# CourseFinder AU CRICOS Course Facts Gap v1.1

**Status:** RESOLVED / HISTORICAL GAP CLOSED  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-au-cricos-course-facts-gap-v1.0.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`

## Resolution summary

The v1.0 document identified two separate concerns that were intentionally sequenced:

1. omitted CRICOS regulatory Course facts that belonged in Layer 1; and
2. Provider-current Course facts that belong in Layer 2.

Both concerns now have accepted implementation paths.

## Layer 1 regulatory facts — resolved

The accepted AU CRICOS model now preserves the CRICOS registered fee/cost semantics independently of Provider-current enrichment.

Current accepted Layer 1 baseline remains:

- Providers: 1,546
- active CRICOS Courses: 26,648
- production adapter: `layer1-au-depth-v1.6.0`
- missing Study Level: 0
- unexplained Layer 1 mapping defects: 0

CRICOS fee/cost source absence remains explicitly classified rather than manufactured.

## Layer 2 Provider-current facts — active controlled expansion

`M1-L2-AU-COURSE-FACTS` is now in controlled production expansion.

Qualified Provider-owned source classes:

- RMIT University — `au_rmit_official_course_pages`
- The University of Queensland — `au_uq_official_program_pages`

Accepted bounded Layer 2 aggregate:

- exact CRICOS Courses: 4
- official Provider Course URLs: 4
- provider-current fee observations: 4
- intake observations: 6
- governed English requirement observations: 14

Provider-current fees remain `provider_current_tuition` and retain published year/basis rather than overwriting or annualising CRICOS registered-total-course fees.

## Identity and evidence decision

Provider enrichment must continue to:

- resolve by exact Provider CRICOS + Course CRICOS code, or another separately governed stable mapping;
- prohibit title-only identity;
- retain private source evidence and SHA-256 capture;
- preserve source record/version lineage;
- fail closed on ambiguity;
- keep Provider URL facts outside canonical Course identity fields.

## Search consequence

The original Search caution remains active.

Current Search state is still:

- Course Documents: 33,105
- `has_fee=true`: 0
- `has_intake=true`: 0
- `has_english=true`: 0

Layer 2 APPLY does not constitute Search admission. Search enrichment readiness remains a separate gate.

## Decision

The original v1.0 gap is **closed as a blocker**. It remains useful historical evidence for why CRICOS registered fees and Provider-current fees are modelled separately.

Current execution should follow Architecture v2.10.37, Running Build v2.41 and Master Project Plan v1.37 rather than using v1.0 as an active work queue.
