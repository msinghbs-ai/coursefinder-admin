# CourseFinder Country Authoritative Source Matrix v1.0

**Status:** AUTHORITATIVE SOURCE-QUALIFICATION RECORD  
**Date:** 18 August 2026  
**Purpose:** Milestone 1 source strategy and country ETL qualification  
**Programme decision:** Country ETL expansion is paused unless a country passes the source-qualification gate defined in `docs/coursefinder-database-architecture-v2.10.23.md`.

## Executive decision

CourseFinder will no longer build country adapters first and discover source fragmentation during implementation.

A country enters Layer 1 production ETL only when an authoritative source can provide a complete target population, stable non-name Provider and Course/Qualification identifiers, current lifecycle, deterministic machine acquisition and acceptable product-use terms.

Current decision:

| Country | Layer 1 decision | Layer 1 canonical source posture | Structured outcomes / Layer 2A | Scholarship enrichment | Programme position |
|---|---|---|---|---|---|
| Australia | **GO / ACCEPTED** | CRICOS — comprehensive Provider/Course/Location/Course-Location regulatory dataset | QILT + PRISMS | Study Australia + Australia Awards + RTP | Primary Milestone 1 country |
| New Zealand | **GO / ACCEPTED** | NZQA Education Organisations + Qualifications | Education Counts | Study with New Zealand / provider scholarships | Second accepted country |
| United Kingdom | **HOLD** | UKVI is Provider authority; Discover Uni is eligible undergraduate-course dataset, not complete all-level Course authority | Discover Uni + NSS + Graduate Outcomes + LEO + TEF | UK government programmes / Study UK search | Enrichment candidate; no Layer 1 ETL yet |
| United States | **HOLD** | No single verified CRICOS-equivalent national current marketed-programme authority qualified | College Scorecard | EducationUSA financial-aid search | Enrichment candidate; no Layer 1 ETL yet |
| Canada | **PAUSE** | IRCC DLI is complete Provider authority; Course authority is federated/provincial/institutional | Statistics Canada / EduCanada where useful | EduCanada scholarship search | Preserve existing work; stop further country ETL generation |
| Germany | **PAUSE** | Hochschulkompass is strong national study portal but complete open machine-use/redistribution contract not proven; DAAD International Programmes is a subset | DAAD / other structured sources after qualification | DAAD Scholarship Database | Source/licensing gate before any further Layer 1 adapter work |
| Ireland | **HOLD / QUALIFY** | QQI Irish Register of Qualifications is a national qualifications/programmes authority; bulk/API machine interface still to be proven | To qualify separately | Government of Ireland International Education Scholarship + provider sources | Best next source-qualification candidate, not implementation candidate |

## Source qualification gate

A country is `GO` for Layer 1 only if all are proven:

1. Authoritative/national source for the declared CourseFinder product population.
2. Stable non-name Provider identity.
3. Stable non-name Course/Qualification/Programme identity.
4. Complete target population, not an incidental subset unless the product scope exactly matches that subset.
5. Current lifecycle/currentness semantics.
6. Deterministic machine acquisition: bulk file or bounded repeatable endpoint.
7. Full inventory, hash and evidence can be reproduced.
8. Licensing/redistribution/product-use terms are acceptable.
9. Replay is idempotent and supports change detection.
10. Campus/location relationships are available where the source exposes them.

Failure of any mandatory item means `HOLD` or `PAUSE`; it does **not** trigger custom institution-by-institution ETL construction.

Layer 2 sources have a different gate. A source may be valuable for outcomes, fees, scholarships, intakes or other enrichment without having authority to create Provider/Course identity.

---

## Australia — GO / ACCEPTED

### Layer 1 — CRICOS

Authority: Australian Government Commonwealth Register of Institutions and Courses for Overseas Students.

Why it qualifies:
- national regulatory population for providers/courses offered to student-visa holders;
- stable `CRICOS Provider Code`;
- stable `CRICOS Course Code`;
- explicit current/expired status;
- locations and Course-to-Location relationships;
- bulk machine-readable files plus consolidated archive;
- repeatable snapshot/evidence model already proven in CourseFinder production UAT.

Resources:
- Dataset: https://data.gov.au/data/dataset/cricos
- `CRICOS Institutions.csv`
- `CRICOS Courses.csv`
- `CRICOS Locations.csv`
- `CRICOS Course Locations.csv`
- consolidated `CRICOS Providers, Courses, Locations` archive
- historical monthly snapshots published with the dataset.

Canonical mapping:
- Provider = `AU + cricos + CRICOS Provider Code`.
- Course = `Provider + cricos + CRICOS Course Code`.
- Campus = Provider + authoritative CRICOS Location Name/stable source relationship under the accepted adapter contract.

### Layer 2A — QILT outcomes

QILT is the preferred structured Australian higher-education outcome/experience source. It is an enrichment source, not Course identity authority.

