# M3 — Zoho Pilot Follow-ups

| ID | Item | Impact | Next action | Status |
|---|---|---|---|---|
| ZP-FU-001 | Zoho Creator MCP not exposed in current ChatGPT session | Actual Creator data/action work cannot be invoked here | Zoho MCP admin creates/enables server, adds least-privilege Creator tools, supplies server URL to ChatGPT custom connector and authorises it | BLOCKED |
| ZP-FU-002 | Official Zoho MCP cannot create/modify forms, fields, reports, pages, workflows or connections | UI structure cannot be built through MCP | Create/deploy Creator structural objects through supported Creator tooling, then use MCP for data/action UAT | OPEN |
| ZP-FU-003 | Courses-screen Pilot HTTP gateway is deployed; Creator Connection/end-to-end invocation remains open | Supabase boundary is ready but cannot be accepted until Creator calls it | Configure `coursefinder_pilot_api` Creator Connection with the dedicated token, invoke `zoho-course-api`, and run 401/400/404/429/search/lookup UAT | PARTIAL |
| ZP-FU-004 | QILT/PRISMS current Pilot read projection not yet admitted to Zoho | Insight cards must remain neutral/unavailable | Reconcile actual source-grain read model and add contextual DTOs with source/reporting period/grain/freshness | OPEN |
| ZP-FU-005 | Legacy `api.zoho_course_candidates_v1` remains authenticated executable | Potential confusion/legacy attack surface | Assess consumers; revoke/supersede under separate safe migration if unused | OPEN |
| ZP-FU-006 | Actual Creator responsive/auth/retry UAT not possible yet | Final acceptance cannot close | After connection/build, run targeted → bounded integration → one final responsive acceptance gate | OPEN |