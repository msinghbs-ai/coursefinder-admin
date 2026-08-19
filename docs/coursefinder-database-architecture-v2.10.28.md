# CourseFinder Database Architecture v2.10.28

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.27.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 19 August 2026  
**AU completeness UAT:** `docs/uat/coursefinder-au-geography-fields-completeness-gate-uat-v1.0.md`

v2.10.28 retains all accepted Layer 1 identity, QILT, PRISMS and Scholarship contracts and records the evidence-backed AU geography/Field-of-Education correction required for Admin filtering.

## 1. Layer 1 completeness does not change identity

AU CRICOS remains the Layer 1 Provider/Course identity authority.

This correction does not create a new Provider/Course identity path. Provider and Course identity remains exact CRICOS registration based; names remain display/reconciliation data only.

Accepted identity counts remain:
- Providers: **1,546**;
- Courses: **26,648**;
- Campuses: **3,922**;
- Course↔Campus relationships: **47,671**.

## 2. Geography contract

### Provider geography

`catalogue.providers.subdivision_id` represents a directly published Provider postal/administrative subdivision where the authoritative source publishes one.

For AU, CRICOS Institutions now populates Provider postal subdivision by exact source State token through `ref.resolve_subdivision_exact`.

Accepted coverage: **1,546 / 1,546 AU Providers**.

Provider postal subdivision must not be interpreted as all operating States.

### Campus geography

`catalogue.campuses.subdivision_id` represents the directly published Campus/Location subdivision.

AU CRICOS Locations now populates **3,921 / 3,922** Campuses.

The remaining Muirden Senior Secondary College row is an explicit upstream source-null (`City=null`, `State=null`) and remains canonical null. Postcode is not used to infer State.

### Course geography

Course State/Region is relational, not a direct Course scalar:

`Course -> course_campuses -> Campus -> subdivision`

A Course can therefore be present in multiple States/Territories.

Admin/Search filters must use existence across all linked Campus subdivisions rather than Provider postal State or a single representative Campus.

## 3. Field of Study contract

CRICOS `Field of Education 1 Narrow Field` is accepted as a source-published ASCED narrow-field observation.

Canonical reference codes are namespaced:
- broad field: `asced-NN`;
- narrow field: `asced-NNNN`.

The 12 ASCED broad fields are seeded as reference parents. Four-digit narrow fields are created only from source-published CRICOS values.

No fuzzy text classification is permitted for this Layer 1 mapping.

New provenance relation:

### `catalogue.course_field_observations`

Stores:
- Course;
- canonical Field;
- source/evidence;
- source field code/name;
- primary flag;
- observation status/time.

Current AU state:
- Course primary field populated: **26,648 / 26,648**;
- current field observations: **26,648**;
- accepted narrow fields represented: **79**.

`courses.primary_field_id` is the current canonical primary reference pointer; observation rows retain source/evidence lineage.

## 4. Delivery contract

For AU CRICOS the accepted delivery observation currently exists on the Course↔Campus relationship.

Admin filtering must therefore evaluate `catalogue.course_campuses.delivery_mode`, with a direct Course delivery scalar used only when independently source-supported.

Current AU coverage:
- Courses with Course↔Campus relationship: **26,614 / 26,648**;
- Courses with delivery mode: **26,614 / 26,648**;
- current observed mode: `on_campus`.

The 34 courses without a Course Location relationship remain a valid missing-data exception queue.

## 5. Filter/read-contract invariants

Course decision filtering now follows these authoritative paths:
- Country -> Provider country;
- State/Region -> any linked Course Campus subdivision;
- Provider -> canonical Provider ID;
- Study level -> canonical study level;
- Field -> exact canonical ASCED field;
- Delivery -> Course↔Campus delivery mode when present;
- Has State -> any authoritative linked Campus subdivision;
- Has Link -> active `catalogue.course_links` row;
- Has Fee -> active/current `catalogue.course_fees` row;
- Has Intake / English / Scholarship -> corresponding structured relation.

Multi-State Courses must match every State in which they have a linked Campus. Display may summarise multiple regions, but filtering must not collapse them to one representative State.

Provider State filtering can match direct Provider postal subdivision or an operating Campus subdivision; presentation must distinguish postal State from Campus coverage where both are shown.

## 6. Course links and fees remain Layer 2

`catalogue.course_links` and the hardened `catalogue.course_fees` relation are structurally ready but AU coverage remains zero after this Layer 1 correction:
- active Course Links: **0**;
- active Course Fees: **0**.

CRICOS does not become authority for values it does not publish.

Course URLs, Fees, Intakes and English requirements require first-party Provider/University sources with:
- exact canonical Course resolution, preferably through published CRICOS Course code or another governed stable source key;
- content-hashed evidence;
- source-local observation identity;
- validity/year/audience semantics;
- bounded APPLY and replay/idempotency.

## 7. Runtime contract

The national ZIP-depth path exceeded the Supabase Edge compute ceiling during this correction gate.

Accepted bounded maintenance worker:

`layer1-au-completeness-v0.1.0`

It:
- discovers current direct CRICOS Institutions/Courses/Locations CSV resources;
- captures evidence once;
- pins all subsequent batches to exact expected SHA-256 hashes;
- applies records in bounded RPC chunks;
- never infers missing geography;
- is invoked through the existing single-use Pilot nonce control.

This worker is a maintenance/completeness path and does not replace canonical identity rules.

## 8. Gate state

AU geography + Field completeness correction is **PASS WITH ONE BOUNDED SOURCE-NULL CAMPUS GEOGRAPHY GAP**.

The next AU completeness gate is Layer 2 first-party Course enrichment for URLs, Fees, Intakes and English requirements. Search publication/ranking remains separately governed.