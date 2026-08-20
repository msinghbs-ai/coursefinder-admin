# CourseFinder PIM Admin Guide v1.0

**Status:** LIVING GOVERNANCE GUIDE  
**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-001`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Admin/PIM design:** `docs/coursefinder-admin-pim-design-decisions-v1.10.md`  
**Running build at initiation:** `docs/coursefinder-running-build-v2.42.md`

## 1. Purpose

This guide explains what CourseFinder Admin fields mean, where they come from, how an administrator should validate them, and what may safely be exposed to downstream consumers such as Zoho.

It is a semantic guide, not a replacement for the database architecture. The canonical model must not be redesigned merely to simplify a screen or external integration.

The governing chain is:

**authoritative source -> evidence -> canonical/relational storage -> governed Admin read -> Admin presentation -> change history -> curated consumer contract**

## 2. Non-negotiable Admin rules

1. Never identify a Provider or Course by display name/title when a governed stable identifier is available.
2. For Australian regulated Courses, reconcile by exact CRICOS Course Code and Provider CRICOS identity.
3. `NULL`, numeric zero, source-suppressed, not-applicable and not-yet-enriched are different states.
4. `last_verified_at` means the observation was rechecked; it is not human approval.
5. Completeness means required information presence under a defined profile or display rule; it is not truth and does not grant publication.
6. Search status is a downstream projection state, not a canonical data-presence test.
7. One-to-many facts remain one-to-many. Do not flatten fees, intakes, campuses, English tests, scholarships, outcomes or evidence into a misleading single value.
8. Regulatory values and Provider-current values are separate semantic classes even when the numbers happen to match.
9. Source vocabulary and evidence must remain recoverable after normalisation.
10. Automated suggestions must be evidence-backed, reviewable and fail closed when identity or semantics are ambiguous.

## 3. Semantic classifications

| Classification | Meaning | Typical examples |
|---|---|---|
| Regulatory | Fact published by a regulator/national authority at regulatory grain | CRICOS registration, registered total-course fees, Course Level |
| Provider-current | Current/year-specific fact published by the Provider | 2027 indicative annual tuition, current intake, current English threshold |
| Relational observation | Repeatable/time-scoped fact linked to a canonical entity | fees, intakes, English requirements, campuses, outcomes |
| Derived | Calculated from governed facts with an explicit rule | Admin operational presence score |
| Display-only | UI formatting or label with no canonical authority | `AUD 132,900`, human-friendly basis labels |
| Consumer-curated | Stable external contract derived from canonical data | Zoho Course Fee observation object |
| Source-only evidence | Original material retained for audit but not promoted as canonical truth | snapshot file/hash/raw vocabulary |

## 4. Null and state semantics

| Stored/displayed state | Meaning | Admin behaviour |
|---|---|---|
| `NULL` | Source did not supply the value, value is not applicable, or the observation is not scoped that way; interpretation depends on field contract | Show an explicit semantic label such as `Not supplied by source` when important; never coerce to zero |
| `0` | Source supplied a numeric zero | Display `0`; never show as missing |
| empty relationship | No accepted observation exists | Show an explicit empty state; do not substitute another semantic class |
| suppressed | Authority deliberately withheld value | Preserve suppression state if supported; do not expose as zero |
| stale | Existing observation exceeded governed freshness expectation | Keep value/evidence visible and flag for review; do not silently delete |
| unpublished | Canonical record exists but is not admitted to publication | Do not equate with incomplete or invalid |

## 5. Core entity guide

### 5.1 Provider

**Business meaning:** canonical institution/provider identity.

**Primary storage:** `catalogue.providers` with governed identifiers/registrations in related catalogue tables.

**Authority:** country-specific Layer 1 authority. For AU, CRICOS identity is authoritative for the accepted substrate.

**Identity rule:** stable Provider key/official regulatory code before name.

**Common traps:**

- Provider State is not the same as Course Campus State.
- Provider display name changes must not create a new Provider.
- Provider-current website content does not redefine the Layer 1 Provider identity.

**Admin validation:** compare stable identifier, official name, lifecycle, source/evidence and related campuses/courses to the governing source.

### 5.2 Course

**Business meaning:** canonical Course identity owned by a Provider.

**Primary storage:** `catalogue.courses`; registration facts in `catalogue.course_registrations`; repeatable facts in related tables.

**AU identity rule:** exact CRICOS Course Code under the correct Provider. Title-only matching is forbidden.

**Common traps:**

- identical/similar titles can represent different Courses and Providers;
- Provider-current webpages enrich a Course but do not redefine its CRICOS identity;
- lifecycle/publication state is independent of whether a downstream Search document exists.

### 5.3 Campus

**Business meaning:** canonical delivery location associated with a Provider and, through relationships, one or more Courses.

**Primary storage:** `catalogue.campuses`, `catalogue.course_campuses`.

**Cardinality:** Provider 1:N Campus; Course M:N Campus where source supports it.

**Common traps:**

- do not infer a synthetic Campus solely to improve completeness;
- Provider geography must not be substituted for Course delivery geography;
- `campus_id = NULL` on a repeatable observation means no accepted campus scope is recorded for that observation; it does not automatically mean every campus.

## 6. Course Fees — reference semantic contract

### 6.1 Canonical storage

**Table:** `catalogue.course_fees`

Important fields:

| Field | Meaning |
|---|---|
| `course_id` | stable canonical Course relationship |
| `fee_type` | semantic type of amount |
| `amount` | source-preserved numeric amount |
| `currency_code` | currency of the amount |
| `fee_year` | source-published fee year; `NULL` where source supplies no year |
| `audience` | intended audience, e.g. `international` |
| `basis` | semantic charging/measurement basis |
| `load_basis` | source-supported study-load basis when applicable |
| `campus_id` | optional campus scope; `NULL` is not permission to infer a campus |
| `valid_from`, `valid_to` | observation validity window |
| `source_id` | governed source relationship |
| `evidence_id` | evidence artifact relationship |
| `source_fee_key` | source-scoped stable observation key |
| `source_snapshot_at` | source snapshot represented by the observation |
| `last_verified_at` | latest governed re-verification time; not approval |
| `status` | observation lifecycle/status |

### 6.2 CRICOS registered total-course fees

CRICOS fee observations use `basis = registered_total_course` and remain regulatory facts.

Governed fee types:

| `fee_type` | Admin label | Meaning |
|---|---|---|
| `tuition` | Tuition Fee | CRICOS registered tuition component for the whole registered Course |
| `non_tuition` | Non-Tuition Fee | CRICOS registered non-tuition component for the whole registered Course |
| `estimated_total_course_cost` | Estimated Total Course Cost | CRICOS estimated total registered Course cost |

Rules:

- never annualise these amounts;
- never relabel them as a Provider-current annual fee;
- `fee_year = NULL` is valid when CRICOS supplies no fee year;
- `amount = 0` is a real supplied value and must remain visible;
- retain all three concepts independently even where tuition and total cost are numerically equal.

### 6.3 Provider-current fees

Provider-current observations are a separate class. Current accepted AU Course Facts use `fee_type = provider_current_tuition` and preserve the Provider-published year and basis such as `annual`, `indicative_annual` or `total_indicative`.

Rules:

- Provider-current fees must never overwrite or masquerade as CRICOS registered total-course fees;
- if no Provider-current fee exists, show `No current Provider fee evidence loaded` rather than substituting CRICOS;
- campus/intake/load scope must be retained where the Provider source publishes it;
- year/basis must be source-preserved rather than normalised to an invented annual amount.

### 6.4 Admin fee grouping

The governed Course-detail read contract groups active fee observations into:

1. `cricos_registered` — `basis = registered_total_course`;
2. `provider_current` — governed `fee_type` beginning `provider_current_`;
3. `other` — active non-CRICOS/non-provider-current fee semantics that must not be silently mislabeled.

The `other` group is exception-first: if populated, Admin should surface **Needs semantic review** until the fee type is governed.

## 7. Reference audit — CRICOS 121174E

**Provider:** Swinburne University of Technology  
**Course:** Bachelor of Artificial Intelligence  
**CRICOS Course Code:** `121174E`  
**Identity used for reconciliation:** exact CRICOS Course Code under Provider stable key `provider:cricos:00111d`.

Do not reconcile this record using the title `Bachelor of Artificial Intelligence`.

### 7.1 Authoritative facts

| CRICOS concept | Source value | Canonical representation |
|---|---:|---|
| Tuition Fee | AUD 132,900 | `fee_type=tuition`, `basis=registered_total_course` |
| Non Tuition Fee | AUD 0 | `fee_type=non_tuition`, `basis=registered_total_course` |
| Estimated Total Course Cost | AUD 132,900 | `fee_type=estimated_total_course_cost`, `basis=registered_total_course` |
| Audience | International | `audience=international` |
| Fee year | Not supplied | `fee_year=NULL` |
| Course Level | Bachelor Degree | governed Study Level mapping; original source vocabulary retained through source/evidence mapping |
| Duration | 156 weeks | canonical Course duration |

### 7.2 Live canonical result validated 20 August 2026

Exact Course ID: `1b8be4ac-01c0-4b11-888f-083401acd784`.

The live Pilot stores three active `catalogue.course_fees` rows with amounts `132900.00`, `0.00`, `132900.00`, currency `AUD`, audience `international`, basis `registered_total_course`, `fee_year=NULL`, and preserved source/evidence/snapshot/verification metadata.

The governed `public.admin_read('course_detail', ...)` response now returns those three observations in `fee_summary.cricos_registered`, returns an empty `provider_current` list, and returns an empty `other` list.

### 7.3 Required Admin presentation

Preferred visible presentation:

**CRICOS Registered Fees**

| Type | Amount | Basis | Audience | Year |
|---|---:|---|---|---|
| Tuition Fee | AUD 132,900 | Registered total course | International | Not supplied by source |
| Non-Tuition Fee | AUD 0 | Registered total course | International | Not supplied by source |
| Estimated Total Course Cost | AUD 132,900 | Registered total course | International | Not supplied by source |

Secondary drill-down should expose:

- source label;
- evidence artifact;
- source snapshot time;
- last verified time;
- validity window;
- campus scope when present;
- source observation key for audit/engineering roles.

## 8. Course grid fee semantics

The Course decision grid must not choose an arbitrary/latest fee observation.

For the existing `fee_amount` compatibility column the governed meaning is now:

**active `fee_type = tuition` + `basis = registered_total_course`**

The UI label must make that meaning clear, e.g. **CRICOS tuition (total course)**.

Provider-current fees belong in their own column/filter/detail surface if admitted later.

Zero-safe display rule: test for `NULL`/undefined explicitly; do not use truthiness to decide whether a numeric fee exists.

## 9. Intakes

**Primary storage:** `catalogue.course_intakes`.

**Grain:** repeatable Course observation, optionally campus-scoped, with year/label/start date/deadline and source/evidence.

**Classification:** Provider-current Layer 2 unless another authority is explicitly governed.

**Common traps:**

- do not collapse multiple intakes to one date;
- do not infer campus scope when `campus_id` is null;
- an accepted Intake in canonical storage does not mean Search has admitted it.

## 10. English entry requirements

**Primary storage:** `catalogue.course_english_requirements` with `ref.english_tests`.

**Grain:** Course + governed test identity + score/component requirement + source/evidence, with validity where supplied.

**Common traps:**

- never coerce an unsupported alternative test/scheme into a known test identity;
- keep component thresholds separate from overall score;
- Provider-current requirements do not redefine Course identity.

## 11. Study Level

**Primary canonical taxonomy:** `ref.study_levels`.

**Source mapping/evidence:** governed source mappings and Course study-level observations.

For CRICOS, populated Course Level vocabulary is authoritative for Layer 1 mapping. Do not infer a level from Course title when CRICOS supplies a populated level.

Admin should expose both the canonical level and the source vocabulary/evidence path when auditing mappings.

## 12. Field of Study

**Primary taxonomy:** `ref.fields_of_study`.

**Observation:** `catalogue.course_field_observations` where source mappings/observations are retained.

Do not treat a display category or external marketing study area as automatically identical to the canonical taxonomy. Mapping authority and confidence must be governed.

## 13. Scholarships

**Primary model:** relational `scholarship.*` tables including Scholarships, identifiers, offering cycles, application windows, scopes, criterion groups/criteria, award tiers and coverage.

**Cardinality:** inherently one-to-many and compound.

Common traps:

- do not flatten compound eligibility into a single unqualified text flag;
- Provider-scoped Scholarship applicability is not automatically Course-specific unless the scope contract says so;
- preserve cycle/window/evidence rather than treating a Scholarship as timeless.

## 14. QILT outcomes

**Primary observation:** `catalogue.provider_outcomes` with governed metric/survey reference data.

**Grain:** source cohort/time-scoped Provider outcome observation unless a more specific mapping is explicitly proven.

Common traps:

- do not imply Course-level resolution when source grain is Provider/field/cohort aggregate;
- source cohort and survey identity are part of meaning;
- an outcome value is not a ranking by default.

## 15. PRISMS student flow

**Primary observation:** `catalogue.student_flow_observations`.

**Grain:** aggregate time/geography/sector/study-area dimensions defined by the source.

Common traps:

- never fabricate Provider/Course identity for aggregate observations;
- preserve suppressed values as suppression, not zero;
- avoid flattening dimensions that change the observation grain.

## 16. Evidence and provenance

**Primary storage:** `pipeline.sources`, `pipeline.evidence_artifacts` and source-specific record tables where applicable.

Admin evidence presentation should answer:

- Which authority/source supplied this fact?
- Which snapshot/page/file was used?
- When was it captured?
- What content hash identifies the evidence?
- Which observation points to it?
- When was the fact last re-verified?
- Is the evidence still valid/current for this observation?

Evidence is not decorative metadata. It is part of the audit chain.

## 17. Completeness, readiness and Search

CourseFinder has three different concepts that must remain separate:

1. **Canonical data presence** — accepted relationships/observations exist.
2. **Admin operational completeness/readiness** — a governed/display rule says required facts are present.
3. **Search/consumer admission** — a downstream gate has explicitly projected/approved those facts for a consumer.

As of this guide version, no active Course-specific `pim.completeness_profiles` rule is seeded. The current Admin compatibility score is therefore explicitly **derived/display-only**: equal-weight presence across registration, structure, fee, intake, English and description. It must not be described as publication approval or source truth.

The Admin read projection now derives `has_fee`, `has_intake`, `has_english` and Scholarship linkage from canonical relationships rather than `search.course_documents` flags.

## 18. Lifecycle and publication

Lifecycle describes canonical entity state. Publication describes whether an entity is intended/approved for a publication channel. Search projection state describes the derived Search copy.

Do not infer one state from another.

Examples:

- `active + unpublished` is valid;
- `complete` does not mean `published`;
- `last_verified_at` does not mean approved;
- an accepted Provider-current fee can remain absent from Search until the separate Search gate passes.

## 19. Change signals and exception-first workflows

Admin should prefer signals over manual hunting:

- Added
- Modified
- Source changed
- Evidence changed
- Stale
- Needs review
- Unclassified semantic type
- Search out of sync

Automation may generate these signals deterministically. Humans should focus on ambiguous identity, conflicting authorities, semantic changes and low-confidence exceptions.

## 20. Change-control requirements for field-semantic changes

A material field-semantic change must record at minimum:

- `CF-CHG-YYYYMMDD-NNN` ID;
- initiation timestamp/timezone and originating workstream;
- trigger/reason;
- affected database/RPC/UI/Search/Zoho surfaces;
- semantic before/after;
- authority/evidence;
- migration and Git references;
- visible UI version when applicable;
- UAT and rollback;
- final status/closure timestamp.

Git history alone is insufficient because CourseFinder changes occur in parallel workstreams.

## 21. UX design references — non-authoritative

CourseFinder may borrow interaction principles from mature PIM systems without copying their product model:

- Akeneo: families define required attributes/completeness per channel and its family history records actor/system, timestamp and old/new values.
- UnoPIM: explicit Attributes -> Groups -> Families organisation and a dashboard that surfaces `Needs Attention` rather than forcing users to hunt through the catalogue.
- Pimcore may be used as additional UX/MDM reference where useful, but CourseFinder canonical semantics remain governed by CourseFinder architecture and source authority.

These systems are UX references only; they are not data authorities for CourseFinder.

## 22. First walkthrough gate

The first governed semantic walkthrough is the CRICOS `121174E` fee case.

The chain is now proven through authoritative source facts, evidence, exact CRICOS identity, canonical fee rows and the governed Admin read contract. Change history and curated Zoho mapping are recorded under `CF-CHG-20260820-001` and `docs/coursefinder-zoho-consumer-contract-v1.0.md`.

A frontend/browser release must still present the richer fee semantics and zero-safe grid label before this change record is finally CLOSED. The semantic workstream must not claim full PASS from database correctness alone.
