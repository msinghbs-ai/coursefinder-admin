# Milestone 2 Execution Addendum A12 — Contextual Insight Integration

**Status:** AUTHORITATIVE EXECUTION ADDENDUM  
**Effective:** 27 August 2026  
**Applies to:** M2.4.2 and every later M2.x / M2.x.y workstream unless a newer accepted governance decision explicitly supersedes a clause.

This addendum extends, and does not replace, `PROJECT_INSTRUCTIONS.md`, `STANDING-INSTRUCTIONS.md` and prior Milestone 2 execution addenda.

## A12 — Contextual Insight Integration

Outcome/benchmark data, international student-flow data and Scholarships are useful to operators only when their relationship to a Provider or Course is visible in the catalogue decision context.

### Standing rule

Country-specific insight datasets must not remain useful only as isolated admin tables.

Examples include:
- Australia: QILT Provider outcomes and PRISMS student-flow observations;
- other countries: the accepted country-equivalent graduate outcomes, student-flow/enrolment, regulatory statistics or benchmark datasets where available;
- Scholarships and scholarship eligibility/scope data.

The platform must expose applicable insight data on the **Provider detail blade** and/or **Course detail blade** according to the authority and granularity of the underlying source.

Standalone QILT/PRISMS/country-equivalent and Scholarships workspaces may remain for ingestion, QA, filtering, source inspection and bulk analysis, but they are not considered a complete operator UX by themselves.

## Provider detail blade contract

Where supported by governed data, Provider detail must expose:

- relevant outcome/benchmark metrics with period/year, audience/study level/study area where applicable;
- national/sector benchmark or comparison value where the source provides one;
- international student-flow/enrolment statistics where the observation can be safely related to that Provider;
- current Scholarships offered by or scoped to that Provider;
- source family / country counterpart label;
- observation period, freshness/status and Evidence/provenance link;
- explicit `not available`, `not mapped`, `suppressed`, `not applicable` and source-limited states rather than fabricated values.

## Course detail blade contract

Course detail should expose only insights whose granularity can be defensibly related to the Course.

Permitted relationships include:
- direct Course-linked observations;
- Provider outcomes narrowed by compatible study level / field / source study-area mapping, clearly labelled as **Provider-level contextual data**, not Course-specific truth;
- student-flow observations directly linked to the Course, or a governed compatible study-area/level aggregation labelled with its actual granularity;
- Scholarships directly scoped to the Course;
- Provider-wide Scholarships that are applicable to all/eligible Courses, clearly labelled as Provider-wide rather than Course-specific.

Do not imply a Course-level metric when the source is only Provider-, state-, sector- or study-area-level.

## Country counterpart rule

The UI must use generic semantic groups such as:

- **Student outcomes / benchmarks**
- **International student flow**
- **Scholarships / funding**

Country-specific source names such as QILT or PRISMS may appear as source labels, but the data model and blade UX must allow equivalent source families for AU/NZ/CA/GB/US/IE/DE and future countries without creating country-specific blade architecture.

If a country has no accepted counterpart, display that no governed source is currently available; do not manufacture comparability.

## Scholarship relationship rule

Scholarships must be linked through governed scope/eligibility relationships.

Priority order:
1. direct Course scope;
2. Course collection / field / study-level / campus scope where deterministically compatible;
3. Provider-wide scope;
4. country/general scope only when the scholarship rules actually permit it.

Exclusion scopes override broad inclusion. A scholarship must not be shown as Course-applicable merely because its Provider matches.

## Authority and provenance

Contextual display is a derived read projection only.

It must not:
- redefine Layer 1 Provider/Course identity;
- convert statistical correlation into canonical Course facts;
- authorise Search or Publication mutation;
- flatten suppressed/null/zero values;
- hide the source period, source family or data granularity.

Every displayed insight must remain traceable to the governed source/Evidence where Evidence exists.

## UX and performance

- Detail blades should default to concise summaries and progressive disclosure.
- Avoid loading full standalone datasets into every drawer.
- Read projections must be bounded and indexed/filtered by entity.
- Large related lists inherit A10 paging/search rules.
- The blade should show a small relevant summary first, with links to the full insight/Scholarship workspace when deeper analysis is required.
- Mobile/tablet detail views must remain usable without horizontal dependency on wide raw-data tables.

## Acceptance impact

A milestone that ingests QILT/PRISMS/country-equivalent or Scholarship data is not operator-complete unless:
1. the relationship to Provider/Course entities is modelled or explicitly classified as unavailable;
2. relevant contextual data is visible from the Provider/Course decision journey;
3. granularity is honestly labelled;
4. provenance/freshness is preserved;
5. targeted browser/API/security UAT covers the contextual projection.

