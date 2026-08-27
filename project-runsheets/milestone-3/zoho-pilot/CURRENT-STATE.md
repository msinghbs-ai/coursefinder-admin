# M3 — Zoho Pilot Current State

**Status:** ACTIVE / PARTIAL — PILOT COURSE API PASS; ZOHO CONNECTION/UI BUILD BLOCKED  
**Updated:** 27 August 2026 AEST  
**Change Control:** CF-CHG-20260827-045

## Current truth

- Current ChatGPT session has no exposed Zoho Creator MCP/plugin tools.
- Official Zoho MCP is suitable for authorised Creator data/actions, but not structural creation/modification of forms, reports, pages, fields, workflows or connections.
- Pilot Supabase has a new `zoho-integration-v1` service-role-only read family for Providers, Courses, Campuses, Scholarships and incremental reconciliation.
- Direct service-role credentials must never be placed in Zoho.
- Pilot Edge Function `zoho-course-api` v2 is ACTIVE for the first Courses screen and uses dedicated bearer authentication, safe error responses and per-action rate limiting.
- The integration credential is represented inside Supabase only by a SHA-256 hash in `private.zoho_integration_credentials`; no raw Zoho integration token is stored in DB/source.
- Country/State filter data is exposed only through service-role-only `api.zoho_filter_options_v1`, backed by countries/subdivisions that actually occur in the Search projection.
- Website contract is unchanged and separate.
- Production is unchanged and not authorised.
- Layer 1–4 authority is unchanged.
- QILT/PRISMS are not yet admitted to the Zoho Pilot DTO; Course lookup explicitly reports the contextual sections as `not_admitted`.

## Targeted PASS evidence

- exact Course lookup + replay;
- Course search/filter/paging;
- Campus paging;
- changed-since manifest;
- all nine new function ACL negatives;
- Security Advisor INFO only;
- Performance Advisor INFO only;
- deployed SQL mirrored to Pilot source;
- Course API auth helper ACL + valid/invalid hash: PASS;
- Search-backed Country/State filter options: PASS;
- rate limiter 429 decision path: PASS;
- `zoho-course-api` v2 deployment: PASS.

## Blockers

1. Zoho MCP/server/custom connector is not connected to this ChatGPT session.
2. Creator structural UI cannot be created by the official Zoho MCP itself.
3. Actual Zoho Creator Connection has not yet been configured against the deployed Course API, so end-to-end HTTP auth/error UAT is still open.
4. Current governed QILT/PRISMS read projection at correct grain still requires reconciliation/admission.

## Next gate

Establish the target Creator Pilot app and Creator Connection using the dedicated Pilot token, then invoke the deployed `zoho-course-api` through the Creator gateway, build the Courses widget, and run bounded end-to-end auth/error/responsive UAT.

## Exact connection setup required

Current official setup path:

1. A Zoho MCP administrator opens Zoho MCP and creates an MCP server.
2. Add Tools → Zoho Creator; expose only the required least-privilege Creator tools.
3. In the MCP server Connect section, copy the generated server URL.
4. In ChatGPT on web, an eligible workspace admin/authorised developer enables Developer Mode and creates a custom MCP app.
5. Supply the Zoho MCP endpoint, configure authentication, run Scan Tools, complete OAuth authorization and create the draft app.
6. Select the draft app in a new ChatGPT web chat and verify the actual tool inventory/permissions before any Creator operation.

Current product constraints:
- full custom MCP support is governed by ChatGPT plan/workspace availability and is configured on web;
- current OpenAI documentation states MCP apps are not available on mobile;
- current Zoho documentation states Creator MCP cannot create/modify forms, fields, reports, pages, workflows or connections.

Official references:
- Zoho Creator: “Integrating AI clients with Creator Using Zoho MCP”.
- OpenAI Help: “Developer mode and MCP apps in ChatGPT”.
