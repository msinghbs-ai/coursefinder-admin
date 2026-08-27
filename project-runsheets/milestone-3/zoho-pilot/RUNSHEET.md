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