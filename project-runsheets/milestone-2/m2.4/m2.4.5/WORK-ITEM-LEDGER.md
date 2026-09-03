# M2.4.5 WORK ITEM LEDGER

All material Bugs, Addenda, Features, Governance, Operations and Security items must be recorded here before closure.

| Timestamp AEST | Type | Requested outcome | Workstream | Change ID | Implementation | UAT | Outcome / Next |
|---|---|---|---|---|---|---|---|
| 2026-09-03 10:28 | GOVERNANCE | Insert pre-production Admin/PIM hardening gate before M2.5 | H1-H10 | CF-CHG-20260903-087 | governance/runsheet commits | repository validation | ACTIVE |
| 2026-09-03 10:28 | FEATURE/HARDENING | Simplify/standardise Admin menu/submenu/UI | H1 | CF-CHG-20260903-088 | Pilot v2.15.45; core `527980d1e4fb5870c4870845a9b7956b6b3838f1`; access embed `a5eff83fa4accf190728f796480c5e4a986010ca` | build `33700864619` PASS; deployed UAT `33700864824` PASS | CLOSED / TARGETED PASS |
| 2026-09-03 10:28 | FEATURE/HARDENING | Scraper Config enable/disable and complete controls | H2 | CF-085 | ownership clarification `a033d3ef941eadb7fd992da15eb82c77956f9bec`; live provider registry reconciled | H1/H2 targeted browser running; provider semantic UAT next | ACTIVE |
| 2026-09-03 10:28 | FEATURE/HARDENING | Refactor scraper routing/Layer config UX | H2 | CF-085; child only if semantics change | readers/writers/runtime mapped; wording `60c8ad28afa28b166641d168d0c7bf08e0a74c56` | semantic routing test not yet run | ACTIVE / NO SEMANTIC CHANGE |
| 2026-09-03 10:28 | BUG/FEATURE | Mature Scholarship columns/order/filters | H3 | child CC on implementation | pending | pending | OPEN |
| 2026-09-03 10:28 | OPERATIONS | Revisit Scheduler Jobs | H4 | child CC on implementation | pending | pending | OPEN |
| 2026-09-03 10:28 | FEATURE | Manual record creation across applicable PIM | H5 | child CC on implementation | pending | pending | OPEN |
| 2026-09-03 10:28 | FEATURE/SECURITY | Auto-publication with explicit manual/mass controls | H6 | child CC required | pending | pending | DESIGN REQUIRED / DISABLED |
| 2026-09-03 10:28 | OPERATIONS | Keep Production migration data/telemetry current | H7 | CF-084/CF-087 | continuous | continuous | ACTIVE |
| 2026-09-03 10:28 | GOVERNANCE | Dated Addenda/Bug/Fix intake | H8 | CF-087 + owning CCs | continuous | continuous | ACTIVE |
| 2026-09-03 10:28 | UAT | Faster targeted testing | H9 | CF-087 + owning UAT CC | pending | pending | OPEN |
| 2026-09-03 10:28 | GOVERNANCE/MEETING | Milestone meeting evidence + interaction timeline | H10 | CF-087 | continuous | n/a | ACTIVE |


| 2026-09-03 10:35 | BUG/HARDENING | Remove separate full-screen Users & Roles Admin shell while preserving legacy deep link and rank-6 boundary | H1 | CF-CHG-20260903-088 / CF-078 | canonical embedded workspace; standalone root retired | build `33700864619` PASS; deployed UAT `33700864824` PASS | CLOSED / TARGETED PASS |
| 2026-09-03 10:43 | OPERATIONS/TELEMETRY | Reconcile live Scraper Config and Production migration inventory before H2 | H2/H7 | CF-085 / CF-084 / CF-087 | runtime read only; no mutation | Supabase runtime queries | PASS — Production targets remain pending |
