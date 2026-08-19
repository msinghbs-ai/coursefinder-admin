# CourseFinder AU Layer 1 Regulatory Completeness Design v1.0

**Status:** AUTHORITATIVE DESIGN  
**Date:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.33.md`

## 1. Purpose

Define how AU CRICOS completeness is measured and governed after the primary Layer 1 adapter was corrected to ingest all accepted structured CRICOS Course facts.

The design prevents three different ideas from being collapsed into one score:
- source representation correctness;
- regulatory attribute coverage;
- consumer/publication readiness.

## 2. Design principles

1. Completeness must never reward fabricated data.
2. A source-null value is different from an adapter/mapping defect.
3. A populated but ambiguous regulatory value must remain evidence/review, not be guessed into a canonical field.
4. Regulatory total-course fees must never be treated as annual/current Provider fees.
5. Regulatory completeness must not bypass Search enrichment gates.
6. Canonical identity must remain stable while mappings and relational observations improve.

## 3. Regulatory coverage profile

The current diagnostic profile uses 13 equally weighted dimensions:

| Dimension | Current coverage | Classification |
|---|---:|---|
| CRICOS registration | 26,648 / 26,648 | canonical identity |
| Course title | 26,648 / 26,648 | canonical core |
| Study level | 24,367 / 26,648 | canonical mapping gap |
| Duration | 26,648 / 26,648 | canonical core |
| Primary Field of Education | 26,648 / 26,648 | canonical relationship |
| Campus relationship | 26,614 / 26,648 | relational mapping/source gap to classify |
| Dual Qualification | 26,648 / 26,648 | regulatory observation |
| Foundation Studies | 26,648 / 26,648 | regulatory observation |
| Work Component | 26,648 / 26,648 | regulatory observation |
| Course Language | 26,648 / 26,648 | regulatory observation |
| Tuition Fee | 26,457 / 26,648 | source coverage gap for 191 Courses |
| Non Tuition Fee | 26,457 / 26,648 | source coverage gap for 191 Courses |
| Estimated Total Course Cost | 26,648 / 26,648 | regulatory fee observation |

Current coverage result:
- average: 99.22%;
- 24,239 Courses at 100%;
- 26,448 Courses at or above 90%;
- 200 Courses below 90%.

## 4. Score interpretation

### 4.1 Representation quality

This is a gate metric rather than a consumer score.

For each accepted source field/relationship, classify missing canonical data as one of:
- `source_absent` — authority supplied no value/relationship;
- `mapped` — represented canonically/relationally;
- `review_required` — source populated but semantics are ambiguous;
- `adapter_defect` — deterministic source value/relationship exists but ingestion failed to represent it;
- `explicitly_excluded` — governed decision not to canonicalise the field.

The target is **zero unclassified adapter defects**, not artificial 100% attribute coverage.

### 4.2 Regulatory attribute coverage

The 99.22% diagnostic answers: “How many desired regulatory dimensions currently have usable data?”

It may remain below 100% because the source itself is incomplete.

### 4.3 Publication readiness

A future publication completeness profile must be separately defined and may include:
- official Course URL;
- current/year-specific international fee;
- intake/application timing;
- English entry requirement;
- publication status;
- freshness/verification;
- other Search/API-approved dimensions.

It must not use CRICOS registered total-course fees as a substitute for current Provider fee readiness.

## 5. Residual Layer 1 remediation

### 5.1 Study level

Current gap: 2,281 / 26,648 Courses have no `study_level_id`.

Remediation procedure:
1. inventory every distinct populated CRICOS `Course Level` value and its count;
2. compare against existing `ref.study_levels` vocabulary;
3. map only exact or explicitly approved semantic equivalents;
4. add new reference levels only where the CRICOS meaning is stable and useful across canonical Course modelling;
5. retain raw source value and evidence;
6. send ambiguous values to review;
7. never infer level from Course title when CRICOS supplies a populated Course Level field.

Acceptance target: every populated raw Course Level is either mapped or explicitly review-classified; no silent unmapped values remain.

### 5.2 Campus relationship

Current gap: 34 / 26,648 Courses have no canonical campus relationship.

Remediation procedure:
1. compare CRICOS Course Locations rows against current canonical Course/Campus links;
2. determine whether each gap is source absence, Provider/Location resolution failure, or adapter defect;
3. repair deterministic identity mapping where possible;
4. retain source absence as an explained gap;
5. do not create synthetic campuses.

Acceptance target: all 34 current gaps have an explicit classified reason; deterministic adapter defects are corrected.

### 5.3 Fee blanks

Current CRICOS source contains 191 Courses without Tuition Fee and 191 without Non Tuition Fee.

These remain source coverage gaps unless a later source audit proves a parsing defect.

Rules:
- no annualisation;
- no inference from Estimated Total Course Cost;
- no copying between fee types;
- zero values supplied by CRICOS remain valid observations;
- blank values create no fee observation.

## 6. Operational ingestion contract

Primary operational worker: `layer1-au-depth-v1.5.1`.

The parent worker owns core identity, Course mapping and geography and invokes the regulatory-facts phase internally under the same Layer 1 source/evidence/hash contract.

Maximum accepted batch: 500 active Courses.

Future CRICOS refresh operations must not run the facts worker as a separately scheduled data pipeline.

Search refresh is not part of each Layer 1 batch.

## 7. UAT requirements for completeness remediation

Required tests:
- full distinct Course Level inventory;
- deterministic mapping matrix UAT;
- dry-run across all 26,648 active Courses;
- APPLY;
- same-snapshot replay/idempotency;
- beginning/middle/end bounded runtime batches;
- canonical identity unchanged;
- no duplicate Course/registration/fact/fee rows;
- campus-gap reconciliation report covering all 34 current gaps;
- source-null fee counts unchanged unless source snapshot changes;
- Search documents and enrichment gates unchanged.

## 8. Admin/PIM presentation

Admin should eventually expose two separate indicators:
- **Regulatory completeness / source representation** — source-backed Layer 1 status and gap reason;
- **Publication readiness** — consumer-facing readiness under an approved publication profile.

A single unlabeled “completeness” percentage should not be used for both meanings.

Useful Admin gap reasons should include `source_absent`, `review_required`, `adapter_defect`, `explicitly_excluded` and `not_yet_enriched`.

## 9. Gate sequencing

Serial data lane:

`M1-L1-AU-CRICOS-COMPLETENESS -> M1-L2-AU-COURSE-FACTS -> SEARCH-ENRICHMENT-READINESS -> PUBLICATION-UAT`

Parallel lanes remain:
- `M1-PIM-HARDENING`;
- `M1-SEARCH-VECTOR`.

## 10. Decision

This design is accepted as the governing completeness model for the current AU CRICOS substrate.
