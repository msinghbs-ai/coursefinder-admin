# CourseFinder Database Architecture v2.10.25

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.24.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 18 August 2026  
**Milestone:** Milestone 1 — canonical data platform

v2.10.25 retains all accepted Layer 1 and QILT rules from v2.10.24 and records the accepted **Australia PRISMS Layer 2A student-flow contract** after autonomous source, dry-run, APPLY, replay, integrity, security and performance UAT.

## 1. Authority boundary

Australia CRICOS remains the canonical Layer 1 authority for Provider and Course identity.

PRISMS is accepted only as **Layer 2A structured statistical enrichment**. It has zero authority to:
- create, merge, rename or re-key a Provider;
- create or redefine a Course;
- infer a Provider/Course mapping from names or aggregate statistics;
- change CRICOS stable keys, canonical names, course codes or titles;
- mutate Search by itself.

The accepted production flow is:

`Official Department PRISMS-derived workbook -> immutable private evidence -> source dimensions + time period -> governed Layer 2A student-flow observations`

For the accepted ABS SA4 publication, the source publishes aggregate geography/sector/broad-field dimensions and does **not** publish Provider or Course identifiers. Therefore all accepted PRISMS observations have `provider_id = null` and `course_id = null` by design.

The write contract actively rejects an attempted Provider/Course attachment while the source metadata declares those dimensions unpublished.

## 2. Accepted PRISMS source contract

Accepted source:
- Publisher: Australian Government Department of Education;
- Source system: PRISMS;
- Publication: International student enrolment and commencement data by ABS SA4;
- Collection version: `2025-12`;
- Period: `2025-01-01` to `2025-12-31`;
- Period type: `ytd`;
- Source workbook rows: **1,135**;
- Published grain: state + SA4 + ABS remoteness area + sector + broad field of education;
- Metrics: enrolments and commencements;
- Population: international students;
- privacy suppression marker: `<5`.

The source workbook SHA-256 is:

`c50cec06e48eb6729eed5f2359cdc88c67c9680ceded6cb57be485d8c2094aae`

Workbook size: **63,321 bytes**.

## 3. Student-flow observation grain

`catalogue.student_flow_observations` is the accepted structured Layer 2A fact table for PRISMS-style student-flow observations.

Core governed dimensions include:
- host country;
- optional canonical Provider and Course references;
- canonical subdivision where exact mapping exists;
- source study area and optional governed canonical field mapping;
- optional canonical study level;
- survey + metric;
- audience;
- period start/end/type;
- source geography type/key/name;
- remoteness area;
- source sector/provider type/nationality dimensions;
- source study-area code/name;
- source observation key;
- exact metric value or explicit privacy suppression;
- source + immutable evidence;
- observation status + metadata.

Unique source replay identity is:

`source_id + source_observation_key`

The accepted worker uses source-row-stable keys:

`prisms-sa4:<collection-version>:row:<worksheet-row>:<metric-code>`

This preserves source fidelity where the publication contains duplicate normalized dimension groups rather than collapsing them heuristically.

## 4. Privacy suppression contract

PRISMS `<5` values are retained as published facts without imputation.

Accepted representation:
- exact value -> `metric_value >= 0`, `is_suppressed = false`, `suppression_code = null`;
- suppressed value -> `metric_value = null`, `is_suppressed = true`, `suppression_code = '<5'`.

A table constraint and service RPC enforce this either/or shape.

The initial accepted population contains:
- **2,270** observations total;
- **2,069** exact numeric observations;
- **201** explicit privacy-suppressed observations.

No hidden count is estimated from `<5`.

## 5. Canonical dimension mapping

### AU subdivision

The gate establishes exact AU ISO-style subdivision reference rows:
- AU-ACT;
- AU-NSW;
- AU-NT;
- AU-QLD;
- AU-SA;
- AU-TAS;
- AU-VIC;
- AU-WA.

All 1,135 source rows map deterministically to one of these existing canonical subdivision records.

### Broad field of education

All 13 published broad-field labels are preserved in `ref.external_study_areas` with `source_system = 'PRISMS'`.

Only exact labels already present in the current canonical `ref.fields_of_study` vocabulary are mapped at this gate:
- `Management and Commerce` -> `management-commerce`;
- `Natural and Physical Sciences` -> `natural-physical-sciences`.

The mappings use `exact_existing_canonical_label`, confidence 1.0. No fuzzy mapping, guessed taxonomy expansion or source-driven canonical field creation is permitted.

Initial canonical-field attachment: **372 observations**. All other broad-field facts remain source-qualified and valid without a canonical field link.

## 6. Source/evidence/version lineage

The accepted source row in `pipeline.sources` records:
- `source_type = structured_outcomes`;
- publisher Department of Education;
- source system PRISMS;
- collection version `2025-12`;
- period start/end;
- published source grain;
- `published_provider_dimension = false`;
- `published_course_dimension = false`;
- `identity_authority = false`.

