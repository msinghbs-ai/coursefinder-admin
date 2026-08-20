# CourseFinder M1-PIM-GOV — Provider / Course / Campus Semantic UAT

**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-008`  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Status:** **DB/RPC/SECURITY PASS — FRONTEND/DEPLOYED BROWSER UAT PENDING**

## Purpose

Validate that CourseFinder does not conflate Provider geography with Course delivery geography, and that Course→Campus relationships retain enough provenance for an Admin to understand and audit the relationship.

## Exact identity case

Course resolution used exact CRICOS Course Code `121174E`, never title-only matching.

- Course UUID: `1b8be4ac-01c0-4b11-888f-083401acd784`
- Course stable key: `course:cricos:00111d:121174e`
- Provider stable key: `provider:cricos:00111d`
- Provider: Swinburne University of Technology

## Provider geography observation

Live canonical Provider record returned:

- country: AU
- subdivision: AU-VIC
- primary city: HAWTHORN
- address line 1: Swinburne International (H5)
- postcode: 3122
- Provider lifecycle: active
- Provider publication: unpublished

This is Provider-level geography only.

## Course Campus relationship observation

The Course has one accepted Campus relationship:

- Campus UUID: `2e75d559-4e95-406f-8a1c-ae925a69c23d`
- Campus stable key: `campus:cricos:00111d:hawthorn-campus-john-street-hawthorn-swinburne-university`
- Campus name: Hawthorn Campus John Street Hawthorn Swinburne University
- country: AU
- subdivision: AU-VIC / Victoria
- city: HAWTHORN
- address: John St
- postcode: 3122
- delivery mode: `on_campus`
- `is_primary=false`
- Campus status: active
- Campus publication: unpublished
- explicit Campus validity window: none supplied

## Provenance result

After Pilot migration `m1_pim_gov_course_campus_semantics_v1`, the governed Course Campus projection exposes two provenance layers.

### Campus provenance

- source label: CRICOS Providers, Courses and Locations
- source type: dataset
- source authority URL retained
- Campus evidence type: regulatory snapshot
- Campus evidence source URL retained
- captured timestamp retained
- content hash retained

### Course→Campus relationship provenance

- source label: CRICOS Providers, Courses and Locations
- source type: dataset
- relationship evidence type: regulatory snapshot
- relationship evidence source URL retained
- captured timestamp retained
- content hash retained

The fact that both provenance layers currently originate from CRICOS does not make them semantically interchangeable.

## Security UAT

Before correction, `authenticated` had direct EXECUTE on `public.ui_course_related_campuses(uuid)`.

After correction:

- `authenticated` direct EXECUTE: **false**
- `service_role` EXECUTE: **true**
- normal browser consumption remains through `public.admin_read`.

**Result:** PASS.

## Semantic assertions

| Assertion | Result |
|---|---|
| Exact Course identity used | PASS |
| Provider geography retained separately | PASS |
| Course Campus relationship retained separately | PASS |
| Campus stable identity retained | PASS |
| Campus geography retained | PASS |
| delivery mode retained | PASS |
| primary relationship flag retained without reinterpretation | PASS |
| Campus source/evidence retained | PASS |
| Course→Campus relationship source/evidence retained | PASS |
| No synthetic Campus created | PASS |
| No canonical rows rewritten | PASS |

## Frontend acceptance requirements

The current generic JSON `Campuses` table is not sufficient for semantic closure. The frontend must provide a dedicated Course delivery-campus presentation that:

1. labels the relationship as Course delivery geography;
2. does not imply that Provider State/City is the Course location;
3. shows Campus State/Region/Country from the Campus record;
4. preserves delivery mode and relationship primary flag;
5. distinguishes Campus lifecycle/publication from Course lifecycle/publication;
6. exposes Campus source/evidence separately from Course→Campus relationship source/evidence;
7. handles no-campus relationships as an explicit source/relationship absence rather than inventing a Campus.

## Verdict

**Canonical model:** PASS / unchanged  
**Read-contract semantics:** PASS  
**Provenance completeness:** PASS  
**Security boundary:** PASS  
**Frontend semantic presentation:** PENDING  
**Deployed authenticated browser UAT:** PENDING
