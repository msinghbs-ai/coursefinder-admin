# CourseFinder Database Architecture v2.10.33

**Status:** AUTHORITATIVE  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.32.md`

## 1. Version scope

v2.10.33 preserves all accepted identity, evidence, regulatory observation, QILT, PRISMS, Scholarship and Search contracts from v2.10.32.

This version formalises the AU Layer 1 completeness model after the CRICOS adapter consolidation and changes the next serial data gate so residual Layer 1 canonical mapping defects are resolved before Provider-owned Layer 2 enrichment begins.

Accepted AU identity remains exactly:
- Providers: 1,546;
- active Courses: 26,648.

Primary AU CRICOS operational entrypoint remains `layer1-au-depth-v1.5.1` with an internal bounded CRICOS regulatory-facts phase.

## 2. Completeness model

CourseFinder now distinguishes three different concepts that must not be conflated.

### 2.1 Source representation completeness

Measures whether accepted, populated fields from an authoritative source have been represented correctly in canonical or relational Layer 1 structures with evidence and source semantics preserved.

A source-null value is not an adapter failure. A populated value that cannot be safely mapped into the accepted canonical model is a mapping gap and must be retained in evidence/review rather than guessed.

### 2.2 Regulatory attribute coverage

Measures how many desired regulatory dimensions are present for a Course, regardless of whether a missing value was absent in the authority or is still unmapped.

The current AU analysis-only 13-dimension CRICOS coverage profile is:
1. CRICOS registration;
2. Course title;
3. study level;
4. duration;
5. primary field;
6. campus relationship;
7. Dual Qualification;
8. Foundation Studies;
9. Work Component;
10. Course Language;
11. registered Tuition Fee;
12. registered Non Tuition Fee;
13. Estimated Total Course Cost.

Current average coverage is **99.22%**.

This score is a regulatory data-coverage diagnostic only.

### 2.3 Publication/Search completeness

Measures consumer readiness, freshness and admission into governed publication/search contracts.

It may include current Provider-owned Course URL, current/year-specific fee, intake, English requirement, publication status, freshness and other approved consumer dimensions.

It must not automatically increase because a CRICOS regulatory observation exists.

AU currently has no Course `publishing.entity_states` population supplying a formal publication completeness score, and CRICOS registered total-course fees remain blocked from consumer fee Search admission.

## 3. Current AU Layer 1 completeness state

Current regulatory coverage:
- CRICOS registration: 26,648 / 26,648;
- title: 26,648 / 26,648;
- study level mapped: 24,367 / 26,648;
- duration: 26,648 / 26,648;
- primary field: 26,648 / 26,648;
- campus relationship: 26,614 / 26,648;
- Dual Qualification: 26,648 / 26,648;
- Foundation Studies: 26,648 / 26,648;
- Work Component: 26,648 / 26,648;
- Course Language: 26,648 / 26,648;
- Tuition Fee: 26,457 / 26,648;
- Non Tuition Fee: 26,457 / 26,648;
- Estimated Total Course Cost: 26,648 / 26,648.

Distribution:
- 24,239 Courses at 100%;
- 26,448 Courses at or above 90%;
- 200 Courses below 90%;
- average 99.22%.

## 4. Defect versus source-gap classification

The following are Layer 1 remediation targets because the authoritative source supplies a value or relationship that should be canonically represented:
- **2,281 Courses without mapped `study_level_id`**;
- **34 Courses without a canonical campus relationship**.

The following are source coverage gaps, not adapter defects, unless future source audit proves otherwise:
- 191 Courses without Tuition Fee in the current CRICOS source;
- 191 Courses without Non Tuition Fee in the current CRICOS source.

No fee value may be inferred, copied from Estimated Total Course Cost, annualised or manufactured to improve a completeness score.

## 5. Layer 1 study-level remediation contract

The next serial AU gate is `M1-L1-AU-CRICOS-COMPLETENESS`.

Required study-level work:
- inventory all distinct current CRICOS `Course Level` source values;
- reconcile populated raw values against `ref.study_levels` using explicit deterministic mappings only;
- add missing legitimate reference level codes only when the regulatory meaning is stable and documented;
- preserve the exact CRICOS source vocabulary in evidence;
- do not use title-based level inference where the CRICOS Course Level field is populated;
- route semantically ambiguous values to review rather than force a mapping;
- replay the complete accepted 26,648-Course CRICOS snapshot and prove stable Course identity.

A canonical mapping fix must not change CRICOS Course identity, Course registration code or Provider identity.

## 6. Layer 1 campus remediation contract

The same gate must investigate the 34 Courses without canonical campus relationship.

Required decisions:
- determine whether the source has no Course Location row, contains a Location that failed canonical resolution, or represents another source condition;
- fix deterministic Provider/Location/Course-Location adapter mappings where the source supplies sufficient identity;
- preserve evidence for legitimate source absence;
- do not manufacture a campus solely to increase completeness.

## 7. Gate completion criteria

`M1-L1-AU-CRICOS-COMPLETENESS` passes only when:
- every populated CRICOS Course Level value is mapped or explicitly review-classified with evidence;
- every currently missing campus relationship is explained as corrected mapping or genuine source absence;
- full dry-run/APPLY/replay/idempotency UAT passes;
- AU identity remains 1,546 Providers / 26,648 active Courses;
- CRICOS regulatory facts and 79,562 registered-total-course fee observations remain semantically intact;
- Search remains unchanged unless a separate Search gate is explicitly approved;
- regulatory completeness is recalculated with defect/source-gap attribution.

The gate is not required to force regulatory attribute coverage to 100% where the authority itself leaves accepted fields blank.

## 8. Layer boundary after remediation

Only after the residual Layer 1 mapping gate passes does the primary serial lane proceed to `M1-L2-AU-COURSE-FACTS`.

Layer 2 is limited to Provider-owned facts not authoritatively supplied by CRICOS at the required grain/freshness, including:
- official Course URL;
- current/year-specific international fee schedules;
- authoritative intakes/application timing;
- English entry requirements.

Layer 2 must not re-ingest or redefine accepted CRICOS facts.

## 9. Search boundary

Search remains a governed derived projection.

Current Search state remains:
- 33,105 Course Documents;
- `has_fee=true`: 0;
- `courses/course_fee` gate: `blocked`.

Neither Layer 1 regulatory completeness nor a CRICOS registered total-course fee automatically authorises consumer Search exposure.

## 10. Decision

**v2.10.33 accepted.**

The AU CRICOS adapter consolidation remains accepted. The programme now explicitly closes residual Layer 1 study-level and campus mapping gaps before beginning Provider-owned Layer 2 Course facts.
