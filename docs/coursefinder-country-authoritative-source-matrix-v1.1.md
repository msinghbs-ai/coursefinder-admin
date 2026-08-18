# CourseFinder Country Authoritative Source Matrix v1.1

**Status:** AUTHORITATIVE SOURCE-QUALIFICATION RECORD  
**Supersedes:** `docs/coursefinder-country-authoritative-source-matrix-v1.0.md`  
**Date:** 18 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.26.md`  
**Purpose:** Milestone 1 source strategy, Layer 1 country qualification and Layer 2 enrichment source qualification

## Executive decision

CourseFinder remains source-qualification-first.

A country enters Layer 1 production ETL only when the declared product population has authoritative, sufficiently complete, current, machine-acquirable sources with stable non-name Provider/Course identity and acceptable evidence/use semantics.

Layer 2 sources use a separate gate. They may enrich accepted canonical Providers/Courses or create independent Scholarship entities, but they cannot redefine Layer 1 identity.

## Current source matrix

| Country | Layer 1 decision | Layer 1 canonical source posture | Structured outcomes / Layer 2A | Scholarship enrichment | Programme position |
|---|---|---|---|---|---|
| Australia | **GO / ACCEPTED** | CRICOS — accepted Provider/Course/Location/Course-Location authority | QILT **PASS**; PRISMS **PASS** | Study Australia **QUALIFIED / IMPLEMENTED FIRST SOURCE**; Australia Awards **QUALIFIED / IMPLEMENTED**; RTP **BOUNDED** | Primary Milestone 1 country |
| New Zealand | **GO / ACCEPTED** | NZQA Education Organisations + Qualifications | Education Counts queued | Study with New Zealand / provider scholarships queued for qualification | Second accepted country |
| United Kingdom | **HOLD** | UKVI Provider authority; no accepted complete all-level Course authority | Discover Uni/NSS/Graduate Outcomes/LEO/TEF are Layer 2 candidates | UK government programmes / Study UK search | Enrichment candidate; no Layer 1 ETL yet |
| United States | **HOLD** | No single accepted current marketed-programme Layer 1 authority | College Scorecard candidate | EducationUSA financial-aid search candidate | Enrichment candidate; no Layer 1 ETL yet |
| Canada | **PAUSE** | IRCC DLI Provider authority accepted; Course authority federated | Statistics Canada / EduCanada where useful | EduCanada scholarship search candidate | Preserve existing work; no further fragmented M1 Layer 1 expansion |
| Germany | **PAUSE** | Strong portals exist but complete machine-use/licensing/current target-population contract remains unproven | DAAD/other structured sources after qualification | DAAD Scholarship Database candidate | Source/licensing gate before further Layer 1 work |
| Ireland | **HOLD / QUALIFY** | QQI national qualifications source; machine interface still to be proven for target implementation | To qualify separately | Government of Ireland International Education Scholarship + providers | Source qualification only |

## Australia — accepted Layer 1 substrate

CRICOS remains the AU Provider/Course identity authority.

Accepted stable identity:
- Provider = AU + CRICOS Provider Code;
- Course = accepted Provider + CRICOS Course Code;
- Campus/location relationships follow the accepted CRICOS location contract.

Layer 2 sources may reference these identities only through authoritative stable source keys. They cannot create, rename, merge or re-key CRICOS entities.

## Australia — QILT

**Status:** PASS / ACCEPTED.

Accepted structured surveys:
- Graduate Outcomes Survey;
- Student Experience Survey;
- Graduate Outcomes Survey — Longitudinal;
- Employer Satisfaction Survey.

QILT is evidence-backed Provider/outcome enrichment only and has no Provider/Course identity authority.

## Australia — PRISMS

**Status:** PASS / ACCEPTED for the first ABS SA4 publication.

The accepted source publishes aggregate geography/sector/broad-field observations and no Provider/Course identifiers. CourseFinder therefore retains Provider/Course references as null instead of inventing links.

## Australia — Scholarships

### Study Australia

**Authority:** Australian Trade and Investment Commission — Study Australia.  
**Status:** **QUALIFIED / IMPLEMENTED FIRST-SOURCE CONTRACT.**  
**Source key:** `au_study_australia_scholarships`.  
**Scholarship identifier scheme:** `study_australia_scholarship_id`.

Resource:
- https://search.studyaustralia.gov.au/scholarships

Accepted Scholarship identity:
- source-native 32-hex identifier in the canonical Scholarship detail URL.

Accepted Provider mapping:

`Study Australia Provider source key -> official Study Australia Provider page -> published CRICOS -> exact accepted catalogue Provider registration`

Provider-name identity or fallback matching is prohibited.

First-source UAT proved:
- stable Scholarship identity;
- Offering Cycles;
- Application Windows;
- Provider Scopes through exact CRICOS;
- evidence-backed eligibility narrative;
- fixed-dollar and percentage Award Tiers;
- tuition Coverage;
- deterministic replay/idempotency.

The accepted first-source population is deliberately bounded. It does not assert that the complete Study Australia catalogue has been loaded.

### Australia Awards Scholarships

**Authority:** Department of Foreign Affairs and Trade.  
**Status:** **QUALIFIED / IMPLEMENTED.**  
**Source key:** `au_dfat_australia_awards`.  
**Identifier scheme:** `dfat_award_scheme`.

Resources:
- https://www.dfat.gov.au/people-to-people/australia-awards/australia-awards-scholarships
- https://www.dfat.gov.au/people-to-people/australia-awards/australia-awards-scholarships-opening-and-closing-dates
- https://www.dfat.gov.au/about-us/publications/australia-awards-scholarships-policy-handbook
- https://oasis.dfat.gov.au/

Accepted enduring Scholarship identity:

`AAS`

The 2027 scheme/intake is Offering Cycle `2027`, not a new Scholarship row.

The accepted 2027 cycle proves:
- multiple Application Windows;
- nested `all` / `any` Eligibility groups;
- published eligibility criteria;
- separate Coverage facts;
- private source/evidence version lineage.

### Research Training Program

**Authority:** Australian Government Department of Education.  
**Status:** **BOUNDED.**  
**Source key:** `au_education_rtp`.  
**Persistent program identifier:** `10.82133/C42F-K220`.

Resource:
- https://www.education.gov.au/research-block-grants/research-training-program

Accepted boundary:
- central RTP program identity and central benefits/coverage are source-qualified;
- Provider-specific application windows are not derived from the central page because eligible providers administer applications;
- Provider windows require first-party Provider evidence before canonical ingestion.

## Scholarship source gate

A Scholarship source is accepted for canonical ingestion only when the source contract proves the relevant subset of:
1. stable Scholarship source identity that is not title-only;
2. source authority and currentness/version semantics;
3. deterministic acquisition within a bounded runtime;
4. evidence snapshot/hash lineage;
5. Offering Cycle semantics distinct from Scholarship identity;
6. Application Window semantics without inventing missing time/time-zone facts;
7. Scope mappings through accepted stable canonical identifiers where applicable;
8. Eligibility structure preserved as published, including compound logic when authoritative;
9. Award Tier and Coverage semantics kept separate;
10. replay/idempotency and historical evidence versioning;
11. no implicit student-facing publication.

Failure of a field does not justify fabrication. The source may be `BOUNDED` to the facts it actually authoritatively publishes.

## New Zealand

Layer 1 remains accepted through NZQA.

Layer 2 priorities:
- Education Counts for structured outcome/achievement enrichment;
- Study with New Zealand and first-party provider Scholarship sources after stable source-identity qualification.

No NZ Scholarship implementation is accepted merely because a discovery page exists; the source must first pass the Scholarship-specific gate above.

## Other countries

The v1.0 country decisions remain unchanged:
- GB and US: strong Layer 2 candidates, Layer 1 HOLD;
- CA: existing work preserved, Layer 1 expansion PAUSED;
- DE: PAUSED pending source/use qualification;
- IE: HOLD/QUALIFY.

Scholarship datasets in those countries may be qualified independently as Layer 2 sources without reopening Layer 1 country gates.

## Governance decision

**Australia Scholarship source qualification has moved from candidate to first-source PASS.**

Study Australia and Australia Awards are accepted implementation contracts. RTP is accepted only within its bounded central-program authority. The next Scholarship work is controlled catalogue/source expansion, not relaxation of identity or evidence rules.
