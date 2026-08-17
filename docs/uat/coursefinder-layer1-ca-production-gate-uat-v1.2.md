# CourseFinder — Layer 1 Canada Production Gate UAT v1.2

**Date:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.22.md`  
**Supersedes:** `docs/uat/coursefinder-layer1-ca-production-gate-uat-v1.1.md`  
**Pilot:** `msinghbs-ai/Coursefinder-Pilot` / `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Gate result:** **BLOCKED — PRODUCT SCOPE CORRECTED; BC + UCALGARY + UALBERTA DEGREE SUB-GATES PASS; NATIONAL BACHELOR+ COVERAGE AND FINAL COUNTRY UAT REMAIN**

## 1. Scope change

The Canada Layer 1 target is now explicitly:

`ca-intl-bachelor-plus-v1`

The production catalogue needs Courses relevant to international students at Bachelor's level or above; it does not need every Canadian post-secondary programme.

A Course is eligible for active scope only when:
- its canonical Provider has a current IRCC DLI identity;
- an accepted source provides a stable non-name programme identifier;
- current catalogue membership is proven;
- the accepted source explicitly classifies the programme as Bachelor, Master, Doctorate/PhD or supported first-professional;
- jurisdiction-specific international designation rules are satisfied.

Titles/provider names cannot establish identity or study level.

## 2. Live scope state after correction

| Measure | Current |
|---|---:|
| Total physical CA Course rows | 9,960 |
| Active scope-qualified CA Courses | **1,986** |
| Inactive historical CA Course rows | 7,974 |
| Active CA Providers with Courses | **25** |
| Bachelor | **1,055** |
| Master | **632** |
| Doctorate | **290** |
| First-professional | **9** |
| Active null study level | **0** |

Inactive historical rows remain preserved and are not deleted.

Current student-facing publication/search remains protected while CA is BLOCKED.

## 3. Historical broad-source correction

The following broad data is preserved but not active unless requalified:
- BC: 2,687 EPBC records outside Bachelor+ retired; 1,428 degree-scope records retained active.
- Quebec: 1,363 MES non-degree Courses inactive/unpublished.
- Ontario legacy public-college broad Courses inactive.
- Manitoba, Nova Scotia, Saskatchewan, Newfoundland and Labrador, Northwest Territories and Yukon legacy broad/unclassified Courses inactive.

This prevents lower-level/unclassified data from leaking into the declared product scope.

## 4. BC degree scope

Accepted active set:
- 1,428 Courses / 23 Providers;
- 693 Bachelor;
- 513 Master;
- 213 Doctorate;
- 9 first-professional.

Identity:
`bc_epbc_program_guid`

BC is accepted at scope-definition/integrity level, but an explicit final degree-only full APPLY/replay proof remains scheduled before the country gate closes.

## 5. Alberta source contract

Source: Government of Alberta ALIS post-secondary programme catalogue.  
Source ID: `2455ffdf-66ae-4b82-943c-b7293d996668`  
Identity: `ab_alis_program_guid`  
Worker: `layer1-ca-ab-alis-degrees-v0.2.0`

Accepted source classification:
- `Credential Type = Degree`; and
- exact `Program Type`:
  - Bachelor's -> `bachelor`;
  - Master's -> `masters`;
  - Doctoral -> `doctorate`.

No title-based credential inference is permitted.

For current public Alberta institutions, institution-level international designation plus current IRCC DLI identity is accepted. Private DLIs require programme-specific evidence.

## 6. University of Calgary sub-gate

**Result: PASS**

- inventory: 279/279 stable programme GUIDs;
- accepted: 179;
- levels: 83 Bachelor / 59 Master / 37 Doctorate;
- first APPLY: 179 created / 0 conflicts;
- replay: 0 created / 179 existing / 0 conflicts;
- integrity: 179 distinct identifiers = 179 Courses; 0 orphans.

## 7. University of Alberta sub-gate

Stable ALIS school UUID: `420f73a6-7623-4ec9-8013-a12700c54747`  
IRCC DLI: `O19257171832`  
Canonical Provider ID: `db436563-4650-4820-bd76-0695afcc953d`

### 7.1 Live inventory

**PASS**

- current ALIS records: 432;
- distinct programme GUIDs: 432;
- inventory completeness: 432/432;
- inventory hash: `318438de427989379f77159983fbfd2d081ebb04eb1c31cd7ca02ef61d921efa`.

### 7.2 Degree-only dry-run

**PASS**

