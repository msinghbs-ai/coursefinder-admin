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
- implement a dedicated server-side Pilot HTTP transport over `zoho-integration-v1`; never give Zoho a Supabase service-role key;
- reconcile/admit QILT/PRISMS contextual DTOs only at their real Provider/study-area/state/sector grain;
- run targeted auth/exact/search/paging/null/incremental/replay/reconciliation tests, then bounded Creator integration/responsive UAT;
- keep Production/public Website integration out of scope.

If a blocker persists, update FOLLOW-UPS with evidence and continue independent safe work. Before handoff update RUNSHEET, CURRENT-STATE, FOLLOW-UPS, NEXT-CHAT and CF-CHG-20260827-045.