# M3 — Zoho Pilot Next Chat

Continue from repository/runtime truth, not prior conversation history.

Mandatory start:
1. read `PROJECT_INSTRUCTIONS.md`;
2. read M2 Standing Instructions and A1–A10 because M2.4.x remains active in parallel;
3. read `change-control/REGISTER.md` and CF-CHG-20260827-045;
4. read `project-runsheets/milestone-3/zoho-pilot/{RUNSHEET,CURRENT-STATE,FOLLOW-UPS}.md`;
5. read `docs/coursefinder-zoho-consumer-contract-v1.3.md`, `docs/coursefinder-zoho-integration-read-contract-v1.0.md` and `docs/coursefinder-zoho-creator-ui-ux-pilot-v1.0.md`;
6. reconcile current Pilot repo head, deployed migrations/functions and overlapping CF-CHG-044.

Immediate work:
- inspect whether Zoho Creator MCP is now connected and enumerate exact exposed tools/permissions;
- if connected, use it for supported record/action work only; do not claim it can build Creator structures;
- establish the target Creator Pilot app/roles/connection through supported Creator structural tooling;
- reuse the deployed `zoho-course-api` v2 server-side Pilot transport for the Courses screen; never give Zoho a Supabase service-role key;
- configure the Creator Connection with the dedicated Pilot integration token and run end-to-end 401/400/404/429/search/lookup/filter-option UAT;
- reconcile/admit QILT/PRISMS contextual DTOs only at their real Provider/study-area/state/sector grain;
- run targeted auth/exact/search/paging/null/incremental/replay/reconciliation tests, then bounded Creator integration/responsive UAT;
- keep Production/public Website integration out of scope.

If a blocker persists, update FOLLOW-UPS with evidence and continue independent safe work. Before handoff update RUNSHEET, CURRENT-STATE, FOLLOW-UPS, NEXT-CHAT and CF-CHG-20260827-045.

## Current continuation checkpoint — 1 September 2026

Do not restart bridge/auth diagnosis. The Creator bridge and chunked reference cache are proven.

Continue from:
- `zoho-course-api` v11 ACTIVE;
- `zoho-integration-v2` Course search/filter contract deployed;
- reference bundle contains full Course filter facets;
- Creator reference cache currently proven at 65 rows / 62 Provider chunks before the new `course_filters` row;
- `CF-ZOHO-UI-v4.0.0` package prepared.

Immediate sequence:
1. add `course_filters` to Creator `Cache_Type`;
2. replace/run `cf_refresh_reference_cache` v2 and confirm 66/66;
3. upload v4;
4. UAT Dashboard → Courses → Course Detail → Proposal Builder → Student Proposal/PDF at wide desktop, 1920px and tablet;
5. verify full cached filter lists, provider autocomplete and no unexpected external calls;
6. keep `demoMode=true` for customer-demo stability until explicitly testing live search;
7. only then set `demoMode=false` for bounded live Search v2 / Lookup tests.

Do not present QILT/PRISMS percentages or scholarship values unless admitted by the governed DTOs.
