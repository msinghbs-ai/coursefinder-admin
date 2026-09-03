# CourseFinder PIM Operating Principles v1.0

**Status:** AUTHORITATIVE CROSS-PROGRAMME PIM / ADMIN OPERATING PRINCIPLE  
**Effective:** 3 September 2026 10:03 AEST  
**Owner:** CourseFinder programme governance  
**Change Control:** CF-CHG-20260903-086

## 1. Purpose

This document is the durable principle layer for CourseFinder Admin/PIM delivery. It exists to prevent chat sprawl, version drift, undocumented bug/addenda work, UI regression, duplicate UAT, and feature implementations that are not wired end-to-end.

It does not replace `PROJECT_INSTRUCTIONS.md`, Change Control, milestone runsheets, architecture, or implementation truth. It defines how those mechanisms are used together.

## 2. Source-of-truth hierarchy

For every material task, use this order:

1. current repository/runtime/deployed truth;
2. `PROJECT_INSTRUCTIONS.md`;
3. `docs/README.md` current-document index;
4. this PIM operating principle;
5. active milestone standing instructions and runsheet;
6. active/overlapping Change Controls;
7. accepted architecture, Admin/PIM design, navigation, runbook and UAT records;
8. conversation history only as supporting context.

A chat must never select a document merely because its filename has the highest version number. The current-document index is authoritative for which version is active.

## 3. One milestone / phase = one primary implementation chat

Use a new primary chat for each milestone or formally separated phase.

Recommended chat naming:

`CF M<major>.<minor> — <short gate name> — YYYY-MM-DD`

Examples:
- `CF M2.5 — Production Readiness — 2026-09-03`
- `CF M2.6 — Publication Gate — 2026-10-01`

Do not create a new primary chat for every bug, screenshot, addendum, or small feature. Those are work items inside the active milestone unless they are deliberately split into a parallel governed workstream.

If a chat becomes long, prepare the repository handoff first, then start a continuation named:

`CF M<major>.<minor> — <short gate name> — C02 — YYYY-MM-DD`

The continuation must start from repository truth, not a pasted narrative of the prior conversation.

## 4. Standard start gate before implementation

Before changing code, schema, UI, settings, ingestion, security, API or operational behaviour:

- identify the active milestone and exact gate;
- reconcile current Admin and Pilot repository heads;
- reconcile deployed Supabase/runtime where relevant;
- read current-document index and active runsheet;
- search Change Control for overlapping work;
- identify accepted/frozen baseline that must not regress;
- identify affected navigation, Settings, roles, evidence, telemetry, API/consumer and UAT surfaces;
- decide whether the request is BUG, ADDENDUM, FEATURE, GOVERNANCE, DATA/INGESTION, SECURITY, or OPERATIONS;
- reuse the existing change record if it already owns the work; otherwise create the correct new record;
- define bounded targeted UAT before implementation.

No material task should begin from chat memory alone.

## 5. Work-item intake: bugs, addenda and features

Every material request must be classified and dated.

Minimum ledger fields:
- timestamp with timezone;
- originating chat name;
- milestone/sub-milestone;
- work-item type;
- requested outcome;
- affected modules/surfaces;
- Change ID;
- implementation commit/migration/PR;
- targeted UAT;
- final outcome: PASS, PARTIAL, BLOCKED or DEFERRED;
- next action.

### Bug
A bug restores accepted behaviour. Before fixing, prove the expected baseline and check whether a parallel change intentionally altered the surface.

### Addendum
An addendum extends accepted scope but does not silently replace core principles. It must state which existing principle/contract it extends and what remains unchanged.

### Feature
A feature must be designed as an integrated platform capability, not an isolated screen/control.

## 6. End-to-end feature wiring rule

A feature is not complete because a UI component renders.

Where applicable it must be wired across:

`Data/source → canonical/observation model → operation/workflow → Admin/PIM display → Settings/configuration → permissions → Evidence/provenance → job/telemetry → alerts/cost/freshness → Search/API/consumer admission decision → documentation → UAT → rollback`

If a surface is not applicable, record N/A explicitly.

This rule applies especially to ingestion providers, scraper/API credentials, quotas, scheduling, Provider Contacts, Scholarships, statistics/rankings, AI operations and external integrations.

## 7. Admin Settings protection rule