Resources:
- QILT: https://www.qilt.edu.au/
- Graduate Outcomes Survey: https://www.qilt.edu.au/surveys/graduate-outcomes-survey-%28gos%29
- Student Experience Survey: https://www.qilt.edu.au/surveys/student-experience-survey-%28ses%29
- Graduate Outcomes Survey — Longitudinal: https://qilt.edu.au/surveys/graduate-outcomes-survey---longitudinal-%28gos-l%29
- Employer Satisfaction Survey: https://www.qilt.edu.au/surveys/employer-satisfaction-survey-%28ess%29

Target canonical use:
- Provider/study-area/course-level outcome observations;
- graduate employment/further-study/salary measures;
- student experience measures;
- employer satisfaction;
- time/version scoped observations with source/evidence lineage.

### Layer 2A — PRISMS international-student activity

Resources:
- Department of Education international student monthly summary/data tables: https://www.education.gov.au/international-education-data-and-research/international-student-monthly-summary-and-data-tables

Target use:
- international enrolments;
- commencements;
- student counts and trend observations by available dimensions;
- time-series enrichment, never canonical Course identity.

### Layer 2 — Scholarships

Resources:
- Study Australia Course Search: https://www.studyaustralia.gov.au/en/plan-your-studies/find-a-course
- Study Australia scholarship search: https://search.studyaustralia.gov.au/scholarships?page=1
- Scholarship guidance: https://www.studyaustralia.gov.au/en/plan-your-studies/scholarships
- Australia Awards: https://www.dfat.gov.au/people-to-people/australia-awards
- Research Training Program: https://www.education.gov.au/research-block-grants/research-training-program

Canonical use:
- create/reconcile Scholarship by stable source identifier where available;
- recurring years/intakes are Offering Cycles, not cloned Scholarship identities;
- preserve application windows, scope, eligibility, award tiers and coverage separately.

**Decision:** Australia is the Milestone 1 reference country for full Layer 1 + structured Layer 2 enrichment.

---

## New Zealand — GO / ACCEPTED

### Layer 1 — NZQA

Resources:
- Education organisations: https://www.nzqa.govt.nz/providers/index.do
- Qualifications/courses search: https://www.nzqa.govt.nz/qualifications/courses/index.do

Accepted CourseFinder production result:
- 409 Providers;
- 6,457 Courses/Qualifications;
- 6,457 Search Documents;
- zero Provider/Course identity duplicates under the accepted NZQA identity contract.

Canonical mapping:
- Provider = `NZ + nzqa + Education Organisation number`.
- Course/Qualification = `Provider + nzqa + NZQA qualification Number`.

### Layer 2A — Education Counts

Resources:
- Tertiary provider directory: https://www.educationcounts.govt.nz/directories/list-of-tertiary-providers
- Achievement/attainment statistics: https://www.educationcounts.govt.nz/statistics/achievement-and-attainment

Target use:
- provider cross-checks;
- qualification achievement;
- field/specialisation observations;
- completion/progression measures;
- time-scoped enrichment only.

### Layer 2 — Scholarships

Resource:
- Study with New Zealand scholarships: https://www.studywithnewzealand.govt.nz/en/study-options/scholarships

Target use:
- national/provider scholarship discovery;
- Scholarship source identity where available;
- provider/level/country applicability and recurring Offering Cycles.

**Decision:** New Zealand remains accepted. Extend enrichment before attempting additional fragmented-country Layer 1 work.

---

## United Kingdom — HOLD for Layer 1; strong Layer 2 candidate

### Provider authority

Resource:
- UKVI Register of licensed sponsors — students: https://www.gov.uk/government/publications/register-of-licensed-sponsors-students

This is useful Provider authority but does not supply a complete canonical Course catalogue.

### Course/outcome data

Resources:
- Discover Uni information for providers: https://discoveruni.gov.uk/information-providers/
- National Student Survey data: https://www.officeforstudents.org.uk/for-providers/student-protection-and-choice/national-student-survey-nss/nss-data/
- TEF data: https://www.officeforstudents.org.uk/data-and-analysis/tef-data-dashboard/get-the-data/

Discover Uni combines structured course information and outcome sources but the annual dataset is for eligible undergraduate courses. It therefore does not qualify as a complete all-level Layer 1 Course authority under the current CourseFinder target.

Target Layer 2 use after mapping gate:
- undergraduate course outcome observations;
- NSS;
- Graduate Outcomes/LEO measures exposed through Discover Uni;
- TEF/provider quality observations.

### Scholarships

Resources:
- UK postgraduate international scholarships: https://www.gov.uk/postgraduate-scholarships-international-students
- FCDO scholarship programmes: https://www.gov.uk/guidance/foreign-commonwealth-development-office-international-scholarship-programmes

These are valuable programme sources but not a complete national provider-scholarship catalogue.

**Decision:** Do not build GB Layer 1 ETL until a complete target-scope Course authority with stable programme identity passes source qualification. Structured outcomes can be a separate Layer 2 workstream.

---

## United States — HOLD for Layer 1; Layer 2 candidate

### Outcomes / institution-program data

