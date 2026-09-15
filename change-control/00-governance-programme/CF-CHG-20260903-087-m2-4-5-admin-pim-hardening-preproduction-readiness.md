# CF-CHG-20260903-087 — M2.4.5 Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** CLOSED / PASS — M2.4.5 ACCEPTED AND FROZEN  
**Category:** 00-governance-programme  
**Initiated:** 2026-09-03 10:28 AEST  
**Closed:** 2026-09-15 AEST  
**Origin chat:** CF M2.5 — Production Readiness — 2026-09-03  
**Owner:** CourseFinder programme governance  
**Parent milestone:** M2  
**Inserted gate:** M2.4.5  
**Successor gate:** M2.4.6 Production Operations Model  
**Production gate:** M2.5 remains paused until M2.4.9 records explicit GO.

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

No Production Supabase project was created during M2.4.5. The later programme decision `M2.4.6-M2.4.9-OPERATIONS-PLAN.md` inserts four operational gates before M2.5, so Production now remains paused until M2.4.9 records explicit GO and the existing Production organisation/region/name/cost requirements are met.

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
- active document router pointed implementation work to M2.4.5 while the gate was active;
- M2.4.4 remained frozen;
- M2.5 remained paused at P0;
- no runtime, schema or paid Production resource change was made in this governance step.

Rollback:
- historical rollback instructions are retained for audit; the accepted M2.4.5 baseline must not now be reverted merely to simplify successor operations work.

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

Production boundary remained unchanged: M2.5 was PAUSED AT P0 and no Production project existed.

## H2 update — 2026-09-03 11:50 AEST

CF-089 Scraper Config UX/performance hardening is TARGETED PASS:
- Pilot `b6f75ffccf93981522a5c077100deeac87f7022a`;
- Frontend Build `33705175916` PASS;
- Deployed UAT `33705175873` PASS.

The Parse.bot credential returned HTTP 401 from the official Parse API and Parse.bot remained excluded from execution pending a valid credential and qualified generated-API route. This residual did not authorise bypass or weaken provider qualification; any future Parse.bot enablement requires its applicable successor gate/change control.

## Addenda expansion — 2026-09-03 12:47 AEST

CF-091 added three governed M2.4.5 workstreams without reopening M2.4.4 or authorising Production:

- **H11 — Provider Logo Completeness & University Source Discovery**: one approved primary logo per in-scope university/Provider where first-party Evidence is obtainable; Hotcourses sitemap/navigation may accelerate discovery/reconciliation but is not canonical authority by default.
- **H12 — ARWU & University Diversity Statistics**: ARWU 2025 plus multi-year edition history; University Diversity/HDI as a separate contextual dataset in Statistics & Rankings.
- **H13 — Ranking Acquisition Adapters**: uploaded parser + governed API/Parse.bot acquisition normalised through one staging/validate/apply contract with Evidence, edition/year replay, identity controls and cost telemetry.

Repository reconciliation also confirmed the earlier CF-083/A32 bookkeeping gap had already been closed. DB Architecture v2.10.50 and Admin/PIM Decisions v1.31 remained the accepted architecture/design baseline through this gate.

## Priority override — 2026-09-03 12:59 AEST

User directed execution to **H11 onward first**. The sequence changed execution priority only; it did not weaken acceptance, source-authority, security, publication or Production boundaries.

## Final closure — 2026-09-15 AEST

M2.4.5 is accepted and frozen at Pilot main `e62c01cadaf43efa8c3d8ea57625c23874d1b010`, visible release v2.15.79 / package 0.1.6.

The final active operational workstream, `CF-CHG-20260915-245`, is CLOSED / PASS after PRs #91–#95. Its recovery sequence proved the intended CF-245 path rather than weakening unrelated tests: dedicated deployed UAT `34926246733` PASS, generic targeted UAT `34926246675` PASS, build/smoke `34926246673` PASS and Cloudflare deployment PASS (`c4eef0db-5910-42e7-ab50-0b9d701c5f07`).

The accepted runtime has genuine hourly enrichment history and the rank-gated Enrichment Operations surface. Ongoing dispatcher/retry/cost operating procedures, broader controlled scale, consumer/support operations and Production rehearsal are explicitly transferred to M2.4.6, M2.4.7, M2.4.8 and M2.4.9 respectively under `project-runsheets/milestone-2/m2.4/M2.4.6-M2.4.9-OPERATIONS-PLAN.md`.

This closure does not authorise M2.5 or Production. The exact successor is **M2.4.6 — Production Operations Model**.