Before removing, renaming, hiding or consolidating an existing setting/control:

1. search the Admin codebase and current documentation;
2. identify all readers/writers and runtime consumers;
3. check role/rank visibility and security implications;
4. check whether the same concept is already managed under another Settings card;
5. preserve current values/migration path;
6. prove replacement behaviour before removal;
7. update operator guidance and targeted regression tests.

A duplicated setting should normally be consolidated into the established Settings/config surface rather than creating a second control plane.

## 8. Navigation and feature incubation

Accepted navigation is a governed platform contract.

New or experimental features must not create floating launchers, popups, hidden routes, or one-off navigation patterns.

For trials:
- place the capability under a governed `New Features` / trial area when it is not ready for permanent navigation;
- use the same production CSS/design tokens and component system from day one;
- retain role gating, evidence and telemetry;
- once accepted, move it into the correct permanent module and remove the trial entry;
- record the navigation move in Change Control and release notes.

A mature module such as Provider Contacts should remain a first-class module, not a temporary overlay.

## 9. UI/UX principles

CourseFinder Admin is an operational decision surface.

Standing rules:
- minimise screen bloat;
- prefer progressive disclosure over showing every field at once;
- use cards, grouped sections, compact grids and clear hierarchy;
- use the shared theme, spacing, typography, status colours and interaction patterns across all modules;
- colour should improve status recognition and scanning, not decorate;
- no unstyled trial controls;
- no popup-driven operational workflows;
- preserve breadcrumbs/context for nested operator journeys;
- prefer one or two clicks to evidence, job history and source context;
- reuse accepted searchable/paged filter patterns;
- desktop and tablet behaviour must remain stable;
- accessibility and readable contrast are part of acceptance.

## 10. UAT efficiency and regression control

Use an agile test pyramid:

1. static/build/type/schema checks;
2. targeted unit/contract checks;
3. bounded integration for the changed path;
4. targeted browser UAT for affected screens;
5. regression against frozen invariants;
6. one nominated full acceptance suite at a milestone gate.

Do not run the entire permanent suite after every small change. Do not weaken existing tests to obtain a pass.

A bug fix should normally prove:
- reproduction before;
- targeted correction;
- direct regression test;
- adjacent accepted behaviour;
- rollback/reversion path.

## 11. Chat handoff contract

Before ending a primary or continuation chat, repository records must be updated first.

The user-facing closeout must contain only:

**Achieved**
- material PASS outcomes with references.

**Failed / Blocked**
- only unresolved failures, blockers or deferred items.

**Next**
- exact next gate in dependency order.

**Next chat**
- recommended chat name;
- a compact copy/paste prompt generated from repository truth.

The full chronology remains in `RUNSHEET.md`, not in the chat response.

## 12. Documentation hygiene and version alignment

`docs/README.md` is the authoritative current-document index.

Rules:
- only one version of a document family is marked CURRENT;
- superseded versions are historical evidence, not candidates for new work;
- new documents must declare `Status`, `Effective/Date`, `Supersedes`, and relevant Change ID;
- historical files should be parked under category archives when reference-safe;
- physical moves of historical documents must be atomic with reference rewrites, link validation and a migration ledger;
- do not bulk-move files merely for tidiness if it will break Change Controls, runsheets, UAT or implementation references;
- Git history is evidence, but important historical versions remain discoverable through archive/index records;
- root-level governance should remain minimal and stable.

Target archive categories:
- `docs/archive/governance-programme/`
- `docs/archive/architecture-data/`
- `docs/archive/admin-pim-ux/`
- `docs/archive/layer1/`
- `docs/archive/layer2-layer3/`
- `docs/archive/search-api-integrations/`
- `docs/archive/security-platform/`
- `docs/archive/uat-release-operations/`

## 13. Gate-close requirement

A milestone/sub-milestone cannot be presented as handed over until:
- all in-scope work items are PASS, BLOCKED with evidence, or explicitly DEFERRED;
- Change Controls have implementation/UAT/rollback references;
- runsheet and current state are updated with timestamps;
- current-document index is updated if a canonical document changed;
- visible UI/release notes are updated if browser behaviour changed;
- guides/runbooks are updated where operator behaviour changed;
- the next exact gate and next-chat prompt are committed.

This is the default operating principle unless a later explicitly accepted governance decision supersedes it.
