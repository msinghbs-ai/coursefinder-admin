# CourseFinder Database Architecture v2.10.30

**Status:** AUTHORITATIVE  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.29.md`

## 1. Version scope

v2.10.30 preserves every accepted canonical identity, source/evidence, QILT, PRISMS, Scholarship, Search projection and consumer API contract from v2.10.29.

This version corrects the AU Course Facts execution boundary after verifying that the accepted CRICOS source already exposes structured registered Course cost facts that the current Layer 1 adapter does not persist.

## 2. Canonical source precedence

CourseFinder distinguishes source authority from data freshness/use-case.

A fact supplied by the accepted regulatory identity authority is retained as a regulatory observation when it has meaningful product value and stable Course identity.

A later Provider source may supply a more current or differently scoped observation. It supplements the regulatory fact and does not erase its evidence/history.

Example:

`CRICOS registered tuition -> regulatory/base observation`

`University 2027 international tuition schedule -> first-party current observation`

Both may coexist because they answer different questions.

## 3. AU CRICOS Course fact contract

The accepted CRICOS Course record exposes, in addition to identity/title/level/field/duration, structured facts including tuition/cost and other registration attributes.

The current `layer1-au-depth` implementation persists identity/title/level/duration/field but does not populate `catalogue.course_fees`.

Live verification at this architecture gate:
- AU Courses: 26,648;
- AU `catalogue.course_fees` rows: 0;
- AU Course Links: 0;
- AU Course Intakes: 0;
- AU English requirements: 0.

Detailed gap record: `docs/coursefinder-au-cricos-course-facts-gap-v1.0.md`.

## 4. Fee semantics

CRICOS tuition must not be modelled as an inferred annual tuition fee.

The source describes a registered course-of-study amount. Recommended canonical semantics:
- source: CRICOS;
- audience: international;
- currency: AUD;
- fee basis: `registered_total_course` or equivalent controlled code;
- amount: exact source Tuition Fee;
- observation/source snapshot timestamp retained;
- source/evidence lineage retained.

Where present, Non Tuition Fee and Estimated Total Course Cost remain distinct facts. Do not overwrite Tuition Fee with total cost.

A Provider fee schedule later enters as a separate observation with its own year, intake, campus and basis where the source supplies those dimensions.

## 5. Layer boundary correction

Previous M1 planning grouped Fee entirely under first-party Layer 2 Course Facts. That is too coarse.

Revised AU sequence:

1. **M1-L1-AU-CRICOS-FACTS** — inventory and persist useful omitted regulatory Course facts from the already accepted CRICOS snapshot.
2. **M1-L2-AU-COURSE-FACTS** — ingest first-party current Course URL, current marketed fee schedules, intakes and English requirements using accepted CRICOS Course identity.

Layer 2 must not re-scrape a fact merely because Layer 1 failed to persist an authoritative structured field.

## 6. Source-field classification rule

Every accepted structured source should have a field inventory before the gate closes.

Each source field is classified as one of:
- canonical core attribute;
- relational/time-scoped observation;
- source-only evidence/metadata;
- explicitly excluded, with reason.

A production gate is incomplete if useful source fields are silently discarded without a recorded classification decision.

## 7. Search implications

Search remains derived and independently gated.

Persisting a CRICOS Fee row does not automatically make `has_fee` consumer-ready.

Recommended readiness distinction:
- regulatory fee present;
- current first-party fee present;
- accepted Search Fee readiness.

Search Fee admission remains blocked until the fee-domain UAT defines which observation is appropriate for consumer filtering/display.

## 8. Admin/PIM implications

Admin/PIM should distinguish provenance and freshness rather than a single `Has Fee` boolean where operationally useful.

Recommended Course fact status:
- CRICOS registered fee available;
- current Provider fee available;
- current intake available;
- English requirement available;
- official Course link available;
- last verified/source.

The PIM must not allow browser edits to disguise source provenance.

## 9. Security/hardening

Existing v2.10.29 Search boundaries remain unchanged.

The outstanding M1 security work remains:
- review and minimise public `SECURITY DEFINER` Admin/PIM RPC surface;
- prove grants/role checks for every browser-executable RPC;
- retain service-role-only internal writes;
- close Supabase Auth leaked-password-protection warning where project plan permits;
- perform final exposed-function/storage/RLS advisor review before M1 close.

## 10. Gate decision

**v2.10.30 accepted architecture correction:** regulatory-source field completeness is now an explicit production requirement.

**Programme next:** `M1-L1-AU-CRICOS-FACTS` precedes `M1-L2-AU-COURSE-FACTS`. `M1-PIM-HARDENING` and `M1-SEARCH-VECTOR` can proceed independently in parallel where they do not change canonical data semantics.
