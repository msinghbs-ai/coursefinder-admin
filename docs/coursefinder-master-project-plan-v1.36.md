# CourseFinder Master Project Plan v1.36

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.35.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.36.md`  
**Running build:** `docs/coursefinder-running-build-v2.40.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 active Course substrate |
| AU Layer 1 residual completeness remediation | PASS / COMPLETE | `layer1-au-depth-v1.6.0`; zero missing Study Levels; zero unexplained mapping defects |
| **AU first-party Course facts** | **IN PROGRESS / FIRST SOURCE ACCEPTED** | RMIT official Course pages accepted under exact CRICOS mapping and bounded UAT |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents |
| Vector/semantic Search | REJECTED / NOT ADMITTED | Existing rejection remains in force |
| Search enrichment readiness | BLOCKED / SEPARATE GATE | Layer 2 facts are not automatically consumer-admitted |
| Admin/PIM hardening | PASS / COMPLETE | Existing acceptance remains in force |

## M1-L2-AU-COURSE-FACTS — first source PASS

The Layer 1 prerequisite is satisfied and the first bounded Provider source has independently passed fresh-source UAT.

Accepted source:

- authority: RMIT University
- source key: `au_rmit_official_course_pages`
- Provider CRICOS: `00122A`
- worker: `coursefacts-au-rmit-v0.2.0`
- qualification: `qualified`
- identity authority: false
- APPLY admitted: true
- Search admitted: false

## First accepted Course observations

Exact CRICOS Course mappings:

- `111279A` — Associate Degree in Business
- `103390B` — Advanced Diploma of Electronics and Communications Engineering

Applied Provider-owned facts:

- 2 official Course URLs
- 2 current/year-specific international tuition fees
- 3 intakes
- 8 English entry requirement rows

Provider-current fee semantics are kept separate from CRICOS registered total-course fees.

## Gate controls proven

- exact Provider CRICOS + Course CRICOS resolution;
- no title-only mapping path;
- invalid CRICOS ambiguity test fails closed;
- private evidence snapshot + SHA-256 for each fresh source capture;
- fee year and published fee basis preserved;
- intake timing preserved without inventing Campus scope;
- English tests resolve to governed `ref.english_tests`;
- canonical `courses.course_url` is not overwritten by Layer 2;
- repeated fresh APPLY does not duplicate canonical facts;
- dynamic source-byte changes are retained as evidence versions;
- Search remains unchanged.

## Search boundary

After first-source APPLY/replay:

- Search Documents: 33,105
- `has_fee=true`: 0
- `has_intake=true`: 0
- `has_english=true`: 0

No Layer 2 fact becomes consumer-visible until the separate Search enrichment readiness gate explicitly admits its semantics and freshness contract.

## Next serial work

Continue `M1-L2-AU-COURSE-FACTS` through controlled first-party source expansion.

Expansion rules:

1. prefer authoritative Provider/University Course pages or machine-readable Provider catalogues;
2. resolve by published CRICOS Course code or another governed stable identifier;
3. never use title-only identity;
4. preserve exact source/evidence/versioning;
5. preserve fee year/basis and Campus/intake scope;
6. route ambiguity to review rather than forcing a match;
7. run bounded dry-run/APPLY/replay/idempotency UAT for each new source/adaptor class;
8. keep Search admission separately blocked.

The programme does not require every one of the 1,546 CRICOS Providers to be implemented before a source class can be accepted, but coverage expansion must be measurable and source-qualified rather than inferred.
