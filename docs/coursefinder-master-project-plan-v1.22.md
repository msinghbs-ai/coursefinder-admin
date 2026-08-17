# CourseFinder Master Project Plan v1.22

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.21.md`  
**Last consolidated:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.22.md`  
**Running build:** `docs/coursefinder-running-build-v2.24.md`

## Current position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 IRCC DLI identifiers.
- CA product scope is now explicitly `ca-intl-bachelor-plus-v1`.
- Active scope-qualified CA Courses: **1,986 across 25 Providers**.
  - Bachelor: 1,055
  - Master: 632
  - Doctorate: 290
  - First-professional: 9
  - Active Courses with null study level: 0
- Total physical CA Course rows: 9,960. Of these, 7,974 are retained inactive history and are not part of the active product catalogue.
- BC degree-only gate: 1,428 active Courses / 23 Providers.
- Alberta ALIS verified so far: 558 active Courses / 2 Providers.
  - University of Calgary: 179 — 83 Bachelor / 59 Master / 37 Doctorate.
  - University of Alberta: 379 — 279 Bachelor / 60 Master / 40 Doctorate.
- CA remains blocked on national degree-source coverage plus final Search Projection/security/performance UAT.

## Phase 1 — Layer 1 Canada production scope

### Authoritative product scope

Canada Layer 1 Course acquisition is limited to Courses suitable for the international-student discovery product and classified by an accepted source at Bachelor's level or above.

Required Provider condition:
- current IRCC Designated Learning Institution identity is present and reconciles to the canonical Provider by `ircc_dli` identifier.

Accepted Course levels:
- Bachelor;
- Master;
- Doctorate/PhD;
- first-professional only where the authoritative source explicitly distinguishes that credential.

Excluded from active Layer 1 Course scope:
- associate degrees where below Bachelor level;
- diplomas and advanced diplomas;
- certificates;
- graduate certificates/diplomas;
- post-baccalaureate certificates/diplomas;
- trades/apprenticeship/non-credential programmes;
- records whose study level cannot be established from the accepted source contract.

Course titles and Provider names have zero identity power and must not be used to infer scope.

### Identity contract

- Provider identity: `CA + ircc_dli + DLI number`.
- Course identity: `Provider + source identity scheme + stable source-local programme identifier`.
- Source classification determines study level; title heuristics are prohibited.
- Raw source evidence and current inventory are retained independently of canonical publication state.

### International eligibility rule

- A current IRCC DLI is mandatory for every active CA Provider.
- For Alberta public post-secondary institutions, current public institution-level designation plus current ALIS degree catalogue membership is accepted as the Layer 1 international eligibility gate.
- Private Alberta DLIs require programme-specific designation evidence before their programmes may enter the active scope.

## Historical broad-source correction

Earlier broad Canadian catalogue loads remain preserved for lineage but are not active product data where they cannot prove the new scope.

Corrections already applied:
- BC broad EPBC records outside Bachelor+ scope: 2,687 retired inactive/unpublished; 1,428 retained active.
- Quebec MES non-degree source: 1,363 Courses retired inactive/unpublished.
- Ontario, Manitoba, Nova Scotia, Saskatchewan, Newfoundland and Labrador, Northwest Territories and Yukon legacy broad/unclassified Course rows remain inactive until requalified under `ca-intl-bachelor-plus-v1`.

No historical identities were deleted.

## Alberta production sub-gate

Source: Government of Alberta ALIS post-secondary programme catalogue.  
Identity scheme: `ab_alis_program_guid`.

### University of Calgary — PASS

- live inventory: 279/279 stable ALIS programme GUIDs;
- accepted scope: 179;
- first APPLY: 179 created / 0 conflicts;
- replay: 0 created / 179 existing / 0 conflicts;
- integrity: 179 distinct identifiers / 179 distinct Courses / 0 orphans.

### University of Alberta — PASS

- live inventory: 432/432 stable ALIS programme GUIDs;
- accepted scope: 379 — 279 Bachelor / 60 Master / 40 Doctorate;
- first APPLY: 54 bounded batches, 379 created / 0 existing / 0 conflicts / 0 failed batches;
- replay: 54 bounded batches, 0 created / 379 existing / 0 conflicts / 0 failed batches;
- integrity: 379 distinct identifiers / 379 distinct Courses / 0 orphan identifiers / 0 wrong Provider links / 0 null study levels.

One transient dry-run automation-authorisation clock error was retried once at the same offset and passed without a canonical write. It did not recur during APPLY or full replay.

## CA production blocker

**Blocker code:** `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`

The blocker now means incomplete national coverage for the declared **international + Bachelor-or-above** scope, not incomplete ingestion of every post-secondary programme.

Before CA can become PASS, the accepted source set must demonstrate:
1. authoritative and current source provenance;
2. stable non-name programme identity;
3. deterministic Provider-to-current-DLI mapping;
4. exact source-based Bachelor+ classification;
5. bounded acquisition/resume;
6. private raw evidence/hash lineage;
7. dry-run/APPLY/full replay idempotency;
8. duplicate/orphan/subdivision integrity;
9. Search Projection with no inactive/broad-data leakage;
10. Edge/RPC/storage security review and probe cleanup;
11. production performance/advisor UAT.

## Immediate Layer 1 sequence

1. Complete remaining mapped Alberta public DLI institutions through the ALIS Bachelor+ adapter.
2. Resolve St. Mary's University stable ALIS school identity if current DLI/source evidence supports it.
3. Qualify Ontario university degree sources; the legacy public-college broad catalogue does not satisfy the new product scope.
4. Qualify Quebec Bachelor+/graduate degree sources; the existing MES non-degree source remains inactive.
5. Complete degree-granting coverage for remaining provinces/territories using authoritative provincial or first-party institutional stable identifiers.
6. Re-prove BC degree-only APPLY/replay as an explicit scope gate.
7. Run full-country CA integrity, Search Projection, security and performance UAT.
8. Promote CA to PASS only after the declared national scope is defensible and all final gates close.

Primary country sequence remains:
1. CA;
2. GB;
3. US;
4. IE;
5. DE remediation.

## Parallel Layer 2 position

Scholarship relational core design remains accepted and applied. Scholarship enrichment remains a Layer 2 workstream and does not change the Layer 1 country sequence or the CA production gate.

## Current programme decision

**Canada remains ACTIVE/BLOCKED. The authoritative CA target is now international-student eligible, Bachelor-or-above Courses only. BC and the first two Alberta university sub-gates are scope-qualified; national degree-source coverage and final country UAT remain outstanding.**
