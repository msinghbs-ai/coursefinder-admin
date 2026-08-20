# CourseFinder Zoho Consumer Contract v1.1

**Status:** GOVERNED CURATED CONTRACT — SEMANTIC EXTENSION  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-zoho-consumer-contract-v1.0.md`  
**Change Control:** `CF-CHG-20260820-001`, `CF-CHG-20260820-008`, `CF-CHG-20260820-009`  
**Scope:** semantic mapping contract only; no Search/Website/Zoho publication admission is implied.

All unchanged Provider/Course/Fee/QILT/PRISMS/Scholarship principles from v1.0 remain in force. v1.1 clarifies repeating Campus, Intake and English observation contracts.

## Course Campus relationship object

Do not expose an ambiguous scalar Course `State` or use Provider geography as Course delivery geography.

| API name | Zoho label | Type | Cardinality | Notes |
|---|---|---|---|---|
| `campus_key` | Campus Key | string | single | governed Campus stable key |
| `campus_name` | Campus Name | string | single | display label; not identity by itself |
| `country_code` | Campus Country | string(2) | single | Campus geography |
| `subdivision_code` | Campus State / Region Code | string | single | e.g. AU-VIC |
| `subdivision_name` | Campus State / Region | string | single | e.g. Victoria |
| `city` | Campus City | string | single | Campus geography |
| `postcode` | Campus Postcode | string | single | nullable |
| `delivery_mode` | Course Delivery Mode | string | single | relationship semantic, e.g. `on_campus` |
| `is_primary` | Primary Course Campus | boolean | single | relationship flag; false does not invalidate relationship |
| `campus_status` | Campus Status | string | single | Campus state, not Course state |
| `campus_publication_status` | Campus Publication | string | single | independent of Course publication |
| `campus_last_verified_at` | Campus Last Verified | datetime | single | verification, not approval |
| `campus_source_ref` | Campus Source | object/string | single | proves Campus observation |
| `campus_evidence_ref` | Campus Evidence | object/string | single | curated audit reference |
| `relationship_source_ref` | Course-Campus Source | object/string | single | proves Course→Campus relationship |
| `relationship_evidence_ref` | Course-Campus Evidence | object/string | single | curated audit reference |

`course.campuses` remains an object array. Empty means no accepted Course→Campus relationship is loaded. It must not be auto-filled from Provider address/state.

## Intake observation object

Intakes are repeating Provider-current observations.

| API name | Zoho label | Type | Cardinality | Notes |
|---|---|---|---|---|
| `intake_year` | Intake Year | integer | single | source-preserved year |
| `intake_label` | Intake | string | single | source-governed label |
| `start_date` | Start Date | date | single | nullable where source gives no exact date |
| `application_deadline` | Application Deadline | date | single | nullable when not supplied |
| `campus_key` | Intake Campus Scope | string | single | null means no accepted Campus scope recorded; never infer `all campuses` |
| `status` | Intake Status | string | single | observation status |
| `confidence` | Intake Mapping Confidence | decimal | single | audit/automation signal; not approval |
| `source_intake_key` | Source Intake Key | string | single | stable source-scoped observation identity where available |
| `source_ref` | Source | object/string | single | curated source identity/label/url |
| `evidence_ref` | Evidence | object/string | single | curated evidence reference |
| `evidence_captured_at` | Evidence Captured | datetime | single | snapshot capture time |

Do not flatten multiple same-year Intakes into one year. If Zoho cannot represent child/repeating Intake records without loss, Intake admission must remain blocked until a governed consumer-specific representation is approved.

## English requirement object

English requirements are repeating Course-level observations by governed English test identity.

| API name | Zoho label | Type | Cardinality | Notes |
|---|---|---|---|---|
| `test_code` | English Test Code | string | single | governed `ref.english_tests` identity |
| `test_name` | English Test | string | single | governed display label |
| `overall_score` | Overall Score | decimal | single | preserve source value |
| `component_scores` | Component Scores | object | single | preserve component thresholds; do not flatten into overall |
| `notes` | Requirement Notes | string | single | nullable/source-supported |
| `scope` | Requirement Scope | enum | single | currently `course`; no Campus scope should be invented |
| `status` | Requirement Status | string | single | observation state |
| `confidence` | Requirement Mapping Confidence | decimal | single | audit/automation signal; not approval |
| `valid_from` | Valid From | date | single | nullable |
| `valid_to` | Valid To | date | single | null does not mean permanent |
| `last_verified_at` | Last Verified | datetime | single | verification, not approval |
| `source_requirement_key` | Source Requirement Key | string | single | stable source-scoped observation identity where available |
| `source_ref` | Source | object/string | single | curated source identity/label/url |
| `evidence_ref` | Evidence | object/string | single | curated evidence reference |

Do not emit one generic `English Score` when multiple governed test alternatives/requirements exist.

## Reference consumer case — UQ 102784C

If/when admitted, `102784C` should expose two Intake child observations:

- Semester 1 / 2027 / 22 Feb 2027 / deadline 30 Nov 2026 / no accepted Campus scope recorded;
- Semester 2 / 2027 / 26 Jul 2027 / deadline 31 May 2027 / no accepted Campus scope recorded.

It should expose three English requirement child observations:

- IELTS Academic — overall 6.5 — all four components minimum 6;
- PTE Academic — overall 64 — minimum each 60;
- TOEFL iBT — overall 87 — Reading 19 / Writing 21 / Speaking 19 / Listening 19.

These observations remain Provider-current and evidence-backed. Their existence in Admin/canonical storage does not constitute Zoho admission.

## Admission status

v1.1 remains definition-only. Before Website/Zoho publication, the consumer gate must prove:

- repeating cardinality is supported without semantic loss;
- null Campus scope remains null/unscoped;
- component English thresholds remain intact;
- source/evidence exposure is appropriate;
- consumer schema versioning is defined;
- no internal table/UUID implementation detail is leaked unnecessarily.
