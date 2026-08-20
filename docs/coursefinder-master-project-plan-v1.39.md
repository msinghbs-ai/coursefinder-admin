# CourseFinder Master Project Plan v1.39

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.38.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.43.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 active Course substrate |
| AU Layer 1 residual completeness remediation | PASS / COMPLETE | `layer1-au-depth-v1.6.0`; zero missing Study Levels; zero unexplained mapping defects |
| **AU first-party Course facts** | **IN PROGRESS / 2 QUALIFIED SOURCES / 10 COURSES BOUNDED** | RMIT + UQ production ingestion accepted; controlled expansion continues |
| QUT Course Facts candidate | DEFERRED / SOURCE-SPECIFIC | Official pages are semantically suitable but production Edge acquisition returns HTTP 403; APPLY disabled |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents |
| Vector/semantic Search | REJECTED / NOT ADMITTED | Existing rejection remains in force |
| Search enrichment readiness | BLOCKED / SEPARATE GATE | Layer 2 facts are not automatically consumer-admitted |
| Admin/PIM hardening | PASS / COMPLETE | Existing acceptance remains in force |

## M1-L2-AU-COURSE-FACTS — accepted production state

### Qualified source 1 — RMIT University

- source key: `au_rmit_official_course_pages`
- Provider CRICOS: `00122A`
- worker: `coursefacts-au-rmit-v0.2.0`
- exact bounded Courses: 2
- APPLY admitted: true
- Search admitted: false

### Qualified source 2 — The University of Queensland

- source key: `au_uq_official_program_pages`
- Provider CRICOS: `00025B`
- worker: `coursefacts-au-uq-v0.3.0`
- exact bounded Courses: 8
- APPLY admitted: true
- Search admitted: false

Accepted UQ CRICOS set:

- `102784C`
- `082960F`
- `045401M`
- `013827E`
- `019886A`
- `001942A`
- `080734K`
- `092454G`

UQ v0.3.0 passed dry-run `1912`, APPLY `1913` and replay `1914`.

## Aggregate accepted Provider-owned facts

Across RMIT + UQ:

- exact bounded CRICOS Courses: 10
- official Course URLs: 10
- Provider-current international tuition fees: 10
- intake observations: 18
- governed English requirement observations: 32

These figures describe bounded accepted production coverage only; they are not a claim of complete Australian Provider-current Course Fact coverage.

## Deferred source candidate — QUT

QUT was independently assessed as a third Provider-owned source class.

- source key: `au_qut_official_course_pages`
- Provider CRICOS: `00213J`
- bounded canonical identities proven: `083019B`, `017323G`
- production fetch attempt `1909`: HTTP 403
- browser-equivalent retry `1910`: HTTP 403
- qualification: deferred
- APPLY admitted: false
- Search admitted: false
- accepted QUT canonical Layer 2 facts: 0

The programme will not bypass Provider anti-bot controls merely to increase coverage. QUT may be reconsidered when an authorised stable first-party acquisition path becomes available.

The QUT deferral is source-specific and does not block other AU Course Facts sources.

## Cross-source controls remain mandatory

All accepted Course Facts expansion must continue to enforce:

- exact Provider CRICOS + Course CRICOS identity or another separately governed stable mapping;
- no title-only identity;
- Provider source qualification before APPLY;
- fresh authoritative source evidence and SHA-256 retention;
- exact Provider-published fee year/basis;
- Provider-current fee separation from CRICOS registered total-course fees;
- intake/Campus scope only where explicitly supported;
- governed English-test identities only;
- fail-closed ambiguity handling;
- replay-safe canonical cardinality;
- no canonical `courses.course_url` mutation from Layer 2 links;
- separate Search admission.

## Search boundary

Current Search remains:

- Course Documents: 33,105
- fee/intake/English enrichment admitted: 0

Layer 2 APPLY does not authorise consumer publication.

## Change Control

Current Layer 2 entries:

- `CF-CHG-20260820-002` — UQ first coverage expansion — CLOSED / PASS
- `CF-CHG-20260820-003` — QUT source acquisition — DEFERRED
- `CF-CHG-20260820-004` — UQ second coverage expansion — CLOSED / PASS

## Next serial work

Continue `M1-L2-AU-COURSE-FACTS` autonomously without allowing a source-specific acquisition blocker to halt the AU lane.

Priority order:

1. expand already-qualified production-fetchable UQ/RMIT coverage where current official facts are provable;
2. assess additional authoritative Provider source classes using production-network preflight before substantial adapter implementation;
3. prefer authoritative machine-readable Provider sources where available;
4. defer sources that require challenge circumvention or unstable acquisition rather than manufacturing evidence;
5. preserve exact identity, fee, intake, English, validity and evidence semantics;
6. keep Search admission separately blocked until `SEARCH-ENRICHMENT-READINESS` passes.

Database Architecture remains v2.10.37 because no canonical relational or semantic contract changed in this expansion wave.
