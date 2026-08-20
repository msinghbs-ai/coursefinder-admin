# CF-CHG-20260820-008 — Provider / Course / Campus geography semantics

**Status:** APPLIED / DB-RPC-SECURITY PASS — FRONTEND PRESENTATION PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 12:35 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** semantic read contract / provenance / Admin presentation / security ACL

## Trigger

The full Admin semantic audit identified a high-risk interpretation trap: Provider geography and Course delivery geography are different facts. For exact CRICOS Course `121174E`, the canonical Provider record has its own AU/Victoria/Hawthorn geography while the Course separately relates to a canonical Hawthorn Campus through `catalogue.course_campuses`.

The existing Course detail exposed a generic `Campuses` JSON table. It did not preserve enough provenance to explain whether the evidence supported the Campus itself or the Course→Campus delivery relationship.

## Semantic decision

1. Provider geography describes the Provider record and must not be presented as Course delivery geography.
2. A Course Campus is a relationship observation: `Course -> course_campuses -> Campus`.
3. Campus source/evidence and Course→Campus relationship source/evidence are distinct audit concepts even when they originate from the same authority.
4. `is_primary=false` does not mean the Campus is invalid or secondary in business importance; it only means the relationship is not marked primary by the stored relationship.
5. `valid_from=NULL` / `valid_to=NULL` means no explicit validity window is stored; it is not permission to invent dates.
6. Campus `publication_status` is independent of Course publication status.
7. No synthetic Campus may be created merely to improve completeness.

## Exact reference case

CRICOS Course Code: `121174E`  
Course stable key: `course:cricos:00111d:121174e`  
Provider stable key: `provider:cricos:00111d`

Provider geography:

- country: AU
- subdivision: AU-VIC
- primary city: HAWTHORN
- postcode: 3122

Accepted Course delivery Campus:

- stable key: `campus:cricos:00111d:hawthorn-campus-john-street-hawthorn-swinburne-university`
- name: Hawthorn Campus John Street Hawthorn Swinburne University
- country: AU
- subdivision: AU-VIC / Victoria
- city: HAWTHORN
- address: John St
- postcode: 3122
- delivery mode: `on_campus`
- `is_primary=false`
- Campus status: active
- Campus publication: unpublished

The matching Provider and Campus geography in this case does not collapse the concepts. The relationship remains separately represented and separately evidenced.

## Applied read-contract correction

Pilot migration:

`m1_pim_gov_course_campus_semantics_v1`

Repository mirror:

`supabase/production-migrations/061_m1_pim_gov_course_campus_semantics.sql`

`public.ui_course_related_campuses(uuid)` now returns, for each Course Campus relationship:

- Campus identity: ID, stable key, name, campus code;
- Campus geography: country, subdivision code/name, city, address and postcode;
- Campus state: status, publication status, validity, last verification;
- relationship semantics: delivery mode and `is_primary`;
- Campus authority/provenance: source + evidence;
- Course→Campus relationship authority/provenance: source + evidence.

No canonical Provider, Course, Campus or relationship row was rewritten.

## Security correction

Direct `authenticated` execution of `public.ui_course_related_campuses(uuid)` has been revoked. The browser must obtain Course Campus data through the governed `public.admin_read` boundary. `service_role` execution is retained for the internal dispatcher/operations path.

## Required frontend presentation

The current generic `Campuses` JSON block is not considered the final semantic presentation.

The UI/PIM implementation lane should render a dedicated section such as **Course delivery campuses** with:

- Campus name;
- Campus city / State or Region / Country;
- delivery mode;
- primary relationship flag only where meaningful;
- Campus status/publication state without implying Course publication;
- a drill-down separating **Campus source/evidence** from **Course–Campus relationship source/evidence**;
- explicit note that Provider location is not substituted for Course delivery location.

Do not label Provider State as Course State or derive Course geography from the Provider record.

## UAT

See `docs/uat/coursefinder-m1-pim-gov-campus-semantics-uat-2026-08-20.md`.

Technical result:

- exact `121174E` Course relationship resolved: PASS;
- one accepted Hawthorn Campus returned: PASS;
- Course and Campus stable identities preserved: PASS;
- Campus AU-VIC geography preserved: PASS;
- delivery mode + primary flag preserved: PASS;
- Campus source/evidence exposed: PASS;
- relationship source/evidence exposed: PASS;
- direct authenticated EXECUTE removed: PASS.

## Rollback

Restore the previous `public.ui_course_related_campuses(uuid)` projection only. Do not alter canonical Provider/Course/Campus identities or delete `catalogue.course_campuses` relationships as part of presentation rollback.

## Closure

**Final status:** OPEN — DB/RPC/SECURITY PASS / FRONTEND PRESENTATION PENDING  
**Closed at:** N/A  
**Outcome:** Course Campus read semantics and provenance are now governed. Final closure requires dedicated semantic frontend presentation and deployed browser UAT.
