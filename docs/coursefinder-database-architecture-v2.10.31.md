# CourseFinder Database Architecture v2.10.31

**Status:** AUTHORITATIVE  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.30.md`

## 1. Version scope

v2.10.31 preserves every accepted identity, source/evidence, QILT, PRISMS, Scholarship, Search projection and consumer API contract from v2.10.30.

This version accepts the completed `M1-L1-AU-CRICOS-FACTS` implementation and closes the structured regulatory Course-facts omission identified in v2.10.30.

Accepted AU identity remains exactly:
- Providers: 1,546;
- Courses: 26,648.

No new Course identity rule is introduced.

## 2. Regulatory Course observation model

Useful CRICOS facts that are not canonical identity/core columns are retained as source-backed relational observations rather than flattened into Course identity.

Accepted table: `catalogue.course_regulatory_observations`.

The observation preserves:
- canonical `course_id`;
- registration scheme and registration code;
- VET National Code;
- Dual Qualification;
- Foundation Studies;
- Work Component;
- valid typed work quantities;
- Course Language;
- source id;
- evidence id;
- source snapshot timestamp;
- content hash;
- observation lifecycle and validity.

Snapshot identity is Course + source + registration scheme/code + source snapshot.

A new source snapshot may supersede an earlier current observation without changing the canonical Course.

## 3. VET National Code decision

VET National Code is **not** accepted as CRICOS Course identity.

The current CRICOS export contains Provider-level duplicate VET-code pairs across distinct CRICOS Course codes. Therefore forcing VET National Code into the existing scoped Course identifier uniqueness contract would discard valid source relationships.

VET National Code is retained as a relational regulatory observation with evidence.

CRICOS Course Code remains the AU regulatory Course identity.

## 4. Regulatory boolean and language facts

Accepted relational regulatory facts:
- Dual Qualification;
- Foundation Studies;
- Work Component;
- Course Language.

These facts are source assertions, not identity.

Course Language preserves the exact CRICOS source vocabulary. A future controlled language taxonomy may map the source value, but must not erase the original observation.

## 5. Work-component quantities

Work Component Hours/Week, Weeks and Total Hours are retained as typed numeric observations only when the source value is numerically valid.

Formatting thousands separators may be removed for numeric parsing without changing source evidence.

Negative source quantities are not converted into positive or otherwise inferred values. They remain source evidence until corrected by the authority or separately governed.

## 6. Secondary Field of Education

Primary ASCED narrow-field behaviour from the accepted AU substrate remains unchanged.

CRICOS Field of Education 2 Narrow Field is accepted as a relational non-primary field observation.

If the same source field code is asserted in both primary and secondary positions, the existing source-field relationship is reused; duplicate relations are not created and primary assignment is not downgraded.

Broad fields remain derivable parent metadata and detailed fields remain source evidence until a separate detailed-field canonical contract is approved.

## 7. CRICOS fee contract

`catalogue.course_fees` now carries `source_snapshot_at` for versioned regulatory fee provenance.

Accepted CRICOS fee semantics are:
- audience: `international`;
- currency: `AUD`;
- basis: `registered_total_course`;
- `fee_year`: `NULL`;
- annualised: false;
- `fee_type=tuition` for Tuition Fee;
- `fee_type=non_tuition` for Non Tuition Fee;
- `fee_type=estimated_total_course_cost` for Estimated Total Course Cost.

Blank source values create no observation. Explicit zero remains a valid source value.

These observations must never be relabelled as annual tuition.

A Provider-owned current/year-specific fee remains a separate later observation with its own year, campus, intake or basis dimensions where supplied.

## 8. Source-field completeness rule

The v2.10.30 requirement that every structured accepted source field be classified is now demonstrated for all 24 current CRICOS Courses columns.

The accepted classifications are recorded in:
`docs/coursefinder-au-cricos-course-facts-uat-v1.0.md`.

Fields are governed as one of:
- canonical core;
- relational observation;
- source-only evidence/validation;
- explicitly excluded with reason.

This remains the required pattern for future authoritative structured sources.

## 9. Source/evidence/versioning

The accepted CRICOS Course facts snapshot is versioned by the authoritative resource `last_modified` timestamp and evidence artifact hash.

The current accepted snapshot:
- source last modified: `2026-08-04T08:04:20.717556Z`;
- SHA-256: `fc2f2ef81c0b3c63dd47e1b01c7e5cf22f708c892e70f71707dbb421baed6945`.

Facts and fees retain both source id and evidence id.

Replay of the same source snapshot is structurally idempotent.

## 10. Search boundary

Search remains a governed derived projection and is not a mirror of catalogue facts.

`course_fee` Search admission remains blocked after this architecture update.

Persisting CRICOS registered total-course fee rows does not set consumer `has_fee` and does not authorise display/filter semantics.

The next first-party Course-facts gate may add current/year-specific Provider fees, but Search fee admission still requires its own accepted UAT decision.

## 11. Runtime boundary

Operational Edge worker: `layer1-au-cricos-facts-v1.0.4`.

The worker is bounded to a maximum of 500 active CRICOS Course rows per invocation after runtime UAT rejected larger batch sizes.

The worker verifies the official CRICOS Courses resource identity, source timestamp, active row count and optional expected hash before invoking the service-role-only set-based reconciliation RPC.

Longer full-dataset validation may use a controlled server-side UAT harness, but the production ingestion entrypoint remains bounded.

## 12. Security posture

`catalogue.course_regulatory_observations` is private with RLS enabled and no direct browser write policy.

The reconciliation RPC is service-role only. Pilot invocation continues to use the existing one-time nonce/platform-admin execution boundary.

No new public consumer DTO or Search exposure is created by this version.

Existing unrelated Admin/PIM `SECURITY DEFINER`, authentication and final production-hardening advisories remain assigned to their existing gates.

## 13. Gate decision

**v2.10.31 accepted.**

`M1-L1-AU-CRICOS-FACTS` is complete and the AU canonical substrate is preserved with governed regulatory Course observations and fee semantics.

**Programme next:** `M1-L2-AU-COURSE-FACTS` for Provider-owned current Course URLs, current/year-specific fee schedules, intakes and English requirements. `M1-PIM-HARDENING` and `M1-SEARCH-VECTOR` remain parallel independent workstreams.
