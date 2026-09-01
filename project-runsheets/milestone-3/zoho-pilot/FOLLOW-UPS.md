# M3 — Zoho Pilot Follow-ups

| ID | Item | Impact | Next action | Status |
|---|---|---|---|---|
| ZP-FU-001 | Zoho Creator MCP not exposed in current ChatGPT session | Actual Creator data/action work cannot be invoked here | Zoho MCP admin creates/enables server, adds least-privilege Creator tools, supplies server URL to ChatGPT custom connector and authorises it | BLOCKED |
| ZP-FU-002 | Official Zoho MCP cannot create/modify forms, fields, reports, pages, workflows or connections | UI structure cannot be built through MCP | Create/deploy Creator structural objects through supported Creator tooling, then use MCP for data/action UAT | OPEN |
| ZP-FU-003 | Courses-screen Pilot HTTP gateway is deployed; Creator Connection/end-to-end invocation remains open | Supabase boundary is ready but cannot be accepted until Creator calls it | Configure `coursefinder_pilot_api` Creator Connection with the dedicated token, invoke `zoho-course-api`, and run 401/400/404/429/search/lookup UAT | PARTIAL |
| ZP-FU-004 | QILT/PRISMS current Pilot read projection not yet admitted to Zoho | Insight cards must remain neutral/unavailable | Reconcile actual source-grain read model and add contextual DTOs with source/reporting period/grain/freshness | OPEN |
| ZP-FU-005 | Legacy `api.zoho_course_candidates_v1` remains authenticated executable | Potential confusion/legacy attack surface | Assess consumers; revoke/supersede under separate safe migration if unused | OPEN |
| ZP-FU-006 | Actual Creator responsive/auth/retry UAT not possible yet | Final acceptance cannot close | After connection/build, run targeted → bounded integration → one final responsive acceptance gate | OPEN |

## 1 September 2026 additions

| ID | Item | Impact | Next action | Status |
|---|---|---|---|---|
| ZP-FU-007 | Full Course filter cache not yet refreshed into Creator | UI v4 can fall back to a bounded facet snapshot but full 22-level / 79-area cache is not yet persistent in Zoho | Add `course_filters` dropdown value, use v2 cache refresh, prove 66/66 rows | OPEN / READY |
| ZP-FU-008 | UI v4 high-fidelity Creator acceptance | Mockup-aligned package is built but not yet accepted in Creator | Upload `CF-ZOHO-UI-v4.0.0`, run 2560/1920/tablet visual/responsive UAT | OPEN / READY |
| ZP-FU-009 | Student Proposal / PDF acceptance | v4 print-PDF layout is rebuilt toward approved proposal mockup; browser/Creator print output still needs acceptance | Print to PDF from Creator, compare to approved proposal mockup, correct only bounded visual differences | OPEN / READY |
| ZP-FU-010 | Scholarship filter coverage currently zero in Search projection | UI must not imply populated scholarship catalogue | Keep availability count visible; admit dedicated scholarship DTO/search only through governed backend work | OPEN / DATA COVERAGE |
