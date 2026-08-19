# CourseFinder Database Architecture v2.10.35

**Status:** AUTHORITATIVE  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.34.md`  
**Gate:** `M1-L1-AU-CRICOS-COMPLETENESS` — PASS  
**UAT:** `docs/coursefinder-au-cricos-layer1-adapter-consolidation-uat-v1.2.md`

## 1. Version scope

v2.10.35 preserves all accepted contracts from v2.10.34, including the pre-staged but not previously admitted `M1-L2-AU-COURSE-FACTS` design. This version records the successful AU CRICOS residual Layer 1 completeness gate and the exact source-value Study Level architecture that closes its prerequisite.

Provider and Course identity are unchanged.

## 2. Accepted AU substrate

- CRICOS Providers: **1,546**
- active CRICOS Courses: **26,648**
- missing governed Study Level: **0**
- unexplained Layer 1 mapping defects: **0**
- Search Documents: **33,105**, unchanged by this gate

CRICOS Course code under its governed Provider remains the Course identity. No Course was created, removed, merged or re-keyed by this gate.

## 3. Exact CRICOS Course Level contract

A populated CRICOS `Course Level` is authoritative regulatory vocabulary. For CRICOS:

- mapping must originate from the exact source value;
- Course-title inference is prohibited when `Course Level` is populated;
- raw vocabulary, source, evidence, snapshot and mapping status must remain recoverable;
- populated values that are not deterministically governed must fail closed as unmapped/review-required rather than silently collapse.

### 3.1 Source mapping registry

`ref.study_level_source_mappings` now governs exact source-specific mappings to `ref.study_levels`.

The current CRICOS snapshot contains 20 distinct populated Course Level values and all 20 are deterministically mapped.

### 3.2 Evidence-backed observation

`catalogue.course_study_level_observations` records the evidence/history contract for each current mapping, including exact `source_value`, canonical Study Level, source/evidence identity, CRICOS Course code, snapshot timestamp, mapping status and semantic content hash.

`catalogue.courses.study_level_id` remains the convenient current canonical value; the observation relation is the provenance/history authority.

## 4. Governed taxonomy extensions

Stable detailed concepts added to `ref.study_levels`:

- `primary_school_studies`
- `junior_secondary_studies`
- `senior_secondary_certificate`
- `certificate_i`
- `certificate_ii`
- `certificate_iii`
- `certificate_iv`
- `vocational_short_course`
- `advanced_diploma`
- `bachelor_honours`
- `masters_coursework`
- `masters_research`
- `masters_extended`
- `non_aqf_award`

Existing exact concepts are reused where already governed, including `diploma`, `bachelor`, `graduate_certificate`, `graduate_diploma`, `associate_degree` and `doctorate`. Parent links preserve broad Certificate, Diploma, Bachelor and Masters families where applicable.

## 5. Production apply contract

`public.svc_layer1_apply_course_study_levels(...)` is the accepted production service for this mapping subphase.

It is service-role only, uses a fixed `search_path`, validates source/evidence identity, resolves canonical Provider/Course identity, supports dry-run/APPLY, writes evidence-backed observations and updates the canonical Study Level only for a deterministic exact mapping.

`public.svc_layer1_evidence_descriptor(...)` provides service-role-only access to the descriptor of an approved private evidence artifact for bounded replay/UAT without making external network availability part of a write transaction.

## 6. Adapter versions

Accepted primary AU Layer 1 adapter:

`layer1-au-depth-v1.6.0`

Relative to v1.5.1, it carries `course_level_raw`, removes the regex/free-text Study Level path, invokes the governed Study Level service as a distinct Layer 1 subphase and fails closed for unresolved mappings or identity misses. Provider/Course identity, geography and CRICOS fee semantics are unchanged.

Accepted bounded residual UAT/replay worker:

`layer1-au-completeness-v1.1.0`

This is a nonce-controlled private-evidence replay harness for the same production Study Level RPC; it does not create a separate data model or publication path.

## 7. Residual source gaps

### Campus

- active Courses without canonical Campus: **34**
- matching current CRICOS Course Location rows: **0**
- classification: authoritative `source_absent` for all 34
- identity-resolution issue: 0
- review-required ambiguity: 0
- adapter defect: 0
- synthetic Campuses created: 0

### Registered fees

Fresh current CRICOS audit reconfirms:

- missing Tuition Fee: **191**
- missing Non Tuition Fee: **191**
- the same 191 Courses lack both values
- classification: authoritative `source_absent`

Fee semantics remain AUD / international / `registered_total_course` / `fee_year = null` / not annualised.

## 8. Source anomalies

Four active source rows publish `Work Component Weeks = -1`; one of these also publishes `Work Component Total Hours = -20`. These are preserved as authoritative-source anomalies and are not converted into manufactured positive canonical durations.

## 9. Accepted regulatory completeness

Across the accepted 13 Layer 1 regulatory dimensions:

- total cells: **346,424**
- explained source-gap cells: **416**
- unexplained adapter-defect cells: **0**
- regulatory completeness: **99.88%**

Distribution:

- 26,423 Courses = 13/13
- 34 Courses = 12/13, Campus source absence only
- 191 Courses = 11/13, Tuition + Non Tuition source absence only

Completeness scoring must continue to distinguish source absence from adapter defect; source-null data does not authorise manufacturing values.

## 10. Search isolation

Before and after this Layer 1 gate:

- Search Documents: **33,105**
- aggregate fingerprint: `c3cf5dd66a6b69e58f41c72abb4f1e94`
- max Search `updated_at`: `2026-08-19 04:54:40.774052+00`

No Search rebuild, enrichment admission or consumer publication change occurred.

## 11. Security and operations

The new mapping/observation tables are RLS-enabled and have no anon/authenticated table grants. New SECURITY DEFINER services have fixed `search_path`, explicit service-role checks and no public/anon/authenticated EXECUTE permission.

The new observation `evidence_id` FK has a covering index; the gate-created unindexed-FK advisor finding was cleared.

## 12. Architecture decision

`M1-L1-AU-CRICOS-COMPLETENESS` is **PASS / ACCEPTED** with exactly 1,546 Providers / 26,648 active Courses and zero unexplained Layer 1 mapping defects.

The v2.10.34 Layer 2 Course Facts design remains structurally valid. Its serial prerequisite is now satisfied, so `M1-L2-AU-COURSE-FACTS` may proceed as the next separate gate. No Layer 2 APPLY or Search admission is performed by v2.10.35.
