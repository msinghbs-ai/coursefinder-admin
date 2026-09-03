# CF-CHG-20260903-087 — M2.4.5 Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PLANNING  
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

