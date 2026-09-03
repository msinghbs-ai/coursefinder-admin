# M2.4.5 NEXT CHAT

Recommended chat name:

`CF M2.4.5 — H2 Scraper Config & Routing — 2026-09-03`

Continue from repository/runtime truth.

Mandatory:
1. Read PROJECT_INSTRUCTIONS.md.
2. Read docs/README.md and CF-086 PIM operating principles.
3. Read M2 Standing Instructions.
4. Read CF-087, CF-088 and CF-085.
5. Read this M2.4.5 RUNSHEET/CURRENT-STATE/FOLLOW-UPS/WORK-ITEM-LEDGER/MEETING-READINESS.
6. Read REGISTER and overlapping active Change Controls.
7. Reconcile current Admin/Pilot heads, Pilot Supabase/runtime and targeted CI/UAT.
8. Preserve M2.4.4 CLOSED/PASS/FROZEN.
9. Preserve H1 CF-088 IMPLEMENTED/TARGETED PASS.
10. Keep M2.5 P0 paused; do not create Production resources.

Begin H2:
- treat Administration → Scraper Config as the one provider-control plane;
- inventory and reconcile provider enabled/disabled state, endpoint, write-only credential status, quota/reserve, rate, vendor concurrency, timeout, priority and route membership;
- reconcile `layer2_acquisition_providers`, `layer2_profile_provider_routes`, global `layer2_execution_policy.route_mode`, per-profile `layer2_execution_policies.routing_strategy`, and the runtime consumers in `layer2-provider-control`, `layer2-sync-control`, `layer2-acquire` and scheduled/background paths;
- show effective routing state in Layer operations without creating another writer/control plane;
- preserve Parse.bot disabled until credential + bounded UAT;
- do not alter routing semantics without an owning child Change Control and before/after targeted runtime evidence;
- update Evidence/cost/telemetry and Production migration inventory only when materially affected;
- use targeted build/contract/browser UAT only.

After H2, proceed to H3 Scholarship maturity according to RUNSHEET.

Before ending:
- update owning Change Controls;
- update every M2.4.5 continuity file;
- add absolute-time work ledger entries;
- update MEETING-READINESS achieved/failed/next and interaction evidence;
- return only Achieved, Failed/Blocked, Next and recommended continuation chat.
