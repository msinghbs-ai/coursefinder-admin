# CourseFinder Running Build v2.49

**Status:** CURRENT GOVERNED SOURCE BUILD — CLOUDFLARE RUNTIME OBSERVATION PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.48.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.45.md`  
**Campus semantics UAT:** `docs/uat/coursefinder-m1-pim-gov-campus-semantics-uat-2026-08-20.md`

## Build delta

v2.49 preserves the accepted Layer 1, Layer 2, Search, fee, Insights, Evidence and full-catalogue paging state and adds governed Provider/Course/Campus geography semantics under `CF-CHG-20260820-008`.

## Course Campus semantic correction

Pilot migration:

`m1_pim_gov_course_campus_semantics_v1`

Repository mirror:

`supabase/production-migrations/061_m1_pim_gov_course_campus_semantics.sql`

The Course Campus read now retains separately:

1. Campus identity and geography;
2. Campus status, publication, validity and verification state;
3. Course→Campus delivery mode and primary-relationship flag;
4. Campus source/evidence;
5. Course→Campus relationship source/evidence.

Provider geography is not a Course delivery-location fallback.

## Exact reference case

CRICOS `121174E` remains the exact-code semantic reference.

Provider geography:

- AU;
- AU-VIC;
- HAWTHORN;
- postcode 3122.

Separate accepted Course Campus relationship:

- Hawthorn Campus John Street Hawthorn Swinburne University;
- AU / AU-VIC / HAWTHORN;
- `delivery_mode=on_campus`;
- `is_primary=false`;
- Campus status active;
- Campus publication unpublished;
- separately retained Campus and Course→Campus relationship evidence.

The matching geography in this example does not collapse Provider geography and Course delivery geography into one concept.

## Security after-state

Direct `authenticated` EXECUTE on `public.ui_course_related_campuses(uuid)` is revoked. Internal `service_role` execution remains available and browser consumption stays behind the governed `public.admin_read` boundary.

## Frontend state

Current frontend source remains **PIM Admin v2.6.0**. No new frontend release is claimed by v2.49.

`CF-CHG-20260820-008` remains open until Course detail replaces the generic Campus JSON presentation with a dedicated **Course delivery campuses** section that:

- shows Campus geography from the Campus record;
- preserves delivery mode and relationship flags;
- distinguishes Campus status/publication from Course state;
- exposes Campus provenance separately from Course→Campus relationship provenance;
- does not substitute Provider geography when no Course Campus relationship exists.

## PIM Admin Guide

`docs/coursefinder-pim-admin-guide-v1.1.md` is now the current Campus/geography semantic guide and carries forward unchanged v1.0 rules.

## Preserved governance regressions

- exact `121174E` fee semantics remain unchanged;
- QILT remains Provider-level enrichment;
- PRISMS remains aggregate/no manufactured Provider-Course identity;
- Evidence remains provenance rather than approval;
- full-catalogue exact-code search remains available through PIM Admin v2.6.0;
- Search fee/intake/English enrichment remains unadmitted.

## Preserved programme state

- AU CRICOS Providers: 1,546;
- active AU CRICOS Courses: 26,648;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- accepted Provider-current source classes: RMIT + UQ;
- bounded Provider-current Courses: 10;
- Search Course Documents: 33,105;
- Search fee/intake/English enrichment admitted: 0.

## Change Control

- `CF-CHG-20260820-001` — technical/source PASS / deployed browser pending;
- `CF-CHG-20260820-005` — technical/source PASS / deployed browser pending;
- `CF-CHG-20260820-006` — technical/source PASS / deployed browser pending;
- `CF-CHG-20260820-007` — technical/source PASS / deployed browser pending;
- `CF-CHG-20260820-008` — DB/RPC/SECURITY PASS / frontend presentation pending.

## Documentation decision

Updated:

- Running Build → v2.49;
- Master Plan → v1.45;
- PIM Admin Guide → v1.1;
- Campus semantic UAT;
- Change Control register / `CF-CHG-008`;
- repository migration 061.

Unchanged because the canonical relational model did not change:

- Database Architecture remains v2.10.37;
- Search contract unchanged;
- Layer 1 identity contract unchanged;
- Zoho publication/admission unchanged.

## Next PIM-GOV sequence

1. implement dedicated Course delivery-campus frontend presentation;
2. continue semantic audit through Intake and English requirements;
3. continue Study Level, Field of Study, Scholarship and lifecycle/publication audit;
4. execute deployed browser UAT for open PIM governance changes when Cloudflare runtime observation is available;
5. preserve exact stable identity and source/evidence throughout.
