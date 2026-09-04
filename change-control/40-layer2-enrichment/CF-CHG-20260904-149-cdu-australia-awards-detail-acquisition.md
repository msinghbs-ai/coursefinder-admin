# CF-CHG-20260904-149 — CDU Australia Awards Detail Acquisition

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5

## Change

A single bounded first-party Scholarship detail profile was onboarded for Charles Darwin University’s Australia Awards page under the university’s international Scholarship path.

The profile reuses CDU’s already-qualified Scholarship catalogue acquisition routes, requires Evidence, respects shared-fetch reuse and does not bypass the Layer 2 route gate.

## Runtime result

The acquisition completed through the governed Layer 2 path and produced a Scholarship source record with:

- name: `Australia Award Scholarships`;
- audience: `international`;
- first-party CDU detail URL;
- retained Evidence.

The acquired page did not safely establish a numeric award value in the extracted Evidence, so no amount or percentage was manufactured.

## Safety boundary

No publication, Search, Website or Zoho admission is authorised by this acquisition step.

## Source reconciliation

Pilot migration:

`supabase/migrations/20260904065700_cf_149_cdu_australia_awards_detail_profile.sql`