Resource:
- US Department of Education data catalogue / College Scorecard: https://data.ed.gov/dataset?tags=scorecard

College Scorecard is strong structured enrichment for institution/program completion, debt, repayment and earnings. It has not been accepted as a current canonical marketed-programme Course identity source for CourseFinder.

### Scholarships / financial aid

Resource:
- EducationUSA financial-aid search: https://educationusa.state.gov/financial-aid

Target use:
- scholarship/financial-aid discovery and source observations after stable source-identity validation.

**Decision:** No US Layer 1 ETL until a source-qualified Course identity/currentness authority is proven. Scorecard is evaluated as Layer 2A first.

---

## Canada — PAUSE

### Provider authority

Resource:
- IRCC DLI list: https://www.canada.ca/en/immigration-refugees-citizenship/services/study-canada/study-permit/prepare/designated-learning-institutions-list.html

IRCC provides a strong current Provider authority and stable DLI identity.

### Why Course ETL is paused

Canada has no single accepted CRICOS-equivalent national current Course catalogue for the CourseFinder international Bachelor+ target. Course currentness and stable programme IDs have required provincial and institutional authorities.

The existing CourseFinder work proved the identity model but at disproportionate integration cost. Current preserved live state at the pause decision:
- 1,130 CA Providers;
- 10,253 physical CA Courses;
- 2,279 currently active scoped rows;
- 7,974 inactive/historical rows;
- CA is not included in the accepted Search Projection.

No existing canonical/history rows are deleted by this pause.

### Structured enrichment sources

Resources:
- Statistics Canada postsecondary surveys/data: https://www.statcan.gc.ca/en/survey/business/5017
- EduCanada programme search: https://www.educanada.ca/programs-programmes/index.aspx?lang=eng

These may be useful for aggregate/structured enrichment or source qualification, but neither is currently accepted as the national Layer 1 canonical Course authority.

### Scholarships

Resources:
- EduCanada scholarship search: https://www.educanada.ca/scholarships-bourses/searchAll-rechercheTous.aspx?lang=eng
- International scholarships: https://www.educanada.ca/scholarships-bourses/index.aspx?lang=eng

**Decision:** Stop further CA institution-by-institution ETL. Preserve current work for lineage. Resume only if a source strategy materially reduces adapter fragmentation and passes the source gate.

---

## Germany — PAUSE

### National study portal

Resources:
- Hochschulkompass study search: https://www.hochschulkompass.de/studium.html
- Hochschulkompass downloads: https://www.hochschulkompass.de/hochschulen/downloads.html

Hochschulkompass is a strong national source maintained from university-entered data. The source-qualification review has not yet established an acceptable complete machine interface and product-use/redistribution contract for full CourseFinder programme ingestion.

### DAAD international programmes

Resource:
- DAAD International Programmes: https://www2.daad.de/deutschland/studienangebote/international-programmes/en/result/

This is an international-programmes subset and therefore cannot silently stand in for a full national canonical Course authority.

### Scholarships

Resource:
- DAAD Scholarship Database: https://www2.daad.de/deutschland/stipendium/datenbank/en/21148-scholarship-database/

The DAAD Scholarship Database includes DAAD programmes and selected funding organisations and is a strong Layer 2 scholarship source candidate.

**Decision:** Layer 1 remains paused until machine access/licensing and completeness are proven. Scholarship enrichment can be evaluated separately.

---

## Ireland — HOLD / SOURCE QUALIFICATION

### Layer 1 authority candidate

Resource:
- QQI Irish Register of Qualifications: https://www.qqi.ie/what-we-do/the-qualifications-system/irish-register-of-qualifications

The Irish Register of Qualifications is a national database of NFQ qualifications and programmes that lead to them, including provider/awarding-body information. It is conceptually close to the required canonical authority.

Outstanding gate:
- prove a supported deterministic bulk/API machine interface;
- prove stable non-name Provider and Programme/Qualification keys through that interface;
- prove complete target population/currentness and product-use terms.

Do not start an IE production adapter until those items pass.

### Scholarships

Resource:
- Government of Ireland International Education Scholarships: https://hea.ie/policy/internationalisation/goi-ies/

This is a high-quality government scholarship programme source but not a complete national provider-scholarship catalogue.

**Decision:** Ireland is the best candidate for a future *source qualification* exercise, not a country ETL implementation exercise.

---

## Milestone 1 source strategy

For Milestone 1, the defensible platform story is:

1. **Layer 1 proven at national scale:** Australia CRICOS + New Zealand NZQA.
2. **Layer 2A structured enrichment:** Australia QILT + PRISMS first; New Zealand Education Counts second.
3. **Scholarship relational enrichment:** Australia official/provider sources first; then NZ and other qualified official sources.
4. **Other countries:** remain source-qualified backlog. No implementation starts until the source gate passes.
5. **Canada:** preserve the substantial canonical/history work already completed, but do not spend further delivery time on institution-by-institution ETL under Milestone 1.

This deliberately prioritises a high-quality, explainable canonical platform over nominal country count.
