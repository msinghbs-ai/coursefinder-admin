# CourseFinder Master Project Plan v1.40

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.39.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.44.md`

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
| Admin/PIM hardening | PASS / COMPLETE | Existing security/operational acceptance remains in force; residual legacy advisor debt remains separately governed |
| **M1-PIM-GOV — field semantics/change control/Admin Guide** | **IN PROGRESS / DB-RPC-GOVERNANCE UAT PASS** | First fee semantic walkthrough accepted; frontend/browser semantic release still required before closure |

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

QUT remains independently deferred as a source-specific acquisition issue.

- source key: `au_qut_official_course_pages`
- Provider CRICOS: `00213J`
- bounded canonical identities proven: `083019B`, `017323G`
- production fetch attempt `1909`: HTTP 403
- browser-equivalent retry `1910`: HTTP 403
- qualification: deferred
- APPLY admitted: false
- Search admitted: false
- accepted QUT canonical Layer 2 facts: 0

The QUT deferral does not block other AU Course Facts sources.

## M1-PIM-GOV — accepted semantic governance state

The dedicated semantic/governance workstream has been established to own field meaning, provenance interpretation, Change Control, the PIM Admin Guide and curated downstream consumer semantics.

### First reference walkthrough — CRICOS `121174E`

Exact identity:

- Swinburne University of Technology
- Bachelor of Artificial Intelligence
- CRICOS Course Code `121174E`
- stable Course key `course:cricos:00111d:121174e`

Canonical CRICOS fees validated:

- Tuition Fee — AUD 132,900
- Non-Tuition Fee — AUD 0
- Estimated Total Course Cost — AUD 132,900
- basis — `registered_total_course`
- audience — `international`
- fee year — `NULL` because CRICOS supplies no year for these observations.

The canonical model passed. No schema redesign or fee-value rewrite was required.

### Read-contract corrections accepted

- Course-grid compatibility fee now selects active CRICOS tuition with `basis=registered_total_course` explicitly;
- Admin fee/intake/English presence no longer inherits downstream Search projection flags;
- Course-detail fee summary now preserves fee-level campus scope, validity, source, evidence, source snapshot and verification metadata;
- Provider-current fees remain separate from CRICOS registered total-course fees;
- unclassified future fee semantics fail visibly into a review bucket rather than being mislabeled;
- direct authenticated execution of the corrected internal completeness function is revoked; the governed browser read remains `public.admin_read`.

### Governance outputs

- `change-control/30-admin-pim-ux/CF-CHG-20260820-001-pim-field-semantics-fees-admin-guide.md`
- `docs/coursefinder-pim-admin-guide-v1.0.md`
- `docs/coursefinder-zoho-consumer-contract-v1.0.md`
- `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`

### Remaining acceptance gate

`CF-CHG-20260820-001` stays OPEN until the frontend/UI implementation workstream browser-verifies:

- explicit CRICOS fee labels;
- zero-safe amount display;
- source-not-supplied year semantics;
- separate Provider-current empty/value state;
- provenance/evidence drill-down;
- unclassified fee review state;
- visible UI version update;
- exact-code `121174E` walkthrough.

The workstream must not claim full PASS merely because canonical data/RPC semantics are correct.

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

## Admin semantic controls remain mandatory

- distinguish NULL, zero, suppressed, not applicable and not-yet-enriched;
- stable identity before names/titles;
- completeness/readiness is not truth or publication approval;
- `last_verified_at` is verification, not approval;
- preserve one-to-many observation grain;
- preserve source/evidence provenance;
- never flatten regulatory and Provider-current fee semantics;
- use exception-first `Needs review` signals for unclassified/ambiguous states;
- expose curated consumer contracts rather than internal schema structure.

## Search boundary

Current Search remains:

- Course Documents: 33,105
- fee/intake/English enrichment admitted: 0

Neither Layer 2 APPLY nor the PIM governance correction authorises consumer publication.

## Change Control

Current entries:

- `CF-CHG-20260820-001` — PIM field semantics / Admin Guide — APPLIED / DB-RPC-GOVERNANCE UAT PASS / FRONTEND PENDING
- `CF-CHG-20260820-002` — UQ first Course Facts coverage expansion — CLOSED / PASS
- `CF-CHG-20260820-003` — QUT source acquisition — DEFERRED
- `CF-CHG-20260820-004` — UQ second coverage expansion — CLOSED / PASS

## Next serial/parallel work

### AU Course Facts

Continue autonomously without allowing a source-specific acquisition blocker to halt the AU lane:

1. expand already-qualified production-fetchable UQ/RMIT coverage where current official facts are provable;
2. assess additional authoritative Provider source classes using production-network preflight before substantial adapter implementation;
3. prefer authoritative machine-readable Provider sources where available;
4. defer sources that require challenge circumvention or unstable acquisition rather than manufacturing evidence;
5. keep Search admission separately blocked until `SEARCH-ENRICHMENT-READINESS` passes.

### PIM governance/UI

1. hand the accepted `CF-CHG-20260820-001` frontend criteria to the UI/PIM implementation lane;
2. browser-UAT the exact `121174E` walkthrough after the visible UI version changes;
3. close `CF-CHG-20260820-001` only when authoritative source -> evidence -> canonical storage -> Admin presentation -> change history -> curated Zoho contract is fully demonstrated;
4. continue semantic audit across Provider, Campus, Intakes, English, Study Level, Field of Study, Scholarships, QILT, PRISMS, Evidence, completeness/lifecycle/publication and Search status using the PIM Admin Guide as the living contract.

Database Architecture remains v2.10.37 because the canonical relational model did not change in this governance correction.
