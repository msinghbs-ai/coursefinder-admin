# M3 — Zoho Pilot Run Sheet

## 2026-08-27 12:34 AEST — connection discovery + Pilot contract

**Intent:** establish a governed Zoho Creator Pilot workstream without crossing Production/public Website boundaries.

**Starting state:** M2.4.2 active in parallel; Zoho semantic contract v1.3 existed; no Zoho Creator tool exposed in current ChatGPT session.

**Actions:**
- reconciled CourseFinder governance, current M2.4.2 runtime and live Pilot Supabase;
- inspected available ChatGPT integrations: no Zoho Creator MCP/plugin tool exposed;
- confirmed current official Zoho MCP supports data/actions but not Creator structural creation/modification;
- deployed `zoho-integration-v1` Provider/Course/Campus/Scholarship read + incremental manifest helpers to Pilot;
- corrected Course text search to the current English FTS projection and added substring fallback;
- restricted all new functions to service_role only;
- mirrored deployed SQL into current Pilot source without rebasing active M2.4.2 work;
- completed targeted functional/ACL/advisor validation;
- documented UI/UX and transport contract.

**Outcome:** PARTIAL

**Evidence:**
- CF-CHG-20260827-045;
- Pilot commits `733dccc843bbfe636165cf9e02e7b95bf1c27dec`, `ddbad8012ed1052989aa1f374b145eac9f7386b3`;
- deployed migrations `20260827023923`, `20260827024224`;
- Security Advisor 129 INFO only;
- Performance Advisor 165 INFO only.

**Follow-up:**
- connect the official Zoho MCP/custom connector;
- identify/create target Creator Pilot app structure through Creator-supported structural tooling;
- deploy server-side HTTP integration transport; never expose service-role credential to Zoho;
- reconcile and admit QILT/PRISMS contextual projection;
- run bounded Zoho integration/responsive UAT.

## 2026-09-01 — quota-safe cache + UI v4 implementation

**Intent:** move from integration proof to the final mockup-aligned Zoho Pilot outcome without replacing the proven transport.

**Actions:**
- proved the chunked Creator cache with 65/65 persisted/parsed rows and 3,085 Providers represented in 62 JSON chunks;
- retained one-call `reference_bundle` cache refresh;
- deployed Course search v2 + full filter facets;
- deployed Edge `zoho-course-api` v11;
- validated the full filter domain and a compound filter search;
- prepared `CF-ZOHO-UI-v4.0.0` with mockup-aligned Courses, tabbed Course Detail, Proposal Builder and student Print/PDF layout;
- retained explicit AU/NZ live versus CA Beta/Limited presentation;
- retained QILT/PRISMS contextual/non-admission and Scholarship non-fabrication rules.

**Outcome:** IMPLEMENTED / CREATOR VISUAL UAT PENDING.

**Next:** refresh Creator cache to 66 rows including `course_filters`, upload v4 and complete bounded visual/responsive/PDF acceptance.
