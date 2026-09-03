# CF-CHG-20260903-087 — M2.4.5 Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / H1 TARGETED PASS — H2 ACTIVE  
**Category:** 00-governance-programme  
**Initiated:** 2026-09-03 10:28 AEST  
**Origin chat:** CF M2.5 — Production Readiness — 2026-09-03  
**Owner:** CourseFinder programme governance  
**Parent milestone:** M2  
**Inserted gate:** M2.4.5  
**Production gate:** M2.5 P0 remains paused until M2.4.5 closure.

## Decision

Insert a new pre-production hardening submilestone **M2.4.5** after the frozen M2.4.4 PASS and before M2.5 provisioning.

This does **not** reopen or invalidate M2.4.4. The accepted M2.4.4 baseline remains frozen. M2.4.5 is additive hardening of Pilot/Admin/PIM operations before any paid Production project is created.

## Scope

1. Simplify and standardise Admin menu/submenu and workspace UI/UX.
2. Mature Scraper Config including enable/disable and governed effective controls.
3. Refactor scraper routing / Layer configuration presentation without creating a second control plane.
4. Mature Scholarship Admin/PIM grid, ordering, filters, status/evidence/freshness and responsive UX.
5. Reconcile Scheduler/Jobs operational UX, lineage, retries, due work and health.
6. Establish governed manual record creation/editing patterns across applicable PIM modules.
7. Design/implement auto-publication controls with explicit disabled-by-default global/module controls, manual approval and governed mass-input support; no broad publication is authorised by this Change Control.
8. Keep Production migration inventory, portability data and telemetry current after each material change.
9. Route further Bugs/Addenda/Features through dated M2.4.5 work items and owning Change Controls.
10. Improve UAT speed using targeted/static/contract/bounded integration tiers; reserve full regression for the M2.4.5 nominated acceptance gate.
11. Maintain milestone-meeting readiness with achieved/failed/next, dated commits/UAT/runtime evidence and interaction timestamps. Billable time is never inferred from chat duration.

## Required end-to-end wiring

Each applicable feature must reconcile:
Data/source → workflow → Admin UI → Settings → permissions → Evidence → Jobs/telemetry → cost/freshness → consumer/publication decision → docs → UAT → rollback.

## Production boundary

M2.5 P0 remains paused. No Production Supabase project may be created until:
- M2.4.5 is closed/accepted;
- Production organisation, region, project name and current quoted supplier cost are explicitly confirmed.

## Acceptance

M2.4.5 closes only when:
- work-item ledger is reconciled;
- no known critical Admin/PIM workflow defect remains;
- Settings/routing/navigation duplication is removed or explicitly governed;
- Scheduler/Jobs and manual PIM operations have targeted browser/API evidence;
- publication controls remain safe and disabled until explicitly authorised;
- Production migration inventory/telemetry is current;
- milestone meeting pack/evidence is current;
- exactly one nominated broader regression/acceptance gate passes.



## Governance implementation evidence — 2026-09-03 10:28 AEST

Created/updated:
- CF-087: `e13bbb487c3ae512f1134b0d6d6119c2f8b5bf1f`;
- M2.4.5 RUNSHEET: `bca549bedce91e896e1b231d8deff47e563267b2`;
- CURRENT-STATE: `5e2de4aa1a0adbffa071b203a425180c4bc1c6ba`;
- FOLLOW-UPS: `ac108ce7e8799c97f02bccfc024cf060d7ad1560`;
- WORK-ITEM-LEDGER: `09a90456045062915e4ebe900e8fbee4011b10f5`;
- MEETING-READINESS: `b2fea3594123ad86a01dab0439ba5c2588756ab1`;
- NEXT-CHAT: `08bfebcf78f6f5cee7c93acee0b1822336ec9223`;
- docs router: `53417ce9b96d9c65d4307d427f969a141ba1d15c`;
- Change register: `2380c11329e85873b21e13a60fe6a49ac6dcf018`;
- M2.4 submilestone plan: `8f5e0b3af0d44354dbf7cd75f39ab2319e4912f7`;
- M2.5 P0 pause/redirect: `669a1c04842c2d7bcaed4aa94ad692c0392d84b7`, `3483856151d461be9b3033e3ea1bdee1b73957be`, `98e2e2806c6678717b009d44f553fbfe9ab33040`.

Validation:
- active document router now points implementation work to M2.4.5;
- M2.4.4 remains frozen;
- M2.5 remains paused at P0;
- no runtime, schema or paid Production resource change was made in this governance step.

Rollback:
- revert the listed governance commits and restore M2.5 as the active router if the inserted gate is later cancelled before implementation.

## Execution update — 2026-09-03 10:47 AEST

H1 completed under child Change Control `CF-CHG-20260903-088`.
- Pilot visible release v2.15.45.
- canonical Administration metadata/cards/deep links standardised;
- Users & Roles moved from separate full-screen shell into canonical Administration;
- role/rank boundaries preserved;
- Frontend Build `33700864619` PASS;
- targeted Deployed UAT `33700864824` PASS;
- no full acceptance suite run.

H2 started under CF-085.
- live provider/config/routing readers and writers inventoried;
- Parse.bot remains disabled;
- Firecrawl recorded entitlement/reserve is 5,000 / 250;
- no runtime routing semantic change yet;
- global route mode vs per-profile routing remains the next bounded reconciliation.

Production boundary remains unchanged: M2.5 is PAUSED AT P0 and no Production Supabase project exists.

## H2 update — 2026-09-03 11:50 AEST

CF-089 Scraper Config UX/performance hardening is TARGETED PASS:
- Pilot `b6f75ffccf93981522a5c077100deeac87f7022a`;
- Frontend Build `33705175916` PASS;
- Deployed UAT `33705175873` PASS.

H2 is not fully closed because the user-enabled Parse.bot credential returned HTTP 401 from the official Parse API. Parse.bot remains excluded from execution until a valid API key passes and one generated-API route is qualified.

M2.4.4 remains frozen, M2.5 remains paused at P0, and no Production project has been created.
