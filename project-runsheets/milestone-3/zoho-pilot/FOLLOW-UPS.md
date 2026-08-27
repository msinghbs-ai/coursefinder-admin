# M3 — Zoho Pilot Follow-ups

| ID | Item | Impact | Next action | Status |
|---|---|---|---|---|
| ZP-FU-001 | Zoho Creator MCP not exposed in current ChatGPT session | Actual Creator data/action work cannot be invoked here | Zoho MCP admin creates/enables server, adds least-privilege Creator tools, supplies server URL to ChatGPT custom connector and authorises it | BLOCKED |
| ZP-FU-002 | Official Zoho MCP cannot create/modify forms, fields, reports, pages, workflows or connections | UI structure cannot be built through MCP | Create/deploy Creator structural objects through supported Creator tooling, then use MCP for data/action UAT | OPEN |
| ZP-FU-003 | Pilot DB helpers are service-role-only with no Zoho HTTP gateway yet | Direct Zoho use is intentionally prohibited | Add dedicated server-side Pilot transport with integration auth, rotation, rate limiting and safe errors | OPEN |
| ZP-FU-004 | QILT/PRISMS current Pilot read projection not yet admitted to Zoho | Insight cards must remain neutral/unavailable | Reconcile actual source-grain read model and add contextual DTOs with source/reporting period/grain/freshness | OPEN |
| ZP-FU-005 | Legacy `api.zoho_course_candidates_v1` remains authenticated executable | Potential confusion/legacy attack surface | Assess consumers; revoke/supersede under separate safe migration if unused | OPEN |
| ZP-FU-006 | Actual Creator responsive/auth/retry UAT not possible yet | Final acceptance cannot close | After connection/build, run targeted → bounded integration → one final responsive acceptance gate | OPEN |