# CourseFinder Database Architecture v2.10.24

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.23.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 18 August 2026  
**Milestone:** Milestone 1 — canonical data platform

v2.10.24 retains the source-qualified country and canonical identity rules from v2.10.23 and records the accepted **Australia QILT Layer 2A production contract** after autonomous dry-run/APPLY/idempotency/integrity/security/performance UAT.

## 1. QILT authority boundary

Australia CRICOS remains the canonical Layer 1 identity substrate.

QILT is accepted only as **Layer 2A structured outcomes evidence**. It has zero authority to:
- create a Provider;
- merge or re-key a Provider;
- create or redefine a Course;
- change Provider/Course stable keys, canonical names, course codes or titles;
- enter Search by itself.

The accepted flow is:

`Official QILT workbook -> immutable evidence -> source institution key -> verified mapping to existing CRICOS Provider -> versioned provider_outcomes observation`

Only a unique mapping to an already-existing AU CRICOS Provider may be marked `verified`. Unmatched or ambiguous publisher labels remain unresolved and produce no observation rows.

## 2. Accepted QILT source contracts

| Survey | Accepted source version | Published institution grain used | CourseFinder metrics |
|---|---:|---|---|
| GOS | 2025 | institution + QILT course-level cohort | full-time employment, overall employment, labour-force participation, median full-time salary |
| SES | 2024 | institution + QILT course-level cohort | skills development, peer engagement, teaching quality/engagement, student support/services, learning resources, overall educational experience |
| GOS-L | 2025 | institution + QILT course-level cohort | medium-term full-time employment, medium-term overall employment, medium-term median salary |
| ESS | 2025 | institution, pooled 2023–2025 university result | foundation, adaptive, collaborative, technical and employability skills, overall satisfaction |

The worker fetches the official QILT ZIPs, extracts the published XLSX workbook, validates required sheets, hashes both ZIP and workbook, and retains the workbook in private Evidence Storage.

The **workbook SHA-256** is the stable evidence content hash. A changed ZIP container does not imply changed observations if the extracted workbook is byte-identical.

## 3. Observation grain

`catalogue.provider_outcomes` is the canonical Layer 2A observation table for QILT.

Important semantic rule established by this gate:
- QILT `UG`, `PGC`, `PGR` and `ALL` are **source cohort codes**, not CourseFinder canonical `study_level_id` values.
- They are stored in `source_cohort_code`.
- `study_level_id` remains null unless a future governed mapping genuinely supports the canonical dimension.
- `audience` remains the existing population dimension (`all`, `domestic`, `international`, `mixed`, `unknown`) and must not be overloaded with QILT course-level cohort semantics.

Unique observation identity is:

`Provider + Survey + Metric + external study area + canonical study level + audience + source_cohort_code + collection period + source`

This preserves distinct UG/PGC/PGR observations without pretending that those publisher cohorts are canonical Course identities.

## 4. Mapping contract

`pipeline.source_provider_mappings` is the governed crosswalk between the QILT publisher label and an existing CRICOS Provider.

The runtime may generate conservative aliases **from the existing CRICOS record**, including removal of legal suffixes, parenthetical aliases and registered trading-name fragments. The QILT label itself never creates identity.

Rules:
1. exact unique existing CRICOS label -> verified;
2. unique result after conservative CRICOS-derived normalisation -> verified;
3. zero results -> unmatched;
4. more than one existing CRICOS Provider -> ambiguous/unmatched;
5. unmatched/ambiguous rows do not enter `provider_outcomes`.

Examples deliberately withheld at the production gate include:
- `University of New South Wales` because the accepted substrate label is `UNSW Sydney` and no governed alias was inferred from the current CRICOS record;
- `Victoria University` because two active CRICOS Provider records share that label.

These remain Layer 4 review candidates rather than name-based automatic merges.

## 5. Evidence and version lineage

Every accepted observation retains:
- `source_id` referencing a `structured_outcomes` QILT source with trust rank 95;
- `evidence_id` referencing an immutable private workbook artifact;
- collection version/year;
- source institution key;
- source metric code;
- source cohort code;
- source sheet and row;
- raw published cell text;
- confidence interval where published;
- worker version;
- `identity_authority:false` metadata.

Evidence storage path convention:

`layer2a/AU/qilt/<survey>/<collection-version>/<workbook-sha256>.xlsx`

## 6. Runtime/security contract

Pilot worker: `qilt-au-etl` v0.2.4.

Write boundary:
- Edge runtime uses server-side `service_role` only;
- public direct invocation requires a valid one-time Pilot nonce;
- missing/invalid nonce returns 401;
- all QILT service RPCs are revoked from `anon` and `authenticated` and executable only by `service_role`;
- APPLY validates that every target Provider is an existing AU Provider and every observation has a verified source mapping.

Read boundary:
- internal outcome/mapping/evidence tables remain deny-by-default;
- authenticated UI/API reads use `public.ui_provider_outcomes(provider_id, limit)`;
- unauthenticated calls return no rows;
- evidence remains private Storage.

## 7. Accepted production population

First production APPLY created **2,033 QILT observations**:

| Survey | Observations | Canonical Providers represented | Source cohorts |
|---|---:|---:|---:|
| GOS | 593 | 72 | 3 |
| SES | 977 | 103 | 2 |
| GOS-L | 235 | 40 | 2 |
| ESS | 228 | 38 | 1 |
| **Total** | **2,033** | — | — |

Mapping coverage at dry-run:
- GOS: 100 / 136 institution labels uniquely mapped;
- SES: 112 / 149;
- GOS-L: 41 / 43;
- ESS: 40 / 42.

Coverage is intentionally conservative. Unmatched labels are not a gate failure where the source cannot be safely crosswalked to a unique existing CRICOS Provider.

## 8. Production gate invariants

The accepted gate proves:
- second identical APPLY changed 0 rows for all four surveys;
- duplicate observation identity keys: 0;
- orphan Providers: 0;
- orphan metrics: 0;
- orphan sources: 0;
- orphan evidence: 0;
- observations without a verified Provider mapping: 0;
- observations with canonical `study_level_id` assigned by this worker: 0;
- observations using a non-`all` audience by this worker: 0;
- AU Providers modified by QILT: 0;
- AU Courses modified by QILT: 0;
- Search Documents modified by QILT: 0.

The accepted AU Layer 1 substrate therefore remains **1,546 Providers / 26,648 Courses** and the accepted Search Projection remains **33,105 AU+NZ documents**.

Authenticated provider-outcome projection UAT executed in approximately **7.8 ms** for a representative 36-row provider result.

## 9. Search/publication implication

QILT enrichment is now canonical Layer 2A data but is **not automatically part of Search**.

A separate Search/API projection change must explicitly choose which metrics/cohorts are safe and useful for consumer ranking/filtering/display. Search remains a derived acceptance boundary.

## 10. Governance decision

**M1-L2-AU-QILT is PASS.**

QILT is the first accepted AU independent structured-outcomes source layered over CRICOS without contaminating Layer 1 identity. The same pattern should be reused for PRISMS, Education Counts and other structured outcome datasets: source facts are valuable observations; canonical identity remains owned by the accepted Layer 1 authority.
