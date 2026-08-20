# CF-CHG-20260820-008 — Provider / Course / Campus geography semantics

**Status:** APPLIED / DB-RPC-SECURITY + FRONTEND SOURCE PASS — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 12:35 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** semantic read contract / provenance / Admin presentation / security ACL

## Trigger

The Admin semantic audit identified a high-risk interpretation trap: Provider geography and Course delivery geography are different facts. For exact CRICOS Course `121174E`, the Provider has its own AU/Victoria/Hawthorn geography while the Course separately relates to a canonical Hawthorn Campus through `catalogue.course_campuses`.

The prior Course detail exposed a generic `Campuses` JSON table and did not distinguish evidence supporting the Campus from evidence supporting the Course→Campus relationship.

## Semantic decision

1. Provider geography describes the Provider record and must not be presented as Course delivery geography.
2. Course delivery Campus is a relationship observation: `Course -> course_campuses -> Campus`.
3. Campus source/evidence and Course→Campus relationship source/evidence are separate audit concepts.
4. `is_primary=false` means only that the stored relationship is not marked primary.
5. NULL Campus validity dates mean no explicit validity window is stored; do not invent dates.
6. Campus publication status is independent of Course publication status.
7. No synthetic Campus may be created merely to improve completeness.

## Exact reference case

CRICOS Course Code: `121174E`  
Course stable key: `course:cricos:00111d:121174e`  
Provider stable key: `provider:cricos:00111d`

Provider geography:

- AU / AU-VIC / HAWTHORN / 3122.

Accepted Course delivery Campus:

- stable key `campus:cricos:00111d:hawthorn-campus-john-street-hawthorn-swinburne-university`;
- Hawthorn Campus John Street Hawthorn Swinburne University;
- AU / AU-VIC / HAWTHORN / John St / 3122;
- delivery mode `on_campus`;
- `is_primary=false`;
- Campus status active, publication unpublished;
- Campus evidence `5d6ed80b-e7f4-483c-a268-fdc98af61534`;
- Course→Campus relationship evidence `9f05c3b6-c575-4516-8c1c-fa2111bba379`.

Matching geography does not collapse the Provider and Course-delivery concepts.

## Applied read-contract correction

Pilot migration: `m1_pim_gov_course_campus_semantics_v1`  
Repository mirror: `supabase/production-migrations/061_m1_pim_gov_course_campus_semantics.sql`

The governed Course Campus payload exposes Campus identity/geography/state, delivery-mode/primary relationship semantics, Campus provenance and Course→Campus relationship provenance. No canonical Provider, Course, Campus or relationship row was rewritten.

## Security correction

Direct `authenticated` execution of `public.ui_course_related_campuses(uuid)` is revoked. Course Campus data is obtained through the governed `public.admin_read` boundary.

## Frontend release — PIM Admin v2.7.0

The source release replaces the generic Campus JSON block with **Course delivery campuses**.

It explicitly states Provider address/state is not Course delivery geography and shows:

- Campus name and stable identity;
- State/Region, city, country and address;
- delivery mode and relationship-primary state;
- Campus status/validity/verification;
- **Campus source/evidence**;
- **Course–Campus relationship source/evidence**.

Frontend files are `src/CourseSemanticDetail.jsx`, `src/main.jsx` and the package version alignment. No canonical or Search contract changed.

## UAT

Technical Campus UAT: `docs/uat/coursefinder-m1-pim-gov-campus-semantics-uat-2026-08-20.md`  
Combined v2.7 source/authenticated UAT: `docs/uat/coursefinder-m1-pim-gov-course-detail-v2.7.0-uat-2026-08-20.md`

Passed:

- exact `121174E` relationship resolution;
- one Hawthorn Course delivery Campus;
- Course/Campus stable identities preserved;
- AU-VIC geography preserved;
- delivery mode/relationship-primary semantics preserved;
- Campus evidence exposed;
- relationship evidence exposed;
- authenticated `admin_read('course_detail')` returns the governed Campus payload;
- v2.7 frontend presents the relationship explicitly.

## Rollback

Frontend rollback restores the preceding Course-detail component only. Backend rollback restores the previous Course Campus read projection. Do not alter canonical Provider/Course/Campus identities or delete `catalogue.course_campuses` relationships.

## Decision / status history

| Timestamp | Status | Event |
|---|---|---|
| 20 Aug 2026 12:35 AEST | OPEN / AUDITED | Provider geography and Course delivery geography separation formalised |
| 20 Aug 2026 | APPLIED / TECHNICAL PASS | Course Campus provenance read contract and ACL applied |
| 20 Aug 2026 13:01 AEST | FRONTEND SOURCE PASS | PIM Admin v2.7.0 dedicated Course delivery Campus presentation passed source/authenticated regression UAT |

## Closure

**Final status:** OPEN — DB/RPC/SECURITY + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING  
**Closed at:** N/A  
**Outcome:** Provider and Course-delivery geography are semantically separated through storage, governed read and v2.7 source presentation. Closure requires deployed authenticated browser UAT.
