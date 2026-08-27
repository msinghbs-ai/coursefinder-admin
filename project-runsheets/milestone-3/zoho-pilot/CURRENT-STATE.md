# M3 — Zoho Pilot Current State

**Status:** ACTIVE / PARTIAL — PILOT READ SUBSTRATE PASS; ZOHO CONNECTION/UI BUILD BLOCKED  
**Updated:** 27 August 2026 AEST  
**Change Control:** CF-CHG-20260827-045

## Current truth

- Current ChatGPT session has no exposed Zoho Creator MCP/plugin tools.
- Official Zoho MCP is suitable for authorised Creator data/actions, but not structural creation/modification of forms, reports, pages, fields, workflows or connections.
- Pilot Supabase has a new `zoho-integration-v1` service-role-only read family for Providers, Courses, Campuses, Scholarships and incremental reconciliation.
- Direct service-role credentials must never be placed in Zoho.
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
- deployed SQL mirrored to Pilot source.

## Blockers

1. Zoho MCP/server/custom connector is not connected to this ChatGPT session.
2. Creator structural UI cannot be created by the official Zoho MCP itself.
3. Server-side Zoho→CourseFinder HTTP auth/rate-limit transport is not yet deployed.
4. Current governed QILT/PRISMS read projection at correct grain still requires reconciliation/admission.

## Next gate

Connect the Zoho MCP server, inspect its actual exposed Creator tools/permissions, establish the target Creator Pilot app, then implement/test the server-side Pilot transport and Creator UI from the maintained v1 UI specification.