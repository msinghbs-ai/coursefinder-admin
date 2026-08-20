# CourseFinder Master Project Plan v1.38

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.37.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.42.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 active Course substrate |
| AU Layer 1 residual completeness remediation | PASS / COMPLETE | `layer1-au-depth-v1.6.0`; zero missing Study Levels; zero unexplained mapping defects |
| **AU first-party Course facts** | **IN PROGRESS / TWO SOURCE CLASSES QUALIFIED / COVERAGE EXPANDING** | RMIT + UQ accepted; 6 exact CRICOS Courses now bounded under replay-safe production ingestion |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents |
| Vector/semantic Search | REJECTED / NOT ADMITTED | Existing rejection remains in force |
| Search enrichment readiness | BLOCKED / SEPARATE GATE | Layer 2 facts are not automatically consumer-admitted |
| Admin/PIM hardening | PASS / COMPLETE | Existing acceptance remains in force |

## M1-L2-AU-COURSE-FACTS — current accepted state

Two independent Provider-owned source classes are qualified:

### RMIT University

- source key: `au_rmit_official_course_pages`
- Provider CRICOS: `00122A`
- worker: `coursefacts-au-rmit-v0.2.0`
- bounded Courses: 2
- APPLY admitted: true
- Search admitted: false

### The University of Queensland

- source key: `au_uq_official_program_pages`
- Provider CRICOS: `00025B`
- worker: `coursefacts-au-uq-v0.2.0`
- bounded Courses: 4
- APPLY admitted: true
- Search admitted: false

## Accepted exact Course coverage

RMIT:

- `111279A` — Associate Degree in Business
- `103390B` — Advanced Diploma of Electronics and Communications Engineering

UQ:

- `102784C` — Bachelor of Computer Science (Honours)
- `082960F` — Bachelor of Nursing (Honours)
- `045401M` — Bachelor of Commerce/Bachelor of Information Technology
- `013827E` — Bachelor of Science/Bachelor of Arts

## Aggregate applied Provider-owned facts

- exact bounded CRICOS Courses: 6
- official Course URLs: 6
- current/year-specific international tuition fees: 6
- intakes: 10
- governed English entry requirement rows: 20

Provider-current fee semantics remain separate from CRICOS registered total-course fees.

## Coverage-expansion control proven

The UQ v0.2.0 gate establishes that an already-qualified source class may expand Course coverage without a new architecture version when all of the following remain unchanged:

- Provider/Course resolution remains exact CRICOS identity;
- source authority remains the same Provider-owned program-page class;
- source proof and private evidence capture remain enforced;
- fact grain/semantics remain unchanged;
- fee year/basis remains source-preserved;
- unsupported English-test identities remain uncoerced;
- replay remains canonical-idempotent;
- Search admission remains false.

UQ coverage expansion passed dry-run `1906`, APPLY `1907` and replay `1908`.

## Change Control

Material coverage expansion is recorded as:

- `CF-CHG-20260820-002` — UQ Course Facts coverage expansion — CLOSED / PASS

Database Architecture remains v2.10.37 because this change does not alter canonical semantics or relational contracts.

## Search boundary

After the current Layer 2 APPLY/replay:

- Search Documents: 33,105
- rows with fee/intake/English enrichment: 0

No Provider-current enrichment becomes consumer-visible until Search enrichment readiness explicitly passes.

## Next serial work

Continue `M1-L2-AU-COURSE-FACTS` autonomously through measurable coverage expansion.

Priority order:

1. expand already-qualified RMIT/UQ source coverage where exact first-party Course facts can be proven;
2. qualify additional authoritative Provider source classes with independent bounded dry-run/APPLY/replay/ambiguity UAT;
3. prefer authoritative machine-readable catalogues when available;
4. preserve exact Provider CRICOS + Course CRICOS identity or another separately governed stable mapping;
5. never use title-only identity;
6. preserve source/evidence/version history, fee year/basis and intake/Campus scope;
7. keep unsupported English-test schemes out of canonical test identities until governed;
8. keep Search admission separately blocked.

The gate remains **IN PROGRESS**. Six bounded Courses are evidence of accepted ingestion behaviour, not a claim of complete AU Provider-current Course Fact coverage.
