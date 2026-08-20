# CourseFinder Master Project Plan v1.37

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.36.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.41.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 active Course substrate |
| AU Layer 1 residual completeness remediation | PASS / COMPLETE | `layer1-au-depth-v1.6.0`; zero missing Study Levels; zero unexplained mapping defects |
| **AU first-party Course facts** | **IN PROGRESS / TWO SOURCE CLASSES QUALIFIED** | RMIT and UQ accepted under exact CRICOS mapping and independent bounded UAT |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents |
| Vector/semantic Search | REJECTED / NOT ADMITTED | Existing rejection remains in force |
| Search enrichment readiness | BLOCKED / SEPARATE GATE | Layer 2 facts are not automatically consumer-admitted |
| Admin/PIM hardening | PASS / COMPLETE | Existing acceptance remains in force |

## M1-L2-AU-COURSE-FACTS — controlled expansion

The Layer 1 prerequisite remains satisfied. Two independent Provider-owned web source classes are now qualified.

### Qualified source 1 — RMIT University

- source key: `au_rmit_official_course_pages`
- Provider CRICOS: `00122A`
- worker: `coursefacts-au-rmit-v0.2.0`
- qualification: qualified
- APPLY admitted: true
- Search admitted: false

### Qualified source 2 — The University of Queensland

- source key: `au_uq_official_program_pages`
- Provider CRICOS: `00025B`
- worker: `coursefacts-au-uq-v0.1.0`
- qualification: qualified
- APPLY admitted: true
- Search admitted: false

The second source class is important programme evidence: Course Facts ingestion is no longer proven only against one Provider site's HTML behaviour.

## Accepted bounded observations

Exact CRICOS mappings currently accepted under this gate:

RMIT:

- `111279A` — Associate Degree in Business
- `103390B` — Advanced Diploma of Electronics and Communications Engineering

UQ:

- `102784C` — Bachelor of Computer Science (Honours)
- `082960F` — Bachelor of Nursing (Honours)

Aggregate applied Provider-owned facts:

- 4 official Course URLs
- 4 current/year-specific international tuition fees
- 6 intakes
- 14 governed English entry requirement rows

Provider-current fee semantics remain separate from CRICOS registered total-course fees.

## Cross-source controls proven

Across the two qualified source classes:

- exact Provider CRICOS + Course CRICOS resolution;
- no title-only mapping path;
- invalid CRICOS ambiguity tests fail closed;
- private evidence snapshot + SHA-256 for every fresh source capture;
- fee year and exact published fee basis retained;
- intake timing retained without invented Campus scope;
- English tests persisted only where a governed test identity exists;
- unsupported Provider test alternatives are not coerced into another test;
- canonical `courses.course_url` is not overwritten by Layer 2;
- replay does not duplicate canonical facts;
- both dynamic-byte and unchanged-byte source replay patterns are supported;
- Search remains unchanged.

## Search boundary

After two-source APPLY/replay:

- Search Documents: 33,105
- `has_fee=true`: 0
- `has_intake=true`: 0
- `has_english=true`: 0

No Layer 2 fact becomes consumer-visible until the separate Search enrichment readiness gate explicitly admits its semantics and freshness contract.

## Next serial work

Continue `M1-L2-AU-COURSE-FACTS` through controlled source and Course coverage expansion.

Expansion priorities:

1. increase coverage within already-qualified source classes where official Provider pages remain source-verifiable;
2. qualify additional Provider source classes only after independent bounded UAT;
3. prefer machine-readable Provider catalogues where authoritative and stable;
4. resolve by published CRICOS Course code or another governed stable identifier;
5. never use title-only identity;
6. preserve exact source/evidence/versioning;
7. preserve fee year/basis and Campus/intake scope;
8. route ambiguity and unsupported English-test identities to review rather than forcing a match;
9. keep Search admission separately blocked until the dedicated enrichment-readiness gate.

The programme does not require all 1,546 CRICOS Providers to be completed before source classes can be accepted, but expansion must remain measurable, source-qualified and replay-safe.
