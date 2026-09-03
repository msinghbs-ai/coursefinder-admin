# M2.4.5 NEXT CHAT

Recommended chat name:

`CF M2.4.5 — H2 Parse.bot Qualification → H3 Scholarships — 2026-09-03`

Continue from repository/runtime truth.

Mandatory:
1. Read PROJECT_INSTRUCTIONS.md.
2. Read docs/README.md and CF-086 PIM operating principles.
3. Read M2 Standing Instructions.
4. Read CF-087, CF-088, CF-085 and CF-089.
5. Read this M2.4.5 RUNSHEET/CURRENT-STATE/FOLLOW-UPS/WORK-ITEM-LEDGER/MEETING-READINESS.
6. Read REGISTER and overlapping active Change Controls.
7. Reconcile current Admin/Pilot heads, Pilot Supabase/runtime and targeted CI/UAT.
8. Preserve M2.4.4 CLOSED/PASS/FROZEN.
9. Preserve H1 CF-088 TARGETED PASS.
10. Preserve CF-089 Scraper Config UI/performance TARGETED PASS.
11. Keep M2.5 P0 paused; do not create Production resources.

Begin with the remaining H2 Parse.bot blocker:
- current Parse.bot registry is Enabled but the live official-API credential probe returned HTTP 401 / authentication_failed;
- do not expose or infer the stored key;
- after the Platform Admin rotates/re-enters a valid Parse API key, rerun the built-in connection probe;
- only after HTTP 2xx, perform one bounded official Parse API qualification:
  1. POST /dispatch for one agreed first-party source URL;
  2. poll /dispatch/tasks/{task_id};
  3. capture generated scraper_id + endpoint_name as governed profile configuration;
  4. execute one endpoint;
  5. capture Evidence, credit/rate telemetry and cost basis;
  6. keep generic Parse.bot proxy execution blocked;
  7. admit Parse.bot route only after targeted PASS.
- preserve Scraper Config as the one provider/routing control plane.
- preserve Extraction Profiles as versioned source-specific non-secret rules/qualification.
- preserve Layer 2 workload defaults as advanced scheduler/batch/wave controls with routing read-only.

If valid Parse.bot credentials are not available, record H2 Parse.bot as blocked/deferred and proceed to H3 Scholarship PIM maturity according to RUNSHEET.

Use targeted build/contract/browser UAT only.

Before ending:
- update owning Change Controls;
- update all M2.4.5 continuity files;
- add absolute-time work ledger entries;
- update CF-084 Production portability inventory if runtime changes;
- update MEETING-READINESS achieved/failed/next and interaction evidence;
- return only Achieved, Failed/Blocked, Next and recommended continuation chat.