Accepted source ID:

`37f1776c-77a3-4083-8ec7-7d76ad7a9ad8`

Accepted evidence ID:

`78210aa1-8a20-46f5-ba52-9689068a1e2e`

Evidence storage path:

`layer2a/AU/prisms/sa4/2025-12/c50cec06e48eb6729eed5f2359cdc88c67c9680ceded6cb57be485d8c2094aae.xlsx`

The `evidence` bucket remains private.

## 7. Runtime and write boundary

Pilot worker: `prisms-au-etl` v0.1.0.

Source-control baseline: `msinghbs-ai/Coursefinder-Pilot` commit `0714aab19480924d62757ec20cbbfbe6fe881849`.

Applied migrations:
- `20260818054601_prisms_layer2a_student_flow_contract.sql`;
- `20260818054751_prisms_suppressed_value_and_replay_hardening.sql`.

Runtime controls:
- official Department workbook acquisition;
- expected title/source/sheet/header validation;
- period extracted from the source publication;
- row-count reconciliation to the source summary;
- SHA-256 evidence identity;
- source-qualified deterministic mappings only;
- bounded 5,000-row service APPLY contract;
- one-time Pilot nonce for Edge invocation;
- server-side `service_role` write path;
- write RPCs revoked from `anon` and `authenticated`;
- explicit source metadata enforcement before Provider/Course attachment can ever occur.

## 8. Read boundary

Internal student-flow/evidence/source tables remain deny-by-default for direct client reads.

Authenticated UI/API reads use:

`public.ui_international_student_observations(period_end, subdivision_code, sector, limit)`

The projection exposes:
- source/version/evidence lineage;
- time period;
- source dimensions;
- governed canonical subdivision/field mappings;
- exact versus suppressed value state;
- nullable Provider/Course references.

`anon` execution is revoked. Evidence remains private.

## 9. Accepted production population and reconciliation

Initial APPLY:
- source rows: **1,135**;
- candidate observations: **2,270**;
- observations changed: **2,270**.

Second identical APPLY:
- observations seen: **2,270**;
- observations changed: **0**.

Visible exact numeric totals reconcile exactly to the workbook summary:
- enrolments: **1,035,371**;
- commencements: **467,122**.

The 201 `<5` cells are represented as suppression facts and are not included in numeric sums.

## 10. Identity and Search invariants

Before and after PRISMS APPLY:
- AU Providers: **1,546**;
- AU Courses: **26,648**;
- accepted Search Documents: **33,105** AU+NZ.

Regression hashes were unchanged:
- AU Provider hash: `d63daea157023f0e6b83c71f0a9a88be`;
- AU Course hash: `12c4eed4f4b188a7199f42b68d012052`;
- Search hash: `19f4151148c4b4c7bb768409aeca3192`.

Post-APPLY PRISMS observations with Provider attachment: **0**.  
Post-APPLY PRISMS observations with Course attachment: **0**.

A negative UAT that attempted to attach an existing AU CRICOS Provider was rejected with `source does not publish a Provider dimension`.

## 11. Integrity/security/performance invariants

Post-APPLY integrity:
- duplicate source observation keys: 0;
- invalid exact/suppressed value shapes: 0;
- missing subdivision mappings: 0;
- missing source study-area references: 0;
- invalid canonical field mappings: 0;
- invalid source links: 0;
- invalid evidence links: 0;
- non-international observations: 0.

Security:
- direct Edge call without one-time nonce -> 401;
- direct `anon`/`authenticated` table SELECT -> denied;
- PRISMS service RPC execution -> service role only;
- authenticated curated read RPC -> permitted;
- evidence Storage -> private.

Representative authenticated read for `2025-12-31 + AU-VIC + higher_education`:
- rows: 224;
- execution: approximately **38.2 ms**;
- shared-buffer hits only; no disk reads in measured plan.

Supabase performance advisor reported no missing-index issue on the new observation table. New-table unused-index INFO notices are expected immediately after creation and are not a gate blocker.

## 12. Search/publication implication

PRISMS is now accepted canonical **Layer 2A factual enrichment**, but it is not automatically a Search field or ranking signal.

Any consumer exposure must explicitly choose:
- period semantics;
- suppression handling;
- source versus canonical taxonomy display;
- aggregation rules that do not double-count source rows;
- whether a metric belongs in ranking/filtering or informational display.

This remains a separate M1-SEARCH acceptance decision.

## 13. Governance decision

**M1-L2-AU-PRISMS is PASS.**

The gate establishes that aggregate PRISMS statistical facts can be accepted without inventing Provider/Course links. CRICOS remains the AU identity authority; PRISMS remains time-scoped, source-qualified evidence-backed Layer 2A enrichment.