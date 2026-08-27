# CourseFinder Zoho Creator UI/UX — Pilot v1.0

**Status:** DESIGN AGREED / BUILD BLOCKED BY CREATOR TOOL CONNECTION  
**Date:** 27 August 2026  
**Change Control:** CF-CHG-20260827-045  
**Data contract:** `zoho-integration-v1`

## 1. UX objective

A simple staff workspace for finding CourseFinder records and understanding freshness/context without exposing internal pipelines, source-provider routing, Evidence implementation or database structure.

Zoho is a consumer and operating/search surface, not the canonical authority.

## 2. Navigation

Keep the top-level app small:

1. **Overview**
2. **Providers**
3. **Courses**
4. **Campuses**
5. **Scholarships**
6. **Insights**
7. **Sync Status**

Do not replicate the Admin/PIM navigation tree.

## 3. Overview

Cards:
- Providers available;
- Courses available;
- Campuses available;
- Scholarships available;
- last successful sync;
- pending/failed reconciliation count;
- source freshness warning count.

Primary actions:
- Search Courses;
- exact ID/code lookup;
- view failed sync items.

No vendor/provider-attempt internals.

## 4. Providers

List:
- Provider name;
- stable Provider ID;
- country;
- lifecycle;
- publication;
- last verified/updated.

Filters:
- Country;
- Provider search.

Provider detail:
- identity/status;
- website/location;
- related Courses;
- related Campuses;
- contextual QILT/PRISMS insight cards when admitted at correct grain;
- freshness.

## 5. Courses

Default page size: 10 UI rows.

Search:
- free text;
- exact stable ID/code mode;
- Country;
- State/subdivision;
- Provider;
- Scholarship availability.

Large selectors follow A10:
- server-side/paged search;
- 10 options per page;
- no automatic search-field focus on touch/tablet;
- dependent selectors clear invalid children.

Result columns:
- Course;
- code;
- Provider;
- Country/State;
- study level;
- fee availability;
- intake/English/scholarship indicators;
- freshness.

## 6. Course detail

Order:
1. identity and status;
2. Provider/Country/locations;
3. Course description/link;
4. regulatory tuition;
5. Provider-current tuition;
6. intakes;
7. English requirements;
8. Scholarships;
9. QILT contextual insights;
10. PRISMS contextual insights;
11. freshness/integration state.

Never merge regulatory and Provider-current tuition.

Insight cards must visibly label grain, e.g. **Provider outcome**, **Study-area outcome**, **State/sector context**. Do not label these as Course outcomes.

Missing contextual data uses “Not yet available in Zoho” / governed state, not 0.

## 7. Campuses

List/detail fields:
- Campus name/stable ID;
- Provider;
- country/subdivision/city;
- postcode;
- website;
- lifecycle/publication;
- freshness.

Campus filtering is Provider/Country/State aware.

## 8. Scholarships

List:
- Scholarship name/stable ID;
- Provider;
- type;
- audience;
- award value text;
- academic year;
- application dates;
- lifecycle/publication;
- freshness.

Absence of a linked Scholarship is not proof that no Scholarship exists.

## 9. Insights

Two sections:
- QILT;
- PRISMS.

Filters are based on the source grain, not forced Course grain.

Every insight shows:
- source;
- reporting period;
- grain/scope;
- metric/value or semantic state;
- freshness.

Until a governed Pilot projection is admitted, show a neutral “Context not yet admitted” state and no fabricated chart/value.

## 10. Sync Status

Staff view:
- environment = Pilot;
- contract version;
- last successful watermark;
- expected/processed/created/updated/unchanged/failed counts;
- last sync duration;
- retryable failures;
- next action.

Integration-admin-only actions:
- retry a failed sync;
- replay from a prior watermark;
- force reconciliation check.

These actions operate on Zoho’s integration copy only. They do not mutate CourseFinder canonical data.

## 11. Error UX

Use short task-level messages:
- Not found;
- Invalid filter;
- Connection unavailable;
- Rate limited — retry later;
- Sync incomplete — reconciliation required;
- Context not yet admitted.

Do not display SQL, stack traces, secret names, Evidence paths or internal function names to normal staff.

## 12. Role model

### Staff / Counsellor
Read/search/detail only.

### Zoho Integration Operator
Staff permissions plus sync-status/retry/replay controls for Zoho copy.

### Creator App Admin
Manages Creator app structure, roles, connections and deployment. Still has no CourseFinder canonical-write authority by virtue of this role.

## 13. Responsive behaviour

Desktop:
- dense lists and side/detail panels where Creator supports them.

Tablet/mobile:
- single-column cards/detail;
- filters open without auto-focusing text input;
- pagination rather than loading large dropdowns;
- primary search/exact lookup remains immediately reachable.

## 14. Creator build limitation

Zoho’s official MCP can access records/actions exposed by the MCP administrator, but current Zoho documentation states it does not create or modify forms, fields, reports, pages, workflows or connections.

Therefore the Creator structural build requires:
- Creator UI/developer deployment work for forms/reports/pages/workflows/connections; then
- MCP may be used for record/action UAT and supported operations.

## 15. Minimum Creator objects

Suggested app objects:
- `CF_Providers`;
- `CF_Courses`;
- `CF_Campuses`;
- `CF_Scholarships`;
- `CF_Sync_State`;
- `CF_Sync_Errors`;
- `CourseFinder_Overview` page;
- read reports for each entity;
- Course detail page/report with contextual insight sections.

Stable CourseFinder IDs are unique keys in the Zoho copy and must drive upsert/deduplication.

## 16. Acceptance boundary

This document is a Pilot UI build specification, not proof that the Creator app has been built. Actual Creator responsive UAT is blocked until the target Zoho Creator MCP/connection/app is available.