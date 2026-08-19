# CourseFinder Database Architecture v2.10.34

**Status:** AUTHORITATIVE  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.33.md`

## 1. Version scope

v2.10.34 preserves all accepted contracts from v2.10.33 and records a **pre-staged but not admitted** implementation contract for `M1-L2-AU-COURSE-FACTS`.

The serial programme gate does not change. `M1-L1-AU-CRICOS-COMPLETENESS` remains the immediate prerequisite before any Layer 2 Course Facts APPLY is accepted.

Current AU identity remains exactly 1,546 Providers / 26,648 active Courses.

## 2. Layer 2 Course Facts boundary

Provider-owned Course facts may enrich an accepted CRICOS Course only after exact stable resolution. The preferred AU mapping is:

`Provider CRICOS registration + Course CRICOS registration -> existing canonical Course`

Title-only identity is prohibited. An unresolved or mismatched CRICOS code must fail or enter review; it must never fall back to a title match.

Layer 2 is not an identity authority and must not change Provider identity, Course identity, CRICOS registration, canonical title or canonical source ownership.

## 3. First-party fact domains

The governed contract admits only these domains after the prerequisite gate passes:
- official Provider/University Course URL;
- current/year-specific international tuition fee;
- intake/application timing;
- English entry requirements.

Each observation preserves source and evidence. Fee observations additionally preserve fee year, currency and exact fee basis. Intake observations preserve source-specific intake identity and date scope when published. English observations preserve test, overall/component thresholds and validity/verification metadata.

## 4. Fee semantic separation

Provider-current international tuition is represented as `fee_type=provider_current_tuition`.

It is semantically separate from CRICOS registered Tuition Fee / Non Tuition Fee / Estimated Total Course Cost observations. A Provider-current fee must not overwrite, reinterpret, annualise or derive a CRICOS registered-total-course fee.

## 5. Official Course URL separation

Provider-owned official Course URLs are stored in `catalogue.course_links` with source/evidence provenance.

Layer 2 must not mutate `catalogue.courses.course_url` or promote a Provider URL to a canonical primary link solely because it was discovered. Primary/publication selection is a separate governance decision.

## 6. Idempotency support

The pre-staged contract adds:
- `catalogue.course_intakes.source_intake_key` with source-scoped uniqueness;
- source/validity fields for Course English requirements;
- `pipeline.course_fact_source_qualifications` to govern source admission;
- qualification enforcement in `svc_coursefacts_apply_record`;
- source/evidence-preserving upsert semantics for links, Provider-current fees, intakes and English requirements.

## 7. Bounded RMIT pre-stage

RMIT University (CRICOS Provider 00122A) was used only for bounded contract verification.

Verified CRICOS-coded source records:
- 111279A — Associate Degree in Business;
- 103390B — Advanced Diploma of Electronics and Communications Engineering.

The bounded UAT demonstrated official URL, 2027 fee basis, intake and supported English-test ingestion without canonical identity mutation or CRICOS-fee collision.

The UAT APPLY rows were removed after validation because the prerequisite gate is still open. The RMIT source qualification is `deferred` with `apply_admitted=false` and `search_admitted=false`.

## 8. Current prerequisite state

Live residual Layer 1 gaps remain:
- 2,281 active AU Courses without mapped `study_level_id`;
- 34 active AU Courses without a canonical campus relationship.

Therefore `M1-L2-AU-COURSE-FACTS` is **HOLD / PRE-STAGED**, not accepted.

## 9. Search boundary

Search remains unchanged:
- Course Documents: 33,105;
- `has_fee=true`: 0;
- Course fee Search admission: blocked.

No official URL, Provider-current fee, intake or English fact enters Search until the dedicated Search-enrichment admission gate passes after Layer 2 acceptance.

## 10. Decision

**v2.10.34 accepted as architecture-only pre-stage.**

Implementation scaffolding may remain deployed for reproducibility, but source qualification and APPLY stay blocked until `M1-L1-AU-CRICOS-COMPLETENESS` passes. After that prerequisite is accepted, rerun authoritative source capture plus bounded dry-run/APPLY/replay/idempotency/ambiguity UAT before accepting Layer 2 or expanding beyond the bounded Provider set.