- processed: 432/432;
- accepted stable GUIDs: 379;
- distinct accepted GUIDs: 379;
- Bachelor: 279;
- Master: 60;
- Doctorate: 40;
- unexpected study levels: 0;
- canonical writes during dry-run: 0.

One request returned a transient `JWT issued at future` automation-authorisation error. The exact offset was retried once and passed. The failed request performed no canonical write and the error did not recur during production APPLY/replay.

### 7.3 First APPLY

**PASS**

- bounded batches: 54/54 PASS;
- accepted: 379;
- created: **379**;
- existing: 0;
- conflicts: **0**;
- failed batches: **0**.

### 7.4 Full replay/idempotency

**PASS**

- bounded batches: 54/54 PASS;
- created: **0**;
- existing: **379**;
- conflicts: **0**;
- failed batches: **0**.

### 7.5 Integrity

**PASS**

- identifiers: 379;
- distinct identifiers: 379;
- distinct Courses: 379;
- orphan identifiers: 0;
- wrong Provider links: 0;
- active Courses: 379;
- null study levels: 0;
- level split exactly 279 / 60 / 40.

Alberta scoped source keys after UCalgary + UAlberta:
- 558 keys;
- 558 distinct programme GUIDs;
- 2 Providers.

## 8. Current gate matrix

| Test | Result | Position |
|---|---|---|
| IRCC live Provider authority | **PASS** | 1,130 Providers / DLI identifiers. |
| Non-name Provider identity | **PASS** | DLI number. |
| Non-name Course identity architecture | **PASS** | Provider + source scheme + stable source-local ID. |
| International + Bachelor+ scope contract | **PASS — IMPLEMENTED** | `ca-intl-bachelor-plus-v1`. |
| Historical broad-data isolation | **PASS — CANONICAL LIFECYCLE** | Lower/unclassified broad rows retained inactive. |
| BC scoped active set | **PASS — DATA SCOPE** | 1,428 active degree-level Courses. |
| UCalgary ALIS sub-gate | **PASS** | APPLY/replay/integrity complete. |
| UAlberta ALIS sub-gate | **PASS** | 432 inventory; 379 APPLY; full replay clean. |
| Remaining Alberta public DLIs | **IN PROGRESS** | Verified mappings exist; production UAT outstanding. |
| Ontario Bachelor+ university coverage | **BLOCKED/PENDING** | New degree source set required. |
| Quebec Bachelor+ degree coverage | **BLOCKED/PENDING** | Existing MES source is non-degree and inactive. |
| Other provincial/territorial degree coverage | **PENDING** | Requalify only degree-granting scope. |
| Full CA scoped APPLY/replay | **NOT YET COMPLETE** | Await declared national source set. |
| Full CA integrity | **PARTIAL PASS** | Current active set clean; national set incomplete. |
| Search Projection | **PENDING/PROTECTED** | No student-facing CA publication until final gate. |
| Security | **PARTIAL PASS** | Restricted scope/RPC/evidence model; diagnostic probes remain to remove/lock. |
| Performance | **PARTIAL PASS** | UAlberta bounded batches completed within worker limits; final country UAT pending. |

## 9. Remaining blocker

**Blocker code:** `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`

The blocker is now defined as incomplete national/federated coverage for **international-student eligible Bachelor+ Courses**.

The country gate does not require ingestion of every diploma/certificate/trade programme.

## 10. Required next sequence

1. Run inventory/dry-run/APPLY/full replay/integrity for remaining verified Alberta public-DLI mappings.
2. Resolve St. Mary's University stable source mapping if current evidence supports it.
3. Qualify Ontario university degree sources with stable programme IDs.
4. Qualify Quebec Bachelor+/graduate degree sources.
5. Fill remaining degree-granting provincial/territorial gaps.
6. Re-prove BC degree-only APPLY/full replay explicitly.
7. Run full CA active-scope duplicate/orphan/current-DLI/study-level/geography integrity.
8. Rebuild and UAT Search Projection with zero inactive broad-data leakage.
9. Remove/lock diagnostic/probe Edge Functions and run security advisors.
10. Run final acquisition/search performance UAT.
11. Promote CA to PASS only if every final condition succeeds.

## 11. Decision

**CA remains BLOCKED / NOT YET ACCEPTED FOR PRODUCTION SEARCH.**

The scope architecture is now product-correct and both University of Calgary and University of Alberta have passed complete Alberta ALIS production sub-gates. The active blocker is remaining national Bachelor+ coverage plus final country Search/security/performance UAT.
